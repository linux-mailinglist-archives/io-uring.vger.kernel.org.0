Return-Path: <io-uring+bounces-1838-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id F2A358C09F8
	for <lists+io-uring@lfdr.de>; Thu,  9 May 2024 05:06:05 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 55F4A2833E5
	for <lists+io-uring@lfdr.de>; Thu,  9 May 2024 03:06:04 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F28B413BC0B;
	Thu,  9 May 2024 03:06:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="gMNPy9dd"
X-Original-To: io-uring@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 239E685950
	for <io-uring@vger.kernel.org>; Thu,  9 May 2024 03:05:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715223961; cv=none; b=pZvpJeeXZHoP8fnzV45UkYdI99HaQxI6Tu2JQjpvyek6tMcosoZtUGYpYbyEXOiOi7v9rU0RJaxzkXQX09C5+ymh5EyXKdjIEqbcVTKA/LF0lIKHAchV5YjdcOM+ojv8OXXp664i7QhvGSwJrPfUhJIe3VQBRonFrNpbA4FJO9A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715223961; c=relaxed/simple;
	bh=qFtKg799WJxhVG96xOM3KC1DeFTnfr/N9hSnlpTDOa4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Mo6aphNc/pPv2iWHAI0Jo5j2MLcEg+3QInofY5iuLg39SHiy/auqNFfvtTGWzM+AvWJDTHkm1gkbCCh50IvqrcMscoD9GofFVSw+iAC/JEjRvEq+PkULNNplR7x/0xRjgpNIhBnAvLpeoFWilyxBsXqes7lAsgeCxsHtoBEXiXo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=gMNPy9dd; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1715223959;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=YQhWDYuFWGsQO4AX/dM1DUN9UHLHUzhirOUBNraY5eg=;
	b=gMNPy9ddw/K97tPg5T7p9Zk8QIp0wRw0L+3HTVDj03LmqyxWu6NEylj3p0bH7nPAf5Yv86
	ZHHx394M61wq0oroEmR5inv9y4NSIuxrCHkKCPnpA0O2d/voCD/gMronclYAoXU3Fn8fjJ
	eDsFbTs9VWrV5h9dLvypcBNy61GbCJg=
Received: from mimecast-mx02.redhat.com (mx-ext.redhat.com [66.187.233.73])
 by relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-626-KeIPTJ__P9aSzl3Vm8PM2Q-1; Wed,
 08 May 2024 23:05:55 -0400
X-MC-Unique: KeIPTJ__P9aSzl3Vm8PM2Q-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com [10.11.54.4])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id D9A583800098;
	Thu,  9 May 2024 03:05:54 +0000 (UTC)
Received: from fedora (unknown [10.72.116.32])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id E3837200AD74;
	Thu,  9 May 2024 03:05:52 +0000 (UTC)
Date: Thu, 9 May 2024 11:05:48 +0800
From: Ming Lei <ming.lei@redhat.com>
To: Jens Axboe <axboe@kernel.dk>
Cc: io-uring@vger.kernel.org
Subject: Re: [PATCH] io_uring: add IORING_OP_NOP_FAIL
Message-ID: <Zjw9jIHtan4FAc9D@fedora>
References: <20240509023413.4124075-1-ming.lei@redhat.com>
 <1f411b88-f597-40b0-b4c9-257b029d3c9e@kernel.dk>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1f411b88-f597-40b0-b4c9-257b029d3c9e@kernel.dk>
X-Scanned-By: MIMEDefang 3.4.1 on 10.11.54.4

On Wed, May 08, 2024 at 08:55:09PM -0600, Jens Axboe wrote:
> On 5/8/24 8:34 PM, Ming Lei wrote:
> > Add IORING_OP_NOP_FAIL so that it is easy to inject failure from
> > userspace.
> > 
> > Like IORING_OP_NOP, the main use case is test, and it is very helpful
> > for covering failure handling code in io_uring core change.
> 
> Rather than use a new opcode for this, why don't we just add it to
> the existing NOP? I know we don't check for flags in currently, so
> you would not know if it worked, but we could add that and just
> backport that one-liner as well.

Yeah, it is just for avoiding to break existed tests which may not build
over liburing.

I will switch to this way, looks one-line backporting can solve it.

> And if we had such a flag, the fail res could be passed in as well.

We can just pass the 'injected_fail_res' via sqe->len, meantime keep
'nop_flags' for error injection and future extension.


thanks,
Ming


