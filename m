Return-Path: <io-uring+bounces-6139-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 12A75A1DA09
	for <lists+io-uring@lfdr.de>; Mon, 27 Jan 2025 16:59:39 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 414DA1656CB
	for <lists+io-uring@lfdr.de>; Mon, 27 Jan 2025 15:59:37 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C27EB14F9FD;
	Mon, 27 Jan 2025 15:59:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.microsoft.com header.i=@linux.microsoft.com header.b="Ne6wBdfP"
X-Original-To: io-uring@vger.kernel.org
Received: from linux.microsoft.com (linux.microsoft.com [13.77.154.182])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3F51E14D6ED;
	Mon, 27 Jan 2025 15:59:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=13.77.154.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737993575; cv=none; b=OOB78cG+a5zAC7Ml6MzVA+f83zahAW7m4PTT1wbInVxqZ9iLg9NAZ9DvCsnLYWtio2PugMH2GpIA1VewfafUJAO7qy6Rr5BJQ3NlhuJ/ePAl4JQHO5dQ58fPJ5d/x/GkIbK4JyDMep5XeOSzwqv0xAhXYdgAXWZJect7NFYbn9Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737993575; c=relaxed/simple;
	bh=H+g4ZMD0yhyfee4133CeWuDA9psgDECOgETg+acbf8c=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=DLaKXPPYlt1SQO80l24dw9VMhSncTXfWfdQAt5KTUdltcIUadlPPJ2iD82CjgLGtzoTxdr0BcGhi+wPY75OF6a9Vff2Yhh50HI8kjJWC5mi9LWsurZrv9CxEfRlN6iQSbn6U2+GuHZrMJURGlB0liOSbNkPjH9Y8x9TRtV6UWZ8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.microsoft.com; spf=pass smtp.mailfrom=linux.microsoft.com; dkim=pass (1024-bit key) header.d=linux.microsoft.com header.i=@linux.microsoft.com header.b=Ne6wBdfP; arc=none smtp.client-ip=13.77.154.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.microsoft.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.microsoft.com
Received: from hm-sls2.corp.microsoft.com (unknown [184.146.177.43])
	by linux.microsoft.com (Postfix) with ESMTPSA id 391DD20545AC;
	Mon, 27 Jan 2025 07:59:27 -0800 (PST)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com 391DD20545AC
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.microsoft.com;
	s=default; t=1737993568;
	bh=VjAmq2kOp0FdSGzONSmhJBT9T9J4PGigVc+QqkE8Hg4=;
	h=From:To:Cc:Subject:Date:From;
	b=Ne6wBdfPgCNAVY8zJTkzZB0vL7nPZyMKZ+YDr+jMyYXOmaOFNdrloHzVgQSd6nlO+
	 1rgQ37nJXRH6ekV9/k1e3vjc76DQ6Cky1pMq4gBKEfwIgmieLxCnePIF5WauDf53Bf
	 jMW1QCNkr2s3xBXdoec1sG5UxpkQKt8NYVhnqH44=
From: Hamza Mahfooz <hamzamahfooz@linux.microsoft.com>
To: linux-kernel@vger.kernel.org
Cc: Hamza Mahfooz <hamzamahfooz@linux.microsoft.com>,
	Jens Axboe <axboe@kernel.dk>,
	Paul Moore <paul@paul-moore.com>,
	James Morris <jmorris@namei.org>,
	"Serge E. Hallyn" <serge@hallyn.com>,
	Pavel Begunkov <asml.silence@gmail.com>,
	Stephen Smalley <stephen.smalley.work@gmail.com>,
	Ondrej Mosnacek <omosnace@redhat.com>,
	=?UTF-8?q?Thi=C3=A9baud=20Weksteen?= <tweek@google.com>,
	=?UTF-8?q?Christian=20G=C3=B6ttsche?= <cgzones@googlemail.com>,
	=?UTF-8?q?Bram=20Bonn=C3=A9?= <brambonne@google.com>,
	Masahiro Yamada <masahiroy@kernel.org>,
	linux-security-module@vger.kernel.org,
	io-uring@vger.kernel.org,
	selinux@vger.kernel.org
Subject: [PATCH v3 1/2] io_uring: refactor io_uring_allowed()
Date: Mon, 27 Jan 2025 10:57:17 -0500
Message-ID: <20250127155723.67711-1-hamzamahfooz@linux.microsoft.com>
X-Mailer: git-send-email 2.47.1
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Have io_uring_allowed() return an error code directly instead of
true/false. This is needed for follow-up work to guard io_uring_setup()
with LSM.

Cc: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Hamza Mahfooz <hamzamahfooz@linux.microsoft.com>
---
 io_uring/io_uring.c | 21 ++++++++++++++-------
 1 file changed, 14 insertions(+), 7 deletions(-)

diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
index 7bfbc7c22367..c2d8bd4c2cfc 100644
--- a/io_uring/io_uring.c
+++ b/io_uring/io_uring.c
@@ -3789,29 +3789,36 @@ static long io_uring_setup(u32 entries, struct io_uring_params __user *params)
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
+	return 0;
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
-- 
2.47.1


