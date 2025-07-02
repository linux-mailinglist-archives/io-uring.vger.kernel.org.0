Return-Path: <io-uring+bounces-8571-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 94092AF5A64
	for <lists+io-uring@lfdr.de>; Wed,  2 Jul 2025 16:02:22 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id A4529447A49
	for <lists+io-uring@lfdr.de>; Wed,  2 Jul 2025 14:01:54 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 52242270ED7;
	Wed,  2 Jul 2025 14:02:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="NVSL/2/r"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pl1-f173.google.com (mail-pl1-f173.google.com [209.85.214.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DE3F927EFF4
	for <io-uring@vger.kernel.org>; Wed,  2 Jul 2025 14:02:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751464934; cv=none; b=fiLPpSVRmC8BbpI1Wpv5UKY9KSJPCaRnF/fm7cDVNKVDvQCKZMS5rG9oCqSzaw/8nzd83EfBY6UqmS0MuejXKcdd8QJKg4AEaFMCrxqvuvfnCIyv+pqLzBliWhEeUy/nAJ7qqZzFCl+2pd6OQrfpOetBPTst4hUn4racrR1pb0A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751464934; c=relaxed/simple;
	bh=khLbo7AY0XNMqrKqR2HAeyMwqC7DiaXDpc51InbtiRo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lcWtSwsjpo+tnXtTvXFJpTg7J2LzoHivmYxTeMnIkUt2YcMUsU5pwiP/krAnuifsPCg8t6l37bJ7DGrQKHLw3RFghZPby8DCC6gcU1r3eOX9I5slBicdS6GXAT8u9Px5CHXNZ65G/Dn/Uq1CQms+xYfD2xyVUZaes1LxkjJPsS4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=NVSL/2/r; arc=none smtp.client-ip=209.85.214.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pl1-f173.google.com with SMTP id d9443c01a7336-235ef62066eso86233595ad.3
        for <io-uring@vger.kernel.org>; Wed, 02 Jul 2025 07:02:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1751464932; x=1752069732; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=TEmS8Af/aHhQvsLKosgnrovtauhdpoXEJZZn0CNILNg=;
        b=NVSL/2/r5KcTdhVBlmtOHNzocEKpjgY+BPHq5UQmHTfbHoPkmiFq6AWAdNuG93317t
         tfnlWTyt5q9Lz6Dj7Vir30iKHa++bSUWOR7qyVcACMM0LLeJkO7DD3rJb4+8p8sJrp0m
         zREr+tjOMZgSjPCdc5d2uhwQJTGNQJ3axEsd1n7BlfrefeL4Na+0zamC9suhd9zws5wH
         K9voRUp6igh9Ffq5SVAdCVIsUpD5riclXfx0yFpIv1nEzRzWd+LPiJIUz4ynt7zvaH8H
         RcFxuDOxwmErH3Wd10u/O35AyYRKzeY8DPZ+yQovFYdHk7ABbb7tQ6/oG7fpAAx7A+2X
         c8Fg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1751464932; x=1752069732;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=TEmS8Af/aHhQvsLKosgnrovtauhdpoXEJZZn0CNILNg=;
        b=rODzzLpSN1AGSvsbg3guiOZcFCI10hOXwo+6fuKmp21U/lINUgi841O2YJ+CCVpRo4
         Q31EfEWo1HSN1rCt0eVv7f4yWFxxhqmQ9mk2fAm/R0SCsjymcIWPNmBgfjSzWQ/J2niH
         hyo+Xf49lF1Rgwyby7kz/e0jTyCTlJ76wRuARdQOdLx4HnIAacrotXtchrw5wvHS5kya
         sCC37uFx203aBApsfwZRK/wjaccmue4wuaxeGJ8NdzIrjObsqaXFK4W6sI1ykhTCsPN/
         +vSJTsKgO6Dk40PBTbDB9cXDs0724JaYTcnRWCFNB+toG1Ew+gInWTCzhlmqXAY03kAu
         AnHw==
X-Gm-Message-State: AOJu0YyqEtGAT1CFTtf7mgR9+8kNLVpFMB1wATgHllPB/fhVCF2eLabq
	jeCjA0hXtmGCDyxoZSZ2K/ghgTZ+ATJrgN2qoF4wXOqpwZYNVZyn4Shi/lTzblmM
X-Gm-Gg: ASbGncs13hpYqGCbi6smPDeGMIgIyQtuJHPzRiA5d03kxA0rqDCapfWunfiOxKuAieC
	ZqId/QxK9Q6mt05jdKjnsY/VA2ohwam3bToAmWTVBjnS72app3xKbCuhEggmGqgkKO4rZpf7Bc1
	IjM2lJL6+oyLVDXRZT9gc/UlRX7DXqmuBfaW1XK28oAq+G0CE3I3Kr02rQ5XzYaHflQ6u5/EvXl
	oAhv05mhcgMtN2Ew6iNpm9TYrjfFBYdvesczbmwExHEAoHUuOL/EHRlz8nQVFKYdct875F4TsHY
	GTSg75LFmXMSK9YfLsqD6DjoQkixkX70BlX+L3ywrYJsyYjVdgnpePhcFVo=
X-Google-Smtp-Source: AGHT+IHdRH9uK0gRLZ00MC6YrMWFO22GAE9TAQpe2o0CAB0BPxxhVoRZbZd/KZ18dDAL9zxbw8OQCg==
X-Received: by 2002:a17:903:2f43:b0:235:caa8:1a72 with SMTP id d9443c01a7336-23c6e59333bmr42031495ad.30.1751464931348;
        Wed, 02 Jul 2025 07:02:11 -0700 (PDT)
Received: from 127.com ([50.230.198.98])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-23acb3c6e14sm126828135ad.228.2025.07.02.07.02.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 02 Jul 2025 07:02:10 -0700 (PDT)
From: Pavel Begunkov <asml.silence@gmail.com>
To: io-uring@vger.kernel.org
Cc: asml.silence@gmail.com
Subject: [PATCH v3 5/6] io_uring/zcrx: assert area type in io_zcrx_iov_page
Date: Wed,  2 Jul 2025 15:03:25 +0100
Message-ID: <c3c30a926a18436a399a1768f3cc86c76cd17fa7.1751464343.git.asml.silence@gmail.com>
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

Add a simple debug assertion to io_zcrx_iov_page() making it's not
trying to return pages for a dmabuf area.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 io_uring/zcrx.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/io_uring/zcrx.c b/io_uring/zcrx.c
index fbcec06a1fb0..fcc7550aa0fa 100644
--- a/io_uring/zcrx.c
+++ b/io_uring/zcrx.c
@@ -44,6 +44,8 @@ static inline struct page *io_zcrx_iov_page(const struct net_iov *niov)
 {
 	struct io_zcrx_area *area = io_zcrx_iov_to_area(niov);
 
+	lockdep_assert(!area->mem.is_dmabuf);
+
 	return area->mem.pages[net_iov_idx(niov)];
 }
 
-- 
2.49.0


