Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E9410592F1E
	for <lists+io-uring@lfdr.de>; Mon, 15 Aug 2022 14:44:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242284AbiHOMoJ (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 15 Aug 2022 08:44:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55178 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242180AbiHOMoI (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 15 Aug 2022 08:44:08 -0400
Received: from mail-wm1-x329.google.com (mail-wm1-x329.google.com [IPv6:2a00:1450:4864:20::329])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 11184DEF4
        for <io-uring@vger.kernel.org>; Mon, 15 Aug 2022 05:44:07 -0700 (PDT)
Received: by mail-wm1-x329.google.com with SMTP id p12-20020a7bcc8c000000b003a5360f218fso7756522wma.3
        for <io-uring@vger.kernel.org>; Mon, 15 Aug 2022 05:44:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc;
        bh=ERqPKONVQJ131A8xPa0b9ax3YX2g6jPp6AbgfsU/eyY=;
        b=nkTlWqvuNIqozjLQZaSgd3mmaAJlO0mHdxuQ3UhQHbf4JUrTnC95bKJ00e4RYzQ+OH
         yUilKHnDni+r+BQcaG3dLYgboujH5ObDlTyluLv0fkW17lYsDtTQd61pUN5UkSUG3Ma4
         caOK0n+vUL5J/i04psX+uQID/0QJo+MCIxmZ4QWUZGxHg4IMl4HbyFYJUCZl5U+uItXM
         8r6RCAO2vZxkv2WWDfeHzX7nExhNLYf7yQSRb3cPUZArtOsE2WK8BTJlTIYmWQFMY+V7
         u3XtIWuzw7QNOR0tZVpcEptLh4ZGGIdyTwkMNlLD3THGVtjVxiYUVDw4tY0UXMlhnU2L
         7NJg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc;
        bh=ERqPKONVQJ131A8xPa0b9ax3YX2g6jPp6AbgfsU/eyY=;
        b=kBJsLvNvjryTU4WScBIFS2U/xJsWIMJ0T+JFAfjVpoLA8cQ0SuK19TwqK6n5QoD99N
         RreZVrUxlm5Vl87LWVhr0JJBT8Z/w5zG8NkdC0vWzRWfbgNp2+VUpn+U6YWqR0Zxxqhf
         unQVRH85a81QcZZDp5bsLKS6E0GCucfvz4QuciJqmHpunhG8nD74dG+I8fLU7yt12ZXQ
         J/qkIKvi9DV1A083uf57F0VgfxpcvOclOZY79lOFKtFmqoM206+hphbWBNBsI3j15TNO
         v/HVeUW5PcK0CC4lTBH+ttuaA+SYmdWMBkz7yD9NI2nS2s4tMCVGzeT4sFXNAB+lsIIq
         VH7w==
X-Gm-Message-State: ACgBeo0nKkFSMRc//uGIrQPaI+lGS6MSx4tWxdvBZu2Voeu7I7CiDLq0
        7QKtDsZPwau/p+Q6+swvIXX8chYWDX4=
X-Google-Smtp-Source: AA6agR6k2ZCGQDP8Q0berMuW6o38LUI+xXDtzMmyTTzKijrSAqvGnlnglR1kv43N3Ps3klt3a4q3WA==
X-Received: by 2002:a05:600c:210b:b0:3a5:bb92:d22d with SMTP id u11-20020a05600c210b00b003a5bb92d22dmr10007477wml.99.1660567445234;
        Mon, 15 Aug 2022 05:44:05 -0700 (PDT)
Received: from 127.0.0.1localhost.com ([2620:10d:c092:600::2:5fc6])
        by smtp.gmail.com with ESMTPSA id f13-20020a05600c154d00b003a54fffa809sm10296109wmg.17.2022.08.15.05.44.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 15 Aug 2022 05:44:04 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     io-uring@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>, asml.silence@gmail.com
Subject: [PATCH for-5.20 3/3] io_uring/notif: raise limit on notification slots
Date:   Mon, 15 Aug 2022 13:42:02 +0100
Message-Id: <eb78a0a5f2fa5941f8e845cdae5fb399bf7ba0be.1660566179.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.37.0
In-Reply-To: <cover.1660566179.git.asml.silence@gmail.com>
References: <cover.1660566179.git.asml.silence@gmail.com>
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

1024 notification slots is rather an arbitrary value, raise it up,
everything is accounted to memcg.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 io_uring/notif.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/io_uring/notif.h b/io_uring/notif.h
index 65f0b42f2555..80f6445e0c2b 100644
--- a/io_uring/notif.h
+++ b/io_uring/notif.h
@@ -8,7 +8,7 @@
 #include "rsrc.h"
 
 #define IO_NOTIF_SPLICE_BATCH	32
-#define IORING_MAX_NOTIF_SLOTS (1U << 10)
+#define IORING_MAX_NOTIF_SLOTS	(1U << 15)
 
 struct io_notif_data {
 	struct file		*file;
-- 
2.37.0

