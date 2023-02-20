Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7FEEE69CF20
	for <lists+io-uring@lfdr.de>; Mon, 20 Feb 2023 15:15:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229738AbjBTOPW (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 20 Feb 2023 09:15:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40994 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229479AbjBTOPV (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 20 Feb 2023 09:15:21 -0500
Received: from mail-wr1-x42e.google.com (mail-wr1-x42e.google.com [IPv6:2a00:1450:4864:20::42e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 02B6B10246
        for <io-uring@vger.kernel.org>; Mon, 20 Feb 2023 06:15:21 -0800 (PST)
Received: by mail-wr1-x42e.google.com with SMTP id j2so1191638wrh.9
        for <io-uring@vger.kernel.org>; Mon, 20 Feb 2023 06:15:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=t1HKY2nKL2sgH1F2SB71aRdqAS6sb3mjBXtQfpCwUDI=;
        b=ZMChAuJE0r4aQ1WPp//pf4erqQKWbqXEcTTEZUVdfOKW3rLvizWCYL4LhJJJzx5KZc
         NUHcEfwbc7pYV32GbVmaYYxuMLLbsrKo32Xne2kFaXFdhtzEzzvkRMKUO2bxU/ir5FaL
         nedxjc5ZcKeh4UsUKrngVnBtJG3OUlZLb5mU3MKTZ1IT1kBXDLvabf8GIts7Rn2zmWTe
         yqw/Qc84TjQ+/Ly04kH6yiVJEmkUOsZe8Bn118RIVa3vPG4A6h+ruVcLNC8INhFlO+k2
         JVwZmOG41eM+wqQncD1OTEV7o+WFh72TTSs8iuxlg6xfLYYfueIqundg+lEqBXpc7wY1
         CG0Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=t1HKY2nKL2sgH1F2SB71aRdqAS6sb3mjBXtQfpCwUDI=;
        b=1F43YIgU17+x47VMBGlU2WAgY8oCCliu6APl3DHKTo6QOjHaIzeAIeTxDys2somVHD
         tQVcsp3M3+orFo+ddXe4vn++7KUbHSm5S90se1lNGhlTEvmdkg+ynEE/JXHzC2yyUmnQ
         /Ipih1lOyLQ0ZtQwjvINwmHLn5MVYYh6J4qZIE/Uq+eI9ger04Rv0w8yIdX/zdr8ZKK6
         BGc8ej+h2G9kRGUeP4+3O60T1laRFBgqZ5qbTPFlU6rm9Bw0eEPYMcNsK2Nd9N4Dn1BF
         t/MqQY8fBA+U63xil538vTMQTCLdbvDNSMYZCTinxdrtfILLDFAKs7kZFZaYExzspQAO
         rUag==
X-Gm-Message-State: AO0yUKVQmHRb/ZdJM2eZR4ZrzdM37yYrxTrNMAhOSKLjKyawv6htSI/M
        EJH93E9/0unygSnUiT/0oZz1OJwF9yc=
X-Google-Smtp-Source: AK7set/JOY7S9LJDdBHHpmzyybMdKfIXhV2bax4GZW7bdobqGKE+I9BE+HqEhjwdyfjJf6KP0wrAWg==
X-Received: by 2002:a5d:5c0d:0:b0:2c5:67e3:808d with SMTP id cc13-20020a5d5c0d000000b002c567e3808dmr200892wrb.35.1676902519277;
        Mon, 20 Feb 2023 06:15:19 -0800 (PST)
Received: from 127.0.0.1localhost (94.196.95.64.threembb.co.uk. [94.196.95.64])
        by smtp.gmail.com with ESMTPSA id p9-20020adfce09000000b002c5493a17efsm12496553wrn.25.2023.02.20.06.15.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 20 Feb 2023 06:15:19 -0800 (PST)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     io-uring@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>, asml.silence@gmail.com
Subject: [PATCH for-next 1/1] io_uring/rsrc: fix a comment in io_import_fixed()
Date:   Mon, 20 Feb 2023 14:13:52 +0000
Message-Id: <5b5f79958456caa6dc532f6205f75f224b232c81.1676902343.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.39.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

io_import_fixed() supports offsets, but "may not" means the opposite.
Replace it with "might not" so the comments rather speaks about
possible cases.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 io_uring/rsrc.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/io_uring/rsrc.c b/io_uring/rsrc.c
index 70d7f94670f9..7a915a58eb38 100644
--- a/io_uring/rsrc.c
+++ b/io_uring/rsrc.c
@@ -1336,7 +1336,7 @@ int io_import_fixed(int ddir, struct iov_iter *iter,
 		return -EFAULT;
 
 	/*
-	 * May not be a start of buffer, set size appropriately
+	 * Might not be a start of buffer, set size appropriately
 	 * and advance us to the beginning.
 	 */
 	offset = buf_addr - imu->ubuf;
-- 
2.39.1

