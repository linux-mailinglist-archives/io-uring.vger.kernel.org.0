Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A14C62E24DB
	for <lists+io-uring@lfdr.de>; Thu, 24 Dec 2020 07:42:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725747AbgLXGmJ (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 24 Dec 2020 01:42:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42510 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725613AbgLXGmI (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 24 Dec 2020 01:42:08 -0500
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 69174C061794;
        Wed, 23 Dec 2020 22:41:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=hgZ+lZNP3B/K9Oj/s5udXyrBDVF5xZJ71bYP1nixZdo=; b=hzjxM2aGVedqOqTPaeLJKWYuY4
        xkqiFVFpQKWkgqEySPTCLiSvWvcEJrgRLsJBOnrS0QZdfm4dsSOXZeO0PNLab6ggKCBq1lw6nS3kW
        Y3WaTFZ3ODCAIHwpPam/g5eYytVyG9hqXEC7GPEvByE+eg/g0kafrqgdDkSIVH2HW9VYEuJ8mRIkc
        w8qFJdvjTIWFM9bOal30Yib0rTy3vrCUR/hyI4lFqoeN/ROgowBMVqDPpJTNzgpcOcabaesZubCUI
        HkInEHpdkOK6FMxwC/PdZmtaPCsBloa68FjEumpKaKfc+q+vT15CVF5bXkEMkQSnUvd4YD+3SEbZo
        nG0RhV+w==;
Received: from hch by casper.infradead.org with local (Exim 4.92.3 #3 (Red Hat Linux))
        id 1ksKJL-0000uK-Pw; Thu, 24 Dec 2020 06:41:19 +0000
Date:   Thu, 24 Dec 2020 06:41:19 +0000
From:   Christoph Hellwig <hch@infradead.org>
To:     Pavel Begunkov <asml.silence@gmail.com>
Cc:     dgilbert@interlog.com,
        James Bottomley <James.Bottomley@hansenpartnership.com>,
        Christoph Hellwig <hch@infradead.org>,
        Ming Lei <ming.lei@redhat.com>, linux-block@vger.kernel.org,
        Jens Axboe <axboe@kernel.dk>,
        Matthew Wilcox <willy@infradead.org>,
        Johannes Weiner <hannes@cmpxchg.org>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        "Darrick J . Wong" <darrick.wong@oracle.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Jonathan Corbet <corbet@lwn.net>, linux-xfs@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, io-uring@vger.kernel.org,
        linux-kernel@vger.kernel.org, target-devel@vger.kernel.org,
        linux-scsi@vger.kernel.org, linux-doc@vger.kernel.org
Subject: Re: [PATCH v1 0/6] no-copy bvec
Message-ID: <20201224064119.GA3048@infradead.org>
References: <20201215014114.GA1777020@T590>
 <103235c1-e7d0-0b55-65d0-013d1a09304e@gmail.com>
 <20201215120357.GA1798021@T590>
 <e755fec3-4181-1414-0603-02e1a1f4e9eb@gmail.com>
 <20201222141112.GE13079@infradead.org>
 <933030f0-e428-18fd-4668-68db4f14b976@gmail.com>
 <20201223155145.GA5902@infradead.org>
 <f06ece44a86eb9c8ef07bbd9f6f53342366b7751.camel@HansenPartnership.com>
 <8abc56c2-4db8-5ee3-ab2d-8960d0eeeb0d@interlog.com>
 <f5cb6ac2-1c59-33be-de8f-e86c8528fbec@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <f5cb6ac2-1c59-33be-de8f-e86c8528fbec@gmail.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Wed, Dec 23, 2020 at 08:32:45PM +0000, Pavel Begunkov wrote:
> On 23/12/2020 20:23, Douglas Gilbert wrote:
> > On 2020-12-23 11:04 a.m., James Bottomley wrote:
> >> On Wed, 2020-12-23 at 15:51 +0000, Christoph Hellwig wrote:
> >>> On Wed, Dec 23, 2020 at 12:52:59PM +0000, Pavel Begunkov wrote:
> >>>> Can scatterlist have 0-len entries? Those are directly translated
> >>>> into bvecs, e.g. in nvme/target/io-cmd-file.c and
> >>>> target/target_core_file.c. I've audited most of others by this
> >>>> moment, they're fine.
> >>>
> >>> For block layer SGLs we should never see them, and for nvme neither.
> >>> I think the same is true for the SCSI target code, but please double
> >>> check.
> >>
> >> Right, no-one ever wants to see a 0-len scatter list entry.?? The reason
> >> is that every driver uses the sgl to program the device DMA engine in
> >> the way NVME does.?? a 0 length sgl would be a dangerous corner case:
> >> some DMA engines would ignore it and others would go haywire, so if we
> >> ever let a 0 length list down into the driver, they'd have to
> >> understand the corner case behaviour of their DMA engine and filter it
> >> accordingly, which is why we disallow them in the upper levels, since
> >> they're effective nops anyway.
> > 
> > When using scatter gather lists at the far end (i.e. on the storage device)
> > the T10 examples (WRITE SCATTERED and POPULATE TOKEN in SBC-4) explicitly
> > allow the "number of logical blocks" in their sgl_s to be zero and state
> > that it is _not_ to be considered an error.
> 
> It's fine for my case unless it leaks them out of device driver to the
> net/block layer/etc. Is it?

None of the SCSI Command mentions above are supported by Linux,
nevermind mapped to struct scatterlist.
