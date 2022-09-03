Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AFB9B5ABFE1
	for <lists+io-uring@lfdr.de>; Sat,  3 Sep 2022 18:52:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230488AbiICQwl (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sat, 3 Sep 2022 12:52:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48522 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230333AbiICQwk (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sat, 3 Sep 2022 12:52:40 -0400
Received: from mail-pj1-x1033.google.com (mail-pj1-x1033.google.com [IPv6:2607:f8b0:4864:20::1033])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C481525C47
        for <io-uring@vger.kernel.org>; Sat,  3 Sep 2022 09:52:39 -0700 (PDT)
Received: by mail-pj1-x1033.google.com with SMTP id o2-20020a17090a9f8200b0020025a22208so1151358pjp.2
        for <io-uring@vger.kernel.org>; Sat, 03 Sep 2022 09:52:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date;
        bh=NDfU2jexhTtidmvUsAHPOMw5Ob+mQ0ASulhdL6098FQ=;
        b=WNFyzMKkV4hx8AGpo2rFi0g2YdWpfE2kBN9yHuanu3w3xQYASmLlrMTHKC6kQJ1qQ3
         /QeSymQll227q0JcnolcqEf7vxvrNzngpQGzsz+VPgDPV5KLnbpfkVpecFLXuKL+xugR
         wzkKsqtWIIq9P5/NzR3eTNNP5ZxUUiW894Z2SV/UDpDG4/XtTW7D6CPimPX5NGAZvKE3
         hVUZ8fYphlwJGIFJtIeyM4Woi+Bms49KPhdBOTfot74AQaGWRxxeMAe7+hpQwwf9HGFh
         utkUuH3TKfjlbEgB4XQNlAcXBUwBpymmySrgbSXOCo/i0Q6LcWTXbWuI2e5mC1hGw9qP
         qo5Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date;
        bh=NDfU2jexhTtidmvUsAHPOMw5Ob+mQ0ASulhdL6098FQ=;
        b=edJBBjzl4u6BoAU9vZcgGyOkXvhxTt0MSAPa3MVw9wjtOapoRfWR9FqImgsviPR3KI
         0NUdcM+tJ0GiJuvr+C4SwR1982uZOXbjQ/x1wTY0hBg28X/vu0iKEhdGgsGVthTPwcja
         03lTJppdBDXoVgBscmZ8UKvOrwWFcxktXOzZxQF7JLPLaOZ23vsfT+olkRnRwAMLro9H
         p+RmzUyI/JUBnU+GupStFbWhj2l5lRgTFw3lBLF6+e2qfvJs46VrWCOA7CuU5P+4vutk
         LcSibE8Gw9zzkXKXDTxTLOXt1tHBFlKyGyCc5i1PE6RCNO/JbY5nHmF/gAOxbCVbYDMu
         hn+g==
X-Gm-Message-State: ACgBeo3cZEf41Zy8/WgdWSAfGb80c1/haP7aG5Z8w2zkYLIbeGqyEeM7
        rKQDUF8eDLl4aCerQiPRmxtvT6o0BL8AZw==
X-Google-Smtp-Source: AA6agR7DYBmTZ1nKloJjqSB/DuNbz1khC5IT1JjHo0Kw+drNN63bY2OO8j2P8b7PYV09RXQe+DyymA==
X-Received: by 2002:a17:902:aa87:b0:172:689f:106b with SMTP id d7-20020a170902aa8700b00172689f106bmr41056895plr.127.1662223958892;
        Sat, 03 Sep 2022 09:52:38 -0700 (PDT)
Received: from localhost.localdomain ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id w185-20020a6262c2000000b005289a50e4c2sm4187296pfb.23.2022.09.03.09.52.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 03 Sep 2022 09:52:38 -0700 (PDT)
From:   Jens Axboe <axboe@kernel.dk>
To:     io-uring@vger.kernel.org
Cc:     joshi.k@samsung.com, Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 1/4] io_uring: cleanly separate request types for iopoll
Date:   Sat,  3 Sep 2022 10:52:31 -0600
Message-Id: <20220903165234.210547-2-axboe@kernel.dk>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220903165234.210547-1-axboe@kernel.dk>
References: <20220903165234.210547-1-axboe@kernel.dk>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

After the addition of iopoll support for passthrough, there's a bit of
a mixup here. Clean it up and get rid of the casting for the passthrough
command type.

Signed-off-by: Jens Axboe <axboe@kernel.dk>
---
 io_uring/rw.c | 15 +++++++++------
 1 file changed, 9 insertions(+), 6 deletions(-)

diff --git a/io_uring/rw.c b/io_uring/rw.c
index 9698a789b3d5..966c923bc0be 100644
--- a/io_uring/rw.c
+++ b/io_uring/rw.c
@@ -994,7 +994,7 @@ int io_do_iopoll(struct io_ring_ctx *ctx, bool force_nonspin)
 
 	wq_list_for_each(pos, start, &ctx->iopoll_list) {
 		struct io_kiocb *req = container_of(pos, struct io_kiocb, comp_list);
-		struct io_rw *rw = io_kiocb_to_cmd(req, struct io_rw);
+		struct file *file = req->file;
 		int ret;
 
 		/*
@@ -1006,12 +1006,15 @@ int io_do_iopoll(struct io_ring_ctx *ctx, bool force_nonspin)
 			break;
 
 		if (req->opcode == IORING_OP_URING_CMD) {
-			struct io_uring_cmd *ioucmd = (struct io_uring_cmd *)rw;
+			struct io_uring_cmd *ioucmd;
 
-			ret = req->file->f_op->uring_cmd_iopoll(ioucmd);
-		} else
-			ret = rw->kiocb.ki_filp->f_op->iopoll(&rw->kiocb, &iob,
-							poll_flags);
+			ioucmd = io_kiocb_to_cmd(req, struct io_uring_cmd);
+			ret = file->f_op->uring_cmd_iopoll(ioucmd);
+		} else {
+			struct io_rw *rw = io_kiocb_to_cmd(req, struct io_rw);
+
+			ret = file->f_op->iopoll(&rw->kiocb, &iob, poll_flags);
+		}
 		if (unlikely(ret < 0))
 			return ret;
 		else if (ret)
-- 
2.35.1

