Return-Path: <io-uring+bounces-7926-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 666B1AB11EE
	for <lists+io-uring@lfdr.de>; Fri,  9 May 2025 13:13:17 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 0D88C525107
	for <lists+io-uring@lfdr.de>; Fri,  9 May 2025 11:12:18 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A903E28F947;
	Fri,  9 May 2025 11:11:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="MaFcos2N"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ej1-f49.google.com (mail-ej1-f49.google.com [209.85.218.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E86AC227EA1
	for <io-uring@vger.kernel.org>; Fri,  9 May 2025 11:11:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746789111; cv=none; b=A5qXeefBNlWtmZukpfAC15NyL2vBBLXDy4UArgT/xYnzsiI/tWuuSEQNjLANsjZjucfp6b4GIowtAc7K5QeIZiyC/X7r8bG0kPrJ/Ya56J/KqUmIbCIK8idRjlIqvyAC/G7IWQa1GngO43mEYD8GfBiuYmQ59qyOpph1JXwTun8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746789111; c=relaxed/simple;
	bh=NBSbmE2dDcz0hXNHUHP+khP0cdHWfP/eeK88lQmfG5I=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Ja+7HEHzMRgeEa6pyDYet7R++UNV0LxZE8eA6CHZoaZ6IFcn+LGh7dB2hAtPzZI//zOubHbXX+wVeXAmKvZ5oLOzBu6O/HFnE0vhlgfmUrfFdpTaZpVCIvPZ+gVEbohIupxMlxnM+5sYODNxBH/4l01Duvu5HrLMuYtY/0u9l1Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=MaFcos2N; arc=none smtp.client-ip=209.85.218.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-ej1-f49.google.com with SMTP id a640c23a62f3a-ace333d5f7bso339908266b.3
        for <io-uring@vger.kernel.org>; Fri, 09 May 2025 04:11:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1746789108; x=1747393908; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=gNKt92yEApRnTtpC45Hgf/IpxDq+dnPIx475IQL6ALQ=;
        b=MaFcos2Nrc9XgdcKb4FnhJOXFmee5qgJNSGLx+0eFoEnnsoicRdeFjORsItdMxHTjN
         yHO5r5kTFQY3O3hZ7ZSIaRc4Avy8VPpyPfLN7wW+IJhogyAJnErcVMUjHiP5H8RytFD1
         rexp2MxKMlk/zIZXsHrf5cjOAoLyWvoWQgM1yY+N4z8uEOxvLRtX43kyksQikuRbPqt8
         lENYS5/YI9ioATVRe0TqRiVnIfGsAq6ESkGUUvP4V77GqDV9EuJLlgtCDc/rL7UMOBTv
         YnX3yxuobgnCgFCb/9ICpfO4ucD/duS9aO4pbDh+Y/rqhagz+fzsL7L9SGqaiIyrY9xa
         r2Wg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1746789108; x=1747393908;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=gNKt92yEApRnTtpC45Hgf/IpxDq+dnPIx475IQL6ALQ=;
        b=eQToetyBatgsrmuumhjFYLHolUXydS2JIQ6KNQU+vNh8JhUtPQp+Tws4e5MayXIVqI
         GtJqGMpHs3cRIhMbdb5njQtvoZO71m5qv3oE6vQH7bFMdGiYgYqd2lmtoAQcFRu43CGK
         SZ91vypD/gg3OQhwkHTUJkjgu2RU2oVFcT3n0FC08tpTqFbZ8jnH7VPLqcAtSM2KeFhK
         yrOBf308SUnUFMxqZHpXBlhebrdrWeUCHNZZE0YFV6u/uuCvhZk1HtU648WKCTHTVHyC
         kJ2QDElPacsCfszdA3C9UlWkntO3x3nHKEZYlyP398FVHtS5+c6jqBcIZKzMPs6MTmO9
         uanQ==
X-Gm-Message-State: AOJu0YxtSoVFZLfDBSEDNcMDCxeyrydQZUzX7UyEGDEiLElFZ4twLTiB
	jy86jmFs8icfI99zJGFgoDj7nhRfG2ithdEoWbLU/a+9KkMfr7rplYFNRA==
X-Gm-Gg: ASbGnct7v4YWKHlLnujo9YXw3W9yvyqKRzpCY+ij35QqbCU1hqMzJWOx8Vp6OnYEzRV
	ZMlH+gfbmUGlQNFX9yfYxjBsD12S7d4yHj13knpRYPvO7Nhhux90KdBMw5Gxn2hp7b+poZdZcXj
	xgC3P0mjrRC4NGNVpFSTHdm7vuSs1hZpSyTDLCJBYxj6v4ToPp12JWW1z1QoFGfimo4Oma+A2i6
	UmSjYkXIPTa4Fbl9Zu0/58DR0Oze4RFDZX2JXEmBZHxKLg5rL0zNreUF7x+z1k0osduxLgNKHmU
	Pajw7PuaSOfCqnI32k0H0iXe
X-Google-Smtp-Source: AGHT+IEujK6DHLNHzG7HQZfPPzWmQRj5Ig7CkqinBMC0lkwgBtxmZ8NLb7cXCYD5qMdHrkE7PTfJjA==
X-Received: by 2002:a17:907:970d:b0:ad2:1253:3003 with SMTP id a640c23a62f3a-ad2192d0bd3mr258105666b.59.1746789107595;
        Fri, 09 May 2025 04:11:47 -0700 (PDT)
Received: from 127.com ([2620:10d:c092:600::1:4a65])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-ad219746dfasm132717066b.119.2025.05.09.04.11.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 09 May 2025 04:11:46 -0700 (PDT)
From: Pavel Begunkov <asml.silence@gmail.com>
To: io-uring@vger.kernel.org
Cc: asml.silence@gmail.com
Subject: [PATCH v2 3/8] io_uring: simplify drain ret passing
Date: Fri,  9 May 2025 12:12:49 +0100
Message-ID: <ece724b77e66e6caabcc215e0032ee7ff140f289.1746788718.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <cover.1746788718.git.asml.silence@gmail.com>
References: <cover.1746788718.git.asml.silence@gmail.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

"ret" in io_drain_req() is only used in one place, remove it and pass
-ENOMEM directly.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 io_uring/io_uring.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
index add46ab19017..c32fae28ea52 100644
--- a/io_uring/io_uring.c
+++ b/io_uring/io_uring.c
@@ -1669,7 +1669,6 @@ static __cold void io_drain_req(struct io_kiocb *req)
 {
 	struct io_ring_ctx *ctx = req->ctx;
 	struct io_defer_entry *de;
-	int ret;
 	u32 seq = io_get_sequence(req);
 
 	/* Still need defer if there is pending req in defer list. */
@@ -1686,8 +1685,7 @@ static __cold void io_drain_req(struct io_kiocb *req)
 	io_prep_async_link(req);
 	de = kmalloc(sizeof(*de), GFP_KERNEL_ACCOUNT);
 	if (!de) {
-		ret = -ENOMEM;
-		io_req_defer_failed(req, ret);
+		io_req_defer_failed(req, -ENOMEM);
 		return;
 	}
 
-- 
2.49.0


