Return-Path: <io-uring+bounces-2497-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 0E2C192DBD9
	for <lists+io-uring@lfdr.de>; Thu, 11 Jul 2024 00:20:44 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 0F79D1C23AA8
	for <lists+io-uring@lfdr.de>; Wed, 10 Jul 2024 22:20:43 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 477EA14A633;
	Wed, 10 Jul 2024 22:19:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="XWG858WN"
X-Original-To: io-uring@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 82B7F3BBD8
	for <io-uring@vger.kernel.org>; Wed, 10 Jul 2024 22:19:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720649945; cv=none; b=qcgw84eZDY7UHz+QvYy+1lwiN2c5UBeYMdKGBBQ/lcJUxQs9VMTAqOCW2REej2QITieFGQqpRPJuS/9zPrF3QmgFQjTP3k57kG9alLEm+8YXFwzIIGZ3mUtv7ar4mGSa3+TLBoMZwuNhmm/OQd4pEEMPJsGWMTgxIrGdhRrC058=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720649945; c=relaxed/simple;
	bh=tHBs//jzzMW8Db4CGodh7oxVfzQiy5dEjuEreyM8fXo=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=k1D+In41reawP6xoPN5qLYKnrkY+pnskLTYEgtu14dqloIrxXCcWgAVhnEcgbcYEpIIi9uKPPJpqF9Aq9Bry61ZJDZ9yh250MGDvbdpUYb9MtNV5TI6+GbU4L69xzNYpzOd2ZEJo75Zl6kEFL9wiHznPMoGGknhwdbU77Mjubi4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=XWG858WN; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1720649942;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=tHBs//jzzMW8Db4CGodh7oxVfzQiy5dEjuEreyM8fXo=;
	b=XWG858WN856qjJ4IKgGoROD7M9OQNnHxmTYV/njwSyEzPhXmIb6kkv9m9qx9ygDAQLppAs
	ZkPGiSX0Mqm2HbkpWfkRZH3CEEB41XgOg8oV9HcQaltMk1QYsKAzpiM6Usi8pYwp/2+GNV
	Q1DVz0TybQxynG/AAY7hCLXMKTWWsck=
Received: from mx-prod-mc-04.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-403-tdph6YrkPeu1zVblzju0dw-1; Wed,
 10 Jul 2024 18:18:58 -0400
X-MC-Unique: tdph6YrkPeu1zVblzju0dw-1
Received: from mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.12])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-04.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 0420C19560B2;
	Wed, 10 Jul 2024 22:18:56 +0000 (UTC)
Received: from dhcp-27-174.brq.redhat.com (unknown [10.45.224.169])
	by mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with SMTP id A5B0D19560AE;
	Wed, 10 Jul 2024 22:18:51 +0000 (UTC)
Received: by dhcp-27-174.brq.redhat.com (nbSMTP-1.00) for uid 1000
	oleg@redhat.com; Thu, 11 Jul 2024 00:17:19 +0200 (CEST)
Date: Thu, 11 Jul 2024 00:17:14 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Tejun Heo <tj@kernel.org>
Cc: Pavel Begunkov <asml.silence@gmail.com>, io-uring@vger.kernel.org,
	Jens Axboe <axboe@kernel.dk>,
	Andrew Morton <akpm@linux-foundation.org>,
	Christian Brauner <brauner@kernel.org>,
	Tycho Andersen <tandersen@netflix.com>,
	Thomas Gleixner <tglx@linutronix.de>, linux-kernel@vger.kernel.org,
	Julian Orth <ju.orth@gmail.com>,
	Peter Zijlstra <peterz@infradead.org>
Subject: Re: [PATCH 2/2] kernel: rerun task_work while freezing in
 get_signal()
Message-ID: <20240710221713.GI9228@redhat.com>
References: <20240709190743.GB3892@redhat.com>
 <d2667002-1631-4f42-8aad-a9ea56c0762b@gmail.com>
 <20240709193828.GC3892@redhat.com>
 <d9c00f01-576c-46cd-a88c-76e244460dac@gmail.com>
 <Zo3bt3AJHSG5rVnZ@slm.duckdns.org>
 <933e7957-7a73-4c9a-87a7-c85b702a3a32@gmail.com>
 <20240710191015.GC9228@redhat.com>
 <Zo7e8RQQfG7U5fuT@slm.duckdns.org>
 <20240710213418.GH9228@redhat.com>
 <Zo8Ex0qFRbU2mAOQ@slm.duckdns.org>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Zo8Ex0qFRbU2mAOQ@slm.duckdns.org>
User-Agent: Mutt/1.5.24 (2015-08-30)
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.12

On 07/10, Tejun Heo wrote:
>
> > But how do you think this patch can make the things worse wrt CRIU ?
>
> Oh, I'm not arguing against the patch at all. Just daydreaming about what
> future cleanups should look like.

Ah, sorry, I misunderstood you!

> > In short, I don't like this patch either, I just don't see a better
> > solution for now ;)
>
> I think we're on the same page.

Yes, and I agree with your concerns and your thoughts about future cleanups.

Oleg.


