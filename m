Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3211234E578
	for <lists+io-uring@lfdr.de>; Tue, 30 Mar 2021 12:31:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231701AbhC3Kaf (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 30 Mar 2021 06:30:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50002 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231579AbhC3KaX (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 30 Mar 2021 06:30:23 -0400
Received: from mail-wr1-x429.google.com (mail-wr1-x429.google.com [IPv6:2a00:1450:4864:20::429])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9E36CC061574
        for <io-uring@vger.kernel.org>; Tue, 30 Mar 2021 03:30:20 -0700 (PDT)
Received: by mail-wr1-x429.google.com with SMTP id j18so15720745wra.2
        for <io-uring@vger.kernel.org>; Tue, 30 Mar 2021 03:30:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=IlEfzAhLue7KXkSCB3k2Sceuj/YicMS0nq+WNJb1zpw=;
        b=T2jgvpDYCcb1qHcYOXIf4acdORmzWDc80nHU1h8uc1A465Vim95uW0POCK4T65PQpA
         BKVmSdKlKRQZMCYh+Q5eeHjVReTLOIZSX39Ylj8dpPrXpmc0igE2cV6WGh6UsQRjcd6c
         b3bRskl7ul4XwNySfmZ5Q6B733UCFqcdc8bbGavuc/djFBQdqhAEnDLF04RQ58AQHcKr
         S3ZuRavOihK9YCoOtl921zppHWThvUcqLsm/8LQhq6Y3x+uW4kyIQuADdIVjmK048AO/
         MkmkjEWfYstzoO7yHehEMxoQwpMkg+F/+1m7PPdvQoRfYbdUcE9BLvrDioJ/Ni8HHj2T
         shBw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=IlEfzAhLue7KXkSCB3k2Sceuj/YicMS0nq+WNJb1zpw=;
        b=Xs/8/EcuphWdH+sE46wurbQqaiuXI3Kkutu7trCiSDxOZRvtRjxBHMi3b/52LsEIuJ
         /ZPAXaINVTh0gHpfI1DMeCzs4+qaY8j264kYkXWOJFaKr8lSt2mm/d5bwW/huc0ruayM
         Q+7NWQ2wqzzjDvMcb8Rpr5bvnkVhwFaLAQ+5DS2obYmroTiQsuLmS+tW18Ww+1kQn/AP
         MtqaX7mVt7dgZhuvmGSaaLKjhFxiq09FeQoJv28Kio9YKm9YbsMixBiViZvaXS0TD/eB
         US1fzRcNYAegbYISRqGq3wG+wdJVnbtQJotHVoBlWgLNYmGVrZjoFKyJR4jGO/VsfyXR
         6eYQ==
X-Gm-Message-State: AOAM533VBfkkb9ih3SfZzOumMjvW6AeBmnbrVuIQbDxveuRDoFOtYqzY
        3mXalSa4BNypZEvAjzDseJxTQAF8swXZRA==
X-Google-Smtp-Source: ABdhPJzU/rFIHL/HXio2Q5GYy2zG8aPrlnhI7t/1cpO7ucUhGRmNoU5OiNvOvdnH8w5/sVWf7PiFyg==
X-Received: by 2002:a5d:604b:: with SMTP id j11mr23719938wrt.424.1617100219453;
        Tue, 30 Mar 2021 03:30:19 -0700 (PDT)
Received: from localhost.localdomain ([85.255.234.174])
        by smtp.gmail.com with ESMTPSA id c131sm2794178wma.37.2021.03.30.03.30.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 30 Mar 2021 03:30:18 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
Subject: [PATCH liburing] tests: test CQE ordering on early submission fail
Date:   Tue, 30 Mar 2021 11:26:09 +0100
Message-Id: <bfc0ffac5d54adeb3472ec6160f6aeaf8f70c1ca.1617099951.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.24.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Check that CQEs of a link comes in the order of submission, even when
a link fails early during submission initial prep.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 test/link.c | 53 +++++++++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 53 insertions(+)

diff --git a/test/link.c b/test/link.c
index c89d6b2..fadd0b5 100644
--- a/test/link.c
+++ b/test/link.c
@@ -429,6 +429,53 @@ err:
 	return 1;
 }
 
+static int test_link_fail_ordering(struct io_uring *ring)
+{
+	struct io_uring_cqe *cqe;
+	struct io_uring_sqe *sqe;
+	int ret, i, nr_compl;
+
+	sqe = io_uring_get_sqe(ring);
+	io_uring_prep_nop(sqe);
+	sqe->flags |= IOSQE_IO_LINK;
+	sqe->user_data = 0;
+
+	sqe = io_uring_get_sqe(ring);
+	io_uring_prep_write(sqe, -1, NULL, 100, 0);
+	sqe->flags |= IOSQE_IO_LINK;
+	sqe->user_data = 1;
+
+	sqe = io_uring_get_sqe(ring);
+	io_uring_prep_nop(sqe);
+	sqe->flags |= IOSQE_IO_LINK;
+	sqe->user_data = 2;
+
+	nr_compl = ret = io_uring_submit(ring);
+	/* at least the first nop should have been submitted */
+	if (ret < 1) {
+		fprintf(stderr, "sqe submit failed: %d\n", ret);
+		goto err;
+	}
+
+	for (i = 0; i < nr_compl; i++) {
+		ret = io_uring_wait_cqe(ring, &cqe);
+		if (ret) {
+			fprintf(stderr, "wait completion %d\n", ret);
+			goto err;
+		}
+		if (cqe->user_data != i) {
+			fprintf(stderr, "wrong CQE order, got %i, expected %i\n",
+					(int)cqe->user_data, i);
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
@@ -492,5 +539,11 @@ int main(int argc, char *argv[])
 		return ret;
 	}
 
+	ret = test_link_fail_ordering(&ring);
+	if (ret) {
+		fprintf(stderr, "test_link_fail_ordering last failed\n");
+		return ret;
+	}
+
 	return 0;
 }
-- 
2.24.0

