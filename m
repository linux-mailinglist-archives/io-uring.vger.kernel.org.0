Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 279B854B38D
	for <lists+io-uring@lfdr.de>; Tue, 14 Jun 2022 16:42:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241187AbiFNOhu (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 14 Jun 2022 10:37:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60492 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238290AbiFNOht (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 14 Jun 2022 10:37:49 -0400
Received: from mail-wm1-x329.google.com (mail-wm1-x329.google.com [IPv6:2a00:1450:4864:20::329])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 94F2D1147A
        for <io-uring@vger.kernel.org>; Tue, 14 Jun 2022 07:37:47 -0700 (PDT)
Received: by mail-wm1-x329.google.com with SMTP id m39-20020a05600c3b2700b0039c511ebbacso6337874wms.3
        for <io-uring@vger.kernel.org>; Tue, 14 Jun 2022 07:37:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=pRvBVOE/hkiozWmaa4rfYGZwNs1AXWCtzZOpvsa5jls=;
        b=KW5wgCEIRCTTEW48+U0V70LgeRyFAPjmEisiMvWe48l36sobA9osW9ESPXDRoCgfra
         54PqBo73Az5H+BrYGGVBC4gwSsTiP2Ilnp7ccq3rgHG1slYQAgQYPm2XeW1CLYQOmXfC
         PzeBcyCo+WRF2f9mq7EpO9NOMiSmNauQdpPDMEOm65PTBNp0cTeMUeuQCztUqk1TUHhE
         E22uZAqdN16n/LgrWfhUHiR8xeE3HxSzvt0yhv1lITzJTJyNiKBz7FJlmN/Dht0CcxEd
         BqH28LhdL8yWzGNjOtD0w4DC69Ws8O4nnjHIDl90K7rQr9n4hxk7iwK2HkK3FlQMgCx3
         yAkQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=pRvBVOE/hkiozWmaa4rfYGZwNs1AXWCtzZOpvsa5jls=;
        b=ExsgCVJEhSn2n/jk6Rtx6mmSCycaM/1ZeRvHwnWHf/sg6gMs+LMRxwf8kFe2r0aJ5T
         QmTRnHZ6gAf7gziDMIFtwAruuJ17zz7Wxb7he4BMcabCcVi8ZPgmYNnI8UC3XLKGNGsc
         dzCMj8Hs6L+kRSF1iij8stl3M4AwbVmTdYWkLQHGpUHwdxZDAgblXxtu+ec2rU5siUjA
         868jAkp7V05g59g8JVayS0eWKR9VMiRdyNIdu+zv2J/ALnDft6U4g+eLULU6Uoy0Un9v
         0uLSAaIwfPvFB7M+J5EwiS+V6KKkKfpDUYEdk6lpXLzHVU1sUNqn+yXL53w3Yr4Z0dd7
         FeZA==
X-Gm-Message-State: AOAM530lrHgRK+dENrFgM/Z2m3+fTbfpRecs04964pexFyqe8R8o8+lI
        OMK9rMhbaPT1dIVPDU3nOM385JSHbRCnOg==
X-Google-Smtp-Source: ABdhPJw+dgZRmWeOglrX0+xhlPytNFCIYlGli60nqojcZ5zl21tiCuxpJmMqjDMtwNc9QLT1KlUtHQ==
X-Received: by 2002:a05:600c:3d18:b0:39c:474c:eb with SMTP id bh24-20020a05600c3d1800b0039c474c00ebmr4479104wmb.87.1655217465868;
        Tue, 14 Jun 2022 07:37:45 -0700 (PDT)
Received: from 127.0.0.1localhost (188.28.125.106.threembb.co.uk. [188.28.125.106])
        by smtp.gmail.com with ESMTPSA id a4-20020adff7c4000000b0021033caa332sm12353064wrq.42.2022.06.14.07.37.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 14 Jun 2022 07:37:45 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     io-uring@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>, asml.silence@gmail.com
Subject: [PATCH for-next v2 06/25] io_uring: explain io_wq_work::cancel_seq placement
Date:   Tue, 14 Jun 2022 15:36:56 +0100
Message-Id: <0a6cd1d420834f440928642df2c88a175d969cdb.1655213915.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <cover.1655213915.git.asml.silence@gmail.com>
References: <cover.1655213915.git.asml.silence@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Add a comment on why we keep ->cancel_seq in struct io_wq_work instead
of struct io_kiocb despite it needed only by io_uring but not io-wq.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 io_uring/io-wq.h | 1 +
 1 file changed, 1 insertion(+)

diff --git a/io_uring/io-wq.h b/io_uring/io-wq.h
index ba6eee76d028..3f54ee2a8eeb 100644
--- a/io_uring/io-wq.h
+++ b/io_uring/io-wq.h
@@ -155,6 +155,7 @@ struct io_wq_work_node *wq_stack_extract(struct io_wq_work_node *stack)
 struct io_wq_work {
 	struct io_wq_work_node list;
 	unsigned flags;
+	/* place it here instead of io_kiocb as it fills padding and saves 4B */
 	int cancel_seq;
 };
 
-- 
2.36.1

