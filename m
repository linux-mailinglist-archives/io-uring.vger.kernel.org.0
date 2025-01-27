Return-Path: <io-uring+bounces-6140-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 227F7A1DA0C
	for <lists+io-uring@lfdr.de>; Mon, 27 Jan 2025 16:59:55 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id EC0D91888FC4
	for <lists+io-uring@lfdr.de>; Mon, 27 Jan 2025 15:59:55 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D60F214D6ED;
	Mon, 27 Jan 2025 15:59:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.microsoft.com header.i=@linux.microsoft.com header.b="PtDl01qI"
X-Original-To: io-uring@vger.kernel.org
Received: from linux.microsoft.com (linux.microsoft.com [13.77.154.182])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 47561155747;
	Mon, 27 Jan 2025 15:59:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=13.77.154.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737993578; cv=none; b=QSFtM7AGZJDAVc6sIVg6BU1x45V3Dgw7LkCppwsFyQ1LXWzOOztgl9JKxy3743YpzXEsiUvN6PKN0nuqcbp3J/DHI0WTRz8KOmTuF7rj3dEAKPRtDsBbFNikjAQvvVx5eOPdF+D4LM3OOLHtVlgtLsAFEjN4lL2EH3Tf0khQQp8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737993578; c=relaxed/simple;
	bh=Q7+SMiJKxbIvDSMi+10SwSyW9NdNz2BjBUNgb4kYIoI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=msvQUI8IyOT93HMKCWQ2Jk6wcjSWrinxZv1b0vjgW/2wkMarMyPCC5yZnqaBwBP/hr950cjhliw5+q7XGjPb3a0aZOYUQ3jFQA/33DVshA+Uut5Bon20oPvCTMG1Ckq8mdC3N1gEMe576CbQ4WnsdZl6gdu2g7SA7mT0kUZcYl8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.microsoft.com; spf=pass smtp.mailfrom=linux.microsoft.com; dkim=pass (1024-bit key) header.d=linux.microsoft.com header.i=@linux.microsoft.com header.b=PtDl01qI; arc=none smtp.client-ip=13.77.154.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.microsoft.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.microsoft.com
Received: from hm-sls2.corp.microsoft.com (unknown [184.146.177.43])
	by linux.microsoft.com (Postfix) with ESMTPSA id F2AE72066C1C;
	Mon, 27 Jan 2025 07:59:29 -0800 (PST)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com F2AE72066C1C
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.microsoft.com;
	s=default; t=1737993571;
	bh=2/udn9ZmxbFIXLbmMids8xdWRcpso7DJ8fjy/XbvBwM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=PtDl01qIGWaAIkA7uy/rx3VGXP1OSQ/fvxYLkugwDZnb7uxpxW1dAlrShz7coKMur
	 ZLjOs8uHLSTojcH6QKmobhXUHygChiruD2oh5AWOOUXIF8li8VbbHwL8jKEoXUfoZE
	 sAjj0BaY3Xo127WFH9z9H7ec8q3sOe3BzMpVDgUc=
From: Hamza Mahfooz <hamzamahfooz@linux.microsoft.com>
To: linux-kernel@vger.kernel.org
Cc: Hamza Mahfooz <hamzamahfooz@linux.microsoft.com>,
	Paul Moore <paul@paul-moore.com>,
	James Morris <jmorris@namei.org>,
	"Serge E. Hallyn" <serge@hallyn.com>,
	Jens Axboe <axboe@kernel.dk>,
	Pavel Begunkov <asml.silence@gmail.com>,
	Stephen Smalley <stephen.smalley.work@gmail.com>,
	Ondrej Mosnacek <omosnace@redhat.com>,
	=?UTF-8?q?Bram=20Bonn=C3=A9?= <brambonne@google.com>,
	=?UTF-8?q?Thi=C3=A9baud=20Weksteen?= <tweek@google.com>,
	=?UTF-8?q?Christian=20G=C3=B6ttsche?= <cgzones@googlemail.com>,
	Masahiro Yamada <masahiroy@kernel.org>,
	linux-security-module@vger.kernel.org,
	io-uring@vger.kernel.org,
	selinux@vger.kernel.org
Subject: [PATCH v3 2/2] lsm,io_uring: add LSM hooks for io_uring_setup()
Date: Mon, 27 Jan 2025 10:57:18 -0500
Message-ID: <20250127155723.67711-2-hamzamahfooz@linux.microsoft.com>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20250127155723.67711-1-hamzamahfooz@linux.microsoft.com>
References: <20250127155723.67711-1-hamzamahfooz@linux.microsoft.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

It is desirable to allow LSM to configure accessibility to io_uring
because it is a coarse yet very simple way to restrict access to it. So,
add an LSM for io_uring_allowed() to guard access to io_uring.

Cc: Paul Moore <paul@paul-moore.com>
Signed-off-by: Hamza Mahfooz <hamzamahfooz@linux.microsoft.com>
---
 include/linux/lsm_hook_defs.h       |  1 +
 include/linux/security.h            |  5 +++++
 io_uring/io_uring.c                 |  2 +-
 security/security.c                 | 12 ++++++++++++
 security/selinux/hooks.c            | 14 ++++++++++++++
 security/selinux/include/classmap.h |  2 +-
 6 files changed, 34 insertions(+), 2 deletions(-)

diff --git a/include/linux/lsm_hook_defs.h b/include/linux/lsm_hook_defs.h
index e2f1ce37c41e..9eb313bd0c93 100644
--- a/include/linux/lsm_hook_defs.h
+++ b/include/linux/lsm_hook_defs.h
@@ -455,6 +455,7 @@ LSM_HOOK(int, 0, perf_event_write, struct perf_event *event)
 LSM_HOOK(int, 0, uring_override_creds, const struct cred *new)
 LSM_HOOK(int, 0, uring_sqpoll, void)
 LSM_HOOK(int, 0, uring_cmd, struct io_uring_cmd *ioucmd)
+LSM_HOOK(int, 0, uring_allowed, void)
 #endif /* CONFIG_IO_URING */
 
 LSM_HOOK(void, LSM_RET_VOID, initramfs_populated, void)
diff --git a/include/linux/security.h b/include/linux/security.h
index 980b6c207cad..3e68f8468a22 100644
--- a/include/linux/security.h
+++ b/include/linux/security.h
@@ -2362,6 +2362,7 @@ static inline int security_perf_event_write(struct perf_event *event)
 extern int security_uring_override_creds(const struct cred *new);
 extern int security_uring_sqpoll(void);
 extern int security_uring_cmd(struct io_uring_cmd *ioucmd);
+extern int security_uring_allowed(void);
 #else
 static inline int security_uring_override_creds(const struct cred *new)
 {
@@ -2375,6 +2376,10 @@ static inline int security_uring_cmd(struct io_uring_cmd *ioucmd)
 {
 	return 0;
 }
+extern int security_uring_allowed(void)
+{
+	return 0;
+}
 #endif /* CONFIG_SECURITY */
 #endif /* CONFIG_IO_URING */
 
diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
index c2d8bd4c2cfc..9df7b3b556ef 100644
--- a/io_uring/io_uring.c
+++ b/io_uring/io_uring.c
@@ -3808,7 +3808,7 @@ static inline int io_uring_allowed(void)
 		return -EPERM;
 
 allowed_lsm:
-	return 0;
+	return security_uring_allowed();
 }
 
 SYSCALL_DEFINE2(io_uring_setup, u32, entries,
diff --git a/security/security.c b/security/security.c
index 143561ebc3e8..c9fae447327e 100644
--- a/security/security.c
+++ b/security/security.c
@@ -5999,6 +5999,18 @@ int security_uring_cmd(struct io_uring_cmd *ioucmd)
 {
 	return call_int_hook(uring_cmd, ioucmd);
 }
+
+/**
+ * security_uring_allowed() - Check if io_uring_setup() is allowed
+ *
+ * Check whether the current task is allowed to call io_uring_setup().
+ *
+ * Return: Returns 0 if permission is granted.
+ */
+int security_uring_allowed(void)
+{
+	return call_int_hook(uring_allowed);
+}
 #endif /* CONFIG_IO_URING */
 
 /**
diff --git a/security/selinux/hooks.c b/security/selinux/hooks.c
index 7b867dfec88b..fb37e87df226 100644
--- a/security/selinux/hooks.c
+++ b/security/selinux/hooks.c
@@ -7137,6 +7137,19 @@ static int selinux_uring_cmd(struct io_uring_cmd *ioucmd)
 	return avc_has_perm(current_sid(), isec->sid,
 			    SECCLASS_IO_URING, IO_URING__CMD, &ad);
 }
+
+/**
+ * selinux_uring_allowed - check if io_uring_setup() can be called
+ *
+ * Check to see if the current task is allowed to call io_uring_setup().
+ */
+static int selinux_uring_allowed(void)
+{
+	u32 sid = current_sid();
+
+	return avc_has_perm(sid, sid, SECCLASS_IO_URING, IO_URING__ALLOWED,
+			    NULL);
+}
 #endif /* CONFIG_IO_URING */
 
 static const struct lsm_id selinux_lsmid = {
@@ -7390,6 +7403,7 @@ static struct security_hook_list selinux_hooks[] __ro_after_init = {
 	LSM_HOOK_INIT(uring_override_creds, selinux_uring_override_creds),
 	LSM_HOOK_INIT(uring_sqpoll, selinux_uring_sqpoll),
 	LSM_HOOK_INIT(uring_cmd, selinux_uring_cmd),
+	LSM_HOOK_INIT(uring_allowed, selinux_uring_allowed),
 #endif
 
 	/*
diff --git a/security/selinux/include/classmap.h b/security/selinux/include/classmap.h
index 03e82477dce9..8a8f3908aac8 100644
--- a/security/selinux/include/classmap.h
+++ b/security/selinux/include/classmap.h
@@ -177,7 +177,7 @@ const struct security_class_mapping secclass_map[] = {
 	{ "perf_event",
 	  { "open", "cpu", "kernel", "tracepoint", "read", "write", NULL } },
 	{ "anon_inode", { COMMON_FILE_PERMS, NULL } },
-	{ "io_uring", { "override_creds", "sqpoll", "cmd", NULL } },
+	{ "io_uring", { "override_creds", "sqpoll", "cmd", "allowed", NULL } },
 	{ "user_namespace", { "create", NULL } },
 	/* last one */ { NULL, {} }
 };
-- 
2.47.1


