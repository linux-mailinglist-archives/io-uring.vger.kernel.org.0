Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7282C1BAED1
	for <lists+io-uring@lfdr.de>; Mon, 27 Apr 2020 22:08:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726641AbgD0UI3 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 27 Apr 2020 16:08:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59468 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726789AbgD0UI3 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 27 Apr 2020 16:08:29 -0400
Received: from mail-pj1-x1043.google.com (mail-pj1-x1043.google.com [IPv6:2607:f8b0:4864:20::1043])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 898F2C0610D5
        for <io-uring@vger.kernel.org>; Mon, 27 Apr 2020 13:08:29 -0700 (PDT)
Received: by mail-pj1-x1043.google.com with SMTP id e6so99744pjt.4
        for <io-uring@vger.kernel.org>; Mon, 27 Apr 2020 13:08:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=1ShJY97ZCiJN26A/m9Pl13+gxvYlJRi5H/MBiRQCKAA=;
        b=pPb/6UyxYym50tDXhyX1a2Dt0ycYdFDEFleuNy9likSHZM1YDH/Mwy/APDqV/HMClC
         Y99Jvj/GcprY0ku8mhhvp2uqwuEYkzr4P+OMwIYuchQEK7Z8Bm5iuR1+7WjAvYI9wqkx
         p6Li2CEx9EuPpX5CDgKzcqdBwU2ZB0dAoGSRUR0qe/GIWo10QkZ+AU0N/itvqQ1BEsAr
         I7FfxRXZ74oMcclJ2CTp77m4lrecsIOYhh7uhjl/vCUnEOtRS11RqVqDGkVmp4IOtsvg
         ktPmQqeCBRPFr3m9H9rH2Lr9OdV65yFCwef0lNvU6WDuOkWlfn/vtKHfFXD7y3HjYte2
         RGyQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=1ShJY97ZCiJN26A/m9Pl13+gxvYlJRi5H/MBiRQCKAA=;
        b=eXl17Mr0sHky0bTclEPJkziO3PaV3gaDSTq2oVbK1K5pzUjwHdrn2gUiUYR4IGC4Cw
         5wWEUzXcZmnOfyuOHqLF0Cj5def7UBsPXJI2xepvrAnyEg+0vpMQggs2mFOYsXCj9omz
         lbTy7d9Qukj6q88ztsW4ee6g993nit7IEQGDlfqTE963Zc4lSZNgEMLVjUrYCDSOuod3
         o1Ocx+KQCnPEIStjSVCHiuyNTHh+xUj1ShLL+wUgGFuqRXaxZZthiRnApEWTgeU8GxBx
         dBT2U2V/B219IQd/XrYGAnP5aTk+sJtqBoLIAz5jpt2ARp3xJRbXchQe8Za2aqPHezmC
         scVg==
X-Gm-Message-State: AGi0PuZn0UqJsb3x7qkMw1M9mshcrpJUvkPD2D5ChazuR51c3cwCczNX
        bfU5RihwW6v2wZ3cZ+tHiqYfu9HXMIuSww==
X-Google-Smtp-Source: APiQypKcScA7Ko4tejh9itu5hKiarr5afUS+iaM7D2DRTjJkJ4oHtScMvoMG59upANfBpyoSmGb0HQ==
X-Received: by 2002:a17:90b:8d7:: with SMTP id ds23mr432561pjb.39.1588018108641;
        Mon, 27 Apr 2020 13:08:28 -0700 (PDT)
Received: from [192.168.1.188] ([66.219.217.145])
        by smtp.gmail.com with ESMTPSA id g40sm113985pje.38.2020.04.27.13.08.27
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 27 Apr 2020 13:08:28 -0700 (PDT)
Subject: Re: io_uring, IORING_OP_RECVMSG and ancillary data
To:     Jann Horn <jannh@google.com>
Cc:     Andreas Smas <andreas@lonelycoder.com>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        io-uring <io-uring@vger.kernel.org>
References: <CAObFT-S27KXFGomqPZdXA8oJDe6QxmoT=T6CBgD9R9UHNmakUQ@mail.gmail.com>
 <f75d30ff-53ec-c3a1-19b2-956735d44088@kernel.dk>
 <CAG48ez32nkvLsWStjenGmZdLaSPKWEcSccPKqgPtJwme8ZxxuQ@mail.gmail.com>
 <bd37ec95-2b0b-40fc-8c86-43805e2990aa@kernel.dk>
 <45d7558a-d0c8-4d3f-c63a-33fd2fb073a5@kernel.dk>
 <CAG48ez0pHbz3qvjQ+N6r0HfAgSYdDnV1rGy3gCzcuyH6oiMhBQ@mail.gmail.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <217dc782-161f-7aea-2d18-4e88526b8e1d@kernel.dk>
Date:   Mon, 27 Apr 2020 14:08:25 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.7.0
MIME-Version: 1.0
In-Reply-To: <CAG48ez0pHbz3qvjQ+N6r0HfAgSYdDnV1rGy3gCzcuyH6oiMhBQ@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 4/27/20 2:03 PM, Jann Horn wrote:
> On Mon, Apr 27, 2020 at 9:53 PM Jens Axboe <axboe@kernel.dk> wrote:
>> On 4/27/20 1:29 PM, Jens Axboe wrote:
>>> On 4/27/20 1:20 PM, Jann Horn wrote:
>>>> On Sat, Apr 25, 2020 at 10:23 PM Jens Axboe <axboe@kernel.dk> wrote:
>>>>> On 4/25/20 11:29 AM, Andreas Smas wrote:
>>>>>> Hi,
>>>>>>
>>>>>> Tried to use io_uring with OP_RECVMSG with ancillary buffers (for my
>>>>>> particular use case I'm using SO_TIMESTAMP for incoming UDP packets).
>>>>>>
>>>>>> These submissions fail with EINVAL due to the check in __sys_recvmsg_sock().
>>>>>>
>>>>>> The following hack fixes the problem for me and I get valid timestamps
>>>>>> back. Not suggesting this is the real fix as I'm not sure what the
>>>>>> implications of this is.
>>>>>>
>>>>>> Any insight into this would be much appreciated.
>>>>>
>>>>> It was originally disabled because of a security issue, but I do think
>>>>> it's safe to enable again.
>>>>>
>>>>> Adding the io-uring list and Jann as well, leaving patch intact below.
>>>>>
>>>>>> diff --git a/net/socket.c b/net/socket.c
>>>>>> index 2dd739fba866..689f41f4156e 100644
>>>>>> --- a/net/socket.c
>>>>>> +++ b/net/socket.c
>>>>>> @@ -2637,10 +2637,6 @@ long __sys_recvmsg_sock(struct socket *sock,
>>>>>> struct msghdr *msg,
>>>>>>                         struct user_msghdr __user *umsg,
>>>>>>                         struct sockaddr __user *uaddr, unsigned int flags)
>>>>>>  {
>>>>>> -       /* disallow ancillary data requests from this path */
>>>>>> -       if (msg->msg_control || msg->msg_controllen)
>>>>>> -               return -EINVAL;
>>>>>> -
>>>>>>         return ____sys_recvmsg(sock, msg, umsg, uaddr, flags, 0);
>>>>>>  }
>>>>
>>>> I think that's hard to get right. In particular, unix domain sockets
>>>> can currently pass file descriptors in control data - so you'd need to
>>>> set the file_table flag for recvmsg and sendmsg. And I'm not sure
>>>> whether, to make this robust, there should be a whitelist of types of
>>>> control messages that are permitted to be used with io_uring, or
>>>> something like that...
>>>>
>>>> I think of ancillary buffers as being kind of like ioctl handlers in
>>>> this regard.
>>>
>>> Good point. I'll send out something that hopefully will be enough to
>>> be useful, whole not allowing anything randomly.
>>
>> That things is a bit of a mess... How about something like this for
>> starters?
> [...]
>> +static bool io_net_allow_cmsg(struct msghdr *msg)
>> +{
>> +       struct cmsghdr *cmsg;
>> +
>> +       for_each_cmsghdr(cmsg, msg) {
> 
> Isn't this going to dereference a userspace pointer? ->msg_control has
> not been copied into the kernel at this point, right?

Possibly... Totally untested, maybe I forgot to mention that :-)
I'll check.

The question was more "in principle" if this was a viable approach. The
whole cmsg_type and cmsg_level is really a mess.

-- 
Jens Axboe

