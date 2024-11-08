### Usage
Create a simple Alibaba Cloud FunctionComputeV3 service with the following:

```
# provider.tf

provider "alicloud" {
  region = "us-west-1"
}
```

```
# main.tf

module "my_function" {
  source               = "git@github.com:QYongHao/AlibabaCloudConstructsTerraform.git//FunctionComputeV3Service"
  function_name        = "my-test-function"
  function_description = "This is the test function"
  function_dir         = "./function_code"
}
```

```
# function_code/index.js

export const handler = async (event, context) => {
  return {
    statusCode: 200,
    body: JSON.stringify({
      message: "Hello World",
    }),
  };
};
```
