Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D97331A0077
	for <lists+io-uring@lfdr.de>; Mon,  6 Apr 2020 23:49:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726225AbgDFVts (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 6 Apr 2020 17:49:48 -0400
Received: from us-smtp-2.mimecast.com ([207.211.31.81]:51388 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725933AbgDFVtp (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 6 Apr 2020 17:49:45 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1586209784;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=kIXDxUjS2HMskB+mPSwuv3yFtOM4CbvksE2h37nZI78=;
        b=HdCZpjFcSwWKp1JAt996D+YRgtvKuIuxxjuze4aPMbhwSq3ugFloPh2Yxt7P5Jx1s6Fm/o
        0b72TogcskQEHnofUy3FqaYUyvMhcpep1D7XFamBaZdzEzGfJt6txSLqryYpKkN836wYlX
        Dy9HujfJgJ9I6J7/CtpLBowNrlBsbk4=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-235-ZZz_V7JlNbW38E92nOLS_w-1; Mon, 06 Apr 2020 17:49:40 -0400
X-MC-Unique: ZZz_V7JlNbW38E92nOLS_w-1
Received: by mail-wm1-f69.google.com with SMTP id o5so32659wmo.6
        for <io-uring@vger.kernel.org>; Mon, 06 Apr 2020 14:49:40 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=kIXDxUjS2HMskB+mPSwuv3yFtOM4CbvksE2h37nZI78=;
        b=q3R6O+CoRBtIo1mXmRkPxuWtaGpJBMzlRPDNoYlwsRX1CQ8kBVWWqv5zk9/53rAzH8
         l8OUoGgl/h7Y+lRvCRP5/IiFVcD1m3FplkJsoLs7aD267W7jtYT3dlX5i54Rwh5BjoCd
         BHP07P0SWrMx+4WDLSg5TlK+Szzq1z0qbHMzij6fayOMwN8WX4EliGtaD3CNI5nRPg1B
         GMAfsfzOqM5tilChyvM8Xm8xfkNI7IInoZUkL8qjBlQ9OTrMeNCAWhcaAGEW9l9FXDFh
         g32tvO8V6fyj2ImEkVonWxw+MsoYs9I1X0oJuXAyw0uiz+ifFJ8o2WNSHGSfrJMuxg8G
         pPjg==
X-Gm-Message-State: AGi0PuZrVI7PW0+Vr8ZKYaq5nSUDXJ1rzYFhroLXRNyjjv9Q9xX/YqPg
        QpwFIFjPZNciaTodcLRY0FGDJTgbWqcYlPbeZ4tSPhqY3nm9+A4f0ETTSYqdvJaFkJjaqJQ1W/J
        C/udIuGoyyqCzA7wUi6E=
X-Received: by 2002:a5d:5230:: with SMTP id i16mr1340788wra.15.1586209779343;
        Mon, 06 Apr 2020 14:49:39 -0700 (PDT)
X-Google-Smtp-Source: APiQypJNgJ7eiNVOi5WqhYdhc42FjdejCWO6/Y8fkLNs2CGrGBsCWnbC9H2zd2UGSvXrNhDXRVbxFQ==
X-Received: by 2002:a5d:5230:: with SMTP id i16mr1340765wra.15.1586209779132;
        Mon, 06 Apr 2020 14:49:39 -0700 (PDT)
Received: from redhat.com (bzq-79-176-51-222.red.bezeqint.net. [79.176.51.222])
        by smtp.gmail.com with ESMTPSA id n6sm1057944wmc.28.2020.04.06.14.49.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 06 Apr 2020 14:49:38 -0700 (PDT)
Date:   Mon, 6 Apr 2020 17:49:34 -0400
From:   "Michael S. Tsirkin" <mst@redhat.com>
To:     Christoph Hellwig <hch@lst.de>
Cc:     Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Al Viro <viro@zeniv.linux.org.uk>,
        Felix Kuehling <Felix.Kuehling@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        Zhenyu Wang <zhenyuw@linux.intel.com>,
        Zhi Wang <zhi.a.wang@intel.com>,
        Felipe Balbi <balbi@kernel.org>,
        Jason Wang <jasowang@redhat.com>, Jens Axboe <axboe@kernel.dk>,
        linux-kernel@vger.kernel.org, amd-gfx@lists.freedesktop.org,
        intel-gvt-dev@lists.freedesktop.org,
        intel-gfx@lists.freedesktop.org, linux-usb@vger.kernel.org,
        virtualization@lists.linux-foundation.org,
        linux-fsdevel@vger.kernel.org, io-uring@vger.kernel.org,
        linux-mm@kvack.org
Subject: Re: [PATCH 6/6] kernel: set USER_DS in kthread_use_mm
Message-ID: <20200406174917-mutt-send-email-mst@kernel.org>
References: <20200404094101.672954-1-hch@lst.de>
 <20200404094101.672954-7-hch@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200404094101.672954-7-hch@lst.de>
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Sat, Apr 04, 2020 at 11:41:01AM +0200, Christoph Hellwig wrote:
> Some architectures like arm64 and s390 require USER_DS to be set for
> kernel threads to access user address space, which is the whole purpose
> of kthread_use_mm, but other like x86 don't.  That has lead to a huge
> mess where some callers are fixed up once they are tested on said
> architectures, while others linger around and yet other like io_uring
> try to do "clever" optimizations for what usually is just a trivial
> asignment to a member in the thread_struct for most architectures.
> 
> Make kthread_use_mm set USER_DS, and kthread_unuse_mm restore to the
> previous value instead.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

I'm ok with vhost bits:

Acked-by: Michael S. Tsirkin <mst@redhat.com>

> ---
>  drivers/usb/gadget/function/f_fs.c | 4 ----
>  drivers/vhost/vhost.c              | 3 ---
>  fs/io-wq.c                         | 8 ++------
>  fs/io_uring.c                      | 4 ----
>  kernel/kthread.c                   | 6 ++++++
>  5 files changed, 8 insertions(+), 17 deletions(-)
> 
> diff --git a/drivers/usb/gadget/function/f_fs.c b/drivers/usb/gadget/function/f_fs.c
> index d9e48bd7c692..a1198f4c527c 100644
> --- a/drivers/usb/gadget/function/f_fs.c
> +++ b/drivers/usb/gadget/function/f_fs.c
> @@ -824,13 +824,9 @@ static void ffs_user_copy_worker(struct work_struct *work)
>  	bool kiocb_has_eventfd = io_data->kiocb->ki_flags & IOCB_EVENTFD;
>  
>  	if (io_data->read && ret > 0) {
> -		mm_segment_t oldfs = get_fs();
> -
> -		set_fs(USER_DS);
>  		kthread_use_mm(io_data->mm);
>  		ret = ffs_copy_to_iter(io_data->buf, ret, &io_data->data);
>  		kthread_unuse_mm(io_data->mm);
> -		set_fs(oldfs);
>  	}
>  
>  	io_data->kiocb->ki_complete(io_data->kiocb, ret, ret);
> diff --git a/drivers/vhost/vhost.c b/drivers/vhost/vhost.c
> index 1787d426a956..b5229ae01d3b 100644
> --- a/drivers/vhost/vhost.c
> +++ b/drivers/vhost/vhost.c
> @@ -333,9 +333,7 @@ static int vhost_worker(void *data)
>  	struct vhost_dev *dev = data;
>  	struct vhost_work *work, *work_next;
>  	struct llist_node *node;
> -	mm_segment_t oldfs = get_fs();
>  
> -	set_fs(USER_DS);
>  	kthread_use_mm(dev->mm);
>  
>  	for (;;) {
> @@ -365,7 +363,6 @@ static int vhost_worker(void *data)
>  		}
>  	}
>  	kthread_unuse_mm(dev->mm);
> -	set_fs(oldfs);
>  	return 0;
>  }
>  
> diff --git a/fs/io-wq.c b/fs/io-wq.c
> index 83c2868eff2a..75cc2f31816d 100644
> --- a/fs/io-wq.c
> +++ b/fs/io-wq.c
> @@ -168,7 +168,6 @@ static bool __io_worker_unuse(struct io_wqe *wqe, struct io_worker *worker)
>  			dropped_lock = true;
>  		}
>  		__set_current_state(TASK_RUNNING);
> -		set_fs(KERNEL_DS);
>  		kthread_unuse_mm(worker->mm);
>  		mmput(worker->mm);
>  		worker->mm = NULL;
> @@ -420,14 +419,11 @@ static void io_wq_switch_mm(struct io_worker *worker, struct io_wq_work *work)
>  		mmput(worker->mm);
>  		worker->mm = NULL;
>  	}
> -	if (!work->mm) {
> -		set_fs(KERNEL_DS);
> +	if (!work->mm)
>  		return;
> -	}
> +
>  	if (mmget_not_zero(work->mm)) {
>  		kthread_use_mm(work->mm);
> -		if (!worker->mm)
> -			set_fs(USER_DS);
>  		worker->mm = work->mm;
>  		/* hang on to this mm */
>  		work->mm = NULL;
> diff --git a/fs/io_uring.c b/fs/io_uring.c
> index 367406381044..c332a34e8b34 100644
> --- a/fs/io_uring.c
> +++ b/fs/io_uring.c
> @@ -5871,15 +5871,12 @@ static int io_sq_thread(void *data)
>  	struct io_ring_ctx *ctx = data;
>  	struct mm_struct *cur_mm = NULL;
>  	const struct cred *old_cred;
> -	mm_segment_t old_fs;
>  	DEFINE_WAIT(wait);
>  	unsigned long timeout;
>  	int ret = 0;
>  
>  	complete(&ctx->completions[1]);
>  
> -	old_fs = get_fs();
> -	set_fs(USER_DS);
>  	old_cred = override_creds(ctx->creds);
>  
>  	timeout = jiffies + ctx->sq_thread_idle;
> @@ -5985,7 +5982,6 @@ static int io_sq_thread(void *data)
>  	if (current->task_works)
>  		task_work_run();
>  
> -	set_fs(old_fs);
>  	if (cur_mm) {
>  		kthread_unuse_mm(cur_mm);
>  		mmput(cur_mm);
> diff --git a/kernel/kthread.c b/kernel/kthread.c
> index 316db17f6b4f..9e27d01b6d78 100644
> --- a/kernel/kthread.c
> +++ b/kernel/kthread.c
> @@ -52,6 +52,7 @@ struct kthread {
>  	unsigned long flags;
>  	unsigned int cpu;
>  	void *data;
> +	mm_segment_t oldfs;
>  	struct completion parked;
>  	struct completion exited;
>  #ifdef CONFIG_BLK_CGROUP
> @@ -1235,6 +1236,9 @@ void kthread_use_mm(struct mm_struct *mm)
>  
>  	if (active_mm != mm)
>  		mmdrop(active_mm);
> +
> +	to_kthread(tsk)->oldfs = get_fs();
> +	set_fs(USER_DS);
>  }
>  EXPORT_SYMBOL_GPL(kthread_use_mm);
>  
> @@ -1249,6 +1253,8 @@ void kthread_unuse_mm(struct mm_struct *mm)
>  	WARN_ON_ONCE(!(tsk->flags & PF_KTHREAD));
>  	WARN_ON_ONCE(!tsk->mm);
>  
> +	set_fs(to_kthread(tsk)->oldfs);
> +
>  	task_lock(tsk);
>  	sync_mm_rss(mm);
>  	tsk->mm = NULL;
> -- 
> 2.25.1

