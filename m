Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 94E4C3310C0
	for <lists+io-uring@lfdr.de>; Mon,  8 Mar 2021 15:27:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229650AbhCHO0g (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 8 Mar 2021 09:26:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56166 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229528AbhCHO0H (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 8 Mar 2021 09:26:07 -0500
Received: from mail-wr1-x42e.google.com (mail-wr1-x42e.google.com [IPv6:2a00:1450:4864:20::42e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 51294C06174A
        for <io-uring@vger.kernel.org>; Mon,  8 Mar 2021 06:26:07 -0800 (PST)
Received: by mail-wr1-x42e.google.com with SMTP id w11so11648573wrr.10
        for <io-uring@vger.kernel.org>; Mon, 08 Mar 2021 06:26:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:autocrypt:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=DiRgQpEVc9yLnsXtoMVTOktAshqeCvhGx06W9Re4q00=;
        b=fonVrtE7+9vIZX4GdIBe48QSKpAu0IwLgeMzKbgUGI4p48m80ZGzQjl84kDDRnKfdU
         cqVZtm+Oyr0VqWxNuuQWh32Es1avETEYK/mWXUZsBmwL0d8kKHMfgZG0NvcuZM3cTlJ1
         XpDIsezdkrVxuN/DPRD3BPWhzUzmWWChm0W4C6ShMOGPrk1RINOa4mLjHef8YBMGS6kq
         QosJHiL3TyFJ/tSL8gU52VKE+MU6uHfVOfGmmyAQJWI/STEWNLx0RgKtzyrv35/TcXxR
         J9LgQNFvn9y4i0mn33k7E3C5VRA97M4wV2k/YEC6Ui5hlGG2Cg5suzgQmme+GovPkWWR
         FTzw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:autocrypt
         :message-id:date:user-agent:mime-version:in-reply-to
         :content-language:content-transfer-encoding;
        bh=DiRgQpEVc9yLnsXtoMVTOktAshqeCvhGx06W9Re4q00=;
        b=HTss8UoaFHoL2hDd9dvxGPPA6q1kzfqOmAv4S6B+6DgEGzdCe/+hMFKkuKi3oAZ4dN
         1UqGIRSaec8lOhL+vIsRB8/ZLmxn8sr7bP0FG8GyH2I//LVQnkZby4ZC9ZbIcEWVEKJw
         jJSj2r+Q1YPsKYYSO831juMiVabV5et+6A/LXTCK34jFC9Ot8I80EDKhCnj3sATLl/Ja
         nIG1a4dRtOQjLVFmsoK552FoiCWLMsOydbnDaEc1rz5RJShwY2tN6aH1WTtbQ/rE6ocm
         LI6LEE7JXkhMnKlhzJq6XGPBR9f6AKqzuC6PrTREJ4CG/6Zy2owVKDAD5ryqF5yLD2er
         WSNA==
X-Gm-Message-State: AOAM531tZBq89ivOOrzXdUA0EnS0301bq6/CxZKirjY9mF4M9FyCFRFN
        dpXfzYdZ9dMmX1TfScEBOJ0=
X-Google-Smtp-Source: ABdhPJy77KRNTSrtt7kJaOdcWTSBtbAdTz9yjNbcRhsZedzn9Y6F+pel5iHUcrzTR6qbctNl4pZRNQ==
X-Received: by 2002:a05:6000:18f:: with SMTP id p15mr23298701wrx.23.1615213566116;
        Mon, 08 Mar 2021 06:26:06 -0800 (PST)
Received: from [192.168.8.119] ([148.252.132.144])
        by smtp.gmail.com with ESMTPSA id 18sm18539038wmj.21.2021.03.08.06.26.05
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 08 Mar 2021 06:26:05 -0800 (PST)
Subject: Re: [PATCH 5.12] io_uring: Convert personality_idr to XArray
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
Cc:     Matthew Wilcox <willy@infradead.org>,
        yangerkun <yangerkun@huawei.com>,
        Stefan Metzmacher <metze@samba.org>, yi.zhang@huawei.com
References: <7ccff36e1375f2b0ebf73d957f037b43becc0dde.1615212806.git.asml.silence@gmail.com>
From:   Pavel Begunkov <asml.silence@gmail.com>
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
Message-ID: <803bad80-093a-5fbf-7677-754c9afad530@gmail.com>
Date:   Mon, 8 Mar 2021 14:22:10 +0000
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.3.0
MIME-Version: 1.0
In-Reply-To: <7ccff36e1375f2b0ebf73d957f037b43becc0dde.1615212806.git.asml.silence@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 08/03/2021 14:16, Pavel Begunkov wrote:
> From: "Matthew Wilcox (Oracle)" <willy@infradead.org>
> 
> You can't call idr_remove() from within a idr_for_each() callback,
> but you can call xa_erase() from an xa_for_each() loop, so switch the
> entire personality_idr from the IDR to the XArray.  This manifests as a
> use-after-free as idr_for_each() attempts to walk the rest of the node
> after removing the last entry from it.

yangerkun, can you test it and similarly take care of buffer idr?


> 
> Fixes: 071698e13ac6 ("io_uring: allow registering credentials")
> Cc: stable@vger.kernel.org # 5.6+
> Reported-by: yangerkun <yangerkun@huawei.com>
> Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
> [Pavel: rebased (creds load was moved into io_init_req())]
> Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
> ---
>  fs/io_uring.c | 47 ++++++++++++++++++++++++-----------------------
>  1 file changed, 24 insertions(+), 23 deletions(-)
> 
> p.s. passes liburing tests well
> 
> diff --git a/fs/io_uring.c b/fs/io_uring.c
> index 5ef9f836cccc..5505e19f1391 100644
> --- a/fs/io_uring.c
> +++ b/fs/io_uring.c
> @@ -407,7 +407,8 @@ struct io_ring_ctx {
>  
>  	struct idr		io_buffer_idr;
>  
> -	struct idr		personality_idr;
> +	struct xarray		personalities;
> +	u32			pers_next;
>  
>  	struct {
>  		unsigned		cached_cq_tail;
> @@ -1138,7 +1139,7 @@ static struct io_ring_ctx *io_ring_ctx_alloc(struct io_uring_params *p)
>  	init_completion(&ctx->ref_comp);
>  	init_completion(&ctx->sq_thread_comp);
>  	idr_init(&ctx->io_buffer_idr);
> -	idr_init(&ctx->personality_idr);
> +	xa_init_flags(&ctx->personalities, XA_FLAGS_ALLOC1);
>  	mutex_init(&ctx->uring_lock);
>  	init_waitqueue_head(&ctx->wait);
>  	spin_lock_init(&ctx->completion_lock);
> @@ -6338,7 +6339,7 @@ static int io_init_req(struct io_ring_ctx *ctx, struct io_kiocb *req,
>  	req->work.list.next = NULL;
>  	personality = READ_ONCE(sqe->personality);
>  	if (personality) {
> -		req->work.creds = idr_find(&ctx->personality_idr, personality);
> +		req->work.creds = xa_load(&ctx->personalities, personality);
>  		if (!req->work.creds)
>  			return -EINVAL;
>  		get_cred(req->work.creds);
> @@ -8359,7 +8360,6 @@ static void io_ring_ctx_free(struct io_ring_ctx *ctx)
>  	mutex_unlock(&ctx->uring_lock);
>  	io_eventfd_unregister(ctx);
>  	io_destroy_buffers(ctx);
> -	idr_destroy(&ctx->personality_idr);
>  
>  #if defined(CONFIG_UNIX)
>  	if (ctx->ring_sock) {
> @@ -8424,7 +8424,7 @@ static int io_unregister_personality(struct io_ring_ctx *ctx, unsigned id)
>  {
>  	const struct cred *creds;
>  
> -	creds = idr_remove(&ctx->personality_idr, id);
> +	creds = xa_erase(&ctx->personalities, id);
>  	if (creds) {
>  		put_cred(creds);
>  		return 0;
> @@ -8433,14 +8433,6 @@ static int io_unregister_personality(struct io_ring_ctx *ctx, unsigned id)
>  	return -EINVAL;
>  }
>  
> -static int io_remove_personalities(int id, void *p, void *data)
> -{
> -	struct io_ring_ctx *ctx = data;
> -
> -	io_unregister_personality(ctx, id);
> -	return 0;
> -}
> -
>  static bool io_run_ctx_fallback(struct io_ring_ctx *ctx)
>  {
>  	struct callback_head *work, *next;
> @@ -8530,13 +8522,17 @@ static void io_ring_exit_work(struct work_struct *work)
>  
>  static void io_ring_ctx_wait_and_kill(struct io_ring_ctx *ctx)
>  {
> +	unsigned long index;
> +	struct creds *creds;
> +
>  	mutex_lock(&ctx->uring_lock);
>  	percpu_ref_kill(&ctx->refs);
>  	/* if force is set, the ring is going away. always drop after that */
>  	ctx->cq_overflow_flushed = 1;
>  	if (ctx->rings)
>  		__io_cqring_overflow_flush(ctx, true, NULL, NULL);
> -	idr_for_each(&ctx->personality_idr, io_remove_personalities, ctx);
> +	xa_for_each(&ctx->personalities, index, creds)
> +		io_unregister_personality(ctx, index);
>  	mutex_unlock(&ctx->uring_lock);
>  
>  	io_kill_timeouts(ctx, NULL, NULL);
> @@ -9166,10 +9162,9 @@ SYSCALL_DEFINE6(io_uring_enter, unsigned int, fd, u32, to_submit,
>  }
>  
>  #ifdef CONFIG_PROC_FS
> -static int io_uring_show_cred(int id, void *p, void *data)
> +static int io_uring_show_cred(struct seq_file *m, unsigned int id,
> +		const struct cred *cred)
>  {
> -	const struct cred *cred = p;
> -	struct seq_file *m = data;
>  	struct user_namespace *uns = seq_user_ns(m);
>  	struct group_info *gi;
>  	kernel_cap_t cap;
> @@ -9237,9 +9232,13 @@ static void __io_uring_show_fdinfo(struct io_ring_ctx *ctx, struct seq_file *m)
>  		seq_printf(m, "%5u: 0x%llx/%u\n", i, buf->ubuf,
>  						(unsigned int) buf->len);
>  	}
> -	if (has_lock && !idr_is_empty(&ctx->personality_idr)) {
> +	if (has_lock && !xa_empty(&ctx->personalities)) {
> +		unsigned long index;
> +		const struct cred *cred;
> +
>  		seq_printf(m, "Personalities:\n");
> -		idr_for_each(&ctx->personality_idr, io_uring_show_cred, m);
> +		xa_for_each(&ctx->personalities, index, cred)
> +			io_uring_show_cred(m, index, cred);
>  	}
>  	seq_printf(m, "PollList:\n");
>  	spin_lock_irq(&ctx->completion_lock);
> @@ -9568,14 +9567,16 @@ static int io_probe(struct io_ring_ctx *ctx, void __user *arg, unsigned nr_args)
>  static int io_register_personality(struct io_ring_ctx *ctx)
>  {
>  	const struct cred *creds;
> +	u32 id;
>  	int ret;
>  
>  	creds = get_current_cred();
>  
> -	ret = idr_alloc_cyclic(&ctx->personality_idr, (void *) creds, 1,
> -				USHRT_MAX, GFP_KERNEL);
> -	if (ret < 0)
> -		put_cred(creds);
> +	ret = xa_alloc_cyclic(&ctx->personalities, &id, (void *)creds,
> +			XA_LIMIT(0, USHRT_MAX), &ctx->pers_next, GFP_KERNEL);
> +	if (!ret)
> +		return id;
> +	put_cred(creds);
>  	return ret;
>  }
>  
> 

-- 
Pavel Begunkov
