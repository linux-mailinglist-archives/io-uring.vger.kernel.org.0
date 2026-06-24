Return-Path: <io-uring+bounces-13832-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by mail.lfdr.de with LMTP
	id qp9IC8fpO2oGfQgAu9opvQ
	(envelope-from <io-uring+bounces-13832-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Wed, 24 Jun 2026 16:29:27 +0200
X-Original-To: lists+io-uring@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id 7B0F56BF1DF
	for <lists+io-uring@lfdr.de>; Wed, 24 Jun 2026 16:29:26 +0200 (CEST)
Authentication-Results: mail.lfdr.de;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=CK1QgHuI;
	spf=pass (mail.lfdr.de: domain of "io-uring+bounces-13832-lists+io-uring=lfdr.de@vger.kernel.org" designates 172.234.253.10 as permitted sender) smtp.mailfrom="io-uring+bounces-13832-lists+io-uring=lfdr.de@vger.kernel.org";
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("subspace.kernel.org:s=arc-20240116:i=1")
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 124B330ECBB5
	for <lists+io-uring@lfdr.de>; Wed, 24 Jun 2026 14:23:39 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0106E3C37B4;
	Wed, 24 Jun 2026 14:23:32 +0000 (UTC)
X-Original-To: io-uring@vger.kernel.org
Received: from mail-wr1-f42.google.com (mail-wr1-f42.google.com [209.85.221.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 976503C2786
	for <io-uring@vger.kernel.org>; Wed, 24 Jun 2026 14:23:28 +0000 (UTC)
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782311011; cv=none; b=ODGNfMMc9Vbzc0zBUA+soj3Q1WHIYWUZf1cQjODhm3eCEf7LmNt3GNse99RV18QtgyH/wWtQu2IrspmV5lzY0acuF65WSvkEGVtyZ6jfQpNsCM5mE7aTeoGFdS9EZg8iq7FtJt3R+m3hAbk9u4fWSQ7yPK4hrQgBgpYnljQhlhE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782311011; c=relaxed/simple;
	bh=ANcnDbJl1GrE6afhpUmaNktn53Zw0TE+IUnQR7Lyflk=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=UZe0F+CEM0Y+FcHXOnXA1y8Bbjw1BQRnTBQ77X5SUt5miWe/2UFu2z+MZboMk9NsMLfCO8JYbth9xgUrgBIB0+X1MdKy5UxIITLZ8XQBU61SIV+Opda4BLb4fxPsL1CrVGS24uiXZGJmabfAgXc4KMNnRswyqq5TgSsSO9nX0iE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=CK1QgHuI; arc=none smtp.client-ip=209.85.221.42
Received: by mail-wr1-f42.google.com with SMTP id ffacd0b85a97d-46cdcec58c2so213787f8f.1
        for <io-uring@vger.kernel.org>; Wed, 24 Jun 2026 07:23:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1782311007; x=1782915807; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Per6MI6n5CBZ4jce2Yah0coKW3mXxHCaIKwWKmwmsgQ=;
        b=CK1QgHuIU3L+Hoq9eyhLAP/tW60WuHCUI7tfWelD/UEnl2Wy0NhsVkfh8AA22XEOA2
         hDg0I3Qw0c8thCpYKIRQF2GB97/jDtHq3N7sH/zC33OPWPVMkUtDc/wZajKMWaLEVhh+
         9ZNJdTbT7ze+PrqZ/wGdLFb1rAwCCMVFvHdTBfoD6HTQegbltGhdwjkQ+PvECoQiudJB
         SKRNGqOXEB2kF2ZVf2qCX1biZAaWtJawZh0E366EpIQ4SAIrWsXVO2ZBPpaWDzupv+RC
         TaMQybC2UB1JHLVfYACnBxKWlff5n5TZv8mwnhHgObgWNzrtct1UvpEaaP+EMi+/wDnr
         NuMA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1782311007; x=1782915807;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=Per6MI6n5CBZ4jce2Yah0coKW3mXxHCaIKwWKmwmsgQ=;
        b=psJUCsZ2cgHHzWkhV4dzPpHb/0QkhKLVaPfdFSzRHKrmksIkUlWpxEUFzkNOM8uV3F
         OEtzFA+ZWAqJnFt5NK9Lve6PcWjrfbKNf29X37PLpBmy8VxVUci18W2VpUKfk6bGH75r
         hAjuxfA0CJo9pr3B3mfkizJMYgg7Q4sHgW4OPsMoZ42AHLSqy35RYCLwmL53fTFwsEMS
         cl1spJI25JV95AZ/RdaYTp4js3H4EuinQbfaIjHeKV9p9uVxEXmsLSiOEcyR/1QZYTgJ
         PFFILAaiVhQ+nwhqxznIaVmQgQ/L9hU/fEHBRdG3tkg+Y4Z7s9/Lev1QYBdx0st2YJHQ
         6SMQ==
X-Forwarded-Encrypted: i=1; AHgh+Rp0clsq7rfD05nzIbEEMwwfgKbOI0me7bf4AQbtuTKPIJU4fJ78IjeJGIE3QqXB/TRej4NerhpT9A==@vger.kernel.org
X-Gm-Message-State: AOJu0YwhF2RwyV/COewZiCXAStggZRSEPkm1fxpcdZEstYKYwIge9yI4
	FIVE9e+fP25k3YmPvus5in0fS36mhJtMPzyAtfXgtowVOdtsdUi5H+ne
X-Gm-Gg: AfdE7cmP6r8m7Qp/kMTBkg4Jg/zQR4qCp/CsJTn0uXnzZGSi54OWmGZ8EJQC7SMdY7A
	clrHnear32CGfMdFOuiHYgU37Y0ERPhkdnKoArU7blMV1mmvilBa4ULNcyTJ9kK0WMyrQ/kBxll
	vKv6+MTvvVkdxusOPTuP+4vqXOnXREfWPP5ICQrbvrgSyutDGSMnMaYNiHM5+Nevtdwyk5v7ZVF
	xJXX34NvDMHduYAbNnAagBzml9lYjgkf4jVQJT/zKv7pYhI2HDEqpqepWCpbXMaHKWxH05JDrC2
	jTVLpCHD/EgLMtkoNkvlJBDJI8yMH96eX9liyw7pGoWqcbmPJrHH2tI3HqAaRbg+u+MY28/kH0z
	srFd3TVYmiOY3PgpxHJWWk4mzhwbOGb0QgHGDcTEOzs0jLcYpR4EWHfwiRlCgVchGoXk+3pLxhe
	EPApfuwz9zxrIrU6TpFHFManRkXMD3KyeRtrHLPE/hnCOoDtOLVg==
X-Received: by 2002:a05:6000:471a:b0:460:2e53:a6f6 with SMTP id ffacd0b85a97d-46d04583b35mr1261972f8f.12.1782311006854;
        Wed, 24 Jun 2026 07:23:26 -0700 (PDT)
Received: from pumpkin (82-69-66-36.dsl.in-addr.zen.co.uk. [82.69.66.36])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-46c221d9405sm8183744f8f.22.2026.06.24.07.23.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 24 Jun 2026 07:23:26 -0700 (PDT)
Date: Wed, 24 Jun 2026 15:23:24 +0100
From: David Laight <david.laight.linux@gmail.com>
To: Christian =?UTF-8?B?S8O2bmln?= <christian.koenig@amd.com>
Cc: Kaitao Cheng <kaitao.cheng@linux.dev>, Andrew Morton
 <akpm@linux-foundation.org>, David Hildenbrand <david@kernel.org>, Jens
 Axboe <axboe@kernel.dk>, Tejun Heo <tj@kernel.org>, Alexander Viro
 <viro@zeniv.linux.org.uk>, Christian Brauner <brauner@kernel.org>, Alexei
 Starovoitov <ast@kernel.org>, Daniel Borkmann <daniel@iogearbox.net>,
 Andrii Nakryiko <andrii@kernel.org>, Johannes Weiner <hannes@cmpxchg.org>,
 Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@redhat.com>,
 Arnaldo Carvalho de Melo <acme@kernel.org>, Namhyung Kim
 <namhyung@kernel.org>, Thomas Gleixner <tglx@kernel.org>, Juri Lelli
 <juri.lelli@redhat.com>, Vincent Guittot <vincent.guittot@linaro.org>, Paul
 Moore <paul@paul-moore.com>, Andy Shevchenko
 <andriy.shevchenko@linux.intel.com>, "Paul E. McKenney"
 <paulmck@kernel.org>, Shakeel Butt <shakeel.butt@linux.dev>, David Howells
 <dhowells@redhat.com>, Simona Vetter <simona.vetter@ffwll.ch>, Randy Dunlap
 <rdunlap@infradead.org>, Luca Ceresoli <luca.ceresoli@bootlin.com>, Philipp
 Stanner <phasta@kernel.org>, linux-block@vger.kernel.org,
 linux-kernel@vger.kernel.org, cgroups@vger.kernel.org,
 linux-ntfs-dev@lists.sourceforge.net, linux-fsdevel@vger.kernel.org,
 io-uring@vger.kernel.org, audit@vger.kernel.org, bpf@vger.kernel.org,
 netdev@vger.kernel.org, dri-devel@lists.freedesktop.org,
 linux-perf-users@vger.kernel.org, linux-trace-kernel@vger.kernel.org,
 kexec@lists.infradead.org, live-patching@vger.kernel.org,
 linux-modules@vger.kernel.org, linux-crypto@vger.kernel.org,
 linux-pm@vger.kernel.org, rcu@vger.kernel.org, sched-ext@lists.linux.dev,
 linux-mm@kvack.org, virtualization@lists.linux.dev, damon@lists.linux.dev,
 llvm@lists.linux.dev, Kaitao Cheng <chengkaitao@kylinos.cn>
Subject: Re: [PATCH v3 1/7] list: Add mutable iterator variants
Message-ID: <20260624152324.3def88ce@pumpkin>
In-Reply-To: <cf8467c7-b98f-44a5-9cf9-60b43b5da711@amd.com>
References: <20260622040533.29824-1-kaitao.cheng@linux.dev>
	<20260622040533.29824-2-kaitao.cheng@linux.dev>
	<20260622094242.64531b9a@pumpkin>
	<351a6b67-b394-4c58-aee2-88b6c8089ad5@linux.dev>
	<cf8467c7-b98f-44a5-9cf9-60b43b5da711@amd.com>
X-Mailer: Claws Mail 4.1.1 (GTK 3.24.38; arm-unknown-linux-gnueabihf)
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Action: no action
X-Spamd-Result: default: False [-1.66 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	MID_RHS_NOT_FQDN(0.50)[];
	DMARC_POLICY_ALLOW(-0.50)[gmail.com,none];
	R_SPF_ALLOW(-0.20)[+ip4:172.234.253.10:c];
	R_DKIM_ALLOW(-0.20)[gmail.com:s=20251104];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-13832-lists,io-uring=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	FROM_HAS_DN(0.00)[];
	FORGED_RECIPIENTS(0.00)[m:christian.koenig@amd.com,m:kaitao.cheng@linux.dev,m:akpm@linux-foundation.org,m:david@kernel.org,m:axboe@kernel.dk,m:tj@kernel.org,m:viro@zeniv.linux.org.uk,m:brauner@kernel.org,m:ast@kernel.org,m:daniel@iogearbox.net,m:andrii@kernel.org,m:hannes@cmpxchg.org,m:peterz@infradead.org,m:mingo@redhat.com,m:acme@kernel.org,m:namhyung@kernel.org,m:tglx@kernel.org,m:juri.lelli@redhat.com,m:vincent.guittot@linaro.org,m:paul@paul-moore.com,m:andriy.shevchenko@linux.intel.com,m:paulmck@kernel.org,m:shakeel.butt@linux.dev,m:dhowells@redhat.com,m:simona.vetter@ffwll.ch,m:rdunlap@infradead.org,m:luca.ceresoli@bootlin.com,m:phasta@kernel.org,m:linux-block@vger.kernel.org,m:linux-kernel@vger.kernel.org,m:cgroups@vger.kernel.org,m:linux-ntfs-dev@lists.sourceforge.net,m:linux-fsdevel@vger.kernel.org,m:io-uring@vger.kernel.org,m:audit@vger.kernel.org,m:bpf@vger.kernel.org,m:netdev@vger.kernel.org,m:dri-devel@lists.freedesktop.org,m:linux-perf-users@vger.kernel.org,m:linux-tra
 ce-kernel@vger.kernel.org,m:kexec@lists.infradead.org,m:live-patching@vger.kernel.org,m:linux-modules@vger.kernel.org,m:linux-crypto@vger.kernel.org,m:linux-pm@vger.kernel.org,m:rcu@vger.kernel.org,m:sched-ext@lists.linux.dev,m:linux-mm@kvack.org,m:virtualization@lists.linux.dev,m:damon@lists.linux.dev,m:llvm@lists.linux.dev,m:chengkaitao@kylinos.cn,s:lists@lfdr.de];
	FORGED_SENDER_MAILLIST(0.00)[];
	TO_DN_SOME(0.00)[];
	FORGED_SENDER(0.00)[davidlaightlinux@gmail.com,io-uring@vger.kernel.org];
	MIME_TRACE(0.00)[0:+];
	FORWARDED(0.00)[lists@lfdr.de];
	DKIM_TRACE(0.00)[gmail.com:+];
	ASN(0.00)[asn:63949, ipnet:172.234.224.0/19, country:SG];
	FREEMAIL_FROM(0.00)[gmail.com];
	FORGED_SENDER_FORWARDING(0.00)[];
	RCVD_COUNT_FIVE(0.00)[5];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[davidlaightlinux@gmail.com,io-uring@vger.kernel.org];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	RCPT_COUNT_GT_50(0.00)[52];
	FORGED_RECIPIENTS_FORWARDING(0.00)[];
	ALIAS_RESOLVED(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	TAGGED_RCPT(0.00)[io-uring];
	DBL_BLOCKED_OPENRESOLVER(0.00)[linux.dev:email,sea.lore.kernel.org:rdns,sea.lore.kernel.org:helo,pumpkin:mid,kylinos.cn:email,vger.kernel.org:from_smtp,amd.com:email]
X-Rspamd-Server: lfdr
X-Rspamd-Queue-Id: 7B0F56BF1DF

On Wed, 24 Jun 2026 15:23:47 +0200
Christian K=C3=B6nig <christian.koenig@amd.com> wrote:

> On 6/24/26 15:14, Kaitao Cheng wrote:
> >=20
> >=20
> > =E5=9C=A8 2026/6/22 16:42, David Laight =E5=86=99=E9=81=93: =20
> >> On Mon, 22 Jun 2026 12:05:31 +0800
> >> Kaitao Cheng <kaitao.cheng@linux.dev> wrote:
> >> =20
> >>> From: Kaitao Cheng <chengkaitao@kylinos.cn>
> >>>
> >>> The list_for_each*_safe() helpers are used when the loop body may
> >>> remove the current entry.  Their API exposes the temporary cursor at
> >>> every call site, even though most users only need it for the iterator
> >>> implementation and never reference it in the loop body.
> >>>
> >>> Add *_mutable() variants for list and hlist iteration.  The new helpe=
rs
> >>> support both forms: callers may keep passing an explicit temporary cu=
rsor
> >>> when they need to inspect or reset it, or omit it and let the helper =
use
> >>> a unique internal cursor. =20
> >>
> >> I'm not really sure 'mutable' means anything either.
> >> It is possible to make it valid for the loop body (or even other threa=
ds)
> >> to delete arbitrary list items - but that needs significant extra over=
heads.
> >>
> >> It might be worth doing something that doesn't need the extra variable,
> >> but there is little point doing all the churn just to rename things.
> >> =20
> >>>
> >>> This makes call sites that only mutate the list through the current e=
ntry
> >>> less noisy, while keeping the existing *_safe() helpers available for
> >>> compatibility.
> >>>
> >>> Signed-off-by: Kaitao Cheng <chengkaitao@kylinos.cn>
> >>> ---
> >>>  include/linux/list.h | 269 +++++++++++++++++++++++++++++++++++++----=
--
> >>>  1 file changed, 231 insertions(+), 38 deletions(-)
> >>>
> >>> diff --git a/include/linux/list.h b/include/linux/list.h
> >>> index 09d979976b3b..1081def7cea9 100644
> >>> --- a/include/linux/list.h
> >>> +++ b/include/linux/list.h
> >>> @@ -7,6 +7,7 @@
> >>>  #include <linux/stddef.h>
> >>>  #include <linux/poison.h>
> >>>  #include <linux/const.h>
> >>> +#include <linux/args.h>
> >>> =20
> >>>  #include <asm/barrier.h>
> >>> =20
> >>> @@ -763,28 +764,72 @@ static inline void list_splice_tail_init(struct=
 list_head *list,
> >>>  #define list_for_each_prev(pos, head) \
> >>>  	for (pos =3D (head)->prev; !list_is_head(pos, (head)); pos =3D pos-=
>prev)
> >>> =20
> >>> -/**
> >>> - * list_for_each_safe - iterate over a list safe against removal of =
list entry
> >>> - * @pos:	the &struct list_head to use as a loop cursor.
> >>> - * @n:		another &struct list_head to use as temporary storage
> >>> - * @head:	the head for your list.
> >>> +/*
> >>> + * list_for_each_safe is an old interface, use list_for_each_mutable=
 instead.
> >>>   */
> >>>  #define list_for_each_safe(pos, n, head) \
> >>>  	for (pos =3D (head)->next, n =3D pos->next; \
> >>>  	     !list_is_head(pos, (head)); \
> >>>  	     pos =3D n, n =3D pos->next)
> >>> =20
> >>> +#define __list_for_each_mutable_internal(pos, tmp, head)		\
> >>> +	for (typeof(pos) tmp =3D (pos =3D (head)->next)->next;		\ =20
> >>
> >> Use auto
> >> =20
> >>> +	     !list_is_head(pos, (head));				\
> >>> +	     pos =3D tmp, tmp =3D pos->next)
> >>> +
> >>> +#define __list_for_each_mutable1(pos, head)				\
> >>> +	__list_for_each_mutable_internal(pos, __UNIQUE_ID(next), head)
> >>> +
> >>> +#define __list_for_each_mutable2(pos, next, head)			\
> >>> +	list_for_each_safe(pos, next, head)
> >>> +
> >>>  /**
> >>> - * list_for_each_prev_safe - iterate over a list backwards safe agai=
nst removal of list entry
> >>> + * list_for_each_mutable - iterate over a list safe against entry re=
moval
> >>>   * @pos:	the &struct list_head to use as a loop cursor.
> >>> - * @n:		another &struct list_head to use as temporary storage
> >>> - * @head:	the head for your list.
> >>> + * @...:	either (head) or (next, head)
> >>> + *
> >>> + * next:	another &struct list_head to use as optional temporary stor=
age.
> >>> + *		The temporary cursor is internal unless explicitly supplied by
> >>> + *		the caller.
> >>> + * head:	the head for your list.
> >>> + */
> >>> +#define list_for_each_mutable(pos, ...)					\
> >>> +	CONCATENATE(__list_for_each_mutable, COUNT_ARGS(__VA_ARGS__))	\
> >>> +		(pos, __VA_ARGS__) =20
> >>
> >> The variable argument count logic really just slows down compilation.
> >> Maybe there aren't enough copies of this code to make that significant.
> >> But just because you can do it doesn't mean it is a gooD idea.
> >> I'm also not sure it really adds anything to the readability.
> >>
> >> And, it you are going to make the middle argument optional there is
> >> no need to change the macro name. =20
> >=20
> > Christian K=C3=B6nig and Jani Nikula also disagree with the variadic-ar=
gument
> > implementation approach. If we abandon that method, it means we will
> > inevitably need to add some new macros. If mutable is not a good name,
> > suggestions for better alternatives would be welcome; coming up with a
> > suitable name is indeed rather tricky. =20
>=20
> I don't think you need to add a new macro for the specific use case that =
people want to modify the next element of the iteration.
>=20
> If I remember your numbers correctly that is a really corner case and kee=
ping using the existing *_safe() macros for that sounds perfectly fine to m=
e.

IIRC currently you have a choice of either:
	define               Item that can't be deleted
	list_for_each()	     The current item.
	list_for_each_safe() The next item.
There is also likely to be code that updates the variables to allow
for other scenarios.

Note that if increase a reference count and release a lock then list_for_ea=
ch()
is likely safer than list_for_each_safe() :-)

list.h has 9 variants of the 'safe' loop.
The bloat of another 9 is getting excessive.

It has to be said that this is one of my least favourite type of list...

	David

>=20
> Regards,
> Christian.


