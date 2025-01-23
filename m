Return-Path: <io-uring+bounces-6106-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 3A27CA1AB93
	for <lists+io-uring@lfdr.de>; Thu, 23 Jan 2025 21:49:24 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 29740188CC74
	for <lists+io-uring@lfdr.de>; Thu, 23 Jan 2025 20:49:28 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6C2261A00F8;
	Thu, 23 Jan 2025 20:49:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=debian.org header.i=@debian.org header.b="O52KtsL8"
X-Original-To: io-uring@vger.kernel.org
Received: from stravinsky.debian.org (stravinsky.debian.org [82.195.75.108])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C2A5415A843;
	Thu, 23 Jan 2025 20:49:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=82.195.75.108
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737665359; cv=none; b=bsY79gYa5580XOm1LLkYw9dRZEwg186SjzpJBjn/18kR66CGDP8rJgYEHeFEZ0ClczEhSWwmkwsfbybATn0LXREvQVEQM2iXutTRAEk29kVWL0JLQ861EyPdaQ/T58od1zjiG0Pft0dNzfNGR5DYOzs9WL+sLVjyCaSUjui7sOQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737665359; c=relaxed/simple;
	bh=3l117U1Gc3uv/Xt3eCYeSZ/aZyPw2a+xJtJEBl62iN8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=MsK1xkPbP07vuATwAbHWvzliHIf72O0oAU/YS6wkkfoCAqBLTafvalFOsfKP6QS/yIlgQlRq+ZNGyEFfkgfprIsGuYeh3TvBKWDy8Or0hOrfo1abu1y7PfSeFhd519SXUHxwNliVKmP6nyz25CaTlK9xEAgC+tY7kuaY5j4s4Bs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=debian.org; spf=none smtp.mailfrom=debian.org; dkim=pass (2048-bit key) header.d=debian.org header.i=@debian.org header.b=O52KtsL8; arc=none smtp.client-ip=82.195.75.108
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=debian.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=debian.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=debian.org;
	s=smtpauto.stravinsky; h=X-Debian-User:In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=dvTD+C75nSQ2asi1cLlJtsE7plbOvGdwkde3A5xTFB4=; b=O52KtsL8LRK18v8529cZuYoPIq
	ZoMblikCJV1VQbVFksJAtQAfupIBLD3y97spZVqc45MS3qYD3nkRf1Ic7hlCsV3EXR6+9Hr/h2Eny
	hEKvrC6Lt+CifUDTKfT97vyOmVaCxOyS+4elSFnBW49m4XhReX9gIBbzoNg2mTxHAERMNoRiLc8sd
	+MBN90gcUY9MzKIN7krvO5PGFYW1lGbtZv15o22MwdgISSIKKwUvSkFrTAp5aM1jsEo1lvyNEErJu
	GTDMXKIZMx/g3uNTqBlV+zIblEuxm5+m9QeRYxp77Xldp+U3k8DzOX8+1hOn4BLX0yJ7krVO4cfr3
	LgH9MTbg==;
Received: from authenticated user
	by stravinsky.debian.org with esmtpsa (TLS1.3:ECDHE_X25519__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
	(Exim 4.94.2)
	(envelope-from <carnil@debian.org>)
	id 1tb48S-008mt1-45; Thu, 23 Jan 2025 20:49:09 +0000
Received: by eldamar.lan (Postfix, from userid 1000)
	id 06DF8BE2EE7; Thu, 23 Jan 2025 21:49:07 +0100 (CET)
Date: Thu, 23 Jan 2025 21:49:06 +0100
From: Salvatore Bonaccorso <carnil@debian.org>
To: Xan Charbonnet <xan@charbonnet.com>, 1093243@bugs.debian.org,
	Jens Axboe <axboe@kernel.dk>
Cc: Bernhard Schmidt <berni@debian.org>,
	Pavel Begunkov <asml.silence@gmail.com>, io-uring@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: Bug#1093243: Upgrade to 6.1.123 kernel causes mariadb hangs
Message-ID: <Z5KrQktoX4f2ysXI@eldamar.lan>
References: <173706089225.4380.9492796104667651797.reportbug@backup22.biblionix.com>
 <dde09d65-8912-47e4-a1bb-d198e0bf380b@charbonnet.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <dde09d65-8912-47e4-a1bb-d198e0bf380b@charbonnet.com>
X-Debian-User: carnil

Hi Xan,

On Thu, Jan 23, 2025 at 02:31:34PM -0600, Xan Charbonnet wrote:
> I rented a Linode and have been trying to load it down with sysbench
> activity while doing a mariabackup and a mysqldump, also while spinning up
> the CPU with zstd benchmarks.  So far I've had no luck triggering the fault.
> 
> I've also been doing some kernel compilation.  I followed this guide:
> https://www.dwarmstrong.org/kernel/
> (except that I used make -j24 to build in parallel and used make
> localmodconfig to compile only the modules I need)
> 
> I've built the following kernels:
> 6.1.123 (equivalent to linux-image-6.1.0-29-amd64)
> 6.1.122
> 6.1.121
> 6.1.120
> 
> So far they have all exhibited the behavior.  Next up is 6.1.119 which is
> equivalent to linux-image-6.1.0-28-amd64.  My expectation is that the fault
> will not appear for this kernel.
> 
> It looks like the issue is here somewhere:
> https://www.kernel.org/pub/linux/kernel/v6.x/ChangeLog-6.1.120
> 
> I have to work on some other things, and it'll take a while to prove the
> negative (that is, to know that the failure isn't happening).  I'll post
> back with the 6.1.119 results when I have them.

Additionally please try with 6.1.120 and revert this commit 

3ab9326f93ec ("io_uring: wake up optimisations")

(which landed in 6.1.120).

If that solves the problem maybe we miss some prequisites in the 6.1.y
series here?

Regards,
Salvatore

