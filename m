Return-Path: <io-uring+bounces-4383-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 527639BA9A3
	for <lists+io-uring@lfdr.de>; Mon,  4 Nov 2024 00:53:39 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 011C41F215D1
	for <lists+io-uring@lfdr.de>; Sun,  3 Nov 2024 23:53:39 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BC67318BBA3;
	Sun,  3 Nov 2024 23:53:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="QTIqcH9V"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pf1-f174.google.com (mail-pf1-f174.google.com [209.85.210.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 64F2A15B13C
	for <io-uring@vger.kernel.org>; Sun,  3 Nov 2024 23:53:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730678014; cv=none; b=ieNYLHUI064r0nh/Zw80n9iTirs99ZtZvSv13+tl1Cbyu+q7YpCF499auMP3JOYAh0t6hYeYCTXYMXO9CxHCmJYYJYZsutNCfSSREHq5CN9TUqttjsIFZcjUXVKKR8ZdAxarcSWQh5GkbNSjPm/DOzpYwlhxYec1WKAyyTmp/M8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730678014; c=relaxed/simple;
	bh=0jtkBHN6wEJgdhY+hgsUGhQ2n0lP2JI3MbKpHj7KK4A=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=g5f8WbrulxQ7lGye2XBGOq5Xfivli7xc0F56+yamjf7DDm/6AlncRHbULZFVZfLy1wfmWz5sIPP/KzA6wGeYKgLPTMKow941t2tvkanucpiLUlKC1SX5OOTQNX6G9I7qRK9HmwGdCVMn2sI2ykHSHg2wTuTyPCNcWRp0RGsceG0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=QTIqcH9V; arc=none smtp.client-ip=209.85.210.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-pf1-f174.google.com with SMTP id d2e1a72fcca58-71e52582cf8so3074646b3a.2
        for <io-uring@vger.kernel.org>; Sun, 03 Nov 2024 15:53:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1730678009; x=1731282809; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=tphYYCvcLGlt42zOc1AH41I9arijWS1fq58YPnB4wxA=;
        b=QTIqcH9VEvSc/GBNaci50WG5boXI50xhosCuKz0jUTPpR1a/RL5xq8TIqeWM7RPZfo
         qC/WkKeaS1Rv4IuoHL+lcivSd/tt8SNCvy+Ldqwa26WWZ13Gzq+N6eMQ4ulaiG2bxPyJ
         MxQQYy/Oz7lMmsUzZxkCX1KbixTbxOqMoT5n2ih/i1/h+L69Yq3XUIEaC21pF+baSetp
         pLy3V20V9NPVw9lIfSBxCu+MktzakOvQa/8HNRdaofiNUy6t491lOw+UNVjW8im6wM/G
         Nz3JdyhXLibhqtfc/ToX3illk3cwOi5YtWD5UYr3Or2IiA0Whay3Xe3xBrMTWnhKsVho
         jQXw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1730678009; x=1731282809;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=tphYYCvcLGlt42zOc1AH41I9arijWS1fq58YPnB4wxA=;
        b=tNZ5apyqj9FajyvXHhwLmjdz8lLdUIQGInY+ZUHxBPd2M7KTlhT5pQnZ3nmjc5yufc
         dY188MYDu7IoG6jzQgZyO0j3T63BFOU9PsNHWTuzG47aqXqR+Gwjkg27BwU8fCbRClkb
         NrDY+viGX5GJYy0PKpDexrwwuizNTvWganjfU4i9zgDxzTa+zq0TAjaNzLBZ/+ddMp+I
         5dLcGMWpFyYEDgkkvoi+TivpvfXDcmDZJ+WMLPa0/MpnJ3rZv59wFB56d9fRD/5LitWd
         WWYMyWAw82LrZsKKkHcrjxsgebp3PmkB8RPgeXkjBF8qcnTNG3yRpxbRYl7vsz8H7o+L
         T9hA==
X-Gm-Message-State: AOJu0YxGbPR02XhKu799RSTL9YIqBt1Ut4R1I07FfZBomCPvOV/wANE9
	/sBjZDat6Ii5D+ZvxWkk9NR4duG9/CSdvdffxm94TgnFZmcz/TCCqp+Lr4TYzUc6YQKzhsNtBdW
	VUkA=
X-Google-Smtp-Source: AGHT+IHWsbj0oyOgPUUNzM3OjS6kA8ohkoLHcJrkAH1RCUzXJv8DbMfGalT6+e3GPZnoXpCd+geMkg==
X-Received: by 2002:a05:6a00:17a2:b0:71e:2a0:b0b8 with SMTP id d2e1a72fcca58-720c98a3b34mr15537127b3a.1.1730678009331;
        Sun, 03 Nov 2024 15:53:29 -0800 (PST)
Received: from [192.168.1.150] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-720bc2c569bsm6163081b3a.117.2024.11.03.15.53.28
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 03 Nov 2024 15:53:28 -0800 (PST)
Message-ID: <cc8b92ba-2daa-49e3-abe6-39e7d79f213d@kernel.dk>
Date: Sun, 3 Nov 2024 16:53:27 -0700
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: PROBLEM: io_uring hang causing uninterruptible sleep state on
 6.6.59
To: Andrew Marshall <andrew@johnandrewmarshall.com>
Cc: io-uring@vger.kernel.org
References: <3d913aef-8c44-4f50-9bdf-7d9051b08941@app.fastmail.com>
Content-Language: en-US
From: Jens Axboe <axboe@kernel.dk>
In-Reply-To: <3d913aef-8c44-4f50-9bdf-7d9051b08941@app.fastmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 11/3/24 4:47 PM, Andrew Marshall wrote:
> Hi,
> 
> I, and others (see downstream report below), are encountering io_uring
> at times hanging on 6.6.59 LTS. If the process is killed, the process
> remains stuck in sleep uninterruptible ("D"). This failure can be
> fairly reliably reproduced via Node.js with `npm ci` in at least some
> projects; disabling that tool?s use of io_uring causes via its
> configuration causes it to succeed. I have identified what seems to be
> the problematic commit on linux-6.6.y (f4ce3b5).
> 
> Summary of Kernel version triaging:
> 
> - 6.6.56: succeeds
> - 6.6.57: fails
> - 6.6.58: fails
> - 6.6.59: fails
> - 6.6.59 (with f4ce3b5 reverted): succeeds
> - 6.11.6: succeeds
> 
> System logs upon failure indicate hung task:
> 
> kernel: INFO: task npm ci:47920 blocked for more than 245 seconds.
> kernel:       Tainted: P           O       6.6.58 #1-NixOS
> kernel: "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
> kernel: task:npm ci          state:D stack:0     pid:47920 ppid:47710  flags:0x00004006
> kernel: Call Trace:
> kernel:  <TASK>
> kernel:  __schedule+0x3fc/0x1430
> kernel:  ? sysvec_apic_timer_interrupt+0xe/0x90
> kernel:  schedule+0x5e/0xe0
> kernel:  schedule_preempt_disabled+0x15/0x30
> kernel:  __mutex_lock.constprop.0+0x3a2/0x6b0
> kernel:  io_uring_del_tctx_node+0x61/0xf0
> kernel:  io_uring_clean_tctx+0x5c/0xc0
> kernel:  io_uring_cancel_generic+0x198/0x350
> kernel:  ? srso_return_thunk+0x5/0x5f
> kernel:  ? timerqueue_del+0x2e/0x50
> kernel:  ? __pfx_autoremove_wake_function+0x10/0x10
> kernel:  do_exit+0x167/0xad0
> kernel:  ? __pfx_hrtimer_wakeup+0x10/0x10
> kernel:  do_group_exit+0x31/0x80
> kernel:  get_signal+0xa60/0xa60
> kernel:  arch_do_signal_or_restart+0x3e/0x280
> kernel:  exit_to_user_mode_prepare+0x1d4/0x230
> kernel:  syscall_exit_to_user_mode+0x1b/0x50
> kernel:  do_syscall_64+0x45/0x90
> kernel:  entry_SYSCALL_64_after_hwframe+0x78/0xe2
> 
> For more details, see the downstream bug report in Node.js: https://github.com/nodejs/node/issues/55587
> 
> I identified f4ce3b5d26ce149e77e6b8e8f2058aa80e5b034e as the likely
> problematic commit simply by browsing git log. As indicated above;
> reverting that atop 6.6.59 results in success. Since it is passing on
> 6.11.6, I suspect there is some missing backport to 6.6.x, or some
> other semantic merge conflict. Unfortunately I do not have a compact,
> minimal reproducer, but can provide my large one (it is testing a
> larger build process in a VM) if needed?there are some additional
> details in the above-linked downstream bug report, though. I hope that
> having identified the problematic commit is enough for someone with
> more context to go off of. Happy to provide more information if
> needed.

Don't worry about not having a reproducer, having the backport commit
pin pointed will do just fine. I'll take a look at this.

-- 
Jens Axboe

