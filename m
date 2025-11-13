Return-Path: <io-uring+bounces-10572-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ams.mirrors.kernel.org (ams.mirrors.kernel.org [IPv6:2a01:60a::1994:3:14])
	by mail.lfdr.de (Postfix) with ESMTPS id 6DD69C56FC7
	for <lists+io-uring@lfdr.de>; Thu, 13 Nov 2025 11:50:12 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ams.mirrors.kernel.org (Postfix) with ESMTPS id 05B3034B634
	for <lists+io-uring@lfdr.de>; Thu, 13 Nov 2025 10:47:37 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1A4C83385B3;
	Thu, 13 Nov 2025 10:46:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="f6oc9gFF"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-wr1-f45.google.com (mail-wr1-f45.google.com [209.85.221.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 42AD7337B9D
	for <io-uring@vger.kernel.org>; Thu, 13 Nov 2025 10:46:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763030790; cv=none; b=L1kGcmHDELDL7DO+4O4I20cK9+M8KJFoMKpcua6T+oie4AgYHxdFRRBnF0+USWT1pG3f1N9MZozTVZiY0i1kXF83bbdeZQasyJ2ElE6iVsuKYZiN2PFnQa730iwS9IL3nhXMk0FKa6cAha4kL6l3jz6U80/JpLqeFGpvUIrIbJU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763030790; c=relaxed/simple;
	bh=MB459NgRBJTpj8ZVa00h50/fi42AOTxG1P5e1Mzw0ro=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=geNHvY+0aVug5BA1HwoftaFS5iVi3G+vajUbuM8UJR+ojZi/jpRmB0pY/JzdLDjjKmjC3Hcybp0GXL3GZFN6O54GOq6Z4417y4KbARzjw7S6vVcFVAGCo5rKtX/oZmo7X++Mq+VXqSn0zTxj7V3reLc0+GvgqQXEGAYEnKQB0E0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=f6oc9gFF; arc=none smtp.client-ip=209.85.221.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-wr1-f45.google.com with SMTP id ffacd0b85a97d-42b3b0d76fcso458980f8f.3
        for <io-uring@vger.kernel.org>; Thu, 13 Nov 2025 02:46:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1763030786; x=1763635586; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=e5miRC+rORpYyD9zhfM8G6TTIhPXZRB5wvOWpVBzGlM=;
        b=f6oc9gFFVGSDxrHfYZxKP6Iu0xNNUFIvQmcsmH4YTFE5mVQa0G9mCtIJJAzR4XLoNc
         UCUZWLWxTtO3JCjnUmj1Ng7fguyx1LOosnUV2bqrpG1YE82vkdFAxWu8VJP2bbKIFp7w
         RFqS5rqG7A0Ts3CsAh2OHtkAV3FrJMUsajovt1Vvd7qbT8n9n58mf1tydui8j50N4pYb
         zZly7wD3jpQn8C47qRGKTQAXEpY2335h1b2ZyfiJzr9UCHQ2ohKdPxc0Lpn8tnzmN7Ob
         Xf2Sd05w4Q2TA73oo0G1L2fpFRz5rtb3/IWhEE5DtUP0Q7YxcPRqqMTQZQtjyTRwQwVo
         5kMg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1763030786; x=1763635586;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=e5miRC+rORpYyD9zhfM8G6TTIhPXZRB5wvOWpVBzGlM=;
        b=XTgBQF/0f3CHzqgcI9rF5/okoTu6haRaxygt22zI/pI40MTjdd4PsyTgEL7zCz6qRS
         mK2BmOJM6TlKUP5R/52r5kDpksP1U9T56tqoYGTq6ZiFnbXX2WpsWjYulsl6zf+gcEai
         hajTz4DZjUU3eGXIANFO4w4OL3GOGop9BOjxkLbWPeEfR140Koit0w+s66RMCXz/mryz
         uTb+iwcbMeyB179ISxT7pLM7t4wJqn735A/nbOMgGip1Fnr5Ue/IaM5XZcfxA1IgZko+
         FCEo3Cdyzvj24ev5aeH/N0bBIjb3TqY0iQROBvP5mMw4powNe4Tym0e9nvs8bHAWYlEf
         XElA==
X-Gm-Message-State: AOJu0YyKOif8kOQntxLH6BkS7T2rc+f+IK9KIBsB8NygiAk7KAuuMJ2y
	rhC3E39KM36scdGjHh4wmQUiaNKihd4NLgMYOSag91wm8oOzNFjetuAxL9LIEg==
X-Gm-Gg: ASbGncsP+Svs4u+HjRGXHp6WDwi38Hn6CbmY9Tcscl4QOZ2hGs0p0KBJ3PCvf5w1s03
	7s5ffKvQZSSTWDV0XpCFe+DidLQP0i5RnH/9cosHyBlX7s1VMHfIHN5iNQMK0J/s9Z0cV1XvCjL
	zVMD3WKdW+eFqibC4cCoN4Qm98BH9U9oJKU7Q3ugBg4GTr834rugPdmpOIyUDEh7jP8fjFLKwOZ
	y6UbIFPN3p5OyjgNFiz8Xj5d+ivXLVI9QA9wrYDgkooogykKemb9QJH8Co8cSU1plYQq/JoS2OZ
	lUM/sJ5Aed+KeCQALWkr0fQ69eUj4RlB7TJ83BM2u1KzsWU6myo3tKVvceXGcFIt02tnMxA8JZB
	C81V+CcD/ju8q7zAX0LJw5zOMtZc3WEL7PxUPx66A/cPBaSAsb8+rHepGI+0=
X-Google-Smtp-Source: AGHT+IElO6NSXxpixZ4zTY/0RhwvJ17n4EkEfbJdPC54BjOF0k46b0LyQbn6ImZ7vD/9+bUocUwBMg==
X-Received: by 2002:a5d:588a:0:b0:42b:4177:7135 with SMTP id ffacd0b85a97d-42b4bdaa6e4mr5841911f8f.41.1763030786018;
        Thu, 13 Nov 2025 02:46:26 -0800 (PST)
Received: from 127.com ([2620:10d:c092:600::1:6794])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-42b53e7b12asm3135210f8f.10.2025.11.13.02.46.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 13 Nov 2025 02:46:23 -0800 (PST)
From: Pavel Begunkov <asml.silence@gmail.com>
To: io-uring@vger.kernel.org
Cc: asml.silence@gmail.com,
	axboe@kernel.dk,
	netdev@vger.kernel.org
Subject: [PATCH 01/10] io_uring/zcrx: convert to use netmem_desc
Date: Thu, 13 Nov 2025 10:46:09 +0000
Message-ID: <023f56bc9528ce17d28f03f0bc25d60dea074b15.1763029704.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <cover.1763029704.git.asml.silence@gmail.com>
References: <cover.1763029704.git.asml.silence@gmail.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Convert zcrx to struct netmem_desc, and use struct net_iov::desc to
access its fields instead of struct net_iov inner union alises.
zcrx only directly reads niov->pp, so with this patch it doesn't depend
on the union anymore.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 io_uring/zcrx.c | 12 +++++++-----
 1 file changed, 7 insertions(+), 5 deletions(-)

diff --git a/io_uring/zcrx.c b/io_uring/zcrx.c
index c57ab332acbd..635ee4eb5d8d 100644
--- a/io_uring/zcrx.c
+++ b/io_uring/zcrx.c
@@ -696,12 +696,12 @@ static void io_zcrx_return_niov(struct net_iov *niov)
 {
 	netmem_ref netmem = net_iov_to_netmem(niov);
 
-	if (!niov->pp) {
+	if (!niov->desc.pp) {
 		/* copy fallback allocated niovs */
 		io_zcrx_return_niov_freelist(niov);
 		return;
 	}
-	page_pool_put_unrefed_netmem(niov->pp, netmem, -1, false);
+	page_pool_put_unrefed_netmem(niov->desc.pp, netmem, -1, false);
 }
 
 static void io_zcrx_scrub(struct io_zcrx_ifq *ifq)
@@ -815,7 +815,7 @@ static void io_zcrx_ring_refill(struct page_pool *pp,
 		if (!page_pool_unref_and_test(netmem))
 			continue;
 
-		if (unlikely(niov->pp != pp)) {
+		if (unlikely(niov->desc.pp != pp)) {
 			io_zcrx_return_niov(niov);
 			continue;
 		}
@@ -1082,13 +1082,15 @@ static int io_zcrx_recv_frag(struct io_kiocb *req, struct io_zcrx_ifq *ifq,
 			     const skb_frag_t *frag, int off, int len)
 {
 	struct net_iov *niov;
+	struct page_pool *pp;
 
 	if (unlikely(!skb_frag_is_net_iov(frag)))
 		return io_zcrx_copy_frag(req, ifq, frag, off, len);
 
 	niov = netmem_to_net_iov(frag->netmem);
-	if (!niov->pp || niov->pp->mp_ops != &io_uring_pp_zc_ops ||
-	    io_pp_to_ifq(niov->pp) != ifq)
+	pp = niov->desc.pp;
+
+	if (!pp || pp->mp_ops != &io_uring_pp_zc_ops || io_pp_to_ifq(pp) != ifq)
 		return -EFAULT;
 
 	if (!io_zcrx_queue_cqe(req, niov, ifq, off + skb_frag_off(frag), len))
-- 
2.49.0


