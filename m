Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7DFCA7892F9
	for <lists+io-uring@lfdr.de>; Sat, 26 Aug 2023 03:22:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231621AbjHZBWD (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 25 Aug 2023 21:22:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34856 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231618AbjHZBVd (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 25 Aug 2023 21:21:33 -0400
Received: from mail-pl1-x62d.google.com (mail-pl1-x62d.google.com [IPv6:2607:f8b0:4864:20::62d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9B384212B
        for <io-uring@vger.kernel.org>; Fri, 25 Aug 2023 18:21:30 -0700 (PDT)
Received: by mail-pl1-x62d.google.com with SMTP id d9443c01a7336-1c09673b006so10618825ad.1
        for <io-uring@vger.kernel.org>; Fri, 25 Aug 2023 18:21:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=davidwei-uk.20221208.gappssmtp.com; s=20221208; t=1693012890; x=1693617690;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=fQmFAOYPyQYmMwkH3n9RRbmoobUo7gWIqTt8UijUgLA=;
        b=J11ogROBx0CkEAmY2aTSLQLiSs+xEIt8EgRKXW1j5os3+EAb2o5O7wWEDow0f0UgNx
         aj+HljEkG8JdblcQd7mJNLVm74azGqKhFN+utnP9roj3pkFbAk9u8+0PJbsXS10YfKXK
         i9XEesjAelqR+IcKSeJAyDaH1IR0X1zryh9TFl2WtLTMXQNBcVSkM4qbJ7MEYQiKUraV
         DSeCCfbWRhJdu4bjMWv5vU6/NebRtxBYq3zSqSTIxxnX49i+MEhWn5M8kXXk9DybdrmI
         j0IT3mV7Ipk1YpJ3cduIhEZHxVPpCWZIn0a/zsSFnN6Yqar/VLRU+EJq1MhkxeKGxQmU
         Q4JA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1693012890; x=1693617690;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=fQmFAOYPyQYmMwkH3n9RRbmoobUo7gWIqTt8UijUgLA=;
        b=AGoRmM3AgwQ22zlaYbHxI5WTWvvJ0SXxOXn493YwSsTeaOnlW+KYx2Frkpv/2luXSp
         MWGcfHtl4xd8ORvtuwiWOrBD+ww/2F8GmCfDoh3rwyeUgfZoQ4+lNqd3QBshi0if8fO8
         rSXRb5gi/GB2Oo2E3nkL79s51HQi2e0zY6VryQy0a3PA5eQ0ssa5ffzBl6Xq/1hT6pul
         bRt7goJY39v3fhmE8uqXCy2PHq7WIVcdqndfv6gA85d4PSSOyjn62Omfv4W3hpAvYFjG
         95DLe/hifuYameng5Agv2PmdSosCKQMkfFh6Kt6ES9noc1aq+EVMkg6hui74e/RB2aOH
         5umQ==
X-Gm-Message-State: AOJu0Yzm6MuG4CyMnwU1B+4peCYiIouQASQRbw8ntmPYKGGgp/tt1DgY
        uDerkqSu4OcltRP0ddPjLI9KH58eXb8y5DiYTWlfdg==
X-Google-Smtp-Source: AGHT+IGIo+3adK4mhuENDaoYdhwpNFabeFpYFMgK5SCDkwzDovceVadwG1Af3T5u1BmEPm/ggncWiA==
X-Received: by 2002:a17:902:6acc:b0:1c0:98fe:3677 with SMTP id i12-20020a1709026acc00b001c098fe3677mr10580663plt.56.1693012890112;
        Fri, 25 Aug 2023 18:21:30 -0700 (PDT)
Received: from localhost (fwdproxy-prn-016.fbsv.net. [2a03:2880:ff:10::face:b00c])
        by smtp.gmail.com with ESMTPSA id b18-20020a170902d31200b001b53c8659fesm2417216plc.30.2023.08.25.18.21.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 25 Aug 2023 18:21:29 -0700 (PDT)
From:   David Wei <dw@davidwei.uk>
To:     Jens Axboe <axboe@kernel.dk>,
        Pavel Begunkov <asml.silence@gmail.com>
Cc:     io-uring@vger.kernel.org, netdev@vger.kernel.org,
        Mina Almasry <almasrymina@google.com>,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 02/11] io_uring: add mmap support for shared ifq ringbuffers
Date:   Fri, 25 Aug 2023 18:19:45 -0700
Message-Id: <20230826011954.1801099-3-dw@davidwei.uk>
X-Mailer: git-send-email 2.39.3
In-Reply-To: <20230826011954.1801099-1-dw@davidwei.uk>
References: <20230826011954.1801099-1-dw@davidwei.uk>
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

