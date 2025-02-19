Return-Path: <io-uring+bounces-6540-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 72BCBA3AEF8
	for <lists+io-uring@lfdr.de>; Wed, 19 Feb 2025 02:32:51 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 04F99167409
	for <lists+io-uring@lfdr.de>; Wed, 19 Feb 2025 01:32:49 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B1E8D28FD;
	Wed, 19 Feb 2025 01:32:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="YJfwNOcA"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-wm1-f52.google.com (mail-wm1-f52.google.com [209.85.128.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E5D8124B34
	for <io-uring@vger.kernel.org>; Wed, 19 Feb 2025 01:32:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739928769; cv=none; b=krya88PITI6n2/XSlLyIOFMpaqHIqu8DZqVofxV3yBXDQ+NmkGHOjdVgRHonsv/BimmBsvqhejsSd7YIhxomLsUWIVgZzuqGbYTjSDllMn4FF9xQPfTZa0XgP7EyoxQWY5um4Tha6ose5sFqe9MgUVTrM+NrIxAC7ImkmBeO24Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739928769; c=relaxed/simple;
	bh=HqlbBEnND6hCYgCez40VMQRjIZ4nML5T3KzoE/UdG7w=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=D0Pq5SNpNXFxC0ziJCvjgGdA7Z9N8pD6M72FWPz1FAon9MLpN65Bj1MlQDUYplzk0e9IKBb4NEON1wqg6SAgSLxuC0iBTE+4JD7NP1rYJYJksKBhwG/KQorjmlhelIwooNISzewboMD2AVuEUNrTLdq9IemNnXvmVnb3wfawSkA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=YJfwNOcA; arc=none smtp.client-ip=209.85.128.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-wm1-f52.google.com with SMTP id 5b1f17b1804b1-439946a49e1so9406405e9.0
        for <io-uring@vger.kernel.org>; Tue, 18 Feb 2025 17:32:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1739928766; x=1740533566; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=uvNpFg8xcxJ0e+aGXz89qbRAq3d2u1lb4KH5SKxTQ7s=;
        b=YJfwNOcAgoIO8sIVG3TnhwsEMuTfeZIvXcUxvwTJ1h5CEPOr1CJbcyLIzUGU6LX9Wa
         AYYJGx+B53Nxkar1RZzHAryzO8/nOqbJi16t214D/YgBvqm9JaCxHuVzlkPcG/KrzyUB
         nYAmgl/W8+1C//Ti/xUknsonwiMqBrm2TKpWyZpoQBN/IK2HXMQX9IsiRnVmyIg2iEmd
         4b7IVBs47nUsYi5cV8zNcMWc3euFh4l6M/ARkgWLOE1k/OE+ndpxADZRP3foePW9hZsA
         uIpst3aj1QIrA6/90Fq+oiRkLBstuC38J8tn8XHL52UBMYWsgjzc3tMufFEuSpOavq+I
         hVXw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1739928766; x=1740533566;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=uvNpFg8xcxJ0e+aGXz89qbRAq3d2u1lb4KH5SKxTQ7s=;
        b=qf/ENe0CwO8oU9+6pZfVoK23nw+4UeWv97VYR6KiBw5L04qV0NsQHefWXav86hzZI4
         hBeP9sObA/EZDT792Yn0EvK3/sqH4yXGPyZ+W+nUtq5tY6AFqFqMAqTisg3PEdgdbrTd
         okHtVF1DulhNqtqps1UTVVzeTyRAmL1FMNGCPHRFbrMsML3IHM8KWm3IQJhUSS2F744h
         JqsVJYTHeelZ2pltfQtlq10+xS85SdcPICHgThNyptkKfa9xwazWE7FMv4I8ApGetp8d
         fApcs5+IgvjmIYBeJqHHhCgwF/6q2oYro2r3T3f+8W99y7J7Fp/k1lJF8RPc8H9of7hA
         NDEw==
X-Gm-Message-State: AOJu0YwCmjmnm3cHcpTrbrJzTPro9sw/NRixhRV2JHmJjAucvKWVAlcZ
	ICTK0EyKgJ+Fk9cjvBcfakg2ZPG6QrpXjDtzgUoJ1FspyWe2wDundusFYw==
X-Gm-Gg: ASbGnctZnapRKysYGMZEliNEnJD4VsCtPwxxYL/gHAruiQH+p/HnOSq7wqguPYvwVTj
	0tR93KRdbDfSRjDEbS6qNauaShrHEaBfRGL1QhzAUpplDC80+6nQeSKM8AGt6LhwtnhYjL0WcWs
	WYyWfPTJKFOEhnDHwvwtgsoNhHoVhHkvW+KM9dPIjtXR/1/ZuxLaTt9orU4rSwrf7GP6oop4vaw
	+Ex49Q8Zg8GaxU2jhwfRMgzAZq5n50CBH7kvOsPzF5rssnsk1BdZroujlkaHbCk2boCJVFJT/JU
	bTU9M2N2ITWXG8jZkeYc2Vd/zcL7
X-Google-Smtp-Source: AGHT+IHe5g+6HLRRiJMfW5yMdRfgXAckrXLiDPoz1a6H7jEP2TzSrHoCBcQ6ewHuLThqUIvS29XXtg==
X-Received: by 2002:a05:600c:458a:b0:439:86fb:7340 with SMTP id 5b1f17b1804b1-43999ddb17cmr15833755e9.30.1739928765733;
        Tue, 18 Feb 2025 17:32:45 -0800 (PST)
Received: from 127.0.0.1localhost ([185.69.145.170])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-38f259d8f1csm16617752f8f.69.2025.02.18.17.32.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 18 Feb 2025 17:32:45 -0800 (PST)
From: Pavel Begunkov <asml.silence@gmail.com>
To: io-uring@vger.kernel.org
Cc: asml.silence@gmail.com
Subject: [PATCH v2 2/4] io_uring/rw: don't directly use ki_complete
Date: Wed, 19 Feb 2025 01:33:38 +0000
Message-ID: <4eb4bdab8cbcf5bc87083f7047edc81e920ab83c.1739919038.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <cover.1739919038.git.asml.silence@gmail.com>
References: <cover.1739919038.git.asml.silence@gmail.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

We want to avoid checking ->ki_complete directly in the io_uring
completion path. Fortunately we have only two callback the selection
of which depend on the ring constant flags, i.e. IOPOLL, so use that
to infer the function.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 io_uring/rw.c | 14 +++++++++-----
 1 file changed, 9 insertions(+), 5 deletions(-)

diff --git a/io_uring/rw.c b/io_uring/rw.c
index e8efd97fdee5..27ccc82d7843 100644
--- a/io_uring/rw.c
+++ b/io_uring/rw.c
@@ -563,8 +563,10 @@ static void io_complete_rw_iopoll(struct kiocb *kiocb, long res)
 	smp_store_release(&req->iopoll_completed, 1);
 }
 
-static inline void io_rw_done(struct kiocb *kiocb, ssize_t ret)
+static inline void io_rw_done(struct io_kiocb *req, ssize_t ret)
 {
+	struct io_rw *rw = io_kiocb_to_cmd(req, struct io_rw);
+
 	/* IO was queued async, completion will happen later */
 	if (ret == -EIOCBQUEUED)
 		return;
@@ -586,8 +588,10 @@ static inline void io_rw_done(struct kiocb *kiocb, ssize_t ret)
 		}
 	}
 
-	INDIRECT_CALL_2(kiocb->ki_complete, io_complete_rw_iopoll,
-			io_complete_rw, kiocb, ret);
+	if (req->ctx->flags & IORING_SETUP_IOPOLL)
+		io_complete_rw_iopoll(&rw->kiocb, ret);
+	else
+		io_complete_rw(&rw->kiocb, ret);
 }
 
 static int kiocb_done(struct io_kiocb *req, ssize_t ret,
@@ -598,7 +602,7 @@ static int kiocb_done(struct io_kiocb *req, ssize_t ret,
 
 	if (ret >= 0 && req->flags & REQ_F_CUR_POS)
 		req->file->f_pos = rw->kiocb.ki_pos;
-	if (ret >= 0 && (rw->kiocb.ki_complete == io_complete_rw)) {
+	if (ret >= 0 && !(req->ctx->flags & IORING_SETUP_IOPOLL)) {
 		__io_complete_rw_common(req, ret);
 		/*
 		 * Safe to call io_end from here as we're inline
@@ -609,7 +613,7 @@ static int kiocb_done(struct io_kiocb *req, ssize_t ret,
 		io_req_rw_cleanup(req, issue_flags);
 		return IOU_OK;
 	} else {
-		io_rw_done(&rw->kiocb, ret);
+		io_rw_done(req, ret);
 	}
 
 	return IOU_ISSUE_SKIP_COMPLETE;
-- 
2.48.1


