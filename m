Return-Path: <io-uring+bounces-8430-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 425E3AE08DE
	for <lists+io-uring@lfdr.de>; Thu, 19 Jun 2025 16:34:57 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 6596C7A868B
	for <lists+io-uring@lfdr.de>; Thu, 19 Jun 2025 14:33:34 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0B8142248AB;
	Thu, 19 Jun 2025 14:34:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=purestorage.com header.i=@purestorage.com header.b="JYAmYu0l"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-yb1-f226.google.com (mail-yb1-f226.google.com [209.85.219.226])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C32041FBE8B
	for <io-uring@vger.kernel.org>; Thu, 19 Jun 2025 14:34:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.226
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750343687; cv=none; b=JQOay5xXAS3fVm4bDPHHm/mPWu3kxI4rTxSvepgnOWCjh779LMdAsaB54pWRPQLyaTg5NN95+N6iveiH/EUckTF3ZruyLqhL4ZwyYChZFAudLSi33JKrQM3yXQyECeeJsEuMzVZnY0CAjytTNfEKPBwmNSr/shc8DedW4Snr6mQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750343687; c=relaxed/simple;
	bh=Gr39rdqrLsxp6lFbj8mgr6Hb47LbYzbNx2IISdyK5IA=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=uxB2WCw9biVL4yGw807p2rzrkIbXPf2J4guDXrb6BMvsUf8hM/ok/HCKQDNyx+YPaY2XQMImWoukt/Dsn02B7WURRlxOpTc3hQfEfXR1AXFgezXKPiLF9DMrJ9eheOihmaEQQEmrwTqmxPGmflGT/OoCKz0DNm0DN9dH//n9rZ8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=purestorage.com; spf=fail smtp.mailfrom=purestorage.com; dkim=pass (2048-bit key) header.d=purestorage.com header.i=@purestorage.com header.b=JYAmYu0l; arc=none smtp.client-ip=209.85.219.226
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=purestorage.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=purestorage.com
Received: by mail-yb1-f226.google.com with SMTP id 3f1490d57ef6-e821a5354cdso133024276.1
        for <io-uring@vger.kernel.org>; Thu, 19 Jun 2025 07:34:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=purestorage.com; s=google2022; t=1750343683; x=1750948483; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=y+DUhAWHkst0c7X0/9eUUU0KjzIQKkZSCUQQd7zskFc=;
        b=JYAmYu0l59mn2+TONad2hnSOafQ+dmZ3B2yhH5Fp5P/lNzScofVPJYb7hxvRljt+Gk
         vbbAz6fLvb1nIXuiZex1T9eIFraTNjxl1iObJtNxR5ZysIfYZj7SUy9oTK5N3WO2zHR6
         PosNGz427nrewO7N3ghEFOmXc2e5Ld0YTi5F/nl22Ex2EkiYyDKj6Z1Oj1Ew9sqSVFVI
         0ur7lv+wrm3QvXPAmJ8j0WwL585Vw+P1NpcJkBesI3HcrqQ0FYTdd6TgWfPI6Nxd/MlU
         UTrsh6Em4OsmWq9M+PtaU8x9UMKwM3IpkSf/RTTwHHkH3TO354/H8oe3+pBuc8SJ1LPc
         MBNA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1750343683; x=1750948483;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=y+DUhAWHkst0c7X0/9eUUU0KjzIQKkZSCUQQd7zskFc=;
        b=TNTERKiW8yv9t1pugd0CWUibSDnHiOpYRB9jCM2OuhucQMkArWLWj8QgsJ+sR39p1R
         nfyOpQhgIswuGj7/AMqE9fbOv8ZM1q1boEqBYgjsOmiJetb/mGnfPScP9tJDx/bmZf5g
         QqQJl7wyO6vn6S+Mc4CQ2Y6YINV0axkxLjWlVMZii6fm8ogTGJkdQjrvPmnoGryCRiND
         159gXcSl6O96gnQwMnliKi9lXjh2I95YMuIEGBB3V42+GyYqdNsl6AD7brg3Kr0Bymgt
         +b/8zhSddpZ1oJXM+Ws4mKSYiTftsksYOYPz7utkmwx/7/aSl37OBxLUl5pI+4ln10wa
         CVyA==
X-Forwarded-Encrypted: i=1; AJvYcCXrwf/sDN6/Ax1Nk0NXeUJkC/zLpjkvJ6b7lGWkZZcbNBMZ9R0cvJjiWO1U1cLDujbUn79WM0myUg==@vger.kernel.org
X-Gm-Message-State: AOJu0YwUPL1N295Kpys1y2M1NyAKJ95KzBe+a/JPtrtd045Byj69o3AP
	YBWZgW2oKm3ZfyaShTfriPXBkYnL9NTQIl3oXj9FWYUW0JF1K5tCm557z8epMzqtPObQiwHZiRl
	xEamRn8Y6RVW8o3pCPtgz3ZZpPTxhf4RWBVDg
X-Gm-Gg: ASbGncuP/3nwj5xUjKFyf0DjZTVJj7DmF4JEI4G1v4xcXuCk0sb4Eff+vMz+DwPtP4T
	6y+crHBeZeVwEg0RPjOmTN5iDWPUdSVTYdQXRznJ4L3XHFnMwV1dpcKRgFQSFHoh9uFDe19+tPx
	GDZWHOUDm1AOevMu+EfwL5VIh+lNAJUwXUhnyY8WoYiC+Zw+usGSQvR5X/Q/hQEcXhQk82ejY7q
	BsR0M8kZx/Lg0iL6xQNWgsVLeUp2Mw6dgQsSR0LHPBkXSvAYtl41owPUztb0t0ablW+7nvJ2jpM
	sHPf74+wPVk4XBy51gPI35w+5pFKAUOZSm2DY8Glp3yo2ERExfjJZRU=
X-Google-Smtp-Source: AGHT+IFt6DSlakYJqe8fTMglwxYonTqU4ViPVwUFUnerbH/PRofhRZFUP0LbiTS2m5Lyqu0Zhh99vdkuPNJj
X-Received: by 2002:a05:690c:7485:b0:711:457a:401f with SMTP id 00721157ae682-712b520498cmr22328167b3.4.1750343683581;
        Thu, 19 Jun 2025 07:34:43 -0700 (PDT)
Received: from c7-smtp-2023.dev.purestorage.com ([208.88.159.129])
        by smtp-relay.gmail.com with ESMTPS id 00721157ae682-712b7b565a5sm528877b3.50.2025.06.19.07.34.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 19 Jun 2025 07:34:43 -0700 (PDT)
X-Relaying-Domain: purestorage.com
Received: from dev-csander.dev.purestorage.com (dev-csander.dev.purestorage.com [10.7.70.37])
	by c7-smtp-2023.dev.purestorage.com (Postfix) with ESMTP id EB796340278;
	Thu, 19 Jun 2025 08:34:42 -0600 (MDT)
Received: by dev-csander.dev.purestorage.com (Postfix, from userid 1557716354)
	id 8E20EE44094; Thu, 19 Jun 2025 08:34:42 -0600 (MDT)
From: Caleb Sander Mateos <csander@purestorage.com>
To: Jens Axboe <axboe@kernel.dk>
Cc: Caleb Sander Mateos <csander@purestorage.com>,
	io-uring@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH] io_uring/rsrc: skip atomic refcount for uncloned buffers
Date: Thu, 19 Jun 2025 08:34:34 -0600
Message-ID: <20250619143435.3474028-1-csander@purestorage.com>
X-Mailer: git-send-email 2.45.2
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

io_buffer_unmap() performs an atomic decrement of the io_mapped_ubuf's
reference count in case it has been cloned into another io_ring_ctx's
registered buffer table. This is an expensive operation and unnecessary
in the common case that the io_mapped_ubuf is only registered once.
Load the reference count first and check whether it's 1. In that case,
skip the atomic decrement and immediately free the io_mapped_ubuf.

Signed-off-by: Caleb Sander Mateos <csander@purestorage.com>
---
 io_uring/rsrc.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/io_uring/rsrc.c b/io_uring/rsrc.c
index 94a9db030e0e..9a1f24a43035 100644
--- a/io_uring/rsrc.c
+++ b/io_uring/rsrc.c
@@ -133,12 +133,14 @@ static void io_free_imu(struct io_ring_ctx *ctx, struct io_mapped_ubuf *imu)
 		kvfree(imu);
 }
 
 static void io_buffer_unmap(struct io_ring_ctx *ctx, struct io_mapped_ubuf *imu)
 {
-	if (!refcount_dec_and_test(&imu->refs))
-		return;
+	if (unlikely(refcount_read(&imu->refs) > 1)) {
+		if (!refcount_dec_and_test(&imu->refs))
+			return;
+	}
 
 	if (imu->acct_pages)
 		io_unaccount_mem(ctx, imu->acct_pages);
 	imu->release(imu->priv);
 	io_free_imu(ctx, imu);
-- 
2.45.2


