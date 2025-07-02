Return-Path: <io-uring+bounces-8572-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id B2BAEAF5A66
	for <lists+io-uring@lfdr.de>; Wed,  2 Jul 2025 16:02:24 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 420E94E6EE6
	for <lists+io-uring@lfdr.de>; Wed,  2 Jul 2025 14:02:22 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0D53C27EFF4;
	Wed,  2 Jul 2025 14:02:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="AqU7eOtK"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pl1-f179.google.com (mail-pl1-f179.google.com [209.85.214.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7411A283FD6
	for <io-uring@vger.kernel.org>; Wed,  2 Jul 2025 14:02:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.179
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751464934; cv=none; b=dv0Nkt0CEfJDNtAuFeOtjzO6sxH00Tkm5j63zsSxVGepU6etlxaacz4a7I2bXs3cXFwwUbI4lJKC4/dLXMpKmDgkclFBrQS9M79+FItSy/7yJXsMlE4WshazCkUEPD+3zb/vd748ixAtd/ruFGSj2EnlqB5aADg1BjL+UodVXH4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751464934; c=relaxed/simple;
	bh=GCbjNgrnzL0JicFY+yViQ6z8X1teqau6I+GR1R1ZZ1k=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Zea4+hYMacHSMIdKejN9R+48Hx6xFm9/IMPYojmU0bN4hESOItsQGOLPuSR9pPHOEqcm5/HvKaoWSsndULoLJMqIA3GcMWy73LKAp1vnUjDK7w7gagNgLu5b6IuSsdb73tM3M4j3/z9FeM1pwThRmrFevgCJ1FgfC9kIcMj1Kyw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=AqU7eOtK; arc=none smtp.client-ip=209.85.214.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pl1-f179.google.com with SMTP id d9443c01a7336-235f9ea8d08so62584105ad.1
        for <io-uring@vger.kernel.org>; Wed, 02 Jul 2025 07:02:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1751464932; x=1752069732; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ZD99yD0TSzPVpAJz28qebnzzkPnavwK+Wf/9ls/JjCc=;
        b=AqU7eOtKs1wz/dc0IjSsou70ftDelT7UM19ohpj8N0fsKVwevKnO2vepJDz+qA4qNd
         R82cJM8Dgs4T8UK0AVNmyGRvGu4AOxpjpnrJHuH5+6Xs49XdMqgkRgepMACRIrSCUUxe
         WHKVVLDDvc/ofOdvgICcuhqTKc6b80h2X3OC5xsgAhFIMubLAaoxGcu4Yq9h0/YWU+HE
         iSBT3+WE/x60//oPYJus914ikdxpRg2y08WAhbcKJQsRhZrCw4e6ZIJefN9l51euTbNE
         IA7VJ/fr7/3pPg5aMQjmRW/gZ1da6VdiCgHctdQL8cOKFxgO84mZPFiM9YgGeJ7KJ3VP
         J2LQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1751464932; x=1752069732;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=ZD99yD0TSzPVpAJz28qebnzzkPnavwK+Wf/9ls/JjCc=;
        b=FtqgPQq4WIpfuP8AtLHIbfTxeBeBP6oZajn2KP0bIeS4d0cDsDTwsXLP/+GrcPjIqz
         H8P/tP0DtbR+kigUWL23eeG02E9+jasfpMpYeO1JYTKJzxAWWU95LZ/lFA6OkSM9Jomx
         n76zSf0YxJ4zU+/Vv+JbHWoljMfiUbnkgDGVpRY0kTiFTOYqvF06rizuxjtpeX9lbVfx
         Y4cz9RnydLCm40lzujae0MOc95Pk+PS0DpWuI8AGB2/qRzln7pGqQk9iW+ZxxU2Erv6f
         58DScbK7ugYC96sJuXa62Nih16AHUd4dcxrSLXW9YmNstTVbPIypLFXPUup8I7/N4cub
         YynQ==
X-Gm-Message-State: AOJu0Yw5mpLA7aGdofPOQIKuTJAV8+ZDBVdZ5EOo8db+TNgE01jHTIbD
	F3MsclJYukxpUDlTTtwUWs315X4mJ+mmExtDKDSN3IHHAUPN6Ehol6lkiKgP2BcN
X-Gm-Gg: ASbGncsQr8OZC0nLxSanQNAz0l1d8i4yDS1/uoqDdyn7Ck0xHklhy9ExxAIWgoss/zE
	elM4REMiBX+7+1FeQg5+ekPHsTaqhJXdvM6RvWRBm+dYwX247LqquMr6O9QHyUU4ftAArwY/wQB
	3ppkpsRG3Imi+7MlSay6LxrxwxrxgN+6xxTLjE+8LJ0hY4a6XafKTE8rDFdrK3/nGfB15DE+9Xx
	fvmtldXB2ZPCENoAHvivX6YSCNxVnEh6PpfMdXOhIYId2FbZjO9yRJ8iOILWCg/oYHSIdKfYekD
	J6BgtIv9wowC2aXX4L0ytV+FLI37yBAf0HuwTw/0qsRWSwrqNF83VheiOe8=
X-Google-Smtp-Source: AGHT+IFfNkC9nCpa6bMeBgcokYhPx1LqwJ2JCh2xsMgXAU5icgn/sOj1ZX+8INYns+B4aujgPr8wSQ==
X-Received: by 2002:a17:902:cec5:b0:235:6aa:1675 with SMTP id d9443c01a7336-23c6e5dd889mr53740305ad.52.1751464932182;
        Wed, 02 Jul 2025 07:02:12 -0700 (PDT)
Received: from 127.com ([50.230.198.98])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-23acb3c6e14sm126828135ad.228.2025.07.02.07.02.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 02 Jul 2025 07:02:11 -0700 (PDT)
From: Pavel Begunkov <asml.silence@gmail.com>
To: io-uring@vger.kernel.org
Cc: asml.silence@gmail.com
Subject: [PATCH v3 6/6] io_uring/zcrx: prepare fallback for larger pages
Date: Wed,  2 Jul 2025 15:03:26 +0100
Message-ID: <abdb66b4382c5f1c245247f947b24b065844d211.1751464343.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <cover.1751464343.git.asml.silence@gmail.com>
References: <cover.1751464343.git.asml.silence@gmail.com>
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
 io_uring/zcrx.c | 82 +++++++++++++++++++++++++++++++++----------------
 1 file changed, 55 insertions(+), 27 deletions(-)

diff --git a/io_uring/zcrx.c b/io_uring/zcrx.c
index fcc7550aa0fa..adcf70fb3cef 100644
--- a/io_uring/zcrx.c
+++ b/io_uring/zcrx.c
@@ -927,6 +927,50 @@ static struct net_iov *io_zcrx_alloc_fallback(struct io_zcrx_area *area)
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
@@ -939,11 +983,9 @@ static ssize_t io_zcrx_copy_chunk(struct io_kiocb *req, struct io_zcrx_ifq *ifq,
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
@@ -951,25 +993,22 @@ static ssize_t io_zcrx_copy_chunk(struct io_kiocb *req, struct io_zcrx_ifq *ifq,
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
@@ -979,19 +1018,8 @@ static int io_zcrx_copy_frag(struct io_kiocb *req, struct io_zcrx_ifq *ifq,
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


