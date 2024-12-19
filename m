Return-Path: <io-uring+bounces-5576-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 13B149F86CC
	for <lists+io-uring@lfdr.de>; Thu, 19 Dec 2024 22:19:29 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 44047167536
	for <lists+io-uring@lfdr.de>; Thu, 19 Dec 2024 21:19:26 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 15CCA1D79A3;
	Thu, 19 Dec 2024 21:16:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.microsoft.com header.i=@linux.microsoft.com header.b="CB6w5zTc"
X-Original-To: io-uring@vger.kernel.org
Received: from linux.microsoft.com (linux.microsoft.com [13.77.154.182])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1F3C71BEF8B;
	Thu, 19 Dec 2024 21:16:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=13.77.154.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734642998; cv=none; b=p/BFEmC1v1bTMMV51+DyKvutuNFR8UcrU97rt62rXOu0HIf9hNr3KVKBUI7Lgt/llRjFL7j6APL7SAKIwch+bG+2mU41yAClmWxrn2QFeKe5pJW/m72oUmyzizO9X0Q7ZouGjScEc3m0XyZqq1sYdcH4Ve2kBwDitHHYSffH7xI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734642998; c=relaxed/simple;
	bh=U+duozeGpGNScF52Xe7xSRVKu4Ywc0+XlJJ9+d9oo18=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=Nm81MaDyAir2xc9rLoyVg/jMsDK+Bg88iD5EhUAbYdHyDyPrP+Z7AGN6QNyReiKGYY9Ek4mp/CXhm78bDzS4VJb9kwBC1Bxirfo8mYNxb7zw+C5dpIq1gPLc3Vjn7BzFT2sS7JMPy82IrEvzu+juqg+jjniJ4qPqyHgIA5wb+yQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.microsoft.com; spf=pass smtp.mailfrom=linux.microsoft.com; dkim=pass (1024-bit key) header.d=linux.microsoft.com header.i=@linux.microsoft.com header.b=CB6w5zTc; arc=none smtp.client-ip=13.77.154.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.microsoft.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.microsoft.com
Received: from hm-sls2.corp.microsoft.com (bras-base-toroon4332w-grc-63-70-49-166-4.dsl.bell.ca [70.49.166.4])
	by linux.microsoft.com (Postfix) with ESMTPSA id 074D1203FC96;
	Thu, 19 Dec 2024 13:16:26 -0800 (PST)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com 074D1203FC96
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.microsoft.com;
	s=default; t=1734642988;
	bh=1hlWvWk51FxHvi+OtPYh8MozhprRteIAY5jUyecOoAg=;
	h=From:To:Cc:Subject:Date:From;
	b=CB6w5zTccmZ/ROwUB74uOSObyviTSdhuTEYnjSkhioljt0By336pnmjTS1AHqCiD9
	 F5j2v/K/gGrzk6lr/9YSe5nZ76hmYL8149UbdkLVOtuoFKpZmLJW9mfcjorR4EnWqP
	 upah7EcNDbl8ErNW5ZBB2UumHNzV/R3F6gozXoHs=
From: Hamza Mahfooz <hamzamahfooz@linux.microsoft.com>
To: linux-security-module@vger.kernel.org,
	io-uring@vger.kernel.org
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
	Masahiro Yamada <masahiroy@kernel.org>,
	linux-kernel@vger.kernel.org,
	selinux@vger.kernel.org
Subject: [PATCH 1/2] lsm: add LSM hooks for io_uring_setup()
Date: Thu, 19 Dec 2024 16:16:06 -0500
Message-ID: <20241219211610.83638-1-hamzamahfooz@linux.microsoft.com>
X-Mailer: git-send-email 2.47.1
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

It is desirable to allow LSM to configure accessibility to io_uring. So,
add an LSM for io_uring_allowed() to guard access to io_uring.

Cc: Paul Moore <paul@paul-moore.com>
Signed-off-by: Hamza Mahfooz <hamzamahfooz@linux.microsoft.com>
---
 include/linux/lsm_hook_defs.h       |  1 +
 include/linux/security.h            |  5 +++++
 security/security.c                 | 12 ++++++++++++
 security/selinux/hooks.c            | 14 ++++++++++++++
 security/selinux/include/classmap.h |  2 +-
 5 files changed, 33 insertions(+), 1 deletion(-)

diff --git a/include/linux/lsm_hook_defs.h b/include/linux/lsm_hook_defs.h
index eb2937599cb0..ee45229418dd 100644
--- a/include/linux/lsm_hook_defs.h
+++ b/include/linux/lsm_hook_defs.h
@@ -456,6 +456,7 @@ LSM_HOOK(int, 0, perf_event_write, struct perf_event *event)
 LSM_HOOK(int, 0, uring_override_creds, const struct cred *new)
 LSM_HOOK(int, 0, uring_sqpoll, void)
 LSM_HOOK(int, 0, uring_cmd, struct io_uring_cmd *ioucmd)
+LSM_HOOK(int, 0, uring_allowed, void)
 #endif /* CONFIG_IO_URING */
 
 LSM_HOOK(void, LSM_RET_VOID, initramfs_populated, void)
diff --git a/include/linux/security.h b/include/linux/security.h
index cbdba435b798..0a5e897289e8 100644
--- a/include/linux/security.h
+++ b/include/linux/security.h
@@ -2351,6 +2351,7 @@ static inline int security_perf_event_write(struct perf_event *event)
 extern int security_uring_override_creds(const struct cred *new);
 extern int security_uring_sqpoll(void);
 extern int security_uring_cmd(struct io_uring_cmd *ioucmd);
+extern int security_uring_allowed(void);
 #else
 static inline int security_uring_override_creds(const struct cred *new)
 {
@@ -2364,6 +2365,10 @@ static inline int security_uring_cmd(struct io_uring_cmd *ioucmd)
 {
 	return 0;
 }
+extern int security_uring_allowed(void)
+{
+	return 0;
+}
 #endif /* CONFIG_SECURITY */
 #endif /* CONFIG_IO_URING */
 
diff --git a/security/security.c b/security/security.c
index 09664e09fec9..e4d532e4ead4 100644
--- a/security/security.c
+++ b/security/security.c
@@ -5996,6 +5996,18 @@ int security_uring_cmd(struct io_uring_cmd *ioucmd)
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
index 366c87a40bd1..b4e298c51c16 100644
--- a/security/selinux/hooks.c
+++ b/security/selinux/hooks.c
@@ -7117,6 +7117,19 @@ static int selinux_uring_cmd(struct io_uring_cmd *ioucmd)
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
@@ -7370,6 +7383,7 @@ static struct security_hook_list selinux_hooks[] __ro_after_init = {
 	LSM_HOOK_INIT(uring_override_creds, selinux_uring_override_creds),
 	LSM_HOOK_INIT(uring_sqpoll, selinux_uring_sqpoll),
 	LSM_HOOK_INIT(uring_cmd, selinux_uring_cmd),
+	LSM_HOOK_INIT(uring_allowed, selinux_uring_allowed),
 #endif
 
 	/*
diff --git a/security/selinux/include/classmap.h b/security/selinux/include/classmap.h
index 2bc20135324a..5ae222f7e543 100644
--- a/security/selinux/include/classmap.h
+++ b/security/selinux/include/classmap.h
@@ -177,7 +177,7 @@ const struct security_class_mapping secclass_map[] = {
 	{ "perf_event",
 	  { "open", "cpu", "kernel", "tracepoint", "read", "write", NULL } },
 	{ "anon_inode", { COMMON_FILE_PERMS, NULL } },
-	{ "io_uring", { "override_creds", "sqpoll", "cmd", NULL } },
+	{ "io_uring", { "override_creds", "sqpoll", "cmd", "allowed", NULL } },
 	{ "user_namespace", { "create", NULL } },
 	{ NULL }
 };
-- 
2.47.1


