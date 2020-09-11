Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DB62A2668B4
	for <lists+io-uring@lfdr.de>; Fri, 11 Sep 2020 21:25:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725778AbgIKTZg (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 11 Sep 2020 15:25:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42924 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725776AbgIKTZb (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 11 Sep 2020 15:25:31 -0400
Received: from mail-ej1-x642.google.com (mail-ej1-x642.google.com [IPv6:2a00:1450:4864:20::642])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E072AC061573
        for <io-uring@vger.kernel.org>; Fri, 11 Sep 2020 12:25:30 -0700 (PDT)
Received: by mail-ej1-x642.google.com with SMTP id e23so15216258eja.3
        for <io-uring@vger.kernel.org>; Fri, 11 Sep 2020 12:25:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=to:references:from:autocrypt:subject:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=l0OxWsQkADEstCUKtIQuCl9exatM61ABv+Hzud+4TN4=;
        b=Tc5zvl+nqaeWxMhH2FzuBsrGkphUHHMqS5T7ozAkEOqwlxhYJd/Tpos9zICP0d/cGQ
         k2Jz7lOeqKYvZ3zXqnWOOD3QEPkejVYK/bbWB6Uxdf5FnNPhgXroMXRkxW1PQXOgMs7s
         5fyThp/wkhDUcYgbvGyhJdl0W3mrIE6IB7aZ59otY9u3qu2O6sbMwBcFea4aZM3mFTVg
         AjylRUDOIE5vZ8DKyRovDjBqECWQwSVbXSgZS9PAvhOLegxgqacs1uzl6QXPgHTWu4Zq
         kcyNJ/RZuJvEgEbSW7RRTajNQH7IojshELy7DhHKpKuUrQ5mScoTLWdtoUO17yUREekw
         fK/w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:to:references:from:autocrypt:subject:message-id
         :date:user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=l0OxWsQkADEstCUKtIQuCl9exatM61ABv+Hzud+4TN4=;
        b=ulMtt8FsjBcWZx/zsL6RYoN5xDov42XbagcYx042RsotPWjBYFByDEs91mGJUF1bH6
         kGj1XSa00WbnQ7X7l4xz4Xvp+Ea5NYLtHArtUgZZEeI/WDrEhfi7O5xzDAgyj2D0RL83
         tZDPG7wFRKzK0BxzraTPchk0spT824UcE5LTJSnJV+TT/5kAxb358wJX7KbRqs1pc2nx
         a4Qio5nXfkmvlc7R4aomjhHY0meTryuZMJrBeBsg07BwonSEn9epex8NCeKRaIMIEkrS
         +jbNGBMB2QdcO5dZaC4aDh/91ZeKAGAoMrQDzpKHme7vrq9vzvGTApVJULREGtr95uP3
         WSXw==
X-Gm-Message-State: AOAM530GpgDhRbcjK2UzbeD4lgbnpaYxf3LGbLoC56fjxRq6qrLb5OEq
        M2Xsb1i3CIWTHpOcoGPacEBVn8rA1oU=
X-Google-Smtp-Source: ABdhPJxZp+kbFqcgYvvQVX3u24vcMUojH5AAr6ZMsItaCtg7WvrDZrf1z/7/NLhzqn/+WgYEvDZUaA==
X-Received: by 2002:a17:906:1986:: with SMTP id g6mr3649916ejd.404.1599852329203;
        Fri, 11 Sep 2020 12:25:29 -0700 (PDT)
Received: from [192.168.43.239] ([5.100.193.128])
        by smtp.gmail.com with ESMTPSA id v25sm2431371edr.29.2020.09.11.12.25.27
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 11 Sep 2020 12:25:28 -0700 (PDT)
To:     Jens Axboe <axboe@kernel.dk>, io-uring <io-uring@vger.kernel.org>
References: <b105ea32-3831-b3c5-3993-4b38cc966667@kernel.dk>
 <8f6871c4-1344-8556-25a7-5c875aebe4a5@gmail.com>
 <622649c5-e30d-bc3c-4709-bbe60729cca1@kernel.dk>
 <1c088b17-53bb-0d6d-6573-a1958db88426@kernel.dk>
 <801ed334-54ea-bdee-4d81-34b7e358b506@gmail.com>
 <370c055e-fa8d-0b80-bd34-ba3ba9bc6b37@kernel.dk>
 <74c2802e-788e-d6b2-3ee6-5ef67950dc94@gmail.com>
 <b52f5068-8e03-22a9-cf7d-c3e77fc8282f@kernel.dk>
 <33a6730c-8e0c-e34f-9094-c256a13961cd@gmail.com>
 <163d7844-e2a4-2739-af4e-79f4a3ec9a1d@kernel.dk>
 <73b8038a-eedf-04f7-6991-938512faaee6@kernel.dk>
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
Subject: Re: [PATCH for-next] io_uring: ensure IOSQE_ASYNC file table grabbing
 works, with SQPOLL
Message-ID: <8f953abe-cdcd-18a9-fe06-2c0480cddff5@gmail.com>
Date:   Fri, 11 Sep 2020 22:23:02 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.3.0
MIME-Version: 1.0
In-Reply-To: <73b8038a-eedf-04f7-6991-938512faaee6@kernel.dk>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 10/09/2020 21:18, Jens Axboe wrote:
> On 9/10/20 7:11 AM, Jens Axboe wrote:
>> On 9/10/20 6:37 AM, Pavel Begunkov wrote:
>>> On 09/09/2020 19:07, Jens Axboe wrote:
>>>> On 9/9/20 9:48 AM, Pavel Begunkov wrote:
>>>>> On 09/09/2020 16:10, Jens Axboe wrote:
>>>>>> On 9/9/20 1:09 AM, Pavel Begunkov wrote:
>>>>>>> On 09/09/2020 01:54, Jens Axboe wrote:
>>>>>>>> On 9/8/20 3:22 PM, Jens Axboe wrote:
>>>>>>>>> On 9/8/20 2:58 PM, Pavel Begunkov wrote:
>>>>>>>>>> On 08/09/2020 20:48, Jens Axboe wrote:
>>>>>>>>>>> Fd instantiating commands like IORING_OP_ACCEPT now work with SQPOLL, but
>>>>>>>>>>> we have an error in grabbing that if IOSQE_ASYNC is set. Ensure we assign
>>>>>>>>>>> the ring fd/file appropriately so we can defer grab them.
>>>>>>>>>>
>>>>>>>>>> IIRC, for fcheck() in io_grab_files() to work it should be under fdget(),
>>>>>>>>>> that isn't the case with SQPOLL threads. Am I mistaken?
>>>>>>>>>>
>>>>>>>>>> And it looks strange that the following snippet will effectively disable
>>>>>>>>>> such requests.
>>>>>>>>>>
>>>>>>>>>> fd = dup(ring_fd)
>>>>>>>>>> close(ring_fd)
>>>>>>>>>> ring_fd = fd
>>>>>>>>>
>>>>>>>>> Not disagreeing with that, I think my initial posting made it clear
>>>>>>>>> it was a hack. Just piled it in there for easier testing in terms
>>>>>>>>> of functionality.
>>>>>>>>>
>>>>>>>>> But the next question is how to do this right...> 
>>>>>>>> Looking at this a bit more, and I don't necessarily think there's a
>>>>>>>> better option. If you dup+close, then it just won't work. We have no
>>>>>>>> way of knowing if the 'fd' changed, but we can detect if it was closed
>>>>>>>> and then we'll end up just EBADF'ing the requests.
>>>>>>>>
>>>>>>>> So right now the answer is that we can support this just fine with
>>>>>>>> SQPOLL, but you better not dup and close the original fd. Which is not
>>>>>>>> ideal, but better than NOT being able to support it.
>>>>>>>>
>>>>>>>> Only other option I see is to to provide an io_uring_register()
>>>>>>>> command to update the fd/file associated with it. Which may be useful,
>>>>>>>> it allows a process to indeed to this, if it absolutely has to.
>>>>>>>
>>>>>>> Let's put aside such dirty hacks, at least until someone actually
>>>>>>> needs it. Ideally, for many reasons I'd prefer to get rid of
>>>>>>
>>>>>> BUt it is actually needed, otherwise we're even more in a limbo state of
>>>>>> "SQPOLL works for most things now, just not all". And this isn't that
>>>>>> hard to make right - on the flush() side, we just need to park/stall the
>>>>>
>>>>> I understand that it isn't hard, but I just don't want to expose it to
>>>>> the userspace, a) because it's a userspace API, so couldn't probably be
>>>>> killed in the future, b) works around kernel's problems, and so
>>>>> shouldn't really be exposed to the userspace in normal circumstances.
>>>>>
>>>>> And it's not generic enough because of a possible "many fds -> single
>>>>> file" mapping, and there will be a lot of questions and problems.
>>>>>
>>>>> e.g. if a process shares a io_uring with another process, then
>>>>> dup()+close() would require not only this hook but also additional
>>>>> inter-process synchronisation. And so on.
>>>>
>>>> I think you're blowing this out of proportion. Just to restate the
>>>
>>> I just think that if there is a potentially cleaner solution without
>>> involving userspace, we should try to look for it first, even if it
>>> would take more time. That was the point.
>>
>> Regardless of whether or not we can eliminate that need, at least it'll
>> be a relaxing of the restriction, not an increase of it. It'll never
>> hurt to do an extra system call for the case where you're swapping fds.
>> I do get your point, I just don't think it's a big deal.
> 
> BTW, I don't see how we can ever get rid of a need to enter the kernel,
> we'd need some chance at grabbing the updated ->files, for instance.

Thanks for taking a look.
Yeah, agree, it should get it from somewhere, and that reminds me that
we have a similar situation with sqo_mm -- it grabs it from the
task-creator and keeps it to the end... Do we really need to set
->files of another thread? Retaining to the end seem to work well
enough with mm. And we need, then it would be more consistent
to replace mm there as well.

> Might be possible to hold a reference to the task and grab it from
> there, though feels a bit iffy to hold a task reference from the ring on
> the task that holds a reference to the ring. Haven't looked too close,
> should work though as this won't hold a file/files reference, it's just
> a freeing reference.

BTW, if the process-creator dies, then its ->files might be killed
and ->sqo_files become dangling, so should be invalidated. Your
approach with a task's reference probably handles it naturally.

-- 
Pavel Begunkov
