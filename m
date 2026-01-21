Return-Path: <io-uring+bounces-11862-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id sA4qCKgjcWl8eQAAu9opvQ
	(envelope-from <io-uring+bounces-11862-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Wed, 21 Jan 2026 20:06:16 +0100
X-Original-To: lists+io-uring@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [IPv6:2605:f480:58:1:0:1994:3:14])
	by mail.lfdr.de (Postfix) with ESMTPS id 83D965BCF6
	for <lists+io-uring@lfdr.de>; Wed, 21 Jan 2026 20:06:15 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id 59F7AB64CE9
	for <lists+io-uring@lfdr.de>; Wed, 21 Jan 2026 17:48:56 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0F3CA35F8BD;
	Wed, 21 Jan 2026 17:40:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="sw8Ft/Yd"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-oi1-f178.google.com (mail-oi1-f178.google.com [209.85.167.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6A8A8340DAB
	for <io-uring@vger.kernel.org>; Wed, 21 Jan 2026 17:40:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.178
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769017205; cv=none; b=kW893VnulgHecz/VJw7bAfd1UQLefnLLzoXFGgv38av6WNFAqDHsNk1ujaO6VOY4s4mS5yeBIUgsCM8KHX0ABRmphjjjITulcdCx/G2dKyDW7qAhC/0tD9wJ5/mx6+P/JEIRkzVndtICjdKhT6jTJ9njrPbmI128h0a91rymRaU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769017205; c=relaxed/simple;
	bh=zFTo0irLgEmqdaedqmgzumllkNbee2ofdCeXyzwf32A=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=B5azD8pfjByrLyadv/qQbwMcPjCIz7jtL2w6iIzkYTu2yZ7klvHRzxRuBLbCn/y4RpgF04ytOvIVbVLMndAUdxi4EW1gO3UHL/ZG+wlzrPdViZanI1d6CHVR+1LTeufqq/EfMd+GhhuYWOYNmX25fXtXgQVeXD1thKkfocDlNCs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=sw8Ft/Yd; arc=none smtp.client-ip=209.85.167.178
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-oi1-f178.google.com with SMTP id 5614622812f47-45c92df37fdso52959b6e.3
        for <io-uring@vger.kernel.org>; Wed, 21 Jan 2026 09:40:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1769017200; x=1769622000; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:to:subject:user-agent:mime-version:date:message-id:from
         :to:cc:subject:date:message-id:reply-to;
        bh=lbfr84cBvpJtHIkeEU7JKZu5BFioyd+LYtmfg4+rFT0=;
        b=sw8Ft/YdCMmQvn9+OzvlnPMGz2igB5gL94xmxuIM7SIy+FlLnhbTAg7agdLbKIpWme
         0H7+qW/TkpJO30fU0Bml+uqX/y/0COT6KDZAKGzkK4wZzf1mnv4pGoG38XZjUprcZkin
         G8ib3BB6GOWDdaHc+4WMbNeXH48Ma0ij6LJi61d8UfgCKqGbRMDX4SyQuCUMyf5DJfVn
         UTjprW1Rdxd1mi0WBw/39wVCJosYZDLA1m9IaRyHeebuU3TaqgWF2ir55lsDqqvQ+aUO
         BeDXrcDzu46bumj19WsMbDo5nv+qmt8ol79O1Iwyv6oDm8eK/2fU5FKw6jrdBAEGUzBE
         P21Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1769017200; x=1769622000;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=lbfr84cBvpJtHIkeEU7JKZu5BFioyd+LYtmfg4+rFT0=;
        b=V4743RVZy+3O+VXLyrkhv08svnCloi0XzIQoY4krwgCE1NxaCcvHGPR0t9MzWgDpfS
         oliUVT2JwOkSD8wKq6pqFO/Xd2SfTj3/yk2cDyb+Yea/jn1HrFx1wPTGp4hgiivB0qyY
         QZQquafYEIu2OUyaxP5jwbhYl2W8In80yeLk1Z6jv8YmshmeG1MGOAUwdnsJcXg3X/zS
         Csaqs44lWaQhph4G8nta77xTRtCEtHmOkSIqVhPdeKt5Mb6koJyVIOoK5uhpogr/fohD
         b4j2l2Ph/h4/39C2nZ2R5zG2Ew5LNF0P6InBltCD69TrcouKccXHwU/jCV7BKvdpCgvV
         c78w==
X-Forwarded-Encrypted: i=1; AJvYcCXhzexaklC2wnisKMCV/GcNsvEt1GKofXp1r51TNVLz6+LABaItc5YoMXAqdsn7yA2RVUTLSrRNXA==@vger.kernel.org
X-Gm-Message-State: AOJu0Yy0wtLSgZ8Eyb9QPkbX/6YdL3LtnVVHnaDBkGiuavvyc22Uprh5
	kVT85HdgkfNeQ9Q/moF/M4PYNj+/rT2ZS1mcUatgCSwooumoYDQD3F2FqkULktQIR48=
X-Gm-Gg: AZuq6aKe04soPEdd6jQCcNGfW391mST7I2728FRRwmwBuUHTZOLA3CmhYWo+LpCafF5
	V1b+THPxwYkkRCWNtNJQye4Ik81n4ZKOKmmD76CgxGABKoKeuF3/x64TflLkD0jY/rzm3dSyPZO
	WvYebP3vFzahnwkBjPTrmHHbt4/tQ8pbBQjb8z+s8+/ksK0094t1ePUjY5FVqkeiGoZZxq2kMs+
	BGYcFe9EQG9RDdr6yqfhbmp75JOpk/M7vl1k5wOBUDtf3nLteL04WY5xfNKiD+/7VPOS1m0VygM
	iASo6xxRzvp6ejZLHjjMOMog0Az/BgKA4tAjE01MwlYbOrn0HOsHQV4WJNaZuMe1Obf1mWCCP4a
	Ld9azvLeeDgkRWlrAKkx69laO1gAzqg94yI56VIC2blBH0bi/J8GItBZgBfw5vuWSihcJD9WYFv
	LOtyBa2Jgp0KwktXtXNeIomU5uSyP2mCOiu4B0OrSTwzOmpPztywpML8Esz2DXRC3ZHWIp
X-Received: by 2002:a05:6808:6709:b0:450:cfd3:cfba with SMTP id 5614622812f47-45c9c11f263mr8226935b6e.57.1769017200601;
        Wed, 21 Jan 2026 09:40:00 -0800 (PST)
Received: from [192.168.1.102] ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id 586e51a60fabf-4044bd150dasm11909862fac.14.2026.01.21.09.39.59
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 21 Jan 2026 09:40:00 -0800 (PST)
Message-ID: <3b3a65a9-44d7-43d3-a4ad-62557fb48758@kernel.dk>
Date: Wed, 21 Jan 2026 10:39:59 -0700
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [syzbot] [io-uring?] INFO: task hung in io_wq_put_and_exit (6)
To: syzbot <syzbot+4eb282331cab6d5b6588@syzkaller.appspotmail.com>,
 io-uring@vger.kernel.org, linux-kernel@vger.kernel.org,
 syzkaller-bugs@googlegroups.com
References: <696fc9e7.a70a0220.111c58.0006.GAE@google.com>
Content-Language: en-US
From: Jens Axboe <axboe@kernel.dk>
In-Reply-To: <696fc9e7.a70a0220.111c58.0006.GAE@google.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spamd-Result: default: False [-1.46 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	R_DKIM_ALLOW(-0.20)[kernel-dk.20230601.gappssmtp.com:s=20230601];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	TAGGED_FROM(0.00)[bounces-11862-lists,io-uring=lfdr.de];
	DKIM_TRACE(0.00)[kernel-dk.20230601.gappssmtp.com:+];
	DMARC_NA(0.00)[kernel.dk];
	RCVD_TLS_LAST(0.00)[];
	RCPT_COUNT_THREE(0.00)[4];
	MIME_TRACE(0.00)[0:+];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	FROM_HAS_DN(0.00)[];
	TO_DN_SOME(0.00)[];
	R_SPF_SOFTFAIL(0.00)[~all:c];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[axboe@kernel.dk,io-uring@vger.kernel.org];
	ASN(0.00)[asn:7979, ipnet:2605:f480::/32, country:US];
	RCVD_COUNT_FIVE(0.00)[5];
	TAGGED_RCPT(0.00)[io-uring,4eb282331cab6d5b6588];
	MID_RHS_MATCH_FROM(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	SUBJECT_HAS_QUESTION(0.00)[]
X-Rspamd-Queue-Id: 83D965BCF6
X-Rspamd-Action: no action
X-Rspamd-Server: lfdr

On 1/20/26 11:31 AM, syzbot wrote:
> Hello,
> 
> syzbot has tested the proposed patch but the reproducer is still triggering an issue:
> INFO: task hung in io_wq_put_and_exit
> 
> INFO: task syz.1.135:6891 blocked for more than 143 seconds.
>       Not tainted syzkaller #0
>       Blocked by coredump.
> "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
> task:syz.1.135       state:D stack:25688 pid:6891  tgid:6887  ppid:6342   task_flags:0x400548 flags:0x00080000
> Call Trace:
>  <TASK>
>  context_switch kernel/sched/core.c:5260 [inline]
>  __schedule+0xfe4/0x5e10 kernel/sched/core.c:6867
>  __schedule_loop kernel/sched/core.c:6949 [inline]
>  schedule+0xdd/0x390 kernel/sched/core.c:6964
>  schedule_timeout+0x1b2/0x280 kernel/time/sleep_timeout.c:75
>  do_wait_for_common kernel/sched/completion.c:100 [inline]
>  __wait_for_common+0x2e7/0x4c0 kernel/sched/completion.c:121
>  io_wq_exit_workers io_uring/io-wq.c:1325 [inline]

Not sure how much better we can make this. syzbot is running on 2 cpus,
and spawns hundreds of "lets read 2GB from MSR", which are super slow.
So you have 2 cpus wanting to run hundreds of these. And yes that'll
mean that exiting a ring can take a loooong time, because even if it
needs to finish just a single reader, that's a lot of MSR data to read
when you have hundreds of tasks doing the same thing.

IOW, there's no bug here, other than yes if you overload the system so
substantially on a small system, then yes things will take a long time
to finish.

That said, it'd be nice to get this bug flagged as such, however I'm not
aware of any way to really do that. We can obviously work-around this in
io-wq:

diff --git a/io_uring/io-wq.c b/io_uring/io-wq.c
index 2fa7d3601edb..3c94f281ff6b 100644
--- a/io_uring/io-wq.c
+++ b/io_uring/io-wq.c
@@ -17,6 +17,7 @@
 #include <linux/task_work.h>
 #include <linux/audit.h>
 #include <linux/mmu_context.h>
+#include <linux/sched/sysctl.h>
 #include <uapi/linux/io_uring.h>
 
 #include "io-wq.h"
@@ -1313,6 +1314,13 @@ static void io_wq_cancel_tw_create(struct io_wq *wq)
 
 static void io_wq_exit_workers(struct io_wq *wq)
 {
+	/*
+	 * Shut up hung task complaint, see for example
+	 *
+	 * https://lore.kernel.org/all/696fc9e7.a70a0220.111c58.0006.GAE@google.com/
+	 */
+	unsigned long timeout = sysctl_hung_task_timeout_secs * HZ / 2;
+
 	if (!wq->task)
 		return;
 
@@ -1322,7 +1330,11 @@ static void io_wq_exit_workers(struct io_wq *wq)
 	io_wq_for_each_worker(wq, io_wq_worker_wake, NULL);
 	rcu_read_unlock();
 	io_worker_ref_put(wq);
-	wait_for_completion(&wq->worker_done);
+	do {
+		if (wait_for_completion_timeout(&wq->worker_done, timeout))
+			break;
+		printk("io-wq: taking a long time to exit\n");
+	} while (1);
 
 	spin_lock_irq(&wq->hash->wait.lock);
 	list_del_init(&wq->wait.entry);

which we can obviously do, but it's also really annoying imho. But I
guess that can be coupled with a dump, etc.

-- 
Jens Axboe

