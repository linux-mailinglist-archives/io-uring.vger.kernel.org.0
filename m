Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 80C413A5FFE
	for <lists+io-uring@lfdr.de>; Mon, 14 Jun 2021 12:25:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232788AbhFNK1V (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 14 Jun 2021 06:27:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58296 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232786AbhFNK1V (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 14 Jun 2021 06:27:21 -0400
Received: from mail-wr1-x42b.google.com (mail-wr1-x42b.google.com [IPv6:2a00:1450:4864:20::42b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B0BBFC061574
        for <io-uring@vger.kernel.org>; Mon, 14 Jun 2021 03:25:03 -0700 (PDT)
Received: by mail-wr1-x42b.google.com with SMTP id c5so13931417wrq.9
        for <io-uring@vger.kernel.org>; Mon, 14 Jun 2021 03:25:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=to:references:from:subject:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=JGpl4bTFBxhTE6m97oF7Uk4IW9+R3LOOGjJeN89SHP0=;
        b=Kmir1fn2DbEeQG/kKBdLQHYHxpnLHadlDAMnaDJtdIp42VPS37eEuBJz59o9ohrOEP
         cen6AQl/FXn3CwKmT7O3ysM+4YNpeo34BKQEAhHBMyN6+Nr2fIh+kVH79XeMv+9Fsk3x
         VyBT3eArjBk2qB/8VocT1BLRLksbSXjQYYRskzfs3IBhZVtkXCMZbL+MHk4dY+ckzbOp
         +J9pWvOos97yjVQdOBOEwbcMYwoqs7OOSfxHB1HIc7MQQuNhQPfaq8xyElbx0EFHYu/H
         0ejLdnEp1AS8T+vE5nn3yasEGu4ejdrSLnbvL6cvNoHkZ8wcpuWC3fMWWPUBUnHAEU1y
         AvGw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:to:references:from:subject:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=JGpl4bTFBxhTE6m97oF7Uk4IW9+R3LOOGjJeN89SHP0=;
        b=UVbaB0+EZCBVzj+y9dvOu5jPR572srR3XJmDOkkZSHmqRdJFogxnLn0wBCYHYpQKMY
         haHiDDpf43CyLrmdujJIaoOhutr0l7E2Y7NuVqL2ilcrWM3Tbm/BwetXQ2TMAQguJF1w
         bAF5MDEzbYcLbGBSBFqhGwnd06kSHLnuFDPM4HOBkyo8NfYU9ZspyDVyqXTjbLn3lV7S
         sw/b2yl4ucfPjSiEQ0tqMldLEjcFDw90LAZgdmBxeku/7ZxgVs78SE4zYwHRWkz9Ksdp
         E0fMazgRQyPRdjN/ZJRcODMtn9llpX7FOSjAws1Q2SjWgHSUHHAOoQ+qBvnAmsH1vJc3
         px4Q==
X-Gm-Message-State: AOAM53027TkqdNfD/RsgbxlfTEWVZNYEO4jJhaSn+aNr9Ej4WGIzlzwv
        6KJPGoISwmKenSLDG3mn86d4rQ6c6lSu0g==
X-Google-Smtp-Source: ABdhPJwCxOnX2/XvQPuDWJfrWgnMRClDvW0xsvvVcd7lcV/55wzABCMFc2wZ7NMtiVgtjKRs/82S1g==
X-Received: by 2002:a5d:47c3:: with SMTP id o3mr18171317wrc.122.1623666302133;
        Mon, 14 Jun 2021 03:25:02 -0700 (PDT)
Received: from [192.168.8.197] ([85.255.237.119])
        by smtp.gmail.com with ESMTPSA id v18sm16975590wrb.10.2021.06.14.03.25.01
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 14 Jun 2021 03:25:01 -0700 (PDT)
To:     Hao Xu <haoxu@linux.alibaba.com>, Jens Axboe <axboe@kernel.dk>,
        io-uring@vger.kernel.org
References: <d60270856b8a4560a639ef5f76e55eb563633599.1623236455.git.asml.silence@gmail.com>
 <d8033ef5-f22e-10a7-d836-0e66455327cf@linux.alibaba.com>
From:   Pavel Begunkov <asml.silence@gmail.com>
Subject: Re: [PATCH] io_uring: fix blocking inline submission
Message-ID: <238f6b1f-5bbd-1870-43e8-7308acda85a8@gmail.com>
Date:   Mon, 14 Jun 2021 11:24:50 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.1
MIME-Version: 1.0
In-Reply-To: <d8033ef5-f22e-10a7-d836-0e66455327cf@linux.alibaba.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 6/9/21 1:42 PM, Hao Xu wrote:
> 在 2021/6/9 下午7:07, Pavel Begunkov 写道:
>> There is a complaint against sys_io_uring_enter() blocking if it submits
>> stdin reads. The problem is in __io_file_supports_async(), which
>> sees that it's a cdev and allows it to be processed inline.
>>
>> Punt char devices using generic rules of io_file_supports_async(),
>> including checking for presence of *_iter() versions of rw callbacks.
>> Apparently, it will affect most of cdevs with some exceptions like
>> null and zero devices.
>>
>> Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
>> ---
>>
>> "...For now, just ensure that anything potentially problematic is done
>> inline". I believe this part is outdated, but what use cases we miss?
>> Anything that we care about?
>>
>> IMHO the best option is to do like in this patch and add
>> (read,write)_iter(), to places we care about.
>>
>> /dev/[u]random, consoles, any else?
>>
> This reminds me another thing, once I did nowait read on a brd(block
> ramdisk), I saw a 10%~30% regression after __io_file_supports_async()
> added. brd is bio based device (block layer doesn't support nowait IO
> for this kind of device), so theoretically it makes sense to punt it to
> iowq threads in advance in __io_file_supports_async(), but actually
> what originally happen is: IOCB_NOWAIT is not delivered to block
> layer(REQ_NOWAIT) and then the IO request is executed inline (It seems

IIUC we fixed it was fixed by

f8b78caf21d5bc3fcfc40c18898f9d52ed1451a5 ("block: don't ignore REQ_NOWAIT for direct IO")

> brd device won't block). This finally makes 'check it in advance'
> slower..

Trying to understand what kind of slower it is... It makes an attempt
to execute it inline. Does it return -EAGAIN? Always succeed
submission (e.g. queued for truly async execution ki_complete style)?

>>   fs/io_uring.c | 2 +-
>>   1 file changed, 1 insertion(+), 1 deletion(-)
>>
>> diff --git a/fs/io_uring.c b/fs/io_uring.c
>> index 42380ed563c4..44d1859f0dfb 100644
>> --- a/fs/io_uring.c
>> +++ b/fs/io_uring.c
>> @@ -2616,7 +2616,7 @@ static bool __io_file_supports_async(struct file *file, int rw)
>>               return true;
>>           return false;
>>       }
>> -    if (S_ISCHR(mode) || S_ISSOCK(mode))
>> +    if (S_ISSOCK(mode))
>>           return true;
>>       if (S_ISREG(mode)) {
>>           if (IS_ENABLED(CONFIG_BLOCK) &&
>>
> 

-- 
Pavel Begunkov
