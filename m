Return-Path: <io-uring+bounces-12715-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id UGVDL7qWuGk8gQEAu9opvQ
	(envelope-from <io-uring+bounces-12715-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Tue, 17 Mar 2026 00:48:10 +0100
X-Original-To: lists+io-uring@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 608FE2A2129
	for <lists+io-uring@lfdr.de>; Tue, 17 Mar 2026 00:48:10 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id DBCA0303AB45
	for <lists+io-uring@lfdr.de>; Mon, 16 Mar 2026 23:47:56 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 134F71F872D;
	Mon, 16 Mar 2026 23:47:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Oixac+U3"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-wm1-f42.google.com (mail-wm1-f42.google.com [209.85.128.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9257135CB73
	for <io-uring@vger.kernel.org>; Mon, 16 Mar 2026 23:47:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773704876; cv=none; b=NrBwaLCuG2cl0VWtK4vuaPk3BWyJeks6G/q9aVw7gHaZrpSb43+GxdAV/Vwq51Qb9VibQ9+kmErA/guoDzTSOTefLGdM68euHBvRx0ngwFeQP1jTJvJEjY98wWKL+4ZNWCPRJErs3TCMLyIz/DYIDZq8UVEXdUlkDgf2Irzk5EE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773704876; c=relaxed/simple;
	bh=1HyZ0Xh4ZG8bSvbgcUqd61hFrgpxo9RSP66WKHSRzOQ=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=gQ4OcteZhfF4A+/QcQJVmqSKryZZ0jPurFlNHdtstDIt/v4nRKbW8GFVOi2RiVXG9jXl7fahHeTLv4DRwsBcxBs1o4nGhQDMo6drHTK3WmoUxIDiTRLt9WqxvwflnUjSQih+vnbq76Xb8NofuZIu0u5JkRqUe6NZ5MfE+e9sVLc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Oixac+U3; arc=none smtp.client-ip=209.85.128.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-wm1-f42.google.com with SMTP id 5b1f17b1804b1-48374014a77so54414845e9.3
        for <io-uring@vger.kernel.org>; Mon, 16 Mar 2026 16:47:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1773704872; x=1774309672; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=FZ7YyaBd7okSV1SHleghLHiScAk3gKELn8k7LbE4hXg=;
        b=Oixac+U3wOCrwRGoHQ3GYtS4qcu0CtAY3q0GkqOjlj5WririmDZW/ZGArO7AvmKVc7
         RFv2m7ms4H0kaK4GtMQ2gm/f2o27xlVi+XJxGCFk8VC3YsMNt6QkWCN5NPr+kgD2z39p
         Zht5PRQTSQvI/2J6p5GuuyotnoJxJjvLSCPj8E4/AngYZ/EMH76tdnl5JGoamm1odqhB
         1T5caBx0gMBiGI3ATA05kfqGc0EvtCa+BdOsMrXgMrlOvPI0D+OKqq1NesTUm0hbEupC
         yBc8OPMAYKoUwrpXk1m/2uWNm1vkHEwfQYvjbQyZu3eKXeEALs5puhTypGs6F9umM+nd
         ZEaw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1773704872; x=1774309672;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=FZ7YyaBd7okSV1SHleghLHiScAk3gKELn8k7LbE4hXg=;
        b=c+/342BDdd4pZMAPMR3WnIqJJXMTvtQXGuEXMrLhaZDoTvyLV8yVoUMxtTavRy2ARP
         VLTyWQY57HB8axerlMettY0YecfMGfVxM8mItczv/DM/KKM5wkIRtrh4J/g52YBGn7sJ
         exyD44VRGOhojpYyY/7X4AS039eiFXk0ZYEMcsnksz6CJlcAtENYOuUjaNzVSGeyh0in
         NYR+XMGanAKEd8l+EKC693cmwiMRGtGzTtgBPWcfzC6D2OT4mOIFSoCbytjcRZFyz8lE
         WDexdhq8LZkzZVwFmEBtsw/yAZ3JjJTKIQ/+WmaiefInaUOLTIYJK6Yc4UIdZwV4+6Ja
         xuDw==
X-Gm-Message-State: AOJu0Yz346t/scMjcNhCS7dSPUBnynoe42pBfvRYL8k626mBcCMzGNXW
	KIxWkkwjgPgjfc47+HF+kxm8bZk2zdCszJkIBQzaM6RBwquOpefrZZcPYWXBxA==
X-Gm-Gg: ATEYQzwGSdBRbV/kBp0aQlQLSzRVdjtXLIdSjpYyy74TqNKtYKz33T5N4tUPS4S7ahI
	aiQ1tPKbK4d6iPtyCnL9+LL6JucbVLi7Ya9p1VTigre+cZXOWSCX0S7cCz1keesAz/3BxRMNg9Q
	a3hZevA9kVCkeViAeOkD50TjeCU0hhZ28TimoARqH7o0wa5v8ZTK21C0R1dOCA/fBKCWtjdQQqi
	q6QhH3Dx/7WnTKYkDOs7TTA82XB/yhDIkJhrOtp4ELpo5mSe5rGTK6CZ7WbPAugibyv/4VVQYgS
	VQLvrmHSsGfigCG5Fu+yu6ZzccxymiNpXQzPhzd/ayRRk7Ouk5oIEdxGEaNwOCoXzPGyheXx3V3
	1LXXxXgwxoh7Q2mNyZtUDKzIve36jJB13OjnT46JtW1fluTBFjLLkxdvU48WORPBuTGZwEXnsqQ
	aWQW9TefXqfGtg8e2yuWPAunBSa6m4vq1ZV8dywZnbFgZWcGKAkP5g8EkX9u9rPNrq0vWOTHljQ
	83wzAJKwWka9A3A8Og3J14ti0sOgA==
X-Received: by 2002:a05:600c:1f96:b0:485:40db:d40c with SMTP id 5b1f17b1804b1-485566cf8f0mr268451405e9.3.1773704872539;
        Mon, 16 Mar 2026 16:47:52 -0700 (PDT)
Received: from 127.mynet ([2a01:4b00:bd21:4f00:7cc6:d3ca:494:116c])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-43b3d427457sm23883331f8f.3.2026.03.16.16.47.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 16 Mar 2026 16:47:51 -0700 (PDT)
From: Pavel Begunkov <asml.silence@gmail.com>
To: io-uring@vger.kernel.org
Cc: asml.silence@gmail.com,
	axboe@kernel.dk
Subject: [PATCH liburing 1/1] Update uapi headers
Date: Mon, 16 Mar 2026 23:47:54 +0000
Message-ID: <9e1d997c5189d438c5d13b03c28412116705815e.1773704793.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.53.0
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spamd-Result: default: False [-1.66 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[gmail.com,none];
	R_MISSING_CHARSET(0.50)[];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c0a:e001:db::/64:c];
	R_DKIM_ALLOW(-0.20)[gmail.com:s=20230601];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	MIME_TRACE(0.00)[0:+];
	DKIM_TRACE(0.00)[gmail.com:+];
	TAGGED_FROM(0.00)[bounces-12715-lists,io-uring=lfdr.de];
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
	ASN(0.00)[asn:63949, ipnet:2600:3c0a::/32, country:SG];
	RCVD_COUNT_FIVE(0.00)[5];
	NEURAL_HAM(-0.00)[-1.000];
	TO_DN_NONE(0.00)[];
	TAGGED_RCPT(0.00)[io-uring];
	MID_RHS_MATCH_FROM(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns]
X-Rspamd-Queue-Id: 608FE2A2129
X-Rspamd-Action: no action
X-Rspamd-Server: lfdr

We'll need new zcrx interfaces including zcrx specific query and ctrl
registeration definitions. Pull them in.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 src/include/liburing/io_uring.h       | 42 ++++++++++++++++++++++++++-
 src/include/liburing/io_uring/query.h | 28 ++++++++++++++++++
 2 files changed, 69 insertions(+), 1 deletion(-)

diff --git a/src/include/liburing/io_uring.h b/src/include/liburing/io_uring.h
index 7a0b517b..10497daf 100644
--- a/src/include/liburing/io_uring.h
+++ b/src/include/liburing/io_uring.h
@@ -1049,6 +1049,18 @@ struct io_uring_zcrx_area_reg {
 	__u64	__resv2[2];
 };
 
+enum zcrx_reg_flags {
+	ZCRX_REG_IMPORT	= 1,
+};
+
+enum zcrx_features {
+	/*
+	 * The user can ask for the desired rx page size by passing the
+	 * value in struct io_uring_zcrx_ifq_reg::rx_buf_len.
+	 */
+	ZCRX_FEATURE_RX_PAGE_SIZE	= 1 << 0,
+};
+
 /*
  * Argument for IORING_REGISTER_ZCRX_IFQ
  */
@@ -1063,10 +1075,38 @@ struct io_uring_zcrx_ifq_reg {
 
 	struct io_uring_zcrx_offsets offsets;
 	__u32	zcrx_id;
-	__u32	__resv2;
+	__u32	rx_buf_len;
 	__u64	__resv[3];
 };
 
+enum zcrx_ctrl_op {
+	ZCRX_CTRL_FLUSH_RQ,
+	ZCRX_CTRL_EXPORT,
+
+	__ZCRX_CTRL_LAST,
+};
+
+struct zcrx_ctrl_flush_rq {
+	__u64		__resv[6];
+};
+
+struct zcrx_ctrl_export {
+	__u32		zcrx_fd;
+	__u32 		__resv1[11];
+};
+
+struct zcrx_ctrl {
+	__u32	zcrx_id;
+	__u32	op; /* see enum zcrx_ctrl_op */
+	__u64	__resv[2];
+
+	union {
+		struct zcrx_ctrl_export		zc_export;
+		struct zcrx_ctrl_flush_rq	zc_flush;
+	};
+};
+
+
 #ifdef __cplusplus
 }
 #endif
diff --git a/src/include/liburing/io_uring/query.h b/src/include/liburing/io_uring/query.h
index 5d754322..0b624817 100644
--- a/src/include/liburing/io_uring/query.h
+++ b/src/include/liburing/io_uring/query.h
@@ -18,6 +18,8 @@ struct io_uring_query_hdr {
 
 enum {
 	IO_URING_QUERY_OPCODES			= 0,
+	IO_URING_QUERY_ZCRX			= 1,
+	IO_URING_QUERY_SCQ			= 2,
 
 	__IO_URING_QUERY_MAX,
 };
@@ -36,6 +38,32 @@ struct io_uring_query_opcode {
 	__u64	enter_flags;
 	/* Bitmask of all supported IOSQE_* flags */
 	__u64	sqe_flags;
+	/* The number of available query opcodes */
+	__u32	nr_query_opcodes;
+	__u32	__pad;
+};
+
+struct io_uring_query_zcrx {
+	/* Bitmask of supported ZCRX_REG_* flags, */
+	__u64 register_flags;
+	/* Bitmask of all supported IORING_ZCRX_AREA_* flags */
+	__u64 area_flags;
+	/* The number of supported ZCRX_CTRL_* opcodes */
+	__u32 nr_ctrl_opcodes;
+	/* Bitmask of ZCRX_FEATURE_* indicating which features are available */
+	__u32 features;
+	/* The refill ring header size */
+	__u32 rq_hdr_size;
+	/* The alignment for the header */
+	__u32 rq_hdr_alignment;
+	__u64 __resv2;
+};
+
+struct io_uring_query_scq {
+	/* The SQ/CQ rings header size */
+	__u64 hdr_size;
+	/* The alignment for the header */
+	__u64 hdr_alignment;
 };
 
 #endif
-- 
2.53.0


