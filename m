Return-Path: <io-uring+bounces-3348-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 5463998C32C
	for <lists+io-uring@lfdr.de>; Tue,  1 Oct 2024 18:21:54 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 19E00286C5C
	for <lists+io-uring@lfdr.de>; Tue,  1 Oct 2024 16:21:53 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4DFAD1CBEB5;
	Tue,  1 Oct 2024 16:13:22 +0000 (UTC)
X-Original-To: io-uring@vger.kernel.org
Received: from mout.perfora.net (mout.perfora.net [74.208.4.196])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 94FF11CB524;
	Tue,  1 Oct 2024 16:13:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.208.4.196
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727799202; cv=none; b=crhs//DQSlviweQakpgXY+JeW9Wj8Gg7JXvgs0b+xGgpIcmsriALbpx8/ufUecYETRs+YaOPv7cnqAq+AcrCYIp4kZoNLpKfMnpB3SCBuQ+hZNRGaGVA/GBWT8+B+2eZti2U9hnmfqijCB5OblSwGrBboqplWTwC8oz6OCeVrYg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727799202; c=relaxed/simple;
	bh=WArsn0K56fFi+9xbf+w+UqcpmiTu4Zl6xOHkdw1M67o=;
	h=From:To:Cc:References:In-Reply-To:Subject:Date:Message-ID:
	 MIME-Version:Content-Type; b=ld7o1Sjl7knS5A0g5lX3ROS2FJ38noSM+1De/I3WlcY4e9t3sl58LyDRkLcW1Agnpv+ylxVnwKLzNNitudt3Slam3bs0bXTDUrJaTQqAWNkOJxcweEvpmZ1Qxm8EIQE1Zk6KD9HQN3nBE5QrC0KWNcsJ0repbzb3d7CDkJYrMdw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=thebergstens.com; spf=pass smtp.mailfrom=thebergstens.com; arc=none smtp.client-ip=74.208.4.196
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=thebergstens.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=thebergstens.com
Received: from jimw8 ([98.97.139.223]) by mrelay.perfora.net (mreueus002
 [74.208.5.2]) with ESMTPSA (Nemesis) id 0Lbtbu-1sCjf30cXE-00evug; Tue, 01 Oct
 2024 17:58:25 +0200
From: "James R. Bergsten" <jim@thebergstens.com>
To: "'Christoph Hellwig'" <hch@lst.de>,
	"'Kanchan Joshi'" <joshi.k@samsung.com>
Cc: <axboe@kernel.dk>,
	<kbusch@kernel.org>,
	<hare@suse.de>,
	<sagi@grimberg.me>,
	<martin.petersen@oracle.com>,
	<brauner@kernel.org>,
	<viro@zeniv.linux.org.uk>,
	<jack@suse.cz>,
	<jaegeuk@kernel.org>,
	<bcrl@kvack.org>,
	<dhowells@redhat.com>,
	<bvanassche@acm.org>,
	<asml.silence@gmail.com>,
	<linux-nvme@lists.infradead.org>,
	<linux-fsdevel@vger.kernel.org>,
	<io-uring@vger.kernel.org>,
	<linux-block@vger.kernel.org>,
	<linux-aio@kvack.org>,
	<gost.dev@samsung.com>,
	<vishak.g@samsung.com>,
	<javier.gonz@samsung.com>
References: <CGME20240930182052epcas5p37edefa7556b87c3fbb543275756ac736@epcas5p3.samsung.com> <20240930181305.17286-1-joshi.k@samsung.com> <20241001092047.GA23730@lst.de>
In-Reply-To: <20241001092047.GA23730@lst.de>
Subject: RE: [PATCH v7 0/3] FDP and per-io hints
Date: Tue, 1 Oct 2024 08:58:17 -0700
Message-ID: <006901db141a$bf9aa590$3ecff0b0$@thebergstens.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain;
	charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Mailer: Microsoft Outlook 16.0
Thread-Index: AQEtLMzQU9Mj3GK9LglaQbGW3QSfFAJ3IhvwAcJpBdOzrA9SwA==
Content-Language: en-us
X-Provags-ID: V03:K1:lv/Ipl00MnBrV8wUg8fbNZhL45WxX047MlZz8sQSg7lOnpxDafj
 sctE9uJCJBO181V3JR/KCGtQEG8rMmYDC0NJNzoVB9jQz7Pdno0U7uAK3m6Z9vsAs9GYJSf
 lyWMXG6tQg/J7lLe6hTY+ToIsKv+7SKuWoeo8WwyRTZ6fewLcGBa3tg8+tzdHOx2mqRYey9
 WRH9M3x+SzUUDzPMPNgcA==
X-Spam-Flag: NO
UI-OutboundReport: notjunk:1;M01:P0:bQEm0Aqwc7E=;Ngp++CpEr0ANOEF+JEqnq6St0VH
 XBDgQ0ALFIrFs+SbZtoljDmOZ5zLnlVoGx2+F4dYzhFR5ACzYTWonUrgq7f5AhZREz6jAIZqW
 qeGrvj/HLq57PiV82HBvnIowVhM4l8sTSWbHCJBcpieej+N6tPLorEzj6NfMUBqoHNovg87QU
 KidukiwF/W2Fe6DgW4RleSZSphq5N4yC26h4WdzRH0fjPUci4X4CbwWj7yzjzMxMHjeoskFZv
 2e/gv4iUCwnzPPWG2JSpXm6hJqA6PtD+P2JWPiYSJhyksSPTVRUal5hLMv6Jy1dx1JVczenBF
 dWK7vslMfXvmBjrX/my1Y/MFEHC77u0lmwhlACN8zGcCiB8668dtXhMpwB+pAGZz7OTYZ4nEo
 miQajcXB6wmlSmfg3NKDOmd31Nt1kyC11I4TTFQ0w2SwLLyfshWE3ZrOStzFE3PMCzadn0fUY
 OatIKesgMnLKY/nAbyjdaZqB1QEB2WS67DVA2NCpH8AzIT/TVYeAW+Ln+1Er/rdDhFQzDWroM
 n07siZpzAos07RGSp7YVcaoi2vtmMmEJ+GzdA5qfUR3hENqes/8/raHNt8kK8XrJvkIh+qLAl
 Rac9V9iFXyIvMJ2avOqv+OmRkuudTJGyNVBHVZmjk7YVR7tItfb1VzDRnyvlIux63RxOrVMiT
 6MduGSPIFnFW/tVpRf6IUGoNa+SRMOmLMX9GE4hWLcmShx81Jdmxq1mRGjxtHWnMy0IwPXkcP
 osEDB0LDYYggbNoaoqW6XLyvBT8jpaZGQ==

Now THIS Is the NVMe I came to know and love.  =F0=9F=98=8A

-----Original Message-----
From: Linux-nvme <linux-nvme-bounces@lists.infradead.org> On Behalf Of =
Christoph Hellwig
Sent: Tuesday, October 1, 2024 2:21 AM
To: Kanchan Joshi <joshi.k@samsung.com>
Cc: axboe@kernel.dk; kbusch@kernel.org; hch@lst.de; hare@suse.de; =
sagi@grimberg.me; martin.petersen@oracle.com; brauner@kernel.org; =
viro@zeniv.linux.org.uk; jack@suse.cz; jaegeuk@kernel.org; =
bcrl@kvack.org; dhowells@redhat.com; bvanassche@acm.org; =
asml.silence@gmail.com; linux-nvme@lists.infradead.org; =
linux-fsdevel@vger.kernel.org; io-uring@vger.kernel.org; =
linux-block@vger.kernel.org; linux-aio@kvack.org; gost.dev@samsung.com; =
vishak.g@samsung.com; javier.gonz@samsung.com
Subject: Re: [PATCH v7 0/3] FDP and per-io hints

Any reason you completely ignored my feedback on the last version and =
did not even answer?

That's not a very productive way to work.




