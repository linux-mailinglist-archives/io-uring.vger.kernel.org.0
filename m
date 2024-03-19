Return-Path: <io-uring+bounces-1133-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 23FFC87F521
	for <lists+io-uring@lfdr.de>; Tue, 19 Mar 2024 02:42:58 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 8514A282380
	for <lists+io-uring@lfdr.de>; Tue, 19 Mar 2024 01:42:56 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 39087612F6;
	Tue, 19 Mar 2024 01:42:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="XmawsWtU"
X-Original-To: io-uring@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9C55A2F22
	for <io-uring@vger.kernel.org>; Tue, 19 Mar 2024 01:42:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710812564; cv=none; b=bw0DVFDqR4NmNAQqFRNbws0lQTGNFA9/ePzD2j14gTO79BH6yVAm6BpfUwSL8gfFARvMWUdjwal0RQIbwM3fmbmj2PCgp5JS5yzZIukPqwgE6pz0FEzYFCKcO2fESW/Qk2WG8rZw6cuo15RzNtbjvybgcfsGYmngdCNHca48UWE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710812564; c=relaxed/simple;
	bh=xsccCYRBTxi+L3b5gS1kmw03qUdGeBWnLSPXHNmALBU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=GsSsDmuDoUHUUvLd8IYr1MMOGME8FSqWa8YzFAlQnSdkRpsloSOmICiMt5F/h+7RjhSF8mYELwfkVgzixWPKRsZf8eqPATIqAK4JJo19uOmVfs9IkibhCLBGMzWFl26mUfkhlKtpmJI04Byc2dalyU2peq3R/EEWEpit27cLZX0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=XmawsWtU; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1710812561;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=R5aJQW0eAXgLvqMmyvs8gwyLF6UUG5gyvsg1YOINB3s=;
	b=XmawsWtUL13PHgJJuVgyLJmgilziGvg2wphclQtNeOq5hGOZfM2R2rBrVzhrHHFDgwapCP
	XVA8roW9hr+CbUPE3TfZi5qWgr6KjGFmXOjRXF/dldeK5LYCOMSTGipC+FjDGP1HWYv2qg
	WveXo4u2EDSYx9Sz2Cat6uW0xPgImI8=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-80-WZ7bafERPYOb_DZTnbx9uw-1; Mon, 18 Mar 2024 21:42:39 -0400
X-MC-Unique: WZ7bafERPYOb_DZTnbx9uw-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com [10.11.54.3])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id E465184B163;
	Tue, 19 Mar 2024 01:42:38 +0000 (UTC)
Received: from fedora (unknown [10.72.116.95])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id D196C1121306;
	Tue, 19 Mar 2024 01:42:35 +0000 (UTC)
Date: Tue, 19 Mar 2024 09:42:26 +0800
From: Ming Lei <ming.lei@redhat.com>
To: Pavel Begunkov <asml.silence@gmail.com>
Cc: io-uring@vger.kernel.org, linux-block@vger.kernel.org,
	Jens Axboe <axboe@kernel.dk>, Kanchan Joshi <joshi.k@samsung.com>
Subject: Re: [PATCH v3 00/13] Remove aux CQE caches
Message-ID: <ZfjtgmBuNFmznj9O@fedora>
References: <cover.1710799188.git.asml.silence@gmail.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cover.1710799188.git.asml.silence@gmail.com>
X-Scanned-By: MIMEDefang 3.4.1 on 10.11.54.3

On Mon, Mar 18, 2024 at 10:00:22PM +0000, Pavel Begunkov wrote:
> Mandate ctx locking for task_work. Then, remove aux CQE caches mostly
> used by multishot requests and post them directly into the CQ.
> 
> It's leaving some of the pre existing issue_flags and state conversion
> non conformant chunks, which will need to clean up later.
> 
> v3: pass IO_URING_F_COMPLETE_DEFER to the cmd cancellation path
>     drop patch moving request cancellation list removal to tw 
>     drop all other ublk changes

For the series, pass ublksrv test.

Tested-by: Ming Lei <ming.lei@redhat.com>


Thanks,
Ming


