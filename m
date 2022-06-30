Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A96F4561DDE
	for <lists+io-uring@lfdr.de>; Thu, 30 Jun 2022 16:28:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235776AbiF3O1u (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 30 Jun 2022 10:27:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36022 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237229AbiF3O1c (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 30 Jun 2022 10:27:32 -0400
Received: from mail-wr1-x436.google.com (mail-wr1-x436.google.com [IPv6:2a00:1450:4864:20::436])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4C2B0970E0
        for <io-uring@vger.kernel.org>; Thu, 30 Jun 2022 07:11:00 -0700 (PDT)
Received: by mail-wr1-x436.google.com with SMTP id i25so21988488wrc.13
        for <io-uring@vger.kernel.org>; Thu, 30 Jun 2022 07:11:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=9SES2uJe1XQEEw4lFujdU37YT/Twd7J82sjSG5PHuJQ=;
        b=YlyJOch6waf9fb6yXVp/C/KnWAKo755q3m/Oj92f65wcX9KSPv1nj5OXAyoNXvED0v
         LDndkR3GoiNtqFCvi1ARFi/6iDrQhv8lDrzVDTyz7GV+sejBVMRjDZLzXK2z1oFbz6sS
         slpOp6ilaXm0ihaHnarnnzZ1oIMph9Gqozb0otVk0iyvNWItZBEQRqWoEIaNTdfIur/X
         BFfQ1dG6Sl6MgGPZm2dqLnDcjlh6tKFbHkHqVwTm3exPjtn732pEmLtEwnEqaQqyZI67
         +xmseaVMKp/B8fmRIroTiJbsuk4NmokTmnfDg0LKCHpCiGpAmqHTyoj4ltsJfbpuMSvq
         +Cbg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=9SES2uJe1XQEEw4lFujdU37YT/Twd7J82sjSG5PHuJQ=;
        b=XCHv5iUjSQDJyzi/18di8RJuQRGHWA5IguNyqYwBzCxWW1C4EVBPr+CD0aqS/r/4hF
         F5EPRzZ4h6E39fgu20Tx8/9LvzoLWuVkyOqOCu5wfMLZIdxIH1h2TQ6ofHq0bFl7O+j1
         yjYcQON6/Gaf1xzyo6AsNiclCyV6CVqzAHz4Kb3BlvCLgwEkCdi5srP6aAa9kFuXAaKl
         qIXDTR6qM0E+2258dPKe770yBucxpqKDVmw+eNWY47jg9j5cb5Lr03RaL2bT+Vh1pWDp
         5n/DOb4cMRU5wREBEEtcNec5eyqog5ZBwTVNb0Pz2GAfAzQVwWQ+pq2OYGcBpaSutovq
         J8Hg==
X-Gm-Message-State: AJIora8+sqwYxlBCuzJZMV1yatR0du6G40XtCrO4c9MflnN3/BrSu5rx
        tNwBgMw5DoJIvVMAS4J4xdfxTPDRu445Zg==
X-Google-Smtp-Source: AGRyM1tlDa1WIBO2YnA8OaRVNvTcEFArxaI8jNIQrxTPY++fkJxYu4iAuJ49DIUtI2GxMybFTZAlaA==
X-Received: by 2002:a5d:5c03:0:b0:21b:90e6:42bc with SMTP id cc3-20020a5d5c03000000b0021b90e642bcmr9056898wrb.36.1656598240597;
        Thu, 30 Jun 2022 07:10:40 -0700 (PDT)
Received: from 127.0.0.1localhost (82-132-232-9.dab.02.net. [82.132.232.9])
        by smtp.gmail.com with ESMTPSA id ay29-20020a05600c1e1d00b003a03be171b1sm3741392wmb.43.2022.06.30.07.10.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 30 Jun 2022 07:10:40 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     io-uring@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>, asml.silence@gmail.com
Subject: [PATCH liburing v2 3/5] file-register: fix return codes
Date:   Thu, 30 Jun 2022 15:10:15 +0100
Message-Id: <758c2ea5ceb0de6f8b4be66c0dcda79b7a7aed8d.1656597976.git.asml.silence@gmail.com>
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

Use T_EXIT* in file-register.c

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 test/file-register.c | 28 ++++++++++++++--------------
 1 file changed, 14 insertions(+), 14 deletions(-)

diff --git a/test/file-register.c b/test/file-register.c
index cd00a90..6a9cbb1 100644
--- a/test/file-register.c
+++ b/test/file-register.c
@@ -847,25 +847,25 @@ int main(int argc, char *argv[])
 	ret = test_basic(&ring, 0);
 	if (ret) {
 		printf("test_basic failed\n");
-		return ret;
+		return T_EXIT_FAIL;
 	}
 
 	ret = test_basic(&ring, 1);
 	if (ret) {
 		printf("test_basic failed\n");
-		return ret;
+		return T_EXIT_FAIL;
 	}
 
 	ret = test_basic_many(&ring);
 	if (ret) {
 		printf("test_basic_many failed\n");
-		return ret;
+		return T_EXIT_FAIL;
 	}
 
 	ret = test_sparse(&ring);
 	if (ret) {
 		printf("test_sparse failed\n");
-		return ret;
+		return T_EXIT_FAIL;
 	}
 
 	if (no_update)
@@ -874,49 +874,49 @@ int main(int argc, char *argv[])
 	ret = test_additions(&ring);
 	if (ret) {
 		printf("test_additions failed\n");
-		return ret;
+		return T_EXIT_FAIL;
 	}
 
 	ret = test_removals(&ring);
 	if (ret) {
 		printf("test_removals failed\n");
-		return ret;
+		return T_EXIT_FAIL;
 	}
 
 	ret = test_replace(&ring);
 	if (ret) {
 		printf("test_replace failed\n");
-		return ret;
+		return T_EXIT_FAIL;
 	}
 
 	ret = test_replace_all(&ring);
 	if (ret) {
 		printf("test_replace_all failed\n");
-		return ret;
+		return T_EXIT_FAIL;
 	}
 
 	ret = test_grow(&ring);
 	if (ret) {
 		printf("test_grow failed\n");
-		return ret;
+		return T_EXIT_FAIL;
 	}
 
 	ret = test_shrink(&ring);
 	if (ret) {
 		printf("test_shrink failed\n");
-		return ret;
+		return T_EXIT_FAIL;
 	}
 
 	ret = test_zero(&ring);
 	if (ret) {
 		printf("test_zero failed\n");
-		return ret;
+		return T_EXIT_FAIL;
 	}
 
 	ret = test_huge(&ring);
 	if (ret) {
 		printf("test_huge failed\n");
-		return ret;
+		return T_EXIT_FAIL;
 	}
 
 	ret = test_skip(&ring);
@@ -928,7 +928,7 @@ int main(int argc, char *argv[])
 	ret = test_sparse_updates();
 	if (ret) {
 		printf("test_sparse_updates failed\n");
-		return ret;
+		return T_EXIT_FAIL;
 	}
 
 	ret = test_fixed_removal_ordering();
@@ -946,7 +946,7 @@ int main(int argc, char *argv[])
 	ret = test_partial_register_fail();
 	if (ret) {
 		printf("test_partial_register_fail failed\n");
-		return ret;
+		return T_EXIT_FAIL;
 	}
 
 	return T_EXIT_PASS;
-- 
2.36.1

