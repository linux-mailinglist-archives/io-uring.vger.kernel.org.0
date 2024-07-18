Return-Path: <io-uring+bounces-2524-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id ED810934F41
	for <lists+io-uring@lfdr.de>; Thu, 18 Jul 2024 16:42:17 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 9C2B01F235A4
	for <lists+io-uring@lfdr.de>; Thu, 18 Jul 2024 14:42:17 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 960A3143C55;
	Thu, 18 Jul 2024 14:41:44 +0000 (UTC)
X-Original-To: io-uring@vger.kernel.org
Received: from szxga03-in.huawei.com (szxga03-in.huawei.com [45.249.212.189])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EDEC712C7FB;
	Thu, 18 Jul 2024 14:41:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.189
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721313704; cv=none; b=JZKZ5Gn6LCcgheuffTNv9cRrpMnb5nqT2dflzZ22rjBBh+zr+dGdu/eX1eG7AV8dY5eceijBpDqptoFwLOwryMj7mdKl7FrvveJvvonAgFOU1/FL8EBLtW6hBROOUzgI4YRl3q98521WzQEA394TSLL9URPp6ESozRE3tMuXBzI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721313704; c=relaxed/simple;
	bh=iXzyFsVsJ6bOJ/aYkV/P6u+K+L2f9NSjbK9pGavbBIM=;
	h=Message-ID:Date:MIME-Version:Subject:From:To:CC:References:
	 In-Reply-To:Content-Type; b=ucw4gNiH4re51MxeDQAOPWxGjMC1yPJVgTGcPNspJmJBVtl7hQRvTXXCv1j5ERYbBnQD3fvol9nuvFxyadRBfgdOfWQjID6shZiI9t1SEkzn67jQWbr3kmgP8HghjjPShoqcm+5nu3fQ3vU+tG3eKDoGp//HXdKAMQsMfafHI9I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; arc=none smtp.client-ip=45.249.212.189
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Received: from mail.maildlp.com (unknown [172.19.163.252])
	by szxga03-in.huawei.com (SkyGuard) with ESMTP id 4WPwPn1y2DzQlmF;
	Thu, 18 Jul 2024 22:37:33 +0800 (CST)
Received: from dggpemd200001.china.huawei.com (unknown [7.185.36.224])
	by mail.maildlp.com (Postfix) with ESMTPS id 1570F18009D;
	Thu, 18 Jul 2024 22:41:38 +0800 (CST)
Received: from [10.174.178.209] (10.174.178.209) by
 dggpemd200001.china.huawei.com (7.185.36.224) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1258.34; Thu, 18 Jul 2024 22:41:37 +0800
Message-ID: <4457af52-01a2-be1b-9d13-486b6bd8e579@huawei.com>
Date: Thu, 18 Jul 2024 22:41:37 +0800
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
From: Wang Zhaolong <wangzhaolong1@huawei.com>
To: <cve@kernel.org>, <linux-kernel@vger.kernel.org>,
	<linux-cve-announce@vger.kernel.org>, <axboe@kernel.dk>
CC: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	<io-uring@vger.kernel.org>
References: <2024071253-CVE-2024-41001-7879@gregkh>
 <18634c7e-b234-ac02-20f8-4d5426733679@huawei.com>
In-Reply-To: <18634c7e-b234-ac02-20f8-4d5426733679@huawei.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: dggems703-chm.china.huawei.com (10.3.19.180) To
 dggpemd200001.china.huawei.com (7.185.36.224)

Hello,

I think a possible reason for the leak scenario is:

When `audit_context->dummy` is 0. __audit_sockaddr() allocates sockaddr.

In the below process, audit_reset_context() return early. ctx->sockaddr
is not released.

   io_issue_sqe
     audit_uring_entry
       __audit_uring_entry
         ctx->dummy -- set dummy as non-zero
     def->issue()
     audit_uring_exit
       __audit_uring_exit
         audit_reset_context

static void audit_reset_context(struct audit_context *ctx)
{
     ......
     /* if ctx is non-null, reset the "ctx->context" regardless */
     ctx->context = AUDIT_CTX_UNUSED;
     if (ctx->dummy)
         return;

     ......
     kfree(ctx->sockaddr);
     ......
}

The `audit_uring_entry(IORING_OP_NOP);` statement initializes the 'dummy' once at the
beginning to ensure that ctx->sockaddr is allocated and deallocated in pairs later
in the process.

According to the above analysis, I think the fixes tag should be
5bd2182d58e9 ("audit,io_uring,io-wq: add some basic audit support to io_uring")
Is my understanding correct?

I look forward to hearing back.

Best regards,
Wang Zhaolong

> Hello,
> 
> I was confused when reviewing the fix for CVE-2024-41001.
> To better understand the issue and the proposed solution, I would
> greatly appreciate your help in clarifying the following points:
> 
> 1. What was the original patch that introduced this issue (any Fixes tag)?
> 2. Is the leaking variable member the "context->sockaddr"?
> 3. Could you shed some light on how the reference to the leaked memory is
>     lost during the transition from the prep phase to the issue phase?
> 4. The fix introduces a NOP operation "before the SQPOLL does anything."
>     How does this addition of a NOP operation prevent the memory leak from
>     occurring?
> 
> Thank you in advance for taking the time to address my questions. Your
> insights will help me better understand this fix.
> 
> Best regards,
> Wang Zhaolong
> 
>> Description
>> ===========
>>
>> In the Linux kernel, the following vulnerability has been resolved:
>>
>> io_uring/sqpoll: work around a potential audit memory leak
>>
>> kmemleak complains that there's a memory leak related to connect
>> handling:
>>
>> unreferenced object 0xffff0001093bdf00 (size 128):
>> comm "iou-sqp-455", pid 457, jiffies 4294894164
>> hex dump (first 32 bytes):
>> 02 00 fa ea 7f 00 00 01 00 00 00 00 00 00 00 00  ................
>> 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
>> backtrace (crc 2e481b1a):
>> [<00000000c0a26af4>] kmemleak_alloc+0x30/0x38
>> [<000000009c30bb45>] kmalloc_trace+0x228/0x358
>> [<000000009da9d39f>] __audit_sockaddr+0xd0/0x138
>> [<0000000089a93e34>] move_addr_to_kernel+0x1a0/0x1f8
>> [<000000000b4e80e6>] io_connect_prep+0x1ec/0x2d4
>> [<00000000abfbcd99>] io_submit_sqes+0x588/0x1e48
>> [<00000000e7c25e07>] io_sq_thread+0x8a4/0x10e4
>> [<00000000d999b491>] ret_from_fork+0x10/0x20
>>
>> which can can happen if:
>>
>> 1) The command type does something on the prep side that triggers an
>>     audit call.
>> 2) The thread hasn't done any operations before this that triggered
>>     an audit call inside ->issue(), where we have audit_uring_entry()
>>     and audit_uring_exit().
>>
>> Work around this by issuing a blanket NOP operation before the SQPOLL
>> does anything.
>>
>> The Linux kernel CVE team has assigned CVE-2024-41001 to this issue.
> 


