Return-Path: <io-uring+bounces-6322-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 0B3CFA2D4B1
	for <lists+io-uring@lfdr.de>; Sat,  8 Feb 2025 08:52:37 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 2FF5F188D68E
	for <lists+io-uring@lfdr.de>; Sat,  8 Feb 2025 07:52:42 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 02BB319F101;
	Sat,  8 Feb 2025 07:52:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Kna+Kcxw"
X-Original-To: io-uring@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3F7072556E
	for <io-uring@vger.kernel.org>; Sat,  8 Feb 2025 07:52:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739001152; cv=none; b=GMoIeMJRyRrQw0VsM6b7M6W/rykNJzCYpcTXHesL83nC6FZVXGY+P9Ors0wlQ/BIuFoKAucqljzXzCrFz99SIaSIhpdHNWl0jMsuYEfeVs5FVC9ujiaygCJbQ8GqKeJ8Mx6fH+GD6Ik/XbSavueClaRrQRWkxvVYMs+wBRGJhxk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739001152; c=relaxed/simple;
	bh=20PfcucZNzbzPZDZGpsvtn4jF11wpC3A4zVrh+iSQ20=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=h5X2s38pXsmJJmq0XDnNxC2ScwTMoJ4jwoJRdMg5v3hnt6tKxVOFEwiuv1aEjv9aX/17EMB16QD/Th0+noatBcGxQevukkcNd4kTpRRyrBkhLPW4+R0FzDKVOoYoaCWdOCGSdtYpGYrF/phNNmteS59MlhCZtVrFQFwAtccrd/w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=Kna+Kcxw; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1739001150;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=NMht2+kcxEROVmGO1bBAyHwfsiMpC34EL/UZ+0VmY6k=;
	b=Kna+KcxwoAs5kPIRLOsLfMjL+ZVflpmuRLya0Dw8pbaz3OkWardZHiiCNzDXewHR4014eJ
	4XjnGd/RWeUgMC9icl8Kw57/nSdIkfuG0deTrmEZTmYe/7Xkd37AX9s67jjHX7iUp/n9wF
	Mc8WrF8vt3Dsvgdx+02cncmGFDliBIw=
Received: from mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-531-336y_DZTP3mJ2NlKpAlAdQ-1; Sat,
 08 Feb 2025 02:52:26 -0500
X-MC-Unique: 336y_DZTP3mJ2NlKpAlAdQ-1
X-Mimecast-MFC-AGG-ID: 336y_DZTP3mJ2NlKpAlAdQ
Received: from mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.93])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 83ABC1800874;
	Sat,  8 Feb 2025 07:52:25 +0000 (UTC)
Received: from fedora (unknown [10.72.116.41])
	by mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 9FC651800115;
	Sat,  8 Feb 2025 07:52:20 +0000 (UTC)
Date: Sat, 8 Feb 2025 15:52:14 +0800
From: Ming Lei <ming.lei@redhat.com>
To: Keith Busch <kbusch@kernel.org>
Cc: Keith Busch <kbusch@meta.com>, io-uring@vger.kernel.org,
	linux-block@vger.kernel.org, axboe@kernel.dk,
	asml.silence@gmail.com
Subject: Re: [PATCH 0/6] ublk zero-copy support
Message-ID: <Z6cNLuVOyYZ8N-yU@fedora>
References: <20250203154517.937623-1-kbusch@meta.com>
 <Z6WDVdYxxQT4Trj8@fedora>
 <Z6YTfi29FcSQ1cSe@kbusch-mbp>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Z6YTfi29FcSQ1cSe@kbusch-mbp>
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.93

On Fri, Feb 07, 2025 at 07:06:54AM -0700, Keith Busch wrote:
> On Fri, Feb 07, 2025 at 11:51:49AM +0800, Ming Lei wrote:
> > On Mon, Feb 03, 2025 at 07:45:11AM -0800, Keith Busch wrote:

...

> > Does this interface support to read to partial buffer? Which is useful
> > for stacking device cases.
> 
> Are you wanting to read into this buffer without copying in parts? As in
> provide an offset and/or smaller length across multiple commands? If
> that's what you mean, then yes, you can do that here.

Sorry, forget another problem here.

For short read, we need to zero the remained bytes in each part of buffer,
how to deal with that?

Please see io_req_zero_remained() in my patch of "[PATCH V10 10/12] io_uring:
support leased group buffer with REQ_F_GROUP_BUF":

https://lore.kernel.org/linux-block/20241107110149.890530-11-ming.lei@redhat.com/#r



Thanks,
Ming


