Return-Path: <io-uring+bounces-3783-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 444309A2547
	for <lists+io-uring@lfdr.de>; Thu, 17 Oct 2024 16:39:50 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id C620DB26310
	for <lists+io-uring@lfdr.de>; Thu, 17 Oct 2024 14:39:47 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 81B591DE4DE;
	Thu, 17 Oct 2024 14:39:24 +0000 (UTC)
X-Original-To: io-uring@vger.kernel.org
Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A8B491DE4D7;
	Thu, 17 Oct 2024 14:39:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729175964; cv=none; b=N+GaUnTWUaaie5VQMbZOZ2uLlaSRS3djNMTep0YiVXo0kFzKwGZKpwRKMfMuPY28y1X0rnrRIQw/9uJfwYnq7TxY6IX4r0mlwHhfi5vnOhJuoHbVS9k5yxsdLh9RuP5+a4fcMX8/jyzCsK4QR4ur8axbw/1SlSw1CPe1uoMP/rI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729175964; c=relaxed/simple;
	bh=CuYz17cIJdcuLShxlbX3UoKc1gUQDy/HPYX63KQn8IA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=XCGlSau56hrhE/pvjjEjnSXp3KKAnNJapP1yDAbdEY1N8MKx1Lsr1/kfr65Kj1Xu2RKbCS2RPM66bN2u6eDbcfv6WRh0NlHCLBEvxeLN7GQoiOFS1FbG8Gsb+BlPOqOicTPsmnERJmxUnYUdsfEqCWmsuqB2DIWNJLIr9YD+YXk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id 9C6B5227A8E; Thu, 17 Oct 2024 16:39:18 +0200 (CEST)
Date: Thu, 17 Oct 2024 16:39:18 +0200
From: Christoph Hellwig <hch@lst.de>
To: Anuj Gupta <anuj20.g@samsung.com>
Cc: axboe@kernel.dk, hch@lst.de, kbusch@kernel.org,
	martin.petersen@oracle.com, asml.silence@gmail.com,
	anuj1072538@gmail.com, krisman@suse.de, io-uring@vger.kernel.org,
	linux-nvme@lists.infradead.org, linux-block@vger.kernel.org,
	gost.dev@samsung.com, linux-scsi@vger.kernel.org,
	vishak.g@samsung.com
Subject: Re: [PATCH v4 11/11] scsi: add support for user-meta interface
Message-ID: <20241017143918.GC21905@lst.de>
References: <20241016112912.63542-1-anuj20.g@samsung.com> <CGME20241016113757epcas5p42b95123c857e5d92d9cdec55e190ce4e@epcas5p4.samsung.com> <20241016112912.63542-12-anuj20.g@samsung.com> <20241017113923.GC1885@green245>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20241017113923.GC1885@green245>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Thu, Oct 17, 2024 at 05:09:23PM +0530, Anuj Gupta wrote:
> This snippet prevents a scenario where a apptag check is specified without
> a reftag check and vice-versa, which is not possible for scsi[1].
> But for
> block layer generated integrity apptag check (BIP_CHECK_APPTAG) is not
> specified. When scsi drive is formatted with type1/2 PI, block layer would
> specify refcheck but not appcheck. Hence, these I/O's would fail. Do you
> see how we can handle this?

Well, this is also related to difference in capability checking.

Just curious, do you have any user of the more fine grained checking
in NVMe?  If not we could support the SCSI semantics only and emulate
them using the fine grained NVMe semantics and have no portability
problems.


