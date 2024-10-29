Return-Path: <io-uring+bounces-4171-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 45E489B56CF
	for <lists+io-uring@lfdr.de>; Wed, 30 Oct 2024 00:26:16 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 77AF01C22528
	for <lists+io-uring@lfdr.de>; Tue, 29 Oct 2024 23:26:15 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5C11F20B20C;
	Tue, 29 Oct 2024 23:24:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="PcEIzXp+"
X-Original-To: io-uring@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2903F20ADFB;
	Tue, 29 Oct 2024 23:24:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730244298; cv=none; b=Gcye4iLfJeBqvSY3Yc5LCXbJD1VfL3D20JNsuOjQSBoqn3lei2OCMPBV9jokW6yGH0beHz9DsjfMK5naBkaI9d149jQqHhHL2JRYQbXX4yV3EoXYk83btqCT7WCcwr1W8OfuaZol91t88Snk9oAh7HSJ21YQWVB7JZGINeHy9bg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730244298; c=relaxed/simple;
	bh=5ITHqbWzAxBN2O3CfNPZlYSbccUPmxNcsdv/k1wZngY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=P8F0QHNdkyhnGQbubfVMOSuQ2oCcOME5Nme+292ELKVkiVKVDISdxBcRmqE6+yA0BWdj/2eHyMNETenIpRo8ANucXNud9J7KBc8N89VcQp6KFN4LLhpRjCLgZEDxzRjRy0SoAmA84Yw9R565xd5YsU4mFZEFe59Vn3gS2g6r1xQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=PcEIzXp+; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6FF91C4CEE3;
	Tue, 29 Oct 2024 23:24:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1730244297;
	bh=5ITHqbWzAxBN2O3CfNPZlYSbccUPmxNcsdv/k1wZngY=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=PcEIzXp+tfvVvUNURdk2SUgAXMb9xMsyCuJw8u1I/7arTS9xFYlFasZEZy2LB+AaU
	 cYy34kbm5DQ0q2D8xLdWEvHBgRtA5aDrv23CMY0dwpFYVPQ2x39rZ5l9zLR0360zEh
	 hdUfh3aRzAtgu2YHzgJJdHOgn7Ga/Fkd9BhXDvKDAxtm1mGYIi8I/t4aMio4AsL2j+
	 TS/wiKYUfmCGx44aN4IfJ3l3MFjFTzWwnMphpbUpZD94mz8MKh+YJ7ELGT3Gnb2gJe
	 d/yMn58h3JsAiYfxTD7pRBe0Ig9ax163xsoAiFzXO/BGuZ3V/eqrrTzmGl5a8znzBR
	 AoEXBnKGHIU1w==
Date: Tue, 29 Oct 2024 17:24:53 -0600
From: Keith Busch <kbusch@kernel.org>
To: Anuj Gupta <anuj20.g@samsung.com>
Cc: axboe@kernel.dk, hch@lst.de, martin.petersen@oracle.com,
	asml.silence@gmail.com, anuj1072538@gmail.com, brauner@kernel.org,
	jack@suse.cz, viro@zeniv.linux.org.uk, io-uring@vger.kernel.org,
	linux-nvme@lists.infradead.org, linux-block@vger.kernel.org,
	gost.dev@samsung.com, linux-scsi@vger.kernel.org,
	vishak.g@samsung.com, linux-fsdevel@vger.kernel.org,
	Kanchan Joshi <joshi.k@samsung.com>
Subject: Re: [PATCH v5 06/10] io_uring/rw: add support to send metadata along
 with read/write
Message-ID: <ZyFuxfiRqH8YB-46@kbusch-mbp.dhcp.thefacebook.com>
References: <20241029162402.21400-1-anuj20.g@samsung.com>
 <CGME20241029163225epcas5p24ec51c7a9b6b115757ed99cadcc3690c@epcas5p2.samsung.com>
 <20241029162402.21400-7-anuj20.g@samsung.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20241029162402.21400-7-anuj20.g@samsung.com>

On Tue, Oct 29, 2024 at 09:53:58PM +0530, Anuj Gupta wrote:
> This patch adds the capability of sending metadata along with read/write.
> A new meta_type field is introduced in SQE which indicates the type of
> metadata being passed. This meta is represented by a newly introduced
> 'struct io_uring_meta_pi' which specifies information such as flags,buffer
> length,seed and apptag. Application sets up a SQE128 ring, prepares
> io_uring_meta_pi within the second SQE.
> The patch processes the user-passed information to prepare uio_meta
> descriptor and passes it down using kiocb->private.
> 
> Meta exchange is supported only for direct IO.
> Also vectored read/write operations with meta are not supported
> currently.

It looks like it is reasonable to add support for fixed buffers too.
There would be implications for subsequent patches, mostly patch 10, but
it looks like we can do that.

Anyway, this patch mostly looks okay to me. I don't know about the whole
"meta_type" thing. My understanding from Pavel was wanting a way to
chain command specific extra options. For example, userspace metadata
and write hints, and this doesn't look like it can be extended to do
that.

