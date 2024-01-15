Return-Path: <io-uring+bounces-403-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 1912F82D90C
	for <lists+io-uring@lfdr.de>; Mon, 15 Jan 2024 13:49:38 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 126A01C2128F
	for <lists+io-uring@lfdr.de>; Mon, 15 Jan 2024 12:49:37 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A06F41428F;
	Mon, 15 Jan 2024 12:49:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="ALrmMsr4"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pl1-f173.google.com (mail-pl1-f173.google.com [209.85.214.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 48A03134CA;
	Mon, 15 Jan 2024 12:49:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pl1-f173.google.com with SMTP id d9443c01a7336-1d542701796so44016865ad.1;
        Mon, 15 Jan 2024 04:49:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1705322972; x=1705927772; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:to
         :from:from:to:cc:subject:date:message-id:reply-to;
        bh=zAY4fhIX05imv8R3TK0HIbxeC0Nq1d7M0aRDqNU4YGc=;
        b=ALrmMsr4AR78gpILyMraNM3HtrYpeeoDVcBb+8HZK3Eev/ne8fPxmBZCkC6Kmd05xm
         8GCUipCaumGcAgVY39SDH4u7kofkL47JSgJSvfdJsi3vtxuMr8tpUbExtVGB4X1m19wE
         Zm7+gaujeRLxWbC3i0jV2LTfM5quVd19oFggZhTSTCiYwlFB0THCmIR8Tii125vP22Bv
         VUUjtJu+qljgGatJCqheGcIvK5GVOLENPXpkTWglaWYJgNDQjf2qFliYxOfHCsKA3yu5
         GfdmJXut0xlsRFevEYZveXb6ZElFcG0s2YjwR75dmgu52VkzOzgipneAV/XOP7wYJt2Y
         d34g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1705322972; x=1705927772;
        h=content-transfer-encoding:mime-version:message-id:date:subject:to
         :from:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=zAY4fhIX05imv8R3TK0HIbxeC0Nq1d7M0aRDqNU4YGc=;
        b=a1aolULyEnccpKa9IRJw5+SPU14+yjWjsyOpb8xNAMlYGjI0U7xBystopSXl8JSxdZ
         8J3Dxurvg5oYmkamWGEMCdePRnNOUHhoTcmhMg8Wk5yyDAecf5YnR02sNCiqUEqS+WxS
         Um1j9fy0wonssbG2X4RYxW181sGMG2H8UVp1wQs38OrIOVLPyTlLdlEJbhrOcfdyLypj
         f7vPBVEW64GF0C1kHW9EFQP2I6kG5KB537lgEhFU5WOzHhUXzPNmA0POfg+FJI7FJv5D
         43lDiucv/HZ5J8epwFTTvnrtxTP20yGRKajyoVvMRk9CxUBeobLect+dEr8T1mkvBD0p
         k8UQ==
X-Gm-Message-State: AOJu0Ywy125Mi0DkySUc11UMVqMnpzAAmRx66FGFPcCp//u0DEc9oOrv
	McRMcuyfpL+eMFNNL1ka+QA=
X-Google-Smtp-Source: AGHT+IGKYK21agVDOgrH10CE8pOjjHYxcQZgbbKAnFvJzTXK/4aUkUDQNPk9O4KJjr5LgZGiWmKmIA==
X-Received: by 2002:a17:902:c385:b0:1d4:c1b5:7248 with SMTP id g5-20020a170902c38500b001d4c1b57248mr2941983plg.96.1705322972422;
        Mon, 15 Jan 2024 04:49:32 -0800 (PST)
Received: from user.. ([106.51.187.155])
        by smtp.gmail.com with ESMTPSA id s3-20020a17090330c300b001d5b7ae4831sm3840331plc.180.2024.01.15.04.49.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 15 Jan 2024 04:49:32 -0800 (PST)
From: Subramanya Swamy <subramanya.swamy.linux@gmail.com>
To: corbet@lwn.net,
	axboe@kernel.dk,
	asml.silence@gmail.com,
	ribalda@chromium.org,
	rostedt@goodmis.org,
	bhe@redhat.com,
	akpm@linux-foundation.org,
	matteorizzo@google.com,
	subramanya.swamy.linux@gmail.com,
	ardb@kernel.org,
	alexghiti@rivosinc.com,
	linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	io-uring@vger.kernel.org
Subject: [PATCH] iouring:added boundary value check for io_uring_group systl
Date: Mon, 15 Jan 2024 12:49:25 +0000
Message-Id: <20240115124925.1735-1-subramanya.swamy.linux@gmail.com>
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
 Documentation/admin-guide/sysctl/kernel.rst | 9 ++++-----
 io_uring/io_uring.c                         | 8 ++++++--
 2 files changed, 10 insertions(+), 7 deletions(-)

diff --git a/Documentation/admin-guide/sysctl/kernel.rst b/Documentation/admin-guide/sysctl/kernel.rst
index 6584a1f9bfe3..3f96007aa971 100644
--- a/Documentation/admin-guide/sysctl/kernel.rst
+++ b/Documentation/admin-guide/sysctl/kernel.rst
@@ -469,11 +469,10 @@ shrinks the kernel's attack surface.
 io_uring_group
 ==============
 
-When io_uring_disabled is set to 1, a process must either be
-privileged (CAP_SYS_ADMIN) or be in the io_uring_group group in order
-to create an io_uring instance.  If io_uring_group is set to -1 (the
-default), only processes with the CAP_SYS_ADMIN capability may create
-io_uring instances.
+When io_uring_disabled is set to 1, only processes with the
+CAP_SYS_ADMIN may create io_uring instances or process must be in the
+io_uring_group group in order to create an io_uring_instance.
+io_uring_group is set to 0.This is the default setting.
 
 
 kexec_load_disabled
diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
index 09b6d860deba..0ed91b69643d 100644
--- a/io_uring/io_uring.c
+++ b/io_uring/io_uring.c
@@ -146,7 +146,9 @@ static void io_queue_sqe(struct io_kiocb *req);
 struct kmem_cache *req_cachep;
 
 static int __read_mostly sysctl_io_uring_disabled;
-static int __read_mostly sysctl_io_uring_group = -1;
+static unsigned int __read_mostly sysctl_io_uring_group;
+static unsigned int min_gid;
+static unsigned int max_gid  = 4294967294;  /*4294967294 is the max guid*/
 
 #ifdef CONFIG_SYSCTL
 static struct ctl_table kernel_io_uring_disabled_table[] = {
@@ -164,7 +166,9 @@ static struct ctl_table kernel_io_uring_disabled_table[] = {
 		.data		= &sysctl_io_uring_group,
 		.maxlen		= sizeof(gid_t),
 		.mode		= 0644,
-		.proc_handler	= proc_dointvec,
+		.proc_handler	= proc_douintvec_minmax,
+		.extra1         = &min_gid,
+		.extra2         = &max_gid,
 	},
 	{},
 };
-- 
2.34.1


