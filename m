Return-Path: <io-uring+bounces-3431-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 22530991C7A
	for <lists+io-uring@lfdr.de>; Sun,  6 Oct 2024 05:55:27 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id E1179281E70
	for <lists+io-uring@lfdr.de>; Sun,  6 Oct 2024 03:55:25 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9596CEAC6;
	Sun,  6 Oct 2024 03:55:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Hf2EooGD"
X-Original-To: io-uring@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2321E5FEED
	for <io-uring@vger.kernel.org>; Sun,  6 Oct 2024 03:55:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728186925; cv=none; b=lDjTUgZLzj5hV9rD8vkG5W3KmNKyGcaepvb7HiMrpDHXPulwsoJonaVypQv1Uocluj7qpGwa/wZnlsAOmAFddIl7tLfczcXItUV7FLr9ZmdtuXMNPbbFUr5Sx94zP947pjZZC62QLvtYCMFNN6XbA6n8Mnhc3TiyBeEup2aplYE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728186925; c=relaxed/simple;
	bh=cHzYy/peCHbekEClQEQlfrfvaaKGeLEEElmDPiw1bC8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=A6e5PAP+HOrsSpWxnUbb1cr7Hn9U49fQUruaubnZufYZlvRWiyl1W7YoGLLGZy9zoNmsuv15OGIJStHddwLmR4lAiOCloZEv9mwykiA5KaHQg28ESfV/xjC0IUT/uwaDC3kWxxjReqAbwd0p2bUVs7OhFP05TSadtlBw0NtqTsI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=Hf2EooGD; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1728186919;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=7kLinepcpe1b0ntnO9Z6uP9P9sY4ikJtKhQzk/NG7UM=;
	b=Hf2EooGDMNfqOdgKrSD2GNIWH9IH2K7zP/SUEa8I4XhP5jBq7CUVy1DFAh+WFB1JXOPy6V
	vL92xBlwE+61Nk6eJDCTzOCjCDSGZk2EYrOMY5kFBBVgSuc8gaFbNGQa61ZYCHuqJ2ScxR
	+ChfjBeCkSeoZUZuBw4DGg3aGIzdByI=
Received: from mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-466-dAdgM1NMOdWw0pPn8FsyEw-1; Sat,
 05 Oct 2024 23:55:15 -0400
X-MC-Unique: dAdgM1NMOdWw0pPn8FsyEw-1
Received: from mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.4])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 46E17195422B;
	Sun,  6 Oct 2024 03:55:14 +0000 (UTC)
Received: from fedora (unknown [10.72.116.21])
	by mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id DEB0E3000198;
	Sun,  6 Oct 2024 03:55:08 +0000 (UTC)
Date: Sun, 6 Oct 2024 11:54:57 +0800
From: Ming Lei <ming.lei@redhat.com>
To: Pavel Begunkov <asml.silence@gmail.com>
Cc: Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org,
	linux-block@vger.kernel.org
Subject: Re: [PATCH V6 5/8] io_uring: support sqe group with members
 depending on leader
Message-ID: <ZwIKEdkQ4f5ueX31@fedora>
References: <20240912104933.1875409-1-ming.lei@redhat.com>
 <20240912104933.1875409-6-ming.lei@redhat.com>
 <36b88a5a-1209-4db3-8514-0f1e1828f7e1@gmail.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <36b88a5a-1209-4db3-8514-0f1e1828f7e1@gmail.com>
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.4

On Fri, Oct 04, 2024 at 02:18:13PM +0100, Pavel Begunkov wrote:
> On 9/12/24 11:49, Ming Lei wrote:
> > IOSQE_SQE_GROUP just starts to queue members after the leader is completed,
> > which way is just for simplifying implementation, and this behavior is never
> > part of UAPI, and it may be relaxed and members can be queued concurrently
> > with leader in future.
> > 
> > However, some resource can't cross OPs, such as kernel buffer, otherwise
> > the buffer may be leaked easily in case that any OP failure or application
> > panic.
> > 
> > Add flag REQ_F_SQE_GROUP_DEP for allowing members to depend on group leader
> > explicitly, so that group members won't be queued until the leader request is
> > completed, the kernel resource lifetime can be aligned with group leader
> 
> That's the current and only behaviour, we don't need an extra flag
> for that. We can add it back later when anything changes.

OK.

Thanks, 
Ming


