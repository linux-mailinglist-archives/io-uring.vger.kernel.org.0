Return-Path: <io-uring+bounces-4289-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id A6BA59B8826
	for <lists+io-uring@lfdr.de>; Fri,  1 Nov 2024 02:05:14 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 492A21F23323
	for <lists+io-uring@lfdr.de>; Fri,  1 Nov 2024 01:05:14 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C3A9E61FDF;
	Fri,  1 Nov 2024 01:03:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="alh1FPiE"
X-Original-To: io-uring@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 908B920328;
	Fri,  1 Nov 2024 01:03:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730422985; cv=none; b=iHafHEri9zkWvD8hD493r9w5KdnzdhWkzCFSeyDVbDibCf+58EA+vOPxkJ/mWF5Suc/UfWdMX6CEPwCx/jKZJVrZTvG2JFgvbh4REhZcdfuxUUU8UrgGOOQzDajcKY7FOBqkve07KwjrZjr++W6JQ988MtGzNKOWaoYxLrOMuXk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730422985; c=relaxed/simple;
	bh=GVhdOyG4D9/kWSaCeNbk3Uqcva6Wo8dt9xAKwhBgsQ8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=iWcQ018VA4rr/+2sOReQg+ZG4anZgPltlv5rCJllimRVLDitVZxpvn9y/ZsDXn5aVfOCgAVqg5Q3L+LrECWkih8oogl7GDEsfLKlRneMi9rCGvti3R+XasfBefBdFOg0F6bVjLE9odysQBAnt0c+eysLDnLMc+enK1ZHrAKrfSY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=alh1FPiE; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 65631C4CEC3;
	Fri,  1 Nov 2024 01:03:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1730422985;
	bh=GVhdOyG4D9/kWSaCeNbk3Uqcva6Wo8dt9xAKwhBgsQ8=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=alh1FPiEhXxMuq+r1IGkC39v7wVLcBLb3xiRdeL0NgBnSeoFRcp8deeAVVURw33HZ
	 LUjt2airf+wAWeUkPKo2YKHf4UmLSgGWEeuwgiT4QzG4eHGWI8ENj62SSEa3L1hl8B
	 VrstlZ41MKrZSvjTQHlxBRu5CiaI5Rz+LuN4cG/HGOsIzvEe51pSkU8SzgIuRJSAmP
	 6FYmeVlVa3OrPmekhvaG00TB0WfjpQFwrzCnYJjhkvMFO5lCS7CZVDC+l9WH2aZd+O
	 ByiOaNfTJ56wvQKtvVf1Zu4axyEunyhk3GO9EImk3q7NN3kIOZHM9KZoaxRtgoBnXd
	 pBDah45ha5P8g==
Date: Fri, 1 Nov 2024 01:03:02 +0000
From: Jaegeuk Kim <jaegeuk@kernel.org>
To: Bart Van Assche <bvanassche@acm.org>
Cc: Christoph Hellwig <hch@lst.de>, Keith Busch <kbusch@kernel.org>,
	Keith Busch <kbusch@meta.com>, linux-block@vger.kernel.org,
	linux-nvme@lists.infradead.org, linux-scsi@vger.kernel.org,
	io-uring@vger.kernel.org, linux-fsdevel@vger.kernel.org,
	joshi.k@samsung.com, javier.gonz@samsung.com,
	Hannes Reinecke <hare@suse.de>,
	"Martin K . Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCHv10 9/9] scsi: set permanent stream count in block limits
Message-ID: <ZyQoxnwnI75Hi9vj@google.com>
References: <20241029152654.GC26431@lst.de>
 <ZyEAb-zgvBlzZiaQ@kbusch-mbp>
 <20241029153702.GA27545@lst.de>
 <ZyEBhOoDHKJs4EEY@kbusch-mbp>
 <20241029155330.GA27856@lst.de>
 <ZyEL4FOBMr4H8DGM@kbusch-mbp>
 <20241030045526.GA32385@lst.de>
 <c9c2574b-b3be-47ac-8a82-10d92c5892bc@acm.org>
 <20241030171450.GA12580@lst.de>
 <f644c6b2-7549-458d-8a24-07aa44c4b4ee@acm.org>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <f644c6b2-7549-458d-8a24-07aa44c4b4ee@acm.org>

On 10/30, Bart Van Assche wrote:
> On 10/30/24 10:14 AM, Christoph Hellwig wrote:
> > On Wed, Oct 30, 2024 at 09:59:24AM -0700, Bart Van Assche wrote:
> > > 
> > > On 10/29/24 9:55 PM, Christoph Hellwig wrote:
> > > > For the temperature hints the only public user I known is rocksdb, and
> > > > that only started working when Hans fixed a brown paperbag bug in the
> > > > rocksdb code a while ago.  Given that f2fs interprets the hints I suspect
> > > > something in the Android world does as well, maybe Bart knows more.
> > > 
> > > UFS devices typically have less internal memory (SRAM) than the size of a
> > > single zone.
> > 
> > That wasn't quite the question.  Do you know what application in android
> > set the fcntl temperature hints?
> 
> I do not know whether there are any Android apps that use the
> F_SET_(FILE_|)RW_HINT fcntls.
> 
> The only use case in Android platform code I know of is this one: Daejun
> Park, "f2fs-tools: add write hint support", f2fs-dev mailing list,
> September 2024 (https://lore.kernel.org/all/20240904011217epcms2p5a1b15db8e0ae50884429da7be4af4de4@epcms2p5/T/).
> As you probably know f2fs-tools is a software package that includes
> fsck.f2fs.
> 
> Jaegeuk, please correct me if necessary.

Yes, f2fs-tools in Android calls fcntl(fd, F_SET_RW_HINT, &hint);

> 
> Bart.
> 
> 

