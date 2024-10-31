Return-Path: <io-uring+bounces-4269-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id C1F5D9B7C5A
	for <lists+io-uring@lfdr.de>; Thu, 31 Oct 2024 15:06:33 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id F2A4D1C214FB
	for <lists+io-uring@lfdr.de>; Thu, 31 Oct 2024 14:06:32 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D6B8C19DF99;
	Thu, 31 Oct 2024 14:06:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Yajt8S6A"
X-Original-To: io-uring@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A59C4193417;
	Thu, 31 Oct 2024 14:06:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730383588; cv=none; b=QFok1N9uEH63W8BOedWs48M0URNHZkg0g4XrCtulkFLBTUrbNiMMZVJ5AsIrFo3QJxIW7a/uYnMJMU0rOqJgdU5FHlM/X4RWV1Mcu7h2Lij1WrFrfsNTANUFH3jGupUsgcxKr1sqh3YdWargg93QmBOCx81zP75enYJF/E4q6L8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730383588; c=relaxed/simple;
	bh=Muuu1WqyPpcP/xIjgoC6z8E8xeJtiugg598fNvNyN/E=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=MV0JT534Z8tT/kKfSRwpll1urMPbU/GeWwjQ7sVtkB2kITQpEhqxOryUOVejsbDPpfJcdup5gjYxkaw5smn6xuxdcuF+vO4n+EM734wWyopJCQpDpUN3d8y1OeTG3CvClJDgIBMdzM3WlVJv7yDeWt16u4NFzRR9U4tWOrSAoFg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Yajt8S6A; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 97E5CC4FF52;
	Thu, 31 Oct 2024 14:06:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1730383587;
	bh=Muuu1WqyPpcP/xIjgoC6z8E8xeJtiugg598fNvNyN/E=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=Yajt8S6AC7lJXMJrgMLEU3WjiH6d4vU7KU0GM5nIxrxzkAw/O57yMJU7wWVVXTkNR
	 rY7sX5J9AIFrLXPtjGtoazojQ9YMoRazK6YBgLm/ELf+L+vJloJIS1QHBNTvOQnyzK
	 /l78HsUM4nNyzQrlqs8HL8HhaIy5TS1lfMc4hSDpq69PpZOzCBGlWoXYC+1wImnmbN
	 1YmgKCBdtkdZ+PXXHKzy4NmGvZwLiLJ9w0WFhqCqoV1tjb6rO1Inv5xcZOPlxoYUIG
	 SxWpP4CQAvW8UfWHyswYpaL0doLT2p3x8cHDslxjtZ6pL2ZtNVyfw6FDnII5RTIBDO
	 OiNIopie+Riww==
Date: Thu, 31 Oct 2024 08:06:24 -0600
From: Keith Busch <kbusch@kernel.org>
To: Hans Holmberg <hans@owltronix.com>
Cc: Christoph Hellwig <hch@lst.de>, Keith Busch <kbusch@meta.com>,
	linux-block@vger.kernel.org, linux-nvme@lists.infradead.org,
	linux-scsi@vger.kernel.org, io-uring@vger.kernel.org,
	linux-fsdevel@vger.kernel.org, joshi.k@samsung.com,
	javier.gonz@samsung.com, bvanassche@acm.org,
	Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCHv10 9/9] scsi: set permanent stream count in block limits
Message-ID: <ZyOO4PojaVIdmlOA@kbusch-mbp.dhcp.thefacebook.com>
References: <ZyEL4FOBMr4H8DGM@kbusch-mbp>
 <20241030045526.GA32385@lst.de>
 <ZyJTsyDjn6ABVbV0@kbusch-mbp.dhcp.thefacebook.com>
 <20241030154556.GA4449@lst.de>
 <ZyJVV6R5Ei0UEiVJ@kbusch-mbp.dhcp.thefacebook.com>
 <20241030155052.GA4984@lst.de>
 <ZyJiEwZwjevelmW2@kbusch-mbp.dhcp.thefacebook.com>
 <20241030165708.GA11009@lst.de>
 <ZyK0GS33Qhkx3AW-@kbusch-mbp.dhcp.thefacebook.com>
 <CANr-nt35zoSijRXYr+ommmWGfq0+Ye0tf3SfHfwi0cfpvwB0pg@mail.gmail.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CANr-nt35zoSijRXYr+ommmWGfq0+Ye0tf3SfHfwi0cfpvwB0pg@mail.gmail.com>

On Thu, Oct 31, 2024 at 09:19:51AM +0100, Hans Holmberg wrote:
> On Wed, Oct 30, 2024 at 11:33 PM Keith Busch <kbusch@kernel.org> wrote:
> > That is very much apples-to-oranges. The B+ isn't on the same device
> > being evaluated for WAF, where this has all that mixed in. I think the
> > results are pretty good, all things considered.
> 
> No. The meta data IO is just 0.1% of all writes, so that we use a
> separate device for that in the benchmark really does not matter.

It's very little spatially, but they overwrite differently than other
data, creating many small holes in large erase blocks.
 
> Since we can achieve a WAF of ~1 for RocksDB on flash, why should we
> be content with another 67% of unwanted device side writes on top of
> that?
> 
> It's of course impossible to compare your benchmark figures and mine
> directly since we are using different devices, but hey, we definitely
> have an opportunity here to make significant gains for FDP if we just
> provide the right kernel interfaces.
> 
> Why shouldn't we expose the hardware in a way that enables the users
> to make the most out of it?

Because the people using this want this interface. Stalling for the last
6 months hasn't produced anything better, appealing to non-existent
vaporware to block something ready-to-go that satisfies a need right
now is just wasting everyone's time.

Again, I absolutely disagree that this locks anyone in to anything.
That's an overly dramatic excuse.

