Return-Path: <io-uring+bounces-13132-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id cIoMIQqT6mmr0wIAu9opvQ
	(envelope-from <io-uring+bounces-13132-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Thu, 23 Apr 2026 23:45:46 +0200
X-Original-To: lists+io-uring@lfdr.de
Received: from sin.lore.kernel.org (sin.lore.kernel.org [IPv6:2600:3c15:e001:75::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 3E2FB457F3A
	for <lists+io-uring@lfdr.de>; Thu, 23 Apr 2026 23:45:45 +0200 (CEST)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sin.lore.kernel.org (Postfix) with ESMTP id 4A44D3003733
	for <lists+io-uring@lfdr.de>; Thu, 23 Apr 2026 21:45:42 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 007A93C3BE0;
	Thu, 23 Apr 2026 21:45:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=bsbernd.com header.i=@bsbernd.com header.b="WMx90Ksd";
	dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b="dMcnE/2t"
X-Original-To: io-uring@vger.kernel.org
Received: from fout-a3-smtp.messagingengine.com (fout-a3-smtp.messagingengine.com [103.168.172.146])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CC0D529C35A;
	Thu, 23 Apr 2026 21:45:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=103.168.172.146
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776980740; cv=none; b=f1Ja7SKMLt7Rjf3AyyLGv7pa+5UJoMYA1NnnPOGiRgQJPYivzz4tpwz1Txl4QcLV1C1n9Y1G4MDD42/MTnmPHZbDlquS8O/3NpskK3vrbhW11W/tZ3WZYpLevH68AtQHPPGqNoDanWSmXf0hl95j4RZ6A4rynC9iEPjVoHcNhaw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776980740; c=relaxed/simple;
	bh=F8SK0hu0teMVugq09YB/IXwN4R6GXmcgWB7+J4Ihvuc=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=YdT7evIHCAq3jPyFJIy/MWIAHLlAuss/xaJzgPcOHbq6ozQgMpm70VtfMHT5JHkvS5+6JtYLXvkqnJKufNt4QgzoHL6NQY09oSm5dz1fbdnAMTrZGYi5L/jiGl/wsxbfsU41MDC2F394HHd4NHt5yTfZzvJs3skuJvup96qt1Y0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=bsbernd.com; spf=pass smtp.mailfrom=bsbernd.com; dkim=pass (2048-bit key) header.d=bsbernd.com header.i=@bsbernd.com header.b=WMx90Ksd; dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b=dMcnE/2t; arc=none smtp.client-ip=103.168.172.146
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=bsbernd.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=bsbernd.com
Received: from phl-compute-01.internal (phl-compute-01.internal [10.202.2.41])
	by mailfout.phl.internal (Postfix) with ESMTP id EE4C2EC0549;
	Thu, 23 Apr 2026 17:45:37 -0400 (EDT)
Received: from phl-frontend-03 ([10.202.2.162])
  by phl-compute-01.internal (MEProxy); Thu, 23 Apr 2026 17:45:37 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bsbernd.com; h=
	cc:cc:content-transfer-encoding:content-type:content-type:date
	:date:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to; s=fm1; t=1776980737;
	 x=1777067137; bh=F6zwa6TcgHHPn2tKnc1yo4B14tLcDyV9vssvgzHsxkM=; b=
	WMx90KsdDLaSZULZWyKcPeG1xo1qJ78t92eBrz7MxqG06scQqgcTk3hz5rX3JYL4
	+Bu/GpWtvic0HiAbSH6Nd7Ws2JaKlO0CmWE4o7PFCWfIr3Mjvw6Ek7mmOyou7r/r
	ku58YCvx9dVN0WfUvdZCqAmRvRXywc9NqVW4C5AFRy/g0q1lAUXQkRisGXOLcHYd
	RqWbQxrSQRRJiEJ2zvWV0m7U4mMTcNoRsnwZe+jxKHIP9lp4CpmToOPXiaGxg+tO
	HarlEJuoPUz//5a3ko5L07JAOc4eIeF2JnLrIM+TGNzghFa1s2eMvdodLYJUBqZx
	SFLVEnO+0/KIuqL1D6Fxvg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-transfer-encoding
	:content-type:content-type:date:date:feedback-id:feedback-id
	:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to:x-me-proxy
	:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; t=1776980737; x=
	1777067137; bh=F6zwa6TcgHHPn2tKnc1yo4B14tLcDyV9vssvgzHsxkM=; b=d
	McnE/2tis1xIQSyOMQ3ixOVUdcMaF3iY/mRYEdzd5KX5tffGpcyD8JV4YkXVLJn+
	5t67z1ZDNmeF4dRlnfYTk2wfLSH7NIyvyvD4/5LgPjeFZaYjKlDBsnxlrY5U4/Ds
	g/Kux1aQXHqShNpRrdrRuXNAtj2VVlPoBrdEms3J8uInJGMo975/9o/57v5faG1V
	TQJUqQt5cFLq2f6MhBPOpwkBov2mGMHm4xUf+jqLHa/6JZvVCEEJU6UkWPTlCQeq
	no1m2XA/8R/eNgwM1U4gEyobXA8FHn40RFgPAXoxb3MqBa6ubjOlda6JU+LKvev8
	89YZqUC8NjfhO3+W+qG+A==
X-ME-Sender: <xms:AZPqabqzRxaXBGrOrYEIzjUUva13IXPmrhE5CiU-7kQuymz3UtGtCQ>
    <xme:AZPqaXLMGWnxBWPyMbvdKy3zAka2CTAhiKxcyZ8X6PRJRNRj2HOsrUNlYbMDwh8f5
    SDHLxiDvy7NMsGG5XBFFYhghkRgN7g7VyOeYA5JA8MF--BvonA>
X-ME-Received: <xmr:AZPqaYQ12HchPH-ufR3ms676QJActdIfIpD2aUtPVrNyl_iNoFgbuiB-NrFzx88coguFqWuSkBtPGgMhEvI_-arE5CfZ3EkvDqxh9NP19zNEe77C8A>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeefhedrtddtgdeikedviecutefuodetggdotefrod
    ftvfcurfhrohhfihhlvgemucfhrghsthforghilhdpuffrtefokffrpgfnqfghnecuuegr
    ihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmdenucfjug
    hrpefkffggfgfuvfevfhfhjggtgfesthejredttddvjeenucfhrhhomhepuegvrhhnugcu
    ufgthhhusggvrhhtuceosggvrhhnugessghssggvrhhnugdrtghomheqnecuggftrfgrth
    htvghrnhephefhjeeujeelhedtheetfedvgfdtleffuedujefhheegudefvdfhheeuvedu
    ueegnecuvehluhhsthgvrhfuihiivgeptdenucfrrghrrghmpehmrghilhhfrhhomhepsg
    gvrhhnugessghssggvrhhnugdrtghomhdpnhgspghrtghpthhtohephedpmhhouggvpehs
    mhhtphhouhhtpdhrtghpthhtoheprgigsghovgeskhgvrhhnvghlrdgukhdprhgtphhtth
    hopehtohhmrdhlvghimhhinhhgsehgmhgrihhlrdgtohhmpdhrtghpthhtohepihhoqdhu
    rhhinhhgsehvghgvrhdrkhgvrhhnvghlrdhorhhgpdhrtghpthhtoheplhhinhhugidqsg
    hlohgtkhesvhhgvghrrdhkvghrnhgvlhdrohhrghdprhgtphhtthhopehlihgrmhdrhhho
    fihlvghtthesohhrrggtlhgvrdgtohhm
X-ME-Proxy: <xmx:AZPqaeu6zxhby6zBGj2ELLO0DYDhVVr5RsIijHnluVDBYY7NHTRPyQ>
    <xmx:AZPqaRYAP6Oj22SUrlauFnA5jgPIvz8JlyVnw1za_oklQm9OKYb_4Q>
    <xmx:AZPqacEOoDue6dsaaCNrZrKz6qYlA7raRvsEeUMM9zrdvEO4Ry4KiQ>
    <xmx:AZPqadwIF3HUfe7XuTWJdjZa4kHhLiPSwfr-Hx5mq29IDNi5me5fRw>
    <xmx:AZPqafj9GZ1abFbSo-49u4VCexnvhZh4VowJ6ksEI00rtgg_lStA6Ign>
Feedback-ID: i5c2e48a5:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Thu,
 23 Apr 2026 17:45:36 -0400 (EDT)
Message-ID: <053fa6e7-43f7-4c80-9996-7fe6d8c28e45@bsbernd.com>
Date: Thu, 23 Apr 2026 23:45:34 +0200
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
From: Bernd Schubert <bernd@bsbernd.com>
Content-Language: fr
In-Reply-To: <0349d72d-dff8-4f9f-b448-919fa5ae96da@kernel.dk>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spamd-Result: default: False [-0.66 / 15.00];
	SUSPICIOUS_RECIPS(1.50)[];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[bsbernd.com,none];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c15:e001:75::/64:c];
	R_DKIM_ALLOW(-0.20)[bsbernd.com:s=fm1,messagingengine.com:s=fm2];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	RCVD_TLS_LAST(0.00)[];
	TAGGED_FROM(0.00)[bounces-13132-lists,io-uring=lfdr.de];
	TO_DN_EQ_ADDR_SOME(0.00)[];
	MIME_TRACE(0.00)[0:+];
	FREEMAIL_TO(0.00)[kernel.dk,gmail.com];
	FORGED_SENDER_MAILLIST(0.00)[];
	TO_DN_SOME(0.00)[];
	FROM_HAS_DN(0.00)[];
	ASN(0.00)[asn:63949, ipnet:2600:3c15::/32, country:SG];
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
	DBL_BLOCKED_OPENRESOLVER(0.00)[sin.lore.kernel.org:helo,sin.lore.kernel.org:rdns,messagingengine.com:dkim]
X-Rspamd-Queue-Id: 3E2FB457F3A
X-Rspamd-Action: no action
X-Rspamd-Server: lfdr



On 4/21/26 19:47, Jens Axboe wrote:
> Hi Ming,
> 
> Ran into the below running tests on the current tree:
> 
> =============================
> WARNING: suspicious RCU usage
> 7.0.0+ #16 Tainted: G                 N 
> -----------------------------
> lib/maple_tree.c:759 suspicious rcu_dereference_check() usage!
> 
> other info that might help us debug this:
> 
> 
> rcu_scheduler_active = 2, debug_locks = 1
> 1 lock held by iou-wrk-55535/55536:
>  #0: ffff800085a451a0 (ublk_ctl_mutex){+.+.}-{4:4}, at: ublk_ctrl_del_dev+0xdc/0x2f8
> 
> stack backtrace:
> CPU: 4 UID: 0 PID: 55536 Comm: iou-wrk-55535 Tainted: G                 N  7.0.0+ #16 PREEMPT 
> Tainted: [N]=TEST
> Hardware name: linux,dummy-virt (DT)
> Call trace:
>  show_stack+0x1c/0x30 (C)
>  dump_stack_lvl+0x68/0x90
>  dump_stack+0x18/0x20
>  lockdep_rcu_suspicious+0x170/0x200
>  mas_walk+0x3f0/0x6a0
>  mas_find+0x1b4/0x6b0
>  ublk_buf_cleanup+0xe0/0x240
>  ublk_cdev_rel+0x34/0x1b0
>  device_release+0xa4/0x350
>  kobject_put+0x138/0x250
>  put_device+0x18/0x30
>  ublk_put_device+0x18/0x28
>  ublk_ctrl_del_dev+0x120/0x2f8
>  ublk_ctrl_uring_cmd+0x598/0x29b8
>  io_uring_cmd+0x1e0/0x468
>  __io_issue_sqe+0xa4/0x748
>  io_issue_sqe+0x80/0xf68
>  io_wq_submit_work+0x26c/0xdc8
>  io_worker_handle_work+0x334/0xf20
>  io_wq_worker+0x278/0x9e8
>  ret_from_fork+0x10/0x20
> Buffer I/O error on dev ublkb0, logical block 0, async page read
> Buffer I/O error on dev ublkb0, logical block 0, async page read
>  ublkb0: unable to read partition table
> Buffer I/O error on dev ublkb0, logical block 0, async page read
> Buffer I/O error on dev ublkb0, logical block 0, async page read
> Buffer I/O error on dev ublkb0, logical block 512, async page read
> Buffer I/O error on dev ublkb0, logical block 512, async page read
> Buffer I/O error on dev ublkb0, logical block 0, async page read
> Buffer I/O error on dev ublkb0, logical block 512, async page read
> 
> and I briefly looked at it, but then just gave up as a) the maple tree
> documentation is not that detailed, and b) other in-tree users also just
> call mas_for_each() without either a lock held or RCU read side locked.
> 
> Adding Liam for shedding some light on this...
> 

Hmm, that is another one, I run into

Date:   Thu Apr 16 15:16:04 2026 +0200

    ublk: Add rcu_read_lock/unlock in ublk_buf_cleanup
    
    [  399.994025] =============================
    [  399.994694] WARNING: suspicious RCU usage
    [  399.995464] 7.0.0+ #52 Not tainted
    [  399.996034] -----------------------------
    [  399.996697] lib/maple_tree.c:780 suspicious rcu_dereference_check() usage!
    [  399.997748]
                   other info that might help us debug this:
    
    [  399.998961]
                   rcu_scheduler_active = 2, debug_locks = 1
    [  399.999957] 1 lock held by iou-wrk-1495/1509:
    [  400.000596]  #0: ffffffffa05e4590 (ublk_ctl_mutex){+.+.}-{4:4}, at: ublk_ctrl_del_dev+0x3d/0x190 [ublk_drv]
    [  400.001796]
                   stack backtrace:
    [  400.002492] CPU: 40 UID: 0 PID: 1509 Comm: iou-wrk-1495 Not tainted 7.0.0+ #52 PREEMPT
    [  400.002496] Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.17.0-debian-1.17.0-1ubuntu1 04/01/2014
    [  400.002498] Call Trace:
    [  400.002500]  <TASK>
    [  400.002503]  dump_stack_lvl+0x54/0x70
    [  400.002511]  lockdep_rcu_suspicious+0x119/0x160
    [  400.002521]  mas_start+0xed/0x140
    [  400.002531]  mas_find+0x1a6/0x270
    [  400.002538]  ublk_cdev_rel+0xb8/0x320 [ublk_drv]


And have in my pbuf branch

index eb9b5dd8122c..208f6b5ad892 100644
--- a/drivers/block/ublk_drv.c
+++ b/drivers/block/ublk_drv.c
@@ -5478,6 +5478,7 @@ static void ublk_buf_cleanup(struct ublk_device *ub)
        struct ublk_buf_range *range;
        struct page *pages[32];
 
+       rcu_read_lock();
        mas_for_each(&mas, range, ULONG_MAX) {
                unsigned long base = mas.index;
                unsigned long nr = mas.last - base + 1;
@@ -5495,6 +5496,7 @@ static void ublk_buf_cleanup(struct ublk_device *ub)
                }
                kfree(range);
        }
+       rcu_read_unlock();
        mtree_destroy(&ub->buf_tree);
        ida_destroy(&ub->buf_ida);
 }


Thanks,
Bernd

