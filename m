Return-Path: <io-uring+bounces-4624-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id F3D149C5A4D
	for <lists+io-uring@lfdr.de>; Tue, 12 Nov 2024 15:30:12 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id ABC9428112B
	for <lists+io-uring@lfdr.de>; Tue, 12 Nov 2024 14:30:11 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D7CD81FF5F8;
	Tue, 12 Nov 2024 14:25:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ePHLU2/h"
X-Original-To: io-uring@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A77901FEFD1;
	Tue, 12 Nov 2024 14:25:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731421549; cv=none; b=CYRQvBEVzMAIfAZcljuCUeotflOQplXWh+kNpwvfVB9midSTlfQ1HrKUWKh5JKcoykt9MKf666BsiByv+IkE3PA3BMlyFz1PMV9QfOUDsHv8ima3WZxuBs4Zgh1Ejoare1dL3UVaEGIArFFyTRjsZ/7MPEShdb2EoOtiFLlBqU0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731421549; c=relaxed/simple;
	bh=FqK6AvBbok3agYaXcwWnCFMmVIqq7T/f8WTFeYDo4R8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=pAawZicFCVQXj8rIgLRzwIfHAUyJ74mdomKRw7rz2nRSZQfs/NYPw1YyLZhh3OQQjUsyMQIxx2ji8a9GMtr15/cpzseBAQlpSlhpCHvY66pmEKUgheWKZzRoqL1n3mkH73gWLX+LFMl8mdia0CdmKsgovljYKgrq1RClHH0qdp4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ePHLU2/h; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 58F4AC4CECD;
	Tue, 12 Nov 2024 14:25:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1731421549;
	bh=FqK6AvBbok3agYaXcwWnCFMmVIqq7T/f8WTFeYDo4R8=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=ePHLU2/hD6U7PnMMH7nbItnFIAQtapvtYXrLfgEyRh4w1ARIGASKPWGmKV1vKvybR
	 1EKZvr1QfDBPgUlscNmxhahhmpFrR3vrFkx6aHUnAlH8kwxALSJmqUYcE+nu8SOmbI
	 0iG1helEUWOdLRfC5PTBSCRxJyBvCiTLDIMgCSMjafxj4k9HZkfNZsC0Vv3ljeJ9bB
	 WnjjK5n7Lf5wK1OKCGlRUM3O72GrzsH/kTenZhQlJRdHDLPKxdHKLVsR8CdDgENc8k
	 1C8WcFReORB9mUGjtybP4t6kITOXEr2pwCHcyHlb11/JfLm4+za1LevRJd/DT/tMpN
	 1I5gvWqlJLpBg==
Date: Tue, 12 Nov 2024 07:25:45 -0700
From: Keith Busch <kbusch@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: Kanchan Joshi <joshi.k@samsung.com>, Keith Busch <kbusch@meta.com>,
	linux-block@vger.kernel.org, linux-nvme@lists.infradead.org,
	linux-scsi@vger.kernel.org, linux-fsdevel@vger.kernel.org,
	io-uring@vger.kernel.org, axboe@kernel.dk,
	martin.petersen@oracle.com, asml.silence@gmail.com,
	javier.gonz@samsung.com
Subject: Re: [PATCHv11 0/9] write hints with nvme fdp and scsi streams
Message-ID: <ZzNlaXZTn3Pjiofn@kbusch-mbp.dhcp.thefacebook.com>
References: <20241108193629.3817619-1-kbusch@meta.com>
 <CGME20241111103051epcas5p341a23ed677f2dfd6bc6d4e5c4826327b@epcas5p3.samsung.com>
 <20241111102914.GA27870@lst.de>
 <7a2f6231-bb35-4438-ba50-3f9c4cc9789a@samsung.com>
 <20241112133439.GA4164@lst.de>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20241112133439.GA4164@lst.de>

On Tue, Nov 12, 2024 at 02:34:39PM +0100, Christoph Hellwig wrote:
> On Tue, Nov 12, 2024 at 06:56:25PM +0530, Kanchan Joshi wrote:
> > IMO, passthrough propagation of hints/streams should continue to remain 
> > the default behavior as it applies on multiple filesystems. And more 
> > active placement by FS should rather be enabled by some opt in (e.g., 
> > mount option). Such opt in will anyway be needed for other reasons (like 
> > regression avoidance on a broken device).
> 
> I feel like banging my head against the wall.  No, passing through write
> streams is simply not acceptable without the file system being in
> control.  I've said and explained this in detail about a dozend times
> and the file system actually needing to do data separation for it's own
> purpose doesn't go away by ignoring it.

But that's just an ideological decision that doesn't jive with how
people use these. The applications know how they use their data better
than the filesystem, so putting the filesystem in the way to force
streams look like zones is just a unnecessary layer of indirection
getting in the way.

