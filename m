Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7CFF868026A
	for <lists+io-uring@lfdr.de>; Sun, 29 Jan 2023 23:57:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234924AbjA2W5u (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sun, 29 Jan 2023 17:57:50 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48914 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229476AbjA2W5t (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sun, 29 Jan 2023 17:57:49 -0500
Received: from mail-pj1-x102b.google.com (mail-pj1-x102b.google.com [IPv6:2607:f8b0:4864:20::102b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4BE835FC2
        for <io-uring@vger.kernel.org>; Sun, 29 Jan 2023 14:57:48 -0800 (PST)
Received: by mail-pj1-x102b.google.com with SMTP id v6-20020a17090ad58600b00229eec90a7fso12277032pju.0
        for <io-uring@vger.kernel.org>; Sun, 29 Jan 2023 14:57:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=BC9YAcXkfpkz9VFr/Yma3HTTZtxQEDop3sVKj7JNYR8=;
        b=Jw6Bnwsb36D1+MVCBQ8BjOzyVyvvzusRpLq72VLfkZdne2a0z35mq4wMKkcROzaL5W
         J07nPos82bIwhPAW1GjTb4chZBUpKvX608XVzSsp2n0SYahaygMJYA0V1HcLD5fScRPR
         D8LuYSfeU7++8qWKcpTOWfWlChtZrt2BCF7Z6UPxCbmOQa6CyWSlSkc0f1GYlt8bbXfa
         Yv1mJjv68zzptN6zSn59K5TkWXprOUmego9ASzfbInUcEgE4sqIPbvVQKV6OAyCLddl2
         EWZT8BTXXoNa185HsCA6psfylN4rQXHlzvYujDM7zaGQfCESsJbBUpnW7siEtiKM7RoF
         w/2A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=BC9YAcXkfpkz9VFr/Yma3HTTZtxQEDop3sVKj7JNYR8=;
        b=N1CxKHknnRvU9u1mF1AWH8QopiQRUWbLXqqEudQvzSo7trZXZEIEHRDmrUNHmPbkI3
         sOgF5/iVXCNJIRRfvl3ZKy8bY0ojW524MNSRpmAeWaBfNs/6QLwcn3+fHXfNfWkfX3wH
         ZdffqUKYzhtAGxr9tFZ4qx3dZMyNYvH46MV2bCfKmpb+WFrkcCkYi0vGzrMppGt/n0Kk
         LCOqNz9fOq+k3SeqSXXtYH35YMkVDZB3VwQ+HilPN6BAgaxNuqeV++qfoEOqkv8XLOxw
         89/5c5p0DRCg2lblCYONbSR8Z4uf1XTm1NpcmwgzEjH+YvjGHD9seiuRyFl36ZIT37KK
         tRSQ==
X-Gm-Message-State: AO0yUKWJloWVduZ0c6gXDE35H+CdQSXYm+XaDT/cucPKpMjYZsvCOSca
        dDe9J/IlzxMbBBjgDgDTT0nt4nqsy+Mi/QdM
X-Google-Smtp-Source: AK7set8JESeiMdQzmVWo5n39Z6xdMtMRvePo+t+jWXREcZkq//MhykubzOpbmKdJu/99iD08c5WoWg==
X-Received: by 2002:a17:902:ce8c:b0:196:82d5:1ec4 with SMTP id f12-20020a170902ce8c00b0019682d51ec4mr502803plg.0.1675033067691;
        Sun, 29 Jan 2023 14:57:47 -0800 (PST)
Received: from [192.168.1.136] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id a14-20020a170902ecce00b00195f097bc98sm6365892plh.83.2023.01.29.14.57.46
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 29 Jan 2023 14:57:47 -0800 (PST)
Message-ID: <297ad988-9537-c953-d49a-8b891204b0f0@kernel.dk>
Date:   Sun, 29 Jan 2023 15:57:46 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux aarch64; rv:102.0) Gecko/20100101
 Thunderbird/102.6.0
Subject: Re: [PATCH for-next 1/4] io_uring: if a linked request has
 REQ_F_FORCE_ASYNC then run it async
Content-Language: en-US
To:     Dylan Yudaken <dylany@meta.com>,
        Pavel Begunkov <asml.silence@gmail.com>
Cc:     io-uring@vger.kernel.org, kernel-team@fb.com
References: <20230127135227.3646353-1-dylany@meta.com>
 <20230127135227.3646353-2-dylany@meta.com>
From:   Jens Axboe <axboe@kernel.dk>
In-Reply-To: <20230127135227.3646353-2-dylany@meta.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=1.3 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,RCVD_IN_SBL_CSS,
        SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.6
X-Spam-Level: *
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 1/27/23 6:52?AM, Dylan Yudaken wrote:
> REQ_F_FORCE_ASYNC was being ignored for re-queueing linked
> requests. Instead obey that flag.
> 
> Signed-off-by: Dylan Yudaken <dylany@meta.com>
> ---
>  io_uring/io_uring.c | 8 +++++---
>  1 file changed, 5 insertions(+), 3 deletions(-)
> 
> diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
> index db623b3185c8..980ba4fda101 100644
> --- a/io_uring/io_uring.c
> +++ b/io_uring/io_uring.c
> @@ -1365,10 +1365,12 @@ void io_req_task_submit(struct io_kiocb *req, bool *locked)
>  {
>  	io_tw_lock(req->ctx, locked);
>  	/* req->task == current here, checking PF_EXITING is safe */
> -	if (likely(!(req->task->flags & PF_EXITING)))
> -		io_queue_sqe(req);
> -	else
> +	if (unlikely(req->task->flags & PF_EXITING))
>  		io_req_defer_failed(req, -EFAULT);
> +	else if (req->flags & REQ_F_FORCE_ASYNC)
> +		io_queue_iowq(req, locked);
> +	else
> +		io_queue_sqe(req);
>  }
>  
>  void io_req_task_queue_fail(struct io_kiocb *req, int ret)

This one causes a failure for me with test/multicqes_drain.t, which
doesn't quite make sense to me (just yet), but it is a reliable timeout.

-- 
Jens Axboe

