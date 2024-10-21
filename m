Return-Path: <io-uring+bounces-3874-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id A0A339A91AD
	for <lists+io-uring@lfdr.de>; Mon, 21 Oct 2024 22:58:05 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id B6DD91C21B4E
	for <lists+io-uring@lfdr.de>; Mon, 21 Oct 2024 20:58:04 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 69EB71FBF62;
	Mon, 21 Oct 2024 20:57:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=davidwei-uk.20230601.gappssmtp.com header.i=@davidwei-uk.20230601.gappssmtp.com header.b="Purr9Gm1"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pf1-f175.google.com (mail-pf1-f175.google.com [209.85.210.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7A95A1FE115
	for <io-uring@vger.kernel.org>; Mon, 21 Oct 2024 20:57:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.175
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729544279; cv=none; b=Mrrfasv1jZA5YCLMw+brVDZmHNviLESPdBCm7Z2ouSVBRvQInaGYRi8sfY1Z0E/hgUCV/cJduTEIWwXF47wQOyGivQZ5B26fXqZ1UVjd32oW/QWtAXuFOITId69d4GrvWJK5TCeP+YHBiQD1aAQTC1UIxCWjSZztBZERn7Q05kk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729544279; c=relaxed/simple;
	bh=ThLg+9vOyrZx/mD5OTuHJUpP5SWdTSPefC9CAR75DLE=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Ut2p+BP+fLpWSR0vOncx4w4ouPQpi5Pt7z/5oMAuiz5SkX/z+vBl5nsqmkbQFjvy3W2o4lLGYriFw50RDIEM8OqLLciU1jMiCbR/VkZACwXeknFPktiPomBkG6k5fgk+SA4Y16lnfQJqnFcuQSsFM1nkMfM0tDgYK1HzdabluYw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=davidwei.uk; spf=none smtp.mailfrom=davidwei.uk; dkim=pass (2048-bit key) header.d=davidwei-uk.20230601.gappssmtp.com header.i=@davidwei-uk.20230601.gappssmtp.com header.b=Purr9Gm1; arc=none smtp.client-ip=209.85.210.175
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=davidwei.uk
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=davidwei.uk
Received: by mail-pf1-f175.google.com with SMTP id d2e1a72fcca58-71e49ad46b1so3390492b3a.1
        for <io-uring@vger.kernel.org>; Mon, 21 Oct 2024 13:57:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=davidwei-uk.20230601.gappssmtp.com; s=20230601; t=1729544276; x=1730149076; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=mGQ1s+Eq4/Dc0z1ZAtxUVtCh8uQ1A38HBjTEVAv1218=;
        b=Purr9Gm1W2vEdzE2vikSlgYvckriHvJMwvlGw+++4IQ+vVTh9vwbgue+bnrz21z0JV
         MCvGv3dzxbF2AyzjVLFcHauVT6ICFiqxHfbMnU/ymuK3YBVBrbAbjRgj2kyFWoJNmeDv
         G55aYiE46ZV1o0WLf3PDXgPkMNYHwmmo/MvVMssqYR4sa+NAbpuhVBA8eEPBKhheDi0M
         ug7RboDO06zl/AjtHw6dYPnkOOiEEGmAgRlpicjkUVOOa9RVJpahXSq5eojhJaGcGedQ
         IGRpgbJX5g+ILe1fW3EoAy1yfoylYJks05HtdIm9xIiMgykfX8Tlwn3s8JK7djxKngCp
         XLGQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1729544276; x=1730149076;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=mGQ1s+Eq4/Dc0z1ZAtxUVtCh8uQ1A38HBjTEVAv1218=;
        b=pAK/EhcAzb2eviMbGLkyXIbe9Q9xe5Ctd9XRF/js0h0seylwlOe+2oHWj4WGk+vGZZ
         SvX694QT01FyacfbcW5oLowudsNctbm13b7Uu0LhofR4T4j6MvwZ/gF3rDugaC+J5NfW
         Ut5yo8JZ6z07HFX5VwdIlQux0tu7H2E/l5TwfvZOiXVGkLj1lsU8xodDYrRYdQt5vjCR
         QWTqJR6RMOvrAr0lFyxB81IMB5HUAkjAwmE5V1ImMWe7ZPLPiG0IZxnxJehnsTIUvf+J
         NaC5Jpj4WIzIJ+rKE7zorQ8DqP2C/wC5VnqQxkPrPjeSbdURqUJsxqWRMfkAjBcG0ByB
         KI8w==
X-Forwarded-Encrypted: i=1; AJvYcCVvj2oe1pt70NOMTIJiInVXmwztOq9hUl72bz16CWySptd3lEPnRC8GPhQk/MMMgI1C0/Qg2yqfbQ==@vger.kernel.org
X-Gm-Message-State: AOJu0YxFE73lgJUL2WyGCSSsHf+hbq9PU/qf1Vyiq9rR8YSWcCwzeo9h
	2bqf5L98BVCeDZZ1eE6xZCXdSXZBex9Yjvei+t5phzWuNbK8tA9fNDBHnxo9AhA=
X-Google-Smtp-Source: AGHT+IEFmQW+r39kSD4Uh3ilMb2S2I5Sl/rk81LUqO73ImCgkCshYsril8dZWmGQCS3yfMAIcJzY1w==
X-Received: by 2002:a05:6a21:78d:b0:1d9:2b51:3ccd with SMTP id adf61e73a8af0-1d92c4a537emr17486946637.7.1729544275654;
        Mon, 21 Oct 2024 13:57:55 -0700 (PDT)
Received: from ?IPV6:2a03:83e0:1256:1:80c:c984:f4f1:951f? ([2620:10d:c090:500::6:d291])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-7eb0670f979sm175227a12.37.2024.10.21.13.57.54
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 21 Oct 2024 13:57:55 -0700 (PDT)
Message-ID: <11032431-e58b-4f75-a8b5-cf978ffbfa50@davidwei.uk>
Date: Mon, 21 Oct 2024 13:57:52 -0700
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH RFC v4 00/15] fuse: fuse-over-io-uring
Content-Language: en-GB
To: Bernd Schubert <bernd.schubert@fastmail.fm>,
 Miklos Szeredi <miklos@szeredi.hu>
Cc: Jens Axboe <axboe@kernel.dk>, Pavel Begunkov <asml.silence@gmail.com>,
 linux-fsdevel@vger.kernel.org, io-uring@vger.kernel.org,
 Joanne Koong <joannelkoong@gmail.com>, Amir Goldstein <amir73il@gmail.com>,
 Ming Lei <tom.leiming@gmail.com>, Josef Bacik <josef@toxicpanda.com>
References: <20241016-fuse-uring-for-6-10-rfc4-v4-0-9739c753666e@ddn.com>
 <38c76d27-1657-4f8c-9875-43839c8bbe80@davidwei.uk>
 <ed03c267-92c1-4431-85b2-d58fd45807be@fastmail.fm>
From: David Wei <dw@davidwei.uk>
In-Reply-To: <ed03c267-92c1-4431-85b2-d58fd45807be@fastmail.fm>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 2024-10-21 04:47, Bernd Schubert wrote:
> Hi David,
> 
> On 10/21/24 06:06, David Wei wrote:
>> [You don't often get email from dw@davidwei.uk. Learn why this is important at https://aka.ms/LearnAboutSenderIdentification ]
>>
>> On 2024-10-15 17:05, Bernd Schubert wrote:
>> [...]
>>>
> 
> ...
> 
>> Hi Bernd, I applied this patchset to io_uring-6.12 branch with some
>> minor conflicts. I'm running the following command:
>>
>> $ sudo ./build/example/passthrough_hp -o allow_other --debug-fuse --nopassthrough \
>> --uring --uring-per-core-queue --uring-fg-depth=1 --uring-bg-depth=1 \
>> /home/vmuser/scratch/source /home/vmuser/scratch/dest
>> FUSE library version: 3.17.0
>> Creating ring per-core-queue=1 sync-depth=1 async-depth=1 arglen=1052672
>> dev unique: 2, opcode: INIT (26), nodeid: 0, insize: 104, pid: 0
>> INIT: 7.40
>> flags=0x73fffffb
>> max_readahead=0x00020000
>>     INIT: 7.40
>>     flags=0x4041f429
>>     max_readahead=0x00020000
>>     max_write=0x00100000
>>     max_background=0
>>     congestion_threshold=0
>>     time_gran=1
>>     unique: 2, success, outsize: 80
>>
>> I created the source and dest folders which are both empty.
>>
>> I see the following in dmesg:
>>
>> [ 2453.197510] uring is disabled
>> [ 2453.198525] uring is disabled
>> [ 2453.198749] uring is disabled
>> ...
>>
>> If I then try to list the directory /home/vmuser/scratch:
>>
>> $ ls -l /home/vmuser/scratch
>> ls: cannot access 'dest': Software caused connection abort
>>
>> And passthrough_hp terminates.
>>
>> My kconfig:
>>
>> CONFIG_FUSE_FS=m
>> CONFIG_FUSE_PASSTHROUGH=y
>> CONFIG_FUSE_IO_URING=y
>>
>> I'll look into it next week but, do you see anything obviously wrong?
> 
> 
> thanks for testing it! I just pushed a fix to my libfuse branches to
> avoid the abort for -EOPNOTSUPP. It will gracefully fall back to
> /dev/fuse IO now.
> 
> Could you please use the rfcv4 branch, as the plain uring
> branch will soon get incompatible updates for rfc5?
> 
> https://github.com/bsbernd/libfuse/tree/uring-for-rfcv4
> 
> 
> The short answer to let you enable fuse-io-uring:
> 
> echo 1 >/sys/module/fuse/parameters/enable_uring
> 
> 
> (With that the "uring is disabled" should be fixed.)

Thanks, using this branch fixed the issue and now I can see the dest
folder mirroring that of the source folder. There are two issues I
noticed:

[63490.068211] ---[ end trace 0000000000000000 ]---
[64010.242963] BUG: sleeping function called from invalid context at include/linux/sched/mm.h:330
[64010.243531] in_atomic(): 1, irqs_disabled(): 0, non_block: 0, pid: 11057, name: fuse-ring-1
[64010.244092] preempt_count: 1, expected: 0
[64010.244346] RCU nest depth: 0, expected: 0
[64010.244599] 2 locks held by fuse-ring-1/11057:
[64010.244886]  #0: ffff888105db20a8 (&ctx->uring_lock){+.+.}-{3:3}, at: __do_sys_io_uring_enter+0x900/0xd80
[64010.245476]  #1: ffff88810f941818 (&fc->lock){+.+.}-{2:2}, at: fuse_uring_cmd+0x83e/0x1890 [fuse]
[64010.246031] CPU: 1 UID: 0 PID: 11057 Comm: fuse-ring-1 Tainted: G        W          6.11.0-10089-g0d2090ccdbbe #2
[64010.246655] Tainted: [W]=WARN
[64010.246853] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS rel-1.16.0-0-gd239552ce722-prebuilt.qemu.org 04/01/2014
[64010.247542] Call Trace:
[64010.247705]  <TASK>
[64010.247860]  dump_stack_lvl+0xb0/0xd0
[64010.248090]  __might_resched+0x2f8/0x510
[64010.248338]  __kmalloc_cache_noprof+0x2aa/0x390
[64010.248614]  ? lockdep_init_map_type+0x2cb/0x7b0
[64010.248923]  ? fuse_uring_cmd+0xcc2/0x1890 [fuse]
[64010.249215]  fuse_uring_cmd+0xcc2/0x1890 [fuse]
[64010.249506]  io_uring_cmd+0x214/0x500
[64010.249745]  io_issue_sqe+0x588/0x1810
[64010.249999]  ? __pfx_io_issue_sqe+0x10/0x10
[64010.250254]  ? io_alloc_async_data+0x88/0x120
[64010.250516]  ? io_alloc_async_data+0x88/0x120
[64010.250811]  ? io_uring_cmd_prep+0x2eb/0x9f0
[64010.251103]  io_submit_sqes+0x796/0x1f80
[64010.251387]  __do_sys_io_uring_enter+0x90a/0xd80
[64010.251696]  ? do_user_addr_fault+0x26f/0xb60
[64010.251991]  ? __pfx___do_sys_io_uring_enter+0x10/0x10
[64010.252333]  ? __up_read+0x3ba/0x750
[64010.252565]  ? __pfx___up_read+0x10/0x10
[64010.252868]  do_syscall_64+0x68/0x140
[64010.253121]  entry_SYSCALL_64_after_hwframe+0x76/0x7e
[64010.253444] RIP: 0033:0x7f03a03fb7af
[64010.253679] Code: 45 0f b6 90 d0 00 00 00 41 8b b8 cc 00 00 00 45 31 c0 41 b9 08 00 00 00 41 83 e2 01 41 c1 e2 04 41 09 c2 b8 aa 01 00 00 0f 05 <c3> a8 02 74 cc f0 48 83 0c 24 00 49 8b 40 20 8b 00 a8 01 74 bc b8
[64010.254801] RSP: 002b:00007f039f3ffd08 EFLAGS: 00000246 ORIG_RAX: 00000000000001aa
[64010.255261] RAX: ffffffffffffffda RBX: 0000561ab7c1ced0 RCX: 00007f03a03fb7af
[64010.255695] RDX: 0000000000000000 RSI: 0000000000000002 RDI: 0000000000000009
[64010.256127] RBP: 0000000000000002 R08: 0000000000000000 R09: 0000000000000008
[64010.256556] R10: 0000000000000000 R11: 0000000000000246 R12: 0000561ab7c1d7a8
[64010.256990] R13: 0000561ab7c1da00 R14: 0000561ab7c1d520 R15: 0000000000000001
[64010.257442]  </TASK>

If I am already in dest when I do the mount using passthrough_hp and
then e.g. ls, it hangs indefinitely even if I kill passthrough_hp.

