Return-Path: <io-uring+bounces-6524-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 638B2A3AB6B
	for <lists+io-uring@lfdr.de>; Tue, 18 Feb 2025 23:02:06 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id C6B363A48D0
	for <lists+io-uring@lfdr.de>; Tue, 18 Feb 2025 22:01:39 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DB8A22862BD;
	Tue, 18 Feb 2025 22:01:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=davidwei-uk.20230601.gappssmtp.com header.i=@davidwei-uk.20230601.gappssmtp.com header.b="KEPbfVlO"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pj1-f47.google.com (mail-pj1-f47.google.com [209.85.216.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 73D8E1C701B
	for <io-uring@vger.kernel.org>; Tue, 18 Feb 2025 22:01:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739916104; cv=none; b=nG2J1f0K0dIqe/+vCJzgHGGKipX+NiYPpVlxMFCSVlzcFXdczjPHupQisnJAtAaCmRkNln+9esDDURyJQ6rLN005kPvDYOA9LuYbxTRlSXOeBu7437eK6RkTjoRQoE9e3QjOsd/uOn+mmwGmyhuD0Ca6R1f4srTh/JN83sjEbOo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739916104; c=relaxed/simple;
	bh=VCN7bDMu1wbb30x4oD5ih9cJjZx9VYiqK6rTypUeh0Y=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=OmeVdiKoRp0/q3ORNmT0RPcfy+xADDLkxOczAFLh2/1enzPA301IDMKLqlD3VzBJrme7t8dSCirozWdKLyxZHFUUJ8AD4gPNpdKQBkTf5F3nAn0KAtYwTUtNb6QxGpXjW/odyfhkwC8/CuzPhD7/Q3QboE7mYJlpKV1nFRSFBP0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=davidwei.uk; spf=none smtp.mailfrom=davidwei.uk; dkim=pass (2048-bit key) header.d=davidwei-uk.20230601.gappssmtp.com header.i=@davidwei-uk.20230601.gappssmtp.com header.b=KEPbfVlO; arc=none smtp.client-ip=209.85.216.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=davidwei.uk
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=davidwei.uk
Received: by mail-pj1-f47.google.com with SMTP id 98e67ed59e1d1-2fc11834404so8508711a91.0
        for <io-uring@vger.kernel.org>; Tue, 18 Feb 2025 14:01:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=davidwei-uk.20230601.gappssmtp.com; s=20230601; t=1739916103; x=1740520903; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=vhYVfmU8RD9dhfxIQEmEnt4HeDToaTcnJxE8nhiL6RQ=;
        b=KEPbfVlOdZTfSmf8cNbnIPMhEOOpL/eWeLez/V7Zi69zMfANXD2YccXlSt9jfEbSQj
         WMqy3FtlLtFm3Bl+L7hY9BLt8yFKcRD0NOmY90J0z+4WrcUvXKDdHeHdDO3Kgc6MufT9
         NipB9z4Zw51Fek12kcw3nKmSFqAB2b7Vqh97rg56umIRAwdVDz2azGaDPQj1UTL1Y7jG
         /+9Y+POhfuifEct0bvsrgPF4Q1VuLRE9/o0hLLwBpsuwQH5DmlgRBAjh7mvxIiFa+iq6
         HVR/IbUbgLlM75fnFK6hQJsvQseD+qACZ4Af/uJpFwVfDGNupULTpmgnGrZG6VaaJA8E
         kF6g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1739916103; x=1740520903;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=vhYVfmU8RD9dhfxIQEmEnt4HeDToaTcnJxE8nhiL6RQ=;
        b=buNn7mV5v6hEzJh5FedkFIh3fFPbqLb4r50qaqqIioQcO1X9D7yhBSvemoUAUTyp4z
         alsl+0n6b9YqMU6O+3JcBPqF9+Ny+6Pjj8SDMm8dqKwGOgChWAogkwx1IB7VB2a7CviV
         uQoOuASN0mkZe7uhOLQJp1X2NE1b0iGYHc1cAL6Rn6a9LORWd6u9BbR11vyVWRpp4z6c
         x0J06Xvd2RzIOMJfXT8XgcTZNO0I+JwMj7SOnptC/+xYniStzC9y1KzW8lmNwm46m7CV
         u8qVf+UxPX9ok7QSQy0oquXITAnMdcdIYGaCs6c4ICW8ULfxVb4yT04QIcOHP7+QWbw+
         L7vw==
X-Gm-Message-State: AOJu0YziYREFpgYr4X4B6v5u0lHUL0oGrdbB5PL1d5KW4CFIyV3ZGnZ6
	ttKellPdpcs+PydavW6AipPXSZFMk8Qm4gem2hR6iYsdejt0eP39ZlVFLpOfPiccTqnRN6f2naF
	3
X-Gm-Gg: ASbGncv6vFd7BZPEWHAYrOtmzuW13dPUZgbN30sidBMdtEJpjzD1dbZEw6tVu6q00Nn
	4Fx62K9iXlY3ZJ10SXWwfkKWqCdc4SDuJMHRewjRCblNsemflaNd8cw8KBunlhiY0QateV8zJeu
	87LARnaq/wRNaKSnsvELLPltfTXLZYihnpNK117MKDJQEgmgztTf0lUtt/zg7hyuvbxQGoR6R2z
	JlIuNMUSAqczqbLcSrY/q9YaHqw4UxAUnkWTvfV6YCAWBcEQt00J2vFsSS9t3ZLofSLMGrbs7jR
X-Google-Smtp-Source: AGHT+IEc8tTJw6hJefBk5vsffgKksqLjfH9jVWVNBedmvlG2W3Y0bm0gFIRiN+qyxdBfXEDxQmS9XA==
X-Received: by 2002:a17:90b:17c7:b0:2ee:cd83:8fe7 with SMTP id 98e67ed59e1d1-2fc411679e8mr23399633a91.35.1739916102701;
        Tue, 18 Feb 2025 14:01:42 -0800 (PST)
Received: from localhost ([2a03:2880:ff:47::])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-2fc13ad35absm10481291a91.25.2025.02.18.14.01.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 18 Feb 2025 14:01:42 -0800 (PST)
From: David Wei <dw@davidwei.uk>
To: io-uring@vger.kernel.org
Cc: Jens Axboe <axboe@kernel.dk>,
	Pavel Begunkov <asml.silence@gmail.com>
Subject: [PATCH liburing v2 2/4] zcrx: sync io_uring headers
Date: Tue, 18 Feb 2025 14:01:34 -0800
Message-ID: <20250218220136.2238838-3-dw@davidwei.uk>
X-Mailer: git-send-email 2.43.5
In-Reply-To: <20250218220136.2238838-1-dw@davidwei.uk>
References: <20250218220136.2238838-1-dw@davidwei.uk>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Sync linux/io_uring.h with zcrx changes.

Signed-off-by: David Wei <dw@davidwei.uk>
---
 src/include/liburing/io_uring.h | 54 +++++++++++++++++++++++++++++++++
 1 file changed, 54 insertions(+)

diff --git a/src/include/liburing/io_uring.h b/src/include/liburing/io_uring.h
index 452240a6ebb4..d2fcd1d22ea0 100644
--- a/src/include/liburing/io_uring.h
+++ b/src/include/liburing/io_uring.h
@@ -87,6 +87,7 @@ struct io_uring_sqe {
 	union {
 		__s32	splice_fd_in;
 		__u32	file_index;
+		__u32	zcrx_ifq_idx;
 		__u32	optlen;
 		struct {
 			__u16	addr_len;
@@ -262,6 +263,7 @@ enum io_uring_op {
 	IORING_OP_FTRUNCATE,
 	IORING_OP_BIND,
 	IORING_OP_LISTEN,
+	IORING_OP_RECV_ZC,
 
 	/* this goes last, obviously */
 	IORING_OP_LAST,
@@ -619,6 +621,9 @@ enum io_uring_register_op {
 	/* send MSG_RING without having a ring */
 	IORING_REGISTER_SEND_MSG_RING		= 31,
 
+	/* register a netdev hw rx queue for zerocopy */
+	IORING_REGISTER_ZCRX_IFQ		= 32,
+
 	/* resize CQ ring */
 	IORING_REGISTER_RESIZE_RINGS		= 33,
 
@@ -920,6 +925,55 @@ enum io_uring_socket_op {
 	SOCKET_URING_OP_SETSOCKOPT,
 };
 
+/* Zero copy receive refill queue entry */
+struct io_uring_zcrx_rqe {
+	__u64	off;
+	__u32	len;
+	__u32	__pad;
+};
+
+struct io_uring_zcrx_cqe {
+	__u64	off;
+	__u64	__pad;
+};
+
+/* The bit from which area id is encoded into offsets */
+#define IORING_ZCRX_AREA_SHIFT	48
+#define IORING_ZCRX_AREA_MASK	(~(((__u64)1 << IORING_ZCRX_AREA_SHIFT) - 1))
+
+struct io_uring_zcrx_offsets {
+	__u32	head;
+	__u32	tail;
+	__u32	rqes;
+	__u32	__resv2;
+	__u64	__resv[2];
+};
+
+struct io_uring_zcrx_area_reg {
+	__u64	addr;
+	__u64	len;
+	__u64	rq_area_token;
+	__u32	flags;
+	__u32	__resv1;
+	__u64	__resv2[2];
+};
+
+/*
+ * Argument for IORING_REGISTER_ZCRX_IFQ
+ */
+struct io_uring_zcrx_ifq_reg {
+	__u32	if_idx;
+	__u32	if_rxq;
+	__u32	rq_entries;
+	__u32	flags;
+
+	__u64	area_ptr; /* pointer to struct io_uring_zcrx_area_reg */
+	__u64	region_ptr; /* struct io_uring_region_desc * */
+
+	struct io_uring_zcrx_offsets offsets;
+	__u64	__resv[4];
+};
+
 #ifdef __cplusplus
 }
 #endif
-- 
2.43.5


