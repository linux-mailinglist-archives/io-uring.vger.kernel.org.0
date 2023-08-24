Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D7F5B787BBB
	for <lists+io-uring@lfdr.de>; Fri, 25 Aug 2023 00:56:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243976AbjHXWzq (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 24 Aug 2023 18:55:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45958 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244037AbjHXWzf (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 24 Aug 2023 18:55:35 -0400
Received: from mail-ej1-x631.google.com (mail-ej1-x631.google.com [IPv6:2a00:1450:4864:20::631])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 128F11FD0
        for <io-uring@vger.kernel.org>; Thu, 24 Aug 2023 15:55:27 -0700 (PDT)
Received: by mail-ej1-x631.google.com with SMTP id a640c23a62f3a-9936b3d0286so37412166b.0
        for <io-uring@vger.kernel.org>; Thu, 24 Aug 2023 15:55:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1692917725; x=1693522525;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=LRwqn+8y3sMpl97JXgW1Kcuei5VeXjUdmpcF0r4gMS0=;
        b=DXyyYBC1SzcFWlLWIMc3z5yrf2YD+w6N5PB0/6pdMK2bAFSDSEzcDYS73L0MFyF9Zf
         MIWQuoFocHzrjT3DMJ9itefeYA657qBPDC6+zuPDQjEcw0Wv74xjfzy8Repge4yChXhp
         RQyfpD1L9bDlN7zg/vHMzMvM/gxCCx0s31Yuu8Cv9Z7R+UlhjG0q2pL0dWVofIDBZrTG
         YvjhxqlHNoWqOqAXJeCuPH9xlHm7GdmWCn7svctIwZyuZEBjMa4dcUi6HfsiG/RgdPif
         76R/vxUwYGdBj0PnqIbnh/zQYnypaFBo/IQmOuef58rFTr1r7fP2a6Lt4NfbUzaT/qlK
         yEew==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1692917725; x=1693522525;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=LRwqn+8y3sMpl97JXgW1Kcuei5VeXjUdmpcF0r4gMS0=;
        b=jfWfdikrXkFuHo9nRXiiwWUcZvhYNISBkVoxelu0k1SxUfxrLaK54s7DB/pkkYdFvF
         wKDOuLrWz62nlMtPWbgeMNejVbqHKrfl5PZB5BfQHQya8QUNTV3n2EC4Sbnp25oo50XX
         LXa5DNFG9Ll8YpiAIpIe9qJAlUeNe1XFsb9BRFEROo1r+jR9lsi6aprxMh32qLXiKWyK
         pXPSs/bR1frhXIfuVxWSqG8+YpbbqWtXT2Hi9vPNexLp/EUePlcWsP5bcoLWUnV0On32
         Ja4RUHeEyfaFpDv78Y4P27MXwHT2QsiKJ0+lqscxTNUgMs6283HjB9sZnTlk30P4IGf0
         Wfag==
X-Gm-Message-State: AOJu0YyJ1CewVOiqnWlDkJahzifyuN10wmCHpL3Kc+x5RO8g/al72G0V
        58VaIH97L8JESWESwZSdV0EcPAQ9Rok=
X-Google-Smtp-Source: AGHT+IH+fbo+C1jxd5nu0ioFzFSHzY4NOlGa83eY2ZTy2xfozVwU2qwxVCn9GpiT97THswGXibmpUw==
X-Received: by 2002:a17:906:7493:b0:9a1:ca55:b668 with SMTP id e19-20020a170906749300b009a1ca55b668mr6703370ejl.59.1692917725362;
        Thu, 24 Aug 2023 15:55:25 -0700 (PDT)
Received: from 127.0.0.1localhost ([148.252.140.69])
        by smtp.gmail.com with ESMTPSA id q4-20020a170906144400b00992f81122e1sm173469ejc.21.2023.08.24.15.55.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 24 Aug 2023 15:55:25 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     io-uring@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>, asml.silence@gmail.com
Subject: [PATCH v2 09/15] io_uring: compact SQ/CQ heads/tails
Date:   Thu, 24 Aug 2023 23:53:31 +0100
Message-ID: <9c8deddf9a7ed32069235a530d1e117fb460bc4c.1692916914.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <cover.1692916914.git.asml.silence@gmail.com>
References: <cover.1692916914.git.asml.silence@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Queues heads and tails cache line aligned. That makes sq, cq taking 4
lines or 5 lines if we include the rest of struct io_rings (e.g.
sq_flags is frequently accessed).

Since modern io_uring is mostly single threaded, it doesn't make much
send to spread them as such, it wastes space and puts additional pressure
on caches. Put them all into a single line.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 include/linux/io_uring_types.h | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/include/linux/io_uring_types.h b/include/linux/io_uring_types.h
index c0c03d8059df..608a8e80e881 100644
--- a/include/linux/io_uring_types.h
+++ b/include/linux/io_uring_types.h
@@ -69,8 +69,8 @@ struct io_uring_task {
 };
 
 struct io_uring {
-	u32 head ____cacheline_aligned_in_smp;
-	u32 tail ____cacheline_aligned_in_smp;
+	u32 head;
+	u32 tail;
 };
 
 /*
-- 
2.41.0

