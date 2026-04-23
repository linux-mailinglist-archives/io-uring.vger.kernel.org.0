Return-Path: <io-uring+bounces-13133-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id 56fuHcOT6mnQ0wIAu9opvQ
	(envelope-from <io-uring+bounces-13133-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Thu, 23 Apr 2026 23:48:51 +0200
X-Original-To: lists+io-uring@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id A6E74457F70
	for <lists+io-uring@lfdr.de>; Thu, 23 Apr 2026 23:48:50 +0200 (CEST)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 44BDF3010D9F
	for <lists+io-uring@lfdr.de>; Thu, 23 Apr 2026 21:48:49 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 536F434402B;
	Thu, 23 Apr 2026 21:48:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20251104.gappssmtp.com header.i=@kernel-dk.20251104.gappssmtp.com header.b="wlwyAkt8"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-oi1-f178.google.com (mail-oi1-f178.google.com [209.85.167.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 25AA829C35A
	for <io-uring@vger.kernel.org>; Thu, 23 Apr 2026 21:48:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.178
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776980928; cv=none; b=aE9U8ttpHNPtW0oRrIxcsaZ2d8phYuAAV9BVyOSJHdD38o0hKTXPKotcB38LGWnHQj9j7c5KuR15m/NOuHDsg+/3M69yj3Qfb+gz90Q1bkexDjIK7H5FOTt4i/rqwQigLQDEp0eXM3Qyzv0Pag44+/N++5/Nhiw24nsJsIXw6Jk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776980928; c=relaxed/simple;
	bh=fMOGa9Rwyv9lL5SYVtE8xPa1vf8LUh9hNa830GKZu8o=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=bbO4FUxsjVndLKPnEZLWE7aX0kPmzVNdaadTXC7YperyeQnTPPMudPbFJcTC/Y+3iXRgBpFmKzCeuVb3wW8ctNYha7n8mg41rM6E1UFStHhY8MDcbN6ZA48Di6vQ4RI/eYHjXQ+alVC38WfERiZh1RoHaQUOYPbxqfXacKdopm8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20251104.gappssmtp.com header.i=@kernel-dk.20251104.gappssmtp.com header.b=wlwyAkt8; arc=none smtp.client-ip=209.85.167.178
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-oi1-f178.google.com with SMTP id 5614622812f47-479d593a0c3so3600715b6e.0
        for <io-uring@vger.kernel.org>; Thu, 23 Apr 2026 14:48:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20251104.gappssmtp.com; s=20251104; t=1776980925; x=1777585725; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=8Om4Gff6PHUsp0JmJxEZIBhz8X2FJjaFcTZ+MBwubTI=;
        b=wlwyAkt8hvG4jDVhL71PnXHVjQtzXetfF91iooyk6XaiQGai0CTSY1diYOTGSz3vhw
         Ag/Q4Pf+b5uwRbdpWEYtkCXe6dzJr4fc1ICUds5bcl15IBoT1ewJQxnEnreXDOgW8Hi1
         ziXk2Qk4ZmsvUFE/uj1WjpODChWRpBlfletVxI/uNlinf5qpi2whiUhhtKZFMbQ4ZCVj
         ZaNZecScLFnUqx1XFiPmB5FyeX205fYjq4mPIT7Pd1B0FXNxz7JNgeK3sB6JMCrHCkfI
         HcdeNLqLpefY5S8qlY2tTkDRymhsRzFtjihn0cELbi2cLJRGN6jzyhCViU1+rEEHUVBf
         pjDQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1776980925; x=1777585725;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=8Om4Gff6PHUsp0JmJxEZIBhz8X2FJjaFcTZ+MBwubTI=;
        b=mtotQPXvQnQr/8PHZZchyOwKl34SjFevhsYQI1H79JPGNjun5DiWIiyvFgjZxM5sfR
         Ae5+LmcmADkOoawUafiWHbR7BYYFjr8Z2pvMunVUWeDeZzXb7/zYaAE6NxL+D6R4JYDE
         2psy2h8OklTSg6xnTMvKHMoe6bWlZc+1Hj5C1eqB0orFlKYAmFR86xpheH+MvmGj0ZgB
         k6EyE4/JyGACvNGH0KwRJhbcHd+t6ZAvXLvSoWVhGnk39loXKF0jyN8BqVbVucpVx7/h
         BK7fgxLw1vjaMoh/84lVltbMShPvakrQAMTImCc2+JiFHowGHQQHBRFCkMf8n083Nrel
         TqVw==
X-Gm-Message-State: AOJu0YyTP9x4dG7Nd4eUioGwc3SeGB+pvf7WcL/LmKtrOgPbb9ygHHKj
	eh1HiAwr98s5HMHk8vXE+c9zDpqk6xMBdDnAAinrmB/4LZkjW2aNkP/qI6HIPocWUA+8BRz1z6j
	mm6HrFVQ=
X-Gm-Gg: AeBDietZxhZ1dVlZvj3oi60/eqnwZNnQ6ZImXrpUe22XMWIYGm/rvO7tqkagiZnkTmq
	PQ0ZIzQErYOegSnDoq0/muHVD9KeNg1H8mFPBvXMK72nKIvHXrj5ZCewWP3pAXh0+xm6dSUG6yt
	++j/gAg7SGYS6WUp+0/UIm9eLp1yIp1KdYqVU1Pqkt67sr8H/tYQjyPE31PDERuM4RdMEMYlRiJ
	cc+lVNYt0CZtiAZeWBIVKE0VlL/BK4FjC4eecLseypcgCWfhkP4I0jOJZL7s0/3hJmPKJuNkY1g
	0ooWhk3PqLjKw7EF6E9W50vn6iU297FhuACF1GLB1m4AXaWOg/Futez5EiAdx/paSwuxrYX37KT
	klbgkqEKx0IMKjJfs6Fu/D1XONwXfIysSD8NIqkQvFWlBuTNr7nV3or0AHjcfz72elnov7bxjUR
	dkfgfX7KvoG8Sd5lAX8qxej150jonuMgVZNu74iox+bAoEpugOfTHOwqsG0ZAvyPjksW3c//dmg
	KHbpppGry/UEq1zhgK2
X-Received: by 2002:a54:4386:0:b0:479:e96e:65b6 with SMTP id 5614622812f47-479e96ea357mr6270800b6e.13.1776980925139;
        Thu, 23 Apr 2026 14:48:45 -0700 (PDT)
Received: from [192.168.1.150] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id 5614622812f47-4799ff36814sm14527947b6e.7.2026.04.23.14.48.43
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 23 Apr 2026 14:48:44 -0700 (PDT)
Message-ID: <331c739c-d0fd-4c53-bbd5-cbb18f5dfedb@kernel.dk>
Date: Thu, 23 Apr 2026 15:48:43 -0600
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: RCU warning off ublk_buf_cleanup() -> mas_for_each()
To: Bernd Schubert <bernd@bsbernd.com>, Ming Lei <tom.leiming@gmail.com>
Cc: io-uring <io-uring@vger.kernel.org>,
 "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>,
 "Liam R. Howlett" <liam.howlett@oracle.com>
References: <0349d72d-dff8-4f9f-b448-919fa5ae96da@kernel.dk>
 <053fa6e7-43f7-4c80-9996-7fe6d8c28e45@bsbernd.com>
Content-Language: en-US
From: Jens Axboe <axboe@kernel.dk>
In-Reply-To: <053fa6e7-43f7-4c80-9996-7fe6d8c28e45@bsbernd.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spamd-Result: default: False [-0.16 / 15.00];
	SUSPICIOUS_RECIPS(1.50)[];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c0a:e001:db::/64:c];
	R_DKIM_ALLOW(-0.20)[kernel-dk.20251104.gappssmtp.com:s=20251104];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	RCVD_TLS_LAST(0.00)[];
	DMARC_NA(0.00)[kernel.dk];
	TO_DN_EQ_ADDR_SOME(0.00)[];
	TAGGED_FROM(0.00)[bounces-13133-lists,io-uring=lfdr.de];
	FORGED_SENDER_MAILLIST(0.00)[];
	FREEMAIL_TO(0.00)[bsbernd.com,gmail.com];
	TO_DN_SOME(0.00)[];
	MIME_TRACE(0.00)[0:+];
	FROM_HAS_DN(0.00)[];
	ASN(0.00)[asn:63949, ipnet:2600:3c0a::/32, country:SG];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	RCVD_COUNT_FIVE(0.00)[5];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[axboe@kernel.dk,io-uring@vger.kernel.org];
	DKIM_TRACE(0.00)[kernel-dk.20251104.gappssmtp.com:+];
	NEURAL_HAM(-0.00)[-1.000];
	TAGGED_RCPT(0.00)[io-uring];
	MID_RHS_MATCH_FROM(0.00)[];
	RCPT_COUNT_FIVE(0.00)[5];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns,kernel-dk.20251104.gappssmtp.com:dkim]
X-Rspamd-Queue-Id: A6E74457F70
X-Rspamd-Action: no action
X-Rspamd-Server: lfdr

On 4/23/26 3:45 PM, Bernd Schubert wrote:
> 
> 
> On 4/21/26 19:47, Jens Axboe wrote:
>> Hi Ming,
>>
>> Ran into the below running tests on the current tree:
>>
>> =============================
>> WARNING: suspicious RCU usage
>> 7.0.0+ #16 Tainted: G                 N 
>> -----------------------------
>> lib/maple_tree.c:759 suspicious rcu_dereference_check() usage!
>>
>> other info that might help us debug this:
>>
>>
>> rcu_scheduler_active = 2, debug_locks = 1
>> 1 lock held by iou-wrk-55535/55536:
>>  #0: ffff800085a451a0 (ublk_ctl_mutex){+.+.}-{4:4}, at: ublk_ctrl_del_dev+0xdc/0x2f8
>>
>> stack backtrace:
>> CPU: 4 UID: 0 PID: 55536 Comm: iou-wrk-55535 Tainted: G                 N  7.0.0+ #16 PREEMPT 
>> Tainted: [N]=TEST
>> Hardware name: linux,dummy-virt (DT)
>> Call trace:
>>  show_stack+0x1c/0x30 (C)
>>  dump_stack_lvl+0x68/0x90
>>  dump_stack+0x18/0x20
>>  lockdep_rcu_suspicious+0x170/0x200
>>  mas_walk+0x3f0/0x6a0
>>  mas_find+0x1b4/0x6b0
>>  ublk_buf_cleanup+0xe0/0x240
>>  ublk_cdev_rel+0x34/0x1b0
>>  device_release+0xa4/0x350
>>  kobject_put+0x138/0x250
>>  put_device+0x18/0x30
>>  ublk_put_device+0x18/0x28
>>  ublk_ctrl_del_dev+0x120/0x2f8
>>  ublk_ctrl_uring_cmd+0x598/0x29b8
>>  io_uring_cmd+0x1e0/0x468
>>  __io_issue_sqe+0xa4/0x748
>>  io_issue_sqe+0x80/0xf68
>>  io_wq_submit_work+0x26c/0xdc8
>>  io_worker_handle_work+0x334/0xf20
>>  io_wq_worker+0x278/0x9e8
>>  ret_from_fork+0x10/0x20
>> Buffer I/O error on dev ublkb0, logical block 0, async page read
>> Buffer I/O error on dev ublkb0, logical block 0, async page read
>>  ublkb0: unable to read partition table
>> Buffer I/O error on dev ublkb0, logical block 0, async page read
>> Buffer I/O error on dev ublkb0, logical block 0, async page read
>> Buffer I/O error on dev ublkb0, logical block 512, async page read
>> Buffer I/O error on dev ublkb0, logical block 512, async page read
>> Buffer I/O error on dev ublkb0, logical block 0, async page read
>> Buffer I/O error on dev ublkb0, logical block 512, async page read
>>
>> and I briefly looked at it, but then just gave up as a) the maple tree
>> documentation is not that detailed, and b) other in-tree users also just
>> call mas_for_each() without either a lock held or RCU read side locked.
>>
>> Adding Liam for shedding some light on this...
>>
> 
> Hmm, that is another one, I run into
> 
> Date:   Thu Apr 16 15:16:04 2026 +0200
> 
>     ublk: Add rcu_read_lock/unlock in ublk_buf_cleanup
>     
>     [  399.994025] =============================
>     [  399.994694] WARNING: suspicious RCU usage
>     [  399.995464] 7.0.0+ #52 Not tainted
>     [  399.996034] -----------------------------
>     [  399.996697] lib/maple_tree.c:780 suspicious rcu_dereference_check() usage!
>     [  399.997748]
>                    other info that might help us debug this:
>     
>     [  399.998961]
>                    rcu_scheduler_active = 2, debug_locks = 1
>     [  399.999957] 1 lock held by iou-wrk-1495/1509:
>     [  400.000596]  #0: ffffffffa05e4590 (ublk_ctl_mutex){+.+.}-{4:4}, at: ublk_ctrl_del_dev+0x3d/0x190 [ublk_drv]
>     [  400.001796]
>                    stack backtrace:
>     [  400.002492] CPU: 40 UID: 0 PID: 1509 Comm: iou-wrk-1495 Not tainted 7.0.0+ #52 PREEMPT
>     [  400.002496] Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.17.0-debian-1.17.0-1ubuntu1 04/01/2014
>     [  400.002498] Call Trace:
>     [  400.002500]  <TASK>
>     [  400.002503]  dump_stack_lvl+0x54/0x70
>     [  400.002511]  lockdep_rcu_suspicious+0x119/0x160
>     [  400.002521]  mas_start+0xed/0x140
>     [  400.002531]  mas_find+0x1a6/0x270
>     [  400.002538]  ublk_cdev_rel+0xb8/0x320 [ublk_drv]
> 
> 
> And have in my pbuf branch
> 
> index eb9b5dd8122c..208f6b5ad892 100644
> --- a/drivers/block/ublk_drv.c
> +++ b/drivers/block/ublk_drv.c
> @@ -5478,6 +5478,7 @@ static void ublk_buf_cleanup(struct ublk_device *ub)
>         struct ublk_buf_range *range;
>         struct page *pages[32];
>  
> +       rcu_read_lock();
>         mas_for_each(&mas, range, ULONG_MAX) {
>                 unsigned long base = mas.index;
>                 unsigned long nr = mas.last - base + 1;
> @@ -5495,6 +5496,7 @@ static void ublk_buf_cleanup(struct ublk_device *ub)
>                 }
>                 kfree(range);
>         }
> +       rcu_read_unlock();
>         mtree_destroy(&ub->buf_tree);
>         ida_destroy(&ub->buf_ida);
>  }

Fixed in patches going to Linus tomorrow, see HEAD~3..HEAD~1 in this
branch:

https://git.kernel.org/pub/scm/linux/kernel/git/axboe/linux.git/log/?h=block-7.1

-- 
Jens Axboe


