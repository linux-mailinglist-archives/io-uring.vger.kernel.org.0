Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 523152C92F0
	for <lists+io-uring@lfdr.de>; Tue,  1 Dec 2020 00:45:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730239AbgK3Xor (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 30 Nov 2020 18:44:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49570 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729627AbgK3Xoq (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 30 Nov 2020 18:44:46 -0500
Received: from mail-wr1-x443.google.com (mail-wr1-x443.google.com [IPv6:2a00:1450:4864:20::443])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7B97FC0613D2
        for <io-uring@vger.kernel.org>; Mon, 30 Nov 2020 15:44:06 -0800 (PST)
Received: by mail-wr1-x443.google.com with SMTP id r3so18728675wrt.2
        for <io-uring@vger.kernel.org>; Mon, 30 Nov 2020 15:44:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=to:references:from:autocrypt:subject:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=my8BvPvFD8cSIE9/h7F35Zmhtn6jfx1aDHxM7QSXETQ=;
        b=cKs36je9/H14Iat9426VlVLMcGKRcetrFb2X3tKWFp5jgZBcmY9U5TdbdjIRgBCulW
         JM+yAmJZrGZ1MGHDGgD8+xqxzX9zI0EXZkA0cfd52VJAjkGmp5e12KLze9pEWleN+G/E
         2jJr4VBAJH5bYBIjzWAvHfQwp+TGVMGZ15M1XNKNv1AYg2mCqqgjY+1V0y1xCxp1MAfy
         uuWlORDHXiLdbV2o3BeEsmUZhwDPW1qvbSz5oP1+dr38I1rMVLIMndeuB+oS3xJv6MTO
         vsG8EFnkjpSntC9A4k/YQCJOUP2pAw9yELPtk9KmWaiI8mltawWkq3joDA97ZrdSkzat
         Yk+w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:to:references:from:autocrypt:subject:message-id
         :date:user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=my8BvPvFD8cSIE9/h7F35Zmhtn6jfx1aDHxM7QSXETQ=;
        b=cCmaiStwBjBC1l52LBs9ZNJXYJmcwPOl5+NuzQ3oK+2u/YHpY6Yg8eCqEhsUHpFgd5
         TEi2Y31wLUwQLnb/BdUUIyiddq1+Rp/jUeRGvUM2FnusxDxWhskEt4kB7tI7OjtVz0DZ
         pqd4nS9X8AZbdiQvjxXz4N2KxHwSlDwJ+/XVw2dQ2/hTLTpVKSBC/QSuAGFYuc2LHeYG
         jzGNaQTFsZtx//uN3MRFS1Ow9gtCZ+NNzxjEZeodd2Xe05lvFHV+w9JLRe5/VMvftLu9
         1T12VWK++VrdYmIt1Gi4dN1r5gc99+zFWEwPTdgekTBYYvIBOM+k+ihn4ORCTvzGBEFm
         1ihg==
X-Gm-Message-State: AOAM531Rp+Kl5RtdDjArR/knC3hw4sKDnohdkw6drzKx0owoz4ekfrYT
        odDvyzetS22tfiplDFa83WrjJ37EoHCQMg==
X-Google-Smtp-Source: ABdhPJy+AX6XwCTtHCiWu/M11PEQ5BvXrJdzbw5DFepPsRetZYRa6ROP/oTM1OB8Wk71tAZC43xStQ==
X-Received: by 2002:adf:e48d:: with SMTP id i13mr31408750wrm.387.1606779844988;
        Mon, 30 Nov 2020 15:44:04 -0800 (PST)
Received: from [192.168.1.144] (host109-152-100-189.range109-152.btcentralplus.com. [109.152.100.189])
        by smtp.gmail.com with ESMTPSA id 34sm28801402wrh.78.2020.11.30.15.44.03
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 30 Nov 2020 15:44:04 -0800 (PST)
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
References: <136e474beffa8c70e1fc67b10a0c76db3096c67d.1606700781.git.asml.silence@gmail.com>
 <52211090-ec7c-e0c5-8100-8df4f9778913@kernel.dk>
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
Subject: Re: [PATCH 5.11] io_uring: refactor send/recv msg and iov managing
Message-ID: <c6cb708d-44a4-7b52-5ca7-94ba1ec42cb3@gmail.com>
Date:   Mon, 30 Nov 2020 23:40:48 +0000
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.3.0
MIME-Version: 1.0
In-Reply-To: <52211090-ec7c-e0c5-8100-8df4f9778913@kernel.dk>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 30/11/2020 22:56, Jens Axboe wrote:
> On 11/29/20 6:47 PM, Pavel Begunkov wrote:
>> After copying a send/recv msg header, fix up all the fields right away
>> instead of delaying it. Keeping it in one place makes it easier. Also
>> replace msg->iov with free_iov, that either keeps NULL or an iov to be
>> freed, and kmsg->msg.msg_iter holding the right iov. That's more aligned
>> with how rw handles it and easier to follow.
> 
> Looks good to me, but doesn't apply to the 5.11 branch. A quick guess
> would be that we're conflicting with the compat fix from 5.10...

Forgot to mention that it's based on 5.11 + that fix.
To avoid conflicts I'll resend after you merge that into 5.11

-- 
Pavel Begunkov
