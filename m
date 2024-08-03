Return-Path: <io-uring+bounces-2651-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 766BB946B2F
	for <lists+io-uring@lfdr.de>; Sat,  3 Aug 2024 23:37:45 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 342EA1F21E2F
	for <lists+io-uring@lfdr.de>; Sat,  3 Aug 2024 21:37:45 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BFD144204E;
	Sat,  3 Aug 2024 21:37:40 +0000 (UTC)
X-Original-To: io-uring@vger.kernel.org
Received: from cloud48395.mywhc.ca (cloud48395.mywhc.ca [173.209.37.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7BE0CB653
	for <io-uring@vger.kernel.org>; Sat,  3 Aug 2024 21:37:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=173.209.37.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722721060; cv=none; b=V9rx4Qe99Ubs7Kx3cqA/cDFTasP77EZwD2lNmC4L8OzfvSn5h8EbG6cWdGEONU2uCciJE4QQZm4j0oxMRwZtvAS+1ijjLDIPJodh7wFPrgOnlxM6Ggs/IYGgKh7vBmvL4IvfowzhcerifZ2N/9BoEY2g8t6t+tYy85oOrwrzS9I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722721060; c=relaxed/simple;
	bh=iv0fZ+1N6pBOA2R+P/saUsFiXlW8BUGvbcz4CGm2Pm4=;
	h=Message-ID:Subject:From:To:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=dXmE3NdRg5n9S5D2sxt/lngi0IfhyVK52taWXWK5BudUS87OO0LtYYL45Ct2S+6737tCSMNnLckP3PPBnHCQtFSXLj9iRw28LxQX4DeiYCx/a/fV12YvLoDdzsYZ0rrL652rx9P0+Z2IRu+8vL8V/ZMRSbmikA2xnuRcBYesMOo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=trillion01.com; spf=pass smtp.mailfrom=trillion01.com; arc=none smtp.client-ip=173.209.37.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=trillion01.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=trillion01.com
Received: from [45.44.224.220] (port=47976 helo=[192.168.1.177])
	by cloud48395.mywhc.ca with esmtpsa  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.96.2)
	(envelope-from <olivier@trillion01.com>)
	id 1saMRU-0004Qe-2e;
	Sat, 03 Aug 2024 17:37:36 -0400
Message-ID: <1be64672f22be44fbe1540053427d978c0224dfc.camel@trillion01.com>
Subject: Re: io_uring NAPI busy poll RCU is causing 50 context
 switches/second to my sqpoll thread
From: Olivier Langlois <olivier@trillion01.com>
To: Jens Axboe <axboe@kernel.dk>, Pavel Begunkov <asml.silence@gmail.com>, 
	io-uring@vger.kernel.org
Date: Sat, 03 Aug 2024 17:37:36 -0400
In-Reply-To: <a428d20d-8c14-465c-89ef-52aa8fc67970@kernel.dk>
References: <b1ad0ab3a7e70b72aa73b0b7cab83273358b2e1d.camel@trillion01.com>
	 <00918946-253e-43c9-a635-c91d870407b7@gmail.com>
	 <bcd3b198697e16059ec69566251ad23c4c78e7a7.camel@trillion01.com>
	 <43c27aa1-d955-4375-8d96-cd4201aecf50@gmail.com>
	 <4dbbd36aa7ecd1ce7a6289600b5655563e4a5a74.camel@trillion01.com>
	 <93b294fc-c4e8-4f1f-8abb-ebcea5b8c3a1@gmail.com>
	 <7edc139bd159764075923e75ffb646e7313c7864.camel@trillion01.com>
	 <a428d20d-8c14-465c-89ef-52aa8fc67970@kernel.dk>
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

On Sat, 2024-08-03 at 08:36 -0600, Jens Axboe wrote:
>=20
> You can check the mappings in /sys/kernel/debug/block/<device>/
>=20
> in there you'll find a number of hctxN folders, each of these is a
> hardware queue. hcxt0/type tells you what kind of queue it is, and
> inside the directory, you'll find which CPUs this queue is mapped to.
> Example:
>=20
> root@r7625 /s/k/d/b/nvme0n1# cat hctx1/type=20
> default
>=20
> "default" means it's a read/write queue, so it'll handle both reads
> and
> writes.
>=20
> root@r7625 /s/k/d/b/nvme0n1# ls hctx1/
> active=A0 cpu11/=A0=A0 dispatch=A0=A0=A0=A0=A0=A0 sched_tags=A0=A0=A0=A0=
=A0=A0=A0=A0 tags
> busy=A0=A0=A0 cpu266/=A0 dispatch_busy=A0 sched_tags_bitmap=A0 tags_bitma=
p
> cpu10/=A0 ctx_map=A0 flags=A0=A0=A0=A0=A0=A0=A0=A0=A0 state=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0=A0=A0 type
>=20
> and we can see this hardware queue is mapped to cpu 10/11/266.
>=20
> That ties into how these are mapped. It's pretty simple - if a task
> is
> running on cpu 10/11/266 when it's queueing IO, then it'll use hw
> queue
> 1. This maps to the interrupts you found, but note that the admin
> queue
> (which is not listed these directories, as it's not an IO queue) is
> the
> first one there. hctx0 is nvme0q1 in your /proc/interrupts list.
>=20
> If IO is queued on hctx1, then it should complete on the interrupt
> vector associated with nvme0q2.
>=20
I have entered hacking territory but I did not find any other way to do
it...

drivers/nvme/host/pci.c
diff --git a/drivers/nvme/host/pci.c b/drivers/nvme/host/pci.c
index 6cd9395ba9ec..70b7ca84ee21 100644
--- a/drivers/nvme/host/pci.c
+++ b/drivers/nvme/host/pci.c
@@ -2299,7 +2299,7 @@ static unsigned int nvme_max_io_queues(struct
nvme_dev *dev)
         */
        if (dev->ctrl.quirks & NVME_QUIRK_SHARED_TAGS)
                return 1;
-       return num_possible_cpus() + dev->nr_write_queues + dev-
>nr_poll_queues;
+       return 1 + dev->nr_write_queues + dev->nr_poll_queues;
 }
=20
 static int nvme_setup_io_queues(struct nvme_dev *dev)

it works. I have no more IRQ on cpu1 as I wanted

 63:          9          0          0          0  PCI-MSIX-0000:00:04.0
0-edge      nvme0q0
 64:          0          0          0       7533  PCI-MSIX-0000:00:04.0
1-edge      nvme0q1

# ls /sys/kernel/debug/block/nvme0n1/hctx0/
active  busy  cpu0  cpu1  cpu2  cpu3  ctx_map  dispatch  dispatch_busy
flags  sched_tags  sched_tags_bitmap  state  tags  tags_bitmap  type


