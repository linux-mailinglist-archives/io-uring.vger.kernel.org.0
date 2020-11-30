Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DBBB62C8DF6
	for <lists+io-uring@lfdr.de>; Mon, 30 Nov 2020 20:23:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729929AbgK3TVt (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 30 Nov 2020 14:21:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36884 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729923AbgK3TVr (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 30 Nov 2020 14:21:47 -0500
Received: from mail-wm1-x341.google.com (mail-wm1-x341.google.com [IPv6:2a00:1450:4864:20::341])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4031CC0617A6
        for <io-uring@vger.kernel.org>; Mon, 30 Nov 2020 11:20:29 -0800 (PST)
Received: by mail-wm1-x341.google.com with SMTP id e25so640194wme.0
        for <io-uring@vger.kernel.org>; Mon, 30 Nov 2020 11:20:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id:in-reply-to:references:mime-version
         :content-transfer-encoding;
        bh=Pw/lc/FluL4dSMsXNCCON76r9NHYEL2t2Cav3gD08rc=;
        b=orMmp+RYIhQ2das8EZzo+BaUMsy/3fFm1fqPeyMagmHpkjqi+cjxY7KJ8D6QPNztMG
         8/plkuO5NoAlrhy1Czr/ZzP5MgwsZF66g1o7nPbNP1UldN2TwEHIP1za0vxnUgp4FwGI
         UyRSmF8ZmXoRpga6os7AkZhq5vMje3FcMpc8OoqZ+on6jLwQXCGo7drxY6PGyMJrDJWV
         nHmbyp2ybgfoPyHpfmcO4ywS1eukXoMFl/PeeraiJV2jduPoZZljlRspDd+fRNFRmMWN
         4UBh50BERQmI5bm1Wy7ST0jmPaQ0L8sSf6PHCUskTCFEsCBDNZkjC9E/RQFZjbDqEbl1
         iDCQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=Pw/lc/FluL4dSMsXNCCON76r9NHYEL2t2Cav3gD08rc=;
        b=bX6OKCeV4LZ1KH45FoaeHxzK+jUXp7GVV33sRgcUxuE4qdiEHd6l3KV8bphbzjbWpL
         UOW8t17TQJCnNg5nbl+uoo0DsR9fxC4QQ2OHYiqTk97kGTMffyG//D8SCGbyHCRHi0Wr
         m0D354nkwtpdZNoI1P5Msz5pja0axupfUYB8Ars6T7qNUIKQm4amBtwpeuaMinJ9N+RR
         Ih6ewtBRIBS86oQKgqsRZpMVygiL3nN2a+QsKAKM2xpp9FP9+ogrfN9CAm41Ybv5J9rd
         H6DYsOsQolXn8pBOATrsHfXeWgCJUSgzhu2CL8k+7CQ6kvs2bpW9KoNOqIAqBAqJdP9G
         Ahqg==
X-Gm-Message-State: AOAM532cIBHaAX3NA/x6mI4YHP0hrq8MdVkuUO3xFDKBSzrrgWg4wfv8
        FSdhT/6j8agwaQpeVAN/glIiqoh5l4B37Q==
X-Google-Smtp-Source: ABdhPJwFDoFqMWJ2dEjnh04kzVkdPMLj2G+SQLhLYXJriBQbYSi2TcPABegwdhEcPlaQaTlhDfq6Hg==
X-Received: by 2002:a7b:c406:: with SMTP id k6mr372194wmi.90.1606764028001;
        Mon, 30 Nov 2020 11:20:28 -0800 (PST)
Received: from localhost.localdomain (host109-152-100-135.range109-152.btcentralplus.com. [109.152.100.135])
        by smtp.gmail.com with ESMTPSA id i11sm29886775wrm.1.2020.11.30.11.20.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 30 Nov 2020 11:20:27 -0800 (PST)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
Subject: [PATCH liburing v2 2/2] test/timeout: test timeout updates
Date:   Mon, 30 Nov 2020 19:17:02 +0000
Message-Id: <31844b0f1ca30ec431520e87acb21fe71aed5d33.1606763705.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <cover.1606763704.git.asml.silence@gmail.com>
References: <cover.1606763704.git.asml.silence@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Test timeout updates if supported. Fuzzy checks that it sustains
specified timings. Tests async/linked update, rel/abs, short and longer
delays.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 test/timeout.c | 272 ++++++++++++++++++++++++++++++++++++++++++++++++-
 1 file changed, 271 insertions(+), 1 deletion(-)

diff --git a/test/timeout.c b/test/timeout.c
index 7e9f11d..b80fc36 100644
--- a/test/timeout.c
+++ b/test/timeout.c
@@ -965,10 +965,213 @@ err:
 	return 1;
 }
 
+static int test_update_timeout(struct io_uring *ring, unsigned long ms,
+				bool abs, bool async, bool linked)
+{
+	struct io_uring_sqe *sqe;
+	struct io_uring_cqe *cqe;
+	struct __kernel_timespec ts, ts_upd;
+	unsigned long long exp_ms, base_ms = 10000;
+	struct timeval tv;
+	int ret, i, nr = 2;
+	__u32 mode = abs ? IORING_TIMEOUT_ABS : 0;
+
+	msec_to_ts(&ts_upd, ms);
+	gettimeofday(&tv, NULL);
+
+	sqe = io_uring_get_sqe(ring);
+	if (!sqe) {
+		fprintf(stderr, "%s: get sqe failed\n", __FUNCTION__);
+		goto err;
+	}
+	msec_to_ts(&ts, base_ms);
+	io_uring_prep_timeout(sqe, &ts, 0, 0);
+	sqe->user_data = 1;
+
+	if (linked) {
+		sqe = io_uring_get_sqe(ring);
+		if (!sqe) {
+			fprintf(stderr, "%s: get sqe failed\n", __FUNCTION__);
+			goto err;
+		}
+		io_uring_prep_nop(sqe);
+		sqe->user_data = 3;
+		sqe->flags = IOSQE_IO_LINK;
+		if (async)
+			sqe->flags |= IOSQE_ASYNC;
+		nr++;
+	}
+
+	sqe = io_uring_get_sqe(ring);
+	if (!sqe) {
+		fprintf(stderr, "%s: get sqe failed\n", __FUNCTION__);
+		goto err;
+	}
+	io_uring_prep_timeout_update(sqe, &ts_upd, 1, mode);
+	sqe->user_data = 2;
+	if (async)
+		sqe->flags |= IOSQE_ASYNC;
+
+	ret = io_uring_submit(ring);
+	if (ret != nr) {
+		fprintf(stderr, "%s: sqe submit failed: %d\n", __FUNCTION__, ret);
+		goto err;
+	}
+
+	for (i = 0; i < nr; i++) {
+		ret = io_uring_wait_cqe(ring, &cqe);
+		if (ret < 0) {
+			fprintf(stderr, "%s: wait completion %d\n", __FUNCTION__, ret);
+			goto err;
+		}
+
+		switch (cqe->user_data) {
+		case 1:
+			if (cqe->res != -ETIME) {
+				fprintf(stderr, "%s: got %d, wanted %d\n",
+						__FUNCTION__, cqe->res, -ETIME);
+				goto err;
+			}
+			break;
+		case 2:
+			if (cqe->res != 0) {
+				fprintf(stderr, "%s: got %d, wanted %d\n",
+						__FUNCTION__, cqe->res,
+						0);
+				goto err;
+			}
+			break;
+		case 3:
+			if (cqe->res != 0) {
+				fprintf(stderr, "nop failed\n");
+				goto err;
+			}
+			break;
+		default:
+			goto err;
+		}
+		io_uring_cqe_seen(ring, cqe);
+	}
+
+	exp_ms = mtime_since_now(&tv);
+	if (exp_ms >= base_ms / 2) {
+		fprintf(stderr, "too long, timeout wasn't updated\n");
+		goto err;
+	}
+	if (ms >= 1000 && !abs && exp_ms < ms / 2) {
+		fprintf(stderr, "fired too early, potentially updated to 0 ms"
+					"instead of %lu\n", ms);
+		goto err;
+	}
+	return 0;
+err:
+	return 1;
+}
+
+static int test_update_nonexistent_timeout(struct io_uring *ring)
+{
+	struct io_uring_sqe *sqe;
+	struct io_uring_cqe *cqe;
+	struct __kernel_timespec ts;
+	int ret;
+
+	sqe = io_uring_get_sqe(ring);
+	if (!sqe) {
+		fprintf(stderr, "%s: get sqe failed\n", __FUNCTION__);
+		goto err;
+	}
+	msec_to_ts(&ts, 0);
+	io_uring_prep_timeout_update(sqe, &ts, 42, 0);
+
+	ret = io_uring_submit(ring);
+	if (ret != 1) {
+		fprintf(stderr, "%s: sqe submit failed: %d\n", __FUNCTION__, ret);
+		goto err;
+	}
+
+	ret = io_uring_wait_cqe(ring, &cqe);
+	if (ret < 0) {
+		fprintf(stderr, "%s: wait completion %d\n", __FUNCTION__, ret);
+		goto err;
+	}
+
+	ret = cqe->res;
+	if (ret == -ENOENT)
+		ret = 0;
+	io_uring_cqe_seen(ring, cqe);
+	return ret;
+err:
+	return 1;
+}
+
+static int test_update_invalid_flags(struct io_uring *ring)
+{
+	struct io_uring_sqe *sqe;
+	struct io_uring_cqe *cqe;
+	struct __kernel_timespec ts;
+	int ret;
+
+	sqe = io_uring_get_sqe(ring);
+	if (!sqe) {
+		fprintf(stderr, "%s: get sqe failed\n", __FUNCTION__);
+		goto err;
+	}
+	io_uring_prep_timeout_remove(sqe, 0, IORING_TIMEOUT_ABS);
+
+	ret = io_uring_submit(ring);
+	if (ret != 1) {
+		fprintf(stderr, "%s: sqe submit failed: %d\n", __FUNCTION__, ret);
+		goto err;
+	}
+
+	ret = io_uring_wait_cqe(ring, &cqe);
+	if (ret < 0) {
+		fprintf(stderr, "%s: wait completion %d\n", __FUNCTION__, ret);
+		goto err;
+	}
+	if (cqe->res != -EINVAL) {
+		fprintf(stderr, "%s: got %d, wanted %d\n",
+				__FUNCTION__, cqe->res, -EINVAL);
+		goto err;
+	}
+	io_uring_cqe_seen(ring, cqe);
+
+
+	sqe = io_uring_get_sqe(ring);
+	if (!sqe) {
+		fprintf(stderr, "%s: get sqe failed\n", __FUNCTION__);
+		goto err;
+	}
+	msec_to_ts(&ts, 0);
+	io_uring_prep_timeout_update(sqe, &ts, 0, -1);
+
+	ret = io_uring_submit(ring);
+	if (ret != 1) {
+		fprintf(stderr, "%s: sqe submit failed: %d\n", __FUNCTION__, ret);
+		goto err;
+	}
+
+	ret = io_uring_wait_cqe(ring, &cqe);
+	if (ret < 0) {
+		fprintf(stderr, "%s: wait completion %d\n", __FUNCTION__, ret);
+		goto err;
+	}
+	if (cqe->res != -EINVAL) {
+		fprintf(stderr, "%s: got %d, wanted %d\n",
+				__FUNCTION__, cqe->res, -EINVAL);
+		goto err;
+	}
+	io_uring_cqe_seen(ring, cqe);
+
+	return 0;
+err:
+	return 1;
+}
 
 int main(int argc, char *argv[])
 {
-	struct io_uring ring;
+	struct io_uring ring, sqpoll_ring;
+	bool has_timeout_update, sqpoll;
 	int ret;
 
 	if (argc > 1)
@@ -980,6 +1183,9 @@ int main(int argc, char *argv[])
 		return 1;
 	}
 
+	ret = io_uring_queue_init(8, &sqpoll_ring, IORING_SETUP_SQPOLL);
+	sqpoll = !ret;
+
 	ret = test_single_timeout(&ring);
 	if (ret) {
 		fprintf(stderr, "test_single_timeout failed\n");
@@ -1054,6 +1260,68 @@ int main(int argc, char *argv[])
 		return ret;
 	}
 
+	ret = test_update_nonexistent_timeout(&ring);
+	has_timeout_update = (ret != -EINVAL);
+	if (has_timeout_update) {
+		if (ret) {
+			fprintf(stderr, "test_update_nonexistent_timeout failed\n");
+			return ret;
+		}
+
+		ret = test_update_invalid_flags(&ring);
+		if (ret) {
+			fprintf(stderr, "test_update_invalid_flags failed\n");
+			return ret;
+		}
+
+		ret = test_update_timeout(&ring, 0, false, false, false);
+		if (ret) {
+			fprintf(stderr, "test_update_timeout failed\n");
+			return ret;
+		}
+
+		ret = test_update_timeout(&ring, 1, false, false, false);
+		if (ret) {
+			fprintf(stderr, "test_update_timeout 1ms failed\n");
+			return ret;
+		}
+
+		ret = test_update_timeout(&ring, 1000, false, false, false);
+		if (ret) {
+			fprintf(stderr, "test_update_timeout 1s failed\n");
+			return ret;
+		}
+
+		ret = test_update_timeout(&ring, 0, true, true, false);
+		if (ret) {
+			fprintf(stderr, "test_update_timeout abs failed\n");
+			return ret;
+		}
+
+
+		ret = test_update_timeout(&ring, 0, false, true, false);
+		if (ret) {
+			fprintf(stderr, "test_update_timeout async failed\n");
+			return ret;
+		}
+
+		ret = test_update_timeout(&ring, 0, false, false, true);
+		if (ret) {
+			fprintf(stderr, "test_update_timeout linked failed\n");
+			return ret;
+		}
+
+		if (sqpoll) {
+			ret = test_update_timeout(&sqpoll_ring, 0, false, false,
+						  false);
+			if (ret) {
+				fprintf(stderr, "test_update_timeout sqpoll"
+						"failed\n");
+				return ret;
+			}
+		}
+	}
+
 	/*
 	 * this test must go last, it kills the ring
 	 */
@@ -1063,5 +1331,7 @@ int main(int argc, char *argv[])
 		return ret;
 	}
 
+	if (sqpoll)
+		io_uring_queue_exit(&sqpoll_ring);
 	return 0;
 }
-- 
2.24.0

