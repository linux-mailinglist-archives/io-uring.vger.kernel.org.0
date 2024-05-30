Return-Path: <io-uring+bounces-2021-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 7A0DE8D5219
	for <lists+io-uring@lfdr.de>; Thu, 30 May 2024 21:09:48 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 945F51C20FC9
	for <lists+io-uring@lfdr.de>; Thu, 30 May 2024 19:09:47 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 51AEE6D1BA;
	Thu, 30 May 2024 19:09:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=toxicpanda-com.20230601.gappssmtp.com header.i=@toxicpanda-com.20230601.gappssmtp.com header.b="XBVepKmv"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-oi1-f173.google.com (mail-oi1-f173.google.com [209.85.167.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CC5116D1B0
	for <io-uring@vger.kernel.org>; Thu, 30 May 2024 19:09:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717096185; cv=none; b=gcp2rj8cuoZU0NX8z6MmhrrXY2ktzW5sMASAJ3eidmV6sf71lpZn94QuIcfR7Slz0ByssZY5fMgukSmDkg4JazhcJFCbQH2qK68WQvY3zA+EC7rCofw5njQRLk1s9eGL2YgmxYyMtSXlezX+AszimFB+o8TlXfkU0KqWoT7sdPQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717096185; c=relaxed/simple;
	bh=82n7acpe086iLqaQTWYYdHGZLamVImqGqDYDXR5vMtY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ZZwlGvVgXmi8rRkDjmm5d+f9goF8YHWFe9PDPvr0prIIFyKZ2+0VgzLiOBaWglcRGx8lcV6Xhel4jvg1Tm/AFyN/B+eDgvyFIIzPc3QaRX+eJ3DV72WOsoCwg7RQOH+kWIoW6qskF687Ln2JGMXyS5n5cKFi2mcgi9FPISbThaA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=toxicpanda.com; spf=none smtp.mailfrom=toxicpanda.com; dkim=pass (2048-bit key) header.d=toxicpanda-com.20230601.gappssmtp.com header.i=@toxicpanda-com.20230601.gappssmtp.com header.b=XBVepKmv; arc=none smtp.client-ip=209.85.167.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=toxicpanda.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=toxicpanda.com
Received: by mail-oi1-f173.google.com with SMTP id 5614622812f47-3d1bdefedc0so660222b6e.1
        for <io-uring@vger.kernel.org>; Thu, 30 May 2024 12:09:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=toxicpanda-com.20230601.gappssmtp.com; s=20230601; t=1717096183; x=1717700983; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=STEkyafVIcde8Faj8aThfnneXmr4cChiJsEg44JX/7E=;
        b=XBVepKmvEEczWKag6ii2ldL3L4p5b9vEDkfnrfWMSa8K1zfvMoqen6AbPdzNbZ4zC2
         c6Mqe348JZFlzBGusbhe5y20Y0zZt6KuQRKml4vbtOIIXiD4HxlkuXTkyXLMPmb3AoAW
         yrWwkxbnhlgIWGIQ0sjvviQHzbujUHTMgpJVrymnygN50jpcnxqyuOR9LtcN4e2ZiEfB
         xIVIX3Kj2kzjpcfukF5XBTKFMXXagL9+TdftfxbcydQNJhqwDe3pQWLOjkvPkSSWfYq4
         xYl7aZadBI48O/ZCXMgA/5Chfakh9VpB7VvQVW1fxbz/Bk+EmTnv3cvOkxaE1OTpB/Kk
         qgiA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1717096183; x=1717700983;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=STEkyafVIcde8Faj8aThfnneXmr4cChiJsEg44JX/7E=;
        b=IB7IsP0d7laKlUipIXR33xYRWGlnVyIwIz9NxMIXHb4INgupdEKYDxkSXSou7dIWvk
         oTF8ECvqDLibg9748mcKT1kByRvvUzpuvaO05Q54gNNp/Iq9i/rR/qp0iCfNrhIZva3e
         xkZQRvaFbO5ygz4NnZ7mBTXOsvtlm2+6E1IR4blwiLN9y21zI0S9RiuPIQsGVYBRw8Io
         1jNBJ9odld0IKH8CjR2DzYOaWCwQyAawdpEvSuUFdkg1vNXRCf5hU2r9bSbW7Ly48x7s
         DS4zr8PBLvlG4401nV+gxn0X5aBWAspvl9BV1lFs48MxIe33dfwH2iSEBnZfXxyKpSE6
         t4/A==
X-Forwarded-Encrypted: i=1; AJvYcCUbBfb3XhGRZpQOGs4YnUFtJB4tMToLCkfnzatQOy+ZZofOnXPJXeKHngK5S1/mtx3F1iA5Pm7Aql//CcpZVfkGJW7tOcsipX8=
X-Gm-Message-State: AOJu0YyrSiKM0jKuwqvMWALColc0K4PhEMgz1BVBWQnaqd+ekx/Ye3LH
	Tb3W22F7HlqE1VU7xWWa0XnW8zsNGbC8bdlUlyO9nvl/6QCMm+3GybdfdmKqx74=
X-Google-Smtp-Source: AGHT+IGzMKqBOeUDnXYclSdBYnjrIWAc6XIydaMi9nNxv5fMnkBfm9Ebgas0uhT0ClRRJz1TCEyANg==
X-Received: by 2002:a05:6808:f8a:b0:3c9:c2fa:4585 with SMTP id 5614622812f47-3d1dcd0f337mr3580047b6e.42.1717096182765;
        Thu, 30 May 2024 12:09:42 -0700 (PDT)
Received: from localhost (syn-076-182-020-124.res.spectrum.com. [76.182.20.124])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-6ae4a7463a5sm1004726d6.46.2024.05.30.12.09.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 30 May 2024 12:09:42 -0700 (PDT)
Date: Thu, 30 May 2024 15:09:41 -0400
From: Josef Bacik <josef@toxicpanda.com>
To: Bernd Schubert <bernd.schubert@fastmail.fm>
Cc: Kent Overstreet <kent.overstreet@linux.dev>,
	Bernd Schubert <bschubert@ddn.com>,
	Miklos Szeredi <miklos@szeredi.hu>,
	Amir Goldstein <amir73il@gmail.com>, linux-fsdevel@vger.kernel.org,
	Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org,
	Ingo Molnar <mingo@redhat.com>,
	Peter Zijlstra <peterz@infradead.org>,
	Andrei Vagin <avagin@google.com>, io-uring@vger.kernel.org,
	Jens Axboe <axboe@kernel.dk>, Ming Lei <ming.lei@redhat.com>,
	Pavel Begunkov <asml.silence@gmail.com>
Subject: Re: [PATCH RFC v2 00/19] fuse: fuse-over-io-uring
Message-ID: <20240530190941.GA2210558@perftesting>
References: <20240529-fuse-uring-for-6-9-rfc2-out-v1-0-d149476b1d65@ddn.com>
 <5mimjjxul2sc2g7x6pttnit46pbw3astwj2giqfr4xayp63el2@fb5bgtiavwgv>
 <8c3548a9-3b15-49c4-9e38-68d81433144a@fastmail.fm>
 <owccqrazlyfo2zcsprxr7bhpgjrh4km3xlc4ku2aqhqhlqhtyj@djlwwccmlwhw>
 <fe874c55-a26f-413f-9719-9cf59b1a3d28@fastmail.fm>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <fe874c55-a26f-413f-9719-9cf59b1a3d28@fastmail.fm>

On Thu, May 30, 2024 at 06:17:29PM +0200, Bernd Schubert wrote:
> 
> 
> On 5/30/24 18:10, Kent Overstreet wrote:
> > On Thu, May 30, 2024 at 06:02:21PM +0200, Bernd Schubert wrote:
> >> Hmm, initially I had thought about writing my own ring buffer, but then 
> >> io-uring got IORING_OP_URING_CMD, which seems to have exactly what we
> >> need? From interface point of view, io-uring seems easy to use here, 
> >> has everything we need and kind of the same thing is used for ublk - 
> >> what speaks against io-uring? And what other suggestion do you have?
> >>
> >> I guess the same concern would also apply to ublk_drv. 
> >>
> >> Well, decoupling from io-uring might help to get for zero-copy, as there
> >> doesn't seem to be an agreement with Mings approaches (sorry I'm only
> >> silently following for now).
> >>
> >> From our side, a customer has pointed out security concerns for io-uring. 
> >> My thinking so far was to implemented the required io-uring pieces into 
> >> an module and access it with ioctls... Which would also allow to
> >> backport it to RHEL8/RHEL9.
> > 
> > Well, I've been starting to sketch out a ringbuffer() syscall, which
> > would work on any (supported) file descriptor and give you a ringbuffer
> > for reading or writing (or call it twice for both).
> > 
> > That seems to be what fuse really wants, no? You're already using a file
> > descriptor and your own RPC format, you just want a faster
> > communications channel.
> 
> Fine with me, if you have something better/simpler with less security
> concerns - why not. We just need a community agreement on that.
> 
> Do you have something I could look at?

FWIW I have no strong feelings between using iouring vs any other ringbuffer
mechanism we come up with in the future.

That being said iouring is here now, is proven to work, and these are good
performance improvements.  If in the future something else comes along that
gives us better performance then absolutely we should explore adding that
functionality.  But this solves the problem today, and I need the problem solved
yesterday, so continuing with this patchset is very much a worthwhile
investment, one that I'm very happy you're tackling Bernd instead of me ;).
Thanks,

Josef

