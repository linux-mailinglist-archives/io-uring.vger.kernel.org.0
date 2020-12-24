Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BAF172E2863
	for <lists+io-uring@lfdr.de>; Thu, 24 Dec 2020 18:31:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728511AbgLXRbA (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 24 Dec 2020 12:31:00 -0500
Received: from bedivere.hansenpartnership.com ([96.44.175.130]:37900 "EHLO
        bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726839AbgLXRbA (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 24 Dec 2020 12:31:00 -0500
Received: from localhost (localhost [127.0.0.1])
        by bedivere.hansenpartnership.com (Postfix) with ESMTP id 97C271280937;
        Thu, 24 Dec 2020 09:30:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
        d=hansenpartnership.com; s=20151216; t=1608831019;
        bh=ZrDKMysEKyRnhYwGjS71SXXWaighP0ldoE8CWdohIrg=;
        h=Message-ID:Subject:From:To:Date:In-Reply-To:References:From;
        b=r8mNX+IrqMNTTr696CzKuwaS+Sq91rTomLLBTI6H2DQdIAq2hg33Y7UH5jb+Go3cI
         tb6nDGo60ZPDH/51WQjOHUSL6ZxKTbUHp+YB5IXye5R/Z2sAeuMEGaBDZTuMX5elLc
         TByeaVv9dfWCLAVPKYUK4GoJKGCinejD2LtKCi08=
Received: from bedivere.hansenpartnership.com ([127.0.0.1])
        by localhost (bedivere.hansenpartnership.com [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id h3bvsEulAG7l; Thu, 24 Dec 2020 09:30:19 -0800 (PST)
Received: from jarvis.int.hansenpartnership.com (unknown [IPv6:2601:600:8280:66d1::c447])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by bedivere.hansenpartnership.com (Postfix) with ESMTPSA id 8B4791280936;
        Thu, 24 Dec 2020 09:30:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
        d=hansenpartnership.com; s=20151216; t=1608831019;
        bh=ZrDKMysEKyRnhYwGjS71SXXWaighP0ldoE8CWdohIrg=;
        h=Message-ID:Subject:From:To:Date:In-Reply-To:References:From;
        b=r8mNX+IrqMNTTr696CzKuwaS+Sq91rTomLLBTI6H2DQdIAq2hg33Y7UH5jb+Go3cI
         tb6nDGo60ZPDH/51WQjOHUSL6ZxKTbUHp+YB5IXye5R/Z2sAeuMEGaBDZTuMX5elLc
         TByeaVv9dfWCLAVPKYUK4GoJKGCinejD2LtKCi08=
Message-ID: <bdd002f433928dd545d336a982516afa4e095d49.camel@HansenPartnership.com>
Subject: Re: [PATCH v1 0/6] no-copy bvec
From:   James Bottomley <James.Bottomley@HansenPartnership.com>
To:     dgilbert@interlog.com, Christoph Hellwig <hch@infradead.org>,
        Pavel Begunkov <asml.silence@gmail.com>
Cc:     Ming Lei <ming.lei@redhat.com>, linux-block@vger.kernel.org,
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
Date:   Thu, 24 Dec 2020 09:30:17 -0800
In-Reply-To: <8abc56c2-4db8-5ee3-ab2d-8960d0eeeb0d@interlog.com>
References: <cover.1607976425.git.asml.silence@gmail.com>
         <20201215014114.GA1777020@T590>
         <103235c1-e7d0-0b55-65d0-013d1a09304e@gmail.com>
         <20201215120357.GA1798021@T590>
         <e755fec3-4181-1414-0603-02e1a1f4e9eb@gmail.com>
         <20201222141112.GE13079@infradead.org>
         <933030f0-e428-18fd-4668-68db4f14b976@gmail.com>
         <20201223155145.GA5902@infradead.org>
         <f06ece44a86eb9c8ef07bbd9f6f53342366b7751.camel@HansenPartnership.com>
         <8abc56c2-4db8-5ee3-ab2d-8960d0eeeb0d@interlog.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.34.4 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Wed, 2020-12-23 at 15:23 -0500, Douglas Gilbert wrote:
> On 2020-12-23 11:04 a.m., James Bottomley wrote:
> > On Wed, 2020-12-23 at 15:51 +0000, Christoph Hellwig wrote:
> > > On Wed, Dec 23, 2020 at 12:52:59PM +0000, Pavel Begunkov wrote:
> > > > Can scatterlist have 0-len entries? Those are directly
> > > > translated into bvecs, e.g. in nvme/target/io-cmd-file.c and
> > > > target/target_core_file.c. I've audited most of others by this
> > > > moment, they're fine.
> > > 
> > > For block layer SGLs we should never see them, and for nvme
> > > neither. I think the same is true for the SCSI target code, but
> > > please double check.
> > 
> > Right, no-one ever wants to see a 0-len scatter list entry.  The
> > reason is that every driver uses the sgl to program the device DMA
> > engine in the way NVME does.  a 0 length sgl would be a dangerous
> > corner case: some DMA engines would ignore it and others would go
> > haywire, so if we ever let a 0 length list down into the driver,
> > they'd have to understand the corner case behaviour of their DMA
> > engine and filter it accordingly, which is why we disallow them in
> > the upper levels, since they're effective nops anyway.
> 
> When using scatter gather lists at the far end (i.e. on the storage
> device) the T10 examples (WRITE SCATTERED and POPULATE TOKEN in SBC-
> 4) explicitly allow the "number of logical blocks" in their sgl_s to
> be zero and state that it is _not_ to be considered an error.

But that's pretty irrelevant.  The scatterlists that block has been
constructing to drive DMA engines pre-date SCSI's addition of SGLs by
decades (all SCSI commands before the object commands use a linear
buffer which is implemented in the HBA engine as a scatterlist but not
described by the SCSI standard as one).

So the answer to the question should the block layer emit zero length
sgl elements is "no" because they can confuse some DMA engines.

If there's a more theoretical question of whether the target driver in
adding commands it doesn't yet support should inject zero length SGL
elements into block because SCSI allows it, the answer is still "no"
because we don't want block to have SGLs that may confuse other DMA
engines.  There's lots of daft corner cases in the SCSI standard we
don't implement and a nop for SGL elements seems to be one of the more
hare brained because it adds no useful feature and merely causes
compatibility issues.

James
 

