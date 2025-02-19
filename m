Return-Path: <io-uring+bounces-6555-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 29AF9A3BB47
	for <lists+io-uring@lfdr.de>; Wed, 19 Feb 2025 11:13:28 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 596D13B517B
	for <lists+io-uring@lfdr.de>; Wed, 19 Feb 2025 10:09:09 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 581EE1DC184;
	Wed, 19 Feb 2025 10:09:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="XFZEn41s"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ej1-f52.google.com (mail-ej1-f52.google.com [209.85.218.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 96D3B1DB546
	for <io-uring@vger.kernel.org>; Wed, 19 Feb 2025 10:09:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739959747; cv=none; b=m0PaTuB9mKrQCPf+++sBGgvzgpB0SCeoPFZEGT7/Cb2HzG1IKiwhgDGVqA7Lv8M9PKJPfKcIZg7X6/DyGmMsKxbUes4Gzi2fe+4+CYhzBi3L2w67bIYI9SET1w075cUaIqAC94ugQgFJ2qw+MJwZVIUE5Rci6NlqNh/Mt3Cms40=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739959747; c=relaxed/simple;
	bh=5SYAZNUg/RKcESHBy5beIRJSSAwQ/4hLbkFbh+Ufiis=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=nWQAGSq3wbaIqjrE8hgWVW1hmIzG87rbmQAe3z9cFzb2NCe7c9qA0MDqnyloUMbjH3AIr0J9KHiiYBAJH7G4tHWxW8gOTwFye68moIb6va0ww3Cv8FM1p14q7yyNB1wypX13723N6WZoP8YqkjtESnjb34l1zmb+HWcQecl+l88=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=XFZEn41s; arc=none smtp.client-ip=209.85.218.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-ej1-f52.google.com with SMTP id a640c23a62f3a-abb8045c3f3so480260966b.2
        for <io-uring@vger.kernel.org>; Wed, 19 Feb 2025 02:09:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1739959743; x=1740564543; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=ImM9l31Qqc822crAYwq+aQfdQU/Omp2hZgGQQWHU9bo=;
        b=XFZEn41sf5iLwQ+wd9ntrl+MJdtBH/FArClJ9KX1JcCMBbdEh9xxUcbu4vAUnMJg+k
         mUjpvW1fNvqwJ+y4a3DrTEm1emulqlDoXfox/VWb/Alf25hSexp3/1B7bLmQa9iHThHm
         M1gLXndhHXElDdJzgmVYiS0kbd0M2SPNsnjzSa7DoGwFFxo0doypYcn0ANAneGwrXwfi
         554JUoPN2zguCES19WlBADM782sQiUcDhTIh7iM9wBcSsBs04tu2dOSSeQWl87sW5llQ
         dKpi8x3R566c3VAEQBjE7XGskkRfmTDEx/SwuqlP56whCghQxwg8RKTYvQBt5Idt0PMK
         i3wg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1739959743; x=1740564543;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=ImM9l31Qqc822crAYwq+aQfdQU/Omp2hZgGQQWHU9bo=;
        b=pHj7wIfDBw3r3i/EALlgRMnd/VooBMlWqiMcDWXAipBN0HaOAQTT9EFwtg+FWqPLJn
         xUKx/Wvj/oXKaFmXUlsJ0RFBXqY+WSab98eV4VP2aJ6kbEwojRU4tQLmk3zGp+hu9Fr2
         w/tcsRwhprq/yBlWez0Mm9S1fJmi9ZtL0x32/8CPtl2PC4Bh0FHf1xjI4weGTxoG+gu7
         GJMXWrTv3AV/WCY5lLt8IxCGpNv742XNKCjadqPHKL0lwsO8Q4kETYZANIsE2BCOIJ43
         9Fl+u4nrDokDnQ0l/+lAVLbOb1TCJuo4Ak70QXh6QxpCpE2HzVfiUUcrqlbStWW3b7LP
         GYeg==
X-Gm-Message-State: AOJu0YwHboHDGwxAz2GbKz3Ek4zyP5MVO5t3wtdoATUqQR5MNYOEc4ta
	O5NHXZBHgzrcOA6yHiJmWvkGhTWTL9plPCNybgeuHSlsws5gjLQcobpddg==
X-Gm-Gg: ASbGnct/z+fb1ykLVXNb4DgR/PTsBOE1VgV1aUv0Cq7WteQAJtRUU7flYXvAAr0q/7K
	IxHrYzN2tKnHecqoCjSuRji4g7O0x7yksh7T//c3A4mvO75zdOCPGg4DDmip5ETnevU7uiDh3M2
	jhjD0NsBdpGtvjkcXWW/Hv5YmGK+m8ql+RWJbAAMPQdVM9n9glr9MpE+ZHkcA06kx2vSWkxgr9C
	wmd7Y8I1WWY9PW765LZDJ+aX+aCqTMsWBFC0fcF+cba1P5O0ovCDkvQiJk3Ot3/yAE9Lc/vsb0=
X-Google-Smtp-Source: AGHT+IFn7lVs9Fr886OQnkL6dnbCrsvLmr4SRvql2oiXV+lLiCcvwY5330cnjws5tUIUdqLOGBLgbA==
X-Received: by 2002:a17:907:7743:b0:ab7:ee47:993f with SMTP id a640c23a62f3a-abbcd0a6399mr258094866b.47.1739959743147;
        Wed, 19 Feb 2025 02:09:03 -0800 (PST)
Received: from 127.com ([2620:10d:c092:600::1:cfff])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-aba5323202dsm1230141766b.6.2025.02.19.02.09.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 19 Feb 2025 02:09:02 -0800 (PST)
From: Pavel Begunkov <asml.silence@gmail.com>
To: io-uring@vger.kernel.org
Cc: asml.silence@gmail.com,
	kernel test robot <lkp@intel.com>,
	Dan Carpenter <dan.carpenter@linaro.org>
Subject: [PATCH 1/1] io_uring/zcrx: fix leaks on failed registration
Date: Wed, 19 Feb 2025 10:09:54 +0000
Message-ID: <fbf16279dd73fa4c6df048168728355636ba5f53.1739959771.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.48.1
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

If we try to register a device-less interface like veth,
io_register_zcrx_ifq() will leak struct io_zcrx_ifq with a bunch of
resources attached to it. Fix that.

Fixes: 9fd13751abf5f ("io_uring/zcrx: grab a net device")
Reported-by: kernel test robot <lkp@intel.com>
Reported-by: Dan Carpenter <dan.carpenter@linaro.org>
Closes: https://lore.kernel.org/r/202502190532.W7NnmyiP-lkp@intel.com/
Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 io_uring/zcrx.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/io_uring/zcrx.c b/io_uring/zcrx.c
index a9eaab3fccf2..f2d326e18e67 100644
--- a/io_uring/zcrx.c
+++ b/io_uring/zcrx.c
@@ -388,8 +388,9 @@ int io_register_zcrx_ifq(struct io_ring_ctx *ctx,
 		goto err;
 
 	ifq->dev = ifq->netdev->dev.parent;
+	ret = -EOPNOTSUPP;
 	if (!ifq->dev)
-		return -EOPNOTSUPP;
+		goto err;
 	get_device(ifq->dev);
 
 	ret = io_zcrx_map_area(ifq, ifq->area);
-- 
2.48.1


