Return-Path: <io-uring+bounces-5816-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 8A077A09E16
	for <lists+io-uring@lfdr.de>; Fri, 10 Jan 2025 23:36:06 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id D42C318902F4
	for <lists+io-uring@lfdr.de>; Fri, 10 Jan 2025 22:35:01 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8BB06220699;
	Fri, 10 Jan 2025 22:27:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="PECpis9E"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ed1-f50.google.com (mail-ed1-f50.google.com [209.85.208.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A980221D5AC
	for <io-uring@vger.kernel.org>; Fri, 10 Jan 2025 22:27:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736548043; cv=none; b=notHEmUZulMaUIMGmqrgw8RSi/L51U9MaNgqtWQaY6tv6eOD0mHCV23Twxp3RvyMfsx3D92XF4dP6T8+hRClcsACUndfBJza5eB+AapM5LFKegdqczlrUFOxToS/NGBszNxrjygiDBKDb6qpSdRML6wrTTUr+VuFMfKMd4/Ecr8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736548043; c=relaxed/simple;
	bh=Bq6hsMNUr3U7XrwocJLYwu+QzZjpQkkNYVQEKRzO1g8=;
	h=MIME-Version:From:Date:Message-ID:Subject:To:Content-Type; b=rtNSU0jd2XJGGIU2du2XrsyFArwka1/sBFBcasIlI9am7Wl4WfxAUDwDBxsETwIBcmThR5d2vZcLK3exQku6FjK+/cks7fhXt4oGSvf2PkherhnK24f8sEKurB9Oxdk/vR4kSAV5m73znoPfl4BJi3Eoj9DvrSeyz8tCsTQPqvM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=PECpis9E; arc=none smtp.client-ip=209.85.208.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-ed1-f50.google.com with SMTP id 4fb4d7f45d1cf-5d3cfdc7e4fso2699a12.0
        for <io-uring@vger.kernel.org>; Fri, 10 Jan 2025 14:27:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1736548040; x=1737152840; darn=vger.kernel.org;
        h=to:subject:message-id:date:from:mime-version:from:to:cc:subject
         :date:message-id:reply-to;
        bh=Bq6hsMNUr3U7XrwocJLYwu+QzZjpQkkNYVQEKRzO1g8=;
        b=PECpis9Ez880/c6C6A+17wENFw+vVFKTCr0Bz5AUSInS03OxVtznFXYPxUqhiv4sU8
         Asv6lWnqRMuIsuIYAx+LGkWb+ZY8orqsO8ElAPIgYjcXHEhrAK0BuqycgDgmLh3AjAWI
         44EWQbk1qnXQae1QTzcnaUJYTBIf4ZidKJOChJi7JKCAiUfk4GoWukNt8Yfta2/zzj5o
         NXMs+Bw2QZEjJZ+ozsM9axAzIzF1xpsECyfYuINRiFTF9XHOuKdovCj+DC08vvkl8Wbo
         RkMbZ7cCkrhVu+JUYa0T4QXHL+4hvweoWlCYQum0pEoELhFprkFpPxXp+FfwvzJAILLs
         z2WQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1736548040; x=1737152840;
        h=to:subject:message-id:date:from:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=Bq6hsMNUr3U7XrwocJLYwu+QzZjpQkkNYVQEKRzO1g8=;
        b=gB1z8nr+zeADax0KIqBpZwaY45pihaHatQfiRD04JgIh0femuTPM38HAhB27QDRxVb
         uPwM18pmBtphpD8O48ehuwSz6ooCd5vgDfQXAmVnlLHkcrCOhnN+/1WhSPBiOfTvFz8L
         lqGo5RoTDLaDKKBDvyFdo/FTvIigtsnenQ33yGuog4U4KiSKrzpHNta78vghhelNGyUF
         13Qm6Rget5zNW+/te0ToKE/rqtcRSIBOCcPwkVYpFViO+rhZOvncmrKx0u+Fa3ld+fkH
         bB2wlcqZVpxoOQwpmzoHCfCg2O5xAJap1UQbgMBckScz2Fl6oTMsrVY6CIy2Ug/FOURV
         oiWA==
X-Forwarded-Encrypted: i=1; AJvYcCVzJaJS8qX76/Is7/6zXmzdl+Aj+YMheHqqJ+MkyQpLSgTNzLv4+9kFfN1CHEB55qMXIMk8lcOLag==@vger.kernel.org
X-Gm-Message-State: AOJu0YzR7599xszxb6BR6H1coGXA+bxNJyB4JDqkt7gCCFr1zbXKL5R5
	GRu5HfEEpwfqz8nO88UDwzcoxFD2pg648K7FIhlgFY6ZeKk+qyjVNoFrfYFvvDH6AEv2xr52kTz
	Tc219epjg1I+2HzECb6OHtEUK0WazEvHurwiu
X-Gm-Gg: ASbGnctRLkStH7jaJcjnFi733z6pMoUoResyDfdsHvB467gT0UTo3BZ+KyKUpY1yhkC
	h7D4f5Esb6upm3g2ISj7sHVjs4wS/0h61V4gJjHI=
X-Google-Smtp-Source: AGHT+IHPMxB8DKe+/Un8LXlBUrhGayfxgRxULr+xopUGnFJDg8CKu2EoWBwl+unENnY4WQPvQ68RUVl8wOy8xMYSooM=
X-Received: by 2002:a05:6402:519:b0:5d4:428e:e99f with SMTP id
 4fb4d7f45d1cf-5d9a0cc9cdamr126802a12.3.1736548039636; Fri, 10 Jan 2025
 14:27:19 -0800 (PST)
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
From: Jann Horn <jannh@google.com>
Date: Fri, 10 Jan 2025 23:26:42 +0100
X-Gm-Features: AbW1kvY0h5OlDT5HyuV3K1P1GT1mGqD_bwqn8B3jtIYB_jkat6uclww4cg2SdMY
Message-ID: <CAG48ez2HHU+vSCcurs5TsFXiEfUhLSXbEzcugBSTBZgBWkzpuA@mail.gmail.com>
Subject: futex+io_uring: futex_q::task can maybe be dangling (but is not
 actually accessed, so it's fine)
To: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, 
	Peter Zijlstra <peterz@infradead.org>, Darren Hart <dvhart@infradead.org>, 
	Davidlohr Bueso <dave@stgolabs.net>, =?UTF-8?Q?Andr=C3=A9_Almeida?= <andrealmeid@igalia.com>, 
	kernel list <linux-kernel@vger.kernel.org>, Jens Axboe <axboe@kernel.dk>, 
	Pavel Begunkov <asml.silence@gmail.com>, io-uring <io-uring@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"

Hi!

I think there is some brittle interaction between futex and io_uring;
but to be clear, I don't think that there is actually a bug here.

In io_uring, when a IORING_OP_FUTEX_WAIT SQE is submitted with
IOSQE_ASYNC, an io_uring worker thread can queue up futex waiters via
the following path:

ret_from_fork -> io_wq_worker -> io_worker_handle_work ->
io_wq_submit_work[called as ->do_work] -> io_issue_sqe ->
io_futex_wait[called as .issue] -> futex_queue -> __futex_queue

futex_q instances normally describe synchronously waiting tasks, and
__futex_queue() records the identity of the calling task (which is
normally the waiter) in futex_q::task. But io_uring waits on futexes
asynchronously instead; from io_uring's perspective, a pending futex
wait is not tied to the task that called into futex_queue(), it is
just tied to the userspace task on behalf of which the io_uring worker
is acting (I think). So when a futex wait operation is started by an
io_uring worker task, I think that worker task could go away while the
futex_q is still queued up on the futex, and so I think we can end up
with a futex_q whose "task" member points to a freed task_struct.

The good part is that (from what I understand) that "task" member is
only used for two purposes:

1. futexes that are either created through the normal futex syscalls
use futex_wake_mark as their .wake callback, which needs the task
pointer to know which task should be woken.
2. PI futexes use it for priority inheritance magic (and AFAICS there
is no way for io_uring to interface with PI futexes)

I'm not sure what is the best thing to do is here - maybe the current
situation is fine, and I should just send a patch that adds a comment
describing this to the definition of the "task" member? Or maybe it
would be better for robustness to ensure that the "task" member is
NULLed out in those cases, though that would probably make the
generated machine code a little bit more ugly? (Or maybe I totally
misunderstand what's going on and there isn't actually a dangling
pointer...)

