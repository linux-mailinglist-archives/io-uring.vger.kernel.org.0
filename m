Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 626C2567C9C
	for <lists+io-uring@lfdr.de>; Wed,  6 Jul 2022 05:42:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229480AbiGFDlg (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 5 Jul 2022 23:41:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45962 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229809AbiGFDlg (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 5 Jul 2022 23:41:36 -0400
Received: from mail-il1-x12e.google.com (mail-il1-x12e.google.com [IPv6:2607:f8b0:4864:20::12e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DB84A1D0EC
        for <io-uring@vger.kernel.org>; Tue,  5 Jul 2022 20:41:34 -0700 (PDT)
Received: by mail-il1-x12e.google.com with SMTP id v1so5277800ilg.11
        for <io-uring@vger.kernel.org>; Tue, 05 Jul 2022 20:41:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:subject:date:message-id:in-reply-to:references:mime-version
         :content-transfer-encoding;
        bh=dNvJ2cyduJU4oP9p8VcACup4a7slqRhxUtHeCCkIxT0=;
        b=Dly67QQ104kf4Xzg+NW6n+4cd/GfaWerv18Uor4ys44MQBgQ/LGUqnSGRTZ8DRFB5J
         WXm3rTvpw7l/yuksyHROsFYfZwo6Yyg0GeznTPAV0tUXbPGk9fovaPz7Pqsq59KtFnOL
         Izlj0GW9efLgjeuCRC6nGuLcL0G6HVDK3q2jd8kqZTlO5Vzb84sUxyeJ/pXUH9W594vh
         E84+poE9odNgL9vopXxCF6wPScZOayFVKmoBsqAWrRL9SR2hSzS+9J2IQAXTAYeZh1sA
         cB+aPaqAbYv1MLyMqKmLpFNpgHPjfe3E1MblGZRp5918YpR2kr2gbh99w4/VUFJHhj/X
         JXAw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=dNvJ2cyduJU4oP9p8VcACup4a7slqRhxUtHeCCkIxT0=;
        b=tt6wxH2ZtE11XsDcECj7iJPfsJJ18tkJSYovfKgHCKGC93/ISk760WP5q1dGUP2hgH
         eFwqe9qTr6Nosp7pe7IDXybAQMIQGVSF00yLmYh1qRUsqo7MpDx2yhHLIoMx0D45AJOq
         /blMnnnVKpjmlSF9sfwpGmm53yqDsQD1z+25cSx+mL5InlCcCYqzjtlMJ/cyB4xL8wjY
         DINfpgrX3DFLK4qr8m7JemnwVs9o0bbeV7e68IH0n9VHKgceh4gp63MgaTk6CGMCMe2Q
         TZd4qSHsnCSwxSX6KcjYc9/8ueNypa8/I0MfFbG2s8yOiZFPx4mMYK8xqbvA2WlaYlv/
         AEZA==
X-Gm-Message-State: AJIora8lAWCuSQxZ5AGe+vt/mQO6RqyBNyr7ODO/HKWf5i/owy3bSaeI
        k2b0snqlOlvys4444xZ/iCycqpy2EFIwnBQ+
X-Google-Smtp-Source: AGRyM1vW76jZ24LZws4ZmBvnW/ojoqxOiuTmqdyNIabeDphxeqP1bivZuJkhjzZy1WJVEoGahyy8HQ==
X-Received: by 2002:a05:6e02:154c:b0:2dc:1e6c:ad84 with SMTP id j12-20020a056e02154c00b002dc1e6cad84mr5623198ilu.167.1657078893995;
        Tue, 05 Jul 2022 20:41:33 -0700 (PDT)
Received: from didactylos.localdomain ([2600:1700:57f0:ca20:763a:c795:fcf6:91ea])
        by smtp.gmail.com with ESMTPSA id z6-20020a05660217c600b006692192baf7sm16427854iox.25.2022.07.05.20.41.33
        for <io-uring@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 05 Jul 2022 20:41:33 -0700 (PDT)
From:   Eli Schwartz <eschwartz93@gmail.com>
To:     io-uring@vger.kernel.org
Subject: [PATCH liburing 4/6] tests: mention in a status message that this is a skip
Date:   Tue,  5 Jul 2022 23:40:56 -0400
Message-Id: <20220706034059.2817423-5-eschwartz93@gmail.com>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220706034059.2817423-1-eschwartz93@gmail.com>
References: <20220706034059.2817423-1-eschwartz93@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

It didn't specify that it's an error, and ultimately either returned an
early 0 or, now, T_EXIT_SKIP. Clarify in the logging what it actually
is.

Signed-off-by: Eli Schwartz <eschwartz93@gmail.com>
---
 test/file-register.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/test/file-register.c b/test/file-register.c
index ae35c37..634ef81 100644
--- a/test/file-register.c
+++ b/test/file-register.c
@@ -306,7 +306,7 @@ static int test_sparse(struct io_uring *ring)
 	ret = io_uring_register_files(ring, files, 200);
 	if (ret) {
 		if (ret == -EBADF) {
-			fprintf(stdout, "Sparse files not supported\n");
+			fprintf(stdout, "Sparse files not supported, skipping\n");
 			no_update = 1;
 			goto done;
 		}
-- 
2.35.1

