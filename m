Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CABA830F1F4
	for <lists+io-uring@lfdr.de>; Thu,  4 Feb 2021 12:22:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235477AbhBDLVh (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 4 Feb 2021 06:21:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42094 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235317AbhBDLVg (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 4 Feb 2021 06:21:36 -0500
Received: from mail-wr1-x434.google.com (mail-wr1-x434.google.com [IPv6:2a00:1450:4864:20::434])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 730D5C0613D6
        for <io-uring@vger.kernel.org>; Thu,  4 Feb 2021 03:20:56 -0800 (PST)
Received: by mail-wr1-x434.google.com with SMTP id q7so2980442wre.13
        for <io-uring@vger.kernel.org>; Thu, 04 Feb 2021 03:20:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=to:cc:references:from:autocrypt:subject:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=Blp9NfeU5pQFianZffyKzAnUXHvaDIETSYZIiebOIaU=;
        b=pnnpi7XMJxMEIePrCRTS9A8cCeNUnmGpk0IdZhQJ6Kgv/IcpPMOjCgtbgbMiFXUo05
         sQeSgSbKOKpCSguM7SfQChTFgOHX+cpXspb/TmVEbziU3oiVAkyuobM13zkiF/71DNUA
         Ki+WQkf6Xh0voQB6AsmItCe37eso3HhOKhBsDsv7o9f4AC3H9NvVtsRsqvRM+c1AMfFL
         V/wS55KNVArt/CP2QKQM+0AmUNkV4SmXEM9XniOGH4MtcKTrNiJGagFb6wO7xkNcUnyd
         1U2VNsMOxYf8NhpfiUjlvyoph6eQ+fO8jT+rYMuv6Tq1G6dVLBYa04P5HpcBSqDctXP/
         9trg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:to:cc:references:from:autocrypt:subject
         :message-id:date:user-agent:mime-version:in-reply-to
         :content-language:content-transfer-encoding;
        bh=Blp9NfeU5pQFianZffyKzAnUXHvaDIETSYZIiebOIaU=;
        b=WIaaadPZvA4iG/TTq6Df3dkb46aJqJPCgKdg3E1sij+Cy/Iqac0zgHdHtXOa3CiiXn
         mhD4/0Si8CmuTsMoUMg6QZqEvo9odGhfMHh729QUJ/TYqc45Smm+xSZ4Do4iBZtPnrsx
         nImhw0f8nxyVpTjWnzYl1c9Iq5RuYYX28wCJFP8lS5IFerfeKNizk0IcC2/3czCoTdLF
         iCZ5ivpJq0HRkhhMpN9oFM3vz0tykPCgU6lgKuKL3ecG5e5k0q47bVFdu7zTQgMoZb28
         jekT6u4BVjfV5POO859vT594IIjR/QWcD4gT8JqGwtWEvbGebHZyb1Q1uvjKrJu19Ovp
         MYbQ==
X-Gm-Message-State: AOAM532U98V9J+rQftI+VRsmurFCXJqvgxiYAU7/oj6LZJKz+S9erXtl
        bRAGD6aDBOlUHNX4Vyinf5f8f4IrfX9oJw==
X-Google-Smtp-Source: ABdhPJymtDcdT/6ECfmXzJ4hH4T082yPItLtZlNyjrSQvZNxjBUf2Kd5b061DLuEtDqNQEA/qnr1uQ==
X-Received: by 2002:adf:d84a:: with SMTP id k10mr8896757wrl.156.1612437655221;
        Thu, 04 Feb 2021 03:20:55 -0800 (PST)
Received: from [192.168.8.171] ([148.252.133.145])
        by smtp.gmail.com with ESMTPSA id z1sm7788901wru.70.2021.02.04.03.20.54
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 04 Feb 2021 03:20:54 -0800 (PST)
To:     Hao Xu <haoxu@linux.alibaba.com>, Jens Axboe <axboe@kernel.dk>
Cc:     io-uring@vger.kernel.org, Joseph Qi <joseph.qi@linux.alibaba.com>
References: <1612364276-26847-1-git-send-email-haoxu@linux.alibaba.com>
 <1612364276-26847-3-git-send-email-haoxu@linux.alibaba.com>
 <c97beeca-f401-3a21-5d8d-aa53a4292c03@gmail.com>
 <9b1d9e51-1b92-a651-304d-919693f9fb6f@gmail.com>
 <3668106c-5e80-50c8-6221-bdfa246c98ae@linux.alibaba.com>
From:   Pavel Begunkov <asml.silence@gmail.com>
Autocrypt: addr=asml.silence@gmail.com; prefer-encrypt=mutual; keydata=
 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 bA==
Subject: Re: [PATCH 2/2] io_uring: don't hold uring_lock when calling
 io_run_task_work*
Message-ID: <f1a0bb32-6357-45e7-d4e4-c65c134f2229@gmail.com>
Date:   Thu, 4 Feb 2021 11:17:10 +0000
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.3.0
MIME-Version: 1.0
In-Reply-To: <3668106c-5e80-50c8-6221-bdfa246c98ae@linux.alibaba.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 04/02/2021 03:25, Hao Xu wrote:
> 在 2021/2/4 上午12:45, Pavel Begunkov 写道:
>> On 03/02/2021 16:35, Pavel Begunkov wrote:
>>> On 03/02/2021 14:57, Hao Xu wrote:
>>>> This is caused by calling io_run_task_work_sig() to do work under
>>>> uring_lock while the caller io_sqe_files_unregister() already held
>>>> uring_lock.
>>>> we need to check if uring_lock is held by us when doing unlock around
>>>> io_run_task_work_sig() since there are code paths down to that place
>>>> without uring_lock held.
>>>
>>> 1. we don't want to allow parallel io_sqe_files_unregister()s
>>> happening, it's synchronised by uring_lock atm. Otherwise it's
>>> buggy.
> Here "since there are code paths down to that place without uring_lock held" I mean code path of io_ring_ctx_free().

I guess it's to the 1/2, but let me outline the problem again:
if you have two tasks userspace threads sharing a ring, then they
can both and in parallel call syscall:files_unregeister. That's
a potential double percpu_ref_kill(&data->refs), or even worse.

Same for 2, but racing for the table and refs.

>>
>> This one should be simple, alike to
>>
>> if (percpu_refs_is_dying())
>>     return error; // fail *files_unregister();
>>
>>>
>>> 2. probably same with unregister and submit.
>>>
>>>>
>>>> Reported-by: Abaci <abaci@linux.alibaba.com>
>>>> Fixes: 1ffc54220c44 ("io_uring: fix io_sqe_files_unregister() hangs")
>>>> Signed-off-by: Hao Xu <haoxu@linux.alibaba.com>
>>>> ---
>>>>   fs/io_uring.c | 19 +++++++++++++------
>>>>   1 file changed, 13 insertions(+), 6 deletions(-)
>>>>
>>>> diff --git a/fs/io_uring.c b/fs/io_uring.c
>>>> index efb6d02fea6f..b093977713ee 100644
>>>> --- a/fs/io_uring.c
>>>> +++ b/fs/io_uring.c
>>>> @@ -7362,18 +7362,25 @@ static int io_sqe_files_unregister(struct io_ring_ctx *ctx, bool locked)
>>>>         /* wait for all refs nodes to complete */
>>>>       flush_delayed_work(&ctx->file_put_work);
>>>> +    if (locked)
>>>> +        mutex_unlock(&ctx->uring_lock);
>>>>       do {
>>>>           ret = wait_for_completion_interruptible(&data->done);
>>>>           if (!ret)
>>>>               break;
>>>>           ret = io_run_task_work_sig();
>>>> -        if (ret < 0) {
>>>> -            percpu_ref_resurrect(&data->refs);
>>>> -            reinit_completion(&data->done);
>>>> -            io_sqe_files_set_node(data, backup_node);
>>>> -            return ret;
>>>> -        }
>>>> +        if (ret < 0)
>>>> +            break;
>>>>       } while (1);
>>>> +    if (locked)
>>>> +        mutex_lock(&ctx->uring_lock);
>>>> +
>>>> +    if (ret < 0) {
>>>> +        percpu_ref_resurrect(&data->refs);
>>>> +        reinit_completion(&data->done);
>>>> +        io_sqe_files_set_node(data, backup_node);
>>>> +        return ret;
>>>> +    }
>>>>         __io_sqe_files_unregister(ctx);
>>>>       nr_tables = DIV_ROUND_UP(ctx->nr_user_files, IORING_MAX_FILES_TABLE);
>>>>
>>>
>>
> 

-- 
Pavel Begunkov
