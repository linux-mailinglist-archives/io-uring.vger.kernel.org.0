Return-Path: <io-uring+bounces-13319-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id gGe/IU4mBWq3SwIAu9opvQ
	(envelope-from <io-uring+bounces-13319-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Thu, 14 May 2026 03:33:02 +0200
X-Original-To: lists+io-uring@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id B1A9053CB9B
	for <lists+io-uring@lfdr.de>; Thu, 14 May 2026 03:33:01 +0200 (CEST)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 1748E3014BC7
	for <lists+io-uring@lfdr.de>; Thu, 14 May 2026 01:32:58 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 72FE22FF164;
	Thu, 14 May 2026 01:32:57 +0000 (UTC)
X-Original-To: io-uring@vger.kernel.org
Received: from dggsgout12.his.huawei.com (dggsgout12.his.huawei.com [45.249.212.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 80BAE31A053;
	Thu, 14 May 2026 01:32:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.56
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778722377; cv=none; b=Cdgkzdu91Da5MC5bvzb8bg3c6btI/ad5YVEYPtAjywfcYpspf8Fh9xfs9cbpR1UTZXYIGa9XZCTSqO/peCzibrqGv/7MnOhl6ErHtzWIRWMQK997Nc00wgFoEjb2RK18ZsPNXCLJQn68pXT5I+PKDIOQQH/psbfTYvVElIHumKc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778722377; c=relaxed/simple;
	bh=X1Y0VIR9BQZwAP6ngkxtYijkqaCrKOH0thxIzz4qs88=;
	h=Message-ID:Date:MIME-Version:From:Subject:To:Cc:References:
	 In-Reply-To:Content-Type; b=DqdbluKzzWXdprdZX6+uOX/kC8olXrb6rudn1z+vGmWFCeG+xWyNltQI4hqPO+WWXEPB0TCxt6Kna5Rv8nooMAZH4o2ggSAZtXk2M3im9n/nNWa+PQELc6oyJiBDrvZv8zHH/uJrr/VRM/PhZuEKDfzsFi4o4M3+lAUElgAO8WQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com; spf=pass smtp.mailfrom=huaweicloud.com; arc=none smtp.client-ip=45.249.212.56
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huaweicloud.com
Received: from mail.maildlp.com (unknown [172.19.163.198])
	by dggsgout12.his.huawei.com (SkyGuard) with ESMTPS id 4gGCVL3WXyzKHMQy;
	Thu, 14 May 2026 09:31:54 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.128])
	by mail.maildlp.com (Postfix) with ESMTP id 69B8740574;
	Thu, 14 May 2026 09:32:49 +0800 (CST)
Received: from [10.174.176.179] (unknown [10.174.176.179])
	by APP4 (Coremail) with SMTP id gCh0CgAX31o4JgVqOPvdCA--.34519S3;
	Thu, 14 May 2026 09:32:49 +0800 (CST)
Message-ID: <b4c6d8c5-1423-4443-b3c4-92c399e0cb6d@huaweicloud.com>
Date: Thu, 14 May 2026 09:32:40 +0800
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
From: Zizhi Wo <wozizhi@huaweicloud.com>
Subject: Re: [PATCH] io_uring: validate user-controlled cq.head in
 io_cqe_cache_refill()
To: Jens Axboe <axboe@kernel.dk>, asml.silence@gmail.com,
 io-uring@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, yangerkun@huawei.com,
 chengzhihao1@huawei.com
References: <20260513063254.1122354-1-wozizhi@huaweicloud.com>
 <f8dc69f8-7191-4c60-a2a3-2fa85a089927@kernel.dk>
 <36e2e080-0fe0-4108-8a27-3be8b10ef97b@kernel.dk>
In-Reply-To: <36e2e080-0fe0-4108-8a27-3be8b10ef97b@kernel.dk>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:gCh0CgAX31o4JgVqOPvdCA--.34519S3
X-Coremail-Antispam: 1UD129KBjvJXoW7CFW5JFWruryDuw1DtFykGrg_yoW8Aw1xpF
	WUt3WYgrZYvry7Ka4DZr4rtryftrsFyrs3JrWfGa4UtFyfuFnxKF1rKryFkFWvvrZ7Cr12
	yFsI9rZIyrs8ZaDanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUUylb4IE77IF4wAFF20E14v26r4j6ryUM7CY07I20VC2zVCF04k2
	6cxKx2IYs7xG6rWj6s0DM7CIcVAFz4kK6r1j6r18M28lY4IEw2IIxxk0rwA2F7IY1VAKz4
	vEj48ve4kI8wA2z4x0Y4vE2Ix0cI8IcVAFwI0_tr0E3s1l84ACjcxK6xIIjxv20xvEc7Cj
	xVAFwI0_Gr1j6F4UJwA2z4x0Y4vEx4A2jsIE14v26rxl6s0DM28EF7xvwVC2z280aVCY1x
	0267AKxVW0oVCq3wAS0I0E0xvYzxvE52x082IY62kv0487Mc02F40EFcxC0VAKzVAqx4xG
	6I80ewAv7VC0I7IYx2IY67AKxVWUAVWUtwAv7VC2z280aVAFwI0_Jr0_Gr1lOx8S6xCaFV
	Cjc4AY6r1j6r4UM4x0Y48IcVAKI48JMxkF7I0En4kS14v26r126r1DMxAIw28IcxkI7VAK
	I48JMxC20s026xCaFVCjc4AY6r1j6r4UMI8I3I0E5I8CrVAFwI0_Jr0_Jr4lx2IqxVCjr7
	xvwVAFwI0_JrI_JrWlx4CE17CEb7AF67AKxVWUAVWUtwCIc40Y0x0EwIxGrwCI42IY6xII
	jxv20xvE14v26r1j6r1xMIIF0xvE2Ix0cI8IcVCY1x0267AKxVWUJVW8JwCI42IY6xAIw2
	0EY4v20xvaj40_Jr0_JF4lIxAIcVC2z280aVAFwI0_Jr0_Gr1lIxAIcVC2z280aVCY1x02
	67AKxVWUJVW8JbIYCTnIWIevJa73UjIFyTuYvjxUFKZXUUUUU
X-CM-SenderInfo: pzr2x6tkl6x35dzhxuhorxvhhfrp/
X-Rspamd-Queue-Id: B1A9053CB9B
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-1.46 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	R_SPF_ALLOW(-0.20)[+ip4:172.234.253.10];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	TAGGED_FROM(0.00)[bounces-13319-lists,io-uring=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	DMARC_NA(0.00)[huaweicloud.com];
	FREEMAIL_TO(0.00)[kernel.dk,gmail.com,vger.kernel.org];
	MIME_TRACE(0.00)[0:+];
	TO_DN_SOME(0.00)[];
	ASN(0.00)[asn:63949, ipnet:172.234.224.0/19, country:SG];
	FROM_HAS_DN(0.00)[];
	TAGGED_RCPT(0.00)[io-uring];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[wozizhi@huaweicloud.com,io-uring@vger.kernel.org];
	RCPT_COUNT_FIVE(0.00)[6];
	RCVD_COUNT_FIVE(0.00)[6];
	R_DKIM_NA(0.00)[];
	NEURAL_HAM(-0.00)[-1.000];
	MID_RHS_MATCH_FROM(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[huaweicloud.com:mid,sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns]
X-Rspamd-Action: no action



在 2026/5/13 22:20, Jens Axboe 写道:
> On 5/13/26 8:18 AM, Jens Axboe wrote:
>> On 5/13/26 12:32 AM, Zizhi Wo wrote:
>>> diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
>>> index 4ed998d60c09..92e255e9e08f 100644
>>> --- a/io_uring/io_uring.c
>>> +++ b/io_uring/io_uring.c
>>> @@ -710,11 +710,13 @@ static bool io_fill_nop_cqe(struct io_ring_ctx *ctx, unsigned int off)
>>>    * fill the cq entry
>>>    */
>>>   bool io_cqe_cache_refill(struct io_ring_ctx *ctx, bool overflow, bool cqe32)
>>>   {
>>>   	struct io_rings *rings = ctx->rings;
>>> -	unsigned int off = ctx->cached_cq_tail & (ctx->cq_entries - 1);
>>> +	unsigned int head = READ_ONCE(ctx->rings->cq.head);
>>> +	unsigned int tail = ctx->cached_cq_tail;
>>> +	unsigned int off = tail & (ctx->cq_entries - 1);
>>>   	unsigned int free, queued, len;
>>
>> This looks wrong, as you're snapshotting 'tail' while it could get
>> modified by if a nop fill before the refill happens. And fwiw, looks
>> like the refill part potentially suffers from the same unsigned issue.
> 

Yes. I wasn't aware of io_fill_nop_cqe(), the fact that
cached_cq_tail can be modified between the snapshot and the refill
was missed. The same oversight also means the unsigned issue in that
function went unnoticed...

> To be clearer, I think you want to add a helper ala:
> 
> static unsigned int io_cqring_queued(struct io_ring_ctx *ctx)
> {
> 	struct io_rings *rings = io_get_rings(ctx);
> 	int diff;
> 
> 	diff = (int)( ctx->cached_cq_tail - READ_ONCE(rings->cq.head));
> 	if (diff >= 0)
>          	return min((unsigned int) diff, ctx->cq_entries);
> 	return 0;
> }
> 
> or something like that, and then use it in both spots. Would make for a
> cleaner fix, too.
> 

Thanks for the suggestion. I'll send a v2 using this helper in both
spots.

Thanks,
Zizhi Wo


