Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B75B31504E1
	for <lists+io-uring@lfdr.de>; Mon,  3 Feb 2020 12:06:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727632AbgBCLGv (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 3 Feb 2020 06:06:51 -0500
Received: from out2-smtp.messagingengine.com ([66.111.4.26]:37367 "EHLO
        out2-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727268AbgBCLGu (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 3 Feb 2020 06:06:50 -0500
Received: from compute5.internal (compute5.nyi.internal [10.202.2.45])
        by mailout.nyi.internal (Postfix) with ESMTP id 7C46621F57;
        Mon,  3 Feb 2020 06:06:49 -0500 (EST)
Received: from mailfrontend2 ([10.202.2.163])
  by compute5.internal (MEProxy); Mon, 03 Feb 2020 06:06:49 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=anarazel.de; h=
        date:from:to:cc:subject:message-id:references:mime-version
        :content-type:in-reply-to; s=fm3; bh=NeywmRTXFlPPGpmrIlLmDGmyULW
        /aHnlSGPykwDSgV4=; b=mIdeyCoPq+cYflUc2/An6NdgElK7pUEqlDNRzwUfYJ8
        GA8p6srodHzgacu1/5IAdhWaHCB4QBrvj7Gr3PhHeoJfuDxKLXWL0nztRSHJZVev
        0zhy1gBr3mz/2EwFYpluX0+zQKhLRNGoh7Vkdj7phZs14WUOCKxmf3kZk5bvkyM6
        VhfcHgXt0QSTwcAb1ImIDrNj5gjUZAr0UpE1kxp3VyYxSlggA/19aOBN7z2rqqbF
        PfP44S9d4rIbhYSI7TFBBhaTEux415E/ffLj3LjDdUc/KOH2XSpr9UDv0JQmsHcb
        TTYA0++rQgFgnK7LkDbF2GgdPAkhMclCTrV+A+Ywv5A==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-type:date:from:in-reply-to
        :message-id:mime-version:references:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; bh=NeywmR
        TXFlPPGpmrIlLmDGmyULW/aHnlSGPykwDSgV4=; b=QS2hbBA36i5GE7TbVxNATW
        1nFk1kJ/F3mhHG2TAUoSY7lP03TQ9pz/vMWzrDGUmghx2YsZX7l88gPDz8sGfXSa
        nbjF2PKM6qeBW2fCovpSkL5HSoPXozPrd07pVjjHQHoHaFkSXfeKYiJ3eA6n4YzP
        Ah5+ilnO+nUf3nW89/oC4zuedIfbXCzz+GZSFWqljpPyTZDDF7uInxtz4Nubi06V
        xBIPfsOcNzvNjwjnz2hta+DKrpjZY2ftsqTBcOzZc8sYprSp3/nR/q3dxdYVz01E
        lieNu1hHbfDxKf2mYnn7GHVsK0GlmCdXyqPFHRfv+bmR1lLOeL/vOJQvyl9rXogw
        ==
X-ME-Sender: <xms:yP43XgmNoGQ3oPwpsI7mZd5TGm7phJbkFTG7NsgKVqNb_9XYAj1iRg>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedugedrgeejgddvvdcutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmdenuc
    fjughrpeffhffvuffkfhggtggujgesthdtredttddtvdenucfhrhhomheptehnughrvghs
    ucfhrhgvuhhnugcuoegrnhgurhgvshesrghnrghrrgiivghlrdguvgeqnecukfhppeduje
    dvrdehkedrvdejrdduvdejnecuvehluhhsthgvrhfuihiivgeptdenucfrrghrrghmpehm
    rghilhhfrhhomheprghnughrvghssegrnhgrrhgriigvlhdruggv
X-ME-Proxy: <xmx:yP43Xkqcj9ahGzgmMs8oHquwHSP1HGIyJ1hfdBXym-ciKCSRlY4p_g>
    <xmx:yP43XgmzbfQYAVL2HsN3wA0ClrFtQXC0-mPsn-85NND-4gUhkZnlbw>
    <xmx:yP43XkzyuQqIho2ZEV5TSLLPrOqU31qg0tac-0thFlLmAxlZVHskkg>
    <xmx:yf43XlZIFjlGzoXBBD0dBfeU9xL2gni4ROvk54k_x0Qy-a3ei97uAg>
Received: from intern.anarazel.de (unknown [172.58.27.127])
        by mail.messagingengine.com (Postfix) with ESMTPA id 0073730602DB;
        Mon,  3 Feb 2020 06:06:48 -0500 (EST)
Date:   Sun, 2 Feb 2020 23:42:57 -0800
From:   Andres Freund <andres@anarazel.de>
To:     Matthew Wilcox <willy@infradead.org>
Cc:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org,
        linux-fsdevel@vger.kernel.org
Subject: Re: io_uring force_nonblock vs POSIX_FADV_WILLNEED
Message-ID: <20200203074257.nx23pigjtmgbyyyz@alap3.anarazel.de>
References: <20200201094309.6si5dllxo4i25f4u@alap3.anarazel.de>
 <20200203064047.GC8731@bombadil.infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200203064047.GC8731@bombadil.infradead.org>
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Hi Matthew,

On 2020-02-02 22:40:47 -0800, Matthew Wilcox wrote:
> On Sat, Feb 01, 2020 at 01:43:09AM -0800, Andres Freund wrote:
> > As far as I can tell POSIX_FADV_WILLNEED synchronously starts readahead,
> > including page allocation etc, which of course might trigger quite
> > blocking. The fs also quite possibly needs to read metadata.
> > 
> > 
> > Seems like either WILLNEED would have to always be deferred, or
> > force_page_cache_readahead, __do_page_cache_readahead would etc need to
> > be wired up to know not to block. Including returning EAGAIN, despite
> > force_page_cache_readahead and generic_readahead() intentially ignoring
> > return values / errors.
> 
> The first step is going to be letting the readahead code know that it
> should have this behaviour, which is tricky because the code flow looks
> like this:
> 
> io_fadvise
>   vfs_fadvise
>     file->f_op->fadvise()

Yea.


> ... and we'd be breaking brand new ground trying to add a gfp_t to a
> file_operations method.  Which is not to say it couldn't be done, but
> would mean changing filesystems, just so we could pass the gfp
> flags through from the top level to the low level.  It wouldn't be
> too bad; only two filesystems implement an ->fadvise op today.

I was wondering if the right approach could be to pass through a kiocb
instead of gfp_t. There's obviously precedent for that in
file_operations, and then IOCB_NOWAIT could be used to represent the the
intent to not block. It'd be a bit weird in the sense that currently
there'd probably be no callback - but that seems fairly minor. And who
knows, 


> Next possibility, we could add a POSIX_FADV_WILLNEED_ASYNC advice
> flag.

POSIX_FADV_DONTNEED has similar problems to POSIX_FADV_WILLNEED, so it'd
be nice to come up with an API change to vfs_fadvise that'd support
both. Obviously there also could be a POSIX_FADV_DONTNEED_ASYNC, but ...


> Something I already want to see in an entirely different context is
> a flag in the task_struct which says, essentially, "don't block in
> memory allocations" -- ie behave as if __GFP_NOWAIT | __GFP_NOWARN
> is set.  See my proposal here:

I'm a bit out of my depth here: Would __GFP_NOWAIT actually be suitable
to indicate that no blocking IO is to be executed by the FS? E.g. for
metadata? As far as I can tell that's also a problem, not just reclaim
to make space for the to-be-read data.


> I've got my head stuck in the middle of the readahead code right now,
> so this seems like a good time to add this functionality.  Once I'm done
> with finding out who broke my test VM, I'll take a shot at adding
> this.

Cool!

Greetings,

Andres Freund
