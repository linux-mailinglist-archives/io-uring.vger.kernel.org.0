Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 12C271D33A7
	for <lists+io-uring@lfdr.de>; Thu, 14 May 2020 16:55:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727917AbgENOzI (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 14 May 2020 10:55:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39434 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727885AbgENOzH (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 14 May 2020 10:55:07 -0400
Received: from mail-wm1-x344.google.com (mail-wm1-x344.google.com [IPv6:2a00:1450:4864:20::344])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 32830C061A0C
        for <io-uring@vger.kernel.org>; Thu, 14 May 2020 07:55:07 -0700 (PDT)
Received: by mail-wm1-x344.google.com with SMTP id g12so33075667wmh.3
        for <io-uring@vger.kernel.org>; Thu, 14 May 2020 07:55:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=to:cc:references:from:autocrypt:subject:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=VljZtSHHMdgBlV/KrRhfcZ5jyPxHSZPX8efDlkCs+fs=;
        b=N38RyPUP6MGAiThceFSfGNit1M3isjsAYy9CvmL7Mjd7fk5XEjkcYR02VtFYa3Syl2
         ShCdBoodHvS9rnuSys6sIX18Bj2GR/dcuTAu58bXrD5vvurmiP+Q+TS1ExyaAPWXRI5J
         6Sgn4pu2V1eHW0jjlyBCM3WXJuqW2af6FcBxlV9pN8RwqOD6ETl5G5pHUmPz57L9WJv/
         0Mw/8vUHlLZQhLUpli08q97+G8FpFx/G93xTf9Gn0SGNjXstTtyX/xu/YVU2ldlQCXFb
         uQLpoYco/L0AFd82T+Pp/97kumpI9tni0Efp7lnK+ghohU6EhdenU843f5Kd4jnRvm5v
         WZtw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:to:cc:references:from:autocrypt:subject
         :message-id:date:user-agent:mime-version:in-reply-to
         :content-language:content-transfer-encoding;
        bh=VljZtSHHMdgBlV/KrRhfcZ5jyPxHSZPX8efDlkCs+fs=;
        b=dxfpzyMv1r6S8wNBwxSKy2qqF5oxUfL0lt2pCx/cDi3tIgCxnqgHzl/VlLL7R4xbxi
         9l+/QJ1c0yR+7kQhKEelubK2omhPFEYuNBz1o0JXMb3MNu4dZbcu5NaD6UdSbVmkpTAy
         82vAL84VqO6S2H3MBGOtfzByO6tAYJjCmzGl+XMeGj4g72wxTsBSufdY94QBYlgCyyD7
         ZxbFCV7dEQfjvm3x7LDmbo0Cv2sQNVYfRWKAng+BLPPvd+Ripo64FDRfPwIS+4tL1IkQ
         gyie5yhI21JmH8nr4TKGs+8BK3/EMXfWJVtqlzjCsTITSw5vHn7x7jLtRpniD86VXwoe
         7bnA==
X-Gm-Message-State: AGi0Pubx834rj6CVq0+FCfV1FXkhnAcRDSCUnfIXPxX4Xg3A1lNUJtqg
        cDn81yfyB8BR7xnOYV2QR/w=
X-Google-Smtp-Source: APiQypL6yaV7p0kQ/7zJK62zaLWUDEKG9yIhhHGX8skY8DtJlbQB32sJmOalyfuDgY5t3UAIcZU5Dg==
X-Received: by 2002:a7b:c5c7:: with SMTP id n7mr38901743wmk.18.1589468105527;
        Thu, 14 May 2020 07:55:05 -0700 (PDT)
Received: from [192.168.43.127] ([46.191.65.149])
        by smtp.gmail.com with ESMTPSA id s15sm4282329wro.80.2020.05.14.07.55.03
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 14 May 2020 07:55:04 -0700 (PDT)
To:     Jens Axboe <axboe@kernel.dk>,
        Xiaoguang Wang <xiaoguang.wang@linux.alibaba.com>,
        io-uring <io-uring@vger.kernel.org>
Cc:     joseph qi <joseph.qi@linux.alibaba.com>,
        Jiufei Xue <jiufei.xue@linux.alibaba.com>
References: <492bb956-a670-8730-a35f-1d878c27175f@kernel.dk>
 <dc5a0caf-0ba4-bfd7-4b6e-cbcb3e6fde10@linux.alibaba.com>
 <70602a13-f6c9-e8a8-1035-6f148ba2d6d7@kernel.dk>
 <a68bbc0a-5bd7-06b6-1616-2704512228b8@kernel.dk>
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
Subject: Re: [PATCH RFC} io_uring: io_kiocb alloc cache
Message-ID: <0ec1b33d-893f-1b10-128e-f8a8950b0384@gmail.com>
Date:   Thu, 14 May 2020 17:53:53 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.3.0
MIME-Version: 1.0
In-Reply-To: <a68bbc0a-5bd7-06b6-1616-2704512228b8@kernel.dk>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 14/05/2020 17:33, Jens Axboe wrote:
> On 5/14/20 8:22 AM, Jens Axboe wrote:
>>> I still use my previous io_uring_nop_stress tool to evaluate the improvement
>>> in a physical machine. Memory 250GB and cpu is "Intel(R) Xeon(R) CPU E5-2682 v4 @ 2.50GHz".
>>> Before this patch:
>>> $sudo taskset -c 60 ./io_uring_nop_stress -r 300
>>> total ios: 1608773840
>>> IOPS:      5362579
>>>
>>> With this patch:
>>> sudo taskset -c 60 ./io_uring_nop_stress -r 300
>>> total ios: 1676910736
>>> IOPS:      5589702
>>> About 4.2% improvement.
>>
>> That's not bad. Can you try the patch from Pekka as well, just to see if
>> that helps for you?
>>
>> I also had another idea... We basically have two types of request life
>> times:
>>
>> 1) io_kiocb can get queued up internally
>> 2) io_kiocb completes inline
>>
>> For the latter, it's totally feasible to just have the io_kiocb on
>> stack. The downside is if we need to go the slower path, then we need to
>> alloc an io_kiocb then and copy it. But maybe that's OK... I'll play
>> with it.

Does it differ from having one pre-allocated req? Like fallback_req, but without
atomics and returned only under uring_mutex (i.e. in __io_queue_sqe()). Putting
aside its usefulness, at least it will have a chance to work with reads/writes.

> 
> Can you try this with your microbenchmark? Just curious what it looks
> like for that test case if we completely take slab alloc+free out of it.
> 
> 
> diff --git a/fs/io_uring.c b/fs/io_uring.c
> index d2e37215d05a..4ecd6bd38f02 100644
> --- a/fs/io_uring.c
> +++ b/fs/io_uring.c
> @@ -525,6 +525,7 @@ enum {
>  	REQ_F_POLLED_BIT,
>  	REQ_F_BUFFER_SELECTED_BIT,
>  	REQ_F_NO_FILE_TABLE_BIT,
> +	REQ_F_STACK_REQ_BIT,
>  
>  	/* not a real bit, just to check we're not overflowing the space */
>  	__REQ_F_LAST_BIT,
> @@ -580,6 +581,8 @@ enum {
>  	REQ_F_BUFFER_SELECTED	= BIT(REQ_F_BUFFER_SELECTED_BIT),
>  	/* doesn't need file table for this request */
>  	REQ_F_NO_FILE_TABLE	= BIT(REQ_F_NO_FILE_TABLE_BIT),
> +	/* on-stack req */
> +	REQ_F_STACK_REQ		= BIT(REQ_F_STACK_REQ_BIT),
>  };
>  
>  struct async_poll {
> @@ -695,10 +698,14 @@ struct io_op_def {
>  	unsigned		pollout : 1;
>  	/* op supports buffer selection */
>  	unsigned		buffer_select : 1;
> +	/* op can use stack req */
> +	unsigned		stack_req : 1;
>  };
>  
>  static const struct io_op_def io_op_defs[] = {
> -	[IORING_OP_NOP] = {},
> +	[IORING_OP_NOP] = {
> +		.stack_req		= 1,
> +	},
>  	[IORING_OP_READV] = {
>  		.async_ctx		= 1,
>  		.needs_mm		= 1,
> @@ -1345,7 +1352,8 @@ static void __io_req_aux_free(struct io_kiocb *req)
>  	if (req->flags & REQ_F_NEED_CLEANUP)
>  		io_cleanup_req(req);
>  
> -	kfree(req->io);
> +	if (req->io)
> +		kfree(req->io);
>  	if (req->file)
>  		io_put_file(req, req->file, (req->flags & REQ_F_FIXED_FILE));
>  	if (req->task)
> @@ -1370,6 +1378,8 @@ static void __io_free_req(struct io_kiocb *req)
>  	}
>  
>  	percpu_ref_put(&req->ctx->refs);
> +	if (req->flags & REQ_F_STACK_REQ)
> +		return;
>  	if (likely(!io_is_fallback_req(req)))
>  		kmem_cache_free(req_cachep, req);
>  	else
> @@ -5784,12 +5794,10 @@ static int io_init_req(struct io_ring_ctx *ctx, struct io_kiocb *req,
>  	 * link list.
>  	 */
>  	req->sequence = ctx->cached_sq_head - ctx->cached_sq_dropped;
> -	req->opcode = READ_ONCE(sqe->opcode);
>  	req->user_data = READ_ONCE(sqe->user_data);
>  	req->io = NULL;
>  	req->file = NULL;
>  	req->ctx = ctx;
> -	req->flags = 0;
>  	/* one is dropped after submission, the other at completion */
>  	refcount_set(&req->refs, 2);
>  	req->task = NULL;
> @@ -5839,6 +5847,7 @@ static int io_submit_sqes(struct io_ring_ctx *ctx, unsigned int nr,
>  {
>  	struct io_submit_state state, *statep = NULL;
>  	struct io_kiocb *link = NULL;
> +	struct io_kiocb stack_req;
>  	int i, submitted = 0;
>  
>  	/* if we have a backlog and couldn't flush it all, return BUSY */
> @@ -5865,20 +5874,31 @@ static int io_submit_sqes(struct io_ring_ctx *ctx, unsigned int nr,
>  	for (i = 0; i < nr; i++) {
>  		const struct io_uring_sqe *sqe;
>  		struct io_kiocb *req;
> -		int err;
> +		int err, op;
>  
>  		sqe = io_get_sqe(ctx);
>  		if (unlikely(!sqe)) {
>  			io_consume_sqe(ctx);
>  			break;
>  		}
> -		req = io_alloc_req(ctx, statep);
> -		if (unlikely(!req)) {
> -			if (!submitted)
> -				submitted = -EAGAIN;
> -			break;
> +
> +		op = READ_ONCE(sqe->opcode);
> +
> +		if (io_op_defs[op].stack_req) {
> +			req = &stack_req;
> +			req->flags = REQ_F_STACK_REQ;
> +		} else {
> +			req = io_alloc_req(ctx, statep);
> +			if (unlikely(!req)) {
> +				if (!submitted)
> +					submitted = -EAGAIN;
> +				break;
> +			}
> +			req->flags = 0;
>  		}
>  
> +		req->opcode = op;
> +
>  		err = io_init_req(ctx, req, sqe, statep, async);
>  		io_consume_sqe(ctx);
>  		/* will complete beyond this point, count as submitted */
> 

-- 
Pavel Begunkov
