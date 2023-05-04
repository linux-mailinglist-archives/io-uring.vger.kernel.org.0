Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5E6FE6F6B09
	for <lists+io-uring@lfdr.de>; Thu,  4 May 2023 14:19:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230416AbjEDMTN (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 4 May 2023 08:19:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49412 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230415AbjEDMTK (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 4 May 2023 08:19:10 -0400
Received: from mail-wr1-f54.google.com (mail-wr1-f54.google.com [209.85.221.54])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E9505618B;
        Thu,  4 May 2023 05:19:08 -0700 (PDT)
Received: by mail-wr1-f54.google.com with SMTP id ffacd0b85a97d-3064099f9b6so259169f8f.1;
        Thu, 04 May 2023 05:19:08 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1683202747; x=1685794747;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=it1Jg8DeNZi+uSQaZN6tyTLLss5U0nLB9ujTI6DLQlE=;
        b=I2EcyFal6Slt1X71bBmBCA1jLd9RXN2G5Sl8E8Z1DnTyyUFK/ML4aNCDsnwEU6Gm28
         YHOv1H4uhD0GyLHu0TI4Aw+5b47rGSXnAlh10kZQ78obYMAqZ09INVdqZSPZcSmoavrz
         9YxqXKC/XSBj9ao7zCg0CyBLiDlqzIazbuSVvbVBHDXbs+Kd4uy3QX71OnLsaMRxDcF+
         szmkygZKJqhjOksQShanmCryb1j58OjOms7gVAatUj2eHZ65EMdlbCSClPdjcgWCROG6
         tNT3RLbp2+qtKumgiOmwZqvoM61SjfmhvQ/L7hqOOGy72OBty9usXfT7YO23tYllbK8h
         CgpA==
X-Gm-Message-State: AC+VfDwX7UXE0NBF1cs6thGJ9E2kcXFYuWaUXlFA4DB/S0T53Pv1cN0k
        FSSnr5hisvEndxtcQe6w9QhrbuxlAx3dXw==
X-Google-Smtp-Source: ACHHUZ5pFqkNjG1UPGsV75RqUHWvgJLeZ2Ye5mVCDjBw50wrtT9suVc5ow9F1hW4QpWHoybLEEvBqg==
X-Received: by 2002:adf:fec7:0:b0:307:41a1:dc86 with SMTP id q7-20020adffec7000000b0030741a1dc86mr902784wrs.67.1683202747127;
        Thu, 04 May 2023 05:19:07 -0700 (PDT)
Received: from localhost (fwdproxy-cln-030.fbsv.net. [2a03:2880:31ff:1e::face:b00c])
        by smtp.gmail.com with ESMTPSA id m18-20020adffa12000000b003047297a5e8sm29871228wrr.54.2023.05.04.05.19.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 04 May 2023 05:19:06 -0700 (PDT)
From:   Breno Leitao <leitao@debian.org>
To:     io-uring@vger.kernel.org, linux-nvme@lists.infradead.org,
        asml.silence@gmail.com, hch@lst.de, axboe@kernel.dk,
        ming.lei@redhat.com
Cc:     leit@fb.com, linux-kernel@vger.kernel.org,
        linux-block@vger.kernel.org, sagi@grimberg.me, joshi.k@samsung.com,
        kbusch@kernel.org
Subject: [PATCH v4 3/3] io_uring: Remove unnecessary BUILD_BUG_ON
Date:   Thu,  4 May 2023 05:18:56 -0700
Message-Id: <20230504121856.904491-4-leitao@debian.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230504121856.904491-1-leitao@debian.org>
References: <20230504121856.904491-1-leitao@debian.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.4 required=5.0 tests=BAYES_00,
        FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

In the io_uring_cmd_prep_async() there is an unnecessary compilation time
check to check if cmd is correctly placed at field 48 of the SQE.

This is unnecessary, since this check is already in place at
io_uring_init():

          BUILD_BUG_SQE_ELEM(48, __u64,  addr3);

Remove it and the uring_cmd_pdu_size() function, which is not used
anymore.

Keith started a discussion about this topic in the following thread:
Link: https://lore.kernel.org/lkml/ZDBmQOhbyU0iLhMw@kbusch-mbp.dhcp.thefacebook.com/

Signed-off-by: Breno Leitao <leitao@debian.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 io_uring/uring_cmd.c | 3 ---
 io_uring/uring_cmd.h | 8 --------
 2 files changed, 11 deletions(-)

diff --git a/io_uring/uring_cmd.c b/io_uring/uring_cmd.c
index ed536d7499db..5e32db48696d 100644
--- a/io_uring/uring_cmd.c
+++ b/io_uring/uring_cmd.c
@@ -70,9 +70,6 @@ int io_uring_cmd_prep_async(struct io_kiocb *req)
 {
 	struct io_uring_cmd *ioucmd = io_kiocb_to_cmd(req, struct io_uring_cmd);
 
-	BUILD_BUG_ON(uring_cmd_pdu_size(0) != 16);
-	BUILD_BUG_ON(uring_cmd_pdu_size(1) != 80);
-
 	memcpy(req->async_data, ioucmd->sqe, uring_sqe_size(req->ctx));
 	ioucmd->sqe = req->async_data;
 	return 0;
diff --git a/io_uring/uring_cmd.h b/io_uring/uring_cmd.h
index 7c6697d13cb2..8117684ec3ca 100644
--- a/io_uring/uring_cmd.h
+++ b/io_uring/uring_cmd.h
@@ -3,11 +3,3 @@
 int io_uring_cmd(struct io_kiocb *req, unsigned int issue_flags);
 int io_uring_cmd_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe);
 int io_uring_cmd_prep_async(struct io_kiocb *req);
-
-/*
- * The URING_CMD payload starts at 'cmd' in the first sqe, and continues into
- * the following sqe if SQE128 is used.
- */
-#define uring_cmd_pdu_size(is_sqe128)				\
-	((1 + !!(is_sqe128)) * sizeof(struct io_uring_sqe) -	\
-		offsetof(struct io_uring_sqe, cmd))
-- 
2.34.1

