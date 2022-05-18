Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 763B352BC88
	for <lists+io-uring@lfdr.de>; Wed, 18 May 2022 16:16:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236691AbiERMul (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 18 May 2022 08:50:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36824 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236852AbiERMuk (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 18 May 2022 08:50:40 -0400
Received: from mail-wr1-x432.google.com (mail-wr1-x432.google.com [IPv6:2a00:1450:4864:20::432])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 07B76174916
        for <io-uring@vger.kernel.org>; Wed, 18 May 2022 05:50:38 -0700 (PDT)
Received: by mail-wr1-x432.google.com with SMTP id j24so2596458wrb.1
        for <io-uring@vger.kernel.org>; Wed, 18 May 2022 05:50:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to;
        bh=YnjPuDtKehEZ16N5Zgmn2x7hmWmqmy/nCxinGtILWX0=;
        b=giTUBGlRB+fUVZOLF3htTWzZv7+nmc9HNpIKQ0Rwi0wrWmfDKnom2uwKtt/TZYW39+
         SgG65dBpgkgFT5ZHXVQjELnqDAGxJzLC3nu3ZxjQXlOY2PQmbHw4yG1ENR4Mqf2QrOBJ
         ovFLN2gmDNOykIooiyrEbk6sdge/oNzuItouxxYex/JOtME65M3uK8T4Tv4U/jRPUkAu
         7mNZVmShMDmjmepP7FFUlkLFYCUc3ibMz3roizOzGPcrjctenTZ+zSgYEIEGxpcCdQLJ
         DLtt0XC3QfhDCwa9LVUUQtOS4gWX/9TZgU4cpOAHApqpixey+hoX2Sg7Vt3Hccc2OVz9
         u/3A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=YnjPuDtKehEZ16N5Zgmn2x7hmWmqmy/nCxinGtILWX0=;
        b=21fiYbzSv2cwXckKE1wyXorm77mkFNr4vH7W7gbRtHU3FJklzGuDlIMu4fFBn7VGuU
         BT0SWYD2A2Ac5mvwqT47YFseJCHUmg97+gYWViUzROJJF125CamUOx5CQsaPu11RiPvL
         ho/YwwDlFna2ApPsF5ClIXfG91s1zZOzkZc9HEFVZNG6EDtu8rvau8zQr0irkAOj/K+4
         Apw0bCFLs8RShzQNyzzp5xPPJpMwHFkG1S1ylJjhD145rw8nJLqt3bk/eWAqcu1jbwqk
         7DET6IyrxsJgRUojZMrAMW3YlzqdwkUoGV/UW0YnVg0tTfqM/5JFRupvlUedroGoh84C
         NTpg==
X-Gm-Message-State: AOAM530aDiU4rHHE2+mxwBwumzICLUsBS/Doe/Tl19Lezcc6MlQiB7uH
        ByS01mROQJLc/HZn20/yPAZsaw==
X-Google-Smtp-Source: ABdhPJz1FvaiCtH5RJjqWdRc78yrpCUCxFafFi08XdY7lxorlichdoskdg9JTqOymv6Rmhyg0rWOvQ==
X-Received: by 2002:a05:6000:793:b0:20c:c809:9af1 with SMTP id bu19-20020a056000079300b0020cc8099af1mr22342778wrb.370.1652878236544;
        Wed, 18 May 2022 05:50:36 -0700 (PDT)
Received: from google.com (cpc155339-bagu17-2-0-cust87.1-3.cable.virginm.net. [86.27.177.88])
        by smtp.gmail.com with ESMTPSA id r3-20020a1c2b03000000b003942a244f39sm5277111wmr.18.2022.05.18.05.50.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 18 May 2022 05:50:35 -0700 (PDT)
Date:   Wed, 18 May 2022 13:50:34 +0100
From:   Lee Jones <lee.jones@linaro.org>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     Pavel Begunkov <asml.silence@gmail.com>, io-uring@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [REPORT] Use-after-free Read in __fdget_raw in v5.10.y
Message-ID: <YoTrmjuct3ctvFim@google.com>
References: <YoOJ/T4QRKC+fAZE@google.com>
 <97cba3e1-4ef7-0a17-8456-e0787d6702c6@kernel.dk>
 <YoOT7Cyobsed5IE3@google.com>
 <d503d5ff-4bc5-2bd0-00d3-cd7b0a0724cb@kernel.dk>
 <YoOW2+ov8KF1YcYF@google.com>
 <3d271554-9ddc-07ad-3ff8-30aba31f8bf2@kernel.dk>
 <YoOcYR15Jhkw2XwL@google.com>
 <f34c85cc-71a5-59d4-dd7a-cc07e2af536c@kernel.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <f34c85cc-71a5-59d4-dd7a-cc07e2af536c@kernel.dk>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Tue, 17 May 2022, Jens Axboe wrote:

> On 5/17/22 7:00 AM, Lee Jones wrote:
> > On Tue, 17 May 2022, Jens Axboe wrote:
> > 
> >> On 5/17/22 6:36 AM, Lee Jones wrote:
> >>> On Tue, 17 May 2022, Jens Axboe wrote:
> >>>
> >>>> On 5/17/22 6:24 AM, Lee Jones wrote:
> >>>>> On Tue, 17 May 2022, Jens Axboe wrote:
> >>>>>
> >>>>>> On 5/17/22 5:41 AM, Lee Jones wrote:
> >>>>>>> Good afternoon Jens, Pavel, et al.,
> >>>>>>>
> >>>>>>> Not sure if you are presently aware, but there appears to be a
> >>>>>>> use-after-free issue affecting the io_uring worker driver (fs/io-wq.c)
> >>>>>>> in Stable v5.10.y.
> >>>>>>>
> >>>>>>> The full sysbot report can be seen below [0].
> >>>>>>>
> >>>>>>> The C-reproducer has been placed below that [1].
> >>>>>>>
> >>>>>>> I had great success running this reproducer in an infinite loop.
> >>>>>>>
> >>>>>>> My colleague reverse-bisected the fixing commit to:
> >>>>>>>
> >>>>>>>   commit fb3a1f6c745ccd896afadf6e2d6f073e871d38ba
> >>>>>>>   Author: Jens Axboe <axboe@kernel.dk>
> >>>>>>>   Date:   Fri Feb 26 09:47:20 2021 -0700
> >>>>>>>
> >>>>>>>        io-wq: have manager wait for all workers to exit
> >>>>>>>
> >>>>>>>        Instead of having to wait separately on workers and manager, just have
> >>>>>>>        the manager wait on the workers. We use an atomic_t for the reference
> >>>>>>>        here, as we need to start at 0 and allow increment from that. Since the
> >>>>>>>        number of workers is naturally capped by the allowed nr of processes,
> >>>>>>>        and that uses an int, there is no risk of overflow.
> >>>>>>>
> >>>>>>>        Signed-off-by: Jens Axboe <axboe@kernel.dk>
> >>>>>>>
> >>>>>>>     fs/io-wq.c | 30 ++++++++++++++++++++++--------
> >>>>>>>     1 file changed, 22 insertions(+), 8 deletions(-)
> >>>>>>
> >>>>>> Does this fix it:
> >>>>>>
> >>>>>> commit 886d0137f104a440d9dfa1d16efc1db06c9a2c02
> >>>>>> Author: Jens Axboe <axboe@kernel.dk>
> >>>>>> Date:   Fri Mar 5 12:59:30 2021 -0700
> >>>>>>
> >>>>>>     io-wq: fix race in freeing 'wq' and worker access
> >>>>>>
> >>>>>> Looks like it didn't make it into 5.10-stable, but we can certainly
> >>>>>> rectify that.
> >>>>>
> >>>>> Thanks for your quick response Jens.
> >>>>>
> >>>>> This patch doesn't apply cleanly to v5.10.y.
> >>>>
> >>>> This is probably why it never made it into 5.10-stable :-/
> >>>
> >>> Right.  It doesn't apply at all unfortunately.
> >>>
> >>>>> I'll have a go at back-porting it.  Please bear with me.
> >>>>
> >>>> Let me know if you into issues with that and I can help out.
> >>>
> >>> I think the dependency list is too big.
> >>>
> >>> Too much has changed that was never back-ported.
> >>>
> >>> Actually the list of patches pertaining to fs/io-wq.c alone isn't so
> >>> bad, I did start to back-port them all but some of the big ones have
> >>> fs/io_uring.c changes incorporated and that list is huge (256 patches
> >>> from v5.10 to the fixing patch mentioned above).
> >>
> >> The problem is that 5.12 went to the new worker setup, and this patch
> >> landed after that even though it also applies to the pre-native workers.
> >> Hence the dependency chain isn't really as long as it seems, probably
> >> just a few patches backporting the change references and completions.
> >>
> >> I'll take a look this afternoon.
> > 
> > Thanks Jens.  I really appreciate it.
> 
> Can you see if this helps? Untested...

What base does this apply against please?

I tried Mainline and v5.10.116 and both failed.

> diff --git a/fs/io-wq.c b/fs/io-wq.c
> index 3d5fc76b92d0..35af489bcaf6 100644
> --- a/fs/io-wq.c
> +++ b/fs/io-wq.c
> @@ -125,6 +125,9 @@ struct io_wq {
>  	refcount_t refs;
>  	struct completion done;
>  
> +	atomic_t worker_refs;
> +	struct completion worker_done;
> +
>  	struct hlist_node cpuhp_node;
>  
>  	refcount_t use_refs;
> @@ -250,8 +253,8 @@ static void io_worker_exit(struct io_worker *worker)
>  	raw_spin_unlock_irq(&wqe->lock);
>  
>  	kfree_rcu(worker, rcu);
> -	if (refcount_dec_and_test(&wqe->wq->refs))
> -		complete(&wqe->wq->done);
> +	if (atomic_dec_and_test(&wqe->wq->worker_refs))
> +		complete(&wqe->wq->worker_done);
>  }
>  
>  static inline bool io_wqe_run_queue(struct io_wqe *wqe)
> @@ -695,9 +698,13 @@ static bool create_io_worker(struct io_wq *wq, struct io_wqe *wqe, int index)
>  	worker->wqe = wqe;
>  	spin_lock_init(&worker->lock);
>  
> +	atomic_inc(&wq->worker_refs);
> +
>  	worker->task = kthread_create_on_node(io_wqe_worker, worker, wqe->node,
>  				"io_wqe_worker-%d/%d", index, wqe->node);
>  	if (IS_ERR(worker->task)) {
> +		if (atomic_dec_and_test(&wq->worker_refs))
> +			complete(&wq->worker_done);
>  		kfree(worker);
>  		return false;
>  	}
> @@ -717,7 +724,6 @@ static bool create_io_worker(struct io_wq *wq, struct io_wqe *wqe, int index)
>  	if (index == IO_WQ_ACCT_UNBOUND)
>  		atomic_inc(&wq->user->processes);
>  
> -	refcount_inc(&wq->refs);
>  	wake_up_process(worker->task);
>  	return true;
>  }
> @@ -822,17 +828,18 @@ static int io_wq_manager(void *data)
>  		task_work_run();
>  
>  out:
> -	if (refcount_dec_and_test(&wq->refs)) {
> -		complete(&wq->done);
> -		return 0;
> -	}
>  	/* if ERROR is set and we get here, we have workers to wake */
> -	if (test_bit(IO_WQ_BIT_ERROR, &wq->state)) {
> -		rcu_read_lock();
> -		for_each_node(node)
> -			io_wq_for_each_worker(wq->wqes[node], io_wq_worker_wake, NULL);
> -		rcu_read_unlock();
> -	}
> +	rcu_read_lock();
> +	for_each_node(node)
> +		io_wq_for_each_worker(wq->wqes[node], io_wq_worker_wake, NULL);
> +	rcu_read_unlock();
> +
> +	if (atomic_read(&wq->worker_refs))
> +		wait_for_completion(&wq->worker_done);
> +
> +	if (refcount_dec_and_test(&wq->refs))
> +		complete(&wq->done);
> +
>  	return 0;
>  }
>  
> @@ -1135,6 +1142,9 @@ struct io_wq *io_wq_create(unsigned bounded, struct io_wq_data *data)
>  
>  	init_completion(&wq->done);
>  
> +	init_completion(&wq->worker_done);
> +	atomic_set(&wq->worker_refs, 0);
> +
>  	wq->manager = kthread_create(io_wq_manager, wq, "io_wq_manager");
>  	if (!IS_ERR(wq->manager)) {
>  		wake_up_process(wq->manager);
> @@ -1179,11 +1189,6 @@ static void __io_wq_destroy(struct io_wq *wq)
>  	if (wq->manager)
>  		kthread_stop(wq->manager);
>  
> -	rcu_read_lock();
> -	for_each_node(node)
> -		io_wq_for_each_worker(wq->wqes[node], io_wq_worker_wake, NULL);
> -	rcu_read_unlock();
> -
>  	wait_for_completion(&wq->done);
>  
>  	for_each_node(node)
> 
> 

-- 
Lee Jones [李琼斯]
Principal Technical Lead - Developer Services
Linaro.org │ Open source software for Arm SoCs
Follow Linaro: Facebook | Twitter | Blog
