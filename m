Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 71B24677E3F
	for <lists+io-uring@lfdr.de>; Mon, 23 Jan 2023 15:42:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229894AbjAWOmM (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 23 Jan 2023 09:42:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49464 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230134AbjAWOmM (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 23 Jan 2023 09:42:12 -0500
Received: from mail-wr1-x435.google.com (mail-wr1-x435.google.com [IPv6:2a00:1450:4864:20::435])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EB39518A8F
        for <io-uring@vger.kernel.org>; Mon, 23 Jan 2023 06:42:10 -0800 (PST)
Received: by mail-wr1-x435.google.com with SMTP id h16so11004225wrz.12
        for <io-uring@vger.kernel.org>; Mon, 23 Jan 2023 06:42:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Zz8mte92pKCxIeKLVprZKS17+HTmr83atw+WYLy32Vc=;
        b=Vj1M8TO8amcgkWABvF/oy7xptxFL/Gusqo6sLqo1bAvRHrv0imIWciRhFLjdyOiLJQ
         O4w+7vPstf+5Owpdx6QOL4XtCTlFvHForJW26lZxp+bU9gJ1RCdaPebsLf+QWmU2oydi
         ZKkTRvh8gQ2821S7YZs+MTa26K/OIcr9FZoGzOxQthtkhjF460T4l8I0QF5QkItubyY2
         llmGgQIAtdFmMm+/Bv1FUFwZ4IEMUBSRDx7yIxU1+IiGcjxzwCA0Ha+xnmbFwU0vDivu
         rD0+zWwnBkW9cLoivAqQPOPGJYEhYe4f1Bvj1F7avvP/LdqSBkqFvjjdRSJ+ILXMmKm8
         P6yg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Zz8mte92pKCxIeKLVprZKS17+HTmr83atw+WYLy32Vc=;
        b=Qr4UTba6wstL8affXRhHvzy8EgQasfD4rDri9smh6CJRYwt+KqIOJFrkewRFCEWqAu
         KoeCHPOPBfHT37Yk5xwT3Rr8JMKfI+Yl8K8nVE1apixb2YLUXF6iiOoLliwMc0lw7C62
         TnXENray4yH7GxWFPGAHT24tjJrXH8+adNYH1Kic2fTdQIr/uZzJzN+/e8zA1NC3aM4o
         53Vr3NZRF03k5mI+5DGWeqtHeq6WQVGm3Xr7X/7CSAoTBv6ZtKTDNikO/V5H6r6hxrN2
         cPP/aFz4oAmJqG70efkTgCa3StvoNrB98c/DqPSb68Gk2fKixgpLtyK5vMieL7mvyX+7
         WP0g==
X-Gm-Message-State: AFqh2koA1bGoTm9WLwE+LXPaswU5k2RcWEeU6E5hve/A4P1kV0GKQS3Q
        zgLfWIz/YqoCYx/VPfVOvN4p2kR1rTA=
X-Google-Smtp-Source: AMrXdXsjodMupCNr8n5cE+7o42mWBW1XaAfpb0NgcnER5hy+ldjKyij10BQgs8oYiBty4RJFVxeyHQ==
X-Received: by 2002:a5d:67d2:0:b0:2be:50a7:cfa9 with SMTP id n18-20020a5d67d2000000b002be50a7cfa9mr11576694wrw.63.1674484929331;
        Mon, 23 Jan 2023 06:42:09 -0800 (PST)
Received: from 127.0.0.1localhost (188.30.84.186.threembb.co.uk. [188.30.84.186])
        by smtp.gmail.com with ESMTPSA id d24-20020adfa358000000b00236883f2f5csm3250534wrb.94.2023.01.23.06.42.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 23 Jan 2023 06:42:09 -0800 (PST)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     io-uring@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>, asml.silence@gmail.com
Subject: [PATCH for-next 1/7] io_uring: use user visible tail in io_uring_poll()
Date:   Mon, 23 Jan 2023 14:37:13 +0000
Message-Id: <228ffcbf30ba98856f66ffdb9a6a60ead1dd96c0.1674484266.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <cover.1674484266.git.asml.silence@gmail.com>
References: <cover.1674484266.git.asml.silence@gmail.com>
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

We return POLLIN from io_uring_poll() depending on whether there are
CQEs for the userspace, and so we should use the user visible tail
pointer instead of a transient cached value.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 io_uring/io_uring.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
index aef30d265a13..c42c1124ad5c 100644
--- a/io_uring/io_uring.c
+++ b/io_uring/io_uring.c
@@ -2888,7 +2888,7 @@ static __poll_t io_uring_poll(struct file *file, poll_table *wait)
 	 * pushes them to do the flush.
 	 */
 
-	if (io_cqring_events(ctx) || io_has_work(ctx))
+	if (__io_cqring_events_user(ctx) || io_has_work(ctx))
 		mask |= EPOLLIN | EPOLLRDNORM;
 
 	return mask;
-- 
2.38.1

