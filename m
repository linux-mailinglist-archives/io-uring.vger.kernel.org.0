Return-Path: <io-uring+bounces-4186-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id C09999B5AD2
	for <lists+io-uring@lfdr.de>; Wed, 30 Oct 2024 05:47:09 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 86868284765
	for <lists+io-uring@lfdr.de>; Wed, 30 Oct 2024 04:47:08 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AA56A192597;
	Wed, 30 Oct 2024 04:47:04 +0000 (UTC)
X-Original-To: io-uring@vger.kernel.org
Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C3CA8374F1;
	Wed, 30 Oct 2024 04:47:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730263624; cv=none; b=YITGhr+ZgalHTvr+YXzMnO5cPhgbKRF5O63Q9Om0puT9NSdWUudB5XZ4R9fShjFgLW77vpTz6GPmiBtpYlBP1RkvM9YEnrqz7l5QcNyopJXjikALnBVxNqCD4x2KwCWXQdWOA5qBw7OgeHO0bANjY/na/TJdHFTsGSEx6FisAdw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730263624; c=relaxed/simple;
	bh=/x4L28ef0xId3iGF9gr2b+luueoJOe+xhZv26NmOfi4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=gRcXc7xgFxvNjrFGIiBudYnE/OyeRaJEGZc3HF+eUUzcVtHcgY+12OAT25oIj0l+p5+8O5a5UYL1D3G4i4LVt/ypZIzXfMZRx/zdQHMt+2p5XMeAz56SVJ8ELZeaJYvDscpEbXv/VI8eWzWLDBIMTx56JPRVMRxr6RfgZXXPv/c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id DD0F5227A8E; Wed, 30 Oct 2024 05:46:58 +0100 (CET)
Date: Wed, 30 Oct 2024 05:46:58 +0100
From: Christoph Hellwig <hch@lst.de>
To: Bart Van Assche <bvanassche@acm.org>
Cc: Keith Busch <kbusch@meta.com>, linux-block@vger.kernel.org,
	linux-nvme@lists.infradead.org, linux-scsi@vger.kernel.org,
	io-uring@vger.kernel.org, linux-fsdevel@vger.kernel.org, hch@lst.de,
	joshi.k@samsung.com, javier.gonz@samsung.com,
	Keith Busch <kbusch@kernel.org>
Subject: Re: [PATCHv10 4/9] block: allow ability to limit partition write
 hints
Message-ID: <20241030044658.GA32344@lst.de>
References: <20241029151922.459139-1-kbusch@meta.com> <20241029151922.459139-5-kbusch@meta.com> <a1ff3560-4072-4ecf-8501-e353b1c98bf0@acm.org>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <a1ff3560-4072-4ecf-8501-e353b1c98bf0@acm.org>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Tue, Oct 29, 2024 at 10:25:11AM -0700, Bart Van Assche wrote:
>> +}
>
> bitmap_copy() is not atomic. Shouldn't the bitmap_copy() call be
> serialized against the code that tests bits in bdev->write_hint_mask?

It needs something.  I actually pointed that out last round, but forgot
about it again this time :)


