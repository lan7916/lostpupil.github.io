---
layout: post
title: "Ajax获取chemical的信息"
date: 2014-09-24 13:15:00
category: blog
description: "通过ajax来获取远程的信息自动填充到表单中"
---
##需求
客户需要根据ketcher中画出的结构式来自动填写一些有的信息，这边通过远程的api来获取到相应的数据，代码如下：

``` coffeescript
  #auto fill from remote
  remote_info = (smiles,type) ->
    uri = "http://cactus.nci.nih.gov/chemical/structure/#{smiles}/#{type}"
    $.ajax uri,
      type: 'get'
      error: (jqXHR, textStatus, errorThrown) ->
        console.log jqXHR.status
      success: (data, textStatus, jqXHR) ->
        val = data.split("\n")[0]
        switch type
          when 'image' then $("#chemical_img").attr 'src', uri
          when 'mw' then $('#chemical_mole_weight').val val
          when 'cas' then $('#chemical_cas').val val
          when 'iupac_name' then $('#chemical_english_name').val val
          when 'names' then $('#chemical_english_synonym').val val
          when 'formula' then $('#chemical_mole_formula').val val
        return
   #调用方法
  $('#getmole').click ->
    ketcher = getKetcher()
    smiles = ketcher.getSmiles()
    type = ["mw","cas","iupac_name","names","formula","image"]
    type.map (type) ->
      remote_info(smiles,type) if smiles

    $('#chemical_smiles').val smiles
    $('#ketcherModal').modal('hide')
```

这边使用map方法对type数组中所有的元素进行方法的调用，加上if的判断条件来判断smiles是否为空，如果空则不执行函数体。
否则就去网站上获取到化学品的信息。
