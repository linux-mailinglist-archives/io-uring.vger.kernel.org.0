Return-Path: <io-uring+bounces-1018-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 38DD887DA58
	for <lists+io-uring@lfdr.de>; Sat, 16 Mar 2024 14:56:30 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id C1223281F32
	for <lists+io-uring@lfdr.de>; Sat, 16 Mar 2024 13:56:28 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 75F9F17BAF;
	Sat, 16 Mar 2024 13:56:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="E+AosMuD"
X-Original-To: io-uring@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C9A4D2F4A
	for <io-uring@vger.kernel.org>; Sat, 16 Mar 2024 13:56:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710597384; cv=none; b=XHTZi0cdQHzxVBtRbXVu051R87WmONzrMo9/XZn15iJ/v1SIuo17wRM5CO6RoR2g8/OWCGbbVKKhgXf0l6yVstRd5y3pbHbZq8hj8X5aLog/yGTEHiiwVHUxRaHHOs6cJQ/vS1QPRqnl6JrOOh67Vw+3daPw7wN0FFTUbeoooVk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710597384; c=relaxed/simple;
	bh=HwZY4WJc6gF+kop719+5t8mex0n8bh9ueyo0bCmtDIo=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=jzXNt5Y8Vv6/aJNaUABE1ak8B5NlpCAaClvn9hE9eDibHdC9qecz+wodFs8IIkJ3dvStcexfnzkBGBqIIA+2DgrqSz+jpSVBPXMCvzw4WSJS3mQTtQ31mfew7OHawp9VeOw825LB8Rkx2XTHerEp+D/eY0BAnlTyHGzAgzavXTU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=E+AosMuD; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1710597379;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=3IyaeP4KTYSzl2Jnd9bGwqrGlMEQfY44kHWhoVyV14c=;
	b=E+AosMuDWZpVJGwKoSt6g4dJv8XpM20V90Yli5WEls7SiQ0oTUucmzkpSfwQSHigkie1Gi
	Yhbjg9WuEXUfhURhYC3rnYLZ1PsaVxBOOHkCFimZnhKZpGbE+OJfsXcA748ylSSKqTn6Ic
	qYHUYsieNk4wSmB1jFAzux4Jata0epE=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-635-yOdP-w9QNru1BzIxNkCGUw-1; Sat, 16 Mar 2024 09:56:16 -0400
X-MC-Unique: yOdP-w9QNru1BzIxNkCGUw-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com [10.11.54.3])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 136FF85A58C;
	Sat, 16 Mar 2024 13:56:16 +0000 (UTC)
Received: from fedora (unknown [10.72.116.22])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id CC3811121312;
	Sat, 16 Mar 2024 13:56:12 +0000 (UTC)
Date: Sat, 16 Mar 2024 21:56:04 +0800
From: Ming Lei <ming.lei@redhat.com>
To: Pavel Begunkov <asml.silence@gmail.com>
Cc: Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org,
	linux-block@vger.kernel.org, Kanchan Joshi <joshi.k@samsung.com>
Subject: Re: (subset) [PATCH 00/11] remove aux CQE caches
Message-ID: <ZfWk9Pp0zJ1i1JAE@fedora>
References: <cover.1710514702.git.asml.silence@gmail.com>
 <171054320158.386037.13510354610893597382.b4-ty@kernel.dk>
 <ZfWIFOkN/X9uyJJe@fedora>
 <29b950aa-d3c3-4237-a146-c6abd7b68b8f@gmail.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <29b950aa-d3c3-4237-a146-c6abd7b68b8f@gmail.com>
X-Scanned-By: MIMEDefang 3.4.1 on 10.11.54.3

On Sat, Mar 16, 2024 at 01:27:17PM +0000, Pavel Begunkov wrote:
> On 3/16/24 11:52, Ming Lei wrote:
> > On Fri, Mar 15, 2024 at 04:53:21PM -0600, Jens Axboe wrote:

...

> > The following two error can be triggered with this patchset
> > when running some ublk stress test(io vs. deletion). And not see
> > such failures after reverting the 11 patches.
> 
> I suppose it's with the fix from yesterday. How can I
> reproduce it, blktests?

Yeah, it needs yesterday's fix.

You may need to run this test multiple times for triggering the problem:

1) git clone https://github.com/ublk-org/ublksrv.git

2) cd ublksrv

3) make test T=generic/004


Thanks,
Ming


