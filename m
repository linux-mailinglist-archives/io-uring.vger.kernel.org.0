Return-Path: <io-uring+bounces-9929-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [IPv6:2605:f480:58:1:0:1994:3:14])
	by mail.lfdr.de (Postfix) with ESMTPS id 3B8A5BC5242
	for <lists+io-uring@lfdr.de>; Wed, 08 Oct 2025 15:11:26 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id 267604E392E
	for <lists+io-uring@lfdr.de>; Wed,  8 Oct 2025 13:11:25 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EDD4027AC4C;
	Wed,  8 Oct 2025 13:11:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="drjZmQC8"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-wm1-f43.google.com (mail-wm1-f43.google.com [209.85.128.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 315792765DF
	for <io-uring@vger.kernel.org>; Wed,  8 Oct 2025 13:11:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759929082; cv=none; b=iZiUoVeVweyjDZWUNCsKwr5cf23xY/vDD0bMh8YvEfJ3POYz4p69VHpw2tPRZ1yX9OT+qLruXAwm8oPZeUFfON5tJ5+pzZgfN+s0jOrmcm40DjvkCXPWWBheLsW+JbwecTmgwGp1wQQJxZ+FsfOLBgnXOqFFbQTBYOkClKskJXw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759929082; c=relaxed/simple;
	bh=Tppkg4MldLBgBrI9SzjD/Q3iLLzNpMq+oU6yavdK2rg=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=pBlAhDjkXriLQQCeoPPrIjgCEY89pizKq4VZ1+aVEyP7vdpjSc71CUm6+OA243j7Vo6ngpGpLbhuiE/CYlX28PdhFF+AohtMskP76lWf5kM7QEQ/71vSraynqqadKZaJvROSxB+MgPO4ULkj+M1CD0cISRyS4lB7FzSX9GXZjQA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=drjZmQC8; arc=none smtp.client-ip=209.85.128.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-wm1-f43.google.com with SMTP id 5b1f17b1804b1-46e33b260b9so71204945e9.2
        for <io-uring@vger.kernel.org>; Wed, 08 Oct 2025 06:11:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1759929079; x=1760533879; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=sCUt6DzpwFo9y4KJ0twUr3sa8Mj3ShUrbI048KiFl/Y=;
        b=drjZmQC8Sxzpb1dNxNmqlCidmOUTwJc8QaWo9puvsn/C1RC43MPy1M7uahRQ7W/HwU
         DjRqcc1vx/m7BVFDyqBnl/wgAQq5q54SUy7e7RloOUzWxWjU+/PZXlAuwuAojggUa3s8
         6b89QVUWEFg1tTd5wmVhNohRICpo+h1XxCUU4nCzH0f/pjY/RFQTCtULNQlq7Tdp2Y8D
         ya9V5qT/SJEOq17zu7/khAdfec2aoZzARINS23bm0LGnlebx9s6ndFSUA6vqBarfQUwY
         MtuzbpMzPoUXeBw4Hqh0P8rJym36o7Y3OkhAWVCMZlW9sNH4Ev6/yLVBqX9OZRDsIE3s
         n1Yw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1759929079; x=1760533879;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=sCUt6DzpwFo9y4KJ0twUr3sa8Mj3ShUrbI048KiFl/Y=;
        b=jU0sNAXDel+BQvq9abwytyyutyGn2TXKRT3JWRvMT1W0jvFKQPUNqG+EO9wJRS8Vxt
         gWEvoc8H5+o3aCc2QE1Puw1yMiU1qA8XxwgeZAG+rnv4YxFttmGGslXakUM85RuB9wDI
         rjV1zDAUrZH10ypBHtLdPCbc4NZ1KRBmEy3utCJpdyHMdwcKe3BhqCRRy+0XdFYLkAIR
         UGHQTwKoQI7Ohy+Nitd7wADcbk/v6iXP9Q0GWY+ZEPnnZfVaN5ilRF6OVxSI65DzzagP
         AOUsox4DT+dn++cmzM/vgPdIC2iYYq3HWzdNss7p2Sbe7V9+BdJh+k9Tpc4sjAKiQseZ
         CFzA==
X-Gm-Message-State: AOJu0Yxo0iXBopwo6FHK0OikUmpL7KqxNd7J8oud9lboDqeNwRWSIPxn
	WGSU4NO4GbQw+MPSAqmPLU2VDz4uhojvKY8mRPs5gimT28GCo05p8ZxdSTgkmw==
X-Gm-Gg: ASbGncuvm9RS6Dmq1PQBIhLZi9J30vL1L3afJXBqFzFntvSae3BBCs7fjN6WgNi96Ya
	yQF29DLgUBupWG0ti4i3jAQpXiWHbPpAu6ccPhPCkkfkNgvDUhspC9t1Yp1/oQPU2yl4aHj2iTh
	kF+O83OOP1UKnsJYq0j5U9UeLS7v0SrBQC3ucDDxXmR9abaxwtc2SbV9+4RHbg13IEbwSz76hpH
	xjUgrtj9BVFH8ExSsF6RTsiJCXSM2QWB8obXHIaSmZpPDN7C9Dr4M2vAxwiSnktlMD4WPKTGdXN
	mF4vHZ1TrSOCRCRHNn/m20MEQGK3RKtobeVjPIJwoKWFH5dmUP9Fk7JkhOTR1j2A+3J6Lswbz/S
	TqCiL6z1DvJd+o9FaIBXPuYoZJjp1Pw==
X-Google-Smtp-Source: AGHT+IEMbpkJORbR9U87Ksq/ylpHUVCrODH14lyAZjRiCv7BNmRTB8rOUnB7+aOI9S5r62TUnrJM4g==
X-Received: by 2002:a05:600c:34cc:b0:46e:59dd:1b4d with SMTP id 5b1f17b1804b1-46fa9aa2076mr36974385e9.16.1759929079035;
        Wed, 08 Oct 2025 06:11:19 -0700 (PDT)
Received: from 127.com ([2620:10d:c092:600::1:b002])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-46fab3cd658sm14613725e9.1.2025.10.08.06.11.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 08 Oct 2025 06:11:18 -0700 (PDT)
From: Pavel Begunkov <asml.silence@gmail.com>
To: io-uring@vger.kernel.org
Cc: asml.silence@gmail.com,
	netdev@vger.kernel.org,
	Byungchul Park <byungchul@sk.com>
Subject: [PATCH io_uring for-review] io_uring/zcrx: convert to use netmem_desc
Date: Wed,  8 Oct 2025 14:12:54 +0100
Message-ID: <2ea0f9bd5d0dbc599d766b7b35df4132e904abc6.1759928725.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.49.0
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
index 723e4266b91f..966ed95e801d 100644
--- a/io_uring/zcrx.c
+++ b/io_uring/zcrx.c
@@ -693,12 +693,12 @@ static void io_zcrx_return_niov(struct net_iov *niov)
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
@@ -800,7 +800,7 @@ static void io_zcrx_ring_refill(struct page_pool *pp,
 		if (!page_pool_unref_and_test(netmem))
 			continue;
 
-		if (unlikely(niov->pp != pp)) {
+		if (unlikely(niov->desc.pp != pp)) {
 			io_zcrx_return_niov(niov);
 			continue;
 		}
@@ -1136,13 +1136,15 @@ static int io_zcrx_recv_frag(struct io_kiocb *req, struct io_zcrx_ifq *ifq,
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


