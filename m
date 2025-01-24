Return-Path: <io-uring+bounces-6114-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 03371A1B990
	for <lists+io-uring@lfdr.de>; Fri, 24 Jan 2025 16:44:09 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 01C6D1884B1F
	for <lists+io-uring@lfdr.de>; Fri, 24 Jan 2025 15:44:13 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 24731149C4D;
	Fri, 24 Jan 2025 15:44:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=furiosa-ai.20230601.gappssmtp.com header.i=@furiosa-ai.20230601.gappssmtp.com header.b="IcOkeMoO"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pl1-f173.google.com (mail-pl1-f173.google.com [209.85.214.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7D9EA12EBDB
	for <io-uring@vger.kernel.org>; Fri, 24 Jan 2025 15:44:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737733445; cv=none; b=nvs/T2k5LXQ5hv8y3/y2YlPbDcqY9ew0bD9n2SvlBmKUjPGJEkCd2fax7sCQdu0FM3b3xAy0afCozYlyOYP28TMSUOcw2K4oXWIZetI0YVoGhBUDNDFoqf7IiN5XNLD3x8JDO8bz1WUvH/Y55aFCZ+0ETJCQKRLcaY5VtQvigZU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737733445; c=relaxed/simple;
	bh=8DFRc63keW5rpWX30uBo1ANRLa8lmser5FkoPQSJf7I=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=cb3yljDlReVwMivOivy7noYgmw6XpXTVo1evUlqi03rjd+dxclnCA+WsC6Xlc9iIyq8sPFhMfy9VBWv+YJIOzeBCZ/Q+42DRUicaV/8lRcojF+oGhwFophp14vFhxJuSVMt9sZ/vGqDM9yzwK3fY7R71V+2IWuDZmzsg+u6e4hA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=furiosa.ai; spf=none smtp.mailfrom=furiosa.ai; dkim=pass (2048-bit key) header.d=furiosa-ai.20230601.gappssmtp.com header.i=@furiosa-ai.20230601.gappssmtp.com header.b=IcOkeMoO; arc=none smtp.client-ip=209.85.214.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=furiosa.ai
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=furiosa.ai
Received: by mail-pl1-f173.google.com with SMTP id d9443c01a7336-21675fd60feso51468835ad.2
        for <io-uring@vger.kernel.org>; Fri, 24 Jan 2025 07:44:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=furiosa-ai.20230601.gappssmtp.com; s=20230601; t=1737733442; x=1738338242; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=NZFFfAwOfnOiCIgOdtC31a/N9dMzQqS2sHbMYCjo3Ac=;
        b=IcOkeMoOyPSxbVBrSB8orWhQuJLY7BWDzWhkrYQKrNipbdZLiOBpnQvQvtxLDublRl
         PvuLee3PyXorzh8dfqYz9GUQ0H+Wmb7LiMsQdN+fbji5F0tLFyRDWmgVEw9VVDVK1zRN
         MXI3vO90vw/8BkZzIdXmFn7b4NIHMxnAuJFInhTqfvE8NplY4trhUwvrnyBc+fCok2BD
         e7sHgci0p2Fd9A1+WkJvn5oZt1aBVGK+2LoNm0MiwuRhNjII0nX9FYRpY1LCKcyzsDPh
         CTJ77d1j7I33GgKdpb0d4nXa8KRu9dEu9cvUqO7DRdWBvbZEhwTnjrL9lQaBTE0OeMr2
         Bifw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1737733442; x=1738338242;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=NZFFfAwOfnOiCIgOdtC31a/N9dMzQqS2sHbMYCjo3Ac=;
        b=tQaxfP89buyGyScRzn/SOfnWq3Y/tKMBBn/zND1mQuPl/HcpymIFf/ynE2Xfoj8kIL
         nvNg16vBT6bc3vK11FJmW1G87gSIVBbut8LMfHoIvyw485hArkG0/mdJZOuhOoyqgubX
         kwI8ImCbJBMV95RoAfPrm7AhfXO6P5bZYONiXBqldgehEPn+YLAN1B1Pi4iiWu7Pradd
         VS5LMmd1yEFUZgrcsxJVOcuaeaEIM36chOQmLwZUpBxZgPCCbQj/ZdxVAZ9qpGTjU+Ng
         et7KdE7uclIsaiyJK44uZADY7m8pY01TddAE11B3XZa7sCx+Q86S7wLrdt1Re2EcBfsC
         /tJQ==
X-Gm-Message-State: AOJu0Yww8eBDCAQhrBcOuFKMkcp2J2kim8RFVJ87HaIqT04xw/xlJGYi
	BUBivI1Xqmv3Hh747bqgaVl7QA17hzzkxDPvhAZLjLK+RPC8kh9D2f0Z++Z7m+OWyuQLZDb8fnY
	en0A=
X-Gm-Gg: ASbGncss5KZTpdJZYPjjj06NMJ1Am1HQaWUaTFCYldT87qRlhoX/s5/3dLxwfvjY+AU
	zK4sGsXFDOG8NRGiZ0Sj8XfTztIdkflksRJ4xIAeyn8OnxJlaklwUvQ8tclqlhmcWYIHy+J2AX3
	ZtwzsTJIlSJ+Ae1wA3unG5xxC6gQixE+VgQHTpnR2/y48xIWoa5p2sh7Anz5z65HICyK1W+Hwce
	Q7bWptL8iNbyeRscxB7CU530Iyh0dibPmWew87y3LvNuu4sfKH5rbUqLWVDKscLZAycJJFYNRYx
	2UYkIRJLYmLoyHu/5iEe+Bwylv3oGyLpmuJ4uNH+AI8=
X-Google-Smtp-Source: AGHT+IEkSl5eJzRFBTY8aXW5JFBDVzHoDqk9FGHYXp+Xs2IF/fRqdE8JQbom3L5LziogrsKl9avDjw==
X-Received: by 2002:a17:902:e803:b0:215:385e:921c with SMTP id d9443c01a7336-21c3563c5c4mr425919805ad.51.1737733442640;
        Fri, 24 Jan 2025 07:44:02 -0800 (PST)
Received: from sidong.sidong.yang.office.furiosa.vpn ([175.195.128.78])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-21da414df1dsm17604125ad.189.2025.01.24.07.44.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 24 Jan 2025 07:44:02 -0800 (PST)
From: Sidong Yang <sidong.yang@furiosa.ai>
To: io-uring <io-uring@vger.kernel.org>,
	Jens Axboe <axboe@kernel.dk>
Cc: Sidong Yang <sidong.yang@furiosa.ai>
Subject: [PATCH v2] io_uring/futex: Factor out common free logic into io_free_ifd()
Date: Fri, 24 Jan 2025 15:43:36 +0000
Message-ID: <20250124154344.6928-1-sidong.yang@furiosa.ai>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

This patch introduces io_free_ifd() that try to cache or free
io_futex_data. It could be used for completion. It also could be used
for error path in io_futex_wait(). Old code just release the ifd but it
could be cached.

Signed-off-by: Sidong Yang <sidong.yang@furiosa.ai>
---
v2: use io_free_ifd() for completion
---
 io_uring/futex.c | 12 +++++++++---
 1 file changed, 9 insertions(+), 3 deletions(-)

diff --git a/io_uring/futex.c b/io_uring/futex.c
index e29662f039e1..94a7159f9cff 100644
--- a/io_uring/futex.c
+++ b/io_uring/futex.c
@@ -44,6 +44,13 @@ void io_futex_cache_free(struct io_ring_ctx *ctx)
 	io_alloc_cache_free(&ctx->futex_cache, kfree);
 }
 
+static void io_free_ifd(struct io_ring_ctx *ctx, struct io_futex_data *ifd)
+{
+	if (!io_alloc_cache_put(&ctx->futex_cache, ifd)) {
+		kfree(ifd);
+	}
+}
+
 static void __io_futex_complete(struct io_kiocb *req, struct io_tw_state *ts)
 {
 	req->async_data = NULL;
@@ -57,8 +64,7 @@ static void io_futex_complete(struct io_kiocb *req, struct io_tw_state *ts)
 	struct io_ring_ctx *ctx = req->ctx;
 
 	io_tw_lock(ctx, ts);
-	if (!io_alloc_cache_put(&ctx->futex_cache, ifd))
-		kfree(ifd);
+	io_free_ifd(ctx, ifd);
 	__io_futex_complete(req, ts);
 }
 
@@ -353,13 +359,13 @@ int io_futex_wait(struct io_kiocb *req, unsigned int issue_flags)
 		return IOU_ISSUE_SKIP_COMPLETE;
 	}
 
+	io_free_ifd(ctx, ifd);
 done_unlock:
 	io_ring_submit_unlock(ctx, issue_flags);
 done:
 	if (ret < 0)
 		req_set_fail(req);
 	io_req_set_res(req, ret, 0);
-	kfree(ifd);
 	return IOU_OK;
 }
 
-- 
2.43.0


