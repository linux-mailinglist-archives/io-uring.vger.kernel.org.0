Return-Path: <io-uring+bounces-11166-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sin.lore.kernel.org (sin.lore.kernel.org [104.64.211.4])
	by mail.lfdr.de (Postfix) with ESMTPS id 9DA67CCA140
	for <lists+io-uring@lfdr.de>; Thu, 18 Dec 2025 03:28:18 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sin.lore.kernel.org (Postfix) with ESMTP id 52C8D3006473
	for <lists+io-uring@lfdr.de>; Thu, 18 Dec 2025 02:28:16 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B30352F7ADE;
	Thu, 18 Dec 2025 02:28:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="ZexA4MLZ"
X-Original-To: io-uring@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E99BEC13B
	for <io-uring@vger.kernel.org>; Thu, 18 Dec 2025 02:28:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1766024894; cv=none; b=gVEyNFQGeoFvawsdopd/QvqM689HBQR+aBTzQeNV1Ja2kCi2dbrmOM2FYdEctAdy+bMP1CS0mynfJEyv9MObNOJmx6Yt8mYRDjPlkcZsjM7NeoLDewAkZthvB3q4NCPIYBiSIggd6T+BgfIpfBbaKn0UVgN4Newjt6726p2thqo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1766024894; c=relaxed/simple;
	bh=0G9RwQPZnidn84bY4N0PMdm3GvmrF+rAs7nbKNPCFTo=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=YR9AILLgcPlrPYgyyMsWMO2PHV4bQoIgvlxQsEaL3IHxGw9g/5bKw9eQxIUprgfzqNrThbJX/a2ASYq+0Ds0Yv/s98DAJHUelrp12kwTTy3N6kzs+X/Sb8eCoYLpAkmGS3V9vj0LA7y4tRVaJoGkg1AntsepQcbw6wgYs03EGpk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=ZexA4MLZ; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1766024891;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=t+7SLw0T/yPzRR5se1r+f3gd/PFT+EhJyTxPKtGag9k=;
	b=ZexA4MLZBQ3RRFFyI5vKzCh6kariC/zU2N/BmStgzndP7XiX8q8JGHtOktQpiQmg40TfcF
	ml+xNr+Vj8SMYAtpzuOemkkDoJmrsnLjDdJvcPZQtw6Z6QFlh6bqShLJ2D7+TqW58nhe3d
	GdV+6h5+FYKoEyI1HLHMRfxdn9JNKrs=
Received: from mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-223-0aOTJEZjNSW2uhXVdZRJ8g-1; Wed,
 17 Dec 2025 21:28:07 -0500
X-MC-Unique: 0aOTJEZjNSW2uhXVdZRJ8g-1
X-Mimecast-MFC-AGG-ID: 0aOTJEZjNSW2uhXVdZRJ8g_1766024886
Received: from mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.4])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 901641956050;
	Thu, 18 Dec 2025 02:28:06 +0000 (UTC)
Received: from fedora (unknown [10.72.116.190])
	by mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 13CAE30001A2;
	Thu, 18 Dec 2025 02:28:02 +0000 (UTC)
Date: Thu, 18 Dec 2025 10:27:57 +0800
From: Ming Lei <ming.lei@redhat.com>
To: huang-jl <huang-jl@deepseek.com>
Cc: axboe@kernel.dk, csander@purestorage.com, io-uring@vger.kernel.org,
	nj.shetty@samsung.com
Subject: Re: [PATCH v6.20] io_uring/rsrc: refactor io_import_kbuf() to use
 single loop
Message-ID: <aUNmrSVkZEMk7xmF@fedora>
References: <20251217123156.1100620-1-ming.lei@redhat.com>
 <20251217151647.193815-1-huang-jl@deepseek.com>
 <aUNcE48RnCy_rFQj@fedora>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aUNcE48RnCy_rFQj@fedora>
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.4

On Thu, Dec 18, 2025 at 09:42:43AM +0800, Ming Lei wrote:
> On Wed, Dec 17, 2025 at 11:16:47PM +0800, huang-jl wrote:
> > The code looks correct to me.
> > 
> > > This simplifies the logic
> > 
> > I'm not an expert in Linux development, but from my perspective, the
> > original version seems simpler and more readable. The semantics of
> > iov_iter_advance() are clear and well-understood.
> > 
> > That said, I understand the appeal of merging them into a single loop.
> > 
> > > and avoids the overhead of iov_iter_advance()
> > 
> > Could you clarify what overhead you mean? If it's the function call
> > overhead, I think the compiler would inline it anyway. The actual
> > iteration work seems equivalent between both approaches.
> 
> iov_iter_advance() is global function, and it can't be inline.
> 
> Also single loop is more readable, cause ->iov_offset can be ignored easily.
> 
> In theory, re-calculating nr_segs isn't necessary, it is just for avoiding
> potential split, however not get idea how it is triggered. Nitesh didn't
> mention the exact reason:
> 
> https://lkml.org/lkml/2025/4/16/351
> 
> I will look at the reason and see if it can be avoided.

The reason is in both bio_iov_bvec_set() and bio_may_need_split().

->bi_vcnt doesn't make sense for cloned bio, and shouldn't be used as multiple
segment hint.

However, it also shows bio_split_rw() is too heavy.


Thanks,
Ming


