Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6063C561DDD
	for <lists+io-uring@lfdr.de>; Thu, 30 Jun 2022 16:28:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235716AbiF3O1u (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 30 Jun 2022 10:27:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36032 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237231AbiF3O1c (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 30 Jun 2022 10:27:32 -0400
Received: from mail-wr1-x42a.google.com (mail-wr1-x42a.google.com [IPv6:2a00:1450:4864:20::42a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2017F7BD12
        for <io-uring@vger.kernel.org>; Thu, 30 Jun 2022 07:11:00 -0700 (PDT)
Received: by mail-wr1-x42a.google.com with SMTP id i25so21988594wrc.13
        for <io-uring@vger.kernel.org>; Thu, 30 Jun 2022 07:10:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=g5eL2S5tzNaGAY7wK7p0NilJ83pONxXsgwXX15Q/gZE=;
        b=q1T049KxKm9YY9lx1FbkrpRt3OryvlkVmLAJo5WD8U4io+k2+owrQkCmgZTUP6l0qL
         3IOkAQJ+t4vAN61szcxPuV682zOL+GXYZq8judfwsBeKREth0DR55rQPDe87hGh1LTuA
         KVu4HN2oFPpM9QurEgLCPIodljahiS1y12tia3qVd3tohqiiPfO8WHDXhamGitHxqEvt
         plNx/P7iJutBBn/rtVl6zDd7ZM+aW4hI6JYxEyurNX5JiV0KiIp16S7sJtIn1QxdsPW8
         h0B3fEHPVv0V11B5HRaRPb+nAqanzU9i/w6yBxthhba4m9CoDEWDmKPuFkXckpQXRacO
         rHow==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=g5eL2S5tzNaGAY7wK7p0NilJ83pONxXsgwXX15Q/gZE=;
        b=IEliM5wMOG+J71Jz959S4sma0ZSZIoQLxtHY67V3bEuzE+hnQ7/OAO7TJpmTB2IuvG
         znmedAfhjFwfsGItq/lOimOUUWsCJpWMmLOV3erpv0eQR9iArTCGyGTEs4RfUfCZOUaH
         VvJZdpU5luDPbbSaD/EaVzljG3LDH/B7JfC9qQWoPrEkHfOoYghgqQKNViXQYmF28K6j
         Yz4oOrOCK4HT2A7eIQITGoUMnt893O8uQl//A8lrQeBYbv/LDV16p0csBsxQRLJyD3be
         hhWrkqMCxbmA1N4u1iPXdLcwVfA4IwV36y586DfW+hSJwQ3EFg2M3OaBumEispAfeajg
         nCaw==
X-Gm-Message-State: AJIora/OIgfX9OwgWB8jBF8lel0l3PhAD33jmFf/2XxRIFtpf6/aSQwl
        ldB74gW6WttJH3C7x4ReFfy3ogm3iLO6oQ==
X-Google-Smtp-Source: AGRyM1tptsiNqpamvjxiNGi/d/Sl3W6Idsfbxk6Z3h3GfULIXQN9NZgK2HmO4DVGTVNJmxoxojqm5A==
X-Received: by 2002:a5d:470c:0:b0:21b:812e:1b70 with SMTP id y12-20020a5d470c000000b0021b812e1b70mr8348868wrq.147.1656598241893;
        Thu, 30 Jun 2022 07:10:41 -0700 (PDT)
Received: from 127.0.0.1localhost (82-132-232-9.dab.02.net. [82.132.232.9])
        by smtp.gmail.com with ESMTPSA id ay29-20020a05600c1e1d00b003a03be171b1sm3741392wmb.43.2022.06.30.07.10.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 30 Jun 2022 07:10:41 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     io-uring@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>, asml.silence@gmail.com
Subject: [PATCH liburing v2 4/5] tests: print file-register errors to stderr
Date:   Thu, 30 Jun 2022 15:10:16 +0100
Message-Id: <83964670becc86df23d1db74b6429337c87e3c9f.1656597976.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <cover.1656597976.git.asml.silence@gmail.com>
References: <cover.1656597976.git.asml.silence@gmail.com>
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
 test/file-register.c | 36 ++++++++++++++++++------------------
 1 file changed, 18 insertions(+), 18 deletions(-)

diff --git a/test/file-register.c b/test/file-register.c
index 6a9cbb1..4004a81 100644
--- a/test/file-register.c
+++ b/test/file-register.c
@@ -840,31 +840,31 @@ int main(int argc, char *argv[])
 
 	ret = io_uring_queue_init(8, &ring, 0);
 	if (ret) {
-		printf("ring setup failed\n");
+		fprintf(stderr, "ring setup failed\n");
 		return T_EXIT_FAIL;
 	}
 
 	ret = test_basic(&ring, 0);
 	if (ret) {
-		printf("test_basic failed\n");
+		fprintf(stderr, "test_basic failed\n");
 		return T_EXIT_FAIL;
 	}
 
 	ret = test_basic(&ring, 1);
 	if (ret) {
-		printf("test_basic failed\n");
+		fprintf(stderr, "test_basic failed\n");
 		return T_EXIT_FAIL;
 	}
 
 	ret = test_basic_many(&ring);
 	if (ret) {
-		printf("test_basic_many failed\n");
+		fprintf(stderr, "test_basic_many failed\n");
 		return T_EXIT_FAIL;
 	}
 
 	ret = test_sparse(&ring);
 	if (ret) {
-		printf("test_sparse failed\n");
+		fprintf(stderr, "test_sparse failed\n");
 		return T_EXIT_FAIL;
 	}
 
@@ -873,79 +873,79 @@ int main(int argc, char *argv[])
 
 	ret = test_additions(&ring);
 	if (ret) {
-		printf("test_additions failed\n");
+		fprintf(stderr, "test_additions failed\n");
 		return T_EXIT_FAIL;
 	}
 
 	ret = test_removals(&ring);
 	if (ret) {
-		printf("test_removals failed\n");
+		fprintf(stderr, "test_removals failed\n");
 		return T_EXIT_FAIL;
 	}
 
 	ret = test_replace(&ring);
 	if (ret) {
-		printf("test_replace failed\n");
+		fprintf(stderr, "test_replace failed\n");
 		return T_EXIT_FAIL;
 	}
 
 	ret = test_replace_all(&ring);
 	if (ret) {
-		printf("test_replace_all failed\n");
+		fprintf(stderr, "test_replace_all failed\n");
 		return T_EXIT_FAIL;
 	}
 
 	ret = test_grow(&ring);
 	if (ret) {
-		printf("test_grow failed\n");
+		fprintf(stderr, "test_grow failed\n");
 		return T_EXIT_FAIL;
 	}
 
 	ret = test_shrink(&ring);
 	if (ret) {
-		printf("test_shrink failed\n");
+		fprintf(stderr, "test_shrink failed\n");
 		return T_EXIT_FAIL;
 	}
 
 	ret = test_zero(&ring);
 	if (ret) {
-		printf("test_zero failed\n");
+		fprintf(stderr, "test_zero failed\n");
 		return T_EXIT_FAIL;
 	}
 
 	ret = test_huge(&ring);
 	if (ret) {
-		printf("test_huge failed\n");
+		fprintf(stderr, "test_huge failed\n");
 		return T_EXIT_FAIL;
 	}
 
 	ret = test_skip(&ring);
 	if (ret) {
-		printf("test_skip failed\n");
+		fprintf(stderr, "test_skip failed\n");
 		return T_EXIT_FAIL;
 	}
 
 	ret = test_sparse_updates();
 	if (ret) {
-		printf("test_sparse_updates failed\n");
+		fprintf(stderr, "test_sparse_updates failed\n");
 		return T_EXIT_FAIL;
 	}
 
 	ret = test_fixed_removal_ordering();
 	if (ret) {
-		printf("test_fixed_removal_ordering failed\n");
+		fprintf(stderr, "test_fixed_removal_ordering failed\n");
 		return T_EXIT_FAIL;
 	}
 
 	ret = test_mixed_af_unix();
 	if (ret) {
-		printf("test_mixed_af_unix failed\n");
+		fprintf(stderr, "test_mixed_af_unix failed\n");
 		return T_EXIT_FAIL;
 	}
 
 	ret = test_partial_register_fail();
 	if (ret) {
-		printf("test_partial_register_fail failed\n");
+		fprintf(stderr, "test_partial_register_fail failed\n");
 		return T_EXIT_FAIL;
 	}
 
-- 
2.36.1

