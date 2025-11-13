Return-Path: <io-uring+bounces-10583-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ams.mirrors.kernel.org (ams.mirrors.kernel.org [IPv6:2a01:60a::1994:3:14])
	by mail.lfdr.de (Postfix) with ESMTPS id 211A7C5703F
	for <lists+io-uring@lfdr.de>; Thu, 13 Nov 2025 11:54:20 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ams.mirrors.kernel.org (Postfix) with ESMTPS id E42B43564C8
	for <lists+io-uring@lfdr.de>; Thu, 13 Nov 2025 10:49:38 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A82A0333740;
	Thu, 13 Nov 2025 10:49:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="G+sH9mMg"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-wm1-f45.google.com (mail-wm1-f45.google.com [209.85.128.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C73553376BC
	for <io-uring@vger.kernel.org>; Thu, 13 Nov 2025 10:49:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763030948; cv=none; b=c9+AAfueCOQahPGkQAV8C6Qmy3dSPltQSPgzMmW60NavEZcDm7LcvyoHk27d1T3+zpemACtg/M8maDz2rMd0KAqG2H961X8QcJYjkgdH/b+gBYQaj1muBmPzcqE27IjqNFhEK1sf2NC1+/MmFlyW+N1m97qz/fiAaf5WstnugFQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763030948; c=relaxed/simple;
	bh=ZeS2U5PggwHPIY17ZMbJv075ct4iZXCsNiAKcfAY2/8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Q2rP74ElOOkNQCF6zVt/VuOv6p3n6PZgWfH6q/YNjH97ybWllkMeXc5PJ4Dl64gWnoCbtihleyP74Xrzymux4rUVqjEZk9F8ir16ookCI+Zmg0BYJQWB5Ow1lk0GZ22CRVWx78tawLC2qr4BQ7IPdXgHvJVqX9yAA0zlEdeYUQE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=G+sH9mMg; arc=none smtp.client-ip=209.85.128.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-wm1-f45.google.com with SMTP id 5b1f17b1804b1-47775fb6c56so7701665e9.1
        for <io-uring@vger.kernel.org>; Thu, 13 Nov 2025 02:49:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1763030944; x=1763635744; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=6Kc82PldLSxZ5hkwlD6LeukwKNCQm0DDHzt4xTIX1pM=;
        b=G+sH9mMgmVDkEM860pu5bFboz+Y/TuQv5jWZ2vJPca35XZtr6X435nBuIwdI9yySpT
         FaZeI9BNbreRwqDQNBF4qpWyT3cJFB+9MHsKVvSu3rce7SxRJaV77Lc3MI7Y7TdPDi5b
         BE+bpfxUyflSHwulwaecaolQOzRLvpsCe6OqeiTpfQNej5gEW5pIDzkGGZ6EWp3qET13
         mjRMyoKrcIsMTB3o9wQEx5XqqmF8ii5uuf4I1OUrdAE4/FLFD5ALEoTN9r3DUttQ1qst
         yNFpHyBm+Kfp/bFNv1I5mMuf1roQZJ+V/84UoLUTjBPvfS1VQ9UkatMZffx9lh/viRLY
         Jzbg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1763030944; x=1763635744;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=6Kc82PldLSxZ5hkwlD6LeukwKNCQm0DDHzt4xTIX1pM=;
        b=f33YsmQa8JMUXUO104gzH7hUCKSxs/1bMULW4g72iAGfI880imlK0KCHQvFYB2bXKl
         JNmSUokMXvD7ITMgjd1jkR8La1po4AEkk/XwHkP3qCpPyI4e69BuiT6e77xF6Xrxi9I7
         /eMHTok7fmlK2WQik5L524XBlgsu//dzKs3FLYkIliTLetNptqkNfC5IhSvtjy3qpL36
         wEo0nTXGS1HLRFeOsElhWE2QisFaHElRFxRbLGqv9FpeEU4klkSsF4B2j0d5kxhwjYdr
         9kHEgE2pFTs6RQ9iLRf9hFzIhpzQI5KSJrBK7m7j+W6t8HhOmXrPajp9qkpWMcrJyI1R
         e82Q==
X-Gm-Message-State: AOJu0Yxn+TmUZQpT7yXLUMupxc3pE1cmgVjiHLexOqiHirq2wZuS8hQ9
	FBMddb1Kkv2K9TvY0gn0xp2xuT9zbrs9U2ayrnyOH2iiED76oI+vCBTEtvX6ew==
X-Gm-Gg: ASbGncu9w9HmafoZakGd9UhwaiV0tCr78YLRK6Fo1hm23EGAXc3gC2jeI5s+bcYEM+7
	GbGf5gBZss6QUm5fCq0K3eO4GbEGmyLJSg2SVGaSsuC+bCLlN9KyX3V4RbdIwGu6am4iTbku7Db
	SEwzPgWWmLBGB4oQTC6K/pbeVdR5NSDG8g5hBYI4RsWLm7eeIWX/wG5NC/6NY4kcZbBhpK3TuXE
	4TRR3dk1osXMFieMPURRja8zbuPsqFdqHvla1mPX00L6X4wTLn9gsHZ2nRzsPreSMrJqDjhjgUd
	RKhfdnZrp5Eg9GRYAVCrTW3y3w34YlUP8QOha3OO7sMRDXSWNxP2veWfypq8PX1OUzSRVXsSQDz
	1aLKLpaMlH1lfL+yFgEU4vqhq6bthQeMMDcoTOlqrg+d7oHLTbnQttQYhAkw=
X-Google-Smtp-Source: AGHT+IEAcKNhb3aBAzaZrElIqo/r1n1b4inz4gpwmfXmnISg5CZPgitFv8JyMNzR9wAh4AR1hLTTCQ==
X-Received: by 2002:a05:600c:4584:b0:471:14b1:da13 with SMTP id 5b1f17b1804b1-4778707e9c8mr52021785e9.14.1763030943554;
        Thu, 13 Nov 2025 02:49:03 -0800 (PST)
Received: from 127.com ([2620:10d:c092:600::1:6794])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-47787e442c2sm88850945e9.7.2025.11.13.02.49.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 13 Nov 2025 02:49:03 -0800 (PST)
From: Pavel Begunkov <asml.silence@gmail.com>
To: io-uring@vger.kernel.org
Cc: asml.silence@gmail.com
Subject: [PATCH 2/2] io_uring/query: introduce rings info query
Date: Thu, 13 Nov 2025 10:48:58 +0000
Message-ID: <0bbcf565bfa25e4940d1bcb6fa76fcafd61c68a1.1763030298.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <cover.1763030298.git.asml.silence@gmail.com>
References: <cover.1763030298.git.asml.silence@gmail.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Same problem as with zcrx in the previous patch, the user needs to know
SQ/CQ header sizes to allocated memory before setup to use it for user
provided rings, i.e. IORING_SETUP_NO_MMAP, however that information is
only returned after registration, hence the user is guessing kernel
implementation details.

Return the header size and alignment, which is split with the same
motivation, to allow the user to know the real structure size without
alignment in case there will be more flexible placement schemes in the
future.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 include/uapi/linux/io_uring/query.h |  8 ++++++++
 io_uring/query.c                    | 13 +++++++++++++
 2 files changed, 21 insertions(+)

diff --git a/include/uapi/linux/io_uring/query.h b/include/uapi/linux/io_uring/query.h
index fc0cb1580e47..2456e6c5ebb5 100644
--- a/include/uapi/linux/io_uring/query.h
+++ b/include/uapi/linux/io_uring/query.h
@@ -19,6 +19,7 @@ struct io_uring_query_hdr {
 enum {
 	IO_URING_QUERY_OPCODES			= 0,
 	IO_URING_QUERY_ZCRX			= 1,
+	IO_URING_QUERY_SCQ			= 2,
 
 	__IO_URING_QUERY_MAX,
 };
@@ -57,4 +58,11 @@ struct io_uring_query_zcrx {
 	__u64 __resv2;
 };
 
+struct io_uring_query_scq {
+	/* The SQ/CQ rings header size */
+	__u64 hdr_size;
+	/* The alignment for the header */
+	__u64 hdr_alignment;
+};
+
 #endif
diff --git a/io_uring/query.c b/io_uring/query.c
index 6f9fa5153903..e61b6221f87f 100644
--- a/io_uring/query.c
+++ b/io_uring/query.c
@@ -9,6 +9,7 @@
 union io_query_data {
 	struct io_uring_query_opcode opcodes;
 	struct io_uring_query_zcrx zcrx;
+	struct io_uring_query_scq scq;
 };
 
 #define IO_MAX_QUERY_SIZE		sizeof(union io_query_data)
@@ -43,6 +44,15 @@ static ssize_t io_query_zcrx(union io_query_data *data)
 	return sizeof(*e);
 }
 
+static ssize_t io_query_scq(union io_query_data *data)
+{
+	struct io_uring_query_scq *e = &data->scq;
+
+	e->hdr_size = sizeof(struct io_rings);
+	e->hdr_alignment = SMP_CACHE_BYTES;
+	return sizeof(*e);
+}
+
 static int io_handle_query_entry(struct io_ring_ctx *ctx,
 				 union io_query_data *data, void __user *uhdr,
 				 u64 *next_entry)
@@ -74,6 +84,9 @@ static int io_handle_query_entry(struct io_ring_ctx *ctx,
 	case IO_URING_QUERY_ZCRX:
 		ret = io_query_zcrx(data);
 		break;
+	case IO_URING_QUERY_SCQ:
+		ret = io_query_scq(data);
+		break;
 	}
 
 	if (ret >= 0) {
-- 
2.49.0


