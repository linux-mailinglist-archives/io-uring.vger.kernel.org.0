Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B98B5420143
	for <lists+io-uring@lfdr.de>; Sun,  3 Oct 2021 13:11:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229994AbhJCLNf (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sun, 3 Oct 2021 07:13:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52952 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230004AbhJCLNf (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sun, 3 Oct 2021 07:13:35 -0400
Received: from mail-ed1-x52a.google.com (mail-ed1-x52a.google.com [IPv6:2a00:1450:4864:20::52a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1735FC061780
        for <io-uring@vger.kernel.org>; Sun,  3 Oct 2021 04:11:48 -0700 (PDT)
Received: by mail-ed1-x52a.google.com with SMTP id dj4so53980080edb.5
        for <io-uring@vger.kernel.org>; Sun, 03 Oct 2021 04:11:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=9uDnSWYw+6kkT0Xv49HZLtjIMDObjj/q/VLSy6LEUZU=;
        b=CZg3eO4E6EfGb/wPWMyNJAOQ1NKufgoNHg6FEJRX1S9L+sYgnKawnfOegBKcd6piKc
         NZS30BO8dlINnZz144bV60Kp6vb/7MaDlPbDG+tUCeW9X/G14A7SE+UyyOww5uzvs1dC
         HDLLXJocKibcs/HpS1WAp1IyLCdSVByQLeuADc269x4nqubRf05b/wsdZJM04Oz7uMUB
         veaWielDwvZl8lMMADnGOlZzU1BDukb3t745eb1viPpxsMCShyRue6nZNH27HlliAF1U
         zzaRWf1+udTzUrUGWyeT9o3dQrIIAl1Ezfc7i+/iMpUF+4RJwxrv1zaLuAy8/3PrtDST
         1T4A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=9uDnSWYw+6kkT0Xv49HZLtjIMDObjj/q/VLSy6LEUZU=;
        b=2ugEzv1LaozvjogFoOaxy8bw+bSYiwumlSat451+d1psRWAEGinnkgmiqqifjwsqC4
         UctNzy+A7iNqkOzWwgVlwMH20dkfI54coByFxzyrW4FyRHJ16Xtg2/h79MZrXDqKj87T
         fELnGUGRZfd38Tm+0q3PL8EuCzDOk/Qhru8uCboTyOvIeo8YfAZNDcgAVPtpdhl4j2x6
         YaTa3r8rnmYZyiMN3omAxdXtjUZ7mS8EHnC5BVZjUwEsUGsyqL3GhvAxF9B+sfTBHYWK
         6/FL8ZDoXJuc+2NGMmoHPP+kYVJngsP/rQc5+l1OvASBczJatTLhqMgzOSBvVRw8/7KJ
         Qg6g==
X-Gm-Message-State: AOAM531yF6FkrUk3a9prA0ZU45in6j98ELt0OhJe8qdVesdUJVpzZob/
        u8F2j3xTPVZZUs0PfPSN5wOddXaED9w=
X-Google-Smtp-Source: ABdhPJxVuUIlMG1CVytwy86cT4WesJa/tPM0ODd6pujeuUYrlOM7u67KcVA/M7BKaPzYtJLA16qjcw==
X-Received: by 2002:a50:eb9a:: with SMTP id y26mr477048edr.186.1633259506393;
        Sun, 03 Oct 2021 04:11:46 -0700 (PDT)
Received: from localhost.localdomain ([85.255.233.39])
        by smtp.gmail.com with ESMTPSA id r6sm210492edd.89.2021.10.03.04.11.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 03 Oct 2021 04:11:46 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     io-uring@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>, asml.silence@gmail.com
Subject: [PATCH liburing 1/2] io_uring: test IORING_TIMEOUT_ETIME_SUCCESS
Date:   Sun,  3 Oct 2021 12:10:59 +0100
Message-Id: <d1a5b6bdbcfa1ec6b5ca014248e12b3b1edb4e5d.1633259449.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <cover.1633259449.git.asml.silence@gmail.com>
References: <cover.1633259449.git.asml.silence@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Make sure we don't fail links on ETIME when IORING_TIMEOUT_ETIME_SUCCESS
is set.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 src/include/liburing/io_uring.h |  1 +
 test/timeout.c                  | 67 +++++++++++++++++++++++++++++++++
 2 files changed, 68 insertions(+)

diff --git a/src/include/liburing/io_uring.h b/src/include/liburing/io_uring.h
index 7aa43fc..61683bd 100644
--- a/src/include/liburing/io_uring.h
+++ b/src/include/liburing/io_uring.h
@@ -162,6 +162,7 @@ enum {
 #define IORING_TIMEOUT_BOOTTIME		(1U << 2)
 #define IORING_TIMEOUT_REALTIME		(1U << 3)
 #define IORING_LINK_TIMEOUT_UPDATE	(1U << 4)
+#define IORING_TIMEOUT_ETIME_SUCCESS	(1U << 5)
 #define IORING_TIMEOUT_CLOCK_MASK	(IORING_TIMEOUT_BOOTTIME | IORING_TIMEOUT_REALTIME)
 #define IORING_TIMEOUT_UPDATE_MASK	(IORING_TIMEOUT_UPDATE | IORING_LINK_TIMEOUT_UPDATE)
 /*
diff --git a/test/timeout.c b/test/timeout.c
index 775063f..f8ba973 100644
--- a/test/timeout.c
+++ b/test/timeout.c
@@ -1267,6 +1267,67 @@ static int test_timeout_link_cancel(void)
 	return 0;
 }
 
+
+static int test_not_failing_links(void)
+{
+	struct io_uring ring;
+	struct io_uring_sqe *sqe;
+	struct io_uring_cqe *cqe;
+	struct __kernel_timespec ts;
+	int ret;
+
+	ret = io_uring_queue_init(8, &ring, 0);
+	if (ret) {
+		fprintf(stderr, "ring create failed: %d\n", ret);
+		return 1;
+	}
+
+	msec_to_ts(&ts, 1);
+	sqe = io_uring_get_sqe(&ring);
+	io_uring_prep_timeout(sqe, &ts, 0, IORING_TIMEOUT_ETIME_SUCCESS);
+	sqe->user_data = 1;
+	sqe->flags |= IOSQE_IO_LINK;
+
+	sqe = io_uring_get_sqe(&ring);
+	io_uring_prep_nop(sqe);
+	sqe->user_data = 2;
+
+	ret = io_uring_submit(&ring);
+	if (ret != 2) {
+		fprintf(stderr, "%s: sqe submit failed: %d\n", __FUNCTION__, ret);
+		return 1;
+	}
+
+	ret = io_uring_wait_cqe(&ring, &cqe);
+	if (ret < 0) {
+		fprintf(stderr, "%s: wait completion %d\n", __FUNCTION__, ret);
+		return 1;
+	} else if (cqe->user_data == 1 && cqe->res == -EINVAL) {
+		fprintf(stderr, "ETIME_SUCCESS is not supported, skip\n");
+		goto done;
+	} else if (cqe->res != -ETIME || cqe->user_data != 1) {
+		fprintf(stderr, "timeout failed %i %i\n", cqe->res,
+				(int)cqe->user_data);
+		return 1;
+	}
+	io_uring_cqe_seen(&ring, cqe);
+
+	ret = io_uring_wait_cqe(&ring, &cqe);
+	if (ret < 0) {
+		fprintf(stderr, "%s: wait completion %d\n", __FUNCTION__, ret);
+		return 1;
+	} else if (cqe->res || cqe->user_data != 2) {
+		fprintf(stderr, "nop failed %i %i\n", cqe->res,
+				(int)cqe->user_data);
+		return 1;
+	}
+done:
+	io_uring_cqe_seen(&ring, cqe);
+	io_uring_queue_exit(&ring);
+	return 0;
+}
+
+
 int main(int argc, char *argv[])
 {
 	struct io_uring ring, sqpoll_ring;
@@ -1450,6 +1511,12 @@ int main(int argc, char *argv[])
 		return ret;
 	}
 
+	ret = test_not_failing_links();
+	if (ret) {
+		fprintf(stderr, "test_not_failing_links failed\n");
+		return ret;
+	}
+
 	if (sqpoll)
 		io_uring_queue_exit(&sqpoll_ring);
 	return 0;
-- 
2.33.0

