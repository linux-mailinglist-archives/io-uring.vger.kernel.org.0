Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5715354C56B
	for <lists+io-uring@lfdr.de>; Wed, 15 Jun 2022 12:05:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238827AbiFOKFp (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 15 Jun 2022 06:05:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49878 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238275AbiFOKFo (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 15 Jun 2022 06:05:44 -0400
Received: from mail-wr1-x433.google.com (mail-wr1-x433.google.com [IPv6:2a00:1450:4864:20::433])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E87DC3BF8D
        for <io-uring@vger.kernel.org>; Wed, 15 Jun 2022 03:05:43 -0700 (PDT)
Received: by mail-wr1-x433.google.com with SMTP id k19so14638854wrd.8
        for <io-uring@vger.kernel.org>; Wed, 15 Jun 2022 03:05:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=FtwqEhPzT3nHMQBDGkRoV01F2A3n7O/yvr9Y5995Vdg=;
        b=d60XiiZNGLDTm0KeH2p+vs/fm1TtkyY4sRW0+eNTjXE4VANEquA/Zq0AUquepd4tk5
         K+chIApUWSKQEQ0wdIpYwjrVTPN+Mj6VIymL1ERnDkZC0LfCiOcU8jpOLQZXfcZrqh4C
         NgUXNktmoEPz8DSefuOpiSyFj6RQBLdIL32UbLPankWuZTR60pGTqq/XU++NwjNdIlv2
         T30GQUpdx/KX/IpYaB43c3A2EULLVyBXr23RLPtasOfuuGU/MwSzl3s7SMmFDFz2PT3T
         fGhGVIukeo0wSR2q9i7gcl4+ms1G/h1GOK1oPOnPLMPovP6/NkZs6K6lz//B3+evoWk2
         Prbg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=FtwqEhPzT3nHMQBDGkRoV01F2A3n7O/yvr9Y5995Vdg=;
        b=gBKrHg814SqXdqfsOSl6heKj5OAUtcXz9KeNq1rmtcBSmBc3+NAxW6Tj7bmZUw2eWM
         JhSbEneKVvsp4IRgEndSflAAY5Glb41uN1+C3aNxwNghropvFyXDi/E+cTnZmL5Bi2+F
         iYxnQ1YnY3+n8J0GZQKLwrnahohXEAlSQQZgJH1KqKsxxwwWDR83ahVM6Pqla+YdG68Z
         hu+5pOMZiQhLPmvQ1RxS58hSBB5Eo3Yg2h5bobjEYjV9egQ8npFE1hTWwBVlP4znBPH/
         xxGOhiH9CRiwe2W2pW6Ei+tS8JmWrVPi250y/7d0L5ssbxmSk7fGVcf2PYcsyJYHX63f
         fi5Q==
X-Gm-Message-State: AJIora/axM6fi2p0jaQOLOKGYigwCt8UCVJv/M8fY+6rMVw9kljV1Zed
        lDggiqwyo4nBFUN6scpHbEKAFvX+zCF87g==
X-Google-Smtp-Source: AGRyM1uWA1AWhX5dax8wr+zA6MpvQ24dke2A12ZoC4OcUqyWrv8Ew1wJlIgFhCaaezxgb6KPmCLl+g==
X-Received: by 2002:adf:e902:0:b0:213:a337:92ae with SMTP id f2-20020adfe902000000b00213a33792aemr9239583wrm.84.1655287542212;
        Wed, 15 Jun 2022 03:05:42 -0700 (PDT)
Received: from 127.0.0.1localhost (188.28.125.106.threembb.co.uk. [188.28.125.106])
        by smtp.gmail.com with ESMTPSA id w5-20020a5d6805000000b002119c1a03e4sm14074984wru.31.2022.06.15.03.05.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 15 Jun 2022 03:05:41 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     io-uring@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>, asml.silence@gmail.com
Subject: [PATCH liburing 1/3] io_uring: update headers with IORING_SETUP_SINGLE_ISSUER
Date:   Wed, 15 Jun 2022 11:05:10 +0100
Message-Id: <b5e78497efd3a50bcc75f5d9aab1992375952c93.1655213733.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <cover.1655213733.git.asml.silence@gmail.com>
References: <cover.1655213733.git.asml.silence@gmail.com>
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

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 src/include/liburing/io_uring.h | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/src/include/liburing/io_uring.h b/src/include/liburing/io_uring.h
index 15d9fbd..ee6ccc9 100644
--- a/src/include/liburing/io_uring.h
+++ b/src/include/liburing/io_uring.h
@@ -137,9 +137,12 @@ enum {
  * IORING_SQ_TASKRUN in the sq ring flags. Not valid with COOP_TASKRUN.
  */
 #define IORING_SETUP_TASKRUN_FLAG	(1U << 9)
-
 #define IORING_SETUP_SQE128		(1U << 10) /* SQEs are 128 byte */
 #define IORING_SETUP_CQE32		(1U << 11) /* CQEs are 32 byte */
+/*
+ * Only one task is allowed to submit requests
+ */
+#define IORING_SETUP_SINGLE_ISSUER	(1U << 12)
 
 enum io_uring_op {
 	IORING_OP_NOP,
-- 
2.36.1

