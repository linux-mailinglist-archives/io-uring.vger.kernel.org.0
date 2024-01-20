Return-Path: <io-uring+bounces-437-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id E2B93833513
	for <lists+io-uring@lfdr.de>; Sat, 20 Jan 2024 15:44:29 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 6762DB20DE3
	for <lists+io-uring@lfdr.de>; Sat, 20 Jan 2024 14:44:27 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 09BB1FC02;
	Sat, 20 Jan 2024 14:44:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="lG26gPJK"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-oa1-f49.google.com (mail-oa1-f49.google.com [209.85.160.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8FB33FBEB;
	Sat, 20 Jan 2024 14:44:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705761861; cv=none; b=JQGKRiVNGpjI7ZmLACfJy+1BzsWqDMqA2UWC4b8VfLyUdwpJ3zSjH7PIren1ZGlIwe99shCRrwV9lw5mH3w9hB8gART6xJalgOezTwJP0frIhQo0lh4omaLSrRAQLWbHWSxOf4oo8mOTbWD7E7FNh0D6BYOHSOEVH8y/ocwuLn0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705761861; c=relaxed/simple;
	bh=HPmQ0al3jf48A0014h/f2dPpfRLn6G7iqgyVLg+H2Fo=;
	h=From:To:Subject:Date:Message-Id:MIME-Version; b=rhdQZbI11hc2tKuJSl6qmG7Pj8vgBDL9IrKqxtYnGdR02tSwrcvPnItp70YA7S/haOviFvYu2y4Wkkt/3KCNcFgFN4c/voicwHXYfCxJuzfuRLUFwO7mrTcHubscxufUdnos34MdddLeNBAYJMTriLWJ36J6l5e2m5+2brRVhl4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=lG26gPJK; arc=none smtp.client-ip=209.85.160.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-oa1-f49.google.com with SMTP id 586e51a60fabf-210a73a5932so1185032fac.3;
        Sat, 20 Jan 2024 06:44:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1705761859; x=1706366659; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:to
         :from:from:to:cc:subject:date:message-id:reply-to;
        bh=IfBwVEpfexQbIPSgBww/5k3Cr6Ag1bm9WDe5/2EYrlU=;
        b=lG26gPJKXyKMBgPk+7cVh+B0MrH/OUGF7AKU1rmmvB7qAw85F7bRAmBFfwD3bvZnsq
         yrtd4LnxBar4uCOblzHhDm4RsSdF3uIBoofR/iGd5pgN0xsyWDovVqi8abLswSTlzjbj
         ZMzbQaCf9FMChJjxGe9hdnXv0eYjWry2pfOkI0iXKZfYSggBGneWOb0Io4YqXTqu7SDx
         OEa3Dstu47cJgCsBd+wLvmwqcy36AEE6GSCz44Bj/Ne1x4H8Bv6mFeDvWvr4Mgvjyx9w
         0uQ/depTaRWOd3MT+v4HzRKQOvTjj7mnih6pAZGEqs4VjdusI1bY3SPGv+D8pHX3XImG
         i9Vw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1705761859; x=1706366659;
        h=content-transfer-encoding:mime-version:message-id:date:subject:to
         :from:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=IfBwVEpfexQbIPSgBww/5k3Cr6Ag1bm9WDe5/2EYrlU=;
        b=QUywdipKP+/RkxEzmzYTlUVsrjILQECVF3aisOWhIO+m8lbSTVPfrk4+8cV9HMy5CQ
         s7QrFCiqgUzcjZW6kE1Prr7PcEuk/GM4YgyXXSpYvWdneexWrONjrLNbp8BqIu846aHG
         xGIDYf6kFKDT1ld3jZgVXUNc5QTMjD+dBxEdjuad47mk6HdJ3GQfT+ACuNbIEnTu4UmJ
         ie8hMHvqOhvCfVHHvNdST+wu9dAR49S44eMhW2yzS21eXsqLp8pFxtn8PBD9/to2ZwSr
         anyhdnmOqfO53xFy/EWRWayerfLcuRv8Uktf+MxGUwrWeYWOxIjfuIy5UFOIJFHhDsxs
         /1/A==
X-Gm-Message-State: AOJu0YxynpztCj6cyJnafuWeLstn+g69K2g3pTg70KAh9s76y0RCj0G3
	bhKgbvBtKDkr0Py8JvxB8lOnGELciNPlaClc2tbADN25KuU2bTUx
X-Google-Smtp-Source: AGHT+IGDQLZFG/7k7xzDA1DiSebrrV+gTIdvhMQqGug98bRrvWDlEtU0Tk70r8YverpOmatw4Ll9WA==
X-Received: by 2002:a05:6870:41d4:b0:214:2d23:f68b with SMTP id z20-20020a05687041d400b002142d23f68bmr1306732oac.5.1705761859601;
        Sat, 20 Jan 2024 06:44:19 -0800 (PST)
Received: from user.. ([106.51.184.167])
        by smtp.gmail.com with ESMTPSA id h8-20020a654808000000b005ca0ae17983sm4649637pgs.8.2024.01.20.06.44.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 20 Jan 2024 06:44:19 -0800 (PST)
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
Subject: [PATCH v2] iouring:added boundary value check for io_uring_group systl
Date: Sat, 20 Jan 2024 14:44:11 +0000
Message-Id: <20240120144411.2564-1-subramanya.swamy.linux@gmail.com>
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

Signed-off-by: Subramanya Swamy <subramanya.swamy.linux@gmail.com>
---
 Documentation/admin-guide/sysctl/kernel.rst | 6 ++----
 io_uring/io_uring.c                         | 8 ++++++--
 2 files changed, 8 insertions(+), 6 deletions(-)

diff --git a/Documentation/admin-guide/sysctl/kernel.rst b/Documentation/admin-guide/sysctl/kernel.rst
index 6584a1f9bfe3..a8b61ab3e118 100644
--- a/Documentation/admin-guide/sysctl/kernel.rst
+++ b/Documentation/admin-guide/sysctl/kernel.rst
@@ -470,10 +470,8 @@ io_uring_group
 ==============
 
 When io_uring_disabled is set to 1, a process must either be
-privileged (CAP_SYS_ADMIN) or be in the io_uring_group group in order
-to create an io_uring instance.  If io_uring_group is set to -1 (the
-default), only processes with the CAP_SYS_ADMIN capability may create
-io_uring instances.
+privledged (CAP_SYS_ADMIN) or be in the io_uring_group group in order
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


