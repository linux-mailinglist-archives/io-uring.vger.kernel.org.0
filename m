Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 50DF64E7907
	for <lists+io-uring@lfdr.de>; Fri, 25 Mar 2022 17:38:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239489AbiCYQjf (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 25 Mar 2022 12:39:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33212 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235828AbiCYQje (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 25 Mar 2022 12:39:34 -0400
Received: from mail-ej1-x634.google.com (mail-ej1-x634.google.com [IPv6:2a00:1450:4864:20::634])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5404864BDA
        for <io-uring@vger.kernel.org>; Fri, 25 Mar 2022 09:38:00 -0700 (PDT)
Received: by mail-ej1-x634.google.com with SMTP id a8so16420861ejc.8
        for <io-uring@vger.kernel.org>; Fri, 25 Mar 2022 09:38:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=famMtC1njLlAOWSU4kiqjz8a6YmzTBeOfix+j4vPp/8=;
        b=qHQwiOBJZFn3vKDey8UMA6gthMfMpwXxejQQLcwJ8i50c5E4DeRLGNgO7Jp8Is42uD
         XK8bfpJ9rUvp1u91rs48Df9/aeNopYoI5uuMlBe/uQMZdaHxpwzov28pXGJomHFa7MZE
         UAUi/No7sKdH+O6F9fwV76XE+VrlCwFGWbW+pH7sXEdUcoAZ4yh4rVRy9ryeA42Qa4LE
         2iilcrZ5stXmYdZBZAj+CQmA/uBe5I0ssbgopBaw+hz/dCUGEBOhSAiHOxuadDctd9Od
         6Ucu1JSYOUxlH3q0nQoMtyjg1NCWeJ0If61f02Mf2xobb3O2WyiaYnZNP0rAKNtTX8SG
         LHXg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=famMtC1njLlAOWSU4kiqjz8a6YmzTBeOfix+j4vPp/8=;
        b=PxVOyWsXUuqF2PnTa6cE1vBAUcSYdfENADKWT+QBaGg32xDrH86SmGIqSp4rQA6oJU
         gTr6efDmm44cO9l6y3Vk/L8yxGlnuQH53sLWdDoZ8QG/Ek0OXgxUaO8w/t8Kb8HTYpht
         y7jke8atPr3IgIxkFrg9DQUa7VK2YykGaK/qmPPBzyU4j3eI+6RgblG8ZiFkrBooZW8h
         HGwfTs96C/q33188h82qHq1RZqJj5VsLZBQ6NhKZW8UhfchUB98tvteEWTuwNx4WaVmU
         qda2Jllt97KGD8G+H1yohu7nHfQCqWeRhdStNi+5S0erT7jIL/TGfsbmJfJ6Q/Ek7vhQ
         jkfw==
X-Gm-Message-State: AOAM533ZVDmhrvVH2PRA0YOxDslc0wIqQoD1U+0crMyColGg5MHPgB2J
        67xQb0JwcV5wYttvVcRHBDwNKCh6FYqm0g==
X-Google-Smtp-Source: ABdhPJxO5M9hCyUasrPfrboZ6CtR6AtF8dQYpVdxrGM/DCty/TQOpVJB4YSaI+x+BsT2RyeLogwbGw==
X-Received: by 2002:a17:906:9c8e:b0:6df:f6bf:7902 with SMTP id fj14-20020a1709069c8e00b006dff6bf7902mr12445253ejc.191.1648226278611;
        Fri, 25 Mar 2022 09:37:58 -0700 (PDT)
Received: from 127.0.0.1localhost ([85.105.239.232])
        by smtp.gmail.com with ESMTPSA id dm11-20020a170907948b00b006cf488e72e3sm2488811ejc.25.2022.03.25.09.37.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 25 Mar 2022 09:37:58 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     io-uring@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>, asml.silence@gmail.com
Subject: [PATCH 5.18] io_uring: fix leaking uid in files registration
Date:   Fri, 25 Mar 2022 16:36:31 +0000
Message-Id: <accee442376f33ce8aaebb099d04967533efde92.1648226048.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.35.1
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

When there are no files for __io_sqe_files_scm() to process in the
range, it'll free everything and return. However, it forgets to put uid.

Fixes: 08a451739a9b5 ("io_uring: allow sparse fixed file sets")
Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 fs/io_uring.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index e5769287b3b8..fd53a8330f43 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -8834,6 +8834,7 @@ static int __io_sqe_files_scm(struct io_ring_ctx *ctx, int nr, int offset)
 			fput(fpl->fp[i]);
 	} else {
 		kfree_skb(skb);
+		free_uid(fpl->user);
 		kfree(fpl);
 	}
 
-- 
2.35.1

