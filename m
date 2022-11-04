Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3334061952A
	for <lists+io-uring@lfdr.de>; Fri,  4 Nov 2022 12:08:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230507AbiKDLIA (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 4 Nov 2022 07:08:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42612 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231493AbiKDLHr (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 4 Nov 2022 07:07:47 -0400
Received: from mail-ed1-x52e.google.com (mail-ed1-x52e.google.com [IPv6:2a00:1450:4864:20::52e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 61FBA644D
        for <io-uring@vger.kernel.org>; Fri,  4 Nov 2022 04:07:46 -0700 (PDT)
Received: by mail-ed1-x52e.google.com with SMTP id r14so7075516edc.7
        for <io-uring@vger.kernel.org>; Fri, 04 Nov 2022 04:07:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ukBWgP1IqPf+hr/q+Re1wnZEtefqk8gst+cV6x82YFM=;
        b=iQyrYQkbTKC3q2njaAxZIxhDBJtMKZTGQuoiM5YImXfasCROMmVOuXqYTRQY8ldguH
         S01gMW0nFLgmVXBJZunCaXOe+hnTu1Mc1onWE2fWOM7BW3evGBLjLyWrHcZSPO1TDY58
         PY3fJ9gBEpwX9g4oX7YCzj+aINQxeDiUSCwvtPpny5lfA9La87ENz+8BHzs5G+V2+xet
         2caqjwuNyDweJec8uQz4RHP4QS+gyeRrl1Qzs1jM3EPjkL6CVf38VLzcYYVYiYyqAwpC
         NoMBkvtxjpzX69Kj4yM1sZJ7CG7zIXW7hsMWaR5Rj8aKFzThfDjaMmBiFe+obcDX0Tp+
         fsjA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=ukBWgP1IqPf+hr/q+Re1wnZEtefqk8gst+cV6x82YFM=;
        b=u7jE5vHBZoFaQMsz+G/NO3KSgw4h/NyLfcJRJ+Ey69cm6f8kKvqn8YgmMRvqHh1gYQ
         mkvQo/684+9sKSQyGO4IgoQ1/RGvivpB4YbV80XAcO9osz8VOnYqyIQsAPGTPV/vzXg8
         Gi3cJ7w8RPXwVyDcsOZvt8lfeHza799tE0ybKyV/oQCMRHfTm7D60IAtWWssu8Vq6A53
         MQusC3ikaMQhOGdRb3iElV3D0jF8MeHejivVNcdu904vPN7qZ9olq1nVj1xTgT5GSwh7
         kY5RFafyp+e39Jf2X8o9PE1RCM4pJ4N3zjJFdWar+yVud2NVMA9KwFUSo/yBtpDLKiPX
         wo/w==
X-Gm-Message-State: ACrzQf2cRU69wjtMH+jqawEo0n/nv12YyRhTZz+lLjz1Cwlo5K+7eC6E
        TTR8byowB0BNDl9VzEvIjJaOiGlatT8=
X-Google-Smtp-Source: AMsMyM6UPvLdhEZo+nnPyU7g6TmQ8VmRuhgDhE1MkLzt866b6wCUocG3CllCd8xlC0BsFk1sk34rxA==
X-Received: by 2002:a05:6402:164d:b0:464:4ac8:d269 with SMTP id s13-20020a056402164d00b004644ac8d269mr6404704edx.394.1667560064609;
        Fri, 04 Nov 2022 04:07:44 -0700 (PDT)
Received: from 127.0.0.1localhost.com ([2620:10d:c092:600::2:4173])
        by smtp.gmail.com with ESMTPSA id bg19-20020a170906a05300b0078df26efb7dsm1665491ejb.107.2022.11.04.04.07.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 04 Nov 2022 04:07:44 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     io-uring@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>, asml.silence@gmail.com
Subject: [PATCH liburing 2/3] tests/zc: add control flags tests
Date:   Fri,  4 Nov 2022 11:05:52 +0000
Message-Id: <49b3b714bce66a056b645afe894748f7cabd548d.1667559818.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.38.0
In-Reply-To: <cover.1667559818.git.asml.silence@gmail.com>
References: <cover.1667559818.git.asml.silence@gmail.com>
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

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 test/send-zerocopy.c | 26 +++++++++++++++++++++-----
 1 file changed, 21 insertions(+), 5 deletions(-)

diff --git a/test/send-zerocopy.c b/test/send-zerocopy.c
index 30b50e1..6e637f4 100644
--- a/test/send-zerocopy.c
+++ b/test/send-zerocopy.c
@@ -123,7 +123,7 @@ static int test_send_faults(int sock_tx, int sock_rx)
 	int msg_flags = 0;
 	unsigned zc_flags = 0;
 	int payload_size = 100;
-	int ret, i, nr_cqes = 2;
+	int ret, i, nr_cqes, nr_reqs = 3;
 	struct io_uring ring;
 
 	ret = io_uring_queue_init(32, &ring, IORING_SETUP_SUBMIT_ALL);
@@ -132,28 +132,44 @@ static int test_send_faults(int sock_tx, int sock_rx)
 		return -1;
 	}
 
+	/* invalid buffer */
 	sqe = io_uring_get_sqe(&ring);
 	io_uring_prep_send_zc(sqe, sock_tx, (void *)1UL, payload_size,
 			      msg_flags, zc_flags);
 	sqe->user_data = 1;
 
+	/* invalid address */
 	sqe = io_uring_get_sqe(&ring);
 	io_uring_prep_send_zc(sqe, sock_tx, tx_buffer, payload_size,
 			      msg_flags, zc_flags);
-	sqe->user_data = 2;
 	io_uring_prep_send_set_addr(sqe, (const struct sockaddr *)1UL,
 				    sizeof(struct sockaddr_in6));
+	sqe->user_data = 2;
+
+	/* invalid send/recv flags */
+	sqe = io_uring_get_sqe(&ring);
+	io_uring_prep_send_zc(sqe, sock_tx, tx_buffer, payload_size,
+			      msg_flags, ~0U);
+	sqe->user_data = 3;
 
 	ret = io_uring_submit(&ring);
-	assert(ret == 2);
+	assert(ret == nr_reqs);
 
+	nr_cqes = nr_reqs;
 	for (i = 0; i < nr_cqes; i++) {
 		ret = io_uring_wait_cqe(&ring, &cqe);
 		assert(!ret);
-		assert(cqe->user_data <= 2);
+		assert(cqe->user_data <= nr_reqs);
 
 		if (!(cqe->flags & IORING_CQE_F_NOTIF)) {
-			assert(cqe->res == -EFAULT);
+			int expected = (cqe->user_data == 3) ? -EINVAL : -EFAULT;
+
+			if (cqe->res != expected) {
+				fprintf(stderr, "invalid cqe res %i vs expected %i, "
+					"user_data %i\n",
+					cqe->res, expected, (int)cqe->user_data);
+				return -1;
+			}
 			if (cqe->flags & IORING_CQE_F_MORE)
 				nr_cqes++;
 		}
-- 
2.38.0

