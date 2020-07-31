Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E2E9923463C
	for <lists+io-uring@lfdr.de>; Fri, 31 Jul 2020 14:51:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733303AbgGaMvW (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 31 Jul 2020 08:51:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35550 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1733284AbgGaMvV (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 31 Jul 2020 08:51:21 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6A0BBC06174A;
        Fri, 31 Jul 2020 05:51:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=/E+nRnuzYADDq5kJccpG2KsLOsqg5kYB+ZX8OUJOTCo=; b=iDtPrKfbud83lSM7XUMkIm4Vqr
        qFeKUitDrpzf33hdorLEhFk8OiRjSxk6ofvysEk0oHCoy/1AxesS2MyqUJnBRxCjN0uV6wXsCDsU1
        BuaDnyqK1TGMxPHFEzhGjt9RLCyQqiAU0xH1oLyDyAHu7QdjSdfNfSDTxYS3hXCKW7rf2gdNUqWnP
        oQlAAr2oW8N6qf3LMkiTRAoa8WpK48Cg8aG6cqvXp8hPk5Z6FHhy+fGJPJgtbs+mvUoU22pR9PtUz
        /rbAgSff+TlyYITMcI9x2N9eQMs0XdW+pdZazpqImMmmwbacpCsR8n1HO5cExNAlHok5P1+C5cTxi
        CtcLEB/Q==;
Received: from hch by casper.infradead.org with local (Exim 4.92.3 #3 (Red Hat Linux))
        id 1k1UVC-0003bj-2S; Fri, 31 Jul 2020 12:51:10 +0000
Date:   Fri, 31 Jul 2020 13:51:10 +0100
From:   "hch@infradead.org" <hch@infradead.org>
To:     Damien Le Moal <Damien.LeMoal@wdc.com>
Cc:     "hch@infradead.org" <hch@infradead.org>,
        Kanchan Joshi <joshiiitr@gmail.com>,
        Jens Axboe <axboe@kernel.dk>,
        Pavel Begunkov <asml.silence@gmail.com>,
        Kanchan Joshi <joshi.k@samsung.com>,
        "viro@zeniv.linux.org.uk" <viro@zeniv.linux.org.uk>,
        "bcrl@kvack.org" <bcrl@kvack.org>,
        Matthew Wilcox <willy@infradead.org>,
        "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-aio@kvack.org" <linux-aio@kvack.org>,
        "io-uring@vger.kernel.org" <io-uring@vger.kernel.org>,
        "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>,
        "linux-api@vger.kernel.org" <linux-api@vger.kernel.org>,
        SelvaKumar S <selvakuma.s1@samsung.com>,
        Nitesh Shetty <nj.shetty@samsung.com>,
        Javier Gonzalez <javier.gonz@samsung.com>,
        Johannes Thumshirn <Johannes.Thumshirn@wdc.com>,
        Naohiro Aota <Naohiro.Aota@wdc.com>
Subject: Re: [PATCH v4 6/6] io_uring: add support for zone-append
Message-ID: <20200731125110.GA11500@infradead.org>
References: <CA+1E3rKxZk2CatTuPcQq5d14vXL9_9LVb2_+AfR2m9xn2WTZdg@mail.gmail.com>
 <MWHPR04MB3758DC08EA17780E498E9EC0E74E0@MWHPR04MB3758.namprd04.prod.outlook.com>
 <20200731064526.GA25674@infradead.org>
 <MWHPR04MB37581344328A42EA7F5ED13EE74E0@MWHPR04MB3758.namprd04.prod.outlook.com>
 <CA+1E3rLM4G4SwzD6RWsK6Ssp7NmhiPedZDjrqN3kORQr9fxCtw@mail.gmail.com>
 <MWHPR04MB375863C20C1EF2CB27E62703E74E0@MWHPR04MB3758.namprd04.prod.outlook.com>
 <20200731091416.GA29634@infradead.org>
 <MWHPR04MB37586D39CA389296CE0252A4E74E0@MWHPR04MB3758.namprd04.prod.outlook.com>
 <20200731094135.GA4104@infradead.org>
 <MWHPR04MB3758A4B2967DB1FABAAD9265E74E0@MWHPR04MB3758.namprd04.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <MWHPR04MB3758A4B2967DB1FABAAD9265E74E0@MWHPR04MB3758.namprd04.prod.outlook.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Fri, Jul 31, 2020 at 10:16:49AM +0000, Damien Le Moal wrote:
> > 
> > Let's keep semantics and implementation separate.  For the case
> > where we report the actual offset we need a size imitation and no
> > short writes.
> 
> OK. So the name of the flag confused me. The flag name should reflect "Do zone
> append and report written offset", right ?

Well, we already have O_APPEND, which is the equivalent to append to
the write pointer.  The only interesting addition is that we also want
to report where we wrote.  So I'd rather have RWF_REPORT_OFFSET or so.

> Just to clarify, here was my thinking for zonefs:
> 1) file open with O_APPEND/aio has RWF_APPEND: then it is OK to assume that the
> application did not set the aio offset since APPEND means offset==file size. In
> that case, do zone append and report back the written offset.

Yes.

> 2) file open without O_APPEND/aio does not have RWF_APPEND: the application
> specified an aio offset and we must respect it, write it that exact same order,
> so use regular writes.

Yes.

> 
> For regular file systems, with case (1) condition, the FS use whatever it wants
> for the implementation, and report back the written offset, which  will always
> be the file size at the time the aio was issued.

Yes. 

> 
> Your method with a new flag to switch between (1) and (2) is OK with me, but the
> "no short writes" may be difficult to achieve in a regular FS, no ? I do not
> think current FSes have such guarantees... Especially in the case of buffered
> async writes I think.

I'll have to check what Jens recently changed with io_uring, but
traditionally the only short write case for a normal file system is the
artifical INT_MAX limit for the write size.

> > Anything with those semantics can be implemented using Zone Append
> > trivially in zonefs, and we don't even need the exclusive lock in that
> > case.  But even without that flag anything that has an exclusive lock can
> > at least in theory be implemented using Zone Append, it just need
> > support for submitting another request from the I/O completion handler
> > of the first.  I just don't think it is worth it - with the exclusive
> > lock we do have access to the zone serialied so a normal write works
> > just fine.  Both for the sync and async case.
> 
> We did switch to have zonefs do append writes in the sync case, always. Hmmm...
> Not sure anymore it was such a good idea.

It might be a good idea as long as we have the heavy handed scheduler
locking.  But if we don't have that there doesn't seem to be much of
a reason for zone append.

> OK. Makes sense. That said, taking Naohiro's work on btrfs as an example, zone
> append is used for every data write, no matter if it is O_APPEND/RWF_APPEND or
> not. The size limitation for zone append writes is not needed at all by
> applications. Maximum extent size is aligned to the max append write size
> internally, and if the application issued a larger write, it loops over multiple
> extents, similarly to any regular write may do (if there is overwrite etc...).

True, we probably don't need the limit for a normal file system.

> For the regular FS case, my thinking on the semantic really was: if asked to do
> so, return the written offset for a RWF_APPEND aios. And I think that
> implementing that does not depend in any way on what the FS does internally.

Exactly.

> 
> But I think I am starting to see the picture you are drawing here:
> 1) Introduce a fcntl() to get "maximum size for atomic append writes"
> 2) Introduce an aio flag specifying "Do atomic append write and report written
> offset"

I think we just need the 'report written offset flag', in fact even for
zonefs with the right locking we can handle unlimited write sizes, just
with lower performance.  E.g.

1) check if the write size is larger than the zone append limit

if no:

 - take the shared lock  and issue a zone append, done

if yes:

 - take the exclusive per-inode (zone) lock and just issue either normal
   writes or zone append at your choice, relying on the lock to
   serialize other writers.  For the async case this means we need a
   lock than can be release in a different context than it was acquired,
   which is a little ugly but can be done.

> And the implementation is actually completely free to use zone append writes or
> regular writes regardless of the "Do atomic append write and report written
> offset" being used or not.

Yes, that was my point about keeping the semantics and implementation
separate.
