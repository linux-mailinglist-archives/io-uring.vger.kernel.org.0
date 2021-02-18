Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E190931EEFF
	for <lists+io-uring@lfdr.de>; Thu, 18 Feb 2021 19:54:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232725AbhBRSwi (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 18 Feb 2021 13:52:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42630 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232760AbhBRShU (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 18 Feb 2021 13:37:20 -0500
Received: from mail-wr1-x430.google.com (mail-wr1-x430.google.com [IPv6:2a00:1450:4864:20::430])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9DFB3C061A2D
        for <io-uring@vger.kernel.org>; Thu, 18 Feb 2021 10:33:55 -0800 (PST)
Received: by mail-wr1-x430.google.com with SMTP id f7so2909749wrt.12
        for <io-uring@vger.kernel.org>; Thu, 18 Feb 2021 10:33:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id:in-reply-to:references:mime-version
         :content-transfer-encoding;
        bh=ZCRT/wZz3Sp34Yl/ZBsVAL5wKTv9t/4V7hRczTZDdyk=;
        b=uryTKCG+WnWgvLavlKbjPxgObZx2ZMp7yZY/j/7hnd66yDD4FhkG+JrRjIrX87hPtg
         qU/IFUBy37hZetC64aFtYSa2SVXwT4ZfXxJve+Zk3RNimoAnBy8LInUsUevVUqgCsCl7
         YdHQvuNjVUTpnKsUz90yNT3Hu/FX9DupI8U9gf+pDM7USeTiMTIehd77U2NXSOFcqyk0
         c18aeFBEZ9d9RWTjxEBUcj1yo7A21/XdK1x2se3b1iXf+tDvqFWRHtvZCXp1Q4e4LQNd
         y+BFoyDmEpsbC5Pjnr02Wkivvhqlwf9C/bA4JAB2oZJDhUPU8G9iwYOUchERXb1lnHfv
         QWhg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=ZCRT/wZz3Sp34Yl/ZBsVAL5wKTv9t/4V7hRczTZDdyk=;
        b=q4Trt9BmumIezGp3DPUqZyZ7z6bEEMpDj4MBR3fOa0VLn5DMLyMwI6Kkm3VvMJHgac
         obLf9HCix8HjpxeeeVpacgNFghVQhCZJNvs/ZCMLVYwxUocqqFFUIxtROgpNllqkAr2J
         gxiv+R+m4jzUF40hkGD4XEo/KMQ2Pg2KWCX5cqjgVNM29NTTZNF+8/6ZPGfWENWmrp1p
         bkIzYq3WQ5zDA7qMZVqFLexbqpkL3yLwjNB+kEpv0nzcFzGAPpWEy0ROpiyMDbNTELHb
         Leezf9Dklf+wlRtV5Vg8sjP5y53PPM0/mjkYb68/9XH0whNFZvh7ycWw/opHGYbfDIDC
         K6Ww==
X-Gm-Message-State: AOAM532vIry956I/CzIorxZae0lKbiNuF4/3OzrsiPCewf6qBOkQCsyP
        JKDxYcMK7dOcuioqjkeFpha4XAF5+TMrig==
X-Google-Smtp-Source: ABdhPJyWQbyqqspR8P0mMs84jY9BNC2kBecIbdH/u5fiAgpOC+Ge/VEQhTlpcBpRld2O7cT25Y+JmA==
X-Received: by 2002:adf:fc48:: with SMTP id e8mr5680937wrs.154.1613673234396;
        Thu, 18 Feb 2021 10:33:54 -0800 (PST)
Received: from localhost.localdomain ([85.255.236.139])
        by smtp.gmail.com with ESMTPSA id 36sm4034459wrh.94.2021.02.18.10.33.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 18 Feb 2021 10:33:54 -0800 (PST)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
Subject: [PATCH 10/11] io_uring: don't do async setup for links' heads
Date:   Thu, 18 Feb 2021 18:29:46 +0000
Message-Id: <9fa097b6e833494ad79256921dc1f46ab23916c5.1613671791.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <cover.1613671791.git.asml.silence@gmail.com>
References: <cover.1613671791.git.asml.silence@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Now, as we can do async setup without holding an SQE, we can skip doing
io_req_defer_prep() for link heads, it will be tried to be executed
inline and follows all the rules of the non-linked requests.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 fs/io_uring.c | 3 ---
 1 file changed, 3 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 7d54b0abbb82..45f78fd25ce2 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -6820,9 +6820,6 @@ static int io_submit_sqe(struct io_ring_ctx *ctx, struct io_kiocb *req,
 			ctx->drain_next = 0;
 		}
 		if (req->flags & (REQ_F_LINK | REQ_F_HARDLINK)) {
-			ret = io_req_defer_prep(req);
-			if (unlikely(ret))
-				req->flags |= REQ_F_FAIL_LINK;
 			link->head = req;
 			link->last = req;
 		} else {
-- 
2.24.0

