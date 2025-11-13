Return-Path: <io-uring+bounces-10558-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [142.0.200.124])
	by mail.lfdr.de (Postfix) with ESMTPS id 2BFB3C56C45
	for <lists+io-uring@lfdr.de>; Thu, 13 Nov 2025 11:11:04 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id 727E54E96BA
	for <lists+io-uring@lfdr.de>; Thu, 13 Nov 2025 10:07:33 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8EA502D739A;
	Thu, 13 Nov 2025 10:07:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="h9CWKL6V"
X-Original-To: io-uring@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 60A7029BDB0;
	Thu, 13 Nov 2025 10:07:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763028442; cv=none; b=SoHg4/x44492uY5Ty0cRRE6pWTXnpqqSICk8DBWA+vDkF4WVsZzc+xdba0lC06gW7LCjXzs0VNnUcUthBwUcs4OrZi79SoXdR+LXXjPwrwpL+GBDZ6l3NMMXEZBnCBJ9+FHjeZ3Vf9Desp45IMx3wdi71yU568cpJm8cQ6BjsBk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763028442; c=relaxed/simple;
	bh=b3VA823H8cA4p4hri58M0nhDqztktTrYY51gFDiD6/c=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=lMKzFvZd4E+xVsx8j8Me/Cl/KgXR3r7W8t9XW4WwnrhKuOogqmzoqm6btFpX8sj37Is3cZsAhTeKck24S/lvBaGZg92ofuC1N8jmTcAklxu3uPUg/DgRsxP5rgGhlmI/Y+69xM5v9EJBlBmH/spu5yerVY1IwGzaLk3VZQkOmDM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=h9CWKL6V; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 81BF7C113D0;
	Thu, 13 Nov 2025 10:07:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1763028442;
	bh=b3VA823H8cA4p4hri58M0nhDqztktTrYY51gFDiD6/c=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=h9CWKL6VbuALV0svoZZL1nnqIUvc3mlH2uhnyATuxQYyzRzOuVnigui8R4dTEVerP
	 BrO09D0Szpr53PWfHhDHbxNE6Yr1PFELmzikG08wGmU7VYvfyOVXug6pkz8WNGoTmm
	 Ld/V632WhqUlK9dFLmeiieM8izNkHQhix+gGpjKmgFSzJjfCwqrm0dGBsNndz7e1NP
	 +P8A76lLoVjwHiHqu17ZHjNkKX2pGlYEDBZQiLbMMCOhuDQptOX2hg5+NlumgjRXyU
	 GFIj/9pJRtBxZIvwKCsVHO62+HKopksUjOQk3CI16ZfjV1yMmLmaWjWBF19Eq1fLYP
	 18zQ/8HYdsD6A==
Message-ID: <2a5f574c-815a-497c-b244-dbdfabe39855@kernel.org>
Date: Thu, 13 Nov 2025 19:07:19 +0900
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: enable iomap dio write completions from interrupt context
To: Christoph Hellwig <hch@lst.de>, Jan Kara <jack@suse.cz>
Cc: Christian Brauner <brauner@kernel.org>,
 Alexander Viro <viro@zeniv.linux.org.uk>, "Darrick J. Wong"
 <djwong@kernel.org>, Jens Axboe <axboe@kernel.dk>,
 Avi Kivity <avi@scylladb.com>, Naohiro Aota <naohiro.aota@wdc.com>,
 Johannes Thumshirn <jth@kernel.org>, linux-xfs@vger.kernel.org,
 linux-fsdevel@vger.kernel.org, io-uring@vger.kernel.org
References: <20251112072214.844816-1-hch@lst.de>
 <zqi5yb34w6zsqe7yiv7nryx7xl23txy5fmr5h7ydug7rjnby3l@leukbllawuv2>
 <20251113100527.GA10056@lst.de>
Content-Language: en-US
From: Damien Le Moal <dlemoal@kernel.org>
Organization: Western Digital Research
In-Reply-To: <20251113100527.GA10056@lst.de>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 11/13/25 19:05, Christoph Hellwig wrote:
> On Thu, Nov 13, 2025 at 10:58:00AM +0100, Jan Kara wrote:
>> On Wed 12-11-25 08:21:24, Christoph Hellwig wrote:
>>> While doing this I've also found dead code which gets removed (patch 1)
>>> and an incorrect assumption in zonefs that read completions are called
>>> in user context, which it assumes for it's error handling.  Fix this by
>>> always calling error completions from user context (patch 2).
>>
>> Speaking of zonefs, I how is the unconditional locking of
>> zi->i_truncate_mutex in zonefs_file_write_dio_end_io() compatible with
>> inline completions?
> 
> It wouldn't, but zonefs doesn't use write inline completions because
> it marks all I/O to sequential zones as unwritten.

Yes, append writes only. Probably need to add a comment to clarify that to make
sure there is no mistake about the completion context.

-- 
Damien Le Moal
Western Digital Research

