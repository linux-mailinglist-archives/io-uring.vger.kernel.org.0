Return-Path: <io-uring+bounces-4065-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 2974A9B33BC
	for <lists+io-uring@lfdr.de>; Mon, 28 Oct 2024 15:38:11 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id C90E31F2267A
	for <lists+io-uring@lfdr.de>; Mon, 28 Oct 2024 14:38:10 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1F7131DDC12;
	Mon, 28 Oct 2024 14:38:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Kidl4wY2"
X-Original-To: io-uring@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E6FFC1DB350;
	Mon, 28 Oct 2024 14:38:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730126288; cv=none; b=QM8fXb4uPnFfk8V+1JZ1sBJzXXRpcEcf0eI/UOhcc4CE8V2lXQ/ORLZjlV5z4DMKYjMvJDY489Xqzr/cSiOUMfxTvNgORfC3qvzohN146bwG81/nvpKzoZox9uaL4hVz3KZy1Vc5pp/jMyT/A3U+gGiH7YGK27xC5nhWGXCxHFY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730126288; c=relaxed/simple;
	bh=WBihszhgpbdEbKDk5fhd5HVOlYkYO0uSU5+sDIILYF0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=P9cLkD9iUDO2Uvrl2K/jTXgdd2iG+STFBvKbAN95kp/AmFAUS21XkaFFU+YhVgad+8SN4QTurUD2nCZAKuBbetCdioDfeirUrpVwNUSerEk6XnhbY9zhe31njQ4149PyGjpOAS4UFg6uDKPDdBOx9i7orhVUP+nSq7EGzHI/wec=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Kidl4wY2; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1BA5FC4CEC3;
	Mon, 28 Oct 2024 14:38:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1730126287;
	bh=WBihszhgpbdEbKDk5fhd5HVOlYkYO0uSU5+sDIILYF0=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=Kidl4wY2iDvB2eVMqxFD1HjOWFIatEISx40q3eIVQmoJ60Ua9in6X6dMDgGM/WxZS
	 8coUkV8wt04cObM2LFKTdywh2xaSXAbrEGMiQ2ue5yqx4gLWeaCRysN/YkR6Aq3u0C
	 w5s1X/5Plpe8d/q0isevYMBzy+nsJfK4XVvrfXQ8++AJ8WkwWkgzt8F6FE3NPEhuV+
	 B3ohC5T7rdS3p89s/r9xhSRxmR+Oq5/WEIFpr1A1EiX3DDm3iyLHwgdxY0Py1+MkA+
	 l54v2oPnMsXsRZBWHAi+MGn3Yo8e/s/VyELqL+t8EWvkguEF99LJhg01Zm1YFzla0J
	 UYqpZOnKUwZqA==
Date: Mon, 28 Oct 2024 08:38:05 -0600
From: Keith Busch <kbusch@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: Keith Busch <kbusch@meta.com>, linux-block@vger.kernel.org,
	linux-nvme@lists.infradead.org, linux-scsi@vger.kernel.org,
	io-uring@vger.kernel.org, linux-fsdevel@vger.kernel.org,
	joshi.k@samsung.com, javier.gonz@samsung.com, bvanassche@acm.org
Subject: Re: [PATCHv9 4/7] block, fs: add write hint to kiocb
Message-ID: <Zx-hzSwkkUMeuA5C@kbusch-mbp>
References: <20241025213645.3464331-1-kbusch@meta.com>
 <20241025213645.3464331-5-kbusch@meta.com>
 <20241028115932.GE8517@lst.de>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20241028115932.GE8517@lst.de>

On Mon, Oct 28, 2024 at 12:59:32PM +0100, Christoph Hellwig wrote:
> On Fri, Oct 25, 2024 at 02:36:42PM -0700, Keith Busch wrote:
> > +static u16 blkdev_write_hint(struct kiocb *iocb, struct block_device *bdev)
> > +{
> > +	u16 hint = iocb->ki_write_hint;
> > +
> > +	if (!hint)
> > +		return file_inode(iocb->ki_filp)->i_write_hint;
> > +
> > +	if (hint > bdev_max_write_hints(bdev))
> > +		return file_inode(iocb->ki_filp)->i_write_hint;
> > +
> > +	if (bdev_is_partition(bdev) &&
> > +	    !test_bit(hint - 1, bdev->write_hint_mask))
> > +		return file_inode(iocb->ki_filp)->i_write_hint;
> 
> I would have expected an error when using an invalid stream identifier.

It's a hint. fcntl doesn't error if you give an unusable hint, so
neither should this. You get sane default behavior.

