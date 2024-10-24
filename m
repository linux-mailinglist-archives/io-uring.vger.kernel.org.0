Return-Path: <io-uring+bounces-4003-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id D851D9AF2C9
	for <lists+io-uring@lfdr.de>; Thu, 24 Oct 2024 21:45:08 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 9DA8F2849D1
	for <lists+io-uring@lfdr.de>; Thu, 24 Oct 2024 19:45:07 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 927511FF02C;
	Thu, 24 Oct 2024 19:45:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="iMm7iwRB"
X-Original-To: io-uring@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 616D2169AE4;
	Thu, 24 Oct 2024 19:45:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729799105; cv=none; b=uVeun1f+lSNsMFQPVUp+UIXOVmYW2lCyfBPqB4noJiwg9MBnidbX3RhYC6bnq/a4S8TsTtq9/ptXztZ3ixEC/FyvXUPOspqUcxqYkOVXwkevgqtHuaFasznq8BXT7AqNWTOT+pJ7GEfCUrwum/lYtjXgkdJrGxkIf356yg7ocb4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729799105; c=relaxed/simple;
	bh=c3ndfUOsrrS7srSLbBC5XHM8epxlV6CY0XRm3bJUdrk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=bO5uTov2WN9dx3yy/rgr4UC4TSRtTIdxR+fiNQhyQi30bg08EJ0+WgdD20jvobyjsmPdbcTkKlJLwgHfwX3N8ujwMnSg0b2CZJCGOFpZdedaxq4P+3S6Ga2xelMWReF39nSHf3olVBtboNIbOm08/CioFjD6A3eviVMbLQx9v9Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=iMm7iwRB; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 73751C4CEC7;
	Thu, 24 Oct 2024 19:45:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1729799105;
	bh=c3ndfUOsrrS7srSLbBC5XHM8epxlV6CY0XRm3bJUdrk=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=iMm7iwRB0IZhUym/BkBFYexGqZs5nJlZjVp6oVWt2Y+QKne9rEfQ8OP5uGohgohK5
	 OiLmtiC6Qcki98RPMySRRWlpwcdMEmFLZ+/OQp8MaYl4f3oON41x5L0VpNeY3PMrYg
	 ANIwH36Hdj6UkfYudeAL5AwSm4C01OH3kIlZD7LXJHXDrRglTNUiU6c0MYQsvr8c5o
	 W2CrIRTSUcfVjtU7jyIVcfJkDZ2qCYFfmze8hT/onGmRyUslacLh8u42UKGSt+E5bD
	 0isyu0ZkRtRKyd+IBnN5hp7ulV05UaHP1cOFz4f9nlbiQDrqwRGML40hlhUkWhtRjG
	 zNWDjrPygqmnw==
Date: Thu, 24 Oct 2024 13:45:02 -0600
From: Keith Busch <kbusch@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: Keith Busch <kbusch@meta.com>, linux-block@vger.kernel.org,
	linux-nvme@lists.infradead.org, axboe@kernel.dk,
	io-uring@vger.kernel.org, linux-fsdevel@vger.kernel.org,
	joshi.k@samsung.com, javier.gonz@samsung.com
Subject: Re: [PATCHv8 2/6] block: use generic u16 for write hints
Message-ID: <Zxqjvu0w9OsJN2uB@kbusch-mbp.dhcp.thefacebook.com>
References: <20241017160937.2283225-1-kbusch@meta.com>
 <20241017160937.2283225-3-kbusch@meta.com>
 <20241018054643.GA20262@lst.de>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20241018054643.GA20262@lst.de>

On Fri, Oct 18, 2024 at 07:46:44AM +0200, Christoph Hellwig wrote:
> On Thu, Oct 17, 2024 at 09:09:33AM -0700, Keith Busch wrote:
> > From: Keith Busch <kbusch@kernel.org>
> > 
> > This is still backwards compatible with lifetime hints. It just doesn't
> > constrain the hints to that definition.
> 
> So in the end we'll end up with two uses of it - the existing 5
> temperature hints and the new stream separation.  I think it
> would be cleaner to make it a union, but I don't care that
> strongly.
> 
> But we probably want a way to distinguish which one is supported.
> 
> E.g. for SCSI we set a net BLK_FEAT_WRITE_HINTS, for NVMe we'll set
> BLK_FEAT_STREAM_SEPARATION.
> 
> Either way this should probably be the first patch in the series.

I'm not sure I follow this feedback. The SCSI feature is defined as a
lifetime stream association in SBC-5. So it's still a stream for SCSI,
but you want to call it "WRITE_HINT", which is not a term used in the
SCSI spec for this feature. But, you want to call it STREAM_SEPARATION
for NVMe only, even though the FDP spec doesn't use that term? What's
wrong with just calling it a generic hint support feature?

I also don't see why SCSI couldn't use per-io hints just like this
enables for NVMe. The spec doesn't limit SCSI to just 5 streams, so this
provides a way to access them all through the raw block device.

