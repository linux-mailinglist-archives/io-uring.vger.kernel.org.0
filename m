Return-Path: <io-uring+bounces-5575-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 872049F86D0
	for <lists+io-uring@lfdr.de>; Thu, 19 Dec 2024 22:19:57 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 227C51897E09
	for <lists+io-uring@lfdr.de>; Thu, 19 Dec 2024 21:19:19 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AE2D21A0B0C;
	Thu, 19 Dec 2024 21:16:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.microsoft.com header.i=@linux.microsoft.com header.b="dvXYfQIt"
X-Original-To: io-uring@vger.kernel.org
Received: from linux.microsoft.com (linux.microsoft.com [13.77.154.182])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3E28A1C3F13;
	Thu, 19 Dec 2024 21:16:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=13.77.154.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734642996; cv=none; b=HlOmZ7TSumgNggcMwHVOZzOlfSB9jVt967ufYdorANS9Fe4pJzTSGBzz7kKDDkg15TO6MO3dKn/fvN3Za/MH7u9uyeQyOpotghTet+o8EL0e2/qTEz6n8p/RYpxPAffNa21byR8EjLxFrK/XL5i65yznzYGEICWxAGVnOwx7Fvo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734642996; c=relaxed/simple;
	bh=XKdGAHeRXw/DdS9tToFsPARQHrLBUbT9Zk45sRUvvjc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YedLPad7Au4XS3P/lkJVrgfRnAL5jYxWTMnTF0etbg2W3AcRKxixHhrPmIxoFy+tjzJOqbgbTCjqwc9cM6CsEvQiHm/3G7wwcPQTF/AgzmIKLl/fflYI8yCnktpn0r+inD5UJlf6IiRM3p3EE/w/Qmhxt44k2uJZknOvbzqkMQw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.microsoft.com; spf=pass smtp.mailfrom=linux.microsoft.com; dkim=pass (1024-bit key) header.d=linux.microsoft.com header.i=@linux.microsoft.com header.b=dvXYfQIt; arc=none smtp.client-ip=13.77.154.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.microsoft.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.microsoft.com
Received: from hm-sls2.corp.microsoft.com (bras-base-toroon4332w-grc-63-70-49-166-4.dsl.bell.ca [70.49.166.4])
	by linux.microsoft.com (Postfix) with ESMTPSA id 6CCD120ACD87;
	Thu, 19 Dec 2024 13:16:28 -0800 (PST)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com 6CCD120ACD87
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.microsoft.com;
	s=default; t=1734642988;
	bh=Q7isC5kCbRv3kAbF8ov5jvgkaOrcxKNTguRPWo2zAoU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=dvXYfQItZB8nprwta0cH6NehuNA1ldDoXlxtv1au3O6agrnGAduWvijxTmz+BSdVH
	 Jreqi5q9xgexbarYk+3efiYi2LQdFoP1CVQHqx/UBYvM7e09Dk9p9O+SuT6dnbtAr4
	 hiYrzwLZv3n32jtlr3TVJCbY05ZtUlvvXOf6nnjA=
From: Hamza Mahfooz <hamzamahfooz@linux.microsoft.com>
To: linux-security-module@vger.kernel.org,
	io-uring@vger.kernel.org
Cc: Hamza Mahfooz <hamzamahfooz@linux.microsoft.com>,
	Jens Axboe <axboe@kernel.dk>,
	Pavel Begunkov <asml.silence@gmail.com>,
	linux-kernel@vger.kernel.org
Subject: [PATCH 2/2] io_uring: use security_uring_allowed()
Date: Thu, 19 Dec 2024 16:16:07 -0500
Message-ID: <20241219211610.83638-2-hamzamahfooz@linux.microsoft.com>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241219211610.83638-1-hamzamahfooz@linux.microsoft.com>
References: <20241219211610.83638-1-hamzamahfooz@linux.microsoft.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

To make use of the new LSM hook, call security_uring_allowed()
from io_uring_allowed() and while we are at it return error codes
from io_uring_allowed() instead of true/false.

Cc: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Hamza Mahfooz <hamzamahfooz@linux.microsoft.com>
---
 io_uring/io_uring.c | 21 ++++++++++++++-------
 1 file changed, 14 insertions(+), 7 deletions(-)

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
-- 
2.47.1


