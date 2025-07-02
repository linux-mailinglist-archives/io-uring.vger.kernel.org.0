Return-Path: <io-uring+bounces-8580-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 4DA61AF5B20
	for <lists+io-uring@lfdr.de>; Wed,  2 Jul 2025 16:28:01 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 419904E6E3D
	for <lists+io-uring@lfdr.de>; Wed,  2 Jul 2025 14:28:01 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 624F928B503;
	Wed,  2 Jul 2025 14:27:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="WniWM+4Z"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pg1-f170.google.com (mail-pg1-f170.google.com [209.85.215.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D44D52F5321
	for <io-uring@vger.kernel.org>; Wed,  2 Jul 2025 14:27:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.170
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751466473; cv=none; b=on7V6A8APw/wLyBAO0j7AoKx/1urT0nKGalPqH9H9frvoUluBEiwJ0ZmhzseZjXKYpRydoml3EhlTwxtg/bjV8y+nFo9rsFN8+zg2cfCLEBCpi6hKTlC9w2O/Zff0ZmPG41rJIn7u+sRXredmlIkveYt2v+qBLwYfV5MSIGMG5E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751466473; c=relaxed/simple;
	bh=kBn08fMz5B/K7LjJbwIghdjpWbDmSlXEV7TAJsNFFWA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mFfprNHkyGvlatbs/tGWpQJCakx2vw6n6asQAj6xvGPVXyu/xp2Pmt0vUzU121i96qTrGYT2H2mRqNDAaIAHXOCmLb+V4ml7YzBEjeHfBUni9OArvhxdfwm6Ui+1YVsfWNEaBbZpZaJkaOrFOH6som6vPB0+q0OiZMJjSa7bLjw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=WniWM+4Z; arc=none smtp.client-ip=209.85.215.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pg1-f170.google.com with SMTP id 41be03b00d2f7-b170c99aa49so5405320a12.1
        for <io-uring@vger.kernel.org>; Wed, 02 Jul 2025 07:27:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1751466471; x=1752071271; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=XMYOvrAUMt7KTtUlLDpZjR0CL4H80f8yqxbmar/OkVU=;
        b=WniWM+4Zpx8adrNO3oT/F6wT6bljcojWvjKvo5AbiBn+ONhR21n2eIkryhwXllMXMz
         RsQrq72A/BPyXvjHeSyuYPah0a3qULQq+aMQXAF02jxKVpDcrVUR+ilMtsItpncxS5Hm
         a2raJCRkuUSecCH1cked2i2GHTFZbehAmkcmEbjEL5ojXXdzqiV112z3esWXwEM8BPtd
         JuKNeQRflnp/hWi7cK7Eqjz67EYiBZTV/+LuDuUuoI6IpVpi3YheB4cxKBcVdnvkPYdi
         MtJ+BYjo8fc8Iza3NdHjy9J+lSel1To4qglxN8/WOlb4yo8G7hDTFfMOT2GajCZw6nd7
         pKEw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1751466471; x=1752071271;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=XMYOvrAUMt7KTtUlLDpZjR0CL4H80f8yqxbmar/OkVU=;
        b=UZ3oY6Q7TqUvd1teKcvreO9ztv6Mf/UOk3mLXgfs/dKzwstT4F9SlOFpVGLlNQ50kk
         irKZAmhKBelDQVMTcBZQCCy1EDSHN3Ezc2GeNalW0WXyEvzg+u5l4WSsl7sMhmNAVMOL
         YZX4lMKFi9TtKsRm1D0lq0zklfQfewPnl+0oKfb7V8qxM1p/h0ljDIRfiKLaaFqBF8+I
         p9YfHWbUbgtRZQiGNCI23ifrqI+McGJYysgk9g3V6ilwq3ghurUkL5K9u+q2/BBoVYWU
         QMpWo8nkFsb4B64rS3d5jqQvAx7Yq5VWYA6b9KL2nhvS+jE2TOJYPYZ/vYuf5ofDZa/6
         u/gA==
X-Gm-Message-State: AOJu0YxhxJC8nyc9Bxpa8UVwSmDITcbdAFhJgkCEPz9HXjePWz/h3od6
	vjOz0o2KftGrezZ2tojxRiJqPxP/wgXMxCFQKoj87JJA9Ypco5vjPPaKrBYyXYOR
X-Gm-Gg: ASbGncvzQ417riCvFjwO7s6VyRCNA8r5a21L86JB1+ZAvtIM1NpYCFtEtHVd4OEMMse
	llcVR5QSnIQ+2FnrhSir50boyMuY701/Wz1XvG5Tx6aX2cYvN2gH1JG1Fw3v437nRHmwcyF+0Y/
	zmnwVnQ9GdgT9z5mAUWtcICmJWoEBSWThP+8blcNl2cjEBSsB97jH2OfjrnI9q+zOpWX39JXdRf
	T0T/gi1lv29xUqLIQ44ga8COZJRKUubtUpa7gytz3zPnEbxZTTsVB2Q7M15LgoEj+gsj2IvyfQ9
	F5o1b8p6jXC4oCRn116RX1pYXSZaKfzO++OPFqg/cqUNtlfMwzF4rGlDiHY=
X-Google-Smtp-Source: AGHT+IEW/mVNPeQdR0ZRoe/CeAW04PzsjOl0jnLLB570lT7h0d5rbV3jO4RKHprIhxLtktisC2ic0Q==
X-Received: by 2002:a05:6a21:38c:b0:1fd:ecfa:b6d7 with SMTP id adf61e73a8af0-222d7f08833mr5828656637.28.1751466470686;
        Wed, 02 Jul 2025 07:27:50 -0700 (PDT)
Received: from 127.com ([50.230.198.98])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-74af5409a41sm13765094b3a.29.2025.07.02.07.27.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 02 Jul 2025 07:27:50 -0700 (PDT)
From: Pavel Begunkov <asml.silence@gmail.com>
To: io-uring@vger.kernel.org
Cc: asml.silence@gmail.com
Subject: [PATCH v4 6/6] io_uring/zcrx: prepare fallback for larger pages
Date: Wed,  2 Jul 2025 15:29:09 +0100
Message-ID: <e84bc705a4e1edeb9aefff470d96558d8232388f.1751466461.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <cover.1751466461.git.asml.silence@gmail.com>
References: <cover.1751466461.git.asml.silence@gmail.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

io_zcrx_copy_chunk() processes one page at a time, which won't be
sufficient when the net_iov size grows. Introduce a structure keeping
the target niov page and other parameters, it's more convenient and can
be reused later. And add a helper function that can efficient copy
buffers of an arbitrary length. For 64bit archs the loop inside should
be compiled out.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 io_uring/zcrx.c | 83 +++++++++++++++++++++++++++++++++----------------
 1 file changed, 56 insertions(+), 27 deletions(-)

diff --git a/io_uring/zcrx.c b/io_uring/zcrx.c
index fcc7550aa0fa..8777b90a46f3 100644
--- a/io_uring/zcrx.c
+++ b/io_uring/zcrx.c
@@ -927,6 +927,51 @@ static struct net_iov *io_zcrx_alloc_fallback(struct io_zcrx_area *area)
 	return niov;
 }
 
+struct io_copy_cache {
+	struct page		*page;
+	unsigned long		offset;
+	size_t			size;
+};
+
+static ssize_t io_copy_page(struct io_copy_cache *cc, struct page *src_page,
+			    unsigned int src_offset, size_t len)
+{
+	size_t copied = 0;
+
+	len = min(len, cc->size);
+
+	while (len) {
+		void *src_addr, *dst_addr;
+		struct page *dst_page = cc->page;
+		unsigned dst_offset = cc->offset;
+		size_t n = len;
+
+		if (folio_test_partial_kmap(page_folio(dst_page)) ||
+		    folio_test_partial_kmap(page_folio(src_page))) {
+			dst_page = nth_page(dst_page, dst_offset / PAGE_SIZE);
+			dst_offset = offset_in_page(dst_offset);
+			src_page = nth_page(src_page, src_offset / PAGE_SIZE);
+			src_offset = offset_in_page(src_offset);
+			n = min(PAGE_SIZE - src_offset, PAGE_SIZE - dst_offset);
+			n = min(n, len);
+		}
+
+		dst_addr = kmap_local_page(dst_page) + dst_offset;
+		src_addr = kmap_local_page(src_page) + src_offset;
+
+		memcpy(dst_addr, src_addr, n);
+
+		kunmap_local(src_addr);
+		kunmap_local(dst_addr);
+
+		cc->size -= n;
+		cc->offset += n;
+		len -= n;
+		copied += n;
+	}
+	return copied;
+}
+
 static ssize_t io_zcrx_copy_chunk(struct io_kiocb *req, struct io_zcrx_ifq *ifq,
 				  struct page *src_page, unsigned int src_offset,
 				  size_t len)
@@ -939,11 +984,9 @@ static ssize_t io_zcrx_copy_chunk(struct io_kiocb *req, struct io_zcrx_ifq *ifq,
 		return -EFAULT;
 
 	while (len) {
-		size_t copy_size = min_t(size_t, PAGE_SIZE, len);
-		const int dst_off = 0;
+		struct io_copy_cache cc;
 		struct net_iov *niov;
-		struct page *dst_page;
-		void *dst_addr, *src_addr;
+		size_t n;
 
 		niov = io_zcrx_alloc_fallback(area);
 		if (!niov) {
@@ -951,25 +994,22 @@ static ssize_t io_zcrx_copy_chunk(struct io_kiocb *req, struct io_zcrx_ifq *ifq,
 			break;
 		}
 
-		dst_page = io_zcrx_iov_page(niov);
-		dst_addr = kmap_local_page(dst_page);
-		src_addr = kmap_local_page(src_page);
-
-		memcpy(dst_addr, src_addr + src_offset, copy_size);
+		cc.page = io_zcrx_iov_page(niov);
+		cc.offset = 0;
+		cc.size = PAGE_SIZE;
 
-		kunmap_local(src_addr);
-		kunmap_local(dst_addr);
+		n = io_copy_page(&cc, src_page, src_offset, len);
 
-		if (!io_zcrx_queue_cqe(req, niov, ifq, dst_off, copy_size)) {
+		if (!io_zcrx_queue_cqe(req, niov, ifq, 0, n)) {
 			io_zcrx_return_niov(niov);
 			ret = -ENOSPC;
 			break;
 		}
 
 		io_zcrx_get_niov_uref(niov);
-		src_offset += copy_size;
-		len -= copy_size;
-		copied += copy_size;
+		src_offset += n;
+		len -= n;
+		copied += n;
 	}
 
 	return copied ? copied : ret;
@@ -979,19 +1019,8 @@ static int io_zcrx_copy_frag(struct io_kiocb *req, struct io_zcrx_ifq *ifq,
 			     const skb_frag_t *frag, int off, int len)
 {
 	struct page *page = skb_frag_page(frag);
-	u32 p_off, p_len, t, copied = 0;
-	int ret = 0;
 
-	off += skb_frag_off(frag);
-
-	skb_frag_foreach_page(frag, off, len,
-			      page, p_off, p_len, t) {
-		ret = io_zcrx_copy_chunk(req, ifq, page, p_off, p_len);
-		if (ret < 0)
-			return copied ? copied : ret;
-		copied += ret;
-	}
-	return copied;
+	return io_zcrx_copy_chunk(req, ifq, page, off + skb_frag_off(frag), len);
 }
 
 static int io_zcrx_recv_frag(struct io_kiocb *req, struct io_zcrx_ifq *ifq,
-- 
2.49.0


