Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E8AD1337805
	for <lists+io-uring@lfdr.de>; Thu, 11 Mar 2021 16:39:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233653AbhCKPjO (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 11 Mar 2021 10:39:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46156 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234167AbhCKPix (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 11 Mar 2021 10:38:53 -0500
Received: from mail-io1-xd33.google.com (mail-io1-xd33.google.com [IPv6:2607:f8b0:4864:20::d33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0C7D5C061574
        for <io-uring@vger.kernel.org>; Thu, 11 Mar 2021 07:38:53 -0800 (PST)
Received: by mail-io1-xd33.google.com with SMTP id a7so22326775iok.12
        for <io-uring@vger.kernel.org>; Thu, 11 Mar 2021 07:38:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:from:to:references:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=JsQnXC6e2yh5wCSaarv2wRJlNWuH8zl1Q4/XpLtLbYw=;
        b=eQyDLnFcU7hkPtCzzWMPcmkoj0ruekSOjO2f8ztqhGvmklrBtDYh8jJb589vZ7jJ48
         ME+BGF0NEcaReptPSXIiIaP0KKzT9IMR8pfjXpL20eZZcfrGfghUd3SJr8StZA+0SPnT
         Be+k27VN7LkRaQQudYihn+ATKfcLyiC9btz/qbXk2hWTIgaEFe75m85cVxAUA7TQcJIU
         49fwq1MEuq9rNm2YGERXiGs7mhMFGAolRasOk338gPnKjx8HVG0+qxLdJTK3K6ugurMj
         zHO2zs/eID824IgRAD4TpW9Y4Aet4Q0zqXBDYV61SGWXGjEQy/+JiE2ELsZuGvK8UGTn
         G6pg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:references:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=JsQnXC6e2yh5wCSaarv2wRJlNWuH8zl1Q4/XpLtLbYw=;
        b=rwkkB+HIjU4TEV7CT3qIY5utsI0362YxP+PDqQhTJOl2mdrQf0KzNSwH/mmtPyGL/7
         KXcTfJAYiMaIOQ6aPCG+KW8I2oqVGbrtC6ewAIYyFmfsXGKLc9CfgsuKyBFBy3SqCUrq
         wR+Ioa7RUEpcNI0VmKdKqq0jAMrx739KM6kSA3ILnyTabcnGTrJbJZeiTbOfBMDezxUH
         Gd9sTskldvSOtmHgubdsVchit37jKjcuqcekrCZdEhKLu1zlFpeGn509vpJEgrJ3sDVB
         jbb5T3Qhxw1qJBJExKAEKGu8O93LAn/nFdRhpsxqJFNZAQEGuOg50Bg+mjkCbGlcQQ3b
         m+mQ==
X-Gm-Message-State: AOAM53356AOHTPRciJUgFZ+UYJk/P+qX9NeE0dJTiYpyQsnfKChDsbCE
        YQ+0A7sUII2oKPsxLKyx5DKv+2F8lASBlQ==
X-Google-Smtp-Source: ABdhPJzkNQxr2oERoQZ4RNiQhd58CKgMbysbJas/fqtWx68JD47inxPfVkbTVUO6ZFVm1zQK9B6DQQ==
X-Received: by 2002:a02:b890:: with SMTP id p16mr4148801jam.138.1615477132073;
        Thu, 11 Mar 2021 07:38:52 -0800 (PST)
Received: from [192.168.1.30] ([65.144.74.34])
        by smtp.gmail.com with ESMTPSA id c18sm1499084ild.37.2021.03.11.07.38.51
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 11 Mar 2021 07:38:51 -0800 (PST)
Subject: Re: IORING_SETUP_ATTACH_WQ (was Re: [PATCH 1/3] io_uring: fix invalid
 ctx->sq_thread_idle)
From:   Jens Axboe <axboe@kernel.dk>
To:     Stefan Metzmacher <metze@samba.org>,
        Pavel Begunkov <asml.silence@gmail.com>,
        io-uring@vger.kernel.org
References: <cover.1615381765.git.asml.silence@gmail.com>
 <fd8edef7aecde8d776d703350b3f6c0ec3154ed3.1615381765.git.asml.silence@gmail.com>
 <a25f115b-830c-e0f6-6d61-ff171412ea8b@samba.org>
 <b5fe7af7-3948-67ae-e716-2d2d3d985191@gmail.com>
 <5efea46e-8dce-3d6b-99e4-9ee9a111d8a6@samba.org>
 <470c84a6-70bf-be9e-ab38-5fa357299749@gmail.com>
 <a2583c0d-5fae-094c-7768-f37477b0559d@samba.org>
 <d954c7df-ef25-038e-9ef5-9b5dcbd4b14a@kernel.dk>
Message-ID: <a677fc5d-aa83-163c-0701-41a65cd084f8@kernel.dk>
Date:   Thu, 11 Mar 2021 08:38:50 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <d954c7df-ef25-038e-9ef5-9b5dcbd4b14a@kernel.dk>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 3/11/21 8:30 AM, Jens Axboe wrote:
> On 3/11/21 5:44 AM, Stefan Metzmacher wrote:
>>
>> Am 11.03.21 um 13:27 schrieb Pavel Begunkov:
>>> On 11/03/2021 11:46, Stefan Metzmacher wrote:
>>>> Am 11.03.21 um 12:18 schrieb Pavel Begunkov:
>>>>> On 10/03/2021 13:56, Stefan Metzmacher wrote:
>>>>>>
>>>>>> Hi Pavel,
>>>>>>
>>>>>> I wondered about the exact same change this morning, while researching
>>>>>> the IORING_SETUP_ATTACH_WQ behavior :-)
>>>>>>
>>>>>> It still seems to me that IORING_SETUP_ATTACH_WQ changed over time.
>>>>>> As you introduced that flag, can you summaries it's behavior (and changes)
>>>>>> over time (over the releases).
>>>>>
>>>>> Not sure I remember the story in details, but from the beginning it was
>>>>> for io-wq sharing only, then it had expanded to SQPOLL as well. Now it's
>>>>> only about SQPOLL sharing, because of the recent io-wq changes that made
>>>>> it per-task and shared by default.
>>>>>
>>>>> In all cases it should be checking the passed in file, that should retain
>>>>> the old behaviour of failing setup if the flag is set but wq_fd is not valid.
>>>>
>>>> Thanks, that's what I also found so far, see below for more findings.
>>>>
>>>>>>
>>>>>> I'm wondering if ctx->sq_creds is really the only thing we need to take care of.
>>>>>
>>>>> io-wq is not affected by IORING_SETUP_ATTACH_WQ. It's per-task and mimics
>>>>> all the resources of the creator (on the moment of io-wq creation). Off
>>>>> ATTACH_WQ topic, but that's almost matches what it has been before, and
>>>>> with dropped unshare bit, should be totally same.
>>>>>
>>>>> Regarding SQPOLL, it was always using resources of the first task, so
>>>>> those are just reaped of from it, and not only some particular like
>>>>> mm/files but all of them, like fork does, so should be safer.
>>>>>
>>>>> Creds are just a special case because of that personality stuff, at least
>>>>> if we add back iowq unshare handling.
>>>>>
>>>>>>
>>>>>> Do we know about existing users of IORING_SETUP_ATTACH_WQ and their use case?
>>>>>
>>>>> Have no clue.
>>>>>
>>>>>> As mm, files and other things may differ now between sqe producer and the sq_thread.
>>>>>
>>>>> It was always using mm/files of the ctx creator's task, aka ctx->sqo_task,
>>>>> but right, for the sharing case those may be different b/w ctx, so looks
>>>>> like a regression to me
>>>>
>>>> Good. I'll try to explore a possible way out below.
>>>>
>>>> Ok, I'm continuing the thread here (just pasting the mail I already started to write :-)
>>>>
>>>> I did some more research regarding IORING_SETUP_ATTACH_WQ in 5.12.
>>>>
>>>> The current logic in io_sq_offload_create() is this:
>>>>
>>>> +       /* Retain compatibility with failing for an invalid attach attempt */
>>>> +       if ((ctx->flags & (IORING_SETUP_ATTACH_WQ | IORING_SETUP_SQPOLL)) ==
>>>> +                               IORING_SETUP_ATTACH_WQ) {
>>>> +               struct fd f;
>>>> +
>>>> +               f = fdget(p->wq_fd);
>>>> +               if (!f.file)
>>>> +                       return -ENXIO;
>>>> +               if (f.file->f_op != &io_uring_fops) {
>>>> +                       fdput(f);
>>>> +                       return -EINVAL;
>>>> +               }
>>>> +               fdput(f);
>>>> +       }
>>>>
>>>> That means that IORING_SETUP_ATTACH_WQ (without IORING_SETUP_SQPOLL) is completely
>>>> ignored (except that we still simulate the -ENXIO and -EINVAL  cases), correct?
>>>> (You already agreed on that above :-)
>>>
>>> Yep, and we do these -ENXIO and -EINVAL for SQPOLL as well.
>>>  
>>>> The reason for this is that io_wq is no longer maintained per io_ring_ctx,
>>>> but instead it is now global per io_uring_task.
>>>> Which means each userspace thread (or the sq_thread) has its own io_uring_task and
>>>> thus its own io_wq.
>>>
>>> Just for anyone out of context, it's per process/thread/struct task/etc.
>>> struct io_uring_task is just a bit of a context attached to a task ever submitted
>>> io_uring requests, and its' not some special kind of a task.
>>>
>>>> Regarding the IORING_SETUP_SQPOLL|IORING_SETUP_ATTACH_WQ case we still allow attaching
>>>> to the sq_thread of a different io_ring_ctx. The sq_thread runs in the context of
>>>> the io_uring_setup() syscall that created it. We used to switch current->mm, current->files
>>>> and other things before calling __io_sq_thread() before, but we no longer do that.
>>>> And this seems to be security problem to me, as it's now possible for the attached
>>>> io_ring_ctx to start sqe's copying the whole address space of the donator into
>>>> a registered fixed file of the attached process.
>>>
>>> It's not as bad, because 1) you voluntarily passes fd and 2) requires privileges,
>>> but it's a change of behaviour, which, well, can be exploited as you said.
>>
>> Yes, but pointers and other things may have a different meaning now, as they were
>> against the thread that produced the sqe's and now it's relativ to the unchanged sq_thread.
>> So unmodified application may corrupt/leak there data.
>>
>>>> As we already ignore IORING_SETUP_ATTACH_WQ without IORING_SETUP_SQPOLL, what about
>>>> ignoring it as well if the attaching task uses different ->mm, ->files, ...
>>>> So IORING_SETUP_ATTACH_WQ would only have any effect if the task calling io_uring_setup()
>>>> runs in the same context (except of the creds) as the existing sq_thread, which means it would work
>>>> if multiple userspace threads of the same userspace process want to share the sq_thread and its
>>>> io_wq. Everything else would be stupid (similar to the unshare() cases).
>>>> But as this has worked before, we just silently ignore IORING_SETUP_ATTACH_WQ is
>>>> we find a context mismatch and let io_uring_setup() silently create a new sq_thread.
>>>
>>> options:
>>> 1. Return back all that acquire_mm_files. Not great, not as safe
>>> as new io-wq, etc.
>>>
>>> 2. Completely ignore SQPOLL sharing. Performance regressions...
>>>
>>> 3. Do selected sharing. Maybe if thread group or so matches, should
>>> be safer than just mm/files check (or any subset of possibly long
>>> list). And there may be differences when the creator task do
>>> unshare/etc., but can be patched up (from where the unshare hook came
>>> in the first place).
>>>
>>> I like 3) but 2) may do as well. The only performance problem I see
>>> is for those who wanted to use it out of threads. E.g. there even
>>> was a proposal to have per-CPU SQPOLL tasks and keep them per whole
>>> system.
>>
>> Yes 2. with having a new IORING_SETUP_ATTACH_SQ (see my other mail)
>>
>> Or 3. and I guess the thread group might be ok.
>> But somehow 2 feels safer and we could start with fresh ideas from there.
> 
> 3 should be perfectly safe, outside of someone doing unshare(). And I
> think we already agreed that this case is in the realm of "garbage in,
> garbage out" and we don't need to specifically cater to it. If we match
> at attach time, we should be good to go.

Just to be clear, something like the below - totally untested, but
in principle.


diff --git a/fs/io_uring.c b/fs/io_uring.c
index 6c62a3c95c1a..9a732b3b39fa 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -269,6 +269,7 @@ struct io_sq_data {
 	unsigned		sq_thread_idle;
 	int			sq_cpu;
 	pid_t			task_pid;
+	pid_t			task_tgid;
 
 	unsigned long		state;
 	struct completion	startup;
@@ -7081,6 +7082,10 @@ static struct io_sq_data *io_attach_sq_data(struct io_uring_params *p)
 		fdput(f);
 		return ERR_PTR(-EINVAL);
 	}
+	if (sqd->task_tgid != current->tgid) {
+		fdput(f);
+		return ERR_PTR(-EPERM);
+	}
 
 	refcount_inc(&sqd->refs);
 	fdput(f);
@@ -7091,8 +7096,14 @@ static struct io_sq_data *io_get_sq_data(struct io_uring_params *p)
 {
 	struct io_sq_data *sqd;
 
-	if (p->flags & IORING_SETUP_ATTACH_WQ)
-		return io_attach_sq_data(p);
+	if (p->flags & IORING_SETUP_ATTACH_WQ) {
+		sqd = io_attach_sq_data(p);
+		if (!IS_ERR(sqd))
+			return sqd;
+		/* fall through for EPERM case, setup new sqd/task */
+		if (PTR_ERR(sqd) != -EPERM)
+			return sqd;
+	}
 
 	sqd = kzalloc(sizeof(*sqd), GFP_KERNEL);
 	if (!sqd)
@@ -7793,6 +7804,7 @@ static int io_sq_offload_create(struct io_ring_ctx *ctx,
 		}
 
 		sqd->task_pid = current->pid;
+		sqd->task_tgid = current->tgid;
 		tsk = create_io_thread(io_sq_thread, sqd, NUMA_NO_NODE);
 		if (IS_ERR(tsk)) {
 			ret = PTR_ERR(tsk);

-- 
Jens Axboe

