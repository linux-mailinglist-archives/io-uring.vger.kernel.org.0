Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 73DFF28EED0
	for <lists+io-uring@lfdr.de>; Thu, 15 Oct 2020 10:53:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730352AbgJOIxX (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 15 Oct 2020 04:53:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33284 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726329AbgJOIxX (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 15 Oct 2020 04:53:23 -0400
Received: from mail-io1-xd42.google.com (mail-io1-xd42.google.com [IPv6:2607:f8b0:4864:20::d42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 26957C061755
        for <io-uring@vger.kernel.org>; Thu, 15 Oct 2020 01:53:23 -0700 (PDT)
Received: by mail-io1-xd42.google.com with SMTP id n6so3304423ioc.12
        for <io-uring@vger.kernel.org>; Thu, 15 Oct 2020 01:53:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=jjiCvGcCqX6kxSFTlIIsiLCTdISobZ1LNpDvp+votn8=;
        b=KRq/Jr3X2UETLCiBmq8NTQQxSWd8iyKlKSBr/VUrzomayzrl7Iz1/939eQOaV9KW3M
         SDbhR8maeYcaGfEkZVbGqB0Xx6uGYViRsviFRwL/nHr9n8gEc7EpZM6b2tp4XmAHouhI
         kazPtMpe+Z7F1zHRRHSG4on/EUzqK2I3ehZq+R2UoDQjnhpn6jd/7xLm1tpvW23gR1Zr
         2iiOvz6yH0S/JgwPTtiOfdIvSK3wh68w/8xcYq7oWw/XytRnOs42oUitBqrsCWgHQGyE
         4zYu4/CPi4hAMV5pyioTu0A9NpWJfP7YvO/P89dbKOYl8PikHkPkCWjluOYBJkxnlB0v
         /N2g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=jjiCvGcCqX6kxSFTlIIsiLCTdISobZ1LNpDvp+votn8=;
        b=YtyMm20usJBY5trMoCYzcqxLLPK4wtBLlN2X7pwzE6R/sNjygxwrIdB2O1wBserWxg
         0iSOG2z5qqIK+sNkpg2Uk7k9X5OluVFajDi2YAJotclqcLtFrznPYcHzOTMSqjbcEvXD
         JVCF+wSv8rM/uuItXVYviEWkDvo3NK9zahiBJ2Ax8BiehIlqdwsU5U8esqAPp76qFA3x
         vyrmw9v/ssMGqrkwiJzW5yH68IFEYmIZHz57+6yPpiiJbZ7dnW8b9fSYZ9YPbxnRESlg
         U3vLD0a7Mf6XsP3YQ2+mtspztSbT5kt5BTmi90xNqxUh6H0+MieHOWsDwTp9D9WlVcZX
         j3Mw==
X-Gm-Message-State: AOAM533Mout4YFmKJJ5Q3tE2JlpniirFxg9qasz/W5lb+bcALx+chhNn
        YnqZS36vgeJf94nms4MWpg0=
X-Google-Smtp-Source: ABdhPJx4j48t6c0dgguzbuhRZFPz6+NqH7/h16WwV9no8VbT5M5DheIfFyLr51IH7q3xmugAl3KP3Q==
X-Received: by 2002:a02:a0c2:: with SMTP id i2mr2633811jah.92.1602752002140;
        Thu, 15 Oct 2020 01:53:22 -0700 (PDT)
Received: from ubuntu-m3-large-x86 ([2604:1380:45d1:2600::3])
        by smtp.gmail.com with ESMTPSA id b9sm1914868ilq.51.2020.10.15.01.53.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 15 Oct 2020 01:53:21 -0700 (PDT)
Date:   Thu, 15 Oct 2020 01:53:19 -0700
From:   Nathan Chancellor <natechancellor@gmail.com>
To:     Pavel Begunkov <asml.silence@gmail.com>
Cc:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org,
        clang-built-linux@googlegroups.com
Subject: Re: [PATCH 2/2] io_uring: optimise io_fail_links()
Message-ID: <20201015085319.GA3683749@ubuntu-m3-large-x86>
References: <cover.1602703669.git.asml.silence@gmail.com>
 <3341227735910a265b494d22645061a6bdcb225d.1602703669.git.asml.silence@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <3341227735910a265b494d22645061a6bdcb225d.1602703669.git.asml.silence@gmail.com>
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Wed, Oct 14, 2020 at 08:44:22PM +0100, Pavel Begunkov wrote:
> Optimise put handling in __io_fail_links() after removing
> REQ_F_COMP_LOCKED.
> 
> Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
> ---
>  fs/io_uring.c | 11 ++++++++++-
>  1 file changed, 10 insertions(+), 1 deletion(-)
> 
> diff --git a/fs/io_uring.c b/fs/io_uring.c
> index f61af4d487fd..271a016e8507 100644
> --- a/fs/io_uring.c
> +++ b/fs/io_uring.c
> @@ -1816,7 +1816,16 @@ static void __io_fail_links(struct io_kiocb *req)
>  		trace_io_uring_fail_link(req, link);
>  
>  		io_cqring_fill_event(link, -ECANCELED);
> -		io_put_req_deferred(link, 2);
> +
> +		/*
> +		 * It's ok to free under spinlock as they're not linked anymore,
> +		 * but avoid REQ_F_WORK_INITIALIZED because it may deadlock on
> +		 * work.fs->lock.
> +		 */
> +		if (link->flags | REQ_F_WORK_INITIALIZED)
> +			io_put_req_deferred(link, 2);
> +		else
> +			io_double_put_req(link);
>  	}
>  
>  	io_commit_cqring(ctx);
> -- 
> 2.24.0
> 

This part of commit 9c357fed168a ("io_uring: fix REQ_F_COMP_LOCKED by
killing it") causes a clang warning:

fs/io_uring.c:1816:19: warning: bitwise or with non-zero value always
evaluates to true [-Wtautological-bitwise-compare]
                if (link->flags | REQ_F_WORK_INITIALIZED)
                    ~~~~~~~~~~~~^~~~~~~~~~~~~~~~~~~~~~~~
1 warning generated.

According to the comment, was it intended for that to be a bitwise AND
then negated to check for the absence of it? If so, wouldn't it be
clearer to flip the condition so that a negation is not necessary like
below? I can send a formal patch if my analysis is correct but if not,
feel free to fix it yourself and add

Reported-by: Nathan Chancellor <natechancellor@gmail.com>

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 66c41d53a9d3..28b1a0fede3e 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -1813,10 +1813,10 @@ static void __io_fail_links(struct io_kiocb *req)
 		 * but avoid REQ_F_WORK_INITIALIZED because it may deadlock on
 		 * work.fs->lock.
 		 */
-		if (link->flags | REQ_F_WORK_INITIALIZED)
-			io_put_req_deferred(link, 2);
-		else
+		if (link->flags & REQ_F_WORK_INITIALIZED)
 			io_double_put_req(link);
+		else
+			io_put_req_deferred(link, 2);
 	}
 
 	io_commit_cqring(ctx);
