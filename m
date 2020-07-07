Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1855B21730D
	for <lists+io-uring@lfdr.de>; Tue,  7 Jul 2020 17:56:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728386AbgGGPww (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 7 Jul 2020 11:52:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37218 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726911AbgGGPww (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 7 Jul 2020 11:52:52 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1B89CC061755;
        Tue,  7 Jul 2020 08:52:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=qitSqQ6l4aGdEl0MrtN8o8wIkc9K9uBrYFU/ZY3hNGo=; b=ATlv/7WAaftyiLTznXRxAacQ/n
        edoJAS8BUr4W7qqGcIZ+q/7+gwTlJG1cMyu5qmAR89hjYdBO9eUFOVBuLuV+hOg5MxPfWrYbKQRRW
        jXt4K/LdlVXLxcb0hgZTjnkPHWhjxN3bewjAY7llv5DI1d6guV8vDdhLh4QXNzYGZ4YuKdwkOeozT
        j9OothcA4TwpplRBydMaHjyiHjzZd8GIPl1FTF/bC5dCRXYAFql6dzvEmh590O1odf4/JKJLmdFAm
        AI7r0X5A8GVMoMPtBZCRF9CHzATbrFzGYV5rXXbboluSn2rEp+MyefYDgJ27nZkwlmTxXXcaD/z9N
        BUnCsdGg==;
Received: from willy by casper.infradead.org with local (Exim 4.92.3 #3 (Red Hat Linux))
        id 1jspte-0006Jf-0u; Tue, 07 Jul 2020 15:52:38 +0000
Date:   Tue, 7 Jul 2020 16:52:37 +0100
From:   Matthew Wilcox <willy@infradead.org>
To:     Kanchan Joshi <joshi.k@samsung.com>
Cc:     Jens Axboe <axboe@kernel.dk>, viro@zeniv.linux.org.uk,
        bcrl@kvack.org, hch@infradead.org, Damien.LeMoal@wdc.com,
        asml.silence@gmail.com, linux-fsdevel@vger.kernel.org,
        mb@lightnvm.io, linux-kernel@vger.kernel.org, linux-aio@kvack.org,
        io-uring@vger.kernel.org, linux-block@vger.kernel.org,
        Selvakumar S <selvakuma.s1@samsung.com>,
        Nitesh Shetty <nj.shetty@samsung.com>,
        Javier Gonzalez <javier.gonz@samsung.com>
Subject: Re: [PATCH v3 4/4] io_uring: add support for zone-append
Message-ID: <20200707155237.GM25523@casper.infradead.org>
References: <1593974870-18919-1-git-send-email-joshi.k@samsung.com>
 <CGME20200705185227epcas5p16fba3cb92561794b960184c89fdf2bb7@epcas5p1.samsung.com>
 <1593974870-18919-5-git-send-email-joshi.k@samsung.com>
 <fe0066b7-5380-43ee-20b2-c9b17ba18e4f@kernel.dk>
 <20200705210947.GW25523@casper.infradead.org>
 <239ee322-9c38-c838-a5b2-216787ad2197@kernel.dk>
 <20200706141002.GZ25523@casper.infradead.org>
 <4a9bf73e-f3ee-4f06-7fad-b8f8861b0bc1@kernel.dk>
 <20200706143208.GA25523@casper.infradead.org>
 <20200707151105.GA23395@test-zns>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200707151105.GA23395@test-zns>
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Tue, Jul 07, 2020 at 08:41:05PM +0530, Kanchan Joshi wrote:
> On Mon, Jul 06, 2020 at 03:32:08PM +0100, Matthew Wilcox wrote:
> > On Mon, Jul 06, 2020 at 08:27:17AM -0600, Jens Axboe wrote:
> > > On 7/6/20 8:10 AM, Matthew Wilcox wrote:
> > > > On Sun, Jul 05, 2020 at 03:12:50PM -0600, Jens Axboe wrote:
> > > >> On 7/5/20 3:09 PM, Matthew Wilcox wrote:
> > > >>> On Sun, Jul 05, 2020 at 03:00:47PM -0600, Jens Axboe wrote:
> > > >>>> On 7/5/20 12:47 PM, Kanchan Joshi wrote:
> > > >>>>> From: Selvakumar S <selvakuma.s1@samsung.com>
> > > >>>>>
> > > >>>>> For zone-append, block-layer will return zone-relative offset via ret2
> > > >>>>> of ki_complete interface. Make changes to collect it, and send to
> > > >>>>> user-space using cqe->flags.
> > > >
> > > >>> I'm surprised you aren't more upset by the abuse of cqe->flags for the
> > > >>> address.
> 
> Documentation (https://kernel.dk/io_uring.pdf) mentioned cqe->flags can carry
> the metadata for the operation. I wonder if this should be called abuse.
> 
> > > >> Yeah, it's not great either, but we have less leeway there in terms of
> > > >> how much space is available to pass back extra data.
> > > >>
> > > >>> What do you think to my idea of interpreting the user_data as being a
> > > >>> pointer to somewhere to store the address?  Obviously other things
> > > >>> can be stored after the address in the user_data.
> > > >>
> > > >> I don't like that at all, as all other commands just pass user_data
> > > >> through. This means the application would have to treat this very
> > > >> differently, and potentially not have a way to store any data for
> > > >> locating the original command on the user side.
> > > >
> > > > I think you misunderstood me.  You seem to have thought I meant
> > > > "use the user_data field to return the address" when I actually meant
> > > > "interpret the user_data field as a pointer to where userspace
> > > > wants the address stored".
> > > 
> > > It's still somewhat weird to have user_data have special meaning, you're
> > > now having the kernel interpret it while every other command it's just
> > > an opaque that is passed through.
> > > 
> > > But it could of course work, and the app could embed the necessary
> > > u32/u64 in some other structure that's persistent across IO. If it
> > > doesn't have that, then it'd need to now have one allocated and freed
> > > across the lifetime of the IO.
> > > 
> > > If we're going that route, it'd be better to define the write such that
> > > you're passing in the necessary information upfront. In syscall terms,
> > > then that'd be something ala:
> > > 
> > > ssize_t my_append_write(int fd, const struct iovec *iov, int iovcnt,
> > > 			off_t *offset, int flags);
> > > 
> > > where *offset is copied out when the write completes. That removes the
> > > need to abuse user_data, with just providing the storage pointer for the
> > > offset upfront.
> > 
> > That works for me!  In io_uring terms, would you like to see that done
> > as adding:
> > 
> >        union {
> >                __u64   off;    /* offset into file */
> > +		__u64   *offp;	/* appending writes */
> >                __u64   addr2;
> >        };
> But there are peformance implications of this approach?
> If I got it right, the workflow is: - Application allocates 64bit of space,
> writes "off" into it and pass it
>  in the sqe->addr2
> - Kernel first reads sqe->addr2, reads the value to know the intended
>  write-location, and stores the address somewhere (?) to be used during
>  completion. Storing this address seems tricky as this may add one more
>  cacheline (in io_kiocb->rw)?

io_kiocb is:
        /* size: 232, cachelines: 4, members: 19 */
        /* forced alignments: 1 */
        /* last cacheline: 40 bytes */
so we have another 24 bytes before io_kiocb takes up another cacheline.
If that's a serious problem, I have an idea about how to shrink struct
kiocb by 8 bytes so struct io_rw would have space to store another
pointer.

> - During completion cqe res/flags are written as before, but extra step
>  to copy the append-completion-result into that user-space address.
> Extra steps are due to the pointer indirection.

... we've just done an I/O.  Concern about an extra pointer access
seems misplaced?

> And it seems application needs to be careful about managing this 64bit of
> space for a cluster of writes, especially if it wants to reuse the sqe
> before the completion.
> New one can handle 64bit result cleanly, but seems slower than current
> one.

But userspace has to _do_ something with that information anyway.  So
it must already have somewhere to put that information.

I do think that interpretation of that field should be a separate flag
from WRITE_APPEND so apps which genuinely don't care about where the I/O
ended up don't have to allocate some temporary storage.  eg a logging
application which just needs to know that it managed to append to the
end of the log and doesn't need to do anything if it's successful.
