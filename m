Return-Path: <io-uring+bounces-12965-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id AKWMLQX20mmLcgcAu9opvQ
	(envelope-from <io-uring+bounces-12965-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Mon, 06 Apr 2026 01:53:41 +0200
X-Original-To: lists+io-uring@lfdr.de
Received: from sto.lore.kernel.org (sto.lore.kernel.org [IPv6:2600:3c09:e001:a7::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 5877F3A0505
	for <lists+io-uring@lfdr.de>; Mon, 06 Apr 2026 01:53:41 +0200 (CEST)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sto.lore.kernel.org (Postfix) with ESMTP id 7D7F53003D14
	for <lists+io-uring@lfdr.de>; Sun,  5 Apr 2026 23:53:39 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 510CB383C96;
	Sun,  5 Apr 2026 23:53:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="ex2I1O6F"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-wr1-f52.google.com (mail-wr1-f52.google.com [209.85.221.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B6995381B17
	for <io-uring@vger.kernel.org>; Sun,  5 Apr 2026 23:53:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775433216; cv=none; b=puadzGYH5yQ41YUJ2rFsIW6fe/OC6J9IMNqwfrMiKl9chCessgB74Dvq+AaR0M82Na7V0s1HkyqZd4oBMdDkpkVwew0/ErGmcfmN4lRGnptIfy9aRRfBc5aQWX/3LvISbwEdlYj1qb/OyllphiuIwUYZfn1WKNuuDyEJ2qVh4g0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775433216; c=relaxed/simple;
	bh=Yj0hD69zan3jXoQa+KU3ZuqYzZkT2re7up7IKvAvly8=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=d2JS7Hws80yJ8Fj/PFhOJp0m1qKiYipFZGySOtL/qZNsfUYnrnvOwuuqKgqq2fH8m0tMLrGZ7eOO5eKboO8a/oLnaIXe0vYa18CjHLoa+tUd9onpGfGGvpwptEnvmMk5GmCaeEp+MtoUC2rr7pDoNSHX5cPeYbvjwG+ybuHxYR8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=ex2I1O6F; arc=none smtp.client-ip=209.85.221.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-wr1-f52.google.com with SMTP id ffacd0b85a97d-43cfb723698so3158294f8f.3
        for <io-uring@vger.kernel.org>; Sun, 05 Apr 2026 16:53:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1775433213; x=1776038013; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=+o8SlLfQNJf2zGSX+T9XxW7oHeUb1Mk1jVVU90cHf6g=;
        b=ex2I1O6FOARnHA4VjrQ6hW3vWmfratct83ejU16KTAOTBA+OdSqGSPJlpkbt++hy8t
         OxsVCC+syYG+D/eyCBhTj1zTRuqY798V1t9HE63eVwZSKLh1QYjcFtSlH2NlsuUNAN9q
         ZOGHpA2jq9g/WehP0uYZ8YVCLvYvrb5W6vyqJR7ZSa93fwkYxi7nOTOOvE57uDbfF3ym
         BJIQzAAONhmIvEsNVImc1iAyOdJeRaNe6ig/2Eyqnbz4y2b5FC6P3xJDs7JB/te5dAYY
         POzt/oudtiJyi70duY+2BaYmbtga9UYX4QYEvGdQSrSPI5xpaSCz2XH+QEkugCBhYiK0
         mHKg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1775433213; x=1776038013;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=+o8SlLfQNJf2zGSX+T9XxW7oHeUb1Mk1jVVU90cHf6g=;
        b=nXyL8w5p5SqPZRXEpu4a3tPCoTN1Ifvf+MSVpA7qDS2cGibVaiGNS4mEtZsKS07k4S
         qvTU8B9tyyyBhhDSmfdmBn6tnSqgtI4buyzbpQwozpjJGVPChpHQIo8MMUx1LXhtEq2V
         8zgn7DqHxzXQ8DClpzMjLTqhEgZScR6SRusNkvGCDBkpPFHyezKo5beGt8L/4Lk6xnl2
         Aogm+WTZ57vTHV7DssWGdKAh27XvG3OaG8zW6Gjg1nIFeQQl5vv06yCE2i5YusswihKY
         EGN+jBL8StUNIgUb/H1IcrUBpvwI6tjc1d+Jk2S/73p5GfNfFxfUZHHdUfp+rcywdpCL
         LbWw==
X-Gm-Message-State: AOJu0Yx0KJpUR7SQe5pBy+t6g/R/T7/jTb/OamNvvFlJLdNasZT/eNr+
	+671IdWTt7zxuZPuxZaUWrg+Wr5wPnP76kiHdz3Sn/5prX0CdLpNSmvzR/33w0Pt0jc=
X-Gm-Gg: AeBDiev7vEemPVP/R2UdBdUNa478XE1rHw4JfHcVHgSISJxY7igTdcJZlxZAA7YLTN7
	IJK7diQGMA8mT8UDuc3G99ekyeKBCb789hkuCQdQG94gYZOeAc3yAmf49Q9bA2nIN5xS0OiZ6z6
	lpSdraKwRX0JqqUw4o7b/BWgSTYPZB7OwtLi3YRIKewSQHrGIVgybvpSaSD9sW4qLnJFxrB7/CO
	nT0X2jfT+4p2x4dg1ZD52pYu1oMEBfBk08/d5ZPI1p1YI4LEd4fw5JtQnpB4Mv3McMlERhttiGm
	3JYEAcXeRvhaZwGml12HgBvUn+cPkSS/dmYBA9dUpZzOX6LrtBFwj0xbP6RAzbDYnJTrzGboDr4
	ZGYpw2gq7npN0ylmj1Wl+sFsZha3JJAUJAyR9Lm7qgrH4iwyecujxasomgChf3xS468Fk6T1wq4
	TDkvYmKvi+NEh7/saIH43g1HFO/8FzjiDUDsUJXBYb63NpvhTzzvvwUGXfKLILSmKpcz8vOz+H0
	N/I/2y0vJDlPzFfW4rutMh+Da3yHgtLKmXCI0vR
X-Received: by 2002:a05:6000:1446:b0:43d:4c:22be with SMTP id ffacd0b85a97d-43d292d4789mr16005305f8f.36.1775433212609;
        Sun, 05 Apr 2026 16:53:32 -0700 (PDT)
Received: from localhost.localdomain (host86-175-208-130.range86-175.btcentralplus.com. [86.175.208.130])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-43d1e4d29bbsm36284485f8f.21.2026.04.05.16.53.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 05 Apr 2026 16:53:31 -0700 (PDT)
From: Bertie Tryner <bertietryner@gmail.com>
X-Google-Original-From: Bertie Tryner <Bertie.Tryner@warwick.ac.uk>
To: io-uring@vger.kernel.org
Cc: axboe@kernel.dk,
	asml.silence@gmail.com,
	Bertie Tryner <Bertie.Tryner@warwick.ac.uk>
Subject: [PATCH] io_uring/zcrx: reorder fd allocation and disclosure in zcrx_export()
Date: Mon,  6 Apr 2026 00:53:30 +0100
Message-Id: <20260405235330.49287-1-Bertie.Tryner@warwick.ac.uk>
X-Mailer: git-send-email 2.39.5 (Apple Git-154)
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spamd-Result: default: False [-0.16 / 15.00];
	SUSPICIOUS_RECIPS(1.50)[];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	R_MISSING_CHARSET(0.50)[];
	DMARC_POLICY_ALLOW(-0.50)[gmail.com,none];
	R_DKIM_ALLOW(-0.20)[gmail.com:s=20251104];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c09:e001:a7::/64:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	MIME_TRACE(0.00)[0:+];
	TO_DN_SOME(0.00)[];
	FREEMAIL_CC(0.00)[kernel.dk,gmail.com,warwick.ac.uk];
	TAGGED_FROM(0.00)[bounces-12965-lists,io-uring=lfdr.de];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	ASN(0.00)[asn:63949, ipnet:2600:3c09::/32, country:SG];
	RCPT_COUNT_THREE(0.00)[4];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[bertietryner@gmail.com,io-uring@vger.kernel.org];
	FROM_HAS_DN(0.00)[];
	DKIM_TRACE(0.00)[gmail.com:+];
	RCVD_COUNT_FIVE(0.00)[5];
	TAGGED_RCPT(0.00)[io-uring];
	NEURAL_HAM(-0.00)[-1.000];
	FREEMAIL_FROM(0.00)[gmail.com];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sto.lore.kernel.org:helo,sto.lore.kernel.org:rdns,warwick.ac.uk:email,warwick.ac.uk:mid]
X-Rspamd-Queue-Id: 5877F3A0505
X-Rspamd-Action: no action
X-Rspamd-Server: lfdr

Currently, zcrx_export() allocates and discloses a file descriptor to
userspace before the backing file is successfully created. If file
creation fails, the fd is released back to the pool, but the number
has already been written to the user-provided control structure.

While this requires a misbehaving or racing userspace to trigger,
it is better practice to ensure the file descriptor is only
disclosed once the operation is guaranteed to succeed. This aligns
the ZCRX export logic with the standard patterns used in the VFS
layer and other fd-publishing paths.

Move the get_unused_fd_flags() and copy_to_user() calls to after
the file has been successfully created.

Signed-off-by: Bertie Tryner <Bertie.Tryner@warwick.ac.uk>
---
 io_uring/zcrx.c | 25 ++++++++++++++-----------
 1 file changed, 14 insertions(+), 11 deletions(-)

diff --git a/io_uring/zcrx.c b/io_uring/zcrx.c
index 262ac73..700eff9 100644
--- a/io_uring/zcrx.c
+++ b/io_uring/zcrx.c
@@ -637,19 +637,10 @@ static int zcrx_export(struct io_ring_ctx *ctx, struct io_zcrx_ifq *ifq,
 {
 	struct zcrx_ctrl_export *ce = &ctrl->zc_export;
 	struct file *file;
-	int fd = -1;
+	int fd;
 
 	if (!mem_is_zero(ce, sizeof(*ce)))
 		return -EINVAL;
-	fd = get_unused_fd_flags(O_CLOEXEC);
-	if (fd < 0)
-		return fd;
-
-	ce->zcrx_fd = fd;
-	if (copy_to_user(arg, ctrl, sizeof(*ctrl))) {
-		put_unused_fd(fd);
-		return -EFAULT;
-	}
 
 	refcount_inc(&ifq->refs);
 	refcount_inc(&ifq->user_refs);
@@ -657,11 +648,23 @@ static int zcrx_export(struct io_ring_ctx *ctx, struct io_zcrx_ifq *ifq,
 	file = anon_inode_create_getfile("[zcrx]", &zcrx_box_fops,
 					 ifq, O_CLOEXEC, NULL);
 	if (IS_ERR(file)) {
-		put_unused_fd(fd);
 		zcrx_unregister(ifq);
 		return PTR_ERR(file);
 	}
 
+	fd = get_unused_fd_flags(O_CLOEXEC);
+	if (fd < 0) {
+		fput(file);
+		return fd;
+	}
+
+	ce->zcrx_fd = fd;
+	if (copy_to_user(arg, ctrl, sizeof(*ctrl))) {
+		fput(file);
+		put_unused_fd(fd);
+		return -EFAULT;
+	}
+
 	fd_install(fd, file);
 	return 0;
 }
-- 
2.50.1 (Apple Git-155)


