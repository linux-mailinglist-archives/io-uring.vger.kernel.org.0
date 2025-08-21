Return-Path: <io-uring+bounces-9147-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 9C6C3B2EB20
	for <lists+io-uring@lfdr.de>; Thu, 21 Aug 2025 04:09:52 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id E6C93A24E62
	for <lists+io-uring@lfdr.de>; Thu, 21 Aug 2025 02:08:51 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 67EBA194124;
	Thu, 21 Aug 2025 02:08:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="1V4YlXRe"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pj1-f52.google.com (mail-pj1-f52.google.com [209.85.216.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E61112D8DCA
	for <io-uring@vger.kernel.org>; Thu, 21 Aug 2025 02:08:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755742131; cv=none; b=G2PAimB3MWThnDXfrIu9n9dXJfPnHIIQZfrwzaPktEtAFCnamMhTnMap9kzDsBQQPNmm70i6lNk3nDyTtWLRPaLq95LNocKVSMQDGqPtVzTb3I25LQ4virXPbs603SqCRSE+3WwNP9GkwjYOC/2+FVD0FAlF/a84nbkD3rI4lxc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755742131; c=relaxed/simple;
	bh=z22CnnNUfb4eUQJlyn43RIDDTFZk6IXP64yrFNlyhh4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fbe0wMfNnMmWLug4LMTc2TGIavcqrI7VNZuJlh6DXgY59vI9YnXHXbNLuUvr1TP7fanjFH3s133ZY0brRe8SvvxCWiRilEX1Z9mlTOXNbNYibV/1Endk7L3vtgeoHBniqUr5FibVtzMPVTorSRPbSzK2MB7xu49ZtMm/tRoClEY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=1V4YlXRe; arc=none smtp.client-ip=209.85.216.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-pj1-f52.google.com with SMTP id 98e67ed59e1d1-32326e8005bso611012a91.3
        for <io-uring@vger.kernel.org>; Wed, 20 Aug 2025 19:08:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1755742129; x=1756346929; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Jv/xnt0ZEob0PHLQOowYo+NlbXVrcgKpU0CwggxALaM=;
        b=1V4YlXReK7fcUFXBYK99scQq2H00no1Y90ROyJIXDAJLUX25VGZoeLVFbn/j2tdEvQ
         BuyZMtro/rc3A6PAtKzy6pb9hoyTizN/C+7MuDdc8TWHA3tWGST2ZJ47QuPsGghi4EfW
         1616kvX+iw53R7uegxFDn16FFtQWn+gRxtjMuYLegdwwO6l+nPzKHBPUr18e6jG7eE0V
         Tspm7GqimO1Nt/WYp+jT3Que/FM5qZA0QoFivCU+kALHry54gVR5Dv4c+k0l2TALGe6r
         qhAVoKJpAFKX+V9qGxQiq+dDwbaaV7gwy4xXkKIWCXEp+vCAI55dE9shQyC05pXfby0s
         uu8w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755742129; x=1756346929;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Jv/xnt0ZEob0PHLQOowYo+NlbXVrcgKpU0CwggxALaM=;
        b=aumm6rFNRTYg05tLP90lMU/71WcrrEad6tAuI1sm2DOTt+tQNmiKO9rxE/h0ojB7yN
         ENgmACSwIHc2OdI2lWnIwOXJ1OhnqtzWCh0pBe9SBuijbpQ1rpIf0FCw9WXbYwSIjjwW
         8rnSsZb/J3sTz1s6V79BBEtQfcBq/jXW9Q18E25IYJyEHUlWrHTTqIDUSRYy0rDDXytq
         MV1Y548zZR8WUEIAro7CkMkqiAsP0W9xe621P+zoSNMWou/GFs/seNYd3LnGSt9htyZr
         A62LMpWyXdkhn43smwMlaXayG5Hu3HZWF+uAGTcHCL/xWUDow3h8XWa4ONSDK3dmK/Rj
         dxEQ==
X-Gm-Message-State: AOJu0Ywvq5nExi/yaR7Ew6VNN2eplc9ZQROCMcf0tnQ4Dlw/WCxafFHr
	xd8UAeeX3VV5kuZXPyZlEbhYRYFoMUNdVG7lVa054fMeFhgrNtm61kcNT8swNO3BLLF+RfeqB+0
	saDoT
X-Gm-Gg: ASbGncs67AVHSbvS7SsFUhJkQtGOVuSbDh4b5mITcuVOb06tSyOnAS1ZggfxT/OXs9Y
	VuV2PTxDCyYZwwOfLpigJZmXKBz+fa2/Sg8X2o9p/60pBsxNmX5n5aG3+YQNcEnC55mmVbs3TCB
	2VWIy218Cv3RONVbT5sESHQXZsaOIhp3i3iu83DnEDr5QO7gOK9QHt07v8MqSrXhC0plwBZhZS3
	n9LthmV0vqZP4xmtqagav692pXwE0IEv90ulnSHLxQA/WJgiA+blM30KhRYLOHRQp26y3Ph+qMs
	n2cux1IMBvcdpU/sIRgStgIi6MW1BMHT2me2pfmt5LbePG/pyY76p1KE34guY77W7fvU+izg6/H
	a9G/dOq0=
X-Google-Smtp-Source: AGHT+IEJPb1uKNjB2lnHDASyDeLtLdS1JnHh2sptJNFUnk9lgsTD6DJ6EkuTGef/HmCMjmO/4HbbWQ==
X-Received: by 2002:a17:90b:3dc5:b0:324:eaed:1a5b with SMTP id 98e67ed59e1d1-324ed15454bmr1242009a91.31.1755742128700;
        Wed, 20 Aug 2025 19:08:48 -0700 (PDT)
Received: from m2max ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-324f381812asm104827a91.0.2025.08.20.19.08.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 20 Aug 2025 19:08:47 -0700 (PDT)
From: Jens Axboe <axboe@kernel.dk>
To: io-uring@vger.kernel.org
Cc: Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 12/12] io_uring/kbuf: check for ring provided buffers first in recycling
Date: Wed, 20 Aug 2025 20:03:41 -0600
Message-ID: <20250821020750.598432-14-axboe@kernel.dk>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250821020750.598432-2-axboe@kernel.dk>
References: <20250821020750.598432-2-axboe@kernel.dk>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

This is the most likely of paths if a provided buffer is used, so offer
it up first and push the legacy buffers to later.

Signed-off-by: Jens Axboe <axboe@kernel.dk>
---
 io_uring/kbuf.h | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/io_uring/kbuf.h b/io_uring/kbuf.h
index 1a539969fc9c..32f73adbe1e9 100644
--- a/io_uring/kbuf.h
+++ b/io_uring/kbuf.h
@@ -129,10 +129,10 @@ static inline bool io_kbuf_recycle(struct io_kiocb *req, struct io_buffer_list *
 {
 	if (req->flags & REQ_F_BL_NO_RECYCLE)
 		return false;
-	if (req->flags & REQ_F_BUFFER_SELECTED)
-		return io_kbuf_recycle_legacy(req, issue_flags);
 	if (req->flags & REQ_F_BUFFER_RING)
 		return io_kbuf_recycle_ring(req, bl);
+	if (req->flags & REQ_F_BUFFER_SELECTED)
+		return io_kbuf_recycle_legacy(req, issue_flags);
 	return false;
 }
 
-- 
2.50.1


