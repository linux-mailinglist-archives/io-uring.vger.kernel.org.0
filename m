Return-Path: <io-uring+bounces-13329-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id gDYdLGHQBWoPbwIAu9opvQ
	(envelope-from <io-uring+bounces-13329-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Thu, 14 May 2026 15:38:41 +0200
X-Original-To: lists+io-uring@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id D218454269A
	for <lists+io-uring@lfdr.de>; Thu, 14 May 2026 15:38:40 +0200 (CEST)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 8CB55301175F
	for <lists+io-uring@lfdr.de>; Thu, 14 May 2026 13:37:43 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EC78738A73A;
	Thu, 14 May 2026 13:37:42 +0000 (UTC)
X-Original-To: io-uring@vger.kernel.org
Received: from dggsgout11.his.huawei.com (dggsgout11.his.huawei.com [45.249.212.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 80B2C30DD1F;
	Thu, 14 May 2026 13:37:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778765862; cv=none; b=lviCHFR4kR/+YtuVKbEUxuk+UH/pT6wcJS89f1gt9b8oMGV8mLK7fVVlEkM3iNo+iYEyE/a8E3lnYfc2lLvAEBfBX7cJZrkFxYzp20+Kswq+nprYc2UZK2cK+Az0Hg6IEKSmgnOOKszWvsKTFMwo0K1a81bpbsxnUlOsJaiZO0Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778765862; c=relaxed/simple;
	bh=Zw/TG0CW00mVJz6WAxesoz1fJyGmNJSTg3AjyKBfZrY=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=iunqkd4V0/mCEBMD5yHEt0u61T97LXxmQ032no6lCUB2UbQHZD0YYScm2MK6+7HRFadj3GR7EMhBI7ZSZrkDINGmCL3iKuosyJ80OcKhwwZ+3LuKPqO+SUmmg+DSjQcPKSditurLDcXv6nxUqdvpLmvIYorNH8wpls3nluP3WgE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com; spf=pass smtp.mailfrom=huaweicloud.com; arc=none smtp.client-ip=45.249.212.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huaweicloud.com
Received: from mail.maildlp.com (unknown [172.19.163.170])
	by dggsgout11.his.huawei.com (SkyGuard) with ESMTPS id 4gGWb11HJDzYQtvs;
	Thu, 14 May 2026 21:37:01 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.128])
	by mail.maildlp.com (Postfix) with ESMTP id 632384056B;
	Thu, 14 May 2026 21:37:35 +0800 (CST)
Received: from [10.174.176.179] (unknown [10.174.176.179])
	by APP4 (Coremail) with SMTP id gCh0CgCnb1sb0AVqcPwbCQ--.49570S3;
	Thu, 14 May 2026 21:37:32 +0800 (CST)
Message-ID: <eaca07d4-0cb8-4a27-9ca7-5f494786bbd4@huaweicloud.com>
Date: Thu, 14 May 2026 21:37:31 +0800
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH V2] io_uring: validate user-controlled cq.head in
 io_cqe_cache_refill()
To: Jens Axboe <axboe@kernel.dk>, asml.silence@gmail.com,
 io-uring@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, yangerkun@huawei.com,
 chengzhihao1@huawei.com
References: <20260514021847.4062782-1-wozizhi@huaweicloud.com>
 <ca0a0f6f-f760-4c6a-813e-93eb187b1b9c@kernel.dk>
From: Zizhi Wo <wozizhi@huaweicloud.com>
In-Reply-To: <ca0a0f6f-f760-4c6a-813e-93eb187b1b9c@kernel.dk>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:gCh0CgCnb1sb0AVqcPwbCQ--.49570S3
X-Coremail-Antispam: 1UD129KBjvdXoWrur1fJw47Jw43Jr17Jw1xuFg_yoWDCrX_Gr
	s7tFn3Jr4xJFnFv3Zakr4IvF4DK3yjkF1UXr109a1ayan7AaykGas7Gr9aqw4Sqa10kF13
	CFZ0gw40qryjvjkaLaAFLSUrUUUUjb8apTn2vfkv8UJUUUU8Yxn0WfASr-VFAUDa7-sFnT
	9fnUUIcSsGvfJTRUUUbz8YFVCjjxCrM7AC8VAFwI0_Gr0_Xr1l1xkIjI8I6I8E6xAIw20E
	Y4v20xvaj40_Wr0E3s1l1IIY67AEw4v_Jr0_Jr4l8cAvFVAK0II2c7xJM28CjxkF64kEwV
	A0rcxSw2x7M28EF7xvwVC0I7IYx2IY67AKxVWDJVCq3wA2z4x0Y4vE2Ix0cI8IcVCY1x02
	67AKxVW8Jr0_Cr1UM28EF7xvwVC2z280aVAFwI0_GcCE3s1l84ACjcxK6I8E87Iv6xkF7I
	0E14v26rxl6s0DM2AIxVAIcxkEcVAq07x20xvEncxIr21l5I8CrVACY4xI64kE6c02F40E
	x7xfMcIj6xIIjxv20xvE14v26r1j6r18McIj6I8E87Iv67AKxVWUJVW8JwAm72CE4IkC6x
	0Yz7v_Jr0_Gr1lF7xvr2IY64vIr41lc7CjxVAaw2AFwI0_JF0_Jw1l42xK82IYc2Ij64vI
	r41l4I8I3I0E4IkC6x0Yz7v_Jr0_Gr1lx2IqxVAqx4xG67AKxVWUJVWUGwC20s026x8Gjc
	xK67AKxVWUGVWUWwC2zVAF1VAY17CE14v26r126r1DMIIYrxkI7VAKI48JMIIF0xvE2Ix0
	cI8IcVAFwI0_Jr0_JF4lIxAIcVC0I7IYx2IY6xkF7I0E14v26r1j6r4UMIIF0xvE42xK8V
	AvwI8IcIk0rVWUJVWUCwCI42IY6I8E87Iv67AKxVWUJVW8JwCI42IY6I8E87Iv6xkF7I0E
	14v26r4j6r4UJbIYCTnIWIevJa73UjIFyTuYvjxUwxhLUUUUU
X-CM-SenderInfo: pzr2x6tkl6x35dzhxuhorxvhhfrp/
X-Rspamd-Queue-Id: D218454269A
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-1.46 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	R_SPF_ALLOW(-0.20)[+ip4:172.234.253.10:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	TAGGED_FROM(0.00)[bounces-13329-lists,io-uring=lfdr.de];
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
	DBL_BLOCKED_OPENRESOLVER(0.00)[fedora:email,huawei.com:email,sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns,huaweicloud.com:mid]
X-Rspamd-Action: no action



在 2026/5/14 21:26, Jens Axboe 写道:
> On 5/13/26 8:18 PM, Zizhi Wo wrote:
>> From: Zizhi Wo <wozizhi@huawei.com>
>>
>> [BUG]
>> A fuzzing run reproduced an unkillable io_uring task stuck at ~100% CPU:
>>
>>      [root@fedora io_uring_stress]# ps -ef | grep io_uring
>>      root  1240  1  99 13:36 ?  00:01:35 [io_uring_stress] <defunct>
>>
>> The task loops inside io_cqring_wait() and never returns to userspace, and
>> SIGKILL has no effect.
> 
> Thanks - applied with a few edits, see final result here:
> 
> https://git.kernel.org/pub/scm/linux/kernel/git/axboe/linux.git/commit/?h=io_uring-7.1&id=f44d38a31f1802b7222adaea9ee69f9d280f698a
> 
> The comments (and commit message) read very LLM'ish, so dialed that back

Indeed..since my English isn't great, I used AI to polish it up a bit :)

> a bit. And there's no reason to put io_cqring_queued() in a header file
> when it's only used in io_uring.c. And finally, the 'queued' variable is
> now useless, so kill that too.
> 
Thanks for pointing that out.

Thanks,
Zizhi Wo


