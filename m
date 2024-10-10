Return-Path: <io-uring+bounces-3550-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 8E1949981DB
	for <lists+io-uring@lfdr.de>; Thu, 10 Oct 2024 11:18:06 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 2682A28406B
	for <lists+io-uring@lfdr.de>; Thu, 10 Oct 2024 09:18:05 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A2C1F1A0BDC;
	Thu, 10 Oct 2024 09:13:41 +0000 (UTC)
X-Original-To: io-uring@vger.kernel.org
Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ACA4F1A264C;
	Thu, 10 Oct 2024 09:13:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728551621; cv=none; b=SUiNbCauctpuwx+YuK0FNdLDDoX+aQAalpKF37cLt0fPSS5q6d/HQoLOiB+NBA0yYtVj5izd00Lr0lqFawvTe5ANBiF1D/EKwpTea52foyktI/8GTlYhjiNTpTKc/f6zluNJYvH6lqBnjmUk/MlOVryor6csZkakRgfHKOpipUw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728551621; c=relaxed/simple;
	bh=HEnrQ2rQUJyeEm5INxm+3Pp4mP/TzMmvJIThagsyB9w=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=dgWt6QjhPh2yD/DRm1u0hOt85Pti0Ixcp+5qwiayVqTTMQO2yioZ76FezkhGUvJi4vfOv1XD1uBzwjGNBh6GbP7Q75N9BEBmFIPSedxNGPUfygOXGzD7+mAU+fKC04B7mTBKoTzkg0FqjwuEMLrZzYekoFc5zpWZ8vOfbN0yhNo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id 370CF227A8E; Thu, 10 Oct 2024 11:13:34 +0200 (CEST)
Date: Thu, 10 Oct 2024 11:13:33 +0200
From: Christoph Hellwig <hch@lst.de>
To: Javier =?iso-8859-1?Q?Gonz=E1lez?= <javier.gonz@samsung.com>
Cc: Keith Busch <kbusch@kernel.org>, Christoph Hellwig <hch@lst.de>,
	Jens Axboe <axboe@kernel.dk>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Kanchan Joshi <joshi.k@samsung.com>, hare@suse.de, sagi@grimberg.me,
	brauner@kernel.org, viro@zeniv.linux.org.uk, jack@suse.cz,
	jaegeuk@kernel.org, bcrl@kvack.org, dhowells@redhat.com,
	bvanassche@acm.org, asml.silence@gmail.com,
	linux-nvme@lists.infradead.org, linux-fsdevel@vger.kernel.org,
	io-uring@vger.kernel.org, linux-block@vger.kernel.org,
	linux-aio@kvack.org, gost.dev@samsung.com, vishak.g@samsung.com
Subject: Re: [PATCH v7 0/3] FDP and per-io hints
Message-ID: <20241010091333.GB9287@lst.de>
References: <20241004062733.GB14876@lst.de> <20241004065233.oc5gqcq3lyaxzjhz@ArmHalley.local> <20241004123027.GA19168@lst.de> <20241007101011.boufh3tipewgvuao@ArmHalley.local> <20241008122535.GA29639@lst.de> <ZwVFTHMjrI4MaPtj@kbusch-mbp> <20241009092828.GA18118@lst.de> <Zwab8WDgdqwhadlE@kbusch-mbp> <CGME20241010070738eucas1p2057209e5f669f37ca586ad4a619289ed@eucas1p2.samsung.com> <20241010070736.de32zgad4qmfohhe@ArmHalley.local>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20241010070736.de32zgad4qmfohhe@ArmHalley.local>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Thu, Oct 10, 2024 at 09:07:36AM +0200, Javier González wrote:
> I think we should attempt to pursue that with an example in mind. Seems
> XFS is the clear candidate. You have done work already in enable SMR
> HDDs; it seems we can get FDP under that umbrella. This will however
> take time to get right. We can help with development, testing, and
> experimental evaluation on the WAF benefits for such an interface.

Or ZNS SSDs for that matter.

> However, this work should not block existing hardware enabling an
> existing use-case. The current patches are not intrusive. They do not
> make changse to the API and merely wire up what is there to the driver.
> Anyone using temperaturs will be able to use FDP - this is a win without
> a maintainance burden attached to it. The change to the FS / application
> API will not require major changes either; I believe we all agree that
> we cannot remove the temperatures, so all existing temperature users
> will be able to continue using them; we will just add an alternative for
> power users on the side.

As mentioned probably close to a dozen times over this thread and it's
predecessors:  Keeping the per-file I/O hint API and mapping that to
FDP is fine.  Exposing the overly-simplistic hints to the NVMe driver
through the entire I/O stack and locking us into that is not.

> So the proposal is to merge the patches as they are and commit to work
> together on a new, better API for in-kernel users (FS), and for
> applications (syscall, uring).

And because of that the whole merge it now and fix it later unfortunately
doesn't work, as a proper implementation will regress behavior for at
least some users that only have the I/O hints API but try to emulate
real stream separation with it.  With the per-I/O hints in io_uring that
is in fact almost guaranteed.


