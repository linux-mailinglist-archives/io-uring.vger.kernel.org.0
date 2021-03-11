Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D032D337793
	for <lists+io-uring@lfdr.de>; Thu, 11 Mar 2021 16:28:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234368AbhCKP2H (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 11 Mar 2021 10:28:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43712 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234175AbhCKP1e (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 11 Mar 2021 10:27:34 -0500
Received: from mail-il1-x131.google.com (mail-il1-x131.google.com [IPv6:2607:f8b0:4864:20::131])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4B184C061574
        for <io-uring@vger.kernel.org>; Thu, 11 Mar 2021 07:27:34 -0800 (PST)
Received: by mail-il1-x131.google.com with SMTP id b5so19230234ilq.10
        for <io-uring@vger.kernel.org>; Thu, 11 Mar 2021 07:27:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:references:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=uy3VQGnLdrLRE6iwvpQlYUeNmD2ZHC2MyIlm1Qoub0g=;
        b=EcW7HPydqDGVZZF25i37VeHz+Osq6lyzwFDZOm2U/7o2+1Z6MQyT5n+RcxLMJF4sBs
         AMIIW4fXx8YDXtZUJPXoFbIxAIxMR3vYoE0DDYFcY8C4FbkUyUPPgikiYax4HEaVvgNK
         wdBPKntKdOMiE6HYPhhzFY5u1ot4baVnGEJDXsaYHHSgzIiRqnPOAAOXe1wjC6X682fN
         ulS/JpEoE8lWRs8RldtA2q+tu4keaq2KMrXEUtlD6p2XAmIDT+wa+vfhBAaGwL7gSnyM
         YVpAGuh+g9u3Pf9gxNlvooqKaQvATF5L0AQLxPY35SdKMhFg838M1KtcjmwoQnjDRV1Q
         TFiA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=uy3VQGnLdrLRE6iwvpQlYUeNmD2ZHC2MyIlm1Qoub0g=;
        b=uGom5YY7LNsVZS8h7BrNUGhROOkjWM6zzaDgDc2uJQ0vSUPGfSRMCIExpuPCUGSKjp
         E8tQFIkUVviWqauC1f3UavwzBWYekD9SfUfb3FpjVTbkl3Bvv3LmC134j8YLa2DXGgC/
         GTk6eCnU1ueOxR5lcR8gJHCsCXt+6mnRyYvolUN21RYNf1E8fTVtjpt214IhafEzTzrS
         T9MOuseSQYNSdk/JQRSReB7hrE7l0NTJi5Q9OOZPTKBWvgmWIHlGzK01idGHNy8idRfe
         Zc6qN9q6G/AVJunnsq5eQ270p+fMvnF3rSaSAB1bj4Zo9ydNKo9GcEQo253zAcRu+K6D
         LHTQ==
X-Gm-Message-State: AOAM530HOGvL+UItIeyws+hCpgXX33R2pKD3BWmsbJ4Fkq4iidBvTpJt
        bRht5lERqz7yMWi/cBffOEVL9zhLtFtMaA==
X-Google-Smtp-Source: ABdhPJw+zPIhd5uRaaoQ4pPYIvH/1ya6JtgpUBLNQ5ncURc3QbSZ0BqfR0B1HzrOUVzgeV+qSPJV3A==
X-Received: by 2002:a92:ce4e:: with SMTP id a14mr7345278ilr.219.1615476453443;
        Thu, 11 Mar 2021 07:27:33 -0800 (PST)
Received: from [192.168.1.30] ([65.144.74.34])
        by smtp.gmail.com with ESMTPSA id h12sm634327ilj.41.2021.03.11.07.27.32
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 11 Mar 2021 07:27:32 -0800 (PST)
Subject: Re: IORING_SETUP_ATTACH_WQ (was Re: [PATCH 1/3] io_uring: fix invalid
 ctx->sq_thread_idle)
To:     Stefan Metzmacher <metze@samba.org>,
        Pavel Begunkov <asml.silence@gmail.com>,
        io-uring@vger.kernel.org
References: <cover.1615381765.git.asml.silence@gmail.com>
 <fd8edef7aecde8d776d703350b3f6c0ec3154ed3.1615381765.git.asml.silence@gmail.com>
 <a25f115b-830c-e0f6-6d61-ff171412ea8b@samba.org>
 <b5fe7af7-3948-67ae-e716-2d2d3d985191@gmail.com>
 <5efea46e-8dce-3d6b-99e4-9ee9a111d8a6@samba.org>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <021e5223-fa9a-ea95-eea9-840609b09444@kernel.dk>
Date:   Thu, 11 Mar 2021 08:27:32 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <5efea46e-8dce-3d6b-99e4-9ee9a111d8a6@samba.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 3/11/21 4:46 AM, Stefan Metzmacher wrote:
> 
> Am 11.03.21 um 12:18 schrieb Pavel Begunkov:
>> On 10/03/2021 13:56, Stefan Metzmacher wrote:
>>>
>>> Hi Pavel,
>>>
>>> I wondered about the exact same change this morning, while researching
>>> the IORING_SETUP_ATTACH_WQ behavior :-)
>>>
>>> It still seems to me that IORING_SETUP_ATTACH_WQ changed over time.
>>> As you introduced that flag, can you summaries it's behavior (and changes)
>>> over time (over the releases).
>>
>> Not sure I remember the story in details, but from the beginning it was
>> for io-wq sharing only, then it had expanded to SQPOLL as well. Now it's
>> only about SQPOLL sharing, because of the recent io-wq changes that made
>> it per-task and shared by default.
>>
>> In all cases it should be checking the passed in file, that should retain
>> the old behaviour of failing setup if the flag is set but wq_fd is not valid.
> 
> Thanks, that's what I also found so far, see below for more findings.
> 
>>>
>>> I'm wondering if ctx->sq_creds is really the only thing we need to take care of.
>>
>> io-wq is not affected by IORING_SETUP_ATTACH_WQ. It's per-task and mimics
>> all the resources of the creator (on the moment of io-wq creation). Off
>> ATTACH_WQ topic, but that's almost matches what it has been before, and
>> with dropped unshare bit, should be totally same.
>>
>> Regarding SQPOLL, it was always using resources of the first task, so
>> those are just reaped of from it, and not only some particular like
>> mm/files but all of them, like fork does, so should be safer.
>>
>> Creds are just a special case because of that personality stuff, at least
>> if we add back iowq unshare handling.
>>
>>>
>>> Do we know about existing users of IORING_SETUP_ATTACH_WQ and their use case?
>>
>> Have no clue.
>>
>>> As mm, files and other things may differ now between sqe producer and the sq_thread.
>>
>> It was always using mm/files of the ctx creator's task, aka ctx->sqo_task,
>> but right, for the sharing case those may be different b/w ctx, so looks
>> like a regression to me
> 
> Good. I'll try to explore a possible way out below.
> 
> Ok, I'm continuing the thread here (just pasting the mail I already
> started to write :-)
> 
> I did some more research regarding IORING_SETUP_ATTACH_WQ in 5.12.
> 
> The current logic in io_sq_offload_create() is this:
> 
> +       /* Retain compatibility with failing for an invalid attach attempt */
> +       if ((ctx->flags & (IORING_SETUP_ATTACH_WQ | IORING_SETUP_SQPOLL)) ==
> +                               IORING_SETUP_ATTACH_WQ) {
> +               struct fd f;
> +
> +               f = fdget(p->wq_fd);
> +               if (!f.file)
> +                       return -ENXIO;
> +               if (f.file->f_op != &io_uring_fops) {
> +                       fdput(f);
> +                       return -EINVAL;
> +               }
> +               fdput(f);
> +       }
> 
> That means that IORING_SETUP_ATTACH_WQ (without IORING_SETUP_SQPOLL)
> is completely ignored (except that we still simulate the -ENXIO and
> -EINVAL  cases), correct? (You already agreed on that above :-)

Correct, there's no need to share anything there anymore. So we just
pretend that we do, since the application is none the wiser on that
front anyway.

> The reason for this is that io_wq is no longer maintained per
> io_ring_ctx, but instead it is now global per io_uring_task. Which
> means each userspace thread (or the sq_thread) has its own
> io_uring_task and thus its own io_wq.

Right

> Regarding the IORING_SETUP_SQPOLL|IORING_SETUP_ATTACH_WQ case we still
> allow attaching to the sq_thread of a different io_ring_ctx. The
> sq_thread runs in the context of the io_uring_setup() syscall that
> created it. We used to switch current->mm, current->files and other
> things before calling __io_sq_thread() before, but we no longer do
> that. And this seems to be security problem to me, as it's now
> possible for the attached io_ring_ctx to start sqe's copying the whole
> address space of the donator into a registered fixed file of the
> attached process.

As Pavel commented, this isn't really a security issue, as you're
willingly passing the fd for someone to attach to. That's why I made it
an fd based attachment in the first place. That said, it can cause
breakage now where if you rely on your ring creator mm (etc) to be used,
then you'll have a bad time since things will fail. That's obviously not
ideal, and certainly needs fixing.

> As we already ignore IORING_SETUP_ATTACH_WQ without
> IORING_SETUP_SQPOLL, what about ignoring it as well if the attaching
> task uses different ->mm, ->files, ... So IORING_SETUP_ATTACH_WQ would
> only have any effect if the task calling io_uring_setup() runs in the
> same context (except of the creds) as the existing sq_thread, which
> means it would work if multiple userspace threads of the same
> userspace process want to share the sq_thread and its io_wq.
> Everything else would be stupid (similar to the unshare() cases). But
> as this has worked before, we just silently ignore
> IORING_SETUP_ATTACH_WQ is we find a context mismatch and let
> io_uring_setup() silently create a new sq_thread.
> 
> What do you think?

I think that's a very reasonable first approach, and would avoid a
direct regression in terms of having the thread now uses different
resources. It might very well cause a CPU regression since you now have
eg 2 threads instead of 1, but that's something we can tackle down the
line.

-- 
Jens Axboe

