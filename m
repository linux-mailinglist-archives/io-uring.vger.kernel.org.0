Return-Path: <io-uring+bounces-5676-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id DBE85A019A5
	for <lists+io-uring@lfdr.de>; Sun,  5 Jan 2025 14:51:41 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id C9C441625EA
	for <lists+io-uring@lfdr.de>; Sun,  5 Jan 2025 13:51:39 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 901B51EA80;
	Sun,  5 Jan 2025 13:51:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="EoXJOVet"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ej1-f45.google.com (mail-ej1-f45.google.com [209.85.218.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BA6F3849C;
	Sun,  5 Jan 2025 13:51:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736085097; cv=none; b=PXO6Lsq1OMGrTlCWfKybqE+hvpBQcwt1T6EE4hXt94PDc8kX7c/hb8MShaJ5fqOnHJxpxiTPuvOwbLrZZvyo5qaHHNlMJruXpcrzuvWi1ewFWLmVXJCnKZdfJwycsQsfRlTcU3b79suXeBPTuw5SrcSnJqLMMRx5WNIltpENvNw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736085097; c=relaxed/simple;
	bh=i9P42Dosj1G2bxeAy60RZ48HxHacvLji6CnfZjS9MbI=;
	h=Message-ID:Date:MIME-Version:Subject:From:To:References:
	 In-Reply-To:Content-Type; b=U7htqkow+/cUktO+fdSPYER8wOJQ6iFfbVZ9Ku1relrT7s5yvD5NPi7nVTbJR9x3vh/BQtudK8xvWqQibemrIXn9hQzVA40N/LbuqpQ2N0l9Tt5Reom21vlqSFvAK7RfdVYODQuWXnpUklM+Pr2C1X6l2GLPo6PKVBRIL138PZg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=EoXJOVet; arc=none smtp.client-ip=209.85.218.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-ej1-f45.google.com with SMTP id a640c23a62f3a-aa6c0d1833eso2824644766b.1;
        Sun, 05 Jan 2025 05:51:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1736085094; x=1736689894; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:content-language:references
         :to:from:subject:user-agent:mime-version:date:message-id:from:to:cc
         :subject:date:message-id:reply-to;
        bh=h/Q73UfzbaIcmeWh9jKVJyQ3XNF+VainRugSJxsQ4oE=;
        b=EoXJOVetGejgM2ZG3c3SDFHBxAM1WZyWBOumn34At7byP08kdGT7X/vKD1u0d933gI
         01MN8fK2vvYS5n8o+YnPVviRmMapgejxkrab6sdJH5rEaUnhrKAFagu3ndPZs743EsPQ
         NaNrK3z0Fn5tS6tRUpyWveXS089OISUxg2nEktvAp8UfxemG0oeiD8EoZQYfhTaF99rW
         2Z29WDQ4fihbsaVx9hNdNvUMNRQKgaDLyoCL1BI06zeTSCwGbl/q+lr3cfDfEyC/jnbV
         3NCobpjpqD8ONK1lJ1bLHmucjoG0egHrHyXrnK44lcGipjllaX4xLZCbC2QD+8tWnSRn
         Scjw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1736085094; x=1736689894;
        h=content-transfer-encoding:in-reply-to:content-language:references
         :to:from:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=h/Q73UfzbaIcmeWh9jKVJyQ3XNF+VainRugSJxsQ4oE=;
        b=meawumq3QBeOiXo9wd5vEjzjES37fp/Da49I5bdbSvrPFcXQ6KoOyc05jJfpLhAE+1
         GLM7yD905GH4dh+Cx6vMYoob2121k798ahNZ5aGcC48T7XrkS46d8m09DFLk+5IMzlSe
         tMFrZdVmBG5VNM9/CORi5+wv3TL7Uuq2I3g3xIAT4tqBcDfP6SLii9GlJxahcG9Ifm1m
         w0mnigWhmhT1z5iB0vqQHOFoSKPUtswU9b1GBYW2lEa8QK4Xm06zPHzmh7TcWjzNBPdo
         GggAFNut6MUOywvrCQyBU16+2D2p2PIlAXLC+miwfU14ikN1kwIZ+tJ0FJL/KxJMcb8W
         10qg==
X-Forwarded-Encrypted: i=1; AJvYcCV5KgmjS4yoBgRn4WQZ0Cb4WpHftgjJVcL8aKfefj2jxvIXyeNGSRzGUzWyIliMtXY6bcwZvzIcDCoPk0SD@vger.kernel.org, AJvYcCW8FUSa9MZzgy6JepwIf8D8NqOZ2gljy/10fI0WKsiPDTBtUpAdUBQzfV6PQJ5K1xjJm7FXfYXEBw==@vger.kernel.org
X-Gm-Message-State: AOJu0YztR/s//Ec1SDABfWVltoYKL86mXhvm6OUDhnEbknM78ehF3v7s
	NSQlsyoAlCmgoAkXPHBnnHglj6GZYYi+P8WHGL7g110bCZY3HSL5
X-Gm-Gg: ASbGncv9pwn52+M0dPyU7g2gfp3gCOfpdo323UIY8GMiTQhRYgv81RL0t/Z8DxNK71l
	bIhyCkSB7ztB3nZhsvWLYsRLj6hEYv0GkFpNeuDjgfy1fBjcGNfE4N+nI2mIuVeojzrzFwIS4pQ
	tPT45Qa0H2ZC+pHGjg08PYW5VZHnI75Rxp/zMNQ2/PbO4dczCVNNDRGyOr5JPBdLjBRdEdkg8Qa
	/8hLWJ4JT9x8rY9nMUxonKCLK14stuFMZunYJ3rCijE/6wRY2pBpVU4N3SkqpzdYYya
X-Google-Smtp-Source: AGHT+IHvQ4kC7Uf6usvBDCeJVOW2BCJeKTUQWF2ZlkudeXgD7AiZy10a7QLVI4YsYF8YoyTDdr9aKA==
X-Received: by 2002:a17:906:ef09:b0:aa6:acd6:b30d with SMTP id a640c23a62f3a-aac3355fea1mr4551342266b.48.1736085093690;
        Sun, 05 Jan 2025 05:51:33 -0800 (PST)
Received: from ?IPV6:2620:10d:c096:325::46? ([2620:10d:c092:600::1:6814])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-aac0efe497dsm2131382166b.132.2025.01.05.05.51.33
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 05 Jan 2025 05:51:33 -0800 (PST)
Message-ID: <bb2cb6bd-d2ec-4378-bf9d-339571f7c53a@gmail.com>
Date: Sun, 5 Jan 2025 13:52:29 +0000
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [syzbot] [io-uring?] WARNING in __io_submit_flush_completions
From: Pavel Begunkov <asml.silence@gmail.com>
To: syzbot <syzbot+1bcb75613069ad4957fc@syzkaller.appspotmail.com>,
 axboe@kernel.dk, io-uring@vger.kernel.org, linux-kernel@vger.kernel.org,
 syzkaller-bugs@googlegroups.com
References: <6765b448.050a0220.15b956.00d4.GAE@google.com>
 <62983fd8-d5f6-470e-88e2-6f4737bfed79@gmail.com>
Content-Language: en-US
In-Reply-To: <62983fd8-d5f6-470e-88e2-6f4737bfed79@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

On 12/24/24 13:57, Pavel Begunkov wrote:
> On 12/20/24 18:15, syzbot wrote:
>>
>> HEAD commit:    8faabc041a00 Merge tag 'net-6.13-rc4' of git://git.kernel...
>> git tree:       upstream
>> console output: https://syzkaller.appspot.com/x/log.txt?x=13249e0f980000
>> kernel config:  https://syzkaller.appspot.com/x/.config?x=c22efbd20f8da769
>> dashboard link: https://syzkaller.appspot.com/bug?extid=1bcb75613069ad4957fc
>> compiler:       gcc (Debian 12.2.0-14) 12.2.0, GNU ld (GNU Binutils for Debian) 2.40
>> syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=12172fe8580000
>> C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=111f92df980000
>>
>> Downloadable assets:
>> disk image: https://storage.googleapis.com/syzbot-assets/0bdb6cecaf61/disk-8faabc04.raw.xz
>> vmlinux: https://storage.googleapis.com/syzbot-assets/98b22dfadac0/vmlinux-8faabc04.xz
>> kernel image: https://storage.googleapis.com/syzbot-assets/65a511d3ba7f/bzImage-8faabc04.xz
>>
>> IMPORTANT: if you fix the issue, please add the following tag to the commit:
>> Reported-by: syzbot+1bcb75613069ad4957fc@syzkaller.appspotmail.com
> 
> I can't reproduce but it makes sense. It shouldn't be a real
> problem as it's protected by ->uring_lock

#syz test: https://github.com/isilence/linux.git syz/get-cqe-lockdep

-- 
Pavel Begunkov


