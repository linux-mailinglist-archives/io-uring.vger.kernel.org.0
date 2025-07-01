Return-Path: <io-uring+bounces-8553-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id E9708AEFA90
	for <lists+io-uring@lfdr.de>; Tue,  1 Jul 2025 15:30:44 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 5C0711893793
	for <lists+io-uring@lfdr.de>; Tue,  1 Jul 2025 13:28:33 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6527F276026;
	Tue,  1 Jul 2025 13:26:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="YnTi+8f8"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pf1-f171.google.com (mail-pf1-f171.google.com [209.85.210.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D6983275AE0
	for <io-uring@vger.kernel.org>; Tue,  1 Jul 2025 13:26:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751376380; cv=none; b=WMmm0eH7wwztimnnti4bYdHCu8pQKfU6fIgrtZRJk/Ov9DX4YhQQGbrkTCLAUybO3cKKrL1TKLc9D/WtT7jbA4TCge3uafhvKYf5gObIIgbdQhDG+vYCkyRAoRh8B+IZg5SFhQhPtGM4WJzMXrspMRhlF70lMEHdxSenvkVP/wI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751376380; c=relaxed/simple;
	bh=4OFf5Hb905eFuvFC3PdSs9Tv2OSIUaSCSMnXgwpLnT0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HQaip/SIGr1lsdiNXm6IQZIDTlQ9Vf0cC4Kz+i0m7aIRvcvh1zZxlhFLB+awrzHqCZXRWqwwO0Mm+//DT8xbJJlrvJGpEY9TBegy3xtCnF6JeJ/nIGFB0Kng1eV3CrsE667oMW+pcnJ0HRnabtwxjX+HYHvSp0n9WmA3/OAH5vA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=YnTi+8f8; arc=none smtp.client-ip=209.85.210.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pf1-f171.google.com with SMTP id d2e1a72fcca58-748f5a4a423so2016175b3a.1
        for <io-uring@vger.kernel.org>; Tue, 01 Jul 2025 06:26:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1751376377; x=1751981177; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=IAc+jVeSquKm/tIell4OX+9rFxYJdq94AKJ2GG1EWOY=;
        b=YnTi+8f8nfPKlRX+XjOXcNoO+5xeWyoWgSKmV5ClqWsO1nW5da/fNBDNaxWzRzE01q
         jkVL8rUlVDzKbVLcmzWk+7tAgHi77vfqEy3scH/CIRai48FcNN8iHDsihRyEQSQjJMfP
         //7YXDgjYWOKiJqywByom9szv1TgCARLyliBmFPDngwiS6JJaivSeEHYepAoen4CBzx9
         /i7JG+h6GMkoH7O0xsiAcmKfYFOxpZTK9w+9hzv4a+zkfWcpO0SWlql/gf+YDl9vhKna
         o3mNl6KrUr3mEk0c7+mczjTtedVZTkw1n5C+JPyTPYfcsd30/i3ioauLgPnC1hm2W5RT
         Xd9w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1751376377; x=1751981177;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=IAc+jVeSquKm/tIell4OX+9rFxYJdq94AKJ2GG1EWOY=;
        b=sfGn+nj7NwGNkPuMrlQ6gOzEjiGIOaMhqfr6owwuuKiAmJBT9y475Fq94waAzRZl64
         hSQknd6ruwM45kLHPnTNR6S4H4ZwbG20AspnCxiq7QNCGSkM57iAZsmgZSBLLoIFaGHS
         WWwe3/nw3+lKmZNcu6ha1/V5ZSWrnAY2j4PTowcivNAgOuBmyUQE20uhQmEo7U0+bF4A
         3mkYBy1ZoTu/3rgrn4/VDLt/3c4xO0bbAhvjlXXBc+9J7lFl8A6zW3vCF5gntM/tZapj
         HGxRGks/nD0m1aA4nuhw19SvRyl6l7djrLKmeCQ9p1qZCskj6TcD5qRw1SPS0weK7aD5
         kkvw==
X-Gm-Message-State: AOJu0YyEIXvK6XoWLTj3a0+KakepBtY0IcOEE1WRzuDjcr9bMBTNiolC
	528JnxRhJY5qreqW49MxvXjGZrSl7eRl5n8A08PkM7V96vFzsilcc96NG6jNMsFO
X-Gm-Gg: ASbGncvq4Oy7RfvLo/d4MskO+x9jnkM/GCefYU/iMuHFoMHaO6RGI3CXaUs2DK/iLPu
	DS4Ac+jjqzLcnjjdd/c6jGgzRxXOp6cyhg9RB3iZrwvS+LRRMT1RcVWyPOtesRvL7dNd+ztI7v0
	cXGSUT53M0yoS1m3YATqWBvTByuf7IuLewRNRl0s9VVAHtBNLGXwCETC/XUah9TO6j22ldMzNx9
	sPcP+h70xWazfFCwUqCXa0xL7O0/udBgLpINnluco7IUdQlESyALpumHISEPV8WqPb1jIklRGfq
	ImpsMH6BHl23EFfuz8v9kBKnw4cvrLx0DIDC0nxTxnpCdPpPLGiwHvY92X9BcV9weUk4jw==
X-Google-Smtp-Source: AGHT+IGlgT2nwgom+7SrZ1tp7GjWxL+M+971aON/Z/RX6vPLG8adcfDeFrYvyCXo1YT7WZ9Zvkz8SQ==
X-Received: by 2002:a05:6a21:998e:b0:220:658:860 with SMTP id adf61e73a8af0-220a12a7bd4mr27482025637.12.1751376376745;
        Tue, 01 Jul 2025 06:26:16 -0700 (PDT)
Received: from 127.com ([50.230.198.98])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-74af557439csm11788025b3a.80.2025.07.01.06.26.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 01 Jul 2025 06:26:16 -0700 (PDT)
From: Pavel Begunkov <asml.silence@gmail.com>
To: io-uring@vger.kernel.org
Cc: asml.silence@gmail.com
Subject: [PATCH v2 1/6] io_uring/zcrx: always pass page to io_zcrx_copy_chunk
Date: Tue,  1 Jul 2025 14:27:27 +0100
Message-ID: <b8f9f4bac027f5f44a9ccf85350912d1db41ceb8.1751376214.git.asml.silence@gmail.com>
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


