Return-Path: <io-uring+bounces-4965-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 8AE6C9D56B1
	for <lists+io-uring@lfdr.de>; Fri, 22 Nov 2024 01:23:40 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 520C428309D
	for <lists+io-uring@lfdr.de>; Fri, 22 Nov 2024 00:23:39 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8C99E2CA8;
	Fri, 22 Nov 2024 00:23:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="pbprpurr"
X-Original-To: io-uring@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5A40715A8;
	Fri, 22 Nov 2024 00:23:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732235014; cv=none; b=d7ttB+Vb/PG028BFvsUmmbHVQmZVdIFov9LDubXK8yMKKYFiR50PL+vB+pZJkKV8Fnq7WqmUygPV9QKUO3TurdSmL5/ZaNevDP/Zzozl9rRVBNDWdaeEn16yyh7FJiSCXuQg2vsW5HdK3ybLQ7TmI3X7W14Ol+mWCtTrZwzhIBk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732235014; c=relaxed/simple;
	bh=+QH/OYcCJQTHkWDi9Mz3wZ7DEIXig5j4yU+JGy8razE=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=mBmAXvjXDIq0/hciBZOuTgiJx1f3qy+22jhqbMPPWgefqGNq27/h4nue0Dcx3uVzDedt6X/3DWWCRg8VWnPV+2YZHTo8yx+oP+NYi9JJHPNE9rYcAr1icVQ3bfQjYrM3ZoCLkbrGfQmB9U/GbvQntIFGG44VOWdQcCNcCV9+1BI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=pbprpurr; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B69A0C4CECC;
	Fri, 22 Nov 2024 00:23:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1732235013;
	bh=+QH/OYcCJQTHkWDi9Mz3wZ7DEIXig5j4yU+JGy8razE=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=pbprpurr8gstgLWvynRh4gN3SAZyj677O93nF23T9qO34OFlTgSrJsI8/uUcvUIes
	 O6tsINdL98/x3LSSQDZqJmLnC8vmi5C46OgAIaYkGbWxrcRq2UVRhgBFnlhEcUwaOU
	 RFdFRd1JKeu0cKZCjdtry4IUpWxmx2Vr5W5ptofcojHJF6Dq1tCXBCZW9LYmUY76/G
	 dcmAyQmAsS/DpYuw5qDXuX7fvXhqXqI4l54z2zHBZ8oBuQQ7H7qTb1swv9zN8NsefB
	 2SqT8869FtEnzICbW5HYwZBO2IrRzKmKL7oUq8H6UTlxwEeZ42zplti8uWeqcY7ZnY
	 9LEMFpFWjPXpA==
Message-ID: <858dbafa-6320-4603-82b9-38f586f18249@kernel.org>
Date: Fri, 22 Nov 2024 10:23:26 +1000
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] slab: Fix too strict alignment check in create_cache()
To: Guenter Roeck <linux@roeck-us.net>,
 "Christoph Lameter (Ampere)" <cl@gentwo.org>
Cc: Geert Uytterhoeven <geert@linux-m68k.org>,
 Vlastimil Babka <vbabka@suse.cz>, Pekka Enberg <penberg@kernel.org>,
 David Rientjes <rientjes@google.com>, Joonsoo Kim <iamjoonsoo.kim@lge.com>,
 Andrew Morton <akpm@linux-foundation.org>,
 Roman Gushchin <roman.gushchin@linux.dev>,
 Hyeonggon Yoo <42.hyeyoo@gmail.com>, Jens Axboe <axboe@kernel.dk>,
 Pavel Begunkov <asml.silence@gmail.com>, Mike Rapoport <rppt@kernel.org>,
 Christian Brauner <brauner@kernel.org>, Kees Cook <keescook@chromium.org>,
 Jann Horn <jannh@google.com>, linux-mm@kvack.org, io-uring@vger.kernel.org,
 linux-m68k@vger.kernel.org, linux-kernel@vger.kernel.org
References: <80c767a5d5927c099aea5178fbf2c897b459fa90.1732106544.git.geert@linux-m68k.org>
 <4f70f8d3-4ba5-43dc-af1c-f8e207d27e9f@suse.cz>
 <2e704ffc-2e79-27f7-159e-8fe167d5a450@gentwo.org>
 <CAMuHMdWQisrjqaPPd0xLgtSAxRwnxCPdsqnWSncMiPYLnre2MA@mail.gmail.com>
 <693a6243-b2bd-7f2b-2b69-c7e2308d0f58@gentwo.org>
 <f602e322-af21-4bb3-86d4-52795a581354@roeck-us.net>
Content-Language: en-US
From: Greg Ungerer <gerg@kernel.org>
In-Reply-To: <f602e322-af21-4bb3-86d4-52795a581354@roeck-us.net>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit


On 22/11/24 04:30, Guenter Roeck wrote:
> On Thu, Nov 21, 2024 at 09:23:28AM -0800, Christoph Lameter (Ampere) wrote:
>> On Thu, 21 Nov 2024, Geert Uytterhoeven wrote:
>>
>>> Linux has supported m68k since last century.
>>
>> Yeah I fondly remember the 80s where 68K systems were always out of reach
>> for me to have. The dream system that I never could get my hands on. The
>> creme de la creme du jour. I just had to be content with the 6800 and
>> 6502 processors. Then IBM started the sick road down the 8088, 8086
>> that led from crap to more crap. Sigh.
>>
>>> Any new such assumptions are fixed quickly (at least in the kernel).
>>> If you need a specific alignment, make sure to use __aligned and/or
>>> appropriate padding in structures.
>>> And yes, the compiler knows, and provides __alignof__.
>>>
>>>> How do you deal with torn reads/writes in such a scenario? Is this UP
>>>> only?
>>>
>>> Linux does not support (rate) SMP m68k machines.
>>
>> Ah. Ok that explains it.
>>
>> Do we really need to maintain support for a platform that has been
>> obsolete for decade and does not even support SMP?
> 
> Since this keeps coming up, I think there is a much more important
> question to ask:
> 
> Do we really need to continue supporting nommu machines ? Is anyone
> but me even boot testing those ?

Yes. Across many architectures. And yes on every release, and for m68k building
and testing on every rc for nommu at a minimum.

I rarely hit build or testing problems on nonmmu targets. At least every kernel
release I build and test armnommu (including thumb2 on cortex), m68k, RISC-V and
xtensa. They are all easy, qemu targets for them all. Thats just me. So I would
guess there are others building and testing too.

But what has that got to do with this thread, seems somewhat tangential to the
discussions here so far...

Regards
Greg



