Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BEDAD246423
	for <lists+io-uring@lfdr.de>; Mon, 17 Aug 2020 12:11:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726265AbgHQKLL (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 17 Aug 2020 06:11:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40958 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726151AbgHQKLH (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 17 Aug 2020 06:11:07 -0400
Received: from mail-lf1-x132.google.com (mail-lf1-x132.google.com [IPv6:2a00:1450:4864:20::132])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 11BD2C061389
        for <io-uring@vger.kernel.org>; Mon, 17 Aug 2020 03:11:07 -0700 (PDT)
Received: by mail-lf1-x132.google.com with SMTP id j22so8078151lfm.2
        for <io-uring@vger.kernel.org>; Mon, 17 Aug 2020 03:11:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=to:cc:references:from:autocrypt:subject:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=teNTGPBcXDcYUqCsR0LbmiwCLY1JUW3Hvwkpx9lIIw8=;
        b=JvW32SQtER14j1VZ/IebZrZpE4GRERB9xZBhbYWFmLaeAOcax1WhSxDIZDcYdKgwAI
         VLJM2mfBKxXo/WDyoXBll1UQ0L45qnTFpmfEnV+q3ePEihIc6cQcvgLaMFuhwTW1fAeS
         i663fimwdmOfURf5GoBrhd71uq1udddboAY61kVRinHPusRoi+Oe4QseUcvbaCDthfm9
         xmYkcCoeScmbS+jKpXUkc4b9+g3UhqSA+PagYpinGr9jz6xSJuPCt4r9hx9khNGCM8gp
         M/wmmWSg/vNH6t5QQAU/l47mpyazvJXzOHqEP0+WZTqKXVd8HzYZ5ZNI53e015CCLbK2
         rwlw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:to:cc:references:from:autocrypt:subject
         :message-id:date:user-agent:mime-version:in-reply-to
         :content-language:content-transfer-encoding;
        bh=teNTGPBcXDcYUqCsR0LbmiwCLY1JUW3Hvwkpx9lIIw8=;
        b=YfXFKyEuuwvXLgvbWI2Km2fOAneF7BAkfZUVOYmiShYHAO2zXiIVcNy2FgYGDbnpsV
         f1JA5e4koEyoT3wtR9fXh+YToH/meTE0IzgteTMmPEK5S3khpdxQ+t+Og6yofyB40FCj
         qnTwxKajLS5WWrtg9AW/pHxPlPMxnXPjJhpv+KimH6nQ99XyGLwD3/+FPHRAA3OfY3BE
         lcWzdmyeUXu708NBjZggkk0O0eo61CvDJlpF/evGdUF+Xci2ykmOosB7q+V5vz48XG3c
         0fG9lqCBM1AWu5wN/gl0PIquJrq78ItOKF4FoAZAEwqBnuhH9c1ZwKa1TmZGMa4+FTKs
         wEEw==
X-Gm-Message-State: AOAM532ETrXpgphfZyGRETRNdPHpjdKHwahHDTyx6NkRDuiQvvSSbFCp
        mBQmkzPGMjQ/+qyNHqvWFu0=
X-Google-Smtp-Source: ABdhPJzNhT+DFTFdoHy3Qk2vy0P7dJBNuqQ8B1MO7OjztiHcIkglp7IZJP1KTFH7sb0NMYdm/cP10g==
X-Received: by 2002:a05:6512:1055:: with SMTP id c21mr7050167lfb.84.1597659063331;
        Mon, 17 Aug 2020 03:11:03 -0700 (PDT)
Received: from [192.168.88.252] (n146-194.tmp.edunet.ru. [213.184.146.194])
        by smtp.gmail.com with ESMTPSA id 5sm5426411lfz.35.2020.08.17.03.11.02
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 17 Aug 2020 03:11:02 -0700 (PDT)
To:     Josef <josef.grieb@gmail.com>, Jens Axboe <axboe@kernel.dk>,
        io-uring@vger.kernel.org
Cc:     norman@apache.org
References: <CAAss7+pf+CGQiSDM8_fhsHRwjWUxESPcJMhOOsDOitqePQxCrg@mail.gmail.com>
 <d0621b79-4277-a9ad-208e-b60153c08d15@kernel.dk>
 <bb45665c-1311-807d-5a03-459cf3cbd103@gmail.com>
 <d06c7f29-726b-d46a-8c51-0dc47ef374ad@kernel.dk>
 <63024e23-2b71-937a-6759-17916743c16c@gmail.com>
 <CAAss7+qGqCpp8dWpDR2rVJERwtV7r=9vEajOMqbhkSQ8Y-yteQ@mail.gmail.com>
 <fa0c9555-d6bc-33a3-b6d1-6a95a744c69f@kernel.dk>
 <904b4d74-09ec-0bd3-030a-59b09fb1a7da@kernel.dk>
 <CAAss7+r8CZMVmxj0_mHTPUVbp3BzT4LGa2uEUjCK1NpXQnDkdw@mail.gmail.com>
 <390e6d95-040b-404e-58c4-d633d6d0041d@kernel.dk>
 <63b47134-ad9c-4305-3a19-8c5deb7da686@kernel.dk>
 <CAAss7+o+py+ui=nbW03V_RADxnTE6Dz9q229rnpn+YeWu5GP=w@mail.gmail.com>
 <689aa6e9-bfff-3353-fc09-d8dec49485bd@kernel.dk>
 <b35ac93e-cf5f-ee98-404d-358674d51075@kernel.dk>
 <CAAss7+qHUNSX7xxQE6L1Upc2jYj-jLPaGMH+O1e30oF2nrmjCw@mail.gmail.com>
 <e51a81ed-075c-d90f-96cc-995d89f15143@kernel.dk>
 <CAAss7+qkX1YkBaMSqdXGpZtaaEyfjBCH75saFc+soiiFXqw4mw@mail.gmail.com>
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
Subject: Re: io_uring process termination/killing is not working
Message-ID: <f118a29d-1672-93f4-6ef9-4630feaa17ab@gmail.com>
Date:   Mon, 17 Aug 2020 13:08:56 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.3.0
MIME-Version: 1.0
In-Reply-To: <CAAss7+qkX1YkBaMSqdXGpZtaaEyfjBCH75saFc+soiiFXqw4mw@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 17/08/2020 11:58, Josef wrote:
>> BTW, something I think you're aware of, but wanted to bring up
>> explicitly - if IORING_FEAT_FAST_POLL is available in the ring features,
>> then you generally don't want/need to link potentially blocking requests
>> on pollable files with a poll in front. io_uring will do this
>> internally, and save you an sqe and completion event for each of these
>> types of requests.
>>
>> Your test case is a perfect example of that, neither the accept nor the
>> socket read would need a poll linked in front of them, as they are both
>> pollable file types and will not trigger use of an async thread to wait
>> for the event. Instead an internal poll is armed which will trigger the
>> issue of that request, when the socket is ready
> 
> I am guessing if the socket(non blocking) is not writable as you said
> it's a pollable file type, io_uring will first use an internal poll to
> check if the socket is writable, right? so I don't explicitly need a
> poll(POLLOUT)

IIRC, it won't.

E.g. one possible scenario:
1. io_issue_sqe(force_nonblock=true), aka inlined execution
2. io_send() sets REQ_F_NOWAIT
3. __io_queue_sqe() fails such request.


BTW, Jens, it's not really clear to me, what semantics is expected
from io_uring when *NOWAIT is set (e.g. MSG_DONTWAIT)? If that's
fail-fast, then it doesn't look consistent that io_wq_submit_work()
keeps resubmitting it in a loop.

-- 
Pavel Begunkov
