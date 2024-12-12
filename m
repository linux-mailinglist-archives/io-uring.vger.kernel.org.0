Return-Path: <io-uring+bounces-5456-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 41D969EDF30
	for <lists+io-uring@lfdr.de>; Thu, 12 Dec 2024 07:06:09 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 52E56188A731
	for <lists+io-uring@lfdr.de>; Thu, 12 Dec 2024 06:06:09 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5065317C230;
	Thu, 12 Dec 2024 06:06:05 +0000 (UTC)
X-Original-To: io-uring@vger.kernel.org
Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 72D085684;
	Thu, 12 Dec 2024 06:06:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733983565; cv=none; b=qPF4L8Wn5k0BplHB+Bq7T26lYjPtlFZMjvh/T3GPuckWE645RONoKWuPTARgWNaKRs9KOE3S/9SPCVPU5Tz6BhkhiWZW5p7+/BS2Tat/kmfOeu696XzLn98Q3YnrMDqMop5Q+8P4y98+5aqFgCwcAoKvs8L73ZI8piKl7yieq+Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733983565; c=relaxed/simple;
	bh=3jkI5C568UAqXbmo32SfC1VkTPOAYhBLOrjyNyBqdZA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ZVkMAI5S2KM0/eNImCc1/kCl4XUat8NXarGQ3gGHlCiAecjyyFW5G+5j8t1YO92lEyAnhzEyub5oghsSDuQsQu53jDh1sjlAJr2XUe0rE5XPIMdfyC+axKxJ0WOR4s5lQqllkT9uii0MX+nkdU8yLfN+z6yuuqM5ZnWfqWeOKvk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id BF4A268D07; Thu, 12 Dec 2024 07:05:58 +0100 (CET)
Date: Thu, 12 Dec 2024 07:05:58 +0100
From: Christoph Hellwig <hch@lst.de>
To: Kanchan Joshi <joshi.k@samsung.com>
Cc: Christoph Hellwig <hch@lst.de>, Keith Busch <kbusch@meta.com>,
	axboe@kernel.dk, linux-block@vger.kernel.org,
	linux-nvme@lists.infradead.org, linux-fsdevel@vger.kernel.org,
	io-uring@vger.kernel.org, sagi@grimberg.me, asml.silence@gmail.com,
	anuj20.g@samsung.com, Keith Busch <kbusch@kernel.org>
Subject: Re: [PATCHv13 00/11] block write streams with nvme fdp
Message-ID: <20241212060558.GA5266@lst.de>
References: <20241210194722.1905732-1-kbusch@meta.com> <CGME20241211071358epcas5p11c75e89d15c153ea3a41c82a5171d9de@epcas5p1.samsung.com> <20241211071350.GA14002@lst.de> <bd53dbed-f6a9-4322-88b5-460f8e9885a0@samsung.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <bd53dbed-f6a9-4322-88b5-460f8e9885a0@samsung.com>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Thu, Dec 12, 2024 at 11:21:07AM +0530, Kanchan Joshi wrote:
> On 12/11/2024 12:43 PM, Christoph Hellwig wrote:
> > The changes looks good to me.  I'll ty to send out an API for querying
> > the paramters in the next so that we don't merge the granularity as dead
> > code
> 
> What do you have in mind for this API. New fcntl or ioctl?
> With ability limited to querying only or....

Yes, new fcntl or ioctl, query the number of streams and (nominal)
stream granularity as a start.  There is a few other things that
might be useful:

 - check if the size is just nominal or not, aka if the device can
   shorten it.  FDP currently allows for that, but given that
   notifications for that are out of bounds it makes a complete mess
   of software actually trying to use it for more than simple hot/cold
   separation like cachelib, so we find a way to query that in the
   spec.
 - reporting of the remaining capacity per stream, although I'm not
   sure if that should be in the same ioctl/fcntl, or better done
   using a separate interface that has the stream number as input
   and the capacity as out, which would seem a lot simpler

