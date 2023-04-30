Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 256736F293E
	for <lists+io-uring@lfdr.de>; Sun, 30 Apr 2023 16:36:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231163AbjD3OgN (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sun, 30 Apr 2023 10:36:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45272 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231132AbjD3OgM (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sun, 30 Apr 2023 10:36:12 -0400
Received: from mail-wm1-f53.google.com (mail-wm1-f53.google.com [209.85.128.53])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9CDCF30D7;
        Sun, 30 Apr 2023 07:36:10 -0700 (PDT)
Received: by mail-wm1-f53.google.com with SMTP id 5b1f17b1804b1-3f178da21afso9172355e9.1;
        Sun, 30 Apr 2023 07:36:10 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1682865369; x=1685457369;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=xYztlqpoEVeIHrKJhvcjUMJ8ItqPkXoCxbhVy1uECD8=;
        b=FQI35MwBpoaVia+4InoU7iFGH9MbjnMNh19HXUIUbjQgPTNdh+/PCigiQnJytUH7Z+
         JwOLkQHS+9EDDRBX/65+5ikKxwSW5ZN0MnT5UjG/LBJJGRrnMbzokVM7iH9B1Cgl5dkj
         69uYXqNfkgJgSgPyN9UnOsVf/tEpQBTGGjT6u8HjhSYynIlh1t5Fucj6feb9gbDOhmd0
         sBLo6UuU/6X4oi7LEBpaXKRAPV25G0fmAlugb20ZIBqhMlDIiw79Po2XxE2wSf5aglcE
         9mN19nCqWSoDh1phrCcqbMJBKIHO4R7MxAs8z9PSvH1llCaFGsBu80qTAMx5U2GaAsUI
         OEuQ==
X-Gm-Message-State: AC+VfDzngnDd7RM/Kjwbo7mYWppmKC9R3l47+DtVW0T5AKQTPZF9KOYb
        uOcyu8xoOPzxw76TS3xyB/kRrzrK3369nA==
X-Google-Smtp-Source: ACHHUZ5664eOiLW3ZPACCqiNPyzg5aNNsS92B900veDjENR7znnwEFn7Tk4ea/zKV8HHvuHnyLT7PQ==
X-Received: by 2002:a05:600c:3797:b0:3f2:5a60:a03e with SMTP id o23-20020a05600c379700b003f25a60a03emr8721130wmr.14.1682865368556;
        Sun, 30 Apr 2023 07:36:08 -0700 (PDT)
Received: from localhost (fwdproxy-cln-026.fbsv.net. [2a03:2880:31ff:1a::face:b00c])
        by smtp.gmail.com with ESMTPSA id g10-20020a7bc4ca000000b003f171234a08sm29747037wmk.20.2023.04.30.07.36.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 30 Apr 2023 07:36:07 -0700 (PDT)
From:   Breno Leitao <leitao@debian.org>
To:     io-uring@vger.kernel.org, linux-nvme@lists.infradead.org,
        asml.silence@gmail.com, axboe@kernel.dk, ming.lei@redhat.com
Cc:     leit@fb.com, linux-kernel@vger.kernel.org,
        linux-block@vger.kernel.org, sagi@grimberg.me, joshi.k@samsung.com,
        hch@lst.de, kbusch@kernel.org
Subject: [PATCH v3 3/4] io_uring: Remove unnecessary BUILD_BUG_ON
Date:   Sun, 30 Apr 2023 07:35:31 -0700
Message-Id: <20230430143532.605367-4-leitao@debian.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230430143532.605367-1-leitao@debian.org>
References: <20230430143532.605367-1-leitao@debian.org>
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
index a1be746cd009..743d1496431b 100644
--- a/io_uring/uring_cmd.c
+++ b/io_uring/uring_cmd.c
@@ -71,9 +71,6 @@ int io_uring_cmd_prep_async(struct io_kiocb *req)
 	struct io_uring_cmd *ioucmd = io_kiocb_to_cmd(req, struct io_uring_cmd);
 	size_t size = uring_sqe_size(req->ctx);
 
-	BUILD_BUG_ON(uring_cmd_pdu_size(0) != 16);
-	BUILD_BUG_ON(uring_cmd_pdu_size(1) != 80);
-
 	memcpy(req->async_data, ioucmd->sqe, size);
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

