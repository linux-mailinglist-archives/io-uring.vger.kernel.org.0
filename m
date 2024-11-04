Return-Path: <io-uring+bounces-4393-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 9A2169BAB9C
	for <lists+io-uring@lfdr.de>; Mon,  4 Nov 2024 04:51:54 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id EAE72B2098B
	for <lists+io-uring@lfdr.de>; Mon,  4 Nov 2024 03:51:51 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B296B1632FD;
	Mon,  4 Nov 2024 03:51:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="m01F4iGo"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pg1-f176.google.com (mail-pg1-f176.google.com [209.85.215.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 43C191FC3;
	Mon,  4 Nov 2024 03:51:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.176
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730692306; cv=none; b=DbLYGlsmh5p2ZC8aKVKzKQuaXE9Z5j86ju8NszT+pAvMpiqahilFWjmL3pmrI26mxDMYcoTEaSf7Axsfwi2Zs+QlJKR4ABb61fP/GAnjGWVT1bDICEW2OP81b2IIUNK5l/X5hgT1dxEh+G/YBrCihKvnZrNSmQ2SfEEb/dKB9t0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730692306; c=relaxed/simple;
	bh=2YBDf4aEcUdG4ikl8c4N2RvASg1cVtOLQxa9wUre+0o=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=miGbyoi8eaw2FO2+sh8qUWC1Cn7niAzWS83GbfY3MDn8m7HuubA1mz0+L/6w8UXrsy4WC6pQcaVCvyovvUt21CdSTrHjG5bHOvvp+xKqquKjqLOI3wdgDgeTM4L8M4/QJmKiMESQmAQua8s9PHfQVrJg/JFybUfw3C92oi4WB1M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=m01F4iGo; arc=none smtp.client-ip=209.85.215.176
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pg1-f176.google.com with SMTP id 41be03b00d2f7-7ee4c57b037so2253951a12.0;
        Sun, 03 Nov 2024 19:51:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1730692304; x=1731297104; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=dLWepLDfhSxujVfPCMpMu7koV/FkQnXnALy5OmAOzEo=;
        b=m01F4iGoG2UwXjJWeB/JVRT2IIT1h+qg1nLg6/XU27KnEJx5ya8CJp5D6qb2IqOOYe
         AYlG+M0ZCBliV47HWpvuT/QKT7NlPQnqnP1X2qGlpbGgeYHBmI/6ZKXPB4uhScYgKbYz
         PtCpnU1ZsARBLzctLp5u+yQ3Rhmbb67AnZM5473Ai/HB0YbPXajKYPCipSbT65UtAsMR
         EhFdY54/zq2vNq6sLV7cSxlDnGBOfPZsvlHOKqmj0OKJsVFvkC/vr8IE+ubliAEZ/bHu
         71LWcWY9J/2AhMk10baAu601nknJ3SQmjnK5UMqWv2cIMzzTnuwgVNIy/No9S6KS+xSi
         bfVw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1730692304; x=1731297104;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=dLWepLDfhSxujVfPCMpMu7koV/FkQnXnALy5OmAOzEo=;
        b=MAG9boKay8hPvuXQql6meqIEwFyOT+hzgr2hQ5VcRnjSXSxyRNv9YoJLvLVQCVbsFP
         PYbF9jKU3rPrCAzvAnjghsuRDSyDatDNc487z2nR7od1SicDkbAgXD1ypyK5vKQ6QQlR
         lnkx6etWwREyNxyZOkKH+29CXvMn6NObLJAaJPy5k9ruBP5Uzep6EWYrDGZG4AeevbMT
         hiRnbVILxCR/jCItHg6qa+t4Cn/JEh2YFjYcPYHmaCN1d4jI9D4tLcjDZRqOn0vw9DMx
         Np0dKRZWKH8jKWdbLJyVLbCj0cQWXIZjedPA+xfzygQ6N8C+DwSwENcHlJQV29DPnP/e
         l+QA==
X-Forwarded-Encrypted: i=1; AJvYcCV2Hn8ngTB1VlESFpAZhUeYu8g9mIFmCAJJZlpe3SBLT+pTB+w4+h66ivFVVxSfyY+wv+oCxGHH1Aqd3TTJ@vger.kernel.org, AJvYcCWNP2AluMYGwSZOdZldywvB0C2DARehZ6UJRQZcnKftM+S45e5PEM5ehF9+NaZzqOLewoIxU1EVqA==@vger.kernel.org
X-Gm-Message-State: AOJu0YwxTD6y0hK1/zg4zcirFeOAzm4Vo7bgYQtd0GgT6kZiHEH2JID7
	x8GW71ClkqjO8qEYeJWBuH7uz8/NsBIGkv/0pjPE4KOt+z+/hibn9L69pphH1Dc=
X-Google-Smtp-Source: AGHT+IEBnd00DQKAS+SaXwLwS8P7IYwoC74518MzZvkVPMAs89AByd0Ty8TZAHXG+KwxyW72y8ZHWQ==
X-Received: by 2002:a05:6a20:7284:b0:1db:b808:af25 with SMTP id adf61e73a8af0-1dbb809085amr11841146637.9.1730692304355;
        Sun, 03 Nov 2024 19:51:44 -0800 (PST)
Received: from debian.resnet.ucla.edu (s-169-232-97-87.resnet.ucla.edu. [169.232.97.87])
        by smtp.googlemail.com with ESMTPSA id 41be03b00d2f7-7ee452ae3a0sm6054991a12.37.2024.11.03.19.51.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 03 Nov 2024 19:51:43 -0800 (PST)
From: Daniel Yang <danielyangkang@gmail.com>
To: Jens Axboe <axboe@kernel.dk>,
	Pavel Begunkov <asml.silence@gmail.com>,
	io-uring@vger.kernel.org (open list:IO_URING),
	linux-kernel@vger.kernel.org (open list)
Cc: Daniel Yang <danielyangkang@gmail.com>,
	syzbot+05c0f12a4d43d656817e@syzkaller.appspotmail.com
Subject: [PATCH] io_uring/rsrc: fix null ptr dereference in io_sqe_buffer_register
Date: Sun,  3 Nov 2024 19:51:05 -0800
Message-Id: <20241104035105.192960-1-danielyangkang@gmail.com>
X-Mailer: git-send-email 2.39.2
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The call stack io_sqe_buffer_register -> io_buffer_account_pin ->
headpage_already_acct results in a null ptr dereference in the for loop.
There is no guarantee that ctx->buf_table.nodes[i] is an allocated node
so add a check if null before dereferencing.

Signed-off-by: Daniel Yang <danielyangkang@gmail.com>
Reported-by: syzbot+05c0f12a4d43d656817e@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=05c0f12a4d43d656817e
Fixes: 661768085e99 ("io_uring/rsrc: get rid of the empty node and dummy_ubuf")
---
 io_uring/rsrc.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/io_uring/rsrc.c b/io_uring/rsrc.c
index af60d9f59..e2edb752a 100644
--- a/io_uring/rsrc.c
+++ b/io_uring/rsrc.c
@@ -581,6 +581,8 @@ static bool headpage_already_acct(struct io_ring_ctx *ctx, struct page **pages,
 	/* check previously registered pages */
 	for (i = 0; i < ctx->buf_table.nr; i++) {
 		struct io_rsrc_node *node = ctx->buf_table.nodes[i];
+		if (!node)
+			continue;
 		struct io_mapped_ubuf *imu = node->buf;
 
 		for (j = 0; j < imu->nr_bvecs; j++) {
-- 
2.39.2


