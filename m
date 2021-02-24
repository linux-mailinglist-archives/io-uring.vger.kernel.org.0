Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DC55A3235CC
	for <lists+io-uring@lfdr.de>; Wed, 24 Feb 2021 03:36:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233125AbhBXCfz (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 23 Feb 2021 21:35:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43974 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233068AbhBXCfx (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 23 Feb 2021 21:35:53 -0500
Received: from mail-pf1-x42d.google.com (mail-pf1-x42d.google.com [IPv6:2607:f8b0:4864:20::42d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C2730C061574
        for <io-uring@vger.kernel.org>; Tue, 23 Feb 2021 18:35:13 -0800 (PST)
Received: by mail-pf1-x42d.google.com with SMTP id r5so305814pfh.13
        for <io-uring@vger.kernel.org>; Tue, 23 Feb 2021 18:35:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=pRX4IwXvTAbwMKp6invoZ5vO5e/RPmvYzTUsyy8YjAU=;
        b=vYMWuV/XIjA7myhdZXUYgXE7Sdx6C31VKbyn0f8/Bamx2j/ric8oRo5JsoSOFvfKv/
         QPJNnh49CvQlNMbv3CNO2Kqe0UtZHnkigBj5v0E3GgfQfG16Wiz5xhtz//IKH3EEmusV
         Q0sAIIQzLYcwi0kKC/m8znG/i34fwRgk05rSkFYbgQpe2NIyVn9jnqd6mhqvo1llsF0p
         FCvNK40dgYV15Jg1gvt5V6674D+nMvoBXv4HLGi3NK6bZ6AYAN3lvfGndtrjHMLratJp
         mGSType3HV+dDvusbmRwYq7W+WoAkhsYzv0JSyhTSbMmBo4dc0YFzYUdxeS0n/WWhu59
         nyLg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=pRX4IwXvTAbwMKp6invoZ5vO5e/RPmvYzTUsyy8YjAU=;
        b=In9T30/TnoZHtCA7t+6TVzuatK8Gy53XKpOfzx4bxC17+0PVejC2MgqcVyZpcQW50f
         6TZAWY/OXVKS44Ngj5PtmXxr53LZDDRVqO+qoie+gAHCCJr5oI2X0KCujR7SryDj4tuD
         IyxlqONSmq3PzTaZipsgUrnvR7yiNcQMipBzaXI+BNjUx3RCUPS0dUUSiZjf8uHARbRf
         MQ/suID9P3m66ojLVvGnJwYxDUUe7M5x/OZE1qysc/lqx6WyYkYqAydqVj6FC8iHwNyh
         HSrK/ZFYTkxMRX0rg8kOeejnL8JucDu7hV++VhJMtCk12CAT86it9vAqLPjn1P+SL9oK
         xENw==
X-Gm-Message-State: AOAM531xPOyWzA8F9Ljo0uf0F9GrcD3E5ZthMxBkYZvAPIxuEwhnLhRF
        KVKDBx3hRy/Vj0idnK4oR5MkVqc7XtQ3CA==
X-Google-Smtp-Source: ABdhPJwgDBdgUKgW0s3Fj/uAimNd5q4FIDxoYLgI7gL1C3uslK+ZgdaU9Etczph/yZ1ua1bjH0Jdcg==
X-Received: by 2002:a63:4246:: with SMTP id p67mr26349540pga.414.1614134113116;
        Tue, 23 Feb 2021 18:35:13 -0800 (PST)
Received: from [192.168.1.134] ([66.219.217.173])
        by smtp.gmail.com with ESMTPSA id o20sm426983pjt.43.2021.02.23.18.35.12
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 23 Feb 2021 18:35:12 -0800 (PST)
Subject: Re: [PATCH] io_uring: don't issue reqs in iopoll mode when ctx is
 dying
To:     Xiaoguang Wang <xiaoguang.wang@linux.alibaba.com>,
        Pavel Begunkov <asml.silence@gmail.com>,
        io-uring@vger.kernel.org
Cc:     joseph.qi@linux.alibaba.com
References: <20210206150006.1945-1-xiaoguang.wang@linux.alibaba.com>
 <e4220bf0-2d60-cdd8-c738-cf48236073fa@gmail.com>
 <3e3cb8da-d925-7ebd-11a0-f9e145861962@linux.alibaba.com>
 <f3081423-bdee-e7e4-e292-aa001f0937d1@gmail.com>
 <e185a388-9b7c-b01f-bcf9-2440d9024fd2@gmail.com>
 <754563ed-5b2b-075d-16f8-d980e51102e6@linux.alibaba.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <215e12a6-1aa7-c56f-1349-bd3828b225f6@kernel.dk>
Date:   Tue, 23 Feb 2021 19:35:11 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <754563ed-5b2b-075d-16f8-d980e51102e6@linux.alibaba.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 2/23/21 7:30 PM, Xiaoguang Wang wrote:
> hi Pavel,
> 
>> On 08/02/2021 13:35, Pavel Begunkov wrote:
>>> On 08/02/2021 02:50, Xiaoguang Wang wrote:
>>>>>> The io_identity's count is underflowed. It's because in io_put_identity,
>>>>>> first argument tctx comes from req->task->io_uring, the second argument
>>>>>> comes from the task context that calls io_req_init_async, so the compare
>>>>>> in io_put_identity maybe meaningless. See below case:
>>>>>>       task context A issue one polled req, then req->task = A.
>>>>>>       task context B do iopoll, above req returns with EAGAIN error.
>>>>>>       task context B re-issue req, call io_queue_async_work for req.
>>>>>>       req->task->io_uring will set to task context B's identity, or cow new one.
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

Is it issue or reissue? I found this one today:

https://lore.kernel.org/io-uring/c9f6e1f6-ff82-0e58-ab66-956d0cde30ff@kernel.dk/

-- 
Jens Axboe

