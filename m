Return-Path: <io-uring+bounces-12906-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id qB2mAm04zGn7RQYAu9opvQ
	(envelope-from <io-uring+bounces-12906-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Tue, 31 Mar 2026 23:11:09 +0200
X-Original-To: lists+io-uring@lfdr.de
Received: from sto.lore.kernel.org (sto.lore.kernel.org [172.232.135.74])
	by mail.lfdr.de (Postfix) with ESMTPS id C34DA3716A3
	for <lists+io-uring@lfdr.de>; Tue, 31 Mar 2026 23:11:08 +0200 (CEST)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sto.lore.kernel.org (Postfix) with ESMTP id 94F54306E190
	for <lists+io-uring@lfdr.de>; Tue, 31 Mar 2026 21:08:16 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3214F41323C;
	Tue, 31 Mar 2026 21:07:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="XIpEWXNv"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-wr1-f45.google.com (mail-wr1-f45.google.com [209.85.221.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AA809423A92
	for <io-uring@vger.kernel.org>; Tue, 31 Mar 2026 21:07:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774991262; cv=none; b=ShwJJ8bKHf1W0bPXsaYM7N+ZIl3gTFIyXHwEnQxI4FUA7M9Y9Ua8+qvc/Rqlbjpm1JiYV+WMN8/+Dsejjdlrs4N0Y2yKmFDOUCThWIhfR71+ovPxcH/JNgFXVwFZ2v52pjxZLKXskPOulFAVF2b3zVh/izP0U0zWz/T7PvWc8/o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774991262; c=relaxed/simple;
	bh=sDNJgH/ttdk5M8DhwU5nl6fTGa/xQQGwBH0RBcQg8Sc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LS3CXVoVaYSq+7TTjJ+jF8zDD6GosyF94HNIx6LXD99XJ44xHKGr2jh6tDLjGsi6fi0kBAIj5/PBnpeE7Q5jrBEUZdhg1RdixF2cEg6t62C0zH2khBBaeVY87e3sKwc+uHCyR4LmG/XklFIrEb7/u2GGEoZIJOp71Vd4JZkmOj4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=XIpEWXNv; arc=none smtp.client-ip=209.85.221.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-wr1-f45.google.com with SMTP id ffacd0b85a97d-43b87970468so5407538f8f.3
        for <io-uring@vger.kernel.org>; Tue, 31 Mar 2026 14:07:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1774991258; x=1775596058; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=hU1F6N/ptF7KDLzfeOiGQ+wkh6yR548EBAW1ECp/d2c=;
        b=XIpEWXNvUZlHPVJ+ocAmAV4O1jWlWbcfdIUSxfCs4cxQNCrqdoT/AB52Poxq1abXpJ
         ELVDw4kdVtf0ZLVBzsWYgBIj5hTYSP3qKkGls1Xiz3sHahICIrqxQavmdslpsGPZYVql
         LLRtAuyw2gWyO6j5VHoTc/eRlybFxtWp98jQdoDt3eGEOe8uew25WdlT8Rf2KFIztKTB
         xf6fMfC792lLfrXbD2NLLsB7d3gYIK5dPcRNdAPV+7/Pn5vF2wWLrnll5CSvtPSeR+wQ
         5HKr1/Qb4pDXrTF1jsgozAjPJQeIq9QVrcy/a1IZLYGTnsbXk5o+nPU9A+4i8Y0MnYEE
         gl9Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1774991259; x=1775596059;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=hU1F6N/ptF7KDLzfeOiGQ+wkh6yR548EBAW1ECp/d2c=;
        b=iTfHCCKwedOgUxX3WYzgVcIMIA2kE8Bw5K3XW+X97UdaOmXOpK33Ajy7llhDtwHR6W
         gPsJ2Qhy67d6uf9e+/ae+JZAs9EtGdfFcpBTHq2eVbwPSGOB5iQzAJIJW5GIJzsP03Ta
         dfiDLhDzclQ1lBwwZ8nECGy4gTre4kS/aPz/wqJJ75uVnppX4fYS0ZGQnsq0fJ8H7exI
         XrNTmmAIwC+h32x5QYktl+0GcBxt24Lha/DNh9tuq7Db7POs4CuCTDDDzMOMRg/LZ8hP
         YsU/xfsUcNK6mxmtUaPtdsPeEQV+5wkAfZP0to0PORkCE8Ck+wn2aR4Tz5FBVL8g2DlL
         domQ==
X-Gm-Message-State: AOJu0YxIWjb75U1rXP/HsEyAOihNj3SJQ3sbN8yYd2ul4HLHfxlnjkHN
	SYFlHUXZRHSXVIDH+qfCSegfJKiR1zO0uNbn+iz36E7QU3bdJ+wsWqAVPafOCg==
X-Gm-Gg: ATEYQzzEDhSwQG8cDhGjonRVCKHq3lw/nuyl7La+AhZlhsS7DmVEItrPPbud361Xj+4
	v4ylKVZEkxFrC64CBirLK3LOU0JHX5xmMXlNFPsHeFI1vkcOeAeiWXwQ+qHJvIByDL2oe7wZohy
	zYFmZx0PXEzMo7cVjUKNYizyAKwAxfn+CVIpX+D29kgvHb+5Ct8SPRrAScTNG55NXYIrROHhrcc
	bgY8W6L7J1HYHkM3WlJI8HiLApltQud1wsjl+ntNdQ3ScMldI3FSaJWduHr/dWgjCraSHKU/zwK
	Xg2yImhCjqK4eBbEa66rLPllMdjhJDo/kt6mOEAT84oA0Jc7zU9dQbQ/PEl7uT1a2vAP25pLZLx
	7u0HhBkvSnU9qp/gLNApXuK7BYDXboGKeVsGktEDz7ROlWBq3O+dVeX1iO3VaRV1+PcrvIVpERJ
	7ODFtW9SfTvWQiagQHEtHXM5wXeC3UZBY5itnqUNBVuGGLDJs/5R5chZk5PAYqqGcv2oXq4dQmk
	TSnMRb5GKlwT4oFltn0N3cW/+ZN9Kunrb7QGNZi
X-Received: by 2002:a05:6000:2c06:b0:43b:8f4e:27f8 with SMTP id ffacd0b85a97d-43d1505e841mr1888498f8f.12.1774991258501;
        Tue, 31 Mar 2026 14:07:38 -0700 (PDT)
Received: from 127.mynet ([2a01:4b00:bd21:4f00:7cc6:d3ca:494:116c])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-43cf2570b18sm32431393f8f.31.2026.03.31.14.07.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 31 Mar 2026 14:07:37 -0700 (PDT)
From: Pavel Begunkov <asml.silence@gmail.com>
To: io-uring@vger.kernel.org
Cc: asml.silence@gmail.com,
	axboe@kernel.dk,
	netdev@vger.kernel.org
Subject: [PATCH io_uring-7.1 v3 5/6] io_uring/zcrx: use dma_len for chunk size calculation
Date: Tue, 31 Mar 2026 22:07:42 +0100
Message-ID: <03b219af3f6cfdd1cf64679b8bab7461e47cc123.1774780198.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <cover.1774780198.git.asml.silence@gmail.com>
References: <cover.1774780198.git.asml.silence@gmail.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spamd-Result: default: False [-1.66 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[gmail.com,none];
	R_MISSING_CHARSET(0.50)[];
	R_SPF_ALLOW(-0.20)[+ip4:172.232.135.74:c];
	R_DKIM_ALLOW(-0.20)[gmail.com:s=20251104];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	MIME_TRACE(0.00)[0:+];
	DKIM_TRACE(0.00)[gmail.com:+];
	TAGGED_FROM(0.00)[bounces-12906-lists,io-uring=lfdr.de];
	FORGED_SENDER_MAILLIST(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	FREEMAIL_CC(0.00)[gmail.com,kernel.dk,vger.kernel.org];
	RCVD_TLS_LAST(0.00)[];
	RCPT_COUNT_THREE(0.00)[4];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	FREEMAIL_FROM(0.00)[gmail.com];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[asmlsilence@gmail.com,io-uring@vger.kernel.org];
	FROM_HAS_DN(0.00)[];
	ASN(0.00)[asn:63949, ipnet:172.232.128.0/19, country:SG];
	RCVD_COUNT_FIVE(0.00)[5];
	NEURAL_HAM(-0.00)[-1.000];
	TO_DN_NONE(0.00)[];
	TAGGED_RCPT(0.00)[io-uring];
	MID_RHS_MATCH_FROM(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sto.lore.kernel.org:helo,sto.lore.kernel.org:rdns]
X-Rspamd-Queue-Id: C34DA3716A3
X-Rspamd-Action: no action
X-Rspamd-Server: lfdr

Buffers are now dma-mapped earlier and we can sg_dma_len(), otherwise,
since it's walking with for_each_sgtable_dma_sg(), it might wrongfully
reject some configurations. As a bonus, it'd now be able to use larger
chunks if dma addresses are coalesced e.g by iommu.

Fixes: 8c0cab0b7bf76 ("always dma map in advance")
Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 io_uring/zcrx.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/io_uring/zcrx.c b/io_uring/zcrx.c
index d84ad40eae49..3bf800426fd2 100644
--- a/io_uring/zcrx.c
+++ b/io_uring/zcrx.c
@@ -63,7 +63,7 @@ static int io_area_max_shift(struct io_zcrx_mem *mem)
 	unsigned i;
 
 	for_each_sgtable_dma_sg(sgt, sg, i)
-		shift = min(shift, __ffs(sg->length));
+		shift = min(shift, __ffs(sg_dma_len(sg)));
 	return shift;
 }
 
-- 
2.53.0


