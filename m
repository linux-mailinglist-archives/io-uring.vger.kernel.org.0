Return-Path: <io-uring+bounces-10299-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [IPv6:2605:f480:58:1:0:1994:3:14])
	by mail.lfdr.de (Postfix) with ESMTPS id 8A4C2C229E2
	for <lists+io-uring@lfdr.de>; Fri, 31 Oct 2025 00:02:14 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id 0AC774E52F7
	for <lists+io-uring@lfdr.de>; Thu, 30 Oct 2025 23:02:13 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AA36B288520;
	Thu, 30 Oct 2025 23:02:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="d0HFleTs"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-io1-f51.google.com (mail-io1-f51.google.com [209.85.166.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8834F1386C9
	for <io-uring@vger.kernel.org>; Thu, 30 Oct 2025 23:02:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761865330; cv=none; b=YJIeR3AmRZ61eRBA1FnSZE8arTaZbxR3rvmyXnurEBt5N9kE5fO89Pm5eBfqE3ZhfdF6JaqH/WtE738B6DHY+eNJiqvxxUy+zh3jFG4NIAdRgu7KVVW6SIxhLWi7Y7sw90AC0khk98HB3Tb8+hGsaev7THmV4TGS5KMUjYKztos=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761865330; c=relaxed/simple;
	bh=XCKBcVvyhP+A3QeTqoY911uBXichWT/SLwC6p0oeCyM=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=ESHhF1Lht+iUIUsa/i5ibLXwmduPV/6Y6TMye+M7KYyvIPyAdO0gfnFRK0IajGE1iN5oayfJA9xCU/u89FqSS8+WychAihdGgtUFLV7ko0mTihwipU3WDibDSmAnw2OtwdgWj+rVKpkm8zEXFyNJsM3dkjPaF5HSzYrPQ6ft1w4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=d0HFleTs; arc=none smtp.client-ip=209.85.166.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-io1-f51.google.com with SMTP id ca18e2360f4ac-9435969137aso146269939f.1
        for <io-uring@vger.kernel.org>; Thu, 30 Oct 2025 16:02:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1761865326; x=1762470126; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:to:subject:user-agent:mime-version:date:message-id:from
         :to:cc:subject:date:message-id:reply-to;
        bh=WNrbW+SeKAgnRYtsM5qOYmcjtZuWAEhxcYqXFGylGdQ=;
        b=d0HFleTs8NoMc87lWA41jNY82UFlVjMVLomRUkfoLOhzWaOwuR13BpuHZ63/LRLO9L
         OL3l6FhYCijDwL7+ryD01wyqKMvFvyuZUpWjB2tKtjlHTgLC+/2T8h22XeM+0YieOed8
         f7lTjS0nkwQyafU2/2JmSCGLTo0LeVqxoIc+MTzDT1NaprRU1Yy6y11hY77LmGoBOnzX
         mfV9RWMoU8NjWB0/xxvf7HWtcwXNbDRXX2pJh4xTvft1UtXScG0RzijV2A4z0LFKyJAh
         tukEfpp0OOKfxS8onwtXzpWaQtESms2IgzhdAn4u7w0VeIsRUOiLr9xmvIP1hmvuQML2
         N8cA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1761865326; x=1762470126;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=WNrbW+SeKAgnRYtsM5qOYmcjtZuWAEhxcYqXFGylGdQ=;
        b=v/2ZeMcyauu8JA7/6+iMTiQKTeKSYRvFU4nN8XtwwJFxjyVCET66Jrrg6eeVP6+4XR
         12BV7fzJySfRLzBH2/R0NTNWMhEqgX044QKYUz2aKm6qL2ypTwu2L+c2/Dwq4rFbr6Gc
         4ZeaQrUlXcBNSjHOKHkY4CItWHAGISYQRm7uznoHkR0AqqahcZ39yPrEVKwIC1sDA3Ws
         klaSkR8KUYG34go9B2GPG17Z6EZo1c/oxl29fYikkFyTkcG9f6WhGVLSRSWTeKeGkpjD
         XfSmQB2PQeqhol93zYj5RadQ5VbM/87l9yj6UNWEPTfU7q2VnsXTq3qFcwZX66gPGg0e
         P4zg==
X-Forwarded-Encrypted: i=1; AJvYcCUy6kkFfg4df6bLlTbO/X7Wt3isEHL5o/7Nh3LXbgj1mgyEP0WI2YQ6W+8QW91CaF6tBeL+D7u0Lw==@vger.kernel.org
X-Gm-Message-State: AOJu0YyJvgkv/nQSdWj+ZK0lJJjqxNULGBGiD0SOpg9KpgrK9IUJ0DrQ
	AdV3B2DZYRL8lii9HfTH/SwgpKTXtTySHPt7VCD2GfFAsTQ22faQQyZUMelqMOW4s58=
X-Gm-Gg: ASbGnctDn+s/aWVfTQr5HmT+JjqDdktrSYdmqdqf3BOi6JEHw4/mSCk2dlm5N6Qk290
	syAJHkqe/zCjYQMPk9Eenjv98/mjbdNdBJqYSRHNhr39APY7VAEua2M2FNMXZAiOzWJ2s/4pyGY
	Di14TQpeM7m6Y8zP3WAdmUMi5jlSUZg8zM8F1N/Bt0R/5f1fxOfhsjvr2uuBAag9UBk4SGqt4uT
	kqgj+nehP5bZvPuq3cgeUsHi4L2O4Pgy1krZA5oxtE5V3fYhFnyChsgwJPVh92eV6M0hzs4Aveq
	HJ4zJB/GX++0Nvady4x0cNW0ImtUkVunu6CZDs4KkZCQ6VWQLOG/WNDqlGRZw7HHz97j/YLLH2b
	pSAWhkOndBCoExiF87tgo28rjcByxtiuTvitgaDyzXhyzgEAVani+IWNFjBOCAMszD2MDWKORaj
	+X1vXM5oUo
X-Google-Smtp-Source: AGHT+IGEHw5+bdrQi6l+uxrKVAADzYnOcJRr15Glf/t4OXjeLbRsVsT9gNjYKKBlbMG+nGcRbxSS6Q==
X-Received: by 2002:a05:6602:718a:b0:892:f398:591 with SMTP id ca18e2360f4ac-94822865f52mr223511939f.2.1761865326174;
        Thu, 30 Oct 2025 16:02:06 -0700 (PDT)
Received: from [192.168.1.150] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id 8926c6da1cb9f-5b6a5a990d2sm35946173.53.2025.10.30.16.02.05
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 30 Oct 2025 16:02:05 -0700 (PDT)
Message-ID: <e5e294fd-6874-46b9-9d85-f5fd5fc12f03@kernel.dk>
Date: Thu, 30 Oct 2025 17:02:04 -0600
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [syzbot] [io-uring?] KASAN: global-out-of-bounds Read in
 io_uring_show_fdinfo
To: syzbot <syzbot+b883b008a0b1067d5833@syzkaller.appspotmail.com>,
 io-uring@vger.kernel.org, kbusch@kernel.org, linux-kernel@vger.kernel.org,
 syzkaller-bugs@googlegroups.com
References: <6903e7f7.050a0220.3344a1.044d.GAE@google.com>
Content-Language: en-US
From: Jens Axboe <axboe@kernel.dk>
In-Reply-To: <6903e7f7.050a0220.3344a1.044d.GAE@google.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 10/30/25 4:34 PM, syzbot wrote:
> Hello,
> 
> syzbot found the following issue on:
> 
> HEAD commit:    f9ba12abc528 Add linux-next specific files for 20251029
> git tree:       linux-next
> console output: https://syzkaller.appspot.com/x/log.txt?x=16493fe2580000
> kernel config:  https://syzkaller.appspot.com/x/.config?x=32e95de7031f410d
> dashboard link: https://syzkaller.appspot.com/bug?extid=b883b008a0b1067d5833
> compiler:       Debian clang version 20.1.8 (++20250708063551+0c9f909b7976-1~exp1~20250708183702.136), Debian LLD 20.1.8
> syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=15729258580000
> C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=10988e14580000
> 
> Downloadable assets:
> disk image: https://storage.googleapis.com/syzbot-assets/7b5f5194573e/disk-f9ba12ab.raw.xz
> vmlinux: https://storage.googleapis.com/syzbot-assets/83dabfc9c13b/vmlinux-f9ba12ab.xz
> kernel image: https://storage.googleapis.com/syzbot-assets/7e62a1d361f0/bzImage-f9ba12ab.xz
> 
> The issue was bisected to:
> 
> commit 101e596e7404d07a85b38358a392009503aad797
> Author: Jens Axboe <axboe@kernel.dk>
> Date:   Tue Oct 28 01:09:28 2025 +0000
> 
>     io_uring/fdinfo: cap SQ iteration at max SQ entries

Don't think that's right, it's more like:

commit 1cba30bf9fdd6c982708f3587f609a30c370d889
Author: Keith Busch <kbusch@kernel.org>
Date:   Thu Oct 16 11:09:38 2025 -0700

    io_uring: add support for IORING_SETUP_SQE_MIXED

as it looks like 'opcode' is invalid, and hence it's reading beyond the end
of the io_issue_defs[] array.

Something like this should fix it:

diff --git a/io_uring/fdinfo.c b/io_uring/fdinfo.c
index 3f254ae0ad61..bd8251832320 100644
--- a/io_uring/fdinfo.c
+++ b/io_uring/fdinfo.c
@@ -106,6 +106,8 @@ static void __io_uring_show_fdinfo(struct io_ring_ctx *ctx, struct seq_file *m)
 
 		sqe = &ctx->sq_sqes[sq_idx << sq_shift];
 		opcode = READ_ONCE(sqe->opcode);
+		if (opcode >= IORING_OP_LAST)
+			continue;
 		if (sq_shift) {
 			sqe128 = true;
 		} else if (io_issue_defs[opcode].is_128) {

-- 
Jens Axboe

