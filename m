Return-Path: <io-uring+bounces-4123-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 8581E9B4E29
	for <lists+io-uring@lfdr.de>; Tue, 29 Oct 2024 16:37:15 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id B682B1C20E81
	for <lists+io-uring@lfdr.de>; Tue, 29 Oct 2024 15:37:14 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0DF891922FA;
	Tue, 29 Oct 2024 15:37:10 +0000 (UTC)
X-Original-To: io-uring@vger.kernel.org
Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4679F192D73;
	Tue, 29 Oct 2024 15:37:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730216229; cv=none; b=O5iUeu0jdXJNMHti0ScIynnEajN3hdYIWvEdBEJus+XL7AIWyfFasEssZ+WTQfGYNmTa7v0fAOGH/whNqReAJzftHpgaeZF2heRvIKQ1s4uWsEBV2Mg7Ki8V2EBPZPKAHgnB0t5ZOUJe8vLwnYMDHmFyRAUjkPyDDVxwk2eoFkE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730216229; c=relaxed/simple;
	bh=lFQQZjnzLNHPgQNeCTI6H4PsC8XIjLOfXpfRMh4dzUY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=qulMqhKNSgnWGw86zEY5cGWIdZlvklXh0/nGoZY/kExaTwC3luE6YBaB1A06cpEvKnqA+aLOlikV2efnoNKUfhJZnnpcSa6WNHnucUZ2hPSiie2QJr+Z7A+dgXG4MarcZZY3aQGrZIkll0sfByWFXFkIugNzn1JtPEx/wdgIXpE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id 260AC227AAD; Tue, 29 Oct 2024 16:37:03 +0100 (CET)
Date: Tue, 29 Oct 2024 16:37:02 +0100
From: Christoph Hellwig <hch@lst.de>
To: Keith Busch <kbusch@kernel.org>
Cc: Christoph Hellwig <hch@lst.de>, Keith Busch <kbusch@meta.com>,
	linux-block@vger.kernel.org, linux-nvme@lists.infradead.org,
	linux-scsi@vger.kernel.org, io-uring@vger.kernel.org,
	linux-fsdevel@vger.kernel.org, joshi.k@samsung.com,
	javier.gonz@samsung.com, bvanassche@acm.org,
	Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCHv10 9/9] scsi: set permanent stream count in block limits
Message-ID: <20241029153702.GA27545@lst.de>
References: <20241029151922.459139-1-kbusch@meta.com> <20241029151922.459139-10-kbusch@meta.com> <20241029152654.GC26431@lst.de> <ZyEAb-zgvBlzZiaQ@kbusch-mbp>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZyEAb-zgvBlzZiaQ@kbusch-mbp>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Tue, Oct 29, 2024 at 09:34:07AM -0600, Keith Busch wrote:
> So then don't use it that way? I still don't know what change you're
> expecting to happen with this feedback. What do you want the kernel to
> do differently here?

Same as before:  don't expose them as write streams, because they
aren't.  A big mess in this series going back to the versions before
your involvement is that they somehow want to tie up the temperature
hints with the stream separation, which just ends up very messy.

