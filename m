Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C46AE6E776C
	for <lists+io-uring@lfdr.de>; Wed, 19 Apr 2023 12:29:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232554AbjDSK35 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 19 Apr 2023 06:29:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41400 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232416AbjDSK3t (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 19 Apr 2023 06:29:49 -0400
Received: from mail-wr1-f45.google.com (mail-wr1-f45.google.com [209.85.221.45])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D72A655B5;
        Wed, 19 Apr 2023 03:29:48 -0700 (PDT)
Received: by mail-wr1-f45.google.com with SMTP id ffacd0b85a97d-2f27a9c7970so2872830f8f.2;
        Wed, 19 Apr 2023 03:29:48 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1681900187; x=1684492187;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=1cjooBvMCNJhlavL1EbY+Mb4+Vf8+MK1I5YGhYcyjWY=;
        b=BieOR9qWpyyctOUZRHD6mXLe5j0m8n2iG0O3S/oPEzGCNK9x68OUJOBanpmPzJLkp2
         i25+twwxGmBoPYFsoa2z+1+09eYUpT1uVHvGnh6O0V+LdDYnV3kMr8GvwUFEsgUERsVU
         cmqFaRTXc9W03qSe6YjIxrbYnjIzMKB0FKj3CiaewPwt/wdhDGMqVWoGYOIUVCXEELNA
         Pn8kNH+1RlBt/hZKzqZ9CFziKSa5aof7PpIKBp3BvADoVAYXTX1CpE4DZEXK+T0hKoE+
         REGmiId4IVmS9HaI1ebEwpa1ywjv3QPxgH0lul8vASr+IaTd4t/NhFt04AmsrTVKdqjU
         klgg==
X-Gm-Message-State: AAQBX9eZFIgy/ExcYmm+edBz1gCew6YooUdpZlEgS3+Awi2sWGMQUj3q
        KJKKcI4eJqS86yslwEx0ppm1UwUFU/j4U0G2
X-Google-Smtp-Source: AKy350ZrF9+PU5wlzZyJvzaoxWd8IqaVJy/LdD8KdSkMSbZ5FuQTzjQ/kFdz1vtwzq0yJtgJRJNPWw==
X-Received: by 2002:adf:e588:0:b0:2f9:2fb0:c46 with SMTP id l8-20020adfe588000000b002f92fb00c46mr3516652wrm.68.1681900187024;
        Wed, 19 Apr 2023 03:29:47 -0700 (PDT)
Received: from localhost (fwdproxy-cln-017.fbsv.net. [2a03:2880:31ff:11::face:b00c])
        by smtp.gmail.com with ESMTPSA id k25-20020a7bc419000000b003f1736fdfedsm1783916wmi.10.2023.04.19.03.29.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 19 Apr 2023 03:29:46 -0700 (PDT)
From:   Breno Leitao <leitao@debian.org>
To:     io-uring@vger.kernel.org, linux-nvme@lists.infradead.org,
        asml.silence@gmail.com, axboe@kernel.dk
Cc:     leit@fb.com, linux-kernel@vger.kernel.org,
        linux-block@vger.kernel.org, sagi@grimberg.me, hch@lst.de,
        kbusch@kernel.org, ming.lei@redhat.com
Subject: [PATCH 2/2] io_uring: Remove unnecessary BUILD_BUG_ON
Date:   Wed, 19 Apr 2023 03:29:30 -0700
Message-Id: <20230419102930.2979231-3-leitao@debian.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230419102930.2979231-1-leitao@debian.org>
References: <20230419102930.2979231-1-leitao@debian.org>
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

In the io_uring_cmd_prep_async() there is a unnecessary compilation time
check to check if cmd is correctly placed at field 48 of the SQE.

This is uncessary, since this check is already in place at
io_uring_init():

          BUILD_BUG_SQE_ELEM(48, __u64,  addr3);

Remove it and the uring_cmd_pdu_size() function, which is not used
anymore.

Keith started a discussion about this topic in the following thread:
https://lore.kernel.org/lkml/ZDBmQOhbyU0iLhMw@kbusch-mbp.dhcp.thefacebook.com/

Signed-off-by: Breno Leitao <leitao@debian.org>
---
 io_uring/uring_cmd.c | 3 ---
 io_uring/uring_cmd.h | 8 --------
 2 files changed, 11 deletions(-)

diff --git a/io_uring/uring_cmd.c b/io_uring/uring_cmd.c
index 5cb2e39e99f9..fccc497bab59 100644
--- a/io_uring/uring_cmd.c
+++ b/io_uring/uring_cmd.c
@@ -71,9 +71,6 @@ int io_uring_cmd_prep_async(struct io_kiocb *req)
 	struct io_uring_cmd *ioucmd = io_kiocb_to_cmd(req, struct io_uring_cmd);
 	size_t size = sizeof(struct io_uring_sqe);
 
-	BUILD_BUG_ON(uring_cmd_pdu_size(0) != 16);
-	BUILD_BUG_ON(uring_cmd_pdu_size(1) != 80);
-
 	if (req->ctx->flags & IORING_SETUP_SQE128)
 		size <<= 1;
 
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

