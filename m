Return-Path: <io-uring+bounces-13842-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by mail.lfdr.de with LMTP
	id YGYXIVOXPmqtIgkAu9opvQ
	(envelope-from <io-uring+bounces-13842-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Fri, 26 Jun 2026 17:14:27 +0200
X-Original-To: lists+io-uring@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id D659E6CE60E
	for <lists+io-uring@lfdr.de>; Fri, 26 Jun 2026 17:14:26 +0200 (CEST)
Authentication-Results: mail.lfdr.de;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=VGEdF35x;
	spf=pass (mail.lfdr.de: domain of "io-uring+bounces-13842-lists+io-uring=lfdr.de@vger.kernel.org" designates 2600:3c0a:e001:db::12fc:5321 as permitted sender) smtp.mailfrom="io-uring+bounces-13842-lists+io-uring=lfdr.de@vger.kernel.org";
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("subspace.kernel.org:s=arc-20240116:i=1")
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 6451D30ED32D
	for <lists+io-uring@lfdr.de>; Fri, 26 Jun 2026 15:09:58 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 15E8037C11B;
	Fri, 26 Jun 2026 15:09:57 +0000 (UTC)
X-Original-To: io-uring@vger.kernel.org
Received: from mail-yw1-f174.google.com (mail-yw1-f174.google.com [209.85.128.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 04FA436D9E1
	for <io-uring@vger.kernel.org>; Fri, 26 Jun 2026 15:09:52 +0000 (UTC)
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782486596; cv=none; b=Gap4BW73+msAH3mSE9eAA6ZDYNNzUUeLKbLywQwO1m/fxvHbdFakLkYiS+5rm7QvBmrXBZ6H7f5FmyEaRY9a4hWG5mIXekEO7r/cXZ2JvBhoYJeuoDlPp7yogBLvlx3KK2PIrEu8eW7AIF2Z99wvHmSNAQvwj5ZMAIeskWqfvVI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782486596; c=relaxed/simple;
	bh=HLN8jh5FjMttL87tuGfBQWgkWd2nJLaWeRsgpBwqTM8=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=hnDnTrUaeiUr6j5Hyc80fcy7VDmSX9dt5mAtfaf1bzmsrEbTvUKHGRFTtmO7wnj+bcVYngnwSmbHz8sjkG1l8GEY4H+wcFbPLusowZWYPxjLj79qxNgOJDI133AcIL2roB8Zm4iHwbw49lAcDAQOFM2BdQez1jI/FB/DNrJfN54=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=VGEdF35x; arc=none smtp.client-ip=209.85.128.174
Received: by mail-yw1-f174.google.com with SMTP id 00721157ae682-80b127bb2bdso1946637b3.2
        for <io-uring@vger.kernel.org>; Fri, 26 Jun 2026 08:09:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1782486592; x=1783091392; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=Uwg4ScW9rTxeyxnBOcB3H4RQQ1Dm/pdUs5X3AGEG4BY=;
        b=VGEdF35xq1T0kCsJB9HoviASkhvHj1r6ZS1DHQ5cc6yUmXsIQiNxebxcnp6wfFlkxr
         r5WMa0mr5AvTEaNaTqAZkvh09vRvNjEFQ6aSM6l9k2E7zDJ/F7bZSjH7HB+Uxb/3/Sy0
         /Q9fYb8YqltNGOHgawgkRr8I8Eb0CvFovsF0Xrw3zP/zRYjn/x5jTPIIvd4V4/NnC7KF
         AqjfHM8KPLXFJMsgHxZ1CMTcstSMalC/XhwGNW/Sw6bnJXMIbTxKf8gzfag563Rn4Vpo
         vqguFOSXsSjIlE3d3l/OsWLtxoBK06e3jyogHDbrpj+3kVzegIgpIdIdnqxdaLo6QtA9
         dOHQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1782486592; x=1783091392;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Uwg4ScW9rTxeyxnBOcB3H4RQQ1Dm/pdUs5X3AGEG4BY=;
        b=s5YEPrkCWK4uN/clQcPpl4yq+kRQu78nnAq8kVIKOeOvZJJZT18KNT6Xeu5tllzQPE
         WBeADl8pIaHs3CEZVk2mK4msY7pToC7AVpU+KPO2o7vzoOtHYJtF8xjEypHr0HrV0ooy
         kRRL30j3vtic+uzmPmt20TbV3ojYGPgqLy/ootEOphSv/y+xS+YNt+gY6FkjnA540Cbt
         xvSJYDaM9g/nl2Fmybbmt1ECmHg//wWgR3ygMcpgyL04YckIfYuDsz5QGN+m+9BuTH7E
         cKFXlGGX/ncpnmXSSdyni/2MufuKYYyRABTtUvNCUBZdhyNb6MafeLGLq7J0J2ekkC/F
         o6AQ==
X-Gm-Message-State: AOJu0YzY2FgBvpT0x3XLDkEzEScy72bUAeFD4LXOwdPKUb40O4Wh5f5T
	dy/GdNXB0htfGzHAJLwhJA8n/q9h1ZqNY2fyS6dSGVXqYmMd6vzDkPPWAP6RubIRi1U=
X-Gm-Gg: AfdE7cn+dk1wN1534Zepm7eHANHOL0+xSDSgpK4/JhB22eZQPxstIaG3AdgNmsQy0cW
	mAYl5+1TMOO8lApVSMMvjAOW+Dnq6p6ww1iznDXAwsFxQLixngto3SPJK79aK72YdPJoTV01hep
	rofAKpLCgO3N0ZZ56A9vYIq1yB0ecfNuTBi3moT3FNDnuC1iKY9JA6BfTNawPJgsjCkSRqUqHt6
	dj0gvuOa/dBkfwV28RKYBZ3p9Fk6/BxC3IfmgAcgAetuOB7Yz2TFyLWYzYdkY3tZocCl9fQhB9/
	yssgA3iKW1+Y5JbzkYJpwteTiTkQio1CWIfCYQmNcEF22Jm1TZKuWcMNd9hO9Yqcc9prS+awjWr
	bRj5SP+eqBHZstBu+3CMDQR8iUtIlbpZAHvzFGiT8ZzEY9GZCTA3xgEmSv1Ol18KWPTfNuIiUef
	VdrkFE3WUrSIS7utswzHpWzPn9viRtIGh2dC78b3gLONS5Yz3Vw/wysd90o4cpzPjSxFj/zg==
X-Received: by 2002:a05:690c:3682:b0:80c:85b6:7652 with SMTP id 00721157ae682-80c85b6852emr7292727b3.71.1782486591487;
        Fri, 26 Jun 2026 08:09:51 -0700 (PDT)
Received: from rivendell ([76.78.230.49])
        by smtp.gmail.com with ESMTPSA id 00721157ae682-80c211137bdsm5379197b3.12.2026.06.26.08.09.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 26 Jun 2026 08:09:51 -0700 (PDT)
From: Ben Carey <benjamin.james.carey3@gmail.com>
To: io-uring@vger.kernel.org
Cc: linux-kernel@vger.kernel.org,
	axboe@kernel.dk,
	stable@vger.kernel.org,
	benjamin.james.carey3@gmail.com
Subject: [BUG] RCU hang with io_uring nvme polling
Date: Fri, 26 Jun 2026 11:09:46 -0400
Message-ID: <20260626150946.287781-1-benjamin.james.carey3@gmail.com>
X-Mailer: git-send-email 2.54.0
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Action: no action
X-Spamd-Result: default: False [-1.66 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[gmail.com,none];
	R_MISSING_CHARSET(0.50)[];
	R_DKIM_ALLOW(-0.20)[gmail.com:s=20251104];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c0a:e001:db::/64:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	PRECEDENCE_BULK(0.00)[];
	TAGGED_FROM(0.00)[bounces-13842-lists,io-uring=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	FREEMAIL_CC(0.00)[vger.kernel.org,kernel.dk,gmail.com];
	FORGED_RECIPIENTS(0.00)[m:io-uring@vger.kernel.org,m:linux-kernel@vger.kernel.org,m:axboe@kernel.dk,m:stable@vger.kernel.org,m:benjamin.james.carey3@gmail.com,m:benjaminjamescarey3@gmail.com,s:lists@lfdr.de];
	FORGED_SENDER(0.00)[benjaminjamescarey3@gmail.com,io-uring@vger.kernel.org];
	FORGED_SENDER_MAILLIST(0.00)[];
	FREEMAIL_FROM(0.00)[gmail.com];
	FROM_HAS_DN(0.00)[];
	MIME_TRACE(0.00)[0:+];
	FORWARDED(0.00)[lists@lfdr.de];
	DKIM_TRACE(0.00)[gmail.com:+];
	ASN(0.00)[asn:63949, ipnet:2600:3c0a::/32, country:SG];
	FROM_NEQ_ENVFROM(0.00)[benjaminjamescarey3@gmail.com,io-uring@vger.kernel.org];
	TO_DN_NONE(0.00)[];
	ALIAS_RESOLVED(0.00)[];
	RCVD_COUNT_FIVE(0.00)[5];
	FORGED_SENDER_FORWARDING(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	MID_RHS_MATCH_FROM(0.00)[];
	TAGGED_RCPT(0.00)[io-uring];
	FORGED_RECIPIENTS_FORWARDING(0.00)[];
	RCPT_COUNT_FIVE(0.00)[5];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[vger.kernel.org:from_smtp,sea.lore.kernel.org:rdns,sea.lore.kernel.org:helo]
X-Rspamd-Server: lfdr
X-Rspamd-Queue-Id: D659E6CE60E

From: benjamin.james.carey3@gmail.com

Hello, whomever this may concern.

I am working in a lab researching energy efficiency of I/O servicing and
completion mechanisms, and we have encountered an issue when using io_uring and
completing I/O requests while polling NVMe drives.

Description
===========

When using fio to run io_uring test benches for energy consumption analysis
on our lab server, we're encountering strange kernel locking behaviors as
numjobs increases.

This issue occurs on our workloads the poll for I/O completion. Specifically,
whenever the numjobs parameter scales to beyond the nvme.poll_queues
parameter, the job takes much longer to complete or doesn't complete at all.

Notably, this issue occurs also on a QEMU image mimicking our setup. Using GDB
to read dmesg output we get the following:

...
rcu: INFO: rcu_preempt detected stalls on CPUs/tasks:
rcu: 	Tasks blocked on level-0 rcu_node (CPUs 0-7): P1070
rcu: 	(detected by 7, t=252035 jiffies, g=1985, q=25149 ncpus=8)
task:fio             state:R  running task     stack:13296 pid:1070  tgid:1070  ppid:1068   task_flags:0x400140 flags:0x00080000
Call Trace:
...
? blk_hctx_poll+0x34/0x80
blk_mq_poll+0x2b/0x40
bio_poll+0x94/0x180
iocb_bio_iopoll+0x31/0x50
io_uring_classic_poll+0x20/0x40
io_do_iopoll+0x233/0x430
? io_issue_sqe+0x2f/0x560
? io_submit_sqes+0x270/0x820
__do_sys_io_uring_enter+0x228/0x770
? handle_softirqs+0xc7/0x250
__x64_sys_io_uring_enter+0x21/0x30
x64_sys_call+0x17c8/0x1dd0
do_syscall_64+0xe0/0x5a0
entry_SYSCALL_64_after_hwframe+0x77/0x7f

Expected behavior
=================

fio job completes after specified runtime.

Actual behavior
===============

fio job never completes, system becomes less responsive (if the number of poll
queues and jobs are high) and RCU stall checker detects stalls.

Observations
============

After some minimal investigation we found this notable function being called as
the callback for q->mq_ops->poll:

static int nvme_poll(struct blk_mq_hw_ctx *hctx, struct io_comp_batch *iob)
{
	struct nvme_queue *nvmeq = hctx->driver_data;
	bool found;

	if (!test_bit(NVMEQ_POLLED, &nvmeq->flags) ||
	    !nvme_cqe_pending(nvmeq))
		return 0;

	spin_lock(&nvmeq->cq_poll_lock);
	found = nvme_poll_cq(nvmeq, iob);
	spin_unlock(&nvmeq->cq_poll_lock);

	return found;
}

This function, when stuck on the RCU loop, always returns 0. It also always
calls the helper function nvme_cqe_pending.

Following this are some items that may help in reproducing this issue.

Steps to reproduce
==================
From a running QEMU image with the latest kernel:
1. Attach GDB to the running instance.
2. Enable io polling via sysfs (echo 1 > /sys/block/nvme0n1/queue/io_poll).
3. Execute the fio job below.
4. After 1-2 minutes, observe RCU stalls.

Offending fio job
=================

fio --bs=1K --direct=1 --iodepth=1 --runtime=1 --rw=randread --time_based \
  --ioengine=io_uring --hipri=1 --fixedbufs=0 --registerfiles=0 \
    --sqthread_poll=0 \
  --numjobs=2 --name=job0 --output-format=json --clocksource=clock_gettime \
  --filename=/dev/nvme0n1

Kernel config
=============

Start with x86_defconfig

The following options are enabled for ease of debugging with GDB and QEMU.

In "Kernel Hacking" do the following:
- Set "Compile-time checks and compiler options -> Debug options" to "Rely on
  the toolchain's implicit default DWARF version."
- Set "Compile-time checks and compiler options -> Provide GDB scripts for
  debugging" to Yes.
- Set "x86 Debugging -> Choose kernel unwinder" to "Frame pointer unwinder."

In "Processor types and features" do the following:
- Set "Randomize the address of the kernel image (KASLR)" to No.

The following options are enabled to support NVMe over PCIe.

In "Device Drivers" do the following:
- Set "PCI Support -> PCI Endpoint support" to Yes.
- Set "NVMe Support -> NVM Express block device" to Module.
- Set "NVMe Support -> NVMe Target Support" to Module.
- Set "NVMe Support -> NVMe PCI Endpoint Function target support" to Module.

Kernel command line
===================

BOOT_IMAGE=/vmlinuz-7.1.0-g3996771b8f75 root=/dev/mapper/ubuntu--vg-ubuntu--lv \
ro nvme.poll_queues=1 nokaslr \
crashkernel=2G-4G:320M,4G-32G:512M,32G-64G:1024M,64G-128G:2048M,128G-:4096M

(nokaslr may be unneeded.)

QEMU command line
=================
qemu-system-x86_64 \
  -m 4G -enable-kvm -monitor stdio -s -S -smp 8 \
  -device nvme,serial=deadbeef,drive=nvm \
  -drive file=disk.img,index=0,media=disk,if=virtio \
  -drive file=nvme.img,index=1,media=disk,if=none,id=nvm \
  -chardev socket,path=/tmp/port1,server=on,wait=off,id=port1-char \
  -device virtio-serial \
  -device virtserialport,id=port1,chardev=port1-char,name=org.fedoraproject.port.0 \
  -net user,hostfwd=tcp::10022-:22,hostfwd=tcp::45455-:45455 \
  -net nic

For us, disk.img and nvme.img are created via:
dd if=/dev/zero of=disk.img bs=4K count=5000000
dd if=/dev/zero of=nvme.img bs=4K count=2000000

We then format disk.img with ext4.

To install a test userspace we download an ISO of Ubuntu Server 26.04 and
append the filename as a parameter to the QEMU task. After installing it.


If you all think there's a better mailing list to which this should be sent,
please let me know. Also, please let me know if there are other details about
how to reproduce this issue or the system on which this issue appears, or if
you have any other questions.

Best wishes,
Benjamin Carey

