Return-Path: <io-uring+bounces-4871-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 6F74A9D3F5B
	for <lists+io-uring@lfdr.de>; Wed, 20 Nov 2024 16:50:31 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 170231F23504
	for <lists+io-uring@lfdr.de>; Wed, 20 Nov 2024 15:50:31 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AD4E213BAEE;
	Wed, 20 Nov 2024 15:50:25 +0000 (UTC)
X-Original-To: io-uring@vger.kernel.org
Received: from mail-yw1-f176.google.com (mail-yw1-f176.google.com [209.85.128.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4B36B74068;
	Wed, 20 Nov 2024 15:50:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.176
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732117825; cv=none; b=h9wQT2HVH9JiXnV3f25Yyy3Y9APefrUFVGD0mbN2gSh8Q6bD+b0a0BxdQROk6JkT+TTefQogyU5mvR0kqzQsSsg9XAwdGsxIdyAeYVgjvrfDFsL+ezH/X8nwypk6ucayL/3pM7eg6/S81Z7AQqFsSXBiYaPVkZ6WdTcB7q/musk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732117825; c=relaxed/simple;
	bh=av5qTvb1y6W+QV9G+TXybytQX64pxu8jcTjrWKoL2XM=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=hbs43pMuYcr40H5ysW+rr9xiWC9rrKUFODAnXpVMAiQPcLNV7goKnALOIcTWcn4QoHrM34hDoL2vDdzPqNq0adiQgJXKAZVVFQD+aRS/DXv9bTfQoJ0XC7tN90h5wH05eAxHk9YSiQdGAIgGFtVWcvlDq1f7bsi0pQWatO55ivc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=linux-m68k.org; spf=pass smtp.mailfrom=gmail.com; arc=none smtp.client-ip=209.85.128.176
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=linux-m68k.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-yw1-f176.google.com with SMTP id 00721157ae682-6ee6a2ae6ecso49362797b3.3;
        Wed, 20 Nov 2024 07:50:23 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1732117821; x=1732722621;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=4LC1XgSXTVJwbVV22CCZwiiEz0DrDvqfvt7w+YrEcxY=;
        b=B8BRL4trSiLMKuOszC0NNpwuGIv3urb7LOSUNXx0z2PmUGhdsOmmackuaWoe1M0jO4
         kQUXyNHbSOCEQinUIYgJWZowVhZqLnmrTinl/QHvMlxTDFiy1e24rW6GJm+efcuho4Yt
         UfFTJ8qGeb/FU9N8CXWkdqtZMxXbFnj8SHkZYjV0CWgP+7oKmVpMzkFGG/1oBGX657Ue
         YpPqQQJhAvFxyrLiGfhkh4mD0c3rGf3m0tARzlzX4EiMB99r8M9L7b9J6NE9WKDAnL3P
         YFjszwEfB9vvj80QxPZzEyPqRulSnkvnnmqttKljmFSVtDhvvWrQAn+djyMGyi8vjuIb
         YlDA==
X-Forwarded-Encrypted: i=1; AJvYcCUCTEoKcuUCgzz0P0wKXExRp31k1vG2at8bUbnZFCo5IjfSsxl7n9dbkDSDrHQ+uUMCZ7k5OvO/WHX4vEsa@vger.kernel.org, AJvYcCXPbuAPF7UB0e3oJxjt+K3tzbKaULqgHuLwFyfO+1y9EeORgI8IGTSkSAiFpvuNvxKCxdjK4D9nkw==@vger.kernel.org, AJvYcCXi4Vi8AfKnF3aVPeTaiQ7O0CHTtFEw3QhT/HLJBe7GwNAVsFL8NRuJVq529xa2ZAjPJWmYiqLDhotK3g==@vger.kernel.org
X-Gm-Message-State: AOJu0YzJLlW7IyVa0Qvq9Mta/9gNTXkS4tLVDGwLiIIrRJRhXFw/qT5x
	Mqs6QyZYX6Bx1BTHd8d8xREFnUnSY1TQPrvFG1wfNgO+CplZwnVq3MGQSFrt
X-Google-Smtp-Source: AGHT+IFuVg1tr1f+FHXqmGagk8X6Ufw2UKSiFM/R4mMOPwP3DWa7X7Ts35fQNompLH7G9O9NmKk6WA==
X-Received: by 2002:a05:690c:23c4:b0:6dd:d5b7:f35d with SMTP id 00721157ae682-6eebd2991ddmr36005317b3.30.1732117821242;
        Wed, 20 Nov 2024 07:50:21 -0800 (PST)
Received: from mail-yw1-f180.google.com (mail-yw1-f180.google.com. [209.85.128.180])
        by smtp.gmail.com with ESMTPSA id 00721157ae682-6ee712c5507sm22796067b3.62.2024.11.20.07.50.18
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 20 Nov 2024 07:50:19 -0800 (PST)
Received: by mail-yw1-f180.google.com with SMTP id 00721157ae682-6ee6a2ae6ecso49361687b3.3;
        Wed, 20 Nov 2024 07:50:18 -0800 (PST)
X-Forwarded-Encrypted: i=1; AJvYcCVNePmhkk3RMH5T9x7BAvbPehXI0rjxLdo8QC4TJINsmXIuLt7/eXBWurNPW2vbBXijBa6u092ghHF/bQ==@vger.kernel.org, AJvYcCWGI7JVyoFJqvhaNCBhgSh5QwVVOAlJ5RR3WJEWpvfIGL7qCLCPY4RZg0Fp83YN+EwHe+6QVpAFG/vWpL0m@vger.kernel.org, AJvYcCXPb9vAHTMqFGWGQsnsAZktBHXCY096uCqzw68v8P3nXIm07acWS57r78GQDYT08oK6k3fSHMaa6w==@vger.kernel.org
X-Received: by 2002:a05:690c:6f11:b0:6ee:694f:fea3 with SMTP id
 00721157ae682-6eebd0fb580mr37931657b3.14.1732117818431; Wed, 20 Nov 2024
 07:50:18 -0800 (PST)
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <80c767a5d5927c099aea5178fbf2c897b459fa90.1732106544.git.geert@linux-m68k.org>
 <4f70f8d3-4ba5-43dc-af1c-f8e207d27e9f@suse.cz> <f6a16e3c-98de-4a56-8dd1-ea2cbac1874a@roeck-us.net>
 <921f264e-dd84-4b1c-92da-948f1cc8d12c@suse.cz>
In-Reply-To: <921f264e-dd84-4b1c-92da-948f1cc8d12c@suse.cz>
From: Geert Uytterhoeven <geert@linux-m68k.org>
Date: Wed, 20 Nov 2024 16:50:06 +0100
X-Gmail-Original-Message-ID: <CAMuHMdWHwXWtPWKnTii_JNqEn2hGQ3Un5fcJ9itH4t=VX-rONg@mail.gmail.com>
Message-ID: <CAMuHMdWHwXWtPWKnTii_JNqEn2hGQ3Un5fcJ9itH4t=VX-rONg@mail.gmail.com>
Subject: Re: [PATCH] slab: Fix too strict alignment check in create_cache()
To: Vlastimil Babka <vbabka@suse.cz>
Cc: Guenter Roeck <linux@roeck-us.net>, Christoph Lameter <cl@linux.com>, Pekka Enberg <penberg@kernel.org>, 
	David Rientjes <rientjes@google.com>, Joonsoo Kim <iamjoonsoo.kim@lge.com>, 
	Andrew Morton <akpm@linux-foundation.org>, Roman Gushchin <roman.gushchin@linux.dev>, 
	Hyeonggon Yoo <42.hyeyoo@gmail.com>, Jens Axboe <axboe@kernel.dk>, 
	Pavel Begunkov <asml.silence@gmail.com>, Mike Rapoport <rppt@kernel.org>, 
	Christian Brauner <brauner@kernel.org>, Kees Cook <keescook@chromium.org>, Jann Horn <jannh@google.com>, 
	linux-mm@kvack.org, io-uring@vger.kernel.org, linux-m68k@vger.kernel.org, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi Vlastimil,

On Wed, Nov 20, 2024 at 4:44=E2=80=AFPM Vlastimil Babka <vbabka@suse.cz> wr=
ote:
> On 11/20/24 16:14, Guenter Roeck wrote:
> > On 11/20/24 07:03, Vlastimil Babka wrote:
> >> On 11/20/24 13:49, Geert Uytterhoeven wrote:
> >>> On m68k, where the minimum alignment of unsigned long is 2 bytes:
> >>>
> >>>      Kernel panic - not syncing: __kmem_cache_create_args: Failed to =
create slab 'io_kiocb'. Error -22
> >>>      CPU: 0 UID: 0 PID: 1 Comm: swapper Not tainted 6.12.0-atari-0377=
6-g7eaa1f99261a #1783
> >>>      Stack from 0102fe5c:
> >>>         0102fe5c 00514a2b 00514a2b ffffff00 00000001 0051f5ed 00425e7=
8 00514a2b
> >>>         0041eb74 ffffffea 00000310 0051f5ed ffffffea ffffffea 00601f6=
0 00000044
> >>>         0102ff20 000e7a68 0051ab8e 004383b8 0051f5ed ffffffea 000000b=
8 00000007
> >>>         01020c00 00000000 000e77f0 0041e5f0 005f67c0 0051f5ed 000000b=
6 0102fef4
> >>>         00000310 0102fef4 00000000 00000016 005f676c 0060a34c 0000001=
0 00000004
> >>>         00000038 0000009a 01000000 000000b8 005f668e 0102e000 0000137=
2 0102ff88
> >>>      Call Trace: [<00425e78>] dump_stack+0xc/0x10
> >>>       [<0041eb74>] panic+0xd8/0x26c
> >>>       [<000e7a68>] __kmem_cache_create_args+0x278/0x2e8
> >>>       [<000e77f0>] __kmem_cache_create_args+0x0/0x2e8
> >>>       [<0041e5f0>] memset+0x0/0x8c
> >>>       [<005f67c0>] io_uring_init+0x54/0xd2
> >>>
> >>> The minimal alignment of an integral type may differ from its size,
> >>> hence is not safe to assume that an arbitrary freeptr_t (which is
> >>> basically an unsigned long) is always aligned to 4 or 8 bytes.
> >>>
> >>> As nothing seems to require the additional alignment, it is safe to f=
ix
> >>> this by relaxing the check to the actual minimum alignment of freeptr=
_t.
> >>>
> >>> Fixes: aaa736b186239b7d ("io_uring: specify freeptr usage for SLAB_TY=
PESAFE_BY_RCU io_kiocb cache")
> >>> Fixes: d345bd2e9834e2da ("mm: add kmem_cache_create_rcu()")
> >>> Reported-by: Guenter Roeck <linux@roeck-us.net>
> >>> Closes: https://lore.kernel.org/37c588d4-2c32-4aad-a19e-642961f200d7@=
roeck-us.net
> >>> Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
> >>
> >> Thanks, will add it to slab pull for 6.13.
> >>
> >>> ---
> >>>   mm/slab_common.c | 2 +-
> >>>   1 file changed, 1 insertion(+), 1 deletion(-)
> >>>
> >>> diff --git a/mm/slab_common.c b/mm/slab_common.c
> >>> index 893d320599151845..f2f201d865c108bd 100644
> >>> --- a/mm/slab_common.c
> >>> +++ b/mm/slab_common.c
> >>> @@ -230,7 +230,7 @@ static struct kmem_cache *create_cache(const char=
 *name,
> >>>     if (args->use_freeptr_offset &&
> >>>         (args->freeptr_offset >=3D object_size ||
> >>>          !(flags & SLAB_TYPESAFE_BY_RCU) ||
> >>> -        !IS_ALIGNED(args->freeptr_offset, sizeof(freeptr_t))))
> >>> +        !IS_ALIGNED(args->freeptr_offset, __alignof(freeptr_t))))
> >>
> >> Seems only bunch of places uses __alignof but many use __alignoff__ an=
d this
> >> also is what seems to be documented?
> >
> > __alignoff__ -> __alignof__
>
> Yeah I meant __alignof__
> Will chage it locally then.

Thank you!

Gr{oetje,eeting}s,

                        Geert

--=20
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k=
.org

In personal conversations with technical people, I call myself a hacker. Bu=
t
when I'm talking to journalists I just say "programmer" or something like t=
hat.
                                -- Linus Torvalds

