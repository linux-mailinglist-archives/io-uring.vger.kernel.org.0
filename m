Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 244A26E1004
	for <lists+io-uring@lfdr.de>; Thu, 13 Apr 2023 16:29:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231571AbjDMO3H (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 13 Apr 2023 10:29:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58842 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231558AbjDMO3E (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 13 Apr 2023 10:29:04 -0400
Received: from mail-wm1-x330.google.com (mail-wm1-x330.google.com [IPv6:2a00:1450:4864:20::330])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 54F7AAD09
        for <io-uring@vger.kernel.org>; Thu, 13 Apr 2023 07:29:02 -0700 (PDT)
Received: by mail-wm1-x330.google.com with SMTP id i8-20020a05600c354800b003ee93d2c914so9938112wmq.2
        for <io-uring@vger.kernel.org>; Thu, 13 Apr 2023 07:29:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1681396140; x=1683988140;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=XJDeBFWflXiYXndOhi/AhPK+oyloSSkv8OIb38IyP1c=;
        b=DGEOyitcGDuQFn0SMe4jrtK2G7ZPztpYYYIIqEoGNnj6uFwd+krlBSyuf/XPAJLIxC
         PglSBhr+8dDu0qfFGdJIUMlfLIn7TaxRNb//OEMJrFeQtBqhLTG1AwN6FcPpMYmg9kYZ
         taibiXPLWyqhiXMMrQRQQbEeiPjDmxAgXz8U9xd1tL70FUUQ5dV2BLxBaeOh6zE8gT2v
         3vBkXm8UDZBw+DyyQ0Fy3BLy0jKRrv4Tsw7O38vuIVJfqyMbdTMelkVR1Yyt3vclB2hk
         tzFqZQuMwjFu4h0UfPEKe1FZlGb5s1jPXymEYsO/icUMNp9tJk2/la87eLDm6lYZ7dtD
         2QKw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1681396140; x=1683988140;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=XJDeBFWflXiYXndOhi/AhPK+oyloSSkv8OIb38IyP1c=;
        b=cr5TtpS/AxRCNVkYEVPhpD1zTa1MGHy5u7nNPdJVE3Gd9EuumS/JxVu3CD9C7nAUTS
         hLpsFtU+VNhoGdCmFpAjUdxlPd9jzeGgij1pq/wKPoeF27KabIJ4Yk5/HBSBQ88s5Ika
         JfzGGgvAdpoMWgcLdQI7WUtVJA1sLgwADuvXHcJkDtAQQQiENGPq4Fvn32H/BC/mzQuS
         0EyFoZ2n46psSURfZCxPq9dBQtbZYEJWtnnlZeBijNh/8b4uli7QQ3MFeYS/mrM1yHB7
         QMSvUj5LzYB61+S10hpGdw3JX7ydMecpEiots5rEqTdtHYuOLOLnJnh9yfzRrUgUHqEz
         kT8g==
X-Gm-Message-State: AAQBX9cpeyLJw/l+0sNKAd3PMghmjJLe6fWIRvMoGxLXj3lrFZpwDUzF
        nlX8V1C4ZfsXgG6cy+YdOQUUh1w8/tA=
X-Google-Smtp-Source: AKy350bEZmI6Cb3vL6lx1k6FVubv/GiO9tAzRiEfFkNVvTPT9iKHWCvY7jjTDp0UmB6pJe74f05gQg==
X-Received: by 2002:a05:600c:1e11:b0:3f0:4275:395f with SMTP id ay17-20020a05600c1e1100b003f04275395fmr1559707wmb.13.1681396140773;
        Thu, 13 Apr 2023 07:29:00 -0700 (PDT)
Received: from 127.0.0.1localhost (94.196.97.186.threembb.co.uk. [94.196.97.186])
        by smtp.gmail.com with ESMTPSA id z14-20020adff1ce000000b002f28de9f73bsm1387391wro.55.2023.04.13.07.29.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 13 Apr 2023 07:29:00 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     io-uring@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>, asml.silence@gmail.com
Subject: [PATCH 09/10] io_uring/rsrc: simplify single file node switching
Date:   Thu, 13 Apr 2023 15:28:13 +0100
Message-Id: <37cfb46f46160f81dced79f646e97db608994574.1681395792.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <cover.1681395792.git.asml.silence@gmail.com>
References: <cover.1681395792.git.asml.silence@gmail.com>
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

At maximum io_install_fixed_file() removes only one file,
so no need to keep needs_switch state and we can call
io_rsrc_node_switch() right after removal.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 io_uring/filetable.c | 11 ++++-------
 1 file changed, 4 insertions(+), 7 deletions(-)

diff --git a/io_uring/filetable.c b/io_uring/filetable.c
index b80614e7d605..6255fa255ae2 100644
--- a/io_uring/filetable.c
+++ b/io_uring/filetable.c
@@ -64,7 +64,6 @@ static int io_install_fixed_file(struct io_ring_ctx *ctx, struct file *file,
 				 u32 slot_index)
 	__must_hold(&req->ctx->uring_lock)
 {
-	bool needs_switch = false;
 	struct io_fixed_file *file_slot;
 	int ret;
 
@@ -83,16 +82,17 @@ static int io_install_fixed_file(struct io_ring_ctx *ctx, struct file *file,
 
 		ret = io_rsrc_node_switch_start(ctx);
 		if (ret)
-			goto err;
+			return ret;
 
 		old_file = (struct file *)(file_slot->file_ptr & FFS_MASK);
 		ret = io_queue_rsrc_removal(ctx->file_data, slot_index,
 					    ctx->rsrc_node, old_file);
 		if (ret)
-			goto err;
+			return ret;
+
 		file_slot->file_ptr = 0;
 		io_file_bitmap_clear(&ctx->file_table, slot_index);
-		needs_switch = true;
+		io_rsrc_node_switch(ctx, ctx->file_data);
 	}
 
 	ret = io_scm_file_account(ctx, file);
@@ -101,9 +101,6 @@ static int io_install_fixed_file(struct io_ring_ctx *ctx, struct file *file,
 		io_fixed_file_set(file_slot, file);
 		io_file_bitmap_set(&ctx->file_table, slot_index);
 	}
-err:
-	if (needs_switch)
-		io_rsrc_node_switch(ctx, ctx->file_data);
 	return ret;
 }
 
-- 
2.40.0

