Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5E7FA217953
	for <lists+io-uring@lfdr.de>; Tue,  7 Jul 2020 22:26:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728618AbgGGU0t (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 7 Jul 2020 16:26:49 -0400
Received: from mailout4.samsung.com ([203.254.224.34]:28386 "EHLO
        mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728699AbgGGU0s (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 7 Jul 2020 16:26:48 -0400
Received: from epcas5p4.samsung.com (unknown [182.195.41.42])
        by mailout4.samsung.com (KnoxPortal) with ESMTP id 20200707202643epoutp04a7bf38fab0dc942bb30a0058fe518349~fkkF5612Q0118001180epoutp04B
        for <io-uring@vger.kernel.org>; Tue,  7 Jul 2020 20:26:42 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout4.samsung.com 20200707202643epoutp04a7bf38fab0dc942bb30a0058fe518349~fkkF5612Q0118001180epoutp04B
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1594153603;
        bh=di5oLKKNJ2teDfCcdovos7BSFrPFNe8BpdT5LngXwkE=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=uG48wYBBbBfSJP3xDZYxdz/z5JuzWcIFthaniLgqyA8xxyBxEwi5sxSVk4pY308HG
         icslpKRsvhnZ0Hxsn9dE9N2K5IanvJOtb3hIQ0vJY1qIO7eO3zLr0wAICzYZkISg3X
         wmg1cVbFF/XyAlscl7JZbWmNwUj/0VjNuSTiIL2c=
Received: from epsmges5p3new.samsung.com (unknown [182.195.42.75]) by
        epcas5p3.samsung.com (KnoxPortal) with ESMTP id
        20200707202641epcas5p3b3fb45c52b37d706fc79acd7ad7d2b3a~fkkEna3921444914449epcas5p3c;
        Tue,  7 Jul 2020 20:26:41 +0000 (GMT)
Received: from epcas5p1.samsung.com ( [182.195.41.39]) by
        epsmges5p3new.samsung.com (Symantec Messaging Gateway) with SMTP id
        5C.A1.09475.18AD40F5; Wed,  8 Jul 2020 05:26:41 +0900 (KST)
Received: from epsmtrp2.samsung.com (unknown [182.195.40.14]) by
        epcas5p1.samsung.com (KnoxPortal) with ESMTPA id
        20200707202641epcas5p14cd9dddb04f5968593574ba5592016b6~fkkEJWsQ_0685206852epcas5p1U;
        Tue,  7 Jul 2020 20:26:41 +0000 (GMT)
Received: from epsmgms1p2.samsung.com (unknown [182.195.42.42]) by
        epsmtrp2.samsung.com (KnoxPortal) with ESMTP id
        20200707202641epsmtrp25d35c08b129cb404b940d20b559abc05~fkkEIalVq2592925929epsmtrp2d;
        Tue,  7 Jul 2020 20:26:41 +0000 (GMT)
X-AuditID: b6c32a4b-39fff70000002503-cf-5f04da8136d6
Received: from epsmtip2.samsung.com ( [182.195.34.31]) by
        epsmgms1p2.samsung.com (Symantec Messaging Gateway) with SMTP id
        0F.C4.08303.08AD40F5; Wed,  8 Jul 2020 05:26:41 +0900 (KST)
Received: from test-zns (unknown [107.110.206.5]) by epsmtip2.samsung.com
        (KnoxPortal) with ESMTPA id
        20200707202638epsmtip24e9e6769af4085fcfae77a47562709df~fkkB1ny-y0137001370epsmtip25;
        Tue,  7 Jul 2020 20:26:38 +0000 (GMT)
Date:   Wed, 8 Jul 2020 01:53:42 +0530
From:   Kanchan Joshi <joshi.k@samsung.com>
To:     Matthew Wilcox <willy@infradead.org>
Cc:     Jens Axboe <axboe@kernel.dk>, viro@zeniv.linux.org.uk,
        bcrl@kvack.org, hch@infradead.org, Damien.LeMoal@wdc.com,
        asml.silence@gmail.com, linux-fsdevel@vger.kernel.org,
        mb@lightnvm.io, linux-kernel@vger.kernel.org, linux-aio@kvack.org,
        io-uring@vger.kernel.org, linux-block@vger.kernel.org,
        Selvakumar S <selvakuma.s1@samsung.com>,
        Nitesh Shetty <nj.shetty@samsung.com>,
        Javier Gonzalez <javier.gonz@samsung.com>
Subject: Re: [PATCH v3 4/4] io_uring: add support for zone-append
Message-ID: <20200707202342.GA28364@test-zns>
MIME-Version: 1.0
In-Reply-To: <20200707155237.GM25523@casper.infradead.org>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrGKsWRmVeSWpSXmKPExsWy7bCmum7jLZZ4g00fFCzmrNrGaLH6bj+b
        Rde/LSwWre3fmCxOT1jEZPGu9RyLxeM7n9ktpkxrYrTYe0vbYs/ekywWl3fNYbNYsf0Ii8W2
        3/OZLa5MWcRs8frHSTaL83+Ps1r8/jGHzUHQY+esu+wem1doeVw+W+qx6dMkdo/uqz8YPfq2
        rGL0+LxJzqP9QDeTx6Ynb5kCOKO4bFJSczLLUov07RK4Mi5dbmcp2G5W8fH3C7YGxnnaXYyc
        HBICJhLv/59nArGFBHYzSpw/n9/FyAVkf2KUeNFxgBXC+cwo0flgAztMx+pfcxghOnYxSuyZ
        GwpR9IxR4tebLWwgCRYBFYnLCyexdDFycLAJaEpcmFwKYooIaEi82WIEUs4ssJJZYkbLGxaQ
        cmEBR4nPO0+CzeQV0JX43b+CFcIWlDg58wlYDaeAlcSmxllgtqiAssSBbceZQAZJCDzhkLh4
        7iwjxHEuEk/Xr2OCsIUlXh3fAnW0lMTnd3vZIOxiiV93jjJDNHcwSlxvmMkCkbCXuLjnL1gz
        s0CGxKYVv9kgbD6J3t9PmEA+kBDglehoE4IoV5S4N+kpK4QtLvFwxhIo20PiWPMFJkigTGGR
        uLH6P9sERrlZSB6ahWQFhG0l0fmhiXUW0ApmAWmJ5f84IExNifW79Bcwsq5ilEwtKM5NTy02
        LTDOSy3XK07MLS7NS9dLzs/dxAhOelreOxgfPfigd4iRiYPxEKMEB7OSCG+vNmO8EG9KYmVV
        alF+fFFpTmrxIUZpDhYlcV6lH2fihATSE0tSs1NTC1KLYLJMHJxSDUxLDO3WTrsmbj1/1Ve7
        4/K26YfZTvDsXp5q1tbKlfLCS/EWT/JM5ZMZh3V+7nmx9IjnHsUzM8VlC/syf66xaS45OUvn
        85mp0X9mWodrlS9TurVF/tY953duMiWtqg2NU45GnbqRzSUfdMfw/amlBoyvDmytWJ83Y3vP
        8qv6vw6ecWTY/eb+0nDtSdXzTjMp1K3b+nDZofkFDwVLjsf1RyyS/P9qefI51sP6ey2DRH3L
        P1pNkep7wu42mbXdnHfKqeXH9IwetR+tCT/5Z1Kj5Z2u7IOXN//79az6a2Tgvo0fpvq5/vvf
        emt1/ZYI/rK4jku//R5Y1fofnM9rlxnY8O/uyTfV8yddbXW08tO6O8VVRYmlOCPRUIu5qDgR
        AOc3r/npAwAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrAIsWRmVeSWpSXmKPExsWy7bCSvG7jLZZ4g97nTBZzVm1jtFh9t5/N
        ouvfFhaL1vZvTBanJyxisnjXeo7F4vGdz+wWU6Y1MVrsvaVtsWfvSRaLy7vmsFms2H6ExWLb
        7/nMFlemLGK2eP3jJJvF+b/HWS1+/5jD5iDosXPWXXaPzSu0PC6fLfXY9GkSu0f31R+MHn1b
        VjF6fN4k59F+oJvJY9OTt0wBnFFcNimpOZllqUX6dglcGdOOnGEveGlc0bNmM3sD4yuNLkZO
        DgkBE4nVv+YwdjFycQgJ7GCUaP2wjgUiIS7RfO0HO4QtLLHy33N2iKInjBJHny9nAkmwCKhI
        XF44CaiBg4NNQFPiwuRSEFNEQEPizRYjkHJmgbXMEmf/T2MGKRcWcJT4vPMkI4jNK6Ar8bt/
        BSvEzCksEu92PmeHSAhKnJz5BOwIZgEziXmbHzKDDGUWkJZY/o8DJMwpYCWxqXEWWImogLLE
        gW3HmSYwCs5C0j0LSfcshO4FjMyrGCVTC4pz03OLDQuM8lLL9YoTc4tL89L1kvNzNzGCI1FL
        awfjnlUf9A4xMnEwHmKU4GBWEuHt1WaMF+JNSaysSi3Kjy8qzUktPsQozcGiJM77ddbCOCGB
        9MSS1OzU1ILUIpgsEwenVAOTS431diGGOyu5XZ1KP8vMO2LtxcN+3y1vR3Zn5GQ7n8fBW4O1
        tqw60PuI4/HJyIDtWpE/Zn6q/6FeuflMqdu+PM+nc/5EhMyJrPwQuCTAYkvx976rf65e3N4e
        bvIp+eauI0pLPXaesdb/P6du+9IX+7hmMDVGLmta//pD/Pw69yVczfLvE+YpZWXf8lBenfwu
        9JUEh8C+V4U7uXxPPYr4mNwQ35y79ce7kCgLF++bbzbazL8bvM45U+OpXd1zzXbOXcxK/9l/
        /4u34jjDM6+K2/qC7VaHB0uC+rSZTeIWJN/YXyXyMDHeevH03RbrJ+nN9KgsbnjDcjpwwkaH
        6k/zq0Uvn7wq25TnZ18QY3ZbiaU4I9FQi7moOBEAZabiDTMDAAA=
X-CMS-MailID: 20200707202641epcas5p14cd9dddb04f5968593574ba5592016b6
X-Msg-Generator: CA
Content-Type: multipart/mixed;
        boundary="----nai8lIH9ngBNHun9R6qswQcIIemhXBCkNXu5CagZqSM5j8ea=_e3847_"
CMS-TYPE: 105P
X-CMS-RootMailID: 20200705185227epcas5p16fba3cb92561794b960184c89fdf2bb7
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
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

------nai8lIH9ngBNHun9R6qswQcIIemhXBCkNXu5CagZqSM5j8ea=_e3847_
Content-Type: text/plain; charset="utf-8"; format="flowed"
Content-Disposition: inline

On Tue, Jul 07, 2020 at 04:52:37PM +0100, Matthew Wilcox wrote:
>On Tue, Jul 07, 2020 at 08:41:05PM +0530, Kanchan Joshi wrote:
>> On Mon, Jul 06, 2020 at 03:32:08PM +0100, Matthew Wilcox wrote:
>> > On Mon, Jul 06, 2020 at 08:27:17AM -0600, Jens Axboe wrote:
>> > > On 7/6/20 8:10 AM, Matthew Wilcox wrote:
>> > > > On Sun, Jul 05, 2020 at 03:12:50PM -0600, Jens Axboe wrote:
>> > > >> On 7/5/20 3:09 PM, Matthew Wilcox wrote:
>> > > >>> On Sun, Jul 05, 2020 at 03:00:47PM -0600, Jens Axboe wrote:
>> > > >>>> On 7/5/20 12:47 PM, Kanchan Joshi wrote:
>> > > >>>>> From: Selvakumar S <selvakuma.s1@samsung.com>
>> > > >>>>>
>> > > >>>>> For zone-append, block-layer will return zone-relative offset via ret2
>> > > >>>>> of ki_complete interface. Make changes to collect it, and send to
>> > > >>>>> user-space using cqe->flags.
>> > > >
>> > > >>> I'm surprised you aren't more upset by the abuse of cqe->flags for the
>> > > >>> address.
>>
>> Documentation (https://protect2.fireeye.com/url?k=297dbcbf-74aee030-297c37f0-0cc47a31ce52-632d3561909b91fc&q=1&u=https%3A%2F%2Fkernel.dk%2Fio_uring.pdf) mentioned cqe->flags can carry
>> the metadata for the operation. I wonder if this should be called abuse.
>>
>> > > >> Yeah, it's not great either, but we have less leeway there in terms of
>> > > >> how much space is available to pass back extra data.
>> > > >>
>> > > >>> What do you think to my idea of interpreting the user_data as being a
>> > > >>> pointer to somewhere to store the address?  Obviously other things
>> > > >>> can be stored after the address in the user_data.
>> > > >>
>> > > >> I don't like that at all, as all other commands just pass user_data
>> > > >> through. This means the application would have to treat this very
>> > > >> differently, and potentially not have a way to store any data for
>> > > >> locating the original command on the user side.
>> > > >
>> > > > I think you misunderstood me.  You seem to have thought I meant
>> > > > "use the user_data field to return the address" when I actually meant
>> > > > "interpret the user_data field as a pointer to where userspace
>> > > > wants the address stored".
>> > >
>> > > It's still somewhat weird to have user_data have special meaning, you're
>> > > now having the kernel interpret it while every other command it's just
>> > > an opaque that is passed through.
>> > >
>> > > But it could of course work, and the app could embed the necessary
>> > > u32/u64 in some other structure that's persistent across IO. If it
>> > > doesn't have that, then it'd need to now have one allocated and freed
>> > > across the lifetime of the IO.
>> > >
>> > > If we're going that route, it'd be better to define the write such that
>> > > you're passing in the necessary information upfront. In syscall terms,
>> > > then that'd be something ala:
>> > >
>> > > ssize_t my_append_write(int fd, const struct iovec *iov, int iovcnt,
>> > > 			off_t *offset, int flags);
>> > >
>> > > where *offset is copied out when the write completes. That removes the
>> > > need to abuse user_data, with just providing the storage pointer for the
>> > > offset upfront.
>> >
>> > That works for me!  In io_uring terms, would you like to see that done
>> > as adding:
>> >
>> >        union {
>> >                __u64   off;    /* offset into file */
>> > +		__u64   *offp;	/* appending writes */
>> >                __u64   addr2;
>> >        };
>> But there are peformance implications of this approach?
>> If I got it right, the workflow is: - Application allocates 64bit of space,
>> writes "off" into it and pass it
>>  in the sqe->addr2
>> - Kernel first reads sqe->addr2, reads the value to know the intended
>>  write-location, and stores the address somewhere (?) to be used during
>>  completion. Storing this address seems tricky as this may add one more
>>  cacheline (in io_kiocb->rw)?
>
>io_kiocb is:
>        /* size: 232, cachelines: 4, members: 19 */
>        /* forced alignments: 1 */
>        /* last cacheline: 40 bytes */
>so we have another 24 bytes before io_kiocb takes up another cacheline.
>If that's a serious problem, I have an idea about how to shrink struct
>kiocb by 8 bytes so struct io_rw would have space to store another
>pointer.
Yes, io_kiocb has room. Cache-locality wise whether that is fine or
it must be placed within io_rw - I'll come to know once I get to
implement this. Please share the idea you have, it can come handy.

>> - During completion cqe res/flags are written as before, but extra step
>>  to copy the append-completion-result into that user-space address.
>> Extra steps are due to the pointer indirection.
>
>... we've just done an I/O.  Concern about an extra pointer access
>seems misplaced?

I was thinking about both read-from (submission) and write-to
(completion) from user-space pointer, and all those checks APIs
(get_user, copy_from_user) perform.....but when seen against I/O (that
too direct), it does look small. Down the line it may matter for cached-IO
but I get your point. 

>> And it seems application needs to be careful about managing this 64bit of
>> space for a cluster of writes, especially if it wants to reuse the sqe
>> before the completion.
>> New one can handle 64bit result cleanly, but seems slower than current
>> one.
>
>But userspace has to _do_ something with that information anyway.  So
>it must already have somewhere to put that information.

Right. But it is part of SQE/CQE currently, and in new scheme it gets
decoupled and needs to be managed separately. 
>I do think that interpretation of that field should be a separate flag
>from WRITE_APPEND so apps which genuinely don't care about where the I/O
>ended up don't have to allocate some temporary storage.  eg a logging
>application which just needs to know that it managed to append to the
>end of the log and doesn't need to do anything if it's successful.
Would you want that new flag to do what RWF_APPEND does as well? 
In v2, we had a separate flag RWF_ZONE_APPEND and did not use
file-append infra at all. Thought was: apps using the new flag will
always look at where write landed.

In v3, I've been looking at this as: 
zone-append = file-append + something-extra-to-know-where-write-landed.
We see to it that something-extra does not get executed for regular
files/block-dev append (ref: FMODE_ZONE_APPEND patch1)....and existing
behavior (the one you described for logging application) is retained.
But on a zoned-device/file, file-append becomes zone-append, all the
time. 

------nai8lIH9ngBNHun9R6qswQcIIemhXBCkNXu5CagZqSM5j8ea=_e3847_
Content-Type: text/plain; charset="utf-8"


------nai8lIH9ngBNHun9R6qswQcIIemhXBCkNXu5CagZqSM5j8ea=_e3847_--
