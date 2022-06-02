Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B19FA53B437
	for <lists+io-uring@lfdr.de>; Thu,  2 Jun 2022 09:18:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231670AbiFBHSr (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 2 Jun 2022 03:18:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36948 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231330AbiFBHSq (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 2 Jun 2022 03:18:46 -0400
Received: from mail-pl1-x633.google.com (mail-pl1-x633.google.com [IPv6:2607:f8b0:4864:20::633])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1D10C30C;
        Thu,  2 Jun 2022 00:18:46 -0700 (PDT)
Received: by mail-pl1-x633.google.com with SMTP id n8so3830231plh.1;
        Thu, 02 Jun 2022 00:18:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=Fg+YJdKSIUZuBoNCQW7zpcvmuvQppBd7jxUfv/9/4Rg=;
        b=iHWIW77EkqbOtQ32Uz1DYaHC7kq6l1hccXzCOqC0Tbxhoveun+hvDM8GSWlYFpigbo
         6XwAS8hPqqTSwdIoxoslTM9SFMnO/fCdVgt1cLbExGlxf+0TBjJtFZexiJzbPF+qg1Mt
         FHvnX655CpVIDNHoIw1U54EvpihfhGQqFdjnyv+QKyg+PRg5QiNVmwT5HKAmv/HBr4eG
         6hfOn5TrUSYrPVwSx+6RwM/41bLlJXUHpA4+HZJDpxFTN750U0BY408F9JbQ1UIyIglq
         +48aQ1HphvvKTe4NYvqvqAXsNQ0KuGaOjAWov3m9NSj/RNqrUj61sbsqZLciCbREFCBe
         CGNQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=Fg+YJdKSIUZuBoNCQW7zpcvmuvQppBd7jxUfv/9/4Rg=;
        b=XglPT2e2AsqT7Eh+RSPshrhYgKvu8Vo3CVZSLPJ7eSWPiJkaWO6tkigOk9d830OXvt
         ak95WHigBFYcjeYYk2xu0fD3ZJ7l5mgAwAVRtBonjvbYZNvUFo5dwYtVZSkLIeZqHK64
         SFg4rTpZH3DPGHNt+bf7/Dw+Cra1tpCpdjDH4MdWd58iuBIctxr8cm8mFqa3M3CnAbip
         ATD3bl7ogiaCk6TH5mpNNPXMXSN7XmQRhPrLFfCZGiPG8RwA7c3jsqHffaSU7iijlLdv
         VrD6BqxAt1lDpwZkouYL7FBmV0BkR50hJIURqIolZVEJbCUbCvOa52V1Gf7HPysrWkkg
         VG6g==
X-Gm-Message-State: AOAM5318kksD2D5ay/ecnnbp7cCIhsn37v5S0XNAcjqd8HtvDSHsV6Wh
        jfImSericc/ojwmExqcu4Jk=
X-Google-Smtp-Source: ABdhPJyGX+6GvYUtyPYtoGRKRU/u9lUyv7+RLdY59q27u/vHFaUSbDx1I07YUKw2QLbIiElRuUDc9A==
X-Received: by 2002:a17:902:7b8f:b0:162:467:db7c with SMTP id w15-20020a1709027b8f00b001620467db7cmr3390055pll.140.1654154325648;
        Thu, 02 Jun 2022 00:18:45 -0700 (PDT)
Received: from localhost.localdomain ([193.203.214.57])
        by smtp.gmail.com with ESMTPSA id o21-20020a170903211500b0015e8d4eb26esm2677593ple.184.2022.06.02.00.18.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 02 Jun 2022 00:18:45 -0700 (PDT)
From:   cgel.zte@gmail.com
X-Google-Original-From: chi.minghao@zte.com.cn
To:     axboe@kernel.dk
Cc:     asml.silence@gmail.com, io-uring@vger.kernel.org,
        linux-kernel@vger.kernel.org, Minghao Chi <chi.minghao@zte.com.cn>,
        Zeal Robot <zealci@zte.com.cn>
Subject: [PATCH] io_uring: Remove redundant NULL check before kfree
Date:   Thu,  2 Jun 2022 07:18:41 +0000
Message-Id: <20220602071841.278214-1-chi.minghao@zte.com.cn>
X-Mailer: git-send-email 2.25.1
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

From: Minghao Chi <chi.minghao@zte.com.cn>

kfree on NULL pointer is a no-op.

Reported-by: Zeal Robot <zealci@zte.com.cn>
Signed-off-by: Minghao Chi <chi.minghao@zte.com.cn>
---
 fs/io_uring.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 1fc0166d9133..d1fe967f2343 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -4445,8 +4445,7 @@ static int io_read(struct io_kiocb *req, unsigned int issue_flags)
 	kiocb_done(req, ret, issue_flags);
 out_free:
 	/* it's faster to check here then delegate to kfree */
-	if (iovec)
-		kfree(iovec);
+	kfree(iovec);
 	return 0;
 }
 
-- 
2.25.1


