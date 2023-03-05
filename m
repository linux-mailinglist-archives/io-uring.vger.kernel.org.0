Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CA5646AAE47
	for <lists+io-uring@lfdr.de>; Sun,  5 Mar 2023 06:18:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229561AbjCEFSI (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sun, 5 Mar 2023 00:18:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36172 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229489AbjCEFSH (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sun, 5 Mar 2023 00:18:07 -0500
Received: from mail-wm1-x32c.google.com (mail-wm1-x32c.google.com [IPv6:2a00:1450:4864:20::32c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 97665A5F7
        for <io-uring@vger.kernel.org>; Sat,  4 Mar 2023 21:18:06 -0800 (PST)
Received: by mail-wm1-x32c.google.com with SMTP id d41-20020a05600c4c2900b003e9e066550fso3376514wmp.4
        for <io-uring@vger.kernel.org>; Sat, 04 Mar 2023 21:18:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=fA7/K+Vze4hmrlBZHBIX5f/ICsXE8EjaToWL73cOBGc=;
        b=RM9dnAbOKgYbHNcn0HFeLlsrikZ9/sHzotvXzyZs6ZMYEFCuyzF4hbnRYgU8EztnZA
         PGi0jFEfkx3gyhrMyMNcoF5NSlRD0HEEcfuuOf4NTFhf/xs1uGNYMRUNDU2k38aJhCEb
         prrsRN0lDJvx/zzXg7nDaFifEBj35LfBI38LZi5iOnaVrfzMA32sMCzbmvV0AQwEyPIa
         1FQBkEQ1H9mAFMYccT/4QSX/u4LSsee+aPhaEmBPtBAuDloBXgggXONKLJoTbv06zcu1
         v/noQOHimXJFlRrBS/2g4fHfI1RSnzm6V2/21YQlilhl0R2aGoGiWIHu3BXnec40OYjb
         Le5g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=fA7/K+Vze4hmrlBZHBIX5f/ICsXE8EjaToWL73cOBGc=;
        b=RmOC/nuRM4Ye6dTM+p04CGfKeaGn/gd+2ktR9K+IpdXFiasFjcwAxvtQOpzpF/a0Sw
         y+pZn4yl2nIHyrmV4ALS+lNyLmmmRSKK4XsF48cDqYKbKEziR0BkT7CsBifZAUlZ/T3b
         WOB87YsuBaecKca3cERzN5LN51RHlPRUsMkakbE0gSohh2u1i7xfS7gwjHtBq3ckDCR4
         k6fnqqc50n9UPQ/JWoBF1qGPgTNVsVidqM9jAOM4aMwMJQ+4+P6w5qNu976XNVxYt6ou
         NfSlAq7MiRlFl5hs0HkydtSlHDbjquNhy/+7iK4H4uoSyxeRIbvuUmt5m6CsS9svePxQ
         Uz6A==
X-Gm-Message-State: AO0yUKV4fqGCtVwFQgF7wNON7JltJwLZRU3WP7tm8JoKzuxJ/YXosYcU
        0bZbbU9Pa+xKMo54esoAp9d7Q/4vJ4M=
X-Google-Smtp-Source: AK7set93Lngab46Qes95eVazQXJovQgHLdQ0X0l1YqVUd7XMt/pN7zMw0B2lVDOiGhKClTQdMEFhVQ==
X-Received: by 2002:a05:600c:a06:b0:3ea:ed4d:38f6 with SMTP id z6-20020a05600c0a0600b003eaed4d38f6mr6065469wmp.4.1677993483960;
        Sat, 04 Mar 2023 21:18:03 -0800 (PST)
Received: from 127.0.0.1localhost (94.196.92.184.threembb.co.uk. [94.196.92.184])
        by smtp.gmail.com with ESMTPSA id c40-20020a05600c4a2800b003eb20d4d4a8sm6606120wmp.44.2023.03.04.21.18.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 04 Mar 2023 21:18:03 -0800 (PST)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     io-uring@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>, asml.silence@gmail.com
Subject: [PATCH liburing 1/1] tests/fd-pass: close rings
Date:   Sun,  5 Mar 2023 05:16:57 +0000
Message-Id: <2514ac14bffdffe0a78fd51c41698deb20d54cc4.1677993404.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.39.1
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

Don't leak rings from test(), we call it several times and have a good
number of open rings lingering during the test for no good reason.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 test/fd-pass.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/test/fd-pass.c b/test/fd-pass.c
index 245495c..f3ede77 100644
--- a/test/fd-pass.c
+++ b/test/fd-pass.c
@@ -161,6 +161,8 @@ static int test(const char *filename, int source_fd, int target_fd)
 	if (verify_fixed_read(&dring, target_fd, 0))
 		return T_EXIT_FAIL;
 
+	io_uring_queue_exit(&sring);
+	io_uring_queue_exit(&dring);
 	return T_EXIT_PASS;
 }
 
-- 
2.39.1

