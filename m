Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9C4377D6F68
	for <lists+io-uring@lfdr.de>; Wed, 25 Oct 2023 16:43:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233628AbjJYOMR (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 25 Oct 2023 10:12:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48788 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235079AbjJYOMQ (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 25 Oct 2023 10:12:16 -0400
Received: from mail-io1-xd33.google.com (mail-io1-xd33.google.com [IPv6:2607:f8b0:4864:20::d33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A6237189
        for <io-uring@vger.kernel.org>; Wed, 25 Oct 2023 07:12:12 -0700 (PDT)
Received: by mail-io1-xd33.google.com with SMTP id ca18e2360f4ac-7a6643ba679so40554339f.1
        for <io-uring@vger.kernel.org>; Wed, 25 Oct 2023 07:12:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1698243132; x=1698847932; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=C+mW7kMSuK3NzW1jiI5GCJyWXx0fI+ce4Y2QfsD3XRY=;
        b=nlSODgFbo1p5BzL1PHGIBUMskZf6maO27H+CUooRUhjY33V15xVoXRAAhPujShTFIo
         YWt3hwp2RGV3mU2WaRtaGEnU3r7uSvAevPEKyxICFzqWRMmdeJxK5H93QzFMV6tPKvnd
         LBlMFps7i6QG58n4GkswhwhFJyCq+ohMe/fu//H6297+WZxZgLpqBANI6yrovR0fdCyk
         ey+cVeBURP6jSNxZNjR2HgGaBajJ1EliXnARnj/eJ+E6OZKD2pEf6MvowsZIqC82iKzi
         WG2jnauOlF6e0++hJlEI+hpWn7dL4Ou3Zbu7PT4RTWQEj/a+Niw4/2yXUnU8hphO8xvk
         26qA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1698243132; x=1698847932;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=C+mW7kMSuK3NzW1jiI5GCJyWXx0fI+ce4Y2QfsD3XRY=;
        b=CKTMslSLA4SQL9zFJflPaMNgLxMWSvzODg/FF70fFg4bz6Py4ZARrel6FRdrYaPMsB
         9HJKLWq6NEwlOTRFE7dSPBe4HJrjLFujmhU6SQeslivWdwMSV+3W8xEfw5cB/S/Fkcd5
         GqpnKbub+7kkrhnvbaRSombtA5ezcU4zgSLnoE0ztcc4baVPRYw8GxtPcO3l7a7cifou
         Chz0j70eYm4SUWatCtXBvYfOT5jaV8QSOVyk5IOHSMCi0HsI7Xm43cwuFQ4bLOeOtevZ
         T66oZ+qpu9pmsp9Mevq1K5z7YyncLJAdGSOFmEnpNK3u2xOWY14Jvtw7VoYqAjIWIU/0
         Os0w==
X-Gm-Message-State: AOJu0YyfACj6l9NiFVw4ktwL4D7jw8DLHP4naEeeb+PBimQdq9T+McQ6
        ulZA59D2qUCLJLB0N3xBO/6ENA==
X-Google-Smtp-Source: AGHT+IFChEatE+Fny22th1+AGzrOabn3wHmYs+Rhxa0zTSdwxCaOLOVJSN0mxltsEevwJG0E0S995g==
X-Received: by 2002:a05:6602:120b:b0:79a:c487:2711 with SMTP id y11-20020a056602120b00b0079ac4872711mr16247020iot.0.1698243131888;
        Wed, 25 Oct 2023 07:12:11 -0700 (PDT)
Received: from [192.168.1.94] ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id f10-20020a056638118a00b0042b1c02d17csm3452821jas.2.2023.10.25.07.12.11
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 25 Oct 2023 07:12:11 -0700 (PDT)
Message-ID: <9c39b20e-2cbd-4715-be04-2d93759ca269@kernel.dk>
Date:   Wed, 25 Oct 2023 08:12:10 -0600
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] io_uring/fdinfo: park SQ thread while retrieving cpu/pid
Content-Language: en-US
To:     Pavel Begunkov <asml.silence@gmail.com>,
        Gabriel Krisman Bertazi <krisman@suse.de>
Cc:     io-uring <io-uring@vger.kernel.org>
References: <64f28d0f-b2b9-4ff4-8e2f-efdf1c63d3d4@kernel.dk>
 <65368e95.170a0220.4fb79.0929SMTPIN_ADDED_BROKEN@mx.google.com>
 <23557993-424d-42a8-b832-2e59f164a577@kernel.dk>
 <103b6f05-831c-e875-478a-7e9f8187575e@gmail.com>
 <de2c75e1-8f0a-4dfe-81f2-fa2637096c6d@kernel.dk>
 <0a2d4d82-b54b-7643-4cbe-455fe3ea87df@gmail.com>
From:   Jens Axboe <axboe@kernel.dk>
In-Reply-To: <0a2d4d82-b54b-7643-4cbe-455fe3ea87df@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 10/25/23 8:09 AM, Pavel Begunkov wrote:
> On 10/25/23 14:44, Jens Axboe wrote:
>> On 10/25/23 6:09 AM, Pavel Begunkov wrote:
>>> On 10/23/23 16:27, Jens Axboe wrote:
>>>> On 10/23/23 9:17 AM, Gabriel Krisman Bertazi wrote:
>>>>> Jens Axboe <axboe@kernel.dk> writes:
>>>>>
>>>>>> We could race with SQ thread exit, and if we do, we'll hit a NULL pointer
>>>>>> dereference. Park the SQPOLL thread while getting the task cpu and pid for
>>>>>> fdinfo, this ensures we have a stable view of it.
>>>>>>
>>>>>> Cc: stable@vger.kernel.org
>>>>>> Link: https://bugzilla.kernel.org/show_bug.cgi?id=218032
>>>>>> Signed-off-by: Jens Axboe <axboe@kernel.dk>
>>>>>>
>>>>>> ---
>>>>>>
>>>>>> diff --git a/io_uring/fdinfo.c b/io_uring/fdinfo.c
>>>>>> index c53678875416..cd2a0c6b97c4 100644
>>>>>> --- a/io_uring/fdinfo.c
>>>>>> +++ b/io_uring/fdinfo.c
>>>>>> @@ -53,7 +53,6 @@ static __cold int io_uring_show_cred(struct seq_file *m, unsigned int id,
>>>>>>    __cold void io_uring_show_fdinfo(struct seq_file *m, struct file *f)
>>>>>>    {
>>>>>>        struct io_ring_ctx *ctx = f->private_data;
>>>>>> -    struct io_sq_data *sq = NULL;
>>>>>>        struct io_overflow_cqe *ocqe;
>>>>>>        struct io_rings *r = ctx->rings;
>>>>>>        unsigned int sq_mask = ctx->sq_entries - 1, cq_mask = ctx->cq_entries - 1;
>>>>>> @@ -64,6 +63,7 @@ __cold void io_uring_show_fdinfo(struct seq_file *m, struct file *f)
>>>>>>        unsigned int cq_shift = 0;
>>>>>>        unsigned int sq_shift = 0;
>>>>>>        unsigned int sq_entries, cq_entries;
>>>>>> +    int sq_pid = -1, sq_cpu = -1;
>>>>>>        bool has_lock;
>>>>>>        unsigned int i;
>>>>>>    @@ -143,13 +143,18 @@ __cold void io_uring_show_fdinfo(struct seq_file *m, struct file *f)
>>>>>>        has_lock = mutex_trylock(&ctx->uring_lock);
>>>>>>          if (has_lock && (ctx->flags & IORING_SETUP_SQPOLL)) {
>>>>>> -        sq = ctx->sq_data;
>>>>>> -        if (!sq->thread)
>>>>>> -            sq = NULL;
>>>>>> +        struct io_sq_data *sq = ctx->sq_data;
>>>>>> +
>>>>>> +        io_sq_thread_park(sq);
>>>>>> +        if (sq->thread) {
>>>>>> +            sq_pid = task_pid_nr(sq->thread);
>>>>>> +            sq_cpu = task_cpu(sq->thread);
>>>>>> +        }
>>>>>> +        io_sq_thread_unpark(sq);
>>>>>
>>>>> Jens,
>>>>>
>>>>> io_sq_thread_park will try to wake the sqpoll, which is, at least,
>>>>> unnecessary. But I'm thinking we don't want to expose the ability to
>>>>> schedule the sqpoll from procfs, which can be done by any unrelated
>>>>> process.
>>>>>
>>>>> To solve the bug, it should be enough to synchronize directly on
>>>>> sqd->lock, preventing sq->thread from going away inside the if leg.
>>>>> Granted, it is might take longer if the sqpoll is busy, but reading
>>>>> fdinfo is not supposed to be fast.  Alternatively, don't call
>>>>> wake_process in this case?
>>>>
>>>> I did think about that but just went with the exported API. But you are
>>>> right, it's a bit annoying that it'd also wake the thread, in case it
>>>
>>> Waking it up is not a problem but without parking sq thread won't drop
>>> the lock until it's time to sleep, which might be pretty long leaving
>>> the /proc read stuck on the lock uninterruptibly.
>>>
>>> Aside from parking vs lock, there is a lock inversion now:
>>>
>>> proc read                   | SQPOLL
>>>                              |
>>> try_lock(ring) // success   |
>>>                              | woken up
>>>                              | lock(sqd); // success
>>> lock(sqd); // stuck         |
>>>                              | try to submit requests
>>>                              | -- lock(ring); // stuck
>>
>> Yeah good point, forgot we nest these opposite of what you'd expect.
>> Honestly I think the fix here is just to turn it into a trylock. Yes
>> that'll miss some cases where we could've gotten the pid/cpu, but
>> doesn't seem worth caring about.
>>
>> IOW, fold in this incremental.
> 
> Should work, otherwise you probably can just park first.

In general I think it's better to have the observational side be less of
an impact, which is why I liked not doing the parking. Sometimes apps do
stupid things and monitor fdinfo/ etc continually. As it's possible to
get the task/cpu anyway via other means, should be better to just skip
if we don't get the lock.

> Long term it'd be nice to make sqpoll to not hold sqd->lock during
> submission + polling as it currently does. Park callers sleep on the
> lock, but if we replace it with some struct completion the rest
> should be easy enough.

Yeah agree.

-- 
Jens Axboe

