Return-Path: <io-uring+bounces-3788-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 615B99A27F5
	for <lists+io-uring@lfdr.de>; Thu, 17 Oct 2024 18:06:49 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 9B8E31C20CA4
	for <lists+io-uring@lfdr.de>; Thu, 17 Oct 2024 16:06:48 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 60DB31DE8AF;
	Thu, 17 Oct 2024 16:06:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="gffDCd6j"
X-Original-To: io-uring@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1B74B13B797;
	Thu, 17 Oct 2024 16:06:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729181205; cv=none; b=q7h8xoo+8+7f/aBEoXEJvQCkC2pV287ZrvcK54AXKXqbUhSIYls5Q2XSY7BQZRHGXjs99EjVIMm+PlgnSnKHchnD9Z0C9b3pKfThvtSfXILgjXGTGkkEqpDPiZLeV25Rgi52Q58UG4r9Wz+SnO5jFvWjp/ychwc/vEn5Ppu0ZFA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729181205; c=relaxed/simple;
	bh=sxLBVfVgG6T70/qpBvtsFGUgrJ9BQHiMs+QBb2kssdg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=A4sUtipHXXdmePTX/6VRwrHhU9L4k4UTrQhu6YoZBvZ2Rnq9vJfF02OEr4vsB0DcnUffylkctZq8BSQTAiGGM8tV5eqjUvcda/8XH8WLFKN5lV16YqSyok2ZIUeKK/50Y4vP2FRbzA1B1hz2VOJYQPP66bGujbirdsbonAiffeQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=gffDCd6j; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 481DCC4CEC3;
	Thu, 17 Oct 2024 16:06:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1729181204;
	bh=sxLBVfVgG6T70/qpBvtsFGUgrJ9BQHiMs+QBb2kssdg=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=gffDCd6jUTW1l1kOMeBrkIvTn0E+ToGcq/Xm+HdcLQ1Oza1utr/Oy1QbQxYgsjrWW
	 Z7r4Uc3GEa75Q+ZWX5YvKzBQcAunJCXuuNFfw8pZYvYStMxzWjb0pen98HU1Qt8/xk
	 kuhJg8Jf1aMhbmD1z03D7B2TVVa+YT5eNXGQMuPQXG6nuwimwzsPQuRa88P38+N5Ow
	 odQsIJrRlEiimxp1+3f3+nYrosWSNuWt0bvGwiyJ+bdSWrYKrqSfK73R+7UmJXGdu8
	 BXoN2+6XEeSWIUUo+d7LAiROz/12437PYHGbxV0iDZ4EliKp+XqaM/B2+R/nPJv9TO
	 H1z6YF5t/E7Xw==
Date: Thu, 17 Oct 2024 10:06:41 -0600
From: Keith Busch <kbusch@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: Kanchan Joshi <joshi.k@samsung.com>, axboe@kernel.dk, hare@suse.de,
	sagi@grimberg.me, martin.petersen@oracle.com, brauner@kernel.org,
	viro@zeniv.linux.org.uk, jack@suse.cz, jaegeuk@kernel.org,
	bcrl@kvack.org, dhowells@redhat.com, bvanassche@acm.org,
	asml.silence@gmail.com, linux-nvme@lists.infradead.org,
	linux-fsdevel@vger.kernel.org, io-uring@vger.kernel.org,
	linux-block@vger.kernel.org, linux-aio@kvack.org,
	gost.dev@samsung.com, vishak.g@samsung.com, javier.gonz@samsung.com
Subject: Re: [PATCH v7 0/3] FDP and per-io hints
Message-ID: <ZxE2EeZYKN1ZiSuT@kbusch-mbp.dhcp.thefacebook.com>
References: <CGME20240930182052epcas5p37edefa7556b87c3fbb543275756ac736@epcas5p3.samsung.com>
 <20240930181305.17286-1-joshi.k@samsung.com>
 <20241015055006.GA18759@lst.de>
 <8be869a7-c858-459a-a34b-063bc81ce358@samsung.com>
 <20241017152336.GA25327@lst.de>
 <ZxEw5-l6DtlXCQRO@kbusch-mbp.dhcp.thefacebook.com>
 <20241017154649.GA27203@lst.de>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20241017154649.GA27203@lst.de>

On Thu, Oct 17, 2024 at 05:46:49PM +0200, Christoph Hellwig wrote:
> On Thu, Oct 17, 2024 at 09:44:39AM -0600, Keith Busch wrote:
> 
> > We can add a fop_flags and block/fops.c can be the first one to turn it
> > on since that LBA access is entirely user driven.
> 
> Yes, that's my main request on the per-I/O hint interface.
> 
> Now we just need to not dumb down the bio level interface to five
> temeperature level and just expose the different write streams and we
> can all have a happy Kumbaya.

I'm sending a revised version of this patch set that attempts to address
these issues.

The io_uring hint is weird to me, so that part is simplified just to get
the point across.

