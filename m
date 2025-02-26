Return-Path: <io-uring+bounces-6775-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 505C8A457ED
	for <lists+io-uring@lfdr.de>; Wed, 26 Feb 2025 09:16:09 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 5C3D67A624F
	for <lists+io-uring@lfdr.de>; Wed, 26 Feb 2025 08:15:09 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B4B3E258CEC;
	Wed, 26 Feb 2025 08:16:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="dSH5giKN"
X-Original-To: io-uring@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 34F862AE9A
	for <io-uring@vger.kernel.org>; Wed, 26 Feb 2025 08:16:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740557762; cv=none; b=FZPxq0UIj67DjXqCLRuyax9Ek3iiX4JaBQWRyBUtCsDhr8NIxbubD1CowGGgYTSR8X4ndxO4uESfbOOk5lNQ9Ff/EM/Snkunyjr537l1xVJnz0cf4kKgCNMWZELu71y3F+bBOx7VzpNKTiDbQrGek/0InRCKk/L4/L1QOl52feg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740557762; c=relaxed/simple;
	bh=nALpxznmBhzULFmfDkpB8aWVcJCEE83NjjXYdSRCF6Q=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=E/9BHUE85ygCIJBbmHDz9nNwTZsiYVo0zdWCFXCWTNzD0fwwV10/SDI7vnMDiTeEILJIMaxvRhMprUACJlWyn7HemDOi4Wr+vP4AUxc7zxPwRlSboON3uKAT1tiGrvYA42/x3kVdeMg8pcb4crGqHfIu53P1wxwMWPZUYadHsKs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=dSH5giKN; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1740557760;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=IkUcDBu8Qo7NTXBR3iH6KjBpPvAxntcf8hHlhE3zaYc=;
	b=dSH5giKNFw+S/pF+G0pWnaRAq1HolnXDuwN1x7Fr1pInmZsMsK99CXBdgq1fW6qX6ipV8W
	0kXw7vf7rW7ImGMLpWXSyzLDIDsBUCxKg1i27rQyYfRsceQX7SwIKqDHdwNwXsFWWtHzHP
	FRTiB1k9YsGlKxeG6SttHXi+NBZkI10=
Received: from mx-prod-mc-04.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-313-lMLmeSYlPcSKOrHiRuniNw-1; Wed,
 26 Feb 2025 03:15:53 -0500
X-MC-Unique: lMLmeSYlPcSKOrHiRuniNw-1
X-Mimecast-MFC-AGG-ID: lMLmeSYlPcSKOrHiRuniNw_1740557752
Received: from mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.93])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-04.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 7455219039C2;
	Wed, 26 Feb 2025 08:15:52 +0000 (UTC)
Received: from fedora (unknown [10.72.120.27])
	by mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 3F7FA1800359;
	Wed, 26 Feb 2025 08:15:45 +0000 (UTC)
Date: Wed, 26 Feb 2025 16:15:39 +0800
From: Ming Lei <ming.lei@redhat.com>
To: Keith Busch <kbusch@meta.com>
Cc: asml.silence@gmail.com, axboe@kernel.dk, linux-block@vger.kernel.org,
	io-uring@vger.kernel.org, bernd@bsbernd.com,
	csander@purestorage.com, Keith Busch <kbusch@kernel.org>
Subject: Re: [PATCHv5 09/11] ublk: zc register/unregister bvec
Message-ID: <Z77Nq_5ZGxUjxkau@fedora>
References: <20250224213116.3509093-1-kbusch@meta.com>
 <20250224213116.3509093-10-kbusch@meta.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250224213116.3509093-10-kbusch@meta.com>
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.93

On Mon, Feb 24, 2025 at 01:31:14PM -0800, Keith Busch wrote:
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
> ---

Looks IO_LINK doesn't work, and UNREG_BUF cqe can be received from userspace.

It is triggered reliably in the ublk selftests(test_loop_03.sh) I just post out:

https://lore.kernel.org/linux-block/20250226081136.2410001-4-ming.lei@redhat.com/T/#m3adfecbfa33de9f9f728ccb4ab1185091be34797


Thanks,
Ming


