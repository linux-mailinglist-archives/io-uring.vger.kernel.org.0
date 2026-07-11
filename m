Return-Path: <io-uring+bounces-13944-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by mail.lfdr.de with LMTP
	id c6RnDWsKUmrjLQMAu9opvQ
	(envelope-from <io-uring+bounces-13944-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Sat, 11 Jul 2026 11:18:35 +0200
X-Original-To: lists+io-uring@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 812B674102E
	for <lists+io-uring@lfdr.de>; Sat, 11 Jul 2026 11:18:34 +0200 (CEST)
Authentication-Results: mail.lfdr.de;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=ivwaIDqL;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (mail.lfdr.de: domain of "io-uring+bounces-13944-lists+io-uring=lfdr.de@vger.kernel.org" designates 2600:3c0a:e001:db::12fc:5321 as permitted sender) smtp.mailfrom="io-uring+bounces-13944-lists+io-uring=lfdr.de@vger.kernel.org";
	arc=pass ("subspace.kernel.org:s=arc-20240116:i=1")
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id EB4A1302DF4B
	for <lists+io-uring@lfdr.de>; Sat, 11 Jul 2026 09:12:55 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A341E37FF42;
	Sat, 11 Jul 2026 09:12:55 +0000 (UTC)
X-Original-To: io-uring@vger.kernel.org
Received: from mail-wm1-f49.google.com (mail-wm1-f49.google.com [209.85.128.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EAE0A384CFF
	for <io-uring@vger.kernel.org>; Sat, 11 Jul 2026 09:12:53 +0000 (UTC)
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783761175; cv=none; b=IAjnafEy3Nfm7Q6vfLImWuZOw6y5ga9mbYbQa638Zji5JFTGxhpBVrhC7m6+7kP2NVsmVIpx2ecwBWhsqz0KPj0IgSL6k6PQZyMPplgSBzYJB4BlxMfw4QZaB4tM04KSoHWXMXiaeejnz5rvlbJyXXhrRsgiveqNfAnULIL04ZM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783761175; c=relaxed/simple;
	bh=sf7h6e3qIuOu45i4wFaRlSo5EyFdR4r98W7HHSFyDYw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Fi89KKYGbZXfN9Pfuu8uJk4xzrTKIvdoZ8tNMmIjWApd2iLEcqG2jVY2PKR/W2l2gkLjfNFeSOW3wGkK4/bUQrVIEZgNzknZiRkk+9C8MEbZZHG59DXP+cbkPiZwWc5DL5si3uNtyP7zQv9TH/kzo/lFJGWmo8yPpsHOzt97nZk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=ivwaIDqL; arc=none smtp.client-ip=209.85.128.49
Received: by mail-wm1-f49.google.com with SMTP id 5b1f17b1804b1-493b966dd74so6342985e9.3
        for <io-uring@vger.kernel.org>; Sat, 11 Jul 2026 02:12:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1783761172; x=1784365972; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=D7p9Vw0p1ikWeSXT0qG5mOPHIKFYKdDBHqfgF5TTIVI=;
        b=ivwaIDqL9ziTx1Hw33/w9iJ5jfNmPwrvTz22k9b1kZPC+nJcQ2mdIi44m8jmNv937G
         DoTswHQVR18WlrQ3bmSr/0bTOjfJsRW6gkzmu+iPw1mlPd4/O/iZ9NFVlN7CmQ3Erclr
         AvdI6b/PNZWyNj4Tl8e3j+ieIWGWoGOjVUkDamlTvr3ob1C5NY2WKr7hfybat/ePC/jH
         zrj5dr4KH5kKn+WYiV5yKSeIT6U95UAxcA4tPoyJbte/9VGDKbxVjRO6r0oH4kNa3IIM
         9vUhqTTW1+iFMp/lQQznV1UJDltmxBDS7WsDMZ/4OsrpwF9HBwtqRzrvvAWMPr8IBD6l
         jS7Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1783761172; x=1784365972;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=D7p9Vw0p1ikWeSXT0qG5mOPHIKFYKdDBHqfgF5TTIVI=;
        b=DW+5YPSZN3J1y9mJCBTv8TJB5D83GQcqbXE7AYZa3kZJCycoHZO7XWjP+44BJT6lZw
         825sR6/Ejudl74nyFgAn68TMMqxSgCvySFrubuy5DFDheWrr+dOohJcKBagMjqDld8wO
         yUKenmuXTFILn89HxW2a6ZmlppKTbK5qFIOk4Ko11MTedldX1QtKc2GATWWHZ5Lo8csG
         hrRQjAwkIg2rQXZj0K2B9aAePyrd5pYRar75s2ue4AVK/GciYzPaTJTqZsdnq9GAJ4hi
         eOKn823ld61ES4s2RiFSpNf35eIRd4nOQHtsMg1J2Bz36ZuxALXQtaVA37Eo0lWmbUR2
         +0hA==
X-Gm-Message-State: AOJu0YxqSevmTPqPhB5yJ6toZWztDMEMX13tjrRmL0R/qyD/15GbhDYB
	dMGE4hse4bgJb7MHHqAe0aiG9wljgUtZVnAGKTIm7Xm7JrK6jq8isOHKyUWa6Q==
X-Gm-Gg: AfdE7clrDSculEj5aeCZ/zigjYUztbWBjIFPZcw9tldD6qwYtGetsISwFWOd5cHyUOy
	DqBwViJ9p6Dt9IW1mUVddKmd7lswrBHiESG//qlzU1P9TTRBCwt8APNw0iD67WZP4tgpUpKHLu2
	ap/LZnaLNMUtcUqEvjKYoCjwa469r5lHaavBezSi+dtpWD//6dK6D1mEsdTC2R9SVP/55mgRA/J
	Uth0rgshteUWAF+XOVC/IiB+fGX4n9kULCr7ruuPNs0tD3EyoInLoFO0QfDF0cTayRG1EoMPnb+
	wovgdlGIa8Lh2tmM0pUFgQGep0lZHaSV98gHoShH1oMNNAbiPbIwj82EX5YeDMO82k7FlIklZ3V
	2YTUZraSFEbBdIiJoVviiEFCR1irrQMygV72UZ3V6EknyRsi4R820W6Pw3XEvszdfiPL8tGgKQJ
	66UIBDAfNXwgVQQmAdKIgfymZs8ED0ZC1d4gCGLhIfLSh/SzVXDIQt5UZqGBafj+KB+6k8/L9Tr
	BinuX9YF9xd2XzTlEP41mRIrGt4gAne7PdIYKQFKYrE9es=
X-Received: by 2002:a05:600c:5490:b0:493:d2b1:48c8 with SMTP id 5b1f17b1804b1-493f883a6b6mr18700925e9.33.1783761172280;
        Sat, 11 Jul 2026 02:12:52 -0700 (PDT)
Received: from 127.0.0.1localhost (82-132-221-54.dab.02.net. [82.132.221.54])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-69c60d47188sm681191a12.27.2026.07.11.02.12.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 11 Jul 2026 02:12:50 -0700 (PDT)
From: Pavel Begunkov <asml.silence@gmail.com>
To: io-uring@vger.kernel.org
Cc: asml.silence@gmail.com,
	netdev@vger.kernel.org
Subject: [PATCH review-only 15/17] io_uring/zcrx: add dynamic area creation
Date: Sat, 11 Jul 2026 10:11:38 +0100
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
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c0a:e001:db::/64:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-13944-lists,io-uring=lfdr.de];
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
	ASN(0.00)[asn:63949, ipnet:2600:3c0a::/32, country:SG];
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
	DBL_BLOCKED_OPENRESOLVER(0.00)[sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns,vger.kernel.org:from_smtp]
X-Rspamd-Server: lfdr
X-Rspamd-Queue-Id: 812B674102E

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


