Return-Path: <io-uring+bounces-4778-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 6119A9D16B2
	for <lists+io-uring@lfdr.de>; Mon, 18 Nov 2024 18:03:52 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 274922814E4
	for <lists+io-uring@lfdr.de>; Mon, 18 Nov 2024 17:03:51 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 099DA1BDABE;
	Mon, 18 Nov 2024 17:03:36 +0000 (UTC)
X-Original-To: io-uring@vger.kernel.org
Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A50CA1BD4E2;
	Mon, 18 Nov 2024 17:03:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731949415; cv=none; b=iQNskrV1BPItOKd77cIGALT8KG2sLKzka/DEHieHSkUwC+JtdVMux/14lbGAB0sdmawmHA/5lTROei5Mlb54pXptKIHvNXrY1q8NyjRgGeMyfmG231p/h4iCR5mIdH8NeGjg/6MuRBcZSTCWxzFkj0zKQwdQofcf7vEv4rIf3Dw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731949415; c=relaxed/simple;
	bh=aKT4+yPOL+JA1/XTTM8RRhWneRBcVJHNJ25rVLNFFFI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=AZn1TKT/NI1uPN82v2SrL1rn+7UeN5M7jgqEVavjwwtPGKFULKumgYBeMWX+kUiaKky1Rnuw9rFyTg7y2nonpsnXAt40yenvsoESYFh/3fZkheGUNz/FUGofzZqRAQ2V/Ezsn4S37LPyzQCbplLQykqt1uh0FC879QGAmeIEdYA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id 6053068D12; Mon, 18 Nov 2024 18:03:29 +0100 (CET)
Date: Mon, 18 Nov 2024 18:03:29 +0100
From: Christoph Hellwig <hch@lst.de>
To: Pavel Begunkov <asml.silence@gmail.com>
Cc: Christoph Hellwig <hch@lst.de>, Anuj Gupta <anuj20.g@samsung.com>,
	axboe@kernel.dk, kbusch@kernel.org, martin.petersen@oracle.com,
	anuj1072538@gmail.com, brauner@kernel.org, jack@suse.cz,
	viro@zeniv.linux.org.uk, io-uring@vger.kernel.org,
	linux-nvme@lists.infradead.org, linux-block@vger.kernel.org,
	gost.dev@samsung.com, linux-scsi@vger.kernel.org,
	vishak.g@samsung.com, linux-fsdevel@vger.kernel.org,
	Kanchan Joshi <joshi.k@samsung.com>
Subject: Re: [PATCH v9 06/11] io_uring: introduce attributes for read/write
 and PI support
Message-ID: <20241118170329.GA14956@lst.de>
References: <20241114104517.51726-1-anuj20.g@samsung.com> <CGME20241114105405epcas5p24ca2fb9017276ff8a50ef447638fd739@epcas5p2.samsung.com> <20241114104517.51726-7-anuj20.g@samsung.com> <c622ee8c-82f0-44d4-99da-91357af7ecac@gmail.com> <b61e1bfb-a410-4f5f-949d-a56f2d5f7791@gmail.com> <20241118125029.GB27505@lst.de> <2a98aa33-121b-46ed-b4ae-e4049179819a@gmail.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <2a98aa33-121b-46ed-b4ae-e4049179819a@gmail.com>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Mon, Nov 18, 2024 at 04:59:22PM +0000, Pavel Begunkov wrote:
>>
>> Can we please stop overdesigning the f**k out of this?  Really,
>
> Please stop it, it doesn't add weight to your argument. The design
> requirement has never changed, at least not during this patchset
> iterations.

That's what you think because you are overdesigning the hell out of
it.  And at least for me that rings every single alarm bell about
horrible interface design.

>> either we're fine using the space in the extended SQE, or
>> we're fine using a separate opcode, or if we really have to just
>> make it uring_cmd.  But stop making thing being extensible for
>> the sake of being extensible.
>
> It's asked to be extendible because there is a good chance it'll need to
> be extended, and no, I'm not suggesting anyone to implement the entire
> thing, only PI bits is fine.

Extensibility as in having reserved fields that can be checked for
is one thing.  "Extensibility" by adding indirections over indirections
without a concrete use case is another thing.  And we're deep into the
latter phase now.

> And no, it doesn't have to be "this or that" while there are other
> options suggested for consideration. And the problem with the SQE128
> option is not even about SQE128 but how it's placed inside, i.e.
> at a fixed spot.
>
> Do we have technical arguments against the direction in the last
> suggestion?

Yes.  It adds completely pointless indirections and variable offsets.
How do you expect people to actually use that sanely without
introducing bugs left right and center?

I really don't get why you want to make an I/O fast path as complicated
as possible.

