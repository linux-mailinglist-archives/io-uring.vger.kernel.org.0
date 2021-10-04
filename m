Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C1EB44216F2
	for <lists+io-uring@lfdr.de>; Mon,  4 Oct 2021 21:04:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237495AbhJDTFt (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 4 Oct 2021 15:05:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59108 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238849AbhJDTFs (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 4 Oct 2021 15:05:48 -0400
Received: from mail-ed1-x534.google.com (mail-ed1-x534.google.com [IPv6:2a00:1450:4864:20::534])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3AF96C061745
        for <io-uring@vger.kernel.org>; Mon,  4 Oct 2021 12:03:59 -0700 (PDT)
Received: by mail-ed1-x534.google.com with SMTP id p13so40763736edw.0
        for <io-uring@vger.kernel.org>; Mon, 04 Oct 2021 12:03:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=PfJTGo3iAj2lGQ6a4wT0V2OYjBNLGkvFgD3rzmwV4e0=;
        b=hDSPTi3lg4yPynkNjCBF7KK2bfbJRmdeRMqNP5GeXciixPFwmUcRp2z4XJwyI+r8Dy
         ivHBSedpcr/VnpxpbtFz9Znt3soJ3PgsLHIq+HqqAGbxr9ya7u7P2nCGTtfcG68RxyXj
         OKeKt4drEkk2Ljuy06KEeWGrVlvNGDfGXxtitlxnd3LriqId02XACToKtoAguF1pCwNr
         2hOQAVw4Nog55Kg+esB5SaAtvbuYFbb5zSRvdZX/UvVPFFnaLBIhJKyDRh79mSWKW694
         MNP7TqHOa3jV4l6klM5ZR5oTeBMuUfOeZkj49sTfB/c5QGl7hlD3J1tqSvs9S2/N+vK2
         4tNg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=PfJTGo3iAj2lGQ6a4wT0V2OYjBNLGkvFgD3rzmwV4e0=;
        b=b2RcRx2JhANfcHohszuucwNXZ44CqwSkqyTsxiF2i8DFvvBBtxsEGHK6okX0iuVCW1
         xOZ5Z6vUO+k9KoohHklt8QGrHeFtl221QBRx67Uo3EZyODtsxSU4OzGsu/g3sAe8wV1t
         VVQToGDs3pPFDzKxz7apPkbU5ESbJwFXWsuMfbbZZWd9hWsDJZSfGA5txqKJ2hhcHU3R
         qsvT/UGZHSo1aT1MydXtUhnWf0lsttGxkdqf29rK6O09KK0TCWAq4Qaba3h19cPJgGL3
         h7QTP/UtO370XT7MEfSyKOIODFaEtOwCcg9/IOHnxRLeDBaqYsdNDWoaGe7kAIzSANZv
         jqWg==
X-Gm-Message-State: AOAM5312MLt8GV/nwllDVoFbsr0YlgXrdrYBzhv2deWenMq3oOg2I+dZ
        NUl4/2BBNdUO2rSR4LYyMhiIVl08CgM=
X-Google-Smtp-Source: ABdhPJx5ga7M+8d2fG+ZhgxzscRt2Td3eptKNesJevmmtVXlulwCgujL64hbHTRzxcU5Q+UhG4nbWg==
X-Received: by 2002:a17:906:848b:: with SMTP id m11mr19336701ejx.270.1633374237006;
        Mon, 04 Oct 2021 12:03:57 -0700 (PDT)
Received: from localhost.localdomain ([85.255.237.101])
        by smtp.gmail.com with ESMTPSA id k12sm6855045ejk.63.2021.10.04.12.03.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 04 Oct 2021 12:03:56 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     io-uring@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>, asml.silence@gmail.com
Subject: [PATCH 10/16] io_uring: optimise io_free_batch_list()
Date:   Mon,  4 Oct 2021 20:02:55 +0100
Message-Id: <cc9fdfb6f72a4e8bc9918a5e9f2d97869a263ae4.1633373302.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <cover.1633373302.git.asml.silence@gmail.com>
References: <cover.1633373302.git.asml.silence@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Delay reading the next node in io_free_batch_list(), allows the compiler
to load the value a bit later improving register spilling in some cases.
With gcc 11.1 it helped to move @task_refs variable from the stack to a
register and optimises out a couple of per request instructions.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 fs/io_uring.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 10112ea73e77..50312ac4537d 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -2280,9 +2280,10 @@ static void io_free_batch_list(struct io_ring_ctx *ctx,
 		struct io_kiocb *req = container_of(node, struct io_kiocb,
 						    comp_list);
 
-		node = req->comp_list.next;
-		if (!req_ref_put_and_test(req))
+		if (!req_ref_put_and_test(req)) {
+			node = req->comp_list.next;
 			continue;
+		}
 
 		io_queue_next(req);
 		io_dismantle_req(req);
@@ -2294,6 +2295,7 @@ static void io_free_batch_list(struct io_ring_ctx *ctx,
 			task_refs = 0;
 		}
 		task_refs++;
+		node = req->comp_list.next;
 		wq_stack_add_head(&req->comp_list, &ctx->submit_state.free_list);
 	} while (node);
 
-- 
2.33.0

