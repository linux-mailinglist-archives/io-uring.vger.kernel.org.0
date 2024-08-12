Return-Path: <io-uring+bounces-2722-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 2B94E94F808
	for <lists+io-uring@lfdr.de>; Mon, 12 Aug 2024 22:15:59 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id AEA791F2144F
	for <lists+io-uring@lfdr.de>; Mon, 12 Aug 2024 20:15:58 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B6392183CA5;
	Mon, 12 Aug 2024 20:15:54 +0000 (UTC)
X-Original-To: io-uring@vger.kernel.org
Received: from cloud48395.mywhc.ca (cloud48395.mywhc.ca [173.209.37.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6EA0F15C143
	for <io-uring@vger.kernel.org>; Mon, 12 Aug 2024 20:15:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=173.209.37.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723493754; cv=none; b=oVblsk59kzNQoIN3vyMsMdNQc/b2fka6jWOOZORoZpiJ0lMLWe5ql9HgpvvzZnrm0okHfVXG5fut5lco1+aIZkZqkSU8/jPL5uV+dQFsrTu/QThmKNyiRcrl4ccCB3A0YBFuMIh0/l5cMNqI4U0W21ZbiPqtsfM43ZvF/HpN9tQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723493754; c=relaxed/simple;
	bh=lgzBobEMMlCeH7Sm5AT9WbuZVom2P0On/nya7F+Xzyo=;
	h=Message-ID:Subject:From:To:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=qBxl6w/xarDZDFL/nRw213erZ2CAsDiYVs1fdE62mYuH5Srmt07Nn2FPrmLAZm87ABqu4nCgWL5oFAt4ZHK0WupzjFWZHWEu6Euou6PCAjxQ8VM3nePPUOMbJbGZdB3OxFKmD3gOMHExLrS08FvsXGItXi97PX78/dG1LsonRq4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=trillion01.com; spf=pass smtp.mailfrom=trillion01.com; arc=none smtp.client-ip=173.209.37.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=trillion01.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=trillion01.com
Received: from [45.44.224.220] (port=44638 helo=[192.168.1.177])
	by cloud48395.mywhc.ca with esmtpsa  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.96.2)
	(envelope-from <olivier@trillion01.com>)
	id 1sdbSC-00022h-1i;
	Mon, 12 Aug 2024 16:15:44 -0400
Message-ID: <8887f2d97c1dafb6ceaf9f5c492457f642f532dd.camel@trillion01.com>
Subject: Re: [PATCH] io_uring/napi: remove duplicate io_napi_entry timeout
 assignation
From: Olivier Langlois <olivier@trillion01.com>
To: Jens Axboe <axboe@kernel.dk>, Pavel Begunkov <asml.silence@gmail.com>, 
	io-uring@vger.kernel.org
Date: Mon, 12 Aug 2024 16:15:43 -0400
In-Reply-To: <f1397b51-8d41-4f91-aa25-37f771fe4e13@kernel.dk>
References: 
	<145b54ff179f87609e20dffaf5563c07cdbcad1a.1723423275.git.olivier@trillion01.com>
	 <05255cc5136254574b884b5e10aae7cf8301662a.camel@trillion01.com>
	 <8c1ee6ab-8425-4d13-80f5-ff085d12dc91@kernel.dk>
	 <f1397b51-8d41-4f91-aa25-37f771fe4e13@kernel.dk>
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
User-Agent: Evolution 3.52.4 
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

On Mon, 2024-08-12 at 12:11 -0600, Jens Axboe wrote:
> On 8/12/24 12:10 PM, Jens Axboe wrote:
> > On 8/11/24 7:00 PM, Olivier Langlois wrote:
> > > On Sun, 2024-08-11 at 20:34 -0400, Olivier Langlois wrote:
> > > > io_napi_entry() has 2 calling sites. One of them is unlikely to
> > > > find
> > > > an
> > > > entry and if it does, the timeout should arguable not be
> > > > updated.
> > > >=20
> > > > The other io_napi_entry() calling site is overwriting the
> > > > update made
> > > > by io_napi_entry() so the io_napi_entry() timeout value update
> > > > has no
> > > > or
> > > > little value and therefore is removed.
> > > >=20
> > > > Signed-off-by: Olivier Langlois <olivier@trillion01.com>
> > > > ---
> > > > =A0io_uring/napi.c | 1 -
> > > > =A01 file changed, 1 deletion(-)
> > > >=20
> > > > diff --git a/io_uring/napi.c b/io_uring/napi.c
> > > > index 73c4159e8405..1de1d4d62925 100644
> > > > --- a/io_uring/napi.c
> > > > +++ b/io_uring/napi.c
> > > > @@ -26,7 +26,6 @@ static struct io_napi_entry
> > > > *io_napi_hash_find(struct hlist_head *hash_list,
> > > > =A0	hlist_for_each_entry_rcu(e, hash_list, node) {
> > > > =A0		if (e->napi_id !=3D napi_id)
> > > > =A0			continue;
> > > > -		e->timeout =3D jiffies + NAPI_TIMEOUT;
> > > > =A0		return e;
> > > > =A0	}
> > > > =A0
> > > I am commenting my own patch because I found something curious
> > > that I
> > > was not sure about when I was reviewing the code.
> > >=20
> > > Should the remaining e->timeout assignation be wrapped with a
> > > WRITE_ONCE() macro to ensure an atomic store?
> >=20
> > I think that makes sense to do as lookup can be within rcu, and
> > hence we have nothing serializing it. Not for torn writes, but to
> > ensure that the memory sanitizer doesn't complain. I can just make
> > this change while applying, or send a v2.
>=20
> As a separate patch I mean, not a v2. That part can wait until 6.12.
>=20
ok. np. I'll look into it soon.

In the meantime, I have detected few suspicious things in the napi
code.

I am reporting them here to have few extra eye balls looking at them to
be sure that everything is fine or not.

1. in __io_napi_remove_stale(),

is it ok to use hash_for_each() instead of hash_for_each_safe()?

it might be ok because it is a hash_del_rcu() and not a simple
hash_del() but I have little experience with possible RCU shortcuts so
I am unsure on this one...

2. in io_napi_free()

list_del(&e->list); is not called. Can the only reason be that
io_napi_free() is called as part of the ring destruction so it is an
optimization to not clear the list since it is not expected to be
reused?

would calling INIT_LIST_HEAD() before exiting as an extra precaution to
make the function is future proof in case it is reused in another
context than the ring destruction be a good idea?

3. I am surprised to notice that in __io_napi_do_busy_loop(),
list_for_each_entry_rcu() is called to traverse the list but the
regular methods list_del() and list_add_tail() are called to update the
list instead of their RCU variant.

Is this ok?

if it is, the only plausible explanation that can think of is that it
is paired with another RCU hash table update... I guess maybe this is a
common RCU idiom that I am unaware of and this is why this is even not
derserving a small comment to address this point, I would think that
this might deserve one. This setup leaves me perplexed...


