Return-Path: <io-uring+bounces-2634-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 9219C945466
	for <lists+io-uring@lfdr.de>; Fri,  2 Aug 2024 00:02:58 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 0B73B282F12
	for <lists+io-uring@lfdr.de>; Thu,  1 Aug 2024 22:02:57 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DE26713E04C;
	Thu,  1 Aug 2024 22:02:53 +0000 (UTC)
X-Original-To: io-uring@vger.kernel.org
Received: from cloud48395.mywhc.ca (cloud48395.mywhc.ca [173.209.37.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9FBE914AA9;
	Thu,  1 Aug 2024 22:02:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=173.209.37.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722549773; cv=none; b=YUDqTlcfZZ8KbF9UY1iF4aFDr3xCRBI0TDvDvYrDCb3NrSdjx4L9H08xLgwP+B4AUn2p2fKWqis75twfMKOGPgL5EXIa/prGHge4JZlQeLY65byc3ZgVI4o0bIcb2yFKvY+zeEUbYY8GWFg4U4lNdLQmkC7260xRdkx+B1dvthg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722549773; c=relaxed/simple;
	bh=l3ySH+k8H2oB483V9c0B34KU0g3LpC/pefj6/z+V7bo=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=c8KAqnlmqBCcpY9+clQJ6ujoBn6YRFS6vc5aUL5tynC4yJHwhlEgqV+n1vQYokwVDwKLftd+D/yHIizxCquxTfKV3Czuu1SI9NXng+PkdYOEdkN2auNzh1olkjNJsE6F/mxnzQuL0TV9Ton6OMd9cf+2RsGGR13816KmcM5hYvk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=trillion01.com; spf=pass smtp.mailfrom=trillion01.com; arc=none smtp.client-ip=173.209.37.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=trillion01.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=trillion01.com
Received: from [45.44.224.220] (port=48282 helo=[192.168.1.177])
	by cloud48395.mywhc.ca with esmtpsa  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.96.2)
	(envelope-from <olivier@trillion01.com>)
	id 1sZdso-0001tj-1R;
	Thu, 01 Aug 2024 18:02:50 -0400
Message-ID: <4dbbd36aa7ecd1ce7a6289600b5655563e4a5a74.camel@trillion01.com>
Subject: Re: io_uring NAPI busy poll RCU is causing 50 context
 switches/second to my sqpoll thread
From: Olivier Langlois <olivier@trillion01.com>
To: Pavel Begunkov <asml.silence@gmail.com>, io-uring@vger.kernel.org
Cc: netdev@vger.kernel.org
Date: Thu, 01 Aug 2024 18:02:49 -0400
In-Reply-To: <43c27aa1-d955-4375-8d96-cd4201aecf50@gmail.com>
References: <b1ad0ab3a7e70b72aa73b0b7cab83273358b2e1d.camel@trillion01.com>
	 <00918946-253e-43c9-a635-c91d870407b7@gmail.com>
	 <bcd3b198697e16059ec69566251ad23c4c78e7a7.camel@trillion01.com>
	 <43c27aa1-d955-4375-8d96-cd4201aecf50@gmail.com>
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

On Wed, 2024-07-31 at 01:33 +0100, Pavel Begunkov wrote:
>=20
> You're seeing something that doesn't make much sense to me, and we
> need
> to understand what that is. There might be a bug _somewhere_, that's
> always a possibility, but before saying that let's get a bit more
> data.
>=20
> While the app is working, can you grab a profile and run mpstat for
> the
> CPU on which you have the SQPOLL task?
>=20
> perf record -g -C <CPU number> --all-kernel &
> mpstat -u -P <CPU number> 5 10 &
>=20
> And then as usual, time it so that you have some activity going on,
> mpstat interval may need adjustments, and perf report it as before.
>=20
First thing first.

The other day, I did put my foot in my mouth by saying the NAPI busy
poll was adding 50 context switches/second.

I was responsible for that behavior with the rcu_nocb_poll boot kernel
param. I have removed the option and the context switches went away...

I am clearly outside my comfort zone with this project, I am trying
things without fully understand what I am doing and I am making errors
and stuff that is incorrect.

On top of that, before mentioning io_uring RCU usage, I did not realize
that net/core was already massively using RCU, including in
napi_busy_poll, therefore, that io_uring is using rcu before calling
napi_busy_poll, the point does seem very moot.

this is what I did the other day and I wanted to apologize to have said
something incorrect.

that being said, it does not remove the possible merit of what I did
propose.

I really think that the current io_uring implemention of the napi
device tracking strategy is overkill for a lot of scenarios...

if some sort of abstract interface like a mini struct net_device_ops
with 3-4 function pointers where the user could select between the
standard dynamic tracking or a manual lightweight tracking was present,
that would be very cool... so cool...

I am definitely interested in running the profiler tools that you are
proposing... Most of my problems are resolved...

- I got rid of 99.9% if the NET_RX_SOFTIRQ
- I have reduced significantly the number of NET_TX_SOFTIRQ
  https://github.com/amzn/amzn-drivers/issues/316
- No more rcu context switches
- CPU2 is now nohz_full all the time
- CPU1 local timer interrupt is raised once every 2-3 seconds for an
unknown origin. Paul E. McKenney did offer me his assistance on this
issue
https://lore.kernel.org/rcu/367dc07b740637f2ce0298c8f19f8aec0bdec123.camel@=
trillion01.com/t/#u

I am going to give perf record a second chance... but just keep in
mind, that it is not because it is not recording much, it is not
because nothing is happening. if perf relies on interrupts to properly
operate, there is close to 0 on my nohz_full CPU...

thx a lot for your help Pavel!


