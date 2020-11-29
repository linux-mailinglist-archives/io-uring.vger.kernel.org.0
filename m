Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E5A4E2C7A43
	for <lists+io-uring@lfdr.de>; Sun, 29 Nov 2020 18:33:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726470AbgK2RdK (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sun, 29 Nov 2020 12:33:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52280 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725830AbgK2RdJ (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sun, 29 Nov 2020 12:33:09 -0500
Received: from mail-wr1-x443.google.com (mail-wr1-x443.google.com [IPv6:2a00:1450:4864:20::443])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 49ECAC0613D3
        for <io-uring@vger.kernel.org>; Sun, 29 Nov 2020 09:32:29 -0800 (PST)
Received: by mail-wr1-x443.google.com with SMTP id 23so12030548wrc.8
        for <io-uring@vger.kernel.org>; Sun, 29 Nov 2020 09:32:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id:in-reply-to:references:mime-version
         :content-transfer-encoding;
        bh=BS3AU4jA4AKy8rLrtCOqBThrRDffP+aSLp9m0+UWRyM=;
        b=fIybVSurTP0fyRP+0lBCreH+x/rb1gkShCkT+r2MvRRj+pAMHl//eQIaqLbWctB9N7
         sRfkSnnuy/ZGKjZNIGq63gP/OdlSPVVQjtbTm/PFCmb9NegVmW9t7OvN2KEaCf2dploR
         pGRvd9cez5uXimZ8AYxsxvDc2i29j61+Gmr8L/p2ybsKWZklXN9NOkO0qrqnc3GPTsdw
         KIH9csbfZbsIU6bNiUyyFhaJ3yQ8bye0Ri8/eQ+zSP4AiIE6Vq/G0dYuCEaQuHXqvqWc
         M51oeR5O1/Dowxh+N7IwlFLySnlZWvPmuGCgc+dKqPInH1cSfSFcsY0Aawz/87W11mvk
         f2gQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=BS3AU4jA4AKy8rLrtCOqBThrRDffP+aSLp9m0+UWRyM=;
        b=k4nR+++jbNXy9U4kpMvG1UHOoIVYr1ANZDc2Tkwq3skdW2yfthEc+RsEtxtw2jQ8Eu
         b93fMHhibVAj1Krd6wNVvtQXJP0rWyCZ0QmjRjohEjQqF9GdbCJYB8xGCL5/TmpqnnPy
         fRBPdtgLoROnVyAhsfG9yZe434muNzChB3R06uljCdn9ypY+BwjW7LmvKMXrPhqUc4gk
         M/OdaBZ0eVAlz+XQ9APzKUUPOUZWLbEOl9drUnEhVt6ip2DtmAIRoI+BV7Bpwnzt1Hst
         b9Ov5wag6rdOd40fToo0KzqlC5QBMLcAtJ7s6Epkl/aCWek4VuJHlsjXj8LnFH31XtYc
         2MRA==
X-Gm-Message-State: AOAM533hh7Pij684VlCRT0GrNAad7+fgYI3oIhrUyhv3bbkdvt9LSuQc
        Tz9xpTMqjky3PoMUr7n09jqlKJqtw3w=
X-Google-Smtp-Source: ABdhPJw2GLF3eGP7aze8MLgCBA87ERWz27NyjfnBHuz5HdM4Oc7aE+bgdTAPmcI/qhUA+nPubtnJ9w==
X-Received: by 2002:a5d:504f:: with SMTP id h15mr23142095wrt.402.1606671148063;
        Sun, 29 Nov 2020 09:32:28 -0800 (PST)
Received: from localhost.localdomain (host109-152-100-189.range109-152.btcentralplus.com. [109.152.100.189])
        by smtp.gmail.com with ESMTPSA id l24sm25306377wrb.28.2020.11.29.09.32.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 29 Nov 2020 09:32:27 -0800 (PST)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
Subject: [PATCH liburing 2/2] test/timeout: test timeout updates
Date:   Sun, 29 Nov 2020 17:29:07 +0000
Message-Id: <05a3c04e9298f8c9f14cc92956a7b708f359e4d8.1606670836.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <cover.1606670836.git.asml.silence@gmail.com>
References: <cover.1606670836.git.asml.silence@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Test timeout updates if supported. Fuzzy checks that it sustains
specified timings. Tests async/linked update, short and longer delays.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 test/timeout.c | 255 +++++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 255 insertions(+)

diff --git a/test/timeout.c b/test/timeout.c
index 7e9f11d..9db7661 100644
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
 	struct io_uring ring;
+	bool has_timeout_update;
 	int ret;
 
 	if (argc > 1)
@@ -1054,6 +1257,58 @@ int main(int argc, char *argv[])
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
+	}
+
 	/*
 	 * this test must go last, it kills the ring
 	 */
-- 
2.24.0

