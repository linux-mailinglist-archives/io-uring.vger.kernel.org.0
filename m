Return-Path: <io-uring+bounces-3960-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 59C1C9ADC3B
	for <lists+io-uring@lfdr.de>; Thu, 24 Oct 2024 08:32:53 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id E813A282B29
	for <lists+io-uring@lfdr.de>; Thu, 24 Oct 2024 06:32:51 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E1BBE17A90F;
	Thu, 24 Oct 2024 06:32:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="b5qk8aXS"
X-Original-To: io-uring@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B45F52FC52
	for <io-uring@vger.kernel.org>; Thu, 24 Oct 2024 06:32:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729751568; cv=none; b=PBp9vqJ4D5hVjf5DlvEUDqhD0j57m/aTzDjZd0OM2cAyaToQ6e/P2OVrmnlakh+Wr7QM+sddTFX26syYjjhThLExX78NZDNctxQnbKLMjCg2PLyrTEbTuuTEQfifuyHwFYivAlFLKAZc7haurD6PHlrn3M8NYy2lGYJWKUimijA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729751568; c=relaxed/simple;
	bh=+UPCXQBkWNTDiXfeMiQlhW8zB4gJG3TTUSrx8pIfxiY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=N7UuWO/ScQaa3e5MOvorG8aaWWSB3dUrhd/OnuVklN2yWU6wnYE7vD7M3xywl1sVZn6SqXMp5tsd/IPIz6RGWTFIjiP3NGLAdRrXD41m90BzeKDY1O0iVL7SoyIJzuoG76AddX9vBVc1Z5mk3mF9C6B15prw8BW7cZBdo3pHjkk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=b5qk8aXS; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1729751565;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=1YPOQaP9fLsohm+bZdFISaQhDYYb3guJlfd4tvlkGmE=;
	b=b5qk8aXSUlp0SKuugrNeZMt/kfEQtclF58MY3kPedOFVx0LLfcJdRuhFp5lnpHohfbvlkQ
	bQIh9WnCB+e1jUQmoauskm8HI2NVAb+myioGPjx3U+KTrJrqQ1FxMR/3ofWy25N/DlDkgq
	YXZM4YhBDltgZDFqC+DI7qYl6lNiajE=
Received: from mx-prod-mc-04.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-407-Nb3Pj152Mk6E4qJjtxXwGw-1; Thu,
 24 Oct 2024 02:32:43 -0400
X-MC-Unique: Nb3Pj152Mk6E4qJjtxXwGw-1
Received: from mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.4])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-04.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 5434B19560AF;
	Thu, 24 Oct 2024 06:32:42 +0000 (UTC)
Received: from fedora (unknown [10.72.116.150])
	by mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 00012300018D;
	Thu, 24 Oct 2024 06:32:37 +0000 (UTC)
Date: Thu, 24 Oct 2024 14:32:32 +0800
From: Ming Lei <ming.lei@redhat.com>
To: Uday Shankar <ushankar@purestorage.com>
Cc: Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org,
	Pavel Begunkov <asml.silence@gmail.com>,
	linux-block@vger.kernel.org
Subject: Re: [PATCH V7 5/7] io_uring: support leased group buffer with
 REQ_F_GROUP_KBUF
Message-ID: <ZxnqAMkrUowONyu7@fedora>
References: <20241012085330.2540955-1-ming.lei@redhat.com>
 <20241012085330.2540955-6-ming.lei@redhat.com>
 <ZxnlmNGYWz+AikvV@dev-ushankar.dev.purestorage.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZxnlmNGYWz+AikvV@dev-ushankar.dev.purestorage.com>
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.4

On Thu, Oct 24, 2024 at 12:13:44AM -0600, Uday Shankar wrote:
> On Sat, Oct 12, 2024 at 04:53:25PM +0800, Ming Lei wrote:
> > +int io_import_group_kbuf(struct io_kiocb *req, unsigned long buf_off,
> > +		unsigned int len, int dir, struct iov_iter *iter)
> > +{
> > +	struct io_kiocb *lead = req->grp_link;
> 
> This works since grp_link and grp_leader are in a union together, but
> this should really be req->grp_leader, right?

Yeah, will fix it in V8.

Thanks, 
Ming


