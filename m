Return-Path: <io-uring+bounces-4047-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 3ACC19B1880
	for <lists+io-uring@lfdr.de>; Sat, 26 Oct 2024 15:44:14 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id CB7BA1C2145A
	for <lists+io-uring@lfdr.de>; Sat, 26 Oct 2024 13:44:11 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DE3AAC139;
	Sat, 26 Oct 2024 13:44:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="fhlSL7ci"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pf1-f177.google.com (mail-pf1-f177.google.com [209.85.210.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4832379FD
	for <io-uring@vger.kernel.org>; Sat, 26 Oct 2024 13:44:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.177
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729950247; cv=none; b=Fsa62gQacOykc8ckMJtc+HpLw5A4y5Rn9p5gwQULl6yQ+e+QhaS5TBANdeJACYgfHXC5xBCoQ+EwgPNQCFf/6d8LXRkhUnIiPKIP/9AB6BUXDOB1KGPqWt1DP3zICy1d00qPkSB/mOOQ9gJxKpkdxjKKiQ1V8PgN9ZiQ5ri6O2U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729950247; c=relaxed/simple;
	bh=CIYYwFXhiX6rWqA/iZoE8OuumaP7jLDK2RrQdiPIf9E=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=TmkH6nTa4CvKug2Q17Pzj8teiQkoqkKXb1fOivm1MjEVc7pa+ZIUGjX53v6lcVHm4AjIln44ii1RB0jccmi2J5m94N58d6fzOBwgoCnlP+Of80z3mEzmsNQcS6FXOo1CVnXAbQIGLGTRsuzBZftzACcKUcKuYhpSZgEw950Tlx0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=fhlSL7ci; arc=none smtp.client-ip=209.85.210.177
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-pf1-f177.google.com with SMTP id d2e1a72fcca58-71e4c2e36daso2741558b3a.0
        for <io-uring@vger.kernel.org>; Sat, 26 Oct 2024 06:44:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1729950243; x=1730555043; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:to:subject:user-agent:mime-version:date:message-id:from
         :to:cc:subject:date:message-id:reply-to;
        bh=SYL3sDrivDG+u/WdvsApqr6CIyeeBUY6DA7C24ZdxlA=;
        b=fhlSL7ci5cwadzUwSOdYjMzZg0K/l+zZsa3LVUIoYFp9AbrnLxr0pqtkRHxUjq1UyD
         o73hUlNQ2teJkGljtfJBmOhXOOuBqhgxCJIcdON0J/7lYLakhgvPaC+tWItxGKIL0/DM
         WJmc9TwR1plvpSfDS4+GLBQ7ScbUblkTqsHDdKn7sZ3KPsJFNp/H1VGcgctibPAE21Sr
         L5tHaxAKFZRzmzBYX3aPapHzcxtpkjqYPnnPQseWXmwr+0RE3SnPzIwWyMd7+zXTkG5s
         e5lrEU8Hdi5CP0uUwE9HpGMvFI5mj+ZWyziA/2Ttb60AIawZEAHCkoG7cGC0EnUgAdZq
         l8Rg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1729950243; x=1730555043;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=SYL3sDrivDG+u/WdvsApqr6CIyeeBUY6DA7C24ZdxlA=;
        b=p6RVDZEJvNalOnoEbgaLUTQJtlXnOo14s4gPLPWB7iZQKDDkFmuVNFcrX2ws+h18ao
         mfnu13447TdQ9lKnyuEsN/EGPBnwOWJfHNj260MytLXgTIG8x52p5lHfiERe1gvgrvQ1
         uaYISpNIluzlQWxZYkU2YOAYnL5TBl7MekypEupEeS6gDGsV26G2RBRtWVGNXvbazkxJ
         dbDBhQ36p5rIy30K02NiGefTk04bTomWx4nRqD7xQzf1JM/Wnu/U7dXSuyBQEDhtbDfo
         msHW4OYqyQdLXMPGddNc6RwUxA7l4x8ChaJUmxv0T7LgaFr+Kc9Ve95t+6wjlTcxcVKp
         l41Q==
X-Forwarded-Encrypted: i=1; AJvYcCWtNUGHmirSxE8b5+wHx0R1qoaZpuU23XmyxMeaWWRbMD5jpYmeZTc9YzerMdgjhLUdkN++A75CDg==@vger.kernel.org
X-Gm-Message-State: AOJu0Ywx9VIhxf7RZZYvkt5fPU7mbXyiv8jmN5HHjGrc7bTdYpKehjdX
	03FN0bnaXbUMoblcCFQdOOqWD1n/1YgJlKbdwUqYm/0PmxePdNiSMqq0jFkfdhQ=
X-Google-Smtp-Source: AGHT+IFKhFUO3L8EA1Un6AOdVbpwGyP3t+q6ofgDmxfN7EcxjRd6ZL/PZHDe1NV/eNoeIlogLxBp4w==
X-Received: by 2002:aa7:88d6:0:b0:71e:7f08:492c with SMTP id d2e1a72fcca58-72062f20a50mr4594789b3a.1.1729950243554;
        Sat, 26 Oct 2024 06:44:03 -0700 (PDT)
Received: from [192.168.1.150] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-72057a0b926sm2726060b3a.129.2024.10.26.06.44.02
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 26 Oct 2024 06:44:02 -0700 (PDT)
Message-ID: <5ed947b0-5762-4631-8633-b737bc09eebf@kernel.dk>
Date: Sat, 26 Oct 2024 07:44:01 -0600
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [syzbot] [io-uring?] INFO: task hung in io_wq_put_and_exit (4)
To: syzbot <syzbot+58928048fd1416f1457c@syzkaller.appspotmail.com>,
 asml.silence@gmail.com, io-uring@vger.kernel.org,
 linux-kernel@vger.kernel.org, syzkaller-bugs@googlegroups.com
References: <671c817d.050a0220.2b8c0f.01ad.GAE@google.com>
Content-Language: en-US
From: Jens Axboe <axboe@kernel.dk>
In-Reply-To: <671c817d.050a0220.2b8c0f.01ad.GAE@google.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 10/25/24 11:43 PM, syzbot wrote:
> syzbot has found a reproducer for the following issue on:
> 
> HEAD commit:    b423f5a9a61f Merge tag 'acpi-6.12-rc5' of git://git.kernel..
> git tree:       upstream
> console+strace: https://syzkaller.appspot.com/x/log.txt?x=1393565f980000
> kernel config:  https://syzkaller.appspot.com/x/.config?x=fd919c0fc1af4272
> dashboard link: https://syzkaller.appspot.com/bug?extid=58928048fd1416f1457c
> compiler:       Debian clang version 15.0.6, GNU ld (GNU Binutils for Debian) 2.40
> syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=122f04a7980000
> C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=132cbe40580000

Perfect thanks, we'll take a look.

-- 
Jens Axboe


