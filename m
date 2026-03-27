Return-Path: <io-uring+bounces-12882-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id wD7XH2W+xmnoNwUAu9opvQ
	(envelope-from <io-uring+bounces-12882-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Fri, 27 Mar 2026 18:29:09 +0100
X-Original-To: lists+io-uring@lfdr.de
Received: from sto.lore.kernel.org (sto.lore.kernel.org [172.232.135.74])
	by mail.lfdr.de (Postfix) with ESMTPS id 276D33485A0
	for <lists+io-uring@lfdr.de>; Fri, 27 Mar 2026 18:29:09 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sto.lore.kernel.org (Postfix) with ESMTP id A5FC0307B94D
	for <lists+io-uring@lfdr.de>; Fri, 27 Mar 2026 17:27:18 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D2AFA3EF67D;
	Fri, 27 Mar 2026 17:27:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="brQLbJIQ"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pl1-f173.google.com (mail-pl1-f173.google.com [209.85.214.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 93D563EE1DA
	for <io-uring@vger.kernel.org>; Fri, 27 Mar 2026 17:27:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774632433; cv=none; b=lJGfbkvc/Y7V0Ir84oksojDDCG88Q2Or354qkxvWBV/8hw2DJIGD4U6WfSWCuzVaz8bqm/z3BLYYU/VEiKgBOELqCTuZs4NYBmMmIK0pwxjpLiM6Qo0xxxwMFQbcZhCv9e1sTgUSLhuCCcuyruMcDXk0yCqP7f1GVq6y0JiQgFU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774632433; c=relaxed/simple;
	bh=d5YExv8Y+Lk8RnkmcqoroYnjWltvpPz2KtOBqvpPcL4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qLfsDREY0A2YFeb5GTkScqOAzTm8A6i97I6PC3N97i1ZI7Ga+pwRBTqLOIKmeaGqdEDE9CtFaP10g964qhKm+9pdDX8Od/BvOXn/+Lw+QLAPns1B5KR5v19Ee2/amt1cyOumsHwr9wNOboz9VdY1aJcciv1lk2cWLt4e2PvlLEw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=brQLbJIQ; arc=none smtp.client-ip=209.85.214.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pl1-f173.google.com with SMTP id d9443c01a7336-2b0ba3bfe16so20480805ad.1
        for <io-uring@vger.kernel.org>; Fri, 27 Mar 2026 10:27:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1774632432; x=1775237232; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=MUS3bIrREsve/w2+HfX/jvGNTrwIj9OvdptgT8AMvDE=;
        b=brQLbJIQodHMDmtDDXum5fGKa7x6FShxji6m1XekY/zCOU6Y6EwmdLTQbYIh/a3Pav
         WZd7vsYKPVipJhxa5qJ2A/EdrP5+0OH8Pj28Wpfhu6snrtTYsdP7HXOI5P8zg7NKKX1E
         52gTQtgHIwGOAMBDPaJc9OlB+PvjYiJjI4ylVfb4woxg77ni2BXP/eefdM+b190m6NdE
         DF48Ut3XoMMgTNa3Y/rS8Dwtv380ZJ/HqAcFEr8Fbz7nksykIeYpiFro8QDvQ01lrSlk
         /paNHvP+TT80IJFYM5Qr6R+GTvDS3Q4h7ttELqqTyYRxUAqwrSAE2SDZZQNyHZpmH4VN
         +IVg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1774632432; x=1775237232;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=MUS3bIrREsve/w2+HfX/jvGNTrwIj9OvdptgT8AMvDE=;
        b=n+EpXkMfC+yfs38isBHfiQUYObYifklBGxnXNwx4uCZXzX0Igu5RN7U6Vy2YfclBnl
         98sFvucGR8X+8yS1H3Rne8Ynb1IKhlbNeipmLuHeO8zL8DI0FCofUEYPVY/Tx2ach9P1
         NA3DEtM5Mafmw700D6quHBAutEji73s/lrcsH3Mio4a+8LOU90PvovJgZElz4r0JQilA
         YdVkBDuPuf41fUB+YAZrE02aoJFcLZs30qqW5X6O2211fCFKRFMP1s9/rmu88mTt+ac1
         S4eGc6udPEtB2sNsOtHYnP2KRpf16Q+sc7TYU/Yq4Zv0eQroSsJ/GWovrL9+anjYgXAm
         dHFQ==
X-Forwarded-Encrypted: i=1; AJvYcCXQg9gGfX+zQwHdZBCiep/CKvg/qjDxoPN2E+dlbIfQn5A5vO1IBuR7EmhhRghhA/3Uf4d4hWfXvw==@vger.kernel.org
X-Gm-Message-State: AOJu0YxdhJW69tp/0iu4QxLZ6jdzmbdl2qT7DVOtA0qlD8iM6VQDImTN
	7ykThRUbzgyuawzEEEqblvpvL71YxhX0twGy0ZO+XGQwQGBoB9oLRh+P
X-Gm-Gg: ATEYQzyJsDWzXNIPhGtlkvqPJFrkuqj8785R1yMej4awOFt2KnMSBB+1DIc2D3ZQLgd
	KqaVDQp6kHlJXT225dg4fQBSJZhlyVVdCqhfgedBXMlxWpzEIRLPyHh00naEg4Dj4v9wpqiKA4o
	bqhvCeeR+32XeCVV/yzSQ8ZR6QmVFrhmWq0xsoceINdkYk7r/CXkYEzYIzOJWo4jQjajcXU5giq
	xvl1QXuepkwGddAiraPdsdqOW03jyC48CddgVDDI0AR4YjMmszFhikvagjrct/oCK+4wIkCz3TM
	95PcRKSgc18HRhVcARq6iV8xrm592WepcMGqDFKSxXnrctKYwizdt5S3s6FJn+6wuSlEPhHZsyK
	HYFu8VcfZ0OwKjwdH5GdtQjxFE9ky5+kWOQFJshkNeXR793eApNdljA8QDGhtX13yngnHdyzFxs
	AR/wh564ofQet2K5LMuw==
X-Received: by 2002:a17:902:d50a:b0:2b0:5ac2:9aa5 with SMTP id d9443c01a7336-2b0c48e8be1mr61631265ad.19.1774632431826;
        Fri, 27 Mar 2026 10:27:11 -0700 (PDT)
Received: from localhost ([2a03:2880:ff:47::])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2b0bc68914bsm70323385ad.0.2026.03.27.10.27.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 27 Mar 2026 10:27:11 -0700 (PDT)
From: Joanne Koong <joannelkoong@gmail.com>
To: axboe@kernel.dk
Cc: csander@purestorage.com,
	asml.silence@gmail.com,
	io-uring@vger.kernel.org
Subject: [PATCH v4 4/5] io_uring/rsrc: rename and export IO_IMU_DEST / IO_IMU_SOURCE
Date: Fri, 27 Mar 2026 10:26:30 -0700
Message-ID: <20260327172631.3380702-5-joannelkoong@gmail.com>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260327172631.3380702-1-joannelkoong@gmail.com>
References: <20260327172631.3380702-1-joannelkoong@gmail.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spamd-Result: default: False [0.84 / 15.00];
	SUSPICIOUS_RECIPS(1.50)[];
	MID_CONTAINS_FROM(1.00)[];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	R_MISSING_CHARSET(0.50)[];
	DMARC_POLICY_ALLOW(-0.50)[gmail.com,none];
	R_DKIM_ALLOW(-0.20)[gmail.com:s=20251104];
	R_SPF_ALLOW(-0.20)[+ip4:172.232.135.74:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	FREEMAIL_CC(0.00)[purestorage.com,gmail.com,vger.kernel.org];
	MIME_TRACE(0.00)[0:+];
	FORGED_SENDER_MAILLIST(0.00)[];
	TAGGED_FROM(0.00)[bounces-12882-lists,io-uring=lfdr.de];
	RECEIVED_HELO_LOCALHOST(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	ASN(0.00)[asn:63949, ipnet:172.232.128.0/19, country:SG];
	RCPT_COUNT_THREE(0.00)[4];
	PRECEDENCE_BULK(0.00)[];
	RCVD_COUNT_FIVE(0.00)[5];
	FROM_NEQ_ENVFROM(0.00)[joannelkoong@gmail.com,io-uring@vger.kernel.org];
	FROM_HAS_DN(0.00)[];
	DKIM_TRACE(0.00)[gmail.com:+];
	TO_DN_NONE(0.00)[];
	TAGGED_RCPT(0.00)[io-uring];
	NEURAL_HAM(-0.00)[-1.000];
	FREEMAIL_FROM(0.00)[gmail.com];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sto.lore.kernel.org:helo,sto.lore.kernel.org:rdns]
X-Rspamd-Queue-Id: 276D33485A0
X-Rspamd-Action: no action
X-Rspamd-Server: lfdr

Rename IO_IMU_DEST and IO_IMU_SOURCE to IO_BUF_DEST and IO_BUF_SOURCE
and export it so subsystems may use it.

This is needed by the io_buffer_register_bvec() path for callers who may
need the buffer to be both readable and writable.

Signed-off-by: Joanne Koong <joannelkoong@gmail.com>
---
 include/linux/io_uring_types.h | 5 +++++
 io_uring/io_uring.c            | 2 +-
 io_uring/rsrc.c                | 2 +-
 io_uring/rsrc.h                | 5 -----
 4 files changed, 7 insertions(+), 7 deletions(-)

diff --git a/include/linux/io_uring_types.h b/include/linux/io_uring_types.h
index 328c3c1e2a31..0f41f9351a78 100644
--- a/include/linux/io_uring_types.h
+++ b/include/linux/io_uring_types.h
@@ -44,6 +44,11 @@ enum io_uring_cmd_flags {
 	IO_URING_F_COMPAT		= (1 << 12),
 };
 
+enum {
+	IO_BUF_DEST	= 1 << ITER_DEST,
+	IO_BUF_SOURCE	= 1 << ITER_SOURCE,
+};
+
 struct iou_loop_params;
 
 struct io_wq_work_node {
diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
index 16122f877aed..b5debc615657 100644
--- a/io_uring/io_uring.c
+++ b/io_uring/io_uring.c
@@ -3215,7 +3215,7 @@ static int __init io_uring_init(void)
 	io_uring_optable_init();
 
 	/* imu->dir is u8 */
-	BUILD_BUG_ON((IO_IMU_DEST | IO_IMU_SOURCE) > U8_MAX);
+	BUILD_BUG_ON((IO_BUF_DEST | IO_BUF_SOURCE) > U8_MAX);
 
 	/*
 	 * Allow user copy in the per-command field, which starts after the
diff --git a/io_uring/rsrc.c b/io_uring/rsrc.c
index 039e3b30ff60..cf5638406a0c 100644
--- a/io_uring/rsrc.c
+++ b/io_uring/rsrc.c
@@ -820,7 +820,7 @@ static struct io_rsrc_node *io_sqe_buffer_register(struct io_ring_ctx *ctx,
 	imu->release = io_release_ubuf;
 	imu->priv = imu;
 	imu->flags = 0;
-	imu->dir = IO_IMU_DEST | IO_IMU_SOURCE;
+	imu->dir = IO_BUF_DEST | IO_BUF_SOURCE;
 	if (coalesced)
 		imu->folio_shift = data.folio_shift;
 	refcount_set(&imu->refs, 1);
diff --git a/io_uring/rsrc.h b/io_uring/rsrc.h
index cff0f8834c35..8d48195faf9d 100644
--- a/io_uring/rsrc.h
+++ b/io_uring/rsrc.h
@@ -23,11 +23,6 @@ struct io_rsrc_node {
 	};
 };
 
-enum {
-	IO_IMU_DEST	= 1 << ITER_DEST,
-	IO_IMU_SOURCE	= 1 << ITER_SOURCE,
-};
-
 enum {
 	IO_REGBUF_F_KBUF		= 1,
 };
-- 
2.52.0


