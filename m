Return-Path: <io-uring+bounces-6854-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 6B3B0A49324
	for <lists+io-uring@lfdr.de>; Fri, 28 Feb 2025 09:15:49 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 146AB7A9F1B
	for <lists+io-uring@lfdr.de>; Fri, 28 Feb 2025 08:14:28 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0761D204845;
	Fri, 28 Feb 2025 08:15:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Jro7XiJ3"
X-Original-To: io-uring@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 756681FE44B
	for <io-uring@vger.kernel.org>; Fri, 28 Feb 2025 08:15:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740730517; cv=none; b=UN0UTiITcVp/3OQfqwFWccgN1H2KFFaQ7nkB0onq5yjMzUp6Y7/3qA94V/QuVFxl5qKfmFeIk48FU8JtgXuU4HprgxPznX3UjEEbHh0MoISC7X6/f1yJwsQ3tUWbIqXZm/2gRUgkHNTZjpMTrylCrqj5Fo5h7KyaNP9gUpIfUVw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740730517; c=relaxed/simple;
	bh=dLVxveumxeenUcUSHn3NT0dRVr6/tZoHTjuD3Vnu6fc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=dim01cmR3Lx0HBP2fUyi6ZSM7540k36ygKc1GTIDUzCh9i5EflKvFVdEb0QFBx2yvmX543HIxNZ/7AixOgkJlvFlfrsrpdGGvuXhoBwK879v4e0eezaN8dbO8isiV0uEMw/VBGQBzJ9aIBB7XpXL+QKKxaXoiDJ0j8db5+mu0Xc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=Jro7XiJ3; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1740730515;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=eRccp4VYUJ7iVLOPuYyafBpr1ah62bhkdlT4K+RL4I0=;
	b=Jro7XiJ3bGrXFRj765v99SjJn/tDh4tTdaOH/xkj3fgtVp8gz8ZDJbC+Psu3VpJbccn1T/
	8bp52/CmKddagUSJedw5RhXckzwWg5Fbpykjd8vIOAEceys59kspPRf5peN/fozwHONp+u
	wXrL+o4WozB+9krVoO8q3bYy26lHiZo=
Received: from mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-557-3m0H-eIGPiCjoB2yxgVL2w-1; Fri,
 28 Feb 2025 03:15:11 -0500
X-MC-Unique: 3m0H-eIGPiCjoB2yxgVL2w-1
X-Mimecast-MFC-AGG-ID: 3m0H-eIGPiCjoB2yxgVL2w_1740730510
Received: from mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.111])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 7A23D180087B;
	Fri, 28 Feb 2025 08:15:09 +0000 (UTC)
Received: from fedora (unknown [10.72.120.18])
	by mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 012F9180098C;
	Fri, 28 Feb 2025 08:15:03 +0000 (UTC)
Date: Fri, 28 Feb 2025 16:14:57 +0800
From: Ming Lei <ming.lei@redhat.com>
To: Keith Busch <kbusch@meta.com>
Cc: axboe@kernel.dk, asml.silence@gmail.com, linux-block@vger.kernel.org,
	io-uring@vger.kernel.org, linux-nvme@lists.infradead.org,
	csander@purestorage.com, Keith Busch <kbusch@kernel.org>
Subject: Re: [PATCHv8 5/6] ublk: zc register/unregister bvec
Message-ID: <Z8FwgbNtpu-bDZfR@fedora>
References: <20250227223916.143006-1-kbusch@meta.com>
 <20250227223916.143006-6-kbusch@meta.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250227223916.143006-6-kbusch@meta.com>
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.111

On Thu, Feb 27, 2025 at 02:39:15PM -0800, Keith Busch wrote:
> From: Keith Busch <kbusch@kernel.org>
> 
> Provide new operations for the user to request mapping an active request
> to an io uring instance's buf_table. The user has to provide the index
> it wants to install the buffer.
> 
> A reference count is taken on the request to ensure it can't be
> completed while it is active in a ring's buf_table.
> 
> Signed-off-by: Keith Busch <kbusch@kernel.org>

Reviewed-by: Ming Lei <ming.lei@redhat.com>

Thanks,
Ming


