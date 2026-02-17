Return-Path: <io-uring+bounces-12279-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id WHk8JBhKlGn0BwIAu9opvQ
	(envelope-from <io-uring+bounces-12279-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Tue, 17 Feb 2026 11:59:36 +0100
X-Original-To: lists+io-uring@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [IPv6:2600:3c04:e001:36c::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 42E3F14B14F
	for <lists+io-uring@lfdr.de>; Tue, 17 Feb 2026 11:59:36 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id 9970A302AF37
	for <lists+io-uring@lfdr.de>; Tue, 17 Feb 2026 10:59:12 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5D50432D0DE;
	Tue, 17 Feb 2026 10:59:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="nqggczfk"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-wm1-f42.google.com (mail-wm1-f42.google.com [209.85.128.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EDD6A32BF51
	for <io-uring@vger.kernel.org>; Tue, 17 Feb 2026 10:59:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771325945; cv=none; b=pJF/AO3IMONR9lg9FIIuW1UzzShxcTLsKaYkWnYiO3fLmg9kepMuLtLvbysq2PL/W8CmNPIpOikE4oy8Z15bbrqlgKR4evNcBpPbpoFr8pGSPDOAlqZgRwUN1zr3vxE0yTOJ+AU9Td9Zw/99FtSE4/U6+eHNfjLOu3CLb1fhtTA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771325945; c=relaxed/simple;
	bh=vKrjZiwP7d/2tsuWlOGmo5etWthFEDBquJaxbzRI8IA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=s1TzOKv5Z10eYD7/UAu8/4/dGv5WLRV9ELUA0Gq9R3gpuNUw64T04YNdVC+MSVzmSg+Gu3r7f4FZymRTaVPLjQDZtHlEykgYc2dGwHoAc0PNZyWNq0qnJMqxmy1PrmgqMlxuy3iKUYL8WzRBwIPncf14BH9IyUphQspzcXNTTMI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=nqggczfk; arc=none smtp.client-ip=209.85.128.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-wm1-f42.google.com with SMTP id 5b1f17b1804b1-480706554beso39681205e9.1
        for <io-uring@vger.kernel.org>; Tue, 17 Feb 2026 02:59:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1771325942; x=1771930742; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=UHpJTLX1FI9TF8Lz9wpjsap/XYPEHymSqSKaFnhhx70=;
        b=nqggczfkySilVmb0iP+U5e5qf/TQNz2fOG+A61h3t9mDOXZsWb2w7BFQEL91G5IIV2
         W0wuzaIaJ+ibOKSd9eNBRVt/ipp/r3Efq8X1uroK1zPEHllpwc8Rpm7omMnJg1alNHqu
         +zegbNzVYzkfkQbT8t6hGWe2ky/rE3jwRCQB/NrdKSzGANEVB+vwHC2cdgCEJq9hIOn3
         g9wzxJI5rCMRToRTuro/hq7etZAR4BN36t/fnIn8AaGeA8qljLkI+W0PUZvC9IYehaVC
         d8USuCiFN87DjmCsHlPYLYgFPM+OCXa6+Vik9bN8pfRpff/8ZYLS9YqYQ+y3jXG07bD/
         H5+w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1771325942; x=1771930742;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=UHpJTLX1FI9TF8Lz9wpjsap/XYPEHymSqSKaFnhhx70=;
        b=koNIckeCKtjbkEjDRLFwrtZOsW5V3o3r48SvZC3oZ3EFQAdGzHIr7mVurhYtMMwQj9
         l3Oyz8IUotcY5V0KhrSo1/rPj2cfgYowX5vpBGJMHV1jrCKNp1xlbDDeP6rr8Xn91DJu
         z3J9RQIRAz2kv5QXHM59q8yoTdCfe4461Hz2jxqqGLIBcIlHORKkz7ZxCEZyMeYZ6Dc0
         dSZqDQ7IoDlCCEiXjuVWIlXtAjyoj4OPEQMAqhbtxJYjltS9fIANVE356EKFvM0YjA0G
         vhTysxifLd2OGXsmNMBol80Hj0+VG0otZqzsHa3vcUfzTuEHi4uM46nJZt9n9AwFrrev
         Nazw==
X-Gm-Message-State: AOJu0YyAQy+zx01IvtATWmHxyoWsUv4nhuZefg4CHCzSM16Kelrvzbsw
	AlfF+neVyg6c6PV3grxuJY5fVCRQJHTXvjMWhEQYRfHSoWrZpviALDbl0LfUgA==
X-Gm-Gg: AZuq6aLIwBZDSfuH8DXwD2BZID9t/3bwuNYhTaisH3yJIs8x4/S6MLs+I6/HcOCvA4Y
	UCH8pCX6Q8fbZ2AxtVgWgvutrae/iAAYF/5UBINI8SMM2SuqO1kwFWjnDch/5bFnXWPGQlyVT5b
	cnjOx0huMc4bl2/jCKQG8ERmu5dBnmkZIA5IeNtbZNUc+NeQHyAZsqPs3NJ852at/IoJm+xcdB9
	okS+nyLiW1/4CdnxljsxXm4zROxY20i/VzDJC8f/Mn6djvHytTt7fniL0TtxNaj3wU3BZUNmLh7
	BETztnCavjROsSXRZEAqBYqw/qBFoLeEhRfcNJaeMQtVpt9pYRrW3OcXr7XtHpPii0eruh9M5L6
	uowgg/a2LdTO8/GhGjNPuK3GjZVS8N9NY5l/cSq0QHhwlDhDuP6hXU892tNJZveq5ph5Zgfq3LX
	gg7chomJnKH/Y45QBh77wkHfRv6fC/VdGPXXYDrEWD5qSQQbPpUo3HtbOULYgOzR37qkAQih/xw
	9dNFoDkaR6y0CNwnniyHbUr63WbPw==
X-Received: by 2002:a05:600c:1c19:b0:483:5310:dc67 with SMTP id 5b1f17b1804b1-48379be817cmr203753345e9.20.1771325941861;
        Tue, 17 Feb 2026 02:59:01 -0800 (PST)
Received: from 127.mynet ([2a01:4b00:bd21:4f00:7cc6:d3ca:494:116c])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-48370a78c89sm327759395e9.5.2026.02.17.02.59.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 17 Feb 2026 02:59:01 -0800 (PST)
From: Pavel Begunkov <asml.silence@gmail.com>
To: io-uring@vger.kernel.org
Cc: asml.silence@gmail.com,
	axboe@kernel.dk,
	netdev@vger.kernel.org
Subject: [PATCH review-only 2/4] io_uring/zcrx: always dma map in advance
Date: Tue, 17 Feb 2026 10:58:53 +0000
Message-ID: <0afb4dfc31f93e5754110d3bafa0f11b6eab8b92.1771325198.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <cover.1771325198.git.asml.silence@gmail.com>
References: <cover.1771325198.git.asml.silence@gmail.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-1.66 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[gmail.com,none];
	R_MISSING_CHARSET(0.50)[];
	R_DKIM_ALLOW(-0.20)[gmail.com:s=20230601];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c04:e001:36c::/64:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	RCVD_TLS_LAST(0.00)[];
	TAGGED_FROM(0.00)[bounces-12279-lists,io-uring=lfdr.de];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	RCVD_COUNT_FIVE(0.00)[5];
	FORGED_SENDER_MAILLIST(0.00)[];
	FREEMAIL_CC(0.00)[gmail.com,kernel.dk,vger.kernel.org];
	MIME_TRACE(0.00)[0:+];
	FROM_NEQ_ENVFROM(0.00)[asmlsilence@gmail.com,io-uring@vger.kernel.org];
	RCPT_COUNT_THREE(0.00)[4];
	PRECEDENCE_BULK(0.00)[];
	MID_RHS_MATCH_FROM(0.00)[];
	TO_DN_NONE(0.00)[];
	DKIM_TRACE(0.00)[gmail.com:+];
	TAGGED_RCPT(0.00)[io-uring];
	FREEMAIL_FROM(0.00)[gmail.com];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	ASN(0.00)[asn:63949, ipnet:2600:3c04::/32, country:SG];
	FROM_HAS_DN(0.00)[]
X-Rspamd-Queue-Id: 42E3F14B14F
X-Rspamd-Action: no action

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
index 117d578224f5..290db098cfe7 100644
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
@@ -460,6 +446,7 @@ static int io_zcrx_create_area(struct io_zcrx_ifq *ifq,
 	ret = io_import_area(ifq, &area->mem, area_reg);
 	if (ret)
 		goto err;
+	area->is_mapped = true;
 
 	if (buf_size_shift > io_area_max_shift(&area->mem)) {
 		ret = -ERANGE;
@@ -495,6 +482,10 @@ static int io_zcrx_create_area(struct io_zcrx_ifq *ifq,
 		niov->type = NET_IOV_IOURING;
 	}
 
+	ret = io_populate_area_dma(ifq, area);
+	if (ret)
+		goto err;
+
 	area->free_count = nr_iovs;
 	/* we're only supporting one area per ifq for now */
 	area->area_id = 0;
@@ -1036,7 +1027,6 @@ static bool io_pp_zc_release_netmem(struct page_pool *pp, netmem_ref netmem)
 static int io_pp_zc_init(struct page_pool *pp)
 {
 	struct io_zcrx_ifq *ifq = io_pp_to_ifq(pp);
-	int ret;
 
 	if (WARN_ON_ONCE(!ifq))
 		return -EINVAL;
@@ -1049,10 +1039,6 @@ static int io_pp_zc_init(struct page_pool *pp)
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
2.52.0


