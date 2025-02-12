Return-Path: <io-uring+bounces-6350-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 2DE89A31C12
	for <lists+io-uring@lfdr.de>; Wed, 12 Feb 2025 03:30:10 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id C59443A8326
	for <lists+io-uring@lfdr.de>; Wed, 12 Feb 2025 02:30:00 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5193C1D5CC5;
	Wed, 12 Feb 2025 02:29:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Tb5Zs6Yl"
X-Original-To: io-uring@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A65181CDA3F
	for <io-uring@vger.kernel.org>; Wed, 12 Feb 2025 02:29:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739327393; cv=none; b=loykp4KXnV9iQjl4z+jSBGLF4EzARAGwC2Wnemk3r7gHkR0eZJcnHLrUUAa9c/7hATponcGTXEfFC4NW2RQuo+T5uCFMsm4AUF58hXOvBVVlW8WVLrmPB74apbY3lrgXMM2Djh0R3hys9rRC0WMAJkc/4gq184TyCykhx2PT93I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739327393; c=relaxed/simple;
	bh=2IgyZ0g7V2m88LSvM3T3N2W+3GlHleRe3LMJAhSFzg4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=LwfdIt7YxjGBV1+JqCMkP40FlYqGZlfk5RUKoG+q4YRvr05UgTt7+6ddpJ0gpgOMvX5EFFiI7km9VI2b9NlI+8pWZDLLRBSIdcd+URWkCJDsbtRYEIiHqzl66I+D+dKSoxkz5Nsvvtbk2agcs6+uJu+nxjcsv20USx0u4Fqv2a8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=Tb5Zs6Yl; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1739327390;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=X39yARt4BW8kEibKLCcAsrQXU54adKPNw9W/thdQxrY=;
	b=Tb5Zs6Yl9bM+szhBKU3xoMMmwagw+EDUc89rkNZHt4o47iYrZQ+wk98zwVw6qnw7N9s8ev
	zxr2c2GYZmPkFW4+i54cGIzJ/spQYnWvnJipwzG9Xqjtd+fGzqnAsJXJ2K1lTUCHVO4xO0
	G6YxzQH+41WXTWKVN3huWARN1ZQNWc8=
Received: from mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-407-tlW4EdVNOfWTPZgnjJBirA-1; Tue,
 11 Feb 2025 21:29:45 -0500
X-MC-Unique: tlW4EdVNOfWTPZgnjJBirA-1
X-Mimecast-MFC-AGG-ID: tlW4EdVNOfWTPZgnjJBirA
Received: from mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.111])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 31DFF1800374;
	Wed, 12 Feb 2025 02:29:43 +0000 (UTC)
Received: from fedora (unknown [10.72.116.142])
	by mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id A046918004A7;
	Wed, 12 Feb 2025 02:29:37 +0000 (UTC)
Date: Wed, 12 Feb 2025 10:29:32 +0800
From: Ming Lei <ming.lei@redhat.com>
To: Keith Busch <kbusch@meta.com>
Cc: asml.silence@gmail.com, axboe@kernel.dk, linux-block@vger.kernel.org,
	io-uring@vger.kernel.org, bernd@bsbernd.com,
	Keith Busch <kbusch@kernel.org>
Subject: Re: [PATCHv2 0/6] ublk zero-copy support
Message-ID: <Z6wHjGFcFCLMnUez@fedora>
References: <20250211005646.222452-1-kbusch@meta.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250211005646.222452-1-kbusch@meta.com>
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.111

On Mon, Feb 10, 2025 at 04:56:40PM -0800, Keith Busch wrote:
> From: Keith Busch <kbusch@kernel.org>
> 
> Previous version was discussed here:
> 
>   https://lore.kernel.org/linux-block/20250203154517.937623-1-kbusch@meta.com/
> 
> The same ublksrv reference code in that link was used to test the kernel
> side changes.
> 
> Before listing what has changed, I want to mention what is the same: the
> reliance on the ring ctx lock to serialize the register ahead of any
> use. I'm not ignoring the feedback; I just don't have a solid answer
> right now, and want to progress on the other fronts in the meantime.

It is explained in the following links:

https://lore.kernel.org/linux-block/b6211101-3f74-4dea-a880-81bb75575dbd@gmail.com/

- node kbuffer is registered in ublk uring_cmd's ->issue(), but lookup
  in RW_FIXED OP's ->prep(), and ->prep() is always called before calling
  ->issue() when the two are submitted in same io_uring_enter(), so you
  need to move io_rsrc_node_lookup() & buffer importing from RW_FIXED's ->prep()
  to ->issue() first.

- secondly, ->issue() order is only respected by IO_LINK, and io_uring
  can't provide such guarantee without using IO_LINK:

  Pavel explained it in the following link:

  https://lore.kernel.org/linux-block/68256da6-bb13-4498-a0e0-dce88bb32242@gmail.com/

  There are also other examples, such as, register buffer stays in one
  link chain, and the consumer OP isn't in this chain, the consumer OP
  can still be issued before issuing register_buffer.


Thanks, 
Ming


