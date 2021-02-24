Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C4AEC3239C6
	for <lists+io-uring@lfdr.de>; Wed, 24 Feb 2021 10:45:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234568AbhBXJo6 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 24 Feb 2021 04:44:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50380 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234751AbhBXJmx (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 24 Feb 2021 04:42:53 -0500
Received: from mail-wr1-x42e.google.com (mail-wr1-x42e.google.com [IPv6:2a00:1450:4864:20::42e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 00F39C06178B
        for <io-uring@vger.kernel.org>; Wed, 24 Feb 2021 01:42:12 -0800 (PST)
Received: by mail-wr1-x42e.google.com with SMTP id w11so1194177wrr.10
        for <io-uring@vger.kernel.org>; Wed, 24 Feb 2021 01:42:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:autocrypt:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=I3160vQJVgtFVhRZFPkTJYTxf0iHsnJiPQjixo4QY3U=;
        b=F7tzRsToLlUw6PduUd9fXOXqFvQXqvN5WphRFYO+vrKuTKlot0t2kSAYjX2gIGrA1a
         Vg2bM9YuZZLazGQZpPgtA+tLKSzpXFNh+9GET97SbfTBpY57WrqwVKycSWXUIz9768HY
         sqRvKjRKsg7f7A6sUZmJ2S3EFMkos3GBS8a1u5cHzBl84fMuEk872Xnh0/sYVGwT+A+3
         fzJQ69ju9l/hlN8IR/inqJ6qH4hRgQgL0IcFyX55iOlI5gs0Z9BOJGKazjRn2xQ18pLb
         /YEDPSh2WksYC7IKw/suyCdQE55jd/cQ/kjI7c1kyOlIBvPdj7hGbDY4ZSKBN2kkhxgx
         Igkg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:autocrypt
         :message-id:date:user-agent:mime-version:in-reply-to
         :content-language:content-transfer-encoding;
        bh=I3160vQJVgtFVhRZFPkTJYTxf0iHsnJiPQjixo4QY3U=;
        b=PacevW7PIx7WoqathrG2rbOw43jtClPkt8hBAk/Nu1i9uJpVr8Q5WejcnEZNhVGWM5
         KE8KzemRnPZkzAlZzEwWXlK1GTqe/fwJ/UTeYqza991L+MpDubOP3wmefo6AjC/tvm25
         INzD0i0TGINFKWqJ/SvAxoldCbsJhINE3uHmSQmcnh6gMlTvOdvLw9H/tqhNpzzf5gXv
         grMWsGIFi/5L8NU4Mxd26uhyzA5WZ3Wu7BbTAhj3rLgdBKMuRI27yOx+VqEY4AP+sMXI
         bM2SugIOyhqIWuXlOOMWRIk8YpBBmtTxt2OKffnBSOz+bVcFtcVO4yrMX5wWYFnTVqEy
         1mlw==
X-Gm-Message-State: AOAM530ARHnpreJoPxqvdw6PdurX27eoCnLc9pXdivZte6pdFZRSmZkz
        FesXdJv47ffDy/cumClOvZHibX8tw4bsNg==
X-Google-Smtp-Source: ABdhPJzBQ4sDjYgzKXG8gllUvusVvAKHB2XAU3fpg0PfanYBc7vOQ7vSz3Mpns/EX+gbQ0CIXlDUlg==
X-Received: by 2002:adf:ce85:: with SMTP id r5mr19766784wrn.18.1614159726032;
        Wed, 24 Feb 2021 01:42:06 -0800 (PST)
Received: from [192.168.8.165] ([148.252.132.56])
        by smtp.gmail.com with ESMTPSA id f14sm1270188wmf.7.2021.02.24.01.42.05
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 24 Feb 2021 01:42:05 -0800 (PST)
Subject: Re: [PATCH] io_uring: don't issue reqs in iopoll mode when ctx is
 dying
To:     Xiaoguang Wang <xiaoguang.wang@linux.alibaba.com>,
        io-uring@vger.kernel.org
Cc:     axboe@kernel.dk, joseph.qi@linux.alibaba.com
References: <20210206150006.1945-1-xiaoguang.wang@linux.alibaba.com>
 <e4220bf0-2d60-cdd8-c738-cf48236073fa@gmail.com>
 <3e3cb8da-d925-7ebd-11a0-f9e145861962@linux.alibaba.com>
 <f3081423-bdee-e7e4-e292-aa001f0937d1@gmail.com>
 <e185a388-9b7c-b01f-bcf9-2440d9024fd2@gmail.com>
 <754563ed-5b2b-075d-16f8-d980e51102e6@linux.alibaba.com>
From:   Pavel Begunkov <asml.silence@gmail.com>
Autocrypt: addr=asml.silence@gmail.com; prefer-encrypt=mutual; keydata=
 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 bA==
Message-ID: <7ca1f2c0-6d70-7cab-e713-3379543b3f46@gmail.com>
Date:   Wed, 24 Feb 2021 09:38:13 +0000
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.3.0
MIME-Version: 1.0
In-Reply-To: <754563ed-5b2b-075d-16f8-d980e51102e6@linux.alibaba.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 24/02/2021 02:30, Xiaoguang Wang wrote:
> hi Pavel,
> 
>> On 08/02/2021 13:35, Pavel Begunkov wrote:
>>> On 08/02/2021 02:50, Xiaoguang Wang wrote:
>>>>>> The io_identity's count is underflowed. It's because in io_put_identity,
>>>>>> first argument tctx comes from req->task->io_uring, the second argument
>>>>>> comes from the task context that calls io_req_init_async, so the compare
>>>>>> in io_put_identity maybe meaningless. See below case:
>>>>>>       task context A issue one polled req, then req->task = A.
>>>>>>       task context B do iopoll, above req returns with EAGAIN error.
>>>>>>       task context B re-issue req, call io_queue_async_work for req.
>>>>>>       req->task->io_uring will set to task context B's identity, or cow new one.
>>>>>> then for above case, in io_put_identity(), the compare is meaningless.
>>>>>>
>>>>>> IIUC, req->task should indicates the initial task context that issues req,
>>>>>> then if it gets EAGAIN error, we'll call io_prep_async_work() in req->task
>>>>>> context, but iopoll reqs seems special, they maybe issued successfully and
>>>>>> got re-issued in other task context because of EAGAIN error.
>>>>>
>>>>> Looks as you say, but the patch doesn't solve the issue completely.
>>>>> 1. We must not do io_queue_async_work() under a different task context,
>>>>> because of it potentially uses a different set of resources. So, I just
>>>>> thought that it would be better to punt it to the right task context
>>>>> via task_work. But...
>>>>>
>>>>> 2. ...iovec import from io_resubmit_prep() might happen after submit ends,
>>>>> i.e. when iovec was freed in userspace. And that's not great at all.
>>>> Yes, agree, that's why I say we neeed to re-consider the io identity codes
>>>> more in commit message :) I'll have a try to prepare a better one.
>>>
>>> I'd vote for dragging -AGAIN'ed reqs that don't need io_import_iovec()
>>> through task_work for resubmission, and fail everything else. Not great,
>>> but imho better than always setting async_data.
>>
>> Hey Xiaoguang, are you working on this? I would like to leave it to you,
>> If you do.
> Sorry, currently I'm busy with other project and don't have much time to work on
> it yet. Hao Xu will help to continue work on the new version patch.

Thanks for letting know! It's really not a big deal, just was leaving it
if someones wants to take a shot, but we'll get it fixed ourselves
otherwise.

-- 
Pavel Begunkov
