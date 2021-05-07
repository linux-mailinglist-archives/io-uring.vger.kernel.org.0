Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B7CB93768FD
	for <lists+io-uring@lfdr.de>; Fri,  7 May 2021 18:42:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232135AbhEGQny (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 7 May 2021 12:43:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58064 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229849AbhEGQny (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 7 May 2021 12:43:54 -0400
Received: from mail-wr1-x434.google.com (mail-wr1-x434.google.com [IPv6:2a00:1450:4864:20::434])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2F29EC061574
        for <io-uring@vger.kernel.org>; Fri,  7 May 2021 09:42:54 -0700 (PDT)
Received: by mail-wr1-x434.google.com with SMTP id l13so9899171wru.11
        for <io-uring@vger.kernel.org>; Fri, 07 May 2021 09:42:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=kuX4oD7lpMvPRiPLwD2/PQeeHlMvzKp4RG2PXdKvH50=;
        b=scpbD0o4sqEbwC4TMtc3TWAwVBQ3r4cl2iSMCmEQKu/emlVCzlJCj/A5w/pMl3a8u6
         vNkHWsvcH2RxnMRr8OpgTl0ohP1bpAXjy+jsSz0HFWYx+/MUF//cZuhDPI9rGnwEfSPD
         nBd3zxIReuDRimu9oyX/OYtxpUlaiGJ2f3GJg4O1BKnYHfG5aQuKYwcvKr5ntETcP4V2
         IPmBcumKDWcrEhhBJ9gXjdyITLUS6C5kSDagjDlZqttu1u0lgfbT0S0tu6HwHszU+D+t
         wfaAq+gq+EKgRhq8BfZfmiog9cN2LIJJLgK7XSvhJKB+n0jN9+hBlYPGs/Z2P/LKL25t
         ylgQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=kuX4oD7lpMvPRiPLwD2/PQeeHlMvzKp4RG2PXdKvH50=;
        b=sHm6Sbja6YQMIsX6EBzNdBEtzfL2l5BoWladE4N9iabtMB7QApnicq1GeHC16ksN+5
         ZRrhJA2nMMPte8bBcbqqItBekzyu6Zd0yo1sYxgs6DWaqG+65NQkOlEh0Xpit5w7Hcib
         ZD814xR6UDladq8lHMJ41iz2CIof05618abEEb9MfzcMtozadG++EksO9TWvBW5IHI0Y
         S2DTkOq2GNjRMN+nk5ChxMv5JzU00jMAWBnJcN+6HqSwIm0XvjHnWbRlZqueSFSOlpaG
         0L0LvwBWOnTpl+YfNMAwqgbmvSU7eF7/gJnB2v9Oq3VYI9oYILP50hmv78h6Fk3DSOJJ
         jJ3A==
X-Gm-Message-State: AOAM5327YTGSkNlK9RGR4HHpZ91O5uwi5oh2qdadyIhV37juGNRIPX1D
        L5THq47f82Vw9XfcVxYpNkdpIdKu+jY=
X-Google-Smtp-Source: ABdhPJxUMTtNYeDBL2sfGV+ulupD5W4hVS8lDCXCMZbX858mzovpLkVrfr2q537wbb014RhzyrxGbQ==
X-Received: by 2002:a5d:4386:: with SMTP id i6mr13587210wrq.207.1620405773011;
        Fri, 07 May 2021 09:42:53 -0700 (PDT)
Received: from localhost.localdomain ([148.252.132.80])
        by smtp.gmail.com with ESMTPSA id x8sm8821990wrs.25.2021.05.07.09.42.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 07 May 2021 09:42:52 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
Subject: [PATCH liburing 1/1] tests: remove test_link_fail_ordering()
Date:   Fri,  7 May 2021 17:42:41 +0100
Message-Id: <2038218a804134079c8883293f6d89a1723ac563.1620405748.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Apparently old kernels were posting CQEs of a link failed during
submission in a strange order, kill the test.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 test/link.c | 53 -----------------------------------------------------
 1 file changed, 53 deletions(-)

diff --git a/test/link.c b/test/link.c
index fadd0b5..c89d6b2 100644
--- a/test/link.c
+++ b/test/link.c
@@ -429,53 +429,6 @@ err:
 	return 1;
 }
 
-static int test_link_fail_ordering(struct io_uring *ring)
-{
-	struct io_uring_cqe *cqe;
-	struct io_uring_sqe *sqe;
-	int ret, i, nr_compl;
-
-	sqe = io_uring_get_sqe(ring);
-	io_uring_prep_nop(sqe);
-	sqe->flags |= IOSQE_IO_LINK;
-	sqe->user_data = 0;
-
-	sqe = io_uring_get_sqe(ring);
-	io_uring_prep_write(sqe, -1, NULL, 100, 0);
-	sqe->flags |= IOSQE_IO_LINK;
-	sqe->user_data = 1;
-
-	sqe = io_uring_get_sqe(ring);
-	io_uring_prep_nop(sqe);
-	sqe->flags |= IOSQE_IO_LINK;
-	sqe->user_data = 2;
-
-	nr_compl = ret = io_uring_submit(ring);
-	/* at least the first nop should have been submitted */
-	if (ret < 1) {
-		fprintf(stderr, "sqe submit failed: %d\n", ret);
-		goto err;
-	}
-
-	for (i = 0; i < nr_compl; i++) {
-		ret = io_uring_wait_cqe(ring, &cqe);
-		if (ret) {
-			fprintf(stderr, "wait completion %d\n", ret);
-			goto err;
-		}
-		if (cqe->user_data != i) {
-			fprintf(stderr, "wrong CQE order, got %i, expected %i\n",
-					(int)cqe->user_data, i);
-			goto err;
-		}
-		io_uring_cqe_seen(ring, cqe);
-	}
-
-	return 0;
-err:
-	return 1;
-}
-
 int main(int argc, char *argv[])
 {
 	struct io_uring ring, poll_ring;
@@ -539,11 +492,5 @@ int main(int argc, char *argv[])
 		return ret;
 	}
 
-	ret = test_link_fail_ordering(&ring);
-	if (ret) {
-		fprintf(stderr, "test_link_fail_ordering last failed\n");
-		return ret;
-	}
-
 	return 0;
 }
-- 
2.31.1

