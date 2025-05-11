Return-Path: <io-uring+bounces-7943-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id E8578AB282B
	for <lists+io-uring@lfdr.de>; Sun, 11 May 2025 14:21:54 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id C3F007AC379
	for <lists+io-uring@lfdr.de>; Sun, 11 May 2025 12:20:32 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 304ED256C98;
	Sun, 11 May 2025 12:21:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="R2z4YM89"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-wm1-f42.google.com (mail-wm1-f42.google.com [209.85.128.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4AB40256C9F;
	Sun, 11 May 2025 12:21:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746966090; cv=none; b=pu/0848VMmnSZnvEmH1aZ37kBOPYCz9LQ8qbtWyuL2DW4AhVYCJtwr2+Z/y8G1c0kbfJlGvBcQxXcQMDVzDFkCLYVU5FdbRDmnehhG5+0kj21VvavzVcXuqjsidGseqMvS4Yrj716faw9XxOnBaGMfpq+vsSctptQ9W/QAuvwIk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746966090; c=relaxed/simple;
	bh=WBXmCkUfQl4gFE8Jw6o2BOV5h++xUf3Ei2Jc3+sfA50=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=naslr1mM35SGjFmirDB4oMHbj3RtUtk/14a+A3NcxDXvxBLVRM1tPbuBL/WwIcLAdR2Uopd5GamwtHZe09IitAbtbx/2XfkVD/4LWyFumwHEMPhhqeYfXbo4n+/57n9M5cfxSoyfxjjtsSBW52hFl5fh2y1bxCYkwpVDwupc6o8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=R2z4YM89; arc=none smtp.client-ip=209.85.128.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-wm1-f42.google.com with SMTP id 5b1f17b1804b1-43d0c18e84eso16474675e9.3;
        Sun, 11 May 2025 05:21:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1746966086; x=1747570886; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:to:subject:user-agent:mime-version:date:message-id:from
         :to:cc:subject:date:message-id:reply-to;
        bh=BD1z8hpQvpsm9b7kTx7pDwYfhbYq4IAkdQzaMsoMhQE=;
        b=R2z4YM899F8jxMGXGsyBatjD9wwy85oAQraV+al3Bi0A+rWscbnjM5ItAFHKG/gJ4k
         iGeqb26Q969Cxc/bu4oTwG78dfZfLy5FvzQbOBCUTWyYd8g3iv6sXFY1AZTdTi2u0f1Y
         Fgj7mXnU4v0v3i4LHCoUh/ICo84ZqsKh1LbZQMqBtAkyd+MqRgE7i08PoyT16bP5wcAo
         jTGXAMq94LLxZ3mGn4MOWEepOToo3/cPMhf3T2tTOzAbkj8UsuulpEHs5HiTscb7JDmO
         algRSMax+q8qoYDo0xmTwHOrmH+bbRdDGnOB6UlpvK/W2nKq2atNRsmeddSRtn7twjbX
         XYYw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1746966086; x=1747570886;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=BD1z8hpQvpsm9b7kTx7pDwYfhbYq4IAkdQzaMsoMhQE=;
        b=QZ1j1nH8V519nFMC5C2YkdBlDeaxSV3UtJ9tWTkdPxJnseimBwvpWLWeaF7EO2nsIE
         /ntJOBDZmhilyBFm6ka4wolyk6m0F48zB7qPsVrCzYzcolOz2eJboEOmIrArdFaYwWhl
         R8c07lGkJ00DixDl+2Xg0HoPYQxZZUT2fMCSDcSQdVGJfAz9LXKKSO+52oqt7ZBwFtkI
         /bd0Gpz1FvuhPy3C1kOfEQhubiEhunMZOwh80BZ6cko18gP3wO0XJqJ8jwZ+PA+GYmd8
         uoehINcMP9rxJh8R93VtYQqqQuX+LvvgrdG24XIi7YrEvlGrKdHlX01kRc101lwvc62X
         0KYA==
X-Forwarded-Encrypted: i=1; AJvYcCWCcaBS5BfGRKq0DlELvx67LnaDxwt11/nfl1Ac4CrWv5ylzCpsOrQbQm6z/VEron+L6rqf/s95EQ==@vger.kernel.org, AJvYcCX9EHztwSfLTL2J61M+cpSAzrvG7Vj2YyVItovmoLoAfX+pLdYq1mtExE1AS3aRH+oA4WVJebRzPiG66qPt@vger.kernel.org
X-Gm-Message-State: AOJu0Yyck0lwvc5PRA3YufuntzEgsHUzxDLBjbPrwPextKT/gaiA1m/c
	WREiP5csJ2aTHQqERj01yPy6XXTmLMP/AtwsIoBkwoM3rPkqM2Ajojw4Yg==
X-Gm-Gg: ASbGnctIaxCoJ1uzkUiq1iuQkdwaLs72KhGGQR9qs+RPFJ6ZVXkQnCunStxKT+4drf4
	yh0elg+qx/simo4ap2F0x0Wp81IpZ3cv2BEfZpGEJAfBDQqtq0Kzg2qZCKP6gAsu52/Bf+DeUez
	0FEauvhnIAI4Yp2sTL032Pax+tRKqt1weF4sF6jA0rU4IYiG3uxK91lXZEWMRMj5C9DflbHxOvN
	6uXjW2tV6udbORJMId1HMGrWVX80OtkeoumDvyO8KZaPDOnv5FgEKJb0ynsuT5+jf+swcjdwLIs
	zVyDjmJ7TDIwa0trhmKc0QFRmiICq2PckU5Euy8eEgg2hzvabt665zF5QNxy8A==
X-Google-Smtp-Source: AGHT+IGauk905MhEon6onu9sM8lFD2S7ja98BXFPVTZIrIxCNz36RGWMPRLjQN/miqEZ/Oq75d7w7A==
X-Received: by 2002:a05:600c:a44:b0:440:68db:9fef with SMTP id 5b1f17b1804b1-442d6dc56a9mr68883335e9.20.1746966086178;
        Sun, 11 May 2025 05:21:26 -0700 (PDT)
Received: from [192.168.8.100] ([148.252.140.219])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3a1f58ebec4sm9280181f8f.36.2025.05.11.05.21.24
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 11 May 2025 05:21:25 -0700 (PDT)
Message-ID: <3460e09f-fafd-4d59-829a-341fa47d9652@gmail.com>
Date: Sun, 11 May 2025 13:22:35 +0100
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [syzbot] [io-uring?] BUG: unable to handle kernel NULL pointer
 dereference in io_buffer_select
To: syzbot <syzbot+6456a99dfdc2e78c4feb@syzkaller.appspotmail.com>,
 axboe@kernel.dk, io-uring@vger.kernel.org, linux-kernel@vger.kernel.org,
 syzkaller-bugs@googlegroups.com
References: <681fed0a.050a0220.f2294.001c.GAE@google.com>
Content-Language: en-US
From: Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <681fed0a.050a0220.f2294.001c.GAE@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 5/11/25 01:19, syzbot wrote:
> Hello,
> 
> syzbot found the following issue on:
> 
> HEAD commit:    0d8d44db295c Merge tag 'for-6.15-rc5-tag' of git://git.ker..
> git tree:       upstream
> console output: https://syzkaller.appspot.com/x/log.txt?x=12df282f980000
> kernel config:  https://syzkaller.appspot.com/x/.config?x=925afd2bdd38a581
> dashboard link: https://syzkaller.appspot.com/bug?extid=6456a99dfdc2e78c4feb
> compiler:       arm-linux-gnueabi-gcc (Debian 12.2.0-14) 12.2.0, GNU ld (GNU Binutils for Debian) 2.40
> userspace arch: arm
> syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=150338f4580000
> C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=143984f4580000
> 
> Downloadable assets:
> disk image (non-bootable): https://storage.googleapis.com/syzbot-assets/98a89b9f34e4/non_bootable_disk-0d8d44db.raw.xz
> vmlinux: https://storage.googleapis.com/syzbot-assets/f2af76a30640/vmlinux-0d8d44db.xz
> kernel image: https://storage.googleapis.com/syzbot-assets/a0bb41cd257b/zImage-0d8d44db.xz
> 
> IMPORTANT: if you fix the issue, please add the following tag to the commit:
> Reported-by: syzbot+6456a99dfdc2e78c4feb@syzkaller.appspotmail.com
> 
> Unable to handle kernel NULL pointer dereference at virtual address 0000000e when read
> [0000000e] *pgd=84797003, *pmd=df777003
> Internal error: Oops: 205 [#1] SMP ARM
> Modules linked in:
> CPU: 1 UID: 0 PID: 3105 Comm: syz-executor192 Not tainted 6.15.0-rc5-syzkaller #0 PREEMPT
> Hardware name: ARM-Versatile Express
> PC is at io_ring_buffer_select io_uring/kbuf.c:163 [inline]

this line:

tail = smp_load_acquire(&br->tail);

The offset of the tail field is 0xe so bl->buf_ring should be 0. That's
while it has IOBL_BUF_RING flag set. Same goes for the other report. Also,
since it's off io_buffer_select(), which looks up the list every time we
can exclude the req having a dangling pointer.

-- 
Pavel Begunkov


