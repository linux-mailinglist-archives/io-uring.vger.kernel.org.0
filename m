Return-Path: <io-uring+bounces-2619-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 7015994235A
	for <lists+io-uring@lfdr.de>; Wed, 31 Jul 2024 01:14:22 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id EF1CA1F21A4A
	for <lists+io-uring@lfdr.de>; Tue, 30 Jul 2024 23:14:21 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 16605191F90;
	Tue, 30 Jul 2024 23:14:17 +0000 (UTC)
X-Original-To: io-uring@vger.kernel.org
Received: from cloud48395.mywhc.ca (cloud48395.mywhc.ca [173.209.37.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3418A1AA3E5;
	Tue, 30 Jul 2024 23:14:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=173.209.37.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722381257; cv=none; b=ZUWV893OW3M4C9SSt71O1bN4DCZtg//nRs2FiNy68hNMJ3xBf2Otm4LqXqxkxxESCyfCUAXtRQof6PENQTuyUIy59tuiN1WR8RmaNTHYIJO8OJeeN3Jvw9H9SgqmXBxJoQjmgs5jcsqOHH8/B4LFfcFS0IZVcanGoagouNNWwPQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722381257; c=relaxed/simple;
	bh=m1e5QbsfI+5cNKkiGJUhdk3rcvpQMzxUS0KNQOf7ZIs=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=s0zjtxpxOE+DBYYAKD5lExDFRheF1rsdSHx14noMJelZX0+rtrKsr+nmjYdXXeek45U4p1crNMKw3gT9fHE4C0zWLBt8Wl+Q39hgw9+ZVRXMhDR1PdN3t45x6Tmyo1GtKztzwu5TMCiPInE3VH6Q/oXh6ZzgexiTb88dQ0kGfY4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=trillion01.com; spf=pass smtp.mailfrom=trillion01.com; arc=none smtp.client-ip=173.209.37.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=trillion01.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=trillion01.com
Received: from [45.44.224.220] (port=60896 helo=[192.168.1.177])
	by cloud48395.mywhc.ca with esmtpsa  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.96.2)
	(envelope-from <olivier@trillion01.com>)
	id 1sYw2h-0003kZ-2e;
	Tue, 30 Jul 2024 19:14:07 -0400
Message-ID: <bcd3b198697e16059ec69566251ad23c4c78e7a7.camel@trillion01.com>
Subject: Re: io_uring NAPI busy poll RCU is causing 50 context
 switches/second to my sqpoll thread
From: Olivier Langlois <olivier@trillion01.com>
To: Pavel Begunkov <asml.silence@gmail.com>, io-uring@vger.kernel.org
Cc: netdev@vger.kernel.org
Date: Tue, 30 Jul 2024 19:14:03 -0400
In-Reply-To: <00918946-253e-43c9-a635-c91d870407b7@gmail.com>
References: <b1ad0ab3a7e70b72aa73b0b7cab83273358b2e1d.camel@trillion01.com>
	 <00918946-253e-43c9-a635-c91d870407b7@gmail.com>
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
User-Agent: Evolution 3.52.3 
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

On Tue, 2024-07-30 at 21:25 +0100, Pavel Begunkov wrote:
>=20
> Removing an entry or two once every minute is definitely not
> going to take 50% CPU, RCU machinery is running in background
> regardless of whether io_uring uses it or not, and it's pretty
> cheap considering ammortisation.
>=20
> If anything it more sounds from your explanation like the
> scheduler makes a wrong decision and schedules out the sqpoll
> thread even though it could continue to run, but that's need
> a confirmation. Does the CPU your SQPOLL is pinned to stays
> 100% utilised?

Here are the facts as they are documented in the github issue.

1. despite thinking that I was doing NAPI busy polling, I was not
because my ring was not receiving any sqe after its initial setup.

This is what the patch developped with your input
https://lore.kernel.org/io-uring/382791dc97d208d88ee31e5ebb5b661a0453fb79.1=
722374371.git.olivier@trillion01.com/T/#u

is addressing

(BTW, I should check if there is such a thing, but I would love to know
if the net code is exposing a tracepoint when napi_busy_poll is called
because it is very tricky to know if it is done for real or not)

2. the moment a second ring has been attached to the sqpoll thread that
was receving a lot of sqe, the NAPI busy loop started to be made for
real and the sqpoll cpu usage unexplicably dropped from 99% to 55%

3. here is my kernel cmdline:
hugepages=3D72 isolcpus=3D0,1,2 nohz_full=3D0,1,2 rcu_nocbs=3D0,1,2
rcu_nocb_poll irqaffinity=3D3 idle=3Dnomwait processor.max_cstate=3D1
intel_idle.max_cstate=3D1 nmi_watchdog=3D0

there is absolutely nothing else on CPU0 where the sqpoll thread
affinity is set to run.

4. I got the idea of doing this:
echo common_pid =3D=3D sqpoll_pid > /sys/kernel/tracing/events/sched/filter
echo 1 > /sys/kernel/tracing/events/sched/sched_switch/enable

and I have recorded over 1,000 context switches in 23 seconds with RCU
related kernel threads.

5. just for the fun of checking out, I have disabled NAPI polling on my
io_uring rings and the sqpoll thread magically returned to 99% CPU
usage from 55%...

I am open to other explanations for what I have observed but my current
conclusion is based on what I am able to see... the evidence appears
very convincing to me...

> >=20
> > So is this a good idea in your opinion?
>=20
> I believe that's a good thing, I've been prototyping a similar
> if not the same approach just today, i.e. user [un]registers
> napi instance by id you can get with SO_INCOMING_NAPI_ID.
>=20
this is fantastic!

I am super happy to see all this NAPI busy polling feature interest and
activity which is a feature that I am very fond with (along with
io_uring)

I am looking forward collaborating with you Pavel to make io_uring the
best NAPI busy polling goto solution!

Greetings,
Olivier


