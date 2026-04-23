Return-Path: <io-uring+bounces-13134-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id UPUxLnqU6mnQ0wIAu9opvQ
	(envelope-from <io-uring+bounces-13134-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Thu, 23 Apr 2026 23:51:54 +0200
X-Original-To: lists+io-uring@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 1FF05457FD3
	for <lists+io-uring@lfdr.de>; Thu, 23 Apr 2026 23:51:53 +0200 (CEST)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 85B253011852
	for <lists+io-uring@lfdr.de>; Thu, 23 Apr 2026 21:51:52 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B448A2C11CA;
	Thu, 23 Apr 2026 21:51:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=bsbernd.com header.i=@bsbernd.com header.b="fpKjTqDp";
	dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b="CogqYBSf"
X-Original-To: io-uring@vger.kernel.org
Received: from fout-a3-smtp.messagingengine.com (fout-a3-smtp.messagingengine.com [103.168.172.146])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4A82E23D7CE;
	Thu, 23 Apr 2026 21:51:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=103.168.172.146
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776981111; cv=none; b=F/tRRMnv5CIdFJ7jMphqHvJ/suAZZ237kE+pFz/ZEuYlHL3vKPxgvx9SgYYlvUM2fQ0vh0sLEEkV1wlobpyqnnfSNR74cYGqMrooIh17lBUHjanHf8JvSsfjuXp1sEVaQfBIdzvYmy8YJzlnSmlhd1pK1iymZWrWtItG6IplYtw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776981111; c=relaxed/simple;
	bh=5rd2UNDr8ISDF5PO3zwO0wa9W21l/qosMVczJubR5EM=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=dhs5Trkq97o7EJUNGKXc/l1MPIBzVSAX1GlRZSZY2MNsVz/RXMpAxsmJVYf4famL/Nkj4Jo+9MVG+aysu6PiYKjYCK3gfELJAPacn9leOct6NF5ZJSO9/8MVJvGghFFjIIDFNZjjE599HMjlCb4hY/VYqJgdgEJxQfmJQB6Uy/s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=bsbernd.com; spf=pass smtp.mailfrom=bsbernd.com; dkim=pass (2048-bit key) header.d=bsbernd.com header.i=@bsbernd.com header.b=fpKjTqDp; dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b=CogqYBSf; arc=none smtp.client-ip=103.168.172.146
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=bsbernd.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=bsbernd.com
Received: from phl-compute-03.internal (phl-compute-03.internal [10.202.2.43])
	by mailfout.phl.internal (Postfix) with ESMTP id 71444EC01C5;
	Thu, 23 Apr 2026 17:51:49 -0400 (EDT)
Received: from phl-frontend-04 ([10.202.2.163])
  by phl-compute-03.internal (MEProxy); Thu, 23 Apr 2026 17:51:49 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bsbernd.com; h=
	cc:cc:content-transfer-encoding:content-type:content-type:date
	:date:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to; s=fm1; t=1776981109;
	 x=1777067509; bh=O2XnU5kswIzxSPi8+xSmEOCLdvF0LDvQGgZh6HEcRkI=; b=
	fpKjTqDpYMrqtsIbabobsBU+hPtd4U27bW2m5Div2UpjlQlM/n8lBRwH0ezfXKVo
	j/x0/diU5XJLAJQf34lrK8iZLGm5L4KN4ECsLdEaNLaJpWdUhqpuKYtJ89jQtG+D
	XykPJUHaWz+2E6v3TCDHS9Wp591CPo7Akyw3z0b4Qp1nodWMpRlOBl0jHUbgcx1g
	/zGkPgJ6xbqxekVlmDBovY9sdQnrJO43B4u8cj5xMzjc18OWXEGQj/cQT1Xq32Q4
	9ntP87m+I+e4F8XRS71fcFaw3khXjVjmxIAai/erZvd3hh9m/e4ygIaNz3DwVpEm
	+gBUt4BMXGa3C4Su6pd2SA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-transfer-encoding
	:content-type:content-type:date:date:feedback-id:feedback-id
	:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to:x-me-proxy
	:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; t=1776981109; x=
	1777067509; bh=O2XnU5kswIzxSPi8+xSmEOCLdvF0LDvQGgZh6HEcRkI=; b=C
	ogqYBSfWHHObyQKfrPvj1GVkpub22a7yNFbfDAdmOUQRV83upnkvaQYAcTTFiZty
	qqbOle5NWjrwanBt+OWpbcUk8XIt14CB2f99u0wGVPX5QI6qoQJsraOUzRWg5aMq
	xSjFloBglvGv5OzupClCSteSh386jPCgL6FP7QwDCZMF867qZb0i9Zim9FeU9JYg
	PgFoWf+RsLfplelkrRS+DT42OfJmQMhtXLzER6L1NXo39bKfCSHk6mhCRqAc+lp4
	r1+hYoZcAA0lh7WBmfQhoFKvI9LWjux1uAStCtw2ik45gXkCYzc1frwMp/GrHS7W
	DVZby8qbJ8ZZkGcgZWldw==
X-ME-Sender: <xms:dZTqabupaKqBlWBM-y3dpuR3PiOW8tlO1hVsWOUZb6DIzv26L931zw>
    <xme:dZTqad9wE7_ws048jr-HYtTJR9Y9cnCb7_xVUTolWqvG5C2MW1_qAb3zDpnnFhniC
    iE0oAI36UnkS8ngFkR9AkGUcxNNo4jUuDXhRW10AKUEsq94h6in>
X-ME-Received: <xmr:dZTqae0lWXfwiGBqjGJ5iVd4C4h9hwcVe6ky0SLYyXgN3sVTVEHkizUkTO4R-R1zrcUx1-9bo_tymp9g9tJGPe3u9wxZg6RWrnQ4V4orpPDbGFozxA>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeefhedrtddtgdeikedvkecutefuodetggdotefrod
    ftvfcurfhrohhfihhlvgemucfhrghsthforghilhdpuffrtefokffrpgfnqfghnecuuegr
    ihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmdenucfjug
    hrpefkffggfgfuvfevfhfhjggtgfesthejredttddvjeenucfhrhhomhepuegvrhhnugcu
    ufgthhhusggvrhhtuceosggvrhhnugessghssggvrhhnugdrtghomheqnecuggftrfgrth
    htvghrnhepjefgleejueffhefhueekvdduhfetteehtdehfeejhfevudethefhtdetvdek
    keevnecuffhomhgrihhnpehkvghrnhgvlhdrohhrghenucevlhhushhtvghrufhiiigvpe
    dtnecurfgrrhgrmhepmhgrihhlfhhrohhmpegsvghrnhgusegsshgsvghrnhgurdgtohhm
    pdhnsggprhgtphhtthhopeehpdhmohguvgepshhmthhpohhuthdprhgtphhtthhopegrgi
    gsohgvsehkvghrnhgvlhdrughkpdhrtghpthhtohepthhomhdrlhgvihhmihhnghesghhm
    rghilhdrtghomhdprhgtphhtthhopehiohdquhhrihhnghesvhhgvghrrdhkvghrnhgvlh
    drohhrghdprhgtphhtthhopehlihhnuhigqdgslhhotghksehvghgvrhdrkhgvrhhnvghl
    rdhorhhgpdhrtghpthhtoheplhhirghmrdhhohiflhgvthhtsehorhgrtghlvgdrtghomh
X-ME-Proxy: <xmx:dZTqaaBtgGnEta_7EVGtZgaHHbRLRr29XRNIMqXf33l2T3XnxEQzsg>
    <xmx:dZTqaSe15XP5k3JRMJZVQB_yfQJEiQJCFRVkElqJcG67X2g_1FgfgQ>
    <xmx:dZTqaf5s9ILbultpTd5-6tnhWW-d-537NHlY_FSCB7jG2XJRyBAa7A>
    <xmx:dZTqadX26WLJQTLeXJACzyJmdztu0ufCEFstX2yvIpeaxdS-J4ScUA>
    <xmx:dZTqacV_rnCZ1TVxvs1XaQMjQFdrykJNMzg-aMhwk3FuqfTcrFDUt1AI>
Feedback-ID: i5c2e48a5:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Thu,
 23 Apr 2026 17:51:48 -0400 (EDT)
Message-ID: <4ec7a5a2-2338-4440-aa7f-b193aac0217f@bsbernd.com>
Date: Thu, 23 Apr 2026 23:51:47 +0200
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: RCU warning off ublk_buf_cleanup() -> mas_for_each()
To: Jens Axboe <axboe@kernel.dk>, Ming Lei <tom.leiming@gmail.com>
Cc: io-uring <io-uring@vger.kernel.org>,
 "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>,
 "Liam R. Howlett" <liam.howlett@oracle.com>
References: <0349d72d-dff8-4f9f-b448-919fa5ae96da@kernel.dk>
 <053fa6e7-43f7-4c80-9996-7fe6d8c28e45@bsbernd.com>
 <331c739c-d0fd-4c53-bbd5-cbb18f5dfedb@kernel.dk>
From: Bernd Schubert <bernd@bsbernd.com>
Content-Language: fr
In-Reply-To: <331c739c-d0fd-4c53-bbd5-cbb18f5dfedb@kernel.dk>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spamd-Result: default: False [-0.66 / 15.00];
	SUSPICIOUS_RECIPS(1.50)[];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[bsbernd.com,none];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c0a:e001:db::/64:c];
	R_DKIM_ALLOW(-0.20)[bsbernd.com:s=fm1,messagingengine.com:s=fm2];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	RCVD_TLS_LAST(0.00)[];
	TAGGED_FROM(0.00)[bounces-13134-lists,io-uring=lfdr.de];
	TO_DN_EQ_ADDR_SOME(0.00)[];
	MIME_TRACE(0.00)[0:+];
	FREEMAIL_TO(0.00)[kernel.dk,gmail.com];
	FORGED_SENDER_MAILLIST(0.00)[];
	TO_DN_SOME(0.00)[];
	FROM_HAS_DN(0.00)[];
	ASN(0.00)[asn:63949, ipnet:2600:3c0a::/32, country:SG];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	RCVD_COUNT_FIVE(0.00)[6];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[bernd@bsbernd.com,io-uring@vger.kernel.org];
	DKIM_TRACE(0.00)[bsbernd.com:+,messagingengine.com:+];
	NEURAL_HAM(-0.00)[-1.000];
	TAGGED_RCPT(0.00)[io-uring];
	MID_RHS_MATCH_FROM(0.00)[];
	RCPT_COUNT_FIVE(0.00)[5];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[messagingengine.com:dkim,sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns]
X-Rspamd-Queue-Id: 1FF05457FD3
X-Rspamd-Action: no action
X-Rspamd-Server: lfdr



On 4/23/26 23:48, Jens Axboe wrote:
> On 4/23/26 3:45 PM, Bernd Schubert wrote:
>>
>>
>> On 4/21/26 19:47, Jens Axboe wrote:
>>> Hi Ming,
>>>
>>> Ran into the below running tests on the current tree:
>>>
>>> =============================
>>> WARNING: suspicious RCU usage
>>> 7.0.0+ #16 Tainted: G                 N 
>>> -----------------------------
>>> lib/maple_tree.c:759 suspicious rcu_dereference_check() usage!
>>>
>>> other info that might help us debug this:
>>>
>>>
>>> rcu_scheduler_active = 2, debug_locks = 1
>>> 1 lock held by iou-wrk-55535/55536:
>>>  #0: ffff800085a451a0 (ublk_ctl_mutex){+.+.}-{4:4}, at: ublk_ctrl_del_dev+0xdc/0x2f8
>>>
>>> stack backtrace:
>>> CPU: 4 UID: 0 PID: 55536 Comm: iou-wrk-55535 Tainted: G                 N  7.0.0+ #16 PREEMPT 
>>> Tainted: [N]=TEST
>>> Hardware name: linux,dummy-virt (DT)
>>> Call trace:
>>>  show_stack+0x1c/0x30 (C)
>>>  dump_stack_lvl+0x68/0x90
>>>  dump_stack+0x18/0x20
>>>  lockdep_rcu_suspicious+0x170/0x200
>>>  mas_walk+0x3f0/0x6a0
>>>  mas_find+0x1b4/0x6b0
>>>  ublk_buf_cleanup+0xe0/0x240
>>>  ublk_cdev_rel+0x34/0x1b0
>>>  device_release+0xa4/0x350
>>>  kobject_put+0x138/0x250
>>>  put_device+0x18/0x30
>>>  ublk_put_device+0x18/0x28
>>>  ublk_ctrl_del_dev+0x120/0x2f8
>>>  ublk_ctrl_uring_cmd+0x598/0x29b8
>>>  io_uring_cmd+0x1e0/0x468
>>>  __io_issue_sqe+0xa4/0x748
>>>  io_issue_sqe+0x80/0xf68
>>>  io_wq_submit_work+0x26c/0xdc8
>>>  io_worker_handle_work+0x334/0xf20
>>>  io_wq_worker+0x278/0x9e8
>>>  ret_from_fork+0x10/0x20
>>> Buffer I/O error on dev ublkb0, logical block 0, async page read
>>> Buffer I/O error on dev ublkb0, logical block 0, async page read
>>>  ublkb0: unable to read partition table
>>> Buffer I/O error on dev ublkb0, logical block 0, async page read
>>> Buffer I/O error on dev ublkb0, logical block 0, async page read
>>> Buffer I/O error on dev ublkb0, logical block 512, async page read
>>> Buffer I/O error on dev ublkb0, logical block 512, async page read
>>> Buffer I/O error on dev ublkb0, logical block 0, async page read
>>> Buffer I/O error on dev ublkb0, logical block 512, async page read
>>>
>>> and I briefly looked at it, but then just gave up as a) the maple tree
>>> documentation is not that detailed, and b) other in-tree users also just
>>> call mas_for_each() without either a lock held or RCU read side locked.
>>>
>>> Adding Liam for shedding some light on this...
>>>
>>
>> Hmm, that is another one, I run into
>>
>> Date:   Thu Apr 16 15:16:04 2026 +0200
>>
>>     ublk: Add rcu_read_lock/unlock in ublk_buf_cleanup
>>     
>>     [  399.994025] =============================
>>     [  399.994694] WARNING: suspicious RCU usage
>>     [  399.995464] 7.0.0+ #52 Not tainted
>>     [  399.996034] -----------------------------
>>     [  399.996697] lib/maple_tree.c:780 suspicious rcu_dereference_check() usage!
>>     [  399.997748]
>>                    other info that might help us debug this:
>>     
>>     [  399.998961]
>>                    rcu_scheduler_active = 2, debug_locks = 1
>>     [  399.999957] 1 lock held by iou-wrk-1495/1509:
>>     [  400.000596]  #0: ffffffffa05e4590 (ublk_ctl_mutex){+.+.}-{4:4}, at: ublk_ctrl_del_dev+0x3d/0x190 [ublk_drv]
>>     [  400.001796]
>>                    stack backtrace:
>>     [  400.002492] CPU: 40 UID: 0 PID: 1509 Comm: iou-wrk-1495 Not tainted 7.0.0+ #52 PREEMPT
>>     [  400.002496] Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.17.0-debian-1.17.0-1ubuntu1 04/01/2014
>>     [  400.002498] Call Trace:
>>     [  400.002500]  <TASK>
>>     [  400.002503]  dump_stack_lvl+0x54/0x70
>>     [  400.002511]  lockdep_rcu_suspicious+0x119/0x160
>>     [  400.002521]  mas_start+0xed/0x140
>>     [  400.002531]  mas_find+0x1a6/0x270
>>     [  400.002538]  ublk_cdev_rel+0xb8/0x320 [ublk_drv]
>>
>>
>> And have in my pbuf branch
>>
>> index eb9b5dd8122c..208f6b5ad892 100644
>> --- a/drivers/block/ublk_drv.c
>> +++ b/drivers/block/ublk_drv.c
>> @@ -5478,6 +5478,7 @@ static void ublk_buf_cleanup(struct ublk_device *ub)
>>         struct ublk_buf_range *range;
>>         struct page *pages[32];
>>  
>> +       rcu_read_lock();
>>         mas_for_each(&mas, range, ULONG_MAX) {
>>                 unsigned long base = mas.index;
>>                 unsigned long nr = mas.last - base + 1;
>> @@ -5495,6 +5496,7 @@ static void ublk_buf_cleanup(struct ublk_device *ub)
>>                 }
>>                 kfree(range);
>>         }
>> +       rcu_read_unlock();
>>         mtree_destroy(&ub->buf_tree);
>>         ida_destroy(&ub->buf_ida);
>>  }
> 
> Fixed in patches going to Linus tomorrow, see HEAD~3..HEAD~1 in this
> branch:
> 
> https://git.kernel.org/pub/scm/linux/kernel/git/axboe/linux.git/log/?h=block-7.1
> 

Thank you, will check after getting some sleep.


