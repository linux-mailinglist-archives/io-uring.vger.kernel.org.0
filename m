Return-Path: <io-uring+bounces-4731-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 532349CF27C
	for <lists+io-uring@lfdr.de>; Fri, 15 Nov 2024 18:12:29 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 00A941F21F81
	for <lists+io-uring@lfdr.de>; Fri, 15 Nov 2024 17:12:29 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 874601D5CFB;
	Fri, 15 Nov 2024 17:12:11 +0000 (UTC)
X-Original-To: io-uring@vger.kernel.org
Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BE9411D54D6;
	Fri, 15 Nov 2024 17:12:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731690731; cv=none; b=p4QmbYXPVYWY2TMKAaQw/wt2flOBZ/hqW8VvKEw242NrTRgk8M4hDbiVTSKSV0Dz/ZDbZVqrQcX6snKJqmryB5MwdYD61tMbBeOPAng7Er0x/Q9YYMe22ezfHnH4QeIEfTLcAdC/nciHLBf1lUnriRMRlvVzMjgqEC1AAMZpWXw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731690731; c=relaxed/simple;
	bh=o0JniwdGM26ckI6rARVWzEW4E5UgWvCj7h4qvQEDMh4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=okUUthhkYM5ZYeZWgbgkgazrLlyQUzofqVgfLJ7Dxfqg/DOOq3WnEegVZN39/CrSu8yfrUl5NfXI+UWZmXHAdodUBt0uyyAMYQ06ZmRyClv6FlzdqBFKk4ylQOC6pNwxLSgOCDBM+3M37Q51tuwcYYQmfMCqoKgaaUNEHea5VwA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id 644E668D12; Fri, 15 Nov 2024 18:12:05 +0100 (CET)
Date: Fri, 15 Nov 2024 18:12:05 +0100
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
Message-ID: <20241115171205.GA23990@lst.de>
References: <20241114104517.51726-1-anuj20.g@samsung.com> <CGME20241114105405epcas5p24ca2fb9017276ff8a50ef447638fd739@epcas5p2.samsung.com> <20241114104517.51726-7-anuj20.g@samsung.com> <20241114121632.GA3382@lst.de> <3fa101c9-1b38-426d-9d7c-8ed488035d4a@gmail.com> <20241114151921.GA28206@lst.de> <f945c1fc-2206-45fe-8e83-ebe332a84cb5@gmail.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <f945c1fc-2206-45fe-8e83-ebe332a84cb5@gmail.com>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Fri, Nov 15, 2024 at 04:40:58PM +0000, Pavel Begunkov wrote:
>> So?  If we have a strong enough requirement for something else we
>> can triviall add another opcode.  Maybe we should just add different
>> opcodes for read/write with metadata so that folks don't freak out
>> about this?
>
> IMHO, PI is not so special to have a special opcode for it unlike
> some more generic read/write with meta / attributes, but that one
> would have same questions.

Well, apparently is one the hand hand not general enough that you
don't want to give it SQE128 space, but you also don't want to give
it an opcode.

Maybe we just need make it uring_cmd to get out of these conflicting
requirements.

Just to make it clear: I'm not a huge fan of a separate opcode or
uring_cmd, but compared to the version in this patch it is much better.

> PI as a special case. And that's more of a problem of the static
> placing from previous version, e.g. it wouldn't be a problem if in the
> long run it becomes sth like:
>
> struct attr attr, *p;
>
> if (flags & META_IN_USE_SQE128)
> 	p = sqe + 1;
> else {
> 	copy_from_user(&attr);
> 	p = &attr;
> }
>
> but that shouldn't be PI specific.

Why would anyone not use the SQE128 version?


