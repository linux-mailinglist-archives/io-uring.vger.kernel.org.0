Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 941E6219C92
	for <lists+io-uring@lfdr.de>; Thu,  9 Jul 2020 11:49:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726309AbgGIJtX (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 9 Jul 2020 05:49:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59688 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726140AbgGIJtW (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 9 Jul 2020 05:49:22 -0400
Received: from mail-wr1-x442.google.com (mail-wr1-x442.google.com [IPv6:2a00:1450:4864:20::442])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 289FBC061A0B;
        Thu,  9 Jul 2020 02:49:22 -0700 (PDT)
Received: by mail-wr1-x442.google.com with SMTP id f18so1679669wrs.0;
        Thu, 09 Jul 2020 02:49:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=to:cc:references:from:autocrypt:subject:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=Q3OfTHS44nA1/IJe34zPMsvaFnQF1KlTjpCyMedeBJ4=;
        b=bp8zZLEwo0eWVE7r6RnSi9OoKPSUy85aDgxRRs+zC1SfonaHwxt8EK3h9dQEAIid3Q
         hqSZhiGmomFr1hjF2s4k8poTtutPbxa+5euOyQN+VEwYb7EKy57gqT+SzN6VwE7k3L29
         IX7YAwhp4+d9FKLw7ly+Bh9knaaIJMJoVWAcT6O+YeLwAe2XDTJWNbJdymxnaJAFgOxX
         kG2gQ25u4hSCYBJ8N/7qo33dd4KvziH9nlZ6H7Up4ZaTZh+1nx9RAS5+Uxs5nSTwiNEc
         6nBnAgxX9z/mFkoZZbxCHOZ556P9PLzUZvl2jAhBnHrFvlSd2qxTFnI+anE6i5KfrEQU
         w/ew==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:to:cc:references:from:autocrypt:subject
         :message-id:date:user-agent:mime-version:in-reply-to
         :content-language:content-transfer-encoding;
        bh=Q3OfTHS44nA1/IJe34zPMsvaFnQF1KlTjpCyMedeBJ4=;
        b=WNnlc2yQDk162IPH3CwfA+/LPD5QMgPBeFYXiRW7ChTqvmWymAHTDgXNU7pJsO3isD
         sSAlzzKubDiz7IS4oC4sM7lEzJeeEb5S/9xJH6734d7KqdjE6QIec3thx9dDgm+bMiq4
         rNwA68Qpf9S2RMrKk9/QkF7HvoQpThWnnpcnfoUGvjJRZ63EUWz8HefJpDs7RjPZVOUU
         CvMk85yDjHAhuXdc52JQ8kPo5UXsWjgTvNr19Nh/olkvAsJf4G0k6wjhIrZNkpSwLy/Q
         r3eSx87hmYZaq5fo8i36yTAfqw/ZIErlJgGbWWBgryDQQoGECSQhfG56cy6+qV7KP3Hf
         B4fA==
X-Gm-Message-State: AOAM530dEzBr1FNMNYEe8wbojxO9pHRrSQytqyyzPjmDlSdkCNZRhDcN
        nA81NGw3fV+v4c+Gr9kwfDsfMDNw
X-Google-Smtp-Source: ABdhPJzfmbIILe+2dk4/1c9GVKX6PRs8nMy1GaMhIqFyr7EDiMoHHIhZXXBzxZlA0BKhbSmAHvpeBw==
X-Received: by 2002:a5d:6a07:: with SMTP id m7mr63544434wru.324.1594288160429;
        Thu, 09 Jul 2020 02:49:20 -0700 (PDT)
Received: from [192.168.43.42] ([5.100.193.69])
        by smtp.gmail.com with ESMTPSA id c25sm3652845wml.46.2020.07.09.02.49.19
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 09 Jul 2020 02:49:19 -0700 (PDT)
To:     Matthew Wilcox <willy@infradead.org>
Cc:     Jens Axboe <axboe@kernel.dk>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        linux-fsdevel@vger.kernel.org, io-uring@vger.kernel.org,
        kernel-janitors@vger.kernel.org
References: <20200708184711.GA31157@mwanda>
 <58b9349b-22fd-e474-c746-2d3b542f5b23@kernel.dk>
 <66d2af76-eee0-e30d-44e5-ed70d9d808a5@gmail.com>
 <20200708195632.GW25523@casper.infradead.org>
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
Subject: Re: [PATCH] io_uring: fix a use after free in io_async_task_func()
Message-ID: <20a7ee28-e08b-23a7-e090-da75e71b64c0@gmail.com>
Date:   Thu, 9 Jul 2020 12:47:37 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.3.0
MIME-Version: 1.0
In-Reply-To: <20200708195632.GW25523@casper.infradead.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 08/07/2020 22:56, Matthew Wilcox wrote:
> On Wed, Jul 08, 2020 at 10:28:51PM +0300, Pavel Begunkov wrote:
>> On 08/07/2020 22:15, Jens Axboe wrote:
>>> On 7/8/20 12:47 PM, Dan Carpenter wrote:
>>>> The "apoll" variable is freed and then used on the next line.  We need
>>>> to move the free down a few lines.
>>>
>>> Thanks for spotting this Dan, applied.
>>
>> I wonder why gcc can't find it... It shouldn't be hard to do after
>> marking free-like functions with an attribute.
>>
>> Are there such tools for the kernel?
> 
> GCC doesn't have an __attribute__((free)) yet.  Martin Sebor is working on
> it: https://gcc.gnu.org/bugzilla/show_bug.cgi?id=87736
> also: https://gcc.gnu.org/bugzilla/show_bug.cgi?id=94527
> 
> (I just confirmed with him on IRC that he's still working on it; it's
> part of an ongoing larger project)

Good to know. It looks broader indeed, hence won't probably be here too soon.

-- 
Pavel Begunkov
