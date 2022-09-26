Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CC2645EA973
	for <lists+io-uring@lfdr.de>; Mon, 26 Sep 2022 17:03:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235396AbiIZPDC (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 26 Sep 2022 11:03:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56762 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234536AbiIZPCT (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 26 Sep 2022 11:02:19 -0400
Received: from mail-wr1-x435.google.com (mail-wr1-x435.google.com [IPv6:2a00:1450:4864:20::435])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8E4C44F19B
        for <io-uring@vger.kernel.org>; Mon, 26 Sep 2022 06:34:29 -0700 (PDT)
Received: by mail-wr1-x435.google.com with SMTP id r7so10291814wrm.2
        for <io-uring@vger.kernel.org>; Mon, 26 Sep 2022 06:34:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date;
        bh=qoamLtSYKDbF7m1xh1KcYGmvTM3OlM4cGMedGE/GRfc=;
        b=kutX7WsmyLRQCVSrwIs1SYx5RKf44zQj2tnHSCDahdmgj5kpeO/AEELba1GfuT68so
         K/BaiJNcK4aEGpnkpRwO+J8r3s6kjEU3Hf+trhXjRBGaJTOITWnzr42qR5d1yg6cN5sT
         kZY6RPN+UgOZvWqaTsGxMu5ngPaW5MbDJeDfVWhJ3AIuhFILQhZjqPS8mtKsY41+z71R
         3EdswADJn6UB6BAu+ETbw/57lEqEDd2L0fJQNSADSsyVQbvezM+jWborVhQHFjzWU8zR
         +SxJQ9znSpO6iz4gvUIOOkCsUV7jWWTJfnSUh9Q3rCVmEpestjpxdN3vY3D+T0gFucKC
         1KIw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date;
        bh=qoamLtSYKDbF7m1xh1KcYGmvTM3OlM4cGMedGE/GRfc=;
        b=NZTQRqFFjPoVHlj6i8dmXKkztaL9GNrnhT+8bKMRRQud+tE8H5nwJ0IkHvpNpRJV/d
         g/iBPXM4xRmt8qK0zAouEsBqVYe8VVLzTcurLp6ea2dTe8FBVhVTcdjVpqL7nTajFG1Z
         06jtdXUXR/iSGa+G41L5sowBtxj3tWksed11YCMbBXv3rgZsAg7+gOBcnau34OaG+A1t
         cvD2yCqBGafipShPFDLfNsCL+60u2wqdJZOVu0DgMI7EXAeD12Bvx18ByAWb+58uNhcs
         FJeko9MHVHt4xB3kOHGcvW2jWwRpWyv5lnNwa3h6hkFqrZalJNHIJi4gg1rgBA+Ww0MV
         HqcA==
X-Gm-Message-State: ACrzQf0UgFhpBq0uLLjIHCzefPdwD46EIpD5FEUsB1lOdUrvntq5p2dB
        1LqxUv+zi1qI0BewPCt9ByAEELYAmqA=
X-Google-Smtp-Source: AMsMyM5y8dZPCMtLfvhrGEOO4g9JpXo79gjiSJKfHhHY7+cHs0bnZXMLNC+mD8GLItQVjFH+qex8qA==
X-Received: by 2002:adf:e841:0:b0:22a:cb58:f8c1 with SMTP id d1-20020adfe841000000b0022acb58f8c1mr13802682wrn.173.1664199267766;
        Mon, 26 Sep 2022 06:34:27 -0700 (PDT)
Received: from 127.0.0.1localhost (188.28.209.34.threembb.co.uk. [188.28.209.34])
        by smtp.gmail.com with ESMTPSA id r8-20020a05600c35c800b003a84375d0d1sm11797195wmq.44.2022.09.26.06.34.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 26 Sep 2022 06:34:27 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     io-uring@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>, asml.silence@gmail.com
Subject: [PATCH for-next] tests: test async_data double-free with sendzc
Date:   Mon, 26 Sep 2022 14:33:12 +0100
Message-Id: <aae98072a1e606a7f11dd68cf904d1ccb9e39ebe.1664193624.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.37.2
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

Similar to send_recv.c:test_invalid().

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 test/send-zerocopy.c | 59 ++++++++++++++++++++++++++++++++++++++++++--
 1 file changed, 57 insertions(+), 2 deletions(-)

diff --git a/test/send-zerocopy.c b/test/send-zerocopy.c
index 80723de..1c4e5f2 100644
--- a/test/send-zerocopy.c
+++ b/test/send-zerocopy.c
@@ -533,6 +533,55 @@ static bool io_check_zc_sendmsg(struct io_uring *ring)
 	return p->ops_len > IORING_OP_SENDMSG_ZC;
 }
 
+/* see also send_recv.c:test_invalid */
+static int test_invalid_zc(void)
+{
+	struct io_uring ring;
+	int ret, fds[2];
+	struct io_uring_cqe *cqe;
+	struct io_uring_sqe *sqe;
+	bool notif = false;
+
+	if (!has_sendmsg)
+		return 0;
+
+	ret = t_create_ring(8, &ring, 0);
+	if (ret)
+		return ret;
+	ret = t_create_socket_pair(fds, true);
+	if (ret)
+		return ret;
+
+	sqe = io_uring_get_sqe(&ring);
+	io_uring_prep_sendmsg(sqe, fds[0], NULL, MSG_WAITALL);
+	sqe->opcode = IORING_OP_SENDMSG_ZC;
+	sqe->flags |= IOSQE_ASYNC;
+
+	ret = io_uring_submit(&ring);
+	if (ret != 1) {
+		fprintf(stderr, "submit failed %i\n", ret);
+		return ret;
+	}
+	ret = io_uring_wait_cqe(&ring, &cqe);
+	if (ret)
+		return 1;
+	if (cqe->flags & IORING_CQE_F_MORE)
+		notif = true;
+	io_uring_cqe_seen(&ring, cqe);
+
+	if (notif) {
+		ret = io_uring_wait_cqe(&ring, &cqe);
+		if (ret)
+			return 1;
+		io_uring_cqe_seen(&ring, cqe);
+	}
+
+	io_uring_queue_exit(&ring);
+	close(fds[0]);
+	close(fds[1]);
+	return 0;
+}
+
 int main(int argc, char *argv[])
 {
 	struct io_uring ring;
@@ -602,7 +651,7 @@ int main(int argc, char *argv[])
 	ret = test_async_addr(&ring);
 	if (ret) {
 		fprintf(stderr, "test_async_addr() failed\n");
-		return ret;
+		return T_EXIT_FAIL;
 	}
 
 	ret = t_register_buffers(&ring, buffers_iov, ARRAY_SIZE(buffers_iov));
@@ -617,7 +666,13 @@ int main(int argc, char *argv[])
 	ret = test_inet_send(&ring);
 	if (ret) {
 		fprintf(stderr, "test_inet_send() failed\n");
-		return ret;
+		return T_EXIT_FAIL;
+	}
+
+	ret = test_invalid_zc();
+	if (ret) {
+		fprintf(stderr, "test_invalid_zc() failed\n");
+		return T_EXIT_FAIL;
 	}
 out:
 	io_uring_queue_exit(&ring);
-- 
2.37.2

