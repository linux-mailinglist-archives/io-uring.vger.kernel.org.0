Return-Path: <io-uring+bounces-4769-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 1A5A49D10E7
	for <lists+io-uring@lfdr.de>; Mon, 18 Nov 2024 13:49:19 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 75C69B21561
	for <lists+io-uring@lfdr.de>; Mon, 18 Nov 2024 12:49:16 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BD2C814B07E;
	Mon, 18 Nov 2024 12:49:10 +0000 (UTC)
X-Original-To: io-uring@vger.kernel.org
Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C49A426AD0;
	Mon, 18 Nov 2024 12:49:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731934150; cv=none; b=WW5P7/FtkznqCsH3qWW4wXrNQ36tlgO37nHMixyFCt4sxF9tru/bp4IUngsrh4Tj/DbulWVfkNrXo7+iIkxGXhAwLA0cDWqrXqMeoxiWds+SkqxiEJFS3ELrvFbHtkryWakBibClTi+5WHFWTugNMAWvYrvEK0uw6ZM0M/Jk+Is=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731934150; c=relaxed/simple;
	bh=wHmkj8DXtelIvOhADAEWw/Bqiw8vgdqx0hOR8s9/pD0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=PV27rB+cYZGlQXPJEE1Kh8pyg/TzHWW0S8A2X6S7XB/IGHPegmN3AztwK1ndgqyuvNmC/go5DdBMLO7pqScsSas4ODMnAyFC2gV+lUQpIc3iF4jPpSXvvGrvb32dWA6UevOeuZHuixKd7UBtkbP0BUkeuOqdopvdOFGYI4J4Oz0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id 5F06568BFE; Mon, 18 Nov 2024 13:49:01 +0100 (CET)
Date: Mon, 18 Nov 2024 13:49:01 +0100
From: Christoph Hellwig <hch@lst.de>
To: Pavel Begunkov <asml.silence@gmail.com>
Cc: Christoph Hellwig <hch@lst.de>, Anuj Gupta <anuj20.g@samsung.com>,
	axboe@kernel.dk, kbusch@kernel.org, martin.petersen@oracle.com,
	anuj1072538@gmail.com, brauner@kernel.org, jack@suse.cz,
	viro@zeniv.linux.org.uk, io-uring@vger.kernel.org,
	linux-nvme@lists.infradead.org, linux-block@vger.kernel.org,
	gost.dev@samsung.com, linux-scsi@vger.kernel.org,
	vishak.g@samsung.com, linux-fsdevel@vger.kernel.org,
	Kanchan Joshi <joshi.k@samsung.com>
Subject: Re: [PATCH v9 06/11] io_uring: introduce attributes for read/write
 and PI support
Message-ID: <20241118124901.GA27505@lst.de>
References: <20241114104517.51726-1-anuj20.g@samsung.com> <CGME20241114105405epcas5p24ca2fb9017276ff8a50ef447638fd739@epcas5p2.samsung.com> <20241114104517.51726-7-anuj20.g@samsung.com> <20241114121632.GA3382@lst.de> <3fa101c9-1b38-426d-9d7c-8ed488035d4a@gmail.com> <20241114151921.GA28206@lst.de> <f945c1fc-2206-45fe-8e83-ebe332a84cb5@gmail.com> <20241115171205.GA23990@lst.de> <397bc8b7-b569-4726-984a-46054d6b5950@gmail.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <397bc8b7-b569-4726-984a-46054d6b5950@gmail.com>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Fri, Nov 15, 2024 at 07:03:28PM +0000, Pavel Begunkov wrote:
>>> but that shouldn't be PI specific.
>>
>> Why would anyone not use the SQE128 version?
>
> !SQE128 with user pointer can easily be faster depending on the
> ratio of requests that use SQE128 and don't. E.g. one PI read
> following with a 100 of send/recv on average. copy_from_user
> is not _that_ expensive and we're talking about zeroing an
> extra never used afterwards cache line.

Why would you use the same ring for it?  Remember PI is typically
used by thing like databases.  Everything that does disk I/O
will use it, so optimizing for it actually being used absolutely
makes sense.


