Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 420A5358BAE
	for <lists+io-uring@lfdr.de>; Thu,  8 Apr 2021 19:48:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232476AbhDHRsd (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 8 Apr 2021 13:48:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39838 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232281AbhDHRsd (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 8 Apr 2021 13:48:33 -0400
Received: from mail-wr1-x433.google.com (mail-wr1-x433.google.com [IPv6:2a00:1450:4864:20::433])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8726BC061760
        for <io-uring@vger.kernel.org>; Thu,  8 Apr 2021 10:48:21 -0700 (PDT)
Received: by mail-wr1-x433.google.com with SMTP id q26so3028048wrz.9
        for <io-uring@vger.kernel.org>; Thu, 08 Apr 2021 10:48:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:from:to:references:autocrypt:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=GR8dF7xzEFN4VnQ5G1QUEeGW8MH+25NE9I5fNOzkjsk=;
        b=gUWwU8u5mDkUlRQqSNXgmOIPQQwRAqB50ruMwZAXAgH9FFXRGw+s+9DT22DB2utsHq
         EWY2DL9AtScTh0ze1hvoYeeWuMZ7u3SirTkV2EUZwWM82ewXa0pyVhlLNoLVkgrj0lAv
         WpUsOF1ui4ekdKpZ1zLhN4/HXg9fMOLfhjNGE2juDkvJwT7BRPcuM1y3AzSgDnNt2xmV
         vRSrVtOy1tIJf2789yDXC9zTGUY/mXMcQDznXMdtxMhy7hN9u+hV22oAUHKZEdXo8nep
         1NbMQRvFb9lq8leDL8DUCRkHhtjLRP6lWRAdW4Yb0QhCksquPzm5XpOf7gZrQTdrOLbt
         CEcg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:references:autocrypt:message-id
         :date:user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=GR8dF7xzEFN4VnQ5G1QUEeGW8MH+25NE9I5fNOzkjsk=;
        b=fTfzuJToF/3PQVuk8A4Oabf/yOrarVJX3Kp+sKJvoDw+c7/hxGChlwm4GBE9MEZ4cF
         iSxxN45Nx8/XkcE2wH9z22Juzua+Tzn8sF349umPrVrD64odrNw1tMzsFpxhtDInbMcV
         vcYK1B/s4y6cjQwt3KxUQr4EB9NG8s6pmRgX9/Nkd4ckPGDHSKcmFBlhEe/Tb3beva/B
         H61ppZTLpV1OMfM8PSzZvXS1vT3bR215sxNn9W+gMVRyhOTflFPxPkS4wRO3U/cC/xJO
         fhIOyq5MHEyGO2zv57QeH7SqkcLrrnVKiES1M6qqWPibw3oO5M/KOhCuYBO40gSW8sL9
         G7+Q==
X-Gm-Message-State: AOAM532NmqXpCXCLi9yivgRvcCrRULaGB7DUW778A2QGFz3foCoLzXfC
        rJUPNJF0vljgR2ImXnQKNFRc77odAyQaXw==
X-Google-Smtp-Source: ABdhPJzpzYMXyZ8IHZs6tYVSpQum29w6LIRAAMf7Xbw3epWKR/c5E20R4z1dJxeV2nzo5PPGQciaPw==
X-Received: by 2002:a5d:5407:: with SMTP id g7mr13313244wrv.163.1617904100000;
        Thu, 08 Apr 2021 10:48:20 -0700 (PDT)
Received: from [192.168.8.158] ([148.252.128.224])
        by smtp.gmail.com with ESMTPSA id u63sm14703528wmg.24.2021.04.08.10.48.18
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 08 Apr 2021 10:48:19 -0700 (PDT)
Subject: Re: [PATCH 5.12 v2] io_uring: fix rw req completion
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
References: <a1db1d9603cf6abb6de51a58fe6e966c7ea1e5d3.1617903478.git.asml.silence@gmail.com>
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
Message-ID: <27994eed-e8aa-266b-d521-fed2ced6e6aa@gmail.com>
Date:   Thu, 8 Apr 2021 18:44:13 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.3.0
MIME-Version: 1.0
In-Reply-To: <a1db1d9603cf6abb6de51a58fe6e966c7ea1e5d3.1617903478.git.asml.silence@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 08/04/2021 18:40, Pavel Begunkov wrote:
> WARNING: at fs/io_uring.c:8578 io_ring_exit_work.cold+0x0/0x18
> 
> As reissuing is now passed back by REQ_F_REISSUE, kiocb_done() may just
> set the flag and do nothing leaving dangling requests. The handling is a
> bit fragile, e.g. can't just complete them because the case of reading
> beyond file boundary needs blocking context to return 0, otherwise it
> may be -EAGAIN.
> 
> Go the easy way for now, just emulate how it was by io_rw_reissue() in
> kiocb_done()

Need to adjust the message a bit, will resend

> 
> Fixes: 230d50d448ac ("io_uring: move reissue into regular IO path")
> Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
> Link: https://lore.kernel.org/r/f602250d292f8a84cca9a01d747744d1e797be26.1617842918.git.asml.silence@gmail.com
> Signed-off-by: Jens Axboe <axboe@kernel.dk>
> ---
> 
> v2: io_rw_reissue() may fail, check return code
> 
>  fs/io_uring.c | 13 +++++++++++++
>  1 file changed, 13 insertions(+)
> 
> diff --git a/fs/io_uring.c b/fs/io_uring.c
> index f1881ac0744b..f2df0569a60a 100644
> --- a/fs/io_uring.c
> +++ b/fs/io_uring.c
> @@ -2762,6 +2762,7 @@ static void kiocb_done(struct kiocb *kiocb, ssize_t ret,
>  {
>  	struct io_kiocb *req = container_of(kiocb, struct io_kiocb, rw.kiocb);
>  	struct io_async_rw *io = req->async_data;
> +	bool check_reissue = (kiocb->ki_complete == io_complete_rw);
>  
>  	/* add previously done IO, if any */
>  	if (io && io->bytes_done > 0) {
> @@ -2777,6 +2778,18 @@ static void kiocb_done(struct kiocb *kiocb, ssize_t ret,
>  		__io_complete_rw(req, ret, 0, issue_flags);
>  	else
>  		io_rw_done(kiocb, ret);
> +
> +	if (check_reissue && req->flags & REQ_F_REISSUE) {
> +		req->flags &= ~REQ_F_REISSUE;
> +		if (!io_rw_reissue(req)) {
> +			int cflags = 0;
> +
> +			req_set_fail_links(req);
> +			if (req->flags & REQ_F_BUFFER_SELECTED)
> +				cflags = io_put_rw_kbuf(req);
> +			__io_req_complete(req, issue_flags, ret, cflags);
> +		}
> +	}
>  }
>  
>  static int io_import_fixed(struct io_kiocb *req, int rw, struct iov_iter *iter)
> 

-- 
Pavel Begunkov
