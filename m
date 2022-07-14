Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A19C35752DB
	for <lists+io-uring@lfdr.de>; Thu, 14 Jul 2022 18:33:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239142AbiGNQdM (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 14 Jul 2022 12:33:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59716 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231500AbiGNQdL (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 14 Jul 2022 12:33:11 -0400
Received: from mail-ed1-x52d.google.com (mail-ed1-x52d.google.com [IPv6:2a00:1450:4864:20::52d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F3FB8655BE;
        Thu, 14 Jul 2022 09:33:10 -0700 (PDT)
Received: by mail-ed1-x52d.google.com with SMTP id y4so3132436edc.4;
        Thu, 14 Jul 2022 09:33:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=KKGLBgoJENP1ndNirJV7mLartfrtHoCd/+TqG/AV5qY=;
        b=TWc/HlV7tLW63L6eBsecKG7ffiJp5KmdklZzPVp52OOlajkhFqdxQBiO/arOmuBy+U
         jp10Pn3Qh2AaMcNlY2rcn3adC4xNRsOAK0/goL7EoOIhRS1cPRYgDpEqF0jECZGZWwH/
         6L/6GoY3nM/oGaoMOXlo83InapnSkCMH+iGytkca9C1ke7Dm7TXOJLCSly8zLUTfygVO
         /Q7fpEK+Yy7EpHIC3xyS2HztCbijfO7/tEdSby5aU3eQniSB7os4PBE4QqGCifc0/Lef
         sZAeRZsvoakNsyHEw9cjkRAfo62eEuHVjQ7WOFvO6OhiCvhxvG8tb/XDVtVQW8r/Pd1X
         I7qA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=KKGLBgoJENP1ndNirJV7mLartfrtHoCd/+TqG/AV5qY=;
        b=ERssPa4ltsLYSnh1C9D5wJDHZsX2RTh28XMsGJhv1phB2hCXaw1EoH9IHJ9T7vhJSl
         kpq9pM/NP0ejO1SbPIHm5uWEJni7kJHQbtXmXnp5c15AfAy/7oMKRJ3j6MO1Gp1nGgIp
         9jNEyB3/EZLtO67vDRyQkix3RbrAOdS3qxpXZcuhVCvVc4R0Pea37+ZhUA3QDJOrbUED
         b67ErkMX4dIZ+xlGcyf9Ap4HqfTO6+ea2acyFufjQXNhm6kx/NZkXuAMVTh3V4Wh7P0e
         c56gyqrw291OG9pUNnqn7CLo2W7g1bp+2rUE582b+gV6ihVWIeRVCuQJ1qJMi/6ehusS
         MxPw==
X-Gm-Message-State: AJIora/bFkAP3AHEwfNGFhVDgNW37qFRw4lewdnAj/UVywEsBJKyYnY/
        51t2j34dEmVMVFBVGv8uFn0O+IYcVM8=
X-Google-Smtp-Source: AGRyM1tsh9pFzJTqkVz9D0nqsNb4uGzzg7MShuzr3IgiW57if2wZoqh2oINU2uJ1UtkIJS/+yPl4uQ==
X-Received: by 2002:a05:6402:3202:b0:43a:86f5:a930 with SMTP id g2-20020a056402320200b0043a86f5a930mr13173571eda.389.1657816389164;
        Thu, 14 Jul 2022 09:33:09 -0700 (PDT)
Received: from localhost.localdomain ([46.248.82.114])
        by smtp.gmail.com with ESMTPSA id lr3-20020a170906fb8300b006feb479fcb4sm877682ejb.44.2022.07.14.09.33.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 14 Jul 2022 09:33:08 -0700 (PDT)
From:   Uros Bizjak <ubizjak@gmail.com>
To:     io-uring@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     Uros Bizjak <ubizjak@gmail.com>, Jens Axboe <axboe@kernel.dk>,
        Pavel Begunkov <asml.silence@gmail.com>
Subject: [PATCH] io_uring: Use atomic_long_try_cmpxchg in __io_account_mem
Date:   Thu, 14 Jul 2022 18:33:01 +0200
Message-Id: <20220714163301.67794-1-ubizjak@gmail.com>
X-Mailer: git-send-email 2.35.3
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

Use atomic_long_try_cmpxchg instead of
atomic_long_cmpxchg (*ptr, old, new) == old in __io_account_mem.
x86 CMPXCHG instruction returns success in ZF flag, so this
change saves a compare after cmpxchg (and related move
instruction in front of cmpxchg).

Also, atomic_long_try_cmpxchg implicitly assigns old *ptr value
to "old" when cmpxchg fails, enabling further code simplifications.

No functional change intended.

Signed-off-by: Uros Bizjak <ubizjak@gmail.com>
Cc: Jens Axboe <axboe@kernel.dk>
Cc: Pavel Begunkov <asml.silence@gmail.com>
---
 fs/io_uring.c | 7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index a01ea49f3017..9f82904dcdae 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -10504,14 +10504,13 @@ static inline int __io_account_mem(struct user_struct *user,
 	/* Don't allow more pages than we can safely lock */
 	page_limit = rlimit(RLIMIT_MEMLOCK) >> PAGE_SHIFT;
 
+	cur_pages = atomic_long_read(&user->locked_vm);
 	do {
-		cur_pages = atomic_long_read(&user->locked_vm);
 		new_pages = cur_pages + nr_pages;
 		if (new_pages > page_limit)
 			return -ENOMEM;
-	} while (atomic_long_cmpxchg(&user->locked_vm, cur_pages,
-					new_pages) != cur_pages);
-
+	} while (!atomic_long_try_cmpxchg(&user->locked_vm,
+					  &cur_pages, new_pages));
 	return 0;
 }
 
-- 
2.35.3

