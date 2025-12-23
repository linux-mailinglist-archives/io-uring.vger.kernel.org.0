Return-Path: <io-uring+bounces-11253-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [IPv6:2600:3c04:e001:36c::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id E4293CD77EB
	for <lists+io-uring@lfdr.de>; Tue, 23 Dec 2025 01:36:35 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id 73E133017845
	for <lists+io-uring@lfdr.de>; Tue, 23 Dec 2025 00:36:31 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EC0921FCF41;
	Tue, 23 Dec 2025 00:36:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="BHlH4UOY"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pj1-f43.google.com (mail-pj1-f43.google.com [209.85.216.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5C1D41FE47B
	for <io-uring@vger.kernel.org>; Tue, 23 Dec 2025 00:36:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1766450190; cv=none; b=blBTikaMfwyaP7Txk7pwqBtvDXzIG0+EtZ827rYvwCJz1X18MZsB16mO0nZ/7oqEyyRDJR6zKQFP6gYtjdTaADyRcF1Ugpio3pAv0rzP7K0a7oBy7PbWkOJOfUfobTx2e2cfaohy0jLBRIRq489GF0+DbgukQqRpqIJm/9WQBvA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1766450190; c=relaxed/simple;
	bh=4BAaGievTtvkLoNgL0ZTdQZ2RPDEbM53T+cmtPTo8so=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PD+XYqZgNKg0txkLdIfnBF3KtpyLSpUT4NgqSjHaqEl4WBb9Wkp6K1/QV3AV6mlc6T2Hf+s+kKWnklu5DeIZsoYJ3HtSlMAine+mXCybb7vCfp1d+a0Va3THSXYDorr2jmg4oMr0KdbYTy8d+Ke5K3/sfbMzROxMfHIHEWjetVg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=BHlH4UOY; arc=none smtp.client-ip=209.85.216.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pj1-f43.google.com with SMTP id 98e67ed59e1d1-34ab8e0df53so4324923a91.3
        for <io-uring@vger.kernel.org>; Mon, 22 Dec 2025 16:36:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1766450188; x=1767054988; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=o+ENtiB+VRiuAX55mhgrey4moIu9hfBSn8/uNmk3lgI=;
        b=BHlH4UOYRXkpSKJAeFRa6TyGsT4/7sulwJFm5IDu2xDh81RDg8uzI6ZedumDOLOElR
         3l1gWFMhzXB9L/XUbiMaw2m9sH5a7ki3KPQfA3wEZVZjBQg0TiVhO4zqCRBivwPJV1hI
         1EcSlmw93aFkrGcNh+zliTq2q1gwt1ACDCgfgffLgrrZ1XadjfAb33OqQAGVUbHJMdI2
         /eE07C/iuoMqAubtGNsMwXTeG4JwawByisxT9qHYsHq1UIKnTYsEQywt9q7SXQExKmyJ
         0/QCWN51/l5lQ9Vp8tGg/4stXK5+os3lZze0GsADF/5VUOsVq4qD2ASHbj8lwzBBdhtZ
         0g9A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1766450188; x=1767054988;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=o+ENtiB+VRiuAX55mhgrey4moIu9hfBSn8/uNmk3lgI=;
        b=q+0XG8LFx/xgo40qIHBpA22/AUcQ2BgzZTb+udviQpfCzGQyZenNYO4Pjv+KrkuksL
         +ENLzeXJjlsYn/YOaswuk8oT85bXOkuo0kKnOPkgE5ySco4tnCHgqi0mI8wcbLEu2ZK1
         cmeAPrO1XR4RU0ldUjJycIHqB3KZ9weuwPWH8WqKw15Div90usWvhUL450GCZd0dxDo1
         OGBp+wMSfzks/Tm8545TnF22OFT2dyBGcpvwkEIv5eCg377xZCp11kIqozbsva25FbnC
         cKR8DTSv5IS3VIglBT5cG+0gG5816QlryUnR/gAl7wZKgDVNeR/9pzFCPLyq+7TMfvsS
         h26A==
X-Forwarded-Encrypted: i=1; AJvYcCXgvOCy7Lb9ldUkm8tp0+90zm2PSYLjwavYfz/27IZH2iFTdP0D7YNgvVafkdlQDhmvbjsJV1h6VA==@vger.kernel.org
X-Gm-Message-State: AOJu0YxgyYVPVqW2PVfj8eVQIJvce6VUpSy1oyXwuc3w6T4c15tr/HqK
	garFgIGWqNfTq9S1XBcnDLOKm0EJ59mB4qL/jXH1YEjtKBDVclYgMta0
X-Gm-Gg: AY/fxX4hBiAGZvbyqr55sho/ovwn2mE79FhfJKECOnb2WaASR7r5FH8WBX1WYBn3D+r
	DPBp9hU54gsFp6eGg1OyH/HB5Lci6dvZoURey8AqvbnZGHyWCyGkd/x5me8soy2v9Hgk6FiEWgq
	hc0jT+L3WpgVJOAYLggq/eXe8EFNPfgbGXEG09tn8Mh8n2xG7lS9LjSMpyUGQQISTZPoW1Nj0c8
	qzhwzdD4M4HaP4MNnlNyHqmIWr3vNSymdaCAgl3W5my2tSLeKLdh4ytmbpv322kkEEdhmaV9gK9
	q2RdvQNkEvhIXCuVJjfAjXYfnHlScGwr2DRY9mLyzkXNtFaOwVH4U7oFY6FPvFEB7/BCflmiVwD
	7i8b/A0SXpkidSB5XBtBWBveqVutKk6QRP0FqH98EFzanUJey1r2kxxE+1riAldgDMOb6vVnEDc
	l7F1/eZcZZUZF7DqA0jQ==
X-Google-Smtp-Source: AGHT+IHgUi6j/vR98IfxIAMRLvGFafv4XiQ2mXaRJzZ2yxwA6p6KyPV9EoArZQE91ncYnPKtNT+S7Q==
X-Received: by 2002:a05:6a21:3288:b0:35d:d477:a7d7 with SMTP id adf61e73a8af0-376a75ef3f1mr12678919637.7.1766450188602;
        Mon, 22 Dec 2025 16:36:28 -0800 (PST)
Received: from localhost ([2a03:2880:ff:41::])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2a2f3c6a80esm106804295ad.8.2025.12.22.16.36.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 22 Dec 2025 16:36:28 -0800 (PST)
From: Joanne Koong <joannelkoong@gmail.com>
To: miklos@szeredi.hu,
	axboe@kernel.dk
Cc: bschubert@ddn.com,
	asml.silence@gmail.com,
	io-uring@vger.kernel.org,
	csander@purestorage.com,
	xiaobing.li@samsung.com,
	linux-fsdevel@vger.kernel.org
Subject: [PATCH v3 02/25] io_uring/kbuf: rename io_unregister_pbuf_ring() to io_unregister_buf_ring()
Date: Mon, 22 Dec 2025 16:34:59 -0800
Message-ID: <20251223003522.3055912-3-joannelkoong@gmail.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20251223003522.3055912-1-joannelkoong@gmail.com>
References: <20251223003522.3055912-1-joannelkoong@gmail.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Use the more generic name io_unregister_buf_ring() as this function will
be used for unregistering both provided buffer rings and kernel-managed
buffer rings.

This is a preparatory change for upcoming kernel-managed buffer ring
support.

Signed-off-by: Joanne Koong <joannelkoong@gmail.com>
---
 io_uring/kbuf.c     | 2 +-
 io_uring/kbuf.h     | 2 +-
 io_uring/register.c | 2 +-
 3 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/io_uring/kbuf.c b/io_uring/kbuf.c
index 100367bb510b..cbe477db7b86 100644
--- a/io_uring/kbuf.c
+++ b/io_uring/kbuf.c
@@ -718,7 +718,7 @@ int io_register_pbuf_ring(struct io_ring_ctx *ctx, void __user *arg)
 	return 0;
 }
 
-int io_unregister_pbuf_ring(struct io_ring_ctx *ctx, void __user *arg)
+int io_unregister_buf_ring(struct io_ring_ctx *ctx, void __user *arg)
 {
 	struct io_uring_buf_reg reg;
 	struct io_buffer_list *bl;
diff --git a/io_uring/kbuf.h b/io_uring/kbuf.h
index bf15e26520d3..40b44f4fdb15 100644
--- a/io_uring/kbuf.h
+++ b/io_uring/kbuf.h
@@ -74,7 +74,7 @@ int io_provide_buffers_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe
 int io_manage_buffers_legacy(struct io_kiocb *req, unsigned int issue_flags);
 
 int io_register_pbuf_ring(struct io_ring_ctx *ctx, void __user *arg);
-int io_unregister_pbuf_ring(struct io_ring_ctx *ctx, void __user *arg);
+int io_unregister_buf_ring(struct io_ring_ctx *ctx, void __user *arg);
 int io_register_pbuf_status(struct io_ring_ctx *ctx, void __user *arg);
 
 bool io_kbuf_recycle_legacy(struct io_kiocb *req, unsigned issue_flags);
diff --git a/io_uring/register.c b/io_uring/register.c
index 62d39b3ff317..4c6879698844 100644
--- a/io_uring/register.c
+++ b/io_uring/register.c
@@ -750,7 +750,7 @@ static int __io_uring_register(struct io_ring_ctx *ctx, unsigned opcode,
 		ret = -EINVAL;
 		if (!arg || nr_args != 1)
 			break;
-		ret = io_unregister_pbuf_ring(ctx, arg);
+		ret = io_unregister_buf_ring(ctx, arg);
 		break;
 	case IORING_REGISTER_SYNC_CANCEL:
 		ret = -EINVAL;
-- 
2.47.3


