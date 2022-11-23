Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EF154635BE3
	for <lists+io-uring@lfdr.de>; Wed, 23 Nov 2022 12:36:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236491AbiKWLgi (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 23 Nov 2022 06:36:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46534 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236844AbiKWLgh (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 23 Nov 2022 06:36:37 -0500
Received: from mail-wr1-x435.google.com (mail-wr1-x435.google.com [IPv6:2a00:1450:4864:20::435])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4944311DA39
        for <io-uring@vger.kernel.org>; Wed, 23 Nov 2022 03:36:36 -0800 (PST)
Received: by mail-wr1-x435.google.com with SMTP id x17so15496493wrn.6
        for <io-uring@vger.kernel.org>; Wed, 23 Nov 2022 03:36:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=CnrNjjHUtd8weh2wxZbyMyM1wu77vG5OfU8KEdIwyQc=;
        b=N3qUI4kBg6GooWVcVvblmc6j0PeokL0AkaNLmUSAPcoER6yoAvV7gukjjrrZr8SZjv
         IDKUhZCGon3yiR5Bhk/+GrJHpxSFnCGW4efuOqKVhqKy6TwrumJrwy301T6Jvf+agPE+
         0e4zfXsG2qB7aL6c/LA5wAeFKu9ZoBur76ABxF8FHUM5JFmX79F62R2Nw0WnL3vbnCg3
         07RW4j7mASrdLEZK7wDAAM76aOIqs6llC/m4mkLDuX6XvTUOES0itBsEyWg6v4/IgdXA
         TqXtuYENXnxbxdQff2A7beQ1v4nHKWh+fPeMOR+TeNLlc9ddhOTzxN/4Ok13vM9bTHbc
         Vjdw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=CnrNjjHUtd8weh2wxZbyMyM1wu77vG5OfU8KEdIwyQc=;
        b=SKfo+Y793mDNrfjVCVyxCWu25II5dlAYci1Ht4TLxANjG0mINhaCCS1He0Ynr0HUzr
         9ssTdXdN9x5NpgDAwgvsKE/t93Hh6rYr6HI6rrTlOgdmr63SlLFl5nD5LXwM26GYg6TM
         EiP0nkjjQBhNyYVx/sbwynf3P34VuawK9jSk1aanFXH0PlZLkCTKSlU8Um1Snuuo9T56
         X814Mwbvoy2JhgPlG52WhsnfYF8X1V/XwK+Wjpw4eGJKrPX1IHsDH7onCpx/gcPf7+4+
         SPn3KSRlKMUcKRthuM82gABcH0FAgeJhH9MCN2LXmzcTxIU1mbP9TnJkBMkWFkc6Zgou
         TamA==
X-Gm-Message-State: ANoB5pk2M5NeUARFxIwOt1gplKTYHtWk0XdGvjgSWblwUUIZzbcwVvMe
        zv06hrE4hS7lLFCdLN+83PvLX4VySyo=
X-Google-Smtp-Source: AA0mqf7lk8+mDoW6Ftd+nA9JPFMA7zCGJhRDnW40DgzJ12LyL+TUdTjScBc5cJCHRm0QhMson2IaIQ==
X-Received: by 2002:a05:6000:5:b0:241:d692:3cc5 with SMTP id h5-20020a056000000500b00241d6923cc5mr8822209wrx.419.1669203394670;
        Wed, 23 Nov 2022 03:36:34 -0800 (PST)
Received: from 127.0.0.1localhost.com ([2620:10d:c092:600::2:e1b])
        by smtp.gmail.com with ESMTPSA id y9-20020a5d4ac9000000b00241ce5d605dsm10854508wrs.110.2022.11.23.03.36.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 23 Nov 2022 03:36:34 -0800 (PST)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     io-uring@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>, asml.silence@gmail.com
Subject: [PATCH liburing 3/3] tests: check for missing multipoll events
Date:   Wed, 23 Nov 2022 11:35:10 +0000
Message-Id: <4b0f4d96027b69d9b0f8392887dc973c5afffe31.1669079092.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <cover.1669079092.git.asml.silence@gmail.com>
References: <cover.1669079092.git.asml.silence@gmail.com>
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
 test/poll.c | 93 +++++++++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 93 insertions(+)

diff --git a/test/poll.c b/test/poll.c
index f0c1c40..a7db7dc 100644
--- a/test/poll.c
+++ b/test/poll.c
@@ -11,10 +11,17 @@
 #include <signal.h>
 #include <poll.h>
 #include <sys/wait.h>
+#include <error.h>
 
 #include "helpers.h"
 #include "liburing.h"
 
+static void do_setsockopt(int fd, int level, int optname, int val)
+{
+	if (setsockopt(fd, level, optname, &val, sizeof(val)))
+		error(1, errno, "setsockopt %d.%d: %d", level, optname, val);
+}
+
 static int test_basic(void)
 {
 	struct io_uring_cqe *cqe;
@@ -94,6 +101,85 @@ static int test_basic(void)
 	return 0;
 }
 
+static int test_missing_events(void)
+{
+	struct io_uring_cqe *cqe;
+	struct io_uring_sqe *sqe;
+	struct io_uring ring;
+	int i, ret, sp[2];
+	char buf[2] = {};
+	int res_mask = 0;
+
+	if (!t_probe_defer_taskrun())
+		return 0;
+
+	ret = io_uring_queue_init(8, &ring, IORING_SETUP_SINGLE_ISSUER |
+					    IORING_SETUP_DEFER_TASKRUN);
+	if (ret) {
+		fprintf(stderr, "ring setup failed: %d\n", ret);
+		return 1;
+	}
+
+	if (socketpair(AF_UNIX, SOCK_STREAM, 0, sp) != 0) {
+		perror("Failed to create Unix-domain socket pair\n");
+		return 1;
+	}
+	do_setsockopt(sp[0], SOL_SOCKET, SO_SNDBUF, 1);
+	ret = send(sp[0], buf, sizeof(buf), 0);
+	if (ret != sizeof(buf)) {
+		perror("send failed\n");
+		return 1;
+	}
+
+	sqe = io_uring_get_sqe(&ring);
+	io_uring_prep_poll_multishot(sqe, sp[0], POLLIN|POLLOUT);
+	ret = io_uring_submit(&ring);
+	if (ret != 1) {
+		fprintf(stderr, "sqe submit failed: %d\n", ret);
+		return 1;
+	}
+
+	/* trigger EPOLLIN */
+	ret = send(sp[1], buf, sizeof(buf), 0);
+	if (ret != sizeof(buf)) {
+		fprintf(stderr, "send sp[1] failed %i %i\n", ret, errno);
+		return 1;
+	}
+
+	/* trigger EPOLLOUT */
+	ret = recv(sp[1], buf, sizeof(buf), 0);
+	if (ret != sizeof(buf)) {
+		perror("recv failed\n");
+		return 1;
+	}
+
+	for (i = 0; ; i++) {
+		if (i == 0)
+			ret = io_uring_wait_cqe(&ring, &cqe);
+		else
+			ret = io_uring_peek_cqe(&ring, &cqe);
+
+		if (i != 0 && ret == -EAGAIN) {
+			break;
+		}
+		if (ret) {
+			fprintf(stderr, "wait completion %d, %i\n", ret, i);
+			return 1;
+		}
+		res_mask |= cqe->res;
+		io_uring_cqe_seen(&ring, cqe);
+	}
+
+	if ((res_mask & (POLLIN|POLLOUT)) != (POLLIN|POLLOUT)) {
+		fprintf(stderr, "missing poll events %i\n", res_mask);
+		return 1;
+	}
+	io_uring_queue_exit(&ring);
+	close(sp[0]);
+	close(sp[1]);
+	return 0;
+}
+
 int main(int argc, char *argv[])
 {
 	int ret;
@@ -106,5 +192,12 @@ int main(int argc, char *argv[])
 		fprintf(stderr, "test_basic() failed %i\n", ret);
 		return T_EXIT_FAIL;
 	}
+
+	ret = test_missing_events();
+	if (ret) {
+		fprintf(stderr, "test_missing_events() failed %i\n", ret);
+		return T_EXIT_FAIL;
+	}
+
 	return 0;
 }
-- 
2.38.1

