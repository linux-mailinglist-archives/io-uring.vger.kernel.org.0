Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 73804789218
	for <lists+io-uring@lfdr.de>; Sat, 26 Aug 2023 00:56:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229791AbjHYW4P (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 25 Aug 2023 18:56:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52878 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229920AbjHYW4J (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 25 Aug 2023 18:56:09 -0400
Received: from mail-pf1-x42b.google.com (mail-pf1-x42b.google.com [IPv6:2607:f8b0:4864:20::42b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2460C199F
        for <io-uring@vger.kernel.org>; Fri, 25 Aug 2023 15:56:07 -0700 (PDT)
Received: by mail-pf1-x42b.google.com with SMTP id d2e1a72fcca58-68bed2c786eso1122420b3a.0
        for <io-uring@vger.kernel.org>; Fri, 25 Aug 2023 15:56:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=davidwei-uk.20221208.gappssmtp.com; s=20221208; t=1693004166; x=1693608966;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=FqXYs9JKDR7EAnDxjSwatlgPrNqTmHker8ZbKfpU3gE=;
        b=lCB7WHCdd4R8tUMIan6Ga/7Tavbv7fVn1todwxKYAhR1vItB53MdQqCh/W4uSusrSO
         5bpTdYigvd0ZHXqG1qEey0Ugyu1KfUV7bUgtiwGVkLwkEJlm1VigWs2V5VOCNr00vV8O
         YuAtThVQUQ6SbnLhqL9QA1ny7USGQh5VYxdZDkuY9lC23UYQQP+giGDGVz4YyGAw0alG
         n0cpoe5cE0StEoHrYRl6+/veouqxBymScvxOQLYp4RuiuIQDxQMXIhR0bxz5uqckFTdT
         Z3uqQvvSiFLsT1ANQXIOR/QUf4JeefqzSfVn+kmLhsy1d/pPJT5SZiu/d9Zs92hubCnc
         f1Cg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1693004166; x=1693608966;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=FqXYs9JKDR7EAnDxjSwatlgPrNqTmHker8ZbKfpU3gE=;
        b=fmJYv6DrZuORVY0trsNVPLzeZfu8ONLufA1XGGIe+UVncsG4nqKuNBhw5pDXN9vFgw
         W9NeC254Ph3jXTfO5QEPYDCm95yQ0+tWAjGCdfBMbPcM3JPGF7MchFXNrBcQAt3JSjeA
         5pt8AouSei6Cc5wa1CCtI8ricY3s62mpRxOHGUna9yzBvO/cwXr4ic9XV1IamlIh300a
         5xzxXnUblJhANgZ/98swmXecyv05M/oIar1IRenQHQy+eFgVb5YKZL7FyyqAimzRC0q8
         z/N9DKTuCPpodXmxaD+7VvO4+igbfNRjYNRuwcd7UBmopX99qWysOg0tEgaW1EFca7c9
         v5fQ==
X-Gm-Message-State: AOJu0YxER/+gac4jav6ptKxSJB3wu4r1Fr6riStjE/oKBnMH8m+5manW
        kDZuoHEvQtcaUcDd+ZVWx+Bx/w==
X-Google-Smtp-Source: AGHT+IHOSHg7RUcjMRGkFWFBAFNCL23Z1xQhUasW1n2o0nbzBF7hONfyB+bQ2oc1CkWLbShPJy7/1g==
X-Received: by 2002:a05:6a21:71c1:b0:137:3eba:b7fb with SMTP id ay1-20020a056a2171c100b001373ebab7fbmr18585655pzc.2.1693004166374;
        Fri, 25 Aug 2023 15:56:06 -0700 (PDT)
Received: from localhost (fwdproxy-prn-003.fbsv.net. [2a03:2880:ff:3::face:b00c])
        by smtp.gmail.com with ESMTPSA id g25-20020aa78759000000b006732786b5f1sm2069993pfo.213.2023.08.25.15.56.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 25 Aug 2023 15:56:06 -0700 (PDT)
From:   David Wei <dw@davidwei.uk>
To:     Jens Axboe <axboe@kernel.dk>,
        Pavel Begunkov <asml.silence@gmail.com>
Cc:     io-uring@vger.kernel.org, Mina Almasry <almasrymina@google.com>,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 04/11] io_uring: setup ZC for an RX queue when registering an ifq
Date:   Fri, 25 Aug 2023 15:55:43 -0700
Message-Id: <20230825225550.957014-5-dw@davidwei.uk>
X-Mailer: git-send-email 2.39.3
In-Reply-To: <20230825225550.957014-1-dw@davidwei.uk>
References: <20230825225550.957014-1-dw@davidwei.uk>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

From: David Wei <davidhwei@meta.com>

This patch sets up ZC for an RX queue in a net device when an ifq is
registered with io_uring. The RX queue is specified in the registration
struct. The XDP command added in the previous patch is used to enable or
disable ZC RX.

For now since there is only one ifq, its destruction is implicit during
io_uring cleanup.

Signed-off-by: David Wei <davidhwei@meta.com>
Co-developed-by: Jonathan Lemon <jonathan.lemon@gmail.com>
---
 io_uring/io_uring.c |  1 +
 io_uring/zc_rx.c    | 62 +++++++++++++++++++++++++++++++++++++++++++--
 io_uring/zc_rx.h    |  1 +
 3 files changed, 62 insertions(+), 2 deletions(-)

diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
index 0b6c5508b1ca..f2ec0a454307 100644
--- a/io_uring/io_uring.c
+++ b/io_uring/io_uring.c
@@ -3098,6 +3098,7 @@ static __cold void io_ring_ctx_wait_and_kill(struct io_ring_ctx *ctx)
 	percpu_ref_kill(&ctx->refs);
 	xa_for_each(&ctx->personalities, index, creds)
 		io_unregister_personality(ctx, index);
+	io_unregister_zc_rx_ifq(ctx);
 	if (ctx->rings)
 		io_poll_remove_all(ctx, NULL, true);
 	mutex_unlock(&ctx->uring_lock);
diff --git a/io_uring/zc_rx.c b/io_uring/zc_rx.c
index 6c57c9b06e05..8cc66731af5b 100644
--- a/io_uring/zc_rx.c
+++ b/io_uring/zc_rx.c
@@ -3,6 +3,7 @@
 #include <linux/errno.h>
 #include <linux/mm.h>
 #include <linux/io_uring.h>
+#include <linux/netdevice.h>
 
 #include <uapi/linux/io_uring.h>
 
@@ -10,6 +11,35 @@
 #include "kbuf.h"
 #include "zc_rx.h"
 
+typedef int (*bpf_op_t)(struct net_device *dev, struct netdev_bpf *bpf);
+
+static int __io_queue_mgmt(struct net_device *dev, struct io_zc_rx_ifq *ifq,
+			   u16 queue_id)
+{
+	struct netdev_bpf cmd;
+	bpf_op_t ndo_bpf;
+
+	ndo_bpf = dev->netdev_ops->ndo_bpf;
+	if (!ndo_bpf)
+		return -EINVAL;
+
+	cmd.command = XDP_SETUP_ZC_RX;
+	cmd.zc_rx.ifq = ifq;
+	cmd.zc_rx.queue_id = queue_id;
+
+	return ndo_bpf(dev, &cmd);
+}
+
+static int io_open_zc_rxq(struct io_zc_rx_ifq *ifq)
+{
+	return __io_queue_mgmt(ifq->dev, ifq, ifq->if_rxq_id);
+}
+
+static int io_close_zc_rxq(struct io_zc_rx_ifq *ifq)
+{
+	return __io_queue_mgmt(ifq->dev, NULL, ifq->if_rxq_id);
+}
+
 static struct io_zc_rx_ifq *io_zc_rx_ifq_alloc(struct io_ring_ctx *ctx)
 {
 	struct io_zc_rx_ifq *ifq;
@@ -19,12 +49,17 @@ static struct io_zc_rx_ifq *io_zc_rx_ifq_alloc(struct io_ring_ctx *ctx)
 		return NULL;
 
 	ifq->ctx = ctx;
+	ifq->if_rxq_id = -1;
 
 	return ifq;
 }
 
 static void io_zc_rx_ifq_free(struct io_zc_rx_ifq *ifq)
 {
+	if (ifq->if_rxq_id != -1)
+		io_close_zc_rxq(ifq);
+	if (ifq->dev)
+		dev_put(ifq->dev);
 	io_free_rbuf_ring(ifq);
 	kfree(ifq);
 }
@@ -41,17 +76,22 @@ int io_register_zc_rx_ifq(struct io_ring_ctx *ctx,
 		return -EFAULT;
 	if (ctx->ifq)
 		return -EBUSY;
+	if (reg.if_rxq_id == -1)
+		return -EINVAL;
 
 	ifq = io_zc_rx_ifq_alloc(ctx);
 	if (!ifq)
 		return -ENOMEM;
 
-	/* TODO: initialise network interface */
-
 	ret = io_allocate_rbuf_ring(ifq, &reg);
 	if (ret)
 		goto err;
 
+	ret = -ENODEV;
+	ifq->dev = dev_get_by_index(&init_net, reg.if_idx);
+	if (!ifq->dev)
+		goto err;
+
 	/* TODO: map zc region and initialise zc pool */
 
 	ifq->rq_entries = reg.rq_entries;
@@ -59,6 +99,10 @@ int io_register_zc_rx_ifq(struct io_ring_ctx *ctx,
 	ifq->if_rxq_id = reg.if_rxq_id;
 	ctx->ifq = ifq;
 
+	ret = io_open_zc_rxq(ifq);
+	if (ret)
+		goto err;
+
 	ring_sz = sizeof(struct io_rbuf_ring);
 	rqes_sz = sizeof(struct io_uring_rbuf_rqe) * ifq->rq_entries;
 	cqes_sz = sizeof(struct io_uring_rbuf_cqe) * ifq->cq_entries;
@@ -80,3 +124,17 @@ int io_register_zc_rx_ifq(struct io_ring_ctx *ctx,
 	io_zc_rx_ifq_free(ifq);
 	return ret;
 }
+
+int io_unregister_zc_rx_ifq(struct io_ring_ctx *ctx)
+{
+	struct io_zc_rx_ifq *ifq;
+
+	ifq = ctx->ifq;
+	if (!ifq)
+		return -EINVAL;
+
+	ctx->ifq = NULL;
+	io_zc_rx_ifq_free(ifq);
+
+	return 0;
+}
diff --git a/io_uring/zc_rx.h b/io_uring/zc_rx.h
index 4363734f3d98..340ececa9f9c 100644
--- a/io_uring/zc_rx.h
+++ b/io_uring/zc_rx.h
@@ -17,5 +17,6 @@ struct io_zc_rx_ifq {
 
 int io_register_zc_rx_ifq(struct io_ring_ctx *ctx,
 			  struct io_uring_zc_rx_ifq_reg __user *arg);
+int io_unregister_zc_rx_ifq(struct io_ring_ctx *ctx);
 
 #endif
-- 
2.39.3

