Return-Path: <io-uring+bounces-3830-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id AEB609A4609
	for <lists+io-uring@lfdr.de>; Fri, 18 Oct 2024 20:40:06 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 3D0B7B2305C
	for <lists+io-uring@lfdr.de>; Fri, 18 Oct 2024 18:40:04 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 777F42038D8;
	Fri, 18 Oct 2024 18:40:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="pv0stGs8"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-oa1-f45.google.com (mail-oa1-f45.google.com [209.85.160.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8A12320010F
	for <io-uring@vger.kernel.org>; Fri, 18 Oct 2024 18:39:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729276801; cv=none; b=TyP0+NdacmyOhDSqtdwbzk7YaqabKvYkjqM0CNGQQ1Onw06d44Y/TYpco1vN3LrJ688EE7rRKHnzCTKzW0a24RuuMSJNKbmEsmxC8SxEODVuVD5qPxmuVGcu1lPYc2xjWCLqkjxQ8uYN6wPLSc1OAgPGiWhw42NwOWo+u0Qo6gI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729276801; c=relaxed/simple;
	bh=gAOYuzdKVb6Mk7SD8XmfAHuM3EAk/c+NAqW/Rv2R8Lg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UYz6uNbzp1KJZcX/lIwt0BIEO4Du3o60llfxdQcrvq0xKFJJfcSg533UlcFXryAuvi0UCl/h2fWQ0+IY3WB1ks+TLOR2KGUaQGKmoaf0QLU9U13xTMWoJDhxJKAoqFhhND8+l+6Bq0Iru2veZUzDBAdu3a2K/CXjHNZxoDTltwY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=pv0stGs8; arc=none smtp.client-ip=209.85.160.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-oa1-f45.google.com with SMTP id 586e51a60fabf-288d74b3a91so1471062fac.0
        for <io-uring@vger.kernel.org>; Fri, 18 Oct 2024 11:39:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1729276798; x=1729881598; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=DKm19nf0wk6JSqYXMnkKhRXK7xTl4qYDr26LOfOqa+4=;
        b=pv0stGs8ySRBM2far5k5xk6Mv3IMTX6wdTov73tXVtfWjTmS/XiOn4ErU+kuRwGaXt
         gSccB+wtnVSULxCr9yZzOayeTdj8cMsFuKTqRga9wikO7zwewDHU5808Yz9Y7maPS0Ia
         ljtlD1iurf59J5DahPjrNpB0/W0FFEJvc/4+4NJaLTCxdNJuyvZSdlnxrYejfepywC/e
         3H5Q1JSWBBFUos7ReMkgMukwfQID2WDrjtPAksxikJWZOW3eT6NZJh6WmHXSsWRBvVOK
         ExEbU75gD3uGGAhdQ7u/0791sTARPRHyD1HpGRvty2pi5Is5OVM4Fhd8tiAjeMe8RIVB
         xa/Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1729276798; x=1729881598;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=DKm19nf0wk6JSqYXMnkKhRXK7xTl4qYDr26LOfOqa+4=;
        b=RkPXtg2imsVsn6IxAI24BslfFOMn4Ow4962zD9Q9N8s3jceZeeY2GFjXYvzWd+gEA0
         ENsQOd1FCm+dGCRPMfxiOk65NDcaQigtx2ipZrjED+SgDo1oZ/iKy1yTlmdOugnzV2VK
         fbJ47MHi/egQKxqM7cHL2TCRO5bfn/alz8NsHXHzuPTWCbEVdUttna1XdIqPTXBF0+gs
         YQNO+XMTLibk2qbvyuf4LcPfrVFaFiBd4+31BOZC89nEnw/uVcZaMggybe96HQ4leCeY
         FOxxnMJ01KhZHivjzPP8P2fAkJ9uYJJ7/hWqf/GCDGhWyjJYPoT8Lvyu3QBqxvXVoi/N
         IJLQ==
X-Gm-Message-State: AOJu0YxgvE7kU8iVlOkBjWvikmRyz5fPNWich8s2CzQW5TUyGipQeav0
	TlVWTL2+AMYutGgSyvIdpW7zyUjjlbWdncLp0IUE0+YDN+HZAid7cDixjt5IgKOIANcfA8jYDWz
	2
X-Google-Smtp-Source: AGHT+IEigix2KgJ0ZA4NssLWW2DQY5CahrFtylwPNlPJ8Qap0Y3CBlFjxWxAofyEE71Xjgv0HLp2Lw==
X-Received: by 2002:a05:6870:9689:b0:277:bf1c:da4a with SMTP id 586e51a60fabf-2892c546dbfmr3277405fac.45.1729276798166;
        Fri, 18 Oct 2024 11:39:58 -0700 (PDT)
Received: from localhost.localdomain ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id 8926c6da1cb9f-4dc10c2b424sm534387173.98.2024.10.18.11.39.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 18 Oct 2024 11:39:56 -0700 (PDT)
From: Jens Axboe <axboe@kernel.dk>
To: io-uring@vger.kernel.org
Cc: Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 4/4] io_uring: kill 'imu' from struct io_kiocb
Date: Fri, 18 Oct 2024 12:38:26 -0600
Message-ID: <20241018183948.464779-5-axboe@kernel.dk>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20241018183948.464779-1-axboe@kernel.dk>
References: <20241018183948.464779-1-axboe@kernel.dk>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

It's no longer being used, remove it.

Signed-off-by: Jens Axboe <axboe@kernel.dk>
---
 include/linux/io_uring_types.h | 3 ---
 1 file changed, 3 deletions(-)

diff --git a/include/linux/io_uring_types.h b/include/linux/io_uring_types.h
index 9c7e1d3f06e5..ae42f819c287 100644
--- a/include/linux/io_uring_types.h
+++ b/include/linux/io_uring_types.h
@@ -613,9 +613,6 @@ struct io_kiocb {
 	struct task_struct		*task;
 
 	union {
-		/* store used ubuf, so we can prevent reloading */
-		struct io_mapped_ubuf	*imu;
-
 		/* stores selected buf, valid IFF REQ_F_BUFFER_SELECTED is set */
 		struct io_buffer	*kbuf;
 
-- 
2.45.2


