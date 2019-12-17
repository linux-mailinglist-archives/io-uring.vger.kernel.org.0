Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 38E00122DBD
	for <lists+io-uring@lfdr.de>; Tue, 17 Dec 2019 14:58:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728539AbfLQN6c (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 17 Dec 2019 08:58:32 -0500
Received: from mail-wr1-f67.google.com ([209.85.221.67]:36398 "EHLO
        mail-wr1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728345AbfLQN6c (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 17 Dec 2019 08:58:32 -0500
Received: by mail-wr1-f67.google.com with SMTP id z3so3872170wru.3;
        Tue, 17 Dec 2019 05:58:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=THIo9+Njw2AjrCPqK5WUOyXgr+Ut9xXnH2Hdz6HGu/Q=;
        b=iREclmrUHnzVezvv+UEMvsy4Ds/03128d2oU76dT9jS4PRgwxPmLsodlsALIFH1se8
         4Vf0QgEC+iKEhlMyNkiEYm7pu6Toe9QnCxZAVfXZYhy61alyMBcCji6Xr3qxLT5nd+2s
         j4WC1S//1X/IPF09eDUYw6jWuF2tVbRQYfcRzQ6LWTKlKp/elleACcGU+a/8f5cvDeW/
         McwTRUfjy2OZrb6OQ6+ERHnMp/k1CzeILhe+//7WML0hYRfcfh6pgv7t0K1yyFHYqY0E
         x/3G7CP0ksE1AMbZkGxlAX907SWzNn7W/Qy78GW1GGKlz0Gscd+Uo8d+lKKtTeO+IJvu
         UQug==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=THIo9+Njw2AjrCPqK5WUOyXgr+Ut9xXnH2Hdz6HGu/Q=;
        b=DTjI2JsnHvi4dJXbWi/u7CR2OC5aquw5gAKWxrK5e80FwzqE4a7CpVUEZ/WH0jCW1U
         oRCEIH8ZIXKy0s7LVN0z82OMIdJ1PVJN6eBCkB1+tSG3qeIAh2gSxV39RhkH6AK87o9d
         4z15ofaAY8sbF7Vx95tiCcABPetdkKrnvXzyK1SjFF6EokO9v3Ub8SVaBM+yHf55FdvJ
         16GI3r5ROnuq/oaiw88xdTgyv1Fg74GFthuubA66e2CUk7UF01tjijS9A1Hbeu4j6q5E
         YwkumXh6dcbQLqKyE8smUW9XIYEiOG9eNdtJC6Udwb9ZrHC5pKiuHPt9CIGxqV2R4j3A
         Lvcg==
X-Gm-Message-State: APjAAAVP4JyQnzX+CW2LzuGkVCQqRWJP3bYcTi3BqWYg1YmJIjYip7IA
        z18TnWtaFZZ2PNYA8eZ60S0=
X-Google-Smtp-Source: APXvYqxwbzUOvuz0ARMygmrZLqxEyZcyyT8nPw+81ozxGV30TcNmk5KwGqg5QrdwtrQFXV7x/DASdw==
X-Received: by 2002:adf:f606:: with SMTP id t6mr35770657wrp.85.1576591110424;
        Tue, 17 Dec 2019 05:58:30 -0800 (PST)
Received: from localhost ([185.85.220.194])
        by smtp.gmail.com with ESMTPSA id a1sm3007098wmj.40.2019.12.17.05.58.29
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 17 Dec 2019 05:58:29 -0800 (PST)
Date:   Tue, 17 Dec 2019 15:00:57 +0100
From:   Dmitry Dolgov <9erthalion6@gmail.com>
To:     Pavel Begunkov <asml.silence@gmail.com>
Cc:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/3] io_uring: move *queue_link_head() from common path
Message-ID: <20191217140057.vswyslavkmrbcebz@localhost>
References: <cover.1576538176.git.asml.silence@gmail.com>
 <eda17f0736faff0876c580f1cd841b61c92d7e39.1576538176.git.asml.silence@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <eda17f0736faff0876c580f1cd841b61c92d7e39.1576538176.git.asml.silence@gmail.com>
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

> On Tue, Dec 17, 2019 at 02:22:09AM +0300, Pavel Begunkov wrote:
>
> Move io_queue_link_head() to links handling code in io_submit_sqe(),
> so it wouldn't need extra checks and would have better data locality.
>
> ---
>  fs/io_uring.c | 32 ++++++++++++++------------------
>  1 file changed, 14 insertions(+), 18 deletions(-)
>
> diff --git a/fs/io_uring.c b/fs/io_uring.c
> index bac9e711e38d..a880ed1409cb 100644
> --- a/fs/io_uring.c
> +++ b/fs/io_uring.c
> @@ -3373,13 +3373,15 @@ static bool io_submit_sqe(struct io_kiocb *req, struct io_submit_state *state,
>  			  struct io_kiocb **link)
>  {
>  	struct io_ring_ctx *ctx = req->ctx;
> +	unsigned int sqe_flags;
>  	int ret;
>
> +	sqe_flags = READ_ONCE(req->sqe->flags);

Just out of curiosity, why READ_ONCE it necessary here? I though, that
since io_submit_sqes happens within a uring_lock, it's already
protected. Do I miss something?

> @@ -3421,9 +3423,15 @@ static bool io_submit_sqe(struct io_kiocb *req, struct io_submit_state *state,
>  		}
>  		trace_io_uring_link(ctx, req, head);
>  		list_add_tail(&req->link_list, &head->link_list);
> -	} else if (req->sqe->flags & (IOSQE_IO_LINK|IOSQE_IO_HARDLINK)) {
> +
> +		/* last request of a link, enqueue the link */
> +		if (!(sqe_flags & IOSQE_IO_LINK)) {

Yes, as you mentioned in the previous email, it seems correct that if
IOSQE_IO_HARDLINK imply IOSQE_IO_LINK, then here we need to check both.

> +			io_queue_link_head(head);
> +			*link = NULL;
> +		}
> +	} else if (sqe_flags & (IOSQE_IO_LINK|IOSQE_IO_HARDLINK)) {
