Return-Path: <io-uring+bounces-4294-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 888889B8986
	for <lists+io-uring@lfdr.de>; Fri,  1 Nov 2024 03:57:39 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id BB9EDB21B73
	for <lists+io-uring@lfdr.de>; Fri,  1 Nov 2024 02:57:36 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EA24A13B7AF;
	Fri,  1 Nov 2024 02:57:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="X9o1ZJPr"
X-Original-To: io-uring@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 85FF5137775
	for <io-uring@vger.kernel.org>; Fri,  1 Nov 2024 02:57:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730429850; cv=none; b=ehQMQlyRE7QoNDM2/+KJLAOzsFu3EEUqWIALPYm9BPwpY5ozrNzK3mBmAW4YfObO594FgSrf4rqT7/d2V2xcBBuqbOyG+liEUeRZRIQRdK0e3FyKobEGfzkVymPj6VkQdBATQSJq3x9gLtEmkbiY7ZmeaJG8VAlLw1JuLT+fr80=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730429850; c=relaxed/simple;
	bh=/mdzDZR4+wo1myx0nPTYHZaXC5JbN5DcrsAG0GvRWTg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=PWRvA/2zqxAvvt2xgJ4Eet2mKqcYI6fG68ZML8tKsdaiCwIGoiJS5U4UX/A4a/bO6/HsEO5FOh9lXNHbiVZYZ1W1GqiZ2pQuCO+8YFpBaTQc8+lxW0YJSJrqEIPy5VaFf6GBzTXyKJbHNbF15MVf0uHD2QhVQZV1I4wjRfMDbH0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=X9o1ZJPr; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1730429847;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=WrRR+jmjGYZ4o2y5dZd8Dy64s/J6JM0Bu0o0KaXdXFg=;
	b=X9o1ZJPr6LbG5BcUA+GTWC37L38WP4t2dXkhD6hRCIgJHJAYop5gMqcNiXZtsMQczBlHgg
	G8d3ACPMKQ9AK6ZHKYTu53r6zTgIerJXmwpnPQMq3EqDvM0gsakcSgGHCUpRbZMJ833UwC
	TzXdAUpmpIkBbuRGxHQUsv60EhqxqvU=
Received: from mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-423-0OFgqDoiPI6huLLcjHnjWA-1; Thu,
 31 Oct 2024 22:57:23 -0400
X-MC-Unique: 0OFgqDoiPI6huLLcjHnjWA-1
Received: from mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.4])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id BADFB1956088;
	Fri,  1 Nov 2024 02:57:22 +0000 (UTC)
Received: from fedora (unknown [10.72.116.63])
	by mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 505AA30001A5;
	Fri,  1 Nov 2024 02:57:17 +0000 (UTC)
Date: Fri, 1 Nov 2024 10:57:12 +0800
From: Ming Lei <ming.lei@redhat.com>
To: Jens Axboe <axboe@kernel.dk>
Cc: Pavel Begunkov <asml.silence@gmail.com>, io-uring@vger.kernel.org,
	linux-block@vger.kernel.org,
	Uday Shankar <ushankar@purestorage.com>,
	Akilesh Kailash <akailash@google.com>
Subject: Re: [PATCH V8 0/8] io_uring: support sqe group and leased group kbuf
Message-ID: <ZyRDiFM2ivDWC_rf@fedora>
References: <e76d9742-5693-4057-b925-3917943c7441@kernel.dk>
 <f51e50c8-271e-49b6-b3e1-a63bf61d7451@kernel.dk>
 <ZyGT3h5jNsKB0mrZ@fedora>
 <674e8c3c-1f2c-464a-ad59-da3d00104383@kernel.dk>
 <ZyGjID-17REc9X3e@fedora>
 <ZyGx4JBPdU4VlxlZ@fedora>
 <d986221d-7399-4487-9c28-5d6f953510cd@kernel.dk>
 <ZyLxJdn7bboZMAcs@fedora>
 <63e2091d-d000-4b42-818b-802341ac877f@kernel.dk>
 <d9069c8e-6a58-4574-b842-f1e1f20c55f3@kernel.dk>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <d9069c8e-6a58-4574-b842-f1e1f20c55f3@kernel.dk>
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.4

On Thu, Oct 31, 2024 at 09:07:18AM -0600, Jens Axboe wrote:
> Another option is that we fully stick with the per-group buffer concept,
> which could also work just fine with io_rsrc_node. If we stick with the
> OP_GROUP_START thing, then that op could setup group_buf thing that is
> local to that group. This is where an instantiated buffer would appear
> too, keeping it strictly local to that group. That avoids needing any
> kind of ring state for this, and the group_buf would be propagated from
> the group leader to the members. The group_buf lives until all members
> of the group are dead, at which point it's released. I forget if your
> grouping implementation mandated the same scheme I originally had, where
> the group leader completes last? If it does, then it's a natural thing

Yes, the group leader's CQE is posted after all members' CQE are posted,
and the leader request is freed after all member request is freed.

> to have the group_buf live for the duration of the group leader, and it
> can just be normal per-io_kiocb data at that point, nothing special
> needed there.

That is basically what GROUP_KBUF is written, just not using io_rsrc_node.

> 
> As with the previous scheme, each request using one of these
> IORING_RSRC_KBUFFER nodes just assigns it like it would any other fixed
> resource node, and the normal completion path puts it.

Here the thing is simpler, all member can just use leader's io_rsrc_node,
leader's rsrc_node reference is grabbed & leased to member when adding member
to group, and released by the normal io_req_put_rsrc_nodes(). 

Thanks,
Ming


