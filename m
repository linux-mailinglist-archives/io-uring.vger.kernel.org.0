Return-Path: <io-uring+bounces-4770-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 5823C9D10F6
	for <lists+io-uring@lfdr.de>; Mon, 18 Nov 2024 13:50:54 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 047851F225A7
	for <lists+io-uring@lfdr.de>; Mon, 18 Nov 2024 12:50:54 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DCC4E19884B;
	Mon, 18 Nov 2024 12:50:35 +0000 (UTC)
X-Original-To: io-uring@vger.kernel.org
Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B4D6626AD0;
	Mon, 18 Nov 2024 12:50:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731934235; cv=none; b=aSOxNT8C1aBrQUg39iKvHRYw5PA5BI0c+iFVnT6U7YqvKkYp93lVncJrL9ogoLh6aamG3OCyY84lDBTJNz881SIRvAvllR5ihfAis+mLS74TvAzUTMoBzMib2Ri4426nW5W1Wc7YzmZ1jBeoLGBru2E0xxMlQ2aD5outhDB1T6w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731934235; c=relaxed/simple;
	bh=vVc30S78CSd0YTffVqXFcysvNZ66QZx3RW5IvODdI6g=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=QDrDZhkNePb3QdWGUAsNhQCFQebu0ABeQLuJ+SAR2GUdByU0kNvjKU1IER0mp4Q6Rrsevp7enwh8vRuxlRuvQ31OqW7ooabTcPu9tRlmj3bEARMgf6fM4/c77nJL1jzDy7rFaveiKU62a8WCAyE0etaUEluZKlOfjDI8NF/feV0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id 106FF68BFE; Mon, 18 Nov 2024 13:50:30 +0100 (CET)
Date: Mon, 18 Nov 2024 13:50:29 +0100
From: Christoph Hellwig <hch@lst.de>
To: Pavel Begunkov <asml.silence@gmail.com>
Cc: Anuj Gupta <anuj20.g@samsung.com>, axboe@kernel.dk, hch@lst.de,
	kbusch@kernel.org, martin.petersen@oracle.com,
	anuj1072538@gmail.com, brauner@kernel.org, jack@suse.cz,
	viro@zeniv.linux.org.uk, io-uring@vger.kernel.org,
	linux-nvme@lists.infradead.org, linux-block@vger.kernel.org,
	gost.dev@samsung.com, linux-scsi@vger.kernel.org,
	vishak.g@samsung.com, linux-fsdevel@vger.kernel.org,
	Kanchan Joshi <joshi.k@samsung.com>
Subject: Re: [PATCH v9 06/11] io_uring: introduce attributes for read/write
 and PI support
Message-ID: <20241118125029.GB27505@lst.de>
References: <20241114104517.51726-1-anuj20.g@samsung.com> <CGME20241114105405epcas5p24ca2fb9017276ff8a50ef447638fd739@epcas5p2.samsung.com> <20241114104517.51726-7-anuj20.g@samsung.com> <c622ee8c-82f0-44d4-99da-91357af7ecac@gmail.com> <b61e1bfb-a410-4f5f-949d-a56f2d5f7791@gmail.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <b61e1bfb-a410-4f5f-949d-a56f2d5f7791@gmail.com>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Sat, Nov 16, 2024 at 12:32:25AM +0000, Pavel Begunkov wrote:
> We can also reuse your idea from your previous iterations and
> use the bitmap to list all attributes. Then preamble and
> the explicit attr_type field are not needed, type checking
> in the loop is removed and packing is better. And just
> by looking at the map we can calculate the size of the
> array and remove all size checks in the loop.

Can we please stop overdesigning the f**k out of this?  Really,
either we're fine using the space in the extended SQE, or
we're fine using a separate opcode, or if we really have to just
make it uring_cmd.  But stop making thing being extensible for
the sake of being extensible.


