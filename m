Return-Path: <io-uring+bounces-2635-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id EF3B39454B9
	for <lists+io-uring@lfdr.de>; Fri,  2 Aug 2024 01:05:45 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 89681B22775
	for <lists+io-uring@lfdr.de>; Thu,  1 Aug 2024 23:05:43 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 86F1914B075;
	Thu,  1 Aug 2024 23:05:38 +0000 (UTC)
X-Original-To: io-uring@vger.kernel.org
Received: from cloud48395.mywhc.ca (cloud48395.mywhc.ca [173.209.37.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 719FAD2F5;
	Thu,  1 Aug 2024 23:05:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=173.209.37.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722553538; cv=none; b=hBmANzPKVB/azsXEl/5o1FMKnhrLdbd5l4lDLAHWfZn/3Ox/gtWX/1M5FOMaYVEAN+6fCpkrvq5Q9swq96pIkFdLVVnj7u6mfYW8QAcei9PDMeEa/IrzvCoxxiXNI0E+fzheE6+4OajH//nPYbwMy9xq+R83us8vFo2TdXB8Z3g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722553538; c=relaxed/simple;
	bh=PtPKb/3gkGJs5E7KLeHnbriRs21F34tPsu6+uWzyok8=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=HPie7saUjKhwneXlQG8IflRtruv2bUk17cKJ/+/H7HPrzxohErx/4LowULD5fWW1PSyNUDeLhojygNLl75hvOnP+RQv2wTjfjkFco0MENoCJcUtqiOSjm3EvAWoSQa8gVjzn37nndq+4/2muaJMCOClfwHDKgjz+OfgQUDnncYw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=trillion01.com; spf=pass smtp.mailfrom=trillion01.com; arc=none smtp.client-ip=173.209.37.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=trillion01.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=trillion01.com
Received: from [45.44.224.220] (port=59976 helo=[192.168.1.177])
	by cloud48395.mywhc.ca with esmtpsa  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.96.2)
	(envelope-from <olivier@trillion01.com>)
	id 1sZerX-0005bl-0H;
	Thu, 01 Aug 2024 19:05:35 -0400
Message-ID: <9ba345b74c19fec2c19f05d2887c6315b0855a75.camel@trillion01.com>
Subject: Re: io_uring NAPI busy poll RCU is causing 50 context
 switches/second to my sqpoll thread
From: Olivier Langlois <olivier@trillion01.com>
To: Pavel Begunkov <asml.silence@gmail.com>, io-uring@vger.kernel.org
Cc: netdev@vger.kernel.org
Date: Thu, 01 Aug 2024 19:05:34 -0400
In-Reply-To: <66f7bc8a-e4a9-4912-9ea7-c88dbb6fb999@gmail.com>
References: <b1ad0ab3a7e70b72aa73b0b7cab83273358b2e1d.camel@trillion01.com>
	 <00918946-253e-43c9-a635-c91d870407b7@gmail.com>
	 <bcd3b198697e16059ec69566251ad23c4c78e7a7.camel@trillion01.com>
	 <43c27aa1-d955-4375-8d96-cd4201aecf50@gmail.com>
	 <66f7bc8a-e4a9-4912-9ea7-c88dbb6fb999@gmail.com>
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

On Wed, 2024-07-31 at 02:00 +0100, Pavel Begunkov wrote:
>=20
> I forgot to add, ~50 switches/second for relatively brief RCU
> handling
> is not much, not enough to take 50% of a CPU. I wonder if sqpoll was
> still running but napi busy polling time got accounted to softirq
> because of disabled bh and you didn't include it, hence asking CPU
> stats. Do you see any latency problems for that configuration?
>=20
Pavel,

I am not sure if I will ever discover what this 50% CPU usage drop was
exactly.

when I did test
https://lore.kernel.org/io-uring/382791dc97d208d88ee31e5ebb5b661a0453fb79.1=
722374371.git.olivier@trillion01.com/T/#u

from this custom setup:
https://github.com/axboe/liburing/issues/1190#issuecomment-2258632731

iou-sqp task cpu usage went back to 100%...

there was also my busy_poll config numbers that were inadequate.

I went from:
echo 1000 > /sys/class/net/enp39s0/napi_defer_hard_irqs
echo 500 > /sys/class/net/enp39s0/gro_flush_timeout

to:
echo 5000 > /sys/class/net/enp39s0/napi_defer_hard_irqs
# gro_flush_timeout unit is nanoseconds
echo 100000 > /sys/class/net/enp39s0/gro_flush_timeout

ksoftirqd has stopped being awakening to service NET SOFTIRQS but I
would that this might not be the cause neither

I have no more latency issues. After a lot of efforts during the last 7
days, my system latency have improved by a good 10usec on average over
what it was last week...

but knowing that it can be even better is stopping me from letting
go...

the sporadic CPU1 interrupt can introduce a 27usec delay and this is
the difference between a win or a loss that is at stake...
https://lore.kernel.org/rcu/367dc07b740637f2ce0298c8f19f8aec0bdec123.camel@=
trillion01.com/T/#m5abf9aa02ec7648c615885a6f8ebdebc57935c35

I want to get rid of that interrupt so hard that is going to provide a
great satidfaction when I will have finally found the cause...


