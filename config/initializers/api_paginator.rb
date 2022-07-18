ApiPagination.configure do |config|
  config.paginator = :pagy

  Pagy::DEFAULT[:max_per_page] = 100
end
