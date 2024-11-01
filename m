Return-Path: <io-uring+bounces-4293-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 183DD9B8975
	for <lists+io-uring@lfdr.de>; Fri,  1 Nov 2024 03:43:20 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id A7D8CB21B5B
	for <lists+io-uring@lfdr.de>; Fri,  1 Nov 2024 02:43:17 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1CCB4132122;
	Fri,  1 Nov 2024 02:43:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="AiH0XRvq"
X-Original-To: io-uring@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2D99F137742
	for <io-uring@vger.kernel.org>; Fri,  1 Nov 2024 02:43:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730428994; cv=none; b=aKk/fn2VCuZ9WB2biegNnwQPlr3nPSWoassyMaKU4GPmDce06ST0gnUrm1FMI7tHWOYFtBjI8PI6CLGwt59xrvuqKPlI1HDA3Fl6kkSTGvIVB7Gkab1NMFmCaRu2KElxj6RdYxlnGARPADDmpYzNF4d1pFx0SwtNRED2JVwAb5Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730428994; c=relaxed/simple;
	bh=zWqicXYigEX2TTAS0jS+g3fq83f4qhZAiHvJF5S8L5c=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=slVu2F2XgUA7ZgOUqZ8FgD2rjxSqpEFD9E10CaHODlaNlsEeFrP6vWVzLMBvBwc6+NiS+5b1z9Dfsat+pn/WxFTrYr84B8e20EHdKDClisU/df44V5lI2Gan51EamCW8gQl11tWbqCXfEUMDBWoWkF4lmHIXXTtQ1Zwny+vo4vw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=AiH0XRvq; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1730428986;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=Pb+2pyU04rnn4Cic6llGI79nIr6WrjTzfSE30/bLHeQ=;
	b=AiH0XRvq7HBeVxOOUGghiYIcpKT3tS+BgVOHXkPuGM3bKLNCmy+bcbP1lBXVWmpglAD4Th
	w/2kj8s1KZ2UHTxHyK3FYawxURwSjpZkyxPkHL/RD83/aNpUJmwpgys3k9VSo+ih04Nrbl
	s8h2+5LqDnPeJlr8a4OBz7MnnNEanQM=
Received: from mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-632-Fxz_JEiMMbWGC0k0xHSauw-1; Thu,
 31 Oct 2024 22:43:02 -0400
X-MC-Unique: Fxz_JEiMMbWGC0k0xHSauw-1
Received: from mx-prod-int-02.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-02.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.15])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id D587D1955F3E;
	Fri,  1 Nov 2024 02:42:59 +0000 (UTC)
Received: from fedora (unknown [10.72.116.63])
	by mx-prod-int-02.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 6198A1956089;
	Fri,  1 Nov 2024 02:42:55 +0000 (UTC)
Date: Fri, 1 Nov 2024 10:42:50 +0800
From: Ming Lei <ming.lei@redhat.com>
To: Jens Axboe <axboe@kernel.dk>
Cc: io-uring <io-uring@vger.kernel.org>,
	Pavel Begunkov <asml.silence@gmail.com>, ming.lei@redhat.com
Subject: Re: [PATCH RFC] io_uring: extend io_uring_sqe flags bits
Message-ID: <ZyRAKm0IQV7wWjhC@fedora>
References: <e60a3dd3-3a74-4181-8430-90c106a202f6@kernel.dk>
 <ZyQ5CcwfLhaASvMz@fedora>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZyQ5CcwfLhaASvMz@fedora>
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.15

On Fri, Nov 01, 2024 at 10:12:25AM +0800, Ming Lei wrote:
> On Thu, Oct 31, 2024 at 03:22:18PM -0600, Jens Axboe wrote:
> > In hindsight everything is clearer, but it probably should've been known
> > that 8 bits of ->flags would run out sooner than later. Rather than
> > gobble up the last bit for a random use case, add a bit that controls
> > whether or not ->personality is used as a flags2 argument. If that is
> > the case, then there's a new IOSQE2_PERSONALITY flag that tells io_uring
> > which personality field to read.
> > 
> > While this isn't the prettiest, it does allow extending with 15 extra
> > flags, and retains being able to use personality with any kind of
> > command. The exception is uring cmd, where personality2 will overlap
> > with the space set aside for SQE128. If they really need that, then that
> 
> The space is the 1st `short` for uring_cmd, instead of SQE128 only.
> 
> Also it is overlapped with ->optval and ->addr3, so just wondering why not
> use ->__pad2?
> 
> Another ways is to use __pad2 for sqe2_flags for non-uring_cmd, and for
> uring_cmd, use its top 16 as sqe2_flags, this way does work, but it is
> just a bit ugly to use.

Also IOSQE2_PERSONALITY doesn't have to be per-SQE, and it can be one
feature of IORING_FEAT_IOSQE2_PERSONALITY, that is why I thought it is
fine to take the 7th bit as SQE_GROUP now.

Thanks,
Ming


