Return-Path: <io-uring+bounces-4020-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 734489B0212
	for <lists+io-uring@lfdr.de>; Fri, 25 Oct 2024 14:21:01 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 1EE7C1F234DB
	for <lists+io-uring@lfdr.de>; Fri, 25 Oct 2024 12:21:01 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C95A81FE0EA;
	Fri, 25 Oct 2024 12:20:11 +0000 (UTC)
X-Original-To: io-uring@vger.kernel.org
Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CFFBC22B668;
	Fri, 25 Oct 2024 12:20:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729858811; cv=none; b=ICY4cwjuZJUE4S5v7/UP8NeHyGrGB27CML/V2eHPJcXnTd2NMnO6FpsXvlsraTK5211piB5T/S5NHz6cIPPyhIsyfyY8y6eKkSH946ZhkNMJD644ZKfj1XudQaiCnSdjXd5zpCTx9mmjiKfF0lTwloJAdT7mGljg5QxZJlIq7eE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729858811; c=relaxed/simple;
	bh=8X80uaXF8TqfdaImqADVxCzpnrXj4/8HBIouSuTJMqk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=l8fz9P329IbPjfCyu9KwFuJo5KLm3Kl1k7BSl1z1f3NRwRN/IOJKp/6F4FsZnwPvIaCldSQ+dAlYZTEDycOsTNdhQo25M+CJXbF5OCbn1lkU+w/HoNy9k2dNOUgSatkTA66QfM/IEN7KXYOrUdNypVSs9hBQqzAI4yFyUUZOJcA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id 75910227A88; Fri, 25 Oct 2024 14:20:04 +0200 (CEST)
Date: Fri, 25 Oct 2024 14:20:04 +0200
From: Christoph Hellwig <hch@lst.de>
To: Keith Busch <kbusch@kernel.org>
Cc: Christoph Hellwig <hch@lst.de>, Keith Busch <kbusch@meta.com>,
	linux-block@vger.kernel.org, linux-nvme@lists.infradead.org,
	axboe@kernel.dk, io-uring@vger.kernel.org,
	linux-fsdevel@vger.kernel.org, joshi.k@samsung.com,
	javier.gonz@samsung.com
Subject: Re: [PATCHv8 2/6] block: use generic u16 for write hints
Message-ID: <20241025122004.GA22710@lst.de>
References: <20241017160937.2283225-1-kbusch@meta.com> <20241017160937.2283225-3-kbusch@meta.com> <20241018054643.GA20262@lst.de> <Zxqjvu0w9OsJN2uB@kbusch-mbp.dhcp.thefacebook.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Zxqjvu0w9OsJN2uB@kbusch-mbp.dhcp.thefacebook.com>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Thu, Oct 24, 2024 at 01:45:02PM -0600, Keith Busch wrote:
> I'm not sure I follow this feedback. The SCSI feature is defined as a
> lifetime stream association in SBC-5. So it's still a stream for SCSI,
> but you want to call it "WRITE_HINT", which is not a term used in the
> SCSI spec for this feature. But, you want to call it STREAM_SEPARATION
> for NVMe only, even though the FDP spec doesn't use that term? What's
> wrong with just calling it a generic hint support feature?

The "Constrained Streams with Data Lifetimes" are called streams for
political reasons but they are not.  They are buckets of different data
lifetimes.

> I also don't see why SCSI couldn't use per-io hints just like this
> enables for NVMe. The spec doesn't limit SCSI to just 5 streams, so this
> provides a way to access them all through the raw block device.

I don't mind passing per-I/O temperature hints to SCSI block devices.

But we should not confuse a streams/FDP like streams that are different
context which are assumed to be discarded together and have a concept of
Stream Granularity Size or Reclaim Unit size with the data temperature
hints that are at the storage level fundamentally per-I/O and just bucket
into temperature group without any indication of data locality.

