Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CAE242D73AE
	for <lists+io-uring@lfdr.de>; Fri, 11 Dec 2020 11:17:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726033AbgLKKNT (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 11 Dec 2020 05:13:19 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:46087 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2389247AbgLKKM4 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 11 Dec 2020 05:12:56 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1607681488;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=P8D5DIstzEm8ihIF+aB3HUZTpf2nMT3IhW18hOVMkZM=;
        b=R68OZvy0JBSNEzwlOoIQB8LILhmreYLiIvtHsw3CrjTWg3G+iVAywdDGWZ6xqG24Jnkeet
        mRIw7eFkZvzqdxrXDCasT/nbnCaXf5exeSSeXrmxLP/Lm4ggACHoKvnQY1dQj57+8A1JYy
        bjDlKJHTwvAqumx+OcFLI5yvw8uGB8I=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-270-lNHHlxE9OWS7jXkAZ55sbA-1; Fri, 11 Dec 2020 05:11:26 -0500
X-MC-Unique: lNHHlxE9OWS7jXkAZ55sbA-1
Received: by mail-wm1-f71.google.com with SMTP id u123so1563158wmu.5
        for <io-uring@vger.kernel.org>; Fri, 11 Dec 2020 02:11:26 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=P8D5DIstzEm8ihIF+aB3HUZTpf2nMT3IhW18hOVMkZM=;
        b=j3zMjrOUeMlfP5tosr2zs2sdhz+HBZJiTiaUNyyjp5buPIoE61UZFJxWi1Ib2/0Vt9
         0eOTWErZM9M9FLGe+Ig41bThWPc3tRco8KNdT/bXRO/fRGGHeGFgm77KCFIRhsd5tY0+
         z31VUIGY1ol0TvSQakdx15TapDOk8si84Rz4OypexroI+C4MfCVpBfJdf2AwzOEqicHT
         onM2AgXc89IOB7oDduPgBTZiSpBHzh3O6purp7xGoVUdGn4m7CbuPKFMOrmFZ/Ux5pB5
         qeuPN2d6aOoeQFZZYXDG4cvFAbqm8PPjdeoY64FsbDbdAlmMzhiAg/B8hG/2doTbQipM
         JhYA==
X-Gm-Message-State: AOAM532y8EAh6KUNnBiPmuljcCSy8rpZEF2QZx+d1o7hNcDhGMmwwkQl
        pcQTpCjq2CJrd/l+XCoQv3iwOW32WjG4zwJrxl8tjUfbBdrW1hTNtaUQikTpe8T0FqIRtTHuKgN
        O0KPCIVCL4dz7hV1n0ao=
X-Received: by 2002:adf:b647:: with SMTP id i7mr13047494wre.241.1607681484876;
        Fri, 11 Dec 2020 02:11:24 -0800 (PST)
X-Google-Smtp-Source: ABdhPJxsk9VGIWusXI4R+OvrxnYPN2LMYnNwtPM68771xryzpTIiJg/Cj8zCx8R8Yp2BeaMCjJMLeA==
X-Received: by 2002:adf:b647:: with SMTP id i7mr13047469wre.241.1607681484569;
        Fri, 11 Dec 2020 02:11:24 -0800 (PST)
Received: from steredhat (host-79-24-227-66.retail.telecomitalia.it. [79.24.227.66])
        by smtp.gmail.com with ESMTPSA id m4sm13619869wmi.41.2020.12.11.02.11.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 11 Dec 2020 02:11:23 -0800 (PST)
Date:   Fri, 11 Dec 2020 11:11:21 +0100
From:   Stefano Garzarella <sgarzare@redhat.com>
To:     Hao Xu <haoxu@linux.alibaba.com>
Cc:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org,
        Joseph Qi <joseph.qi@linux.alibaba.com>
Subject: Re: [PATCH liburing v2] test/timeout-new: test for timeout feature
Message-ID: <20201211101121.uk5i75uw2fln3zdh@steredhat>
References: <1607660867-66721-1-git-send-email-haoxu@linux.alibaba.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <1607660867-66721-1-git-send-email-haoxu@linux.alibaba.com>
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Fri, Dec 11, 2020 at 12:27:47PM +0800, Hao Xu wrote:
>Tests for the new timeout feature. It covers:
>    - wake up when timeout, sleeping time calculated as well
>    - wake up by a cqe before timeout
>    - the above two in sqpoll thread mode
>    - multi child-threads wake up by a cqe issuing in main thread before
>      timeout
>
>Signed-off-by: Hao Xu <haoxu@linux.alibaba.com>
>---
> .gitignore         |   1 +
> test/Makefile      |   3 +
> test/timeout-new.c | 246 +++++++++++++++++++++++++++++++++++++++++++++++++++++
> 3 files changed, 250 insertions(+)
> create mode 100644 test/timeout-new.c
>
>diff --git a/.gitignore b/.gitignore
>index c85a49ba6a85..2d11cc136846 100644
>--- a/.gitignore
>+++ b/.gitignore
>@@ -111,6 +111,7 @@
> /test/timeout-overflow
> /test/unlink
> /test/wakeup-hang
>+/test/timeout-new

Please keep the alphabetic order.

> /test/*.dmesg
>
> config-host.h
>diff --git a/test/Makefile b/test/Makefile
>index dbbb485ded79..f19a8a40fb5c 100644
>--- a/test/Makefile
>+++ b/test/Makefile
>@@ -106,6 +106,7 @@ test_targets += \
> 	timeout-overflow \
> 	unlink \
> 	wakeup-hang \
>+	timeout-new \

Ditto.

> 	# EOL
>
> all_targets += $(test_targets)
>@@ -229,6 +230,7 @@ test_srcs := \
> 	timeout.c \
> 	unlink.c \
> 	wakeup-hang.c \
>+	timeout-new.c \

Ditto.

> 	# EOL
>
> test_objs := $(patsubst %.c,%.ol,$(patsubst %.cc,%.ol,$(test_srcs)))
>@@ -245,6 +247,7 @@ across-fork: XCFLAGS = -lpthread
> ce593a6c480a-test: XCFLAGS = -lpthread
> wakeup-hang: XCFLAGS = -lpthread
> pipe-eof: XCFLAGS = -lpthread
>+timeout-new: XCFLAGS = -lpthread
>
> install: $(test_targets) runtests.sh runtests-loop.sh
> 	$(INSTALL) -D -d -m 755 $(datadir)/liburing-test/
>diff --git a/test/timeout-new.c b/test/timeout-new.c
>new file mode 100644
>index 000000000000..45b9a149ae11
>--- /dev/null
>+++ b/test/timeout-new.c
>@@ -0,0 +1,246 @@
>+/* SPDX-License-Identifier: MIT */
>+/*
>+ * Description: tests for getevents timeout
>+ *
>+ */
>+#include <stdio.h>
>+#include <sys/time.h>
>+#include <unistd.h>
>+#include <pthread.h>
>+#include "liburing.h"
>+
>+#define TIMEOUT_MSEC	200
>+#define TIMEOUT_SEC	10
>+
>+int thread_ret0, thread_ret1;
>+int cnt = 0;
>+pthread_mutex_t mutex;
>+
>+static void msec_to_ts(struct __kernel_timespec *ts, unsigned int msec)
>+{
>+	ts->tv_sec = msec / 1000;
>+	ts->tv_nsec = (msec % 1000) * 1000000;
>+}
>+
>+static unsigned long long mtime_since(const struct timeval *s,
>+				      const struct timeval *e)
>+{
>+	long long sec, usec;
>+
>+	sec = e->tv_sec - s->tv_sec;
>+	usec = (e->tv_usec - s->tv_usec);
>+	if (sec > 0 && usec < 0) {
>+		sec--;
>+		usec += 1000000;
>+	}
>+
>+	sec *= 1000;
>+	usec /= 1000;
>+	return sec + usec;
>+}
>+
>+static unsigned long long mtime_since_now(struct timeval *tv)
>+{
>+	struct timeval end;
>+
>+	gettimeofday(&end, NULL);
>+	return mtime_since(tv, &end);
>+}
>+
>+
>+static int test_return_before_timeout(struct io_uring *ring)
>+{
>+	struct io_uring_cqe *cqe;
>+	struct io_uring_sqe *sqe;
>+	int ret;
>+	struct __kernel_timespec ts;
>+
>+	sqe = io_uring_get_sqe(ring);
>+	if (!sqe) {
>+		fprintf(stderr, "%s: get sqe failed\n", __FUNCTION__);
>+		return 1;
>+	}
>+
>+	io_uring_prep_nop(sqe);
>+
>+	ret = io_uring_submit(ring);
>+	if (ret <= 0) {
>+		fprintf(stderr, "%s: sqe submit failed: %d\n", __FUNCTION__, ret);
>+		return 1;
>+	}
>+
>+	msec_to_ts(&ts, TIMEOUT_MSEC);
>+	ret = io_uring_wait_cqe_timeout(ring, &cqe, &ts);
>+	if (ret < 0) {
>+		fprintf(stderr, "%s: timeout error: %d\n", __FUNCTION__, ret);
>+		return 1;
>+	}
>+
>+	io_uring_cqe_seen(ring, cqe);
>+	return 0;
>+}
>+
>+static int test_return_after_timeout(struct io_uring *ring)
>+{
>+	struct io_uring_cqe *cqe;
>+	int ret;
>+	struct __kernel_timespec ts;
>+	struct timeval tv;
>+	unsigned long long exp;
>+
>+	msec_to_ts(&ts, TIMEOUT_MSEC);
>+	gettimeofday(&tv, NULL);
>+	ret = io_uring_wait_cqe_timeout(ring, &cqe, &ts);
>+	exp = mtime_since_now(&tv);
>+	if (ret != -ETIME) {
>+		fprintf(stderr, "%s: timeout error: %d\n", __FUNCTION__, 
>ret);
>+		return 1;
>+	}
>+
>+	if (exp < TIMEOUT_MSEC / 2 || exp > (TIMEOUT_MSEC  * 3) / 2) {
>+		fprintf(stderr, "%s: Timeout seems wonky (got %llu)\n", __FUNCTION__, exp);
>+		return 1;
>+	}
>+
>+	return 0;
>+}
>+
>+int __reap_thread_fn(void *data) {
>+	struct io_uring *ring = (struct io_uring *)data;
>+	struct io_uring_cqe *cqe;
>+	struct __kernel_timespec ts;
>+
>+	msec_to_ts(&ts, TIMEOUT_SEC);
>+	pthread_mutex_lock(&mutex);
>+	cnt++;
>+	pthread_mutex_unlock(&mutex);
>+	return io_uring_wait_cqe_timeout(ring, &cqe, &ts);
>+}
>+
>+void *reap_thread_fn0(void *data) {
>+	thread_ret0 = __reap_thread_fn(data);
>+	return NULL;
>+}
>+
>+void *reap_thread_fn1(void *data) {
>+	thread_ret1 = __reap_thread_fn(data);
>+	return NULL;
>+}
>+
>+/*
>+ * This is to test issuing a sqe in main thread and reaping it in two child-thread
>+ * at the same time. To see if timeout feature works or not.
>+ */
>+int test_multi_threads_timeout() {
>+	struct io_uring ring;
>+	int ret;
>+	bool both_wait = false;
>+	pthread_t reap_thread0, reap_thread1;
>+	struct io_uring_sqe *sqe;
>+
>+	ret = io_uring_queue_init(8, &ring, 0);
>+	if (ret) {
>+		fprintf(stderr, "%s: ring setup failed: %d\n", __FUNCTION__, ret);
>+		return 1;
>+	}
>+
>+	pthread_create(&reap_thread0, NULL, reap_thread_fn0, &ring);
>+	pthread_create(&reap_thread1, NULL, reap_thread_fn1, &ring);
>+
>+	/*
>+	 * make two threads both enter io_uring_wait_cqe_timeout() before issuing the sqe
>+	 * as possible as we can. So that there are two threads in the ctx->wait queue.
>+	 * In this way, we can test if a cqe wakes up two threads at the 
>same time.
>+	 */
>+	while(!both_wait) {
>+		pthread_mutex_lock(&mutex);
>+		if (cnt == 2)
>+			both_wait = true;
>+		pthread_mutex_unlock(&mutex);
>+		sleep(1);
>+	}
>+
>+	sqe = io_uring_get_sqe(&ring);
>+	if (!sqe) {
>+		fprintf(stderr, "%s: get sqe failed\n", __FUNCTION__);
>+		goto err;
>+	}
>+
>+	io_uring_prep_nop(sqe);
>+
>+	ret = io_uring_submit(&ring);
>+	if (ret <= 0) {
>+		fprintf(stderr, "%s: sqe submit failed: %d\n", __FUNCTION__, ret);
>+		goto err;
>+	}
>+
>+	pthread_join(reap_thread0, NULL);
>+	pthread_join(reap_thread1, NULL);
>+
>+	if ((thread_ret0 && thread_ret0 != -ETIME) || (thread_ret1 && thread_ret1 != -ETIME)) {
>+		fprintf(stderr, "%s: thread wait cqe timeout failed: %d %d\n",
>+				__FUNCTION__, thread_ret0, thread_ret1);
>+		goto err;
>+	}
>+
>+	return 0;
>+err:
>+	return 1;
>+}
>+
>+int main(int argc, char *argv[])
>+{
>+	struct io_uring ring_normal, ring_sq;
>+	int ret;
>+
>+	if (argc > 1)
>+		return 0;
>+
>+	ret = io_uring_queue_init(8, &ring_normal, 0);
>+	if (ret) {
>+		fprintf(stderr, "ring_normal setup failed: %d\n", ret);
>+		return 1;
>+	}
>+	if (!(ring_normal.features & IORING_FEAT_EXT_ARG)) {
>+		fprintf(stderr, "feature IORING_FEAT_EXT_ARG not supported.\n");
>+		return 1;
>+	}
>+
>+	ret = test_return_before_timeout(&ring_normal);
>+	if (ret) {
>+		fprintf(stderr, "ring_normal: test_return_before_timeout failed\n");
>+		return ret;
>+	}
>+
>+	ret = test_return_after_timeout(&ring_normal);
>+	if (ret) {
>+		fprintf(stderr, "ring_normal: test_return_after_timeout failed\n");
>+		return ret;
>+	}
>+
>+	ret = io_uring_queue_init(8, &ring_sq, IORING_SETUP_SQPOLL);
>+	if (ret) {
>+		fprintf(stderr, "ring_sq setup failed: %d\n", ret);
>+		return 1;
>+	}
>+
>+	ret = test_return_before_timeout(&ring_sq);
>+	if (ret) {
>+		fprintf(stderr, "ring_sq: test_return_before_timeout failed\n");
>+		return ret;
>+	}
>+
>+	ret = test_return_after_timeout(&ring_sq);
>+	if (ret) {
>+		fprintf(stderr, "ring_sq: test_return_after_timeout failed\n");
>+		return ret;
>+	}
>+
>+	ret = test_multi_threads_timeout();
>+	if (ret) {
>+		fprintf(stderr, "test_multi_threads_timeout failed\n");
>+		return ret;
>+	}
>+
>+	return 0;
>+}
>-- 
>1.8.3.1
>

Thanks,
Stefano

