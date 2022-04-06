Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E51704F6292
	for <lists+io-uring@lfdr.de>; Wed,  6 Apr 2022 17:08:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235354AbiDFPC0 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 6 Apr 2022 11:02:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33790 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235322AbiDFPBy (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 6 Apr 2022 11:01:54 -0400
Received: from mail-ej1-x634.google.com (mail-ej1-x634.google.com [IPv6:2a00:1450:4864:20::634])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2781ABF329
        for <io-uring@vger.kernel.org>; Wed,  6 Apr 2022 04:46:21 -0700 (PDT)
Received: by mail-ej1-x634.google.com with SMTP id dr20so3679095ejc.6
        for <io-uring@vger.kernel.org>; Wed, 06 Apr 2022 04:46:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=SG6pO4W68lasv2c2yo8I8YutyRF+ZZXhM5T2CHVWrlY=;
        b=PC6TPhm6HU+m1tGfQORbk9XoJnfVW5esxi2Ubi2sZWAO4kUzSoXX2nUmI0hhUT0kMz
         Fcsh1OUhtIkXnjiBNqjw2XONJxG+U+t64pJPKdjOSxB+T+cdEZsxuzS7mAp4PWk7EzXF
         RGP1OTISZRcGU4x5SNeJIG+oM/nadM6UdNUqtJPQAK7QBjZ7RaTUsnynTM1NnXXCQZzM
         esrQX9wrLOxca2lZbUD1AS5sM6pUi8BjnwYZUUAAStMIkPQQd/oB/IEZp02plaR+2htV
         ETkz4ZNKeBlzWH5iRrYKe6LKPRF0nr+A/YBo7WK74vLoClXwBbE9rLKhXITsSog2/TLN
         JIXQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=SG6pO4W68lasv2c2yo8I8YutyRF+ZZXhM5T2CHVWrlY=;
        b=PgVGqDDm4R1n0+bhVNb5t/Q74/tIf3a8a1lwKLB34vZAQCGWKLTFZHr9ktHttLx2N6
         OXcu76lVXnQRNvlFxNmCcrqXuBtut+2dp411C+cy2lsAciS2ljgKjg4eZVZulrNUd7EU
         hv0iGQrDzmIKRMmsRwGWHAI0fkbS5UgYYZW0PyPVw6brmwww4PXP+1wmOrtAgehIDHZt
         5F4j1E3NLeC4no4vcA5z18FX49vLXB7v6Qc7cdI51cFJ7uoCPEX7f89MouyTcI6EFw1j
         qVQCkH7Rf23zZ8iqjcBKIzb44MNeMCHjDoIiJkf96rPbCOSAXton9OJzHTYl2E0P1Tft
         BnUA==
X-Gm-Message-State: AOAM530a2qqncMw5emlNmGQx5WlZfFE4AdSx8VZ0J6u3UjROSeuafmWw
        C2FZzqINRxEMpLPt/1cxl5PEQ3G7NXM=
X-Google-Smtp-Source: ABdhPJztqvlZ41+y3fXKSDwQAG/sf3SDHJkMHxIMhuOaPN13XCpIeKHxuyYhuWNAK/nMfj7ymIDG6w==
X-Received: by 2002:a17:906:d54b:b0:6e7:f185:18d5 with SMTP id cr11-20020a170906d54b00b006e7f18518d5mr8302188ejc.155.1649245531014;
        Wed, 06 Apr 2022 04:45:31 -0700 (PDT)
Received: from 127.0.0.1localhost ([148.252.129.65])
        by smtp.gmail.com with ESMTPSA id g16-20020a170906521000b006d58773e992sm6506022ejm.188.2022.04.06.04.45.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 06 Apr 2022 04:45:30 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     io-uring@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>, asml.silence@gmail.com
Subject: [PATCH 1/2] io_uring: nospec index for tags on files update
Date:   Wed,  6 Apr 2022 12:43:57 +0100
Message-Id: <55c05506d6ade79de01f5f5677be2e738daf3e47.1649245017.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <cover.1649245017.git.asml.silence@gmail.com>
References: <cover.1649245017.git.asml.silence@gmail.com>
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

Don't forget to array_index_nospec() for indexes before updating rsrc
tags in __io_sqe_files_update(), just use already safe and precalculated
index @i.

Fixes: c3bdad0271834 ("io_uring: add generic rsrc update with tags")
Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 fs/io_uring.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index f95b44a91b7d..449d4ea419cb 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -9294,7 +9294,7 @@ static int __io_sqe_files_update(struct io_ring_ctx *ctx,
 				err = -EBADF;
 				break;
 			}
-			*io_get_tag_slot(data, up->offset + done) = tag;
+			*io_get_tag_slot(data, i) = tag;
 			io_fixed_file_set(file_slot, file);
 			err = io_sqe_file_register(ctx, file, i);
 			if (err) {
-- 
2.35.1

