Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EDE4D779005
	for <lists+io-uring@lfdr.de>; Fri, 11 Aug 2023 15:00:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231132AbjHKNAB (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 11 Aug 2023 09:00:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34960 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229793AbjHKNAA (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 11 Aug 2023 09:00:00 -0400
Received: from mail-ej1-x62a.google.com (mail-ej1-x62a.google.com [IPv6:2a00:1450:4864:20::62a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D58AD119
        for <io-uring@vger.kernel.org>; Fri, 11 Aug 2023 05:59:59 -0700 (PDT)
Received: by mail-ej1-x62a.google.com with SMTP id a640c23a62f3a-99bc9e3cbf1so409284466b.0
        for <io-uring@vger.kernel.org>; Fri, 11 Aug 2023 05:59:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1691758798; x=1692363598;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=o490qkgA8jkvniu8QjPKbh3eSmq5bsQk5VJPtrM3x6o=;
        b=iEZtT1ZIMVpkZR65ut0wc4UJkouU6iRbFO9mT37exRYIPBEMjn71uagWk5zlFza6dp
         vqhY4Fd8KQQl/8v7vjHh6OgcKVSgycma/PZmPukYTI+tmesyh36ARzOTyT1KQoPgBfDM
         9T5nN7bIdYgapU75rj4+7qt2aiNXKimF69/vEM2nblxCvtVzzB4LxoC4QKXJ15WmStLB
         xEccaB9K/rRdEOOG/YOwUv8B8aAZtQRJa+lZ5ZgtWPfG76PGuUJJEobr1gsPASwyE1lm
         FReJeUjbKIgqRmMwYxV2rLAQFbpUJtd5Ua6Yg2/EoVV+Ba1tdgy8ox11aKCAK36FN3mE
         EezQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1691758798; x=1692363598;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=o490qkgA8jkvniu8QjPKbh3eSmq5bsQk5VJPtrM3x6o=;
        b=DlCRETfQ1/QPDGqys/jlkjh99kfk26kfsowC4/VGKk1aPif58NYfUhMy/VBM5nFcYy
         3st9IFDxrbsu8AR3th76CrQdQQqJlwuTpOg6aQ9//PUlbLepCxrpNj/m+Fq6IqKbrgd9
         mcWpFpXZ6lmgyqitlP0fy8uBbc9RaDt6Pc2lvxThT8LaJPJUz3l6gqnwMDFf96SEZuy/
         pbBwA0YVvZbNC4oXFjpFEG60ZS3EsTXmLbY+OCE2/ORyTmwN1k4qoYU3jta30aq3I3m8
         6dytQqnhtF0qEl+yVAfC02iUop1H7+UBq7zgH+koYwtDiWDmsVPOv2MGiIHq1eYU90LS
         DuzA==
X-Gm-Message-State: AOJu0YxRRbkkGtydqKJc+/g2vvYEU40fC77hckF2EjUeoTuPnhJVTHds
        KZ0NBsCwMD9ImCoGucNz8zp4D9xzf6s=
X-Google-Smtp-Source: AGHT+IE4C19xnyFQ5CHicf6I3J0LBjGVNPx3lEy6DY4oLOTptpNTKS571qQdbyH7JH2LNah12mkBDw==
X-Received: by 2002:a17:906:10d2:b0:99b:50ea:2f96 with SMTP id v18-20020a17090610d200b0099b50ea2f96mr2214499ejv.12.1691758798112;
        Fri, 11 Aug 2023 05:59:58 -0700 (PDT)
Received: from 127.com ([2620:10d:c092:600::2:a57e])
        by smtp.gmail.com with ESMTPSA id j23-20020a170906411700b00988e953a586sm2219141ejk.61.2023.08.11.05.59.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 11 Aug 2023 05:59:57 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     io-uring@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>, asml.silence@gmail.com
Subject: [PATCH liburing] tests: don't expect multishot recv overflow backlogging
Date:   Fri, 11 Aug 2023 13:58:30 +0100
Message-ID: <d078c0f797322bd01d8c91743d652b734e83e9ba.1691758633.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.41.0
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

Multishots may and are likely to complete when there is no space in CQ,
don't rely on overflows.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 test/recv-multishot.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/test/recv-multishot.c b/test/recv-multishot.c
index e4a07ce..f66f131 100644
--- a/test/recv-multishot.c
+++ b/test/recv-multishot.c
@@ -271,7 +271,7 @@ static int test(struct args *args)
 		 */
 		bool const early_last = args->early_error == ERROR_EARLY_OVERFLOW &&
 					!args->wait_each &&
-					i == N_CQE_OVERFLOW &&
+					i >= N_CQE_OVERFLOW &&
 					!(cqe->flags & IORING_CQE_F_MORE);
 
 		bool const should_be_last =
-- 
2.41.0

