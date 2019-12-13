Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4620211DF10
	for <lists+io-uring@lfdr.de>; Fri, 13 Dec 2019 09:06:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725468AbfLMIGz (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 13 Dec 2019 03:06:55 -0500
Received: from mail-wm1-f68.google.com ([209.85.128.68]:38361 "EHLO
        mail-wm1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725793AbfLMIGz (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 13 Dec 2019 03:06:55 -0500
Received: by mail-wm1-f68.google.com with SMTP id u2so521525wmc.3;
        Fri, 13 Dec 2019 00:06:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=I5SL/bqlSvsdjamq/iP/6SdZILW/1fqCxzt8/ezc6Ds=;
        b=FSaDFdOe0ChenS0PyUuFKuMvHGFpVkkaeYMZMoWGXoGP0eaH7/btljc+cpo9/peq7u
         yYEnh0FTcKl4iEulozbOXg9oOYgeTcGE2kfuvb19UJALwpjiKtqMP0zrehgNG017YD6l
         5jtowULgNh5hsAbxJS/ZVLPEnZQi+KO5dMWM8EtaxUIm5tH7+uQNb4pmNJhvChCqUQVO
         RfKIiBv9WysIfE5O/YwCEU/Eocff59XhcffeYJrWXgyCUotZIczQzvEJ5tnsakZLqyh4
         1GFk2A1prQeQhkMfLrCkpfVKkTsUoOY5atVwuyMOP+kIMloYCplqYF0/Egam3Tjft0y4
         eUwg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=I5SL/bqlSvsdjamq/iP/6SdZILW/1fqCxzt8/ezc6Ds=;
        b=l4PrdOAQiDM1Se40pGFXEuxi4BQOABBNGPM+djnAwpWruehOIA4X+xneYAilHgCSBs
         u7W4gHZzqp9tzjCZAEPVMqiCRAvmSkfnnbVCZVKHJRVYcANYzs0wopeouktURD4Sa4qe
         eFW8JC2FywrXGD/ratwsgASXd9prqKCTC1EUO2Fbg6SYYffPMo3keHxl2xvHjP1zodND
         0CoeJwWk/1G8Dhn9AyZLvWZagwJpXTNweskvjQ1o2LPFWLcgV13Qh5REsHNOnyxQPu8z
         FBqT3QObXfVB6kHOQo3wkT2C0wOIe+XM4HdZK46G0U6fbFNd3qNUFRgxsYGVFwvc+V0O
         dSbw==
X-Gm-Message-State: APjAAAWJ9KBUxpmgbR2hzYfgGwC3Ve3OINJjrq0o6ACoB2XC7lHb+GmX
        7JIpMxpkBPKH0GsaauRf0PuoJmEW
X-Google-Smtp-Source: APXvYqxCVon0+7wO1tLZGEvbxLmbmoy4quP8LE9xN1sLkAGhR3hrnCJXyNKJzlIlInDZvzRSLbKrHw==
X-Received: by 2002:a7b:ce81:: with SMTP id q1mr11969896wmj.47.1576224413108;
        Fri, 13 Dec 2019 00:06:53 -0800 (PST)
Received: from localhost.localdomain ([109.126.149.210])
        by smtp.gmail.com with ESMTPSA id y7sm955828wmd.1.2019.12.13.00.06.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 13 Dec 2019 00:06:52 -0800 (PST)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH liburing] Test wait after under-consuming
Date:   Fri, 13 Dec 2019 11:06:17 +0300
Message-Id: <e5579bbac4fcb4f0e9b6ba4fbf3a56bd9a925c6c.1576224356.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.24.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

In case of an error submission won't consume all sqes. This tests that
it will get back to the userspace even if (to_submit == to_wait)

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 test/link.c | 56 ++++++++++++++++++++++++++++++++++++++++++++++++++++-
 1 file changed, 55 insertions(+), 1 deletion(-)

diff --git a/test/link.c b/test/link.c
index 8ec1649..93653f3 100644
--- a/test/link.c
+++ b/test/link.c
@@ -384,6 +384,55 @@ err:
 	return 1;
 }
 
+static int test_early_fail_and_wait(struct io_uring *ring)
+{
+	struct io_uring_cqe *cqe;
+	struct io_uring_sqe *sqe;
+	int ret, submitted, i;
+	const int invalid_fd = 42;
+	struct iovec iov = { .iov_base = NULL, .iov_len = 0 };
+
+	sqe = io_uring_get_sqe(ring);
+	if (!sqe) {
+		printf("get sqe failed\n");
+		goto err;
+	}
+
+	io_uring_prep_readv(sqe, invalid_fd, &iov, 1, 0);
+	sqe->user_data = 1;
+	sqe->flags |= IOSQE_IO_LINK;
+
+	sqe = io_uring_get_sqe(ring);
+	if (!sqe) {
+		printf("get sqe failed\n");
+		goto err;
+	}
+
+	io_uring_prep_nop(sqe);
+	sqe->user_data = 2;
+
+	submitted = io_uring_submit_and_wait(ring, 2);
+	if (submitted == -EAGAIN)
+		return 0;
+	if (submitted <= 0) {
+		printf("sqe submit failed: %d\n", submitted);
+		goto err;
+	}
+
+	for (i = 0; i < 2; i++) {
+		ret = io_uring_wait_cqe(ring, &cqe);
+		if (ret < 0) {
+			printf("wait completion %d\n", ret);
+			goto err;
+		}
+		io_uring_cqe_seen(ring, cqe);
+	}
+
+	return 0;
+err:
+	return 1;
+}
+
 int main(int argc, char *argv[])
 {
 	struct io_uring ring, poll_ring;
@@ -400,7 +449,6 @@ int main(int argc, char *argv[])
 	if (ret) {
 		printf("poll_ring setup failed\n");
 		return 1;
-
 	}
 
 	ret = test_single_link(&ring);
@@ -439,5 +487,11 @@ int main(int argc, char *argv[])
 		return ret;
 	}
 
+	ret = test_early_fail_and_wait(&ring);
+	if (ret) {
+		fprintf(stderr, "test_early_fail_and_wait\n");
+		return ret;
+	}
+
 	return 0;
 }
-- 
2.24.0

