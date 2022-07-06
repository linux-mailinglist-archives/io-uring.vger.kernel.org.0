Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C02B0567C96
	for <lists+io-uring@lfdr.de>; Wed,  6 Jul 2022 05:41:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229682AbiGFDlf (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 5 Jul 2022 23:41:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45932 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229817AbiGFDld (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 5 Jul 2022 23:41:33 -0400
Received: from mail-io1-xd2d.google.com (mail-io1-xd2d.google.com [IPv6:2607:f8b0:4864:20::d2d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 859FF1D0EF
        for <io-uring@vger.kernel.org>; Tue,  5 Jul 2022 20:41:32 -0700 (PDT)
Received: by mail-io1-xd2d.google.com with SMTP id u20so12922473iob.8
        for <io-uring@vger.kernel.org>; Tue, 05 Jul 2022 20:41:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:subject:date:message-id:in-reply-to:references:mime-version
         :content-transfer-encoding;
        bh=PuqrKgkF0BrpsdGgHmBbhhU4JgPZ23Ju60Td0HEhJIQ=;
        b=qUnJKGO1YW97Vu0zoFVtPEfKdXG4i2afrTY2Zq+34+Mp68oZUxq8T3EU0J5fglGDxX
         WCm8mT/Os19mRHDLcPZyBMbD6EaVhPa4+oBF53tH5V7SsxjSz8Z+F3+U5ry4fVRZRNyt
         Y7hd/pg81tt5BQRJvxLbJhCV0vSNJ7frHdJcxpfH16VKWZnY9rR6nhK9WW5j15lEXdOj
         M8nqxK3BartLRunQJlWBqq3UC29RrfsZ5SI6cscCd00D2yTEHHzSkZo1zOWKlOWyhTDR
         r+bSzLUIUy6r6HKLbUczUor1COG771NqkUgOsLa+6NzCGcKj1ZgjEuIvBp/zS8oINo1D
         QFKg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=PuqrKgkF0BrpsdGgHmBbhhU4JgPZ23Ju60Td0HEhJIQ=;
        b=EfIgef5ZRvMAXF1mj/+7MXXv2oGi61dmOy1Z0jQ7nx6HTXD3Yksr+ooWnm+EirV6WJ
         3Gz3kxP+kOo8PMqAOJx9ufNo9lYuSEJdaaAUryiFgL64xdZEoMI8MTU/gutginyosAZK
         2P7mmDcpvolJ/fMsg0nNwlIdvZr/HuAgpZmi/+RSp42xzHhbCcO8gA12Wvqr96pb5wti
         I5/0NIjzAnmaTUrhClyZmDZTm+FU+bc45EgOCgJ9f90tMhv41Ra1xjXlaWNz7T1m/eWq
         dM/RXsBTq0r1vlH48gocR4d7QXISLP4Jnai10GKDX7+dztSca6c8qYRMunIQ5N3egHXn
         zarw==
X-Gm-Message-State: AJIora+YN1gwjotj2ylWDILZm2thT2vKDaqnUdzkXdPMZIRAS4DbU/Vt
        o2w9N/z0SGYGhL/y3RJ5glrfHeGUqLAgVdys
X-Google-Smtp-Source: AGRyM1tczPE4sGwzSudLMzD9sQNEe3Y+CLgNMMNKxSI6LfSVovHwRqTawUfZTiY9pLdlMHlHxY17LA==
X-Received: by 2002:a05:6638:3a07:b0:33d:1340:8ac4 with SMTP id cn7-20020a0566383a0700b0033d13408ac4mr20350954jab.113.1657078891536;
        Tue, 05 Jul 2022 20:41:31 -0700 (PDT)
Received: from didactylos.localdomain ([2600:1700:57f0:ca20:763a:c795:fcf6:91ea])
        by smtp.gmail.com with ESMTPSA id z6-20020a05660217c600b006692192baf7sm16427854iox.25.2022.07.05.20.41.30
        for <io-uring@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 05 Jul 2022 20:41:31 -0700 (PDT)
From:   Eli Schwartz <eschwartz93@gmail.com>
To:     io-uring@vger.kernel.org
Subject: [PATCH liburing 1/6] tests: do not report an error message when return ret that might be a skip
Date:   Tue,  5 Jul 2022 23:40:53 -0400
Message-Id: <20220706034059.2817423-2-eschwartz93@gmail.com>
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

We are going to update these functions to distinguish between pass/skip,
so ret might be nonzero but have handled its own non-error message.

Signed-off-by: Eli Schwartz <eschwartz93@gmail.com>
---
 test/fallocate.c   | 8 ++++++--
 test/file-update.c | 4 +++-
 2 files changed, 9 insertions(+), 3 deletions(-)

diff --git a/test/fallocate.c b/test/fallocate.c
index 6cb57e0..a9bf6fd 100644
--- a/test/fallocate.c
+++ b/test/fallocate.c
@@ -230,7 +230,9 @@ int main(int argc, char *argv[])
 
 	ret = test_fallocate(&ring);
 	if (ret) {
-		fprintf(stderr, "test_fallocate failed\n");
+		if (ret != T_EXIT_SKIP) {
+			fprintf(stderr, "test_fallocate failed\n");
+		}
 		return ret;
 	}
 
@@ -242,7 +244,9 @@ int main(int argc, char *argv[])
 
 	ret = test_fallocate_rlimit(&ring);
 	if (ret) {
-		fprintf(stderr, "test_fallocate_rlimit failed\n");
+		if (ret != T_EXIT_SKIP) {
+			fprintf(stderr, "test_fallocate_rlimit failed\n");
+		}
 		return ret;
 	}
 
diff --git a/test/file-update.c b/test/file-update.c
index 97db95a..b8039c9 100644
--- a/test/file-update.c
+++ b/test/file-update.c
@@ -165,7 +165,9 @@ int main(int argc, char *argv[])
 
 	ret = test_sqe_update(&r1);
 	if (ret) {
-		fprintf(stderr, "test_sqe_update failed\n");
+		if (ret != T_EXIT_SKIP) {
+			fprintf(stderr, "test_sqe_update failed\n");
+		}
 		return ret;
 	}
 
-- 
2.35.1

