Return-Path: <io-uring+bounces-10920-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id EED9BC9D6F4
	for <lists+io-uring@lfdr.de>; Wed, 03 Dec 2025 01:38:40 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 9D9EB3A2073
	for <lists+io-uring@lfdr.de>; Wed,  3 Dec 2025 00:38:39 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B3F5422FE0E;
	Wed,  3 Dec 2025 00:37:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="fwkBkaK/"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pf1-f179.google.com (mail-pf1-f179.google.com [209.85.210.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 36C3325B1D2
	for <io-uring@vger.kernel.org>; Wed,  3 Dec 2025 00:37:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.179
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764722233; cv=none; b=t8WQLb/hqCsmGL0eE+ovaPIIoQ9xMOHVEnoeXE8Kx5gIF602vzZucVl2rxqNf4JcvXARBBFypzewRrM+ksFGJlAdCWIGYSQqAGs/T0LeIwtfBHg+aK2zNC98ZiO8NzNaYfPVqSlBGZjxbcRRyqt5tTJTZkd66xZ9KeJYc8+J6Oc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764722233; c=relaxed/simple;
	bh=5eK+SWDhLpes0WgGB1yI6ykRUTk3qSxid1pNxzxrdno=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GomjHhDYLzxQ87JN9om8xjdLYyH1BM+B1OcJm8Xsu7F5bA+W0j+XSSrFW15mw76amchvUMmqMLxJ0nDCPLApcUPZN1ieIpHqD8g1vaJrNq0Ie7Tb5QBziBYVdG79dmm1QrcXy911xSpQh7jbWXT+63kb+2346txs1LXJw1oiF8M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=fwkBkaK/; arc=none smtp.client-ip=209.85.210.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pf1-f179.google.com with SMTP id d2e1a72fcca58-7a9c64dfa8aso4839199b3a.3
        for <io-uring@vger.kernel.org>; Tue, 02 Dec 2025 16:37:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1764722231; x=1765327031; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=3fkt73EuxuNJ1I8X/QObEo4LIp+wArdiuU4gz5REkdY=;
        b=fwkBkaK/000u7HQDmpTR7ywpGKVS9dUWCDwoUb1qG7Ms8rnspZojaHK/8jVEIcTGRE
         vURV8UV+oEHAuGOmHepN5LzyF3s7egDTQH/NZPLOZae0dHQU5EmZgH3/c6ruKjoVnYBK
         ZwtjxwT9tLML3lNv/gM3AWT5RD9KXAkPUTAHI+Qg1PjG2JdwqxEWBYfUdhqdSUJB9ZFw
         oOWugR2/QJnDAMfM+jc8980F4ExRAUwABkjoiEEleWT7LTG7HUU+eXOeRye4e384HHkm
         CXZ4OJOj0LE74/Lu1UhkE9r79w4Ry9oWhkv8SJW/TNDvrGP/yo1OFKjZV/wog20tvuHX
         EWZg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1764722231; x=1765327031;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=3fkt73EuxuNJ1I8X/QObEo4LIp+wArdiuU4gz5REkdY=;
        b=XEEkGjr1ZT8enu1c1AG9YXRl2GU4d2GJUcdvmVyMPBD6D4YHCK/UoPcljY2s6G1EeB
         33ZG6ejGeGB3s07IpQMLc1c2XxcCchsHl32ke77KzqFLldqlC4JfY+27/qCRuLsTLCEM
         et+EjJvlLJEKbHH80YdItq8Fa2+a2WmzDq8LTYEb8bG6RurUB7GExyg/D1d1SyZTQw8D
         dz/CDxw9xLe9UVdsaM6PButMnmAAIlvUsP/+1OlzIZIXFv6gMfwMmt1V84XJ3zjc73CA
         F5iQtPIlaUBBRrqix3KsX88Hu7LVM4FdA+McmtWnS9q7CT6X6XN5bP0GS7q1M654wvRt
         K+kQ==
X-Forwarded-Encrypted: i=1; AJvYcCW5gfYeZ9b6iQ8QyGw316zDBYwUADwFxEbw83ditMzSX0runfRVu4ZAjfRU5UJev9OMYY4nCtYoyQ==@vger.kernel.org
X-Gm-Message-State: AOJu0YzR4Jx9vTNGXndvnetMkjGWiT11g34HVh/sJbNY3spueFOL3l/V
	bjDkSTeZitwjGQPmPMgImv8Cu6GotsUj1+scPwJKf0bzRLXoNbKsfzwc
X-Gm-Gg: ASbGncsrtC8Uf/WjWz7V9exLR9LbGmk/VvSTVl1fk1tRUUk5OYfh5YsPntnYfNWn5we
	UrOjYstHXpTo3HfxRMSF+KhFWBjMLUp1+Oq/mmSwR3ioWEP2QF1PuwZX9pIHGGmz5ZCnPj7ehIK
	VxgiXUsXVzlgTS8C3Wq4Pc1o/dVy3RTzaJ/s5lnQIYNU7LKXe4Yt1s8mFDUh+/GVevKNRt2q2jJ
	JOimTYy50v9qy/FJ/fvMVZ4Rx3E9FMmvUp20Gg5ER5+BfBGIgEFVQsY0aFCt4GSHJXm0lrWt20w
	ulaXavQWuI/Ql9FgbvjJ+4ODH8PXX/fs1CmVv0DC9GKJu/bHxOQnccOUy9uOuQY9A8+JaOObck8
	sio6MG3IWAT4M+JEOYHKId7iysRad1bxZYvAvDnOX+lLXJLxVTrdmyvI+dFJvoic9IqD0qLiILU
	eeyOZsKLibwW9bSSPCEQ==
X-Google-Smtp-Source: AGHT+IHsUjpd9arGX5qpZZvMlUiCyED7iIxHnWQ4Tx8waqmADtkAEa6xww+qAmpWCN5C9ImJmGTNUg==
X-Received: by 2002:a05:6a20:7484:b0:35c:dfd6:6acb with SMTP id adf61e73a8af0-363f5e2541dmr794785637.30.1764722231473;
        Tue, 02 Dec 2025 16:37:11 -0800 (PST)
Received: from localhost ([2a03:2880:ff:4f::])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-7d15e9c3dfcsm18129387b3a.40.2025.12.02.16.37.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 02 Dec 2025 16:37:11 -0800 (PST)
From: Joanne Koong <joannelkoong@gmail.com>
To: miklos@szeredi.hu,
	axboe@kernel.dk
Cc: bschubert@ddn.com,
	asml.silence@gmail.com,
	io-uring@vger.kernel.org,
	csander@purestorage.com,
	xiaobing.li@samsung.com,
	linux-fsdevel@vger.kernel.org
Subject: [PATCH v1 25/30] io_uring/rsrc: add io_buffer_register_bvec()
Date: Tue,  2 Dec 2025 16:35:20 -0800
Message-ID: <20251203003526.2889477-26-joannelkoong@gmail.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20251203003526.2889477-1-joannelkoong@gmail.com>
References: <20251203003526.2889477-1-joannelkoong@gmail.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Add io_buffer_register_bvec() for registering a bvec array.

This is a preparatory patch for fuse-over-io-uring zero-copy.

Signed-off-by: Joanne Koong <joannelkoong@gmail.com>
---
 include/linux/io_uring/buf.h | 14 ++++++++++++++
 io_uring/rsrc.c              | 25 +++++++++++++++++++++++++
 2 files changed, 39 insertions(+)

diff --git a/include/linux/io_uring/buf.h b/include/linux/io_uring/buf.h
index 2b49c01fe2f5..ff6b81bb95e5 100644
--- a/include/linux/io_uring/buf.h
+++ b/include/linux/io_uring/buf.h
@@ -23,6 +23,11 @@ bool io_uring_is_kmbuf_ring(struct io_ring_ctx *ctx, unsigned int buf_group,
 struct io_br_sel io_ring_buffer_select(struct io_kiocb *req, size_t *len,
 				       struct io_buffer_list *bl,
 				       unsigned int issue_flags);
+
+int io_buffer_register_bvec(struct io_ring_ctx *ctx, struct bio_vec *bvs,
+			    unsigned int nr_bvecs, unsigned int total_bytes,
+			    u8 dir, unsigned int index,
+			    unsigned int issue_flags);
 #else
 static inline int io_uring_buf_ring_pin(struct io_ring_ctx *ctx,
 					unsigned buf_group,
@@ -70,6 +75,15 @@ static inline struct io_br_sel io_ring_buffer_select(struct io_kiocb *req,
 
 	return sel;
 }
+static inline int io_buffer_register_bvec(struct io_ring_ctx *ctx,
+					  struct bio_vec *bvs,
+					  unsigned int nr_bvecs,
+					  unsigned int total_bytes, u8 dir,
+					  unsigned int index,
+					  unsigned int issue_flags)
+{
+	return -EOPNOTSUPP;
+}
 #endif /* CONFIG_IO_URING */
 
 #endif /* _LINUX_IO_URING_BUF_H */
diff --git a/io_uring/rsrc.c b/io_uring/rsrc.c
index a5605c35d857..7358f153d136 100644
--- a/io_uring/rsrc.c
+++ b/io_uring/rsrc.c
@@ -1020,6 +1020,31 @@ int io_buffer_register_request(struct io_ring_ctx *ctx, struct request *rq,
 	return ret;
 }
 
+int io_buffer_register_bvec(struct io_ring_ctx *ctx, struct bio_vec *bvs,
+			    unsigned int nr_bvecs, unsigned int total_bytes,
+			    u8 dir, unsigned int index,
+			    unsigned int issue_flags)
+{
+	struct io_rsrc_data *data = &ctx->buf_table;
+	struct bio_vec *bvec;
+	int ret, i;
+
+	io_ring_submit_lock(ctx, issue_flags);
+	ret = io_buffer_init(ctx, nr_bvecs, total_bytes, dir, NULL, NULL,
+			     index);
+	if (ret)
+		goto unlock;
+
+	bvec = data->nodes[index]->buf->bvec;
+	for (i = 0; i < nr_bvecs; i++)
+		bvec[i] = bvs[i];
+
+unlock:
+	io_ring_submit_unlock(ctx, issue_flags);
+	return ret;
+}
+EXPORT_SYMBOL_GPL(io_buffer_register_bvec);
+
 int io_buffer_unregister(struct io_ring_ctx *ctx, unsigned int index,
 			 unsigned int issue_flags)
 {
-- 
2.47.3


