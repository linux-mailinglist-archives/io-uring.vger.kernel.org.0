Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7C8C731F91A
	for <lists+io-uring@lfdr.de>; Fri, 19 Feb 2021 13:13:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230038AbhBSMKe (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 19 Feb 2021 07:10:34 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41542 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229959AbhBSMKb (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 19 Feb 2021 07:10:31 -0500
Received: from mail-wr1-x42e.google.com (mail-wr1-x42e.google.com [IPv6:2a00:1450:4864:20::42e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CE670C061574;
        Fri, 19 Feb 2021 04:09:49 -0800 (PST)
Received: by mail-wr1-x42e.google.com with SMTP id v15so8128917wrx.4;
        Fri, 19 Feb 2021 04:09:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=to:cc:references:from:autocrypt:subject:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=mLZ7yE0qPJLT/6EKNn4r5XPFKjIt+psxXa9UkDGVnKc=;
        b=fNA7dP2fsBVPLkSM6nOIWpVODiILiveTKWQgk1pDTW++JjewaoHJSRRAFJJOnpfj+y
         KP5e9O6SlljcQsCfB8rADFopS04gB+ViR5Y1aA8zVNQN1skW6EBVKAsNRDAbR7RUJFcu
         sGusZ9ShtGaKjt54OsnQqxs1+NfW48evAl4LfR40G2+ZT5JE/hbNSiuRRj0vl5igVOsE
         iZIWyPH1IBPaSFuHcTzWmI1tQMLCaX7D1mx6Ek5K4sK6XZZGEYmbRVmCCKs0fGlu6XwT
         T+b82RuN4C2JfG14CccKSRQNkWa7obRDuF1l/hC2O6YX2rysnFdckRpyiX6rmxvtziRo
         bl2A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:to:cc:references:from:autocrypt:subject
         :message-id:date:user-agent:mime-version:in-reply-to
         :content-language:content-transfer-encoding;
        bh=mLZ7yE0qPJLT/6EKNn4r5XPFKjIt+psxXa9UkDGVnKc=;
        b=tG8juY1SIp6qkre25Bz58ac/PY4g/oBr0aePsSMInIhM1fQ4U4ZaZFUimwCdY2qfHg
         qDOaFo4PzIurPg8BPuJwov2RSuvJltqDtD+caF0lGk3DnJFunZK6uBjWuBOVvtcdA5qs
         0AtlltX7G3oPFgWOa3qZpKIJY/Z9do+ImZezZfPGOIpkQlNUxwij4hgx46qVzyd+2W9Z
         z2P0SVgquqjXeJUbQLtJuWxB2sIcxlXSge3Pp7d4tL6IDTDeuwklwdxSvkBGB6hnLwJG
         0P/noe1myrvHYxC1AlHzqRlzsiUvhzhO9k3tMI0GSnv5S6MEIOTyOYmNQCvByQUnK9z4
         zKtQ==
X-Gm-Message-State: AOAM530fa3BWw3Lc+mKE79byWqIeCZnJwiJ8mlSl+DfD5xntSWVYPmNv
        e3PdPD+1prsRIM0poMzb99tu0ZuXxfKdcg==
X-Google-Smtp-Source: ABdhPJxo94ZvKaUPPhVRMJZC0BPQb6rbv3V0H0prGyFYfR1uG8dqe5AVlN1HpZ+VOif8XDkUWlzi0Q==
X-Received: by 2002:a5d:570a:: with SMTP id a10mr9133048wrv.70.1613736588573;
        Fri, 19 Feb 2021 04:09:48 -0800 (PST)
Received: from [192.168.8.137] ([85.255.236.139])
        by smtp.gmail.com with ESMTPSA id x18sm12603082wrs.16.2021.02.19.04.09.47
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 19 Feb 2021 04:09:48 -0800 (PST)
To:     Lennert Buytenhek <buytenh@wantstofly.org>,
        Jens Axboe <axboe@kernel.dk>,
        Al Viro <viro@zeniv.linux.org.uk>,
        linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        io-uring@vger.kernel.org
Cc:     David Laight <David.Laight@aculab.com>,
        Matthew Wilcox <willy@infradead.org>
References: <20210218122640.GA334506@wantstofly.org>
 <20210218122755.GC334506@wantstofly.org>
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
Subject: Re: [PATCH v3 2/2] io_uring: add support for IORING_OP_GETDENTS
Message-ID: <9a6fb59b-be85-c36b-3c83-26cff37bcb87@gmail.com>
Date:   Fri, 19 Feb 2021 12:05:58 +0000
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.3.0
MIME-Version: 1.0
In-Reply-To: <20210218122755.GC334506@wantstofly.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 18/02/2021 12:27, Lennert Buytenhek wrote:
> IORING_OP_GETDENTS behaves much like getdents64(2) and takes the same
> arguments, but with a small twist: it takes an additional offset
> argument, and reading from the specified directory starts at the given
> offset.
> 
> For the first IORING_OP_GETDENTS call on a directory, the offset
> parameter can be set to zero, and for subsequent calls, it can be
> set to the ->d_off field of the last struct linux_dirent64 returned
> by the previous IORING_OP_GETDENTS call.
> 
> Internally, if necessary, IORING_OP_GETDENTS will vfs_llseek() to
> the right directory position before calling vfs_getdents().
> 
> IORING_OP_GETDENTS may or may not update the specified directory's
> file offset, and the file offset should not be relied upon having
> any particular value during or after an IORING_OP_GETDENTS call.
> 
> Signed-off-by: Lennert Buytenhek <buytenh@wantstofly.org>
> ---
>  fs/io_uring.c                 | 73 +++++++++++++++++++++++++++++++++++
>  include/uapi/linux/io_uring.h |  1 +
>  2 files changed, 74 insertions(+)
> 
> diff --git a/fs/io_uring.c b/fs/io_uring.c
> index 056bd4c90ade..6853bf48369a 100644
> --- a/fs/io_uring.c
> +++ b/fs/io_uring.c
> @@ -635,6 +635,13 @@ struct io_mkdir {
>  	struct filename			*filename;
>  };
>  
[...]
> +static int io_getdents(struct io_kiocb *req, unsigned int issue_flags)
> +{
> +	struct io_getdents *getdents = &req->getdents;
> +	bool pos_unlock = false;
> +	int ret = 0;
> +
> +	/* getdents always requires a blocking context */
> +	if (issue_flags & IO_URING_F_NONBLOCK)
> +		return -EAGAIN;
> +
> +	/* for vfs_llseek and to serialize ->iterate_shared() on this file */
> +	if (file_count(req->file) > 1) {

Looks racy, is it safe? E.g. can be concurrently dupped and used, or just
several similar IORING_OP_GETDENTS requests.

> +		pos_unlock = true;
> +		mutex_lock(&req->file->f_pos_lock);
> +	}
> +
> +	if (req->file->f_pos != getdents->pos) {
> +		loff_t res = vfs_llseek(req->file, getdents->pos, SEEK_SET);

I may be missing the previous discussions, but can this ever become
stateless, like passing an offset? Including readdir.c and beyond. 

> +		if (res < 0)
> +			ret = res;
> +	}
> +
> +	if (ret == 0) {
> +		ret = vfs_getdents(req->file, getdents->dirent,
> +				   getdents->count);
> +	}
> +
> +	if (pos_unlock)
> +		mutex_unlock(&req->file->f_pos_lock);
> +
> +	if (ret < 0) {
> +		if (ret == -ERESTARTSYS)
> +			ret = -EINTR;
> +		req_set_fail_links(req);
> +	}
> +	io_req_complete(req, ret);
> +	return 0;
> +}
[...]

-- 
Pavel Begunkov
