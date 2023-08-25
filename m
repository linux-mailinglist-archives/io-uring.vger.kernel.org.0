Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7C590789216
	for <lists+io-uring@lfdr.de>; Sat, 26 Aug 2023 00:56:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229672AbjHYW4N (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 25 Aug 2023 18:56:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52866 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229891AbjHYW4G (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 25 Aug 2023 18:56:06 -0400
Received: from mail-pl1-x62d.google.com (mail-pl1-x62d.google.com [IPv6:2607:f8b0:4864:20::62d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A29B7E77
        for <io-uring@vger.kernel.org>; Fri, 25 Aug 2023 15:56:04 -0700 (PDT)
Received: by mail-pl1-x62d.google.com with SMTP id d9443c01a7336-1c06f6f98c0so12004665ad.3
        for <io-uring@vger.kernel.org>; Fri, 25 Aug 2023 15:56:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=davidwei-uk.20221208.gappssmtp.com; s=20221208; t=1693004164; x=1693608964;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=fQmFAOYPyQYmMwkH3n9RRbmoobUo7gWIqTt8UijUgLA=;
        b=yA5jnF/qCqIymxesI02LgGPdAlS19tXLUBtjmOF9Wc168cewBcZbFZqXsx9N6Q9Tux
         37ItxL5pvjHTLx2HAOh2ZFXsQnmyTYZwGUuyRm+4hSmzSMqw7fnpB5NxXOwdhyFqvqM2
         eLz9RFPblQpTiSvt97mWlTKOTKJw5FJ4UUB4Oe9owOPrxGdFejmHg4VLKtakkSunVDeT
         YjTT9U3EOJdJelYXG9nIyvMXhpIDlOfmpOUWLz+6k2R698QCROaCdEvfu4anCQqRrXhD
         OslANzaK8tp9y33bY6bIRNdlX4hzD5jHf8A2KM99ZynglMfRb8e5MQqDNyuC4ppMAWr/
         JQVQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1693004164; x=1693608964;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=fQmFAOYPyQYmMwkH3n9RRbmoobUo7gWIqTt8UijUgLA=;
        b=eGlo7qWboxmNnZ2XnMrTdP6LHSLam/kvinoxc43arDj8j8oiAT90+CuDN3N7wSu0sq
         JNIi7FJL58DkcCI92T9/4ZY+Vyl5VRogXUHrx72nTEDALf1SJ7C0mXOHqpbUZ5EkpBtR
         dETftmr4dsMNZ2yVznjkF4b5PFn7+yTXvJS1GLyte/U+7rZZ1nsoCGu+kx5YuRqSS5kg
         MMpJ1xuPCBA0ISFxJJS55EHT45XwDwU70gGnHqdM/6a1aVn6PElpBu288HZ1rNacDr/A
         UXO4OUEHEpxayz0mO5r/9n+j+XkRzFeRPPazSQNDbWY/8AjHmaw51eYnJxHyyrhRSJpt
         qjMg==
X-Gm-Message-State: AOJu0YyQxfS6pzdifHKDglBY2y+E3SzUDhNth7io0ySndxTQLbWz/OrH
        B1T2afvGB4SdMEuJoUMQGRD3LQ==
X-Google-Smtp-Source: AGHT+IF7MKZzd1apkZgyE0pCxYuuPw3vnIA1QwqQJ01W3emblAl1LeIYO02Pk/G7S6cOBQlB3YFLOg==
X-Received: by 2002:a17:903:26cb:b0:1bc:98dd:e857 with SMTP id jg11-20020a17090326cb00b001bc98dde857mr18753524plb.38.1693004164098;
        Fri, 25 Aug 2023 15:56:04 -0700 (PDT)
Received: from localhost (fwdproxy-prn-003.fbsv.net. [2a03:2880:ff:3::face:b00c])
        by smtp.gmail.com with ESMTPSA id i15-20020a170902c94f00b001b392bf9192sm2294253pla.145.2023.08.25.15.56.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 25 Aug 2023 15:56:03 -0700 (PDT)
From:   David Wei <dw@davidwei.uk>
To:     Jens Axboe <axboe@kernel.dk>,
        Pavel Begunkov <asml.silence@gmail.com>
Cc:     io-uring@vger.kernel.org, Mina Almasry <almasrymina@google.com>,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 02/11] io_uring: add mmap support for shared ifq ringbuffers
Date:   Fri, 25 Aug 2023 15:55:41 -0700
Message-Id: <20230825225550.957014-3-dw@davidwei.uk>
X-Mailer: git-send-email 2.39.3
In-Reply-To: <20230825225550.957014-1-dw@davidwei.uk>
References: <20230825225550.957014-1-dw@davidwei.uk>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

From: David Wei <davidhwei@meta.com>

This patch adds mmap support for ifq rbuf rings. There are two rings and
a struct io_rbuf_ring that contains the head and tail ptrs into each
ring.

Just like the io_uring SQ/CQ rings, userspace issues a single mmap call
using the io_uring fd w/ magic offset IORING_OFF_RBUF_RING. An opaque
ptr is returned to userspace, which is then expected to use the offsets
returned in the registration struct to get access to the head/tail and
rings.

Signed-off-by: David Wei <davidhwei@meta.com>
---
 include/uapi/linux/io_uring.h |  2 ++
 io_uring/io_uring.c           |  5 +++++
 io_uring/zc_rx.c              | 17 +++++++++++++++++
 3 files changed, 24 insertions(+)

diff --git a/include/uapi/linux/io_uring.h b/include/uapi/linux/io_uring.h
index 8f2a1061629b..28154abfe6f4 100644
--- a/include/uapi/linux/io_uring.h
+++ b/include/uapi/linux/io_uring.h
@@ -393,6 +393,8 @@ enum {
 #define IORING_OFF_PBUF_RING		0x80000000ULL
 #define IORING_OFF_PBUF_SHIFT		16
 #define IORING_OFF_MMAP_MASK		0xf8000000ULL
+#define IORING_OFF_RBUF_RING		0x20000000ULL
+#define IORING_OFF_RBUF_SHIFT		16
 
 /*
  * Filled with the offset for mmap(2)
diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
index 7705d18dceff..0b6c5508b1ca 100644
--- a/io_uring/io_uring.c
+++ b/io_uring/io_uring.c
@@ -3368,6 +3368,11 @@ static void *io_uring_validate_mmap_request(struct file *file,
 			return ERR_PTR(-EINVAL);
 		break;
 		}
+	case IORING_OFF_RBUF_RING:
+		if (!ctx->ifq)
+			return ERR_PTR(-EINVAL);
+		ptr = ctx->ifq->ring;
+		break;
 	default:
 		return ERR_PTR(-EINVAL);
 	}
diff --git a/io_uring/zc_rx.c b/io_uring/zc_rx.c
index 63bc6cd7d205..6c57c9b06e05 100644
--- a/io_uring/zc_rx.c
+++ b/io_uring/zc_rx.c
@@ -34,6 +34,7 @@ int io_register_zc_rx_ifq(struct io_ring_ctx *ctx,
 {
 	struct io_uring_zc_rx_ifq_reg reg;
 	struct io_zc_rx_ifq *ifq;
+	size_t ring_sz, rqes_sz, cqes_sz;
 	int ret;
 
 	if (copy_from_user(&reg, arg, sizeof(reg)))
@@ -58,6 +59,22 @@ int io_register_zc_rx_ifq(struct io_ring_ctx *ctx,
 	ifq->if_rxq_id = reg.if_rxq_id;
 	ctx->ifq = ifq;
 
+	ring_sz = sizeof(struct io_rbuf_ring);
+	rqes_sz = sizeof(struct io_uring_rbuf_rqe) * ifq->rq_entries;
+	cqes_sz = sizeof(struct io_uring_rbuf_cqe) * ifq->cq_entries;
+	reg.mmap_sz = ring_sz + rqes_sz + cqes_sz;
+	reg.rq_off.rqes = ring_sz;
+	reg.cq_off.cqes = ring_sz + rqes_sz;
+	reg.rq_off.head = offsetof(struct io_rbuf_ring, rq.head);
+	reg.rq_off.tail = offsetof(struct io_rbuf_ring, rq.tail);
+	reg.cq_off.head = offsetof(struct io_rbuf_ring, cq.head);
+	reg.cq_off.tail = offsetof(struct io_rbuf_ring, cq.tail);
+
+	if (copy_to_user(arg, &reg, sizeof(reg))) {
+		ret = -EFAULT;
+		goto err;
+	}
+
 	return 0;
 err:
 	io_zc_rx_ifq_free(ifq);
-- 
2.39.3

