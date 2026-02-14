Return-Path: <io-uring+bounces-12206-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id UPVmOgr1kGkCeAEAu9opvQ
	(envelope-from <io-uring+bounces-12206-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Sat, 14 Feb 2026 23:19:54 +0100
X-Original-To: lists+io-uring@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id 5782213DB2B
	for <lists+io-uring@lfdr.de>; Sat, 14 Feb 2026 23:19:54 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id ADC1030158A5
	for <lists+io-uring@lfdr.de>; Sat, 14 Feb 2026 22:19:51 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BCF3C314B9A;
	Sat, 14 Feb 2026 22:19:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="gGyW9r/Z"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-wm1-f43.google.com (mail-wm1-f43.google.com [209.85.128.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4B0D43EBF02
	for <io-uring@vger.kernel.org>; Sat, 14 Feb 2026 22:19:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771107590; cv=none; b=CST7YLQSTSzyTm1NNsvML5cMChp5DwWh1t38gKwGpzNicaTdCc2MLvwl9je7s2fcT8MCGlz0Qt2l4Re8S7GqpzErLFIkxZWCbGRmE6pXT0EDDTMzPjEPSjR/ceVbuP2tHFsNL3WZhQdY3d0syMBJWQIt0uTNolOhB9tLdPXJdvw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771107590; c=relaxed/simple;
	bh=zvgYwbndzjuLdn+N1S5WxooWnhAkhdeY9CsN2L6FyGs=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=Tgd/2NyAeOYIXydrUVkc6fuBdvmtxX6LBns/ccm3QppAuHhtiPK7jlB41B2bkeyOltn5gexJiRMBQC+NBf5mB6ZyT/o8XqVzxbz8EIWKEB9dCvZoHwv3RBTGy7Rv0nu+Iy2EpB/+460kNGBHYQXLHind/ChoIhBxrAPmznEh3bE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=gGyW9r/Z; arc=none smtp.client-ip=209.85.128.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-wm1-f43.google.com with SMTP id 5b1f17b1804b1-4837584120eso11168055e9.1
        for <io-uring@vger.kernel.org>; Sat, 14 Feb 2026 14:19:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1771107587; x=1771712387; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=IfWuWXCGCqCd6Ahs+RwT6PL0vAxh8vICPMFNyO+e8dk=;
        b=gGyW9r/ZI8r8fJP/pcWI+rDrKEGARFCDRoFZwydWXNoI3RSSD96OMOmpDWZtNhoTAU
         Lbrd0tDnH5ZqCrGfVrfzTq+g35/BxDVnCFzsXfNOVSWq4mwIXWEIxZu35PRP7fAHjQgB
         8TLWUWiDuySiiTz6i6rujX264PrFZVniBsXUHXdeWkZNIPhfcKx+JDvQDD2itoEhgkss
         N8ENIsvmHgDyOopWySQKfLN6lsY4I04eyHWvRbFAV6UmlkLdUTBDqYZWytdkoljX8QJh
         P+rXECqfFpUP2h8UM9w0vcEFYIjFCsT5CuE9dB/y0hYvhRIkbZbo3ZQXFw1pP4eLM4dc
         +jcA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1771107587; x=1771712387;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=IfWuWXCGCqCd6Ahs+RwT6PL0vAxh8vICPMFNyO+e8dk=;
        b=IX7ore9WEJK/jKsauWsuWGxtkYnINSg2TwotGszjuMWeQbh2RmrLFr4RYBrC6+bjYi
         Rq3+K38HNXrfqOXdk4Iott8+cZI54Hf4X7fnOqB2qit1fDmpCU52oHGJ3mgVA0DPFUTU
         tIPKaNSMIUK26jpksOcmFCj6ucQEgNE0yDajWz/HGDgz0IpNIPIJKnVL1S5V8lnVV5p5
         VXvas7kHPAqfQCokyFb2Yh3CTtpd0rIE6ecNG3TMVxkls0a518kTdXLVRil+27BTeojR
         5U7UBTYO3XMZLMGmBfdq9yuAlovrqT4r6N/LkYQgUG9x83L03PlFnembW4FJSJxV8g/w
         4csA==
X-Gm-Message-State: AOJu0YylvQjbdOLpHOy2HqKeCtLg4gjaXzanUzQNUY0OzxfFh4SVkzBP
	gVBcNhDc+I1aYlS0yZxbLMnngEVMta48x01b/TJq0WaIlMkto9nd6/lczIVa6A==
X-Gm-Gg: AZuq6aKTV6XJopkDtulaPF4q52T3XMKvjw41rvMChoNEAxHmzb1T2+zGPmxqlIqz0Nz
	VlLekH2Yx1Zsmez/vPiYfv872FwAavepQVe05jU3mU9K0QBsRmmdBB3pQyVvvBMhedPkM6L+n0Z
	CGanA8GLTfxCSFKDf9nK3eq0xWK3kB76IQTdBdKHfPqN+gNmSP7CDxrU2+TA2KxIHXVrQlQBiyE
	zUPcp4bILiqFokBF4l1VtrO1DxlVqNLdWlU1naSaVLPr2AWNL3Vx5OgH8S+yr+OKwkvawoRUpFL
	UjOfvqSATdyzcijPDz67lSu+36wlcEX3wNxuju+nXqE3NpLx6+x4YHZ7B9ujKTocXPyfz0oI8a7
	nEnsena+G/sFT5kegJIuq755QAb19l8vMV1GirQd8yG7PbnUUabu9zJGMj6NPczE6BQKcxx9dVV
	+8Hkag1COS6HoYez/q0x2hAgTAxeBcP+PPAYoaARPntNQb/w24meG8yjI/1U6crnUv0lBkmBUsq
	26UJCIeB8bmo9ZbgxKHAcyYbEprSA==
X-Received: by 2002:a05:600c:8189:b0:482:f12f:f35e with SMTP id 5b1f17b1804b1-48379b98ff9mr60265975e9.12.1771107587038;
        Sat, 14 Feb 2026 14:19:47 -0800 (PST)
Received: from 127.mynet ([2a01:4b00:bd21:4f00:7cc6:d3ca:494:116c])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4837e565f5esm82462235e9.10.2026.02.14.14.19.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 14 Feb 2026 14:19:46 -0800 (PST)
From: Pavel Begunkov <asml.silence@gmail.com>
To: io-uring@vger.kernel.org
Cc: asml.silence@gmail.com,
	axboe@kernel.dk,
	netdev@vger.kernel.org
Subject: [PATCH 1/1] io_uring/zcrx: fix sgtable leak on mapping failures
Date: Sat, 14 Feb 2026 22:19:32 +0000
Message-ID: <de01fd4111d3f89ddbddb70bdd427c741f0cda46.1771091730.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.52.0
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
	R_SPF_ALLOW(-0.20)[+ip4:172.234.253.10:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-12206-lists,io-uring=lfdr.de];
	FREEMAIL_CC(0.00)[gmail.com,kernel.dk,vger.kernel.org];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_HAS_DN(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	MIME_TRACE(0.00)[0:+];
	FORGED_SENDER_MAILLIST(0.00)[];
	DKIM_TRACE(0.00)[gmail.com:+];
	ASN(0.00)[asn:63949, ipnet:172.234.224.0/19, country:SG];
	FROM_NEQ_ENVFROM(0.00)[asmlsilence@gmail.com,io-uring@vger.kernel.org];
	TO_DN_NONE(0.00)[];
	RCVD_COUNT_FIVE(0.00)[5];
	RCPT_COUNT_THREE(0.00)[4];
	MID_RHS_MATCH_FROM(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	TAGGED_RCPT(0.00)[io-uring];
	FREEMAIL_FROM(0.00)[gmail.com];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns]
X-Rspamd-Queue-Id: 5782213DB2B
X-Rspamd-Action: no action

In an unlikely case when io_populate_area_dma() fails, which could only
happen on a PAGE_POOL_32BIT_ARCH_WITH_64BIT_DMA machine,
io_zcrx_map_area() will have an initialised and not freed table. It was
supposed to be cleaned up in the error path, but !is_mapped prevents
that.

Fixes: 439a98b972fbb ("io_uring/zcrx: deduplicate area mapping")
Cc: stable@vger.kernel.org
Reported-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 io_uring/zcrx.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/io_uring/zcrx.c b/io_uring/zcrx.c
index 69567e19b4ca..006e1bfefa5f 100644
--- a/io_uring/zcrx.c
+++ b/io_uring/zcrx.c
@@ -288,6 +288,9 @@ static int io_zcrx_map_area(struct io_zcrx_ifq *ifq, struct io_zcrx_area *area)
 	}
 
 	ret = io_populate_area_dma(ifq, area);
+	if (ret && !area->mem.is_dmabuf)
+		dma_unmap_sgtable(ifq->dev, &area->mem.page_sg_table,
+				  DMA_FROM_DEVICE, IO_DMA_ATTR);
 	if (ret == 0)
 		area->is_mapped = true;
 	return ret;
-- 
2.52.0


