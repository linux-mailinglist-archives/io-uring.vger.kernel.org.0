Return-Path: <io-uring+bounces-13102-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id uI9OGT2452mu/wEAu9opvQ
	(envelope-from <io-uring+bounces-13102-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Tue, 21 Apr 2026 19:47:41 +0200
X-Original-To: lists+io-uring@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [IPv6:2600:3c04:e001:36c::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id D87AD43E2BB
	for <lists+io-uring@lfdr.de>; Tue, 21 Apr 2026 19:47:40 +0200 (CEST)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id 148493010EF3
	for <lists+io-uring@lfdr.de>; Tue, 21 Apr 2026 17:47:38 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 465FE2FFDCB;
	Tue, 21 Apr 2026 17:47:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20251104.gappssmtp.com header.i=@kernel-dk.20251104.gappssmtp.com header.b="aj4tCdS9"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-oa1-f42.google.com (mail-oa1-f42.google.com [209.85.160.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 824E52C15B0
	for <io-uring@vger.kernel.org>; Tue, 21 Apr 2026 17:47:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776793655; cv=none; b=i0hbXesES8AtF/vLMh4Usyy9tTuubYcVwK3VxRzqL3wW1HhB0N8P/DjdAXz7/ydaoZUkjS10k0d7/UZ0R7nGIaqVZ+kjcw30x9gUMqPkLoaZSWhmuOJ7ADAtwFusVh/cjPr21k8pg2f3jznKwwSwjeJMKcBsHmnTb5TuFZ4bz7E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776793655; c=relaxed/simple;
	bh=hkog+jHq43lcN04D3PrxPQ8Az/WJVdZkCo6wI+g+PZ8=;
	h=Message-ID:Date:MIME-Version:To:Cc:From:Subject:Content-Type; b=S4KCjg4fDac5llDwPoa17P5OfWkrdPIg/aoeBDpJwo/O8MIuIgtvOXjkYOwiQ7D82tT5XjsQTIpnsrPWfQAajnR3u60OMajFmBSuv2p9rRu5VCMImay6KXtnRS3negzQbuJi4OU0+Xi3d3FrCDV9peRLXmHdBV54uzjS71n03fc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20251104.gappssmtp.com header.i=@kernel-dk.20251104.gappssmtp.com header.b=aj4tCdS9; arc=none smtp.client-ip=209.85.160.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-oa1-f42.google.com with SMTP id 586e51a60fabf-40946982a78so1560132fac.2
        for <io-uring@vger.kernel.org>; Tue, 21 Apr 2026 10:47:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20251104.gappssmtp.com; s=20251104; t=1776793652; x=1777398452; darn=vger.kernel.org;
        h=content-transfer-encoding:subject:from:cc:to:content-language
         :user-agent:mime-version:date:message-id:from:to:cc:subject:date
         :message-id:reply-to;
        bh=T+uA6tfiy5TvLcDxis+yr1LykpZrZeJjZDAG/n12EDI=;
        b=aj4tCdS9x5GUArACxWb/iBbZKhpuzy9kYuZX8WBv/Tt2QFHWkVQY4L2iS+rgUaBEMS
         eL12+45MxIIrmAICH5e6NtHEQF8lbXG5q2fPVnSjnKbLuLFIoM7a6iV36Cfq/enellmj
         OBi1WT5RnLOISDzRZyH03RrPqTVv91QlhEqwVtEAzvda/JcaKUxJ/khitKb6iSES3FAp
         bg2W3ADhmBBiJ+KLVdAx6B5NP+rEJRy5ZL/FiCDcNERlHhyt4DH0fn6Jpi8zSKt3WV90
         pts/kF4kTYVh7WuKcZnehlamOL0HRWgJcJr1ypPAB1RQWar5kudpwN3PkrJ7KCkXcbUA
         b0MQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1776793652; x=1777398452;
        h=content-transfer-encoding:subject:from:cc:to:content-language
         :user-agent:mime-version:date:message-id:x-gm-gg:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=T+uA6tfiy5TvLcDxis+yr1LykpZrZeJjZDAG/n12EDI=;
        b=UaUmQB0rKMfkCNQXwdLHZ0YygdFUopyf4beqzvqYOrYtHyfqPoeJyBk9XtwjNRK41A
         koOMZc9GJp0/+Hk3Up9PMCLWlLhL8GrY3wSj/vmoRQknYAboHG1H7tUHTEfHk23/QDTe
         faVUgGfGBt+PNs9FKAbFE+y3Ae0cfq7z2KT6fcoghLDtTpFFaefxunI9kLa4URvZRMO1
         oI5ac/UVdevuz2Exg82+ryY0j6lf+T6TMXXTrHZjdsDJ2AdSLp5Amn+scfSmWWNaYUp/
         kD26W+uLRwqo+XEbvP9o/y7VV4I5kRUWN8cn9YltqEQejFPCiQxQULfaQFllhZAJMweZ
         eQdw==
X-Gm-Message-State: AOJu0YymnJ6rDisqQaz1ykIRnCJJbCZqq9dbZ+LdBZr/a7nvd6H58XEM
	SJu4hAtnC+uv7Ycix3tMlmajBEpWGOvW4uv1qnKJBDIwq/n8C/fCSZKDCktH9w4uNNM=
X-Gm-Gg: AeBDieuqw/fhT93rfPkOoJJ9IVJDi1UxT++vfGYyBIAYE8BTgfphjqNB6Atrjn6AzZ+
	IK+5PKbfcDeVEBjp2ltRN2T0ylq20pF4VmqdApsZ6YNYgXhQnKzb20Ieq3ar0qb4fEoZYahoAXI
	ODF1xsqtl22r7O6iIuZWGtjv6KGzTXJGD0ciTPR00VHMrYqfh/tm8dGWAuKFDXQfTu0sZRyQ6hQ
	pyveexSOm2UA55yBM6UyXNx7bMWOUpQtSF6H1K0kIn8KLAzJ7A1IqQwQMSTvMkYETbROsHKfYaK
	kkN2vRbBBkSQ1D0SdfbdF/O5tJrwKQ7wn6DF4firQjMheyP2UpAzki1O2WAZDpPuwjHzoyL/pqt
	44ie/punJj9uVZnPbECQPXiXefO0UA8kDO1cEpAJLv8uWZr4mD4KaUPkUuffKfAX3oqFvVOUE9w
	5LTK4sh+frYkJAqyc4uNXBPR+wRkLHBc7M/qxSyVDB6Gb328EY2zMIsvvMSliat3xT5MvWSaw8F
	XpKKBo/7BKQcdhy06hwDnTs1KrLvA==
X-Received: by 2002:a05:6870:e8c:b0:41c:305b:14e1 with SMTP id 586e51a60fabf-42aded84232mr11979349fac.28.1776793652264;
        Tue, 21 Apr 2026 10:47:32 -0700 (PDT)
Received: from [192.168.1.102] ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id 586e51a60fabf-42f090b1de9sm1645594fac.6.2026.04.21.10.47.31
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 21 Apr 2026 10:47:31 -0700 (PDT)
Message-ID: <0349d72d-dff8-4f9f-b448-919fa5ae96da@kernel.dk>
Date: Tue, 21 Apr 2026 11:47:31 -0600
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Content-Language: en-US
To: Ming Lei <tom.leiming@gmail.com>
Cc: io-uring <io-uring@vger.kernel.org>,
 "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>,
 "Liam R. Howlett" <liam.howlett@oracle.com>
From: Jens Axboe <axboe@kernel.dk>
Subject: RCU warning off ublk_buf_cleanup() -> mas_for_each()
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spamd-Result: default: False [-1.66 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	R_DKIM_ALLOW(-0.20)[kernel-dk.20251104.gappssmtp.com:s=20251104];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c04:e001:36c::/64:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-13102-lists,io-uring=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	FROM_HAS_DN(0.00)[];
	FREEMAIL_TO(0.00)[gmail.com];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	TO_DN_SOME(0.00)[];
	DMARC_NA(0.00)[kernel.dk];
	MIME_TRACE(0.00)[0:+];
	TO_DN_EQ_ADDR_SOME(0.00)[];
	DKIM_TRACE(0.00)[kernel-dk.20251104.gappssmtp.com:+];
	ASN(0.00)[asn:63949, ipnet:2600:3c04::/32, country:SG];
	FORGED_SENDER_MAILLIST(0.00)[];
	RCVD_COUNT_FIVE(0.00)[5];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[axboe@kernel.dk,io-uring@vger.kernel.org];
	RCPT_COUNT_THREE(0.00)[4];
	NEURAL_HAM(-0.00)[-1.000];
	TAGGED_RCPT(0.00)[io-uring];
	MID_RHS_MATCH_FROM(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[kernel.dk:mid,tor.lore.kernel.org:helo,tor.lore.kernel.org:rdns]
X-Rspamd-Queue-Id: D87AD43E2BB
X-Rspamd-Action: no action
X-Rspamd-Server: lfdr

Hi Ming,

Ran into the below running tests on the current tree:

=============================
WARNING: suspicious RCU usage
7.0.0+ #16 Tainted: G                 N 
-----------------------------
lib/maple_tree.c:759 suspicious rcu_dereference_check() usage!

other info that might help us debug this:


rcu_scheduler_active = 2, debug_locks = 1
1 lock held by iou-wrk-55535/55536:
 #0: ffff800085a451a0 (ublk_ctl_mutex){+.+.}-{4:4}, at: ublk_ctrl_del_dev+0xdc/0x2f8

stack backtrace:
CPU: 4 UID: 0 PID: 55536 Comm: iou-wrk-55535 Tainted: G                 N  7.0.0+ #16 PREEMPT 
Tainted: [N]=TEST
Hardware name: linux,dummy-virt (DT)
Call trace:
 show_stack+0x1c/0x30 (C)
 dump_stack_lvl+0x68/0x90
 dump_stack+0x18/0x20
 lockdep_rcu_suspicious+0x170/0x200
 mas_walk+0x3f0/0x6a0
 mas_find+0x1b4/0x6b0
 ublk_buf_cleanup+0xe0/0x240
 ublk_cdev_rel+0x34/0x1b0
 device_release+0xa4/0x350
 kobject_put+0x138/0x250
 put_device+0x18/0x30
 ublk_put_device+0x18/0x28
 ublk_ctrl_del_dev+0x120/0x2f8
 ublk_ctrl_uring_cmd+0x598/0x29b8
 io_uring_cmd+0x1e0/0x468
 __io_issue_sqe+0xa4/0x748
 io_issue_sqe+0x80/0xf68
 io_wq_submit_work+0x26c/0xdc8
 io_worker_handle_work+0x334/0xf20
 io_wq_worker+0x278/0x9e8
 ret_from_fork+0x10/0x20
Buffer I/O error on dev ublkb0, logical block 0, async page read
Buffer I/O error on dev ublkb0, logical block 0, async page read
 ublkb0: unable to read partition table
Buffer I/O error on dev ublkb0, logical block 0, async page read
Buffer I/O error on dev ublkb0, logical block 0, async page read
Buffer I/O error on dev ublkb0, logical block 512, async page read
Buffer I/O error on dev ublkb0, logical block 512, async page read
Buffer I/O error on dev ublkb0, logical block 0, async page read
Buffer I/O error on dev ublkb0, logical block 512, async page read

and I briefly looked at it, but then just gave up as a) the maple tree
documentation is not that detailed, and b) other in-tree users also just
call mas_for_each() without either a lock held or RCU read side locked.

Adding Liam for shedding some light on this...

-- 
Jens Axboe


