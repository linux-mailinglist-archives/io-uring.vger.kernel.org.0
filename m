Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DF75420F4FF
	for <lists+io-uring@lfdr.de>; Tue, 30 Jun 2020 14:47:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387934AbgF3Mqx (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 30 Jun 2020 08:46:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37706 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387855AbgF3Mqw (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 30 Jun 2020 08:46:52 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9F0C8C061755;
        Tue, 30 Jun 2020 05:46:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=Q7p5xLxn4weNWP/HSAg2W+OjOZyX+vfU5i1SyJ0YNkk=; b=byFHeKGWpcfPv6qNe1knSNSdd6
        eTgTvR0X9jhfJDShcpq/+Smav0j66PLJDLVbsrnabXaeL3hdlPv9cK+CbGNuN1O6xk2pN/b2vozu5
        K8ANv0hrL4k975gPSzFONfyGBTuTBI+iv9T4Wif+0SG9XZouSDlLL2Ay6vVVrknvyYzFNmSrP+F8w
        2TYFjzSAvJUEC0u7dBI8zbpZN7AM0FnSFStLNXRe5ELDXp8MfThkylMV9+LJWwXFJRvsW0cmPso7d
        ZFoigGJDR8+BatGxguaXFHEzj5/dnI5AuWy993WCQ2axR2aRxQvTTFQbg8m0v53SKiF0qCA/EVuzX
        1kh4QSKA==;
Received: from willy by casper.infradead.org with local (Exim 4.92.3 #3 (Red Hat Linux))
        id 1jqFer-0005Em-Bb; Tue, 30 Jun 2020 12:46:41 +0000
Date:   Tue, 30 Jun 2020 13:46:41 +0100
From:   Matthew Wilcox <willy@infradead.org>
To:     Kanchan Joshi <joshi.k@samsung.com>
Cc:     axboe@kernel.dk, viro@zeniv.linux.org.uk, bcrl@kvack.org,
        asml.silence@gmail.com, Damien.LeMoal@wdc.com, hch@infradead.org,
        linux-fsdevel@vger.kernel.org, mb@lightnvm.io,
        linux-kernel@vger.kernel.org, linux-aio@kvack.org,
        io-uring@vger.kernel.org, linux-block@vger.kernel.org,
        selvakuma.s1@samsung.com, nj.shetty@samsung.com,
        javier.gonz@samsung.com
Subject: Re: [PATCH v2 0/2] zone-append support in io-uring and aio
Message-ID: <20200630124641.GN25523@casper.infradead.org>
References: <CGME20200625171829epcas5p268486a0780571edb4999fc7b3caab602@epcas5p2.samsung.com>
 <1593105349-19270-1-git-send-email-joshi.k@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1593105349-19270-1-git-send-email-joshi.k@samsung.com>
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Thu, Jun 25, 2020 at 10:45:47PM +0530, Kanchan Joshi wrote:
> Zone-append completion result --->
> With zone-append, where write took place can only be known after completion.
> So apart from usual return value of write, additional mean is needed to obtain
> the actual written location.
> 
> In aio, this is returned to application using res2 field of io_event -
> 
> struct io_event {
>         __u64           data;           /* the data field from the iocb */
>         __u64           obj;            /* what iocb this event came from */
>         __s64           res;            /* result code for this event */
>         __s64           res2;           /* secondary result */
> };

Ah, now I understand.  I think you're being a little too specific by
calling this zone-append.  This is really a "write-anywhere" operation,
and the specified address is only a hint.

> In io-uring, cqe->flags is repurposed for zone-append result.
> 
> struct io_uring_cqe {
>         __u64   user_data;      /* sqe->data submission passed back */
>         __s32   res;            /* result code for this event */
>         __u32   flags;
> };
> 
> Since 32 bit flags is not sufficient, we choose to return zone-relative offset
> in sector/512b units. This can cover zone-size represented by chunk_sectors.
> Applications will have the trouble to combine this with zone start to know
> disk-relative offset. But if more bits are obtained by pulling from res field
> that too would compel application to interpret res field differently, and it
> seems more painstaking than the former option.
> To keep uniformity, even with aio, zone-relative offset is returned.

Urgh, no, that's dreadful.  I'm not familiar with the io_uring code.
Maybe the first 8 bytes of the user_data could be required to be the
result offset for this submission type?

> Block IO vs File IO --->
> For now, the user zone-append interface is supported only for zoned-block-device.
> Regular files/block-devices are not supported. Regular file-system (e.g. F2FS)
> will not need this anyway, because zone peculiarities are abstracted within FS.
> At this point, ZoneFS also likes to use append implicitly rather than explicitly.
> But if/when ZoneFS starts supporting explicit/on-demand zone-append, the check
> allowing-only-block-device should be changed.

But we also have O_APPEND files.  And maybe we'll have other kinds of file
in future for which this would make sense.

> Semantics --->
> Zone-append, by its nature, may perform write on a different location than what
> was specified. It does not fit into POSIX, and trying to fit may just undermine

... I disagree that it doesn't fit into POSIX.  As I said above, O_APPEND
is a POSIX concept, so POSIX already understands that writes may not end
up at the current write pointer.

> its benefit. It may be better to keep semantics as close to zone-append as
> possible i.e. specify zone-start location, and obtain the actual-write location
> post completion. Towards that goal, existing async APIs seem to fit fine.
> Async APIs (uring, linux aio) do not work on implicit write-pointer and demand
> explicit write offset (which is what we need for append). Neither write-pointer
> is taken as input, nor it is updated on completion. And there is a clear way to
> get zone-append result. Zone-aware applications while using these async APIs
> can be fine with, for the lack of better word, zone-append semantics itself.
> 
> Sync APIs work with implicit write-pointer (at least few of those), and there is
> no way to obtain zone-append result, making it hard for user-space zone-append.
