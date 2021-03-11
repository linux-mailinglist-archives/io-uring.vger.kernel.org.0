Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BA51633788A
	for <lists+io-uring@lfdr.de>; Thu, 11 Mar 2021 16:55:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234045AbhCKPzG (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 11 Mar 2021 10:55:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49592 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234101AbhCKPym (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 11 Mar 2021 10:54:42 -0500
Received: from hr2.samba.org (hr2.samba.org [IPv6:2a01:4f8:192:486::2:0])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DF001C061574
        for <io-uring@vger.kernel.org>; Thu, 11 Mar 2021 07:54:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=samba.org;
         s=42; h=Date:Message-ID:From:To:CC;
        bh=CSgKdC12rFQ0ByZuRrrfksni9jgie8a5ZWYj2BGwwW8=; b=Co9ht19FjNh6Wq9NeSPR/9Zdxi
        wSVaXWG6njyWniQ5X/RUVMqNyX/8WGpEoRzuzn2CR/SzonHUyOsyMdJUe9vBli2fN2pkyKSWWJOUh
        hRAweSoDQh0ga6Ajf7xrKOqIIofa9rm6y6zRg39i0+76amFizGiZW3mavJhvA0NB/rN9MWKk6reTO
        u4NRWASNQiMCfPW74rzReDVltZwrAI26tYKsDAosjnRqN8wVDZIgFC4AQJ8b7x8HfU/OStyefLVsZ
        v8W7IwjDMWJK4ZkFpIeh0r2NhtGgcEJCjv3fYHpkRsOSxyDjF7DmLsg0Akp8/9ZcTgubpOChxYx+T
        EOnX+MwWWGIyCze4uEF0sceOsV4RKL9z/Mv7ZwTGz8NrY1BHCG2a6o/rPVrBOon+JT6n1m62RRYrQ
        d5h+YJEYoDz/KrILzVgWo8Zf5W120TnwtlWg8iPYxVOswMBZO52jXml0EnM8XMJ2CzKhNYykTHO4/
        MImAerub6cKWV49YSSKqBHNH;
Received: from [127.0.0.2] (localhost [127.0.0.1])
        by hr2.samba.org with esmtpsa (TLS1.3:ECDHE_RSA_CHACHA20_POLY1305:256)
        (Exim)
        id 1lKNe3-0005Ap-I7; Thu, 11 Mar 2021 15:54:39 +0000
Subject: Re: IORING_SETUP_ATTACH_WQ (was Re: [PATCH 1/3] io_uring: fix invalid
 ctx->sq_thread_idle)
To:     Jens Axboe <axboe@kernel.dk>,
        Pavel Begunkov <asml.silence@gmail.com>,
        io-uring@vger.kernel.org
References: <cover.1615381765.git.asml.silence@gmail.com>
 <fd8edef7aecde8d776d703350b3f6c0ec3154ed3.1615381765.git.asml.silence@gmail.com>
 <a25f115b-830c-e0f6-6d61-ff171412ea8b@samba.org>
 <b5fe7af7-3948-67ae-e716-2d2d3d985191@gmail.com>
 <5efea46e-8dce-3d6b-99e4-9ee9a111d8a6@samba.org>
 <470c84a6-70bf-be9e-ab38-5fa357299749@gmail.com>
 <a2583c0d-5fae-094c-7768-f37477b0559d@samba.org>
 <d954c7df-ef25-038e-9ef5-9b5dcbd4b14a@kernel.dk>
 <a677fc5d-aa83-163c-0701-41a65cd084f8@kernel.dk>
From:   Stefan Metzmacher <metze@samba.org>
Message-ID: <966ed604-8bd5-3dfb-28cb-81b2ca7e8bdd@samba.org>
Date:   Thu, 11 Mar 2021 16:54:39 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.1
MIME-Version: 1.0
In-Reply-To: <a677fc5d-aa83-163c-0701-41a65cd084f8@kernel.dk>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Hi Jens,

> diff --git a/fs/io_uring.c b/fs/io_uring.c
> index 6c62a3c95c1a..9a732b3b39fa 100644
> --- a/fs/io_uring.c
> +++ b/fs/io_uring.c
> @@ -269,6 +269,7 @@ struct io_sq_data {
>  	unsigned		sq_thread_idle;
>  	int			sq_cpu;
>  	pid_t			task_pid;
> +	pid_t			task_tgid;
>  
>  	unsigned long		state;
>  	struct completion	startup;
> @@ -7081,6 +7082,10 @@ static struct io_sq_data *io_attach_sq_data(struct io_uring_params *p)
>  		fdput(f);
>  		return ERR_PTR(-EINVAL);
>  	}
> +	if (sqd->task_tgid != current->tgid) {
> +		fdput(f);
> +		return ERR_PTR(-EPERM);
> +	}
>  
>  	refcount_inc(&sqd->refs);
>  	fdput(f);
> @@ -7091,8 +7096,14 @@ static struct io_sq_data *io_get_sq_data(struct io_uring_params *p)
>  {
>  	struct io_sq_data *sqd;
>  
> -	if (p->flags & IORING_SETUP_ATTACH_WQ)
> -		return io_attach_sq_data(p);
> +	if (p->flags & IORING_SETUP_ATTACH_WQ) {
> +		sqd = io_attach_sq_data(p);
> +		if (!IS_ERR(sqd))
> +			return sqd;
> +		/* fall through for EPERM case, setup new sqd/task */
> +		if (PTR_ERR(sqd) != -EPERM)
> +			return sqd;
> +	}
>  
>  	sqd = kzalloc(sizeof(*sqd), GFP_KERNEL);
>  	if (!sqd)
> @@ -7793,6 +7804,7 @@ static int io_sq_offload_create(struct io_ring_ctx *ctx,
>  		}
>  
>  		sqd->task_pid = current->pid;
> +		sqd->task_tgid = current->tgid;
>  		tsk = create_io_thread(io_sq_thread, sqd, NUMA_NO_NODE);
>  		if (IS_ERR(tsk)) {
>  			ret = PTR_ERR(tsk);
> 

Ok, that looks nice and simple, thanks!

metze
