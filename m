Return-Path: <io-uring+bounces-2921-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 9DD8895D06C
	for <lists+io-uring@lfdr.de>; Fri, 23 Aug 2024 16:52:02 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 5BF322864C6
	for <lists+io-uring@lfdr.de>; Fri, 23 Aug 2024 14:52:01 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 701A11885A1;
	Fri, 23 Aug 2024 14:51:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="gecBxMb4"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-io1-f43.google.com (mail-io1-f43.google.com [209.85.166.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7EA55188902
	for <io-uring@vger.kernel.org>; Fri, 23 Aug 2024 14:51:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724424704; cv=none; b=AsLuZ3NLcvmufPNy5aqU6ZDIlPBZygmjE2HXBIeTNmBWekIX6kPSuZ47aqpRYxz8x+icKKejkhsANWi8UWf2JC/EdRPU5DlKEFA0ZDC+tUUVbGxGGhWLOq3Oq/kso1cYYxmuJgZIr4NpzOayOXpwqXIQvbRIT8lVea8LXgssuyo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724424704; c=relaxed/simple;
	bh=4eZS4mdX540H0maC/bvPRFHywgITJ7MiqVHUpXsLliM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=liQ+iA9m3TijlCA+yjDYTvF7ZAxP8KvCQn3s+YANI7w9w5J2jxhwGUDC8V2Jf2jgwjV4G18Z0UpLI3yhv8wVRmvGOkuODcgJrr5ZlDPUm2ncmfwLFrbFINGWXAomtUbL2twXAEJATKySNePlsCg9BWVGzo7T27f0yf1ewKp8iyg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=gecBxMb4; arc=none smtp.client-ip=209.85.166.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-io1-f43.google.com with SMTP id ca18e2360f4ac-82784c8bca5so44177339f.0
        for <io-uring@vger.kernel.org>; Fri, 23 Aug 2024 07:51:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1724424701; x=1725029501; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=13ZYkOezJuvE61Ji1KvE094MwNJk0Fd40sBkhiKcDII=;
        b=gecBxMb470vHRZWPins6bEfUTSLvmG7s3HFbL1Le/6/B7cqTX/cTX2ZQWJtUM6viYe
         BgDFuV7hY6SasI/eNjTjHndVp3w5EuA2G9bHZDEGgdytKPa6s/WH7kYYTwoO3dEGkgqU
         Y3t6hN/uz+C9g7lHlvncFFOHd3JcwpeAZpKGpWWDjXX6MD6xV67U7hx5bZGTY9rDC4TN
         XVQk4JC5rYDyJ++M/EcZfNWgVxTk7lGOphiKmOtkSJWczny7xznYhHqggcDAsck8u/AO
         3/yTXl2OCqTeZZqdhlOTyG02Vt4kJa3daEBiUM8bpsHgzsw7UedmtkT6v+62JEYvFQ0u
         KCUA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1724424701; x=1725029501;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=13ZYkOezJuvE61Ji1KvE094MwNJk0Fd40sBkhiKcDII=;
        b=s/mUmDUaZrb4SnLQJjw+7w4rjtYh77tiUi0xM8ziq6JTbAYwaEOLbuqrRBKPtDCi7s
         QnrfchOww6HGoj9RkeY8/Kc+WSgcDMbeMq/2dZ9GmkrptAuj97ArInNi1FoaDOL1LASR
         FM7Eer1WT/WtaMOTBeEzQ61pWPGk7+zEDuamK/ck6TedKgK7BO6tfXbXH9IHPLHW0x96
         auf9hodw5DV2LhdtbwmsNKUp0OPEVeAiJOoLUqfMLNJQrr/pS50g1IH1YolQzUBFrVE3
         048gTtJgogzPwihlEYZoIhTkhZgi4rZGzQCI7LnMl5nWW0l6uH0W9rAtFPX5n36qtvK4
         8AkQ==
X-Gm-Message-State: AOJu0Yy8eAN94W2WaxfmsQEoea5EedIzhK5FUpOi0UFbjQ4rFNcnvbsH
	srxmI2flRlONpCd77r9eAUmYylLbueF9rRFVY4hvDhs+oCnjhPte7TeCWmd+Xy/JWJNche70hVF
	o
X-Google-Smtp-Source: AGHT+IEIVDhUmZ4TGBw71mYWii+m9qS3Ygv8jMirwfroXKUi7u/Xu/7vIIen1Y82qZhVOd5fnDr6Ww==
X-Received: by 2002:a05:6602:3c6:b0:822:6af4:cf22 with SMTP id ca18e2360f4ac-8278731ce27mr400508039f.5.1724424700743;
        Fri, 23 Aug 2024 07:51:40 -0700 (PDT)
Received: from localhost.localdomain ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id ca18e2360f4ac-8253d5aa137sm115039939f.11.2024.08.23.07.51.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 23 Aug 2024 07:51:39 -0700 (PDT)
From: Jens Axboe <axboe@kernel.dk>
To: io-uring@vger.kernel.org
Cc: Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 3/4] Revert "io_uring: Require zeroed sqe->len on provided-buffers send"
Date: Fri, 23 Aug 2024 08:42:36 -0600
Message-ID: <20240823145104.20600-5-axboe@kernel.dk>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240823145104.20600-2-axboe@kernel.dk>
References: <20240823145104.20600-2-axboe@kernel.dk>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

This reverts commit 79996b45f7b28c0e3e08a95bab80119e95317e28.

Revert the change that restricts a send provided buffer to be zero, so
it will always consume the whole buffer. This is strictly needed for
partial consumption, as the send may very well be a subset of the
current buffer. In fact, that's the intended use case.

For non-incremental provided buffer rings, an application should set
sqe->len carefully to avoid the potential issue described in the
reverted commit. It is recommended that '0' still be set for len for
that case, if the application is set on maintaining more than 1 send
inflight for the same socket. This is somewhat of a nonsensical thing
to do.

Signed-off-by: Jens Axboe <axboe@kernel.dk>
---
 io_uring/net.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/io_uring/net.c b/io_uring/net.c
index dc83a35b8af4..cc81bcacdc1b 100644
--- a/io_uring/net.c
+++ b/io_uring/net.c
@@ -434,8 +434,6 @@ int io_sendmsg_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)
 		sr->buf_group = req->buf_index;
 		req->buf_list = NULL;
 	}
-	if (req->flags & REQ_F_BUFFER_SELECT && sr->len)
-		return -EINVAL;
 
 #ifdef CONFIG_COMPAT
 	if (req->ctx->compat)
@@ -599,7 +597,7 @@ int io_send(struct io_kiocb *req, unsigned int issue_flags)
 	if (io_do_buffer_select(req)) {
 		struct buf_sel_arg arg = {
 			.iovs = &kmsg->fast_iov,
-			.max_len = INT_MAX,
+			.max_len = min_not_zero(sr->len, INT_MAX),
 			.nr_iovs = 1,
 		};
 
-- 
2.43.0


