Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1E05C241BF0
	for <lists+io-uring@lfdr.de>; Tue, 11 Aug 2020 16:00:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728677AbgHKOAZ (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 11 Aug 2020 10:00:25 -0400
Received: from us-smtp-2.mimecast.com ([205.139.110.61]:55055 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1728638AbgHKOAW (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 11 Aug 2020 10:00:22 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1597154420;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=P6YtH2/Jh7TinlxZts+K+ir2wkwOlY8OCnZ6CDUlQwA=;
        b=YQtm+IjMpufyZxt8xE1SvmSBUxWiARc+Mc5brOhtqiKZwN98LOfETAklo1zvIQK/eV7SY4
        jVoP4wwfCIS/FO31JSL3EDuTI0vtSX/TgSFekYjPypsQcGUD5rYeSvHU+nHg7poFnaIpq3
        jMpINO4p0i26gY7wwWSv7zNZJjb0U24=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-290-RyJz0wNTNqicbDJZ_-jgbw-1; Tue, 11 Aug 2020 10:00:16 -0400
X-MC-Unique: RyJz0wNTNqicbDJZ_-jgbw-1
Received: by mail-wm1-f69.google.com with SMTP id z10so837048wmi.8
        for <io-uring@vger.kernel.org>; Tue, 11 Aug 2020 07:00:16 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=P6YtH2/Jh7TinlxZts+K+ir2wkwOlY8OCnZ6CDUlQwA=;
        b=sPBI3TtAgqdHKdvKGhbdJ5w82WtT/+YxlJKZvCaOAQOsPbqDv3+0tLnsSZS1wsZU82
         340vTH2Asb5R+N1etIhW8pIPe2nwN2V7hZlg/vQ1mbm8oKK0MjoFtNxvlsNYkRDhkcCc
         uWxscEoX70QaNkQULemBjgLbxyeGXetAJG0FvYqsnAIfNvypYXv+vmy46y330WbE15eo
         5gxdXugiCtzTNNRlGihC6iGod04rsnyeBJoxlVPj+zi8GJi6G/fZfTkbajY4UyAzBcbY
         TuP7LklgFXyJLL+3BIlAy7Mr3UZxVMII9bGrt+8YAPkzKAO1ITnA1CtCgQ5nY9aMV1FR
         uujQ==
X-Gm-Message-State: AOAM533xk7nqMZgNtw9y+/pXw+vCy07fu5HAKCv/fhE1TjzQ76xIUhyn
        BXP3iK7FEnOycKuTa/y57rEVO2u34Za7ODW7jkd71nBiTL5kvGc9fI029Go/HZ72TZwXE4PoeRw
        G6vACycvtlbwie54oOrg=
X-Received: by 2002:a5d:5086:: with SMTP id a6mr29414977wrt.304.1597154414565;
        Tue, 11 Aug 2020 07:00:14 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwqO2qHTgVwuBQGD53fudeRY6iEmnwXD+kDn7EAgcSziwa8C1tq0azTtZCgq//cCqL55TTirg==
X-Received: by 2002:a5d:5086:: with SMTP id a6mr29414943wrt.304.1597154414296;
        Tue, 11 Aug 2020 07:00:14 -0700 (PDT)
Received: from steredhat ([5.171.229.81])
        by smtp.gmail.com with ESMTPSA id n24sm5388641wmi.36.2020.08.11.07.00.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 11 Aug 2020 07:00:13 -0700 (PDT)
Date:   Tue, 11 Aug 2020 16:00:10 +0200
From:   Stefano Garzarella <sgarzare@redhat.com>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     syzbot <syzbot+996f91b6ec3812c48042@syzkaller.appspotmail.com>,
        io-uring@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, syzkaller-bugs@googlegroups.com,
        viro@zeniv.linux.org.uk
Subject: Re: possible deadlock in __io_queue_deferred
Message-ID: <20200811140010.gigc2amchytqmrkk@steredhat>
References: <00000000000035fdf505ac87b7f9@google.com>
 <76cc7c43-2ebb-180d-c2c8-912972a3f258@kernel.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <76cc7c43-2ebb-180d-c2c8-912972a3f258@kernel.dk>
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Mon, Aug 10, 2020 at 09:55:17AM -0600, Jens Axboe wrote:
> On 8/10/20 9:36 AM, syzbot wrote:
> > Hello,
> > 
> > syzbot found the following issue on:
> > 
> > HEAD commit:    449dc8c9 Merge tag 'for-v5.9' of git://git.kernel.org/pub/..
> > git tree:       upstream
> > console output: https://syzkaller.appspot.com/x/log.txt?x=14d41e02900000
> > kernel config:  https://syzkaller.appspot.com/x/.config?x=9d25235bf0162fbc
> > dashboard link: https://syzkaller.appspot.com/bug?extid=996f91b6ec3812c48042
> > compiler:       clang version 10.0.0 (https://github.com/llvm/llvm-project/ c2443155a0fb245c8f17f2c1c72b6ea391e86e81)
> > syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=133c9006900000
> > C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=1191cb1a900000
> > 
> > IMPORTANT: if you fix the issue, please add the following tag to the commit:
> > Reported-by: syzbot+996f91b6ec3812c48042@syzkaller.appspotmail.com
> 
> Thanks, the below should fix this one.

Yeah, it seems right to me, since only __io_queue_deferred() (invoked by
io_commit_cqring()) can be called with 'completion_lock' held.

Just out of curiosity, while exploring the code I noticed that we call
io_commit_cqring() always with the 'completion_lock' held, except in the
io_poll_* functions.

That's because then there can't be any concurrency?

Thanks,
Stefano

> 
> 
> diff --git a/fs/io_uring.c b/fs/io_uring.c
> index 443eecdfeda9..f9be665d1c5e 100644
> --- a/fs/io_uring.c
> +++ b/fs/io_uring.c
> @@ -898,6 +898,7 @@ static void io_put_req(struct io_kiocb *req);
>  static void io_double_put_req(struct io_kiocb *req);
>  static void __io_double_put_req(struct io_kiocb *req);
>  static struct io_kiocb *io_prep_linked_timeout(struct io_kiocb *req);
> +static void __io_queue_linked_timeout(struct io_kiocb *req);
>  static void io_queue_linked_timeout(struct io_kiocb *req);
>  static int __io_sqe_files_update(struct io_ring_ctx *ctx,
>  				 struct io_uring_files_update *ip,
> @@ -1179,7 +1180,7 @@ static void io_prep_async_link(struct io_kiocb *req)
>  			io_prep_async_work(cur);
>  }
>  
> -static void __io_queue_async_work(struct io_kiocb *req)
> +static struct io_kiocb *__io_queue_async_work(struct io_kiocb *req)
>  {
>  	struct io_ring_ctx *ctx = req->ctx;
>  	struct io_kiocb *link = io_prep_linked_timeout(req);
> @@ -1187,16 +1188,19 @@ static void __io_queue_async_work(struct io_kiocb *req)
>  	trace_io_uring_queue_async_work(ctx, io_wq_is_hashed(&req->work), req,
>  					&req->work, req->flags);
>  	io_wq_enqueue(ctx->io_wq, &req->work);
> -
> -	if (link)
> -		io_queue_linked_timeout(link);
> +	return link;
>  }
>  
>  static void io_queue_async_work(struct io_kiocb *req)
>  {
> +	struct io_kiocb *link;
> +
>  	/* init ->work of the whole link before punting */
>  	io_prep_async_link(req);
> -	__io_queue_async_work(req);
> +	link = __io_queue_async_work(req);
> +
> +	if (link)
> +		io_queue_linked_timeout(link);
>  }
>  
>  static void io_kill_timeout(struct io_kiocb *req)
> @@ -1229,12 +1233,19 @@ static void __io_queue_deferred(struct io_ring_ctx *ctx)
>  	do {
>  		struct io_defer_entry *de = list_first_entry(&ctx->defer_list,
>  						struct io_defer_entry, list);
> +		struct io_kiocb *link;
>  
>  		if (req_need_defer(de->req, de->seq))
>  			break;
>  		list_del_init(&de->list);
>  		/* punt-init is done before queueing for defer */
> -		__io_queue_async_work(de->req);
> +		link = __io_queue_async_work(de->req);
> +		if (link) {
> +			__io_queue_linked_timeout(link);
> +			/* drop submission reference */
> +			link->flags |= REQ_F_COMP_LOCKED;
> +			io_put_req(link);
> +		}
>  		kfree(de);
>  	} while (!list_empty(&ctx->defer_list));
>  }
> @@ -5945,15 +5956,12 @@ static enum hrtimer_restart io_link_timeout_fn(struct hrtimer *timer)
>  	return HRTIMER_NORESTART;
>  }
>  
> -static void io_queue_linked_timeout(struct io_kiocb *req)
> +static void __io_queue_linked_timeout(struct io_kiocb *req)
>  {
> -	struct io_ring_ctx *ctx = req->ctx;
> -
>  	/*
>  	 * If the list is now empty, then our linked request finished before
>  	 * we got a chance to setup the timer
>  	 */
> -	spin_lock_irq(&ctx->completion_lock);
>  	if (!list_empty(&req->link_list)) {
>  		struct io_timeout_data *data = &req->io->timeout;
>  
> @@ -5961,6 +5969,14 @@ static void io_queue_linked_timeout(struct io_kiocb *req)
>  		hrtimer_start(&data->timer, timespec64_to_ktime(data->ts),
>  				data->mode);
>  	}
> +}
> +
> +static void io_queue_linked_timeout(struct io_kiocb *req)
> +{
> +	struct io_ring_ctx *ctx = req->ctx;
> +
> +	spin_lock_irq(&ctx->completion_lock);
> +	__io_queue_linked_timeout(req);
>  	spin_unlock_irq(&ctx->completion_lock);
>  
>  	/* drop submission reference */
> 
> -- 
> Jens Axboe
> 

