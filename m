Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 91C3F174FFC
	for <lists+io-uring@lfdr.de>; Sun,  1 Mar 2020 22:40:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726204AbgCAVkd (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sun, 1 Mar 2020 16:40:33 -0500
Received: from mail-wr1-f65.google.com ([209.85.221.65]:33443 "EHLO
        mail-wr1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726050AbgCAVkd (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sun, 1 Mar 2020 16:40:33 -0500
Received: by mail-wr1-f65.google.com with SMTP id x7so10093265wrr.0;
        Sun, 01 Mar 2020 13:40:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:from:to:references:autocrypt:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=5365KLru4qSZDpNM5l+n3e7Q++lsVis5gf+2sNysuhk=;
        b=XT5NXRlc/J9QW28t42UWFXEHulZbh4xHBCbT4NOOOguvJa4/nfaYCOWJLUkxlznB2w
         rUOHddryfqyJN/UR8PI0jl/UxHE9bd027p+/hJxtf6YE3Ap/8ym0Pdaq8i2L4uw32avR
         z6poPCLX6rjY6VjfDYrm5BX5/hSbdbpq9SFddtNlJBAKa1TsgrkPmZpSb2NsvBlSLW0G
         GLR1VqrxUK8Fs3iRnJZin/WEzKipvjoMApoy6g0QllFokxRcrJqaMRes/2MmsSaOhSx9
         SvS1ovRLhTz/r+fdYlFNy2xhTkoVOQz6euHx3n0u69LusUU11HwNuse/jxOduGw1x+8J
         hCaQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:references:autocrypt:message-id
         :date:user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=5365KLru4qSZDpNM5l+n3e7Q++lsVis5gf+2sNysuhk=;
        b=mBo6I3ZJrPqagoX2Tf7dLLzlQHq6bDyn4uBfqf6V4/BPe+b7icS7PrkGfUZfj5iYBv
         dfjv0qarFAjyM+gKXeahF69Ui0DD1yeYBiis+1mCq1sFIFY0jC7brbt3+SmLRV7Kzrif
         G79XapnLCoMb7jF3vGZEV8Yd2XCC71tCbZN5Q/FPcMjRcWy5XcOXD7b1Ufwv3B+3LysV
         vcwmsV1l/VMYYu+7w8bcI8m/5Cvl+tVfqs+XKzs+6wse5Ze55W5nShfl2qjs18fPcAs+
         K4Yoijh6GUMhW7C3sjST6sk1CkG+4fMh2LmKc9iT+J2/tcKEO1EWh3wU0JWWeg3zVgrB
         9vDw==
X-Gm-Message-State: APjAAAWqEsGtbWyAddtBVoHcKqgEIJ5qcfP4YCUmCHwpQrcsIhypXo83
        p5EBG8qL1ZmoMX8kuBk3b3Rze0h/
X-Google-Smtp-Source: APXvYqzUY7ht/djsoUDX1YlOcfG4nx0hD4dvwWuSt5QGPO6IKihFjSRrtYeDGX1PDlHfpwEuPQETRw==
X-Received: by 2002:adf:fa0f:: with SMTP id m15mr18805089wrr.392.1583098829282;
        Sun, 01 Mar 2020 13:40:29 -0800 (PST)
Received: from [192.168.43.139] ([109.126.130.242])
        by smtp.gmail.com with ESMTPSA id i18sm21042498wrv.30.2020.03.01.13.40.28
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 01 Mar 2020 13:40:28 -0800 (PST)
Subject: Re: [PATCH 9/9] io_uring: pass submission ref to async
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <cover.1583078091.git.asml.silence@gmail.com>
 <29efa25e63ea86b9b038fff202a5f7423b5482c8.1583078091.git.asml.silence@gmail.com>
Autocrypt: addr=asml.silence@gmail.com; prefer-encrypt=mutual; keydata=
 mQINBFmKBOQBEAC76ZFxLAKpDw0bKQ8CEiYJRGn8MHTUhURL02/7n1t0HkKQx2K1fCXClbps
 bdwSHrhOWdW61pmfMbDYbTj6ZvGRvhoLWfGkzujB2wjNcbNTXIoOzJEGISHaPf6E2IQx1ik9
 6uqVkK1OMb7qRvKH0i7HYP4WJzYbEWVyLiAxUj611mC9tgd73oqZ2pLYzGTqF2j6a/obaqha
 +hXuWTvpDQXqcOZJXIW43atprH03G1tQs7VwR21Q1eq6Yvy2ESLdc38EqCszBfQRMmKy+cfp
 W3U9Mb1w0L680pXrONcnlDBCN7/sghGeMHjGKfNANjPc+0hzz3rApPxpoE7HC1uRiwC4et83
 CKnncH1l7zgeBT9Oa3qEiBlaa1ZCBqrA4dY+z5fWJYjMpwI1SNp37RtF8fKXbKQg+JuUjAa9
 Y6oXeyEvDHMyJYMcinl6xCqCBAXPHnHmawkMMgjr3BBRzODmMr+CPVvnYe7BFYfoajzqzq+h
 EyXSl3aBf0IDPTqSUrhbmjj5OEOYgRW5p+mdYtY1cXeK8copmd+fd/eTkghok5li58AojCba
 jRjp7zVOLOjDlpxxiKhuFmpV4yWNh5JJaTbwCRSd04sCcDNlJj+TehTr+o1QiORzc2t+N5iJ
 NbILft19Izdn8U39T5oWiynqa1qCLgbuFtnYx1HlUq/HvAm+kwARAQABtDFQYXZlbCBCZWd1
 bmtvdiAoc2lsZW5jZSkgPGFzbWwuc2lsZW5jZUBnbWFpbC5jb20+iQJOBBMBCAA4FiEE+6Ju
 PTjTbx479o3OWt5b1Glr+6UFAlmKBOQCGwMFCwkIBwIGFQgJCgsCBBYCAwECHgECF4AACgkQ
 Wt5b1Glr+6WxZA//QueaKHzgdnOikJ7NA/Vq8FmhRlwgtP0+E+w93kL+ZGLzS/cUCIjn2f4Q
 Mcutj2Neg0CcYPX3b2nJiKr5Vn0rjJ/suiaOa1h1KzyNTOmxnsqE5fmxOf6C6x+NKE18I5Jy
 xzLQoktbdDVA7JfB1itt6iWSNoOTVcvFyvfe5ggy6FSCcP+m1RlR58XxVLH+qlAvxxOeEr/e
 aQfUzrs7gqdSd9zQGEZo0jtuBiB7k98t9y0oC9Jz0PJdvaj1NZUgtXG9pEtww3LdeXP/TkFl
 HBSxVflzeoFaj4UAuy8+uve7ya/ECNCc8kk0VYaEjoVrzJcYdKP583iRhOLlZA6HEmn/+Gh9
 4orG67HNiJlbFiW3whxGizWsrtFNLsSP1YrEReYk9j1SoUHHzsu+ZtNfKuHIhK0sU07G1OPN
 2rDLlzUWR9Jc22INAkhVHOogOcc5ajMGhgWcBJMLCoi219HlX69LIDu3Y34uIg9QPZIC2jwr
 24W0kxmK6avJr7+n4o8m6sOJvhlumSp5TSNhRiKvAHB1I2JB8Q1yZCIPzx+w1ALxuoWiCdwV
 M/azguU42R17IuBzK0S3hPjXpEi2sK/k4pEPnHVUv9Cu09HCNnd6BRfFGjo8M9kZvw360gC1
 reeMdqGjwQ68o9x0R7NBRrtUOh48TDLXCANAg97wjPoy37dQE7e5Ag0EWYoE5AEQAMWS+aBV
 IJtCjwtfCOV98NamFpDEjBMrCAfLm7wZlmXy5I6o7nzzCxEw06P2rhzp1hIqkaab1kHySU7g
 dkpjmQ7Jjlrf6KdMP87mC/Hx4+zgVCkTQCKkIxNE76Ff3O9uTvkWCspSh9J0qPYyCaVta2D1
 Sq5HZ8WFcap71iVO1f2/FEHKJNz/YTSOS/W7dxJdXl2eoj3gYX2UZNfoaVv8OXKaWslZlgqN
 jSg9wsTv1K73AnQKt4fFhscN9YFxhtgD/SQuOldE5Ws4UlJoaFX/yCoJL3ky2kC0WFngzwRF
 Yo6u/KON/o28yyP+alYRMBrN0Dm60FuVSIFafSqXoJTIjSZ6olbEoT0u17Rag8BxnxryMrgR
 dkccq272MaSS0eOC9K2rtvxzddohRFPcy/8bkX+t2iukTDz75KSTKO+chce62Xxdg62dpkZX
 xK+HeDCZ7gRNZvAbDETr6XI63hPKi891GeZqvqQVYR8e+V2725w+H1iv3THiB1tx4L2bXZDI
 DtMKQ5D2RvCHNdPNcZeldEoJwKoA60yg6tuUquvsLvfCwtrmVI2rL2djYxRfGNmFMrUDN1Xq
 F3xozA91q3iZd9OYi9G+M/OA01husBdcIzj1hu0aL+MGg4Gqk6XwjoSxVd4YT41kTU7Kk+/I
 5/Nf+i88ULt6HanBYcY/+Daeo/XFABEBAAGJAjYEGAEIACAWIQT7om49ONNvHjv2jc5a3lvU
 aWv7pQUCWYoE5AIbDAAKCRBa3lvUaWv7pfmcEACKTRQ28b1y5ztKuLdLr79+T+LwZKHjX++P
 4wKjEOECCcB6KCv3hP+J2GCXDOPZvdg/ZYZafqP68Yy8AZqkfa4qPYHmIdpODtRzZSL48kM8
 LRzV8Rl7J3ItvzdBRxf4T/Zseu5U6ELiQdCUkPGsJcPIJkgPjO2ROG/ZtYa9DvnShNWPlp+R
 uPwPccEQPWO/NP4fJl2zwC6byjljZhW5kxYswGMLBwb5cDUZAisIukyAa8Xshdan6C2RZcNs
 rB3L7vsg/R8UCehxOH0C+NypG2GqjVejNZsc7bgV49EOVltS+GmGyY+moIzxsuLmT93rqyII
 5rSbbcTLe6KBYcs24XEoo49Zm9oDA3jYvNpeYD8rDcnNbuZh9kTgBwFN41JHOPv0W2FEEWqe
 JsCwQdcOQ56rtezdCJUYmRAt3BsfjN3Jn3N6rpodi4Dkdli8HylM5iq4ooeb5VkQ7UZxbCWt
 UVMKkOCdFhutRmYp0mbv2e87IK4erwNHQRkHUkzbsuym8RVpAZbLzLPIYK/J3RTErL6Z99N2
 m3J6pjwSJY/zNwuFPs9zGEnRO4g0BUbwGdbuvDzaq6/3OJLKohr5eLXNU3JkT+3HezydWm3W
 OPhauth7W0db74Qd49HXK0xe/aPrK+Cp+kU1HRactyNtF8jZQbhMCC8vMGukZtWaAwpjWiiH bA==
Message-ID: <fb27a289-717c-b911-7981-db72cbc51c26@gmail.com>
Date:   Mon, 2 Mar 2020 00:39:41 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.3.0
MIME-Version: 1.0
In-Reply-To: <29efa25e63ea86b9b038fff202a5f7423b5482c8.1583078091.git.asml.silence@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 01/03/2020 19:18, Pavel Begunkov wrote:
> Currenlty, every async work handler accepts a submission reference,
> which it should put. Also there is a reference grabbed in io_get_work()
> and dropped in io_put_work(). This patch merge them together.
> 
> - So, ownership of the submission reference passed to io-wq, and it'll
> be put in io_put_work().
> - io_get_put() doesn't take a ref now and so deleted.
> - async handlers don't put the submission ref anymore.
> - make cancellation bits of io-wq to call {get,put}_work() handlers

Hmm, it makes them more like {init,fini}_work() and unbalanced/unpaired. May be
no a desirable thing.

> Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
> ---
>  fs/io-wq.c    | 17 +++++++++++++----
>  fs/io_uring.c | 32 +++++++++++++-------------------
>  2 files changed, 26 insertions(+), 23 deletions(-)
> 
> diff --git a/fs/io-wq.c b/fs/io-wq.c
> index f9b18c16ebd8..686ad043c6ac 100644
> --- a/fs/io-wq.c
> +++ b/fs/io-wq.c
> @@ -751,14 +751,23 @@ static bool io_wq_can_queue(struct io_wqe *wqe, struct io_wqe_acct *acct,
>  	return true;
>  }
>  
> -static void io_run_cancel(struct io_wq_work *work)
> +static void io_run_cancel(struct io_wq_work *work, struct io_wqe *wqe)
>  {
> +	struct io_wq *wq = wqe->wq;
> +
>  	do {
>  		struct io_wq_work *old_work = work;
> +		bool is_internal = work->flags & IO_WQ_WORK_INTERNAL;
> +
> +		if (wq->get_work && !is_internal)
> +			wq->get_work(work);
>  
>  		work->flags |= IO_WQ_WORK_CANCEL;
>  		work->func(&work);
>  		work = (work == old_work) ? NULL : work;
> +
> +		if (wq->put_work && !is_internal)
> +			wq->put_work(old_work);
>  	} while (work);
>  }
>  
> @@ -775,7 +784,7 @@ static void io_wqe_enqueue(struct io_wqe *wqe, struct io_wq_work *work)
>  	 * It's close enough to not be an issue, fork() has the same delay.
>  	 */
>  	if (unlikely(!io_wq_can_queue(wqe, acct, work))) {
> -		io_run_cancel(work);
> +		io_run_cancel(work, wqe);
>  		return;
>  	}
>  
> @@ -914,7 +923,7 @@ static enum io_wq_cancel io_wqe_cancel_cb_work(struct io_wqe *wqe,
>  	spin_unlock_irqrestore(&wqe->lock, flags);
>  
>  	if (found) {
> -		io_run_cancel(work);
> +		io_run_cancel(work, wqe);
>  		return IO_WQ_CANCEL_OK;
>  	}
>  
> @@ -989,7 +998,7 @@ static enum io_wq_cancel io_wqe_cancel_work(struct io_wqe *wqe,
>  	spin_unlock_irqrestore(&wqe->lock, flags);
>  
>  	if (found) {
> -		io_run_cancel(work);
> +		io_run_cancel(work, wqe);
>  		return IO_WQ_CANCEL_OK;
>  	}
>  
> diff --git a/fs/io_uring.c b/fs/io_uring.c
> index d456b0ff6835..c6845a1e5aaa 100644
> --- a/fs/io_uring.c
> +++ b/fs/io_uring.c
> @@ -1556,12 +1556,13 @@ static struct io_kiocb *io_put_req_submission(struct io_kiocb *req)
>  	return nxt;
>  }
>  
> -static void io_put_req_async_submission(struct io_kiocb *req,
> -					struct io_wq_work **workptr)
> +static void io_steal_work(struct io_kiocb *req,
> +			  struct io_wq_work **workptr)
>  {
> -	static struct io_kiocb *nxt;
> +	struct io_kiocb *nxt = NULL;
>  
> -	nxt = io_put_req_submission(req);
> +	if (!(req->flags & REQ_F_DONT_STEAL_NEXT))
> +		io_req_find_next(req, &nxt);
>  	if (nxt)
>  		io_wq_assign_next(workptr, nxt);
>  }
> @@ -2575,7 +2576,7 @@ static bool io_req_cancelled(struct io_kiocb *req)
>  	if (req->work.flags & IO_WQ_WORK_CANCEL) {
>  		req_set_fail_links(req);
>  		io_cqring_add_event(req, -ECANCELED);
> -		io_double_put_req(req);
> +		io_put_req(req);
>  		return true;
>  	}
>  
> @@ -2603,7 +2604,7 @@ static void io_fsync_finish(struct io_wq_work **workptr)
>  	if (io_req_cancelled(req))
>  		return;
>  	__io_fsync(req);
> -	io_put_req_async_submission(req, workptr);
> +	io_steal_work(req, workptr);
>  }
>  
>  static int io_fsync(struct io_kiocb *req, bool force_nonblock)
> @@ -2636,7 +2637,7 @@ static void io_fallocate_finish(struct io_wq_work **workptr)
>  	if (io_req_cancelled(req))
>  		return;
>  	__io_fallocate(req);
> -	io_put_req_async_submission(req, workptr);
> +	io_steal_work(req, workptr);
>  }
>  
>  static int io_fallocate_prep(struct io_kiocb *req,
> @@ -3003,7 +3004,7 @@ static void io_close_finish(struct io_wq_work **workptr)
>  
>  	/* not cancellable, don't do io_req_cancelled() */
>  	__io_close_finish(req);
> -	io_put_req_async_submission(req, workptr);
> +	io_steal_work(req, workptr);
>  }
>  
>  static int io_close(struct io_kiocb *req, bool force_nonblock)
> @@ -3076,7 +3077,7 @@ static void io_sync_file_range_finish(struct io_wq_work **workptr)
>  	if (io_req_cancelled(req))
>  		return;
>  	__io_sync_file_range(req);
> -	io_put_req_async_submission(req, workptr);
> +	io_steal_work(req, workptr);
>  }
>  
>  static int io_sync_file_range(struct io_kiocb *req, bool force_nonblock)
> @@ -3446,7 +3447,7 @@ static void io_accept_finish(struct io_wq_work **workptr)
>  	if (io_req_cancelled(req))
>  		return;
>  	__io_accept(req, false);
> -	io_put_req_async_submission(req, workptr);
> +	io_steal_work(req, workptr);
>  }
>  #endif
>  
> @@ -4716,7 +4717,7 @@ static void io_wq_submit_work(struct io_wq_work **workptr)
>  		io_put_req(req);
>  	}
>  
> -	io_put_req_async_submission(req, workptr);
> +	io_steal_work(req, workptr);
>  }
>  
>  static int io_req_needs_file(struct io_kiocb *req, int fd)
> @@ -6107,13 +6108,6 @@ static void io_put_work(struct io_wq_work *work)
>  	io_put_req(req);
>  }
>  
> -static void io_get_work(struct io_wq_work *work)
> -{
> -	struct io_kiocb *req = container_of(work, struct io_kiocb, work);
> -
> -	refcount_inc(&req->refs);
> -}
> -
>  static int io_init_wq_offload(struct io_ring_ctx *ctx,
>  			      struct io_uring_params *p)
>  {
> @@ -6124,7 +6118,7 @@ static int io_init_wq_offload(struct io_ring_ctx *ctx,
>  	int ret = 0;
>  
>  	data.user = ctx->user;
> -	data.get_work = io_get_work;
> +	data.get_work = NULL;
>  	data.put_work = io_put_work;
>  
>  	if (!(p->flags & IORING_SETUP_ATTACH_WQ)) {
> 

-- 
Pavel Begunkov
