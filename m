Return-Path: <io-uring+bounces-12952-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id sKJwFDz8z2nt2AYAu9opvQ
	(envelope-from <io-uring+bounces-12952-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Fri, 03 Apr 2026 19:43:24 +0200
X-Original-To: lists+io-uring@lfdr.de
Received: from sin.lore.kernel.org (sin.lore.kernel.org [IPv6:2600:3c15:e001:75::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 4EEE93971A4
	for <lists+io-uring@lfdr.de>; Fri, 03 Apr 2026 19:43:23 +0200 (CEST)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sin.lore.kernel.org (Postfix) with ESMTP id 3E987300E499
	for <lists+io-uring@lfdr.de>; Fri,  3 Apr 2026 17:42:11 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BF4703D413A;
	Fri,  3 Apr 2026 17:42:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="SsVyLL+k"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pj1-f49.google.com (mail-pj1-f49.google.com [209.85.216.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9498834DCD7
	for <io-uring@vger.kernel.org>; Fri,  3 Apr 2026 17:42:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775238128; cv=none; b=hbxy5gZabFew7Ihd/lre+DQmwH0M81TS0jbP14q57zRHG004gmNUYHOojIEZTpLBH+zTYn+pvOF1deh4IZ9VBGicuiFUQfh/SBsWl5bXhvxh0lnkxzTA8k6w0bbg7OGLRBGJDv8MUT2lHyweTcGj4H932Px4zQ9/KTmqPy6lnbw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775238128; c=relaxed/simple;
	bh=gfKhHJUI11DLjcj6PhddS2sI7BdAfgKbRKL6oU/bNgk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dhHf7bFuru0Ki+O+m4sbvoH8uUMs7iQGwcFl9ni/gVad+YDBOR4vNe6dsuUhGXQmpKnRMGTCiadUI5NDnSt/junOEDs7O0cGnWR4fIUIpM2kGW3Te2x7ESu+pJzQLGJwbQh5kwvLxu24jSICSGjbWuCGQ4+zc1i/rnXjPDxlh2o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=SsVyLL+k; arc=none smtp.client-ip=209.85.216.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pj1-f49.google.com with SMTP id 98e67ed59e1d1-358ed696623so896127a91.0
        for <io-uring@vger.kernel.org>; Fri, 03 Apr 2026 10:42:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1775238127; x=1775842927; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=iOggaTUNflj01KIBF0TGSGjs4eAoFfwHtVa5ls9Usgw=;
        b=SsVyLL+kmAQqaB/3VNaxSH8LeRDGquSACwYmhmgUUSRlXcHq+vgv/ZPjJbFnFS6MPB
         UG72bBvHgIDOjgBNY2Ngj3U+nakNZ7djl1vcVlPcrzP0XOyd05t8G2h4EHFigkx7N7xz
         mdoyy0ud9FcnO4r/bSP/jE0NmxafisBmU+JHS7EfOpORCapuch40aFwWHgzCwszLOP9u
         Avw/o2YNbUJ41QbD3GQflQu/WcXs8Y9VVCIaxri25dbOZvBMNonMdZpGMtvZcxThZ51o
         KVOwNBuQ+q5nhNGbU16uPjia+mBf/wOAc9SfEEVT/SF9wXPUjnp42A0pLBa/N/WksBbG
         TORQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1775238127; x=1775842927;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=iOggaTUNflj01KIBF0TGSGjs4eAoFfwHtVa5ls9Usgw=;
        b=BR0WIPnQhsNUc1dldWjZMuDRXsZyWZHGuEVM06oItjsi89+QQNQ4K4gVN6pVWSQPpO
         yVX7rqIYsT1A0jhLDkirvVCpMpoWTewSSXJlrAKwN4Z/+vNbcL0H2MrJOMuhO0R0vrX0
         ma1yfOQDgXO5ARiof44YICZbEE8xk8yVPJM8zPfCk//nooINUEUY5IfRJIfsWWTlXEOs
         BIOGuyb9aPNcfO4BYcKqg+6lh9fWKmBegJZc+xX+4nTrbO8xyVv4dita4K65hplkdr0q
         Geur/b6lopu8rFMujCTJjsgQlIzKnLxv3Qyc8EK42w7bEmo6orAk1YfXP0kaJuIpwNe5
         yMZw==
X-Forwarded-Encrypted: i=1; AJvYcCVpxNkD6g/ipYo5gL63/cTjS5vO0ECX9BuFKKZC8uTKoul3mwOxdJqqqdO7F3gkvJUlLsA5pvOmjg==@vger.kernel.org
X-Gm-Message-State: AOJu0YzIWtEJXqjB4KFK67A+D0uL5igiEOEPJqqnLXxuFJ0gGqMOVTFW
	ZvxnJC8Xo5rvCRxj4CrO0i9RZylZAPT05w8x39KP6zLkMbyqE12g8biumlhAkg==
X-Gm-Gg: AeBDietQ/ACRQLEQwHZbJkAueZOqG9XvTXrtpv2uDi/UJEaNcrqiQYDV9FUtjhJtVeH
	/SyiUNhxCLo7aoBndS9LrhtZboOJwfEB52iVYSkKHM/9Rk9+BxepVebY7q2tX89WXKKlCFU0H4S
	KlPTkFf4095Ejey1ElrZQcqPuM61iaJ5Ueo0ggCWynAX2MaBEdx9dXlAWTUQUYcXSOG316wEIMT
	Z4JDRFLYNN5VzDvofvlcZ48exTbImIwyiR8Wu/XRHYxztHCvXPtShjExwXXazstdMNm0M9ufpzA
	TTaF3gWG39tQELkbA2aEVKTez+qUuVSuRdtjTrcpOIJgYCzWotRKZYeb+Fv7Mj8dXeoT7kY/0jk
	vXT8ogJhZNX0aomMFK5Ypl4QAq0/P46TUjSBLdLsfqKlJmHnHNyysLs1QHc0sNNAVlehWIoJxLt
	SfTYryw7IlAJILlaonIxB29CFaPKOX
X-Received: by 2002:a17:90b:2b50:b0:35d:a559:5c1c with SMTP id 98e67ed59e1d1-35de660a07fmr3192980a91.0.1775238126845;
        Fri, 03 Apr 2026 10:42:06 -0700 (PDT)
Received: from localhost ([2a03:2880:ff:4d::])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-35de6a2325bsm940734a91.12.2026.04.03.10.42.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 03 Apr 2026 10:42:06 -0700 (PDT)
From: Joanne Koong <joannelkoong@gmail.com>
To: axboe@kernel.dk
Cc: csander@purestorage.com,
	io-uring@vger.kernel.org
Subject: [PATCH v6 4/4] io_uring/rsrc: rename and export IO_IMU_DEST / IO_IMU_SOURCE
Date: Fri,  3 Apr 2026 10:41:39 -0700
Message-ID: <20260403174139.3634824-5-joannelkoong@gmail.com>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260403174139.3634824-1-joannelkoong@gmail.com>
References: <20260403174139.3634824-1-joannelkoong@gmail.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spamd-Result: default: False [-0.66 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	MID_CONTAINS_FROM(1.00)[];
	DMARC_POLICY_ALLOW(-0.50)[gmail.com,none];
	R_MISSING_CHARSET(0.50)[];
	R_DKIM_ALLOW(-0.20)[gmail.com:s=20251104];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c15:e001:75::/64:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	RCVD_TLS_LAST(0.00)[];
	TAGGED_FROM(0.00)[bounces-12952-lists,io-uring=lfdr.de];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	RCVD_COUNT_FIVE(0.00)[5];
	RECEIVED_HELO_LOCALHOST(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	FROM_HAS_DN(0.00)[];
	MIME_TRACE(0.00)[0:+];
	FROM_NEQ_ENVFROM(0.00)[joannelkoong@gmail.com,io-uring@vger.kernel.org];
	RCPT_COUNT_THREE(0.00)[3];
	PRECEDENCE_BULK(0.00)[];
	NEURAL_HAM(-0.00)[-1.000];
	TO_DN_NONE(0.00)[];
	DKIM_TRACE(0.00)[gmail.com:+];
	TAGGED_RCPT(0.00)[io-uring];
	FREEMAIL_FROM(0.00)[gmail.com];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	ASN(0.00)[asn:63949, ipnet:2600:3c15::/32, country:SG];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sin.lore.kernel.org:helo,sin.lore.kernel.org:rdns]
X-Rspamd-Queue-Id: 4EEE93971A4
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
index 244392026c6d..7aee83e5ea0e 100644
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
index 079b37835833..e5fe68dbe9fc 100644
--- a/io_uring/io_uring.c
+++ b/io_uring/io_uring.c
@@ -3218,7 +3218,7 @@ static int __init io_uring_init(void)
 	io_uring_optable_init();
 
 	/* imu->dir is u8 */
-	BUILD_BUG_ON((IO_IMU_DEST | IO_IMU_SOURCE) > U8_MAX);
+	BUILD_BUG_ON((IO_BUF_DEST | IO_BUF_SOURCE) > U8_MAX);
 
 	/*
 	 * Allow user copy in the per-command field, which starts after the
diff --git a/io_uring/rsrc.c b/io_uring/rsrc.c
index 9283cbe99872..075f7c3a5387 100644
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


