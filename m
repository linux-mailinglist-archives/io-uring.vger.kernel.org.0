Return-Path: <io-uring+bounces-12315-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id qOhnNG/olWlWWQIAu9opvQ
	(envelope-from <io-uring+bounces-12315-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Wed, 18 Feb 2026 17:27:27 +0100
X-Original-To: lists+io-uring@lfdr.de
Received: from sto.lore.kernel.org (sto.lore.kernel.org [IPv6:2600:3c09:e001:a7::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 625BE157BA1
	for <lists+io-uring@lfdr.de>; Wed, 18 Feb 2026 17:27:27 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sto.lore.kernel.org (Postfix) with ESMTP id 91F7A3004631
	for <lists+io-uring@lfdr.de>; Wed, 18 Feb 2026 16:27:26 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 215B3301460;
	Wed, 18 Feb 2026 16:27:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="mWx7YDNX"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-qt1-f196.google.com (mail-qt1-f196.google.com [209.85.160.196])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0AA06342146
	for <io-uring@vger.kernel.org>; Wed, 18 Feb 2026 16:27:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.196
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771432044; cv=none; b=WEc8jPPTm1KkOOcnu6G9BwxOLPz8DMMwBIBxxpp029QKpLsNIJZ2eKe+u/Gq1tmIvMt96W1c9JZQiE9ihO+i8SLXU9p7A3+a7QwOnFvtn/DQD/ugpw28P2P2fnwhcEiQppzPobZJ1ZtWpji0ymHhOeiO2s53buzfgvwosiCYFHA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771432044; c=relaxed/simple;
	bh=joh5coCooij1Yqr2bVarfKgIRqHnUtP/1IS5nosTv70=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=V85FoxsfvjIX4r0+nnxbTGpInET6xuAJrUEeq8yu0IFgSK4qrLxZzPsUVw0W7bEt7zDZftiwWwoXvYIPeIsDb1CBT6GqUmIonc9j9vtvBT41fZu5hidqLjmB7iSPujAtuO6xER1+ibaOOiYDYfhCEnbFt1AWacfVnwJEjIaSzPI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=mWx7YDNX; arc=none smtp.client-ip=209.85.160.196
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-qt1-f196.google.com with SMTP id d75a77b69052e-50336cffef9so47782401cf.0
        for <io-uring@vger.kernel.org>; Wed, 18 Feb 2026 08:27:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1771432041; x=1772036841; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:to:subject:user-agent:mime-version:date:message-id:from
         :to:cc:subject:date:message-id:reply-to;
        bh=ZnFVV/FtovaPMjTV/igK+BoCJgAXasHskCqPhS+jd4A=;
        b=mWx7YDNXOPuKIk35+kxzKfz1IGA12xHFGDRMuLzMRw9fy2qXl+p30+hx4Shyxb31SS
         oek9XPpEqKnu56DIwlfBC5t5ilWVEzpaNM1QiLcAGs0P6CVTFk0vlWT8rI1oljk9BjUz
         MTD2C+gSUoPFtKu/dsXCsYZ/LDG5hWXkzNHlNl3zQrgMRYbPWirxFhR6y+45ezcF/Zdr
         Nd/CUHDo6wCWAWM5QojqBRyRY1p6ZF4RdPRAzae/Xh1GJV+gp4W5oyrxXtg/DgFeE+8B
         6oCJDiEYg+GRbowJF3n+nnSZGt72M9J8hGcWxhaFLHbnaxFpEImAvo6fvoK/w6zgGW4d
         S6yw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1771432041; x=1772036841;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=ZnFVV/FtovaPMjTV/igK+BoCJgAXasHskCqPhS+jd4A=;
        b=qMjBMT6J1VdAtCenXcfVIRdI//q0rJsrJYMqHmQJ7fxcgR/vBOmAiSEbIpc3GU7RoL
         KcmjDVXhUJTHJSC7Yux7IG0rdZuoeFvPmJuo+Da3VjIbBCHsS/cCNTq2l/wIOeuz0c4F
         vQz9cJWTpMNngQF3+X7IdaE7BjVijV5qIZmcS4HkfVh2Z0L05gWd+Kbuqd/begMYqhBg
         nHpAfNf7EeG3Gu8XuwNU6EuNJro0W9xnQaqo+tY1bFx7Hm3PbGcyeNj6tKBtVTiD0DLs
         QGlhoG5O2QzdSr2DQLOv2axzv9Snw4r0RD7eej57FCwmqF28bxKkBHuy6EhIeERN/6kO
         sfxw==
X-Forwarded-Encrypted: i=1; AJvYcCVgN2epVIVPy2f4WZ08tZym4Gy9GU4FBnZfY3KcAJms2MJ8lQEVBHNzIfcNk++ibqzHGC0QbJjnhg==@vger.kernel.org
X-Gm-Message-State: AOJu0Yz8CMpaigq/+itSXCdE9ypcmm2XLSDbIhyTe0aSHeeWcttwsqvt
	lPH576NeebaG+L7+mYSzBSEdwGnAwtF5ea6UUMumfrY5mHda5ft1iqxL1pMYW4Jlvgc=
X-Gm-Gg: AZuq6aJfVxcHJ2i4OMhAPGrLTR5+R7dWOQ3e2+X2KWRHhY8jCy93akSuyTs30G/jg/R
	z1czhdAuQZelcfXmrBMdQzLvSTStKkYXC3GzQviuVWXS3hyN493PHgv7tQONSBHmUqfapqvxFM+
	T/JUKpXTrOxwtyXLCMXsAGRu57qEGxhN6wOXogoIDkw9MSlcSA+4kGozg14qGvsmMS4+L9xwvSf
	GUj4P7EzmiTFD1R4sMaPjIOx5iSS/+waugSQQpw4ZR8XO0/rRDjJYGUufRCQAsM8Zyr9cbaqLV+
	WBAk1c4VXn/W1GXeosNTTj3uWJJkIIGaIp61MwgQ/tlpDPAZxeVcn5C7JTbcgeHIBTsUrSXPqff
	fQ/1CKAgtMtXDaRAEkcCLtQraWUMEo285NCUHr6YNbAkKPi6H/BQymJUmzY75i7o4VgPOgK/N5K
	E0ujUnZ5HdO4N8gwtttYWKGchS0OLbr/xIHKa3xUlu5742RPsbZTWXfLPUkQ==
X-Received: by 2002:a05:622a:1188:b0:505:e7b8:5523 with SMTP id d75a77b69052e-506a67fd915mr236214961cf.8.1771432040755;
        Wed, 18 Feb 2026 08:27:20 -0800 (PST)
Received: from [172.19.0.48] ([99.196.128.5])
        by smtp.gmail.com with ESMTPSA id d75a77b69052e-506849fbb9dsm200067961cf.15.2026.02.18.08.27.13
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 18 Feb 2026 08:27:20 -0800 (PST)
Message-ID: <c71fc714-25b2-4c56-b48a-6d9da1d40d60@kernel.dk>
Date: Wed, 18 Feb 2026 09:27:07 -0700
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [syzbot] [io-uring?] WARNING in __secure_computing
To: syzbot <syzbot+0a4c46806941297fecb9@syzkaller.appspotmail.com>,
 io-uring@vger.kernel.org, kees@kernel.org, linux-kernel@vger.kernel.org,
 luto@amacapital.net, syzkaller-bugs@googlegroups.com, wad@chromium.org
References: <69953966.a70a0220.2c38d7.0111.GAE@google.com>
Content-Language: en-US
From: Jens Axboe <axboe@kernel.dk>
In-Reply-To: <69953966.a70a0220.2c38d7.0111.GAE@google.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [0.84 / 15.00];
	SUSPICIOUS_RECIPS(1.50)[];
	URI_HIDDEN_PATH(1.00)[https://syzkaller.appspot.com/x/.config?x=e2f061f80b102378];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c09:e001:a7::/64:c];
	R_DKIM_ALLOW(-0.20)[kernel-dk.20230601.gappssmtp.com:s=20230601];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	MIME_TRACE(0.00)[0:+];
	DMARC_NA(0.00)[kernel.dk];
	RCVD_TLS_LAST(0.00)[];
	TAGGED_FROM(0.00)[bounces-12315-lists,io-uring=lfdr.de];
	DKIM_TRACE(0.00)[kernel-dk.20230601.gappssmtp.com:+];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[kernel-dk.20230601.gappssmtp.com:dkim,kernel.dk:mid,storage.googleapis.com:url];
	TO_DN_SOME(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[axboe@kernel.dk,io-uring@vger.kernel.org];
	FROM_HAS_DN(0.00)[];
	ASN(0.00)[asn:63949, ipnet:2600:3c09::/32, country:SG];
	RCVD_COUNT_FIVE(0.00)[5];
	RCPT_COUNT_SEVEN(0.00)[7];
	MID_RHS_MATCH_FROM(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	TAGGED_RCPT(0.00)[io-uring,0a4c46806941297fecb9];
	SUBJECT_HAS_QUESTION(0.00)[]
X-Rspamd-Queue-Id: 625BE157BA1
X-Rspamd-Action: no action

On 2/17/26 9:00 PM, syzbot wrote:
> Hello,
> 
> syzbot found the following issue on:
> 
> HEAD commit:    2961f841b025 Merge tag 'turbostat-2026.02.14' of git://git..
> git tree:       upstream
> console output: https://syzkaller.appspot.com/x/log.txt?x=1721315a580000
> kernel config:  https://syzkaller.appspot.com/x/.config?x=e2f061f80b102378
> dashboard link: https://syzkaller.appspot.com/bug?extid=0a4c46806941297fecb9
> compiler:       gcc (Debian 14.2.0-19) 14.2.0, GNU ld (GNU Binutils for Debian) 2.44
> syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=142edb3a580000
> C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=13256722580000
> 
> Downloadable assets:
> disk image (non-bootable): https://storage.googleapis.com/syzbot-assets/d900f083ada3/non_bootable_disk-2961f841.raw.xz
> vmlinux: https://storage.googleapis.com/syzbot-assets/4f9939f81465/vmlinux-2961f841.xz
> kernel image: https://storage.googleapis.com/syzbot-assets/3f9babe832cd/bzImage-2961f841.xz
> 
> IMPORTANT: if you fix the issue, please add the following tag to the commit:
> Reported-by: syzbot+0a4c46806941297fecb9@syzkaller.appspotmail.com
> 
> ------------[ cut here ]------------
> 1
> WARNING: kernel/seccomp.c:1407 at __secure_computing+0x2ae/0x2e0 kernel/seccomp.c:1407, CPU#1: syz.0.17/6077
> Modules linked in:
> CPU: 1 UID: 0 PID: 6077 Comm: syz.0.17 Not tainted syzkaller #0 PREEMPT(full) 
> Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.3-debian-1.16.3-2 04/01/2014
> RIP: 0010:__secure_computing+0x2ae/0x2e0 kernel/seccomp.c:1407
> Code: 00 e8 96 52 fe ff e8 31 27 ff ff e8 fc 68 6b 00 bf 09 00 00 00 e8 82 f0 be ff e8 3d 79 6b 00 e9 06 fe ff ff e8 13 27 ff ff 90 <0f> 0b 90 e8 da 68 6b 00 bf 09 00 00 00 e8 60 f0 be ff e8 fb 26 ff
> RSP: 0018:ffffc9000413fed0 EFLAGS: 00010293
> RAX: 0000000000000000 RBX: ffffc9000413ff48 RCX: ffffffff82097151
> RDX: ffff888035c04900 RSI: ffffffff8209730d RDI: ffff888035c04900
> RBP: 0000000000000003 R08: 0000000000000005 R09: 0000000000000003
> R10: 0000000000000003 R11: 0000000000000000 R12: 00000000000001b4
> R13: 00000000000001b4 R14: ffff888035c04900 R15: 0000000000000001
> FS:  0000555575c2e500(0000) GS:ffff8880d644a000(0000) knlGS:0000000000000000
> CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> CR2: 00007f20e8a71fc0 CR3: 00000000373f5000 CR4: 0000000000352ef0
> Call Trace:
>  <TASK>
>  syscall_trace_enter include/linux/entry-common.h:112 [inline]
>  syscall_enter_from_user_mode_work include/linux/entry-common.h:156 [inline]
>  syscall_enter_from_user_mode include/linux/entry-common.h:187 [inline]
>  do_syscall_64+0x568/0xf80 arch/x86/entry/syscall_64.c:90
>  entry_SYSCALL_64_after_hwframe+0x77/0x7f
> RIP: 0033:0x7f20e8b9c629
> Code: ff c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 44 00 00 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 e8 ff ff ff f7 d8 64 89 01 48
> RSP: 002b:00007ffd25984108 EFLAGS: 00000246 ORIG_RAX: 00000000000001b4
> RAX: ffffffffffffffda RBX: 00007ffd259841f0 RCX: 00007f20e8b9c629
> RDX: 0000000000000000 RSI: 000000000000001e RDI: 0000000000000003
> RBP: 000000000000f6e1 R08: 0000000000000001 R09: 0000000000000000
> R10: 0000001b2d120000 R11: 0000000000000246 R12: 0000000000000000
> R13: 00007f20e8e15fac R14: 00007f20e8e15fa8 R15: 00007f20e8e15fa0
>  </TASK>

Not io_uring, no seccomp label that I can find...

#syz set subsystems: kernel

-- 
Jens Axboe


