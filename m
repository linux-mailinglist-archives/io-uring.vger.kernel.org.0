Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4817E3DF44D
	for <lists+io-uring@lfdr.de>; Tue,  3 Aug 2021 20:04:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234051AbhHCSFA (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 3 Aug 2021 14:05:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56628 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233498AbhHCSFA (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 3 Aug 2021 14:05:00 -0400
Received: from mail-pl1-x62c.google.com (mail-pl1-x62c.google.com [IPv6:2607:f8b0:4864:20::62c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EFBCDC061757
        for <io-uring@vger.kernel.org>; Tue,  3 Aug 2021 11:04:47 -0700 (PDT)
Received: by mail-pl1-x62c.google.com with SMTP id i10so35797pla.3
        for <io-uring@vger.kernel.org>; Tue, 03 Aug 2021 11:04:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:subject:from:in-reply-to:date:cc
         :content-transfer-encoding:message-id:references:to;
        bh=yrc/CySUWfoE6dHZzXg5QyEdsWprYeq3H3n6L7T8oRE=;
        b=CrGR3yiThAiRXqROB24Ho/3fzoU/dqQKQjf+4N7YD+KHFI2j+lYPTtJ2od98Hlta9t
         3k9UYn9urE9F1DdZ35IATpRmfxOukx5DZT5QGBFO4zmhwec5enXS2cUjgXi1FNXc0vw4
         Fe3ozN5pN0032HyCiX4/oTrub3qXgnpvLPnmkL1NaHTg4P5ZczVnoUpHVchzNohQduoa
         YjKNCdLcFybsYJk+x2UxK2z0t1EghLOXifH61e+YHtnyx4YdWxSMuCIRvW+4cPB/yiof
         cdSRyO70c9n+tQsbCdLqIPQ19WbqQBPGPUNmEfd87laiPEns0yRsWLp5D3wrK459PYIh
         rAjQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:subject:from:in-reply-to:date:cc
         :content-transfer-encoding:message-id:references:to;
        bh=yrc/CySUWfoE6dHZzXg5QyEdsWprYeq3H3n6L7T8oRE=;
        b=Abm9pd9hhX5RqH4C2ANAIDS2fKtkBXrWPDxjnFT0PP6UIxtBF66J0U+/jL6zDdFyJA
         sMgVBjfFnrnP8Z/KczLdIoQhPAMb3N9HbnPGl5QmCGve4F9lAnQaooxNfGXhGf0Sn6Ip
         vFN/ClPRNi6n0T/YPgQAGvQ3GQwDYk4tWghShxtkdvfbTbl1bSgNOgyqgx5mGLpmwfXR
         cbZ2IiK5wsGvD+1O2Emr3/2iv+4NUphHPRM8lb/yZpny1zupZUtHnyCvhhEWG+UZfztA
         FzbAfzfoe3OHr9PddeyKLxtxRAnq4hQzDwpmmfXZ6fO4rnqdhdkUgcpd5erB5WJriOmO
         SUXg==
X-Gm-Message-State: AOAM531HiZQaMtUd46YBKU4RutsAjE0b8hOc00m2qJ1PZSEnrQtDTQPJ
        7XWsybSoN1oAdD618kuaOmE=
X-Google-Smtp-Source: ABdhPJyCF4RBB3uKrpf3efQwy/rIzJ0oXlSLKWe7QlOgnNqQE2LzwK42ulXUw8CrwfeyNE7rmF0gHg==
X-Received: by 2002:a17:902:7c01:b029:12c:323d:9ac with SMTP id x1-20020a1709027c01b029012c323d09acmr19434797pll.12.1628013887242;
        Tue, 03 Aug 2021 11:04:47 -0700 (PDT)
Received: from smtpclient.apple (c-24-6-216-183.hsd1.ca.comcast.net. [24.6.216.183])
        by smtp.gmail.com with ESMTPSA id l2sm16290004pfc.157.2021.08.03.11.04.45
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 03 Aug 2021 11:04:46 -0700 (PDT)
Content-Type: text/plain;
        charset=utf-8
Mime-Version: 1.0 (Mac OS X Mail 14.0 \(3654.120.0.1.13\))
Subject: Re: Race between io_wqe_worker() and io_wqe_wake_worker()
From:   Nadav Amit <nadav.amit@gmail.com>
In-Reply-To: <c6ef9d6c-3127-090f-88a2-a1ffd432bbef@kernel.dk>
Date:   Tue, 3 Aug 2021 11:04:44 -0700
Cc:     io-uring@vger.kernel.org, Hao Xu <haoxu@linux.alibaba.com>
Content-Transfer-Encoding: quoted-printable
Message-Id: <3CEF2AD7-AD8B-478D-91ED-488E8441988F@gmail.com>
References: <BFF746C0-FEDE-4646-A253-3021C57C26C9@gmail.com>
 <5bc88410-6423-2554-340d-ef83f1ba9844@kernel.dk>
 <c6ef9d6c-3127-090f-88a2-a1ffd432bbef@kernel.dk>
To:     Jens Axboe <axboe@kernel.dk>
X-Mailer: Apple Mail (2.3654.120.0.1.13)
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org



> On Aug 3, 2021, at 7:37 AM, Jens Axboe <axboe@kernel.dk> wrote:
>=20
> On 8/3/21 7:22 AM, Jens Axboe wrote:
>> On 8/2/21 7:05 PM, Nadav Amit wrote:
>>> Hello Jens,
>>>=20
>>> I encountered an issue, which appears to be a race between
>>> io_wqe_worker() and io_wqe_wake_worker(). I am not sure how to =
address
>>> this issue and whether I am missing something, since this seems to
>>> occur in a common scenario. Your feedback (or fix ;-)) would be
>>> appreciated.
>>>=20
>>> I run on 5.13 a workload that issues multiple async read operations
>>> that should run concurrently. Some read operations can not complete
>>> for unbounded time (e.g., read from a pipe that is never written =
to).
>>> The problem is that occasionally another read operation that should
>>> complete gets stuck. My understanding, based on debugging and the =
code
>>> is that the following race (or similar) occurs:
>>>=20
>>>=20
>>>  cpu0					cpu1
>>>  ----					----
>>> 					io_wqe_worker()
>>> 					 schedule_timeout()
>>> 					 // timed out
>>>  io_wqe_enqueue()
>>>   io_wqe_wake_worker()
>>>    // work_flags & IO_WQ_WORK_CONCURRENT
>>>    io_wqe_activate_free_worker()
>>> 					 io_worker_exit()
>>>=20
>>>=20
>>> Basically, io_wqe_wake_worker() can find a worker, but this worker =
is
>>> about to exit and is not going to process further work. Once the
>>> worker exits, the concurrency level decreases and async work might =
be
>>> blocked by another work. I had a look at 5.14, but did not see
>>> anything that might address this issue.
>>>=20
>>> Am I missing something?
>>>=20
>>> If not, all my ideas for a solution are either complicated (track
>>> required concurrency-level) or relaxed (span another worker on
>>> io_worker_exit if work_list of unbounded work is not empty).
>>>=20
>>> As said, feedback would be appreciated.
>>=20
>> You are right that there's definitely a race here between checking =
the
>> freelist and finding a worker, but that worker is already exiting. =
Let
>> me mull over this a bit, I'll post something for you to try later =
today.
>=20
> Can you try something like this? Just consider it a first tester, need
> to spend a bit more time on it to ensure we fully close the gap.

Thanks for the quick response.

I tried you version. It works better, but my workload still gets stuck
occasionally (less frequently though). It is pretty obvious that the
version you sent still has a race, so I didn=E2=80=99t put the effort =
into
debugging it.

I should note that I have an ugly hack that does make my test pass. I
include it, although it is obviously not the right solution.



diff --git a/fs/io-wq.c b/fs/io-wq.c
index b3e8624a37d0..a8792809e416 100644
--- a/fs/io-wq.c
+++ b/fs/io-wq.c
@@ -165,6 +165,17 @@ static void io_worker_ref_put(struct io_wq *wq)
                complete(&wq->worker_done);
 }
=20
+static void io_queue_worker_create(struct io_wqe *wqe, struct =
io_wqe_acct *acct);
+
+static inline bool io_wqe_run_queue(struct io_wqe *wqe)
+       __must_hold(wqe->lock)
+{
+       if (!wq_list_empty(&wqe->work_list) &&
+           !(wqe->flags & IO_WQE_FLAG_STALLED))
+               return true;
+       return false;
+}
+
 static void io_worker_exit(struct io_worker *worker)
 {
        struct io_wqe *wqe =3D worker->wqe;
@@ -192,17 +203,17 @@ static void io_worker_exit(struct io_worker =
*worker)
        raw_spin_unlock_irq(&wqe->lock);
=20
        kfree_rcu(worker, rcu);
+       raw_spin_lock_irq(&wqe->lock);
+
+       if (!(flags & IO_WORKER_F_BOUND) && io_wqe_run_queue(wqe)) {
+               atomic_inc(&acct->nr_running);
+               atomic_inc(&wqe->wq->worker_refs);
+               io_queue_worker_create(wqe, acct);
+       }
        io_worker_ref_put(wqe->wq);
-       do_exit(0);
-}
=20
-static inline bool io_wqe_run_queue(struct io_wqe *wqe)
-       __must_hold(wqe->lock)
-{
-       if (!wq_list_empty(&wqe->work_list) &&
-           !(wqe->flags & IO_WQE_FLAG_STALLED))
-               return true;
-       return false;
+       raw_spin_unlock_irq(&wqe->lock);
+       do_exit(0);
 }
=20
 /*

