Return-Path: <io-uring+bounces-3907-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id AB30D9AB109
	for <lists+io-uring@lfdr.de>; Tue, 22 Oct 2024 16:40:11 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 6CBDD2845D9
	for <lists+io-uring@lfdr.de>; Tue, 22 Oct 2024 14:40:10 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8C6B41A072C;
	Tue, 22 Oct 2024 14:40:07 +0000 (UTC)
X-Original-To: io-uring@vger.kernel.org
Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B0132199248;
	Tue, 22 Oct 2024 14:40:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729608007; cv=none; b=CqU/laGPah4rNQHZF2wM5LVgKpXyvxvSehZ6d0hzlrcVYiB0oQu/mUCgRZuninpl7tL8S5iy7z3faFpBYWW4LTqSpyCBmraHH4K4B1A/nv/SVJ81/VKP9vGzC6HzzQWDzLmdTGixrI/P/s+KJVzaasogBvWaxgChYyt2z3lYl4Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729608007; c=relaxed/simple;
	bh=Sru1ZLUBFmYmOT8sRLNSEHy8LCmLEdMzOswIqLxOKl8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=YzgPsnucf7bFOeUSO+5ymbEw4RhHBbJA4/Z/BfXFSL6ZpkFq/0qAsg+HDZ5En38gFzDdD8YXgd8dT4MIOBgwEIuHP6N3kqv7SF08vm6b/rcrI8D3OnpRT6wSKWN45aeO/idOqkUQrzgC/PcIoWwi2CepiOox+pON/5TvACSZqzk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id B88DA227AA8; Tue, 22 Oct 2024 16:40:00 +0200 (CEST)
Date: Tue, 22 Oct 2024 16:40:00 +0200
From: Christoph Hellwig <hch@lst.de>
To: Keith Busch <kbusch@kernel.org>
Cc: Christoph Hellwig <hch@lst.de>, Keith Busch <kbusch@meta.com>,
	linux-block@vger.kernel.org, linux-nvme@lists.infradead.org,
	axboe@kernel.dk, io-uring@vger.kernel.org,
	linux-fsdevel@vger.kernel.org, joshi.k@samsung.com,
	javier.gonz@samsung.com, Nitesh Shetty <nj.shetty@samsung.com>,
	Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCHv8 1/6] block, fs: restore kiocb based write hint
 processing
Message-ID: <20241022144000.GA19776@lst.de>
References: <20241017160937.2283225-1-kbusch@meta.com> <20241017160937.2283225-2-kbusch@meta.com> <20241018055032.GB20262@lst.de> <ZxZ3o_HzN8HN6QPK@kbusch-mbp> <20241022064309.GA11161@lst.de> <Zxe4xL-sM5yF2isM@kbusch-mbp>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Zxe4xL-sM5yF2isM@kbusch-mbp>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Tue, Oct 22, 2024 at 08:37:56AM -0600, Keith Busch wrote:
> No doubt it's almost certainly not a good idea to mix different stream
> usages, but that's not the kernels problem. It's user space policy. I
> don't think the kernel needs to perform any heroic efforts to split
> anything here. Just keep it simple.

Unfortunately it's not.  This complicated breaks any intelligent
scheme to manage them.  You can't write portable code assuming you
can know write streams when you need to cope with someone else using
some or all of the same resources.

