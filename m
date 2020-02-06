Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0F95F154BC5
	for <lists+io-uring@lfdr.de>; Thu,  6 Feb 2020 20:15:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727791AbgBFTPv (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 6 Feb 2020 14:15:51 -0500
Received: from mail-io1-f68.google.com ([209.85.166.68]:42178 "EHLO
        mail-io1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727703AbgBFTPv (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 6 Feb 2020 14:15:51 -0500
Received: by mail-io1-f68.google.com with SMTP id s6so7476322iol.9
        for <io-uring@vger.kernel.org>; Thu, 06 Feb 2020 11:15:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=Yyz692Z6QnWkYdRBwPjOV5YRM7wE4OOKfECgwMN1dhg=;
        b=Grq6uFMgAOnJdzWKvD6ZREbmfO9JcWzNoe0EBRumz6W7fuDuDuTj/fMO82/kOD32Yw
         gR5aluhel4VewaE9wMutb9gi4yhS+KUBIvNGv66ywt7H+XvGB4z0PiFBSmo2H7Op8zf0
         hxwwN+ZEaxnAlo0/H2MDU85KF+qTk/2SWLMwiniMlqailA+T8U/uW4RGVVi4jgvyxfi4
         VMjc9z9cA9zyxlIfQmtvefIjFs60wIJMyYQ2rTu5n5Ta+R45zP411g0UivDzTIJM2cH1
         Ew1ace86wpP0pNy9E0uDWCZKxRQpDdle7AiiUWxSHG1yN8px1wO4P5ZpCJdMUnWXFd9W
         yOcg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=Yyz692Z6QnWkYdRBwPjOV5YRM7wE4OOKfECgwMN1dhg=;
        b=iCxZ8hw/b3oHagYi48LX3YzNH5oVMco+9cR7O7i2i7c7iMp5hf7jVE3BlISC612PFT
         QgzMowKc/CYVt9FL6dnvNvY+32nLVSUyAb0nLNXDuAYlpJS8/RfvkFwytt65c+b+dX9d
         uxsDVyARWIumuTDvZO3P2Bui0HsjoUa/1aX42wwjFdNhq/OvzMjKmFwa7IfjK+2St04e
         kVoN8D5nBNrelh+s1sabsPoTRXx+2F8jijViDKuIWRQokAXm+2HgSlgfZQUlQBqCoFSZ
         ax2VEU4mNtfXpMftbU81M3HFUyXsMWprUHBr/DfdbrjOOrf4VRe8Ur2CdbSnf2y9/O2s
         pHyA==
X-Gm-Message-State: APjAAAXmReAe+Fq/SgWLk2zp2+NIaqTepKKR7sX+x6if62Pq22lQnvJ4
        CGktzMNrsp3J+++5D50Zed0tVW6E/hY=
X-Google-Smtp-Source: APXvYqwAxlKBt6Kt7Uflv0GyW7aV1XqUXFmjeffsl54SJmX9ITExxUiW4HOZ1WOmH/79aGBqOtrLAw==
X-Received: by 2002:a5e:9246:: with SMTP id z6mr35891873iop.232.1581016550692;
        Thu, 06 Feb 2020 11:15:50 -0800 (PST)
Received: from [192.168.1.159] ([65.144.74.34])
        by smtp.gmail.com with ESMTPSA id i11sm132553ion.1.2020.02.06.11.15.49
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 06 Feb 2020 11:15:50 -0800 (PST)
Subject: Re: [PATCH liburing v2 0/1] test: add epoll test case
To:     Stefano Garzarella <sgarzare@redhat.com>
Cc:     linux-kernel@vger.kernel.org, io-uring@vger.kernel.org
References: <20200131142943.120459-1-sgarzare@redhat.com>
 <ebc2efdb-4e7f-0db9-ef04-c02aac0b08b1@kernel.dk>
 <CAGxU2F6qvW28=ULNUi-UHethus2bO6VXYX127HOcH_KPToZC-w@mail.gmail.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <ec04cb8f-01e8-6289-2fd4-6dec8a8e2c02@kernel.dk>
Date:   Thu, 6 Feb 2020 12:15:49 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.4.1
MIME-Version: 1.0
In-Reply-To: <CAGxU2F6qvW28=ULNUi-UHethus2bO6VXYX127HOcH_KPToZC-w@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 2/6/20 10:33 AM, Stefano Garzarella wrote:
> 
> 
> On Fri, Jan 31, 2020 at 4:39 PM Jens Axboe <axboe@kernel.dk> wrote:
>>
>> On 1/31/20 7:29 AM, Stefano Garzarella wrote:
>>> Hi Jens,
>>> this is a v2 of the epoll test.
>>>
>>> v1 -> v2:
>>>     - if IORING_FEAT_NODROP is not available, avoid to overflow the CQ
>>>     - add 2 new tests to test epoll with IORING_FEAT_NODROP
>>>     - cleanups
>>>
>>> There are 4 sub-tests:
>>>     1. test_epoll
>>>     2. test_epoll_sqpoll
>>>     3. test_epoll_nodrop
>>>     4. test_epoll_sqpoll_nodrop
>>>
>>> In the first 2 tests, I try to avoid to queue more requests than we have room
>>> for in the CQ ring. These work fine, I have no faults.
>>
>> Thanks!
>>
>>> In the tests 3 and 4, if IORING_FEAT_NODROP is supported, I try to submit as
>>> much as I can until I get a -EBUSY, but they often fail in this way:
>>> the submitter manages to submit everything, the receiver receives all the
>>> submitted bytes, but the cleaner loses completion events (I also tried to put a
>>> timeout to epoll_wait() in the cleaner to be sure that it is not related to the
>>> patch that I send some weeks ago, but the situation doesn't change, it's like
>>> there is still overflow in the CQ).
>>>
>>> Next week I'll try to investigate better which is the problem.
>>
>> Does it change if you have an io_uring_enter() with GETEVENTS set? I wonder if
>> you just pruned the CQ ring but didn't flush the internal side.
> 
> If I do io_uring_enter() with GETEVENTS set and wait_nr = 0 it solves
> the issue, I think because we call io_cqring_events() that flushes the
> overflow list.
> 
> At this point, should we call io_cqring_events() (that flushes the
> overflow list) in io_uring_poll()?
> I mean something like this:
> 
> diff --git a/fs/io_uring.c b/fs/io_uring.c
> index 77f22c3da30f..2769451af89a 100644
> --- a/fs/io_uring.c
> +++ b/fs/io_uring.c
> @@ -6301,7 +6301,7 @@ static __poll_t io_uring_poll(struct file *file, poll_table *wait)
>         if (READ_ONCE(ctx->rings->sq.tail) - ctx->cached_sq_head !=
>             ctx->rings->sq_ring_entries)
>                 mask |= EPOLLOUT | EPOLLWRNORM;
> -       if (READ_ONCE(ctx->rings->cq.head) != ctx->cached_cq_tail)
> +       if (!io_cqring_events(ctx, false))
>                 mask |= EPOLLIN | EPOLLRDNORM;
> 
>         return mask;

That's not a bad idea, would just have to verify that it is indeed safe
to always call the flushing variant from there.

-- 
Jens Axboe

