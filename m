Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6528921798E
	for <lists+io-uring@lfdr.de>; Tue,  7 Jul 2020 22:40:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728748AbgGGUkK (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 7 Jul 2020 16:40:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53806 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728347AbgGGUkJ (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 7 Jul 2020 16:40:09 -0400
Received: from mail-io1-xd42.google.com (mail-io1-xd42.google.com [IPv6:2607:f8b0:4864:20::d42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BDCC3C061755
        for <io-uring@vger.kernel.org>; Tue,  7 Jul 2020 13:40:09 -0700 (PDT)
Received: by mail-io1-xd42.google.com with SMTP id v6so30989912iob.4
        for <io-uring@vger.kernel.org>; Tue, 07 Jul 2020 13:40:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=6BcRRLzOR9a+EmqTy6ErKRyeDhziM18eSEgk9TnV5Yg=;
        b=IQ2Ri285jvhwaFWJllN7Q9RHvfmiak2Yupr2qv/DT/f+pxd3w1HVP5xWzsWCSPuFda
         VF5MBmEQHhhRva0nUZay4UpGEXn8CWI5lmUIndEXJaz6DbqnfRJwb1xLlHyxdRr52PST
         lWdHUF9tLXdy55y6toJX8gYZck7SuqMGVMOBTL3QCSKRdQp6CrhEZPu9ZRpLPUHeIYZ9
         AETpjxE475grhRKQ9wYVbKrSYCXCgo8L4fgLpm0c4JuZlO6Abi3lPQ/+AoABCPetJTGp
         66spIEzwQWKJc2mPi8baE227fPgWFD+yhmTASzJxKHt6oxQglMxuyJq246/2+vM/lk7a
         3Zhw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=6BcRRLzOR9a+EmqTy6ErKRyeDhziM18eSEgk9TnV5Yg=;
        b=Mn7DNHJTVMNCiYeobQk+AxWtbf2S5fcij3QywJpmjesHKcXPxRpdjYYsKTRYvxT7wz
         5vtrKHTlptjZOIk2NUl067T/V5edp7VySgIkB5c2Stio6V1WtpiVR2gV7fXBjRAY0c1a
         9sYqxGd7/wcn0zuDoluItHxmAzQ0bskJsfNfPAghSYnE+Qcs7C84gbUP9nwFFpgbmqFt
         aBCJ+gDdMG7FuuFwGzWyIbHdWad53bFgEpVeiFMOY/Opv8jyMQsCxP/pgAOzbFmtWKaP
         UFgSj1pW3J5ZBXS9BjoNS/rNeQvoTBOkIfJ1gyI3p88pjnUT0OII/UrvaBfnibDl7Ood
         /plw==
X-Gm-Message-State: AOAM533FaC0MMQtqhYO/K4VQYMnZmeGDNoCbydCdOmnHEekMa/ED4Rjv
        NrweNiACZH1lMxYlironrnj3Jk62NiZvDw==
X-Google-Smtp-Source: ABdhPJxebRGc83pzGSG/E6dbpIhDmfmgCpDogiz6BeHTBx5v4jcdBAvuJq2/4tx4nD3aGNga5j5iWw==
X-Received: by 2002:a5e:c311:: with SMTP id a17mr3667434iok.12.1594154408972;
        Tue, 07 Jul 2020 13:40:08 -0700 (PDT)
Received: from [192.168.1.58] ([65.144.74.34])
        by smtp.gmail.com with ESMTPSA id v4sm13400907ilo.44.2020.07.07.13.40.07
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 07 Jul 2020 13:40:08 -0700 (PDT)
Subject: Re: [PATCH v3 4/4] io_uring: add support for zone-append
To:     Kanchan Joshi <joshi.k@samsung.com>,
        Matthew Wilcox <willy@infradead.org>
Cc:     viro@zeniv.linux.org.uk, bcrl@kvack.org, hch@infradead.org,
        Damien.LeMoal@wdc.com, asml.silence@gmail.com,
        linux-fsdevel@vger.kernel.org, mb@lightnvm.io,
        linux-kernel@vger.kernel.org, linux-aio@kvack.org,
        io-uring@vger.kernel.org, linux-block@vger.kernel.org,
        Selvakumar S <selvakuma.s1@samsung.com>,
        Nitesh Shetty <nj.shetty@samsung.com>,
        Javier Gonzalez <javier.gonz@samsung.com>
References: <CGME20200705185227epcas5p16fba3cb92561794b960184c89fdf2bb7@epcas5p1.samsung.com>
 <1593974870-18919-5-git-send-email-joshi.k@samsung.com>
 <fe0066b7-5380-43ee-20b2-c9b17ba18e4f@kernel.dk>
 <20200705210947.GW25523@casper.infradead.org>
 <239ee322-9c38-c838-a5b2-216787ad2197@kernel.dk>
 <20200706141002.GZ25523@casper.infradead.org>
 <4a9bf73e-f3ee-4f06-7fad-b8f8861b0bc1@kernel.dk>
 <20200706143208.GA25523@casper.infradead.org>
 <20200707151105.GA23395@test-zns>
 <20200707155237.GM25523@casper.infradead.org>
 <20200707202342.GA28364@test-zns>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <7a44d9c6-bf7d-0666-fc29-32c3cba9d1d8@kernel.dk>
Date:   Tue, 7 Jul 2020 14:40:06 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.8.0
MIME-Version: 1.0
In-Reply-To: <20200707202342.GA28364@test-zns>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 7/7/20 2:23 PM, Kanchan Joshi wrote:
> On Tue, Jul 07, 2020 at 04:52:37PM +0100, Matthew Wilcox wrote:
>> On Tue, Jul 07, 2020 at 08:41:05PM +0530, Kanchan Joshi wrote:
>>> On Mon, Jul 06, 2020 at 03:32:08PM +0100, Matthew Wilcox wrote:
>>>> On Mon, Jul 06, 2020 at 08:27:17AM -0600, Jens Axboe wrote:
>>>>> On 7/6/20 8:10 AM, Matthew Wilcox wrote:
>>>>>> On Sun, Jul 05, 2020 at 03:12:50PM -0600, Jens Axboe wrote:
>>>>>>> On 7/5/20 3:09 PM, Matthew Wilcox wrote:
>>>>>>>> On Sun, Jul 05, 2020 at 03:00:47PM -0600, Jens Axboe wrote:
>>>>>>>>> On 7/5/20 12:47 PM, Kanchan Joshi wrote:
>>>>>>>>>> From: Selvakumar S <selvakuma.s1@samsung.com>
>>>>>>>>>>
>>>>>>>>>> For zone-append, block-layer will return zone-relative offset via ret2
>>>>>>>>>> of ki_complete interface. Make changes to collect it, and send to
>>>>>>>>>> user-space using cqe->flags.
>>>>>>
>>>>>>>> I'm surprised you aren't more upset by the abuse of cqe->flags for the
>>>>>>>> address.
>>>
>>> Documentation (https://protect2.fireeye.com/url?k=297dbcbf-74aee030-297c37f0-0cc47a31ce52-632d3561909b91fc&q=1&u=https%3A%2F%2Fkernel.dk%2Fio_uring.pdf) mentioned cqe->flags can carry
>>> the metadata for the operation. I wonder if this should be called abuse.
>>>
>>>>>>> Yeah, it's not great either, but we have less leeway there in terms of
>>>>>>> how much space is available to pass back extra data.
>>>>>>>
>>>>>>>> What do you think to my idea of interpreting the user_data as being a
>>>>>>>> pointer to somewhere to store the address?  Obviously other things
>>>>>>>> can be stored after the address in the user_data.
>>>>>>>
>>>>>>> I don't like that at all, as all other commands just pass user_data
>>>>>>> through. This means the application would have to treat this very
>>>>>>> differently, and potentially not have a way to store any data for
>>>>>>> locating the original command on the user side.
>>>>>>
>>>>>> I think you misunderstood me.  You seem to have thought I meant
>>>>>> "use the user_data field to return the address" when I actually meant
>>>>>> "interpret the user_data field as a pointer to where userspace
>>>>>> wants the address stored".
>>>>>
>>>>> It's still somewhat weird to have user_data have special meaning, you're
>>>>> now having the kernel interpret it while every other command it's just
>>>>> an opaque that is passed through.
>>>>>
>>>>> But it could of course work, and the app could embed the necessary
>>>>> u32/u64 in some other structure that's persistent across IO. If it
>>>>> doesn't have that, then it'd need to now have one allocated and freed
>>>>> across the lifetime of the IO.
>>>>>
>>>>> If we're going that route, it'd be better to define the write such that
>>>>> you're passing in the necessary information upfront. In syscall terms,
>>>>> then that'd be something ala:
>>>>>
>>>>> ssize_t my_append_write(int fd, const struct iovec *iov, int iovcnt,
>>>>> 			off_t *offset, int flags);
>>>>>
>>>>> where *offset is copied out when the write completes. That removes the
>>>>> need to abuse user_data, with just providing the storage pointer for the
>>>>> offset upfront.
>>>>
>>>> That works for me!  In io_uring terms, would you like to see that done
>>>> as adding:
>>>>
>>>>        union {
>>>>                __u64   off;    /* offset into file */
>>>> +		__u64   *offp;	/* appending writes */
>>>>                __u64   addr2;
>>>>        };
>>> But there are peformance implications of this approach?
>>> If I got it right, the workflow is: - Application allocates 64bit of space,
>>> writes "off" into it and pass it
>>>  in the sqe->addr2
>>> - Kernel first reads sqe->addr2, reads the value to know the intended
>>>  write-location, and stores the address somewhere (?) to be used during
>>>  completion. Storing this address seems tricky as this may add one more
>>>  cacheline (in io_kiocb->rw)?
>>
>> io_kiocb is:
>>        /* size: 232, cachelines: 4, members: 19 */
>>        /* forced alignments: 1 */
>>        /* last cacheline: 40 bytes */
>> so we have another 24 bytes before io_kiocb takes up another cacheline.
>> If that's a serious problem, I have an idea about how to shrink struct
>> kiocb by 8 bytes so struct io_rw would have space to store another
>> pointer.
> Yes, io_kiocb has room. Cache-locality wise whether that is fine or
> it must be placed within io_rw - I'll come to know once I get to
> implement this. Please share the idea you have, it can come handy.

Except it doesn't, I'm not interested in adding per-request type fields
to the generic part of it. Before we know it, we'll blow past the next
cacheline.

If we can find space in the kiocb, that'd be much better. Note that once
the async buffered bits go in for 5.9, then there's no longer a 4-byte
hole in struct kiocb.

>> ... we've just done an I/O.  Concern about an extra pointer access
>> seems misplaced?
> 
> I was thinking about both read-from (submission) and write-to
> (completion) from user-space pointer, and all those checks APIs
> (get_user, copy_from_user) perform.....but when seen against I/O (that
> too direct), it does look small. Down the line it may matter for cached-IO
> but I get your point. 

Really don't think that matters at all.

-- 
Jens Axboe

