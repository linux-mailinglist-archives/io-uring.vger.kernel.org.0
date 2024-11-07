Return-Path: <io-uring+bounces-4514-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 223F29BFB23
	for <lists+io-uring@lfdr.de>; Thu,  7 Nov 2024 02:05:02 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id A1EB4B2183D
	for <lists+io-uring@lfdr.de>; Thu,  7 Nov 2024 01:04:59 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id ACB7F7FD;
	Thu,  7 Nov 2024 01:04:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="KYCDvTIH"
X-Original-To: io-uring@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6DE2E1854
	for <io-uring@vger.kernel.org>; Thu,  7 Nov 2024 01:04:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730941494; cv=none; b=qZJpSO/i1lITTHSTt4Z3PyQfgH80rh6gvK/XS2+5cJAyLw3O1Y7JA4vO902F1Q1J7szKxjajSWMsdwKArmtRwSsaNRRsI1pIaA+pkGbRTHZz9k50FBjZ7Ml9aVRdOGZcb5Go9EzfIS8sApCGHdQyxMMTYJ5IpTGLj3Ghuzq+9kk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730941494; c=relaxed/simple;
	bh=heGjegeyjAifadIPbWLq0vhRFyygnCp/vB2g4fWW/dA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=W/ZOMdh1tNR/Cgco/QlfBs36fyTU9m2K5KxlEFjCgRVCt0U+KHYQMWJsHAxvtQ92PRuyUS+LVU8J5umcoDvzV+uhctPiSK7yZPh1wIyWRO552W3rSpQafH0SRDMp7Q4PO9WFhqWfM+83Jmxs9WrLH95bbcx3/Y2Dr/aZC7jLgKM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=KYCDvTIH; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1730941491;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=eSXIBSIl3jht1oIEmbNrhPb1vqat5R739MIPQcXPHro=;
	b=KYCDvTIH0Khx1TICjEujxUTcrB3wGfLsERED+W76kqahS/o99mgxFaWJp9/jfpvgOVYi+J
	WnfpSReC3AcTLBbDfyzR5F0/fVNWyrqKTcMDYU+iH7yx/R5LNhTeyr5HQ/UI9x6US6v9Zs
	M80HCVUFTKu13DIOhePW6XOopJMRW5E=
Received: from mx-prod-mc-02.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-581-SBvVoGYON3iC-slGSiiW9w-1; Wed,
 06 Nov 2024 20:04:48 -0500
X-MC-Unique: SBvVoGYON3iC-slGSiiW9w-1
X-Mimecast-MFC-AGG-ID: SBvVoGYON3iC-slGSiiW9w
Received: from mx-prod-int-02.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-02.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.15])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-02.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id C0F411955EE7;
	Thu,  7 Nov 2024 01:04:46 +0000 (UTC)
Received: from fedora (unknown [10.72.116.47])
	by mx-prod-int-02.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 71DEF1956088;
	Thu,  7 Nov 2024 01:04:41 +0000 (UTC)
Date: Thu, 7 Nov 2024 09:04:36 +0800
From: Ming Lei <ming.lei@redhat.com>
To: Jens Axboe <axboe@kernel.dk>
Cc: io-uring@vger.kernel.org, Pavel Begunkov <asml.silence@gmail.com>,
	linux-block@vger.kernel.org,
	Uday Shankar <ushankar@purestorage.com>,
	Akilesh Kailash <akailash@google.com>
Subject: Re: [PATCH V9 3/7] io_uring: shrink io_mapped_buf
Message-ID: <ZywSJCDsogZ0wl_o@fedora>
References: <20241106122659.730712-1-ming.lei@redhat.com>
 <20241106122659.730712-4-ming.lei@redhat.com>
 <44abdb96-3210-45d2-b673-ec2eb309bac2@kernel.dk>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <44abdb96-3210-45d2-b673-ec2eb309bac2@kernel.dk>
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.15

On Wed, Nov 06, 2024 at 08:09:38AM -0700, Jens Axboe wrote:
> On 11/6/24 5:26 AM, Ming Lei wrote:
> > `struct io_mapped_buf` will be extended to cover kernel buffer which
> > may be in fast IO path, and `struct io_mapped_buf` needs to be per-IO.
> > 
> > So shrink sizeof(struct io_mapped_buf) by the following ways:
> > 
> > - folio_shift is < 64, so 6bits are enough to hold it, the remained bits
> >   can be used for the coming kernel buffer
> > 
> > - define `acct_pages` as 'unsigned int', which is big enough for
> >   accounting pages in the buffer
> > 
> > Signed-off-by: Ming Lei <ming.lei@redhat.com>
> > ---
> >  io_uring/rsrc.c | 2 ++
> >  io_uring/rsrc.h | 6 +++---
> >  2 files changed, 5 insertions(+), 3 deletions(-)
> > 
> > diff --git a/io_uring/rsrc.c b/io_uring/rsrc.c
> > index 9b8827c72230..16f5abe03d10 100644
> > --- a/io_uring/rsrc.c
> > +++ b/io_uring/rsrc.c
> > @@ -685,6 +685,8 @@ static bool io_try_coalesce_buffer(struct page ***pages, int *nr_pages,
> >  		return false;
> >  
> >  	data->folio_shift = folio_shift(folio);
> > +	WARN_ON_ONCE(data->folio_shift >= 64);
> 
> Since folio_shift is 6 bits, how can that be try?
> 
> I think you'd want:
> 
> 	WARN_ON_ONCE(folio_shift(folio) >= 64);
> 
> instead.

imu->folio_shift is 6 bits, and it is only copied from data->folio_shift(char),
that is why the warning is added for data->folio_shift.

Thanks,
Ming


