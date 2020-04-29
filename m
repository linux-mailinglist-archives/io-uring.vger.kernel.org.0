Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5AB631BE2F2
	for <lists+io-uring@lfdr.de>; Wed, 29 Apr 2020 17:40:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726530AbgD2Pkj (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 29 Apr 2020 11:40:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44304 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726826AbgD2Pki (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 29 Apr 2020 11:40:38 -0400
Received: from mail-wm1-x336.google.com (mail-wm1-x336.google.com [IPv6:2a00:1450:4864:20::336])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 25281C03C1AD
        for <io-uring@vger.kernel.org>; Wed, 29 Apr 2020 08:40:38 -0700 (PDT)
Received: by mail-wm1-x336.google.com with SMTP id r26so2540444wmh.0
        for <io-uring@vger.kernel.org>; Wed, 29 Apr 2020 08:40:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=to:references:from:autocrypt:subject:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=jXtxi1JTe34SqdxxMX4Be6w/Yz4QlJoZXz/jou0jltQ=;
        b=gur49IoqlwAJkrTiLsDp6EZDDz21yCnTCMNU9H2J0FSUp7F6gEO/n8asS9hVvhutMD
         TncHa5F/REta74BO+OfqjAgDCnNXxFyMstCgWM0JnTwFv6Y82uTdIDpTWMuzQuAPsaUI
         aK5egDoMRFqnJ/E0jfiIgyRDbzzbWrTwJizzHXhqkoOewBL20r7kKcdRdrlHRgH7nI85
         82mBLrPCU5vq3Bg9ytZxNOydprXD4Ap3O+Vh5MStyr1qLkqxVxQCW1FUxIp3PV6w85nh
         Iz4yuQmRH60FN9f5GWzs+UIIJYRmUN3qi/8iCA2lG/XGlueRTS+tjvKm6UX9Z4mL9WzK
         AIFA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:to:references:from:autocrypt:subject:message-id
         :date:user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=jXtxi1JTe34SqdxxMX4Be6w/Yz4QlJoZXz/jou0jltQ=;
        b=ZN3VvOHNW5kv6+Sg4hQDsEsdEOyiIYUEVG5DUUfJnEZKRfoCAK4tSTKTepht4nSN9u
         zYuVE6RPQl9HI7Tk9QkvkSGlu2OKIC/T5fFwD/QAjaH62uCLZTUDOosu2DB/JWmAk2Ly
         mof20kl/DFLAVT3cgcaFyXj1FYlcwiRDEFlmvoq5RWqLpqvzi85pw4a3NSi3kWtMALot
         9kdcLHArIqHk3R8qhBTnr2/++Lkd8ghZzitW/UTedVdq0g9hWgqeyf5y5yTtm2QW3BoJ
         9XL5YAC/wHH+sOOevhXm5nv4ubF0IQ3UAi9u+hGcmUxmBdM9BIJsUVnUMkwoKTij9G+F
         ZfHg==
X-Gm-Message-State: AGi0PuabP+P+UTEVNDpBv3nozahMcCqCb+FPIBA00yY4QTjYEoyUO8aB
        Z0cW10hsUvpwZDgk6OoIaZ9aV3h5
X-Google-Smtp-Source: APiQypIT6l4y/7IsgDsO6PqNFW0LmwhoGF1BzVX/C3fqRKSlRbN7ozNCymrMDKYEQ+3OzbmXINMc4A==
X-Received: by 2002:a1c:f20c:: with SMTP id s12mr4195774wmc.83.1588174836521;
        Wed, 29 Apr 2020 08:40:36 -0700 (PDT)
Received: from [192.168.43.25] ([109.126.129.227])
        by smtp.gmail.com with ESMTPSA id q17sm7991346wmj.45.2020.04.29.08.40.35
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 29 Apr 2020 08:40:36 -0700 (PDT)
To:     Mark Papadakis <markuspapadakis@icloud.com>,
        io-uring <io-uring@vger.kernel.org>
References: <8B8CEFE3-DDC8-46C6-AE63-4990D677A770@icloud.com>
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
Subject: Re: SQE OP - sendfile
Message-ID: <94dbbb15-4751-d03c-01fd-d25a0fe98e25@gmail.com>
Date:   Wed, 29 Apr 2020 18:39:32 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.3.0
MIME-Version: 1.0
In-Reply-To: <8B8CEFE3-DDC8-46C6-AE63-4990D677A770@icloud.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 29/04/2020 18:21, Mark Papadakis wrote:
> Greetings,
> 
> Are there any plans for an SENDFILE SQE OP?
> Using a pipe and 2 two SPLICE ops(using the LINK flag) for moving data from one file FD to a socket FD(for example) works - but it’s somewhat inconvenient and maybe more expensive than it would otherwise be if there was a dedicated op for a sendfile() like facility.
> 

I didn't dig deeply, but it's done by internally creating a pipe and leaving it
with a task up until it exits. I hope such pipes use only 1 page or so, but I
don't like the idea of having one per each io-wq thread (even lazily as it's
done now).

If we really want to do that, would probably need something more elaborate.
Jens may shed some light.

-- 
Pavel Begunkov
