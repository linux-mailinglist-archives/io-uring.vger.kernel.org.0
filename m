Return-Path: <io-uring+bounces-3372-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 1DDAC98CE25
	for <lists+io-uring@lfdr.de>; Wed,  2 Oct 2024 09:52:23 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id C4A5F1F23936
	for <lists+io-uring@lfdr.de>; Wed,  2 Oct 2024 07:52:22 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CA3911946B4;
	Wed,  2 Oct 2024 07:51:49 +0000 (UTC)
X-Original-To: io-uring@vger.kernel.org
Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F12E71946BA;
	Wed,  2 Oct 2024 07:51:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727855509; cv=none; b=Q2U4gv5m7K8QSQrOugV2GbxJkGe42UyQn6VCrwuL+HqakiOImzsKpf1X/Ljv9CTaNq2Ig5pvhnzsrIgMluPllcmPpi5tk8nlAdrwIdQbw0SzvDZ4+hM1RpNxfrFqkPfcR39P01le7fFPJMmMujtESiOzGQJtbOCUuo49+vQcnp0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727855509; c=relaxed/simple;
	bh=HxSk9oqW3t8yQSTSf9S7aoHATSpgBnRzHKVDRJw1aZQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=XYVk+Jx1lVw9Bg0wjw8o8gH5FZwxtzkF6EdjV8enG3SkDfhcXB3Y/omkw9JftGrSkbdlgaKRWIzFXE0A5tBgSb3KPzg6r+aEX1kN7SUJdH+rrZ8rxIMRQB6RDsSU8Tw64uU3gMCV9ngn8Y0k4N7GUoEVx4NX3Kpo9T/CfQ1fVbM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id 0633D227A8E; Wed,  2 Oct 2024 09:51:41 +0200 (CEST)
Date: Wed, 2 Oct 2024 09:51:40 +0200
From: Christoph Hellwig <hch@lst.de>
To: Jens Axboe <axboe@kernel.dk>
Cc: Christoph Hellwig <hch@lst.de>, Kanchan Joshi <joshi.k@samsung.com>,
	kbusch@kernel.org, hare@suse.de, sagi@grimberg.me,
	martin.petersen@oracle.com, brauner@kernel.org,
	viro@zeniv.linux.org.uk, jack@suse.cz, jaegeuk@kernel.org,
	bcrl@kvack.org, dhowells@redhat.com, bvanassche@acm.org,
	asml.silence@gmail.com, linux-nvme@lists.infradead.org,
	linux-fsdevel@vger.kernel.org, io-uring@vger.kernel.org,
	linux-block@vger.kernel.org, linux-aio@kvack.org,
	gost.dev@samsung.com, vishak.g@samsung.com, javier.gonz@samsung.com
Subject: Re: [PATCH v7 0/3] FDP and per-io hints
Message-ID: <20241002075140.GB20819@lst.de>
References: <CGME20240930182052epcas5p37edefa7556b87c3fbb543275756ac736@epcas5p3.samsung.com> <20240930181305.17286-1-joshi.k@samsung.com> <20241001092047.GA23730@lst.de> <99c95f26-d6fb-4354-822d-eac94fdba765@kernel.dk>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <99c95f26-d6fb-4354-822d-eac94fdba765@kernel.dk>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Tue, Oct 01, 2024 at 10:18:41AM -0600, Jens Axboe wrote:
> Have to say, that neither have your responses been. Can't really fault
> people for just giving up at some point, when no productive end seems to
> be in sight.

I heavily disagree and take offence on that.

The previous stream separation approach made total sense, but just
needed a fair amount of work.  But it closely matches how things work
at the hardware and file system level, so it was the right approach.

Suddenly dropping that and ignoring all comments really feels like
someone urgently needs to pull a marketing stunt here.


