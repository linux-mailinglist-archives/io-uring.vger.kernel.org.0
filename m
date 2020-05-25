Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DBA7A1E102D
	for <lists+io-uring@lfdr.de>; Mon, 25 May 2020 16:13:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390877AbgEYOMz (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 25 May 2020 10:12:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43788 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388855AbgEYOMy (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 25 May 2020 10:12:54 -0400
Received: from mail-ej1-x642.google.com (mail-ej1-x642.google.com [IPv6:2a00:1450:4864:20::642])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 64478C061A0E;
        Mon, 25 May 2020 07:12:54 -0700 (PDT)
Received: by mail-ej1-x642.google.com with SMTP id n24so20622725ejd.0;
        Mon, 25 May 2020 07:12:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=to:cc:references:from:autocrypt:subject:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=AqVKpjpJ/UFk+n4oSRZ3Zn0OGgbKIAFSfdMT8GO0gIo=;
        b=Nr2pEUoLJXWhk1181uvxz9kk+N8NWnRAMnFC0XDttH9ZM0dMCX7vksi2ybJEeGIr8O
         XkK0YPIA5wEskAfwaAg2mt6dDUpOkRf4QgEDCnXpwA6VyvtlpOy/2q557pTF2mrBRvSV
         xI09oeHxwkNnLZ+xOSYo4De3PFcFX6mUvrD84jjF50MYlTYT6etzXvi3xaV/mzgcIrvf
         hBl8RsY49LbWuWn1+dc75Wpm4uLtCez9d3Yec5WqcE2HxPIF9k3/k2Jzr5iGo+zsgqaQ
         s1BKVpmH4ef7sWy277i6duTzmAN3mxVGOnQew9cL0VMd9isJfsbJBSgTLLYew4XEKlfr
         FhwQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:to:cc:references:from:autocrypt:subject
         :message-id:date:user-agent:mime-version:in-reply-to
         :content-language:content-transfer-encoding;
        bh=AqVKpjpJ/UFk+n4oSRZ3Zn0OGgbKIAFSfdMT8GO0gIo=;
        b=GFnqDmVR9E9lEQgbUwlhG9jkqkxWRhcDeneZDsMVcZUXBfkrMvDx1v08iy7EUJMlOl
         yuHTo4AzpDm9iEWg/PyxpRc7jy4NEEKgYV1GpkloCt4P+EH0c4gyIwsuqQ+p7pBzYtn5
         6ewGk7V0xEq9Woj3Tw2co4kt0BPCuYixxwXHIG2ESkZ4hco5pE2riCgQPu/VtR/OlRPT
         w7EIW9p1Ecwrkx2Z3lnc9MOiSimezOvP+7REnvlASDv1E8dxhFqE0uqi1mMmu8uGAA7I
         +5WqnCZ9HeAcrvtXOSesWnOqszaXGUloiTw5IT5OWNKR9tU3Ayujdx3rcUkZEQzSf0NV
         A88A==
X-Gm-Message-State: AOAM533lbJvLQ/cXvuattQPTq93jC1/T1a8FXYKGKMq4KfK7Mwx8MK30
        kVFZB2Zfed58NLnXQB8wRWuMH4wE
X-Google-Smtp-Source: ABdhPJxLP6ArLShwYRpGh2pXtx6NvMhyStMIlnl1WZVyLLpjJ3seCjg9fDH3B00fAgIVMqeUtnEKxw==
X-Received: by 2002:a17:906:1088:: with SMTP id u8mr19922910eju.428.1590415972828;
        Mon, 25 May 2020 07:12:52 -0700 (PDT)
Received: from [192.168.43.221] ([46.191.65.149])
        by smtp.gmail.com with ESMTPSA id f5sm16776122edj.1.2020.05.25.07.12.51
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 25 May 2020 07:12:52 -0700 (PDT)
To:     Stefano Garzarella <sgarzare@redhat.com>,
        Jens Axboe <axboe@kernel.dk>
Cc:     io-uring@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-fsdevel@vger.kernel.org
References: <20200525103051.lztpbl33hsgv6grz@steredhat>
 <20200525134552.5dyldwmeks3t6vj6@steredhat>
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
Subject: Re: io_uring: BUG: kernel NULL pointer dereference
Message-ID: <9e5fd20b-3427-7608-4504-455fb300c949@gmail.com>
Date:   Mon, 25 May 2020 17:11:37 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.3.0
MIME-Version: 1.0
In-Reply-To: <20200525134552.5dyldwmeks3t6vj6@steredhat>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 25/05/2020 16:45, Stefano Garzarella wrote:
> On Mon, May 25, 2020 at 12:30:51PM +0200, Stefano Garzarella wrote:
>>
>> I'll try to bisect, but I have some suspicions about:
>> b41e98524e42 io_uring: add per-task callback handler
> 
> I confirm, the bisection ended with this:
> b41e98524e424d104aa7851d54fd65820759875a is the first bad commit
> 
> I'll try to figure out what happened.

Hmm, I'd start with temporary un-union req->task_work.
Could you give it a try?


diff --git a/fs/io_uring.c b/fs/io_uring.c
index e173cea621de..cfab79254d0a 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -645,7 +645,7 @@ struct io_kiocb {

 	struct percpu_ref	*fixed_file_refs;

-	union {
+	// union {
 		/*
 		 * Only commands that never go async can use the below fields,
 		 * obviously. Right now only IORING_OP_POLL_ADD uses them, and
@@ -658,7 +658,7 @@ struct io_kiocb {
 			struct async_poll	*apoll;
 		};
 		struct io_wq_work	work;
-	};
+	// };
 };

 #define IO_PLUG_THRESHOLD		2


-- 
Pavel Begunkov
