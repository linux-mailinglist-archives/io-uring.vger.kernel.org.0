Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A0C06176DF9
	for <lists+io-uring@lfdr.de>; Tue,  3 Mar 2020 05:26:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726998AbgCCE0J (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 2 Mar 2020 23:26:09 -0500
Received: from mail-pg1-f195.google.com ([209.85.215.195]:46549 "EHLO
        mail-pg1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727385AbgCCE0J (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 2 Mar 2020 23:26:09 -0500
Received: by mail-pg1-f195.google.com with SMTP id y30so884922pga.13
        for <io-uring@vger.kernel.org>; Mon, 02 Mar 2020 20:26:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:references:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=YxxiL18P+ePIHClyxP5CgBfjTjw5OwNkm0lq0rqRopA=;
        b=UCpcVwG5/AE14HLwCCgLzW5W0strLpF9CNVx0C7rWHpLTdGs/vlfhlvSBjExaiyR2N
         ZNdyzY5E6QCbkeJDqy3+nn0jdyns6NjEC/wTVPc0Gt3hEKpZ9TKi22zQJ+rGktmtKvrC
         j1hBNc3cKJ2Yrm18SvH6FdQo9rMhyw9J686kkbAsAUZ4sg0vFBXbsIWl/U2zQ/3llAGF
         8ZVKsrXH3QGkkITLq0pXur3VKroQZeJ8Yh4RM3tWit5NE0YOf3YzY3kkRjTRmCxlQF6O
         OOXJQuNBVpauhq8kQBzDC+QtKWE35cJIsWTNySmAnSidsuWyeltWEOpYfIY0sValKf2r
         Ek5g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=YxxiL18P+ePIHClyxP5CgBfjTjw5OwNkm0lq0rqRopA=;
        b=RfgCWEYZpB2TJuUra1Nwagc6qNSuKKf7v7B2QQt9Uszx4dfmJWh4nPyyoil8O9iulV
         oGWYeb30cMJG6BmMUw4W3uO3IDbSMEkPyLFv6tEdRYPtvtBvi8GP8TJlUxwFxh+udPSG
         FmHb5sKQroRZK8tHY6U9sytTxIQvs+wIHg2TYp7UislQIYOHJIf5uhfFnUU4y+bwrm8T
         rjYyzaW6wDczE81yGu1OWXxhdK61o3Agy6cDF/rUSlJ7XFlwjPGpRTEsY/rW4nj4GQwl
         wReZ/zndlt6cSMkEGt1P8mQorJcbN5qd14q/yXD8Z93uvsku7hZxH+pVK9wg2ojLu51I
         Y3rA==
X-Gm-Message-State: ANhLgQ3FkrZLDU6JSZ/0Ee1+p1JkLVwNghmfOfrpMajYCwefLb1hz1Lj
        2jPAbXYcMb1zx0xVSF6h/QGi2g==
X-Google-Smtp-Source: ADFU+vslQrN2SMqMQ7gJvwMNMP4rivpVXsxVlqI4nawDhMr4u7GpeP0f0LqbgWIPzFHkA6zbz0cBmw==
X-Received: by 2002:a62:5183:: with SMTP id f125mr2230582pfb.201.1583209567017;
        Mon, 02 Mar 2020 20:26:07 -0800 (PST)
Received: from [192.168.1.188] ([66.219.217.145])
        by smtp.gmail.com with ESMTPSA id f17sm11759400pge.48.2020.03.02.20.26.05
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 02 Mar 2020 20:26:06 -0800 (PST)
Subject: Re: [PATCH v2 4/4] io_uring: get next req on subm ref drop
To:     Pavel Begunkov <asml.silence@gmail.com>, io-uring@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <cover.1583181841.git.asml.silence@gmail.com>
 <444aef98f849d947d7f10e88f30244fa0bc82360.1583181841.git.asml.silence@gmail.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <3ab75953-ee39-2c4e-99e2-f8c18ceb6a8d@kernel.dk>
Date:   Mon, 2 Mar 2020 21:26:04 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.4.1
MIME-Version: 1.0
In-Reply-To: <444aef98f849d947d7f10e88f30244fa0bc82360.1583181841.git.asml.silence@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 3/2/20 1:45 PM, Pavel Begunkov wrote:
> Get next request when dropping the submission reference. However, if
> there is an asynchronous counterpart (i.e. read/write, timeout, etc),
> that would be dangerous to do, so ignore them using new
> REQ_F_DONT_STEAL_NEXT flag.

Hmm, not so sure I like this one. It's not quite clear to me where we
need REQ_F_DONT_STEAL_NEXT. If we have an async component, then we set
REQ_F_DONT_STEAL_NEXT. So this is generally the case where our
io_put_req() for submit is not the last drop. And for the other case,
the put is generally in the caller anyway. So I don't really see what
this extra flag buys us?

Few more comments below.

> +static void io_put_req_async_submission(struct io_kiocb *req,
> +					struct io_wq_work **workptr)
> +{
> +	static struct io_kiocb *nxt;
> +
> +	nxt = io_put_req_submission(req);
> +	if (nxt)
> +		io_wq_assign_next(workptr, nxt);
> +}

This really should be called io_put_req_async_completion() since it's
called on completion. The naming is confusing.

> @@ -2581,14 +2598,11 @@ static void __io_fsync(struct io_kiocb *req)
>  static void io_fsync_finish(struct io_wq_work **workptr)
>  {
>  	struct io_kiocb *req = container_of(*workptr, struct io_kiocb, work);
> -	struct io_kiocb *nxt = NULL;
>  
>  	if (io_req_cancelled(req))
>  		return;
>  	__io_fsync(req);
> -	io_put_req(req); /* drop submission reference */
> -	if (nxt)
> -		io_wq_assign_next(workptr, nxt);
> +	io_put_req_async_submission(req, workptr);
>  }
>  
>  static int io_fsync(struct io_kiocb *req, bool force_nonblock)
> @@ -2617,14 +2631,11 @@ static void __io_fallocate(struct io_kiocb *req)
>  static void io_fallocate_finish(struct io_wq_work **workptr)
>  {
>  	struct io_kiocb *req = container_of(*workptr, struct io_kiocb, work);
> -	struct io_kiocb *nxt = NULL;
>  
>  	if (io_req_cancelled(req))
>  		return;
>  	__io_fallocate(req);
> -	io_put_req(req); /* drop submission reference */
> -	if (nxt)
> -		io_wq_assign_next(workptr, nxt);
> +	io_put_req_async_submission(req, workptr);
>  }

All of these cleanups are nice (except the naming, as mentioned).

> @@ -3943,7 +3947,10 @@ static int io_poll_add(struct io_kiocb *req)
>  	if (mask) {
>  		io_cqring_ev_posted(ctx);
>  		io_put_req(req);
> +	} else {
> +		req->flags |= REQ_F_DONT_STEAL_NEXT;
>  	}
> +
>  	return ipt.error;
>  }

Is this racy? I guess it doesn't matter since we're still holding the
completion reference.

-- 
Jens Axboe

