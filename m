Return-Path: <io-uring+bounces-9910-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id BAEBABC1542
	for <lists+io-uring@lfdr.de>; Tue, 07 Oct 2025 14:15:35 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 9631F19A0D0D
	for <lists+io-uring@lfdr.de>; Tue,  7 Oct 2025 12:15:49 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 460D38BEC;
	Tue,  7 Oct 2025 12:15:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="MSWSQlAW"
X-Original-To: io-uring@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A6B4D213E6A
	for <io-uring@vger.kernel.org>; Tue,  7 Oct 2025 12:15:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759839323; cv=none; b=NlSatKbUBFg7fTlAraPtT1on1Uujdm0IQjqIyfqhbzxp1NtJ4BJk1A/W5i8kpU3REky4MQu9IVRngq8epnLHtBRGGYRuYRseoQJ2QN9x435I4wieFDto+b4tmbfYHa3zEkm/bm9X8Q2LM8EUHKxGHcJgmERuu1h/Bl+Xrj2GlN8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759839323; c=relaxed/simple;
	bh=fo6pGF/05nRifFRGjSV3VXNDzv5Fx2eHt3ktwmRtiaU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=aGj7pUOjWh+6g4z3o4aW9iX8zQSQMHf7ytKYxrfHyfP4bI/CR4XL73nSlQQftYURiMMYoLlQTrTgIsmOf/WApLYZNsFOsrA7CQtQEJvl1No8AfLvwcgVLXs0e60n+ZsfhD0ulI7pKFZe22jt2KCQg4lsVlENUsqTwas8ZkuSFPE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=MSWSQlAW; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1759839320;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=5DnkYJLI8htZkMXuJF0q4DWlwEkO+3Xhphxedhtl6T4=;
	b=MSWSQlAWMaIz3VloSbvd+853A+L83MkXQF/o/X/rAtpnGAWMgXm8NmTcYOnbrQcByLb0vk
	TLxVktWUKOBZbqnl5Dvh5KqLQUguVQRRmfABROG3iP3h39QkTGhsS0UgYTw0/5w4/ShSOZ
	3kzwaVqLsJSE2yKOzJSgfpmnEE+LeiY=
Received: from mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-113-3TEzadJFMhC2jlxP1HdfDQ-1; Tue,
 07 Oct 2025 08:15:19 -0400
X-MC-Unique: 3TEzadJFMhC2jlxP1HdfDQ-1
X-Mimecast-MFC-AGG-ID: 3TEzadJFMhC2jlxP1HdfDQ_1759839318
Received: from mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.4])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id A3360195608E;
	Tue,  7 Oct 2025 12:15:17 +0000 (UTC)
Received: from fedora (unknown [10.72.120.2])
	by mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 7583A30002CC;
	Tue,  7 Oct 2025 12:15:10 +0000 (UTC)
Date: Tue, 7 Oct 2025 20:15:05 +0800
From: Ming Lei <ming.lei@redhat.com>
To: Christoph Hellwig <hch@infradead.org>
Cc: Jens Axboe <axboe@kernel.dk>, linux-block@vger.kernel.org,
	Mikulas Patocka <mpatocka@redhat.com>,
	Zhaoyang Huang <zhaoyang.huang@unisoc.com>,
	Dave Chinner <dchinner@redhat.com>, linux-fsdevel@vger.kernel.org,
	io-uring@vger.kernel.org
Subject: Re: [PATCH V4 6/6] loop: add hint for handling aio via IOCB_NOWAIT
Message-ID: <aOUESdhW-joMHvyW@fedora>
References: <20250928132927.3672537-1-ming.lei@redhat.com>
 <20250928132927.3672537-7-ming.lei@redhat.com>
 <aN92BCY1GQZr9YB-@infradead.org>
 <aOPPpEPnClM-4CSy@fedora>
 <aOS0LdM6nMVcLPv_@infradead.org>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aOS0LdM6nMVcLPv_@infradead.org>
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.4

On Mon, Oct 06, 2025 at 11:33:17PM -0700, Christoph Hellwig wrote:
> On Mon, Oct 06, 2025 at 10:18:12PM +0800, Ming Lei wrote:
> > On Fri, Oct 03, 2025 at 12:06:44AM -0700, Christoph Hellwig wrote:
> > > On Sun, Sep 28, 2025 at 09:29:25PM +0800, Ming Lei wrote:
> > > > - there isn't any queued blocking async WRITEs, because NOWAIT won't cause
> > > > contention with blocking WRITE, which often implies exclusive lock
> > > 
> > > Isn't this a generic thing we should be doing in core code so that
> > > it applies to io_uring I/O as well?
> > 
> > No.
> > 
> > It is just policy of using NOWAIT or not, so far:
> > 
> > - RWF_NOWAIT can be set from preadv/pwritev
> > 
> > - used for handling io_uring FS read/write
> > 
> > Even though loop's situation is similar with io-uring, however, both two are
> > different subsystem, and there is nothing `core code` for both, more importantly
> > it is just one policy: use it or not use it, each subsystem can make its
> > own decision based on subsystem internal.
> 
> I fail to parse what you say here.  You are encoding special magic
> about what underlying file systems do in an upper layer.  I'd much

NOWAIT is obviously interface provided by FS, here loop just wants to try
NOWAIT first in block layer dispatch context for avoiding the extra wq
schedule latency.

But for write on sparse file, trying NOWAIT first may bring extra retry
cost, that is why the hint is added. It is very coarse, but potential
regression can be avoided.

> rather have a flag similar FOP_DIO_PARALLEL_WRITE that makes this
> limitation clear rather then opencoding it in the loop driver while

What is the limitation?

> leabing the primary user of RWF_NOWAIT out in the cold.

FOP_DIO_PARALLEL_WRITE is one static FS feature, but here it is FS
runtime behavior, such as if the write can be blocked because of space
allocation, so it can't be done by one static flag.

io-uring shares nothing with loop in this area, it is just one policy wrt.
use NOWAIT or not. I don't understand why you insist on covering both
from FS internal...



Thanks,
Ming


