Return-Path: <io-uring+bounces-7173-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id E2C03A6C35A
	for <lists+io-uring@lfdr.de>; Fri, 21 Mar 2025 20:31:48 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 625163A8F66
	for <lists+io-uring@lfdr.de>; Fri, 21 Mar 2025 19:31:35 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6A26322DF95;
	Fri, 21 Mar 2025 19:31:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="U27JJS2W"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-io1-f41.google.com (mail-io1-f41.google.com [209.85.166.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 258E522C35D
	for <io-uring@vger.kernel.org>; Fri, 21 Mar 2025 19:31:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742585505; cv=none; b=UWSxTMsHiOdpGe1mq65X3VNDx+FGHyHsjzJGzwZd5JvEcMQP7V/SOMAJPgbG+GIFrSR26aSj+J+o7rd6twRnTHrpkXhpzIRzM0z/9oms45T+IwpH2uV/iT0fvpsin66sIsnyTtXHjMWZL1P5LNqdVVCmkSa+c4po2mWq3l3y27I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742585505; c=relaxed/simple;
	bh=tmu44H8PHF/Ekh/eMQW+LHxOQINbgxEcpXVMvOIj8SI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qX25ERdRKPqRNY0mpGAl04ocu67qvn3jtEdu7U87+89hEkSaLye479vXF1mUY+4lVM1Mm1ZedZCfJONotj1b4O0zv9G/Hb3avtvIDyDUDHbXERExcHfbmhizL5M1JkV/uyvy35gylatm04L0mEtdV1LwSi1XYkIUTKKIRzScTV0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=U27JJS2W; arc=none smtp.client-ip=209.85.166.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-io1-f41.google.com with SMTP id ca18e2360f4ac-85b4170f1f5so64571339f.3
        for <io-uring@vger.kernel.org>; Fri, 21 Mar 2025 12:31:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1742585500; x=1743190300; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=bZ6z0kB+ScBGWw7Jv+htutGbkm2LGsdDyHzOuI7s9j0=;
        b=U27JJS2W20uEb9gj1lm2ksItiVXuKaPV/snpjWrM5NpEn2iZ0+dvUb5Xi+mziEqYqf
         aZSnEj/aCM6rxZQBlb6VOE9N3ZF/KEHvq0oiNSgq4HoroHX8KRxjHrYhnoFZdzPBI7a1
         rfy5vK5eEpSzHqldgSBTtYf5cJv8+8z6TDfIPbPFsiXO9UkBOij9550S0FE41ceuxn+6
         rJnLmklfUOlRuJznzmJzOTMj9oNNxeP3O+tGxoYwdNceM87CeleYr2oQSK0pD4ss3ga9
         h7OeANT+DpoKCNoMpSXcPEOR2RNnAHXK2Afo3uKUem/4ZhZu3cjtcELLhhogPHaVeL/2
         O5Qg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1742585500; x=1743190300;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=bZ6z0kB+ScBGWw7Jv+htutGbkm2LGsdDyHzOuI7s9j0=;
        b=ce8s1/ptbktbVGEoP+9l5GbzUqvpPWJnxhiualYmb9cMpXJas3zufVVUGsu9E2GuvD
         iDanwJq1pPlDX55cPDPrcyxteuX7LmL5TuFOgewdyTJKjoHpDER2FqGCdH9+i0GTdm+a
         lTlF6gPg5QuD4E1RhECKQStEubOQRIrZvrVtE6s0GavB0QmJZFhK6X28rfLy1FI3VzmV
         26useDwQHZwwi+8oIlWi8WNm7aEZKEcMLjE4Y/eLvoF5cPoyjKLbvjK3rVXCw4EK+IVC
         Im/9CeszquHRnxTdG/oRsgZvNI44Od4vSgkYS63wQcgwKWWoLx5k2uUJPsUk4Duz/y5l
         yTow==
X-Gm-Message-State: AOJu0YyE+qZ0ANnEn6kCFKuge677tg8sy/VvGQ1pslfDYALclClSNhz/
	ksqPcRbZQTaEMEw5YefZLh8Tk90eZJHSVh2wCQp8dMOeqJOFZVzdJorue/2CUdXNI9IS2dNvHC1
	I
X-Gm-Gg: ASbGncsDZoXDNqFvDx6Sjjflc3IKLbpSRNSUjCEGVN4PjnSymdk3XugE9/+tjUfR3s8
	ptiwFH2KO5n7DLrTsDmHZstaN6bmtQx1XsZaxrCUAht9x3E6YiRfZeFXdenHqnnas/tYcPr9Rt6
	m5FFdOgM/9FfoZ5Ag4IQbToy0ps7klpv2zZ0/xbU+Kj3SWMLo/v1OlsNX28e9KTDBr67DwLQ9iV
	glns2sYm8CQ31X6474cmXi4ETjp2e9yJKJE1i2dpI4ceH/+f5dOVhbcL8v8LQtme62wwXFneYVy
	OU+ql72Dy50p9QzKSP4/Jh480jb0Pj/2pR2+7wxKZhg/dbU+tA==
X-Google-Smtp-Source: AGHT+IH8zFuinsrUjDC6QESRtve95GCm71awmku+n53Oz5A6Zkkm6aPHDG+1m96v56KKBok9sBl3Vg==
X-Received: by 2002:a05:6602:b8b:b0:85b:3763:9551 with SMTP id ca18e2360f4ac-85e2ca756a0mr561008539f.7.1742585500522;
        Fri, 21 Mar 2025 12:31:40 -0700 (PDT)
Received: from localhost.localdomain ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id 8926c6da1cb9f-4f2cbdeac82sm571268173.71.2025.03.21.12.31.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 21 Mar 2025 12:31:40 -0700 (PDT)
From: Jens Axboe <axboe@kernel.dk>
To: io-uring@vger.kernel.org
Cc: asml.silence@gmail.com,
	Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 1/5] fs: gate final fput task_work on PF_NO_TASKWORK
Date: Fri, 21 Mar 2025 13:24:55 -0600
Message-ID: <20250321193134.738973-2-axboe@kernel.dk>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250321193134.738973-1-axboe@kernel.dk>
References: <20250321193134.738973-1-axboe@kernel.dk>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Rather than hardwire this to kernel threads, add a task flag that tells
us whether the task in question runs task_work or not. At fork time,
this flag is set for kernel threads. This is in preparation for allowing
kernel threads to signal that they will run deferred task_work.

No functional changes in this patch.

Signed-off-by: Jens Axboe <axboe@kernel.dk>
---
 fs/file_table.c       | 2 +-
 include/linux/sched.h | 2 +-
 kernel/fork.c         | 2 +-
 3 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/fs/file_table.c b/fs/file_table.c
index 5c00dc38558d..d824f1330d6e 100644
--- a/fs/file_table.c
+++ b/fs/file_table.c
@@ -520,7 +520,7 @@ void fput(struct file *file)
 			file_free(file);
 			return;
 		}
-		if (likely(!in_interrupt() && !(task->flags & PF_KTHREAD))) {
+		if (likely(!in_interrupt() && !(task->flags & PF_NO_TASKWORK))) {
 			init_task_work(&file->f_task_work, ____fput);
 			if (!task_work_add(task, &file->f_task_work, TWA_RESUME))
 				return;
diff --git a/include/linux/sched.h b/include/linux/sched.h
index 9c15365a30c0..301f5dda6a06 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -1709,7 +1709,7 @@ extern struct pid *cad_pid;
 						 * I am cleaning dirty pages from some other bdi. */
 #define PF_KTHREAD		0x00200000	/* I am a kernel thread */
 #define PF_RANDOMIZE		0x00400000	/* Randomize virtual address space */
-#define PF__HOLE__00800000	0x00800000
+#define PF_NO_TASKWORK		0x00800000	/* task doesn't run task_work */
 #define PF__HOLE__01000000	0x01000000
 #define PF__HOLE__02000000	0x02000000
 #define PF_NO_SETAFFINITY	0x04000000	/* Userland is not allowed to meddle with cpus_mask */
diff --git a/kernel/fork.c b/kernel/fork.c
index 735405a9c5f3..3745407624c7 100644
--- a/kernel/fork.c
+++ b/kernel/fork.c
@@ -2235,7 +2235,7 @@ __latent_entropy struct task_struct *copy_process(
 		goto fork_out;
 	p->flags &= ~PF_KTHREAD;
 	if (args->kthread)
-		p->flags |= PF_KTHREAD;
+		p->flags |= PF_KTHREAD | PF_NO_TASKWORK;
 	if (args->user_worker) {
 		/*
 		 * Mark us a user worker, and block any signal that isn't
-- 
2.49.0


