Return-Path: <io-uring+bounces-2648-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 0D2BF946A05
	for <lists+io-uring@lfdr.de>; Sat,  3 Aug 2024 16:15:12 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id C2D6F281DCC
	for <lists+io-uring@lfdr.de>; Sat,  3 Aug 2024 14:15:10 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C9718139597;
	Sat,  3 Aug 2024 14:15:09 +0000 (UTC)
X-Original-To: io-uring@vger.kernel.org
Received: from cloud48395.mywhc.ca (cloud48395.mywhc.ca [173.209.37.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6D09314F9F5
	for <io-uring@vger.kernel.org>; Sat,  3 Aug 2024 14:15:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=173.209.37.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722694509; cv=none; b=eE/Qxe6qcJVnCD0ufovjkDSa4dggzi+FCRSz3H0ctaV+aFqLfSY9UIgpDBKrBSyKpwx1s/waZFJn4S5zEaSUcsw+9quL9aP1/t2JdVigkRifvO9T4Z+dVD4yiwq5/e7OrKwi8BV6QT439MKT/IzDUeY2a70bVXTo5b0mIXBECvg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722694509; c=relaxed/simple;
	bh=TfkGMzYK1Gtz9RpAaFNnjHPzGh4oJ6r80408TCnDKE4=;
	h=Message-ID:Subject:From:To:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=JWaS2HXGY9remkYwjmCE7JtxOAP9NqG5sc6IC3NF8Pt30hLyIbHFb3E7qQ+ctdEGXJg4h3pbFVyiG0E5PVLpWZ6KEHQD2/+8n59FRjnTsniw5Ft73G+bypOjSBdYgjPie5/FihSCs1YuX+A5hXCSnjA8LHRQE7T3S3mv7Iu4riY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=trillion01.com; spf=pass smtp.mailfrom=trillion01.com; arc=none smtp.client-ip=173.209.37.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=trillion01.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=trillion01.com
Received: from [45.44.224.220] (port=50722 helo=[192.168.1.177])
	by cloud48395.mywhc.ca with esmtpsa  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.96.2)
	(envelope-from <olivier@trillion01.com>)
	id 1saFXG-0003kf-04;
	Sat, 03 Aug 2024 10:15:06 -0400
Message-ID: <7edc139bd159764075923e75ffb646e7313c7864.camel@trillion01.com>
Subject: Re: io_uring NAPI busy poll RCU is causing 50 context
 switches/second to my sqpoll thread
From: Olivier Langlois <olivier@trillion01.com>
To: Pavel Begunkov <asml.silence@gmail.com>, io-uring@vger.kernel.org
Date: Sat, 03 Aug 2024 10:15:05 -0400
In-Reply-To: <93b294fc-c4e8-4f1f-8abb-ebcea5b8c3a1@gmail.com>
References: <b1ad0ab3a7e70b72aa73b0b7cab83273358b2e1d.camel@trillion01.com>
	 <00918946-253e-43c9-a635-c91d870407b7@gmail.com>
	 <bcd3b198697e16059ec69566251ad23c4c78e7a7.camel@trillion01.com>
	 <43c27aa1-d955-4375-8d96-cd4201aecf50@gmail.com>
	 <4dbbd36aa7ecd1ce7a6289600b5655563e4a5a74.camel@trillion01.com>
	 <93b294fc-c4e8-4f1f-8abb-ebcea5b8c3a1@gmail.com>
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

On Fri, 2024-08-02 at 16:22 +0100, Pavel Begunkov wrote:
> >=20
> > I am definitely interested in running the profiler tools that you
> > are
> > proposing... Most of my problems are resolved...
> >=20
> > - I got rid of 99.9% if the NET_RX_SOFTIRQ
> > - I have reduced significantly the number of NET_TX_SOFTIRQ
> > =A0=A0 https://github.com/amzn/amzn-drivers/issues/316
> > - No more rcu context switches
> > - CPU2 is now nohz_full all the time
> > - CPU1 local timer interrupt is raised once every 2-3 seconds for
> > an
> > unknown origin. Paul E. McKenney did offer me his assistance on
> > this
> > issue
> > https://lore.kernel.org/rcu/367dc07b740637f2ce0298c8f19f8aec0bdec123.ca=
mel@trillion01.com/t/#u
>=20
> And I was just going to propose to ask Paul, but great to
> see you beat me on that
>=20
My investigation has progressed... my cpu1 interrupts are nvme block
device interrupts.

I feel that for questions about block device drivers, this time, I am
ringing at the experts door!

What is the meaning of a nvme interrupt?

I am assuming that this is to signal the completing of writing blocks
in the device...
I am currently looking in the code to find the answer for this.

Next, it seems to me that there is an odd number of interrupts for the
device:
 63:         12          0          0          0  PCI-MSIX-0000:00:04.0
0-edge      nvme0q0
 64:          0      23336          0          0  PCI-MSIX-0000:00:04.0
1-edge      nvme0q1
 65:          0          0          0      33878  PCI-MSIX-0000:00:04.0
2-edge      nvme0q2

why 3? Why not 4? one for each CPU...

If there was 4, I would have concluded that the driver has created a
queue for each CPU...

How are the queues associated to certain request/task?

The file I/O is made by threads running on CPU3, so I find it
surprising that nvmeq1 is choosen...

One noteworthy detail is that the process main thread is on CPU1. In my
flawed mental model of 1 queue per CPU, there could be some sort of
magical association with a process file descriptors table and the
choosen block device queue but this idea does not hold... What would
happen to processes running on CPU2...


