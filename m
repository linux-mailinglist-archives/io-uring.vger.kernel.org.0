Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6FD15678D60
	for <lists+io-uring@lfdr.de>; Tue, 24 Jan 2023 02:24:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230185AbjAXBYX (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 23 Jan 2023 20:24:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51408 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232771AbjAXBYS (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 23 Jan 2023 20:24:18 -0500
Received: from mail-wm1-x335.google.com (mail-wm1-x335.google.com [IPv6:2a00:1450:4864:20::335])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2F398303EC
        for <io-uring@vger.kernel.org>; Mon, 23 Jan 2023 17:23:51 -0800 (PST)
Received: by mail-wm1-x335.google.com with SMTP id f19-20020a1c6a13000000b003db0ef4dedcso11796955wmc.4
        for <io-uring@vger.kernel.org>; Mon, 23 Jan 2023 17:23:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=nxb+pwONt2jMb670XY68A29QyjdzIGjK2DG7ZXaNHME=;
        b=Mp9YptAM6Cwnaug2lNqRwx1eMzrBM+LQ947lLo3MIRkjDsBHLeuPYk3xiv6acHFj1c
         s5tSVbSALRtZJ7D7PvV/dv4+TQ9FOtrYyyVU/owIu+GoWxYgSOlycRlXInOifp3AOGH7
         CS8LjcdprZITcdAxC6rncM8gaoWpFlw2K8+EpQHM/7LNWpynEbRpJXIms/OkNVReQFtY
         9lNfYblSPrYvV+aos0OvWjKl77/ktUt5mctSZZZ9Bt3hH3sTgm8rF2qN89fHJ4HpQ032
         McwogEQVqf7wyJvCpFgCPWqD08tvp9csbiw8Wa2LMk6StBzlo+BGQtCdAX4O4U0DZFk9
         bs8w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=nxb+pwONt2jMb670XY68A29QyjdzIGjK2DG7ZXaNHME=;
        b=jaOL9oC16eZbxa3eaa/+cDhzbKCmus5UW9kMNPI3xBvfERLT2sWc3pvT4eKaQnUnD7
         dtJLbgbBbys4D6NjSYG5qK96/cpf+pYNwvQQMdBsxjWwPBPR6zUPPmv0r1ehZ0pl7gSI
         /AjsEzXXj4kJpT+P2m4H2Fds12jYb/32SHYpDcaF7N5ifuqNTLYrY4EUpMZVWRrGmH9s
         srXEyUToCSj3g9ffGL+ljK38aNP/TSS7NDWr7lVOPzymTtGVi10lnRghwtJOXMsV8ull
         k/uFoSoKZDr9uKo6rillvEep8a2CsZKeoyqRPAiF8b0GT0zTTq5fMEzrm5QPA7FwQ9B6
         E4QA==
X-Gm-Message-State: AFqh2kqiXHfZ+SoR/QODW0q9upaa1nbmy+bfPHAO/EZKA+95rLgHFmjF
        JIdJZqOUtOqcv3IsBdEJyPWt7+Mvjs8=
X-Google-Smtp-Source: AMrXdXuA6d9rlpM5uMJLpxCIJ7fMGCCYG23yhbENE8IvK+g5j9w6ITOyF792FImbZhp3UTaWySRFmw==
X-Received: by 2002:a05:600c:4928:b0:3d9:a5a2:65fa with SMTP id f40-20020a05600c492800b003d9a5a265famr25850099wmp.7.1674523429574;
        Mon, 23 Jan 2023 17:23:49 -0800 (PST)
Received: from 127.0.0.1localhost (92.41.37.76.threembb.co.uk. [92.41.37.76])
        by smtp.gmail.com with ESMTPSA id t20-20020adfa2d4000000b002bdcce37d31sm712912wra.99.2023.01.23.17.23.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 23 Jan 2023 17:23:49 -0800 (PST)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     io-uring@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>, asml.silence@gmail.com
Subject: [PATCH liburing 5/5] tests/msg_ring: remote submit to a deferred tw ring
Date:   Tue, 24 Jan 2023 01:21:49 +0000
Message-Id: <6aabba6058e0029104174379c4c3135d6af835f5.1674523156.git.asml.silence@gmail.com>
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

Test sending messages to a deferred ring from another task

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 test/msg-ring.c | 80 ++++++++++++++++++++++++++++++++++++++++++++++++-
 1 file changed, 79 insertions(+), 1 deletion(-)

diff --git a/test/msg-ring.c b/test/msg-ring.c
index 495c127..cb6687f 100644
--- a/test/msg-ring.c
+++ b/test/msg-ring.c
@@ -146,6 +146,79 @@ err:
 	return 1;
 }
 
+static void *remote_submit_fn(void *data)
+{
+	struct io_uring_sqe *sqe;
+	struct io_uring_cqe *cqe;
+	struct io_uring *target = data;
+	struct io_uring ring;
+	int ret;
+
+	ret = io_uring_queue_init(8, &ring, 0);
+	if (ret) {
+		fprintf(stderr, "thread ring setup failed: %d\n", ret);
+		goto err;
+	}
+	sqe = io_uring_get_sqe(&ring);
+	if (!sqe) {
+		fprintf(stderr, "get sqe failed\n");
+		goto err;
+	}
+
+	io_uring_prep_msg_ring(sqe, target->ring_fd, 0x20, 0x5aa5, 0);
+	sqe->user_data = 1;
+
+	ret = io_uring_submit(&ring);
+	if (ret <= 0) {
+		fprintf(stderr, "sqe submit failed: %d\n", ret);
+		goto err;
+	}
+
+	ret = io_uring_wait_cqe(&ring, &cqe);
+	if (ret < 0) {
+		fprintf(stderr, "wait completion %d\n", ret);
+		goto err;
+	}
+	if (cqe->res != 0 || cqe->user_data != 1) {
+		fprintf(stderr, "invalid cqe\n");
+		goto err;
+	}
+	io_uring_cqe_seen(&ring, cqe);
+	io_uring_queue_exit(&ring);
+	return NULL;
+err:
+	return (void *) (unsigned long) 1;
+}
+
+static int test_remote_submit(struct io_uring *target)
+{
+	struct io_uring_cqe *cqe;
+	pthread_t thread;
+	void *tret;
+	int ret;
+
+	pthread_create(&thread, NULL, remote_submit_fn, target);
+
+	ret = io_uring_wait_cqe(target, &cqe);
+	if (ret < 0) {
+		fprintf(stderr, "wait completion %d\n", ret);
+		goto err;
+	}
+	if (cqe->res != 0x20) {
+		fprintf(stderr, "cqe res %d\n", cqe->res);
+		return -1;
+	}
+	if (cqe->user_data != 0x5aa5) {
+		fprintf(stderr, "user_data %llx\n", (long long) cqe->user_data);
+		return -1;
+	}
+	io_uring_cqe_seen(target, cqe);
+	pthread_join(thread, &tret);
+	return 0;
+err:
+	return 1;
+}
+
 static int test_invalid(struct io_uring *ring, bool fixed)
 {
 	struct io_uring_cqe *cqe;
@@ -322,6 +395,12 @@ int main(int argc, char *argv[])
 				return T_EXIT_FAIL;
 			}
 		}
+
+		ret = test_remote_submit(&ring);
+		if (ret) {
+			fprintf(stderr, "test_remote_submit failed\n");
+			return T_EXIT_FAIL;
+		}
 		io_uring_queue_exit(&ring);
 
 		if (test_disabled_ring(&ring2, 0)) {
@@ -334,7 +413,6 @@ int main(int argc, char *argv[])
 			fprintf(stderr, "test_disabled_ring defer failed\n");
 			return T_EXIT_FAIL;
 		}
-
 	}
 
 	io_uring_queue_exit(&ring2);
-- 
2.38.1

