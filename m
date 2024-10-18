Return-Path: <io-uring+bounces-3803-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 60EE39A3490
	for <lists+io-uring@lfdr.de>; Fri, 18 Oct 2024 07:51:53 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id E543BB21858
	for <lists+io-uring@lfdr.de>; Fri, 18 Oct 2024 05:51:50 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3490D17B50A;
	Fri, 18 Oct 2024 05:51:46 +0000 (UTC)
X-Original-To: io-uring@vger.kernel.org
Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B05751547C3;
	Fri, 18 Oct 2024 05:51:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729230706; cv=none; b=GYabACyAQVm+hifuU4XGsIJOzH+Hhhm941vLHHkJTSpJ3ZRKXnTfBVRtSP1duoeawPfeqZ+DStlIp/4OP5qyQylgEu9rGqyIyFc1+HDMzDK50DobIdAZdUyE4URl5hX4J0mk+N6gQCkYkhMO+ASeEWB6zzlhoeHidiJx9Qe30sY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729230706; c=relaxed/simple;
	bh=3TQ5nthrd5UypsQOg3KaUcv9w9IUfLCFXLwvRqEH+f4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=S5GqaFjEkJbpFY1c2GVsyj3XnJBCEoTm6qOCzCpIlsNT5TvfAQaKbaJnEzQo8zvGU6ARj6kZA2vkx5BRvUyffpIwprzk7VSlo7VuXwLI8pRMOgqeCGSLHt4wwgF+b8e5cWe/SIJndKM41sPPzPupRayo7F7la6D+y5C+HPLMMb8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id C74E7227AAF; Fri, 18 Oct 2024 07:51:40 +0200 (CEST)
Date: Fri, 18 Oct 2024 07:51:40 +0200
From: Christoph Hellwig <hch@lst.de>
To: Keith Busch <kbusch@meta.com>
Cc: linux-block@vger.kernel.org, linux-nvme@lists.infradead.org,
	axboe@kernel.dk, hch@lst.de, io-uring@vger.kernel.org,
	linux-fsdevel@vger.kernel.org, joshi.k@samsung.com,
	javier.gonz@samsung.com, Keith Busch <kbusch@kernel.org>
Subject: Re: [PATCHv8 3/6] block: introduce max_write_hints queue limit
Message-ID: <20241018055140.GC20262@lst.de>
References: <20241017160937.2283225-1-kbusch@meta.com> <20241017160937.2283225-4-kbusch@meta.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20241017160937.2283225-4-kbusch@meta.com>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Thu, Oct 17, 2024 at 09:09:34AM -0700, Keith Busch wrote:
> From: Keith Busch <kbusch@kernel.org>
> 
> Drivers with hardware that support write hints need a way to export how
> many are available so applications can generically query this.

Calling this write hints vs write streams is very confusing.

Otherwise this looks reasonable.


