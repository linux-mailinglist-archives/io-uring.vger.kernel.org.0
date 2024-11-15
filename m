Return-Path: <io-uring+bounces-4736-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 18F6C9CF37D
	for <lists+io-uring@lfdr.de>; Fri, 15 Nov 2024 19:00:50 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id D2E9E282A37
	for <lists+io-uring@lfdr.de>; Fri, 15 Nov 2024 18:00:48 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 03FD21DDC0B;
	Fri, 15 Nov 2024 18:00:28 +0000 (UTC)
X-Original-To: io-uring@vger.kernel.org
Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 936C31DD0E1;
	Fri, 15 Nov 2024 18:00:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731693627; cv=none; b=uoW/GVsd67AuFAoyoZBk6y8Vq+sJLvE/J70olUFwd8WLzVdYWNDQVn4j8SfV9b8HvsaQof3gNpKBBAFhR+RLfMm3xJdC0dBf3p/kZKJPgDPq/pFHzoSQvPalKY/GPtm1R/B+GxSkKslxVT+FfhM1rz1HF3NFkJ+WdkUdFKKiQGk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731693627; c=relaxed/simple;
	bh=uazAE8bf2Bb5VjrCBeKaaXMU6nVGFt9eXnX48hx/hwM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=YsEpHB8PE/fov0+Rvlqd+cidtQnkgUvZAm7mRryYBbJA/VwEAjUn1M3FBnY3p0LNXUEG9bV0BzqDnzJt/oTaY3UKi5IbcACHXhHEzYToqZpAOhzk+YeeLdeVjrJ2oyEx0T77CvR0nJitmlRlZTszZ12dM79hWytsoWErt0PRgx4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id 2B6C768D0A; Fri, 15 Nov 2024 19:00:21 +0100 (CET)
Date: Fri, 15 Nov 2024 19:00:20 +0100
From: Christoph Hellwig <hch@lst.de>
To: Jens Axboe <axboe@kernel.dk>
Cc: Christoph Hellwig <hch@lst.de>, Pavel Begunkov <asml.silence@gmail.com>,
	Anuj Gupta <anuj20.g@samsung.com>, kbusch@kernel.org,
	martin.petersen@oracle.com, anuj1072538@gmail.com,
	brauner@kernel.org, jack@suse.cz, viro@zeniv.linux.org.uk,
	io-uring@vger.kernel.org, linux-nvme@lists.infradead.org,
	linux-block@vger.kernel.org, gost.dev@samsung.com,
	linux-scsi@vger.kernel.org, vishak.g@samsung.com,
	linux-fsdevel@vger.kernel.org, Kanchan Joshi <joshi.k@samsung.com>
Subject: Re: [PATCH v9 06/11] io_uring: introduce attributes for read/write
 and PI support
Message-ID: <20241115180020.GA26128@lst.de>
References: <20241114104517.51726-1-anuj20.g@samsung.com> <CGME20241114105405epcas5p24ca2fb9017276ff8a50ef447638fd739@epcas5p2.samsung.com> <20241114104517.51726-7-anuj20.g@samsung.com> <20241114121632.GA3382@lst.de> <3fa101c9-1b38-426d-9d7c-8ed488035d4a@gmail.com> <20241114151921.GA28206@lst.de> <f945c1fc-2206-45fe-8e83-ebe332a84cb5@gmail.com> <20241115171205.GA23990@lst.de> <97b3061c-430d-4fc0-9b62-ab830010568e@kernel.dk>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <97b3061c-430d-4fc0-9b62-ab830010568e@kernel.dk>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Fri, Nov 15, 2024 at 10:44:58AM -0700, Jens Axboe wrote:
> Let's please lay off the hyperbole here, uring_cmd would be a terrible
> way to do this. We're working through the flags requirements. Obviously
> this is now missing 6.13, but there's no reason why it's not on track to
> make 6.14 in a saner way.

I don't think it would actually be all that terrible.  Still not my
preferred option of course.


