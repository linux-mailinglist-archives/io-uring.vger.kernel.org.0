Return-Path: <io-uring+bounces-7951-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 8CED6AB39CB
	for <lists+io-uring@lfdr.de>; Mon, 12 May 2025 15:57:06 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 20F3D179AE7
	for <lists+io-uring@lfdr.de>; Mon, 12 May 2025 13:57:00 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B91EA1DDA1E;
	Mon, 12 May 2025 13:56:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="1xgdP8wW"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-il1-f171.google.com (mail-il1-f171.google.com [209.85.166.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 095471DDA15
	for <io-uring@vger.kernel.org>; Mon, 12 May 2025 13:56:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747058205; cv=none; b=pNtyoiZ0AO99tKdXSBvXE5MAb5q8g4RxGpIfxSDq9Nfcn+xztvCnV1nvpaDhcKOsr0G1Se6QhhDNxOAaNLdUGzfe5nHUxrKe/JoaJU9QY4camkM+Cg871jxfVHGzJHL2g1FLdwaZO2HgZP4Oyc4mndiR6asgS+GRNgTkiN6d3Ek=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747058205; c=relaxed/simple;
	bh=8ZOqN3eYtKHxzprFnJH92OIlNFxqbm4cFNOdZF3juJI=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=gDCs8omI1DR41qfzbLWpfBmWGMBBkmezGpkfQ8qpRNerBk6gmstoACVBJzf3nEpCGqBq9uE+60hVbn+J/VVTLSQtjJeSPeBJywFayjE4nS4s51J1XXZkJp+iraQW/P9nw98MVSW1wdgEenXjUW8bzgr30XCP2ngXq05hp0BsFQE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=1xgdP8wW; arc=none smtp.client-ip=209.85.166.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-il1-f171.google.com with SMTP id e9e14a558f8ab-3da7642b5deso32106495ab.2
        for <io-uring@vger.kernel.org>; Mon, 12 May 2025 06:56:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1747058203; x=1747663003; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:to:subject:user-agent:mime-version:date:message-id:from
         :to:cc:subject:date:message-id:reply-to;
        bh=I02nvKMWnG/BGLcZpszg4ximcoVRkcnaQyXtdvif/Fs=;
        b=1xgdP8wW+Kr00l7ctARZMo3UxfeIoExuVfX5KgXVO25eWZeYK1qlWPlUzP7iyZCz9K
         4ztmC54lLph+RaU6MrOFDW0locWrj+Xg1BX0kucZEu2I2N4cX4vUDqih2O0D7GNyttIv
         iIQ5Ut/FKdddKcHq6CLOp1y7XrRpKseGkRZ+WrZIfkpeaJ4jRnIJry7Dvv/8pqWLjNLI
         DKw1PD/jwdVOySax6aKM85bkdX5D5H2Om9CjGB7uF1H1YH6oTesEjKOqfoh4LvHzOD6S
         ngnLC+/JWN0PMXBZkoYiqPkCAaUpvYq44+A6g+UO5QlZ3CtLm4IRbji2iVLFtfoxrU0G
         8ufA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1747058203; x=1747663003;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=I02nvKMWnG/BGLcZpszg4ximcoVRkcnaQyXtdvif/Fs=;
        b=ckmYBrwQ5JDOqW8ZH68eSwDvnVYAWTnpSrU09w8s5hL029HSHs6KEcykVAqWMRWrBU
         s5eRt9gabbj3+0AisWbJA4Le+9DcJCwLoR00Kdj0fOcYuZ8inJJoarg3GxU2Kn+7zMGu
         htXodmUZPazV3pxD/c3Dk8f67Ax7wwMRqvAgTFfRI/Iybk2Vzo9OjlulcR13j4JKZayg
         tKBFJUr/99yMqeREizqNl4F27ButB+ftveQqC+Ojov3GNUTfuIJuUuugDHRIfvIJxqt2
         1ZVQbK9WE5PYg5i+fiAatyJWaIVOs0JpP0RLHQqt8WBdXCNGo20TJsaX5p+DfHrGzUEk
         3tyw==
X-Forwarded-Encrypted: i=1; AJvYcCXA362HRqs/lKhxypD3z8pKLHpYtSxtXvEjy77xAx7isuLf/T5zASJfr2ZBOGneQfmPp2XE7Q0mMA==@vger.kernel.org
X-Gm-Message-State: AOJu0Yz1PTgvhuT5OosP8A3sMOc4M1NuRpqW95L7IhGEYkHsxIcPxu3S
	X8XfCSnwbt1jnL7Hu3oCc0NwZO2Vd3XtMotsAjsTx4sYdxoNnp+0+mVX3prwCTg=
X-Gm-Gg: ASbGnct+37OjQmCw3nDPJ4kah2e6sB082LZiRJPvgvFxDpdsUk6nNsTAi+EIC09YQUs
	qmY60692SOCWfNs9D0oUsombib1+uwcxQCETSXYy02S0hszwEYerQOdaOe50dpk4UaRkOQghX14
	3UuRW65lNWz5PSpVb+vs/VYlks8JpKs1PyyTa2TDbW7IFJwEOSmJonEeYbudYG8f8JX89JCnAn6
	9EjtGcYDvSBWkAsGJjegvwo0jVu9DOucKZDBMJpdZuU40Vplt+zCO8YNUQ/Nc43CfIyTfIFg1Gy
	Vtx74YAsmj6eu0+/U85XUQAH4xJOp/CvgLjphQ3aKJyaTmQ=
X-Google-Smtp-Source: AGHT+IE32W9XtGroTDPClMctrHvzw1z18iVp5pajF3jN07omTlG2f/ds5rfYUhF13RHq1hN7F/ugug==
X-Received: by 2002:a05:6e02:168c:b0:3d8:1e96:1f0 with SMTP id e9e14a558f8ab-3da7e20e1e9mr162525385ab.20.1747058201035;
        Mon, 12 May 2025 06:56:41 -0700 (PDT)
Received: from [192.168.1.116] ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id e9e14a558f8ab-3da7e10472fsm22386245ab.28.2025.05.12.06.56.40
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 12 May 2025 06:56:40 -0700 (PDT)
Message-ID: <a132579a-b97c-4653-9ede-6fb25a6eb20c@kernel.dk>
Date: Mon, 12 May 2025 07:56:39 -0600
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [syzbot] [io-uring?] BUG: unable to handle kernel NULL pointer
 dereference in io_buffer_select
To: Pavel Begunkov <asml.silence@gmail.com>,
 syzbot <syzbot+6456a99dfdc2e78c4feb@syzkaller.appspotmail.com>,
 io-uring@vger.kernel.org, linux-kernel@vger.kernel.org,
 syzkaller-bugs@googlegroups.com
References: <681fed0a.050a0220.f2294.001c.GAE@google.com>
 <3460e09f-fafd-4d59-829a-341fa47d9652@gmail.com>
Content-Language: en-US
From: Jens Axboe <axboe@kernel.dk>
In-Reply-To: <3460e09f-fafd-4d59-829a-341fa47d9652@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

On 5/11/25 6:22 AM, Pavel Begunkov wrote:
> On 5/11/25 01:19, syzbot wrote:
>> Hello,
>>
>> syzbot found the following issue on:
>>
>> HEAD commit:    0d8d44db295c Merge tag 'for-6.15-rc5-tag' of git://git.ker..
>> git tree:       upstream
>> console output: https://syzkaller.appspot.com/x/log.txt?x=12df282f980000
>> kernel config:  https://syzkaller.appspot.com/x/.config?x=925afd2bdd38a581
>> dashboard link: https://syzkaller.appspot.com/bug?extid=6456a99dfdc2e78c4feb
>> compiler:       arm-linux-gnueabi-gcc (Debian 12.2.0-14) 12.2.0, GNU ld (GNU Binutils for Debian) 2.40
>> userspace arch: arm
>> syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=150338f4580000
>> C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=143984f4580000
>>
>> Downloadable assets:
>> disk image (non-bootable): https://storage.googleapis.com/syzbot-assets/98a89b9f34e4/non_bootable_disk-0d8d44db.raw.xz
>> vmlinux: https://storage.googleapis.com/syzbot-assets/f2af76a30640/vmlinux-0d8d44db.xz
>> kernel image: https://storage.googleapis.com/syzbot-assets/a0bb41cd257b/zImage-0d8d44db.xz
>>
>> IMPORTANT: if you fix the issue, please add the following tag to the commit:
>> Reported-by: syzbot+6456a99dfdc2e78c4feb@syzkaller.appspotmail.com
>>
>> Unable to handle kernel NULL pointer dereference at virtual address 0000000e when read
>> [0000000e] *pgd=84797003, *pmd=df777003
>> Internal error: Oops: 205 [#1] SMP ARM
>> Modules linked in:
>> CPU: 1 UID: 0 PID: 3105 Comm: syz-executor192 Not tainted 6.15.0-rc5-syzkaller #0 PREEMPT
>> Hardware name: ARM-Versatile Express
>> PC is at io_ring_buffer_select io_uring/kbuf.c:163 [inline]
> 
> this line:
> 
> tail = smp_load_acquire(&br->tail);
> 
> The offset of the tail field is 0xe so bl->buf_ring should be 0. That's
> while it has IOBL_BUF_RING flag set. Same goes for the other report. Also,
> since it's off io_buffer_select(), which looks up the list every time we
> can exclude the req having a dangling pointer.

It's funky for sure, the other one is regular classic provided buffers.
Interestingly, both reports are for arm32...
-- 
Jens Axboe


