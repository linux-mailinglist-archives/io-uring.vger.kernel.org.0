Return-Path: <io-uring+bounces-4190-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id CBCD39B5B16
	for <lists+io-uring@lfdr.de>; Wed, 30 Oct 2024 06:08:52 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 5E075B215D5
	for <lists+io-uring@lfdr.de>; Wed, 30 Oct 2024 05:08:50 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 08C6B1974FA;
	Wed, 30 Oct 2024 05:08:45 +0000 (UTC)
X-Original-To: io-uring@vger.kernel.org
Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D1734BA4A;
	Wed, 30 Oct 2024 05:08:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730264924; cv=none; b=m/3oDsjgYjv4rxzlfOryPbdUIOD7A6AFAplZRx7TS1iPxOU5xdR1a7mGMAM2ljJeqVt/NHY/03Mn/ptrOMDkk0TdU2dKv1LGaNzIg6o8gVBeVFpDvrvfIzT4uo5gm5YODo9v8n2ew1GqHKRLvIOd4fDrqjHLNcKyzD9/SzBu3Hc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730264924; c=relaxed/simple;
	bh=oTV+OApjCbgqpjKmh5o2hvIxR+1lcwYs8ftva5LkNTA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=C5opZx/4npi8z1AS3V4/Z1zaHZc7qZ7vJKkVRq/PCIUvBKlHWCWxcurHzXWoENkvEG+2XH51HI134DPJTnPOYEmIr8h3EVreuipM5RpP3tLJvbGOsvDGE2KGtvM/KoIBYOQxab8OO3Hc4l6f4AmO1JAeZ7aFF7+cnYXNUDldjsY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id D3BCE227A8E; Wed, 30 Oct 2024 06:08:38 +0100 (CET)
Date: Wed, 30 Oct 2024 06:08:38 +0100
From: Christoph Hellwig <hch@lst.de>
To: Kanchan Joshi <joshi.k@samsung.com>
Cc: Keith Busch <kbusch@kernel.org>, Anuj Gupta <anuj20.g@samsung.com>,
	axboe@kernel.dk, hch@lst.de, martin.petersen@oracle.com,
	asml.silence@gmail.com, anuj1072538@gmail.com, brauner@kernel.org,
	jack@suse.cz, viro@zeniv.linux.org.uk, io-uring@vger.kernel.org,
	linux-nvme@lists.infradead.org, linux-block@vger.kernel.org,
	gost.dev@samsung.com, linux-scsi@vger.kernel.org,
	vishak.g@samsung.com, linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH v5 06/10] io_uring/rw: add support to send metadata
 along with read/write
Message-ID: <20241030050838.GB32598@lst.de>
References: <20241029162402.21400-1-anuj20.g@samsung.com> <CGME20241029163225epcas5p24ec51c7a9b6b115757ed99cadcc3690c@epcas5p2.samsung.com> <20241029162402.21400-7-anuj20.g@samsung.com> <ZyFuxfiRqH8YB-46@kbusch-mbp.dhcp.thefacebook.com> <e7aae741-c139-48d1-bb22-dbcd69aa2f73@samsung.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <e7aae741-c139-48d1-bb22-dbcd69aa2f73@samsung.com>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Wed, Oct 30, 2024 at 10:35:19AM +0530, Kanchan Joshi wrote:
> if (sqe->meta_type)
> {
> 	if (type1(sqe->meta_type))
> 		process(type1);
> 	if (type2(sqe>meta_type))
> 		process(type1);
> }

Ensuring that all these are incompatible, which doesn't exactly scale.

So as is this weird meta_type thing (especially overloading the
meta name which is unfortuntely) feels actively harmful.

