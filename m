Return-Path: <io-uring+bounces-3549-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 64A6B9981AB
	for <lists+io-uring@lfdr.de>; Thu, 10 Oct 2024 11:11:56 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id DCEADB29F23
	for <lists+io-uring@lfdr.de>; Thu, 10 Oct 2024 09:10:48 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 630A4192B69;
	Thu, 10 Oct 2024 09:10:29 +0000 (UTC)
X-Original-To: io-uring@vger.kernel.org
Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1F9FC8F6A;
	Thu, 10 Oct 2024 09:10:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728551429; cv=none; b=OVv8uuSaQTsbsHlaCsQ9FHHBD9N28ILlUtr0hObzPZVfU+2jaaYu2kf0lZfRwFHLbgy0/3c1ZZAyEUFwdSQrVU6u0TlQvbu9gkkhWFbj0rXZVjkoV7O+ScdK26rv1D+a/scRTWdnri+7ji9zKc9TgB32viyMlW8/O9wP3JREwsk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728551429; c=relaxed/simple;
	bh=Eh+gMxTT4mXmQNfcxuxyy5KBpH1alhH2XvStgqjym+o=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=A0rPh/r7Bz/4A4eIVwXWQ61T/hIUASLJYN0yTtsiP9PpadCegDwVuzKmQWbOtR9+EKIjWIOUCcjRloz5dDa+IOBhuPK1j1kCaAtzaCrbIz/NRdsXqpP/YoD+Txg02mEzqRg1ROUyxvbPaJXDZNoZq0psIHvlc3luhfBA6LNONHw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id E3E20227A8E; Thu, 10 Oct 2024 11:10:21 +0200 (CEST)
Date: Thu, 10 Oct 2024 11:10:21 +0200
From: Christoph Hellwig <hch@lst.de>
To: Keith Busch <kbusch@kernel.org>
Cc: Christoph Hellwig <hch@lst.de>,
	Javier =?iso-8859-1?Q?Gonz=E1lez?= <javier.gonz@samsung.com>,
	Jens Axboe <axboe@kernel.dk>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Kanchan Joshi <joshi.k@samsung.com>, hare@suse.de, sagi@grimberg.me,
	brauner@kernel.org, viro@zeniv.linux.org.uk, jack@suse.cz,
	jaegeuk@kernel.org, bcrl@kvack.org, dhowells@redhat.com,
	bvanassche@acm.org, asml.silence@gmail.com,
	linux-nvme@lists.infradead.org, linux-fsdevel@vger.kernel.org,
	io-uring@vger.kernel.org, linux-block@vger.kernel.org,
	linux-aio@kvack.org, gost.dev@samsung.com, vishak.g@samsung.com
Subject: Re: [PATCH v7 0/3] FDP and per-io hints
Message-ID: <20241010091021.GA9287@lst.de>
References: <20241004053121.GB14265@lst.de> <20241004061811.hxhzj4n2juqaws7d@ArmHalley.local> <20241004062733.GB14876@lst.de> <20241004065233.oc5gqcq3lyaxzjhz@ArmHalley.local> <20241004123027.GA19168@lst.de> <20241007101011.boufh3tipewgvuao@ArmHalley.local> <20241008122535.GA29639@lst.de> <ZwVFTHMjrI4MaPtj@kbusch-mbp> <20241009092828.GA18118@lst.de> <Zwab8WDgdqwhadlE@kbusch-mbp>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Zwab8WDgdqwhadlE@kbusch-mbp>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Wed, Oct 09, 2024 at 09:06:25AM -0600, Keith Busch wrote:
> > anything to the reclaim unit?  Or is this another of the cases where
> > as a hyperscaler you just "know" from the data sheet?
> 
> As far as I know, this is an inconsequential spec detail that is not
> being considered by any applications testing this. And yet, the expected
> imrpovements are still there, so I don't see a point holding this up for
> that reason.

It was the whole point of the thing, and a major source of complexity.
Although not quite for this use case Hans has numbers that aligning
application data tables / objects / etc to the underlying "erase unit"
absolutely matters.

And just to make it clear the objection here is not that we have an
an interface that doesn't take that into respect at the syscall
level.  We already have that interface and might as well make use
of that.  The problem is that the series tries to directly expose
that to the driver, freezing us into this incomplet interface forever
(assuming we have users actually picking it up).

That's why I keep insisting like a broken record that we need to get
this lower interface right first.

