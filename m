Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C593B6421AC
	for <lists+io-uring@lfdr.de>; Mon,  5 Dec 2022 03:45:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231309AbiLECpp (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sun, 4 Dec 2022 21:45:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45664 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231206AbiLECpo (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sun, 4 Dec 2022 21:45:44 -0500
Received: from mail-wr1-x42c.google.com (mail-wr1-x42c.google.com [IPv6:2a00:1450:4864:20::42c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B85EC10060
        for <io-uring@vger.kernel.org>; Sun,  4 Dec 2022 18:45:43 -0800 (PST)
Received: by mail-wr1-x42c.google.com with SMTP id q7so16627571wrr.8
        for <io-uring@vger.kernel.org>; Sun, 04 Dec 2022 18:45:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=IkqYtqviC3RF91Z5Z3rSsyFaerXGj63h6THg5DwVRpU=;
        b=O9QWAK9HCsnvW4fc/e+iFHZPx9gWOeDiv1WamZvgQv3zXPUQTmlBuG2YqYvg91abp/
         qvwM7C1Kg/gDzmlOp2kl8POddopHZSzEo+YOOFO+6b8dd9PMPnM5Glk0Bw2hCQsQh+L9
         Nc5WseAdOmR7nyR6DaoT8SuxJx3rzcEaiwU7Up5c1u+UGEeulChBepMmJ7zmVhjOEPV4
         BX+s2BXelt5aPaqCvBFo4oytz5qOQuFisULuxFBNDQMZsjEE790h0gyJRN0Ch6ijxhwO
         KPu1X5tDL3/QTZa+gHQlIeEUCd4z+nWwiAZNiBv8UGBrfFu1/85JiUM/AmU652YoIbzS
         s7ZA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=IkqYtqviC3RF91Z5Z3rSsyFaerXGj63h6THg5DwVRpU=;
        b=3ltu1tYBdxgMJpJil9Ot6dTDQ69PVzBX32SZ5bCjcgKBXKst9miTCcyHobA/l7CXii
         p2gQHh8bdtXVrHYapGucVKP4RQUFrsdI8J1qGNKJphKjSd3PEQ4/2g2oK7qlQ2S4knF6
         yqdDn95xq8lstWOdBo7Go+iBmiCi7xj7YmmD1JxC+NsPRJbF9yB8Aea0oISQ7GTQxJ1G
         RrTo7CaIAQp2/Esb2KCs1sf0WI67+X+tiK2tyP0uVRYYNRAmp94TLg0Ahal3F2T6Jeii
         L0OH26Iwy2ucaNO/Xq9byoMOzVowVXZ6ORJk1dmRQH58gJNUGva6Clx5FbJWmXh0w9j6
         GppA==
X-Gm-Message-State: ANoB5pksQ9NeaJoLW4WrnKLs/t7UdFZhtwryIx8nzY7Cy+MRj2Gg6gWF
        ihw8gbZ47yeIYs39wVfRv9HBLYWhw70=
X-Google-Smtp-Source: AA0mqf4ZszM4cDnO4QFcQ3/w+TnpcNBzYXKg0daAWyn9euY98yH5IMbFKL7ZhJaM+Xc8C4OkJVanAg==
X-Received: by 2002:adf:db87:0:b0:242:2719:5784 with SMTP id u7-20020adfdb87000000b0024227195784mr15157913wri.130.1670208341996;
        Sun, 04 Dec 2022 18:45:41 -0800 (PST)
Received: from 127.0.0.1localhost (94.196.241.58.threembb.co.uk. [94.196.241.58])
        by smtp.gmail.com with ESMTPSA id t17-20020a05600c41d100b003cf71b1f66csm15281532wmh.0.2022.12.04.18.45.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 04 Dec 2022 18:45:41 -0800 (PST)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     io-uring@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>, asml.silence@gmail.com
Subject: [PATCH for-next 6/7] io_uring: use tw for putting rsrc
Date:   Mon,  5 Dec 2022 02:44:30 +0000
Message-Id: <9b35443a6f758f76ea75bb7438e6ff5a7b4f40e3.1670207706.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <cover.1670207706.git.asml.silence@gmail.com>
References: <cover.1670207706.git.asml.silence@gmail.com>
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

Use task_work for completing rsrc removals, it'll be needed later for
spinlock optimisations.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 include/linux/io_uring_types.h |  1 +
 io_uring/io_uring.c            |  1 +
 io_uring/rsrc.c                | 19 +++++++++++++++++--
 io_uring/rsrc.h                |  1 +
 4 files changed, 20 insertions(+), 2 deletions(-)

diff --git a/include/linux/io_uring_types.h b/include/linux/io_uring_types.h
index 6be1e1359c89..dcd8a563ab52 100644
--- a/include/linux/io_uring_types.h
+++ b/include/linux/io_uring_types.h
@@ -328,6 +328,7 @@ struct io_ring_ctx {
 	struct io_rsrc_data		*buf_data;
 
 	struct delayed_work		rsrc_put_work;
+	struct callback_head		rsrc_put_tw;
 	struct llist_head		rsrc_put_llist;
 	struct list_head		rsrc_ref_list;
 	spinlock_t			rsrc_ref_lock;
diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
index 7fda57dc0e8c..9eb771a4c912 100644
--- a/io_uring/io_uring.c
+++ b/io_uring/io_uring.c
@@ -326,6 +326,7 @@ static __cold struct io_ring_ctx *io_ring_ctx_alloc(struct io_uring_params *p)
 	spin_lock_init(&ctx->rsrc_ref_lock);
 	INIT_LIST_HEAD(&ctx->rsrc_ref_list);
 	INIT_DELAYED_WORK(&ctx->rsrc_put_work, io_rsrc_put_work);
+	init_task_work(&ctx->rsrc_put_tw, io_rsrc_put_tw);
 	init_llist_head(&ctx->rsrc_put_llist);
 	init_llist_head(&ctx->work_llist);
 	INIT_LIST_HEAD(&ctx->tctx_list);
diff --git a/io_uring/rsrc.c b/io_uring/rsrc.c
index d25309400a45..18de10c68a15 100644
--- a/io_uring/rsrc.c
+++ b/io_uring/rsrc.c
@@ -204,6 +204,14 @@ void io_rsrc_put_work(struct work_struct *work)
 	}
 }
 
+void io_rsrc_put_tw(struct callback_head *cb)
+{
+	struct io_ring_ctx *ctx = container_of(cb, struct io_ring_ctx,
+					       rsrc_put_tw);
+
+	io_rsrc_put_work(&ctx->rsrc_put_work.work);
+}
+
 void io_wait_rsrc_data(struct io_rsrc_data *data)
 {
 	if (data && !atomic_dec_and_test(&data->refs))
@@ -242,8 +250,15 @@ static __cold void io_rsrc_node_ref_zero(struct percpu_ref *ref)
 	}
 	spin_unlock_irqrestore(&ctx->rsrc_ref_lock, flags);
 
-	if (first_add)
-		mod_delayed_work(system_wq, &ctx->rsrc_put_work, delay);
+	if (!first_add)
+		return;
+
+	if (ctx->submitter_task) {
+		if (!task_work_add(ctx->submitter_task, &ctx->rsrc_put_tw,
+				   ctx->notify_method))
+			return;
+	}
+	mod_delayed_work(system_wq, &ctx->rsrc_put_work, delay);
 }
 
 static struct io_rsrc_node *io_rsrc_node_alloc(void)
diff --git a/io_uring/rsrc.h b/io_uring/rsrc.h
index 81445a477622..2b8743645efc 100644
--- a/io_uring/rsrc.h
+++ b/io_uring/rsrc.h
@@ -53,6 +53,7 @@ struct io_mapped_ubuf {
 	struct bio_vec	bvec[];
 };
 
+void io_rsrc_put_tw(struct callback_head *cb);
 void io_rsrc_put_work(struct work_struct *work);
 void io_rsrc_refs_refill(struct io_ring_ctx *ctx);
 void io_wait_rsrc_data(struct io_rsrc_data *data);
-- 
2.38.1

