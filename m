Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0F40330BD10
	for <lists+io-uring@lfdr.de>; Tue,  2 Feb 2021 12:30:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231480AbhBBL2w (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 2 Feb 2021 06:28:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44932 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231381AbhBBL14 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 2 Feb 2021 06:27:56 -0500
Received: from mail-wr1-x435.google.com (mail-wr1-x435.google.com [IPv6:2a00:1450:4864:20::435])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 42634C0613D6
        for <io-uring@vger.kernel.org>; Tue,  2 Feb 2021 03:27:16 -0800 (PST)
Received: by mail-wr1-x435.google.com with SMTP id p15so19989518wrq.8
        for <io-uring@vger.kernel.org>; Tue, 02 Feb 2021 03:27:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:references:autocrypt:subject:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=prebuj2ppGnHy8ru4p8guRUJlv9BPxIpGOVjPCEorPs=;
        b=inKcfDkSiVumlxar5mqqrR46ibWYB8xkFsbM7sCYXqoaIujpakxlnqtfbqEkjMzqOk
         fb+GZuz7K7t+Qq43GmMXiYlNkY2Uv5bbdA3spkHcS/Zx0jsi5OrYzJFQhNxIv1/+cSWa
         NleiBTZkTI0As8THRE1FTK3QvCUPjp6TvNsOtcVjHmAbnplHG2K/KydipHITmNGOWpzz
         cvxr3T9N/1kHNsEHz0O3bz+ugi8CB6HKthUT0r8/s+3wC8Ew2tu+dcvtWHCzWeK6d/H8
         Sd8xQl6iEnJMLEch3E9HL/hx3gCzuUMeICSY9X7Th1PJqQy58BTg5U4pb+B4uQpxhRNA
         33Pw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:references:autocrypt:subject:message-id
         :date:user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=prebuj2ppGnHy8ru4p8guRUJlv9BPxIpGOVjPCEorPs=;
        b=r8CS/ztWsxoTP5accd4zs3Vnl0Xvr+rpPXVmr+jiwon0b4oTHILGNX284GqlQ+x79f
         iNMrr0DaxLVvE2cVEEjNyQ7Xm5ZKTXcnTiiJ3bvhcc2GvGbHQUZ5cJKDT5dhEudk88+/
         R7RK0jFGIC5ydhGxoqt9a84Im1Ad3PpVNpEG3g4n0IuoElyUGg5Jetnf+MR2LZ75G4nL
         UtWSCTF/fg3HGoijs8btL2TkJGN3p/aIcGIAdE9dU0CviAb0aactRhNLNbv6WHocGJHb
         gsEghYshHhtE7oh1Yv25m2HDcXqTENt0HjvSPUx+2VYD9lcxgNN6uuV9LW1ozT7igh8w
         S9eQ==
X-Gm-Message-State: AOAM532oOa21bRbRySO71eO9VbuRNb91vuiJp5sAlbdPqqVlD/JyeEuS
        RFS5x0SCDNq93/VjRxRXGYBYvEDHMASSew==
X-Google-Smtp-Source: ABdhPJx6fHcHy6Wy2JKEA0xB55IOtHC2wthnWlotR6aQ6Cb0tbdkVWCsq8L52BKTSE8XSc5Uc7RLgA==
X-Received: by 2002:adf:d20c:: with SMTP id j12mr23088910wrh.407.1612265234847;
        Tue, 02 Feb 2021 03:27:14 -0800 (PST)
Received: from [192.168.8.170] ([185.69.145.241])
        by smtp.gmail.com with ESMTPSA id n6sm2464084wmi.23.2021.02.02.03.27.13
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 02 Feb 2021 03:27:14 -0800 (PST)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Victor Stewart <v@nametag.social>,
        io-uring <io-uring@vger.kernel.org>
References: <CAM1kxwhCXpTCRjZ5tc_TPADTK3EFeWHD369wr8WV4nH8+M_thg@mail.gmail.com>
 <49743b61-3777-f152-e1d5-128a53803bcd@gmail.com>
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
Subject: Re: bug with fastpoll accept and sqpoll + IOSQE_FIXED_FILE
Message-ID: <c41e9907-d530-5d2a-7e1f-cf262d86568c@gmail.com>
Date:   Tue, 2 Feb 2021 11:23:32 +0000
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.3.0
MIME-Version: 1.0
In-Reply-To: <49743b61-3777-f152-e1d5-128a53803bcd@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 02/02/2021 11:05, Pavel Begunkov wrote:
> On 02/02/2021 05:36, Victor Stewart wrote:
>> started experimenting with sqpoll and my fastpoll accepts started
>> failing. was banging my head against the wall for a few hours... wrote
>> this test case below....
>>
>> basically fastpoll accept only works without sqpoll, and without
>> adding IOSQE_FIXED_FILE to the sqe. fails with both, fails with
>> either. these must be bugs?
>>
>> I'm running Clear Linux 5.10.10-1017.native.
>>
>> i hope no one here is allergic to C++, haha. compilation command
>> commented in the gist, just replace the two paths. and I can fold
>> these checks if needed into a liburing PR later.
>>
>> https://gist.github.com/victorstewart/98814b65ed702c33480487c05b40eb56
> 
> Please don't forget about checking error codes. At least fixed
> files don't work for you because of
> 
> int fds[10];
> memset(fds, -1, 10); // 10 bytes, not 10 ints
> 
> So io_uring_register_files() silently fails.
> 
> 
> For me, all two "with SQPOLL" tests spit SUCCESS, then it hangs.
> But need to test it with upstream to be sure.

Also you forget to submit, all works with these 2 changes.

When you don't do io_uring_submit(), apparently it gets live-locked
in liburing's _io_uring_get_cqe(), that's a bug.

-- 
Pavel Begunkov
