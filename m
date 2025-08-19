Return-Path: <io-uring+bounces-9054-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 60FC0B2BD39
	for <lists+io-uring@lfdr.de>; Tue, 19 Aug 2025 11:26:48 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 6B0D93BFFEC
	for <lists+io-uring@lfdr.de>; Tue, 19 Aug 2025 09:25:48 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2AC57311962;
	Tue, 19 Aug 2025 09:22:28 +0000 (UTC)
X-Original-To: io-uring@vger.kernel.org
Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A79E131AF26;
	Tue, 19 Aug 2025 09:22:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755595348; cv=none; b=ASgTweRT7hx5qT34gsgH3QMxY7Sy76RrJt5X91x9KpT9UuUXnfFs54OCzZHcBu5ttZujBpm9GaBRrYHOmn8IILn0x3S+gKVH1w3FsuOfo5JOypYJxFaO/8vIm7eTooEpr6M4W2EdmTnB0E+a55vAnPNuJ3pk2DQqOx8qSJOmaRQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755595348; c=relaxed/simple;
	bh=VCqMc3TXp0iFDecZLOI6OI90KnUXXPHTpDdlAmnlyWY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=cyx5AoZfsEg+/xZRp2xlmo0IRmSwgRGNN2AYgB56vrMCL4ZxzhbowpstiRUaHCqmZufvPN1kkVGikvB7AzgBbz07ZXyW7U1virw1W3XhMPVx1lEKr/HEdzWZwCm58jdgp9vG99O9if449bO9LYs3xFfIC1GmhIs1S6ae6PWGBLg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id 6CCF7227A88; Tue, 19 Aug 2025 11:22:20 +0200 (CEST)
Date: Tue, 19 Aug 2025 11:22:19 +0200
From: Christoph Hellwig <hch@lst.de>
To: Christian Brauner <brauner@kernel.org>
Cc: Christoph Hellwig <hch@lst.de>, Jens Axboe <axboe@kernel.dk>,
	Alexander Viro <viro@zeniv.linux.org.uk>, Jan Kara <jack@suse.cz>,
	Anuj Gupta <anuj20.g@samsung.com>,
	Kanchan Joshi <joshi.k@samsung.com>, linux-block@vger.kernel.org,
	linux-fsdevel@vger.kernel.org, io-uring@vger.kernel.org
Subject: Re: [PATCH 1/2] fs: add a FMODE_ flag to indicate
 IOCB_HAS_METADATA availability
Message-ID: <20250819092219.GA6234@lst.de>
References: <20250819082517.2038819-1-hch@lst.de> <20250819082517.2038819-2-hch@lst.de> <20250819-erwirbt-freischaffend-e3d3c1e8967a@brauner>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250819-erwirbt-freischaffend-e3d3c1e8967a@brauner>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Tue, Aug 19, 2025 at 11:14:41AM +0200, Christian Brauner wrote:
> It kind of feels like that f_iocb_flags should be changed so that
> subsystems like block can just raise some internal flags directly
> instead of grabbing a f_mode flag everytime they need to make some
> IOCB_* flag conditional on the file. That would mean changing the
> unconditional assigment to file->f_iocb_flags to a |= to not mask flags
> raised by the kernel itself.

This isn't about block.  I will be setting this for a file system
operation as well and use the same io_uring code for that.  That's
how I ran into the issue.


