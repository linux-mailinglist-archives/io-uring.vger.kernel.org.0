Return-Path: <io-uring+bounces-2521-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 8CADC933C8A
	for <lists+io-uring@lfdr.de>; Wed, 17 Jul 2024 13:50:24 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 34E701F21D20
	for <lists+io-uring@lfdr.de>; Wed, 17 Jul 2024 11:50:24 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AE5BC18003B;
	Wed, 17 Jul 2024 11:49:58 +0000 (UTC)
X-Original-To: io-uring@vger.kernel.org
Received: from szxga01-in.huawei.com (szxga01-in.huawei.com [45.249.212.187])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7C1D717FAA9;
	Wed, 17 Jul 2024 11:49:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.187
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721216998; cv=none; b=ZgEKiXMaVf3ZeTqqzAoVsSSFCzIQOycoAB5fF1CGeoqvqle3CieEkp47QgqsNWYvUvBhuPOaAZUHa8hWj7kV6J011WIV3bimZpKs5Yi8X/uYi5WLnW2GBIkcclYsWfLJukBz+rQZIpgR13D76JKAqtp+z7D5x3ZS/8HRfnnBczg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721216998; c=relaxed/simple;
	bh=n3+YoDS+Xgfj3kY/YCOeRAIa9f+VPaDv3q5QYO/6YpE=;
	h=Message-ID:Date:MIME-Version:Subject:To:CC:References:From:
	 In-Reply-To:Content-Type; b=qHIWJPMkwZQ93QsdSddh//dyWqFbv42+FOgptIwq9ZvGfnP3W8ozAWUIBaNxUOaV1CTqizB0xr4bICvxPwKJ4fz6YKF2TTANK8qTH03wCErWeYhEK98st11wG61rH4R7ZZEfoZn82JiozU1lKYEB/naotjTX2rp793B6dQGYJjc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; arc=none smtp.client-ip=45.249.212.187
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Received: from mail.maildlp.com (unknown [172.19.163.252])
	by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4WPDdJ3nf4zxWSK;
	Wed, 17 Jul 2024 19:45:08 +0800 (CST)
Received: from dggpemd200001.china.huawei.com (unknown [7.185.36.224])
	by mail.maildlp.com (Postfix) with ESMTPS id 766191800A1;
	Wed, 17 Jul 2024 19:49:51 +0800 (CST)
Received: from [10.174.178.209] (10.174.178.209) by
 dggpemd200001.china.huawei.com (7.185.36.224) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1258.34; Wed, 17 Jul 2024 19:49:51 +0800
Message-ID: <18634c7e-b234-ac02-20f8-4d5426733679@huawei.com>
Date: Wed, 17 Jul 2024 19:49:50 +0800
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.11.2
Subject: Re: CVE-2024-41001: io_uring/sqpoll: work around a potential audit
 memory leak
To: <cve@kernel.org>, <linux-kernel@vger.kernel.org>,
	<linux-cve-announce@vger.kernel.org>, <axboe@kernel.dk>
CC: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	<io-uring@vger.kernel.org>
References: <2024071253-CVE-2024-41001-7879@gregkh>
From: Wang Zhaolong <wangzhaolong1@huawei.com>
In-Reply-To: <2024071253-CVE-2024-41001-7879@gregkh>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: dggems703-chm.china.huawei.com (10.3.19.180) To
 dggpemd200001.china.huawei.com (7.185.36.224)

Hello,

I was confused when reviewing the fix for CVE-2024-41001.
To better understand the issue and the proposed solution, I would
greatly appreciate your help in clarifying the following points:

1. What was the original patch that introduced this issue (any Fixes tag)?
2. Is the leaking variable member the "context->sockaddr"?
3. Could you shed some light on how the reference to the leaked memory is
    lost during the transition from the prep phase to the issue phase?
4. The fix introduces a NOP operation "before the SQPOLL does anything."
    How does this addition of a NOP operation prevent the memory leak from
    occurring?

Thank you in advance for taking the time to address my questions. Your
insights will help me better understand this fix.

Best regards,
Wang Zhaolong

> Description
> ===========
> 
> In the Linux kernel, the following vulnerability has been resolved:
> 
> io_uring/sqpoll: work around a potential audit memory leak
> 
> kmemleak complains that there's a memory leak related to connect
> handling:
> 
> unreferenced object 0xffff0001093bdf00 (size 128):
> comm "iou-sqp-455", pid 457, jiffies 4294894164
> hex dump (first 32 bytes):
> 02 00 fa ea 7f 00 00 01 00 00 00 00 00 00 00 00  ................
> 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
> backtrace (crc 2e481b1a):
> [<00000000c0a26af4>] kmemleak_alloc+0x30/0x38
> [<000000009c30bb45>] kmalloc_trace+0x228/0x358
> [<000000009da9d39f>] __audit_sockaddr+0xd0/0x138
> [<0000000089a93e34>] move_addr_to_kernel+0x1a0/0x1f8
> [<000000000b4e80e6>] io_connect_prep+0x1ec/0x2d4
> [<00000000abfbcd99>] io_submit_sqes+0x588/0x1e48
> [<00000000e7c25e07>] io_sq_thread+0x8a4/0x10e4
> [<00000000d999b491>] ret_from_fork+0x10/0x20
> 
> which can can happen if:
> 
> 1) The command type does something on the prep side that triggers an
>     audit call.
> 2) The thread hasn't done any operations before this that triggered
>     an audit call inside ->issue(), where we have audit_uring_entry()
>     and audit_uring_exit().
> 
> Work around this by issuing a blanket NOP operation before the SQPOLL
> does anything.
> 
> The Linux kernel CVE team has assigned CVE-2024-41001 to this issue.


