Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4DC5825FE41
	for <lists+io-uring@lfdr.de>; Mon,  7 Sep 2020 18:11:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729826AbgIGQLy (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 7 Sep 2020 12:11:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58982 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729821AbgIGQLu (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 7 Sep 2020 12:11:50 -0400
Received: from mail-pf1-x442.google.com (mail-pf1-x442.google.com [IPv6:2607:f8b0:4864:20::442])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BDE59C061573
        for <io-uring@vger.kernel.org>; Mon,  7 Sep 2020 09:11:49 -0700 (PDT)
Received: by mail-pf1-x442.google.com with SMTP id f18so8824901pfa.10
        for <io-uring@vger.kernel.org>; Mon, 07 Sep 2020 09:11:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:references:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=0yaOn7zKIHVsN1smHQJ1CVqnM0XdS5N41/VZp/lLtdg=;
        b=wOzu4577PNIhXMmuXnHZ76kn2M00VRYuo4MyIkHPeRti1FVPW8Ytrw3Hh0ulcrzR/m
         /s9qN7DGj4KytS3xiRtmQU5zQp1wRsOml3eClHeIJvaNafBGGN11T7t3e+ktRg/tuhUZ
         lRGExdnUsqRsXbyokUUvxN8hMmmkeYcMuI7IRS/VmfA77wXGMG4vgLcWP+jv2KZQ5B21
         qxMo91hdDS768f0jyCwCp8aH9fG/lTMBQ5vG+t90dOTb8mNyq2J08WHtsUNdGRvJu1ZE
         aoXXj1YE/VsNbdlLKJ93f8FfM/lBQhx6oW1Sblp2c/4F3Qnyx5Wbk6Q5cRrJYVnke6Dl
         rSvg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=0yaOn7zKIHVsN1smHQJ1CVqnM0XdS5N41/VZp/lLtdg=;
        b=ry0rdWmn5DvrFQE23IuLKhDEem9ipgo516GiaLKqNPXJP+YXYADWE+B6CrIy/aJU38
         THOmLk7mA2c1QozmRKs5kWOcSWU4HUxgsNeeByF3vbaC1YjmJEqVPtwPMvPd03fM7mRL
         c7evPRrbHCSc5pAUSStDt2U8kij3Iyj7mJJTKXRQuYjJwQwrhwWlWAKxIMvbUpBFAmqL
         LNhGi+Whfa0MHFfDNy3gH1d/NaG24alUF29xKkBHlvJpasUw0dUoDlNvzvF82HXfoT6O
         P/kVraq6z1ya1omFtNftFZNGLPHiLA+HxC4jBSEwBtHLmEKKcnIYd6NOA+UGkqLLUeWn
         08Gg==
X-Gm-Message-State: AOAM532IsoL6aZHx7QE7gaZpGwgQvL403abd3U/bvJL33mnvpykaSf2e
        05lz/b/Ers/PbFqAyZIJk99Rugbfs9ZYwavb
X-Google-Smtp-Source: ABdhPJzHzd09KQKbg3oVde/L7lPCTZm6abv9iDGfjXwHHtRhIUphkSvpPR5FNIEwtVbRvgpCe3Ghpw==
X-Received: by 2002:aa7:942a:: with SMTP id y10mr15109872pfo.68.1599495107984;
        Mon, 07 Sep 2020 09:11:47 -0700 (PDT)
Received: from [192.168.1.182] ([66.219.217.173])
        by smtp.gmail.com with ESMTPSA id l1sm15606264pfc.164.2020.09.07.09.11.46
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 07 Sep 2020 09:11:47 -0700 (PDT)
Subject: Re: [PATCH 8/8] io_uring: enable IORING_SETUP_ATTACH_WQ to attach to
 SQPOLL thread too
To:     Pavel Begunkov <asml.silence@gmail.com>,
        Xiaoguang Wang <xiaoguang.wang@linux.alibaba.com>,
        io-uring@vger.kernel.org
References: <20200903022053.912968-1-axboe@kernel.dk>
 <20200903022053.912968-9-axboe@kernel.dk>
 <c6562c28-7631-d593-d3e5-cde158337337@linux.alibaba.com>
 <aa93c14b-cd50-b250-f70b-5c450c01ee8a@gmail.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <385ae153-cb86-cae7-c58e-f39f8b7e8ee5@kernel.dk>
Date:   Mon, 7 Sep 2020 10:11:46 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <aa93c14b-cd50-b250-f70b-5c450c01ee8a@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 9/7/20 8:00 AM, Pavel Begunkov wrote:
> On 07/09/2020 11:56, Xiaoguang Wang wrote:
>> hi,
>>
>> First thanks for this patchset:) and I have some questions below:
>>
>> 1. Does a uring instance which has SQPOLL enabled but does not specify
>> a valid cpu is meaningful in real business product?
>> IMHO, in a real business product, cpu usage should be under strict management,
>> say a uring instance which has SQPOLL enabled but is not bound to fixed cpu,
>> then this uring instance's corresponding io_sq_thread could be scheduled to any
>> cpu(and can be re-scheduled many times), which may impact any other application
>> greatly because of cpu contention, especially this io_sq_thread is just doing
>> busy loop in its sq_thread_idle period time, so in a real business product, I
>> wonder whether SQPOLL is only meaningful if user specifies a fixed cpu core.
> 
> It is meaningful for a part of cases, for the other part you can set
> processes' affinities and pin each SQPOLL thread to a specific CPU, as
> you'd do even without this series. And that gives you more flexibilty,
> IMHO.

Right, and once we have "any ctx can use this poll thread", then percpu
poll threads could be a subset of that. So no reason that kind of
functionality couldn't be layered on top of that. 

You'd probably just need an extra SETUP flag for this. Xiaoguang, any
interest in attempting to layer that on top of that current code?

>> 2. Does IORING_SETUP_ATTACH_WQ is really convenient?
>> IORING_SETUP_ATTACH_WQ always needs to ensure a parent uring instance exists,
>> that means it also requires app to regulate the creation oder of uring instanes,
>> which maybe not convenient, just imagine how to integrate this new SQPOLL
>> improvements to fio util.
> 
> It may be not so convenient, but it's flexible enough and prevents
> isolation breaking issues. We've discussed that in the thread with
> your patches.

I think there's one minor issue there, and that is matching on just the
fd. That could cause different process rings to attach to the wrong one.
I think we need this on top to match the file as well. This is a bit
different on the SQPOLL side vs the io-wq workqueue.

Something like the below incremental should do it, makes it clear that
we need to be able to get at this file, and doesn't risk false attaching
globally. As a plus, it gets rid of that global list too, and makes it
consistent with io-wq for ATTACH_WQ.

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 0490edfcdd88..4bd18e01ae89 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -232,10 +232,6 @@ struct io_restriction {
 struct io_sq_data {
 	refcount_t		refs;
 
-	/* global sqd lookup */
-	struct list_head	all_sqd_list;
-	int			attach_fd;
-
 	/* ctx's that are using this sqd */
 	struct list_head	ctx_list;
 	struct list_head	ctx_new_list;
@@ -245,9 +241,6 @@ struct io_sq_data {
 	struct wait_queue_head	wait;
 };
 
-static LIST_HEAD(sqd_list);
-static DEFINE_MUTEX(sqd_lock);
-
 struct io_ring_ctx {
 	struct {
 		struct percpu_ref	refs;
@@ -7034,32 +7027,37 @@ static void io_put_sq_data(struct io_sq_data *sqd)
 			kthread_stop(sqd->thread);
 		}
 
-		mutex_lock(&sqd_lock);
-		list_del(&sqd->all_sqd_list);
-		mutex_unlock(&sqd_lock);
-
 		kfree(sqd);
 	}
 }
 
 static struct io_sq_data *io_attach_sq_data(struct io_uring_params *p)
 {
-	struct io_sq_data *sqd, *ret = ERR_PTR(-ENXIO);
+	struct io_ring_ctx *ctx_attach;
+	struct io_sq_data *sqd;
+	struct fd f;
 
-	mutex_lock(&sqd_lock);
-	list_for_each_entry(sqd, &sqd_list, all_sqd_list) {
-		if (sqd->attach_fd == p->wq_fd) {
-			refcount_inc(&sqd->refs);
-			ret = sqd;
-			break;
-		}
+	f = fdget(p->wq_fd);
+	if (!f.file)
+		return ERR_PTR(-ENXIO);
+	if (f.file->f_op != &io_uring_fops) {
+		fdput(f);
+		return ERR_PTR(-EINVAL);
 	}
-	mutex_unlock(&sqd_lock);
 
-	return ret;
+	ctx_attach = f.file->private_data;
+	sqd = ctx_attach->sq_data;
+	if (!sqd) {
+		fdput(f);
+		return ERR_PTR(-EINVAL);
+	}
+
+	refcount_inc(&sqd->refs);
+	fdput(f);
+	return sqd;
 }
 
-static struct io_sq_data *io_get_sq_data(struct io_uring_params *p, int ring_fd)
+static struct io_sq_data *io_get_sq_data(struct io_uring_params *p)
 {
 	struct io_sq_data *sqd;
 
@@ -7071,15 +7069,11 @@ static struct io_sq_data *io_get_sq_data(struct io_uring_params *p, int ring_fd)
 		return ERR_PTR(-ENOMEM);
 
 	refcount_set(&sqd->refs, 1);
-	sqd->attach_fd = ring_fd;
 	INIT_LIST_HEAD(&sqd->ctx_list);
 	INIT_LIST_HEAD(&sqd->ctx_new_list);
 	mutex_init(&sqd->ctx_lock);
 	init_waitqueue_head(&sqd->wait);
 
-	mutex_lock(&sqd_lock);
-	list_add_tail(&sqd->all_sqd_list, &sqd_list);
-	mutex_unlock(&sqd_lock);
 	return sqd;
 }
 
@@ -7746,7 +7740,7 @@ static int io_init_wq_offload(struct io_ring_ctx *ctx,
 }
 
 static int io_sq_offload_create(struct io_ring_ctx *ctx,
-				struct io_uring_params *p, int ring_fd)
+				struct io_uring_params *p)
 {
 	int ret;
 
@@ -7757,7 +7751,7 @@ static int io_sq_offload_create(struct io_ring_ctx *ctx,
 		if (!capable(CAP_SYS_ADMIN) && !capable(CAP_SYS_NICE))
 			goto err;
 
-		sqd = io_get_sq_data(p, ring_fd);
+		sqd = io_get_sq_data(p);
 		if (IS_ERR(sqd)) {
 			ret = PTR_ERR(sqd);
 			goto err;
@@ -8972,7 +8966,7 @@ static int io_uring_create(unsigned entries, struct io_uring_params *p,
 		goto err;
 	}
 
-	ret = io_sq_offload_create(ctx, p, fd);
+	ret = io_sq_offload_create(ctx, p);
 	if (ret)
 		goto err;
 

-- 
Jens Axboe

