Return-Path: <io-uring+bounces-6215-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id B8FC6A25297
	for <lists+io-uring@lfdr.de>; Mon,  3 Feb 2025 07:53:42 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 848CD1883E01
	for <lists+io-uring@lfdr.de>; Mon,  3 Feb 2025 06:53:47 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 19F872557C;
	Mon,  3 Feb 2025 06:53:39 +0000 (UTC)
X-Original-To: io-uring@vger.kernel.org
Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 52377A31;
	Mon,  3 Feb 2025 06:53:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738565619; cv=none; b=BQutZOWNbI9WDkKo05gFCySiUP5NQRYSXdM6Hz2XhCeuXa2h3dvbKHgarZgm6bfL/DghAwnxyxrJ9D8n56GH6ceVQRQzsGoCUvIjcYIfwop1krCghpIVAi7DZ2DWiNPOuQLTy1qE+Ne7jKmZP3+73FctY5v4igyPZK0rvo1R2Vk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738565619; c=relaxed/simple;
	bh=wNHkO8AYBkpkeZDZHNXEfxSSONXKnyJtfYDwnwALPM8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=U0jVWDnnrKrK+mGsIxEenR/tnxKHUrscSrz53g5okWWJXk1Ef/mk7digpQxGYe0LUgDoHZGWrOugpyhvK9Mki6YW6YcgWXUAhWvrhGwZvMeclkgOM+CKLzrkA44OL5nYDLHfLexIANvTA8Qbnz/OKXkVxc6iyHK4srL7wmqo5uw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id 303E467373; Mon,  3 Feb 2025 07:53:32 +0100 (CET)
Date: Mon, 3 Feb 2025 07:53:31 +0100
From: Christoph Hellwig <hch@lst.de>
To: Anuj Gupta <anuj20.g@samsung.com>
Cc: axboe@kernel.dk, hch@lst.de, kbusch@kernel.org,
	martin.petersen@oracle.com, asml.silence@gmail.com,
	anuj1072538@gmail.com, brauner@kernel.org, jack@suse.cz,
	viro@zeniv.linux.org.uk, io-uring@vger.kernel.org,
	linux-nvme@lists.infradead.org, linux-block@vger.kernel.org,
	gost.dev@samsung.com, linux-scsi@vger.kernel.org,
	vishak.g@samsung.com, linux-fsdevel@vger.kernel.org,
	Kanchan Joshi <joshi.k@samsung.com>
Subject: Re: [PATCH v11 07/10] block: introduce
 BIP_CHECK_GUARD/REFTAG/APPTAG bip_flags
Message-ID: <20250203065331.GA16999@lst.de>
References: <20241128112240.8867-1-anuj20.g@samsung.com> <CGME20241128113112epcas5p186ef86baaa3054effb7244c54ee2f991@epcas5p1.samsung.com> <20241128112240.8867-8-anuj20.g@samsung.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20241128112240.8867-8-anuj20.g@samsung.com>
User-Agent: Mutt/1.5.17 (2007-11-01)

Hi Anuj,

I just stumbled over this patch when forward porting my XFS PI support
code over the weekend, which failed badly because it didn't set the
new BIP_CHECK_GUARD and BIP_CHECK_REFTAG flags.  Now for the XFS side
that was just me being to lazy to forward port, but when I started
looking over bio_integrity_add_page users as part of doing this I think
I found a regression caused by this patch.

The scsi and nvme targets never sets these new flags when passing on PI,
so that will probably stop working.  So we'll need to set them and for
nvmet we could also improve the code to actually pass through the
individual flags.  Note that this is just by observation, I didn't find
time to actually set up the SCSI and NVMe target code with PI support.
Maybe we also need blktests test cases to exercise the code and avoid
regressions in the future?


