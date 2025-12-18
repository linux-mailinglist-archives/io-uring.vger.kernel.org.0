Return-Path: <io-uring+bounces-11165-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [172.105.105.114])
	by mail.lfdr.de (Postfix) with ESMTPS id B43D4CCA000
	for <lists+io-uring@lfdr.de>; Thu, 18 Dec 2025 02:43:02 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id B5A7C3009979
	for <lists+io-uring@lfdr.de>; Thu, 18 Dec 2025 01:43:01 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E59BC266581;
	Thu, 18 Dec 2025 01:43:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="OJC+m9wP"
X-Original-To: io-uring@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B35E0260566
	for <io-uring@vger.kernel.org>; Thu, 18 Dec 2025 01:42:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1766022180; cv=none; b=NW7mrbUiQOH327X7h6uazEg5F1K6sjN2GouTFQixSGtIZ94GOwZqvMkn4PrXGG1OCcMRHwIDZV2tNu0PdjjVuqZhtVt5O413s3cxjvHAtfKlUrNvHkl4D7aQwMQdbpPEX5plyY8Qae5Zhm3Wb+z3wJnBTB2SV9nH6AmlYmp95mg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1766022180; c=relaxed/simple;
	bh=Rs/OcZ2lgcxOdA1yBradg6os2T53l/aJZrgPNjLKrZA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=GtxvPo8qcSzrpa2g4CiBaXZO+8xZPp14LHKW71Dt3wi/b74gIeFJaYmUE64yTSXy1UoYzcFr15qhkllso/SQhR88LT5zliQiODL28/lONCHtXr9SBBBrC8V5UHf2fgQo9VSz1Z00Yj1yLsT9tEdxpcOy7zu1pt1XDWBX6dfb2RU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=OJC+m9wP; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1766022177;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=a7ObpfMogJ9WxffAgEHKvXV1+jZ+ZRusEyCS1AtkN9I=;
	b=OJC+m9wPVzkomE0+HvxkClonaTn5BHwI9ZBwQ4FF04ueruiKjmkiROsMKK4+2YLxoqqo03
	aoTB8npZHCg7ZcOWpRx4OMk1ecLdyQ+Jdci6In+hljTcS7MMKOM9IwQqOTJj+RfECLrRmu
	0flHNZzlbVoD7DaFSrlugnIBCBMG2lU=
Received: from mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-534-8upDBlOuM4KZU7Sg632fZA-1; Wed,
 17 Dec 2025 20:42:54 -0500
X-MC-Unique: 8upDBlOuM4KZU7Sg632fZA-1
X-Mimecast-MFC-AGG-ID: 8upDBlOuM4KZU7Sg632fZA_1766022173
Received: from mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.17])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 7ED8E1956054;
	Thu, 18 Dec 2025 01:42:52 +0000 (UTC)
Received: from fedora (unknown [10.72.116.190])
	by mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id A4D6F1956056;
	Thu, 18 Dec 2025 01:42:48 +0000 (UTC)
Date: Thu, 18 Dec 2025 09:42:43 +0800
From: Ming Lei <ming.lei@redhat.com>
To: huang-jl <huang-jl@deepseek.com>
Cc: axboe@kernel.dk, csander@purestorage.com, io-uring@vger.kernel.org,
	nj.shetty@samsung.com
Subject: Re: [PATCH v6.20] io_uring/rsrc: refactor io_import_kbuf() to use
 single loop
Message-ID: <aUNcE48RnCy_rFQj@fedora>
References: <20251217123156.1100620-1-ming.lei@redhat.com>
 <20251217151647.193815-1-huang-jl@deepseek.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251217151647.193815-1-huang-jl@deepseek.com>
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.17

On Wed, Dec 17, 2025 at 11:16:47PM +0800, huang-jl wrote:
> The code looks correct to me.
> 
> > This simplifies the logic
> 
> I'm not an expert in Linux development, but from my perspective, the
> original version seems simpler and more readable. The semantics of
> iov_iter_advance() are clear and well-understood.
> 
> That said, I understand the appeal of merging them into a single loop.
> 
> > and avoids the overhead of iov_iter_advance()
> 
> Could you clarify what overhead you mean? If it's the function call
> overhead, I think the compiler would inline it anyway. The actual
> iteration work seems equivalent between both approaches.

iov_iter_advance() is global function, and it can't be inline.

Also single loop is more readable, cause ->iov_offset can be ignored easily.

In theory, re-calculating nr_segs isn't necessary, it is just for avoiding
potential split, however not get idea how it is triggered. Nitesh didn't
mention the exact reason:

https://lkml.org/lkml/2025/4/16/351

I will look at the reason and see if it can be avoided.


Thanks,
Ming


