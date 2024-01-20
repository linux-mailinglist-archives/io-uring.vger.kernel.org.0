Return-Path: <io-uring+bounces-440-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id B12808335AA
	for <lists+io-uring@lfdr.de>; Sat, 20 Jan 2024 19:19:49 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 66D801F22256
	for <lists+io-uring@lfdr.de>; Sat, 20 Jan 2024 18:19:49 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 97BD112E7C;
	Sat, 20 Jan 2024 18:19:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="m358RrbW"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pf1-f178.google.com (mail-pf1-f178.google.com [209.85.210.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3CDB312E6A;
	Sat, 20 Jan 2024 18:19:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.178
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705774774; cv=none; b=CErEvBlM8a9Cg/dc7V5547fVe0vwp0uNO+G6JuO5wWDa+J2oQPmD0+NmnRqalq3X/E+LP/l1QeRnv3xzbAgyYPSsvWZmfl++6KgE2zLz2b7Hi0kZl57mnbRRpZadjTKhYXdIMcJNuk37r7XaPFv2F2nqJt2RDFFRHYo5eaTlKzs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705774774; c=relaxed/simple;
	bh=U3XAi1Ve5Pl2g7OLbKI9EKf33X80ddsBcG06qkgZVZk=;
	h=From:To:Subject:Date:Message-Id:MIME-Version; b=CxqZtrJAQm4hEdt8Oz6+efwajwOqsCRI0svQ0UpbIGxsbqhrsF75dpNy7+fxi+BON0ysqpGkWRmjDzUQ0ItwP4EUXAYcVi7pSoa34Q3x+igNdbGVQCMmMd4qkrCxUfw9NO7e4lxgKWIshaUsKL7JPUtycvvQf1KT2+c6HF7mybc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=m358RrbW; arc=none smtp.client-ip=209.85.210.178
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pf1-f178.google.com with SMTP id d2e1a72fcca58-6d9cdd0a5e6so1174018b3a.3;
        Sat, 20 Jan 2024 10:19:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1705774772; x=1706379572; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:to
         :from:from:to:cc:subject:date:message-id:reply-to;
        bh=whe5Iq2BHDs/3IsPCikOFkd0eNlnX9L6osSee0Rh/bs=;
        b=m358RrbWM36tT4/WPuUcplNvza2W74GwTBVGZ/nLbaXEWrVNHI4cHj/F1tfLwnTZBn
         uXaxnNjqS6sLOG8fhZGylZ9RQoO3oWGCCKWGCPdOel7ydJ1ST7U7lz7Ob6ScCOIO8ggt
         ISjiUwRgkhgu7eThAC1sPs1olMqk6DCLl0KixwgpM+cdcq+M5GuCNy+AbtZzRDe9smn3
         Yqg+RsPmfyuvKTVm3UZfcDhJbKGY2egEekr2dlQ8zf37d3h5xeX73gZfzBzFUWKjB6LX
         bSmK1RswG+by/sVSs0Ni9a6LszvV+f6/gYc/2kGDqw3O0FPkgDOyFfgG2kLKm1sHdxA5
         BJWg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1705774772; x=1706379572;
        h=content-transfer-encoding:mime-version:message-id:date:subject:to
         :from:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=whe5Iq2BHDs/3IsPCikOFkd0eNlnX9L6osSee0Rh/bs=;
        b=wkkZSFCeRJ0h5T0hq/t+6JF/FUe+G8rxXYjs0WKzodKp4DyK0UpHoShME2ojvrFkHI
         b1Fc2cvIuldxxrZoyjxyfmcHOUMVFOsDEKdscwrQMlq1Fb8YOlpj68QqtxkR3chtjyxu
         S7UYQJwyK4QNrgxU95v5RIoIY9c+yDZ04+CUxtaaUfMKCaK7v+lhvEhrsxe+MkmW9M94
         BeZeIqp55DOxEXsMMYzrFRwQ6PVN3PEajU0rsKTR0PNVgyP+4KVTjINF15SGeDAU6XVs
         MDEeY/UnS41MHnCawuKukkdmEZIeqeO+sCMLWARmhuKOMp9XC6iDHppZqDTJqBQKtksT
         hLBQ==
X-Gm-Message-State: AOJu0YzBT7Ww1wFZZV9JLZAkJF8j37mltbbJuUjp8yzlijMAZMaqI2I1
	uu2Rfk98sMNl/D+/MutF5Mkx7cVkwnPA1aauX1SWqrtqHDpeAjQu
X-Google-Smtp-Source: AGHT+IGvLbYDu6RYfC9WnOgM0oratNd5JHV8jcjYGL2ljS++jr9nEJ8CBACsM9EodmnnOwarIjLCYw==
X-Received: by 2002:a05:6a20:12d5:b0:19a:6166:cb09 with SMTP id v21-20020a056a2012d500b0019a6166cb09mr821672pzg.15.1705774772499;
        Sat, 20 Jan 2024 10:19:32 -0800 (PST)
Received: from user.. ([106.51.184.63])
        by smtp.gmail.com with ESMTPSA id q13-20020a170902c74d00b001d71df4bbf4sm3076504plq.125.2024.01.20.10.19.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 20 Jan 2024 10:19:32 -0800 (PST)
From: Subramanya Swamy <subramanya.swamy.linux@gmail.com>
To: corbet@lwn.net,
	jmoyer@redhat.com,
	axboe@kernel.dk,
	asml.silence@gmail.com,
	akpm@linux-foundation.org,
	bhe@redhat.com,
	ribalda@chromium.org,
	rostedt@goodmis.org,
	subramanya.swamy.linux@gmail.com,
	sshegde@linux.vnet.ibm.com,
	alexghiti@rivosinc.com,
	matteorizzo@google.com,
	ardb@kernel.org,
	linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	io-uring@vger.kernel.org
Subject: [PATCH v3] iouring:added boundary value check for io_uring_group systl
Date: Sat, 20 Jan 2024 18:19:25 +0000
Message-Id: <20240120181925.1959-1-subramanya.swamy.linux@gmail.com>
X-Mailer: git-send-email 2.34.1
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit

/proc/sys/kernel/io_uring_group takes gid as input
added boundary value check to accept gid in range of
0<=gid<=4294967294 & Documentation is updated for same

Fixes: 76d3ccecfa18 ("io_uring: add a sysctl to disable io_uring system-wide")

Signed-off-by: Subramanya Swamy <subramanya.swamy.linux@gmail.com>
---
 Documentation/admin-guide/sysctl/kernel.rst | 4 +---
 io_uring/io_uring.c                         | 8 ++++++--
 2 files changed, 7 insertions(+), 5 deletions(-)

diff --git a/Documentation/admin-guide/sysctl/kernel.rst b/Documentation/admin-guide/sysctl/kernel.rst
index 6584a1f9bfe3..262d92f51fa5 100644
--- a/Documentation/admin-guide/sysctl/kernel.rst
+++ b/Documentation/admin-guide/sysctl/kernel.rst
@@ -471,9 +471,7 @@ io_uring_group
 
 When io_uring_disabled is set to 1, a process must either be
 privileged (CAP_SYS_ADMIN) or be in the io_uring_group group in order
-to create an io_uring instance.  If io_uring_group is set to -1 (the
-default), only processes with the CAP_SYS_ADMIN capability may create
-io_uring instances.
+to create an io_uring instance.
 
 
 kexec_load_disabled
diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
index cd9a137ad6ce..bd6cc0391efa 100644
--- a/io_uring/io_uring.c
+++ b/io_uring/io_uring.c
@@ -154,9 +154,11 @@ static void io_queue_sqe(struct io_kiocb *req);
 struct kmem_cache *req_cachep;
 
 static int __read_mostly sysctl_io_uring_disabled;
-static int __read_mostly sysctl_io_uring_group = -1;
+static unsigned int __read_mostly sysctl_io_uring_group;
 
 #ifdef CONFIG_SYSCTL
+static unsigned int max_gid  = ((gid_t) ~0U) - 1; /*4294967294 is the max guid*/
+
 static struct ctl_table kernel_io_uring_disabled_table[] = {
 	{
 		.procname	= "io_uring_disabled",
@@ -172,7 +174,9 @@ static struct ctl_table kernel_io_uring_disabled_table[] = {
 		.data		= &sysctl_io_uring_group,
 		.maxlen		= sizeof(gid_t),
 		.mode		= 0644,
-		.proc_handler	= proc_dointvec,
+		.proc_handler	= proc_douintvec_minmax,
+		.extra1         = SYSCTL_ZERO,
+		.extra2         = &max_gid,
 	},
 	{},
 };
-- 
2.34.1


