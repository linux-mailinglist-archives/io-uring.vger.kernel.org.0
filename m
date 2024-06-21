Return-Path: <io-uring+bounces-2323-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 8A6C4912F6D
	for <lists+io-uring@lfdr.de>; Fri, 21 Jun 2024 23:23:25 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 46A28288BE8
	for <lists+io-uring@lfdr.de>; Fri, 21 Jun 2024 21:23:24 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1893D156F2E;
	Fri, 21 Jun 2024 21:23:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="KIjoAo9d"
X-Original-To: io-uring@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CD52D4A3F;
	Fri, 21 Jun 2024 21:23:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719005002; cv=none; b=YU+BxoZn1K6sxyI/7Ma29Z9wo0h2PJQVq1+0W2dqeWUajwVvXrpSU+TZCJTL9RkxhXbiatqiEWmgyCXmiUhBhGZJR8nfsBpgkOYfk3x2a00j7TsEu1uXDO3NdrqQivAq5t65WP/oyOzDKNTQ3CMJ5ltAABg4yTU3io7dCyiewbY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719005002; c=relaxed/simple;
	bh=N4ivVfcXJIy+QZ0gUdEeSMav33R3fT7xLRRwMgFHS5Q=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=tLfjNcD60yOIApyoRlTz4LMauwUZqmDE3f0q09H33ae+0p7Y+6vN6dHS4BrJ9QyJCgxeTRaArtQQzDqz5P1JPYRKHcr4ytLeqGNMvUsob/cjTkLvOdDDN7f3/LQ12LHrezBXSJ+p/TzP4lykAjrqHDiWFryOpn3Zy9tOnJpEUSk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=KIjoAo9d; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4D506C2BBFC;
	Fri, 21 Jun 2024 21:23:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1719005001;
	bh=N4ivVfcXJIy+QZ0gUdEeSMav33R3fT7xLRRwMgFHS5Q=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=KIjoAo9dVPq/wWSw7vIa+LUCdLv/cy0F+UpK0V0o6GG4XtJGpPyWD7XS6VYSOCLbE
	 96RxruHq6fyaGWj3Fcup4m2H2zjHCiaQsk2cwLejwCGTDk1h+CDL9GsEpDBeR+358D
	 eVikhWol4HvrtRbxIVuPnG8/eXP7DgKHQJuJc+DHT3QbmE/Ug77DxemimyxG+bwVLd
	 ayCRr4u6b+0c/fvSbv7PmeG3MeTeJovAWkBSk4O562mzy8+vpo9vIy6eLQV2Tb8vex
	 6s75hABhrSF177DZx/ED7ySzT1gVAEo80N7qgJFHW46uWn0nuJwTC9rbYIeMvVkLYN
	 /Y3Eol8tZh44w==
Date: Fri, 21 Jun 2024 14:23:20 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: John Garry <john.g.garry@oracle.com>
Cc: Hannes Reinecke <hare@suse.de>, axboe@kernel.dk, kbusch@kernel.org,
	hch@lst.de, sagi@grimberg.me, jejb@linux.ibm.com,
	martin.petersen@oracle.com, viro@zeniv.linux.org.uk,
	brauner@kernel.org, dchinner@redhat.com, jack@suse.cz,
	linux-block@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-nvme@lists.infradead.org, linux-fsdevel@vger.kernel.org,
	tytso@mit.edu, jbongio@google.com, linux-scsi@vger.kernel.org,
	ojaswin@linux.ibm.com, linux-aio@kvack.org,
	linux-btrfs@vger.kernel.org, io-uring@vger.kernel.org,
	nilay@linux.ibm.com, ritesh.list@gmail.com, willy@infradead.org,
	agk@redhat.com, snitzer@kernel.org, mpatocka@redhat.com,
	dm-devel@lists.linux.dev
Subject: Re: [Patch v9 07/10] block: Add fops atomic write support
Message-ID: <20240621212320.GE103020@frogsfrogsfrogs>
References: <20240620125359.2684798-1-john.g.garry@oracle.com>
 <20240620125359.2684798-8-john.g.garry@oracle.com>
 <680ce641-729b-4150-b875-531a98657682@suse.de>
 <d3332752-52b1-4d24-88cf-3b5e7aa4b74a@oracle.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <d3332752-52b1-4d24-88cf-3b5e7aa4b74a@oracle.com>

On Fri, Jun 21, 2024 at 01:02:34PM +0100, John Garry wrote:
> On 21/06/2024 07:13, Hannes Reinecke wrote:
> > On 6/20/24 14:53, John Garry wrote:
> > > Support atomic writes by submitting a single BIO with the REQ_ATOMIC set.
> > > 
> > > It must be ensured that the atomic write adheres to its rules, like
> > > naturally aligned offset, so call blkdev_dio_invalid() ->
> > > blkdev_atomic_write_valid() [with renaming blkdev_dio_unaligned() to
> > > blkdev_dio_invalid()] for this purpose. The BIO submission path currently
> > > checks for atomic writes which are too large, so no need to check here.
> > > 
> > > In blkdev_direct_IO(), if the nr_pages exceeds BIO_MAX_VECS, then we
> > > cannot
> > > produce a single BIO, so error in this case.
> > > 
> > > Finally set FMODE_CAN_ATOMIC_WRITE when the bdev can support atomic
> > > writes
> > > and the associated file flag is for O_DIRECT.
> > > 
> > > Reviewed-by: Martin K. Petersen <martin.petersen@oracle.com>
> > > Signed-off-by: John Garry <john.g.garry@oracle.com>
> > > ---
> > >   block/fops.c | 20 +++++++++++++++++---
> > >   1 file changed, 17 insertions(+), 3 deletions(-)
> > > 
> > > diff --git a/block/fops.c b/block/fops.c
> > > index 376265935714..be36c9fbd500 100644
> > > --- a/block/fops.c
> > > +++ b/block/fops.c
> > > @@ -34,9 +34,12 @@ static blk_opf_t dio_bio_write_op(struct kiocb *iocb)
> > >       return opf;
> > >   }
> > > -static bool blkdev_dio_unaligned(struct block_device *bdev, loff_t pos,
> > > -                  struct iov_iter *iter)
> > > +static bool blkdev_dio_invalid(struct block_device *bdev, loff_t pos,
> > > +                struct iov_iter *iter, bool is_atomic)
> > >   {
> > > +    if (is_atomic && !generic_atomic_write_valid(iter, pos))
> > > +        return true;
> > > +
> > >       return pos & (bdev_logical_block_size(bdev) - 1) ||
> > >           !bdev_iter_is_aligned(bdev, iter);
> > >   }
> > > @@ -72,6 +75,8 @@ static ssize_t __blkdev_direct_IO_simple(struct
> > > kiocb *iocb,
> > >       bio.bi_iter.bi_sector = pos >> SECTOR_SHIFT;
> > >       bio.bi_write_hint = file_inode(iocb->ki_filp)->i_write_hint;
> > >       bio.bi_ioprio = iocb->ki_ioprio;
> > > +    if (iocb->ki_flags & IOCB_ATOMIC)
> > > +        bio.bi_opf |= REQ_ATOMIC;
> > >       ret = bio_iov_iter_get_pages(&bio, iter);
> > >       if (unlikely(ret))
> > > @@ -343,6 +348,9 @@ static ssize_t __blkdev_direct_IO_async(struct
> > > kiocb *iocb,
> > >           task_io_account_write(bio->bi_iter.bi_size);
> > >       }
> > > +    if (iocb->ki_flags & IOCB_ATOMIC)
> > > +        bio->bi_opf |= REQ_ATOMIC;
> > > +
> > >       if (iocb->ki_flags & IOCB_NOWAIT)
> > >           bio->bi_opf |= REQ_NOWAIT;
> > > @@ -359,12 +367,13 @@ static ssize_t __blkdev_direct_IO_async(struct
> > > kiocb *iocb,
> > >   static ssize_t blkdev_direct_IO(struct kiocb *iocb, struct
> > > iov_iter *iter)
> > >   {
> > >       struct block_device *bdev = I_BDEV(iocb->ki_filp->f_mapping->host);
> > > +    bool is_atomic = iocb->ki_flags & IOCB_ATOMIC;
> > >       unsigned int nr_pages;
> > >       if (!iov_iter_count(iter))
> > >           return 0;
> > > -    if (blkdev_dio_unaligned(bdev, iocb->ki_pos, iter))
> > > +    if (blkdev_dio_invalid(bdev, iocb->ki_pos, iter, is_atomic))
> > 
> > Why not passing in iocb->ki_flags here?
> > Or, indeed, the entire iocb?
> 
> We could (pass the iocb), but we only need to look up one thing - ki_pos. We
> already have is_atomic local. I am just trying to make things as efficient
> as possible. If you really think it's better (to pass iocb), then it can be
> changed.

I certainly do. ;)

https://lore.kernel.org/linux-xfs/20240620212401.GA3058325@frogsfrogsfrogs/

--D

> Thanks,
> John
> 
> 

