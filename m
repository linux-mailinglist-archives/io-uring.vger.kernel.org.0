Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 353994E7279
	for <lists+io-uring@lfdr.de>; Fri, 25 Mar 2022 12:53:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351390AbiCYLzI (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 25 Mar 2022 07:55:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45100 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1357542AbiCYLzC (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 25 Mar 2022 07:55:02 -0400
Received: from mail-ej1-x62f.google.com (mail-ej1-x62f.google.com [IPv6:2a00:1450:4864:20::62f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 10ADBBE26
        for <io-uring@vger.kernel.org>; Fri, 25 Mar 2022 04:53:29 -0700 (PDT)
Received: by mail-ej1-x62f.google.com with SMTP id bi12so14890988ejb.3
        for <io-uring@vger.kernel.org>; Fri, 25 Mar 2022 04:53:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=mfQUPYugyXWtt//oyZ9SH+vlzawGEogTCV5RBHOmcS8=;
        b=eS1WdN2UhhL3xYfVptflnr/vFLt0tFCvc2Wzr0+OWs88Ak3Bj0gbWrJtmZdKUmG5+w
         N9QWQxhQ986JPdVpw16eVUqNWgcIY02Rwidu3pC0IvamE1MSqU1ZGMnD2DPkijvGaLjN
         ZPk87tL7gCWX5ePsN3FNgtOMDAdf8m4t94QC5+HHZ4JGAZBqOJ0gKm92hsWI2XWg58j5
         UFcTczDU1vp/Oq+GimROzIz++IfObaWINDIlxCF83s3dkZHnWAf5B62sbyGiiWtxz9Z/
         i2+W9MuY8AqSQlFzCJaN0IEX+urDu8cUWmFluOa4zspp2ttayPKCiCu+Ph8EPpMkqa+r
         EYAw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=mfQUPYugyXWtt//oyZ9SH+vlzawGEogTCV5RBHOmcS8=;
        b=6VrTr+cGukR68jtQAEAhCa/hyU6CmvDmhuic6HpVKu/JQp5SvLJeoECFa/Wm+HQXjR
         o83Ju1Z/Xc4cIIViCdY0Q52BkxfDeYtiWh+dLxmMZLtDGtZuburE2Fmz6K7SyflDJm9K
         I6Osqeb2wOrsyYiqkbBhgIgiS68T0ADKxNEtfcTvTxCBoUv54ugCnCzgnIWmv5lkE2X7
         s3qWZi2LKoVhjlgU2y9ss0wcybzndIqn2nGfuBxEB95lMQZuQrVnGaHu3sfIEaNDPfzc
         B5j9a0DF0nO5mzJ7dCqDOuFZ0B2RpGD5hwJfxBf4ZkSs6JhOT7EjvvuYfzoixUlseqPz
         Rrgw==
X-Gm-Message-State: AOAM533ODm5+qntChofXWPFFDTauzqjU4XD81tmaxWmnMCsZbsRkDaZG
        dKctEKPWk9ijJJz6wnaPfLNZVOxbN3lo8A==
X-Google-Smtp-Source: ABdhPJzL2VYSXl4kFywTZ/BbIhbuhfLxWr2ypVtUjX/BwQRvR/dhyS/tKI017b3yb7Qzvi+veGI5eQ==
X-Received: by 2002:a17:907:9506:b0:6da:b4cd:515b with SMTP id ew6-20020a170907950600b006dab4cd515bmr11192163ejc.602.1648209207426;
        Fri, 25 Mar 2022 04:53:27 -0700 (PDT)
Received: from 127.0.0.1localhost ([78.179.227.119])
        by smtp.gmail.com with ESMTPSA id u4-20020aa7db84000000b004136c2c357csm2706777edt.70.2022.03.25.04.53.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 25 Mar 2022 04:53:27 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     io-uring@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>, asml.silence@gmail.com
Subject: [PATCH 5/5] io_uring: improve req fields comments
Date:   Fri, 25 Mar 2022 11:52:18 +0000
Message-Id: <1e51d1e6b1f3708c2d4127b4e371f9daa4c5f859.1648209006.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <cover.1648209006.git.asml.silence@gmail.com>
References: <cover.1648209006.git.asml.silence@gmail.com>
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

Move a misplaced comment about req->creds and add a line with
assumptions about req->link.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 fs/io_uring.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 9cd33278089b..51a00ef88136 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -935,10 +935,11 @@ struct io_kiocb {
 	struct async_poll		*apoll;
 	/* opcode allocated if it needs to store data for async defer */
 	void				*async_data;
-	/* custom credentials, valid IFF REQ_F_CREDS is set */
 	/* stores selected buf, valid IFF REQ_F_BUFFER_SELECTED is set */
 	struct io_buffer		*kbuf;
+	/* linked requests, IFF REQ_F_HARDLINK or REQ_F_LINK are set */
 	struct io_kiocb			*link;
+	/* custom credentials, valid IFF REQ_F_CREDS is set */
 	const struct cred		*creds;
 	struct io_wq_work		work;
 };
-- 
2.35.1

