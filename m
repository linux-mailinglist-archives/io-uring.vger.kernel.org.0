Return-Path: <io-uring+bounces-10073-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [IPv6:2605:f480:58:1:0:1994:3:14])
	by mail.lfdr.de (Postfix) with ESMTPS id 3B754BF4EEA
	for <lists+io-uring@lfdr.de>; Tue, 21 Oct 2025 09:23:58 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id 4B6F74FEE44
	for <lists+io-uring@lfdr.de>; Tue, 21 Oct 2025 07:19:19 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1F0B3274B4A;
	Tue, 21 Oct 2025 07:19:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b="vCPAdT6i"
X-Original-To: io-uring@vger.kernel.org
Received: from mailout4.samsung.com (mailout4.samsung.com [203.254.224.34])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 98DB725C822
	for <io-uring@vger.kernel.org>; Tue, 21 Oct 2025 07:19:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=203.254.224.34
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761031153; cv=none; b=I3FjFOz6hd0c4W1OXEiuj8MyS1NkEh74lDIqPht92udJqtElfCLQ33MbL0ELqWIeD/viK7BhQJPhTozCdOdPciA5Jpze1h5ZSMYhTOXPzsR8SAV3xxZ1XyTmDovTud4zJ7Zeo1g+2ALfCwcdFOEd+HR4hzqWHwW/PLVQkIhOr6I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761031153; c=relaxed/simple;
	bh=1BJD1LIFzFYxsQCDQgH3rOU8TKZl+FUQ7wY/gwtXRU8=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:MIME-Version:
	 Content-Type:References; b=YFZ+SQ4/yx91oxrURfHKwykNfWUslWlKPe3zzGatitt+sPuogpX2Vr9s38SHOYCwCDeq0qLgy7jFjbjTnXtlXjn8GvrgqnMk3JtcUjaDLnNRjqxMIXKpdPa3a4uKZIUdGEsyFvFIHt7h1ep4NWG+jEzKNQQ3gsmrgmSqEXv4AoY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com; spf=pass smtp.mailfrom=samsung.com; dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b=vCPAdT6i; arc=none smtp.client-ip=203.254.224.34
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samsung.com
Received: from epcas5p2.samsung.com (unknown [182.195.41.40])
	by mailout4.samsung.com (KnoxPortal) with ESMTP id 20251021071902epoutp04bc8b2463e2b3a84f6caa2e88ec8bb9c7~wcH6CVnzh0924709247epoutp04Y
	for <io-uring@vger.kernel.org>; Tue, 21 Oct 2025 07:19:02 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout4.samsung.com 20251021071902epoutp04bc8b2463e2b3a84f6caa2e88ec8bb9c7~wcH6CVnzh0924709247epoutp04Y
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
	s=mail20170921; t=1761031142;
	bh=8wASAtboqV3GtUcbOgLV9UfZhmV4Pe0fo2rSqAE3M44=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=vCPAdT6iMiUdBsK9MvZt7++ngOZbgQO1dS9161YRpGhA23XLRnLiCC8PEoWU/LTL5
	 8QPgOGQfwSeYXrXLLVSn6q00iOP/n4gEMLvw4pvdYdUDeg08hc6iSLGOWEoaFnf8sy
	 G78ZL0GqLPwqmRhmUcbI/Y6kG7CXvj+HxR3ZEJEM=
Received: from epsnrtp03.localdomain (unknown [182.195.42.155]) by
	epcas5p2.samsung.com (KnoxPortal) with ESMTPS id
	20251021071902epcas5p22aca6ccb22ada9efd17cb78a96a7c70c~wcH5gFtAJ0239402394epcas5p2W;
	Tue, 21 Oct 2025 07:19:02 +0000 (GMT)
Received: from epcas5p4.samsung.com (unknown [182.195.38.94]) by
	epsnrtp03.localdomain (Postfix) with ESMTP id 4crNvT4cQFz3hhTD; Tue, 21 Oct
	2025 07:19:01 +0000 (GMT)
Received: from epsmtip2.samsung.com (unknown [182.195.34.31]) by
	epcas5p3.samsung.com (KnoxPortal) with ESMTPA id
	20251021052840epcas5p36d502a54805a8ba37c2929bb314088d4~waniyqJyM2751027510epcas5p3q;
	Tue, 21 Oct 2025 05:28:40 +0000 (GMT)
Received: from node122.. (unknown [109.105.118.122]) by epsmtip2.samsung.com
	(KnoxPortal) with ESMTPA id
	20251021052839epsmtip264cfd4682038d2505237fb233e4abd22~wanhb7LKN2619626196epsmtip2p;
	Tue, 21 Oct 2025 05:28:39 +0000 (GMT)
From: Xiaobing Li <xiaobing.li@samsung.com>
To: axboe@kernel.dk
Cc: miklos@szeredi.hu, linux-fsdevel@vger.kernel.org,
	io-uring@vger.kernel.org, bschubert@ddn.com, kbusch@kernel.org,
	amir73il@gmail.com, asml.silence@gmail.com, dw@davidwei.uk,
	josef@toxicpanda.com, joannelkoong@gmail.com, tom.leiming@gmail.com,
	joshi.k@samsung.com, kun.dou@samsung.com, peiwei.li@samsung.com,
	xue01.he@samsung.com
Subject: Re:Re:[RFC] fuse: fuse support zero copy.
Date: Tue, 21 Oct 2025 05:24:11 +0000
Message-Id: <20251021052411.5293-1-xiaobing.li@samsung.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <1207928c-ad37-4ba0-b473-d38b9b2ce13c@kernel.dk>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CMS-MailID: 20251021052840epcas5p36d502a54805a8ba37c2929bb314088d4
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: REQ_APPROVE
CMS-TYPE: 105P
cpgsPolicy: CPGSC10-505,Y
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20251021052840epcas5p36d502a54805a8ba37c2929bb314088d4
References: <1207928c-ad37-4ba0-b473-d38b9b2ce13c@kernel.dk>
	<CGME20251021052840epcas5p36d502a54805a8ba37c2929bb314088d4@epcas5p3.samsung.com>

On 10/20/25 10:15:00 AM, Jens Axboe wrote:
>On 10/20/25 2:00 AM, Xiaobing Li wrote:
>> DDN has enabled Fuse to support the io-uring solution, allowing us 
>> to implement zero copy on this basis to further improve performance.
>> 
>> We have currently implemented zero copy using io-uring's fixed-buf 
>> feature, further improving Fuse read performance. The general idea is 
>> to first register a shared memory space through io_uring. 
>> Then, libfuse in user space directly stores the read data into 
>> the registered memory. The kernel then uses the io_uring_cmd_import_fixed 
>> interface to directly retrieve the read results from the 
>> shared memory, eliminating the need to copy data from user space to 
>> kernel space.
>> 
>> The test data is as follows:
>> 
>> 4K IO size                                                           gain
>> -------------------------------------------------------------------------
>>                                |   no zero copy   |    zero copy  |  
>> rw         iodepth     numjobs |      IOPS        |      IOPS     |    
>> read          1           1    |      93K         |      97K      |  1.04
>> read          16          16   |      169K        |      172K     |  1.02
>> read          16          32   |      172K        |      173K     |  1.01
>> read          32          16   |      169K        |      171K     |  1.01
>> read          32          32   |      172K        |      173K     |  1.01
>> randread      1           1    |      116K        |      136K     |  1.17
>> randread      1           32   |      985K        |      994K     |  1.01
>> randread      64          1    |      234K        |      261K     |  1.12
>> randread      64          16   |      166K        |      168K     |  1.01
>> randread      64          32   |      168K        |      170K     |  1.01
>> 
>> 128K IO size                                                         gain
>> -------------------------------------------------------------------------
>>                                |   no zero copy   |    zero copy  |
>> rw         iodepth     numjobs |      IOPS        |      IOPS     |  
>> read           1          1    |      24K         |      28K      |  1.17
>> read           16         1    |      17K         |      19K      |  1.12
>> read           64         1    |      17K         |      19K      |  1.12
>> read           64         16   |      51K         |      55K      |  1.08
>> read           64         32   |      54K         |      56K      |  1.04
>> randread       1          1    |      24K         |      25K      |  1.04
>> randread       16         1    |      17K         |      19K      |  1.12
>> randread       64         1    |      16K         |      19K      |  1.19
>> randread       64         16   |      50K         |      54K      |  1.08
>> randread       64         32   |      49K         |      55K      |  1.12
>> -------------------------------------------------------------------------
>> 
>> I will list the code after this solution is confirmed to be feasible.
>
>Can you post the patches? A bit hard to tell if something is feasible or
>the right direction without them :-)

Ok, I'll send the patch when I'm ready.

--
Xiaobing Li

