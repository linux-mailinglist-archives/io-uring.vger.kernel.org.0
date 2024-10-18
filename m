Return-Path: <io-uring+bounces-3804-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 8D0D69A349F
	for <lists+io-uring@lfdr.de>; Fri, 18 Oct 2024 07:53:52 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id B2ABB1C237F2
	for <lists+io-uring@lfdr.de>; Fri, 18 Oct 2024 05:53:51 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EF645180A76;
	Fri, 18 Oct 2024 05:52:28 +0000 (UTC)
X-Original-To: io-uring@vger.kernel.org
Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 88A0314A09A;
	Fri, 18 Oct 2024 05:52:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729230748; cv=none; b=rP2swCvATthLgnKH3rcnsspoDxfgCOAXmAKgOUWAjjtRJUu+FxTXQuFy1G4zLK7pt2+3yYk6Wze6BjitB1mMSEPgJwTICjjDzTNHXuT6J6UvEtyC3IwtLvTmAGUyuWs/HUDpWlUw9xQnMwj8g6xv2rAkyOjoSsLT/LcOQBjDX7A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729230748; c=relaxed/simple;
	bh=3Q/6MEM8AaIADwK2/fajURuAKDtB/iOpwOi+a3baLo4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Q61vSjn5NtcXMGXEzQ6isJz/NLd96mE2ObeJ5QVOhXoRddHLwX0xxmkv0H6EJ1lV76Da/c5ziLExuthqTbH2wu1ZcXckNnAnqRJ7tUJlddClPhw2iY80pnbrUfiRmKuMe7nn5X0vqnCtJONlVtjNIZzBkNRnL63BgOTMMDdn+wQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id 81037227AAF; Fri, 18 Oct 2024 07:52:23 +0200 (CEST)
Date: Fri, 18 Oct 2024 07:52:23 +0200
From: Christoph Hellwig <hch@lst.de>
To: Keith Busch <kbusch@meta.com>
Cc: linux-block@vger.kernel.org, linux-nvme@lists.infradead.org,
	axboe@kernel.dk, hch@lst.de, io-uring@vger.kernel.org,
	linux-fsdevel@vger.kernel.org, joshi.k@samsung.com,
	javier.gonz@samsung.com, Keith Busch <kbusch@kernel.org>
Subject: Re: [PATCHv8 4/6] fs: introduce per-io hint support flag
Message-ID: <20241018055223.GD20262@lst.de>
References: <20241017160937.2283225-1-kbusch@meta.com> <20241017160937.2283225-5-kbusch@meta.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20241017160937.2283225-5-kbusch@meta.com>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Thu, Oct 17, 2024 at 09:09:35AM -0700, Keith Busch wrote:
> From: Keith Busch <kbusch@kernel.org>
> 
> A block device may support write hints on a per-io basis. The raw block
> file operations can effectively use these, but real filesystems are not
> ready to make use of this. Provide a file_operations flag to indicate
> support, and set it for the block file operations.

I'm a little worried about the overly generic "hint" think again.  Make
it very explicit about the write streams and this make sense.


