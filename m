Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 72705678D5E
	for <lists+io-uring@lfdr.de>; Tue, 24 Jan 2023 02:24:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229476AbjAXBYW (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 23 Jan 2023 20:24:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51550 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232596AbjAXBYS (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 23 Jan 2023 20:24:18 -0500
Received: from mail-wr1-x432.google.com (mail-wr1-x432.google.com [IPv6:2a00:1450:4864:20::432])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 04E51298C1
        for <io-uring@vger.kernel.org>; Mon, 23 Jan 2023 17:23:51 -0800 (PST)
Received: by mail-wr1-x432.google.com with SMTP id e3so12435869wru.13
        for <io-uring@vger.kernel.org>; Mon, 23 Jan 2023 17:23:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=jVF3aoUddvtQic7EorccPZRhLLN8BUyKR0CFCSNtguY=;
        b=eb4LYoxo2fOZICyV8pqZbKqIiu8/LM4isRvczc/B1/qFsbGbzEsdde+DSONuv1l/ja
         D36T7Sl/F5XW+bxDtCsBN0TZdCL3xFG6sgsM2YlMz1g4pEZp4wP6XIfSjTGdlw6nwZDS
         BUFz/It+j5DQ3i14eKqSrsQjBEVx7P4g7/0vwwwIQ7xlA7TuYRKeSGPNuCPrmoiitdy3
         qgI2VlzV+g0P3PflEuWMIJPMaAc9sxwM5vJH2cNHuMauH/oZcDC1qPL6aYa55EUsLk/1
         IF4Fm9gc3BleqbRruu555F5hqnNR1OsMjXQGfHTjuotjdKmrq1LrKBh/o2Sw9KO5HJ3e
         v9UA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=jVF3aoUddvtQic7EorccPZRhLLN8BUyKR0CFCSNtguY=;
        b=ajX70J+t/1kH5CKqw/0lQ+1ag4tc8qwNpwe8+yotL3W0k9HVDUJTU9Kp93AESzBNrs
         4vIceHGL/51K6LGDxMYbD4NjpIfOYpSqyO7DRXr8e6W6yF0K/Em1S0pID3RX646zCxqX
         638tJSJHpakpsFABQwrBs1WNCR2HPV7rzr3bQtBsvdsvUgS4ThrsIoId+5WW8Nz9J+qV
         ari6MnDoITDvSwFHAkSmN17uzZ2075RtC5XE4me5l/KVXheG016u7nII9obb/Mh+S7j0
         /6XpAYY59DRsX/AQc75VJKhaRc6SfTRJvThRMxSPenulFvW6L3+qXw7eMAvEtXTpkAYI
         31Lw==
X-Gm-Message-State: AFqh2krj88WFJ0MWGMloCZJof9yX0TDWR2Dispcq9kj2/M+qRo3BJSMH
        nzcPDLpdeR42xpCSW6WFO5jaNFlXQ1M=
X-Google-Smtp-Source: AMrXdXuKGNq7VjoQFO9KxXG/SBSP/Cf1yqPdKYEjA8+v9nQmthkfoq2KleAj/QEzOjEuFjEZg4u3Zg==
X-Received: by 2002:a05:6000:1f81:b0:2b5:dc24:e08e with SMTP id bw1-20020a0560001f8100b002b5dc24e08emr22028229wrb.69.1674523427786;
        Mon, 23 Jan 2023 17:23:47 -0800 (PST)
Received: from 127.0.0.1localhost (92.41.37.76.threembb.co.uk. [92.41.37.76])
        by smtp.gmail.com with ESMTPSA id t20-20020adfa2d4000000b002bdcce37d31sm712912wra.99.2023.01.23.17.23.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 23 Jan 2023 17:23:47 -0800 (PST)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     io-uring@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>, asml.silence@gmail.com
Subject: [PATCH liburing 3/5] test/msg_ring: test msg_ring to a disabled ring
Date:   Tue, 24 Jan 2023 01:21:47 +0000
Message-Id: <30b4fae32616f4241f209fd35e397d4990d9df76.1674523156.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <cover.1674523156.git.asml.silence@gmail.com>
References: <cover.1674523156.git.asml.silence@gmail.com>
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

A regression test trying to message IORING_SETUP_R_DISABLED rings.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 test/msg-ring.c | 55 +++++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 55 insertions(+)

diff --git a/test/msg-ring.c b/test/msg-ring.c
index 6db7680..66c60b3 100644
--- a/test/msg-ring.c
+++ b/test/msg-ring.c
@@ -191,6 +191,49 @@ err:
 	return 1;
 }
 
+static int test_disabled_ring(struct io_uring *ring, int flags)
+{
+	struct io_uring_cqe *cqe;
+	struct io_uring_sqe *sqe;
+	struct io_uring disabled_ring;
+	int ret;
+
+	flags |= IORING_SETUP_R_DISABLED;
+	ret = io_uring_queue_init(8, &disabled_ring, flags);
+	if (ret) {
+		fprintf(stderr, "ring setup failed: %d\n", ret);
+		return 1;
+	}
+
+	sqe = io_uring_get_sqe(ring);
+	io_uring_prep_msg_ring(sqe, disabled_ring.ring_fd, 0x10, 0x1234, 0);
+	sqe->user_data = 1;
+
+	ret = io_uring_submit(ring);
+	if (ret != 1) {
+		fprintf(stderr, "sqe submit failed: %d\n", ret);
+		return 1;
+	}
+
+	ret = io_uring_wait_cqe(ring, &cqe);
+	if (ret < 0) {
+		fprintf(stderr, "wait completion %d\n", ret);
+		return 1;
+	}
+	if (cqe->res != 0 && cqe->res != -EBADFD) {
+		fprintf(stderr, "cqe res %d\n", cqe->res);
+		return 1;
+	}
+	if (cqe->user_data != 1) {
+		fprintf(stderr, "user_data %llx\n", (long long) cqe->user_data);
+		return 1;
+	}
+
+	io_uring_cqe_seen(ring, cqe);
+	io_uring_queue_exit(&disabled_ring);
+	return 0;
+}
+
 int main(int argc, char *argv[])
 {
 	struct io_uring ring, ring2, pring;
@@ -280,6 +323,18 @@ int main(int argc, char *argv[])
 			}
 		}
 		io_uring_queue_exit(&ring);
+
+		if (test_disabled_ring(&ring2, 0)) {
+			fprintf(stderr, "test_disabled_ring failed\n");
+			return T_EXIT_FAIL;
+		}
+
+		if (test_disabled_ring(&ring2, IORING_SETUP_SINGLE_ISSUER |
+						IORING_SETUP_DEFER_TASKRUN)) {
+			fprintf(stderr, "test_disabled_ring defer failed\n");
+			return T_EXIT_FAIL;
+		}
+
 	}
 
 	return T_EXIT_PASS;
-- 
2.38.1

