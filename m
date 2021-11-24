Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7970F45C702
	for <lists+io-uring@lfdr.de>; Wed, 24 Nov 2021 15:14:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346072AbhKXORw (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 24 Nov 2021 09:17:52 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:51076 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1352902AbhKXORR (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 24 Nov 2021 09:17:17 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1637763247;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=A0hMqTI5hxUUo1KE4RdPFoMNQwfcw+L7bEYYOFYe8Bc=;
        b=GlsaFvyIoYmgQNn/h3ID5KiIa4366/RHCq5dSY7G/qu6U3raVDppUyDS7nPnwj2aa/6Vmp
        Jf1DD2JNhspehdC+ic8d3HTNv4zXVbV77mstqVo6cHOpGGuGolhbF1/uIotTjAESPiwxvh
        qeMAUpBknQzxVxRT0AG+G3f/RXiXEFI=
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com
 [209.85.221.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-424-TZH-G9k8OCSM4HivRjrG2w-1; Wed, 24 Nov 2021 09:14:03 -0500
X-MC-Unique: TZH-G9k8OCSM4HivRjrG2w-1
Received: by mail-wr1-f70.google.com with SMTP id u4-20020a5d4684000000b0017c8c1de97dso521421wrq.16
        for <io-uring@vger.kernel.org>; Wed, 24 Nov 2021 06:14:03 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent
         :content-language:to:cc:references:from:organization:subject
         :in-reply-to:content-transfer-encoding;
        bh=A0hMqTI5hxUUo1KE4RdPFoMNQwfcw+L7bEYYOFYe8Bc=;
        b=nPVNGEE8KsmGNXMqzHW9cJ8WxeQLX5Irot1FnxVNIlxApsyxqgf0yA5Dlti9YnV85w
         n6Kjn+623NE9+La3QRtu3vMSIazDhBixoy4DWMU76g8/TkHy/2Emuqf8kyTj/w6S6bEi
         zH83q3GuTS79YIYzX/bxlCjEVvCJGH+9ij99rksbr69/OSZHf9H9ICfE9sU/QRKX7sLd
         gipO1os6am3QuPlV/+YjMNuKYIBg0k6Tcz30EhTpQVbLMMMQdYAuaJ7J4GMkKwzFgkzk
         PHoCV/1nn4WaHb74GhMI4bxrbda6dJ37o8E4319GmPEf3fuVvFb5lCtfJLKg9h7DyGx5
         iwgg==
X-Gm-Message-State: AOAM5331lG15h40HSvbVe5eCjljCNutI6yckB1WJZrg1CnLkWgWsCRYD
        AOYy5iEZdvRoYx8Nq8kK2tzzSAEQO4BOsMDQz7h0zZE88/LfJAN1jAf03XFLFtgN534lQ/tgeg2
        w+GvQBwkz4h+5EkgGspM=
X-Received: by 2002:a05:6000:1688:: with SMTP id y8mr19601106wrd.420.1637763242086;
        Wed, 24 Nov 2021 06:14:02 -0800 (PST)
X-Google-Smtp-Source: ABdhPJxdkou+qBB9GG+jRq/G6D/I52HGfNekynPXgY61AlkHyvU+ti72rYSCp74uc0+h1LMfZ20aog==
X-Received: by 2002:a05:6000:1688:: with SMTP id y8mr19601060wrd.420.1637763241798;
        Wed, 24 Nov 2021 06:14:01 -0800 (PST)
Received: from [192.168.3.132] (p5b0c6380.dip0.t-ipconnect.de. [91.12.99.128])
        by smtp.gmail.com with ESMTPSA id w4sm15340334wrs.88.2021.11.24.06.14.00
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 24 Nov 2021 06:14:01 -0800 (PST)
Message-ID: <2cdbebb9-4c57-7839-71ab-166cae168c74@redhat.com>
Date:   Wed, 24 Nov 2021 15:14:00 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.2.0
Content-Language: en-US
To:     Jason Gunthorpe <jgg@ziepe.ca>
Cc:     Vlastimil Babka <vbabka@suse.cz>, Jens Axboe <axboe@kernel.dk>,
        Andrew Dona-Couch <andrew@donacou.ch>,
        Andrew Morton <akpm@linux-foundation.org>,
        Drew DeVault <sir@cmpwn.com>,
        Ammar Faizi <ammarfaizi2@gnuweeb.org>,
        linux-kernel@vger.kernel.org, linux-api@vger.kernel.org,
        io_uring Mailing List <io-uring@vger.kernel.org>,
        Pavel Begunkov <asml.silence@gmail.com>, linux-mm@kvack.org
References: <20211123140709.GB5112@ziepe.ca>
 <e4d7d211-5d62-df89-8f94-e49385286f1f@redhat.com>
 <20211123170056.GC5112@ziepe.ca>
 <dd92a69a-6d09-93a1-4f50-5020f5cc59d0@suse.cz>
 <20211123235953.GF5112@ziepe.ca>
 <2adca04f-92e1-5f99-6094-5fac66a22a77@redhat.com>
 <20211124132353.GG5112@ziepe.ca>
 <cca0229e-e53e-bceb-e215-327b6401f256@redhat.com>
 <20211124132842.GH5112@ziepe.ca>
 <eab5aeba-e064-9f3e-fbc3-f73cd299de83@redhat.com>
 <20211124134812.GI5112@ziepe.ca>
From:   David Hildenbrand <david@redhat.com>
Organization: Red Hat
Subject: Re: [PATCH] Increase default MLOCK_LIMIT to 8 MiB
In-Reply-To: <20211124134812.GI5112@ziepe.ca>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 24.11.21 14:48, Jason Gunthorpe wrote:
> On Wed, Nov 24, 2021 at 02:29:38PM +0100, David Hildenbrand wrote:
>> On 24.11.21 14:28, Jason Gunthorpe wrote:
>>> On Wed, Nov 24, 2021 at 02:25:09PM +0100, David Hildenbrand wrote:
>>>> On 24.11.21 14:23, Jason Gunthorpe wrote:
>>>>> On Wed, Nov 24, 2021 at 09:57:32AM +0100, David Hildenbrand wrote:
>>>>>
>>>>>> Unfortunately it will only be a band aid AFAIU. I can rewrite my
>>>>>> reproducer fairly easily to pin the whole 2M range first, pin a second
>>>>>> time only a single page, and then unpin the 2M range, resulting in the
>>>>>> very same way to block THP. (I can block some THP less because I always
>>>>>> need the possibility to memlock 2M first, though).
>>>>>
>>>>> Oh!
>>>>>
>>>>> The issue is GUP always pins an entire compound, no matter how little
>>>>> the user requests.
>>>>
>>>> That's a different issue. I make sure to split the compound page before
>>>> pinning anything :)
>>>
>>> ?? Where is that done in GUP?
>>
>> It's done in my reproducer manually.
> 
> Aren't there many ways for hostile unpriv userspace to cause memory
> fragmentation? You are picking on pinning here, but any approach that
> forces the kernel to make a kalloc on a THP subpage would do just as
> well.

I'm not aware of any where you can fragment 50% of all pageblocks in the
system as an unprivileged user essentially consuming almost no memory
and essentially staying inside well-defined memlock limits. But sure if
there are "many" people will be able to come up with at least one
comparable thing. I'll be happy to learn.

> 
> Arguably if we want to point to an issue here it is in MADV_FREE/etc
> that is the direct culprit in allowing userspace to break up THPs and
> then trigger fragmentation.
> 
> If the objective is to prevent DOS of THP then MADV_FREE should
> conserve the THP and migrate the subpages to non-THP
> memory.
> 
> FOLL_LONGTERM is not the issue here.

Thanks Jason for the discussion but this is where I'll opt out for now
because we seem to strongly disagree and as I said:

"I'm going to leave judgment how bad this is or isn't to the educated
reader, and I'll stop spending time on this as I have more important
things to work on."

But I'm going to leave one last comment to eventually give you a
different perspective: after MADV_DONTNEED the compound page sits on the
deferred split queue and will get split either way soon. People are
right now discussion upstream to even split synchronously, which would
move MADV_FREE out of the picture completely.

My position that FOLL_LONGTERM for unprivileged users is a strong no-go
stands as it is. Not MADV_FREE speeding up the compound page split in my
reproducer. Not MADV_DONTNEED allowing us to zap parts of a THP (I could
even have just used munmap or even mmap(MAP_FIXED)).

-- 
Thanks,

David / dhildenb

