Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D1E95357A67
	for <lists+io-uring@lfdr.de>; Thu,  8 Apr 2021 04:32:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229558AbhDHCck (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 7 Apr 2021 22:32:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36746 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229505AbhDHCck (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 7 Apr 2021 22:32:40 -0400
Received: from mail-wr1-x433.google.com (mail-wr1-x433.google.com [IPv6:2a00:1450:4864:20::433])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 84758C061760
        for <io-uring@vger.kernel.org>; Wed,  7 Apr 2021 19:32:29 -0700 (PDT)
Received: by mail-wr1-x433.google.com with SMTP id s7so264924wru.6
        for <io-uring@vger.kernel.org>; Wed, 07 Apr 2021 19:32:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:from:to:references:autocrypt:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=rhjdClddiLuYd1+F7XCIft4jFTYBq1xWxC+Xml7Q37A=;
        b=QxituHd69xkyIGxF0Vnc0vs6NLTuIHhUhitmn0HxrqL+fwsdtWkknjngMvyGxxSDq7
         /LcvnJEoC/ItUwje2T7j36YC9r/FWL72U/MCyOxLGACLV7/JbwJwoOrX780kG636uCGC
         jA5IM0S7gsiWf59DBoFEDEEmG6vMkjwGUe+cZ5HeM8WhzYzmYSmHIFOg7WFbJGrtm83Y
         lBw6A6k1DfJwtkwkrdqBvBvP7k0bSkfMtBq7lhQSOBo86usuz28JVj2yS0laaiJIVzIh
         5Z72iHCe5zGQHBn/Iqr/Rgspxlsarjgmh/XYpnkmJPjltkhwYtOuSBzAS9LLYtYavi+j
         rAKw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:references:autocrypt:message-id
         :date:user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=rhjdClddiLuYd1+F7XCIft4jFTYBq1xWxC+Xml7Q37A=;
        b=lHSQSmUedS3dAu/1NWmNJe2j29PK3yAO+dgVnL7oQEIswB77mX6DIonOhPS+fsOnox
         mAB9EeRiafX7ITjnLtUc1WhPK1sNEIr3k902YcCfgwuAMCs5fUT4WvgvitZlHV4z7SBc
         RhHEOIgkPcwQDRAJvx7gB80LP3unkpFD0bbZdjxiq4zUnxN6BDXHuOa3GojYVK6W/ewy
         IrpF/47EuYP3cjluTbzreMNOQUY23GSaTM3dMydx65/s+bil0ibwF6iJfjJv7wUtESI9
         tfwVsI+EfbR56yx/nKIFZQH+rB8mm1dKt7De60qg5npHDqFp8JtFtW5HnMT/yr4Faqri
         tgbg==
X-Gm-Message-State: AOAM5302CyLdr9gdYYcWzu5Gl8+Mu3pSSLkyPVrF7cFyciCDiH8ahEnw
        GGV7A9cpVFZOvGPJAi8iE1RF5xx3G7KaTw==
X-Google-Smtp-Source: ABdhPJy2aa9gfnK3qJeHMMaVnaKAyN+hoAL2jDphMfdOY9tTaX32f4Jsj0lRc2mB2ftWN3zRSAEdoQ==
X-Received: by 2002:a5d:6a4a:: with SMTP id t10mr37971wrw.422.1617849148066;
        Wed, 07 Apr 2021 19:32:28 -0700 (PDT)
Received: from [192.168.8.155] ([148.252.132.202])
        by smtp.gmail.com with ESMTPSA id n2sm11492388wrq.59.2021.04.07.19.32.27
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 07 Apr 2021 19:32:27 -0700 (PDT)
Subject: Re: [PATCH 3/4] io_uring: fix poll_rewait racing for ->canceled
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
References: <cover.1617842918.git.asml.silence@gmail.com>
 <f6d92429952fbcb27eed4236238564d84e0f26cc.1617842918.git.asml.silence@gmail.com>
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
Message-ID: <04bcd0c7-4e13-a0eb-ebcd-e6abf08234e1@gmail.com>
Date:   Thu, 8 Apr 2021 03:28:22 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.3.0
MIME-Version: 1.0
In-Reply-To: <f6d92429952fbcb27eed4236238564d84e0f26cc.1617842918.git.asml.silence@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 08/04/2021 01:54, Pavel Begunkov wrote:
> poll->canceled may be set from different contexts, even async, so
> io_poll_rewait() should be prepared that it can change and not read it
> twice.

Please disregard this one, apparently it's not a bug and will get in
my way letter. Other 3 are fine.

> 
> Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
> ---
>  fs/io_uring.c | 5 +++--
>  1 file changed, 3 insertions(+), 2 deletions(-)
> 
> diff --git a/fs/io_uring.c b/fs/io_uring.c
> index de5822350345..376d9c875dc2 100644
> --- a/fs/io_uring.c
> +++ b/fs/io_uring.c
> @@ -4897,15 +4897,16 @@ static bool io_poll_rewait(struct io_kiocb *req, struct io_poll_iocb *poll)
>  	__acquires(&req->ctx->completion_lock)
>  {
>  	struct io_ring_ctx *ctx = req->ctx;
> +	bool canceled = READ_ONCE(poll->canceled);
>  
> -	if (!req->result && !READ_ONCE(poll->canceled)) {
> +	if (!req->result && !canceled) {
>  		struct poll_table_struct pt = { ._key = poll->events };
>  
>  		req->result = vfs_poll(req->file, &pt) & poll->events;
>  	}
>  
>  	spin_lock_irq(&ctx->completion_lock);
> -	if (!req->result && !READ_ONCE(poll->canceled)) {
> +	if (!req->result && !canceled) {
>  		add_wait_queue(poll->head, &poll->wait);
>  		return true;
>  	}
> 

-- 
Pavel Begunkov
