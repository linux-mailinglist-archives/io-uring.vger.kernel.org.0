Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 04F694392F3
	for <lists+io-uring@lfdr.de>; Mon, 25 Oct 2021 11:47:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232712AbhJYJta (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 25 Oct 2021 05:49:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59288 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232768AbhJYJrd (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 25 Oct 2021 05:47:33 -0400
Received: from mail-wm1-x331.google.com (mail-wm1-x331.google.com [IPv6:2a00:1450:4864:20::331])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 265A9C061767
        for <io-uring@vger.kernel.org>; Mon, 25 Oct 2021 02:45:11 -0700 (PDT)
Received: by mail-wm1-x331.google.com with SMTP id 5so382167wmb.1
        for <io-uring@vger.kernel.org>; Mon, 25 Oct 2021 02:45:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=vTFfK25EWhhItYPFU9YL4ZAvnPbFVjEJsNxeD366vDc=;
        b=SrcixviOGCQg93LK0yn0hAlrTNCvz0tTeT7TbZ2r+W7uWzOnrpzPFDzLZgQDZZzHod
         IgECTXssHW8b9Mw3aeNOZ7IORyQeCc9/08wghG87vcTIeyEO1oDLIpBeN01ag3EjUyCe
         i2tZM3aEpKP9biBJsmsSOBST0jg+xW6kAwz4wfXwct7qk98QBxrf/TXYCCH9yFaIoRbc
         TZHjfAK/c3VqL+EE3Bj0PoKAwrkCodKeRZTtBKQI29+h46X1VHX7CyNA5QQ+V5SlWoii
         tW635fTdXpyz3MV+4lAtovR/SKypa4JBzN6NlDUg24+gmxhKqKbshAcMZ7qLb7qOlQr9
         VC5A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=vTFfK25EWhhItYPFU9YL4ZAvnPbFVjEJsNxeD366vDc=;
        b=h072/MOiPbFO5JA2rgB4NfhX5T2DOcQ7//DvY+pVR3vCWjcuxsVJNNxNhZm+t0BZLO
         VFwLSU413twusk4l7jTLOzgVHy/UIZ7I+iOojq16Mrq1Heumuzpb/V/Rww3ZKOnnn81s
         dKjGg3PT9pUUjRepuqz98FjCMe1ULAX4/d/XA0bByXBHBr0gaIuYV1NOa5flkHtf65k1
         fd6KoXxMtHocgJpnC0DK75ekyAUoMOcUNzRPK4+IkHA0ypURVsivqQpPf0a3excb5ZUE
         qNDBEofk5PjbQGShIwOB2IePIqR6ryUXVM7OgH9Su9QQtsz/wR4ypvi7lG9hwO4GTPJG
         0nxg==
X-Gm-Message-State: AOAM531HORrnW0tAQi2d2XqOVoGkdS/9TB7DTkgJqLVzIPGUCUlRWG3t
        CFbUBfzHUanI6EwoCkzR6HkT+RUBJ2U=
X-Google-Smtp-Source: ABdhPJxkRcX0UwYK+xGq/qmePzw/WvZz6FBzTKNYg4t52TO9o7x9Vf3O2oPEjZCl2ahvZMgg2a5u5w==
X-Received: by 2002:a1c:f30a:: with SMTP id q10mr11163446wmq.62.1635155109682;
        Mon, 25 Oct 2021 02:45:09 -0700 (PDT)
Received: from [192.168.8.198] ([185.69.144.165])
        by smtp.gmail.com with ESMTPSA id k17sm20521121wmj.0.2021.10.25.02.45.09
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 25 Oct 2021 02:45:09 -0700 (PDT)
Message-ID: <9e46dc61-44bb-3bbe-13bb-04e11ea3cae5@gmail.com>
Date:   Mon, 25 Oct 2021 10:43:36 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.2.0
Subject: Re: [RFC 1/1] io_uring: improve register file feature's usability
Content-Language: en-US
To:     Xiaoguang Wang <xiaoguang.wang@linux.alibaba.com>,
        io-uring@vger.kernel.org
Cc:     axboe@kernel.dk
References: <20211012084811.29714-1-xiaoguang.wang@linux.alibaba.com>
 <20211012084811.29714-2-xiaoguang.wang@linux.alibaba.com>
 <7899b071-16cf-154d-3354-2211309c2949@gmail.com>
 <b08c5add-96cd-9b1a-0ac5-32a62cace9a4@linux.alibaba.com>
 <4211b3d1-42a8-4528-2c72-7fddf3bddcf6@gmail.com>
 <98943ac6-772c-fd18-8d47-fbd16de10894@linux.alibaba.com>
 <bd7431f2-106c-ab75-fafd-7f36df4e2c8f@gmail.com>
 <e4ed60a6-123a-5f08-5e73-7dbb27d6e9dc@linux.alibaba.com>
From:   Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <e4ed60a6-123a-5f08-5e73-7dbb27d6e9dc@linux.alibaba.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 10/21/21 09:40, Xiaoguang Wang wrote:
>> On 10/13/21 04:32, Xiaoguang Wang wrote:
>>> hi,
>>>> On 10/12/21 14:11, Xiaoguang Wang wrote:
>>>>>> On 10/12/21 09:48, Xiaoguang Wang wrote:
>>>>>>> The idea behind register file feature is good and straightforward, but
>>>>>>> there is a very big issue that it's hard to use for user apps. User apps
>>>>>>> need to bind slot info to file descriptor. For example, user app wants
>>>>>>> to register a file, then it first needs to find a free slot in register
>>>>>>> file infrastructure, that means user app needs to maintain slot info in
>>>>>>> userspace, which is a obvious burden for userspace developers.
>>>>>>
>>>>>> Slot allocation is specifically entirely given away to the userspace,
>>>>>> the userspace has more info and can use it more efficiently, e.g.
>>>>>> if there is only a small managed set of registered files they can
>>>>>> always have O(1) slot "lookup", and a couple of more use cases.
>>>>>
>>>>> Can you explain more what is slot "lookup", thanks. For me, it seems that
>>>>
>>>> I referred to nothing particular, just a way userspace finds a new index,
>>>> can be round robin or "index==fd".
>>>>
>>>>> use fd as slot is the simplest and most efficient way, user does not need to> mange slot info at all in userspace.
>>>>
>>>> As mentioned, it should be slightly more efficient to have a small table,
>>>> cache misses. Also, it's allocated with kvcalloc() so if it can't be
>>>> allocate physically contig memory it will set up virtual memory.
>>>>
>>>> So, if the userspace has some other way of indexing files, small tables
>>>> are preferred. For instance if it operates with 1-2 files, or stores files
>>>> in an array and the index in the array may serve the purpose, or any other
>>>> way. Also, additional memory for those who care.
>>>
>>> Yeah, I agree with you that for small tables, current implementation seems good,
>>>
>>> If user app just registers a small number of files, it may handle it well, but imagine
>>>
>>> how netty, nginx or other network apps which will open thousands of socket files,
>>>
>>> manage these socket files' slot info will be a obvious burden to developer, these
>>>
>>> apps may need to develop a private component to record used or free slot. Especially
>>>
>>> in a high concurrency scenario, frequent sockes opened or closed, this private component
>>>
>>> may need locks to protect, that means this private component will introduce overhead too.
>>>
>>> For a fd, vfs layer has already ensure its unique.
>>>
>>>>
>>>>>> If userspace wants to mimic a fdtable into io_uring's registered table,
>>>>>> it's possible to do as is and without extra fdtable tracking
>>>>>>
>>>>>> fd = open();
>>>>>> io_uring_update_slot(off=fd, fd=fd);
>>>>>
>>>>> No, currently it's hard to do above work, unless we register a big number of files initially.
>>>>
>>>> If they intend to use a big number of files that's the way to go. They
>>>> can unregister/register if needed, usual grow factor=2  should make
>>>> it workable.
>>>
>>> I'm not sure un-register/register are appropriate，say a app registers 1000 files, then
>>>
>>> it needs to un-register 1000 files firstly, there are doubts whether can do this un-registration
>>>
>>> work, if some of these files are used by other threads, which submit sqes with FIXED_FILE
>>>
>>> flags continually, so the first un-registration work needs to synchronize with threads which
>>>
>>> are submitting requests. And later app needs to prepare a new files array, saving current 1000
>>>
>>> files and new files info to this new array, for me, it can works, but not efficient and somewhat
>>>
>>> hard to use :)
>>
>> Sounds reasonable. What I oppose is wiring it solely based on fd. On the
> 
> Are the main concerns are that you worry about the possible big memory consumption, which
> 
> also may not be allocated physically continuous?  If user app open thousands of files, but only
> 
> make a small set of files registered, this method is really not good.
> 
> 
> What about adding a new flag, like IORING_SETUP_REGISTER_FILES_BY_FD. If user creates
> 
> a uring instance with this flag, we'll support register files by fd. App that make most of its opened
> 
> files registered will benefit from this feature, not to maintain slot offset info anymore.
> 
> 
> Considering the future, once io_uring becomes the main program interface, every file maybe
> 
> opened by io_uring, so we can register every file opened by io_uring, after all, file registration
> 
> feature gives performance improvements. In this scenario, this new registration method seems
> 
> simplest.
> 
> 
>> other hand, it sounds what you need is a "grow table" feature.
> 
> No, it's just a result. What I want is that we can use fd as slot info to register files. Once a new fd
> 
> is returned by open(2), it means the slot indexed by this fd in io_uring io_file_table can be updated
> 
> safely, which is convenient for user app. "grow table" feature is just used to implement this support.

You may put it this way. But if the same can be done with smaller features
that can also be used also for other purposes it's preferable. Growing
table may be useful for others not having problems with fds.

>> We can also think about adding new format, instead of array of fds, add
>> passing an array of pairs {offset, fd}.
> 
> Can you explain more about this format, or does this will simply user apps' slot info maintain burden?

Currently, if you're updating slots 1 and 1000 in one operation, you'd
need to pass an array of 1000 elements with -1 between the indexes.
With the mentioned format it would be an array of 2 pairs
{{offset=1, fd1}, {offset=1000, fd2}}

If that's not a problem in your case (e.g. updating only by 1 slot at
a time), then we can just forget about it.

-- 
Pavel Begunkov
