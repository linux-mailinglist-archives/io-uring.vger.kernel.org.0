Return-Path: <io-uring+bounces-6789-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id DD93FA462AF
	for <lists+io-uring@lfdr.de>; Wed, 26 Feb 2025 15:27:47 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 75B6017CC13
	for <lists+io-uring@lfdr.de>; Wed, 26 Feb 2025 14:25:59 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DBF7722A7E5;
	Wed, 26 Feb 2025 14:23:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="2WXZHeDm"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-io1-f49.google.com (mail-io1-f49.google.com [209.85.166.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2EA8022A1C5
	for <io-uring@vger.kernel.org>; Wed, 26 Feb 2025 14:23:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740579819; cv=none; b=hsIUPvNF0OHSx7LZBGxOS0FWJqz/z400NcC7QfYfYkd7PIXwwVdwx2RrBhRR9/sDJrqtWOwTILueeQ2mdaC//94beqKXM6aP1tafBf9p39za57dkBJRMDrB8AR7SyXXdLyPAofWpEUPlQ+YqC3ggEqVDlIfFPrR6Qi1e1q7mOKI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740579819; c=relaxed/simple;
	bh=oESKRxk7S/SAj+JzXbT8tJchADNljAklyGCeLl3hM0Y=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=FS/mpRXvrULDYC0imBtRNkA6tp8mz/Df2tWWI29TTxKwerJEushGPN1BFbzryHG3X5zdB8hi2vMr4hzYLOhc75Pn+8CIhCmpV6Gb7ymXEI7kw+AUsKJ3S34ncRIs/QTXDddMveN0qroDmzxMhgNEJKNmUmn+e607L6whdSqsstE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=2WXZHeDm; arc=none smtp.client-ip=209.85.166.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-io1-f49.google.com with SMTP id ca18e2360f4ac-855183fdcafso28286039f.1
        for <io-uring@vger.kernel.org>; Wed, 26 Feb 2025 06:23:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1740579816; x=1741184616; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:to:subject:user-agent:mime-version:date:message-id:from
         :to:cc:subject:date:message-id:reply-to;
        bh=+lLnbkzYFUFW6XfzIit24LipM1R/Z0yOhTI6EbT/o+g=;
        b=2WXZHeDmVrlHnboRPAA9QI6Smp2eBDLYOufLBWyiEGt/MskC000iqzPD1tYdiALD/+
         Ase5Yzyqgf8SufII8dn+EKz1cFfLZvi8a4Nadk41upoU3ZJ3VDRt6jzncraK80YivA3d
         KaRn9pfKU+vEiRXoBd1aJdU6eoupR7clRvjXfZof7YcbXripeLns0jgqP612AwDb3MzS
         4eETYPUgDt7h/FRgKXCzMOUTzZdT3yiuypjHM8y06WlbZaXhWjFn0P0McfN+r+W1MmJV
         uCEd0NfFHHErNflGjMZX+FPD7sWYVERgQibR8vIXPY+UnXUcKudUVB1qlhXyC7q8ittr
         jRMQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1740579816; x=1741184616;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=+lLnbkzYFUFW6XfzIit24LipM1R/Z0yOhTI6EbT/o+g=;
        b=aYDebCKS4/4A8j9kgaWEGcziWe8ISOqd1Y6vgJoOxYw4eYpOWyyLbWvhk/3IRnnyGx
         YJgPiMq3+OPjloL/vUxhdVAsT/pR68q3tgURZt3bB5iyXr0bQ8HRD40WoHUVrAIpHTJl
         5Nd33S/4xJ9dG6Zm7dt9HEZL4JqBIkij48sA+8DXtz4NRepMt46TVQYSm5Msoz260JYH
         uvft49fnGccORMiviL+dQ9WWq5M/SV12nDbXLYePEEhLJphudY/UGIDU6RICrLZCIUOJ
         +xl9S9yrdHyaG8LiKLiIzkbwa8StCyIaj81AKw6aE7w9uoV+DjqJFU4PurtExua1Tdl4
         kZHw==
X-Forwarded-Encrypted: i=1; AJvYcCVKEuIqDQcvfCBJSPxfoyd2F1WTU+ZoqnZ0Qasf2nUCvEAysyHkfO98o+6XOijA+/ceJFAWLUAgyw==@vger.kernel.org
X-Gm-Message-State: AOJu0YyxuIiY/NdjoxsxB/Qz1+WAXZayf7ygZ3TjdJtRvD9D9uAuQTRR
	WnVbA8WD0Wk+0PbBCbWdCf9wxc17/p0W+1GdzHSwbkbByWErNdPC3OdtrbK0Ako=
X-Gm-Gg: ASbGncvw+PF2dOaD/GSrRH1JFA0K8b5aD3HDwn5PN62sl4jmiR1JFOCRUjEDXB8eq4g
	gsIudvV54hkhxj7xc8CuEPF8WQWUsDB/uKVgghZCEzndGjtyTvyM+OvHnrhNswJAimXCjJMVcUE
	sBwkOBzQHb15AXbDjTalueUkGIFl/81RksPGEJUFKf0SlOtaKD/8MQGDsGB9630PWrBH6yqaJbl
	UuFe2z50gfLFJZxkvTi/a0Rno/1LA16T6314nFDYiPd9ZXgt2pO8WDujcGgAP8kqjQ41Uh00EQH
	Jy2h2j08wilHbbgR8SkZ8w==
X-Google-Smtp-Source: AGHT+IHCTcB7uZZBwrrVwoyg1sY7x7wAOYntHYhSFAGNdVEQ0bIslcm3vAPpwn7DmMLgCW3Yu+nGVw==
X-Received: by 2002:a05:6e02:1686:b0:3cf:fd62:e39c with SMTP id e9e14a558f8ab-3d2cacde097mr187503355ab.5.1740579815860;
        Wed, 26 Feb 2025 06:23:35 -0800 (PST)
Received: from [192.168.1.116] ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id e9e14a558f8ab-3d36165339esm8144515ab.19.2025.02.26.06.23.34
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 26 Feb 2025 06:23:35 -0800 (PST)
Message-ID: <aace30fd-6cdc-4608-8ca8-0cef74dd1c66@kernel.dk>
Date: Wed, 26 Feb 2025 07:23:34 -0700
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [syzbot] [io-uring?] general protection fault in
 native_tss_update_io_bitmap
To: syzbot <syzbot+e2b1803445d236442e54@syzkaller.appspotmail.com>,
 asml.silence@gmail.com, bp@alien8.de, dave.hansen@linux.intel.com,
 hpa@zytor.com, io-uring@vger.kernel.org, linux-kernel@vger.kernel.org,
 mingo@redhat.com, syzkaller-bugs@googlegroups.com, tglx@linutronix.de,
 x86@kernel.org
References: <67bead04.050a0220.38b081.0002.GAE@google.com>
Content-Language: en-US
From: Jens Axboe <axboe@kernel.dk>
In-Reply-To: <67bead04.050a0220.38b081.0002.GAE@google.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 2/25/25 10:56 PM, syzbot wrote:
> Hello,
> 
> syzbot found the following issue on:
> 
> HEAD commit:    e5d3fd687aac Add linux-next specific files for 20250218
> git tree:       linux-next
> console output: https://syzkaller.appspot.com/x/log.txt?x=13fcd7f8580000
> kernel config:  https://syzkaller.appspot.com/x/.config?x=4e945b2fe8e5992f
> dashboard link: https://syzkaller.appspot.com/bug?extid=e2b1803445d236442e54
> compiler:       Debian clang version 15.0.6, GNU ld (GNU Binutils for Debian) 2.40
> syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=149427a4580000
> C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=11ed06e4580000
> 
> Downloadable assets:
> disk image: https://storage.googleapis.com/syzbot-assets/ef079ccd2725/disk-e5d3fd68.raw.xz
> vmlinux: https://storage.googleapis.com/syzbot-assets/99f2123d6831/vmlinux-e5d3fd68.xz
> kernel image: https://storage.googleapis.com/syzbot-assets/eadfc9520358/bzImage-e5d3fd68.xz
> 
> IMPORTANT: if you fix the issue, please add the following tag to the commit:
> Reported-by: syzbot+e2b1803445d236442e54@syzkaller.appspotmail.com
> 
> Oops: general protection fault, probably for non-canonical address 0xdffffc0000000000: 0000 [#1] PREEMPT SMP KASAN PTI
> KASAN: null-ptr-deref in range [0x0000000000000000-0x0000000000000007]
> CPU: 1 UID: 0 PID: 5891 Comm: iou-sqp-5889 Not tainted 6.14.0-rc3-next-20250218-syzkaller #0
> Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 02/12/2025
> RIP: 0010:native_tss_update_io_bitmap+0x1f5/0x640 arch/x86/kernel/process.c:471

This doesn't look io_uring related at all, it looks more like something missing
for error injection and early failure handling in the fork path for the x86 io
bitmap handling. Possibly related to PF_IO_WORKER, didn't poke deep enough to
see if it's specific to that or not. Presumably a change slated for 6.15? It's
testing an older linux-next, so also quite possible that this is known and
already fixed, it's a week old.

#syz set subsystems: kernel

-- 
Jens Axboe


