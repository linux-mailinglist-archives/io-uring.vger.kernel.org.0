Return-Path: <io-uring+bounces-3105-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id EC6F59739AA
	for <lists+io-uring@lfdr.de>; Tue, 10 Sep 2024 16:17:23 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 972701F21F2B
	for <lists+io-uring@lfdr.de>; Tue, 10 Sep 2024 14:17:23 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 803EC17BEC8;
	Tue, 10 Sep 2024 14:17:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="hnUz3AjZ"
X-Original-To: io-uring@vger.kernel.org
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 815131EB2F;
	Tue, 10 Sep 2024 14:17:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725977839; cv=none; b=diOvQeTCk9Bl8lo7D8zm3DrOMKBnUFeAkd3xSHK++3ZEfOKEn6kjez0dM1g1OJqTSat4BA+bsz1Wl58UpOXIgnSP7esPKiNzrGcAMN1s68pQujHjXX4VsrjTvOXhhwcxb0x1j73DslsCcotUHo8WZHy1nG/zbpsB5kO7G7I4q7o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725977839; c=relaxed/simple;
	bh=ILoKlmcc9IlBjuY4J36z4xq3BtRyZ37EwBe1tM0lrnk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=o1zWPb7D7SptjDcH3kjrc5aH2rWFszlK7YLfHV1uekKBIitUWGl6wr/EWf/I7ajCFaAqUPIzMoIGS5c9UFXjt/cMVHpLE377/8NvVNSUjvnJqVpygEMjPQVYP7lO1mvZpd6tRL3rI8Z1Wgu9tOwlNh7y6u+ulGZzmYUbIwis8Tk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=hnUz3AjZ; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=DkOrZ1Suf79nRPSASZN/zy8KeU8qA5QdhlPDiSeKVDE=; b=hnUz3AjZ8oQEKvbkyJ9wzk2EEY
	nibfCyItU0Jxw+x8oUp8v+zTkmkSv+FSCms/YGS4Oxb3TmrbX6G1O2AD2JDs6G5dq0zle2ObC5N1Q
	vl16jF51PffGlGNmWN4EkiJgAIAlw5jFpQvnXXFK7P872FNZv1d71/ygdSXDdlR+4eHjj+62l/qL2
	6PrNaa6rFOHARsNyAclXgdAAIHfL1Su6JERU4L97IQ1vIPYfH+dWvlATUVfk/tnRAIMJfg+68vywC
	iX5MYNmNjLcqkqhHB3UlMK69aQC1z4kEpR3c8aZW7eMTGzxpgKENYy9/wtQ3M/ccVnGW+u/RHPc9B
	+zNySoBA==;
Received: from hch by bombadil.infradead.org with local (Exim 4.97.1 #2 (Red Hat Linux))
	id 1so1g8-00000005qEM-0NM3;
	Tue, 10 Sep 2024 14:17:12 +0000
Date: Tue, 10 Sep 2024 07:17:12 -0700
From: Christoph Hellwig <hch@infradead.org>
To: Pavel Begunkov <asml.silence@gmail.com>
Cc: Christoph Hellwig <hch@infradead.org>, io-uring@vger.kernel.org,
	Jens Axboe <axboe@kernel.dk>, Conrad Meyer <conradmeyer@meta.com>,
	linux-block@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH v4 5/8] block: implement async discard as io_uring cmd
Message-ID: <ZuBU6Nn3lS21FN_Y@infradead.org>
References: <cover.1725621577.git.asml.silence@gmail.com>
 <7fc0a61ae29190a42e958eddfefd6d44cdf372ad.1725621577.git.asml.silence@gmail.com>
 <Zt_8wlXTyS2E7Xbe@infradead.org>
 <430ca5b3-6ee1-463b-9e4e-5d0b934578cc@gmail.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <430ca5b3-6ee1-463b-9e4e-5d0b934578cc@gmail.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

On Tue, Sep 10, 2024 at 11:58:23AM +0100, Pavel Begunkov wrote:
> > Based on the above this function is misnamed, as it validates sector_t
> > range and not a byte range.
> 
> Start and len here are in bytes. What do you mean?

You are right, sorry.

> > > +
> > > +	err = filemap_invalidate_pages(bdev->bd_mapping, start,
> > > +					start + len - 1, nowait);
> > > +	if (err)
> > > +		return err;
> > > +
> > > +	while ((bio = blk_alloc_discard_bio(bdev, &sector, &nr_sects, gfp))) {
> > > +		if (nowait)
> > > +			bio->bi_opf |= REQ_NOWAIT;
> > > +		prev = bio_chain_and_submit(prev, bio);
> > > +	}
> > > +	if (!prev)
> > > +		return -EAGAIN;
> > 
> > If a user changes the max_discard value between the check above and
> > the loop here this is racy.
> 
> If the driver randomly changes it, it's racy either way. What do
> you want to protect against?

The discard limit shrinking and now this successfully returning while
not actually discarding the range.  The fix is pretty simple in that
the nowait case should simply break out of the loop after the first bio.

> > > +sector_t bio_discard_limit(struct block_device *bdev, sector_t sector);
> > 
> > And to be honest, I'd really prefer to not have bio_discard_limit
> > exposed.  Certainly not outside a header private to block/.
> 
> Which is the other reason why first versions were putting down
> a bio seeing that there is more to be done for nowait, which
> you didn't like. I can return back to it or narrow the scopre.

The above should also take care of that.

> 
> > Also why start at 137?  A comment
> > would generally be pretty useful as well.
> 
> There is a comment, 2 lines above the new define.
> 
> /*
>  * A jump here: 130-136 are reserved for zoned block devices
>  * (see uapi/linux/blkzoned.h)
>  */
> 
> Is that your concern?

But those are ioctls, this is not an ioctl and uses a different
number space.  Take a look at e.g. nvme uring cmds which also
don't try to use the same number space as the ioctl.

> > Also can we have a include/uapi/linux/blkdev.h for this instead of
> > bloating fs.h that gets included just about everywhere?
> I don't think it belongs to this series.

How would adding a proper header instead of bloating fs.h not be
part of the series adding the first ever block layer uring_cmds?
Just in case I wasn't clear - this isn't asking you to move anything
existing as we can't do that without breaking existing applications.
It is about adding the new command to the proper place.


