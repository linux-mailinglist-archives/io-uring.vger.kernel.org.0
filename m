Return-Path: <io-uring+bounces-4120-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 38A0F9B4DE3
	for <lists+io-uring@lfdr.de>; Tue, 29 Oct 2024 16:27:18 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id B6709B25EA5
	for <lists+io-uring@lfdr.de>; Tue, 29 Oct 2024 15:27:15 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 208A41940AA;
	Tue, 29 Oct 2024 15:27:04 +0000 (UTC)
X-Original-To: io-uring@vger.kernel.org
Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0FB6619309C;
	Tue, 29 Oct 2024 15:27:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730215624; cv=none; b=QgBCg9Vz3gZj4B9SCu6LJSGbySGNgWmdmBiIQ2gvgYqzhv6gysDHIIAg9SyEnm+eUy4SAhYzXNBy8aJe5KnvCyBejUos9VZqzS07mLVS3sHQBQdWfUKqQlcJWwmq0fJXD1xN05gHilZT71+T0jgu6OfIGk6JLCTEcTA1o51bt2s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730215624; c=relaxed/simple;
	bh=/pvci0BvRZBzSCT6XSTLpWjoAKmRXAcUJaMMtgUC9Kk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=uHtJ2eIXCeYhtoLvixQJRKEEyTNhf1lQM+29a5XXlr+9Y8luGTZvtu5kPOgEpU0ZL0hkJX2jQ6mixkErrGanetDYnPmxAsPJMvNPyxDbj0JHqmR4i04M82xTD5FppFCjySwhdTcgq/gBrEHIaKkYOYrNNbW4Jknj4QQLsCaFQCU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id 064C7227A88; Tue, 29 Oct 2024 16:26:55 +0100 (CET)
Date: Tue, 29 Oct 2024 16:26:54 +0100
From: Christoph Hellwig <hch@lst.de>
To: Keith Busch <kbusch@meta.com>
Cc: linux-block@vger.kernel.org, linux-nvme@lists.infradead.org,
	linux-scsi@vger.kernel.org, io-uring@vger.kernel.org,
	linux-fsdevel@vger.kernel.org, hch@lst.de, joshi.k@samsung.com,
	javier.gonz@samsung.com, bvanassche@acm.org,
	Keith Busch <kbusch@kernel.org>, Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCHv10 9/9] scsi: set permanent stream count in block limits
Message-ID: <20241029152654.GC26431@lst.de>
References: <20241029151922.459139-1-kbusch@meta.com> <20241029151922.459139-10-kbusch@meta.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20241029151922.459139-10-kbusch@meta.com>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Tue, Oct 29, 2024 at 08:19:22AM -0700, Keith Busch wrote:
> From: Keith Busch <kbusch@kernel.org>
> 
> The block limits exports the number of write hints, so set this limit if
> the device reports support for the lifetime hints. Not only does this
> inform the user of which hints are possible, it also allows scsi devices
> supporting the feature to utilize the full range through raw block
> device direct-io.
> 
> Reviewed-by: Bart Van Assche <bvanassche@acm.org>
> Reviewed-by: Hannes Reinecke <hare@suse.de>
> Signed-off-by: Keith Busch <kbusch@kernel.org>

Despite the reviews this is still incorrect.  The permanent streams have
a relative data temperature associated with them as pointed out last
round and are not arbitrary write stream contexts despite (ab)using
the SBC streams facilities.

Bart, btw: I think the current sd implementation is buggy as well, as
it assumes the permanent streams are ordered by their data temperature
in the IO Advise hints mode page, but I can't find anything in the
spec that requires a particular ordering.


