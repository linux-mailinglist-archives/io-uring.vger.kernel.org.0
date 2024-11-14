Return-Path: <io-uring+bounces-4695-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 1131A9C8DB7
	for <lists+io-uring@lfdr.de>; Thu, 14 Nov 2024 16:19:45 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 05CECB227B9
	for <lists+io-uring@lfdr.de>; Thu, 14 Nov 2024 15:19:41 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1331D13AD39;
	Thu, 14 Nov 2024 15:19:34 +0000 (UTC)
X-Original-To: io-uring@vger.kernel.org
Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 42C3B288DA;
	Thu, 14 Nov 2024 15:19:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731597574; cv=none; b=cgK/pYX2Lks6f/m5J2wGOJP1/C/kPFEeS5djDlxbaixGrZS2RrDDd7vm/ywirEFhYdZGmPZWzQjLVgO0dUI1k3zg8l/j9OGBwhwm/ckMi+fgEqpQ229zf2Nt1HHCkkDlIf+KQQyIoRIi7EbcERPd70TEG137aJleBAOUGHrJu0c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731597574; c=relaxed/simple;
	bh=qUnSlvyUDSBoc/EG85EnJYig+SRuW/pJ++tdUa7RIYM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=G0wrVapFDgp359UUGWbTiuRVMBisOs4zDg1Dblvv9NLtl41fj9n6Yv+o7RnBUD/25ZfPWs1T8RmB4MH5AJ6BaOQn/bqA4QYRVxyFqL7sZ2JaSBC+MMIi1axLkLMIMEnjSWyjXDhy8//cfjsXdWfXLL7uJZiKuhB5sBUiGQyHmTw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id 5473668C7B; Thu, 14 Nov 2024 16:19:21 +0100 (CET)
Date: Thu, 14 Nov 2024 16:19:21 +0100
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
Message-ID: <20241114151921.GA28206@lst.de>
References: <20241114104517.51726-1-anuj20.g@samsung.com> <CGME20241114105405epcas5p24ca2fb9017276ff8a50ef447638fd739@epcas5p2.samsung.com> <20241114104517.51726-7-anuj20.g@samsung.com> <20241114121632.GA3382@lst.de> <3fa101c9-1b38-426d-9d7c-8ed488035d4a@gmail.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <3fa101c9-1b38-426d-9d7c-8ed488035d4a@gmail.com>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Thu, Nov 14, 2024 at 01:09:44PM +0000, Pavel Begunkov wrote:
>> Eww.  I know it's frustration for your if maintainers give contradicting
>> guidance, but this is really an awful interface.  Not only the pointless
>
> Because once you placed it at a fixed location nothing realistically
> will be able to reuse it. Not everyone will need PI, but the assumption
> that there will be more more additional types of attributes / parameters.

So?  If we have a strong enough requirement for something else we
can triviall add another opcode.  Maybe we should just add different
opcodes for read/write with metadata so that folks don't freak out
about this?

> With SQE128 it's also a problem that now all SQEs are 128 bytes regardless
> of whether a particular request needs it or not, and the user will need
> to zero them for each request.

The user is not going to create a SQE128 ring unless they need to,
so this seem like a bit of an odd objection.


