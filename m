Return-Path: <io-uring+bounces-991-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id E5BAB87D6AE
	for <lists+io-uring@lfdr.de>; Fri, 15 Mar 2024 23:38:45 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 1CE361C20C11
	for <lists+io-uring@lfdr.de>; Fri, 15 Mar 2024 22:38:45 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2553954745;
	Fri, 15 Mar 2024 22:38:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="fvtASvfd"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pl1-f173.google.com (mail-pl1-f173.google.com [209.85.214.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 242E71774E
	for <io-uring@vger.kernel.org>; Fri, 15 Mar 2024 22:38:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710542321; cv=none; b=h+IFVciY2rQ012M8RjF9Kj9EK5yxIv2E4ktvz4K0FfEbIRHj2eUtv75/Zym+O474MzXbDn1wzni2vSyaOIJh+xIN5A2CCwbyYSGWg+HBE3I3OBjUT4LE6HU12EFYkx6WWHigha8ofY9qQ4+nkPQn2zh479ChNaPqlWi0Keris5o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710542321; c=relaxed/simple;
	bh=ZtmGBms18y5rLruGa78SQlS9w6D2T7MxwMlTdsX4dsI=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=UMM0KL8ygnImQjjUu+9AyDV8BMGoaTCUp9mnfFTzzU8i+SRHprIG608Iv2R1jxraCYE0jtRKfB1WAnS1MQRpUhKd8KFwoiz66hf5yronwSdaLm3xLQW2n+uc6qts1CjbmTtZlyvR6ryFFhmeVdiwOx2ocOiE5I0P2XeGVMVtPI0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=fvtASvfd; arc=none smtp.client-ip=209.85.214.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-pl1-f173.google.com with SMTP id d9443c01a7336-1dd8ee2441dso5183975ad.1
        for <io-uring@vger.kernel.org>; Fri, 15 Mar 2024 15:38:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1710542316; x=1711147116; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:references:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=ic+kabnMCMY5KJ+q4SJK00XV6xYupnupycxy1eugygg=;
        b=fvtASvfdsG/qGWoIa55zZBR3s2EWEf2TCtxXLc0OlQraH2o99FJJ/DEV11AadyaZ/a
         X9MfGqoqtkAv/jTsJrHefD5l8wa3OFvjERzqo1Hhqf1qty2Hg1N/k9IjKWbtu1wgYGmr
         ahXEAk77JLNP9xSTybrhMK+v5IA7yvf1QJy3C8UAJopyTd9fvUh+0hOZFWH9AoRyb6r6
         hWe5qGgpPvnxoPpvqgAt+tk9xCaqnU37LTziQiKzzYkfqWPGwzeXOSsu4HPGZmWZ4Blp
         LcFDWdOHy5VdvKks/ux83nOsbSH5OxR7KYI/1K7RbAnE7CZ3LMGCr0oHwk/71iwGBKBu
         DfqQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1710542316; x=1711147116;
        h=content-transfer-encoding:in-reply-to:from:references:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=ic+kabnMCMY5KJ+q4SJK00XV6xYupnupycxy1eugygg=;
        b=HORHjICbA4/CHNikVgsbQ/SyihS9i1ELOUjJKkuq0jCNAod/kh/Ml6wkQI24URLRnM
         prS0ORj85CbPasuL5A90CLJ7RpyoKCcZ3/MhkRvgZSfbo8JD6ippPgSJXTVkV7qysxBK
         e9bFQGu+J09Kvgg1zfnkh0cE6/le2YAuBcwb5biIVnxB/6o5EiKWO+3kgFRPkOp9xw82
         PY+uUIcWytYe0vnl56G5ICI+uskjQ9aagk4Ad0wJNQSr8qPQwD1Gu3D4sLzDGpWfrL+g
         Je/Ooq7C2qmqruzYOGQL1+eGQtKjmJ/B9FZZjd+GZGLPQgsOlYDUrl2obXb8ZxTWbh2U
         0Enw==
X-Forwarded-Encrypted: i=1; AJvYcCWdgaT4ZDYhACcagxGEbVGI4HXsSXsHcu+76XapTqMVi+rE+mi2iEjefVhekaFnkPw11Nr74b6CS7WSxAMk9CRyPVCDZsmyjAo=
X-Gm-Message-State: AOJu0YyT29A1xmuggGMq0LEGMoRVeyX5m6SJKBFRD2reXiqG0U2FJekB
	8Aw16SCZ2GaDEr7UtQgc/7HvGhtqlRg5aIyUcKa2E5CDgGnIOy5VckdVZb65Pnq7b7Sim/1Drd1
	J
X-Google-Smtp-Source: AGHT+IE+Rl8hRNTw4LjSIwnzdcVlE7pqV6EbEBqwGh98PqS29g23gF2U93X3qctGYOUNlZ9RRhvz1A==
X-Received: by 2002:a05:6a21:1706:b0:1a1:694d:d4f7 with SMTP id nv6-20020a056a21170600b001a1694dd4f7mr6813196pzb.0.1710542316403;
        Fri, 15 Mar 2024 15:38:36 -0700 (PDT)
Received: from [192.168.1.150] ([198.8.77.194])
        by smtp.gmail.com with ESMTPSA id n45-20020a056a000d6d00b006e6ff8ba817sm1208238pfv.16.2024.03.15.15.38.34
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 15 Mar 2024 15:38:35 -0700 (PDT)
Message-ID: <b090c928-6c42-4735-9758-e8a137832607@kernel.dk>
Date: Fri, 15 Mar 2024 16:38:34 -0600
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [syzbot] [io-uring?] KMSAN: uninit-value in io_sendrecv_fail
Content-Language: en-US
To: syzbot <syzbot+f8e9a371388aa62ecab4@syzkaller.appspotmail.com>,
 asml.silence@gmail.com, io-uring@vger.kernel.org,
 linux-kernel@vger.kernel.org, syzkaller-bugs@googlegroups.com
References: <00000000000024b0820613ba8647@google.com>
From: Jens Axboe <axboe@kernel.dk>
In-Reply-To: <00000000000024b0820613ba8647@google.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 3/15/24 4:28 PM, syzbot wrote:
> Hello,
> 
> syzbot found the following issue on:
> 
> HEAD commit:    8ede842f669b Merge tag 'rust-6.9' of https://github.com/Ru..
> git tree:       upstream
> console+strace: https://syzkaller.appspot.com/x/log.txt?x=138f0ad6180000
> kernel config:  https://syzkaller.appspot.com/x/.config?x=a271c5dca0ff14df
> dashboard link: https://syzkaller.appspot.com/bug?extid=f8e9a371388aa62ecab4
> compiler:       Debian clang version 15.0.6, GNU ld (GNU Binutils for Debian) 2.40
> syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=15b4a6fa180000
> C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=14a59799180000
> 
> Downloadable assets:
> disk image: https://storage.googleapis.com/syzbot-assets/af1cd47b84ef/disk-8ede842f.raw.xz
> vmlinux: https://storage.googleapis.com/syzbot-assets/be9297712c37/vmlinux-8ede842f.xz
> kernel image: https://storage.googleapis.com/syzbot-assets/c569fb33468d/bzImage-8ede842f.xz
> 
> IMPORTANT: if you fix the issue, please add the following tag to the commit:
> Reported-by: syzbot+f8e9a371388aa62ecab4@syzkaller.appspotmail.com
> 
> =====================================================
> BUG: KMSAN: uninit-value in io_sendrecv_fail+0x91/0x1e0 io_uring/net.c:1334
>  io_sendrecv_fail+0x91/0x1e0 io_uring/net.c:1334
>  io_req_defer_failed+0x3bd/0x610 io_uring/io_uring.c:1050
>  io_queue_sqe_fallback+0x1e3/0x280 io_uring/io_uring.c:2126
>  io_submit_fail_init+0x4e1/0x790 io_uring/io_uring.c:2304
>  io_submit_sqes+0x19cd/0x2fb0 io_uring/io_uring.c:2480
>  __do_sys_io_uring_enter io_uring/io_uring.c:3656 [inline]
>  __se_sys_io_uring_enter+0x409/0x43e0 io_uring/io_uring.c:3591
>  __x64_sys_io_uring_enter+0x11b/0x1a0 io_uring/io_uring.c:3591
>  do_syscall_x64 arch/x86/entry/common.c:52 [inline]
>  do_syscall_64+0xcf/0x1e0 arch/x86/entry/common.c:83
>  entry_SYSCALL_64_after_hwframe+0x63/0x6b

This is similar to the issue fixed by:

commit 0a535eddbe0dc1de4386046ab849f08aeb2f8faf
Author: Jens Axboe <axboe@kernel.dk>
Date:   Thu Dec 21 08:49:18 2023 -0700

    io_uring/rw: ensure io->bytes_done is always initialized

which I did fix separately for this case, just not in the 6.9 pile. I'll
move it over there to silence this one.

Only side effect of this is that cqe->res may not be -EINVAL, when it
should've been, for an ill formed request that was issued with
ISOQE_ASYNC.

#syz test: git://git.kernel.dk/linux.git io_uring-6.0

-- 
Jens Axboe


