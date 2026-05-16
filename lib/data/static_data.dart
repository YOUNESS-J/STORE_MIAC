import '../models/product.dart';

final List<Product> products = [
  Product(
    id: 'argan-oil-1',
    name: 'Organic Argan Oil',
    price: 48.00,
    category: 'Oils',
    image: 'https://lh3.googleusercontent.com/aida-public/AB6AXuCqtqS9S9YIxGmT4TMbcZ_NWNZva0lp7pqaGVrbSYkbJxXTIfOnlhbqdin09VYV6ausL4awSZ1Xs5xhHD-pFtcMS8OJpDTplWslVP64EilnAmJlv5pJdMX4m316uk9e0zcyNAMSenHIQPLzuVRmoYr_Av0efluphUFa7TELPi8CXzt7nssfEgz0jYJy43Da4WrLDuhf3FBzAeIQA5llx7NhErXYs1GZAhohGhzh3Wf8pgRU7NmdWwwkPzvjXUZLXSNhZQUGUs1tMr_l',
    description: 'Or liquide récolté au cœur de la vallée du Souss, pressé à froid pour une pureté artisanale.',
    isOrganic: true,
  ),
  Product(
    id: 'saffron-1',
    name: 'Premium Saffron',
    price: 32.00,
    category: 'Spices',
    image: 'https://lh3.googleusercontent.com/aida-public/AB6AXuAwIy0Q24UXeoOBS93iLwRMLlH7uv7axphyY2eR3goFrgX4tL5H3sqczL6MlA6XWqWzWLxUdXnUxAec1-M_fG7rtlRsUOyMoDFtJjUKOFlBjWsv2CNaoO-bqurwWstDVuQ484F9ACBktaysVHhvt3BIEXHz7J1ViLHm3TPGKpnqfu6DKwxB6Qxj4PLxjpIGQF31mby9vCbit1aGIfcP0ZhQYfpuqbmVZD7dT2a_1NZbJwKkFdIooIhLRUtC_01RnEO59zQ3OnC1Ja3m',
    description: 'Récolté à la main à l\'aube dans les hautes altitudes des montagnes de l\'Atlas.',
    isLimited: true,
    specs: {'Weight': '1.5g', 'Grade': 'A+', 'Shelf Life': '24 Months'},
  ),
  Product(
    id: 'honey-1',
    name: 'Eucalyptus Honey',
    price: 24.00,
    category: 'Honey',
    image: 'https://lh3.googleusercontent.com/aida-public/AB6AXuDvTNVCYYbnpLTIOO3_SZG77oqAtQ5otdFkmP_y38U6W7DmX16da3HqX8YHbmLH1rl-5UlA9rZ6kyolzOL0yd59_1lL5ai4y8NfakMw7Jy9U_2aM5iFK6pG5BH3tKnnhmjtuopskbpbRkXyrRr5CzOfzu97RtzRRdycdcADL0p7HdOkN4HdTS3N8cc6TOswDVwAcxESbQ7fp6x0TPeAOx2uIhZSB1WJN32gZavAXZb-TEhIRITnQv_whNUDfrwx7o4VFYWWI_VHtjTQ',
    description: 'Miel d\'eucalyptus biologique de haute qualité avec une riche clarté ambrée.',
  ),
  Product(
    id: 'clay-mask-1',
    name: 'Atlas Clay Mask',
    price: 38.00,
    category: 'Skincare',
    image: 'https://lh3.googleusercontent.com/aida-public/AB6AXuAFrsXdO8iuhRRZjnQtRTxCO_u4n_hsy1bTn8bcCYsPl8qlR2E1QcLj5Z2gU8flpKBgjKveWaguxL-wriDc59C2wG27sPSqQHMY4jrz2ZWh6L1hOy0hEBAbxzpizVUWqkvnP-No1dxr5CMJgjaH21RcUi0dhB_BzxzCu-Lu0HMwrshJMNHvCkFME8TRPOunbv-DPCM7W5Q9ty6U1cIGs6QkMqzjSH5P05oO27DfFi3NL51wYLmovzV6VGfWitWjYPTEHKfWn-slJvam',
    description: 'Argile Ghassoul marocaine artisanale pour une purification profonde et naturelle.',
  ),
];