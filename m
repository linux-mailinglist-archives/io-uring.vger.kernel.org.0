Return-Path: <io-uring+bounces-1616-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id D04218AE8CE
	for <lists+io-uring@lfdr.de>; Tue, 23 Apr 2024 15:57:45 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 6D92B1F24A1E
	for <lists+io-uring@lfdr.de>; Tue, 23 Apr 2024 13:57:45 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9C4E0136E15;
	Tue, 23 Apr 2024 13:57:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="MCRJS1wB"
X-Original-To: io-uring@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3B64813699C
	for <io-uring@vger.kernel.org>; Tue, 23 Apr 2024 13:57:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713880661; cv=none; b=eSUEbZTe5a+yhtMgwmLPv2JJXAdlYX0ZDQHWvuOLVkKEhGbEHjp1KLA1p1+9roEv5aPBiXQ6vrJEYUITWTGpVJn4wqr1SgguWvlofwET56+g7lhuoDtVJDvyRAY7Z6jyXVySDsqkWmIG/+uLy5WrMpetCCeBy2Ei0gyHrc4HnOw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713880661; c=relaxed/simple;
	bh=dzD7j51NO7JNbTCql7NBuFQbGaniSr8gFMxVm8r+tz4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=CKiXKF7qf5qnRDCQqGNTXuEKlSEI7xPcbZmNhmH+z8LR+cDj6zDLsg3xcnbgL6R/S6p2X2QODviqLTlMVRbUVGjhZw9EnfWDW5dfJjsnWnZUH0558QrCGnGFe40vUwDYMzzDTPsnUZ6iuf9raU0At4gUaT0WxF5PI9hEAb+GMuY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=MCRJS1wB; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1713880659;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=buoeMniEBD95Z4sRuMDLAYz4w3sm9+AC9UgcFYRX1LM=;
	b=MCRJS1wBB3U28O5isRktFHLoQfF84iNjpd0u2a4NYfJVNC1rS1BkuZBll4DvCu34Ky/+6O
	G6zhG+iejVpXk6ehsAr01CpdxINTZ3s/CdZ04M61nil09DOrh8fMeDXHk0T5ewPnJS9TRH
	DT82wqJ68/I84P5cR2OBgl2JqMD2RnY=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-643-NA1xd7KvP3ujc0E1WCuCNQ-1; Tue, 23 Apr 2024 09:57:35 -0400
X-MC-Unique: NA1xd7KvP3ujc0E1WCuCNQ-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com [10.11.54.4])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id AA8D78AC2C5;
	Tue, 23 Apr 2024 13:57:34 +0000 (UTC)
Received: from fedora (unknown [10.72.116.86])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 9073D20296D2;
	Tue, 23 Apr 2024 13:57:30 +0000 (UTC)
Date: Tue, 23 Apr 2024 21:57:26 +0800
From: Ming Lei <ming.lei@redhat.com>
To: Jens Axboe <axboe@kernel.dk>
Cc: io-uring@vger.kernel.org, linux-block@vger.kernel.org,
	Pavel Begunkov <asml.silence@gmail.com>,
	Kevin Wolf <kwolf@redhat.com>, ming.lei@redhat.com
Subject: Re: [PATCH 2/9] io_uring: support user sqe ext flags
Message-ID: <Zie+RlbtckZJVE2J@fedora>
References: <20240408010322.4104395-1-ming.lei@redhat.com>
 <20240408010322.4104395-3-ming.lei@redhat.com>
 <89dac454-6521-4bd8-b8aa-ad329b887396@kernel.dk>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <89dac454-6521-4bd8-b8aa-ad329b887396@kernel.dk>
X-Scanned-By: MIMEDefang 3.4.1 on 10.11.54.4

On Mon, Apr 22, 2024 at 12:16:12PM -0600, Jens Axboe wrote:
> On 4/7/24 7:03 PM, Ming Lei wrote:
> > sqe->flags is u8, and now we have used 7 bits, so take the last one for
> > extending purpose.
> > 
> > If bit7(IOSQE_HAS_EXT_FLAGS_BIT) is 1, it means this sqe carries ext flags
> > from the last byte(.ext_flags), or bit23~bit16 of sqe->uring_cmd_flags for
> > IORING_OP_URING_CMD.
> > 
> > io_slot_flags() return value is converted to `ULL` because the affected bits
> > are beyond 32bit now.
> 
> If we're extending flags, which is something we arguably need to do at
> some point, I think we should have them be generic and not spread out.

Sorry, maybe I don't get your idea, and the ext_flag itself is always
initialized in io_init_req(), like normal sqe->flags, same with its
usage.

> If uring_cmd needs specific flags and don't have them, then we should
> add it just for that.

The only difference is that bit23~bit16 of sqe->uring_cmd_flags is
borrowed for uring_cmd's ext flags, because sqe byte0~47 have been taken,
and can't be reused for generic flag. If we want to use byte48~63, it has
to be overlapped with uring_cmd's payload, and it is one generic sqe
flag, which is applied on uring_cmd too.

That is the only way I thought of, or any other suggestion for extending sqe
flags generically?


Thanks,
Ming


