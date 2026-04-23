Return-Path: <io-uring+bounces-13135-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id kCS+MumW6mnb1AIAu9opvQ
	(envelope-from <io-uring+bounces-13135-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Fri, 24 Apr 2026 00:02:17 +0200
X-Original-To: lists+io-uring@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [IPv6:2600:3c04:e001:36c::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id DEACF458036
	for <lists+io-uring@lfdr.de>; Fri, 24 Apr 2026 00:02:16 +0200 (CEST)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id A78E43014748
	for <lists+io-uring@lfdr.de>; Thu, 23 Apr 2026 22:02:15 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4FFB133B97F;
	Thu, 23 Apr 2026 22:02:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20251104.gappssmtp.com header.i=@kernel-dk.20251104.gappssmtp.com header.b="npOOXg0s"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-oa1-f42.google.com (mail-oa1-f42.google.com [209.85.160.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 133151F1932
	for <io-uring@vger.kernel.org>; Thu, 23 Apr 2026 22:02:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776981733; cv=none; b=I00Wb3mB/ebrbv9dirmhMtgTCtlD2FC08ygfhi2K9qSfuCWzwHffMMq/PluoVqQieXONtxWGozCq0DKzTt3vo1DDQ9fG2NCMWPRNftE81l7msmq4+tDtvxoWvcTAtLjv3lUxdq+8us9/lxW/hIgCTILq6jQNLf9LkU8Q4u9NASM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776981733; c=relaxed/simple;
	bh=gb12mONxrM/PepYDUN2yzGBh72c11PptH8JGgN0a8uU=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=NXmShRzNOfK6pRRs8Nd+o9tuLvvFWS4ovIam1WIkKeoe6Zvy7c1THgsEdhlop84EU9EmLPOfA/SlpfpONOFza1nwC4b5fniSJbgpbcMYUv91BN5y41RCdW2oLTdRywwhYjEFv1I58HTzA/+iDupSv8oQg9oWF9BIe2xWVzdgUKw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20251104.gappssmtp.com header.i=@kernel-dk.20251104.gappssmtp.com header.b=npOOXg0s; arc=none smtp.client-ip=209.85.160.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-oa1-f42.google.com with SMTP id 586e51a60fabf-404254ffe8aso5050125fac.0
        for <io-uring@vger.kernel.org>; Thu, 23 Apr 2026 15:02:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20251104.gappssmtp.com; s=20251104; t=1776981730; x=1777586530; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=GoZ2co7Bz+IqthrcrKzDDIA2ehg1R3jtJrDEqqqayr4=;
        b=npOOXg0swr2zE5ioZnJrmwr6r+ucVPlClKWkfHo3S1LjGpS+YgM35SQ8tFZxDmY9Iy
         jcurdSkG/S4R8DzlDTgffXUTtK241e6xYtXy8E/A70XLkGb9L1BmeyggJ7Empnmn90oj
         6PD3xo2NqiAGiIJPcoY0IxOGwZWTbZO8qcFnV9Ap+xRlnYreXvJP8HSN9i6JAn1t7aOd
         MjgiALZhcm83kTFWEpB6Ci7sdne4kxJ2UpeoBF+VWZyK7eyqoc8o36HWf0DREtf+jbKX
         BG7VAn5bY0UkCqdaaim8+vFpX8Rps4aHwh2I7ONAfDOCwsUBe6gc3SDZ6w3SpcfOLlqf
         XCdA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1776981730; x=1777586530;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=GoZ2co7Bz+IqthrcrKzDDIA2ehg1R3jtJrDEqqqayr4=;
        b=lomNXGXyvVSaeBeRgGAyexWYoWo/EnQbdvLYA+rt2vkghYl7YzsbkM0q67Ig5lO7m/
         F5StdGPuXhtyl8iE1JJb7nSU3IS4zBPy59kCTByNLtnvM2sZKGLa2H/yLgmXHrAmZ/Zl
         LDOC8xjrioD7mh+d1MZGGPv7VqH3bBPM+SHCX+a7oEITLseLYxrm1St3G3mmpQh2dUQk
         nfAKwH0/ouKa0+m/3TfbnDO9GOyNrw5VtnxHd7+2MFc35xraRj3CrfStEBPN0cBY3Gk2
         pc0zJLlsv6/5NDj7VH4n4iRLuO5a6abkKfgsvK4NDLv//vMXOj/nMxaIR89ixQMj29UD
         O17w==
X-Gm-Message-State: AOJu0YwmRzEI6urTInXRjM6GjjKubwJOcHAmJF7Wkyo3uhXcMFp+DjuO
	ln6QoWNroEdf0z//QBmYZZYpPbnHSUYYge2ZtKpnHBA8sppxIuvkFJm3dP+QDxqKx8E=
X-Gm-Gg: AeBDieu77xH9mLefhLVpXogM0ddvb8BmmL4Yf+L2N0hNg9AF8Pf4fYjoBquqQYq/N2j
	k0pZATPLJzjDhl0zXWhG+gJwL2DIgPBL2I5bsOieuLKQUgYrrlSw4ftKbs/TwqLzTBVJMfOoARK
	WpnRWzpCRWgZ8wzOv5ehknJ4FOIJ0D8t19KAn/gNHwZGkhQRosfa3bylU2F2JWbD9Qw9v4YA2N/
	9cIXmGlkSVsEEQpSj1Ga/JsMXtWAQqbxCG7LcMsFe38Q7CVyPcmdtoi6Th9u5yj8hqxAjYlzxol
	U6HwbrQdDQH8l34eTXWUAtV7SBAghhUp+QAHTzjNk1mFqJdwC3s0PjkDDstcv33dIiUoO9q41Ef
	vaD5G/OCkPwl/jPaOvsq0A7d5BHkqScTQFZL1E2T0RbHC+hnQ6lfC9cJta1n5lZCfhMG3bs2sRu
	zsxVOv7jvKywG/HjkGKQLphMEFUZnNl6eb1kZnpPUm05nGiYX50OcCmp7Zn2DyXdSQ29eK9ksk1
	jPLy+QH8N8yZYNU9XxtF/raW+veWYU=
X-Received: by 2002:a05:6871:3a0c:b0:3f9:d552:f34 with SMTP id 586e51a60fabf-42a99a1f849mr14710748fac.14.1776981729780;
        Thu, 23 Apr 2026 15:02:09 -0700 (PDT)
Received: from [192.168.1.150] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id 586e51a60fabf-42b9ac6f2a3sm19787926fac.16.2026.04.23.15.02.08
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 23 Apr 2026 15:02:09 -0700 (PDT)
Message-ID: <313ec937-da71-4e34-abf2-f89280262d41@kernel.dk>
Date: Thu, 23 Apr 2026 16:02:08 -0600
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
 <331c739c-d0fd-4c53-bbd5-cbb18f5dfedb@kernel.dk>
 <4ec7a5a2-2338-4440-aa7f-b193aac0217f@bsbernd.com>
Content-Language: en-US
From: Jens Axboe <axboe@kernel.dk>
In-Reply-To: <4ec7a5a2-2338-4440-aa7f-b193aac0217f@bsbernd.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spamd-Result: default: False [-0.16 / 15.00];
	SUSPICIOUS_RECIPS(1.50)[];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c04:e001:36c::/64];
	R_DKIM_ALLOW(-0.20)[kernel-dk.20251104.gappssmtp.com:s=20251104];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	RCVD_TLS_LAST(0.00)[];
	DMARC_NA(0.00)[kernel.dk];
	TO_DN_EQ_ADDR_SOME(0.00)[];
	TAGGED_FROM(0.00)[bounces-13135-lists,io-uring=lfdr.de];
	FORGED_SENDER_MAILLIST(0.00)[];
	FREEMAIL_TO(0.00)[bsbernd.com,gmail.com];
	TO_DN_SOME(0.00)[];
	MIME_TRACE(0.00)[0:+];
	FROM_HAS_DN(0.00)[];
	ASN(0.00)[asn:63949, ipnet:2600:3c04::/32, country:SG];
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
	DBL_BLOCKED_OPENRESOLVER(0.00)[kernel-dk.20251104.gappssmtp.com:dkim,tor.lore.kernel.org:helo,tor.lore.kernel.org:rdns]
X-Rspamd-Queue-Id: DEACF458036
X-Rspamd-Action: no action
X-Rspamd-Server: lfdr

On 4/23/26 3:51 PM, Bernd Schubert wrote:
> 
> 
> On 4/23/26 23:48, Jens Axboe wrote:
>> On 4/23/26 3:45 PM, Bernd Schubert wrote:
>>>
>>>
>>> On 4/21/26 19:47, Jens Axboe wrote:
>>>> Hi Ming,
>>>>
>>>> Ran into the below running tests on the current tree:
>>>>
>>>> =============================
>>>> WARNING: suspicious RCU usage
>>>> 7.0.0+ #16 Tainted: G                 N 
>>>> -----------------------------
>>>> lib/maple_tree.c:759 suspicious rcu_dereference_check() usage!
>>>>
>>>> other info that might help us debug this:
>>>>
>>>>
>>>> rcu_scheduler_active = 2, debug_locks = 1
>>>> 1 lock held by iou-wrk-55535/55536:
>>>>  #0: ffff800085a451a0 (ublk_ctl_mutex){+.+.}-{4:4}, at: ublk_ctrl_del_dev+0xdc/0x2f8
>>>>
>>>> stack backtrace:
>>>> CPU: 4 UID: 0 PID: 55536 Comm: iou-wrk-55535 Tainted: G                 N  7.0.0+ #16 PREEMPT 
>>>> Tainted: [N]=TEST
>>>> Hardware name: linux,dummy-virt (DT)
>>>> Call trace:
>>>>  show_stack+0x1c/0x30 (C)
>>>>  dump_stack_lvl+0x68/0x90
>>>>  dump_stack+0x18/0x20
>>>>  lockdep_rcu_suspicious+0x170/0x200
>>>>  mas_walk+0x3f0/0x6a0
>>>>  mas_find+0x1b4/0x6b0
>>>>  ublk_buf_cleanup+0xe0/0x240
>>>>  ublk_cdev_rel+0x34/0x1b0
>>>>  device_release+0xa4/0x350
>>>>  kobject_put+0x138/0x250
>>>>  put_device+0x18/0x30
>>>>  ublk_put_device+0x18/0x28
>>>>  ublk_ctrl_del_dev+0x120/0x2f8
>>>>  ublk_ctrl_uring_cmd+0x598/0x29b8
>>>>  io_uring_cmd+0x1e0/0x468
>>>>  __io_issue_sqe+0xa4/0x748
>>>>  io_issue_sqe+0x80/0xf68
>>>>  io_wq_submit_work+0x26c/0xdc8
>>>>  io_worker_handle_work+0x334/0xf20
>>>>  io_wq_worker+0x278/0x9e8
>>>>  ret_from_fork+0x10/0x20
>>>> Buffer I/O error on dev ublkb0, logical block 0, async page read
>>>> Buffer I/O error on dev ublkb0, logical block 0, async page read
>>>>  ublkb0: unable to read partition table
>>>> Buffer I/O error on dev ublkb0, logical block 0, async page read
>>>> Buffer I/O error on dev ublkb0, logical block 0, async page read
>>>> Buffer I/O error on dev ublkb0, logical block 512, async page read
>>>> Buffer I/O error on dev ublkb0, logical block 512, async page read
>>>> Buffer I/O error on dev ublkb0, logical block 0, async page read
>>>> Buffer I/O error on dev ublkb0, logical block 512, async page read
>>>>
>>>> and I briefly looked at it, but then just gave up as a) the maple tree
>>>> documentation is not that detailed, and b) other in-tree users also just
>>>> call mas_for_each() without either a lock held or RCU read side locked.
>>>>
>>>> Adding Liam for shedding some light on this...
>>>>
>>>
>>> Hmm, that is another one, I run into
>>>
>>> Date:   Thu Apr 16 15:16:04 2026 +0200
>>>
>>>     ublk: Add rcu_read_lock/unlock in ublk_buf_cleanup
>>>     
>>>     [  399.994025] =============================
>>>     [  399.994694] WARNING: suspicious RCU usage
>>>     [  399.995464] 7.0.0+ #52 Not tainted
>>>     [  399.996034] -----------------------------
>>>     [  399.996697] lib/maple_tree.c:780 suspicious rcu_dereference_check() usage!
>>>     [  399.997748]
>>>                    other info that might help us debug this:
>>>     
>>>     [  399.998961]
>>>                    rcu_scheduler_active = 2, debug_locks = 1
>>>     [  399.999957] 1 lock held by iou-wrk-1495/1509:
>>>     [  400.000596]  #0: ffffffffa05e4590 (ublk_ctl_mutex){+.+.}-{4:4}, at: ublk_ctrl_del_dev+0x3d/0x190 [ublk_drv]
>>>     [  400.001796]
>>>                    stack backtrace:
>>>     [  400.002492] CPU: 40 UID: 0 PID: 1509 Comm: iou-wrk-1495 Not tainted 7.0.0+ #52 PREEMPT
>>>     [  400.002496] Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.17.0-debian-1.17.0-1ubuntu1 04/01/2014
>>>     [  400.002498] Call Trace:
>>>     [  400.002500]  <TASK>
>>>     [  400.002503]  dump_stack_lvl+0x54/0x70
>>>     [  400.002511]  lockdep_rcu_suspicious+0x119/0x160
>>>     [  400.002521]  mas_start+0xed/0x140
>>>     [  400.002531]  mas_find+0x1a6/0x270
>>>     [  400.002538]  ublk_cdev_rel+0xb8/0x320 [ublk_drv]
>>>
>>>
>>> And have in my pbuf branch
>>>
>>> index eb9b5dd8122c..208f6b5ad892 100644
>>> --- a/drivers/block/ublk_drv.c
>>> +++ b/drivers/block/ublk_drv.c
>>> @@ -5478,6 +5478,7 @@ static void ublk_buf_cleanup(struct ublk_device *ub)
>>>         struct ublk_buf_range *range;
>>>         struct page *pages[32];
>>>  
>>> +       rcu_read_lock();
>>>         mas_for_each(&mas, range, ULONG_MAX) {
>>>                 unsigned long base = mas.index;
>>>                 unsigned long nr = mas.last - base + 1;
>>> @@ -5495,6 +5496,7 @@ static void ublk_buf_cleanup(struct ublk_device *ub)
>>>                 }
>>>                 kfree(range);
>>>         }
>>> +       rcu_read_unlock();
>>>         mtree_destroy(&ub->buf_tree);
>>>         ida_destroy(&ub->buf_ida);
>>>  }
>>
>> Fixed in patches going to Linus tomorrow, see HEAD~3..HEAD~1 in this
>> branch:
>>
>> https://git.kernel.org/pub/scm/linux/kernel/git/axboe/linux.git/log/?h=block-7.1
>>
> 
> Thank you, will check after getting some sleep.

Sounds good - fixes the issue on my end.

-- 
Jens Axboe


