Return-Path: <io-uring+bounces-12507-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id cLO7G1+MpWmoDgYAu9opvQ
	(envelope-from <io-uring+bounces-12507-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Mon, 02 Mar 2026 14:10:55 +0100
X-Original-To: lists+io-uring@lfdr.de
Received: from sto.lore.kernel.org (sto.lore.kernel.org [172.232.135.74])
	by mail.lfdr.de (Postfix) with ESMTPS id 199031D9851
	for <lists+io-uring@lfdr.de>; Mon, 02 Mar 2026 14:10:55 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sto.lore.kernel.org (Postfix) with ESMTP id 561F03004D23
	for <lists+io-uring@lfdr.de>; Mon,  2 Mar 2026 13:10:53 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 652BC3B3C0D;
	Mon,  2 Mar 2026 13:10:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="bhCAj50J"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-wm1-f44.google.com (mail-wm1-f44.google.com [209.85.128.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9F34B3E0C6A
	for <io-uring@vger.kernel.org>; Mon,  2 Mar 2026 13:10:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772457052; cv=none; b=sKBuaSXa88Gst0CsH35PSYrlp7Jz1BaTNL1wGPudhD4Dx+/1jMO2DVe8eaORexDzpqiWiA2ZD+vtpqhA6X5SqJEHtpPnAglcAqmddGgc8hNIUqjfGQVLJ6Q1RJJdlWgWTHLDVe/aOZkoqFy5flC1oJDIdgDbL7tJ4+BkIT0O/dQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772457052; c=relaxed/simple;
	bh=bYLWyXHpKY1ET/S30DP/JomxzxNzhRal+u18QRUvLV8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=M8shmn/11b0Iz0T9Al0Srm3Qw1nbSFHH7HlyikgMO1kB4sskdIoaER5F/oKzkxc0h07H3kKG3iQok+SkH4buskZ8CES0KrOKHvCJZAi/AIWznPtqSEWMDIFtv1d3y1kVS/Ce0QdtL8r3ObisuhPC3tNzoKM9DAhG/MzIV3xn/d0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=bhCAj50J; arc=none smtp.client-ip=209.85.128.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-wm1-f44.google.com with SMTP id 5b1f17b1804b1-48375f1defeso33316225e9.0
        for <io-uring@vger.kernel.org>; Mon, 02 Mar 2026 05:10:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1772457048; x=1773061848; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=yyoHQY+Lz0QVHqDCT5jTklt4CnH40cXPTcVndum6Sxo=;
        b=bhCAj50JA2jOaElSqcLnaVmT91tbzSJP4yQIuiUIDV9KeWc7p4jBRb9R+iMM2cXeMN
         JK1Wk2+uRc4EZnNc7hYSC5BESuiH5WNNomGMh452JUVIjX8uqLikrjpwyI8OsfLOTA+C
         uZvkjrs+baLvQuzE/J6XArIIB/ejfzDuMqaddURlxe1nOvJseQEIirG0bcDj/GDdUPk7
         BtObXLL3hdYR3fpicrqTqFiM/BKBnrdviR0T1oyqZg5ty6eVxSdbPfr1qFGpOczhAcLg
         RQq3/egRpSXas84n2pCq8XpzABUYesDZvjlJr6g9IxtvkOLgHZEtgaJAm2VMJ5qk9w9z
         8GWw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1772457048; x=1773061848;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=yyoHQY+Lz0QVHqDCT5jTklt4CnH40cXPTcVndum6Sxo=;
        b=nYvU9p9EqokmD6uzGgrHNrvXD08X7vwe9qcr9g7S+BoI9F8lcuL87Gz6hvozewhpf4
         hquB7riHNk2Eq3nbNC4mIdCNXO3DbIZJoWTZifxpuUHF8lq3uTNEtg8Bt0/eoiORNCFU
         rY9nF09PS1y2nQr9PuraOa3/Js8wwlwA21vZMqjYEAnPB6gcP97+vyYBVGaTTlEB7n/R
         YArM+3T6yRcZ4QeWw5RE2wRxZ1ax5z3VeDIbTvu8gaLjW9hlbPRSDtRGOTVJJz4Sg4V4
         YI3+LJHcyf5kYrd+9Nsy+djb9Vbg689VhbPZdRC8geOdyGtB7VDABM9IJEqEx3bDet7D
         h5iA==
X-Gm-Message-State: AOJu0Yw4FlnPyFX7EPcBhqvF0LFJCF24QlFTV5S7reGcBj1Z81j90AH+
	HRrmzynR16udysIBuc0sAOnIyLnKNip/v1jSBigSUkjLiW2koEc72n3SmGhxEw==
X-Gm-Gg: ATEYQzy0+O2Y+lUjIYpFYdnY+HDCQ+XJXoJI9/3WLzl5IKY9/FH87RIri93JpC5x7cw
	G4UyBmcmdwtq8+9dJfmRkF9I5q1G5tDZowxHQ8ucZtyZJapsVMJt+CsyczdrlhrU0PWBSoWDYFt
	sBk1z1KxNH4VgRRDEdyc7Rm10ckQVIfKKnCy0YkEOf7SwVtG5FC6kq9Ix7/u/zUrjqLTwujZLwI
	/uGPVWFWUluz3bF/NYipjdvASK6K1DgD9Nly34BN4IA5zJP/c1KIN84FbS2GmMf3nEqvdKq/Eba
	SPajU9tYEIRKbDz17uZUa338Pu3IuuRVReoZ5E+t6TXYqUdlsylA961WjbNwVjCUsnAG45ot4hp
	Eh7J8MGPMbQOxKUIrWb3eOdrz7O96dZ+EaABEF4OSmOTzDB1m/hJxa/OvTbQwrM//EeybHctWFZ
	547Phz/owDha3mpx0Xo0xZQbcOJgdSYVItsLy9PfFxbnxcFU3jjl2HcGCmtSf7p/MPnOaso9PNA
	Po7sxQg9Q==
X-Received: by 2002:a05:600c:3b18:b0:483:b01c:9508 with SMTP id 5b1f17b1804b1-483c9bb7c0bmr227774885e9.2.1772457047316;
        Mon, 02 Mar 2026 05:10:47 -0800 (PST)
Received: from 127.com ([2620:10d:c092:600::1:cad2])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-483c3b346ccsm259935925e9.2.2026.03.02.05.10.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 02 Mar 2026 05:10:46 -0800 (PST)
From: Pavel Begunkov <asml.silence@gmail.com>
To: io-uring@vger.kernel.org
Cc: asml.silence@gmail.com,
	axboe@kernel.dk
Subject: [PATCH v3 4/4] io_uring/timeout: immediate timeout arg
Date: Mon,  2 Mar 2026 13:10:37 +0000
Message-ID: <765bd569bef00d8bb9c38ca4807f72775b317742.1772456786.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <cover.1772456786.git.asml.silence@gmail.com>
References: <cover.1772456786.git.asml.silence@gmail.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-1.66 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[gmail.com,none];
	R_MISSING_CHARSET(0.50)[];
	R_SPF_ALLOW(-0.20)[+ip4:172.232.135.74:c];
	R_DKIM_ALLOW(-0.20)[gmail.com:s=20230601];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	MIME_TRACE(0.00)[0:+];
	DKIM_TRACE(0.00)[gmail.com:+];
	TAGGED_FROM(0.00)[bounces-12507-lists,io-uring=lfdr.de];
	FORGED_SENDER_MAILLIST(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	FREEMAIL_CC(0.00)[gmail.com,kernel.dk];
	RCVD_TLS_LAST(0.00)[];
	RCPT_COUNT_THREE(0.00)[3];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	FREEMAIL_FROM(0.00)[gmail.com];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[asmlsilence@gmail.com,io-uring@vger.kernel.org];
	FROM_HAS_DN(0.00)[];
	ASN(0.00)[asn:63949, ipnet:172.232.128.0/19, country:SG];
	RCVD_COUNT_FIVE(0.00)[5];
	NEURAL_HAM(-0.00)[-1.000];
	TO_DN_NONE(0.00)[];
	TAGGED_RCPT(0.00)[io-uring];
	MID_RHS_MATCH_FROM(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sto.lore.kernel.org:helo,sto.lore.kernel.org:rdns]
X-Rspamd-Queue-Id: 199031D9851
X-Rspamd-Action: no action

One the things the user has always keep in mind is that any user
pointers they put into an SQE is not going to be read by the kernel
until submission happens, and the user has to ensure the pointee stays
alive until then. For example, snippet below will lead to UAF of the on
stack variable ts. Instead of passing the timeout value as a pointer
allow to store it immediately in the SQE. The user has to set a new flag
called IORING_TIMEOUT_IMMEDIATE_ARG, in which case sqe->addr for timeout
or sqe->addr2 for timeout update requests will be interpreted as a time
value in nanosecods.

void prep_timeout(struct io_uring_sqe *sqe) {
    struct __kernel_timespec ts = {...};
    prep_timeout(sqe, &ts);
}

void submit() {
    sqe = get_sqe();
    prep_timeout(sqe);
    io_uring_submit();
}

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 include/uapi/linux/io_uring.h |  5 +++++
 io_uring/timeout.c            | 20 +++++++++++++++-----
 2 files changed, 20 insertions(+), 5 deletions(-)

diff --git a/include/uapi/linux/io_uring.h b/include/uapi/linux/io_uring.h
index 17475c2045fb..17ac1b785440 100644
--- a/include/uapi/linux/io_uring.h
+++ b/include/uapi/linux/io_uring.h
@@ -343,6 +343,10 @@ enum io_uring_op {
 
 /*
  * sqe->timeout_flags
+ *
+ * IORING_TIMEOUT_IMMEDIATE_ARG:	If set, sqe->addr stores the timeout
+ *					value in nanoseconds instead of
+ *					pointing to a timespec.
  */
 #define IORING_TIMEOUT_ABS		(1U << 0)
 #define IORING_TIMEOUT_UPDATE		(1U << 1)
@@ -351,6 +355,7 @@ enum io_uring_op {
 #define IORING_LINK_TIMEOUT_UPDATE	(1U << 4)
 #define IORING_TIMEOUT_ETIME_SUCCESS	(1U << 5)
 #define IORING_TIMEOUT_MULTISHOT	(1U << 6)
+#define IORING_TIMEOUT_IMMEDIATE_ARG	(1U << 7)
 #define IORING_TIMEOUT_CLOCK_MASK	(IORING_TIMEOUT_BOOTTIME | IORING_TIMEOUT_REALTIME)
 #define IORING_TIMEOUT_UPDATE_MASK	(IORING_TIMEOUT_UPDATE | IORING_LINK_TIMEOUT_UPDATE)
 /*
diff --git a/io_uring/timeout.c b/io_uring/timeout.c
index 4b67746ea3ca..8eddf8add7a2 100644
--- a/io_uring/timeout.c
+++ b/io_uring/timeout.c
@@ -35,10 +35,17 @@ struct io_timeout_rem {
 	bool				ltimeout;
 };
 
-static int io_parse_user_time(ktime_t *time, u64 arg)
+static int io_parse_user_time(ktime_t *time, u64 arg, unsigned flags)
 {
 	struct timespec64 ts;
 
+	if (flags & IORING_TIMEOUT_IMMEDIATE_ARG) {
+		*time = ns_to_ktime(arg);
+		if (*time < 0)
+			return -EINVAL;
+		return 0;
+	}
+
 	if (get_timespec64(&ts, u64_to_user_ptr(arg)))
 		return -EFAULT;
 	if (ts.tv_sec < 0 || ts.tv_nsec < 0)
@@ -475,9 +482,11 @@ int io_timeout_remove_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)
 			return -EINVAL;
 		if (tr->flags & IORING_LINK_TIMEOUT_UPDATE)
 			tr->ltimeout = true;
-		if (tr->flags & ~(IORING_TIMEOUT_UPDATE_MASK|IORING_TIMEOUT_ABS))
+		if (tr->flags & ~(IORING_TIMEOUT_UPDATE_MASK |
+				  IORING_TIMEOUT_ABS |
+				  IORING_TIMEOUT_IMMEDIATE_ARG))
 			return -EINVAL;
-		ret = io_parse_user_time(&tr->time, READ_ONCE(sqe->addr2));
+		ret = io_parse_user_time(&tr->time, READ_ONCE(sqe->addr2), tr->flags);
 		if (ret)
 			return ret;
 	} else if (tr->flags) {
@@ -545,7 +554,8 @@ static int __io_timeout_prep(struct io_kiocb *req,
 	flags = READ_ONCE(sqe->timeout_flags);
 	if (flags & ~(IORING_TIMEOUT_ABS | IORING_TIMEOUT_CLOCK_MASK |
 		      IORING_TIMEOUT_ETIME_SUCCESS |
-		      IORING_TIMEOUT_MULTISHOT))
+		      IORING_TIMEOUT_MULTISHOT |
+		      IORING_TIMEOUT_IMMEDIATE_ARG))
 		return -EINVAL;
 	/* more than one clock specified is invalid, obviously */
 	if (hweight32(flags & IORING_TIMEOUT_CLOCK_MASK) > 1)
@@ -574,7 +584,7 @@ static int __io_timeout_prep(struct io_kiocb *req,
 	data->req = req;
 	data->flags = flags;
 
-	ret = io_parse_user_time(&data->time, READ_ONCE(sqe->addr));
+	ret = io_parse_user_time(&data->time, READ_ONCE(sqe->addr), flags);
 	if (ret)
 		return ret;
 
-- 
2.53.0


