Return-Path: <io-uring+bounces-2474-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 5F1F992BCE3
	for <lists+io-uring@lfdr.de>; Tue,  9 Jul 2024 16:27:38 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id AB56DB25C31
	for <lists+io-uring@lfdr.de>; Tue,  9 Jul 2024 14:27:35 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D283219CCF1;
	Tue,  9 Jul 2024 14:27:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="bviWYE9l"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ej1-f43.google.com (mail-ej1-f43.google.com [209.85.218.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3473A15749F;
	Tue,  9 Jul 2024 14:27:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720535240; cv=none; b=KfhwWn/+tH8+1XQS9PKYQCtLpKe3iWTk7bpQHf77hCYjN73J4hj4zoCFlS6Kk9FQ6OMjRfgjFr5at2m92LpiOTPKJh36+buO8d8pv2TM0o/WQUW/lVLnpNjkRhLKhPdE7gFut6EGi+DmE91m8iPDLwq0sL3JjDhqyr6IsupGklA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720535240; c=relaxed/simple;
	bh=a5wfalHAVGimjhym+BEhPFIfP/IfIqtQ3vq9UUG4wYE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Pwsycs0EZFPYGRsXazSRg7wa+T3ZS3ogRNQrycTPROAGchkKHjC2V6rpczLNPxeVuwE+3Gr+pNrCWZnKIXvUwLsRRIxJEAOtkdGNUd4z2d+WEKX9kPUbYkTBLbBerM8blVLgbW5H61R4j4PLxbAJNrziTMd5eqXStRm8jZ4sPVk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=bviWYE9l; arc=none smtp.client-ip=209.85.218.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-ej1-f43.google.com with SMTP id a640c23a62f3a-a77e6dd7f72so349236166b.3;
        Tue, 09 Jul 2024 07:27:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1720535237; x=1721140037; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=viZ30E1hmv8p2AGmlt9wLyrt+Ui8LZLR4LApZyGXPD0=;
        b=bviWYE9lwny0UillwQeXbDbFq2ioso+cludnrdSJm5vfnPWkjWgofcVwkdWDudzm0G
         h7hyiLIbYSljAD24aLGSVNJHqHpGZMjawW8JBX60GuaQbmwL89ZlRFOlmlPgTy+MArp4
         HS0yWwYmfjCSxU/0EVouLFz1BhJAponqo4qZY6nTY4n23UKDG8DzYo7eqSEKMDJq1tRt
         oGATreh3PDxcr0fKF4l7a382+ytLtd9IBxy3ipRdUsPDlHtHPhxjCUXRPFD/pzxBooQ5
         D+pHvoizm0s0lS63cgNhti+//sLVkoWNb714YFNOWs8/+ixJ/cEMCTD7zIYvVXs4IRZ/
         WZFA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1720535237; x=1721140037;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=viZ30E1hmv8p2AGmlt9wLyrt+Ui8LZLR4LApZyGXPD0=;
        b=II+YKaNYjLIWtP5KW7ocDKKY4DM5UYvgTff/R+z4NpJVB3H1Ov2lyN/RBYMeJI8fY5
         T/17AMEE/or/EHwe8siahlvHqKM5BplZmyPcwDq1lVXiQHdTHxjSGD8FcjATBB4IxOuB
         KOXTXDWCeyDDnVk+XLKALBR7g+4R8Ai9jJkc2+naYR6Z0Sfc1MeLrB9I/cn/ga+prH0M
         Xd1wprRV9aJKyLK/DOrSsbIB/woeWa+FIPhm5/0BrnBF77mx2vQt9Cu0PCOi67c3GnXl
         BXMlXbT0BIIzBvahJUevJwdAO2i4f0Akj71iS4Jei4Y9IXUNbrC88+a3Hu2CZsSaUXL9
         mrUQ==
X-Forwarded-Encrypted: i=1; AJvYcCUrb+WrUWLyLRq8H/7gwHVIL4I1pliEN+uf7eMOCriCYxohgAMg9kiwtPLUBIj7gNKTKti8X1YElrJA6ZQBKKaazxWzdwSwwKjdjE8A
X-Gm-Message-State: AOJu0YxeLXPfypdhDq78GT6uJ0tg5QpYEEgsHRGGAav1XJAcDl9haAVk
	BTAxsioAWSHX4Fv+Sd7+ZrzAkq/Bc/AqgDa/PPmd57zlnP/b+JY+mO0rqA==
X-Google-Smtp-Source: AGHT+IGV2zjagwFScIaii8oEBTXuSEkflfr03lA7nPMekPBzQqC61H7lwsUbothjZVZc8YCRRCr4ng==
X-Received: by 2002:a17:906:3416:b0:a72:88e2:c327 with SMTP id a640c23a62f3a-a780b6fef62mr170714266b.38.1720535237035;
        Tue, 09 Jul 2024 07:27:17 -0700 (PDT)
Received: from 127.0.0.1localhost ([163.114.131.193])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-a780a7ff21esm80649966b.135.2024.07.09.07.27.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 09 Jul 2024 07:27:16 -0700 (PDT)
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
Subject: [PATCH v2 2/2] kernel: rerun task_work while freezing in get_signal()
Date: Tue,  9 Jul 2024 15:27:19 +0100
Message-ID: <149ff5a762997c723880751e8a4019907a0b6457.1720534425.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <cover.1720534425.git.asml.silence@gmail.com>
References: <cover.1720534425.git.asml.silence@gmail.com>
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

Cc: stable@vger.kernel.org
Link: https://github.com/systemd/systemd/issues/33626
Fixes: 12db8b690010c ("entry: Add support for TIF_NOTIFY_SIGNAL")
Reported-by: Julian Orth <ju.orth@gmail.com>
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


