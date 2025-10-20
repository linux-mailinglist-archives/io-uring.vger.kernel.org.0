Return-Path: <io-uring+bounces-10060-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [142.0.200.124])
	by mail.lfdr.de (Postfix) with ESMTPS id 0915BBEFF1C
	for <lists+io-uring@lfdr.de>; Mon, 20 Oct 2025 10:29:34 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id 7AE904F0E2A
	for <lists+io-uring@lfdr.de>; Mon, 20 Oct 2025 08:29:07 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5730B17BB35;
	Mon, 20 Oct 2025 08:26:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b="mTY7+IA9"
X-Original-To: io-uring@vger.kernel.org
Received: from mailout4.samsung.com (mailout4.samsung.com [203.254.224.34])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9CB752EB874
	for <io-uring@vger.kernel.org>; Mon, 20 Oct 2025 08:26:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=203.254.224.34
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760948817; cv=none; b=upokTjmNz7YZcoFEmRKRAUv6ei5ggQMT371NNLHAdjkBx45YbIgoIsEymlgbp6enzemC1vWf7OCcT7WWU5A3SeKH+5czsO38dbqisgAfd1rGb20YBkrUIHK/TFFV/sn9FQB8Dk9KdbF2BbAAvwKXhphIVwOSDzvqDagvutOTnpE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760948817; c=relaxed/simple;
	bh=jb/ehpR8+JoLnYzlieXpBZWmhA8cT5y9pqYcztL/Btw=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version:Content-Type:
	 References; b=MV1TM/ln7yg5sXABdk5krhajbrb4g3NpbCTcqU4v12VPajoitjiU8ZIFKnWfQuc8ybp5DGPKVNl4Rs/Hsp57PKwUwSLdZzl84y01DgVVyiuxJ+vqa4gH9IHzwvrm9ma5hQvK72gRGa6B9dfZl6gCP1Ne3ey5hNOwEhFD3UPQgBk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com; spf=pass smtp.mailfrom=samsung.com; dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b=mTY7+IA9; arc=none smtp.client-ip=203.254.224.34
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samsung.com
Received: from epcas5p2.samsung.com (unknown [182.195.41.40])
	by mailout4.samsung.com (KnoxPortal) with ESMTP id 20251020082652epoutp04005027d9acfe73971aec5851830090a9~wJZ2L9Cyq2122721227epoutp04G
	for <io-uring@vger.kernel.org>; Mon, 20 Oct 2025 08:26:52 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout4.samsung.com 20251020082652epoutp04005027d9acfe73971aec5851830090a9~wJZ2L9Cyq2122721227epoutp04G
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
	s=mail20170921; t=1760948812;
	bh=/YU5/srCLBQzANqXelQRrOe0/MyCPq+UHXhSCmdp+lI=;
	h=From:To:Cc:Subject:Date:References:From;
	b=mTY7+IA9IUEnMRefiJL6Psvg9fqcWotWmfQF2RXgtrZG6i2mGSMKsT+F2DL9GPCvC
	 usyK1qbHK7v45WQCyLLcZBAcBdIiJ6rX898BsSnmB1EJdKIiqK8Y25J9/NGVeeChSU
	 igBv2VXoVuA8NPrLAIIdccUGBz4zA4BYdBTcmnss=
Received: from epsnrtp01.localdomain (unknown [182.195.42.153]) by
	epcas5p4.samsung.com (KnoxPortal) with ESMTPS id
	20251020082652epcas5p4ba5d48e54ed12d72d8d21749b0079772~wJZ1s2aAy1524115241epcas5p4m;
	Mon, 20 Oct 2025 08:26:52 +0000 (GMT)
Received: from epcas5p4.samsung.com (unknown [182.195.38.86]) by
	epsnrtp01.localdomain (Postfix) with ESMTP id 4cqpSC4Hn0z6B9mG; Mon, 20 Oct
	2025 08:26:51 +0000 (GMT)
Received: from epsmtip1.samsung.com (unknown [182.195.34.30]) by
	epcas5p4.samsung.com (KnoxPortal) with ESMTPA id
	20251020080512epcas5p4d3abbe6719fcb78fd65aea0524d85165~wJG7FdVX31621516215epcas5p4K;
	Mon, 20 Oct 2025 08:05:12 +0000 (GMT)
Received: from node122.. (unknown [109.105.118.122]) by epsmtip1.samsung.com
	(KnoxPortal) with ESMTPA id
	20251020080510epsmtip17e7e99e33754ab8fc09ee24c8af2f4e9~wJG5i7euU0836508365epsmtip1Y;
	Mon, 20 Oct 2025 08:05:10 +0000 (GMT)
From: Xiaobing Li <xiaobing.li@samsung.com>
To: miklos@szeredi.hu
Cc: axboe@kernel.dk, linux-fsdevel@vger.kernel.org,
	io-uring@vger.kernel.org, bschubert@ddn.com, kbusch@kernel.org,
	amir73il@gmail.com, asml.silence@gmail.com, dw@davidwei.uk,
	josef@toxicpanda.com, joannelkoong@gmail.com, tom.leiming@gmail.com,
	joshi.k@samsung.com, kun.dou@samsung.com, peiwei.li@samsung.com,
	xue01.he@samsung.com
Subject: [RFC] fuse: fuse support zero copy.
Date: Mon, 20 Oct 2025 08:00:43 +0000
Message-Id: <20251020080043.6638-1-xiaobing.li@samsung.com>
X-Mailer: git-send-email 2.34.1
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CMS-MailID: 20251020080512epcas5p4d3abbe6719fcb78fd65aea0524d85165
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: REQ_APPROVE
CMS-TYPE: 105P
cpgsPolicy: CPGSC10-505,Y
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20251020080512epcas5p4d3abbe6719fcb78fd65aea0524d85165
References: <CGME20251020080512epcas5p4d3abbe6719fcb78fd65aea0524d85165@epcas5p4.samsung.com>

DDN has enabled Fuse to support the io-uring solution, allowing us 
to implement zero copy on this basis to further improve performance.

We have currently implemented zero copy using io-uring's fixed-buf 
feature, further improving Fuse read performance. The general idea is 
to first register a shared memory space through io_uring. 
Then, libfuse in user space directly stores the read data into 
the registered memory. The kernel then uses the io_uring_cmd_import_fixed 
interface to directly retrieve the read results from the 
shared memory, eliminating the need to copy data from user space to 
kernel space.

The test data is as follows:

4K IO size                                                           gain
-------------------------------------------------------------------------
                               |   no zero copy   |    zero copy  |  
rw         iodepth     numjobs |      IOPS        |      IOPS     |    
read          1           1    |      93K         |      97K      |  1.04
read          16          16   |      169K        |      172K     |  1.02
read          16          32   |      172K        |      173K     |  1.01
read          32          16   |      169K        |      171K     |  1.01
read          32          32   |      172K        |      173K     |  1.01
randread      1           1    |      116K        |      136K     |  1.17
randread      1           32   |      985K        |      994K     |  1.01
randread      64          1    |      234K        |      261K     |  1.12
randread      64          16   |      166K        |      168K     |  1.01
randread      64          32   |      168K        |      170K     |  1.01

128K IO size                                                         gain
-------------------------------------------------------------------------
                               |   no zero copy   |    zero copy  |
rw         iodepth     numjobs |      IOPS        |      IOPS     |  
read           1          1    |      24K         |      28K      |  1.17
read           16         1    |      17K         |      19K      |  1.12
read           64         1    |      17K         |      19K      |  1.12
read           64         16   |      51K         |      55K      |  1.08
read           64         32   |      54K         |      56K      |  1.04
randread       1          1    |      24K         |      25K      |  1.04
randread       16         1    |      17K         |      19K      |  1.12
randread       64         1    |      16K         |      19K      |  1.19
randread       64         16   |      50K         |      54K      |  1.08
randread       64         32   |      49K         |      55K      |  1.12
-------------------------------------------------------------------------

I will list the code after this solution is confirmed to be feasible.

