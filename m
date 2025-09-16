Return-Path: <io-uring+bounces-9815-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 2128DB59A46
	for <lists+io-uring@lfdr.de>; Tue, 16 Sep 2025 16:34:39 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 5C3F6526072
	for <lists+io-uring@lfdr.de>; Tue, 16 Sep 2025 14:28:30 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7659E324B19;
	Tue, 16 Sep 2025 14:27:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="I4veuE/W"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-wr1-f46.google.com (mail-wr1-f46.google.com [209.85.221.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B93083451B2
	for <io-uring@vger.kernel.org>; Tue, 16 Sep 2025 14:27:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758032830; cv=none; b=QnMjTpj0Z2K1xGRmH5jOJ5/Nap6WfMzSbJ38UF4WIa8sbOXd4ZAeNBZk19/oh5yiqVhzaeOcSBmt5oRHPleJbGnr5+jPFlebI2g442XysuT1HOgwQpem6SPY1tPVa13bMkb74evRv/vyEn8GFDv8hSq/4yWl9lVZG2i2qBZlPnk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758032830; c=relaxed/simple;
	bh=zFUgVjN8gCChVqCbuCN5B7SJ8Ml3TiaNoAwuIDJZdrw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=sZ/X1JavsQxTBi3iTTHauxPWLYwa4u551sSSwg8Bw6AG7jY+k7EHo7PaCTt+Ag/3v0bN/wSHI/kX77oWyLRvk15HaVDA+JJiJk/bDBinYHjlXWTWJzP38wt/Rbi/iRjvj1vorW0Y+sDNrDnAecqQS9ndByvRhNfI+t+2Yk9gWf4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=I4veuE/W; arc=none smtp.client-ip=209.85.221.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-wr1-f46.google.com with SMTP id ffacd0b85a97d-3e9ca387425so2111630f8f.0
        for <io-uring@vger.kernel.org>; Tue, 16 Sep 2025 07:27:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1758032827; x=1758637627; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=rLh6FB29DjH0Q7hYhSSk+TA0DlD3EiiBje8bEhVpW+g=;
        b=I4veuE/WWtW/EjFCM7zVdlQ46pg8aKUtcxZ19Dq8sjQP7AAvZv+6+wnZl2oSBgHkmA
         TmSrEubcjX/ozUinA5Us7xA5n1lqqMkZBClgITXYPCyw5NzWd94ApP9cMoUfGtgujWlM
         hCe2oSxZ7h4X11YDNBv9/5dHsZoXM2zNhyHjng8BYfqNEpVYT4gz/4xRwoFVfT39W0Xv
         fTeb0eJB2LphdPcQu5+XMWe4/3pSPw268f/9I7wgbgiuduP8Vo3jw9yOrB2Y2LPs3SEX
         xv/Di4O5Tc6qi6wntqKE3xd5Q30L0mzfQBo9YqNrS1WMdaSMF40zEBjfIKLMIlXJILsD
         A8AQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1758032827; x=1758637627;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=rLh6FB29DjH0Q7hYhSSk+TA0DlD3EiiBje8bEhVpW+g=;
        b=KhJf4/VQIRSpyjDokFw1n6x/xOBjOP/J+cbpvSYWEkr+XGN+0Z7LsjfWW75T9nZNxT
         LcOmoLCdtPH9V4J7dBSWJP+JZGPV989lgthCDOCNEsncf8G/lCQogdCFILemOr337W4p
         9GMd3AByl8FcH6GjFvM7VSxw5pDN2MMVdV1ikxUcthEC93HCM4QKWW1mSda5valVveGy
         leAvZGChwggHy9ntoJIlI38+G3U8PJtYKaWVKUgf1zTJT1XeH8V+F1KDHknDCb6p6Y2T
         OoMgmPsHNEU+kTKhcVpLc1GAl2kl/cX/j9Z2OI0nVMS13Ustd6qd30FVL+mGpl+YnGg1
         iBNw==
X-Gm-Message-State: AOJu0YxLLSWelGHUbydpaAeu4CHqpFOhYJL5OVBmkpIQvBW71VhU2/Tt
	XarGJ7/j9QPpgaltQiEPFH6XYqZoOXGcOXfe5OS7fwgdErhGm2gSt1uSq+FpUA==
X-Gm-Gg: ASbGnctwWAQSpbjrC9hstx8L2PgzdT00L5D/gZxeOzCfilL4ys1z9ryvWytFcoNvGPD
	nottVUMtiFyZybzijJTl5g7MzYaVs4FJ17NhxVQHp2c+dXFdYuAox/UqbYFJ6C41LeL+GqFLVmL
	QWo37RxVwiLan3ZKi8q1Ocrn7U5Z+CccIbGYWMCNk9IdkCaHiG0JT3qe6p3tPCJ2msr/Tnhewk4
	hBLNISSw879nnORLksK0QUdpuDeT2cIfAU7GmMIs/ycK/OHlwxTlY89lb3efXob5QSgC7WxIi83
	ZaFO8VKig9t2StLiV5DakfkBLbnbmTGrN/RnoZldZNC/nU89Y1gT91kBFWlKYUZmx4ErvB/8p2c
	AjXhjxg==
X-Google-Smtp-Source: AGHT+IFPvUoQ7F1e2ZU/ZnmyJIgsytT0235SXNnKobzQJA0XHzL/acl+bRHUvh8S+ul9ec6PvZnaVA==
X-Received: by 2002:a5d:5d07:0:b0:3ec:1b42:1f8b with SMTP id ffacd0b85a97d-3ec1b42221dmr4363579f8f.40.1758032826685;
        Tue, 16 Sep 2025 07:27:06 -0700 (PDT)
Received: from 127.com ([2620:10d:c092:600::1:8149])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3ecdc967411sm327971f8f.46.2025.09.16.07.27.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 16 Sep 2025 07:27:05 -0700 (PDT)
From: Pavel Begunkov <asml.silence@gmail.com>
To: io-uring@vger.kernel.org
Cc: asml.silence@gmail.com,
	axboe@kernel.dk,
	netdev@vger.kernel.org
Subject: [PATCH io_uring for-6.18 15/20] io_uring/zcrx: reduce netmem scope in refill
Date: Tue, 16 Sep 2025 15:27:58 +0100
Message-ID: <14ccfe8a94e04b9829ed802ea6f474ba5f638e7c.1758030357.git.asml.silence@gmail.com>
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

Reduce the scope of a local var netmem in io_zcrx_ring_refill.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 io_uring/zcrx.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/io_uring/zcrx.c b/io_uring/zcrx.c
index 6a5b6f32edc3..5f99fc7b43ee 100644
--- a/io_uring/zcrx.c
+++ b/io_uring/zcrx.c
@@ -755,7 +755,6 @@ static void io_zcrx_ring_refill(struct page_pool *pp,
 {
 	unsigned int mask = ifq->rq_entries - 1;
 	unsigned int entries;
-	netmem_ref netmem;
 
 	spin_lock_bh(&ifq->rq_lock);
 
@@ -771,6 +770,7 @@ static void io_zcrx_ring_refill(struct page_pool *pp,
 		struct io_zcrx_area *area;
 		struct net_iov *niov;
 		unsigned niov_idx, area_idx;
+		netmem_ref netmem;
 
 		area_idx = rqe->off >> IORING_ZCRX_AREA_SHIFT;
 		niov_idx = (rqe->off & ~IORING_ZCRX_AREA_MASK) >> ifq->niov_shift;
-- 
2.49.0


