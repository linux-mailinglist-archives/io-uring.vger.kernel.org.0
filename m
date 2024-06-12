Return-Path: <io-uring+bounces-2189-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 7869D905732
	for <lists+io-uring@lfdr.de>; Wed, 12 Jun 2024 17:41:45 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 654F31C20888
	for <lists+io-uring@lfdr.de>; Wed, 12 Jun 2024 15:41:44 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9ECF01802D7;
	Wed, 12 Jun 2024 15:41:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="KmLj2ID2"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ej1-f46.google.com (mail-ej1-f46.google.com [209.85.218.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C68F417F367;
	Wed, 12 Jun 2024 15:41:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718206901; cv=none; b=fQ/vi6qRYD/zk6rT+qrgLyh4fDepCi9oUyRSnt+KMB4cnVQlTy0jkmMp5/2mdvsLjO6tjgyJAjPvL7LFkiZj0m0s7+V1vJHAllBpc8Gh7rj8n57DhHZfd/tGAfiOdO3kSfdnYbLcBgNTOhhon0McgzR/TYWg83MDobzKCA4eGTI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718206901; c=relaxed/simple;
	bh=Vd/7G+qW9Yqd/GXh+83NEPU/+bpz/NECT73XpGCdtbQ=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=XgQ6/FP+2Zz0uaC+X6w8mbYeCKIiZJtZrrPtE/lBLX2c7QyCYlvFChopvw2dg15ymJItuHVV47RgxpX3GPdMiUBG1S6YIDw+TDkj7SUuw1hen6t4YgkjfZt4O64DNRNsnTothzq/fGLAEnGACsVvHNQ6EmMi6QJRlYeOBzZgYaw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=KmLj2ID2; arc=none smtp.client-ip=209.85.218.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-ej1-f46.google.com with SMTP id a640c23a62f3a-a6ef793f4b8so2743466b.1;
        Wed, 12 Jun 2024 08:41:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1718206898; x=1718811698; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:to:subject:user-agent:mime-version:date:message-id:from
         :to:cc:subject:date:message-id:reply-to;
        bh=gyD0R6gDJ7DEGGF9flSomxXkqPcJiga37nXnXFCL5mM=;
        b=KmLj2ID2GhzpfoLvCsqA1yXGqx2oYGX72+mBbnGc+MzQpBNQ7ghP7HXrBni+ppkUKB
         JV830lvOtFj2+Kzyyb+UCpvrxxiWyxphUl8BXcUdTZn5cCFybsQOA52Fc1pR/927UOc/
         bJU41QKeAhE8D6L+E7ydXuFcgbz0h/E5ERgn71JbKWFoHpbYasZLLOg9fMh8H6Pp719e
         f7fc+DQ4D5MSqZ82QHzegpmrN8yTkPsVxDwZnFs//303JuU4Y0tCxmp5MX00zCK0yKZE
         mPlH2xfpYuufC+kMLEkct+Pjg7vcXZFSjtD8Kb5dJb3+1iC2MR83COT8dQyry8YvPG3B
         JkAQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1718206898; x=1718811698;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=gyD0R6gDJ7DEGGF9flSomxXkqPcJiga37nXnXFCL5mM=;
        b=mty0zqiqqsMYSSeLTdK517PPUNYvLnvRxv7QzL0heIJh3kDI2rNX1kHs73gGVGXdkl
         rVvKq9DL+7bp0z2FygcIEEdJLFC+rb63GNjA5NcFFvak0KK1v1hbeX8qHsBfj74taN5p
         VjDc80t+kV2JPHoDGlAlhN+RDZK9cjRXte3tn1u0brXtPoZTqEEStZy4+yaFt6X3uVY+
         X5lPZ5H6tU0DI3AnqtOEcIPO+QmYlz3Cb/rCxV6a7nCFWk2GmG6nSg1uRlwdip6Wyw2A
         531wf+s6JvQmBVQ558bY1iM0cymZ5Qn6H+I05QMFo1xwJdQs0uep3bDbmZda+OvrMUng
         O1IQ==
X-Forwarded-Encrypted: i=1; AJvYcCVeK3ZOcoZCrPjyrQzUA/pko8Mzfu6HbbHgeCWtQXGFIm8U48IKD2LUSbHGVzsgQcL3msXJm9YnHOnZbAx7F4ndcNUnDksuNfZxwiuvo02Ytz/qri02oSZuJl+5j/qrtSrnnuYotHA=
X-Gm-Message-State: AOJu0YznGL07B7kxh+XhV2cvaZV6kyklVyGWruv49NtdD+mbFNG+oZ7/
	TBWVrxpIgXt11LkqpEf+iU6R1Xi/7L0iI1250cWAs94aIDU7MtPPKOkhRQ==
X-Google-Smtp-Source: AGHT+IGqdF7tzNtWlT+EXeEtt46p0gOgVGxehV1AEeY+4/fDUZyosPcBaz0rlWzTxrHU6mTj7xC22w==
X-Received: by 2002:a17:906:4c46:b0:a6f:102a:d40c with SMTP id a640c23a62f3a-a6f47d1e1eemr139128466b.8.1718206897728;
        Wed, 12 Jun 2024 08:41:37 -0700 (PDT)
Received: from [192.168.42.205] ([163.114.131.193])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-a6f0f3196c7sm553305266b.120.2024.06.12.08.41.37
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 12 Jun 2024 08:41:37 -0700 (PDT)
Message-ID: <24c12c7d-71fd-4ff8-b67b-20cdfb67bd86@gmail.com>
Date: Wed, 12 Jun 2024 16:41:45 +0100
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [io-uring] WARNING in io_issue_sqe
To: chase xd <sl1589472800@gmail.com>, Jens Axboe <axboe@kernel.dk>,
 io-uring@vger.kernel.org, linux-kernel@vger.kernel.org
References: <CADZouDR_Qz7dNVDsJyVSK8HfeSPpoO2ts=C-VbzhvHs3xE53AA@mail.gmail.com>
Content-Language: en-US
From: Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <CADZouDR_Qz7dNVDsJyVSK8HfeSPpoO2ts=C-VbzhvHs3xE53AA@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 6/12/24 15:29, chase xd wrote:
> Hi,
> 
> Syzkaller hits a new bug in branch 6.10.0-rc1-00004-gff802a9f35cf-dirty #7.
> Note: this is also not a reliable repro, might need to try more times

Do you have a syz repro? It's easier to understand what it's doing,
which request types are used and such.


> 
> ```
> 
> [  153.857557][T21250] apt-get (21250) used greatest stack depth:
> 22240 bytes left
> [  249.711259][T57846] ------------[ cut here ]------------
> [  249.711626][T57846] WARNING: CPU: 1 PID: 57846 at
> io_uring/refs.h:38 io_issue_sqe+0x10dc/0x1720
> [  249.712188][T57846] Modules linked in:
> [  249.712431][T57846] CPU: 1 PID: 57846 Comm: iou-wrk-57845 Not
> tainted 6.10.0-rc1-00004-gff802a9f35cf-dirty #7
> [  249.713020][T57846] Hardware name: QEMU Standard PC (i440FX + PIIX,
> 1996), BIOS 1.15.0-1 04/01/2014
> [  249.713566][T57846] RIP: 0010:io_issue_sqe+0x10dc/0x1720
> [  249.713894][T57846] Code: fc ff df 4c 89 e2 48 c1 ea 03 80 3c 02 00
> 0f 85 c6 05 00 00 49 89 1c 24 49f
> [  249.715023][T57846] RSP: 0018:ffffc9000e84fc00 EFLAGS: 00010293
> [  249.715389][T57846] RAX: 0000000000000000 RBX: 0000000000000000
> RCX: ffffffff84139c3c
> [  249.715855][T57846] RDX: ffff88801eaad640 RSI: ffffffff8413a70b
> RDI: 0000000000000007
> [  249.716300][T57846] RBP: ffffc9000e84fc80 R08: 0000000000000007
> R09: 0000000000000000
> [  249.716676][T57846] R10: 0000000000000000 R11: 0000000000000000
> R12: ffff8880001c3a00
> [  249.717042][T57846] R13: 0000000000000000 R14: ffff888010600040
> R15: ffff8880001c3a48
> [  249.717428][T57846] FS:  00007f58ce931800(0000)
> GS:ffff88807ec00000(0000) knlGS:0000000000000000
> [  249.717837][T57846] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> [  249.718135][T57846] CR2: 00007f58ce932128 CR3: 000000001b08a000
> CR4: 00000000000006f0
> [  249.718497][T57846] Call Trace:
> [  249.718668][T57846]  <TASK>
> [  249.718810][T57846]  ? __warn+0xc7/0x2f0
> [  249.719003][T57846]  ? io_issue_sqe+0x10dc/0x1720
> [  249.719233][T57846]  ? report_bug+0x347/0x410
> [  249.719451][T57846]  ? handle_bug+0x3d/0x80
> [  249.719654][T57846]  ? exc_invalid_op+0x18/0x50
> [  249.719872][T57846]  ? asm_exc_invalid_op+0x1a/0x20
> [  249.720127][T57846]  ? io_issue_sqe+0x60c/0x1720
> [  249.720420][T57846]  ? io_issue_sqe+0x10db/0x1720
> [  249.720711][T57846]  ? io_issue_sqe+0x10dc/0x1720
> [  249.721012][T57846]  ? __fget_files+0x1bc/0x3d0
> [  249.722194][T57846]  ? io_wq_submit_work+0x264/0xcb0
> [  249.722521][T57846]  io_wq_submit_work+0x264/0xcb0
> [  249.722826][T57846]  io_worker_handle_work+0x97e/0x1790
> [  249.723159][T57846]  io_wq_worker+0x38e/0xe50
> [  249.723435][T57846]  ? __pfx_io_wq_worker+0x10/0x10
> [  249.723687][T57846]  ? ret_from_fork+0x16/0x70
> [  249.723907][T57846]  ? __pfx_lock_release+0x10/0x10
> [  249.724139][T57846]  ? do_raw_spin_lock+0x12c/0x2b0
> [  249.724392][T57846]  ? __pfx_do_raw_spin_lock+0x10/0x10
> [  249.724706][T57846]  ? __pfx_io_wq_worker+0x10/0x10
> [  249.725015][T57846]  ret_from_fork+0x2f/0x70
> [  249.725300][T57846]  ? __pfx_io_wq_worker+0x10/0x10
> [  249.725603][T57846]  ret_from_fork_asm+0x1a/0x30
> [  249.725897][T57846]  </TASK>
> [  249.726083][T57846] Kernel panic - not syncing: kernel: panic_on_warn set ...
> [  249.726521][T57846] CPU: 1 PID: 57846 Comm: iou-wrk-57845 Not
> tainted 6.10.0-rc1-00004-gff802a9f35cf-dirty #7
> [  249.727110][T57846] Hardware name: QEMU Standard PC (i440FX + PIIX,
> 1996), BIOS 1.15.0-1 04/01/2014
> [  249.727647][T57846] Call Trace:
> [  249.727842][T57846]  <TASK>
> [  249.728018][T57846]  panic+0x4fa/0x5a0
> [  249.728252][T57846]  ? __pfx_panic+0x10/0x10
> [  249.728516][T57846]  ? show_trace_log_lvl+0x284/0x390
> [  249.728832][T57846]  ? io_issue_sqe+0x10dc/0x1720
> [  249.729120][T57846]  check_panic_on_warn+0x61/0x80
> [  249.729416][T57846]  __warn+0xd3/0x2f0
> [  249.729650][T57846]  ? io_issue_sqe+0x10dc/0x1720
> [  249.729941][T57846]  report_bug+0x347/0x410
> [  249.730206][T57846]  handle_bug+0x3d/0x80
> [  249.730460][T57846]  exc_invalid_op+0x18/0x50
> [  249.730730][T57846]  asm_exc_invalid_op+0x1a/0x20
> [  249.731031][T57846] RIP: 0010:io_issue_sqe+0x10dc/0x1720
> [  249.731365][T57846] Code: fc ff df 4c 89 e2 48 c1 ea 03 80 3c 02 00
> 0f 85 c6 05 00 00 49 89 1c 24 49f
> [  249.732508][T57846] RSP: 0018:ffffc9000e84fc00 EFLAGS: 00010293
> [  249.732873][T57846] RAX: 0000000000000000 RBX: 0000000000000000
> RCX: ffffffff84139c3c
> [  249.733351][T57846] RDX: ffff88801eaad640 RSI: ffffffff8413a70b
> RDI: 0000000000000007
> [  249.733822][T57846] RBP: ffffc9000e84fc80 R08: 0000000000000007
> R09: 0000000000000000
> [  249.734285][T57846] R10: 0000000000000000 R11: 0000000000000000
> R12: ffff8880001c3a00
> [  249.734757][T57846] R13: 0000000000000000 R14: ffff888010600040
> R15: ffff8880001c3a48
> [  249.735236][T57846]  ? io_issue_sqe+0x60c/0x1720
> [  249.735529][T57846]  ? io_issue_sqe+0x10db/0x1720
> [  249.735825][T57846]  ? __fget_files+0x1bc/0x3d0
> [  249.736116][T57846]  ? io_wq_submit_work+0x264/0xcb0
> [  249.736428][T57846]  io_wq_submit_work+0x264/0xcb0
> [  249.736731][T57846]  io_worker_handle_work+0x97e/0x1790
> [  249.737061][T57846]  io_wq_worker+0x38e/0xe50
> [  249.737353][T57846]  ? __pfx_io_wq_worker+0x10/0x10
> [  249.737646][T57846]  ? ret_from_fork+0x16/0x70
> [  249.737861][T57846]  ? __pfx_lock_release+0x10/0x10
> [  249.738091][T57846]  ? do_raw_spin_lock+0x12c/0x2b0
> [  249.738398][T57846]  ? __pfx_do_raw_spin_lock+0x10/0x10
> [  249.738729][T57846]  ? __pfx_io_wq_worker+0x10/0x10
> [  249.739033][T57846]  ret_from_fork+0x2f/0x70
> [  249.739308][T57846]  ? __pfx_io_wq_worker+0x10/0x10
> [  249.739617][T57846]  ret_from_fork_asm+0x1a/0x30
> [  249.739913][T57846]  </TASK>
> [  249.740236][T57846] Kernel Offset: disabled
> [  249.740518][T57846] Rebooting in 86400 seconds..
> 
> ```
> 
> crepro is in attachments.
> 
> Regards

-- 
Pavel Begunkov

