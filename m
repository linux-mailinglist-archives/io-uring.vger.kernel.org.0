Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 12FBE567C98
	for <lists+io-uring@lfdr.de>; Wed,  6 Jul 2022 05:42:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229817AbiGFDlh (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 5 Jul 2022 23:41:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45972 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230274AbiGFDlg (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 5 Jul 2022 23:41:36 -0400
Received: from mail-io1-xd2c.google.com (mail-io1-xd2c.google.com [IPv6:2607:f8b0:4864:20::d2c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A3EE21D0E6
        for <io-uring@vger.kernel.org>; Tue,  5 Jul 2022 20:41:35 -0700 (PDT)
Received: by mail-io1-xd2c.google.com with SMTP id p128so12960838iof.1
        for <io-uring@vger.kernel.org>; Tue, 05 Jul 2022 20:41:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:subject:date:message-id:in-reply-to:references:mime-version
         :content-transfer-encoding;
        bh=x057cX0WQUKc+gw02TFg5EPcC5q2Nkpgn1fkajLFlvI=;
        b=XJWKgLHvqG5SFvipw2Zw52/F4WindsxEA1OhN4F0P5yqjGhsopoe84dkDBoJG0KswZ
         GNPnUyI2JozpRseaeql35kS/dSjizJRGA4zLp1PvvwhvvwChW7rcQf4oEInuAwoiVRaH
         rm+fw2n2BrsAHLUFC66k8st04fTSAwBIhSMCF7aaa2wZq5CV8umjbEoPkDA7DafFNpfm
         gbpie1mlHMxXurK/3mwrA/CLWUEzXqN1aJ3AH+Pd28ruM/dJuElM29en5TUZJqaJB8W2
         51EnNYCMbSOJXQyapzhycUyNuFh6ELPiKlYmxhOzu5Uve4PIzWhoaU1v2qp5KCccaKTI
         iGaA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=x057cX0WQUKc+gw02TFg5EPcC5q2Nkpgn1fkajLFlvI=;
        b=v4Q3Cxvh10pics32PJGkA29mR8/Q3dskTd2X3i0q46fO4kCiyN6nLExDyEceiruTnN
         NLPY0cu0FgY5YYbJpYEj5CAWzzF6C/knVV24taByIMLGX6XemyyuecqtN9hcXum4jl87
         WVhsA2j8cJJYUbYXwfVfX+MCPUZqPJY/LwC+INvzdbg85wX/kPPpguQIyKcYnK+3HHFj
         s/KL8i8eAGPFkLP3Q2EwdUw+c8j2VA+PcnxuLmuPx7wrCdmCUV3SEBOsxpuzr77fUr8h
         HubVDye8tp3Ba8hj8RQpJucTtHcLeOGH0OKabhLD5Me4ef628hyashX2AuKrMGD56WIs
         UVLg==
X-Gm-Message-State: AJIora/3vijvZCsBVFS0PgbyyN4xsaa1B+0dupUDMq+7XE7daKZRyNfa
        r3M/H9N85NvGOou0fwlLSZYDkwbTuIJCytuC
X-Google-Smtp-Source: AGRyM1sNyYc5VwooATU3zDMwUOhopKqOQvZvtpURb2XUZF5VMxQ8FHeYl5ap3vacSoYd48+BZbgqAQ==
X-Received: by 2002:a6b:8b42:0:b0:675:1e6d:9386 with SMTP id n63-20020a6b8b42000000b006751e6d9386mr21268298iod.153.1657078894777;
        Tue, 05 Jul 2022 20:41:34 -0700 (PDT)
Received: from didactylos.localdomain ([2600:1700:57f0:ca20:763a:c795:fcf6:91ea])
        by smtp.gmail.com with ESMTPSA id z6-20020a05660217c600b006692192baf7sm16427854iox.25.2022.07.05.20.41.34
        for <io-uring@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 05 Jul 2022 20:41:34 -0700 (PDT)
From:   Eli Schwartz <eschwartz93@gmail.com>
To:     io-uring@vger.kernel.org
Subject: [PATCH liburing 5/6] tests: migrate a skip that used a goto to enter cleanup
Date:   Tue,  5 Jul 2022 23:40:57 -0400
Message-Id: <20220706034059.2817423-6-eschwartz93@gmail.com>
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

We cannot use the general cleanup-and-succeed here. Migrate this to use
exitcode reporting via a new "skip" goto.

Signed-off-by: Eli Schwartz <eschwartz93@gmail.com>
---
 test/mkdir.c | 9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

diff --git a/test/mkdir.c b/test/mkdir.c
index 6b3497c..0a6d16f 100644
--- a/test/mkdir.c
+++ b/test/mkdir.c
@@ -72,7 +72,7 @@ int main(int argc, char *argv[])
 	if (ret < 0) {
 		if (ret == -EBADF || ret == -EINVAL) {
 			fprintf(stdout, "mkdirat not supported, skipping\n");
-			goto out;
+			goto skip;
 		}
 		fprintf(stderr, "mkdirat: %s\n", strerror(-ret));
 		goto err;
@@ -97,10 +97,13 @@ int main(int argc, char *argv[])
 		goto err1;
 	}
 
-out:
 	unlinkat(AT_FDCWD, fn, AT_REMOVEDIR);
 	io_uring_queue_exit(&ring);
-	return 0;
+	return T_EXIT_PASS;
+skip:
+	unlinkat(AT_FDCWD, fn, AT_REMOVEDIR);
+	io_uring_queue_exit(&ring);
+	return T_EXIT_SKIP;
 err1:
 	unlinkat(AT_FDCWD, fn, AT_REMOVEDIR);
 err:
-- 
2.35.1

