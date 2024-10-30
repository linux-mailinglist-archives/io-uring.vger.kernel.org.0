Return-Path: <io-uring+bounces-4193-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 038479B5B65
	for <lists+io-uring@lfdr.de>; Wed, 30 Oct 2024 06:42:17 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 2E5741C23B94
	for <lists+io-uring@lfdr.de>; Wed, 30 Oct 2024 05:42:17 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E04A91991DB;
	Wed, 30 Oct 2024 05:42:14 +0000 (UTC)
X-Original-To: io-uring@vger.kernel.org
Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1DBC1374F1;
	Wed, 30 Oct 2024 05:42:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730266934; cv=none; b=JNADVvgZznF808MiQM8D0axrAmz0htKX8kgXF3Yx+9h1qfeRF36cYKMTPED5j601i71IaB+5eClL5QnapLdE1F8Y9Rc/gAIsWRnjCpJhRzS77ClhnMB3vmB9GeDrvLQ9b3Etn+dOBu+5dMTEH/nE6WQ8AWmTFpRuXmZHrKxHrPo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730266934; c=relaxed/simple;
	bh=SU/XmvEAEa5q37B6RBI70LNF+4LJK5baqLboneZ3m5I=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=F8F/O4XgEyaiNz1RUjuEeEt4dWsKEVoRomKEVwgxobmaUXPn7cj1wt1CdfvFn57sU0QaEXFeFWOOlfGnub02jg6eH+K4VOXCFEyOeLIraokAql/t0zsjgZjma7Pj4rO/CH5FpBwd+KuMnLdm54/kiNAwQ8x8IJVf3sRwUROkx7k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id A1C4C227A8E; Wed, 30 Oct 2024 06:42:07 +0100 (CET)
Date: Wed, 30 Oct 2024 06:42:07 +0100
From: Christoph Hellwig <hch@lst.de>
To: Bart Van Assche <bvanassche@acm.org>
Cc: Christoph Hellwig <hch@lst.de>, Keith Busch <kbusch@meta.com>,
	linux-block@vger.kernel.org, linux-nvme@lists.infradead.org,
	linux-scsi@vger.kernel.org, io-uring@vger.kernel.org,
	linux-fsdevel@vger.kernel.org, joshi.k@samsung.com,
	javier.gonz@samsung.com, Keith Busch <kbusch@kernel.org>,
	Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCHv10 9/9] scsi: set permanent stream count in block limits
Message-ID: <20241030054207.GA604@lst.de>
References: <20241029151922.459139-1-kbusch@meta.com> <20241029151922.459139-10-kbusch@meta.com> <20241029152654.GC26431@lst.de> <343c29f2-59d6-48c5-937f-a02775b192ae@acm.org>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <343c29f2-59d6-48c5-937f-a02775b192ae@acm.org>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Tue, Oct 29, 2024 at 10:18:31AM -0700, Bart Van Assche wrote:
> On 10/29/24 8:26 AM, Christoph Hellwig wrote:
>> Bart, btw: I think the current sd implementation is buggy as well, as
>> it assumes the permanent streams are ordered by their data temperature
>> in the IO Advise hints mode page, but I can't find anything in the
>> spec that requires a particular ordering.
>
> How about modifying sd_read_io_hints() such that permanent stream
> information is ignored if the order of the RELATIVE LIFETIME information
> reported by the GET STREAM STATUS command does not match the permanent
> stream order?

That seems odd as there is nothing implying that they should be ordered.
The logic thing to do would be to a little array mapping the linux
temperature levels to the streams ids.


