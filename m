Return-Path: <io-uring+bounces-3377-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id BA2E298DEB2
	for <lists+io-uring@lfdr.de>; Wed,  2 Oct 2024 17:17:52 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 2EAC3B2BF6A
	for <lists+io-uring@lfdr.de>; Wed,  2 Oct 2024 15:14:58 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 189231D0B97;
	Wed,  2 Oct 2024 15:14:00 +0000 (UTC)
X-Original-To: io-uring@vger.kernel.org
Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 83D101D0BBE;
	Wed,  2 Oct 2024 15:13:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727882040; cv=none; b=HRMXEW1eNF6W1q0XU6+HmDeSEXATW+p53cuVR+t74wBt25E8K8eDO9E9t1nTgfoqH3IjzhhibXYGZIJ6YDC2YQckqUrBr4fFaxsbG4Z4xWL4tQWEA7YtN0vKnyH5qtwC7BeWoePvN/pZfFbG/AvqgAUkYL7kD1T5XqAT17Q5QbY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727882040; c=relaxed/simple;
	bh=whVvvacyysEOjUYvVSNXCF2AXIsxHb9DQEhAh4XDOpc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ryyO7F2wOl0j00NjHk5dCwyji8BbieeVzRr5YoVC9VremD8p7W4RpKc+2EhCsc5xfFWd3B5V8V1PPaeBMBvd3FWf+8z32WNjaQO4WyAeU/3gMkWwYBj4GT7KI3P+7P7Mh/YSnHzqp7l9kmgGuRiiiqO2QpIZupP7Y4qSdyQp6/4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id C558B227AB1; Wed,  2 Oct 2024 17:13:44 +0200 (CEST)
Date: Wed, 2 Oct 2024 17:13:44 +0200
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
Message-ID: <20241002151344.GA20364@lst.de>
References: <CGME20240930182052epcas5p37edefa7556b87c3fbb543275756ac736@epcas5p3.samsung.com> <20240930181305.17286-1-joshi.k@samsung.com> <20241001092047.GA23730@lst.de> <99c95f26-d6fb-4354-822d-eac94fdba765@kernel.dk> <20241002075140.GB20819@lst.de> <f14a246b-10bf-40c1-bf8f-19101194a6dc@kernel.dk>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <f14a246b-10bf-40c1-bf8f-19101194a6dc@kernel.dk>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Wed, Oct 02, 2024 at 09:03:22AM -0600, Jens Axboe wrote:
> > The previous stream separation approach made total sense, but just
> > needed a fair amount of work.  But it closely matches how things work
> > at the hardware and file system level, so it was the right approach.
> 
> What am I missing that makes this effort that different from streams?
> Both are a lifetime hint.

A stream has a lot less strings attached.  But hey, don't make me
argue for streams - you pushed the API in despite reservations back
then, and we've learned a lot since.

> > Suddenly dropping that and ignoring all comments really feels like
> > someone urgently needs to pull a marketing stunt here.
> 
> I think someone is just trying to finally get this feature in, so it
> can get used by customers, after many months of fairly unproductive
> discussion.

Well, he finally started on the right approach and gave it up after the
first round of feedback.  That's just a bit weird.


