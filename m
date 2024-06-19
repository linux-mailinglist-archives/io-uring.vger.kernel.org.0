Return-Path: <io-uring+bounces-2269-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 592B290E51F
	for <lists+io-uring@lfdr.de>; Wed, 19 Jun 2024 10:02:39 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 6F5AF1C22D52
	for <lists+io-uring@lfdr.de>; Wed, 19 Jun 2024 08:02:38 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B9ECE6F317;
	Wed, 19 Jun 2024 08:02:34 +0000 (UTC)
X-Original-To: io-uring@vger.kernel.org
Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4E2C577F12;
	Wed, 19 Jun 2024 08:02:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718784154; cv=none; b=PQ56dboE36azl78PGDGg7jVVPnK/X1VDrNjleGcUtuEfnsB0or2YBzI5rz5bkrvmIOCgwO4HyVhqZpl0+JVZsWRg4gutjV1poG3A8iXvMGPwBeQrdKaxTDbfqoKwU5DdJ5AQAXpt4ONH+BtLsZPxwm0hl4HbSljaFIFOOWzmAE8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718784154; c=relaxed/simple;
	bh=z0SlEVjuMjft4IMkiONjhZcAyB+pz/y+jPbljyxtcyo=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=mCK19a6+dUqRcYcAbTEsqdldhcjmwjj53VOIrAdNZADs+mEdW6638aQ9rJ84oLW0SdNS5kVQ/V8Jl0r0/mwC+5RyoexoZiiERUkRCC4cLEAh7vqqk05kDKmkiju6evSZX1mzOMMvYxaoJzPcd7v6KtXgaCtZ0dzMswRF222bLNI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id B204868AFE; Wed, 19 Jun 2024 10:02:18 +0200 (CEST)
Date: Wed, 19 Jun 2024 10:02:18 +0200
From: Christoph Hellwig <hch@lst.de>
To: John Garry <john.g.garry@oracle.com>
Cc: Keith Busch <kbusch@kernel.org>, Christoph Hellwig <hch@lst.de>,
	axboe@kernel.dk, sagi@grimberg.me, jejb@linux.ibm.com,
	martin.petersen@oracle.com, viro@zeniv.linux.org.uk,
	brauner@kernel.org, dchinner@redhat.com, jack@suse.cz,
	djwong@kernel.org, linux-block@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-nvme@lists.infradead.org,
	linux-fsdevel@vger.kernel.org, tytso@mit.edu, jbongio@google.com,
	linux-scsi@vger.kernel.org, ojaswin@linux.ibm.com,
	linux-aio@kvack.org, linux-btrfs@vger.kernel.org,
	io-uring@vger.kernel.org, nilay@linux.ibm.com,
	ritesh.list@gmail.com, willy@infradead.org, agk@redhat.com,
	snitzer@kernel.org, mpatocka@redhat.com, dm-devel@lists.linux.dev,
	hare@suse.de, Himanshu Madhani <himanshu.madhani@oracle.com>
Subject: Re: [PATCH v8 05/10] block: Add core atomic write support
Message-ID: <20240619080218.GA4437@lst.de>
References: <20240610104329.3555488-1-john.g.garry@oracle.com> <20240610104329.3555488-6-john.g.garry@oracle.com> <ZnCGwYomCC9kKIBY@kbusch-mbp.dhcp.thefacebook.com> <20240618065112.GB29009@lst.de> <91e9bbe3-75cf-4874-9d64-0785f7ea21d9@oracle.com> <ZnHDCYiRA9EvuLTc@kbusch-mbp.dhcp.thefacebook.com> <24b58c63-95c9-43d4-a5cb-78754c94cbfb@oracle.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <24b58c63-95c9-43d4-a5cb-78754c94cbfb@oracle.com>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Wed, Jun 19, 2024 at 08:59:33AM +0100, John Garry wrote:
> In this case, I would expect NOIOB >= atomic write boundary.
>
> Would it be sane to have a NOIOB < atomic write boundary in some other 
> config?
>
> I can support these possibilities, but the code will just get more complex.

I'd be tempted to simply not support the case where NOIOB is not a
multiple of the atomic write boundary for now and disable atomic writes
with a big fat warning (and a good comment in the soure code).  If users
show up with a device that hits this and want to use atomic writes we
can resolved it.


