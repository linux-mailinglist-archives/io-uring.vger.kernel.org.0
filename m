Return-Path: <io-uring+bounces-4627-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 003AF9C5DDA
	for <lists+io-uring@lfdr.de>; Tue, 12 Nov 2024 17:56:29 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 325D7B291AE
	for <lists+io-uring@lfdr.de>; Tue, 12 Nov 2024 16:32:15 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8031B205AD6;
	Tue, 12 Nov 2024 16:32:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b="r9jx87aA"
X-Original-To: io-uring@vger.kernel.org
Received: from mailout1.samsung.com (mailout1.samsung.com [203.254.224.24])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 12B7F205ABB
	for <io-uring@vger.kernel.org>; Tue, 12 Nov 2024 16:32:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=203.254.224.24
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731429126; cv=none; b=HgAwob0Ao3QZvNhRON8IDUN2cCWAJJQ9FKqCIv6GOs1ZqBO/nGhZ+f0KMYNa62TODS9TR3C2oDe8ufEWCGai/fiQSKRpUg9Oq5skUBS4EPqwI2qXxMDgIO3E2wwrIzox9eFuQ1YhpvKlP7jiaiEwaL6j7BxPRuH4hNOulT59sZE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731429126; c=relaxed/simple;
	bh=20+Y4zAdakYSoTYa70QV9aDu8bHP40w2Jlt6fgPJaLs=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:In-Reply-To:
	 Content-Type:References; b=Cy6meb8rpX7PauXnxXtgwA6CrL5XOMrOZO0GIyHBeMn+TjOuBRreF1be5daQqRTfFY8kgjLCeCXWVV9K+zuUiTp3gpDJnz7j6yW1L5/l0PxBaCpOlmuxQpNGbEA/KGSW14wkkaXuLjHd2o1yZ7tktD4qqfuAPUpqm/DdNkcehjg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com; spf=pass smtp.mailfrom=samsung.com; dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b=r9jx87aA; arc=none smtp.client-ip=203.254.224.24
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samsung.com
Received: from epcas5p2.samsung.com (unknown [182.195.41.40])
	by mailout1.samsung.com (KnoxPortal) with ESMTP id 20241112163201epoutp0126dfad0e8ab0eeb3449b94049ced6ce8~HRZzpqX-g0598105981epoutp01g
	for <io-uring@vger.kernel.org>; Tue, 12 Nov 2024 16:32:01 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout1.samsung.com 20241112163201epoutp0126dfad0e8ab0eeb3449b94049ced6ce8~HRZzpqX-g0598105981epoutp01g
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
	s=mail20170921; t=1731429122;
	bh=fO/OTNmk4ZkIxUUWP9hECq35FEXHCAw5L7TpQZFyrrk=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=r9jx87aAoAT60wSmq0LNj01LHODnaHm4iTFuxLzAGjRVm/tcJEINh9iTWE7wYAMd4
	 LAclhw9pPDcCRFs+9IBG7yjrXGf8JiOisyjxCN2BuJxRjW5anptOk69VenuKO4L63j
	 C2D2u759/nraMRS5LeA/Ro5XvPDQFxGGkLc+g814=
Received: from epsnrtp1.localdomain (unknown [182.195.42.162]) by
	epcas5p2.samsung.com (KnoxPortal) with ESMTP id
	20241112163201epcas5p20de7f1d5121373334dccef77ee2bcc20~HRZzLDACV1829918299epcas5p2T;
	Tue, 12 Nov 2024 16:32:01 +0000 (GMT)
Received: from epsmgec5p1new.samsung.com (unknown [182.195.38.179]) by
	epsnrtp1.localdomain (Postfix) with ESMTP id 4XnsPr2dQ5z4x9Pp; Tue, 12 Nov
	2024 16:32:00 +0000 (GMT)
Received: from epcas5p2.samsung.com ( [182.195.41.40]) by
	epsmgec5p1new.samsung.com (Symantec Messaging Gateway) with SMTP id
	3A.1F.08574.00383376; Wed, 13 Nov 2024 01:32:00 +0900 (KST)
Received: from epsmtrp2.samsung.com (unknown [182.195.40.14]) by
	epcas5p1.samsung.com (KnoxPortal) with ESMTPA id
	20241112140022epcas5p149b2709709e7a52109dfca99cefc4663~HPVZYeMAs2906529065epcas5p1Q;
	Tue, 12 Nov 2024 14:00:22 +0000 (GMT)
Received: from epsmgms1p1new.samsung.com (unknown [182.195.42.41]) by
	epsmtrp2.samsung.com (KnoxPortal) with ESMTP id
	20241112140022epsmtrp26ef2ac422dfa4f075d1bb656973e7bbd~HPVZXxwZl0763707637epsmtrp2b;
	Tue, 12 Nov 2024 14:00:22 +0000 (GMT)
X-AuditID: b6c32a44-6dbff7000000217e-fc-67338300c3af
Received: from epsmtip2.samsung.com ( [182.195.34.31]) by
	epsmgms1p1new.samsung.com (Symantec Messaging Gateway) with SMTP id
	A5.00.35203.67F53376; Tue, 12 Nov 2024 23:00:22 +0900 (KST)
Received: from ubuntu (unknown [107.99.41.245]) by epsmtip2.samsung.com
	(KnoxPortal) with ESMTPA id
	20241112140020epsmtip2d85a84822d57f03f02e4212268895bda~HPVXfWIw20570005700epsmtip2t;
	Tue, 12 Nov 2024 14:00:20 +0000 (GMT)
Date: Tue, 12 Nov 2024 19:22:33 +0530
From: Nitesh Shetty <nj.shetty@samsung.com>
To: Bart Van Assche <bvanassche@acm.org>
Cc: Javier Gonzalez <javier.gonz@samsung.com>, Matthew Wilcox
	<willy@infradead.org>, Keith Busch <kbusch@kernel.org>, Christoph Hellwig
	<hch@lst.de>, Keith Busch <kbusch@meta.com>, "linux-block@vger.kernel.org"
	<linux-block@vger.kernel.org>, "linux-nvme@lists.infradead.org"
	<linux-nvme@lists.infradead.org>, "linux-scsi@vger.kernel.org"
	<linux-scsi@vger.kernel.org>, "io-uring@vger.kernel.org"
	<io-uring@vger.kernel.org>, "linux-fsdevel@vger.kernel.org"
	<linux-fsdevel@vger.kernel.org>, "joshi.k@samsung.com" <joshi.k@samsung.com>
Subject: Re: [PATCHv10 0/9] write hints with nvme fdp, scsi streams
Message-ID: <20241112135233.2iwgwe443rnuivyb@ubuntu>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
In-Reply-To: <a7ebd158-692c-494c-8cc0-a82f9adf4db0@acm.org>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrAJsWRmVeSWpSXmKPExsWy7bCmhi5Ds3G6wdVV/BbTPvxktli5+iiT
	xbvWcywWj+98Zrc4+v8tm8WkQ9cYLc5cXchisfeWtsWevSdZLOYve8pu0X19B5vF7x9z2Bx4
	PC5f8fbYvELLY9OqTjaPzUvqPXbfbGDzOHexwqNvyypGj8+b5AI4orJtMlITU1KLFFLzkvNT
	MvPSbZW8g+Od403NDAx1DS0tzJUU8hJzU22VXHwCdN0yc4AuVVIoS8wpBQoFJBYXK+nb2RTl
	l5akKmTkF5fYKqUWpOQUmBToFSfmFpfmpevlpZZYGRoYGJkCFSZkZ0x/8p+x4L5Exb6Pz9ka
	GH8KdzFyckgImEhcm/eYsYuRi0NIYDejxIQHLawgCSGBT4wS2y8mQCS+MUr0vb/P1sXIAdbR
	2R8PEd/LKHFw2lM2COcJo0TrpweMIN0sAqoShxZPZwJpYBPQljj9nwMkLCKgIfHtwXIWkHpm
	gYUsEr8/3mQBSQgLOEv0zL0L1ssLtODK6kNMELagxMmZT8BqOAWsJRrf/meDOHslh8TbhaEQ
	tovExPanjBC2sMSr41vYIWwpic/v9kLVl0usnLIC7FAJgRZGiVnXZ0E12Eu0nupnBjmUWSBD
	4twfd4iwrMTUU+vAbmAW4JPo/f2ECSLOK7FjHoytLLFm/QKo+ZIS1743QtkeEvO//oQG6XVm
	ie53ExknMMrNQvLPLIR1s8BWWEl0fmhihQhLSyz/xwFhakqs36W/gJF1FaNkakFxbnpqsmmB
	YV5qOTyKk/NzNzGCk66Wyw7GG/P/6R1iZOJgPMQowcGsJMJ7ytk4XYg3JbGyKrUoP76oNCe1
	+BCjKTB6JjJLiSbnA9N+Xkm8oYmlgYmZmZmJpbGZoZI47+vWuSlCAumJJanZqakFqUUwfUwc
	nFINTDd9J97U+ZMl7hUumGLdymrNOcm5umd5W94E0ZXK3u6M1yRn1626r59TY/Hs5uK1HAc6
	b82b/4OJb+bL05Lb2fkbA3L2BDaWLpxaWDLxZXCKf4OpxZ79q+Wecuzy5JubvXq17dWZlctf
	KWWofL4Qr5Y56+OUgxVnIm6fDM6TUNhRtdg7IdA7VWWDwdp2BXE9JfabSsePOOxxeiHWZ7kr
	9+qMjQJBNYX2U+8tnBS4+5PDjHJGi2v2XbbsX5mP2th+kjmwrfxanLAvB9urhx5N94/2VX3+
	zaR1KdTVfY8q3zQGjwmFlRLdeyyERd9duKW5c4nZ9GAhA99LP+dv+WV12rdl4Y6oyzqePAmC
	aq4/lViKMxINtZiLihMBYi0trUMEAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrMLMWRmVeSWpSXmKPExsWy7bCSvG5ZvHG6welFahbTPvxktli5+iiT
	xbvWcywWj+98Zrc4+v8tm8WkQ9cYLc5cXchisfeWtsWevSdZLOYve8pu0X19B5vF7x9z2Bx4
	PC5f8fbYvELLY9OqTjaPzUvqPXbfbGDzOHexwqNvyypGj8+b5AI4orhsUlJzMstSi/TtErgy
	mtaeYC+YKFaxfspxxgbGo4JdjBwcEgImEp398V2MXBxCArsZJRace8jaxcgJFJeUWPb3CDOE
	LSyx8t9zdoiiR4wSkz6vZANJsAioShxaPJ0JZBCbgLbE6f8cIGERAQ2Jbw+Ws4DUMwssZZG4
	MPc42CBhAWeJnrl3GUFsXqDFV1YfYgKxhQRuM0v8+lgLEReUODnzCQuIzSxgJjFv80NmkPnM
	AtISy/+BzecUsJZofPufbQKjwCwkHbOQdMxC6FjAyLyKUTK1oDg3PbfYsMAwL7Vcrzgxt7g0
	L10vOT93EyM4XrQ0dzBuX/VB7xAjEwfjIUYJDmYlEd5TzsbpQrwpiZVVqUX58UWlOanFhxil
	OViUxHnFX/SmCAmkJ5akZqemFqQWwWSZODilGpi4L7Y3lwYtWnEmZyVjUIpRwvSP2YdOd79d
	MEePUVHrV+qjrredH3UFXh7oNZzslDH/0n2VW6fK/vvJFUje27fj2bdX1YeTLlyKnq6fOzFZ
	7trdBfPXCG3lfH5264dnVuuLeqYdqF0TsnB93fuZT21kZvd9X7lpCa9ktlDoAk3rfy+NHjEI
	KzdenyN5uuHpYn85M8ZTd3li7mhp9Ab1Ggp0ZSy4s+Boy/+q2V89mPj9J31aY7FKYM7lr/t3
	hVYt+3am81kO+66Fz4NzzI01fA84/P/h4qj+K21Xw1tbZqkv53lqdtz5NH9Zsc6qiU6Te0tY
	TgadmLDhbeyT8zfeT92db7C1xtpBaam9F9PligP6TUosxRmJhlrMRcWJADV7k30GAwAA
X-CMS-MailID: 20241112140022epcas5p149b2709709e7a52109dfca99cefc4663
X-Msg-Generator: CA
Content-Type: multipart/mixed;
	boundary="----w5-2f3KIOrSunQhSxAIo7Dy_B_SBAQB3Xz8aCSUoiMSFB8w5=_c2979_"
X-Sendblock-Type: REQ_APPROVE
CMS-TYPE: 105P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20241108165444eucas1p183f631e2710142fbbc7dee9300baf77a
References: <20241105155014.GA7310@lst.de> <Zy0k06wK0ymPm4BV@kbusch-mbp>
	<20241108141852.GA6578@lst.de> <Zy4zgwYKB1f6McTH@kbusch-mbp>
	<CGME20241108165444eucas1p183f631e2710142fbbc7dee9300baf77a@eucas1p1.samsung.com>
	<Zy5CSgNJtgUgBH3H@casper.infradead.org>
	<d7b7a759dd9a45a7845e95e693ec29d7@CAMSVWEXC02.scsc.local>
	<2b5a365a-215a-48de-acb1-b846a4f24680@acm.org>
	<20241111093154.zbsp42gfiv2enb5a@ArmHalley.local>
	<a7ebd158-692c-494c-8cc0-a82f9adf4db0@acm.org>

------w5-2f3KIOrSunQhSxAIo7Dy_B_SBAQB3Xz8aCSUoiMSFB8w5=_c2979_
Content-Type: text/plain; charset="utf-8"; format="flowed"
Content-Disposition: inline

On 11/11/24 09:45AM, Bart Van Assche wrote:
>On 11/11/24 1:31 AM, Javier Gonzalez wrote:
>>On 08.11.2024 10:51, Bart Van Assche wrote:
>>>On 11/8/24 9:43 AM, Javier Gonzalez wrote:
>>>>If there is an interest, we can re-spin this again...
>>>
>>>I'm interested. Work is ongoing in JEDEC on support for copy offloading
>>>for UFS devices. This work involves standardizing which SCSI copy
>>>offloading features should be supported and which features are not
>>>required. Implementations are expected to be available soon.
>>
>>Do you have any specific blockers on the last series? I know you have
>>left comments in many of the patches already, but I think we are all a
>>bit confused on where we are ATM.
>
>Nobody replied to this question that was raised 4 months ago:
>https://lore.kernel.org/linux-block/4c7f30af-9fbc-4f19-8f48-ad741aa557c4@acm.org/
>
>I think we need to agree about the answer to that question before we can
>continue with implementing copy offloading.
>
Yes, even I feel the same.
Blocker with copy has been how we should plumb things in block layer.
A couple of approaches we tried in the past[1].
Restating for reference,

1.payload based approach:
   a. Based on Mikulas patch, here a common payload is used for both source
     and destination bio. 
   b. Initially we send source bio, upon reaching driver we update payload
     and complete the bio.
   c. Send destination bio, in driver layer we recover the source info
     from the payload and send the copy command to device.

   Drawback:
   Request payload contains IO information rather than data.
   Based on past experience Christoph and Bart suggested not a good way
   forward.
   Alternate suggestion from Christoph was to used separate BIOs for src
   and destination and match them using token/id.
   As Bart pointed, I find it hard how to match when the IO split happens.

2. Plug based approach:
   a. Take a plug, send destination bio, form request and wait for src bio
   b. send source bio, merge with destination bio
   c. Upon release of plug send request down to driver.

   Drawback:
   Doesn't work for stacked devices which has async submission.
   Bart suggested this is not good solution overall.
   Alternate suggestion was to use list based approach.
   But we observed lifetime management problems, especially in
   failure handling.

3. Single bio approach:
   a. Use single bio to represent both src and dst info.
   b. Use abnormal IO handling similar to discard.
   Drawback:
   Christoph pointed out that, this will have issue of payload containing
   information for both IO stack and wire.


I am really torn on how to proceed further ?
-- Nitesh Shetty


[1] https://lore.kernel.org/linux-block/20240624103212.2donuac5apwwqaor@nj.shetty@samsung.com/

------w5-2f3KIOrSunQhSxAIo7Dy_B_SBAQB3Xz8aCSUoiMSFB8w5=_c2979_
Content-Type: text/plain; charset="utf-8"


------w5-2f3KIOrSunQhSxAIo7Dy_B_SBAQB3Xz8aCSUoiMSFB8w5=_c2979_--

