[1mdiff --git a/app/views/pages/home.html.erb b/app/views/pages/home.html.erb[m
[1mindex 38899fb..0ff3e4a 100644[m
[1m--- a/app/views/pages/home.html.erb[m
[1m+++ b/app/views/pages/home.html.erb[m
[36m@@ -3,7 +3,7 @@[m
   <!-- Barre de recherche -->[m
   <div class="row justify-content-center mb-2">[m
     <div class="col-md-8 py-4">[m
[31m-      <%= form_with url: search_path, method: :get, local: true, class: "d-flex align-items-center bg-light rounded-pill px-3 shadow-sm py-1" do |f| %>[m
[32m+[m[32m      <%= form_with url: searches_path, method: :get, local: true, class: "d-flex align-items-center bg-light rounded-pill px-3 shadow-sm py-1" do |f| %>[m
         <i class="fas fa-search me-2" style="font-size: 14px; color: #751F1F;"></i>[m
         <%= f.text_field :query, placeholder: "Find your book here...", class: "form-control border-0 bg-light rounded-pill", style: "font-size: 14px; color: #751F1F;", autofocus: false, onclick: "window.location.href='/books'" %>[m
       <% end %>[m
