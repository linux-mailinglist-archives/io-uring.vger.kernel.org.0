Return-Path: <io-uring+bounces-4988-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id C12F69D645B
	for <lists+io-uring@lfdr.de>; Fri, 22 Nov 2024 19:54:54 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 383C0B25508
	for <lists+io-uring@lfdr.de>; Fri, 22 Nov 2024 18:54:52 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BD6B77080C;
	Fri, 22 Nov 2024 18:54:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=gentwo.org header.i=@gentwo.org header.b="iQQORzPd"
X-Original-To: io-uring@vger.kernel.org
Received: from gentwo.org (gentwo.org [62.72.0.81])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2CEA229A5;
	Fri, 22 Nov 2024 18:54:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=62.72.0.81
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732301687; cv=none; b=F9+2j6b2I3g4QmMrssW8lU/gBky7xILoyhCsXbOHapiNQ/HPkSWBqkJyyrL1ugXGh7Bt9bqQ5JzXFtYIcOFjsRE+RFTtVRsSXZfpK7b9UtFUZ0PJ7+E7jgssrcYkYMyCDghUDJJ2fpxmH4khOt3gUbbdM1tOE91iV3bp8YFM98A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732301687; c=relaxed/simple;
	bh=PG0pD3fq0s9X3wR1/Iw8DyETcfy6GZDNYlO1dcCrCpg=;
	h=Date:From:To:cc:Subject:In-Reply-To:Message-ID:References:
	 MIME-Version:Content-Type; b=pLg0wHdrw9det/Zul0aKly1tbX+oJF2jbv7qYxzhtE2FXiqZQYdihrQDPolMAR8hQC9FL4gRAsOg6qMiGFutGQcsGsZ2uo5pi+fqdFBuQlzpeeAF4wYriQSoxKvvD9X74efwL82IDa8AI7x5GdjOQ1Ki5anZmFPQoqubN09jk2g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=gentwo.org; spf=pass smtp.mailfrom=gentwo.org; dkim=pass (1024-bit key) header.d=gentwo.org header.i=@gentwo.org header.b=iQQORzPd; arc=none smtp.client-ip=62.72.0.81
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=gentwo.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gentwo.org
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gentwo.org;
	s=default; t=1732301679;
	bh=PG0pD3fq0s9X3wR1/Iw8DyETcfy6GZDNYlO1dcCrCpg=;
	h=Date:From:To:cc:Subject:In-Reply-To:References:From;
	b=iQQORzPd4U5Jp0NEIcfFdaYBQerl3p0SQ/39/pQKi3Vz9OvPKDLPo3x5iZTOLanLd
	 tobWNI81/Q4y8v8cJ/OG+Raa8lG9MueSGJBKkUv8xFQm3VSNgwZpnMQowzfSejMy9e
	 eTOlyb4dd1o88LVr+QOlVjU42Fd0hedHIjyLZuDA=
Received: by gentwo.org (Postfix, from userid 1003)
	id 6AA92401E7; Fri, 22 Nov 2024 10:54:39 -0800 (PST)
Received: from localhost (localhost [127.0.0.1])
	by gentwo.org (Postfix) with ESMTP id 683B0400CA;
	Fri, 22 Nov 2024 10:54:39 -0800 (PST)
Date: Fri, 22 Nov 2024 10:54:39 -0800 (PST)
From: "Christoph Lameter (Ampere)" <cl@gentwo.org>
To: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
cc: Guenter Roeck <linux@roeck-us.net>, 
    Geert Uytterhoeven <geert@linux-m68k.org>, 
    Vlastimil Babka <vbabka@suse.cz>, Pekka Enberg <penberg@kernel.org>, 
    David Rientjes <rientjes@google.com>, Joonsoo Kim <iamjoonsoo.kim@lge.com>, 
    Andrew Morton <akpm@linux-foundation.org>, 
    Roman Gushchin <roman.gushchin@linux.dev>, 
    Hyeonggon Yoo <42.hyeyoo@gmail.com>, Jens Axboe <axboe@kernel.dk>, 
    Pavel Begunkov <asml.silence@gmail.com>, Mike Rapoport <rppt@kernel.org>, 
    Christian Brauner <brauner@kernel.org>, Kees Cook <keescook@chromium.org>, 
    Jann Horn <jannh@google.com>, linux-mm@kvack.org, io-uring@vger.kernel.org, 
    linux-m68k@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] slab: Fix too strict alignment check in create_cache()
In-Reply-To: <9be80a9f-1587-4e8a-98cb-edf4920e587e@lucifer.local>
Message-ID: <170f59ce-7739-2e84-35d9-fc6da6955ae1@gentwo.org>
References: <80c767a5d5927c099aea5178fbf2c897b459fa90.1732106544.git.geert@linux-m68k.org> <4f70f8d3-4ba5-43dc-af1c-f8e207d27e9f@suse.cz> <2e704ffc-2e79-27f7-159e-8fe167d5a450@gentwo.org> <CAMuHMdWQisrjqaPPd0xLgtSAxRwnxCPdsqnWSncMiPYLnre2MA@mail.gmail.com>
 <693a6243-b2bd-7f2b-2b69-c7e2308d0f58@gentwo.org> <f602e322-af21-4bb3-86d4-52795a581354@roeck-us.net> <CAMuHMdXDmLoNAcKHpjp2O4D05nAd5SOZ=Xqdbb2O_3B09yU1Gw@mail.gmail.com> <508aa9c4-4176-4336-8948-a31f9791dd39@roeck-us.net> <4535df8b-0ca2-4c3c-9523-d27d3de2b9c7@roeck-us.net>
 <9be80a9f-1587-4e8a-98cb-edf4920e587e@lucifer.local>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII

On Fri, 22 Nov 2024, Lorenzo Stoakes wrote:

> An aside, but note that there is a proposal to add nommu support to UML,
> which would entirely prevent our ability to eliminate it [0] (though it
> would make testing it easier! :)

Ok back to the alignment check. The patch is ok and an improvement since
it properly checks for the alignment of the scalar and does not assume
that a scalar is naturally aligned. That may not be necessary but it is
formally more correct.

So

Acked-by: Christoph Lameter <cl@linux.com>



