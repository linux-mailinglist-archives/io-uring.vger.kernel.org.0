Return-Path: <io-uring+bounces-2758-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 893609510E0
	for <lists+io-uring@lfdr.de>; Wed, 14 Aug 2024 02:09:50 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 5A4271C21372
	for <lists+io-uring@lfdr.de>; Wed, 14 Aug 2024 00:09:49 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 40776197;
	Wed, 14 Aug 2024 00:09:47 +0000 (UTC)
X-Original-To: io-uring@vger.kernel.org
Received: from cloud48395.mywhc.ca (cloud48395.mywhc.ca [173.209.37.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F3B5C195
	for <io-uring@vger.kernel.org>; Wed, 14 Aug 2024 00:09:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=173.209.37.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723594187; cv=none; b=pIH3REJh98BBedzqVJZOgt3EvPrPDpHlP1n/yaP0Z103+qsy1xFLxnOLsWmOABIjy1xhcI6295rKnVLZZ306s0hxsVhEEz2r+DhNzt0X/nTmh64bnMDdn6+YewnzS7r6hVrG7GG/cxO4iev+NrQOWZLnfI4EJPPnZnFa8BTNJkc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723594187; c=relaxed/simple;
	bh=w5BRKB/qXJqkIiZknMLkaY1g+GowXtdrpHVYYWiXp/8=;
	h=Message-ID:Subject:From:To:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=f+RKTXbC4uJlPpvoYblDsqiWwO9lLKqesRKOO0u6hmxsm6ftI1DtA4MWzpOz7+h0bTORHbw5/uESUiIgbJrVgiul97ahm24ZeZN72px+CcmRHxl1A7ib0KtxOo5lEjwmxJJ/bp/zCRT2aIfxriMlXr1CtdS1QEmefdEmClQidYE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=trillion01.com; spf=pass smtp.mailfrom=trillion01.com; arc=none smtp.client-ip=173.209.37.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=trillion01.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=trillion01.com
Received: from [45.44.224.220] (port=58188 helo=[192.168.1.177])
	by cloud48395.mywhc.ca with esmtpsa  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.96.2)
	(envelope-from <olivier@trillion01.com>)
	id 1se1aB-0003mc-12;
	Tue, 13 Aug 2024 20:09:43 -0400
Message-ID: <a01899e4b4e6f83f5d191a1a26615655d97a4718.camel@trillion01.com>
Subject: Re: [PATCH] io_uring/napi: remove duplicate io_napi_entry timeout
 assignation
From: Olivier Langlois <olivier@trillion01.com>
To: Jens Axboe <axboe@kernel.dk>, Pavel Begunkov <asml.silence@gmail.com>, 
	io-uring@vger.kernel.org
Date: Tue, 13 Aug 2024 20:09:42 -0400
In-Reply-To: <bea51c28-17e0-4693-96bf-502ffa75f01a@kernel.dk>
References: 
	<145b54ff179f87609e20dffaf5563c07cdbcad1a.1723423275.git.olivier@trillion01.com>
	 <05255cc5136254574b884b5e10aae7cf8301662a.camel@trillion01.com>
	 <8c1ee6ab-8425-4d13-80f5-ff085d12dc91@kernel.dk>
	 <f1397b51-8d41-4f91-aa25-37f771fe4e13@kernel.dk>
	 <8887f2d97c1dafb6ceaf9f5c492457f642f532dd.camel@trillion01.com>
	 <5730c0c1-73cb-42b5-8af3-afe60529f57d@kernel.dk>
	 <e7e8a80ffcca7b3527b74be5741c927937517291.camel@trillion01.com>
	 <bea51c28-17e0-4693-96bf-502ffa75f01a@kernel.dk>
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

On Tue, 2024-08-13 at 12:35 -0600, Jens Axboe wrote:
> On 8/13/24 11:22 AM, Olivier Langlois wrote:
> > On Mon, 2024-08-12 at 14:40 -0600, Jens Axboe wrote:
> > >=20
> > >=20
> > > > 3. I am surprised to notice that in __io_napi_do_busy_loop(),
> > > > list_for_each_entry_rcu() is called to traverse the list but
> > > > the
> > > > regular methods list_del() and list_add_tail() are called to
> > > > update
> > > > the
> > > > list instead of their RCU variant.
> > >=20
> > > Should all just use rcu variants.
> > >=20
> > > Here's a mashup of the changes. Would be great if you can test -
> > > I'll
> > > do
> > > some too, but always good with more than one person testing as it
> > > tends
> > > to hit more cases.
> > >=20
> > Jens,
> >=20
> > I have integrated our RCU corrections into
> > https://lore.kernel.org/io-uring/5fc9dd07e48a7178f547ed1b2aaa0814607fa2=
46.1723567469.git.olivier@trillion01.com/T/#u
> >=20
> > and my testing so far is not showing any problems...
> > but I have a very static setup...
> > I had no issues too without the corrections...
>=20
> Thanks for testing, but regardless of whether that series would go in
> or
> not, I think those rcu changes should be done separately and upfront
> rather than be integrated with other changes.
>=20
sorry about that...

I am going to share a little bit how I currently feel. I feel
disappointed because when I reread your initial reply, I have not been
able to spot a single positive thing said about my proposal despite
that I have prealably tested the water concerning my idea and the big
lines about how I was planning to design it. All, I have been told from
Pavel that the idea was so great that he was even currently playing
with a prototype around the same concept:
https://lore.kernel.org/io-uring/1be64672f22be44fbe1540053427d978c0224dfc.c=
amel@trillion01.com/T/#mc7271764641f9c810ea5438ed3dc0662fbc08cb6

you also have to understand that all the small napi issues that I have
fixed this week are no stranger from me working on this new idea. The
RCU issues that I have reported back have been spotted when I was doing
my final code review before testing my patch before submitting it.

keep in mind that I am by far a git magician. I am a very casual
user... Anything that is outside the usual beaten trails such as
reordoring commits or breaking them down feels perilious to me...

I had 230+ lines changes committed when you confirmed that few lines
should be changed to address this new RCU issue. I did figure that it
would not that big a deal to include them with the rest of my change.

that being said, if my patch submission is acceptable conditional to
needed rework, I am willing to learn how to better use git to meet your
requirements.

Greetings,


