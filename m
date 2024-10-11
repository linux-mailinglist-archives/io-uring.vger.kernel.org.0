Return-Path: <io-uring+bounces-3600-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id D33C999A94C
	for <lists+io-uring@lfdr.de>; Fri, 11 Oct 2024 18:59:25 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 873A61F2253B
	for <lists+io-uring@lfdr.de>; Fri, 11 Oct 2024 16:59:25 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AC35A19F406;
	Fri, 11 Oct 2024 16:59:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="XthzRxwl"
X-Original-To: io-uring@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7EFFA19F133;
	Fri, 11 Oct 2024 16:59:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728665948; cv=none; b=TBfl78BK3aL+bfOuv4vJIcMYjyWFemMqSSKKTFSIR0zoGiMDdq36pBC29H2sNpxGPtwhMZxSXe/LKtXKLbVCR9FSWvEvyQLVbgQzADwsJ9RAzky9pz8sGu/6osziICACiCundDEfwP6F9ytkLlSCp7M5T+kFm+Fc/f2heCCaLvI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728665948; c=relaxed/simple;
	bh=mkYGbk6JIVdaR+ngMKVGQQpONnRKTN08+o+35jtWhaw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=K1Ook/gX/dMm9JKMeK7h2z2fGzVGgThPekPpQtEV8fmHXTjw/4UCxh5J1dCP4WP7czFSwOsKRonlSBkEtLKpxY0BWsG4IuTfH+TTY3fWg5BnZwv4aqimpkqYfxYgo6vJMTJ2OEFV2NK1qiRtQC7a2yN8JMuoy46p6AWRekguANw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=XthzRxwl; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 087ADC4CEC3;
	Fri, 11 Oct 2024 16:59:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1728665948;
	bh=mkYGbk6JIVdaR+ngMKVGQQpONnRKTN08+o+35jtWhaw=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=XthzRxwlyTwMBL7/dqVToKwmwWz/tmxBQIW9AGGTzEbGctR95F+R+YjqQugDgkuM8
	 ZSdTLWGDrN9cpZ51C0wJxyeMztsF7Xnui24tVXpK4IRnur7/ZP3iqO0Tus+pEeEM0c
	 LHUarhCe+CYGrvy0yQHbNyjm5pR7UezxR/EfqQ33483z9FLJNAT2s5iNercKVORDh0
	 p1o9EahbR95h7eZ55BqhKXKbcRHrTuCkVs15ZBP9MtomhvKSdktlzZ2jSNLmLui8Ph
	 v30Z70FuMrkmRWIBObje29CAG014E7yhsJ30Qs6x/3H70RPamvzNp6T1FVHsUr2yVw
	 RDAOSf9awHmUA==
Date: Fri, 11 Oct 2024 10:59:05 -0600
From: Keith Busch <kbusch@kernel.org>
To: Javier Gonzalez <javier.gonz@samsung.com>
Cc: Christoph Hellwig <hch@lst.de>, Hans Holmberg <hans@owltronix.com>,
	Jens Axboe <axboe@kernel.dk>,
	Christian Brauner <brauner@kernel.org>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Kanchan Joshi <joshi.k@samsung.com>, "hare@suse.de" <hare@suse.de>,
	"sagi@grimberg.me" <sagi@grimberg.me>,
	"viro@zeniv.linux.org.uk" <viro@zeniv.linux.org.uk>,
	"jack@suse.cz" <jack@suse.cz>,
	"jaegeuk@kernel.org" <jaegeuk@kernel.org>,
	"bcrl@kvack.org" <bcrl@kvack.org>,
	"dhowells@redhat.com" <dhowells@redhat.com>,
	"bvanassche@acm.org" <bvanassche@acm.org>,
	"asml.silence@gmail.com" <asml.silence@gmail.com>,
	"linux-nvme@lists.infradead.org" <linux-nvme@lists.infradead.org>,
	"linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
	"io-uring@vger.kernel.org" <io-uring@vger.kernel.org>,
	"linux-block@vger.kernel.org" <linux-block@vger.kernel.org>,
	"linux-aio@kvack.org" <linux-aio@kvack.org>,
	"gost.dev@samsung.com" <gost.dev@samsung.com>,
	"vishak.g@samsung.com" <vishak.g@samsung.com>
Subject: Re: [PATCH v7 0/3] FDP and per-io hints
Message-ID: <ZwlZWWiPXT4NGErp@kbusch-mbp.mynextlight.net>
References: <20241007101011.boufh3tipewgvuao@ArmHalley.local>
 <CANr-nt3TA75MSvTNWP3SwBh60dBwJYztHJL5LZvROa-j9Lov7g@mail.gmail.com>
 <97bd78a896b748b18e21e14511e8e0f4@CAMSVWEXC02.scsc.local>
 <CANr-nt11OJfLRFr=rzH0LyRUzVD9ZFLKsgree=Xqv__nWerVkg@mail.gmail.com>
 <20241010071327.rnh2wsuqdvcu2tx4@ArmHalley.local>
 <CGME20241010092019eucas1p157b87b63e91cd2294df4a8f8e2de4cdf@eucas1p1.samsung.com>
 <20241010092010.GC9287@lst.de>
 <20241010122232.r2omntepzkmtmx7p@ArmHalley.local>
 <20241011085631.GA4039@lst.de>
 <20241011122102.znguf6kpmbbsa42t@ArmHalley.local>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20241011122102.znguf6kpmbbsa42t@ArmHalley.local>

On Fri, Oct 11, 2024 at 02:21:02PM +0200, Javier Gonzalez wrote:
> > That's a lot of marketing babble :)    What exact thing is missing
> > from the passthrough interface when using say spdx over io_uring?
> 
> The block layer provides a lot of functionality that passthru cannot
> provide. A simple example would be splits. You know this :)
> 
> I am sure Jens and Keith can give you more specifics on their particular
> reasons.

Splitting, merging, cgroups, iostats, error retries, failover.

We have a recent change staged in 6.13 to try to count iostats on
passthrough, but it doesn't do discards.

Passthrough to partitions requires root access and the slow CAP_SYSADMIN
check on every IO.

Page cache. Though that may not readily work with this io_uring proposal
as-is either.

The generic IO path is safe to changing formats; passthrough isn't.

And it's just generally more work to port existing applications to use
the passthrough interface. It causes duplicating solutions to scenarios
the kernel already handles.

