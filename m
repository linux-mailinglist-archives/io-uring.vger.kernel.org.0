Return-Path: <io-uring+bounces-2525-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 33535935170
	for <lists+io-uring@lfdr.de>; Thu, 18 Jul 2024 20:03:04 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id E24D628481D
	for <lists+io-uring@lfdr.de>; Thu, 18 Jul 2024 18:03:02 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 65507145359;
	Thu, 18 Jul 2024 18:03:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="JBWS5WWd"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pl1-f173.google.com (mail-pl1-f173.google.com [209.85.214.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D4B134204B;
	Thu, 18 Jul 2024 18:02:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721325781; cv=none; b=jGnHTbXk4LQK7GxKeKqoPw85+Szs7eYz668BoM6hMEpXjXNtLG++KftmjTIQB/N6Ry31pKgOcU6NpMwPT9V5nyi2XvhjxalFHbC8jSx6Ny77KmDw9IFCxZiMC+/0nDR5zb31PTzp184jKny5YPBTIJ5qe63uussTyq3EPHeblmM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721325781; c=relaxed/simple;
	bh=+VJtPR6VOe9LvNX/UZXH5jvX7PIQxO/JWJxMuAPIcpM=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=iPXQ0HMDPw0/wBMl34t6uETaUgy1b3cmU6w3o5tsRoQxjuWCRMY9Sv098it+zhB+TLzZzU4DvbnzOMcuhuriuzsf26Mu+zrIsexWv3hMJEIrDPeDSu1XNOMv+yZYdXuQkgFhpv2XXjBE4WZPKqjv/UYhybuAGEhTTrbLaeicIeA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=JBWS5WWd; arc=none smtp.client-ip=209.85.214.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pl1-f173.google.com with SMTP id d9443c01a7336-1fc5296e214so9660265ad.0;
        Thu, 18 Jul 2024 11:02:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1721325779; x=1721930579; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:to:subject:user-agent:mime-version:date:message-id:from
         :to:cc:subject:date:message-id:reply-to;
        bh=AnzVYJeKKCpXlJ0KCWhZ40EvU8G8vZ7ZdJ8TzpSV98w=;
        b=JBWS5WWdL99JjSk+NxMmC5KuuqHV5qk37poFOCkCQYhn1DyU44jzhHO0wQtO1FJ+2F
         EMuQuQhhrfGz6wD5AO8j75H6K+wr3w/pHxmtjhQ7mZqKjPPh+yNsQmNwb6hcJYo7Zqod
         obPJBVnnHRbbOLdWP0t4jX5M8VP3wM5jz7Bik6eTJ7uwYhYdO2FZGlszEfvFL1boCw/h
         VdfXYsbXGaqBR4JhHsoca4XvBa5J7VFyV//NSITAYLumK+jDzSdoQixziqQnQJmipQ1a
         OV9jAKwzR3n0kJ2aEl7w7fHWDWWvXEwzoZ/KK+hGl7GmA9++xx1gK/7572eab0isDgdU
         1G3A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1721325779; x=1721930579;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=AnzVYJeKKCpXlJ0KCWhZ40EvU8G8vZ7ZdJ8TzpSV98w=;
        b=HhOMMLu3tHvJ3Lcdr1lqZe6DBLe4N0EEyvUHUjEQwPTpXOqScxaPUGkFe5QpZr7USZ
         SXvTxfWTraaTxwH5U10MPQv/Erdj/+grLiTFvoie6FDyWkskwc0yoKBwPnzBJF5o4tSp
         vRbqlh+3So5nAnYLE7QBdjEtwZ61nLHMwL9FK3ttHK1mUhPVUqiRFoqj9Ni6IsPQVxAe
         DN89x0D/WZrzZhsWDj0paCQWYMD/iQj5WQHDi2w471pxvOjogH0aEAiLpgsHhux9bJWN
         oKmaVP/GQE9XgOO0m9Bdtt8FMZ+yqXv0UR24Nm/YV0r0i/Y98brHAoZTbgekBvPFtVTf
         5Z3w==
X-Forwarded-Encrypted: i=1; AJvYcCUiIzdkp6peZBh0lKjCQCZIFs2oJuw3PBgdavwJDAqmpCAXPEJu+YGbIXIJm9M7FledLLuP6XKAzVYRPilDVfhz6DCFpmcvYZmgyMWoG5HccFtvw2FgoySFwKxrSJaNGcpEhDmvdSs=
X-Gm-Message-State: AOJu0YyV2ptii528KYs1H+8hT0B9slrLz3xxJs54QVxRFqpmMQUOf983
	NnTyh/S8QpucAJ/94W9cbCPGs8Vo9vYIcWPSMEAEgzMg06v4bRMNRq2/kOgv
X-Google-Smtp-Source: AGHT+IECyYfOyBPfBcg6Q8G+frkFbY9aSrwdTxez0CNOyr81jToZzGaNhYogwxY94Uv/OIdKeg61Aw==
X-Received: by 2002:a17:903:2308:b0:1fc:4a88:fe53 with SMTP id d9443c01a7336-1fc4e56bacamr49959585ad.51.1721325778981;
        Thu, 18 Jul 2024 11:02:58 -0700 (PDT)
Received: from [192.168.69.221] ([192.55.60.1])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-1fc0bc5372dsm95900445ad.295.2024.07.18.11.02.57
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 18 Jul 2024 11:02:58 -0700 (PDT)
Message-ID: <d848129a-ed5e-46f5-ac17-add37d7799fd@gmail.com>
Date: Thu, 18 Jul 2024 19:03:21 +0100
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [syzbot] [io-uring?] general protection fault in
 __io_remove_buffers
To: syzbot <syzbot+2074b1a3d447915c6f1c@syzkaller.appspotmail.com>,
 axboe@kernel.dk, io-uring@vger.kernel.org, linux-kernel@vger.kernel.org,
 syzkaller-bugs@googlegroups.com
References: <00000000000021e299061d7b6219@google.com>
Content-Language: en-US
From: Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <00000000000021e299061d7b6219@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 7/18/24 02:20, syzbot wrote:
> Hello,
> 
> syzbot found the following issue on:
> 
> HEAD commit:    d67978318827 Merge tag 'x86_cpu_for_v6.11_rc1' of git://gi..
> git tree:       upstream
> console+strace: https://syzkaller.appspot.com/x/log.txt?x=1178e9e9980000
> kernel config:  https://syzkaller.appspot.com/x/.config?x=e206d588252bd3ff
> dashboard link: https://syzkaller.appspot.com/bug?extid=2074b1a3d447915c6f1c
> compiler:       Debian clang version 15.0.6, GNU ld (GNU Binutils for Debian) 2.40
> syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=10e07d9e980000
> C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=16adf045980000
> 
> Downloadable assets:
> disk image: https://storage.googleapis.com/syzbot-assets/f34b31760156/disk-d6797831.raw.xz
> vmlinux: https://storage.googleapis.com/syzbot-assets/a92e51d8d32e/vmlinux-d6797831.xz
> kernel image: https://storage.googleapis.com/syzbot-assets/000a6a162550/bzImage-d6797831.xz
> 
> The issue was bisected to:
> 
> commit 87585b05757dc70545efb434669708d276125559
> Author: Jens Axboe <axboe@kernel.dk>
> Date:   Wed Mar 13 02:24:21 2024 +0000
> 
>      io_uring/kbuf: use vm_insert_pages() for mmap'ed pbuf ring
Easily reproducible, the diff helps

#syz test:


diff --git a/io_uring/kbuf.c b/io_uring/kbuf.c
index d2945c9c812b..c95dc1736dd9 100644
--- a/io_uring/kbuf.c
+++ b/io_uring/kbuf.c
@@ -657,8 +657,10 @@ static int io_alloc_pbuf_ring(struct io_ring_ctx *ctx,
  	ring_size = reg->ring_entries * sizeof(struct io_uring_buf_ring);
  
  	bl->buf_ring = io_pages_map(&bl->buf_pages, &bl->buf_nr_pages, ring_size);
-	if (!bl->buf_ring)
+	if (IS_ERR(bl->buf_ring)) {
+		bl->buf_ring = NULL;
  		return -ENOMEM;
+	}
  
  	bl->is_buf_ring = 1;
  	bl->is_mmap = 1;


