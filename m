Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1C9CD3A7B1F
	for <lists+io-uring@lfdr.de>; Tue, 15 Jun 2021 11:49:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231152AbhFOJvQ (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 15 Jun 2021 05:51:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58606 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231380AbhFOJvP (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 15 Jun 2021 05:51:15 -0400
Received: from mail-wr1-x431.google.com (mail-wr1-x431.google.com [IPv6:2a00:1450:4864:20::431])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ECD16C061574;
        Tue, 15 Jun 2021 02:49:09 -0700 (PDT)
Received: by mail-wr1-x431.google.com with SMTP id n7so11420762wri.3;
        Tue, 15 Jun 2021 02:49:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:references:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=pAL4EuLMD0DuYLQrBykcyo4kWhq8f7TRYsP+eolynnY=;
        b=Q/1/VKPzKPctpoH2YwzL66txnJPSi8o24Wh+a7ByqDv0B9WKrZCebMN4NJIuJ9RknA
         yi1DEvsvuomjRIruH4mWmMHPTZais1CljIo2p+nzl3WTzMoKTZQXQC1+w8oO7qi7oCLr
         Ukkj5p1VDMuOjHrxCvB/yzmx2YLaFet7xaA1PbbI//YlU/xJLLaQP3wWTLeMQ2oJCu/8
         8FN0LByaOMqKQszGmSctFccmbFtjXCj19OnxldJ+Rjk/mUtUT/Kcbx4JaIw7pBfl6Xqd
         aQdXgNLEr3vIkmaVfGWcCWbLboYk0+CaWspmrkaGyrwS44lzSiQO3dimP39Wdr4tJLvX
         pJZA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=pAL4EuLMD0DuYLQrBykcyo4kWhq8f7TRYsP+eolynnY=;
        b=l09axVKwUwS1m/fuQRLR3yb9RaEhUn7t6/Io8qVcD7Cq9AyTCie2RUMD7s4qP8qhdl
         BdLg9tBzZan6qIlqNuSY9QB4ErMWZdMGr6l8lhhtw4rkvhA2dTTJcce1EB/CeIKCofwj
         gJJRCDgMLEbRo1Er/gg/JSabbwQhlMXLPDlN+da/HPm2MlsmsDSllEFxIaM1bZP3+3lT
         5nqtiv6DgsOGNmNvc95peaL8SeSLV0q84XIknpwAnA1W4WHHoYwLKg7pDzqgRSAyXgrB
         16kd+r2B9M1ZyUUccUPoOe94q5Rewq0IqiaB/9yrAOZzVfsAQcLR6VyVbIgyGFpVS3Mj
         pOjQ==
X-Gm-Message-State: AOAM531CYq9HnExdB4gmOpsPkmiayLP1E8Zgj5e9C8FeXuLrs5S1fa+f
        MvG5Oy6SNHBFKoog/9SZ9ksyA1H8pJTg9RPa
X-Google-Smtp-Source: ABdhPJzIh3zVVYQvIURH8QnEI+3xKpl4APbLw4T3zk7h3M8E5TZbL4XVhG9J2TVprtDt8ZWnUymmlA==
X-Received: by 2002:a5d:438a:: with SMTP id i10mr24150624wrq.82.1623750548352;
        Tue, 15 Jun 2021 02:49:08 -0700 (PDT)
Received: from [192.168.8.197] ([148.252.132.209])
        by smtp.gmail.com with ESMTPSA id o20sm1756419wms.3.2021.06.15.02.49.07
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 15 Jun 2021 02:49:07 -0700 (PDT)
Subject: Re: [PATCH v2 2/3] io_uring: minor clean up in trace events
 definition
To:     Olivier Langlois <olivier@trillion01.com>,
        Jens Axboe <axboe@kernel.dk>,
        Steven Rostedt <rostedt@goodmis.org>,
        Ingo Molnar <mingo@redhat.com>, io-uring@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <60be7e31.1c69fb81.a8bfb.2e54SMTPIN_ADDED_MISSING@mx.google.com>
From:   Pavel Begunkov <asml.silence@gmail.com>
Message-ID: <2752dcc1-9e56-ba31-54ea-d2363ecb6c93@gmail.com>
Date:   Tue, 15 Jun 2021 10:48:54 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.1
MIME-Version: 1.0
In-Reply-To: <60be7e31.1c69fb81.a8bfb.2e54SMTPIN_ADDED_MISSING@mx.google.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 5/31/21 7:54 AM, Olivier Langlois wrote:
> Fix tabulation to make nice columns

Reviewed-by: Pavel Begunkov <asml.silence@gmail.com>

> 
> Signed-off-by: Olivier Langlois <olivier@trillion01.com>
> ---
>  include/trace/events/io_uring.h | 35 ++++++++++++++++-----------------
>  1 file changed, 17 insertions(+), 18 deletions(-)
> 
> diff --git a/include/trace/events/io_uring.h b/include/trace/events/io_uring.h
> index 12addad1f837..e4e44a2b4aa9 100644
> --- a/include/trace/events/io_uring.h
> +++ b/include/trace/events/io_uring.h
> @@ -12,11 +12,11 @@ struct io_wq_work;
>  /**
>   * io_uring_create - called after a new io_uring context was prepared
>   *
> - * @fd:			corresponding file descriptor
> - * @ctx:		pointer to a ring context structure
> + * @fd:		corresponding file descriptor
> + * @ctx:	pointer to a ring context structure
>   * @sq_entries:	actual SQ size
>   * @cq_entries:	actual CQ size
> - * @flags:		SQ ring flags, provided to io_uring_setup(2)
> + * @flags:	SQ ring flags, provided to io_uring_setup(2)
>   *
>   * Allows to trace io_uring creation and provide pointer to a context, that can
>   * be used later to find correlated events.
> @@ -52,12 +52,12 @@ TRACE_EVENT(io_uring_create,
>   * io_uring_register - called after a buffer/file/eventfd was successfully
>   * 					   registered for a ring
>   *
> - * @ctx:			pointer to a ring context structure
> - * @opcode:			describes which operation to perform
> + * @ctx:		pointer to a ring context structure
> + * @opcode:		describes which operation to perform
>   * @nr_user_files:	number of registered files
>   * @nr_user_bufs:	number of registered buffers
>   * @cq_ev_fd:		whether eventfs registered or not
> - * @ret:			return code
> + * @ret:		return code
>   *
>   * Allows to trace fixed files/buffers/eventfds, that could be registered to
>   * avoid an overhead of getting references to them for every operation. This
> @@ -142,16 +142,16 @@ TRACE_EVENT(io_uring_queue_async_work,
>  	TP_ARGS(ctx, rw, req, work, flags),
>  
>  	TP_STRUCT__entry (
> -		__field(  void *,				ctx		)
> -		__field(  int,					rw		)
> -		__field(  void *,				req		)
> +		__field(  void *,			ctx	)
> +		__field(  int,				rw	)
> +		__field(  void *,			req	)
>  		__field(  struct io_wq_work *,		work	)
>  		__field(  unsigned int,			flags	)
>  	),
>  
>  	TP_fast_assign(
>  		__entry->ctx	= ctx;
> -		__entry->rw		= rw;
> +		__entry->rw	= rw;
>  		__entry->req	= req;
>  		__entry->work	= work;
>  		__entry->flags	= flags;
> @@ -196,10 +196,10 @@ TRACE_EVENT(io_uring_defer,
>  
>  /**
>   * io_uring_link - called before the io_uring request added into link_list of
> - * 				   another request
> + * 		   another request
>   *
> - * @ctx:			pointer to a ring context structure
> - * @req:			pointer to a linked request
> + * @ctx:		pointer to a ring context structure
> + * @req:		pointer to a linked request
>   * @target_req:		pointer to a previous request, that would contain @req
>   *
>   * Allows to track linked requests, to understand dependencies between requests
> @@ -212,8 +212,8 @@ TRACE_EVENT(io_uring_link,
>  	TP_ARGS(ctx, req, target_req),
>  
>  	TP_STRUCT__entry (
> -		__field(  void *,	ctx			)
> -		__field(  void *,	req			)
> +		__field(  void *,	ctx		)
> +		__field(  void *,	req		)
>  		__field(  void *,	target_req	)
>  	),
>  
> @@ -244,7 +244,7 @@ TRACE_EVENT(io_uring_cqring_wait,
>  	TP_ARGS(ctx, min_events),
>  
>  	TP_STRUCT__entry (
> -		__field(  void *,	ctx			)
> +		__field(  void *,	ctx		)
>  		__field(  int,		min_events	)
>  	),
>  
> @@ -272,7 +272,7 @@ TRACE_EVENT(io_uring_fail_link,
>  	TP_ARGS(req, link),
>  
>  	TP_STRUCT__entry (
> -		__field(  void *,	req		)
> +		__field(  void *,	req	)
>  		__field(  void *,	link	)
>  	),
>  
> @@ -318,7 +318,6 @@ TRACE_EVENT(io_uring_complete,
>  			  __entry->res, __entry->cflags)
>  );
>  
> -
>  /**
>   * io_uring_submit_sqe - called before submitting one SQE
>   *
> 

-- 
Pavel Begunkov
