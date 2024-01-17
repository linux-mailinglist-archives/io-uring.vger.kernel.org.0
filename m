Return-Path: <io-uring+bounces-419-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 075D2830AF7
	for <lists+io-uring@lfdr.de>; Wed, 17 Jan 2024 17:24:16 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 2B3971C208C6
	for <lists+io-uring@lfdr.de>; Wed, 17 Jan 2024 16:24:15 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C7B4B224C1;
	Wed, 17 Jan 2024 16:24:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="EY2oTodp"
X-Original-To: io-uring@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 38178224C0
	for <io-uring@vger.kernel.org>; Wed, 17 Jan 2024 16:24:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705508651; cv=none; b=VP+fxC151atBmluwAjr2U8JNc1XlW1lKXNEOIhZSiCoGWNzNPDpFHd5bobtzWEwZ0Tl1dFq/JJTnXVa2PoIj+b9dqYHKNzwiYSKKA0lCuQuYCaFp8NJacVUnFzvGE9lYPM21PtXub6XXy7hhoJPi3AAPy7qLViI62HZsmNooQ8Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705508651; c=relaxed/simple;
	bh=V7NSiEUzn9Fj5EG5n1u3TKU3ug+qH6RLfU67r1WYdT0=;
	h=DKIM-Signature:Received:X-MC-Unique:Received:Received:From:To:Cc:
	 Subject:References:X-PGP-KeyID:X-PGP-CertKey:Date:In-Reply-To:
	 Message-ID:User-Agent:MIME-Version:Content-Type:X-Scanned-By; b=ZMtI63mzuxMNMKp8Nb7XGpEhv+xBvjFUgunVjAA3jDJ1B3+L+MDC/Pk5c8QOXPdPvGU8Yf0ySZVa3GEN/OXYtC5KQ6+ZfYcWfEPbKZV75b/LxUoFcV4GE088y8oLbg/kdqh8tXSXEj1lA7ZcWRsUubBDZdlyWV/tUEOoPw0CDO8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=EY2oTodp; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1705508649;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=cgzxB1GWPSowFFuh8Wa0+6L9konS8qmHvUcWRQRAnYk=;
	b=EY2oTodpBiPEY0W4OKr79oaLA4gvg+LLonzvjUBdjThs4brGASFVW5YFgR6TFy/x0heDEE
	RFFcHwze5b3DvnsnZddQnGy8zdccNP4UhhT6wRMtSkIpZ3W9/lEbq4usGfAM26I/jGv4FQ
	RPCY2nGkm7nGSffxdomtld2kzCgOAeY=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-567-01_nHJL8Ojyzj37dzB3oWw-1; Wed, 17 Jan 2024 11:24:06 -0500
X-MC-Unique: 01_nHJL8Ojyzj37dzB3oWw-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com [10.11.54.5])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 0363C83B825;
	Wed, 17 Jan 2024 16:24:05 +0000 (UTC)
Received: from segfault.usersys.redhat.com (unknown [10.22.9.125])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id D16291BDB1;
	Wed, 17 Jan 2024 16:24:04 +0000 (UTC)
From: Jeff Moyer <jmoyer@redhat.com>
To: Jens Axboe <axboe@kernel.dk>
Cc: io-uring <io-uring@vger.kernel.org>
Subject: Re: [PATCH] io_uring/register: guard compat syscall with CONFIG_COMPAT
References: <80eceef8-b2d7-47e8-9ef9-7264249dedbb@kernel.dk>
	<x49il3suf1q.fsf@segfault.usersys.redhat.com>
	<80491979-03ce-412e-b7d7-719f3cf18566@kernel.dk>
X-PGP-KeyID: 1F78E1B4
X-PGP-CertKey: F6FE 280D 8293 F72C 65FD  5A58 1FF8 A7CA 1F78 E1B4
Date: Wed, 17 Jan 2024 11:24:04 -0500
In-Reply-To: <80491979-03ce-412e-b7d7-719f3cf18566@kernel.dk> (Jens Axboe's
	message of "Wed, 17 Jan 2024 09:04:08 -0700")
Message-ID: <x49edegudwb.fsf@segfault.usersys.redhat.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/27.2 (gnu/linux)
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain
X-Scanned-By: MIMEDefang 3.4.1 on 10.11.54.5

Jens Axboe <axboe@kernel.dk> writes:

> On 1/17/24 8:59 AM, Jeff Moyer wrote:
>> Hi, Jens,
>> 
>> Jens Axboe <axboe@kernel.dk> writes:
>> 
>>> Add compat.h include to avoid a potential build issue:
>>>
>>> io_uring/register.c:281:6: error: call to undeclared function 'in_compat_syscall'; ISO C99 and later do not support implicit function declarations [-Werror,-Wimplicit-function-declaration]
>>>
>>> if (in_compat_syscall()) {
>>>     ^
>>> 1 warning generated.
>>> io_uring/register.c:282:9: error: call to undeclared function 'compat_get_bitmap'; ISO C99 and later do not support implicit function declarations [-Werror,-Wimplicit-function-declaration]
>>> ret = compat_get_bitmap(cpumask_bits(new_mask),
>>>       ^
>>>
>>> Fixes: c43203154d8a ("io_uring/register: move io_uring_register(2) related code to register.c")
>>> Reported-by: Manu Bretelle <chantra@meta.com>
>>> Signed-off-by: Jens Axboe <axboe@kernel.dk>
>>>
>>> ---
>>>
>>> diff --git a/io_uring/register.c b/io_uring/register.c
>>> index 708dd1d89add..5e62c1208996 100644
>>> --- a/io_uring/register.c
>>> +++ b/io_uring/register.c
>>> @@ -14,6 +14,7 @@
>>>  #include <linux/slab.h>
>>>  #include <linux/uaccess.h>
>>>  #include <linux/nospec.h>
>>> +#include <linux/compat.h>
>>>  #include <linux/io_uring.h>
>>>  #include <linux/io_uring_types.h>
>> 
>> This makes sense to me, but I wasn't able to reproduce that build error
>> after disabling CONFIG_COMPAT.
>
> I couldn't either, but apparently it happened internally with our kdump
> config variant.

ok.

>>> @@ -278,13 +279,14 @@ static __cold int io_register_iowq_aff(struct io_ring_ctx *ctx,
>>>  	if (len > cpumask_size())
>>>  		len = cpumask_size();
>>>  
>>> -	if (in_compat_syscall()) {
>>> +#ifdef CONFIG_COMPAT
>>> +	if (in_compat_syscall())
>> 
>> I don't think this is needed.
>> 
>> linux/compat.h:
>> ...
>> #else /* !CONFIG_COMPAT */
>> 
>> #define is_compat_task() (0)
>> /* Ensure no one redefines in_compat_syscall() under !CONFIG_COMPAT */
>> #define in_compat_syscall in_compat_syscall
>> static inline bool in_compat_syscall(void) { return false; }
>> 
>> Isn't the code fine as-is?
>
> It probably is, but this makes it consistent with the other spots we do
> compat handling. Hence I'd prefer to keep it like that, and then perhaps
> we can prune them all at some point.

I see one other spot.  :)  But if you are happy with it, that's fine by
me.

> Thanks for taking a look!

Reviewed-by: Jeff Moyer <jmoyer@redhat.com>

Cheers,
Jeff


