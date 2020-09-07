Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5A95A25FE88
	for <lists+io-uring@lfdr.de>; Mon,  7 Sep 2020 18:18:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730271AbgIGQSo (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 7 Sep 2020 12:18:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60026 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729995AbgIGQSh (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 7 Sep 2020 12:18:37 -0400
Received: from mail-pj1-x1044.google.com (mail-pj1-x1044.google.com [IPv6:2607:f8b0:4864:20::1044])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B8D4CC061573
        for <io-uring@vger.kernel.org>; Mon,  7 Sep 2020 09:18:36 -0700 (PDT)
Received: by mail-pj1-x1044.google.com with SMTP id b16so6941056pjp.0
        for <io-uring@vger.kernel.org>; Mon, 07 Sep 2020 09:18:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:from:to:references:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=CS28LpivZuMPCxZvggxZmB5mNgFAardioYgBPGW6jNA=;
        b=SAOgfH0KBOVzbXAnvjqfAGLtVUBEfqFx2Nz5f+2Rcos7CnmzN/DYIqP/Ig0kuC1PSV
         axTkWG8wRqTQBzNAQA3eDBbximzCybSfQZy++H/MKMsCkobcG+KMz3zH6eaM1+uMeGXQ
         674AOigiAbKYhtrOCgZyNz4O3NeCkr7Eb0xd8QGy5WDh0jdsNtu1bUDKV776FkeDOZKD
         ctSJ3npctC0DjpKh0eZEsUhq4Tt2GjTK6nbw6zjoide4CuAN9jIP0sWuYtMWfOGT2/tN
         kU4aFgaJDd4HAj1d6EFlFgjLbMz9TMqtCPVpgfcTU4p0jzu1a2D+v2JyZoS3wp/pxqLU
         EVTg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:references:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=CS28LpivZuMPCxZvggxZmB5mNgFAardioYgBPGW6jNA=;
        b=XhfQCBkelJY+45OdJk1Ed+Ac4WHJl3kDVD29Kf7iSJVL38b+e+GLTgN7eBfko7aGBN
         G5HnFCer9m43iU4AuJ8KpBW95BBmaZLqXFrGuozXh/XZjdPsRP2ZKzcs8jNThCk7RcvY
         u3A0rlJpUFiZl+Ssr47csscnmvIy+KqlokgoPH7cprWBvaEaWwccVLCjkVyEXRL3XsyZ
         z3cG2GlrQue+pXrbCRLRPEwC/iGSbMaVW8L2OoeGilu2Bwa0w36CBxa67h+tX+5vNpwP
         SKkw8zRJGi1bkRiatQ+wtUw7/EszaBn1Qhknbv6L0NA0/rAcymY3fbpn8nEk251KxFVF
         uRqQ==
X-Gm-Message-State: AOAM531XanbxSrpqEupsslIGleK+yK1tS8dOc4wzrn3f3JXV6kqtIAu/
        MSHwMYkIVX9iXhdBLTdzLmEKZ+lTpmrFp8Zl
X-Google-Smtp-Source: ABdhPJzI3xTYvRL9KchwxqGKVoTfAAGsUwbPN9qInLblbrik4/cjH2M83AmrJbrvXMVOryEAOeGnJw==
X-Received: by 2002:a17:902:6ac7:b029:d0:89f3:28d1 with SMTP id i7-20020a1709026ac7b02900d089f328d1mr18594240plt.13.1599495515924;
        Mon, 07 Sep 2020 09:18:35 -0700 (PDT)
Received: from [192.168.1.182] ([66.219.217.173])
        by smtp.gmail.com with ESMTPSA id kk17sm2833988pjb.31.2020.09.07.09.18.35
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 07 Sep 2020 09:18:35 -0700 (PDT)
Subject: Re: [PATCH 8/8] io_uring: enable IORING_SETUP_ATTACH_WQ to attach to
 SQPOLL thread too
From:   Jens Axboe <axboe@kernel.dk>
To:     Xiaoguang Wang <xiaoguang.wang@linux.alibaba.com>,
        io-uring@vger.kernel.org
References: <20200903022053.912968-1-axboe@kernel.dk>
 <20200903022053.912968-9-axboe@kernel.dk>
 <c6562c28-7631-d593-d3e5-cde158337337@linux.alibaba.com>
 <13bd91f7-9eef-cc38-d892-d28e5d068421@kernel.dk>
Message-ID: <c9cde576-3e5a-15b1-6f54-d0f474e25394@kernel.dk>
Date:   Mon, 7 Sep 2020 10:18:34 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <13bd91f7-9eef-cc38-d892-d28e5d068421@kernel.dk>
Content-Type: text/plain; charset=gbk
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 9/7/20 10:14 AM, Jens Axboe wrote:
> On 9/7/20 2:56 AM, Xiaoguang Wang wrote:
>> 3. When it's appropriate to set ctx's IORING_SQ_NEED_WAKEUP flag? In
>> your current implementation, if a ctx is marked as SQT_IDLE, this ctx
>> will be set IORING_SQ_NEED_WAKEUP flag, but if other ctxes have work
>> to do, then io_sq_thread is still running and does not need to be
>> waken up, then a later wakeup form userspace is unnecessary. I think
>> it maybe appropriate to set IORING_SQ_NEED_WAKEUP when all ctxes have
>> no work to do, you can have a look at my attached codes:)
> 
> That's a good point, any chance I can get you to submit a patch to fix
> that up?

Something like this?

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 4bd18e01ae89..80913973337a 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -6747,8 +6747,6 @@ static enum sq_ret __io_sq_thread(struct io_ring_ctx *ctx,
 			goto again;
 		}
 
-		io_ring_set_wakeup_flag(ctx);
-
 		to_submit = io_sqring_entries(ctx);
 		if (!to_submit || ret == -EBUSY)
 			return SQT_IDLE;
@@ -6825,6 +6823,8 @@ static int io_sq_thread(void *data)
 			io_run_task_work();
 			cond_resched();
 		} else if (ret == SQT_IDLE) {
+			list_for_each_entry(ctx, &sqd->ctx_list, sqd_list)
+				io_ring_set_wakeup_flag(ctx);
 			schedule();
 			start_jiffies = jiffies;
 		}

-- 
Jens Axboe

