Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9B7143372A2
	for <lists+io-uring@lfdr.de>; Thu, 11 Mar 2021 13:32:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233170AbhCKMbj (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 11 Mar 2021 07:31:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34020 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233168AbhCKMb1 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 11 Mar 2021 07:31:27 -0500
Received: from mail-wm1-x32c.google.com (mail-wm1-x32c.google.com [IPv6:2a00:1450:4864:20::32c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AA433C061574
        for <io-uring@vger.kernel.org>; Thu, 11 Mar 2021 04:31:26 -0800 (PST)
Received: by mail-wm1-x32c.google.com with SMTP id d139-20020a1c1d910000b029010b895cb6f2so12685843wmd.5
        for <io-uring@vger.kernel.org>; Thu, 11 Mar 2021 04:31:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=to:references:from:autocrypt:subject:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=d4ckwLHzN/P7xZfOplFqCeLHeRN2HWBi1ZX65VGIJu4=;
        b=NTxL73Rrbh7OAklRR/3GPQwIVuMoc45o0Ir/fo/i91qSCMYiYDj4HzDw9TL3V4ltAI
         5H7fwqjdXic4P2Pvv4yJ7toTB4KcM5IMvwPGtgSHwjQD7t0TN39JFQNr9ll4Tjao7sIU
         bvy+BH22HG4L6OOajXuesha95bw3Z8YpYchui6EnjnXOphMUfvgYBqa/zMX7mrphTYIO
         60kTzkhLstmfBGrFrrFeEXEZhfLsFcfsm6/I/Wk9RP+55iZVN5waJc+jR7mF4Hn9iEv4
         kH3HCHmTVDZUEVuaSUGFbl/nXFAqRZZy2E6+rImQ/38xBRV6rpgnmgGb9EDnIdcXYM56
         CLRw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:to:references:from:autocrypt:subject:message-id
         :date:user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=d4ckwLHzN/P7xZfOplFqCeLHeRN2HWBi1ZX65VGIJu4=;
        b=KP0reqYYp3BA3TmNPpG1Qqb8+ZPCG0C/FUCWm9w4vb0vqhcJ+0Qp1o47uTUee1j4PJ
         MlCF57YHSMTAbgJ7l+ej+FgAYV2kSRLSoF8IlO6lB3qnzJQ5ueNzkacvA7mKnvX7heJy
         YY1/VuCTtRQSsOJG0tF8V5GEVK8BG3HBl1/TNOdi36cDkQUSO9hA8USdVR22R5agzVc2
         NiZIXYsr5TE1pEAz/XtAHBB7anFa04KEZtMM1nlApNPqCs6WNDZiSvS+xZhtPDpyrjF1
         F/hn5+4R0vGUEGXRBjKKPupMSqOp1LGhDy94P2lbn9TMMsyWPsdZVHIZybRzJlfx953Y
         Nf1A==
X-Gm-Message-State: AOAM531NvDgm4rB7B4C5sCYIv4djTBTGN/PgUeIfSyjTYmcsfPTy0N/k
        bSRzkTRZGx4c8MIe4cGchD2BalOiTcg=
X-Google-Smtp-Source: ABdhPJwZEcTgNeRgdebj4ygQRZuDQvNZ6HwYuawZf8qeMz1JxaQxIM/8VWdXCbjkzqNP9XOjYRB5gQ==
X-Received: by 2002:a1c:61c5:: with SMTP id v188mr7848549wmb.20.1615465884829;
        Thu, 11 Mar 2021 04:31:24 -0800 (PST)
Received: from [192.168.8.134] ([185.69.144.148])
        by smtp.gmail.com with ESMTPSA id o7sm3621057wrs.16.2021.03.11.04.31.23
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 11 Mar 2021 04:31:24 -0800 (PST)
To:     Stefan Metzmacher <metze@samba.org>, Jens Axboe <axboe@kernel.dk>,
        io-uring@vger.kernel.org
References: <cover.1615381765.git.asml.silence@gmail.com>
 <fd8edef7aecde8d776d703350b3f6c0ec3154ed3.1615381765.git.asml.silence@gmail.com>
 <a25f115b-830c-e0f6-6d61-ff171412ea8b@samba.org>
 <b5fe7af7-3948-67ae-e716-2d2d3d985191@gmail.com>
 <5efea46e-8dce-3d6b-99e4-9ee9a111d8a6@samba.org>
From:   Pavel Begunkov <asml.silence@gmail.com>
Autocrypt: addr=asml.silence@gmail.com; prefer-encrypt=mutual; keydata=
 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 bA==
Subject: Re: IORING_SETUP_ATTACH_WQ (was Re: [PATCH 1/3] io_uring: fix invalid
 ctx->sq_thread_idle)
Message-ID: <470c84a6-70bf-be9e-ab38-5fa357299749@gmail.com>
Date:   Thu, 11 Mar 2021 12:27:28 +0000
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.3.0
MIME-Version: 1.0
In-Reply-To: <5efea46e-8dce-3d6b-99e4-9ee9a111d8a6@samba.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 11/03/2021 11:46, Stefan Metzmacher wrote:
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
> Ok, I'm continuing the thread here (just pasting the mail I already started to write :-)
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
> That means that IORING_SETUP_ATTACH_WQ (without IORING_SETUP_SQPOLL) is completely
> ignored (except that we still simulate the -ENXIO and -EINVAL  cases), correct?
> (You already agreed on that above :-)

Yep, and we do these -ENXIO and -EINVAL for SQPOLL as well.
 
> The reason for this is that io_wq is no longer maintained per io_ring_ctx,
> but instead it is now global per io_uring_task.
> Which means each userspace thread (or the sq_thread) has its own io_uring_task and
> thus its own io_wq.

Just for anyone out of context, it's per process/thread/struct task/etc.
struct io_uring_task is just a bit of a context attached to a task ever submitted
io_uring requests, and its' not some special kind of a task.

> Regarding the IORING_SETUP_SQPOLL|IORING_SETUP_ATTACH_WQ case we still allow attaching
> to the sq_thread of a different io_ring_ctx. The sq_thread runs in the context of
> the io_uring_setup() syscall that created it. We used to switch current->mm, current->files
> and other things before calling __io_sq_thread() before, but we no longer do that.
> And this seems to be security problem to me, as it's now possible for the attached
> io_ring_ctx to start sqe's copying the whole address space of the donator into
> a registered fixed file of the attached process.

It's not as bad, because 1) you voluntarily passes fd and 2) requires privileges,
but it's a change of behaviour, which, well, can be exploited as you said.

> As we already ignore IORING_SETUP_ATTACH_WQ without IORING_SETUP_SQPOLL, what about
> ignoring it as well if the attaching task uses different ->mm, ->files, ...
> So IORING_SETUP_ATTACH_WQ would only have any effect if the task calling io_uring_setup()
> runs in the same context (except of the creds) as the existing sq_thread, which means it would work
> if multiple userspace threads of the same userspace process want to share the sq_thread and its
> io_wq. Everything else would be stupid (similar to the unshare() cases).
> But as this has worked before, we just silently ignore IORING_SETUP_ATTACH_WQ is
> we find a context mismatch and let io_uring_setup() silently create a new sq_thread.

options:
1. Return back all that acquire_mm_files. Not great, not as safe
as new io-wq, etc.

2. Completely ignore SQPOLL sharing. Performance regressions...

3. Do selected sharing. Maybe if thread group or so matches, should
be safer than just mm/files check (or any subset of possibly long
list). And there may be differences when the creator task do
unshare/etc., but can be patched up (from where the unshare hook came
in the first place).

I like 3) but 2) may do as well. The only performance problem I see
is for those who wanted to use it out of threads. E.g. there even
was a proposal to have per-CPU SQPOLL tasks and keep them per whole
system.

-- 
Pavel Begunkov
