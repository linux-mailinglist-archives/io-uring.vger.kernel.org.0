Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9FC89678D5C
	for <lists+io-uring@lfdr.de>; Tue, 24 Jan 2023 02:24:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232357AbjAXBYV (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 23 Jan 2023 20:24:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51544 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232549AbjAXBYR (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 23 Jan 2023 20:24:17 -0500
Received: from mail-wr1-x42b.google.com (mail-wr1-x42b.google.com [IPv6:2a00:1450:4864:20::42b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 60AAEA5C1
        for <io-uring@vger.kernel.org>; Mon, 23 Jan 2023 17:23:50 -0800 (PST)
Received: by mail-wr1-x42b.google.com with SMTP id y1so7966440wru.2
        for <io-uring@vger.kernel.org>; Mon, 23 Jan 2023 17:23:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=KcbXSoJyVOwwyi4rwKO5FmJttg2V1r5VL9ydicqAb1k=;
        b=Xb5Mw4DU99AjpgZJgxkowaMadQ7seNzfeKu3WHPjYv/IaW0lgDpMMpkuEccgE5oKYj
         7MZEDpygC0CQCeTJT652ukHZaP2dPepBz0RM2obvbJ/yYXuVHbiytciXdTV6ybmUuaJ/
         9WidVdIbm81pRZmV0M3thTUAdZ9VPnq3TRAAHWG65dTQHZWtONN3zCBKYVhTm1uy1jpI
         1CmUfz3Afhw+T6cj9Ez3FTfjiAaxGN6eRweWBliOkx+xY1/adern4EpIVKBFVhYnuCX+
         u7Wf6QIDv0x8zfMyx110k9Q5k/HvBAqHn4PPrGpJx4ugLOVcUcUZbh5PDtVtA4KC0/G3
         SnpA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=KcbXSoJyVOwwyi4rwKO5FmJttg2V1r5VL9ydicqAb1k=;
        b=okdGP17082S9Jq5aaIfxLz6RKxmpEgEjvtaz/HfCJAgWpVTN5qbPiIjJ2B0U62sAgA
         ltJBgJ7jJXUBFnZx3++/7UIolCFS7MlXEzWdeMjvG7v/6LJOZcM0b04/XqX1Hm5U+7ty
         N6tXIaO7SML8pcXb1BJdcBN7AEQCQsS41zu2SPejjcm9k39JxHe8mzsfJsPotWiBIeAU
         KhvxXeZyrbqjqsQ3dnM9c7TBnBcdzrT89L3sinV63eKL5zg84y3YiZTcHztMVMfudMTE
         IhybAN7UEVmimeh0GdZXXdDYYofdtaril+9t+axs2XMF2MIUvOZHTPIQBmd7ot1J5//t
         fH1Q==
X-Gm-Message-State: AFqh2kqI6zbX4GNJ0mUhh6LcgfVOctmYWn1rJLRJtsHbeAwel/RScrqR
        4gYP9hJCz/84VQG9OkzO8CuMv9bA5mQ=
X-Google-Smtp-Source: AMrXdXvJYcAaeUKWHkGpvtzDWHnWqkBhFhW8WQUMXOqEUfszAdv4CmjFANXaP5O3g45eqKm2onnfwQ==
X-Received: by 2002:a5d:5a8f:0:b0:2be:53cc:ca5c with SMTP id bp15-20020a5d5a8f000000b002be53ccca5cmr14467149wrb.15.1674523425702;
        Mon, 23 Jan 2023 17:23:45 -0800 (PST)
Received: from 127.0.0.1localhost (92.41.37.76.threembb.co.uk. [92.41.37.76])
        by smtp.gmail.com with ESMTPSA id t20-20020adfa2d4000000b002bdcce37d31sm712912wra.99.2023.01.23.17.23.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 23 Jan 2023 17:23:45 -0800 (PST)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     io-uring@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>, asml.silence@gmail.com
Subject: [PATCH liburing 1/5] tests/msg_ring: use correct exit codes
Date:   Tue, 24 Jan 2023 01:21:45 +0000
Message-Id: <8e94289f8cff49740b5adaeb981fe58551d4f490.1674523156.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <cover.1674523156.git.asml.silence@gmail.com>
References: <cover.1674523156.git.asml.silence@gmail.com>
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

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 test/msg-ring.c | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/test/msg-ring.c b/test/msg-ring.c
index a825bf9..afe3192 100644
--- a/test/msg-ring.c
+++ b/test/msg-ring.c
@@ -220,27 +220,27 @@ int main(int argc, char *argv[])
 	ret = test_own(&ring);
 	if (ret) {
 		fprintf(stderr, "test_own failed\n");
-		return ret;
+		return T_EXIT_FAIL;
 	}
 	if (no_msg)
 		return T_EXIT_SKIP;
 	ret = test_own(&pring);
 	if (ret) {
 		fprintf(stderr, "test_own iopoll failed\n");
-		return ret;
+		return T_EXIT_FAIL;
 	}
 
 	ret = test_invalid(&ring, 0);
 	if (ret) {
 		fprintf(stderr, "test_invalid failed\n");
-		return ret;
+		return T_EXIT_FAIL;
 	}
 
 	for (i = 0; i < 2; i++) {
 		ret = test_invalid(&ring, 1);
 		if (ret) {
 			fprintf(stderr, "test_invalid fixed failed\n");
-			return ret;
+			return T_EXIT_FAIL;
 		}
 	}
 
@@ -249,7 +249,7 @@ int main(int argc, char *argv[])
 	ret = test_remote(&ring, &ring2);
 	if (ret) {
 		fprintf(stderr, "test_remote failed\n");
-		return ret;
+		return T_EXIT_FAIL;
 	}
 
 	pthread_join(thread, &tret);
-- 
2.38.1

