Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C02692B3511
	for <lists+io-uring@lfdr.de>; Sun, 15 Nov 2020 14:37:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727120AbgKONgn (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sun, 15 Nov 2020 08:36:43 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41586 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727079AbgKONgn (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sun, 15 Nov 2020 08:36:43 -0500
Received: from mail-wr1-x441.google.com (mail-wr1-x441.google.com [IPv6:2a00:1450:4864:20::441])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 36488C0613D1
        for <io-uring@vger.kernel.org>; Sun, 15 Nov 2020 05:36:41 -0800 (PST)
Received: by mail-wr1-x441.google.com with SMTP id k2so15822741wrx.2
        for <io-uring@vger.kernel.org>; Sun, 15 Nov 2020 05:36:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=to:cc:references:from:autocrypt:subject:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=Mkvg6+vMWiwFCUwNfv+zjufTjyElSKDmJ0PzyPy8teo=;
        b=NLSgyivixZTJf41cLKBxuCnrTcXB4heLxZJRvVAVHyKx7JQztiE8Z34rsNcgrbeuN0
         koRq0TvkVCJKUvZ0WXONmPepTm8/g1++QzpRSijRY03TsjQ91xC8UQms4f1kxaxHuXq1
         BrcO3zi3JsT3Gc8xFN1yjLRUAzoQKHBW/7/uvRRu0SvE3qIFvXnHrbUXzgkyNlbhN4MC
         nd/DgOUE4NQiiih8vJv4khcuP5uRs8QSTMa8Jel1VtYMzrMqNbAsJdx7TJ9Ifn3Wr+LR
         OC3kHPcAtc8XQlDxTAGCWAkC+ZAwcfLkWAfO0Q2HSD0a60j1vijCJcjqL6olvPFOoePl
         dXFg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:to:cc:references:from:autocrypt:subject
         :message-id:date:user-agent:mime-version:in-reply-to
         :content-language:content-transfer-encoding;
        bh=Mkvg6+vMWiwFCUwNfv+zjufTjyElSKDmJ0PzyPy8teo=;
        b=RwYR4Om+c26dBovN/U85ECOgwBmmuqBb0iUcSZTvGpdyEdk38mMXuTRr1sitsxOIZc
         iOSTUteyjiAHYXdXwAHzqjbrRD43WAqhC6aVDnYZI21HyMtqEoAsbPWaRV1lApYIp9Ez
         dPZscxnz/7WbWSHBRNf1mKafACymNIGZBXWWKplYJSWYW8BOgU5LAzyHueNPi9IDdII+
         d+KdyakpT/oIy5I8edzOhLReDtoHvyI6pEcsdmxB1yzxUUnPimTkC7XNUdq/gevctPRy
         gmZUqNbR6Rdf1Cq5cLU37oZEJDwcNHGMW4ZP/iniQzoBDkoUhi9nD5qYDPGpmAg8ncLN
         mTMQ==
X-Gm-Message-State: AOAM531R6aIJabK5VKOl9SnT9nNtoHXhE27b7eJqgfzMi3HAxq013T+U
        hRfJV6HRc/Mq0KmLjQ3KY6tUMyQdQqm26g==
X-Google-Smtp-Source: ABdhPJzXKYIoBsq+0ip6rcIt6rLvDqlD2iIydVpqyTUhIPyFowyIjBr+VbJxBDehzDMBpX4ERF6Kbg==
X-Received: by 2002:adf:a54d:: with SMTP id j13mr14959328wrb.132.1605447399483;
        Sun, 15 Nov 2020 05:36:39 -0800 (PST)
Received: from [192.168.1.33] (host109-152-100-135.range109-152.btcentralplus.com. [109.152.100.135])
        by smtp.gmail.com with ESMTPSA id a12sm18016557wrr.31.2020.11.15.05.36.38
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 15 Nov 2020 05:36:38 -0800 (PST)
To:     Bijan Mottahedeh <bijan.mottahedeh@oracle.com>, axboe@kernel.dk
Cc:     io-uring@vger.kernel.org
References: <1605222042-44558-1-git-send-email-bijan.mottahedeh@oracle.com>
 <1605222042-44558-5-git-send-email-bijan.mottahedeh@oracle.com>
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
Subject: Re: [PATCH 4/8] io_uring: implement fixed buffers registration
 similar to fixed files
Message-ID: <1e23c177-2be8-4046-c1ea-7ab263132bb5@gmail.com>
Date:   Sun, 15 Nov 2020 13:33:32 +0000
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.3.0
MIME-Version: 1.0
In-Reply-To: <1605222042-44558-5-git-send-email-bijan.mottahedeh@oracle.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 12/11/2020 23:00, Bijan Mottahedeh wrote:
> Apply fixed_rsrc functionality for fixed buffers support.

I don't get it, requests with fixed files take a ref to a node (see
fixed_file_refs) and put it on free, but I don't see anything similar
here. Did you work around it somehow?

That's not critical for this particular patch as you still do full
quisce in __io_uring_register(), but IIRC was essential for
update/remove requests.

> 
> Signed-off-by: Bijan Mottahedeh <bijan.mottahedeh@oracle.com>
> ---
>  fs/io_uring.c | 294 +++++++++++++++++++++++++++++++++++++++++++++++++++-------
>  1 file changed, 258 insertions(+), 36 deletions(-)
> 
> diff --git a/fs/io_uring.c b/fs/io_uring.c
> index 974a619..de0019e 100644
> --- a/fs/io_uring.c
> +++ b/fs/io_uring.c
> @@ -104,6 +104,14 @@
>  #define IORING_MAX_RESTRICTIONS	(IORING_RESTRICTION_LAST + \
>  				 IORING_REGISTER_LAST + IORING_OP_LAST)
>  
> +/*
> + * Shift of 7 is 128 entries, or exactly one page on 64-bit archs
> + */
> +#define IORING_BUF_TABLE_SHIFT	7	/* struct io_mapped_ubuf */
> +#define IORING_MAX_BUFS_TABLE	(1U << IORING_BUF_TABLE_SHIFT)
> +#define IORING_BUF_TABLE_MASK	(IORING_MAX_BUFS_TABLE - 1)
> +#define IORING_MAX_FIXED_BUFS	UIO_MAXIOV
> +
>  struct io_uring {
>  	u32 head ____cacheline_aligned_in_smp;
>  	u32 tail ____cacheline_aligned_in_smp;
> @@ -338,8 +346,8 @@ struct io_ring_ctx {
>  	unsigned		nr_user_files;
>  
>  	/* if used, fixed mapped user buffers */
> +	struct fixed_rsrc_data	*buf_data;
>  	unsigned		nr_user_bufs;
> -	struct io_mapped_ubuf	*user_bufs;
>  
>  	struct user_struct	*user;
>  
> @@ -401,6 +409,9 @@ struct io_ring_ctx {
>  	struct delayed_work		file_put_work;
>  	struct llist_head		file_put_llist;
>  
> +	struct delayed_work		buf_put_work;
> +	struct llist_head		buf_put_llist;
> +
>  	struct work_struct		exit_work;
>  	struct io_restriction		restrictions;
>  };
> @@ -1019,6 +1030,7 @@ static struct file *io_file_get(struct io_submit_state *state,
>  				struct io_kiocb *req, int fd, bool fixed);
>  static void __io_queue_sqe(struct io_kiocb *req, struct io_comp_state *cs);
>  static void io_file_put_work(struct work_struct *work);
> +static void io_buf_put_work(struct work_struct *work);
>  
>  static ssize_t io_import_iovec(int rw, struct io_kiocb *req,
>  			       struct iovec **iovec, struct iov_iter *iter,
> @@ -1318,6 +1330,8 @@ static struct io_ring_ctx *io_ring_ctx_alloc(struct io_uring_params *p)
>  	INIT_LIST_HEAD(&ctx->inflight_list);
>  	INIT_DELAYED_WORK(&ctx->file_put_work, io_file_put_work);
>  	init_llist_head(&ctx->file_put_llist);
> +	INIT_DELAYED_WORK(&ctx->buf_put_work, io_buf_put_work);
> +	init_llist_head(&ctx->buf_put_llist);
>  	return ctx;
>  err:
>  	if (ctx->fallback_req)
> @@ -2949,6 +2963,15 @@ static void kiocb_done(struct kiocb *kiocb, ssize_t ret,
>  		io_rw_done(kiocb, ret);
>  }
>  
> +static inline struct io_mapped_ubuf *io_buf_from_index(struct io_ring_ctx *ctx,
> +						       int index)
> +{
> +	struct fixed_rsrc_table *table;
> +
> +	table = &ctx->buf_data->table[index >> IORING_BUF_TABLE_SHIFT];
> +	return &table->bufs[index & IORING_BUF_TABLE_MASK];
> +}
> +
>  static ssize_t io_import_fixed(struct io_kiocb *req, int rw,
>  			       struct iov_iter *iter)
>  {
> @@ -2959,10 +2982,15 @@ static ssize_t io_import_fixed(struct io_kiocb *req, int rw,
>  	size_t offset;
>  	u64 buf_addr;
>  
> +	/* attempt to use fixed buffers without having provided iovecs */
> +	if (unlikely(!ctx->buf_data))
> +		return -EFAULT;
> +
> +	buf_index = req->buf_index;
>  	if (unlikely(buf_index >= ctx->nr_user_bufs))
>  		return -EFAULT;
>  	index = array_index_nospec(buf_index, ctx->nr_user_bufs);
> -	imu = &ctx->user_bufs[index];
> +	imu = io_buf_from_index(ctx, index);
>  	buf_addr = req->rw.addr;
>  
>  	/* overflow */
> @@ -8167,28 +8195,73 @@ static unsigned long ring_pages(unsigned sq_entries, unsigned cq_entries)
>  	return pages;
>  }
>  
> -static int io_sqe_buffers_unregister(struct io_ring_ctx *ctx)
> +static void io_buffer_unmap(struct io_ring_ctx *ctx, struct io_mapped_ubuf *imu)
>  {
> -	int i, j;
> +	unsigned i;
>  
> -	if (!ctx->user_bufs)
> -		return -ENXIO;
> +	for (i = 0; i < imu->nr_bvecs; i++)
> +		unpin_user_page(imu->bvec[i].bv_page);
>  
> -	for (i = 0; i < ctx->nr_user_bufs; i++) {
> -		struct io_mapped_ubuf *imu = &ctx->user_bufs[i];
> +	if (imu->acct_pages)
> +		io_unaccount_mem(ctx, imu->nr_bvecs, ACCT_PINNED);
> +	kvfree(imu->bvec);
> +	imu->nr_bvecs = 0;
> +}
>  
> -		for (j = 0; j < imu->nr_bvecs; j++)
> -			unpin_user_page(imu->bvec[j].bv_page);
> +static void io_buffers_unmap(struct io_ring_ctx *ctx)
> +{
> +	unsigned i;
> +	struct io_mapped_ubuf *imu;
>  
> -		if (imu->acct_pages)
> -			io_unaccount_mem(ctx, imu->acct_pages, ACCT_PINNED);
> -		kvfree(imu->bvec);
> -		imu->nr_bvecs = 0;
> +	for (i = 0; i < ctx->nr_user_bufs; i++) {
> +		imu = io_buf_from_index(ctx, i);
> +		io_buffer_unmap(ctx, imu);
>  	}
> +}
> +
> +static void io_buffers_map_free(struct io_ring_ctx *ctx)
> +{
> +	struct fixed_rsrc_data *data = ctx->buf_data;
> +	unsigned nr_tables, i;
> +
> +	if (!data)
> +		return;
>  
> -	kfree(ctx->user_bufs);
> -	ctx->user_bufs = NULL;
> +	nr_tables = DIV_ROUND_UP(ctx->nr_user_bufs, IORING_MAX_BUFS_TABLE);
> +	for (i = 0; i < nr_tables; i++)
> +		kfree(data->table[i].bufs);
> +	kfree(data->table);
> +	percpu_ref_exit(&data->refs);
> +	kfree(data);
> +	ctx->buf_data = NULL;
>  	ctx->nr_user_bufs = 0;
> +}
> +
> +static int io_sqe_buffers_unregister(struct io_ring_ctx *ctx)
> +{
> +	struct fixed_rsrc_data *data = ctx->buf_data;
> +	struct fixed_rsrc_ref_node *ref_node = NULL;
> +
> +	if (!data)
> +		return -ENXIO;
> +
> +	spin_lock(&data->lock);
> +	if (!list_empty(&data->ref_list))
> +		ref_node = list_first_entry(&data->ref_list,
> +					    struct fixed_rsrc_ref_node, node);
> +	spin_unlock(&data->lock);
> +	if (ref_node)
> +		percpu_ref_kill(&ref_node->refs);
> +
> +	percpu_ref_kill(&data->refs);
> +
> +	/* wait for all refs nodes to complete */
> +	flush_delayed_work(&ctx->buf_put_work);
> +	wait_for_completion(&data->done);
> +
> +	io_buffers_unmap(ctx);
> +	io_buffers_map_free(ctx);
> +
>  	return 0;
>  }
>  
> @@ -8241,7 +8314,13 @@ static bool headpage_already_acct(struct io_ring_ctx *ctx, struct page **pages,
>  
>  	/* check previously registered pages */
>  	for (i = 0; i < ctx->nr_user_bufs; i++) {
> -		struct io_mapped_ubuf *imu = &ctx->user_bufs[i];
> +		struct fixed_rsrc_table *table;
> +		struct io_mapped_ubuf *imu;
> +		unsigned index;
> +
> +		table = &ctx->buf_data->table[i >> IORING_BUF_TABLE_SHIFT];
> +		index = i & IORING_BUF_TABLE_MASK;
> +		imu = &table->bufs[index];
>  
>  		for (j = 0; j < imu->nr_bvecs; j++) {
>  			if (!PageCompound(imu->bvec[j].bv_page))
> @@ -8376,19 +8455,82 @@ static int io_sqe_buffer_register(struct io_ring_ctx *ctx, struct iovec *iov,
>  	return ret;
>  }
>  
> -static int io_buffers_map_alloc(struct io_ring_ctx *ctx, unsigned int nr_args)
> +static void io_free_buf_tables(struct fixed_rsrc_data *buf_data,
> +			       unsigned nr_tables)
>  {
> -	if (ctx->user_bufs)
> -		return -EBUSY;
> -	if (!nr_args || nr_args > UIO_MAXIOV)
> -		return -EINVAL;
> +	int i;
>  
> -	ctx->user_bufs = kcalloc(nr_args, sizeof(struct io_mapped_ubuf),
> -					GFP_KERNEL);
> -	if (!ctx->user_bufs)
> -		return -ENOMEM;
> +	for (i = 0; i < nr_tables; i++) {
> +		struct fixed_rsrc_table *table = &buf_data->table[i];
> +		kfree(table->bufs);
> +	}
> +}
>  
> -	return 0;
> +static int io_alloc_buf_tables(struct fixed_rsrc_data *buf_data,
> +			       unsigned nr_tables, unsigned nr_bufs)
> +{
> +	int i;
> +		
> +	for (i = 0; i < nr_tables; i++) {
> +		struct fixed_rsrc_table *table = &buf_data->table[i];
> +		unsigned this_bufs;
> +
> +		this_bufs = min(nr_bufs, IORING_MAX_BUFS_TABLE);
> +		table->bufs = kcalloc(this_bufs, sizeof(struct io_mapped_ubuf),
> +				      GFP_KERNEL);
> +		if (!table->bufs)
> +			break;
> +		nr_bufs -= this_bufs;
> +	}
> +
> +	if (i == nr_tables)
> +		return 0;
> +
> +	io_free_buf_tables(buf_data, nr_tables);
> +	return 1;
> +}
> +
> +static struct fixed_rsrc_data *io_buffers_map_alloc(struct io_ring_ctx *ctx,
> +						    unsigned int nr_args)
> +{
> +	unsigned nr_tables;
> +	struct fixed_rsrc_data *buf_data;
> +	int ret = -ENOMEM;
> +
> +	if (ctx->buf_data)
> +		return ERR_PTR(-EBUSY);
> +	if (!nr_args || nr_args > IORING_MAX_FIXED_BUFS)
> +		return ERR_PTR(-EINVAL);
> +
> +	buf_data = kzalloc(sizeof(*ctx->buf_data), GFP_KERNEL);
> +	if (!buf_data)
> +		return ERR_PTR(-ENOMEM);
> +	buf_data->ctx = ctx;
> +	init_completion(&buf_data->done);
> +	INIT_LIST_HEAD(&buf_data->ref_list);
> +	spin_lock_init(&buf_data->lock);
> +
> +	nr_tables = DIV_ROUND_UP(nr_args, IORING_MAX_BUFS_TABLE);
> +	buf_data->table = kcalloc(nr_tables, sizeof(buf_data->table),
> +				  GFP_KERNEL);
> +	if (!buf_data->table)
> +		goto out_free;
> +
> +	if (percpu_ref_init(&buf_data->refs, io_rsrc_ref_kill,
> +			    PERCPU_REF_ALLOW_REINIT, GFP_KERNEL))
> +		goto out_free;
> +
> +	if (io_alloc_buf_tables(buf_data, nr_tables, nr_args))
> +		goto out_ref;
> +
> +	return buf_data;
> +
> +out_ref:
> +	percpu_ref_exit(&buf_data->refs);
> +out_free:
> +	kfree(buf_data->table);
> +	kfree(buf_data);
> +	return ERR_PTR(ret);
>  }
>  
>  static int io_buffer_validate(struct iovec *iov)
> @@ -8408,39 +8550,119 @@ static int io_buffer_validate(struct iovec *iov)
>  	return 0;
>  }
>  
> +static void io_buf_put_work(struct work_struct *work)
> +{
> +	struct io_ring_ctx *ctx;
> +	struct llist_node *node;
> +
> +	ctx = container_of(work, struct io_ring_ctx, buf_put_work.work);
> +	node = llist_del_all(&ctx->buf_put_llist);
> +	io_rsrc_put_work(node);
> +}
> +
> +static void io_buf_data_ref_zero(struct percpu_ref *ref)
> +{
> +	struct fixed_rsrc_ref_node *ref_node;
> +	struct io_ring_ctx *ctx;
> +	bool first_add;
> +	int delay = HZ;
> +
> +	ref_node = container_of(ref, struct fixed_rsrc_ref_node, refs);
> +	ctx = ref_node->rsrc_data->ctx;
> +
> +	if (percpu_ref_is_dying(&ctx->buf_data->refs))
> +		delay = 0;
> +
> +	first_add = llist_add(&ref_node->llist, &ctx->buf_put_llist);
> +	if (!delay)
> +		mod_delayed_work(system_wq, &ctx->buf_put_work, 0);
> +	else if (first_add)
> +		queue_delayed_work(system_wq, &ctx->buf_put_work, delay);
> +}
> +
> +static void io_ring_buf_put(struct io_ring_ctx *ctx, struct io_rsrc_put *prsrc)
> +{
> +	io_buffer_unmap(ctx, prsrc->buf);
> +}
> +
> +static struct fixed_rsrc_ref_node *alloc_fixed_buf_ref_node(
> +			struct io_ring_ctx *ctx)
> +{
> +	struct fixed_rsrc_ref_node *ref_node;
> +
> +	ref_node = kzalloc(sizeof(*ref_node), GFP_KERNEL);
> +	if (!ref_node)
> +		return ERR_PTR(-ENOMEM);
> +
> +	if (percpu_ref_init(&ref_node->refs, io_buf_data_ref_zero,
> +			    0, GFP_KERNEL)) {
> +		kfree(ref_node);
> +		return ERR_PTR(-ENOMEM);
> +	}
> +	INIT_LIST_HEAD(&ref_node->node);
> +	INIT_LIST_HEAD(&ref_node->rsrc_list);
> +	ref_node->rsrc_data = ctx->buf_data;
> +	ref_node->rsrc_put = io_ring_buf_put;
> +	return ref_node;
> +}
> +
>  static int io_sqe_buffers_register(struct io_ring_ctx *ctx, void __user *arg,
>  				   unsigned int nr_args)
>  {
>  	int i, ret;
>  	struct iovec iov;
>  	struct page *last_hpage = NULL;
> +	struct fixed_rsrc_ref_node *ref_node;
> +	struct fixed_rsrc_data *buf_data;
>  
> -	ret = io_buffers_map_alloc(ctx, nr_args);
> -	if (ret)
> -		return ret;
> +	buf_data = io_buffers_map_alloc(ctx, nr_args);
> +	if (IS_ERR(buf_data))
> +		return PTR_ERR(buf_data);
>  
> -	for (i = 0; i < nr_args; i++) {
> -		struct io_mapped_ubuf *imu = &ctx->user_bufs[i];
> +	for (i = 0; i < nr_args; i++, ctx->nr_user_bufs++) {
> +		struct fixed_rsrc_table *table;
> +		struct io_mapped_ubuf *imu;
> +		unsigned index;
>  
>  		ret = io_copy_iov(ctx, &iov, arg, i);
>  		if (ret)
>  			break;
>  
> +		/* allow sparse sets */
> +		if (!iov.iov_base && !iov.iov_len)
> +			continue;
> +
>  		ret = io_buffer_validate(&iov);
>  		if (ret)
>  			break;
>  
> +		table = &buf_data->table[i >> IORING_BUF_TABLE_SHIFT];
> +		index = i & IORING_BUF_TABLE_MASK;
> +		imu = &table->bufs[index];
> +
>  		ret = io_sqe_buffer_register(ctx, &iov, imu, &last_hpage);
>  		if (ret)
>  			break;
> +	}
>  
> -		ctx->nr_user_bufs++;
> +	ctx->buf_data = buf_data;
> +	if (ret) {
> +		io_sqe_buffers_unregister(ctx);
> +		return ret;
>  	}
>  
> -	if (ret)
> +	ref_node = alloc_fixed_buf_ref_node(ctx);
> +	if (IS_ERR(ref_node)) {
>  		io_sqe_buffers_unregister(ctx);
> +		return PTR_ERR(ref_node);
> +	}
>  
> -	return ret;
> +	buf_data->node = ref_node;
> +	spin_lock(&buf_data->lock);
> +	list_add(&ref_node->node, &buf_data->ref_list);
> +	spin_unlock(&buf_data->lock);
> +	percpu_ref_get(&buf_data->refs);
> +	return 0;
>  }
>  
>  static int io_eventfd_register(struct io_ring_ctx *ctx, void __user *arg)
> @@ -9217,7 +9439,7 @@ static void __io_uring_show_fdinfo(struct io_ring_ctx *ctx, struct seq_file *m)
>  	}
>  	seq_printf(m, "UserBufs:\t%u\n", ctx->nr_user_bufs);
>  	for (i = 0; has_lock && i < ctx->nr_user_bufs; i++) {
> -		struct io_mapped_ubuf *buf = &ctx->user_bufs[i];
> +		struct io_mapped_ubuf *buf = io_buf_from_index(ctx, i);
>  
>  		seq_printf(m, "%5u: 0x%llx/%u\n", i, buf->ubuf,
>  						(unsigned int) buf->len);
> 

-- 
Pavel Begunkov
