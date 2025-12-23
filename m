Return-Path: <io-uring+bounces-11289-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id 63FAECD7DE0
	for <lists+io-uring@lfdr.de>; Tue, 23 Dec 2025 03:30:26 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id BD75A300ACC3
	for <lists+io-uring@lfdr.de>; Tue, 23 Dec 2025 02:30:24 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F0628214A64;
	Tue, 23 Dec 2025 02:30:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="g5tLS/e1"
X-Original-To: io-uring@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3A853283FDD
	for <io-uring@vger.kernel.org>; Tue, 23 Dec 2025 02:30:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1766457023; cv=none; b=gcJ3bxLrFmVUPfglw3yR/rLrFDpF8Vgd765IOG7n9y5ZYfzpNmrucfhCiSnlW5t2IlFZ6rJZZBzXLLrbqA5CK6772EBtMP8k75dP7qH3YvyNmOTvihiOAY68TaAQzgWNbXO9JG/RD9kwrZiSd/2HYWKdxbLep1RDpyRmMtl4AHY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1766457023; c=relaxed/simple;
	bh=R0SGx9qrxJdHodfUBNOyscjzoqf29IwkGwkpX8N9T98=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=p3GS0qIbSNHAOMBZgCJsXJUoPiHMrL4356aDqnHc5noxOR4mUAPrpHY0DBaRdAeGjFzI7PFQ89fvKRWXZZvg668KB+gJzb4HBO1l5xBQTGx7XHHvS4a1i/dDkJB5LUBThcGoht0IWiJSoX/Fj7LzL7I7m+fGfgPOXBxgHcYjOjs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=g5tLS/e1; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1766457021;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=4RgElIhvwM5MM92vj4dyFVrE55d64gbTK1aAwrOpP0o=;
	b=g5tLS/e1CYhmGJQ1NW/ZNBgLqOZ9K7eb6hlHQ3G5crYgmPKjswOLc7W640vNSFmrTxaf8X
	b+ktzvCmQNXGTQ929PqsmuIjKqMonp5C6/xB1WzOJtb0+oIzbaHX9UObEM1OD/1cTeNqS2
	34tvqQ76nBAx/YpmtOxPnrImeitFFhE=
Received: from mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-596-wBxNqTcPOCmvS0y_hBgUaQ-1; Mon,
 22 Dec 2025 21:30:19 -0500
X-MC-Unique: wBxNqTcPOCmvS0y_hBgUaQ-1
X-Mimecast-MFC-AGG-ID: wBxNqTcPOCmvS0y_hBgUaQ_1766457018
Received: from mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.4])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 17C5E1800451;
	Tue, 23 Dec 2025 02:30:18 +0000 (UTC)
Received: from fedora (unknown [10.72.116.97])
	by mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id E9B0C30001A8;
	Tue, 23 Dec 2025 02:30:13 +0000 (UTC)
Date: Tue, 23 Dec 2025 10:30:09 +0800
From: Ming Lei <ming.lei@redhat.com>
To: Caleb Sander Mateos <csander@purestorage.com>
Cc: huang-jl <huang-jl@deepseek.com>, axboe@kernel.dk,
	io-uring@vger.kernel.org, nj.shetty@samsung.com
Subject: Re: [PATCH v6.20] io_uring/rsrc: refactor io_import_kbuf() to use
 single loop
Message-ID: <aUn-sSrlD2gwkFTO@fedora>
References: <20251217123156.1100620-1-ming.lei@redhat.com>
 <20251217151647.193815-1-huang-jl@deepseek.com>
 <aUNcE48RnCy_rFQj@fedora>
 <aUNmrSVkZEMk7xmF@fedora>
 <CADUfDZr8vQ9AQSONNmQVyS-BwV1T_MxfGcAWWHwQ=Ci15gMYFg@mail.gmail.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CADUfDZr8vQ9AQSONNmQVyS-BwV1T_MxfGcAWWHwQ=Ci15gMYFg@mail.gmail.com>
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.4

On Mon, Dec 22, 2025 at 02:56:02PM -0500, Caleb Sander Mateos wrote:
> On Wed, Dec 17, 2025 at 9:28 PM Ming Lei <ming.lei@redhat.com> wrote:
> >
> > On Thu, Dec 18, 2025 at 09:42:43AM +0800, Ming Lei wrote:
> > > On Wed, Dec 17, 2025 at 11:16:47PM +0800, huang-jl wrote:
> > > > The code looks correct to me.
> > > >
> > > > > This simplifies the logic
> > > >
> > > > I'm not an expert in Linux development, but from my perspective, the
> > > > original version seems simpler and more readable. The semantics of
> > > > iov_iter_advance() are clear and well-understood.
> > > >
> > > > That said, I understand the appeal of merging them into a single loop.
> > > >
> > > > > and avoids the overhead of iov_iter_advance()
> > > >
> > > > Could you clarify what overhead you mean? If it's the function call
> > > > overhead, I think the compiler would inline it anyway. The actual
> > > > iteration work seems equivalent between both approaches.
> > >
> > > iov_iter_advance() is global function, and it can't be inline.
> > >
> > > Also single loop is more readable, cause ->iov_offset can be ignored easily.
> > >
> > > In theory, re-calculating nr_segs isn't necessary, it is just for avoiding
> > > potential split, however not get idea how it is triggered. Nitesh didn't
> > > mention the exact reason:
> > >
> > > https://lkml.org/lkml/2025/4/16/351
> > >
> > > I will look at the reason and see if it can be avoided.
> >
> > The reason is in both bio_iov_bvec_set() and bio_may_need_split().
> 
> nr_segs is not just a performance optimization, it's part of the
> struct iov_iter API and used by iov_iter_extract_bvec_pages(), as
> huang-jl pointed out. I don't think it's a good idea to assume that
> nr_segs isn't going to be used and doesn't need to be calculated
> correctly.

It doesn't have to be exact if the bytes covered by `count` won't cross
`nr_segs`.

The `nr_segs` re-calculation is added only for fixing performance regression
in the following link:

https://lkml.org/lkml/2025/4/16/351

because bio_iov_bvec_set() takes iter->nr_segs for setting bio->bi_vcnt.

> 
> I think this patch is a definite improvement as it reduces the number
> of assumptions about the internal structure of a bvec iov_iter. The
> remaining assignment to iter->iov_offset is unfortunate, but I don't
> see a great way around it.
> 

The re-calculation can be removed, please see the following patches:

https://lore.kernel.org/linux-block/20251218093146.1218279-1-ming.lei@redhat.com/

Nitesh has verified that it won't cause perf regression by replacing
bio->bi_vcnt with __bvec_iter_bvec() in bio_may_need_split().


Thanks,
Ming


