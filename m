Return-Path: <io-uring+bounces-10353-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 9347EC2E755
	for <lists+io-uring@lfdr.de>; Tue, 04 Nov 2025 00:44:36 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id D26413BEB89
	for <lists+io-uring@lfdr.de>; Mon,  3 Nov 2025 23:42:39 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B999A3009E8;
	Mon,  3 Nov 2025 23:41:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=davidwei-uk.20230601.gappssmtp.com header.i=@davidwei-uk.20230601.gappssmtp.com header.b="1PCtj9qC"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-oo1-f50.google.com (mail-oo1-f50.google.com [209.85.161.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 18C0A3002DB
	for <io-uring@vger.kernel.org>; Mon,  3 Nov 2025 23:41:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.161.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762213294; cv=none; b=b827SYXD9kBaEoynaXyatKoFAnYUR19qUJ73UWAUEwsxB4BDnOuGoCZPWYOavuT+aZUp0pOgAXr0EQKJUWpZRCJ+w/8e2YcjzYuZnF2uSSp2ypjJcJsSCqpFXZTN3C9USvP/Y+WUJoTMYhhDaNRzZrdFRmfbaZc+yJpr3WNZoWg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762213294; c=relaxed/simple;
	bh=RtN5gjrmQIlUZkZCw0u0g89U/qJDqD0LaWtEgAKlR4U=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=D8ECHPaVVUTDP1Dw6D9lo7i44gTnANsB9zLu4la8JFN42Qawff9fTdmLbKVDemj24p7197bixpEgHqkGY5bKXOF6W1NTmWN+kDX1+Y3wveXfjz6R4H/s+OvmkCmSAv+Dw7cHdbwz2inhzqQ+y8bOYZqk8xMViFXDRgROAOowTog=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=davidwei.uk; spf=none smtp.mailfrom=davidwei.uk; dkim=pass (2048-bit key) header.d=davidwei-uk.20230601.gappssmtp.com header.i=@davidwei-uk.20230601.gappssmtp.com header.b=1PCtj9qC; arc=none smtp.client-ip=209.85.161.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=davidwei.uk
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=davidwei.uk
Received: by mail-oo1-f50.google.com with SMTP id 006d021491bc7-654ecd8afafso1176331eaf.2
        for <io-uring@vger.kernel.org>; Mon, 03 Nov 2025 15:41:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=davidwei-uk.20230601.gappssmtp.com; s=20230601; t=1762213292; x=1762818092; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=spZaZ0BQVbN2cYL13O6nJp6uxw5etopLFoexoflwJGc=;
        b=1PCtj9qCbT2tErLr9r3Z3GBCQU+UpK8iaEqKaen8lbcVz0iYtiqrFTmYlPpzuZliUa
         x6YNbGOI/CpzZbqRM+o8ZqNUpfWQ3MXTKiwwzT2KB48oaAPYTqHIu1QiSHNByg0vhXbE
         TYZ6Z1uCJKhANdG1odSMtGzmCyreCAc2ZfexG5N4oiiakHyjzRUMd3wasBjqGBx1aNRK
         gSbhede1puEV8ty06EI3ut7j+SgQP5fwE5ja3+AjkNGoc9YBkhAUkPcJ8FAMNKrAGuDP
         ikQ6FKWkvQNC2GTTLg4KkKp2tut1xYJyXlrtgDiTeN83Q/5CTOTJwtvj5dA6oh+nOYA5
         tjsQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1762213292; x=1762818092;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=spZaZ0BQVbN2cYL13O6nJp6uxw5etopLFoexoflwJGc=;
        b=cwKyYK8RDNsqJARDyl+DqvgKPvfXgDFHa9NroIcw9ao4buGIIPFB5VKZw12pfGqEOU
         N/s1osJVZIhuTzdwJiojrvgR6sKbEDYqP3LCj8jR9X6Om8Sw0PovGoD0wEZzLZ+dlGrI
         Sz6SEaYanBlW4AQ0kiA3YdaYV0+d869YsujicgUcp72fPJgwx1+7yw+hIaJDdpp/1HVf
         lgPsFztC3R6bhsY1tUl2KEgPb+w1x4THqk/LqRXTw6ot0QR1W4sTuWahyleqSNTbWMc1
         +4YJYKaHRpVGtFKu3a/R4RbNxY23Yl9888nYnRn15oCt8qsOyQT2wpvtpOSaTKTBhUqM
         rSvg==
X-Gm-Message-State: AOJu0YzMOeqGcc4783bleljoZLRZ5rpXIfDbVbLCa4sNQhsaU3nIpTco
	2qk9xdoS+aEF73w8Aqqumfw4gmCFl6ptbRgnJiqFqaztS5vLwc6s8IjnwLyzcileUsXpyzrJTem
	dFyxo
X-Gm-Gg: ASbGncuALgWxDvqFg6e+59GEYP1vhvPa5qpqtuIvF72Kp3ue8ArI98U3eAOBSe5h5JW
	iIryLpjWUCizUU0NbTuGEVb7bUQy1hS3y6RXxin9L9lKNSbpLATDRhnCuc/hkRqNu9ODQye9JNo
	/ypxdN/7QGMmWWz8RBeiGf2Ad3L61OeRV0xaFIl7gtlGomFdWHOsbt5wlPU80gFSAs1svB4UBmc
	fue5BZ4B7qElTOro3FhsPc1aW9BILGOlqItklKKl7uRIAbC8KnEE1oFsuixVP8CuLMCYcJ1phpO
	h5Swbdz6UclTPSp5K//+UnpT3mIqgjAAGTxAxpnKvpA2vEI6LkHFjsxUbzOafv36f2ln+c9HmgP
	fmhAThLMZORldce1vZOvh1dq3HPquwVWNWanN0XbmDZHROc+W8LwobM6Ym6c9QAMJqUCHDxyWyn
	sUP5K6M7Vx5wVXEwC9tIlDAAiUBGxISOqiYOQA6RHC
X-Google-Smtp-Source: AGHT+IH/gxAckKE/c2j6H9PecKKD6Sd58xg0p9LAJO0mlwtwELK1rAHcQapI7HbXpt1nllwoqZGtGA==
X-Received: by 2002:a05:6808:228f:b0:441:8f74:f3d with SMTP id 5614622812f47-44f95fde215mr7406492b6e.55.1762213292045;
        Mon, 03 Nov 2025 15:41:32 -0800 (PST)
Received: from localhost ([2a03:2880:12ff:72::])
        by smtp.gmail.com with ESMTPSA id 006d021491bc7-656ad40e2f5sm459675eaf.10.2025.11.03.15.41.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 03 Nov 2025 15:41:31 -0800 (PST)
From: David Wei <dw@davidwei.uk>
To: io-uring@vger.kernel.org,
	netdev@vger.kernel.org
Cc: Jens Axboe <axboe@kernel.dk>,
	Pavel Begunkov <asml.silence@gmail.com>
Subject: [PATCH v4 10/12] io_uring/zcrx: move io_zcrx_scrub() and dependencies up
Date: Mon,  3 Nov 2025 15:41:08 -0800
Message-ID: <20251103234110.127790-11-dw@davidwei.uk>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20251103234110.127790-1-dw@davidwei.uk>
References: <20251103234110.127790-1-dw@davidwei.uk>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

In preparation for adding zcrx ifq exporting and importing, move
io_zcrx_scrub() and its dependencies up the file to be closer to
io_close_queue().

Signed-off-by: David Wei <dw@davidwei.uk>
---
 io_uring/zcrx.c | 84 ++++++++++++++++++++++++-------------------------
 1 file changed, 42 insertions(+), 42 deletions(-)

diff --git a/io_uring/zcrx.c b/io_uring/zcrx.c
index 00498e3dcbd3..e9981478bcf6 100644
--- a/io_uring/zcrx.c
+++ b/io_uring/zcrx.c
@@ -544,6 +544,48 @@ static void io_put_zcrx_ifq(struct io_zcrx_ifq *ifq)
 		io_zcrx_ifq_free(ifq);
 }
 
+static void io_zcrx_return_niov_freelist(struct net_iov *niov)
+{
+	struct io_zcrx_area *area = io_zcrx_iov_to_area(niov);
+
+	spin_lock_bh(&area->freelist_lock);
+	area->freelist[area->free_count++] = net_iov_idx(niov);
+	spin_unlock_bh(&area->freelist_lock);
+}
+
+static void io_zcrx_return_niov(struct net_iov *niov)
+{
+	netmem_ref netmem = net_iov_to_netmem(niov);
+
+	if (!niov->pp) {
+		/* copy fallback allocated niovs */
+		io_zcrx_return_niov_freelist(niov);
+		return;
+	}
+	page_pool_put_unrefed_netmem(niov->pp, netmem, -1, false);
+}
+
+static void io_zcrx_scrub(struct io_zcrx_ifq *ifq)
+{
+	struct io_zcrx_area *area = ifq->area;
+	int i;
+
+	if (!area)
+		return;
+
+	/* Reclaim back all buffers given to the user space. */
+	for (i = 0; i < area->nia.num_niovs; i++) {
+		struct net_iov *niov = &area->nia.niovs[i];
+		int nr;
+
+		if (!atomic_read(io_get_user_counter(niov)))
+			continue;
+		nr = atomic_xchg(io_get_user_counter(niov), 0);
+		if (nr && !page_pool_unref_netmem(net_iov_to_netmem(niov), nr))
+			io_zcrx_return_niov(niov);
+	}
+}
+
 struct io_mapped_region *io_zcrx_get_region(struct io_ring_ctx *ctx,
 					    unsigned int id)
 {
@@ -699,48 +741,6 @@ static struct net_iov *__io_zcrx_get_free_niov(struct io_zcrx_area *area)
 	return &area->nia.niovs[niov_idx];
 }
 
-static void io_zcrx_return_niov_freelist(struct net_iov *niov)
-{
-	struct io_zcrx_area *area = io_zcrx_iov_to_area(niov);
-
-	spin_lock_bh(&area->freelist_lock);
-	area->freelist[area->free_count++] = net_iov_idx(niov);
-	spin_unlock_bh(&area->freelist_lock);
-}
-
-static void io_zcrx_return_niov(struct net_iov *niov)
-{
-	netmem_ref netmem = net_iov_to_netmem(niov);
-
-	if (!niov->pp) {
-		/* copy fallback allocated niovs */
-		io_zcrx_return_niov_freelist(niov);
-		return;
-	}
-	page_pool_put_unrefed_netmem(niov->pp, netmem, -1, false);
-}
-
-static void io_zcrx_scrub(struct io_zcrx_ifq *ifq)
-{
-	struct io_zcrx_area *area = ifq->area;
-	int i;
-
-	if (!area)
-		return;
-
-	/* Reclaim back all buffers given to the user space. */
-	for (i = 0; i < area->nia.num_niovs; i++) {
-		struct net_iov *niov = &area->nia.niovs[i];
-		int nr;
-
-		if (!atomic_read(io_get_user_counter(niov)))
-			continue;
-		nr = atomic_xchg(io_get_user_counter(niov), 0);
-		if (nr && !page_pool_unref_netmem(net_iov_to_netmem(niov), nr))
-			io_zcrx_return_niov(niov);
-	}
-}
-
 void io_unregister_zcrx_ifqs(struct io_ring_ctx *ctx)
 {
 	struct io_zcrx_ifq *ifq;
-- 
2.47.3


