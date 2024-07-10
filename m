Return-Path: <io-uring+bounces-2491-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id D4AE492D7E0
	for <lists+io-uring@lfdr.de>; Wed, 10 Jul 2024 19:58:44 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id D45FA1C2134F
	for <lists+io-uring@lfdr.de>; Wed, 10 Jul 2024 17:58:43 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 92574196C7C;
	Wed, 10 Jul 2024 17:58:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="I4ZVwxrQ"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ed1-f50.google.com (mail-ed1-f50.google.com [209.85.208.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DDB9F195B3B;
	Wed, 10 Jul 2024 17:58:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720634306; cv=none; b=dBfPah87loxIcO2J4hCRVVJIq8LWAi2D+vPLAOI4/3jgXxucPoDYj7FqFq6je71qYtLGq8Qwy0jlHuxeTDCMmCW3na4e2IzFaRd1WhDgccWIrpR7oTqcvdVG/9MDdZU0158xFDPK6Z6OFQyyU/BgNqQgD7lqx7IFSyqsRm916Vw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720634306; c=relaxed/simple;
	bh=m7m/bVEi2H+hkAa64PgHmBJK8baUdNNCA8E/4JNoJ9k=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qxCd+Eeg3ETjwYEnGYwepxwOoiVhnGAz0nx1/IOAXkcot1RATZ9KkTEImXREMYc/elRcl7xm0nZKngJGd6uo0r8w/t6PuOT2nrl4tVzLN8COMXCwbhVmgDHin1vXTDVAjfIumHFD0XQ/6Y2cMrM4AuGgS+/426kGC7QSA71boA0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=I4ZVwxrQ; arc=none smtp.client-ip=209.85.208.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-ed1-f50.google.com with SMTP id 4fb4d7f45d1cf-595856e2332so16711a12.1;
        Wed, 10 Jul 2024 10:58:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1720634303; x=1721239103; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=DACbqRpGi9j2THmusiEJ+KTHhPMZmG8ZX1NHB/+0xms=;
        b=I4ZVwxrQDuPJY44UJTycDPPCJX8sSVFNMfPLhbYFU8vRXUL2BFzzJVazdA0A0L8jRZ
         jkViiWdR0vZxfs6skoJA/gUkR+/SvuWndqQqocFAbvQroN8BJHLETpBmyp/fN3MWRtmh
         8/wPUNW8+FRcj23lxu9Fe2yW3i4TRZXiJZAAqAp5bW6kpsozmr3R+kuEjbIT93kXyisG
         Xs7xwTvRH4gKs50z3ZgAddgAVu872zD73sR4Hsz+evTblGgeyLYP/DLV640RntWtJ5Wk
         sGkJsSuVOa1YhKbi3WyXE9KGW0XHHSxA5lzubZt+ShM9jP3gYWDocgbLC+KEBJmLQtu2
         mAxQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1720634303; x=1721239103;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=DACbqRpGi9j2THmusiEJ+KTHhPMZmG8ZX1NHB/+0xms=;
        b=nuGzUM0F3ND+6FsJsSjgIQ9N2V+Rj7AT6Mb4UpeTH29FpTlz6BynSb0C3AxKXSw7LL
         UxZt0F+eqqUss0i2yOCc5QqmiIQSRNjtrpSqDlzkdPwCT2EyfVU+L51QqMCeTs1Hq+8W
         poWcrSC1d/zgxoq0tOBiA6ovu3A5lxqoCnuRNuzEyCHo5d+JlMGQUxKk7tx5+q1mxvdZ
         QTHB04HrOtzGIQ/bfgDP876ZUojoIbhftjCv95EGAX5KXpA8+N76cauESNFjzRwuTuLa
         9DvBPKxNcR/qUjcXrFDro2eUcG9YjGfeE8dO4L2D1oX5wOgj5NCUl/3R2WaPG2FKkOhe
         rAjA==
X-Forwarded-Encrypted: i=1; AJvYcCVFa8zR550lnyB/9yUcKF5jJ9RUuymOzIqNbzAWiNuBsQK/1dlKHKhDPCuA5lx6u4WZ66aUQ6q6FamDnVZzpuP8/eOJyoiUKpV6pSpe
X-Gm-Message-State: AOJu0YyJg05gBYVjy0dQxKgUoUqGRZE76EyfwB0O/yhsW+6Vf5Lao3Ee
	JFkgCisgW4LrwKyOFzj5kRYusE1ah6lc91GIzWFX6f1x14Anua4qTmXtKA==
X-Google-Smtp-Source: AGHT+IFsxL2uyUHxli2G9EjszMsBJ2HdxR/VIspu0wmO4SKVOgiFFNFDAAxRJH6kcB8vapUt5CD+Vg==
X-Received: by 2002:a05:6402:1ed6:b0:584:a6f8:c0c5 with SMTP id 4fb4d7f45d1cf-594b7d81a1emr5467989a12.0.1720634302527;
        Wed, 10 Jul 2024 10:58:22 -0700 (PDT)
Received: from 127.0.0.1localhost ([163.114.131.193])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-594bbe2ce4bsm2459679a12.25.2024.07.10.10.58.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 10 Jul 2024 10:58:22 -0700 (PDT)
From: Pavel Begunkov <asml.silence@gmail.com>
To: io-uring@vger.kernel.org
Cc: Jens Axboe <axboe@kernel.dk>,
	asml.silence@gmail.com,
	Oleg Nesterov <oleg@redhat.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Christian Brauner <brauner@kernel.org>,
	Tycho Andersen <tandersen@netflix.com>,
	Thomas Gleixner <tglx@linutronix.de>,
	linux-kernel@vger.kernel.org,
	Julian Orth <ju.orth@gmail.com>,
	Peter Zijlstra <peterz@infradead.org>,
	Tejun Heo <tj@kernel.org>
Subject: [PATCH v3 2/2] kernel: rerun task_work while freezing in get_signal()
Date: Wed, 10 Jul 2024 18:58:18 +0100
Message-ID: <89ed3a52933370deaaf61a0a620a6ac91f1e754d.1720634146.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <cover.1720634146.git.asml.silence@gmail.com>
References: <cover.1720634146.git.asml.silence@gmail.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

io_uring can asynchronously add a task_work while the task is getting
freezed. TIF_NOTIFY_SIGNAL will prevent the task from sleeping in
do_freezer_trap(), and since the get_signal()'s relock loop doesn't
retry task_work, the task will spin there not being able to sleep
until the freezing is cancelled / the task is killed / etc.

Run task_works in the freezer path. Keep the patch small and simple
so it can be easily back ported, but we might need to do some cleaning
after and look if there are other places with similar problems.

Cc: stable@vger.kernel.org
Link: https://github.com/systemd/systemd/issues/33626
Fixes: 12db8b690010c ("entry: Add support for TIF_NOTIFY_SIGNAL")
Reported-by: Julian Orth <ju.orth@gmail.com>
Acked-by: Oleg Nesterov <oleg@redhat.com>
Acked-by: Tejun Heo <tj@kernel.org>
Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 kernel/signal.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/kernel/signal.c b/kernel/signal.c
index 1f9dd41c04be..60c737e423a1 100644
--- a/kernel/signal.c
+++ b/kernel/signal.c
@@ -2600,6 +2600,14 @@ static void do_freezer_trap(void)
 	spin_unlock_irq(&current->sighand->siglock);
 	cgroup_enter_frozen();
 	schedule();
+
+	/*
+	 * We could've been woken by task_work, run it to clear
+	 * TIF_NOTIFY_SIGNAL. The caller will retry if necessary.
+	 */
+	clear_notify_signal();
+	if (unlikely(task_work_pending(current)))
+		task_work_run();
 }
 
 static int ptrace_signal(int signr, kernel_siginfo_t *info, enum pid_type type)
-- 
2.44.0


