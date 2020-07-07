Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 89B82216EB3
	for <lists+io-uring@lfdr.de>; Tue,  7 Jul 2020 16:28:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726900AbgGGO2X (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 7 Jul 2020 10:28:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52156 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726805AbgGGO2X (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 7 Jul 2020 10:28:23 -0400
Received: from mail-io1-xd41.google.com (mail-io1-xd41.google.com [IPv6:2607:f8b0:4864:20::d41])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5FEF0C061755
        for <io-uring@vger.kernel.org>; Tue,  7 Jul 2020 07:28:23 -0700 (PDT)
Received: by mail-io1-xd41.google.com with SMTP id q8so43362323iow.7
        for <io-uring@vger.kernel.org>; Tue, 07 Jul 2020 07:28:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=PnRFrWSYf/FZeqNV55RWDQdyOKsjLYLfvKaccxSNUsc=;
        b=D51efw/6lj2JdhIB8qhlPlauFaB8AinuM1VmgyavyIjZAUdubuyaw2V7OvXQlYjrhC
         Usl/FQtoJQglVTknLZBKZ7llTPgc4Q4G9/xafh/HYSUkQgL5kpwvbG5vGRqQ5+SPKYdp
         bcoj0SnaOlvv25AyU7VR4kP/uAZZbGwRUvJeHRwho8qoCRDRLCxvDc9Ly6e0o5fCREyT
         TgxMKnV0VnpdlBOQMJzwjYb0rjhZTgtFUHkfb0vkkgVMjHgo1nlqGYpN39NzEdYY2p5w
         cHYxVODdO7lZVZj4bBAnorQgUF7kpQRH8htUpEWL4NMcaLxuOaTdVxF9zwZhOa2LJRpS
         3AOA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=PnRFrWSYf/FZeqNV55RWDQdyOKsjLYLfvKaccxSNUsc=;
        b=sVCH2PtS38NdzDUF4yqGegoBjMlIAtjdcyjlqNa2uwuzxHsUQDuy/wRxCr8K3lsq4/
         PfSavHBvcFFnlAUWFxfUtCOEmAX3f9+X8sZCJqWVQa/SFrLtFxvJNXI9Fp+sL7QEQrM3
         yttt3nOv76Sr7CwmqWueHQw+qs97mnJWrmfH0fVAjMe8s9Faac9zMxQu94Gor8wUR+9C
         M5KqG3ri54RUnMKIYBQouojtULquVzV/9oBv0yhXvikXm6BIyAqOtUXdibsMCG7qLCD7
         3AS2brwaI88lhY0Hd/FR/yhh67C8WWtOAJytY83C9WTqq6kuIzdrBn1pe+TtehFyLLbj
         eSqg==
X-Gm-Message-State: AOAM533Z/ECEt0/MI4dT+IalL0dB3ZrA8PfSf6KPwilq4CoPm0cqkEA0
        G4zEbAf31w5OhsQJnBk1+pekrYSmZROsPA==
X-Google-Smtp-Source: ABdhPJwqsHPm0STzzZ+kGsSqNNbFyrqfQ7ewxwD76+hrHmmd5Mj3HP9lQvbq7qjsWRT+tOnZPyl9ZQ==
X-Received: by 2002:a05:6602:2cc9:: with SMTP id j9mr31241538iow.181.1594132102532;
        Tue, 07 Jul 2020 07:28:22 -0700 (PDT)
Received: from [192.168.1.58] ([65.144.74.34])
        by smtp.gmail.com with ESMTPSA id z9sm12988733ilz.45.2020.07.07.07.28.21
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 07 Jul 2020 07:28:21 -0700 (PDT)
Subject: Re: [PATCH] io_uring: export cq overflow status to userspace
To:     Xiaoguang Wang <xiaoguang.wang@linux.alibaba.com>,
        io-uring@vger.kernel.org
Cc:     joseph.qi@linux.alibaba.com
References: <20200707132420.2007-1-xiaoguang.wang@linux.alibaba.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <0ebded37-3660-e3c0-aa51-d3d7e56d634c@kernel.dk>
Date:   Tue, 7 Jul 2020 08:28:20 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.8.0
MIME-Version: 1.0
In-Reply-To: <20200707132420.2007-1-xiaoguang.wang@linux.alibaba.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 7/7/20 7:24 AM, Xiaoguang Wang wrote:
> For those applications which are not willing to use io_uring_enter()
> to reap and handle cqes, they may completely rely on liburing's
> io_uring_peek_cqe(), but if cq ring has overflowed, currently because
> io_uring_peek_cqe() is not aware of this overflow, it won't enter
> kernel to flush cqes, below test program can reveal this bug:
> 
> static void test_cq_overflow(struct io_uring *ring)
> {
>         struct io_uring_cqe *cqe;
>         struct io_uring_sqe *sqe;
>         int issued = 0;
>         int ret = 0;
> 
>         do {
>                 sqe = io_uring_get_sqe(ring);
>                 if (!sqe) {
>                         fprintf(stderr, "get sqe failed\n");
>                         break;;
>                 }
>                 ret = io_uring_submit(ring);
>                 if (ret <= 0) {
>                         if (ret != -EBUSY)
>                                 fprintf(stderr, "sqe submit failed: %d\n", ret);
>                         break;
>                 }
>                 issued++;
>         } while (ret > 0);
>         assert(ret == -EBUSY);
> 
>         printf("issued requests: %d\n", issued);
> 
>         while (issued) {
>                 ret = io_uring_peek_cqe(ring, &cqe);
>                 if (ret) {
>                         if (ret != -EAGAIN) {
>                                 fprintf(stderr, "peek completion failed: %s\n",
>                                         strerror(ret));
>                                 break;
>                         }
>                         printf("left requets: %d\n", issued);
>                         continue;
>                 }
>                 io_uring_cqe_seen(ring, cqe);
>                 issued--;
>                 printf("left requets: %d\n", issued);
>         }
> }
> 
> int main(int argc, char *argv[])
> {
>         int ret;
>         struct io_uring ring;
> 
>         ret = io_uring_queue_init(16, &ring, 0);
>         if (ret) {
>                 fprintf(stderr, "ring setup failed: %d\n", ret);
>                 return 1;
>         }
> 
>         test_cq_overflow(&ring);
>         return 0;
> }
> 
> To fix this issue, export cq overflow status to userspace, then
> helper functions() in liburing, such as io_uring_peek_cqe, can be
> aware of this cq overflow and do flush accordingly.

Is there any way we can accomplish the same without exporting
another set of flags? Would it be enough for the SQPOLl thread to set
IORING_SQ_NEED_WAKEUP if we're in overflow condition? That should
result in the app entering the kernel when it's flushed the user CQ
side, and then the sqthread could attempt to flush the pending
events as well.

Something like this, totally untested...

diff --git a/fs/io_uring.c b/fs/io_uring.c
index d37d7ea5ebe5..d409bd68553f 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -6110,8 +6110,18 @@ static int io_sq_thread(void *data)
 		}
 
 		mutex_lock(&ctx->uring_lock);
-		if (likely(!percpu_ref_is_dying(&ctx->refs)))
+		if (likely(!percpu_ref_is_dying(&ctx->refs))) {
+retry:
 			ret = io_submit_sqes(ctx, to_submit, NULL, -1);
+			if (unlikely(ret == -EBUSY)) {
+				ctx->rings->sq_flags |= IORING_SQ_NEED_WAKEUP;
+				smp_mb();
+				if (io_cqring_overflow_flush(ctx, false)) {
+					ctx->rings->sq_flags &= ~IORING_SQ_NEED_WAKEUP;
+					goto retry;
+				}
+			}
+		}
 		mutex_unlock(&ctx->uring_lock);
 		timeout = jiffies + ctx->sq_thread_idle;
 	}

-- 
Jens Axboe

