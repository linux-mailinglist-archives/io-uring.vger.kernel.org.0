Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BC04C3FA33C
	for <lists+io-uring@lfdr.de>; Sat, 28 Aug 2021 04:40:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233045AbhH1Cl3 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 27 Aug 2021 22:41:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45640 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232953AbhH1Cl2 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 27 Aug 2021 22:41:28 -0400
Received: from mail-io1-xd2e.google.com (mail-io1-xd2e.google.com [IPv6:2607:f8b0:4864:20::d2e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0B973C0613D9
        for <io-uring@vger.kernel.org>; Fri, 27 Aug 2021 19:40:39 -0700 (PDT)
Received: by mail-io1-xd2e.google.com with SMTP id z1so11410597ioh.7
        for <io-uring@vger.kernel.org>; Fri, 27 Aug 2021 19:40:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=to:from:subject:message-id:date:user-agent:mime-version
         :content-language:content-transfer-encoding;
        bh=yYlPxjVUioLQnIZj5l9hSJKhVcYoEAaZyvA0rEe+lrs=;
        b=oED1Q6ugJiI/YBLkcmaAQ+fzZ5VhSFtvopfZEbbecGttt52Bm2gdlOHqhxPyqe9BJt
         G4B2wryCdSJ6XLEbD49NCuuvGCdlCiDE6C3c3yGS+nys2nqhBgQ+rq/hG3lWecUaNryg
         N6T840eDF7+8aN1hwPVJwpsk3cHhhjSvsxiqVScCgRDFBdSyudIqvIGTkAeD90P0Jl8x
         w5gahMxPXSnYYWGvmkhR1XNQqd0PxVTlhKGuJZkvdqCnnm7HRiF2MPGyvhIXOP4xgeVk
         xbAHxpz/OIum8EVc4oGjTiyiOjCXk0cn7emIYTIFC6rqqSrzN6alF6fW3laGoZnPe8Xq
         wuUw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:to:from:subject:message-id:date:user-agent
         :mime-version:content-language:content-transfer-encoding;
        bh=yYlPxjVUioLQnIZj5l9hSJKhVcYoEAaZyvA0rEe+lrs=;
        b=YDyh5gms/yrvl6sFPxWmD9I271AXBrnk66Rs2/ytgN9/Li0GvMtWz5dP1f4QkYdrYU
         0LZl0FETMUMKXhOkXT7e6+xFdEYdnteBGQWyGVfIDth4JiUII3WziUvA00bzIw4gctwa
         ojxe7k6s1YxlkLrajdmBRwARyFwWOOR4Z2PkwX3wNhonk7sxPpiNkxpGXfK3wbLTWEua
         MWAddiozmcwMzMiJNkUrcuPkaqOeMkKkHNU+0XbMhjTN++hec22hAJvQGr4yKjC9MA4E
         DKDa7/zj7/EvlSIvyXYt5DGjACrMw28NrU6DN7SPSoQUbLAq4qMM25Vf4k/fXU7v/FCV
         y1fg==
X-Gm-Message-State: AOAM533AUTda2S8FDRAFy+HoEL+VAsmewdEkCA7Hp13FUlFnO5LiZrKR
        +zYqRHc+Z5u0YY2F39uVoYb1B0yPq4Z9rQ==
X-Google-Smtp-Source: ABdhPJxX/vrgwDtnct4gcN0dNidjrWMK41kbrtQJf/x7lgPoxP2kNsMMRuIbwH6DVL+/F0dEXyYv2Q==
X-Received: by 2002:a02:5bc5:: with SMTP id g188mr10983449jab.136.1630118438076;
        Fri, 27 Aug 2021 19:40:38 -0700 (PDT)
Received: from [192.168.1.116] ([66.219.217.159])
        by smtp.gmail.com with ESMTPSA id i6sm4196520ilb.30.2021.08.27.19.40.37
        for <io-uring@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 27 Aug 2021 19:40:37 -0700 (PDT)
To:     io-uring <io-uring@vger.kernel.org>
From:   Jens Axboe <axboe@kernel.dk>
Subject: [PATCH v2] io_uring: support CLOCK_BOOTTIME/REALTIME for timeouts
Message-ID: <0e110ae2-f744-df44-e017-bf603f481348@kernel.dk>
Date:   Fri, 27 Aug 2021 20:40:36 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Certain use cases want to use CLOCK_BOOTTIME or CLOCK_REALTIME rather than
CLOCK_MONOTONIC, instead of the default CLOCK_MONOTONIC.

Add an IORING_TIMEOUT_BOOTTIME and IORING_TIMEOUT_REALTIME flag that
allows timeouts and linked timeouts to use the selected clock source.

Only one clock source may be selected, and we -EINVAL the request if more
than one is given. If neither BOOTIME nor REALTIME are selected, the
previous default of MONOTONIC is used.

Link: https://github.com/axboe/liburing/issues/369
Signed-off-by: Jens Axboe <axboe@kernel.dk>

---

There are valid reasons for using realtime as well, so update us to
allow either one to be selected. Outside of these two I don't think any
are interesting. I would suggest that the next flag added for timeouts
moved forward a few spots, just to keep the timeout mask consecutive
just in case. Easy to handle.

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 0f827fbe8e6c..bf6551ea2c00 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -508,6 +508,7 @@ struct io_timeout_data {
 	struct hrtimer			timer;
 	struct timespec64		ts;
 	enum hrtimer_mode		mode;
+	u32				flags;
 };
 
 struct io_accept {
@@ -5712,6 +5713,22 @@ static int io_timeout_cancel(struct io_ring_ctx *ctx, __u64 user_data)
 	return 0;
 }
 
+static clockid_t io_timeout_get_clock(struct io_timeout_data *data)
+{
+	switch (data->flags & IORING_TIMEOUT_CLOCK_MASK) {
+	case IORING_TIMEOUT_BOOTTIME:
+		return CLOCK_BOOTTIME;
+	case IORING_TIMEOUT_REALTIME:
+		return CLOCK_REALTIME;
+	default:
+		/* can't happen, vetted at prep time */
+		WARN_ON_ONCE(1);
+		fallthrough;
+	case 0:
+		return CLOCK_MONOTONIC;
+	}
+}
+
 static int io_timeout_update(struct io_ring_ctx *ctx, __u64 user_data,
 			     struct timespec64 *ts, enum hrtimer_mode mode)
 	__must_hold(&ctx->timeout_lock)
@@ -5725,7 +5742,7 @@ static int io_timeout_update(struct io_ring_ctx *ctx, __u64 user_data,
 	req->timeout.off = 0; /* noseq */
 	data = req->async_data;
 	list_add_tail(&req->timeout.list, &ctx->timeout_list);
-	hrtimer_init(&data->timer, CLOCK_MONOTONIC, mode);
+	hrtimer_init(&data->timer, io_timeout_get_clock(data), mode);
 	data->timer.function = io_timeout_fn;
 	hrtimer_start(&data->timer, timespec64_to_ktime(*ts), mode);
 	return 0;
@@ -5807,7 +5824,10 @@ static int io_timeout_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe,
 	if (off && is_timeout_link)
 		return -EINVAL;
 	flags = READ_ONCE(sqe->timeout_flags);
-	if (flags & ~IORING_TIMEOUT_ABS)
+	if (flags & ~(IORING_TIMEOUT_ABS | IORING_TIMEOUT_CLOCK_MASK))
+		return -EINVAL;
+	/* more than one clock specified is invalid, obviously */
+	if (hweight32(flags & IORING_TIMEOUT_CLOCK_MASK) > 1)
 		return -EINVAL;
 
 	req->timeout.off = off;
@@ -5819,12 +5839,13 @@ static int io_timeout_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe,
 
 	data = req->async_data;
 	data->req = req;
+	data->flags = flags;
 
 	if (get_timespec64(&data->ts, u64_to_user_ptr(sqe->addr)))
 		return -EFAULT;
 
 	data->mode = io_translate_timeout_mode(flags);
-	hrtimer_init(&data->timer, CLOCK_MONOTONIC, data->mode);
+	hrtimer_init(&data->timer, io_timeout_get_clock(data), data->mode);
 
 	if (is_timeout_link) {
 		struct io_submit_link *link = &req->ctx->submit_state.link;
diff --git a/include/uapi/linux/io_uring.h b/include/uapi/linux/io_uring.h
index bb6845e14629..4ea0b46e3da0 100644
--- a/include/uapi/linux/io_uring.h
+++ b/include/uapi/linux/io_uring.h
@@ -151,6 +151,9 @@ enum {
  */
 #define IORING_TIMEOUT_ABS	(1U << 0)
 #define IORING_TIMEOUT_UPDATE	(1U << 1)
+#define IORING_TIMEOUT_BOOTTIME	(1U << 2)
+#define IORING_TIMEOUT_REALTIME	(1U << 3)
+#define IORING_TIMEOUT_CLOCK_MASK	(IORING_TIMEOUT_BOOTTIME | IORING_TIMEOUT_REALTIME)
 
 /*
  * sqe->splice_flags

-- 
Jens Axboe

