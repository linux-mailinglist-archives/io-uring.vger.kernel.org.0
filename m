Return-Path: <io-uring+bounces-5573-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 70E209F8619
	for <lists+io-uring@lfdr.de>; Thu, 19 Dec 2024 21:42:39 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 4C3C11893200
	for <lists+io-uring@lfdr.de>; Thu, 19 Dec 2024 20:42:40 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 862D71A01B0;
	Thu, 19 Dec 2024 20:42:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.microsoft.com header.i=@linux.microsoft.com header.b="YMF++CYn"
X-Original-To: io-uring@vger.kernel.org
Received: from linux.microsoft.com (linux.microsoft.com [13.77.154.182])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E1B4E3FD1;
	Thu, 19 Dec 2024 20:42:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=13.77.154.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734640957; cv=none; b=nnNzI5hBWGAgDi9rWisoNY47xd+WX47Qd0J7rJ6WiqXqTVz/F5H84RtoRqn7mSKjJOnaIxgAHaWRKl4hdvOZQr7u6T215P/oj4DWJ44o1yAeoX8ou5IxfVqqcbsoXoxBHCmM/Kf8Znkq5O6Utd6OUUB9L9sTU6pAEnfbdlE2cW8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734640957; c=relaxed/simple;
	bh=6DSTopWMJNTlqwjejKr077ARPFYD2iH2vMsPv/ooX6o=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=aB2DZhyk5QXHQDxm8SGYJjuxcjwM138Au2SbXmjQkPiXjKc4c5nt8epxPxMi+7KoJUrLpSX/qBOZ36+UQh9cRCzhkMKBw8tX3sfdGun3wYcXLz0dzqKtustQaZuMkZq/bRwYFIQUeqUu7V1XlCYkqij03Aayy8rQgxOFLxXI4Gg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.microsoft.com; spf=pass smtp.mailfrom=linux.microsoft.com; dkim=pass (1024-bit key) header.d=linux.microsoft.com header.i=@linux.microsoft.com header.b=YMF++CYn; arc=none smtp.client-ip=13.77.154.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.microsoft.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.microsoft.com
Received: from hm-sls2.corp.microsoft.com (bras-base-toroon4332w-grc-63-70-49-166-4.dsl.bell.ca [70.49.166.4])
	by linux.microsoft.com (Postfix) with ESMTPSA id 6EFB9203FC94;
	Thu, 19 Dec 2024 12:42:34 -0800 (PST)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com 6EFB9203FC94
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.microsoft.com;
	s=default; t=1734640955;
	bh=iVZB9ew11Lrxd3x06+Ra7NzDQmQpUub+riVhr6QI1Yk=;
	h=From:To:Cc:Subject:Date:From;
	b=YMF++CYnXVuqr38qBKTGY/FrIBR1gwXG6P5cu+XkY4PAPBmgKo1u7j0AihVILJrGO
	 pJmeRJOb97F55RRX2qAgAVnKxNWofj1p8MfEwMUnw+SOrMs/uULp48iXqzv6x2dk5n
	 tqyN2NUymW1T3ZxbliFMRpHGBpyi4Fmi5yil4pTs=
From: Hamza Mahfooz <hamzamahfooz@linux.microsoft.com>
To: linux-security-module@vger.kernel.org,
	io-uring@vger.kernel.org
Cc: Hamza Mahfooz <hamzamahfooz@linux.microsoft.com>,
	Paul Moore <paul@paul-moore.com>,
	Jens Axboe <axboe@kernel.dk>,
	James Morris <jmorris@namei.org>,
	"Serge E. Hallyn" <serge@hallyn.com>,
	Pavel Begunkov <asml.silence@gmail.com>,
	Stephen Smalley <stephen.smalley.work@gmail.com>,
	Ondrej Mosnacek <omosnace@redhat.com>,
	=?UTF-8?q?Thi=C3=A9baud=20Weksteen?= <tweek@google.com>,
	Masahiro Yamada <masahiroy@kernel.org>,
	=?UTF-8?q?Bram=20Bonn=C3=A9?= <brambonne@google.com>,
	linux-kernel@vger.kernel.org,
	selinux@vger.kernel.org
Subject: [PATCH] lsm,io_uring: add LSM hooks for io_uring_setup()
Date: Thu, 19 Dec 2024 15:41:41 -0500
Message-ID: <20241219204143.74736-1-hamzamahfooz@linux.microsoft.com>
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
Cc: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Hamza Mahfooz <hamzamahfooz@linux.microsoft.com>
---
 include/linux/lsm_hook_defs.h       |  1 +
 include/linux/security.h            |  5 +++++
 io_uring/io_uring.c                 | 21 ++++++++++++++-------
 security/security.c                 | 12 ++++++++++++
 security/selinux/hooks.c            | 14 ++++++++++++++
 security/selinux/include/classmap.h |  2 +-
 6 files changed, 47 insertions(+), 8 deletions(-)

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
 
diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
index 06ff41484e29..0922bb0724c0 100644
--- a/io_uring/io_uring.c
+++ b/io_uring/io_uring.c
@@ -3806,29 +3806,36 @@ static long io_uring_setup(u32 entries, struct io_uring_params __user *params)
 	return io_uring_create(entries, &p, params);
 }
 
-static inline bool io_uring_allowed(void)
+static inline int io_uring_allowed(void)
 {
 	int disabled = READ_ONCE(sysctl_io_uring_disabled);
 	kgid_t io_uring_group;
 
 	if (disabled == 2)
-		return false;
+		return -EPERM;
 
 	if (disabled == 0 || capable(CAP_SYS_ADMIN))
-		return true;
+		goto allowed_lsm;
 
 	io_uring_group = make_kgid(&init_user_ns, sysctl_io_uring_group);
 	if (!gid_valid(io_uring_group))
-		return false;
+		return -EPERM;
+
+	if (!in_group_p(io_uring_group))
+		return -EPERM;
 
-	return in_group_p(io_uring_group);
+allowed_lsm:
+	return security_uring_allowed();
 }
 
 SYSCALL_DEFINE2(io_uring_setup, u32, entries,
 		struct io_uring_params __user *, params)
 {
-	if (!io_uring_allowed())
-		return -EPERM;
+	int ret;
+
+	ret = io_uring_allowed();
+	if (ret)
+		return ret;
 
 	return io_uring_setup(entries, params);
 }
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


