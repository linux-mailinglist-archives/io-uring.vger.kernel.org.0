Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 28D963FA1BB
	for <lists+io-uring@lfdr.de>; Sat, 28 Aug 2021 01:13:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232376AbhH0XOD (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 27 Aug 2021 19:14:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55990 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232252AbhH0XOD (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 27 Aug 2021 19:14:03 -0400
Received: from mail-io1-xd33.google.com (mail-io1-xd33.google.com [IPv6:2607:f8b0:4864:20::d33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7D531C0613D9
        for <io-uring@vger.kernel.org>; Fri, 27 Aug 2021 16:13:13 -0700 (PDT)
Received: by mail-io1-xd33.google.com with SMTP id e186so10689351iof.12
        for <io-uring@vger.kernel.org>; Fri, 27 Aug 2021 16:13:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=to:from:subject:message-id:date:user-agent:mime-version
         :content-language:content-transfer-encoding;
        bh=EQeVfmSOOtE2NZXBBtS8MSrNbcRgKd2O9W8e6heWCEE=;
        b=M+sgx394mjNHP+p13/adPD240RStXcIrBGn1PjbOWdCLCar/G70nQNU7rVWeuGrWSM
         cicMzhD4qcWfMQyZ3sDeL1LLreWM9f1VHXG9udWSLGQaOhe9N3HYwNBa/UB+bYRwajbp
         VvB0cf4GawpfcMDqCrVMxwIcryG+iGOBvqH+pHX6SDOtdZ8tFW/slnLPqLwf/Vw2KQqN
         8MvH0YbVwZDvgq3PIBgoco5yRQyDhKsM1LsU66pXJIh9gMrh+icFsS4tdCcQ6jbjrsYA
         jTYd6KDNlE8PJZD4xTs8hrdSA0gDam5xqIio42aJMysQ/5yN+VB9RWN/03XcDt6ZfDA+
         crnQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:to:from:subject:message-id:date:user-agent
         :mime-version:content-language:content-transfer-encoding;
        bh=EQeVfmSOOtE2NZXBBtS8MSrNbcRgKd2O9W8e6heWCEE=;
        b=FWq5EeKnU/PiEZaVPGvj50aOP1z6fUE7+fDuNZfSbVliya5cEdDb4p7Zu/J3rdr2U+
         JWt/8b0C/YTdEJQlJgYiezFwCz+Cs5iWHL9lEeu8jFNLVeAY+vzjfcWsAhxJi0FAechU
         ejtfMKaMLYndJfgPmkxxAnL6XmuChzydTLrarO/GS+chfCRGM+PxBdQSI28+KbTjPTXB
         /r4BaGW2wx2Mxv8FFs1q6DdBlw/fIk6Ehmyo3qMcYMpZkrhFfHm3emEl5IYc7Z4o0J/H
         fAuy3T3mC/nD4zAUQO8KLsn28yXTemP1ZU8km7LfnhFA4h3ZxgYmLkixz9DASq+W+SSt
         FEuQ==
X-Gm-Message-State: AOAM532g4CxiD/yU4moeRB3PVFSkupmVqH+7pAod5KmAQl7Z0VVLPf9x
        5R5Hm3h6Mgcpg0hkLWDK7H2+qM9IF+dPiQ==
X-Google-Smtp-Source: ABdhPJzA11f8nbG6wW7jiyGqhzyboKlz3RoQjzYFZTDB5LyAmtx7rxC3QzKgGcdoQFX3YpIhtaEXZw==
X-Received: by 2002:a02:c768:: with SMTP id k8mr9997612jao.71.1630105992643;
        Fri, 27 Aug 2021 16:13:12 -0700 (PDT)
Received: from [192.168.1.116] ([66.219.217.159])
        by smtp.gmail.com with ESMTPSA id u16sm3920196iob.41.2021.08.27.16.13.12
        for <io-uring@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 27 Aug 2021 16:13:12 -0700 (PDT)
To:     io-uring <io-uring@vger.kernel.org>
From:   Jens Axboe <axboe@kernel.dk>
Subject: [PATCH] io_uring: support CLOCK_BOOTTIME for timeouts
Message-ID: <94d4ac48-7fa8-3195-99d6-986a6b5e3712@kernel.dk>
Date:   Fri, 27 Aug 2021 17:13:11 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Certain use cases want to use CLOCK_BOOTTIME rather than CLOCK_MONOTONIC,
as it doesn't stop updating over suspend. Apart from that, they should
behave the same.

Add an IORING_TIMEOUT_BOOTTIME flag that allows timeouts and linked
timeouts to use CLOCK_BOOTTIME instead.

Signed-off-by: Jens Axboe <axboe@kernel.dk>

---

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 0f827fbe8e6c..39c8631e4d10 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -508,6 +508,7 @@ struct io_timeout_data {
 	struct hrtimer			timer;
 	struct timespec64		ts;
 	enum hrtimer_mode		mode;
+	u32				flags;
 };
 
 struct io_accept {
@@ -5725,7 +5726,10 @@ static int io_timeout_update(struct io_ring_ctx *ctx, __u64 user_data,
 	req->timeout.off = 0; /* noseq */
 	data = req->async_data;
 	list_add_tail(&req->timeout.list, &ctx->timeout_list);
-	hrtimer_init(&data->timer, CLOCK_MONOTONIC, mode);
+	if (data->flags & IORING_TIMEOUT_BOOTTIME)
+		hrtimer_init(&data->timer, CLOCK_BOOTTIME, mode);
+	else
+		hrtimer_init(&data->timer, CLOCK_MONOTONIC, mode);
 	data->timer.function = io_timeout_fn;
 	hrtimer_start(&data->timer, timespec64_to_ktime(*ts), mode);
 	return 0;
@@ -5807,7 +5811,7 @@ static int io_timeout_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe,
 	if (off && is_timeout_link)
 		return -EINVAL;
 	flags = READ_ONCE(sqe->timeout_flags);
-	if (flags & ~IORING_TIMEOUT_ABS)
+	if (flags & ~(IORING_TIMEOUT_ABS | IORING_TIMEOUT_BOOTTIME))
 		return -EINVAL;
 
 	req->timeout.off = off;
@@ -5819,12 +5823,16 @@ static int io_timeout_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe,
 
 	data = req->async_data;
 	data->req = req;
+	data->flags = flags;
 
 	if (get_timespec64(&data->ts, u64_to_user_ptr(sqe->addr)))
 		return -EFAULT;
 
 	data->mode = io_translate_timeout_mode(flags);
-	hrtimer_init(&data->timer, CLOCK_MONOTONIC, data->mode);
+	if (flags & IORING_TIMEOUT_BOOTTIME)
+		hrtimer_init(&data->timer, CLOCK_BOOTTIME, data->mode);
+	else
+		hrtimer_init(&data->timer, CLOCK_MONOTONIC, data->mode);
 
 	if (is_timeout_link) {
 		struct io_submit_link *link = &req->ctx->submit_state.link;
diff --git a/include/uapi/linux/io_uring.h b/include/uapi/linux/io_uring.h
index bb6845e14629..18a4ffd2bbb3 100644
--- a/include/uapi/linux/io_uring.h
+++ b/include/uapi/linux/io_uring.h
@@ -151,6 +151,7 @@ enum {
  */
 #define IORING_TIMEOUT_ABS	(1U << 0)
 #define IORING_TIMEOUT_UPDATE	(1U << 1)
+#define IORING_TIMEOUT_BOOTTIME	(1U << 2)
 
 /*
  * sqe->splice_flags

-- 
Jens Axboe

