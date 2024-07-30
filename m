Return-Path: <io-uring+bounces-2610-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 25FBB942149
	for <lists+io-uring@lfdr.de>; Tue, 30 Jul 2024 22:06:00 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 573EB1C22E43
	for <lists+io-uring@lfdr.de>; Tue, 30 Jul 2024 20:05:59 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0CE1518C909;
	Tue, 30 Jul 2024 20:05:56 +0000 (UTC)
X-Original-To: io-uring@vger.kernel.org
Received: from cloud48395.mywhc.ca (cloud48395.mywhc.ca [173.209.37.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D16433FE4;
	Tue, 30 Jul 2024 20:05:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=173.209.37.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722369955; cv=none; b=D8YjHOTX9dVLz0rUgF2t+QOdRwrYhIII2i5U+TwRat/8RIz2hVizUku3xOrfAElDpwdhwLMxVsOn1g/sAoyvCkueyoXSICVcNWzsA4ZGKDn6RyLS1W0NyXrkb/hwKIX+4b+XahQiJQ1hBl8GxpcVv5NrD7Ea6tMQYeyJg/AUzn8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722369955; c=relaxed/simple;
	bh=08Y5t+/8N2aBquIamx/IrSUR1vWd4M2XUzBHr2851tk=;
	h=Message-ID:Subject:From:To:Cc:Date:Content-Type:MIME-Version; b=Jy7r8m1dH+E4nEC2CY+d2fkrARQmMk2vahnWeukhxvv1S1ui4q8D3eSO03ug53PJLRpScnUtjSUGMsNW4VbJDp0GbHrb+uT3jyXyl8cAIRO7ftRhtfBL4iJgWFEyOk+lcZazf9Y+Tg5YVqfLbb0JTFAI37TjiQtbsHl8c9rFvw4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=trillion01.com; spf=pass smtp.mailfrom=trillion01.com; arc=none smtp.client-ip=173.209.37.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=trillion01.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=trillion01.com
Received: from [45.44.224.220] (port=53656 helo=[192.168.1.177])
	by cloud48395.mywhc.ca with esmtpsa  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.96.2)
	(envelope-from <olivier@trillion01.com>)
	id 1sYt6W-0000cG-2X;
	Tue, 30 Jul 2024 16:05:52 -0400
Message-ID: <b1ad0ab3a7e70b72aa73b0b7cab83273358b2e1d.camel@trillion01.com>
Subject: io_uring NAPI busy poll RCU is causing 50 context switches/second
 to my sqpoll thread
From: Olivier Langlois <olivier@trillion01.com>
To: io-uring@vger.kernel.org
Cc: netdev@vger.kernel.org
Date: Tue, 30 Jul 2024 16:05:52 -0400
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

if you are interested into all the details,

they are all here:
https://github.com/axboe/liburing/issues/1190

it seems like I like to write a lot when I am investigating a problem.
Pavel has been a great help in assisting me understanding what was
happening.

Next, I came to question where the integration of RCU came from and I
have found this:
https://lore.kernel.org/all/89ef84bf-48c2-594c-cc9c-f796adcab5e8@kernel.dk/

I guess that in some use-case being able to dynamically manage hundreds
of NAPI devices automatically that can suddenly all be swepted over
during a device reconfiguration is something desirable to have for
some...

but in my case, this is an excessively a high price to pay for a
flexibility that I do not need at all.

I have a single NAPI device. Once I know what it is, it will pratically
remain immutable until termination.

For that reason, I am thinking that offering some sort of polymorphic
NAPI device tracking strategy customization would be desirable.

The current one, the RCU one, I would call it the

dynamic_napi_tracking (rcu could be peppered in the name somewhere so
people know what the strategy is up to)

where as the new one that I am imagining would be called

static_napi_tracking.

NAPI devices would be added/removed by the user manually through an
extended registration function.

for the sake of conveniance, a clear_list operation could even be
offered.

The benefits of this new static tracking strategy would be numerous:
- this removes the need to invoke the heavy duty RCU cavalry
- no need to scan the list to remove stall devices
- no need to search the list at each SQE submission to update the
device timeout value

So is this a good idea in your opinion?


