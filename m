Return-Path: <io-uring+bounces-7964-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id E6CACAB5B26
	for <lists+io-uring@lfdr.de>; Tue, 13 May 2025 19:26:06 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 72F511B446F8
	for <lists+io-uring@lfdr.de>; Tue, 13 May 2025 17:26:15 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3B5082BF3F6;
	Tue, 13 May 2025 17:25:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="P3mDOhoN"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-wm1-f42.google.com (mail-wm1-f42.google.com [209.85.128.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 66F962BF3DD
	for <io-uring@vger.kernel.org>; Tue, 13 May 2025 17:25:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747157151; cv=none; b=lWMA7gEa37vnLSJToucsi7wG1Dbh04ivGK0dLLS9+2eFWfHS3QvBeilPRiHtUD6oNCvgIsqYfbSx1vVCaNBXGr6JMu9+WghMQ69YcAaj4Prd19ONBzBvyAaa1s4cf9ZkCha+aLCMExmDZtUwZPuArYc/jAttiRbdGOH5OheZKrw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747157151; c=relaxed/simple;
	bh=OCOEB6GbqgHgmwZZUfG5UosZPjkUOcs40BNSGB8JV2U=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UfNUGevcrhXzSv37CyDKbD0Oo4EfrDH64sBqsLbqyq1dfC/MwczCRpqFILlqW2x7Wmx/9PZJ6k7nUESWuQds1R2kUtNKDIb9tgHmz4k6xmyC0r7n8mwtT6PNsO/XGIN3HR3ArylKufFRvDLW6AicFNctozi61zeh4Zpz+reuHzM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=P3mDOhoN; arc=none smtp.client-ip=209.85.128.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-wm1-f42.google.com with SMTP id 5b1f17b1804b1-440685d6afcso65488405e9.0
        for <io-uring@vger.kernel.org>; Tue, 13 May 2025 10:25:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1747157147; x=1747761947; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=x21J8q5zUCRi+c4qaGslK+TfYziSX3rJUe/NP6wesf8=;
        b=P3mDOhoNY1jkH0tCmbiJaVuWtCizvFvFdRDa1nu7md5JurVokoN82egLytTSQGl1bD
         rCx/7TPDnjrcmAsYfIhztbznQ32M6lehVLQR4ygdPGptSaeOey3CYPfhTFKziTN0wMqb
         xPdRt7gS6VN/J+dQqM9bMbaVcGMosC2prfLnakDckdC0AnbuKiF06qKKGdemLyGVHAVF
         l2KjeCS3NNSXAUH32Pp2P+Z7/ewmQSfZZbc5VCIX959MLXw/WNcGdEYziVjbTKWIccGr
         Kw8LcjT1w8ftbXgxOue5BOk9hQTrI0PrwQnB1kbf7sPayYraOADGlYebf4CbAf/hFdda
         zM/Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1747157147; x=1747761947;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=x21J8q5zUCRi+c4qaGslK+TfYziSX3rJUe/NP6wesf8=;
        b=npWrVfD1b6CIsOxFj2Jp+mqBDjAIqXgU8WsoDUwgWRbIymGh3R+At6CKu84n5LColP
         wsrIFmz+JyyB+GdKcjKIRM6T0P/pN7T7X/lAUNm2zuGEIlsxkaQ2QUjCc/I6oT4Y/+Da
         2UJXGLLTnW9aLsb/SUY5qyIYt0DHNliPetwYW9hQfnPILQSshv/VnYPnGFRJ9VnSSLnq
         hnIqavHjFkEqutltEDcW6ZT5+RWBs8jyqrqqDwdYfV2odzJwB63jrNRdASlSyyyjKxUy
         mI/jSdOn0w4hrF/JzRwDi/8Xik1PcHuzYMJbrh4JyfPhm5smPomDMRlNFBe2HaGMt4rL
         tOfA==
X-Gm-Message-State: AOJu0YzQuPGETS0MBpChSbn1l6DW/z+55u9kQVEvBJS2ppSGMHcQ995c
	iVAA+lRbs4eyLrj1ozYKF1s1eiFQm9hPqOWmIYmfI04tMzVc/2TdseSseQ==
X-Gm-Gg: ASbGncukQhWG4Vsmm/Z8WWfNj6vQcbHQnaHCs19cHtj8/eiCBuXn8wdAmCufdl5vGcN
	fSLiNsMns05eC/Yn5ObDf2S2aq6NoXFkxcdq6Huoe6HkVsyKnglQrYi0rXsf0tfgnomT9pDvLbu
	SpP2A4ouXpoMbrK/r7t+MzGfr1QRK4UfDth/NmxKKdd9hxQMBxsIAkj+/S4mWbLObsQqNhni+qp
	RVcx2QwdvI/DZeLAB1dRVMdJYaQS3wie0iqE/ATmrvZeV4PQMce/psy99SUiapEl/eVYJF8i1XE
	9ydy2JvDsyag8W0vSQN0395FqLvLwagk2WnQgfDoLYfpM1UTbUgtoMitwzhO40L7/Q==
X-Google-Smtp-Source: AGHT+IG7y/38+QtcG/iBoUyueJVtC4ASSn+eTmFjqWfKCuAmsQcAdVBoJhh965GluheuAWEcGUNIPQ==
X-Received: by 2002:a05:600c:64c8:b0:43d:1b74:e89a with SMTP id 5b1f17b1804b1-442f20db129mr1989075e9.9.1747157147072;
        Tue, 13 May 2025 10:25:47 -0700 (PDT)
Received: from 127.0.0.1localhost ([148.252.146.237])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-442d67e0ff1sm173034745e9.14.2025.05.13.10.25.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 13 May 2025 10:25:46 -0700 (PDT)
From: Pavel Begunkov <asml.silence@gmail.com>
To: io-uring@vger.kernel.org
Cc: asml.silence@gmail.com
Subject: [PATCH 1/6] io_uring/kbuf: account ring io_buffer_list memory
Date: Tue, 13 May 2025 18:26:46 +0100
Message-ID: <3985218b50d341273cafff7234e1a7e6d0db9808.1747150490.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <cover.1747150490.git.asml.silence@gmail.com>
References: <cover.1747150490.git.asml.silence@gmail.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Follow the non-ringed pbuf struct io_buffer_list allocations and account
it against the memcg. There is low chance of that being an actual
problem as ring provided buffer should either ping user memory or
allocate it, which is already accounted.

Cc: stable@vger.kernel.org # 6.1
Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 io_uring/kbuf.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/io_uring/kbuf.c b/io_uring/kbuf.c
index 1cf0d2c01287..446207db1edf 100644
--- a/io_uring/kbuf.c
+++ b/io_uring/kbuf.c
@@ -621,7 +621,7 @@ int io_register_pbuf_ring(struct io_ring_ctx *ctx, void __user *arg)
 		io_destroy_bl(ctx, bl);
 	}
 
-	free_bl = bl = kzalloc(sizeof(*bl), GFP_KERNEL);
+	free_bl = bl = kzalloc(sizeof(*bl), GFP_KERNEL_ACCOUNT);
 	if (!bl)
 		return -ENOMEM;
 
-- 
2.49.0


