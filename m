Return-Path: <io-uring+bounces-9809-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 850F9B59A3C
	for <lists+io-uring@lfdr.de>; Tue, 16 Sep 2025 16:34:04 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 095391C06274
	for <lists+io-uring@lfdr.de>; Tue, 16 Sep 2025 14:28:16 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 25F39341646;
	Tue, 16 Sep 2025 14:27:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="MhPxRdXS"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-wm1-f49.google.com (mail-wm1-f49.google.com [209.85.128.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4AE3633EB01
	for <io-uring@vger.kernel.org>; Tue, 16 Sep 2025 14:27:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758032822; cv=none; b=SUu72G9CiphCn1qIehky7yq9E6ErJnJcEDIeXMQDCcP/T3FSQzFcApqyzSNBy95jxDvNsEx14qXs/FRK/uaA8xsK26UN1emIyAqSMsMvexvlfS3W3punKcQyEDIuyCPM8lq6KJUAebzcSLg34epgsa80ZIeoaVbkNI19NPDR9VA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758032822; c=relaxed/simple;
	bh=dhaO5bXGCF040t/G3p3c2L63kxB5T2zkggK5T1YtcXc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mX5KLokjkJIdSK9XPfILbV4+MugNy+hT9HE3kG0kShwWeiQLO2FN9EKw0xVrW1hrliIkr83KEcBvbidPxS5bTQQVm18zs/qEB3mHE+hMcGqbcteBi2tMcXMJ66jyfJHqUiQ7cQ+xSzNjxrj8RLrZww4QwToGULSU8dyfqJMU4c0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=MhPxRdXS; arc=none smtp.client-ip=209.85.128.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-wm1-f49.google.com with SMTP id 5b1f17b1804b1-45b4d89217aso40724785e9.2
        for <io-uring@vger.kernel.org>; Tue, 16 Sep 2025 07:27:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1758032818; x=1758637618; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=+K+wCvWPeBe4fiwMbzC5U3R6MJ4/gSsqNozWBVE1aVs=;
        b=MhPxRdXSE5UcxTsFmrE/R1Zk3wjxw7IyBwp58U4rfANNYrtnF9sGgj/OftzJcIQIMu
         HMNZOL+ClS1NTb3Tn1BClz8kPjBW9PBIzcK0nqkO+38j1l0BV70I4RRkDCQcht4b7nyS
         VqKFVRfDI7IFFRS1lo9kfnVGXwimq74Sg36z2zOLixVXYtJXVi2rvJ55T8iRfGKqcp7A
         9a1cSOKmSnifZjZwP4bluVW7LwhHV+yyXt7raqHNj1na8ms77OM5uhRaziXra0hd7yMM
         HmS31Qag4/oE8Gq9kTf9zGPo76A+4y2Q1Oed9YHqqzLvmZy54YrBHhbl1vqCCvHaZV1H
         dPKg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1758032818; x=1758637618;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=+K+wCvWPeBe4fiwMbzC5U3R6MJ4/gSsqNozWBVE1aVs=;
        b=dL5/+B1YdFZEM4Zh4ZxgkcRTuEEzKMqRkK6Am3HJStw+UEZOBfixhrxGbdkpvzEc8Y
         xAbtfJqUKdCZxAFIFnwMql4QyKemno5VBdMPw9xYBKgbF4k390NOrPqCBpR782QQJl6T
         uJWwnCqyZu95ep9NxUUELCv+O/6ui3Bg2vBCj9BZt/OwdmgKI34BFYjLkILuJMo0cn2j
         oJu0Oqz4InzFwLs+eP4NppKGTPcKNpv4X0tJxKDQj2bbVUojnBK9YpE6Ss/QfuUJqCKI
         UCWwkfH6w7C43n9FVzzAE4foWPgWEnFJakBTNgG6k4/LWyx9wYZmUWtrTo/V2cSvrrtG
         4/6A==
X-Gm-Message-State: AOJu0Yzz75tUJBgZsxl19t6IIrthUbA4N7Ip+LcvoS1VKpKk4QiZXc/d
	ekWB0BfaFUEVZjYMIAoZ/Q8xrVe8YLvT7vMeTpABSCbsrQUESrA/hVxnKmrtww==
X-Gm-Gg: ASbGncvxgKH0lzbB0X8qLA+bjPe4twp+VX0MFLqevPW88Q6woE9+n1qvgpEnSMMHnAx
	k7WHD8J8kX/piW3c/Vh/y9sKkqGX325hU3JymmEeotnHJBB5i7LeArS6VAVrYyUfDpjQ8STb8v/
	fEv5NVLG+NRSKelL5CF1D1zb6XYU2HmaBgOefxULGOoQ7lhtDvBGDt5eakl2t9nMvI8Xb9fwyoQ
	O/fQhKIkOUDi/uK0BF3X8TSKucOXHZ4bclWopXLfAp1PqEztrO46ku8gUdgU10mKFYqVFRdPi+S
	gTRoYCli3F2/rgNn5fbJ3yuS2jNpgXh/5To8DUKdondflY+3lnveKDd+L1abvfmJJ/8npdpxSS3
	fpIH6Hg==
X-Google-Smtp-Source: AGHT+IFvdUTfW+spY+N4yUPMvLFoNvaMtFtAW2x7UFoT7U2jhK6RZD1Ssm1dUNWTqdRTP5GlFApyPg==
X-Received: by 2002:a05:6000:24c7:b0:3e7:5ece:cffa with SMTP id ffacd0b85a97d-3e765a140fbmr9949464f8f.30.1758032818100;
        Tue, 16 Sep 2025 07:26:58 -0700 (PDT)
Received: from 127.com ([2620:10d:c092:600::1:8149])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3ecdc967411sm327971f8f.46.2025.09.16.07.26.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 16 Sep 2025 07:26:57 -0700 (PDT)
From: Pavel Begunkov <asml.silence@gmail.com>
To: io-uring@vger.kernel.org
Cc: asml.silence@gmail.com,
	axboe@kernel.dk,
	netdev@vger.kernel.org
Subject: [PATCH io_uring for-6.18 09/20] io_uring/zcrx: deduplicate area mapping
Date: Tue, 16 Sep 2025 15:27:52 +0100
Message-ID: <fdbd46d50edf16e0fd4695c4e10f8784a82d2a7d.1758030357.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <cover.1758030357.git.asml.silence@gmail.com>
References: <cover.1758030357.git.asml.silence@gmail.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

With a common type for storing dma addresses and io_populate_area_dma(),
type-specific area mapping helpers are trivial, so open code them and
deduplicate the call to io_populate_area_dma().

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 io_uring/zcrx.c | 37 ++++++++++++++-----------------------
 1 file changed, 14 insertions(+), 23 deletions(-)

diff --git a/io_uring/zcrx.c b/io_uring/zcrx.c
index 16bf036c7b24..bba92774c801 100644
--- a/io_uring/zcrx.c
+++ b/io_uring/zcrx.c
@@ -157,14 +157,6 @@ static int io_import_dmabuf(struct io_zcrx_ifq *ifq,
 	return ret;
 }
 
-static int io_zcrx_map_area_dmabuf(struct io_zcrx_ifq *ifq, struct io_zcrx_area *area)
-{
-	if (!IS_ENABLED(CONFIG_DMA_SHARED_BUFFER))
-		return -EINVAL;
-	return io_populate_area_dma(ifq, area, area->mem.sgt,
-				    area->mem.dmabuf_offset);
-}
-
 static unsigned long io_count_account_pages(struct page **pages, unsigned nr_pages)
 {
 	struct folio *last_folio = NULL;
@@ -275,30 +267,29 @@ static void io_zcrx_unmap_area(struct io_zcrx_ifq *ifq,
 	}
 }
 
-static unsigned io_zcrx_map_area_umem(struct io_zcrx_ifq *ifq, struct io_zcrx_area *area)
-{
-	int ret;
-
-	ret = dma_map_sgtable(ifq->dev, &area->mem.page_sg_table,
-				DMA_FROM_DEVICE, IO_DMA_ATTR);
-	if (ret < 0)
-		return ret;
-	return io_populate_area_dma(ifq, area, &area->mem.page_sg_table, 0);
-}
-
 static int io_zcrx_map_area(struct io_zcrx_ifq *ifq, struct io_zcrx_area *area)
 {
+	unsigned long offset;
+	struct sg_table *sgt;
 	int ret;
 
 	guard(mutex)(&ifq->dma_lock);
 	if (area->is_mapped)
 		return 0;
 
-	if (area->mem.is_dmabuf)
-		ret = io_zcrx_map_area_dmabuf(ifq, area);
-	else
-		ret = io_zcrx_map_area_umem(ifq, area);
+	if (!area->mem.is_dmabuf) {
+		ret = dma_map_sgtable(ifq->dev, &area->mem.page_sg_table,
+				      DMA_FROM_DEVICE, IO_DMA_ATTR);
+		if (ret < 0)
+			return ret;
+		sgt = &area->mem.page_sg_table;
+		offset = 0;
+	} else {
+		sgt = area->mem.sgt;
+		offset = area->mem.dmabuf_offset;
+	}
 
+	ret = io_populate_area_dma(ifq, area, sgt, offset);
 	if (ret == 0)
 		area->is_mapped = true;
 	return ret;
-- 
2.49.0


