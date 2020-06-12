Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DE0261F7D77
	for <lists+io-uring@lfdr.de>; Fri, 12 Jun 2020 21:20:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726384AbgFLTUd (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 12 Jun 2020 15:20:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44374 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726376AbgFLTUc (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 12 Jun 2020 15:20:32 -0400
Received: from mail-wr1-x441.google.com (mail-wr1-x441.google.com [IPv6:2a00:1450:4864:20::441])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C4E79C03E96F;
        Fri, 12 Jun 2020 12:20:31 -0700 (PDT)
Received: by mail-wr1-x441.google.com with SMTP id x14so10909165wrp.2;
        Fri, 12 Jun 2020 12:20:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=to:cc:references:from:autocrypt:subject:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=LuXcbBtMwnamBPCkX1sG4sng+tF/heSnrzHbTXFtj4s=;
        b=DsUa9RpV8L9CWdpiI+BPNTZXCePK54aFjub3ZKf2TOJchFwa9NIQGSb4JXdScKTrMk
         wjSwX+aoHiSrnvefxcN2UwsXmokYoj0xkPpbxs5rODMHjF9Z0+cgNs5LXqYWTI33NwAg
         NWDJSLVArr40a9ocogLX/KXzbHv6IML1V01voQM5iR8fB5LhW4Q0MbN9kfMBz4ipcUVv
         UT3QzwczIXoLeLXhW7/r8PRleQmlRBubOL0aXyBdaGHDLM2JlNow6dliuD1+Azr3dM4R
         xf4lmpRqobpOn6lYjF84tfLYVrRUjzpIFY6sEyO+GF690soLIoz9qUtqy6kqsGsV4tI5
         rFuA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:to:cc:references:from:autocrypt:subject
         :message-id:date:user-agent:mime-version:in-reply-to
         :content-language:content-transfer-encoding;
        bh=LuXcbBtMwnamBPCkX1sG4sng+tF/heSnrzHbTXFtj4s=;
        b=rWOP1l5iisHaatoiixa2vrlbLW6u8YMp5qoqle2WAEWlw9IHCkILmlmYEahj+2LNuY
         9Ab5Vf361a+OH4t7JsYxXnJXgzt8fh7lwpDaTIbO72gWgOaTi6rZAPtZR425bB95Ae/b
         OqmKWFH/4pGQZ7VJd2Q7hF1eXnvZAfBGUkcp3fdHrg/CpSrqW3fP4KO7Q3BW5C2ARd5h
         QuJ0snP+LMlDHn0dEQVCzD8OfJF07Panl9rLPokS6ywp56VZ9ukzKPcvQBVgK/dndif9
         NlWacbN5qAkHMiAMUog0qgtfOdaFYPbKa6+65WliKdGuZG3HhELgJJ/kF6V2bTBsPof7
         mo7w==
X-Gm-Message-State: AOAM531rW8BS8wbI66TD/7hqmeJEp45qNvTT2wEMSJ1OWGZv8v/yjhga
        c0xFPlJUtEfTEaDGlxPmGz9CImEs
X-Google-Smtp-Source: ABdhPJwv7pPerDrvRvRngvNqO7wz80usFRNkJwzS7W+COM5DR8YBEBuRwZ1OWHPx2+vIVGjUl6TQsg==
X-Received: by 2002:a1c:b703:: with SMTP id h3mr385091wmf.81.1591989629779;
        Fri, 12 Jun 2020 12:20:29 -0700 (PDT)
Received: from [192.168.43.114] ([5.100.193.151])
        by smtp.gmail.com with ESMTPSA id e12sm11581250wro.52.2020.06.12.12.20.27
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 12 Jun 2020 12:20:28 -0700 (PDT)
To:     "Eric W. Biederman" <ebiederm@xmission.com>,
        Jens Axboe <axboe@kernel.dk>
Cc:     linux-kernel@vger.kernel.org, io-uring@vger.kernel.org
References: <87a71jjbzr.fsf@x220.int.ebiederm.org>
From:   Pavel Begunkov <asml.silence@gmail.com>
Autocrypt: addr=asml.silence@gmail.com; prefer-encrypt=mutual; keydata=
 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 bA==
Subject: Re: io_wq_work task_pid is nonsense
Message-ID: <ffe050b6-d444-30d9-d701-b61f561118ac@gmail.com>
Date:   Fri, 12 Jun 2020 22:19:05 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.3.0
MIME-Version: 1.0
In-Reply-To: <87a71jjbzr.fsf@x220.int.ebiederm.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 04/06/2020 14:39, Eric W. Biederman wrote:
> I was looking at something else and I happened to come across the
> task_pid field in struct io_wq_work.  The field is initialized with
> task_pid_vnr.  Then it is used for cancelling pending work.
> 
> The only appropriate and safe use of task_pid_vnr is for sending
> a pid value to userspace and that is not what is going on here.
> 
> This use is particularly bad as it looks like I can start a pid
> namespace create an io work queue and create threads that happen to have
> the userspace pid in question and then terminate them, or close their
> io_work_queue file descriptors, and wind up closing someone else's work.
> 
> There is also pid wrap around, and the craziness of de_thread to contend
> with as well.

Thanks reporting about this. It's not as bad because it's limited to a
single io_uring instance and is more like precautions. False positives
should be handled in userspace.

> Perhaps since all the task_pid field is used for is cancelling work for
> an individual task you could do something like the patch below.  I am
> assuming no reference counting is necessary as the field can not live
> past the life of a task.
> 
> Of cource the fact that you don't perform this work for file descriptors
> that are closed just before a task exits makes me wonder.
> 
> Can you please fix this code up to do something sensible?
> Maybe like below?

I'll deal with it. Needs a bit extra to not screw work->task refcounting,
but the idea looks right.

> 
> Eric
> 
> diff --git a/fs/io-wq.h b/fs/io-wq.h
> index 5ba12de7572f..bef29fff7403 100644
> --- a/fs/io-wq.h
> +++ b/fs/io-wq.h
> @@ -91,7 +91,7 @@ struct io_wq_work {
>  	const struct cred *creds;
>  	struct fs_struct *fs;
>  	unsigned flags;
> -	pid_t task_pid;
> +	struct task_struct *task;
>  };
>  
>  #define INIT_IO_WORK(work, _func)				\
> @@ -129,7 +129,7 @@ static inline bool io_wq_is_hashed(struct io_wq_work *work)
>  
>  void io_wq_cancel_all(struct io_wq *wq);
>  enum io_wq_cancel io_wq_cancel_work(struct io_wq *wq, struct io_wq_work *cwork);
> -enum io_wq_cancel io_wq_cancel_pid(struct io_wq *wq, pid_t pid);
> +enum io_wq_cancel io_wq_cancel_task(struct io_wq *wq, struct task_struct *task);
>  
>  typedef bool (work_cancel_fn)(struct io_wq_work *, void *);
>  
> diff --git a/fs/io-wq.c b/fs/io-wq.c
> index 4023c9846860..2139a049d548 100644
> --- a/fs/io-wq.c
> +++ b/fs/io-wq.c
> @@ -1004,18 +1004,16 @@ enum io_wq_cancel io_wq_cancel_work(struct io_wq *wq, struct io_wq_work *cwork)
>  	return io_wq_cancel_cb(wq, io_wq_io_cb_cancel_data, (void *)cwork);
>  }
>  
> -static bool io_wq_pid_match(struct io_wq_work *work, void *data)
> +static bool io_wq_task_match(struct io_wq_work *work, void *data)
>  {
> -	pid_t pid = (pid_t) (unsigned long) data;
> +	struct task_struct *task = data;
>  
> -	return work->task_pid == pid;
> +	return work->task == task;
>  }
>  
> -enum io_wq_cancel io_wq_cancel_pid(struct io_wq *wq, pid_t pid)
> +enum io_wq_cancel io_wq_cancel_task(struct io_wq *wq, struct task_struct *task)
>  {
> -	void *data = (void *) (unsigned long) pid;
> -
> -	return io_wq_cancel_cb(wq, io_wq_pid_match, data);
> +	return io_wq_cancel_cb(wq, io_wq_task_match, task);
>  }
>  
>  struct io_wq *io_wq_create(unsigned bounded, struct io_wq_data *data)
> diff --git a/fs/io_uring.c b/fs/io_uring.c
> index c687f57fb651..b9d557a21a26 100644
> --- a/fs/io_uring.c
> +++ b/fs/io_uring.c
> @@ -1031,8 +1031,8 @@ static inline void io_req_work_grab_env(struct io_kiocb *req,
>  		}
>  		spin_unlock(&current->fs->lock);
>  	}
> -	if (!req->work.task_pid)
> -		req->work.task_pid = task_pid_vnr(current);
> +	if (!req->work.task)
> +		req->work.task = current;
>  }
>  
>  static inline void io_req_work_drop_env(struct io_kiocb *req)
> @@ -7421,7 +7421,7 @@ static int io_uring_flush(struct file *file, void *data)
>  	 * If the task is going away, cancel work it may have pending
>  	 */
>  	if (fatal_signal_pending(current) || (current->flags & PF_EXITING))
> -		io_wq_cancel_pid(ctx->io_wq, task_pid_vnr(current));
> +		io_wq_cancel_task(ctx->io_wq, current);
>  
>  	return 0;
>  }
> 

-- 
Pavel Begunkov
