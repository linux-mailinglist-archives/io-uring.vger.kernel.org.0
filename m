Return-Path: <io-uring+bounces-3649-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id DC12699C1E5
	for <lists+io-uring@lfdr.de>; Mon, 14 Oct 2024 09:47:31 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 927351F2100E
	for <lists+io-uring@lfdr.de>; Mon, 14 Oct 2024 07:47:31 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 276E914B06E;
	Mon, 14 Oct 2024 07:47:16 +0000 (UTC)
X-Original-To: io-uring@vger.kernel.org
Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8A153148FF3;
	Mon, 14 Oct 2024 07:47:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728892036; cv=none; b=gDT2tRYB2laYzoTTMc8XDp+/3ZTREjEeOuJoVODZj6qHypRCjXjFSJVvKKYvAMPEloLm2oYW+Rg1wiV+1Wl5WBJcEpDML6yxwyF00a0MKeQ7qUfGyoN789W16JcaQJ5l7E6GtZKqhwmiW0M3Jg3TtZzv5PilzfYxoMGovzxOERI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728892036; c=relaxed/simple;
	bh=q17jQYSUK8XLyqlZ1suQaunB3N245lax5WY2ykVkc3Y=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Xa3Eq4Kkmu+OJ9gzP8h16HGvJbTP0SM6Jxp6Sz6MMVl7sCSbykz6H6rU72Ml+1YZkSdjp8voo0/+g7bs2J2zQbx1SEu01w6cngqUTktwdY1hJYZ9siDQE35XmDwP9QuWN53pZZN1/+fNdrDjgy9x0jK2bDMSzT22M4Km7b/kLDU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id 14511227AAC; Mon, 14 Oct 2024 09:47:09 +0200 (CEST)
Date: Mon, 14 Oct 2024 09:47:08 +0200
From: Christoph Hellwig <hch@lst.de>
To: Javier Gonzalez <javier.gonz@samsung.com>
Cc: Christoph Hellwig <hch@lst.de>, Jens Axboe <axboe@kernel.dk>,
	Keith Busch <kbusch@kernel.org>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Kanchan Joshi <joshi.k@samsung.com>, "hare@suse.de" <hare@suse.de>,
	"sagi@grimberg.me" <sagi@grimberg.me>,
	"brauner@kernel.org" <brauner@kernel.org>,
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
Message-ID: <20241014074708.GA22575@lst.de>
References: <20241009092828.GA18118@lst.de> <Zwab8WDgdqwhadlE@kbusch-mbp> <CGME20241010070738eucas1p2057209e5f669f37ca586ad4a619289ed@eucas1p2.samsung.com> <20241010070736.de32zgad4qmfohhe@ArmHalley.local> <20241010091333.GB9287@lst.de> <20241010115914.eokdnq2cmcvwoeis@ArmHalley.local> <20241011090224.GC4039@lst.de> <5e9f7f1c-48fd-477f-b4ba-c94e6b50b56f@kernel.dk> <20241014062125.GA21033@lst.de> <34d3ad68068f4f87bf0a61ea8fb8f217@CAMSVWEXC02.scsc.local>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <34d3ad68068f4f87bf0a61ea8fb8f217@CAMSVWEXC02.scsc.local>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Mon, Oct 14, 2024 at 07:02:11AM +0000, Javier Gonzalez wrote:
> > And exactly that is the problem.  For file systems we can't support
> > that sanely.  So IFF you absolutely want the per-I/O hints we need
> > an opt in by the file operations.  I've said that at least twice
> > in this discussion before, but as everyone likes to have political
> > discussions instead of technical ones no one replied to that.
> 
> Is it a way forward to add this in a new spin of the series - keeping the 
> temperature mapping on the NVMe side?

What do you gain from that?  NVMe does not understand data temperatures,
so why make up that claim?  Especially as it directly undermindes any
file system work to actually make use of it.

> If not, what would be acceptable for a first version, before getting into adding
> a new interface to expose agnostic hints?

Just iterate on Kanchan's series for a block layer (and possible user level,
but that's less urgent) interface for stream separation?

