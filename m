Return-Path: <io-uring+bounces-157-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 9FD797FACD5
	for <lists+io-uring@lfdr.de>; Mon, 27 Nov 2023 22:54:33 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id B96E61C20ECD
	for <lists+io-uring@lfdr.de>; Mon, 27 Nov 2023 21:54:32 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C55413EA76;
	Mon, 27 Nov 2023 21:54:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="uey2PQoq"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ed1-x52f.google.com (mail-ed1-x52f.google.com [IPv6:2a00:1450:4864:20::52f])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E4DFD1A1
	for <io-uring@vger.kernel.org>; Mon, 27 Nov 2023 13:54:27 -0800 (PST)
Received: by mail-ed1-x52f.google.com with SMTP id 4fb4d7f45d1cf-548ae9a5eeaso619a12.1
        for <io-uring@vger.kernel.org>; Mon, 27 Nov 2023 13:54:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1701122066; x=1701726866; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:mime-version:from:to:cc:subject
         :date:message-id:reply-to;
        bh=i5GFJDUW3MHlNrfhyC5VB4ESUR3+JVE/rcjBTTcA06g=;
        b=uey2PQoqD4VqWR8DtFOJQMKnRAkh4NFPlOJ3yMXBQmMtS9eqfTKTaY8QyL1tfVAnUu
         mPBZSZvZ8boQx9NASvxQKy2fsIBX2jUiEFiURbV40NQsVowO65V7qhBeWjhQ/OQ29S/Q
         J0qjgPfBPiMsgYY8RNMykYngpX/Ls5cA5pGvFTC6if3jIfNHxCFvOV/Aw7P8g5EpVwV+
         R+CV+PviWjPc4H76jaYqvMR+FIjZTotb5MkD+k5ADWS68ZaTwchqv8se44BS64VP9Q94
         DM4sP5BOyocPYpyBiJEdTArDxmdjV17fpkalTPSLeJmFqtSBz2L2VZ5Tt1QxjnH5aCZ5
         UbCA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1701122066; x=1701726866;
        h=cc:to:subject:message-id:date:from:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=i5GFJDUW3MHlNrfhyC5VB4ESUR3+JVE/rcjBTTcA06g=;
        b=U6sdzjBucC1qD/ixHMyxAkt9xbl9MELFcjrEUcoEWyo0TJwuvpVqVmG71a5PhxaZ4Z
         bqnTHt82V5XIkgZcqmSTYiy5wAdr7Zghp1xyY0Snj3mDKXP27a6ZOoKxAbEXYLfCXkos
         4BgU9o1oRL1WiS2lbuYydPyeGhJ8F1fsFvVHvDfXsq1SLUrp22E1XFV/vkIKwYsGnM5S
         EuESG2FnaOy45un9S2v377J9TMEBGWayR5f7m2q5bv61EGEeLBT62z5hNLWKvF8+EnmN
         oFYXcpRMysuTHfGIDKZhkdtU7J49HzebYtGinAi2/rJyq6hQWWPNvRXWQ8Y/xmOstsJs
         w3aQ==
X-Gm-Message-State: AOJu0YyEeykGRxJbVQTjayIHQ8SiBbMgoi6dk3pqmQGAm2tGzBlewJbl
	OCsH5hBbuMcRnDjgB26Pk+xPOjAFUB4ZO3mbWlolsA==
X-Google-Smtp-Source: AGHT+IG7xZ4KRyQfbbBd9eQ/dnxxRH3eLZSxxvhqaJC/Su/40gRFks8qp3gsssLJI7cZhsC77GdZ4vin2Uj+daxlTvI=
X-Received: by 2002:a05:6402:3510:b0:54b:2abd:ad70 with SMTP id
 b16-20020a056402351000b0054b2abdad70mr280820edd.7.1701122066260; Mon, 27 Nov
 2023 13:54:26 -0800 (PST)
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
From: Jann Horn <jannh@google.com>
Date: Mon, 27 Nov 2023 22:53:48 +0100
Message-ID: <CAG48ez1htVSO3TqmrF8QcX2WFuYTRM-VZ_N10i-VZgbtg=NNqw@mail.gmail.com>
Subject: io_uring: risky use of task work, especially wrt fdget()
To: Jens Axboe <axboe@kernel.dk>, Pavel Begunkov <asml.silence@gmail.com>
Cc: io-uring <io-uring@vger.kernel.org>, kernel list <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"

Hi!

I noticed something that I think does not currently cause any
significant security issues, but could be problematic in the future:

io_uring sometimes processes task work in the middle of syscalls,
including between fdget() and fdput(). My understanding of task work
is that it is expected to run in a context similar to directly at
syscall entry/exit: task context, no locks held, sleeping is okay, and
it doesn't execute in the middle of some syscall that expects private
state of the task_struct to stay the same.

An example of another user of task work is the keyring subsystem,
which does task_work_add() in keyctl_session_to_parent() to change the
cred pointers of another task.

Several places in io_uring process task work while holding an fdget()
reference to some file descriptor. For example, the io_uring_enter
syscall handler calls io_iopoll_check() while the io_ring_ctx is only
referenced via fdget(). This means that if there were another kernel
subsystem that uses task work to close file descriptors, io_uring
would become unsafe. And io_uring does _almost_ that itself, I think:
io_queue_worker_create() can be run on a workqueue, and uses task work
to launch a worker thread from the context of a userspace thread; and
this worker thread can then accept commands to close file descriptors.
Except it doesn't accept commands to close io_uring file descriptors.

A closer miss might be io_sync_cancel(), which holds a reference to
some normal file with fdget()/fdput() while calling into
io_run_task_work_sig(). However, from what I can tell, the only things
that are actually done with this file pointer are pointer comparisons,
so this also shouldn't have significant security impact.

Would it make sense to use fget()/fput() instead of fdget()/fdput() in
io_sync_cancel(), io_uring_enter and io_uring_register? These
functions probably usually run in multithreaded environments anyway
(thanks to the io_uring worker threads), so I would think fdget()
shouldn't bring significant performance savings here?

