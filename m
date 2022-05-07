Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EFC3E51E7A6
	for <lists+io-uring@lfdr.de>; Sat,  7 May 2022 16:07:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1446484AbiEGOKF (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sat, 7 May 2022 10:10:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52156 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1446487AbiEGOKD (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sat, 7 May 2022 10:10:03 -0400
Received: from mail-pg1-x52f.google.com (mail-pg1-x52f.google.com [IPv6:2607:f8b0:4864:20::52f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B9D483C723;
        Sat,  7 May 2022 07:06:17 -0700 (PDT)
Received: by mail-pg1-x52f.google.com with SMTP id r192so4177940pgr.6;
        Sat, 07 May 2022 07:06:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=6kq+acLDjz6PeqvlJm1Gf1hz/F7fG1BH4kW1rIpVdp4=;
        b=ei5SnDWBxj0PtMjNrGj8Eglu6LdAohAyYYabLDrlVOwQhY4yS1lWGM4EMPgqJ1MKOs
         5tPLIzyxsA0mucmU4G/MwACIhi5zJcMgldRtJPJdSEadu5VHAliqjBIrY4h9KyYJ3oTr
         udCk7WYQCLE3R1xxPBrm1jqfs+ppn4CKhSFrJV1V72iP3RBGhhyCpMQbewmqG89m2Mu7
         dsuzR0phIrrUUzC3Y7co3cgzkHdgiE14f7FJgNUKMuxSvAVVXhGXObfGol3lrG3mMY9Y
         7c17BOav3YFLgG997Ql+wB8bm8Cw7qSxD73QAGBVdZfF8tfNx2s5s8e4dLey4bTACOMJ
         G/ag==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=6kq+acLDjz6PeqvlJm1Gf1hz/F7fG1BH4kW1rIpVdp4=;
        b=wRlQhdk/mOGkc7GONYK4RIn7P4I74bUp2JzYXXWABtZKbcre6Di88kEMkCX/XwMqK3
         +ACBBISoIS5+/O/f4BVgpAzyG1VRqhdz6/zG9TQGJzF0P7sRdWUintOdy5Qzu1uFOU5N
         UmJ5/8XBUPfGuNU0eYXoeR3x2NktGXH0wH3aQwbI8QPJiugyOeza42+1+j9kR0dCttw+
         NE4oYKPhQNsPi7l9j5yFovWZlXEk01k96JjIsK3Nu2R0Q754UKDqYpuTk3FsnhhfktXV
         QkTOuzJqs8718aU6XmtB1NjZ19Vv9ie8k/lQrg7dB/cYhFZpTEX/WLMdsiwPMFlDqwIg
         L12A==
X-Gm-Message-State: AOAM530iqmJb7xPOWGbfAv+I7UL2OBOMlF7+5RSIUEUT+WpKPS6+9jW3
        PBD+Nvd1MHIgESAyOdr7yyYb2KJqlc8TFQ==
X-Google-Smtp-Source: ABdhPJwa4MYT3u3eXdYE/BoskSBdkfoAmmujlziIdrBgitwRq4sLI3N7pT82RjUdRxWUuJamai87aw==
X-Received: by 2002:a05:6a00:26cf:b0:4f6:fc52:7b6a with SMTP id p15-20020a056a0026cf00b004f6fc527b6amr8222522pfw.39.1651932377057;
        Sat, 07 May 2022 07:06:17 -0700 (PDT)
Received: from HOWEYXU-MB0.tencent.com ([106.53.33.166])
        by smtp.gmail.com with ESMTPSA id j13-20020a170902c3cd00b0015e8d4eb2acsm3674813plj.246.2022.05.07.07.06.13
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Sat, 07 May 2022 07:06:16 -0700 (PDT)
From:   Hao Xu <haoxu.linux@gmail.com>
To:     io-uring@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>,
        Pavel Begunkov <asml.silence@gmail.com>,
        linux-kernel@vger.kernel.org
Subject: [PATCH 1/4] io_uring: add IORING_ACCEPT_MULTISHOT for accept
Date:   Sat,  7 May 2022 22:06:17 +0800
Message-Id: <20220507140620.85871-2-haoxu.linux@gmail.com>
X-Mailer: git-send-email 2.36.0
In-Reply-To: <20220507140620.85871-1-haoxu.linux@gmail.com>
References: <20220507140620.85871-1-haoxu.linux@gmail.com>
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

From: Hao Xu <howeyxu@tencent.com>

add an accept_flag IORING_ACCEPT_MULTISHOT for accept, which is to
support multishot.

Signed-off-by: Hao Xu <howeyxu@tencent.com>
Signed-off-by: Jens Axboe <axboe@kernel.dk>
---
 include/uapi/linux/io_uring.h | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/include/uapi/linux/io_uring.h b/include/uapi/linux/io_uring.h
index 06621a278cb6..f4d9ca62a5a6 100644
--- a/include/uapi/linux/io_uring.h
+++ b/include/uapi/linux/io_uring.h
@@ -223,6 +223,11 @@ enum {
  */
 #define IORING_RECVSEND_POLL_FIRST	(1U << 0)
 
+/*
+ * accept flags stored in accept_flags
+ */
+#define IORING_ACCEPT_MULTISHOT	(1U << 15)
+
 /*
  * IO completion data structure (Completion Queue Entry)
  */
-- 
2.36.0

