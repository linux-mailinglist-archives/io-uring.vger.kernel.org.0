Return-Path: <io-uring+bounces-11837-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id YG6XDdahb2kLCAAAu9opvQ
	(envelope-from <io-uring+bounces-11837-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Tue, 20 Jan 2026 16:40:06 +0100
X-Original-To: lists+io-uring@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [142.0.200.124])
	by mail.lfdr.de (Postfix) with ESMTPS id 99A6E4657A
	for <lists+io-uring@lfdr.de>; Tue, 20 Jan 2026 16:40:05 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id 153C49A5C68
	for <lists+io-uring@lfdr.de>; Tue, 20 Jan 2026 15:11:10 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1677744DB90;
	Tue, 20 Jan 2026 14:57:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="jDM2FRJm"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ot1-f49.google.com (mail-ot1-f49.google.com [209.85.210.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1F8D7243387
	for <io-uring@vger.kernel.org>; Tue, 20 Jan 2026 14:57:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768921043; cv=none; b=rkJe28qRcqTXbMt6rqAnOExeny0lXLfUA5xpEYR2tOwchuTagR4j7vzhHgouxLUGqkmGhP0Ykt4SgXIvA7h442LIaT7GG1dEHSguK2CwUsHZe4qtQ4dIWvHCfH7lVsNzZtZPwidbaaqCt3KsD8oAJuy5J8ZOwlbxmFlvbgn5pqg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768921043; c=relaxed/simple;
	bh=MNDHOzGOjwdHNpVqzd6uezrl3mpAJcuJ8BscLdMS2ew=;
	h=Message-ID:Date:MIME-Version:To:From:Subject:Content-Type; b=Ma26TJvwHKw2jE1RQetS8hL5DyFnvLdGKSu3fOZRbIcCwu1JkALsDdNCqCoDFXEfMrKwg57v3Hxw1FIZU/e14j813tY5i2S/Qe28DdFK/+gREEZCpRCsVbs2XyF/Sac4akQ+FuRkaaZAmZmvnNhDAEHuWePvaUGEZYXhaWYiEiA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=jDM2FRJm; arc=none smtp.client-ip=209.85.210.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-ot1-f49.google.com with SMTP id 46e09a7af769-7cfca52ac2dso3385975a34.0
        for <io-uring@vger.kernel.org>; Tue, 20 Jan 2026 06:57:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1768921038; x=1769525838; darn=vger.kernel.org;
        h=content-transfer-encoding:subject:from:to:content-language
         :user-agent:mime-version:date:message-id:from:to:cc:subject:date
         :message-id:reply-to;
        bh=C8Ahd/r5jeIUKCDp42qLCzSwfl0NdeJBQjQPD07byx8=;
        b=jDM2FRJmNKr8GSWXYj5vbcnpU59gUuQ7BLgRf6kXzTqxz2NuVu7Awxpek2Aj3VYMFL
         Fq9SMVxIki5d+R9YM1sqdnfoaFacsVbaEz39Q2XR/6OZ/LsrKN6xEZoFcluQkUj0v3nn
         yZjm75u8LeZivG8ZR3Tn45GLwsbJ+Qg2cdmnFshMkUo1de+YnVkBHRGhKzOT4yhQkQBM
         +TaBwCRBWgB5893vEDn69+7GR6MQ7TqBj8KOtELP4PHXpexd9Lwc9hlQf4mNAmDmaagi
         8k5kjpciaoPYS9p7kc/0SVpIq2yocTVbUVrzK0Zi46j8B9auoh1taUE03NsMm4tBYdVm
         J3AA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1768921038; x=1769525838;
        h=content-transfer-encoding:subject:from:to:content-language
         :user-agent:mime-version:date:message-id:x-gm-gg:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=C8Ahd/r5jeIUKCDp42qLCzSwfl0NdeJBQjQPD07byx8=;
        b=cHxsOWbgwjGKZ6KsZd2IGSN1TrTv2mm5VV2/4quZp+k9TPxqP5aEMdd3cFXavHl4kb
         2D27LtWhM34Fzypw1uJG8iHFdpbRXr5EUz/zqcdOJ69yVuC9Uhg9bT236lhmrhXJGfBE
         NVBNIKgR/zSttePntm352uFVcBKiiP+z4yGXrTXwVz/y1sDDUcYQ7kSyJOfO5pWEMG6x
         rJMyXw1ODSCx/Hls7Es40GOHjuyrjvOmNtDKCScudKbCE/DqCHgyKL/tjtxwZQYK8Jso
         15z3dYuQ6QuFnilstBTgqltA2cK5B1yaTksw/FTEZWsRwUyjCdeHEYIfsIYidruCzpZD
         BBrw==
X-Gm-Message-State: AOJu0Yy7hWmZF9SQZ6LZNRaFxHUtDcpMxM4gU84n89vgpDZ7baAHnR+L
	EjdEszV4m95UerbzhLzm/8uPsV+DHM0YDg2fsf4jadAffV6hOAPMKLS0WQA9xKVg2/NWeulwqYm
	yTSDVQ1Q=
X-Gm-Gg: AY/fxX6NvO0UyAP5MHWkA2sZnTFHZT9X+YhdVOy9nAGwU20wsu9zv8Qv8I8j34+BAWd
	z8xZqdTszEmbO4gzoy6rAhJ8cCM8QzDysfEgK9AFjzXzyatMTyDHnMFcatz61ww/IQcfohEOiDc
	UtxkRccCJg2CAoR6iRAFzkZJr1GAzwds+ObmebMvEtmOOq2Xfq6UeLtJ8QEzT1eFC3n76urOxmp
	MPvkn6zyM79ZHYiR/7AB57XVlPnEQRXDoGLGHUR9pSlDGydQv+VEpdoo/TLIHVtrZq2/kvC3k1H
	siyYCkXQa5wA5WAOX0hmeDKgScNQYPvi1diL5MZzvA7kZLkxER88I6ggd84zR3irXn4AM882Zr8
	mqUVxn259hUEL/q9GftM0HWNP49avHGMv0scWmtF3VQfOIGUzzUYegDtkduyPfTXucNCtMAKVWa
	PoBAq42gnx6DYcWZgOAABpws76UHpG1cn4iyEwHeWnFC/qf284UyEt8mliylwzNGpbtdl9
X-Received: by 2002:a05:6830:4125:b0:7c7:69c8:2cb with SMTP id 46e09a7af769-7d140aae18bmr1082604a34.24.1768921038511;
        Tue, 20 Jan 2026 06:57:18 -0800 (PST)
Received: from [192.168.1.102] ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id 46e09a7af769-7cfdf0e956esm8629772a34.10.2026.01.20.06.57.17
        for <io-uring@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 20 Jan 2026 06:57:17 -0800 (PST)
Message-ID: <937c3e38-368e-43eb-9d7e-2dcc0697799f@kernel.dk>
Date: Tue, 20 Jan 2026 07:57:17 -0700
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Content-Language: en-US
To: io-uring <io-uring@vger.kernel.org>
From: Jens Axboe <axboe@kernel.dk>
Subject: [PATCH] io_uring/io-wq: check IO_WQ_BIT_EXIT inside work run loop
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spamd-Result: default: False [-1.46 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	R_DKIM_ALLOW(-0.20)[kernel-dk.20230601.gappssmtp.com:s=20230601];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	RCPT_COUNT_ONE(0.00)[1];
	TO_DN_ALL(0.00)[];
	TAGGED_FROM(0.00)[bounces-11837-lists,io-uring=lfdr.de];
	DMARC_NA(0.00)[kernel.dk];
	RCVD_TLS_LAST(0.00)[];
	DKIM_TRACE(0.00)[kernel-dk.20230601.gappssmtp.com:+];
	MIME_TRACE(0.00)[0:+];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	FROM_HAS_DN(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	R_SPF_SOFTFAIL(0.00)[~all:c];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[axboe@kernel.dk,io-uring@vger.kernel.org];
	ASN(0.00)[asn:7979, ipnet:142.0.200.0/24, country:US];
	RCVD_COUNT_FIVE(0.00)[5];
	TAGGED_RCPT(0.00)[io-uring];
	MID_RHS_MATCH_FROM(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[dfw.mirrors.kernel.org:rdns,dfw.mirrors.kernel.org:helo,kernel.dk:email,kernel.dk:mid]
X-Rspamd-Queue-Id: 99A6E4657A
X-Rspamd-Action: no action
X-Rspamd-Server: lfdr

Currently this is checked before running the pending work. Normally this
is quite fine, as work items either end up blocking (which will create a
new worker for other items), or they complete fairly quickly. But syzbot
reports an issue where io-wq takes seemingly forever to exit, and with a
bit of debugging, this turns out to be because it queues a bunch of big
(2GB - 4096b) reads with a /dev/msr* file. Since this file type doesn't
support ->read_iter(), loop_rw_iter() ends up handling them. Each read
returns 16MB of data read, which takes 20 (!!) seconds. With a bunch of
these pending, processing the whole chain can take a long time. Easily
longer than the syzbot uninterruptible sleep timeout of 140 seconds.
This then triggers a complaint off the io-wq exit path:

INFO: task syz.4.135:6326 blocked for more than 143 seconds.
      Not tainted syzkaller #0
      Blocked by coredump.
"echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
task:syz.4.135       state:D stack:26824 pid:6326  tgid:6324  ppid:5957   task_flags:0x400548 flags:0x00080000
Call Trace:
 <TASK>
 context_switch kernel/sched/core.c:5256 [inline]
 __schedule+0x1139/0x6150 kernel/sched/core.c:6863
 __schedule_loop kernel/sched/core.c:6945 [inline]
 schedule+0xe7/0x3a0 kernel/sched/core.c:6960
 schedule_timeout+0x257/0x290 kernel/time/sleep_timeout.c:75
 do_wait_for_common kernel/sched/completion.c:100 [inline]
 __wait_for_common+0x2fc/0x4e0 kernel/sched/completion.c:121
 io_wq_exit_workers io_uring/io-wq.c:1328 [inline]
 io_wq_put_and_exit+0x271/0x8a0 io_uring/io-wq.c:1356
 io_uring_clean_tctx+0x10d/0x190 io_uring/tctx.c:203
 io_uring_cancel_generic+0x69c/0x9a0 io_uring/cancel.c:651
 io_uring_files_cancel include/linux/io_uring.h:19 [inline]
 do_exit+0x2ce/0x2bd0 kernel/exit.c:911
 do_group_exit+0xd3/0x2a0 kernel/exit.c:1112
 get_signal+0x2671/0x26d0 kernel/signal.c:3034
 arch_do_signal_or_restart+0x8f/0x7e0 arch/x86/kernel/signal.c:337
 __exit_to_user_mode_loop kernel/entry/common.c:41 [inline]
 exit_to_user_mode_loop+0x8c/0x540 kernel/entry/common.c:75
 __exit_to_user_mode_prepare include/linux/irq-entry-common.h:226 [inline]
 syscall_exit_to_user_mode_prepare include/linux/irq-entry-common.h:256 [inline]
 syscall_exit_to_user_mode_work include/linux/entry-common.h:159 [inline]
 syscall_exit_to_user_mode include/linux/entry-common.h:194 [inline]
 do_syscall_64+0x4ee/0xf80 arch/x86/entry/syscall_64.c:100
 entry_SYSCALL_64_after_hwframe+0x77/0x7f
RIP: 0033:0x7fa02738f749
RSP: 002b:00007fa0281ae0e8 EFLAGS: 00000246 ORIG_RAX: 00000000000000ca
RAX: fffffffffffffe00 RBX: 00007fa0275e6098 RCX: 00007fa02738f749
RDX: 0000000000000000 RSI: 0000000000000080 RDI: 00007fa0275e6098
RBP: 00007fa0275e6090 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000000
R13: 00007fa0275e6128 R14: 00007fff14e4fcb0 R15: 00007fff14e4fd98

There's really nothing wrong here, outside of processing these reads
will take a LONG time. However, we can speed up the exit by checking the
IO_WQ_BIT_EXIT inside the io_worker_handle_work() loop, as syzbot will
exit the ring after queueing up all of these reads. Then once the first
item is processed, io-wq will simply cancel the rest. That should avoid
syzbot running into this complaint again.

Cc: stable@vger.kernel.org
Link: https://lore.kernel.org/all/68a2decc.050a0220.e29e5.0099.GAE@google.com/
Reported-by: syzbot+4eb282331cab6d5b6588@syzkaller.appspotmail.com
Signed-off-by: Jens Axboe <axboe@kernel.dk>

---

diff --git a/io_uring/io-wq.c b/io_uring/io-wq.c
index 9fd9f6ab722c..2fa7d3601edb 100644
--- a/io_uring/io-wq.c
+++ b/io_uring/io-wq.c
@@ -598,9 +598,9 @@ static void io_worker_handle_work(struct io_wq_acct *acct,
 	__releases(&acct->lock)
 {
 	struct io_wq *wq = worker->wq;
-	bool do_kill = test_bit(IO_WQ_BIT_EXIT, &wq->state);
 
 	do {
+		bool do_kill = test_bit(IO_WQ_BIT_EXIT, &wq->state);
 		struct io_wq_work *work;
 
 		/*

-- 
Jens Axboe


