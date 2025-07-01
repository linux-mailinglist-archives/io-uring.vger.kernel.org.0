Return-Path: <io-uring+bounces-8558-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 3148FAEFA9C
	for <lists+io-uring@lfdr.de>; Tue,  1 Jul 2025 15:31:45 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 8D43F481C3E
	for <lists+io-uring@lfdr.de>; Tue,  1 Jul 2025 13:27:56 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 05575273818;
	Tue,  1 Jul 2025 13:26:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="eGluNH4Q"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pf1-f169.google.com (mail-pf1-f169.google.com [209.85.210.169])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 503B027604B
	for <io-uring@vger.kernel.org>; Tue,  1 Jul 2025 13:26:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.169
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751376383; cv=none; b=IkXTfvUvjn4lAQxfwRc8wI5ergjgrQ10zYSWsdRHQrWJ8dS6v3FMCoo4oD4IhExFK9X3mKVK0RxeMsJPlFamFcU+2+4SNuoU1AYUtILg6/n6FOEqZamEV3t6pIZ2zig+RsDpbDyMiF5l1MEHBfF6V7Mb5efzy/RGCGUnG5JGYSY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751376383; c=relaxed/simple;
	bh=wTRrCOlMYbkDDqB+f61IWBmriF9KFmN/adgFj3uNosc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=IqyfYm/Fwm1IpDO2NUZhSB4VRE+mapOmP4CHoMrNLezPB/7AVFkfa/q5G8X4QOPD83PWIMKraRr/gQQMocb13FiBFumeG5pN6pl0UtAuOeSqvqQHAwwk5b838hb0U0fPUMPjlr3DYhy/2yNcDhBupJde4DhRZzBasLTXxOuxoFg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=eGluNH4Q; arc=none smtp.client-ip=209.85.210.169
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pf1-f169.google.com with SMTP id d2e1a72fcca58-748f54dfa5fso4853164b3a.2
        for <io-uring@vger.kernel.org>; Tue, 01 Jul 2025 06:26:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1751376380; x=1751981180; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=+m5Q87lImDrO7buV08c+41rnXdELVGGLa3/2RQ724lM=;
        b=eGluNH4QrfCWvI1U/jQZiHKaWkPSZfnXvoB8HTOY9qMpOb3neHLi5wpWgN8nXG3oC3
         rllxeAfYylgpb46HlZi0xOXXE7aEBAhEAYvJPRhd1AKZZqUFKNyc2nyTVMIo57DhEN80
         JwJt3LtKUGAJ0OKS5mWTZminIR+s4MnurLyzvUsMgAKpGOCe2NOBQp9jwy8nNA+GINug
         8GIbwTG3Embwv9+0lceB5cQllkNcNLtJQLg2U8D9qAUvKYZ5po7f4CSmMF4RPpYg1CI6
         F8CAj1OzemtxA/EGCwZzeukPGMJZ6hFqMk129OHUJ6mAKyCvdPl/tMk1ZvSH7Fr49hBN
         523Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1751376380; x=1751981180;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=+m5Q87lImDrO7buV08c+41rnXdELVGGLa3/2RQ724lM=;
        b=OPc4z/inTCTisOjqGL/lEV8iMGZMBZGrzKniVs4BOQ5QS0rCVK+lJYk3KTu/SGtfHh
         AKgGTyu2xxyzBSydisfZU0kULWFzyCBnFfMDGQcp4MAUh+TEGrjiqT9x1yarmjmwTt70
         ndMgWhCRD4DIYStm5Z90hcr+z1cQ8AYh0K7sFJWgukiRTYiHWc9MM3C1LTuRCZTJBkaz
         Or9i04+nrJ5UPg1CX0fLTYEywdeQPf/DxXtGI1E0EI6SihP+rNYeWdr8AuzqqGVMLBwH
         jngs6qfCUGfY1Vimz5WYZB2bL8MbqTCs0fqC9jT8OrEQ7p3xgGuzYFXEhfj9FbZtn0ET
         YIjA==
X-Gm-Message-State: AOJu0Yz3G3ZIoTXWtncfaL/VoxJGUrB5dOXBKMmUOMlRdxeThQFNL4zf
	9hNCwrGm2dEP/qwxXtSJDwVYe8c/rnq80ONVPF01W2w/BrpggiIrsdv/c24YfeAq
X-Gm-Gg: ASbGncs332o5HU5SUK2rJkW/Z1nM7jC8KMDaOYAaNJ/cfP7Rt00GKjthzZTGc9JpCTr
	t0aYHaI7H5YjTQ48PsQSEtP9F/wW2P8068G4e4p2jhj5rZ5YX7nxXBBCWO19usEYXnQ0kHdX39p
	vq7d2R7VkdQHoht50ZHBgP1zLdyPy8CleMcNBxQgIKBl8ZpvNQdc2j3QlmDD6hCm7FgoT70oDXK
	dmXsUTJs8buos22ky8NX1+WWa0SroLe3gvalz9J4nH5uB2fjUbk1OdvonJwoH5qCCIKgNhYbgc4
	w8edcqw1V5FetXETsOBUiM/nulycXQfSTxWeon2B3au1DASaX4Y7kL3+dXA=
X-Google-Smtp-Source: AGHT+IEP1OSYVhs6ncy6dNz/4soFzBtxfmtA8eC/FDdwp03vvVyqUrfG+pi66dtKa6wola2yQEQeVw==
X-Received: by 2002:a05:6a00:2394:b0:748:2e1a:84e3 with SMTP id d2e1a72fcca58-74af6e94f7emr26104806b3a.8.1751376380059;
        Tue, 01 Jul 2025 06:26:20 -0700 (PDT)
Received: from 127.com ([50.230.198.98])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-74af557439csm11788025b3a.80.2025.07.01.06.26.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 01 Jul 2025 06:26:19 -0700 (PDT)
From: Pavel Begunkov <asml.silence@gmail.com>
To: io-uring@vger.kernel.org
Cc: asml.silence@gmail.com
Subject: [PATCH v2 6/6] io_uring/zcrx: prepare fallback for larger chunks
Date: Tue,  1 Jul 2025 14:27:32 +0100
Message-ID: <c08d99baa7cdc387adbad028fd4812aba2837e0c.1751376214.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <cover.1751376214.git.asml.silence@gmail.com>
References: <cover.1751376214.git.asml.silence@gmail.com>
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
index fcc7550aa0fa..cdad17e05d25 100644
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
+			n = PAGE_SIZE - offset_in_page(dst_offset);
+			dst_page = nth_page(dst_page, dst_offset / PAGE_SIZE);
+			dst_offset %= PAGE_SIZE;
+			src_page = nth_page(src_page, src_offset / PAGE_SIZE);
+			src_offset %= PAGE_SIZE;
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


