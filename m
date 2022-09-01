Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3E2555A953D
	for <lists+io-uring@lfdr.de>; Thu,  1 Sep 2022 12:59:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233663AbiIAK6t (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 1 Sep 2022 06:58:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60908 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234329AbiIAK6c (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 1 Sep 2022 06:58:32 -0400
Received: from mail-ej1-x632.google.com (mail-ej1-x632.google.com [IPv6:2a00:1450:4864:20::632])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E8073A0268
        for <io-uring@vger.kernel.org>; Thu,  1 Sep 2022 03:58:30 -0700 (PDT)
Received: by mail-ej1-x632.google.com with SMTP id lx1so33810288ejb.12
        for <io-uring@vger.kernel.org>; Thu, 01 Sep 2022 03:58:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date;
        bh=o4tcufdk/pst//g176VGUKNoUZollqQe85tCRMFvswA=;
        b=clYbcHUd4u7CHMvt36O7Kd+dTLE0YuHKp85IVGT7FqK1N54BVmZ9ax8/sO6qRTWD7v
         88YPqntuRBKsVPoScHQSIZOlHAwq2AJulm0Uzg8HmKS21na1X9vVPYFjp9qfP5dhsyQL
         eldL3sgwGBLyaxj3tuwzK8G94OQQ9JcN3YiKdzFgqbYBMdjJdKbqaLYaY0fl8DXvHjVE
         VUeXUgf+m4RgvoaDsKrrrVyP0x7s6rY+kGBJjvFWcANVOcAcGkhxbadHBbAy6vuUB6Ke
         nUxYz/PozzsHKq5jVkqkBS6hFl0PFVko1fdDYar1oDurijbNeTDE+GgwoJ8vwhDuXlal
         HkyA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date;
        bh=o4tcufdk/pst//g176VGUKNoUZollqQe85tCRMFvswA=;
        b=pCU1Kd8DIkd/NTJcbIz5e6Ga71JmpCyrlxN6FjJLXip04Ofg6xgZzZY2mVUJzlWxn6
         /Ur/PqrmkTvvYca2oDHJuAI+UTx716P/DJOMsNidIenVnGULBNx/HYJopEg0AaBbEQNi
         +klD1puwDm29g6+bstl8dnh9Su6yiBV43ylNiUZc6QgW7CrZWJn8Erkife77qP3tcwud
         4TkN+EHWKHj2S2InCkVeOYThAZPSnaEnKueG1PVNhpa+elWAVP4aBjc34GX4QGCfRN/t
         wFaKZ586WkyfT2weqxNkdoTPfZF1G8nJYpWRxk2SxDKEQoG9J4JHHilM6c/vSNsBLywC
         0OFg==
X-Gm-Message-State: ACgBeo1qXF3eVGDRii3zZxOjhv1s1/TuG9/dFNzVwEuPxzoaQw5yBjJu
        3hDASnhMXB1wu9W16tPyv5DkG/6wSbk=
X-Google-Smtp-Source: AA6agR5kGY//SFEJJYmkHBfk2vY6ysGgzQlcWSy7XjyDccjOrr2/VGPAHe9YkMrDF/c7mao5qVqanw==
X-Received: by 2002:a17:907:6d24:b0:731:7720:bb9b with SMTP id sa36-20020a1709076d2400b007317720bb9bmr23719708ejc.717.1662029909184;
        Thu, 01 Sep 2022 03:58:29 -0700 (PDT)
Received: from 127.0.0.1localhost.com ([2620:10d:c092:600::2:e81f])
        by smtp.gmail.com with ESMTPSA id z14-20020a1709060ace00b0073d6d6e698bsm8277762ejf.187.2022.09.01.03.58.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 01 Sep 2022 03:58:28 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     io-uring@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>, asml.silence@gmail.com
Subject: [RFC 1/6] selftests/net: temporarily disable io_uring zc test
Date:   Thu,  1 Sep 2022 11:54:00 +0100
Message-Id: <12b7507223df04fbd12aa05fc0cb544b51d7ed79.1662027856.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <cover.1662027856.git.asml.silence@gmail.com>
References: <cover.1662027856.git.asml.silence@gmail.com>
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

We're going to change API, to avoid build problems with a couple of
following commits, disable io_uring testing.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 tools/testing/selftests/net/io_uring_zerocopy_tx.c | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/tools/testing/selftests/net/io_uring_zerocopy_tx.c b/tools/testing/selftests/net/io_uring_zerocopy_tx.c
index 9d64c560a2d6..7446ef364e9f 100644
--- a/tools/testing/selftests/net/io_uring_zerocopy_tx.c
+++ b/tools/testing/selftests/net/io_uring_zerocopy_tx.c
@@ -36,6 +36,8 @@
 #include <sys/un.h>
 #include <sys/wait.h>
 
+#if 0
+
 #define NOTIF_TAG 0xfffffffULL
 #define NONZC_TAG 0
 #define ZC_TAG 1
@@ -603,3 +605,10 @@ int main(int argc, char **argv)
 		error(1, 0, "unknown cfg_test %s", cfg_test);
 	return 0;
 }
+
+#else
+int main(int argc, char **argv)
+{
+	return 0;
+}
+#endif
-- 
2.37.2

