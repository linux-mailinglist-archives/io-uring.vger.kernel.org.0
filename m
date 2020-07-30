Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D2C7F23365D
	for <lists+io-uring@lfdr.de>; Thu, 30 Jul 2020 18:10:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729935AbgG3QK2 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 30 Jul 2020 12:10:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42566 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729459AbgG3QK1 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 30 Jul 2020 12:10:27 -0400
Received: from mail-ed1-x543.google.com (mail-ed1-x543.google.com [IPv6:2a00:1450:4864:20::543])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 24109C061574;
        Thu, 30 Jul 2020 09:10:27 -0700 (PDT)
Received: by mail-ed1-x543.google.com with SMTP id c15so10689948edj.3;
        Thu, 30 Jul 2020 09:10:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=to:cc:references:from:autocrypt:subject:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=eo9PvK1FJGvbYrJLMMSODvaUPOt9BkCNoEhylnHRrU4=;
        b=J+mc9/JaP8AYxRGYLIA3B8cE5gEN3H++zt4wieVbiwtDPiVG5ge+Lf0oxzrrsypkmE
         ZDQzhISrbx5nnSm/7EWiB471Zx4m2zE56Xz27MjAsz6jHrZ5jrkAQu5dndNQPU16+w+F
         fUo7rY9oUlBPD12kakW8RswGea1g9Iuo6bQVMC+2xV0RCUp4CDr4Em2WevI9HWsbmbff
         bxfUaOdOVU//5T3BSBT1NMkzgV0SjunszuPQ9POsubUf4Mhp4clHFkBOSvLLW+JhtrJl
         HdPQlUes3fIYQb49Kyu8eCaY0Gwy17OO5Pf+S/0wQbAZ9qqFQBpeTXXinqeWsT5wUFLy
         4I4g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:to:cc:references:from:autocrypt:subject
         :message-id:date:user-agent:mime-version:in-reply-to
         :content-language:content-transfer-encoding;
        bh=eo9PvK1FJGvbYrJLMMSODvaUPOt9BkCNoEhylnHRrU4=;
        b=rKin1bD4qFmPIAcBB0DWpRpTcnAKRUS5uAFGskvxb/KKeHh7fPs4CBAAPgG0QWC6Wf
         LbULaqk+0oqrFm6OAcHySz7gRheJHSq3+Wo+Q9h8M1XsmDXHDxoZrnhj1QWV5IN5SiGu
         AuDe6sMF7EEx4ZkP3gXX9Y50Yq6Gz/pA4MGOIz0eVqyfH7MEoCbp2lkkYHUHKBpjWfY4
         WBK5x/CfFRTwcOG6HNQ69y5hHpdkKCgXh8PyVdxUDRDZUrwwKSeIokBsDgGk33JomB2x
         arsKBhNLRaAWMWA5PIv8AscJ7TA0NTyM/5ZdcrtiaLDdOSmVHt4P/xIo7uBbzCyNxeuc
         dmlw==
X-Gm-Message-State: AOAM53038TXf5XSV9UYlCifKyqznSxaDiPNwxP0OcBQoIMYi7mltoNZq
        J3ZEjBvTtslDLRI7H2xn+Ww=
X-Google-Smtp-Source: ABdhPJyYt7By6mBB1oOrN8tXg18owvXw/2BYthniNkFPHC4qH3/1UnpFnQAdj6ycZ7vz1kG/BVZZdg==
X-Received: by 2002:a05:6402:339:: with SMTP id q25mr3313588edw.268.1596125425830;
        Thu, 30 Jul 2020 09:10:25 -0700 (PDT)
Received: from [192.168.43.105] ([5.100.193.69])
        by smtp.gmail.com with ESMTPSA id l23sm5955630eje.46.2020.07.30.09.10.23
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 30 Jul 2020 09:10:25 -0700 (PDT)
To:     Jens Axboe <axboe@kernel.dk>, Kanchan Joshi <joshiiitr@gmail.com>
Cc:     Kanchan Joshi <joshi.k@samsung.com>, viro@zeniv.linux.org.uk,
        bcrl@kvack.org, Matthew Wilcox <willy@infradead.org>,
        Christoph Hellwig <hch@infradead.org>,
        Damien Le Moal <Damien.LeMoal@wdc.com>,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-aio@kvack.org, io-uring@vger.kernel.org,
        linux-block@vger.kernel.org, linux-api@vger.kernel.org,
        SelvaKumar S <selvakuma.s1@samsung.com>,
        Nitesh Shetty <nj.shetty@samsung.com>,
        Javier Gonzalez <javier.gonz@samsung.com>
References: <1595605762-17010-1-git-send-email-joshi.k@samsung.com>
 <CGME20200724155350epcas5p3b8f1d59eda7f8fbb38c828f692d42fd6@epcas5p3.samsung.com>
 <1595605762-17010-7-git-send-email-joshi.k@samsung.com>
 <f5416bd4-93b3-4d14-3266-bdbc4ae1990b@kernel.dk>
 <CA+1E3rJAa3E2Ti0fvvQTzARP797qge619m4aYLjXeR3wxdFwWw@mail.gmail.com>
 <b0b7159d-ed10-08ad-b6c7-b85d45f60d16@kernel.dk>
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
Subject: Re: [PATCH v4 6/6] io_uring: add support for zone-append
Message-ID: <e871eef2-8a93-fdbc-b762-2923526a2db4@gmail.com>
Date:   Thu, 30 Jul 2020 19:08:28 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.3.0
MIME-Version: 1.0
In-Reply-To: <b0b7159d-ed10-08ad-b6c7-b85d45f60d16@kernel.dk>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 27/07/2020 23:34, Jens Axboe wrote:
> On 7/27/20 1:16 PM, Kanchan Joshi wrote:
>> On Fri, Jul 24, 2020 at 10:00 PM Jens Axboe <axboe@kernel.dk> wrote:
>>>
>>> On 7/24/20 9:49 AM, Kanchan Joshi wrote:
>>>> diff --git a/fs/io_uring.c b/fs/io_uring.c
>>>> index 7809ab2..6510cf5 100644
>>>> --- a/fs/io_uring.c
>>>> +++ b/fs/io_uring.c
>>>> @@ -1284,8 +1301,15 @@ static void __io_cqring_fill_event(struct io_kiocb *req, long res, long cflags)
>>>>       cqe = io_get_cqring(ctx);
>>>>       if (likely(cqe)) {
>>>>               WRITE_ONCE(cqe->user_data, req->user_data);
>>>> -             WRITE_ONCE(cqe->res, res);
>>>> -             WRITE_ONCE(cqe->flags, cflags);
>>>> +             if (unlikely(req->flags & REQ_F_ZONE_APPEND)) {
>>>> +                     if (likely(res > 0))
>>>> +                             WRITE_ONCE(cqe->res64, req->rw.append_offset);
>>>> +                     else
>>>> +                             WRITE_ONCE(cqe->res64, res);
>>>> +             } else {
>>>> +                     WRITE_ONCE(cqe->res, res);
>>>> +                     WRITE_ONCE(cqe->flags, cflags);
>>>> +             }
>>>
>>> This would be nice to keep out of the fast path, if possible.
>>
>> I was thinking of keeping a function-pointer (in io_kiocb) during
>> submission. That would have avoided this check......but argument count
>> differs, so it did not add up.
> 
> But that'd grow the io_kiocb just for this use case, which is arguably
> even worse. Unless you can keep it in the per-request private data,
> but there's no more room there for the regular read/write side.
> 
>>>> diff --git a/include/uapi/linux/io_uring.h b/include/uapi/linux/io_uring.h
>>>> index 92c2269..2580d93 100644
>>>> --- a/include/uapi/linux/io_uring.h
>>>> +++ b/include/uapi/linux/io_uring.h
>>>> @@ -156,8 +156,13 @@ enum {
>>>>   */
>>>>  struct io_uring_cqe {
>>>>       __u64   user_data;      /* sqe->data submission passed back */
>>>> -     __s32   res;            /* result code for this event */
>>>> -     __u32   flags;
>>>> +     union {
>>>> +             struct {
>>>> +                     __s32   res;    /* result code for this event */
>>>> +                     __u32   flags;
>>>> +             };
>>>> +             __s64   res64;  /* appending offset for zone append */
>>>> +     };
>>>>  };
>>>
>>> Is this a compatible change, both for now but also going forward? You
>>> could randomly have IORING_CQE_F_BUFFER set, or any other future flags.
>>
>> Sorry, I didn't quite understand the concern. CQE_F_BUFFER is not
>> used/set for write currently, so it looked compatible at this point.
> 
> Not worried about that, since we won't ever use that for writes. But it
> is a potential headache down the line for other flags, if they apply to
> normal writes.
> 
>> Yes, no room for future flags for this operation.
>> Do you see any other way to enable this support in io-uring?
> 
> Honestly I think the only viable option is as we discussed previously,
> pass in a pointer to a 64-bit type where we can copy the additional
> completion information to.

TBH, I hate the idea of such overhead/latency at times when SSDs can
serve writes in less than 10ms. Any chance you measured how long does it
take to drag through task_work?

> 
>>> Layout would also be different between big and little endian, so not
>>> even that easy to set aside a flag for this. But even if that was done,
>>> we'd still have this weird API where liburing or the app would need to
>>> distinguish this cqe from all others based on... the user_data? Hence
>>> liburing can't do it, only the app would be able to.
>>>
>>> Just seems like a hack to me.
>>
>> Yes, only user_data to distinguish. Do liburing helpers need to look
>> at cqe->res (and decide something) before returning the cqe to
>> application?
> 
> They generally don't, outside of the internal timeout. But it's an issue
> for the API, as it forces applications to handle the CQEs a certain way.
> Normally there's flexibility. This makes the append writes behave
> differently than everything else, which is never a good idea.
> 

-- 
Pavel Begunkov
