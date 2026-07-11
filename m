Return-Path: <io-uring+bounces-13972-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by mail.lfdr.de with LMTP
	id roXmLmIeUmq1MAMAu9opvQ
	(envelope-from <io-uring+bounces-13972-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Sat, 11 Jul 2026 12:43:46 +0200
X-Original-To: lists+io-uring@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [IPv6:2600:3c04:e001:36c::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 6F195741471
	for <lists+io-uring@lfdr.de>; Sat, 11 Jul 2026 12:43:46 +0200 (CEST)
Authentication-Results: mail.lfdr.de;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=Fe3AVo2Q;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (mail.lfdr.de: domain of "io-uring+bounces-13972-lists+io-uring=lfdr.de@vger.kernel.org" designates 2600:3c04:e001:36c::12fc:5321 as permitted sender) smtp.mailfrom="io-uring+bounces-13972-lists+io-uring=lfdr.de@vger.kernel.org";
	arc=pass ("subspace.kernel.org:s=arc-20240116:i=1")
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id C7F063064ABC
	for <lists+io-uring@lfdr.de>; Sat, 11 Jul 2026 10:41:22 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 98BC33BB67F;
	Sat, 11 Jul 2026 10:41:21 +0000 (UTC)
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ej1-f53.google.com (mail-ej1-f53.google.com [209.85.218.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C18532FE05C
	for <io-uring@vger.kernel.org>; Sat, 11 Jul 2026 10:41:19 +0000 (UTC)
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783766481; cv=none; b=ZSzIeP+dItp+jAcpEnWTcwLQKI/8n8oW5bUBdztc0dUIvXe8GEp/9ie1rJorKrQW+1reIDIn5KU/QPG5RvgDU3SEZ/qRrBEktLoOxydrnMEOm55Ks+RzyDc5ggRdsab7mnF50nh6nUbSBpoXsP6GqoCCd5RYCwMHWMEunMabpyg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783766481; c=relaxed/simple;
	bh=sf7h6e3qIuOu45i4wFaRlSo5EyFdR4r98W7HHSFyDYw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=khlW0/ddxj/F00s7Qr6yjzf3FGCmdPaYybwBDTiBmVDWRJhi1NO9Ds9Il7Lc/Szodu5/HmWNVPDaE7YpKivyWu1oLhwe0HxadqwD5T/cF6/mp8dVchIs3pNfAF1uZKsxIbOzL10mDuF8IJ+BfmOzjFK4scB/PMvzZr2WL3Xlvm4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Fe3AVo2Q; arc=none smtp.client-ip=209.85.218.53
Received: by mail-ej1-f53.google.com with SMTP id a640c23a62f3a-c12614b81c9so322559166b.3
        for <io-uring@vger.kernel.org>; Sat, 11 Jul 2026 03:41:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1783766478; x=1784371278; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=D7p9Vw0p1ikWeSXT0qG5mOPHIKFYKdDBHqfgF5TTIVI=;
        b=Fe3AVo2QYGif6mFZtaOvFphdYVl96Gduh7GAEDAqcui/Ol/LTjny8m+l9FS54MafNo
         ocdfJ4JiGfHZoSJ2ZhKFYBWwyhClGcMaQJGCftVnQ8IFG5OOWXmRgCHmzE2z3Mki3Lfx
         YP94MzTDReiifZyPpQLcO0YsBE46T0sqxz3NOwUZi9wCf+TM67X0jDQXqAR9qetrAdIA
         kN7U4imu8VN6U/w9FAO8oZeyZ0TT6iQuspAxnXJDYZhcITwGXKFQjo9SHIDHxmttLBpH
         JMaFVDJ3luwicvXhsJL1gsqIvUpxebfoV8z8Eil/SAgq9vXMy8M4HHcL/cAONPQ0Df+A
         23yA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1783766478; x=1784371278;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=D7p9Vw0p1ikWeSXT0qG5mOPHIKFYKdDBHqfgF5TTIVI=;
        b=cYFCZgX68VLjY1JmD7VVCYim+gEwtjAW8XZH/xa2ZR6C7Iy04s+oNFjmkt6EZ6sjZW
         kCn4C+/FW5rn6N7IwE8lv/La6NypW1v/f/HTNX7LqTIhEt6HJ1A3eyhyFiMl6gSvv4Rl
         l4BdRg1QSBXZYLOx95wIjtoF0FxX6b6HUv63c+246/bR0OmSan3mFn4+Za7BHix3FmHG
         CUk7jFBZ36CJiLCso1oT7qjWnLbYDAcVDGVA++Q0F7RsfTzSgFbrI633xN9WO1f27L6k
         mDdzfzRImq8XG7g79sARPvSuc/vIsxqcpvPToDmMPvHCwsaHyLAAPAaiKPd4eSwPhp8a
         pWGA==
X-Gm-Message-State: AOJu0YzmbKF6CoJZc7Qp325mJrMK26niyiaRArznrGCY9f4VO48vYh6h
	KCwT8VEhSix/3w2L+6CguqmXT1I28uE+RfAtOjCYvTtGrmFNmfzPtfYxbh/hIw==
X-Gm-Gg: AfdE7cl4hzQzHA5j9ajACy7GbR/ArK2ahuY3LFIPk5TAOJOSkXHPrOgUkV85ySuw3B5
	ya+we1lHuZnX5m+U/lEBd+86bneJf4N1eMUVttEjdQjOaZDSIoXbrx3gYVZCm6apVCAKMQjV1pJ
	V196xMSEi056CHT4ih+d7jrjLw/jBBQ63Dq6PVugh5MnoDcCkzuUUbWJOWzjNnx2pUq0LVdmF/d
	hMGvG47nqmym8qdAiGcuQUVG0LZrEB3YjVPcJBvGTwZtplNcaEQpiSuV6v5BhpXslcOjLW9VtqM
	8Pc44xiaa+XwsRqEwuRlSTV/4Wz5p4kJU5q3tEcWSP7mC4BRCfpoMHwt07KAmmwFpgTZpagTgJg
	WvPlouyde8BvQaSFpaZVZqvPIdFs7A+h8Yt7fmlHgHg33nQ1zv089kh6FRCIEtdSKiIDOXr8qnt
	08/62qsyA2A6OOT78a/8cDi6D6K9+RAXp+Y1pRWpB5EErAauWkx817tQNeKVJQRWtzC5I2sZhuG
	1DN/7KC+j4ETm65kOGJ12O0oLyXfwc0lPZxquKLR/oUwCsmrw==
X-Received: by 2002:a17:907:cf87:b0:c12:cacc:92c6 with SMTP id a640c23a62f3a-c161f4bf9bdmr106398566b.59.1783766478283;
        Sat, 11 Jul 2026 03:41:18 -0700 (PDT)
Received: from 127.0.0.1localhost (82-132-222-132.dab.02.net. [82.132.222.132])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-c15d5de95e6sm483041566b.39.2026.07.11.03.41.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 11 Jul 2026 03:41:16 -0700 (PDT)
From: Pavel Begunkov <asml.silence@gmail.com>
To: io-uring@vger.kernel.org
Cc: asml.silence@gmail.com,
	netdev@vger.kernel.org
Subject: [PATCH review-only 15/17] io_uring/zcrx: add dynamic area creation
Date: Sat, 11 Jul 2026 11:40:08 +0100
Message-ID: <9dbb082763ba53ee6f2ceda51772ed9f6ca72383.1783616211.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <cover.1783616211.git.asml.silence@gmail.com>
References: <cover.1783616211.git.asml.silence@gmail.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Action: no action
X-Spamd-Result: default: False [-1.66 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[gmail.com,none];
	R_MISSING_CHARSET(0.50)[];
	R_DKIM_ALLOW(-0.20)[gmail.com:s=20251104];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c04:e001:36c::/64:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-13972-lists,io-uring=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	FREEMAIL_CC(0.00)[gmail.com,vger.kernel.org];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FORGED_RECIPIENTS(0.00)[m:io-uring@vger.kernel.org,m:asml.silence@gmail.com,m:netdev@vger.kernel.org,m:asmlsilence@gmail.com,s:lists@lfdr.de];
	FORGED_SENDER(0.00)[asmlsilence@gmail.com,io-uring@vger.kernel.org];
	MIME_TRACE(0.00)[0:+];
	FROM_HAS_DN(0.00)[];
	FORWARDED(0.00)[lists@lfdr.de];
	FORGED_SENDER_MAILLIST(0.00)[];
	DKIM_TRACE(0.00)[gmail.com:+];
	ASN(0.00)[asn:63949, ipnet:2600:3c04::/32, country:SG];
	FROM_NEQ_ENVFROM(0.00)[asmlsilence@gmail.com,io-uring@vger.kernel.org];
	TO_DN_NONE(0.00)[];
	ALIAS_RESOLVED(0.00)[];
	RCVD_COUNT_FIVE(0.00)[5];
	FORGED_SENDER_FORWARDING(0.00)[];
	RCPT_COUNT_THREE(0.00)[3];
	MID_RHS_MATCH_FROM(0.00)[];
	TAGGED_RCPT(0.00)[io-uring];
	FORGED_RECIPIENTS_FORWARDING(0.00)[];
	FREEMAIL_FROM(0.00)[gmail.com];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[vger.kernel.org:from_smtp,tor.lore.kernel.org:helo,tor.lore.kernel.org:rdns]
X-Rspamd-Server: lfdr
X-Rspamd-Queue-Id: 6F195741471

It's not always possible for the user to predict during registration how
much memory zcrx will need to sustain the traffic. Allow to dynamically
add more areas with a new ctrl code ZCRX_CTRL_ADD_AREA.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 include/uapi/linux/io_uring/zcrx.h |  7 +++
 io_uring/zcrx.c                    | 84 +++++++++++++++++++++++++-----
 2 files changed, 79 insertions(+), 12 deletions(-)

diff --git a/include/uapi/linux/io_uring/zcrx.h b/include/uapi/linux/io_uring/zcrx.h
index 15c05c45ce36..08cdb173b04b 100644
--- a/include/uapi/linux/io_uring/zcrx.h
+++ b/include/uapi/linux/io_uring/zcrx.h
@@ -116,6 +116,7 @@ enum zcrx_ctrl_op {
 	ZCRX_CTRL_FLUSH_RQ,
 	ZCRX_CTRL_EXPORT,
 	ZCRX_CTRL_ARM_NOTIFICATION,
+	ZCRX_CTRL_ADD_AREA,
 
 	__ZCRX_CTRL_LAST,
 };
@@ -134,6 +135,11 @@ struct zcrx_ctrl_arm_notif {
 	__u32		__resv[11];
 };
 
+struct zcrx_ctrl_add_area {
+	__u64		area_ptr; /* pointer to struct io_uring_zcrx_area_reg */
+	__u64		__resv[5];
+};
+
 struct zcrx_ctrl {
 	__u32	zcrx_id;
 	__u32	op; /* see enum zcrx_ctrl_op */
@@ -143,6 +149,7 @@ struct zcrx_ctrl {
 		struct zcrx_ctrl_export		zc_export;
 		struct zcrx_ctrl_flush_rq	zc_flush;
 		struct zcrx_ctrl_arm_notif	zc_arm_notif;
+		struct zcrx_ctrl_add_area	zc_area;
 	};
 };
 
diff --git a/io_uring/zcrx.c b/io_uring/zcrx.c
index 3f61f942c393..f7592a3c058d 100644
--- a/io_uring/zcrx.c
+++ b/io_uring/zcrx.c
@@ -36,6 +36,7 @@
 #define ZCRX_REFILL_CAP MIN(64 * ZCRX_MAX_FRAGS_PER_PAGE, 1024)
 
 #define IO_ZCRX_AREA_SUPPORTED_FLAGS	(IORING_ZCRX_AREA_DMABUF)
+#define ZCRX_MAX_AREAS			1024
 
 #define IO_DMA_ATTR (DMA_ATTR_SKIP_CPU_SYNC | DMA_ATTR_WEAK_ORDERING)
 
@@ -46,7 +47,7 @@ static inline u64 zcrx_area_id_to_token(u32 area_id)
 
 static inline u32 zcrx_next_area_id(struct io_zcrx_ifq *zcrx)
 {
-	return zcrx->nr_areas;
+	return READ_ONCE(zcrx->nr_areas);
 }
 
 static inline struct io_zcrx_ifq *io_pp_to_ifq(struct page_pool *pp)
@@ -295,8 +296,6 @@ static int io_import_area(struct io_zcrx_ifq *ifq,
 
 	if (area_reg->flags & ~IO_ZCRX_AREA_SUPPORTED_FLAGS)
 		return -EINVAL;
-	if (area_reg->rq_area_token)
-		return -EINVAL;
 	if (area_reg->__resv2[0] || area_reg->__resv2[1])
 		return -EINVAL;
 
@@ -311,15 +310,11 @@ static int io_import_area(struct io_zcrx_ifq *ifq,
 	return io_import_umem(ifq, mem, area_reg);
 }
 
-static void io_zcrx_unmap_area(struct io_zcrx_ifq *ifq,
-				struct io_zcrx_area *area)
+static void __io_zcrx_unmap_area(struct io_zcrx_ifq *ifq,
+				 struct io_zcrx_area *area)
 {
 	int i;
 
-	if (!area)
-		return;
-
-	guard(mutex)(&ifq->pp_lock);
 	if (!area->is_mapped)
 		return;
 	area->is_mapped = false;
@@ -337,6 +332,15 @@ static void io_zcrx_unmap_area(struct io_zcrx_ifq *ifq,
 	}
 }
 
+static void io_zcrx_unmap_area(struct io_zcrx_ifq *ifq,
+				struct io_zcrx_area *area)
+{
+	if (!area)
+		return;
+	guard(mutex)(&ifq->pp_lock);
+	__io_zcrx_unmap_area(ifq, area);
+}
+
 static void io_zcrx_unmap_areas(struct io_zcrx_ifq *ifq)
 {
 	unsigned area_idx;
@@ -475,7 +479,9 @@ static int io_zcrx_append_area(struct io_zcrx_ifq *ifq,
 	struct io_zcrx_area **areas, **old_areas;
 	unsigned old_nr;
 
-	if (WARN_ON_ONCE(ifq->kern_readable != kern_readable))
+	if (ifq->kern_readable != kern_readable)
+		return -EINVAL;
+	if (ifq->nr_areas + 1 > ZCRX_MAX_AREAS)
 		return -EINVAL;
 	if (WARN_ON_ONCE(area->area_id != zcrx_next_area_id(ifq)))
 		return -EINVAL;
@@ -516,7 +522,7 @@ static int __zcrx_create_area(struct io_zcrx_ifq *ifq,
 			return -EINVAL;
 		buf_size_shift = ilog2(rx_buf_len);
 	}
-	if (WARN_ON_ONCE(ifq->niov_shift))
+	if (ifq->niov_shift && ifq->niov_shift != buf_size_shift)
 		return -EINVAL;
 	if (!ifq->dev && buf_size_shift != PAGE_SHIFT)
 		return -EOPNOTSUPP;
@@ -578,7 +584,7 @@ static int __zcrx_create_area(struct io_zcrx_ifq *ifq,
 	return 0;
 err:
 	if (area) {
-		io_zcrx_unmap_area(ifq, area);
+		__io_zcrx_unmap_area(ifq, area);
 		io_zcrx_free_area(ifq, area);
 	}
 	return ret;
@@ -1012,6 +1018,8 @@ int io_register_zcrx(struct io_ring_ctx *ctx,
 
 	if (copy_from_user(&area, u64_to_user_ptr(reg.area_ptr), sizeof(area)))
 		return -EFAULT;
+	if (area.rq_area_token)
+		return -EINVAL;
 
 	memset(&notif, 0, sizeof(notif));
 	if (reg.notif_desc && copy_from_user(&notif, u64_to_user_ptr(reg.notif_desc),
@@ -1074,6 +1082,8 @@ int io_register_zcrx(struct io_ring_ctx *ctx,
 			goto err;
 	}
 
+	WARN_ON_ONCE(!ifq->niov_shift);
+
 	reg.zcrx_id = id;
 
 	scoped_guard(mutex, &ctx->mmap_lock) {
@@ -1559,6 +1569,54 @@ static int zcrx_arm_notif(struct io_ring_ctx *ctx, struct io_zcrx_ifq *zcrx,
 	return 0;
 }
 
+static int zcrx_ctrl_add_area(struct io_ring_ctx *ctx, struct io_zcrx_ifq *ifq,
+			      struct zcrx_ctrl *ctrl)
+{
+	struct zcrx_ctrl_add_area *ctrl_add = &ctrl->zc_area;
+	struct io_uring_zcrx_area_reg __user *area_uptr;
+	struct io_uring_zcrx_area_reg area_reg;
+	struct io_zcrx_area *area = NULL;
+	int ret;
+
+	area_uptr = u64_to_user_ptr(ctrl_add->area_ptr);
+	if (copy_from_user(&area_reg, area_uptr, sizeof(area_reg)))
+		return -EFAULT;
+	if (!mem_is_zero(&ctrl_add->__resv, sizeof(ctrl_add->__resv)))
+		return -EINVAL;
+	if (area_reg.rq_area_token)
+		return -EINVAL;
+
+	while (true) {
+		u32 area_id = zcrx_next_area_id(ifq);
+
+		/*
+		 * It's hard to roll back append and page faults under
+		 * ->pp_lock is a bad idea. Grab and post an unstable area id
+		 * first, and then check-retry under the lock.
+		 */
+		area_reg.rq_area_token = zcrx_area_id_to_token(area_id);
+		if (copy_to_user(area_uptr, &area_reg, sizeof(area_reg)))
+			return -EFAULT;
+
+		guard(mutex)(&ifq->pp_lock);
+		if (area_id != zcrx_next_area_id(ifq))
+			continue;
+
+		ret = __zcrx_create_area(ifq, &area_reg, &area,
+					 1U << ifq->niov_shift, area_id);
+		if (ret)
+			break;
+
+		ret = io_zcrx_append_area(ifq, area);
+		if (ret)
+			__io_zcrx_unmap_area(ifq, area);
+		break;
+	}
+	if (ret && area)
+		io_zcrx_free_area(ifq, area);
+	return ret;
+}
+
 int io_zcrx_ctrl(struct io_ring_ctx *ctx, void __user *arg, unsigned nr_args)
 {
 	struct zcrx_ctrl ctrl;
@@ -1585,6 +1643,8 @@ int io_zcrx_ctrl(struct io_ring_ctx *ctx, void __user *arg, unsigned nr_args)
 		return zcrx_export(ctx, zcrx, &ctrl, arg);
 	case ZCRX_CTRL_ARM_NOTIFICATION:
 		return zcrx_arm_notif(ctx, zcrx, &ctrl);
+	case ZCRX_CTRL_ADD_AREA:
+		return zcrx_ctrl_add_area(ctx, zcrx, &ctrl);
 	}
 
 	return -EOPNOTSUPP;
-- 
2.54.0


