Return-Path: <io-uring+bounces-4629-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 5166E9C6101
	for <lists+io-uring@lfdr.de>; Tue, 12 Nov 2024 20:05:20 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 47C23B38F83
	for <lists+io-uring@lfdr.de>; Tue, 12 Nov 2024 17:20:54 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A4AED207A00;
	Tue, 12 Nov 2024 17:19:22 +0000 (UTC)
X-Original-To: io-uring@vger.kernel.org
Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3558720EA32;
	Tue, 12 Nov 2024 17:19:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731431962; cv=none; b=AuJVgwo1YtlT8ixcSC7LvUEt1o61uBLgQSH/Aj2yEdWqV037C6qhsqD73UlT4mH3iIPRAHJKiXx2MBCI4uMu4WZsvHiCMlpy/6r+fCXd1ZfFEuOiQvDSJ+ekxJjyUIWKDI1H3GEcovK29EpXbHTmHHt4JqH2noHlZTZGZQlOI5k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731431962; c=relaxed/simple;
	bh=wQQ61YDQr0Kb5ytutidKepCCkqMHsv+oPhw+KzqWNpc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=NILGBSWJpEePiiHXg3pLZezR/MBVO+DFer0hSoYaXxasG+TcYzlMiwQ9gf7xXaS/WdKBAhaQnug2yMi8uJqXQJWl3iJxtieZMryUtIdvKxeUdxX04eIpkihVaxVOa4NUxH5V2AnzApQ+ycrnxukivRyxGnZuy342Y0qPBfKCx58=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id 8065268AFE; Tue, 12 Nov 2024 18:19:15 +0100 (CET)
Date: Tue, 12 Nov 2024 18:19:14 +0100
From: Christoph Hellwig <hch@lst.de>
To: Keith Busch <kbusch@kernel.org>
Cc: Christoph Hellwig <hch@lst.de>, Kanchan Joshi <joshi.k@samsung.com>,
	Keith Busch <kbusch@meta.com>, linux-block@vger.kernel.org,
	linux-nvme@lists.infradead.org, linux-scsi@vger.kernel.org,
	linux-fsdevel@vger.kernel.org, io-uring@vger.kernel.org,
	axboe@kernel.dk, martin.petersen@oracle.com, asml.silence@gmail.com,
	javier.gonz@samsung.com
Subject: Re: [PATCHv11 0/9] write hints with nvme fdp and scsi streams
Message-ID: <20241112171914.GA21822@lst.de>
References: <20241108193629.3817619-1-kbusch@meta.com> <CGME20241111103051epcas5p341a23ed677f2dfd6bc6d4e5c4826327b@epcas5p3.samsung.com> <20241111102914.GA27870@lst.de> <7a2f6231-bb35-4438-ba50-3f9c4cc9789a@samsung.com> <20241112133439.GA4164@lst.de> <ZzNlaXZTn3Pjiofn@kbusch-mbp.dhcp.thefacebook.com> <20241112165054.GA19355@lst.de>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20241112165054.GA19355@lst.de>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Tue, Nov 12, 2024 at 05:50:54PM +0100, Christoph Hellwig wrote:
> > so putting the filesystem in the way to force
> > streams look like zones is just a unnecessary layer of indirection
> > getting in the way.
> 
> Can you please stop this BS?  Even if a file system doesn't treat
> write streams like zones keeps LBA space and physical allocation units
> entirely separate (for which I see no good reason, but others might
> disagree) you still need the file system in control of the hardware
> resources.

And in case this wasn't clear enough.  Let's assume you want to write
a low write amp flash optimized file system similar to say the storage
layers of the all flash arrays of the last 10-15 years.

You really want to avoid device GC.  You'd better group your data to
the reclaim unit / erase block / insert name here.  So you need file
system control of the write streams, you need to know their size,
you need to be able to query how much your wrote after a power faіl.
Totally independent of how you organize your LBA space.  Mapping
it linearly might be the easier options without major downside, but
you could also allocate them randomly for that matter.

> 
---end quoted text---

