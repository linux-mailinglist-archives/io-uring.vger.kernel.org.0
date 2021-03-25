Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D3F70349A19
	for <lists+io-uring@lfdr.de>; Thu, 25 Mar 2021 20:20:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230064AbhCYTTj (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 25 Mar 2021 15:19:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57938 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230085AbhCYTTH (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 25 Mar 2021 15:19:07 -0400
Received: from mail-wr1-x435.google.com (mail-wr1-x435.google.com [IPv6:2a00:1450:4864:20::435])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D430AC06174A
        for <io-uring@vger.kernel.org>; Thu, 25 Mar 2021 12:19:06 -0700 (PDT)
Received: by mail-wr1-x435.google.com with SMTP id j7so3442731wrd.1
        for <io-uring@vger.kernel.org>; Thu, 25 Mar 2021 12:19:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:references:from:autocrypt:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=kKJW21g8MEmHjmLA42cGGqCwHBWUui+CihYLOVH+/9k=;
        b=fwpCzzAZZdAMqdiAXDNp40EfsBX6pUzES3hmXstvs3SW39rc4OxCMgEpZ0sM/xgmQ5
         IeDdz4CoUceeQjwdZG5x7h+sj6mSlJy5ANnQ3OysyU54RgyEGokk83C4ZJvcCWTIgix/
         i9BAwXDynFBHB5JTRDTcT89p5zzytomNsxU87blhuoQ53Lok2XGdfqmaJhBjzTGuPYBO
         cRZSaau0DtIpU347scfRujoZyYEiz4dNG3EUfVyuufAfUh/wpA2z0h/FcNLF0eu6ENOV
         owl3jo3MNH+mVJ7ZB99inhQ9ZenJGTS4+rLlO28ogL9mqnVLMCxzkRAVfRGVcxm0XnLz
         iFjQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:autocrypt:message-id
         :date:user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=kKJW21g8MEmHjmLA42cGGqCwHBWUui+CihYLOVH+/9k=;
        b=fn/EQ1HCMCEB0b0P6IO11DPnWcmF2FQJ26hQFD0OtTV7hIbizkFZIdJJ3KAj7DXqdd
         WtuovKzteuFB7qwbRXLjy9MVyJ1N1w+pY4PV5wM+1KdmApdSCyolRz7mufQbDBCtw8T/
         DxYsRJXeh3+QFaock2i+E5/13i7PcI0Tysmx1Ew/ELRP+bdsPQAzzLU7rdGG8NdbF0Of
         q7y6g1cDIb63derrNcTDjDvVZ7moYgdTeYY0/8D3yOEO/vR7Xws7BOPMvxvIp+Vjnz4y
         VuLRlPLFfXCI+7W11YFVmCdj5Y9NnKI6Zje7Mhjznx58uZidocQiDl0AMsiXgxHPY2/U
         m9yQ==
X-Gm-Message-State: AOAM532j9LpR6NbX9GMo0vWo5rJt9WXxUVwdMUMV78kKjyUB0uqf508E
        WGAHr/sBZAnnGc5FozlF+j0doXtKMbdShg==
X-Google-Smtp-Source: ABdhPJzg2yHRzWGHoPHw/qrpAWqijI5XCZcFtMDlIqhz7BCgb2QziF57OS3hEn9QFRRBSNtDhBBpnA==
X-Received: by 2002:adf:ff8c:: with SMTP id j12mr10648836wrr.297.1616699945503;
        Thu, 25 Mar 2021 12:19:05 -0700 (PDT)
Received: from [192.168.8.104] ([148.252.129.162])
        by smtp.gmail.com with ESMTPSA id m17sm9003535wrx.92.2021.03.25.12.19.04
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 25 Mar 2021 12:19:04 -0700 (PDT)
Subject: Re: [PATCH v2] io_uring: reg buffer overflow checks hardening
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
References: <2b0625551be3d97b80a5fd21c8cd79dc1c91f0b5.1616624589.git.asml.silence@gmail.com>
 <e8d423fa-5b0d-a337-e921-00697d24028f@kernel.dk>
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
Message-ID: <813d0f09-3842-b224-47d6-5c1da5a28537@gmail.com>
Date:   Thu, 25 Mar 2021 19:15:04 +0000
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.3.0
MIME-Version: 1.0
In-Reply-To: <e8d423fa-5b0d-a337-e921-00697d24028f@kernel.dk>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 25/03/2021 19:17, Jens Axboe wrote:
> On 3/24/21 4:59 PM, Pavel Begunkov wrote:
>> We are safe with overflows in io_sqe_buffer_register() because it will
>> just yield alloc failure, but it's nicer to check explicitly.
>>
>> v2: replace u64 with ulong to handle 32 bit and match
>>     io_sqe_buffer_register() math. (Jens)
> 
> Applied for 5.13 - btw, and I think that was an oversight on this one,
> just put the version stuff below the '---' as it should not go into
> the git log.

right, thanks!

-- 
Pavel Begunkov
