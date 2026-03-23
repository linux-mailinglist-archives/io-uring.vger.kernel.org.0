Return-Path: <io-uring+bounces-12787-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id cLrUKNA1wWm7RQQAu9opvQ
	(envelope-from <io-uring+bounces-12787-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Mon, 23 Mar 2026 13:45:04 +0100
X-Original-To: lists+io-uring@lfdr.de
Received: from sin.lore.kernel.org (sin.lore.kernel.org [104.64.211.4])
	by mail.lfdr.de (Postfix) with ESMTPS id 976EC2F2236
	for <lists+io-uring@lfdr.de>; Mon, 23 Mar 2026 13:45:03 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sin.lore.kernel.org (Postfix) with ESMTP id DC96C301280B
	for <lists+io-uring@lfdr.de>; Mon, 23 Mar 2026 12:44:18 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 611DB3A9DA1;
	Mon, 23 Mar 2026 12:44:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="PnnLbdVr"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-wr1-f54.google.com (mail-wr1-f54.google.com [209.85.221.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 092DA3A9D95
	for <io-uring@vger.kernel.org>; Mon, 23 Mar 2026 12:44:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774269849; cv=none; b=s1tNQk5jtmTcxhi3W3bBmpOLw+L7CVvecg9n36+LcpkhCAnHgI0kofzB3T7cfUEPymiQHtAFiim/7G8mObsrreBmQIlzi/r/jJg+fWC3TVIO2eRwWjXgGBKgLucUh/8UQz0sRgPLkeVeGhUe6Kxc0XJTNRZMH5s7FhsWg9iDLQM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774269849; c=relaxed/simple;
	bh=3/rkRCcO1quIWgE+HYVwINRDxRYcX3m6M/eM1+ucRFE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=c/TjVh8Qw1DdjXsBYGziyJGI+jCtC+JcRdZBBNUwD5N5lFbGmWOnoIRE3Z3vJ3P2BPL8BSIaSa9joGhPQv2wWm+wD2cBauytMAWskJVxfDWYVTA6ID/ier2kbeQuUZ8Oo5KaijBYI5YU6L/kRdv5wdr12T0lnygVT2FOIne1iFI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=PnnLbdVr; arc=none smtp.client-ip=209.85.221.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-wr1-f54.google.com with SMTP id ffacd0b85a97d-43b4915161fso2702613f8f.2
        for <io-uring@vger.kernel.org>; Mon, 23 Mar 2026 05:44:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1774269846; x=1774874646; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=D6QsFGo6QaVOFRRVJ0f3S59qili3JmOc8VCaUAYHt9w=;
        b=PnnLbdVrrH+lLmSoSUiG6v5dlSHihkkapxgl/QW4MMqYRE2GNMyB9DhV4ZmQ1Av4dH
         OpBisGw2yDhQH46UKmru9N6uaajdi7eAsfTeisLpbr9HDFSndj5qvJt6bzhTYBSGQxxv
         yJcNDsC6KN9NQfPhuUoI5A1vDbouMOECeqpbj1UOk3vQFzrAUPwz7nRifIO3bKUW2HSr
         f4yLTgbG8QUEc9yoPLtkXQjg3AgxIsNjdVhOJQOMq5s8jULBBbNmQrYc9OnnReVOorwy
         AKCL2UaerQje/AotHi7hQBEVHMKNj7AW4UAxlBt8AdO4W/cXPKtWV7gBJfpTi30p+3f3
         jH5g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1774269846; x=1774874646;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=D6QsFGo6QaVOFRRVJ0f3S59qili3JmOc8VCaUAYHt9w=;
        b=H2f5TsSDpx0gFJK+lbi7dFTbklJLyaI020VaR6OiagHIvo8vIzGuysVeuhNtcNbl4b
         Kdy4PrQ15b+JI2m0/iXomq98Ph3DFSOX4Y//o2fbrzYEFkYSWAUnIkhaVdDfIJd3MNo+
         f4PYKRDeevlIEAnG576s+W5Jp5/F22Pl0p9Z70SBNUbvuyBmGWNpRvVlmjdkoYMuhkSk
         ojMck2mbu3sV8+5qmjfRwku7q2MpPGQBz/MbLGSABzAs0+/45yLlCo0UAUU2uLunbtE0
         6Ji69fV87JhVwdrMte3yEdbAT4a21aFJh78bXFsS4jW3kJbbdAVAtQBMc9A8uJWg0NCg
         Pskg==
X-Gm-Message-State: AOJu0YxrtAfjg56a3QkC5emC+AlnxyEmakzV4GjM9TQR6xxRPwEbJd0O
	h7Q26nf47nTdj60mNQ0T9mEIRLHkYP6oMe+65CrqzXPj2syDMEUznbmevHUSrA==
X-Gm-Gg: ATEYQzxWoRrXP2aXpKEaaMboRfNVyXHcFfQCLkhY0vBlrXWWHyta3+5eWS1TvOHDyDO
	ChF0XTZMKFy/CycmapgnZYhlLm2yFP6qZXSb0MxE6NjJA8/b8VcBG20zZVJNyj/v/MZhcaZ09vC
	bvzDJN+LgSUwka6VUTaKP1+ggPZoLkBcvT3DTz0t6iJymx/vwM5l55BGyVFwA6mmJrA3bjvzk95
	4RMGRk6rIdqi4VomVvcmXiQ5ooXfSMoLCxegU4vro/SiHvFZOcjG9Zps66wl+SEtGy9joge9yWI
	LwJzGWBwoa9WieaTanxMTcXYAbR6r6/XdK0yVIF60Zre9Bk1Wfrukjsx1ql9MNgaVSnvP9xrZzc
	sfqotBb3mdN7uyRupHJuiqdhWpjHyB60eXHszLpS+8wN81NcLcJcjQ18gXt2BUTV3WnqA9PRmCv
	JHCS7x1kQsNb78s6xwaIS0rtwR4uNvQLCUPhF26BfK8ul3+OxAPetvxdKsfyiwmDJcQ7iBYaHn1
	ViG6/x+ww==
X-Received: by 2002:a05:6000:1ac7:b0:43b:447a:11b8 with SMTP id ffacd0b85a97d-43b64233eadmr19966108f8f.6.1774269845822;
        Mon, 23 Mar 2026 05:44:05 -0700 (PDT)
Received: from 127.com ([2620:10d:c092:600::1:6969])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-43b6425eeb4sm25520861f8f.0.2026.03.23.05.44.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 23 Mar 2026 05:44:05 -0700 (PDT)
From: Pavel Begunkov <asml.silence@gmail.com>
To: io-uring@vger.kernel.org
Cc: asml.silence@gmail.com,
	axboe@kernel.dk,
	netdev@vger.kernel.org
Subject: [PATCH io_uring-7.1 03/16] io_uring/zcrx: always dma map in advance
Date: Mon, 23 Mar 2026 12:43:52 +0000
Message-ID: <334092a2cbdd4aabd7c025050aa99f05ace89bb5.1774261953.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <cover.1774261953.git.asml.silence@gmail.com>
References: <cover.1774261953.git.asml.silence@gmail.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spamd-Result: default: False [-1.66 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[gmail.com,none];
	R_MISSING_CHARSET(0.50)[];
	R_SPF_ALLOW(-0.20)[+ip4:104.64.211.4:c];
	R_DKIM_ALLOW(-0.20)[gmail.com:s=20230601];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	MIME_TRACE(0.00)[0:+];
	DKIM_TRACE(0.00)[gmail.com:+];
	TAGGED_FROM(0.00)[bounces-12787-lists,io-uring=lfdr.de];
	FORGED_SENDER_MAILLIST(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	FREEMAIL_CC(0.00)[gmail.com,kernel.dk,vger.kernel.org];
	RCVD_TLS_LAST(0.00)[];
	RCPT_COUNT_THREE(0.00)[4];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	FREEMAIL_FROM(0.00)[gmail.com];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[asmlsilence@gmail.com,io-uring@vger.kernel.org];
	FROM_HAS_DN(0.00)[];
	ASN(0.00)[asn:63949, ipnet:104.64.192.0/19, country:SG];
	RCVD_COUNT_FIVE(0.00)[5];
	NEURAL_HAM(-0.00)[-1.000];
	TO_DN_NONE(0.00)[];
	TAGGED_RCPT(0.00)[io-uring];
	MID_RHS_MATCH_FROM(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sin.lore.kernel.org:helo,sin.lore.kernel.org:rdns]
X-Rspamd-Queue-Id: 976EC2F2236
X-Rspamd-Action: no action
X-Rspamd-Server: lfdr

zcrx was originally establisihing dma mappings at a late stage when it
was being bound to a page pool. Dma-buf couldn't work this way, so it's
initialised during area creation.

It's messy having them do it at different spots, just move everything to
the area creation time.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 io_uring/zcrx.c | 44 +++++++++++++++-----------------------------
 1 file changed, 15 insertions(+), 29 deletions(-)

diff --git a/io_uring/zcrx.c b/io_uring/zcrx.c
index 5739ce14d8ea..4e8064fc5561 100644
--- a/io_uring/zcrx.c
+++ b/io_uring/zcrx.c
@@ -194,6 +194,7 @@ static int io_import_umem(struct io_zcrx_ifq *ifq,
 {
 	struct page **pages;
 	int nr_pages, ret;
+	bool mapped = false;
 
 	if (area_reg->dmabuf_fd)
 		return -EINVAL;
@@ -210,6 +211,12 @@ static int io_import_umem(struct io_zcrx_ifq *ifq,
 	if (ret)
 		goto out_err;
 
+	ret = dma_map_sgtable(ifq->dev, &mem->page_sg_table,
+			      DMA_FROM_DEVICE, IO_DMA_ATTR);
+	if (ret < 0)
+		goto out_err;
+	mapped = true;
+
 	mem->account_pages = io_count_account_pages(pages, nr_pages);
 	ret = io_account_mem(ifq->user, ifq->mm_account, mem->account_pages);
 	if (ret < 0) {
@@ -223,6 +230,9 @@ static int io_import_umem(struct io_zcrx_ifq *ifq,
 	mem->size = area_reg->len;
 	return ret;
 out_err:
+	if (mapped)
+		dma_unmap_sgtable(ifq->dev, &mem->page_sg_table,
+				  DMA_FROM_DEVICE, IO_DMA_ATTR);
 	sg_free_table(&mem->page_sg_table);
 	unpin_user_pages(pages, nr_pages);
 	kvfree(pages);
@@ -288,30 +298,6 @@ static void io_zcrx_unmap_area(struct io_zcrx_ifq *ifq,
 	}
 }
 
-static int io_zcrx_map_area(struct io_zcrx_ifq *ifq, struct io_zcrx_area *area)
-{
-	int ret;
-
-	guard(mutex)(&ifq->pp_lock);
-	if (area->is_mapped)
-		return 0;
-
-	if (!area->mem.is_dmabuf) {
-		ret = dma_map_sgtable(ifq->dev, &area->mem.page_sg_table,
-				      DMA_FROM_DEVICE, IO_DMA_ATTR);
-		if (ret < 0)
-			return ret;
-	}
-
-	ret = io_populate_area_dma(ifq, area);
-	if (ret && !area->mem.is_dmabuf)
-		dma_unmap_sgtable(ifq->dev, &area->mem.page_sg_table,
-				  DMA_FROM_DEVICE, IO_DMA_ATTR);
-	if (ret == 0)
-		area->is_mapped = true;
-	return ret;
-}
-
 static void io_zcrx_sync_for_device(struct page_pool *pool,
 				    struct net_iov *niov)
 {
@@ -464,6 +450,7 @@ static int io_zcrx_create_area(struct io_zcrx_ifq *ifq,
 	ret = io_import_area(ifq, &area->mem, area_reg);
 	if (ret)
 		goto err;
+	area->is_mapped = true;
 
 	if (buf_size_shift > io_area_max_shift(&area->mem)) {
 		ret = -ERANGE;
@@ -499,6 +486,10 @@ static int io_zcrx_create_area(struct io_zcrx_ifq *ifq,
 		niov->type = NET_IOV_IOURING;
 	}
 
+	ret = io_populate_area_dma(ifq, area);
+	if (ret)
+		goto err;
+
 	area->free_count = nr_iovs;
 	/* we're only supporting one area per ifq for now */
 	area->area_id = 0;
@@ -1080,7 +1071,6 @@ static bool io_pp_zc_release_netmem(struct page_pool *pp, netmem_ref netmem)
 static int io_pp_zc_init(struct page_pool *pp)
 {
 	struct io_zcrx_ifq *ifq = io_pp_to_ifq(pp);
-	int ret;
 
 	if (WARN_ON_ONCE(!ifq))
 		return -EINVAL;
@@ -1093,10 +1083,6 @@ static int io_pp_zc_init(struct page_pool *pp)
 	if (pp->p.dma_dir != DMA_FROM_DEVICE)
 		return -EOPNOTSUPP;
 
-	ret = io_zcrx_map_area(ifq, ifq->area);
-	if (ret)
-		return ret;
-
 	refcount_inc(&ifq->refs);
 	return 0;
 }
-- 
2.53.0


