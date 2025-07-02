Return-Path: <io-uring+bounces-8575-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 394B9AF5B1B
	for <lists+io-uring@lfdr.de>; Wed,  2 Jul 2025 16:27:55 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 5DC7C4E6F90
	for <lists+io-uring@lfdr.de>; Wed,  2 Jul 2025 14:27:55 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1B6A72F4A0D;
	Wed,  2 Jul 2025 14:27:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="UBqwN6ew"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pf1-f174.google.com (mail-pf1-f174.google.com [209.85.210.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9342470810
	for <io-uring@vger.kernel.org>; Wed,  2 Jul 2025 14:27:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751466470; cv=none; b=lwLGNRB5w3xmDKBGW+4lbS46sCMs8CKKAzZlS3L6NSgjuv8YAR8UAH98IglMx55JqXxusXVMzVCqG5KwMVKjaQl57YipR5TbDcBEj9bV3MoEsvxPjUxku3+wo1gLotUr7l+x8R1Hv9RqjEP/+VwTb9Dfua5PLrPqzVRcKy9W70w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751466470; c=relaxed/simple;
	bh=4OFf5Hb905eFuvFC3PdSs9Tv2OSIUaSCSMnXgwpLnT0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=i+NQId7LnF5PV0iTaPCms9XNCGLdwl2/AIif9GKJKuzu8UnV8mRiSTC8DbOFNHLW+Aa2cfRbpgZAOuIQygRWzR5pu7eCuCU1FkctBbeMDHEqL0x8h+2aDdoW0nqByJrOJFUyQRK/gBzv/S9EMgHM/ytrKSm5xaLtOzJpMyi+FjA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=UBqwN6ew; arc=none smtp.client-ip=209.85.210.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pf1-f174.google.com with SMTP id d2e1a72fcca58-74801bc6dc5so6250253b3a.1
        for <io-uring@vger.kernel.org>; Wed, 02 Jul 2025 07:27:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1751466467; x=1752071267; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=IAc+jVeSquKm/tIell4OX+9rFxYJdq94AKJ2GG1EWOY=;
        b=UBqwN6ewe4YpTpHNbDurbnxK0Ar35RWnTDXiHegfe6JC4m6I+1n8x2WIrkaBi5T5W5
         fHvAoMPS/ILpKHKVH8U+GbqqiEUg95gOQv5MtXtOIEwoBf355c7bkOgU0nqgv5P56Zv9
         nsrLwbu9EPcNhMNonQS7NQX8PHL4AG9rgFgVrGQoSiHvx2wXGQoVU9Iwpbam3872CO6e
         HqiCph4gJfg64Gca05sQER6GTRnNLaTxSS9VwXJWr6jqXzAZli61aC7JhBWZJlyRNxCI
         f1t+I/e9bHyH5j0JlkARVAtE1Z0oHQ42F9Ht85+uUZAAnAN3EvS61g/8qW1jb7uEl+9z
         dKEQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1751466467; x=1752071267;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=IAc+jVeSquKm/tIell4OX+9rFxYJdq94AKJ2GG1EWOY=;
        b=oqhM+lnlT2rjO9N3u5wlRyrrHEdiOeNuz4yKM67Rnhx6B/gEeYNizNYVRBMkSM+ddM
         BHQN3TnZKRfwsXisV+AaCCqPevQ7N0lbSuiB0JlI3lSepUw6/qHWX6NeTotgQcDFekId
         BbZFe+hqK9hYB5M+NmFJyjUv6Q+KIQFuoCVARqW3oVSbZDCgj+AOyqtgWkOGJiaD3jfb
         NJN1OUWt92hCv9RgEZ2t6JCUGlRJJQXdpNb+rylANOt85ir9487Lzl0ZMxWdn8GUBSmW
         yMpni9lZqZiMVZOF2rsEgX/zeX/AyC7NJmwNrZ64iaZZqBMCJTOctnVSYy0GA0vow69k
         2+fg==
X-Gm-Message-State: AOJu0YyLWQ3gMqDlsddLBH3bxyGuDGO1YQkP5iekEe/OxKhQV+x/Cd9X
	orrhMe/4QXRcjVDJg5GT3fqM5HkV94jHdeiIWac+bzW2uq4lqo5hprj2/w5GLMvh
X-Gm-Gg: ASbGnctuCuiD0fCO6NEAAma8txZCOZDp5USO1sxlmYk0ayW7mg3d7rX9uolExp5f9Mw
	szQgRqlnM7K2VJFQzBNw7z7aopc+XSFSVCYCfkDhIiXlcI+3smMVRjJMH8c4MQRkPNyuikiyrSG
	CEhuORHFxBnUlkrVX5afUSlZnn/y88dR3CPd+QPRwZBrE5Z5ZK4SjBSaiCHDtbVew0vAeRcewtH
	3ICeAtSi+EXW1GW+UsrBllhK4jOyNMKaruZDCJYpKvkrOdro7Y4xZKgReWFDTBpiZsSvvU5BoCw
	ZmyAX438TNwJmfAZdApIfTytvfSMI5J+BiNz3IsR1h7yMwdKwk/Cbqb8yY8=
X-Google-Smtp-Source: AGHT+IEd14ioKlRLvI9Da8pJroqt1Dp1Y4LxXALq0NbTC9pNes8ThWABlTx7XSwoD1it+vqIaveqkw==
X-Received: by 2002:a05:6a00:3d4c:b0:744:a240:fb1b with SMTP id d2e1a72fcca58-74b51fa0bb1mr4366908b3a.5.1751466467331;
        Wed, 02 Jul 2025 07:27:47 -0700 (PDT)
Received: from 127.com ([50.230.198.98])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-74af5409a41sm13765094b3a.29.2025.07.02.07.27.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 02 Jul 2025 07:27:46 -0700 (PDT)
From: Pavel Begunkov <asml.silence@gmail.com>
To: io-uring@vger.kernel.org
Cc: asml.silence@gmail.com
Subject: [PATCH v4 1/6] io_uring/zcrx: always pass page to io_zcrx_copy_chunk
Date: Wed,  2 Jul 2025 15:29:04 +0100
Message-ID: <b8f9f4bac027f5f44a9ccf85350912d1db41ceb8.1751466461.git.asml.silence@gmail.com>
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

io_zcrx_copy_chunk() currently takes either a page or virtual address.
Unify the parameters, make it take pages and resolve the linear part
into a page the same way general networking code does that.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 io_uring/zcrx.c | 21 ++++++++++-----------
 1 file changed, 10 insertions(+), 11 deletions(-)

diff --git a/io_uring/zcrx.c b/io_uring/zcrx.c
index 797247a34cb7..99a253c1c6c5 100644
--- a/io_uring/zcrx.c
+++ b/io_uring/zcrx.c
@@ -943,8 +943,8 @@ static struct net_iov *io_zcrx_alloc_fallback(struct io_zcrx_area *area)
 }
 
 static ssize_t io_zcrx_copy_chunk(struct io_kiocb *req, struct io_zcrx_ifq *ifq,
-				  void *src_base, struct page *src_page,
-				  unsigned int src_offset, size_t len)
+				  struct page *src_page, unsigned int src_offset,
+				  size_t len)
 {
 	struct io_zcrx_area *area = ifq->area;
 	size_t copied = 0;
@@ -958,7 +958,7 @@ static ssize_t io_zcrx_copy_chunk(struct io_kiocb *req, struct io_zcrx_ifq *ifq,
 		const int dst_off = 0;
 		struct net_iov *niov;
 		struct page *dst_page;
-		void *dst_addr;
+		void *dst_addr, *src_addr;
 
 		niov = io_zcrx_alloc_fallback(area);
 		if (!niov) {
@@ -968,13 +968,11 @@ static ssize_t io_zcrx_copy_chunk(struct io_kiocb *req, struct io_zcrx_ifq *ifq,
 
 		dst_page = io_zcrx_iov_page(niov);
 		dst_addr = kmap_local_page(dst_page);
-		if (src_page)
-			src_base = kmap_local_page(src_page);
+		src_addr = kmap_local_page(src_page);
 
-		memcpy(dst_addr, src_base + src_offset, copy_size);
+		memcpy(dst_addr, src_addr + src_offset, copy_size);
 
-		if (src_page)
-			kunmap_local(src_base);
+		kunmap_local(src_addr);
 		kunmap_local(dst_addr);
 
 		if (!io_zcrx_queue_cqe(req, niov, ifq, dst_off, copy_size)) {
@@ -1003,7 +1001,7 @@ static int io_zcrx_copy_frag(struct io_kiocb *req, struct io_zcrx_ifq *ifq,
 
 	skb_frag_foreach_page(frag, off, len,
 			      page, p_off, p_len, t) {
-		ret = io_zcrx_copy_chunk(req, ifq, NULL, page, p_off, p_len);
+		ret = io_zcrx_copy_chunk(req, ifq, page, p_off, p_len);
 		if (ret < 0)
 			return copied ? copied : ret;
 		copied += ret;
@@ -1065,8 +1063,9 @@ io_zcrx_recv_skb(read_descriptor_t *desc, struct sk_buff *skb,
 		size_t to_copy;
 
 		to_copy = min_t(size_t, skb_headlen(skb) - offset, len);
-		copied = io_zcrx_copy_chunk(req, ifq, skb->data, NULL,
-					    offset, to_copy);
+		copied = io_zcrx_copy_chunk(req, ifq, virt_to_page(skb->data),
+					    offset_in_page(skb->data) + offset,
+					    to_copy);
 		if (copied < 0) {
 			ret = copied;
 			goto out;
-- 
2.49.0


