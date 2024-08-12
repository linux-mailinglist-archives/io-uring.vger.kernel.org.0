Return-Path: <io-uring+bounces-2726-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 1ABB494F907
	for <lists+io-uring@lfdr.de>; Mon, 12 Aug 2024 23:39:53 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 9971BB2223B
	for <lists+io-uring@lfdr.de>; Mon, 12 Aug 2024 21:39:50 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D8C63194A49;
	Mon, 12 Aug 2024 21:39:47 +0000 (UTC)
X-Original-To: io-uring@vger.kernel.org
Received: from cloud48395.mywhc.ca (cloud48395.mywhc.ca [173.209.37.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BD6E614EC59
	for <io-uring@vger.kernel.org>; Mon, 12 Aug 2024 21:39:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=173.209.37.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723498787; cv=none; b=nntFkwhi/oBtJcz2hH6K0x9CEpH+vSmG1aYYX/5ADLST4ZNS564FH5gpjMx8bvaIx0VL4mbw48SfjCx/yg1zIkCdVx2YDdm588/2V4E/ecHQFah8OfJL/eaCZmkTD47WE+PfoLa7RxJ1CID2UohCLI9B2iZJuj2gEveyffMg9Fw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723498787; c=relaxed/simple;
	bh=UfuYOVysLEJ1HjT4Erh8ZMOuc3CXzl0pswdY7k9+D9U=;
	h=Message-ID:Subject:From:To:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=bF2mtwzdx31OwFxjrZbpheKNfFra3RJKxxZgF3t9oyXG5PxH/Sp6vmrr7flgsJM3C4eKy62lsxUu8LyUueYR/4j400VTzSbjzB8iUHNCNUu2AlMw/1V3CEBilTP6KKXRc02jxXRlEABG0+4FD+lKsPLGLbko3e1l6GzNg5N9NVE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=trillion01.com; spf=pass smtp.mailfrom=trillion01.com; arc=none smtp.client-ip=173.209.37.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=trillion01.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=trillion01.com
Received: from [45.44.224.220] (port=52594 helo=[192.168.1.177])
	by cloud48395.mywhc.ca with esmtpsa  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.96.2)
	(envelope-from <olivier@trillion01.com>)
	id 1sdclU-0006zE-0r;
	Mon, 12 Aug 2024 17:39:44 -0400
Message-ID: <01e64ae408b55f2c35e2ae7229e2af8ddde220d7.camel@trillion01.com>
Subject: Re: [PATCH] io_uring/napi: remove duplicate io_napi_entry timeout
 assignation
From: Olivier Langlois <olivier@trillion01.com>
To: Jens Axboe <axboe@kernel.dk>, Pavel Begunkov <asml.silence@gmail.com>, 
	io-uring@vger.kernel.org
Date: Mon, 12 Aug 2024 17:39:43 -0400
In-Reply-To: <5730c0c1-73cb-42b5-8af3-afe60529f57d@kernel.dk>
References: 
	<145b54ff179f87609e20dffaf5563c07cdbcad1a.1723423275.git.olivier@trillion01.com>
	 <05255cc5136254574b884b5e10aae7cf8301662a.camel@trillion01.com>
	 <8c1ee6ab-8425-4d13-80f5-ff085d12dc91@kernel.dk>
	 <f1397b51-8d41-4f91-aa25-37f771fe4e13@kernel.dk>
	 <8887f2d97c1dafb6ceaf9f5c492457f642f532dd.camel@trillion01.com>
	 <5730c0c1-73cb-42b5-8af3-afe60529f57d@kernel.dk>
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

On Mon, 2024-08-12 at 14:40 -0600, Jens Axboe wrote:
>=20
> >=20
> > 1. in __io_napi_remove_stale(),
> >=20
> > is it ok to use hash_for_each() instead of hash_for_each_safe()?
> >=20
> > it might be ok because it is a hash_del_rcu() and not a simple
> > hash_del() but I have little experience with possible RCU shortcuts
> > so
> > I am unsure on this one...
>=20
> Should use hash_for_each_rcu(), and I think for good measure, we
> sould
> just keep it inside the RCU region. Then we know for a fact that the
> deletion doesn't run.

ok, after confirming that it was NOT paranoia, I did push further the
investigation.

hash_for_each_rcu() is meant for the readers. A writer can modify the
container as long as it protects the container against concurrent
writes with locks.

in include/linux/hashtable.h:
static inline void hash_del_rcu(struct hlist_node *node)
{
	hlist_del_init_rcu(node);
}

in include/linux/rculist.h:
static inline void hlist_del_init_rcu(struct hlist_node *n)
{
        if (!hlist_unhashed(n)) {
                __hlist_del(n);
                WRITE_ONCE(n->pprev, NULL);
        }
}

in include/linux/list.h:
static inline void __hlist_del(struct hlist_node *n)
{
	struct hlist_node *next =3D n->next;
	struct hlist_node **pprev =3D n->pprev;

	WRITE_ONCE(*pprev, next);
	if (next)
		WRITE_ONCE(next->pprev, pprev);
}

it seems we are ok since the deleted node next pointer is not reset.
the problem might arise if the next action after removing the node is
to kfree it. we are fine because kfree_rcu() must be defering the
actual free.

That being said, I recommend to replace hash_for_each_rcu() with
hash_for_each_safe() to make everyone sleep better at night...

based on this new info, I'll let you decide which macro to use and I
volunteer to make that change.

>=20
> > 2. in io_napi_free()
> >=20
> > list_del(&e->list); is not called. Can the only reason be that
> > io_napi_free() is called as part of the ring destruction so it is
> > an
> > optimization to not clear the list since it is not expected to be
> > reused?
> >=20
> > would calling INIT_LIST_HEAD() before exiting as an extra
> > precaution to
> > make the function is future proof in case it is reused in another
> > context than the ring destruction be a good idea?
>=20
> I think that's just an oversight, and doesn't matter since it's all
> going away anyway. But it would be prudent to delete it regardless!

ok. I did ask because I am in the process of adding a call to
io_napi_free() in the context of a super new cool patch that I am
working on.. I'll call INIT_LIST_HEAD() to reset the list (or its RCU
variant if it exists).
>=20
> > 3. I am surprised to notice that in __io_napi_do_busy_loop(),
> > list_for_each_entry_rcu() is called to traverse the list but the
> > regular methods list_del() and list_add_tail() are called to update
> > the
> > list instead of their RCU variant.
>=20
> Should all just use rcu variants.
>=20
> Here's a mashup of the changes. Would be great if you can test - I'll
> do
> some too, but always good with more than one person testing as it
> tends
> to hit more cases.

I am so glag to have asked. It is going to be a pleasure to test this
and report back the result.

but it appears that my napi_list is very *static* (wink, wink)



