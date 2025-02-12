Return-Path: <io-uring+bounces-6363-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 3F172A32A1C
	for <lists+io-uring@lfdr.de>; Wed, 12 Feb 2025 16:32:31 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 47BB4188D517
	for <lists+io-uring@lfdr.de>; Wed, 12 Feb 2025 15:29:40 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CA26C211700;
	Wed, 12 Feb 2025 15:28:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Pn7Qcp0J"
X-Original-To: io-uring@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A272221322C;
	Wed, 12 Feb 2025 15:28:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739374134; cv=none; b=gTKG6nFlexyCwGwDvqqYkElJYnB5Glq/ei3rHdxjxEMUJ8YEXi5s1VE4iv3JdWi1aFFhmBwilWS524D0ceBrrfJrh5KX3vH+pXQTiPa7p/z3xTHRQge09Dw7ZkaXNcUcKhOS8f3zHbTvUNotqxOJ0Gj46SEuy3JiQS37yjcdLqE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739374134; c=relaxed/simple;
	bh=LbBtoB5YxzZ1HDwyiWXqxuinvpf/idmjNl6/6wzD9wQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=gZtoxSk5Z9S6FkBy9H8KMGq9AovsSaVY4sI14G/+Ai4TQuH+esCpxPNcS5Bqfzp+5o/vUhunXI0qBvcUOBpiBOdb4Ha6Nv+z/iXPOKJWPuSdWuQRsLcBBHm6CnYf8J5Ldf8qXsrZn6kuIPdzFwwhpAk5w30A8+0PCWQOsk+C8UM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Pn7Qcp0J; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 00DAAC4CEE2;
	Wed, 12 Feb 2025 15:28:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1739374134;
	bh=LbBtoB5YxzZ1HDwyiWXqxuinvpf/idmjNl6/6wzD9wQ=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=Pn7Qcp0JVq2NbhXwmADzluobZvHfPkw/Rxk38ptYzVa8OU3pjiFamHZNTWOLKykU+
	 kOxcgS1et0Yh9nGlgXi7bt3xDtjS9c+XfUULHewnL0U0H5Uz++/rJl3AX0fH8hRQlR
	 kwpPZ5EWCTQZU+ayfgd3w0KkWALdZ4av2Dsg30m68QlN90ahji3k9ULVNdazaYoZD9
	 qLnoJxBtQywxvwDkRfuBzBpu6JcOxfTHfj+wjM7nXJ+5S6jDROPrEick5tjBhJA/pe
	 w8Xo5d7ZeLSdlteP2+Nb+BCORbFtvn7ugvxImQ6JolGxTmDnu1hl+2VOAEC9yNSICE
	 DVo99g6Cc5F7w==
Date: Wed, 12 Feb 2025 08:28:51 -0700
From: Keith Busch <kbusch@kernel.org>
To: Ming Lei <ming.lei@redhat.com>
Cc: Keith Busch <kbusch@meta.com>, asml.silence@gmail.com, axboe@kernel.dk,
	linux-block@vger.kernel.org, io-uring@vger.kernel.org,
	bernd@bsbernd.com
Subject: Re: [PATCHv2 0/6] ublk zero-copy support
Message-ID: <Z6y-M7cby-ZAoLzY@kbusch-mbp>
References: <20250211005646.222452-1-kbusch@meta.com>
 <Z6wHjGFcFCLMnUez@fedora>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Z6wHjGFcFCLMnUez@fedora>

On Wed, Feb 12, 2025 at 10:29:32AM +0800, Ming Lei wrote:
> It is explained in the following links:
> 
> https://lore.kernel.org/linux-block/b6211101-3f74-4dea-a880-81bb75575dbd@gmail.com/
> 
> - node kbuffer is registered in ublk uring_cmd's ->issue(), but lookup
>   in RW_FIXED OP's ->prep(), and ->prep() is always called before calling
>   ->issue() when the two are submitted in same io_uring_enter(), so you
>   need to move io_rsrc_node_lookup() & buffer importing from RW_FIXED's ->prep()
>   to ->issue() first.

I don't think that's accurate, at least in practice. In a normal flow,
we'll have this sequence:

 io_submit_sqes
   io_submit_sqe (uring_cmd ublk register)
     io_init_req
       ->prep()
     io_queue_sqe
       ->issue()
   io_submit_sqe (read/write_fixed)
     io_init_req
       ->prep()
     io_queue_sqe
      ->issue()

The first SQE is handled in its entirety before even looking at the
subsequent SQE. Since the register is first, then the read/write_fixed's
prep will have a valid index. Testing this patch series appears to show
this reliably works.
 
> - secondly, ->issue() order is only respected by IO_LINK, and io_uring
>   can't provide such guarantee without using IO_LINK:
> 
>   Pavel explained it in the following link:
> 
>   https://lore.kernel.org/linux-block/68256da6-bb13-4498-a0e0-dce88bb32242@gmail.com/
> 
>   There are also other examples, such as, register buffer stays in one
>   link chain, and the consumer OP isn't in this chain, the consumer OP
>   can still be issued before issuing register_buffer.

Yep, I got that. Linking is just something I was hoping to avoid. I
understand there are conditions that can break the normal flow I'm
relying on regarding  the ordering. This hasn't appeared to be a problem
in practice, but I agree this needs to be handled.

