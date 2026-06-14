return {
  {
    "3rd/image.nvim",
    event = "VeryLazy",
    dependencies = {
      "nvim-treesitter/nvim-treesitter",
    },
    opts = {
      backend = "kitty",
      integrations = {
        markdown = {
          enabled = true,
          clear_in_insert_mode = false,
          download_remote_images = true,
          only_render_image_at_cursor = false,
          filetypes = { "markdown", "vimwiki" },
        },
        neorg = {
          enabled = true,
          clear_in_insert_mode = false,
          download_remote_images = true,
          only_render_image_at_cursor = false,
          filetypes = { "norg" },
        },
        html = {
          enabled = false,
        },
        css = {
          enabled = false,
        },
      },
      max_width = nil,
      max_height = nil,
      max_width_window_percentage = nil,
      max_height_window_percentage = 50,
      window_overlap_clear_enabled = false,
      window_overlap_clear_ft_ignore = { "cmp_menu", "cmp_docs", "" },
      editor_only_render_when_focused = false,
      tmux_show_only_in_active_window = false,
      hijack_file_patterns = { "*.png", "*.jpg", "*.jpeg", "*.gif", "*.webp", "*.avif" },
    },
    config = function(_, opts)
      local image = require "image"
      image.setup(opts)

      local zoom_factor = 1.2
      local image_scales = {}

      local function get_images_at_cursor()
        local buf = vim.api.nvim_get_current_buf()
        local cursor = vim.api.nvim_win_get_cursor(0)
        local row = cursor[1]
        local images = image.get_images { buffer = buf }
        local matches = {}
        for _, img in ipairs(images) do
          if img.geometry and img.geometry.y then
            local img_row = img.geometry.y
            local img_height = (img.rendered_geometry and img.rendered_geometry.height) or 10
            if row >= img_row and row <= img_row + img_height then
              table.insert(matches, img)
            end
          else
            table.insert(matches, img)
          end
        end
        return matches
      end

      local function zoom_images(direction)
        local images = get_images_at_cursor()
        if #images == 0 then
          images = image.get_images { buffer = vim.api.nvim_get_current_buf() }
        end
        if #images == 0 then
          return
        end
        for _, img in ipairs(images) do
          local id = img.id or tostring(img)
          local scale = image_scales[id] or 1.0
          if direction == "in" then
            scale = scale * zoom_factor
          else
            scale = scale / zoom_factor
          end
          scale = math.max(0.1, math.min(scale, 5.0))
          image_scales[id] = scale

          if img.image_width and img.image_height then
            local new_w = math.floor(img.image_width * scale)
            local new_h = math.floor(img.image_height * scale)
            img:render { width = new_w, height = new_h }
          elseif img.rendered_geometry and img.rendered_geometry.width then
            local base_w = img.rendered_geometry.width
            local base_h = img.rendered_geometry.height
            local new_w = math.floor(base_w * (direction == "in" and zoom_factor or (1 / zoom_factor)))
            local new_h = math.floor(base_h * (direction == "in" and zoom_factor or (1 / zoom_factor)))
            img:render { width = new_w, height = new_h }
          end
        end
      end

      vim.keymap.set("n", "<C-ScrollWheelUp>", function()
        zoom_images "in"
      end, { desc = "Zoom image in" })

      vim.keymap.set("n", "<C-ScrollWheelDown>", function()
        zoom_images "out"
      end, { desc = "Zoom image out" })

      vim.api.nvim_create_user_command("ZoomIn", function()
        zoom_images "in"
      end, { desc = "Zoom image in" })

      vim.api.nvim_create_user_command("ZoomOut", function()
        zoom_images "out"
      end, { desc = "Zoom image out" })

      vim.api.nvim_create_user_command("ZoomReset", function()
        local imgs = image.get_images { buffer = vim.api.nvim_get_current_buf() }
        for _, img in ipairs(imgs) do
          local id = img.id or tostring(img)
          image_scales[id] = nil
          img:render()
        end
      end, { desc = "Reset image zoom" })

      vim.keymap.set("n", "<leader>ir", function()
        local images = image.get_images { buffer = vim.api.nvim_get_current_buf() }
        for _, img in ipairs(images) do
          local id = img.id or tostring(img)
          image_scales[id] = nil
          img:render()
        end
      end, { desc = "Reset image zoom" })
    end,
  },
}
