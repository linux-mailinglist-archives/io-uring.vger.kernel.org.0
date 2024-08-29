Return-Path: <io-uring+bounces-2971-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 3B99D963933
	for <lists+io-uring@lfdr.de>; Thu, 29 Aug 2024 06:04:34 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id A5A4FB20D7C
	for <lists+io-uring@lfdr.de>; Thu, 29 Aug 2024 04:04:31 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 495132837F;
	Thu, 29 Aug 2024 04:04:27 +0000 (UTC)
X-Original-To: io-uring@vger.kernel.org
Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9F83C1870;
	Thu, 29 Aug 2024 04:04:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724904267; cv=none; b=SWHJ0Mnq4+cIuN9j2/AnZRE51SKhX49KoNtizjxXipvAuP9WTJkU/xZj/wPZxKlkIZ/IIR6h6PgFEjHgPiWHWa7xPpCta/dZU4oSpKk+02HJ9Bflc//Vi5YaZAOKH6imzHQgbyTeHQqXs+Sc9OR1iEVWg0+G3W8UXxat8Es0mrI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724904267; c=relaxed/simple;
	bh=+V+cwZCvafZYuugf6KiSaK31SNJRSwnBXfqZybnRO1g=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=pjo1S3oyUaEwwisGPl81kPmZfXWAGQzJ/PwKsms+Yt2Ffpou42KLaJwp0uuqtCrc8hFQqqo6xlEX0ebssrq4AMtePM1nRLD0iR2H+hC7njpNjUb3d0kNkwQ1KPPaZy4oMsthkkN5FEHHDqoH/5qyE8XJrAM+DQyb3paVyRfa/hM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id AAEF568AA6; Thu, 29 Aug 2024 06:04:21 +0200 (CEST)
Date: Thu, 29 Aug 2024 06:04:21 +0200
From: Christoph Hellwig <hch@lst.de>
To: Anuj Gupta <anuj20.g@samsung.com>
Cc: Christoph Hellwig <hch@lst.de>, axboe@kernel.dk, kbusch@kernel.org,
	martin.petersen@oracle.com, asml.silence@gmail.com, krisman@suse.de,
	io-uring@vger.kernel.org, linux-nvme@lists.infradead.org,
	linux-block@vger.kernel.org, gost.dev@samsung.com,
	linux-scsi@vger.kernel.org
Subject: Re: [PATCH v3 03/10] block: handle split correctly for user meta
 bounce buffer
Message-ID: <20240829040421.GA4211@lst.de>
References: <20240823103811.2421-1-anuj20.g@samsung.com> <CGME20240823104620epcas5p2118c152963d6cadfbc9968790ac0e536@epcas5p2.samsung.com> <20240823103811.2421-4-anuj20.g@samsung.com> <20240824083116.GC8805@lst.de> <20240828111806.GA3301@green245>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240828111806.GA3301@green245>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Wed, Aug 28, 2024 at 04:48:06PM +0530, Anuj Gupta wrote:
> I can add it [*], to iterate over the entire bvec array. But the original
> bio_iter still needs to be stored during submission, to calculate the
> number of bytes in the original integrity/metadata iter (as it could have
> gotten split, and I don't have original integrity iter stored anywhere).
> Do you have a different opinion?

Just like for the bio data, the original submitter should never use the
iter, but the _all iter. 


