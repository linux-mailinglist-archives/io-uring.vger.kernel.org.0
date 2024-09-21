Return-Path: <io-uring+bounces-3256-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 7366797DD65
	for <lists+io-uring@lfdr.de>; Sat, 21 Sep 2024 15:52:07 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id CC0D5B21A45
	for <lists+io-uring@lfdr.de>; Sat, 21 Sep 2024 13:52:04 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 671BB16C453;
	Sat, 21 Sep 2024 13:51:58 +0000 (UTC)
X-Original-To: io-uring@vger.kernel.org
Received: from cloud48395.mywhc.ca (cloud48395.mywhc.ca [173.209.37.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 45A91137E
	for <io-uring@vger.kernel.org>; Sat, 21 Sep 2024 13:51:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=173.209.37.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726926718; cv=none; b=mESEMOYM3HbV/qygnriiuxiRaVcTckbH9aVJXTDVZFAcSqhk4qTbG1Px6PG2GHVZ0dghlt0zEOiYi5O0Ok91FPAm6wWg8ixjfMtg4s2H+QSAVtzsRYDkSf5rfmskMMRbOSWDPcEeOAhAaB6j/tcPSiCzWubgnsjZlwgSsxYxwb8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726926718; c=relaxed/simple;
	bh=DCkRfWSV4qcBsGeU/EI7UEquS4fIFbYYpvxXf/UHuo4=;
	h=Message-ID:Subject:From:To:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=puRm5PwWMc9akxq8sOo6MLWTunq8PGeL8svcmkFXYBkYw+cWjrd4sSl0g7tV4v/EcVrQT4ULMS8UgHK5gmcdM9EyG2IqZbBavYZAe/Xd8myeliazIIGgfq/6GU7sM8bam9D2LRiYVNjfJHC00Q/yB3z9X+3UR3tn0e8Nv9qTpdg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=trillion01.com; spf=pass smtp.mailfrom=trillion01.com; arc=none smtp.client-ip=173.209.37.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=trillion01.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=trillion01.com
Received: from [45.44.224.220] (port=55376 helo=[192.168.1.177])
	by cloud48395.mywhc.ca with esmtpsa  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.96.2)
	(envelope-from <olivier@trillion01.com>)
	id 1ss0Wg-00009r-31;
	Sat, 21 Sep 2024 09:51:54 -0400
Message-ID: <bba408eb1f0b42e44a58be467454c7065c0dd534.camel@trillion01.com>
Subject: Re: [PATCH v3 3/3] io_uring/napi: add static napi tracking strategy
From: Olivier Langlois <olivier@trillion01.com>
To: Jens Axboe <axboe@kernel.dk>, Pavel Begunkov <asml.silence@gmail.com>, 
	io-uring@vger.kernel.org
Date: Sat, 21 Sep 2024 09:51:54 -0400
In-Reply-To: <050c85eb-177f-4ef5-93ed-b5d1179b4015@kernel.dk>
References: <cover.1726589775.git.olivier@trillion01.com>
	 <edca1df43f5114f91f9d8ea95e2e8769ec6792b4.1726589775.git.olivier@trillion01.com>
	 <050c85eb-177f-4ef5-93ed-b5d1179b4015@kernel.dk>
Autocrypt: addr=olivier@trillion01.com; prefer-encrypt=mutual;
 keydata=mQINBFYd0ycBEAC53xedP1NExPwtBnDkVuMZgRiLmWoQQ8U7vEwt6HVGSsMRHx9smD76i
 5rO/iCT6tDIpZoyJsTOh1h2NTn6ZkoFSn9lNOJksE77/n7HNaNxiBfvZHsuNuI53CkYFix9JhzP3t
 g5nV/401re30kRfA8OPivpnj6mZhU/9RTwjbVPPb8dPlm2gFLXwGPeDITgSRs+KJ0mM37fW8EatJs
 0a8J1Nk8wBvT7ce+S2lOrxDItra9pW3ukze7LMirwvdMRC5bdlw2Lz03b5NrOUq+Wxv7szn5Xr9f/
 HdaCH7baWNAO6H/O5LbJ3zndewokEmKk+oCIcXjaH0U6QK5gJoO+3Yt5dcTo92Vm3VMxzK2NPFXgp
 La7lR9Ei0hzQ0zptyFFyftt9uV71kMHldaQaSfUTsu9dJbnS2kI/j+F2S1q6dgKi3DEm0ZRGvjsSG
 rkgPJ5T16GI1cS2iQntawdr0A1vfXiB9xZ1SMGxL/l6js9BVlIx/CBGOJ4L190QmxJlcAZ2VnQzrl
 ramRUv01xb00IPJ5TBft5IJ+SY0FnY9pIERIl6w9khwLt/oGuKNmUHmzJGYoJHYfh72Mm8RQ1R/JS
 o6v85ULBGdEC3pQq1j//OPyH3egiXIwFq6BtULH5CvsxQkSqgj1MpjwfgVJ8VbjNwqwBXHjooEORj
 vFQqWQki6By3QARAQABtDJPbGl2aWVyIExhbmdsb2lzIChNeSBrZXkpIDxvbGl2aWVyQHRyaWxsaW
 9uMDEuY29tPokCNwQTAQgAIQUCVh3TJwIbAwULCQgHAwUVCgkICwUWAgMBAAIeAQIXgAAKCRBlaka
 GGsWHEI1AD/9sbj+vnFU29WemVqB4iW+9RrHIcbXI4Jg8WaffTQ8KvVeCJ4otzgVT2nHC2A82t4PF
 0tp21Ez17CKDNilMvOt8zq6ZHx36CPjoqUVjAdozOiBDpC4qB6ZKYn+gqSENO4hqmmaOW57wT9vII
 v6mtHmnFvgpOEJl6wbs8ArHDt0BLSjc8QQfvBhoKoWs+ijQTyvFGlQl0oWxEbUkR1J3gdft9Oj9xQ
 G4OFo73WaSEK/L9IalU2ulCBC+ucSP9McoDxy1i1u8HUDrV5wBY1zafc9zVBcMNH6+ZjxwQmZXqtz
 ATzB3RbSFHAdmvxl8q6MeS2yx7Atk0CXgW9z5k2KeuZhz5rVV5A+D19SSGzW11uYXsibZx/Wjr9xB
 KHB6U7qh5sRHaQS191NPonKcsXXAziR+vxwQTP7ZKfy+g5N/e6uivoUnQrl9uvUDDPXEpwVNSoVws
 Vn4tNyrGEdN11pHDbH5fSGzdpbY8+yczUoxMmsEQe/fpVwRBZUqafRn2TVUhV0qqzsUuQcTNw1zIZ
 JgvkqrHgd4ivd2b1bXBczmu/wMGpEnF6cWzSQDiwC1NF3i+gHCuD8IX1ujThWtzXsn0VtrMkrRCbn
 ponVQ6HcbRYYXPuK0HRRjCSuAKo5porVONepiOSmu0FBrpGqBkpBtLrzKXoi1yt/7a/wGdMcVhYGg
 vA==
Organization: Trillion01 Inc
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.54.0 
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - cloud48395.mywhc.ca
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - trillion01.com
X-Get-Message-Sender-Via: cloud48395.mywhc.ca: authenticated_id: olivier@trillion01.com
X-Authenticated-Sender: cloud48395.mywhc.ca: olivier@trillion01.com
X-Source: 
X-Source-Args: 
X-Source-Dir: 

On Wed, 2024-09-18 at 20:59 -0600, Jens Axboe wrote:
> On 9/18/24 6:59 AM, Olivier Langlois wrote:
> > add the static napi tracking strategy that allows the user to
> > manually
> > manage the napi ids list to busy poll and offload the ring from
> > dynamically update the list.
>=20
> Add the static napi tracking strategy. That allows the user to
> manually
> manage the napi ids list for busy polling, and eliminate the overhead
> of
> dynamically updating the list from the fast path.
>=20
> Maybe?

ok
>=20
> > index b1e0e0d85349..6f0e40e1469c 100644
> > --- a/io_uring/fdinfo.c
> > +++ b/io_uring/fdinfo.c
> > @@ -46,6 +46,46 @@ static __cold int io_uring_show_cred(struct
> > seq_file *m, unsigned int id,
> > =A0	return 0;
> > =A0}
> > =A0
> > +#ifdef CONFIG_NET_RX_BUSY_POLL
> > +static __cold void common_tracking_show_fdinfo(struct io_ring_ctx
> > *ctx,
> > +					=A0=A0=A0=A0=A0=A0 struct seq_file *m,
> > +					=A0=A0=A0=A0=A0=A0 const char
> > *tracking_strategy)
> > +{
> > +	seq_puts(m, "NAPI:\tenabled\n");
> > +	seq_printf(m, "napi tracking:\t%s\n", tracking_strategy);
> > +	seq_printf(m, "napi_busy_poll_dt:\t%llu\n", ctx-
> > >napi_busy_poll_dt);
> > +	if (ctx->napi_prefer_busy_poll)
> > +		seq_puts(m, "napi_prefer_busy_poll:\ttrue\n");
> > +	else
> > +		seq_puts(m, "napi_prefer_busy_poll:\tfalse\n");
> > +}
> > +
> > +static __cold void napi_show_fdinfo(struct io_ring_ctx *ctx,
> > +				=A0=A0=A0 struct seq_file *m)
> > +{
> > +	unsigned int mode =3D READ_ONCE(ctx->napi_track_mode);
> > +
> > +	switch (mode) {
> > +	case IO_URING_NAPI_TRACKING_INACTIVE:
> > +		seq_puts(m, "NAPI:\tdisabled\n");
> > +		break;
> > +	case IO_URING_NAPI_TRACKING_DYNAMIC:
> > +		common_tracking_show_fdinfo(ctx, m, "dynamic");
> > +		break;
> > +	case IO_URING_NAPI_TRACKING_STATIC:
> > +		common_tracking_show_fdinfo(ctx, m, "static");
> > +		break;
> > +	default:
> > +		seq_printf(m, "NAPI:\tunknown mode (%u)\n", mode);
> > +	}
> > +}
> > +#else
> > +static inline void napi_show_fdinfo(struct io_ring_ctx *ctx,
> > +				=A0=A0=A0 struct seq_file *m)
> > +{
> > +}
> > +#endif
>=20
> I think this code should go in napi.c, with the stub
> CONFIG_NET_RX_BUSY_POLL in napi.h. Not a huge deal.
>=20
> This also conflicts with your previous napi patch adding fdinfo
> support.
> What kernel is this patchset based on? You should rebase it
> for-6.12/io_uring, then it should apply to the development branch
> going
> forward too.

The repo used is Linus head. Yes I was surprised to not see my own
patch there. Kernel dev process is still a bit obscure to me... but I
figured that the conflict would be very trivial to solve. Basically,
simply drop the previous patch to replace it with this one.

but yes. I can rebase the patch into your repo. Can you provide me the
URL of your repo?

About your suggestion to move stuff in napi.h. I did though about it.
In fact, the code was there at some point before submission (or in v1).
but I did conclude the exact opposite. That it would be cleaner to keep
the fdinfo stuff together instead of polluting napi TU with it...

with this argument, if you still prefer to see that code in napi TU, I
will move it there.
>=20
> > diff --git a/io_uring/napi.c b/io_uring/napi.c
> > index 6fc127e74f10..d98b87d346ca 100644
> > --- a/io_uring/napi.c
> > +++ b/io_uring/napi.c
> > @@ -38,22 +38,14 @@ static inline ktime_t net_to_ktime(unsigned
> > long t)
> > =A0	return ns_to_ktime(t << 10);
> > =A0}
> > =A0
> > -void __io_napi_add(struct io_ring_ctx *ctx, struct socket *sock)
> > +int __io_napi_add_id(struct io_ring_ctx *ctx, unsigned int
> > napi_id)
> > =A0{
> > =A0	struct hlist_head *hash_list;
> > -	unsigned int napi_id;
> > -	struct sock *sk;
> > =A0	struct io_napi_entry *e;
> > =A0
> > -	sk =3D sock->sk;
> > -	if (!sk)
> > -		return;
> > -
> > -	napi_id =3D READ_ONCE(sk->sk_napi_id);
> > -
> > =A0	/* Non-NAPI IDs can be rejected. */
> > =A0	if (napi_id < MIN_NAPI_ID)
> > -		return;
> > +		return -EINVAL;
> > =A0
> > =A0	hash_list =3D &ctx->napi_ht[hash_min(napi_id, HASH_BITS(ctx-
> > >napi_ht))];
> > =A0
> > @@ -62,13 +54,13 @@ void __io_napi_add(struct io_ring_ctx *ctx,
> > struct socket *sock)
> > =A0	if (e) {
> > =A0		WRITE_ONCE(e->timeout, jiffies + NAPI_TIMEOUT);
> > =A0		rcu_read_unlock();
> > -		return;
> > +		return -EEXIST;
> > =A0	}
> > =A0	rcu_read_unlock();
> > =A0
> > =A0	e =3D kmalloc(sizeof(*e), GFP_NOWAIT);
> > =A0	if (!e)
> > -		return;
> > +		return -ENOMEM;
> > =A0
> > =A0	e->napi_id =3D napi_id;
> > =A0	e->timeout =3D jiffies + NAPI_TIMEOUT;
> > @@ -77,12 +69,37 @@ void __io_napi_add(struct io_ring_ctx *ctx,
> > struct socket *sock)
> > =A0	if (unlikely(io_napi_hash_find(hash_list, napi_id))) {
> > =A0		spin_unlock(&ctx->napi_lock);
> > =A0		kfree(e);
> > -		return;
> > +		return -EEXIST;
> > =A0	}
>=20
> You could abstract this out to a prep patch, having __io_napi_add()
> return an error value. That would leave the meat of your patch
> simpler
> and easier to review.

ok
>=20
> > +static int __io_napi_del_id(struct io_ring_ctx *ctx, unsigned int
> > napi_id)
> > +{
> > +	struct hlist_head *hash_list;
> > +	struct io_napi_entry *e;
> > +
> > +	/* Non-NAPI IDs can be rejected. */
> > +	if (napi_id < MIN_NAPI_ID)
> > +		return -EINVAL;
> > +
> > +	hash_list =3D &ctx->napi_ht[hash_min(napi_id, HASH_BITS(ctx-
> > >napi_ht))];
> > +	spin_lock(&ctx->napi_lock);
> > +	e =3D io_napi_hash_find(hash_list, napi_id);
> > +	if (unlikely(!e)) {
> > +		spin_unlock(&ctx->napi_lock);
> > +		return -ENOENT;
> > +	}
> > +
> > +	list_del_rcu(&e->list);
> > +	hash_del_rcu(&e->node);
> > +	kfree_rcu(e, rcu);
> > +	spin_unlock(&ctx->napi_lock);
> > +	return 0;
> > =A0}
>=20
> For new code, not a bad idea to use:
>=20
> 	guard(spinlock)(&ctx->napi_lock);
>=20
> Only one cleanup path here, but...

first time I hear about this... Some sort of RAII where the compiler
adds automatically unlock function call at every exit points?

ok, I'll look into it
>=20
> > =A0static void __io_napi_remove_stale(struct io_ring_ctx *ctx)
> > @@ -141,8 +158,26 @@ static bool io_napi_busy_loop_should_end(void
> > *data,
> > =A0	return false;
> > =A0}
> > =A0
> > -static bool __io_napi_do_busy_loop(struct io_ring_ctx *ctx,
> > -				=A0=A0 void *loop_end_arg)
> > +/*
> > + * never report stale entries
> > + */
> > +static bool static_tracking_do_busy_loop(struct io_ring_ctx *ctx,
> > +					 void *loop_end_arg)
> > +{
> > +	struct io_napi_entry *e;
> > +	bool (*loop_end)(void *, unsigned long) =3D NULL;
> > +
> > +	if (loop_end_arg)
> > +		loop_end =3D io_napi_busy_loop_should_end;
> > +
> > +	list_for_each_entry_rcu(e, &ctx->napi_list, list)
> > +		napi_busy_loop_rcu(e->napi_id, loop_end,
> > loop_end_arg,
> > +				=A0=A0 ctx->napi_prefer_busy_poll,
> > BUSY_POLL_BUDGET);
> > +	return false;
> > +}
> > +
> > +static bool dynamic_tracking_do_busy_loop(struct io_ring_ctx *ctx,
> > +					=A0 void *loop_end_arg)
> > =A0{
> > =A0	struct io_napi_entry *e;
> > =A0	bool (*loop_end)(void *, unsigned long) =3D NULL;
>=20
> This is somewhat convoluted, but I think it'd be cleaner to have a
> prep
> patch that just passes in both loop_end and loop_end_arg to the
> caller?
> Some of this predates your changes here, but seems there's room for
> cleaning this up. What do you think?

I am not sure that I see your point that it would make the code
cleaner. TBH, I did not fully understood what was the point of the
whole loop_end business thing but since it was unrelated to my changes,
I did leave that thing undisturbed.

I'll take a second look at it to see if I can clean this up a bit...
>=20
> > diff --git a/io_uring/napi.h b/io_uring/napi.h
> > index 27b88c3eb428..220574522484 100644
> > --- a/io_uring/napi.h
> > +++ b/io_uring/napi.h
> > @@ -54,13 +54,20 @@ static inline void io_napi_add(struct io_kiocb
> > *req)
> > =A0{
> > =A0	struct io_ring_ctx *ctx =3D req->ctx;
> > =A0	struct socket *sock;
> > +	struct sock *sk;
> > =A0
> > -	if (!READ_ONCE(ctx->napi_enabled))
> > +	if (READ_ONCE(ctx->napi_track_mode) !=3D
> > IO_URING_NAPI_TRACKING_DYNAMIC)
> > =A0		return;
> > =A0
> > =A0	sock =3D sock_from_file(req->file);
> > -	if (sock)
> > -		__io_napi_add(ctx, sock);
> > +	if (!sock)
> > +		return;
> > +
> > +	sk =3D sock->sk;
> > +	if (!sk)
> > +		return;
> > +
> > +	__io_napi_add_id(ctx, READ_ONCE(sk->sk_napi_id));
> > =A0}
>=20
> I like having this follow the expected outcome, which is that sock
> and
> sk are valid.
>=20
> 	sock =3D sock_from_file(req->file);
> 	if (sock && sock->sk)
> 		__io_napi_add_id(ctx, READ_ONCE(sock->sk-
> >sk_napi_id));
>=20
> or something like that. At least to me that's more readable.
>=20
ok.

All those points will be addressed in v4



