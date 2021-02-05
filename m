Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F081D310900
	for <lists+io-uring@lfdr.de>; Fri,  5 Feb 2021 11:26:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231183AbhBEKZg (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 5 Feb 2021 05:25:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56746 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230088AbhBEKXU (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 5 Feb 2021 05:23:20 -0500
Received: from mail-wr1-x431.google.com (mail-wr1-x431.google.com [IPv6:2a00:1450:4864:20::431])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C25FCC06178A
        for <io-uring@vger.kernel.org>; Fri,  5 Feb 2021 02:22:38 -0800 (PST)
Received: by mail-wr1-x431.google.com with SMTP id c4so7013434wru.9
        for <io-uring@vger.kernel.org>; Fri, 05 Feb 2021 02:22:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=to:cc:references:from:autocrypt:subject:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=awwkxigNGV+VLvxvWzeK+XwUBETZhyf5T8C7f0uVcCY=;
        b=PG1lw/KesWrkzTriC6CAvvh8HcwiTBkMZ4Ofsj064DQ+pErjQ9K5smsS3f0HDCKdNR
         rGsAHmASHOC2BxXgcSkO/qYYsn0Dddy6Indj2aVn6u1GU3hhLK/Dj3+cO44IFZbRgBPS
         Aylyz7dqlo6AL8nmARJEMmc5fvnqLCd88frsWhxnL1FTGwCASYcrxVLKT5TxYu8xuwnx
         /Mjk0YXkEMJyeg6BtxLCZ6ED9pr3H4egQYyHrKSgz+9JLUbP0PToqpuu3Mm4wF6WUYYB
         lnZBcC/IyGpBXkkP+tdQeqoSmLTFhYLwF4wxXuK36hLW2UspPMcr+ZmiQbsZP2tF07a1
         iO6Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:to:cc:references:from:autocrypt:subject
         :message-id:date:user-agent:mime-version:in-reply-to
         :content-language:content-transfer-encoding;
        bh=awwkxigNGV+VLvxvWzeK+XwUBETZhyf5T8C7f0uVcCY=;
        b=FSHR+VrjvKt10AM0MSLpIKQ0YehwWDLkLhd4mjXueFDIuL2jiVN0V3UEth4C+oH38g
         IIv2zoqNhR8YkqU6AS2kF+u09NsU+IaKq4w1hDrbdHJpevvh2k0AKlLw+vCaAYN5ymGl
         7mQCdN5BlwqgC71+e7FBuZ9vcq4g9egwgKIaexkpEXvaTz0yGBDvnSLtnr7Sdp7XzKFa
         9jGGK3uKrvnMWiyYATzfG6lSAPUC30q8JyzXwtXEAt3J+W9uh/yrI70GiRfkRiERrHNk
         T3Y1HHbxT6EmsoeY4XCTKykEZbiwgOh8bEBm9P9dqIhzw+mRW89yoZN3aFxz1RnYS48p
         6cow==
X-Gm-Message-State: AOAM530I08S0XCKcwUo/A8hYTMIA9RX1dhCBosbaZZ7kUHQDH9Ei0ocv
        TO1wWzX9O8UgevYgeLV6dIw=
X-Google-Smtp-Source: ABdhPJwGgye66zSe1fxDoT7FWgcstEA3fU0mr1+uPiH/LEJNRPqTzx0M9CyVUdTeXq7/3W4WmdslDw==
X-Received: by 2002:adf:b611:: with SMTP id f17mr4125628wre.8.1612520557521;
        Fri, 05 Feb 2021 02:22:37 -0800 (PST)
Received: from [192.168.8.177] ([85.255.234.187])
        by smtp.gmail.com with ESMTPSA id c62sm8530955wmd.43.2021.02.05.02.22.36
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 05 Feb 2021 02:22:36 -0800 (PST)
To:     Hao Xu <haoxu@linux.alibaba.com>, Jens Axboe <axboe@kernel.dk>
Cc:     io-uring@vger.kernel.org, Joseph Qi <joseph.qi@linux.alibaba.com>
References: <1612364276-26847-1-git-send-email-haoxu@linux.alibaba.com>
 <1612364276-26847-3-git-send-email-haoxu@linux.alibaba.com>
 <c97beeca-f401-3a21-5d8d-aa53a4292c03@gmail.com>
 <9b1d9e51-1b92-a651-304d-919693f9fb6f@gmail.com>
 <3668106c-5e80-50c8-6221-bdfa246c98ae@linux.alibaba.com>
 <f1a0bb32-6357-45e7-d4e4-c65c134f2229@gmail.com>
 <343f70ec-4c41-ed73-564e-494fca895e90@gmail.com>
 <150de65e-0f6a-315a-376e-8e3fcf07ce1a@linux.alibaba.com>
From:   Pavel Begunkov <asml.silence@gmail.com>
Autocrypt: addr=asml.silence@gmail.com; prefer-encrypt=mutual; keydata=
 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 bA==
Subject: Re: [PATCH 2/2] io_uring: don't hold uring_lock when calling
 io_run_task_work*
Message-ID: <570f215e-7292-380a-1213-fe6e84881386@gmail.com>
Date:   Fri, 5 Feb 2021 10:18:52 +0000
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.3.0
MIME-Version: 1.0
In-Reply-To: <150de65e-0f6a-315a-376e-8e3fcf07ce1a@linux.alibaba.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 05/02/2021 09:57, Hao Xu wrote:
> 在 2021/2/4 下午11:26, Pavel Begunkov 写道:
>> On 04/02/2021 11:17, Pavel Begunkov wrote:
>>> On 04/02/2021 03:25, Hao Xu wrote:
>>>> 在 2021/2/4 上午12:45, Pavel Begunkov 写道:
>>>>> On 03/02/2021 16:35, Pavel Begunkov wrote:
>>>>>> On 03/02/2021 14:57, Hao Xu wrote:
>>>>>>> This is caused by calling io_run_task_work_sig() to do work under
>>>>>>> uring_lock while the caller io_sqe_files_unregister() already held
>>>>>>> uring_lock.
>>>>>>> we need to check if uring_lock is held by us when doing unlock around
>>>>>>> io_run_task_work_sig() since there are code paths down to that place
>>>>>>> without uring_lock held.
>>>>>>
>>>>>> 1. we don't want to allow parallel io_sqe_files_unregister()s
>>>>>> happening, it's synchronised by uring_lock atm. Otherwise it's
>>>>>> buggy.
>>>> Here "since there are code paths down to that place without uring_lock held" I mean code path of io_ring_ctx_free().
>>>
>>> I guess it's to the 1/2, but let me outline the problem again:
>>> if you have two tasks userspace threads sharing a ring, then they
>>> can both and in parallel call syscall:files_unregeister. That's
>>> a potential double percpu_ref_kill(&data->refs), or even worse.
>>>
>>> Same for 2, but racing for the table and refs.
>>
>> There is a couple of thoughts for this:
>>
>> 1. I don't like waiting without holding the lock in general, because
>> someone can submit more reqs in-between and so indefinitely postponing
>> the files_unregister.
> Thanks, Pavel.
> I thought this issue before, until I saw this in __io_uring_register:
> 
>   if (io_register_op_must_quiesce(opcode)) {
>           percpu_ref_kill(&ctx->refs);

It is different because of this kill, it will prevent submissions.

> 
>           /*
>           ¦* Drop uring mutex before waiting for references to exit. If
>           ¦* another thread is currently inside io_uring_enter() it might
>           ¦* need to grab the uring_lock to make progress. If we hold it
>           ¦* here across the drain wait, then we can deadlock. It's safe
>           ¦* to drop the mutex here, since no new references will come in
>           ¦* after we've killed the percpu ref.
>           ¦*/
>           mutex_unlock(&ctx->uring_lock);
>           do {
>                   ret = wait_for_completion_interruptible(&ctx->ref_comp);
>                   if (!ret)
>                           break;
>                   ret = io_run_task_work_sig();
>                   if (ret < 0)
>                           break;
>           } while (1);
> 
>           mutex_lock(&ctx->uring_lock);
> 
>           if (ret) {
>                   percpu_ref_resurrect(&ctx->refs);
>                   goto out_quiesce;
>           }
>   }
> 
> So now I guess the postponement issue also exits in the above code since
> there could be another thread submiting reqs to the shared ctx(or we can say uring fd).
> 
>> 2. I wouldn't want to add checks for that in submission path.
>>
>> So, a solution I think about is to wait under the lock, If we need to
>> run task_works -- briefly drop the lock, run task_works and then do
>> all unregister all over again. Keep an eye on refs, e.g. probably
>> need to resurrect it.
>>
>> Because we current task is busy nobody submits new requests on
>> its behalf, and so there can't be infinite number of in-task_work
>> reqs, and eventually it will just go wait/sleep forever (if not
>> signalled) under the mutex, so we can a kind of upper bound on
>> time.
>>
> Do you mean sleeping with timeout rather than just sleeping? I think this works, I'll work on this and think about the detail.

Without timeout -- it will be awaken when new task_works are coming in,
but Jens knows better.

> But before addressing this issue, Should I first send a patch to just fix the deadlock issue?

Do you mean the deadlock 2/2 was trying to fix? Or some else? The thread
is all about fixing it, but doing it right. Not sure there is a need for
faster but incomplete solution, if that's what you meant.

-- 
Pavel Begunkov
