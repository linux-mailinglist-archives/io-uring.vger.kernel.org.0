Return-Path: <io-uring+bounces-6124-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id C2AB2A1BF84
	for <lists+io-uring@lfdr.de>; Sat, 25 Jan 2025 01:03:38 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 8349F18811D9
	for <lists+io-uring@lfdr.de>; Sat, 25 Jan 2025 00:03:42 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B99661372;
	Sat, 25 Jan 2025 00:03:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Nh3416qr"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-wr1-f45.google.com (mail-wr1-f45.google.com [209.85.221.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9168A800;
	Sat, 25 Jan 2025 00:03:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737763413; cv=none; b=g/jH5efYCOvQR+10h8zU3dxvZldZKVJRGMxGCprnLp8ZMhnvk8DrvVz9a7YMI5KhsVVr76pvWmvAiGVApZTogvYh9v/YBGf7vT6GSDBh978fXBJuSXeaSjRAI+BKvYrXjZn2Y/Ot67qB3IgnHr0Tn5LqBT+tkwQFQJZqXXzrD1c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737763413; c=relaxed/simple;
	bh=GJnDGfm5JjiBkmFGf9KpQpLQhprPnJCJowwvuHkcRtA=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=rILQ1/ykSb2nqCiqxckJkuhAvU8i0DrTlktIkJ0eRBRy4mXL672NolPC+nsbAeu0g+/4b7OkfemLwvV7yRcJBMcQMFJJ6UeB8WQub0m988K34L/kYclolG2Y4FI418XXmJx/xjXJLHtQMSlSOXzW4m5K7n7FsCyUWu2PkqgNNiY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Nh3416qr; arc=none smtp.client-ip=209.85.221.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-wr1-f45.google.com with SMTP id ffacd0b85a97d-38634c35129so2369337f8f.3;
        Fri, 24 Jan 2025 16:03:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1737763410; x=1738368210; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=LvkUz6rrh40BWkmgbM3RB98m2jGyTmY3Ec69ZV7r1sE=;
        b=Nh3416qriqNsEQ6vFGBfBPLSrCvRgIolyNShMGZ0MScIZQxtOR0zP0wPnjnbcZi9fZ
         +sEpjObNu0o9vUHoa76dxzLsSRSoZlUTHFbDccAx2mT1C2BFKS7smA3x/8MvawIahHVS
         lpYM7QXdB9hCNcoiJ1QzZr+ePUQAEot7fqZhE/RMINaPTpcDyv7FaHNNIZn3IbuIF3DP
         cS7n+2K8CNgmGt8muO/n6PgbQefA3vm85FdHNSCDhtHR2kB2Jx1ca336PohhoDkSxeH9
         Xd0Gwxmm/omb2npIJDxyi0Uhvf60ErIlKs+6ug+yDrRujmQLN7QByJtV8ZhnUGIlFRzV
         MS2A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1737763410; x=1738368210;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=LvkUz6rrh40BWkmgbM3RB98m2jGyTmY3Ec69ZV7r1sE=;
        b=s471IoDiRiPUhba2E1nhZVe4fsFI+JJkW5IOiJ7C1TeHgee04GY2pEHJ37V+zAFsR9
         bIXQHnpbvtFNMr6/Vw0iAr84Xmb8VC1JbFf7dkZQTKhKF7fbF/51jEtOV+i1dNFY/LWs
         r8FqGT9pDuFqDcaDSPTfXBnZIqsA+gHjQ/KJoRHGlo0md708NQ6X+JMiwUoxdzmqC8Zj
         +zLbflSlW7k/RATALzR2dy1Y4/jGtnp0ipkSWjFFwXZsgw1tXPU93YeDZIqitFadzeVb
         ZIeoebO7a4eC/j2Q7os/q0QK+RYWVUgwdEkI9fvmO0kQAQnFaeiDxYXakSacFIm7+TmK
         SkxA==
X-Forwarded-Encrypted: i=1; AJvYcCUqeO8t927A6vN7xLisJ8woATmQl/pZmzgoiP+eqkFeVP3xVryZjC3qJF2WVU2JTcUX6/xEsUw8@vger.kernel.org, AJvYcCUvfpEHv/TV9SI1KzingtFR6XuM43ZSFzcSUyJxlwNtkLziVxqusnx3uNzw+HA9OxfZ4p8zxDGtXBYDx+WS@vger.kernel.org, AJvYcCWdIvh+5hANqWzrcXBZzT3+jMoCWiJjXlO5h4Ns3D2yrtfxlMjzK61jtG3v/YbSxpTHRDHc1+fZ@vger.kernel.org, AJvYcCX6mcch4E42QifU7SRz+MhiYsaTt55QCBA/9XCdCjf3Ztzp693pbDxreYyiv35YS281jlF3j67tOQ==@vger.kernel.org
X-Gm-Message-State: AOJu0YwCRETX8GPxMCTMAxqlEdJ7hqN/gRMrztGMdDM2lv4RZdTh/8xq
	lIRhqgp1N2WOmlxvDuTgmlZa0EWG+EMZpEEI+lxmGy+Wuqdi5Gh/u333ZZcOmFwg9Z7XQqvI5Wy
	NyLz0qa8qgo7zRwROXJgDhK6fBII=
X-Gm-Gg: ASbGncsgzRQrh5Tpt71WyhMGXz3LsGcLkPdWpTrfBz+OJEjGTaQo1ClJXSIc0R/IBF+
	8b4FXXyv/N855hZ2CnmvQG6xbICfWS+G1DvGBM9ppTF+UOUwHoz/iSLUoVGRk+lQssLhSI3lUOJ
	s=
X-Google-Smtp-Source: AGHT+IF5aQcwX/SqSfecwFEg7MgmQvaXWsdQUc5yXao/hVLFPCofVnqlKzDb2Di5915jH/TDCc2m8NPAM86FPgXoJ3M=
X-Received: by 2002:a5d:64eb:0:b0:385:df4e:3645 with SMTP id
 ffacd0b85a97d-38bf59ecb69mr32501744f8f.50.1737763409484; Fri, 24 Jan 2025
 16:03:29 -0800 (PST)
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <CAPAsAGwzBeGXbVtWtZKhbUDbD4b4PtgAS9MJYU2kkiNHgyKpfQ@mail.gmail.com>
 <20250122160645.28926-1-ryabinin.a.a@gmail.com>
In-Reply-To: <20250122160645.28926-1-ryabinin.a.a@gmail.com>
From: Andrey Konovalov <andreyknvl@gmail.com>
Date: Sat, 25 Jan 2025 01:03:18 +0100
X-Gm-Features: AWEUYZldK5UH-Z3qoetD2eelx-La3CJnQOnijzUbA8Se3XdD6uoFtorpaKUcIs0
Message-ID: <CA+fCnZdU2GdAw4eUk9b3Ox8_nLXv-s4isxdoTXePU2J6x5pcGw@mail.gmail.com>
Subject: Re: [PATCH] kasan, mempool: don't store free stacktrace in
 io_alloc_cache objects.
To: Andrey Ryabinin <ryabinin.a.a@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, kasan-dev@googlegroups.com, 
	io-uring@vger.kernel.org, linux-mm@kvack.org, netdev@vger.kernel.org, 
	linux-kernel@vger.kernel.org, juntong.deng@outlook.com, lizetao1@huawei.com, 
	stable@vger.kernel.org, Alexander Potapenko <glider@google.com>, 
	Dmitry Vyukov <dvyukov@google.com>, Vincenzo Frascino <vincenzo.frascino@arm.com>, 
	Jens Axboe <axboe@kernel.dk>, Pavel Begunkov <asml.silence@gmail.com>, 
	"David S. Miller" <davem@davemloft.net>, Eric Dumazet <edumazet@google.com>, 
	Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>, Simon Horman <horms@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Jan 22, 2025 at 5:07=E2=80=AFPM Andrey Ryabinin <ryabinin.a.a@gmail=
.com> wrote:
>
> Running the testcase liburing/accept-reust.t with CONFIG_KASAN=3Dy and
> CONFIG_KASAN_EXTRA_INFO=3Dy leads to the following crash:
>
>     Unable to handle kernel paging request at virtual address 00000c64550=
08008
>     ...
>     pc : __kasan_mempool_unpoison_object+0x38/0x170
>     lr : io_netmsg_cache_free+0x8c/0x180
>     ...
>     Call trace:
>      __kasan_mempool_unpoison_object+0x38/0x170 (P)
>      io_netmsg_cache_free+0x8c/0x180
>      io_ring_exit_work+0xd4c/0x13a0
>      process_one_work+0x52c/0x1000
>      worker_thread+0x830/0xdc0
>      kthread+0x2bc/0x348
>      ret_from_fork+0x10/0x20
>
> Since the commit b556a462eb8d ("kasan: save free stack traces for slab me=
mpools")
> kasan_mempool_poison_object() stores some info inside an object.
> It was expected that the object must be reinitialized after
> kasan_mempool_unpoison_object() call, and this is what happens in the
> most of use cases.
>
> However io_uring code expects that io_alloc_cache_put/get doesn't modify
> the object, so kasan_mempool_poison_object() end up corrupting it leading
> to crash later.
>
> Add @notrack argument to kasan_mempool_poison_object() call to tell
> KASAN to avoid storing info in objects for io_uring use case.
>
> Reported-by: lizetao <lizetao1@huawei.com>
> Closes: https://lkml.kernel.org/r/ec2a6ca08c614c10853fbb1270296ac4@huawei=
.com
> Fixes: b556a462eb8d ("kasan: save free stack traces for slab mempools")
> Cc: stable@vger.kernel.org
> Cc: Alexander Potapenko <glider@google.com>
> Cc: Andrey Konovalov <andreyknvl@gmail.com>
> Cc: Dmitry Vyukov <dvyukov@google.com>
> Cc: Vincenzo Frascino <vincenzo.frascino@arm.com>
> Cc: Jens Axboe <axboe@kernel.dk>
> Cc: Pavel Begunkov <asml.silence@gmail.com>
> Cc: "David S. Miller" <davem@davemloft.net>
> Cc: Eric Dumazet <edumazet@google.com>
> Cc: Jakub Kicinski <kuba@kernel.org>
> Cc: Paolo Abeni <pabeni@redhat.com>
> Cc: Simon Horman <horms@kernel.org>
> Signed-off-by: Andrey Ryabinin <ryabinin.a.a@gmail.com>
> ---
>  include/linux/kasan.h  | 13 +++++++------
>  io_uring/alloc_cache.h |  2 +-
>  io_uring/net.c         |  2 +-
>  io_uring/rw.c          |  2 +-
>  mm/kasan/common.c      | 11 ++++++-----
>  mm/mempool.c           |  2 +-
>  net/core/skbuff.c      |  2 +-
>  7 files changed, 18 insertions(+), 16 deletions(-)
>
> diff --git a/include/linux/kasan.h b/include/linux/kasan.h
> index 890011071f2b..4d0bf4af399d 100644
> --- a/include/linux/kasan.h
> +++ b/include/linux/kasan.h
> @@ -328,18 +328,19 @@ static __always_inline void kasan_mempool_unpoison_=
pages(struct page *page,
>                 __kasan_mempool_unpoison_pages(page, order, _RET_IP_);
>  }
>
> -bool __kasan_mempool_poison_object(void *ptr, unsigned long ip);
> +bool __kasan_mempool_poison_object(void *ptr, bool notrack, unsigned lon=
g ip);
>  /**
>   * kasan_mempool_poison_object - Check and poison a mempool slab allocat=
ion.
>   * @ptr: Pointer to the slab allocation.
> + * @notrack: Don't record stack trace of this call in the object.
>   *
>   * This function is intended for kernel subsystems that cache slab alloc=
ations
>   * to reuse them instead of freeing them back to the slab allocator (e.g=
.
>   * mempool).
>   *
>   * This function poisons a slab allocation and saves a free stack trace =
for it
> - * without initializing the allocation's memory and without putting it i=
nto the
> - * quarantine (for the Generic mode).
> + * (if @notrack =3D=3D false) without initializing the allocation's memo=
ry and
> + * without putting it into the quarantine (for the Generic mode).
>   *
>   * This function also performs checks to detect double-free and invalid-=
free
>   * bugs and reports them. The caller can use the return value of this fu=
nction
> @@ -354,10 +355,10 @@ bool __kasan_mempool_poison_object(void *ptr, unsig=
ned long ip);
>   *
>   * Return: true if the allocation can be safely reused; false otherwise.
>   */
> -static __always_inline bool kasan_mempool_poison_object(void *ptr)
> +static __always_inline bool kasan_mempool_poison_object(void *ptr, bool =
notrack)
>  {
>         if (kasan_enabled())
> -               return __kasan_mempool_poison_object(ptr, _RET_IP_);
> +               return __kasan_mempool_poison_object(ptr, notrack, _RET_I=
P_);
>         return true;
>  }
>
> @@ -456,7 +457,7 @@ static inline bool kasan_mempool_poison_pages(struct =
page *page, unsigned int or
>         return true;
>  }
>  static inline void kasan_mempool_unpoison_pages(struct page *page, unsig=
ned int order) {}
> -static inline bool kasan_mempool_poison_object(void *ptr)
> +static inline bool kasan_mempool_poison_object(void *ptr, bool notrack)
>  {
>         return true;
>  }
> diff --git a/io_uring/alloc_cache.h b/io_uring/alloc_cache.h
> index a3a8cfec32ce..dd508dddea33 100644
> --- a/io_uring/alloc_cache.h
> +++ b/io_uring/alloc_cache.h
> @@ -10,7 +10,7 @@ static inline bool io_alloc_cache_put(struct io_alloc_c=
ache *cache,
>                                       void *entry)
>  {
>         if (cache->nr_cached < cache->max_cached) {
> -               if (!kasan_mempool_poison_object(entry))
> +               if (!kasan_mempool_poison_object(entry, true))
>                         return false;
>                 cache->entries[cache->nr_cached++] =3D entry;
>                 return true;
> diff --git a/io_uring/net.c b/io_uring/net.c
> index 85f55fbc25c9..a954e37c7fd3 100644
> --- a/io_uring/net.c
> +++ b/io_uring/net.c
> @@ -149,7 +149,7 @@ static void io_netmsg_recycle(struct io_kiocb *req, u=
nsigned int issue_flags)
>         iov =3D hdr->free_iov;
>         if (io_alloc_cache_put(&req->ctx->netmsg_cache, hdr)) {
>                 if (iov)
> -                       kasan_mempool_poison_object(iov);
> +                       kasan_mempool_poison_object(iov, true);
>                 req->async_data =3D NULL;
>                 req->flags &=3D ~REQ_F_ASYNC_DATA;
>         }
> diff --git a/io_uring/rw.c b/io_uring/rw.c
> index a9a2733be842..cba475003ba7 100644
> --- a/io_uring/rw.c
> +++ b/io_uring/rw.c
> @@ -167,7 +167,7 @@ static void io_rw_recycle(struct io_kiocb *req, unsig=
ned int issue_flags)
>         iov =3D rw->free_iovec;
>         if (io_alloc_cache_put(&req->ctx->rw_cache, rw)) {
>                 if (iov)
> -                       kasan_mempool_poison_object(iov);
> +                       kasan_mempool_poison_object(iov, true);
>                 req->async_data =3D NULL;
>                 req->flags &=3D ~REQ_F_ASYNC_DATA;
>         }
> diff --git a/mm/kasan/common.c b/mm/kasan/common.c
> index ed4873e18c75..e7b54aa9494e 100644
> --- a/mm/kasan/common.c
> +++ b/mm/kasan/common.c
> @@ -230,7 +230,8 @@ static bool check_slab_allocation(struct kmem_cache *=
cache, void *object,
>  }
>
>  static inline void poison_slab_object(struct kmem_cache *cache, void *ob=
ject,
> -                                     bool init, bool still_accessible)
> +                                     bool init, bool still_accessible,
> +                                     bool notrack)
>  {
>         void *tagged_object =3D object;
>
> @@ -243,7 +244,7 @@ static inline void poison_slab_object(struct kmem_cac=
he *cache, void *object,
>         kasan_poison(object, round_up(cache->object_size, KASAN_GRANULE_S=
IZE),
>                         KASAN_SLAB_FREE, init);
>
> -       if (kasan_stack_collection_enabled())
> +       if (kasan_stack_collection_enabled() && !notrack)
>                 kasan_save_free_info(cache, tagged_object);
>  }
>
> @@ -261,7 +262,7 @@ bool __kasan_slab_free(struct kmem_cache *cache, void=
 *object, bool init,
>         if (!kasan_arch_is_ready() || is_kfence_address(object))
>                 return false;
>
> -       poison_slab_object(cache, object, init, still_accessible);
> +       poison_slab_object(cache, object, init, still_accessible, true);

Should notrack be false here?

>
>         /*
>          * If the object is put into quarantine, do not let slab put the =
object
> @@ -495,7 +496,7 @@ void __kasan_mempool_unpoison_pages(struct page *page=
, unsigned int order,
>         __kasan_unpoison_pages(page, order, false);
>  }
>
> -bool __kasan_mempool_poison_object(void *ptr, unsigned long ip)
> +bool __kasan_mempool_poison_object(void *ptr, bool notrack, unsigned lon=
g ip)
>  {
>         struct folio *folio =3D virt_to_folio(ptr);
>         struct slab *slab;
> @@ -519,7 +520,7 @@ bool __kasan_mempool_poison_object(void *ptr, unsigne=
d long ip)
>         if (check_slab_allocation(slab->slab_cache, ptr, ip))
>                 return false;
>
> -       poison_slab_object(slab->slab_cache, ptr, false, false);
> +       poison_slab_object(slab->slab_cache, ptr, false, false, notrack);
>         return true;
>  }
>
> diff --git a/mm/mempool.c b/mm/mempool.c
> index 3223337135d0..283df5d2b995 100644
> --- a/mm/mempool.c
> +++ b/mm/mempool.c
> @@ -115,7 +115,7 @@ static inline void poison_element(mempool_t *pool, vo=
id *element)
>  static __always_inline bool kasan_poison_element(mempool_t *pool, void *=
element)
>  {
>         if (pool->alloc =3D=3D mempool_alloc_slab || pool->alloc =3D=3D m=
empool_kmalloc)
> -               return kasan_mempool_poison_object(element);
> +               return kasan_mempool_poison_object(element, false);
>         else if (pool->alloc =3D=3D mempool_alloc_pages)
>                 return kasan_mempool_poison_pages(element,
>                                                 (unsigned long)pool->pool=
_data);
> diff --git a/net/core/skbuff.c b/net/core/skbuff.c
> index a441613a1e6c..c9f58a698bb7 100644
> --- a/net/core/skbuff.c
> +++ b/net/core/skbuff.c
> @@ -1457,7 +1457,7 @@ static void napi_skb_cache_put(struct sk_buff *skb)
>         struct napi_alloc_cache *nc =3D this_cpu_ptr(&napi_alloc_cache);
>         u32 i;
>
> -       if (!kasan_mempool_poison_object(skb))
> +       if (!kasan_mempool_poison_object(skb, false))
>                 return;
>
>         local_lock_nested_bh(&napi_alloc_cache.bh_lock);
> --
> 2.45.3
>

