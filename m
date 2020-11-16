Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4C5312B5504
	for <lists+io-uring@lfdr.de>; Tue, 17 Nov 2020 00:32:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729338AbgKPXbQ (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 16 Nov 2020 18:31:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44746 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726227AbgKPXbP (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 16 Nov 2020 18:31:15 -0500
Received: from mail-wr1-x441.google.com (mail-wr1-x441.google.com [IPv6:2a00:1450:4864:20::441])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4922CC0613CF
        for <io-uring@vger.kernel.org>; Mon, 16 Nov 2020 15:31:14 -0800 (PST)
Received: by mail-wr1-x441.google.com with SMTP id 23so20848124wrc.8
        for <io-uring@vger.kernel.org>; Mon, 16 Nov 2020 15:31:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=to:cc:references:from:autocrypt:subject:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=V98itPDPoZDu5BJ80AVdCSDNBf3I0GDrbChFLVVHlOQ=;
        b=H17oMFehtsYF2nWv/N26zhVu1D+9hvexnnzySCKQISysaarml128jF5V4ZCp2vGJPC
         hVyaOk4fFsJTUb+/bjfX3+NNdoOl8q17ZYLfFWFCbpQlpX0K9sKTDkLM6ClM3bo5cvZA
         KKu8s/6vcF5S6wXdWW8BKUN3jr3c7WVJJq/Tb7bYESILHaokQrd7gMUjGKTEzt4gYmaA
         os1rsSsyY7GeNDZXgAdH6Cb+rWnrhHAItCg88e3Em/zew2onCOeUgveuiS9Au8+EEtvY
         vYA44EPXSXbGc++DJYWI21VQDN7v0L12bq1KHj++rspMpVVAd2aGzZOwURms+oSc2kZn
         RCsQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:to:cc:references:from:autocrypt:subject
         :message-id:date:user-agent:mime-version:in-reply-to
         :content-language:content-transfer-encoding;
        bh=V98itPDPoZDu5BJ80AVdCSDNBf3I0GDrbChFLVVHlOQ=;
        b=YF5+/Vf8lelhwzCfYhXhn3cMLtun/1zbXQ+muqkPjvyVeVMbYw3WvQo75j3idplcbO
         Vlri9LEG6Vo2j8FLkGbN2eVbcM/K163Ew9QUfekGIRLdj1zcXHizfLKQPuxWPBB8460W
         3ZphDirhVTemFivcoGmQKLe6OOa8sSEknbhBeAGGVCgkt5rdZ54LgAh9seMDWbyDYI28
         ANWHCnGSIWeAnNQMswhP/oYcdLy02KpT2XC+5PGfbOBLaMOpdv6KCJCYFZr0BUM1U0OO
         ymLswXoN6vG9TezFVdzPXf1+IbNv2XeONv2CdE1TbYPwIIZzNmIye1kt6YeE7hPoOEeG
         1Fvw==
X-Gm-Message-State: AOAM531lvq4gDEE9dZx1bEIpiz4KvoJ7rh0QTjAfUOtn8HNeZr8zHC6c
        gtZT9ULcrmAF0mR9brxdbzo+o8vFpVrfaw==
X-Google-Smtp-Source: ABdhPJzRyLXWWSdAKabk8pcKQbOlqeU5SqgAJdnuN4Mdgi3HRaX8zmtndIDWC4QfOM/TbpocSlcQvQ==
X-Received: by 2002:a5d:4b8f:: with SMTP id b15mr23230000wrt.38.1605569472804;
        Mon, 16 Nov 2020 15:31:12 -0800 (PST)
Received: from [192.168.1.33] (host109-152-100-135.range109-152.btcentralplus.com. [109.152.100.135])
        by smtp.gmail.com with ESMTPSA id t17sm1012251wmi.3.2020.11.16.15.31.12
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 16 Nov 2020 15:31:12 -0800 (PST)
To:     Bijan Mottahedeh <bijan.mottahedeh@oracle.com>, axboe@kernel.dk
Cc:     io-uring@vger.kernel.org
References: <1605222042-44558-1-git-send-email-bijan.mottahedeh@oracle.com>
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
Subject: Re: [PATCH 0/8] io_uring: buffer registration enhancements
Message-ID: <55bd38e0-2f76-413a-04ce-c7ef89e6e13d@gmail.com>
Date:   Mon, 16 Nov 2020 23:28:05 +0000
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.3.0
MIME-Version: 1.0
In-Reply-To: <1605222042-44558-1-git-send-email-bijan.mottahedeh@oracle.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 12/11/2020 23:00, Bijan Mottahedeh wrote:
> This patchset is the follow-on to my previous RFC which implements a
> set of enhancements to buffer registration consistent with existing file
> registration functionality:

I like the idea of generic resource handling

> 
> - buffer registration updates		IORING_REGISTER_BUFFERS_UPDATE
> 					IORING_OP_BUFFERS_UPDATE

Do you need it for something specific?

> 
> - readv/writev with fixed buffers	IOSQE_FIXED_BUFFER

Why do we need it?

> 
> - buffer registration sharing		IORING_SETUP_SHARE_BUF
> 					IORING_SETUP_ATTACH_BUF

I haven't looked it up. What's the overhead on that?
And again, do you really need it?

The set is +600 lines, so just want to know that there is
a real benefit from having it.

> 
> Patches 1,2 modularize existing buffer registration code.
> 
> Patch 3 generalizes fixed_file functionality to fixed_rsrc.
> 
> Patch 4 applies fixed_rsrc functionality for fixed buffers support.
> 
> Patch 5 generalizes files_update functionality to rsrc_update.
> 
> Patch 6 implements buffer registration update, and introduces
> IORING_REGISTER_BUFFERS_UPDATE and IORING_OP_BUFFERS_UPDATE, consistent
> with file registration update.
> 
> Patch 7 implements readv/writev support with fixed buffers, and introduces
> IOSQE_FIXED_BUFFER, consistent with fixed files.
> 
> Patch 8 implements buffer sharing among multiple rings; it works as follows:
> 
> - A new ring, A,  is setup. Since no buffers have been registered, the
>   registered buffer state is an empty set, Z. That's different from the
>   NULL state in current implementation.
> 
> - Ring B is setup, attaching to Ring A. It's also attaching to it's
>   buffer registrations, now we have two references to the same empty
>   set, Z.
> 
> - Ring A registers buffers into set Z, which is no longer empty.
> 
> - Ring B sees this immediately, since it's already sharing that set.
> 
> TBD
> 
> - I think I have to add IORING_UNREGISTER_BUFFERS to
>   io_register_op_must_quiesce() but wanted to confirm.

->fixed_file_refs trades off fast unsynchronised access (by adding
percpu_ref_get/put) to not do full quiesce. So, yes, after it's hooked
up right.

> 
> I have used liburing file-{register,update} tests as models for
> buffer-{register,update,share}, tests and they run ok.
> 
> The liburing test suite fails for "self" with/without this patchset.
> 
> Bijan Mottahedeh (8):
>   io_uring: modularize io_sqe_buffer_register
>   io_uring: modularize io_sqe_buffers_register
>   io_uring: generalize fixed file functionality
>   io_uring: implement fixed buffers registration similar to fixed files
>   io_uring: generalize files_update functionlity to rsrc_update
>   io_uring: support buffer registration updates
>   io_uring: support readv/writev with fixed buffers
>   io_uring: support buffer registration sharing
> 
>  fs/io_uring.c                 | 1021 ++++++++++++++++++++++++++++++++---------
>  include/uapi/linux/io_uring.h |   15 +-
>  2 files changed, 807 insertions(+), 229 deletions(-)
> 

-- 
Pavel Begunkov
