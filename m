Return-Path: <io-uring+bounces-5396-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id D6D869EA96A
	for <lists+io-uring@lfdr.de>; Tue, 10 Dec 2024 08:19:28 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id C93EB16606F
	for <lists+io-uring@lfdr.de>; Tue, 10 Dec 2024 07:19:25 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A45C21FCCE6;
	Tue, 10 Dec 2024 07:19:25 +0000 (UTC)
X-Original-To: io-uring@vger.kernel.org
Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0B6B213B280;
	Tue, 10 Dec 2024 07:19:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733815165; cv=none; b=cLFNilVk684MLAhzJSD1ZDkbgH53xsNkQ9l+/elwKdcPy0/y4UmaAvNxSwtJymNLQk2Yagwv9gFIf+3njVIp4tgb1jmlcACs6mFlRxrHe7Ey9eo15906GovycqfGv/OaGRrLEHonl3hQ5LRNgb6dSucu0qMM7kfIaDPmloeqJJE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733815165; c=relaxed/simple;
	bh=HZbJ8nn17GehcYUrumxR3PzWo9nY4HQ+vlvfwaX8pbI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=rf+I7FGV8lweijUQu0IvTwaEJiy7+aufHzMSJhV3VzVbymHOLWVe2ZdH2PAmPFgyt1cUiRhYTkLVJlVxa/bog1ijaO7LyR62mHXNr4oLFcdGqT+7rI9HpGEKkyoiOlVSiLEBm18BQfRtS3RWWabNKM5wJyDXg/W8Ow4fTyz0Jrc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id 20BEC68C4E; Tue, 10 Dec 2024 08:19:18 +0100 (CET)
Date: Tue, 10 Dec 2024 08:19:17 +0100
From: Christoph Hellwig <hch@lst.de>
To: Keith Busch <kbusch@kernel.org>
Cc: Christoph Hellwig <hch@lst.de>, Keith Busch <kbusch@meta.com>,
	axboe@kernel.dk, linux-block@vger.kernel.org,
	linux-nvme@lists.infradead.org, linux-fsdevel@vger.kernel.org,
	io-uring@vger.kernel.org, sagi@grimberg.me, asml.silence@gmail.com,
	anuj20.g@samsung.com, joshi.k@samsung.com
Subject: Re: [PATCHv12 00/12] block write streams with nvme fdp
Message-ID: <20241210071916.GC19956@lst.de>
References: <20241206221801.790690-1-kbusch@meta.com> <20241209125511.GB14316@lst.de> <Z1cVx-EmaTgdFgVN@kbusch-mbp.dhcp.thefacebook.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Z1cVx-EmaTgdFgVN@kbusch-mbp.dhcp.thefacebook.com>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Mon, Dec 09, 2024 at 09:07:35AM -0700, Keith Busch wrote:
> Yep, pretty much. I will revisit the partition mapping. I just haven't
> heard any use cases for divvying the streams up this way, so it's not
> clear to me what the interface needs to provide.

Yes, it would be good to understand use cases first.  I just threw the
patch in as a POC to show we can do it.

> > One thing that came I was pondering for a new version is if statx
> > really is the right vehicle for this as it is a very common fast-path
> > information.  If we had a separate streaminfo ioctl or fcntl it might
> > be easier to leave a bit spare space for extensibility.  I can try to
> > prototype that or we can leave it as-is because everyone is tired of
> > the series.
> 
> Oh sure. I can live without the statx parts from this series if you
> prefer we take additional time to consider other approaches. We have the
> sysfs block attributes reporting the same information, and that is okay
> for now.

I'll try to find some time this afternoon for an interface, but if it
doesn't arrive in time we can probably drop if for the next submission.

