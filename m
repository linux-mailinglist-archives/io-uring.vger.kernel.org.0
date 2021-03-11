Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B79B03371A7
	for <lists+io-uring@lfdr.de>; Thu, 11 Mar 2021 12:46:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232760AbhCKLqP (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 11 Mar 2021 06:46:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52494 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232754AbhCKLqM (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 11 Mar 2021 06:46:12 -0500
Received: from hr2.samba.org (hr2.samba.org [IPv6:2a01:4f8:192:486::2:0])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AB682C061574
        for <io-uring@vger.kernel.org>; Thu, 11 Mar 2021 03:46:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=samba.org;
         s=42; h=Date:Message-ID:From:To:CC;
        bh=hfntgB+ERpSRhEccJpUTjpbIyouYPN4eJrG/K8X/tv8=; b=DpYWvFN/obOVglgkQfxq4pc5gu
        UmWDwLgFaToGhGEpgNRYSPd8RfTCY93L28/Jjds4oBHHfJlWc8UIcWCcyfhUpwYTFqDggInpv0oGX
        SBk/LoLVBunrrqe0DEpUwTqMoBjzw1RwpZ0KRsfDPtAx5op//uYMUoterzLLNixV9jsz32HEU/eEH
        Wf65k98Rd3GNpSbC1u/CB0wnbgiNXSbdk0uYNyQFffSo7+9kLbeTLy6td0bAc0Vn71aRm+FQZfvfs
        cJyzEG2fUjiDvNjrh3EvEaYCcQmxzZ1FmAjDCI7CGxMoyIExTqE7S2R7U0h/v+xPYuRn5arnivgjP
        jneKaybEp9hzwzgRtXNPU9hxmaZUJwvve9HYskeYMAKOO0j8Azlnro5fSlIKqSV5Z6LiZlaQzby5i
        V7Q9TVkGiPN1jwGgtMg3FbZTXtl1IwLswoQECtPB3cJzYsrrFKaVqHkaOT1/+5u7Ezi+9CTJRw26a
        9ebBsS2DO9ipePGV62fwAf75;
Received: from [127.0.0.2] (localhost [127.0.0.1])
        by hr2.samba.org with esmtpsa (TLS1.3:ECDHE_RSA_CHACHA20_POLY1305:256)
        (Exim)
        id 1lKJlZ-0002Kv-GS; Thu, 11 Mar 2021 11:46:09 +0000
To:     Pavel Begunkov <asml.silence@gmail.com>,
        Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
References: <cover.1615381765.git.asml.silence@gmail.com>
 <fd8edef7aecde8d776d703350b3f6c0ec3154ed3.1615381765.git.asml.silence@gmail.com>
 <a25f115b-830c-e0f6-6d61-ff171412ea8b@samba.org>
 <b5fe7af7-3948-67ae-e716-2d2d3d985191@gmail.com>
From:   Stefan Metzmacher <metze@samba.org>
Subject: IORING_SETUP_ATTACH_WQ (was Re: [PATCH 1/3] io_uring: fix invalid
 ctx->sq_thread_idle)
Message-ID: <5efea46e-8dce-3d6b-99e4-9ee9a111d8a6@samba.org>
Date:   Thu, 11 Mar 2021 12:46:09 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.1
MIME-Version: 1.0
In-Reply-To: <b5fe7af7-3948-67ae-e716-2d2d3d985191@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org


Am 11.03.21 um 12:18 schrieb Pavel Begunkov:
> On 10/03/2021 13:56, Stefan Metzmacher wrote:
>>
>> Hi Pavel,
>>
>> I wondered about the exact same change this morning, while researching
>> the IORING_SETUP_ATTACH_WQ behavior :-)
>>
>> It still seems to me that IORING_SETUP_ATTACH_WQ changed over time.
>> As you introduced that flag, can you summaries it's behavior (and changes)
>> over time (over the releases).
> 
> Not sure I remember the story in details, but from the beginning it was
> for io-wq sharing only, then it had expanded to SQPOLL as well. Now it's
> only about SQPOLL sharing, because of the recent io-wq changes that made
> it per-task and shared by default.
> 
> In all cases it should be checking the passed in file, that should retain
> the old behaviour of failing setup if the flag is set but wq_fd is not valid.

Thanks, that's what I also found so far, see below for more findings.

>>
>> I'm wondering if ctx->sq_creds is really the only thing we need to take care of.
> 
> io-wq is not affected by IORING_SETUP_ATTACH_WQ. It's per-task and mimics
> all the resources of the creator (on the moment of io-wq creation). Off
> ATTACH_WQ topic, but that's almost matches what it has been before, and
> with dropped unshare bit, should be totally same.
> 
> Regarding SQPOLL, it was always using resources of the first task, so
> those are just reaped of from it, and not only some particular like
> mm/files but all of them, like fork does, so should be safer.
> 
> Creds are just a special case because of that personality stuff, at least
> if we add back iowq unshare handling.
> 
>>
>> Do we know about existing users of IORING_SETUP_ATTACH_WQ and their use case?
> 
> Have no clue.
> 
>> As mm, files and other things may differ now between sqe producer and the sq_thread.
> 
> It was always using mm/files of the ctx creator's task, aka ctx->sqo_task,
> but right, for the sharing case those may be different b/w ctx, so looks
> like a regression to me

Good. I'll try to explore a possible way out below.

Ok, I'm continuing the thread here (just pasting the mail I already started to write :-)

I did some more research regarding IORING_SETUP_ATTACH_WQ in 5.12.

The current logic in io_sq_offload_create() is this:

+       /* Retain compatibility with failing for an invalid attach attempt */
+       if ((ctx->flags & (IORING_SETUP_ATTACH_WQ | IORING_SETUP_SQPOLL)) ==
+                               IORING_SETUP_ATTACH_WQ) {
+               struct fd f;
+
+               f = fdget(p->wq_fd);
+               if (!f.file)
+                       return -ENXIO;
+               if (f.file->f_op != &io_uring_fops) {
+                       fdput(f);
+                       return -EINVAL;
+               }
+               fdput(f);
+       }

That means that IORING_SETUP_ATTACH_WQ (without IORING_SETUP_SQPOLL) is completely
ignored (except that we still simulate the -ENXIO and -EINVAL  cases), correct?
(You already agreed on that above :-)

The reason for this is that io_wq is no longer maintained per io_ring_ctx,
but instead it is now global per io_uring_task.
Which means each userspace thread (or the sq_thread) has its own io_uring_task and
thus its own io_wq.

Regarding the IORING_SETUP_SQPOLL|IORING_SETUP_ATTACH_WQ case we still allow attaching
to the sq_thread of a different io_ring_ctx. The sq_thread runs in the context of
the io_uring_setup() syscall that created it. We used to switch current->mm, current->files
and other things before calling __io_sq_thread() before, but we no longer do that.
And this seems to be security problem to me, as it's now possible for the attached
io_ring_ctx to start sqe's copying the whole address space of the donator into
a registered fixed file of the attached process.

As we already ignore IORING_SETUP_ATTACH_WQ without IORING_SETUP_SQPOLL, what about
ignoring it as well if the attaching task uses different ->mm, ->files, ...
So IORING_SETUP_ATTACH_WQ would only have any effect if the task calling io_uring_setup()
runs in the same context (except of the creds) as the existing sq_thread, which means it would work
if multiple userspace threads of the same userspace process want to share the sq_thread and its
io_wq. Everything else would be stupid (similar to the unshare() cases).
But as this has worked before, we just silently ignore IORING_SETUP_ATTACH_WQ is
we find a context mismatch and let io_uring_setup() silently create a new sq_thread.

What do you think?

metze
