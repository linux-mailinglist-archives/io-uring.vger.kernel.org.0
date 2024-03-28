Return-Path: <io-uring+bounces-1279-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 1DBFC88F9CF
	for <lists+io-uring@lfdr.de>; Thu, 28 Mar 2024 09:13:37 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id C6C111F28468
	for <lists+io-uring@lfdr.de>; Thu, 28 Mar 2024 08:13:36 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E3CBF2C1BC;
	Thu, 28 Mar 2024 08:13:29 +0000 (UTC)
X-Original-To: io-uring@vger.kernel.org
Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ADA8A54773;
	Thu, 28 Mar 2024 08:13:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711613609; cv=none; b=ZM7TH7MHtJr8gm/0oQfG4iSNNeTM1n271Y8+/hUxTqhZl2B2dDfiJ0vsbmP6xycEcx+dQ/VOzWyHA2Y0pcmSMIjgjCJqo9AwiYkSBfFwkPoRWD8SVU6goDANaVsOdJSN32R3J2vA2tq6Ip4EBwMEjR6YBOYjErtOy6fPCoCG4iE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711613609; c=relaxed/simple;
	bh=44nDPrOav98Wyexxa4Uaj0Zxfq1SDBpzo41Bhi9De8w=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=l4EU77ycc7k6PW7szQ1DEhRkrMqBGA66gIL5dgEFseChBmTCq1RlufAOG0oyTZYPBYNh/qikt6CQS4ptYdSbDazqGfUDZUtL+SywmafXOpTM7CxHa547sQ1tZU58ylxnYiXL7JbFff5ewlxmQ6Nd4kIQk690SizhkG/oTfSDjSc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id AC17A68D17; Thu, 28 Mar 2024 09:13:23 +0100 (CET)
Date: Thu, 28 Mar 2024 09:13:23 +0100
From: Christoph Hellwig <hch@lst.de>
To: Christian Brauner <brauner@kernel.org>
Cc: Dave Chinner <david@fromorbit.com>, linux-fsdevel@vger.kernel.org,
	Jan Kara <jack@suse.cz>, Christoph Hellwig <hch@lst.de>,
	Jens Axboe <axboe@kernel.dk>,
	Alexander Viro <viro@zeniv.linux.org.uk>, io-uring@vger.kernel.org
Subject: Re: [PATCH] [RFC]: fs: claw back a few FMODE_* bits
Message-ID: <20240328081323.GB19225@lst.de>
References: <20240327-begibt-wacht-b9b9f4d1145a@brauner> <ZgTFTu8byn0fg9Ld@dread.disaster.area> <20240328-palladium-getappt-ce6ae1dc17aa@brauner>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240328-palladium-getappt-ce6ae1dc17aa@brauner>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Thu, Mar 28, 2024 at 09:06:43AM +0100, Christian Brauner wrote:
> > Why do we need to set any of these for directory operations now that
> > we have a clear choice? i.e. we can't mmap directories, and the rest
> > of these flags are for read() and write() operations which we also
> > can't do on directories...
> 
> Yeah, I know but since your current implementation raises them for both
> I just did it 1:1:

Yes, sticking to the 1:1 for this patch is probably a good idea.
But we should also fix this in a trivial follow on patch.  I can
write it and add it to your series.


