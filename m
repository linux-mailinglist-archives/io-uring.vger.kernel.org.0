Return-Path: <io-uring+bounces-1022-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 65F3987DA93
	for <lists+io-uring@lfdr.de>; Sat, 16 Mar 2024 16:31:01 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id D00EBB21129
	for <lists+io-uring@lfdr.de>; Sat, 16 Mar 2024 15:30:58 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D1D791B960;
	Sat, 16 Mar 2024 15:30:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="YhWLyRXr"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-wm1-f54.google.com (mail-wm1-f54.google.com [209.85.128.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 23F571B948;
	Sat, 16 Mar 2024 15:30:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710603052; cv=none; b=T3I5BbYhEW4Z9MzKIdILes6Rm46BRCXa1A20ELnT2naedoRO5Gr8SAhMVD5vjtCjjP2yyky0GRpvRk+1SlX5jXwQAVN/ksT9TVXt0zo2GeqVz3laJbpHaFDYzpRigAyQ1D4lkNWXCdFdSFGFkXbIbm3uA4z6/I391BfGChZx6hQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710603052; c=relaxed/simple;
	bh=b7HgeX2TB5a84rYEqdoSCbWkFyQ+lggP7S4/00bewCA=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=sGaJdxIU3gJlLttB5YMc1GtSWFhtZsMcT/58gjtBtg/xQqALBIIhnfixZpxnA/Z+S62kmHkA8618+N/2YDooVaPg53Us4IhDIpWhLqyELgFs4QHlvF0lYf076RFR+o8WDscHjHSHohw63pXeAu67S3OfIp1dXm10TtOgr2wir0c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=YhWLyRXr; arc=none smtp.client-ip=209.85.128.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-wm1-f54.google.com with SMTP id 5b1f17b1804b1-41409dc5becso1416285e9.3;
        Sat, 16 Mar 2024 08:30:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1710603049; x=1711207849; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:references:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=Ej0sxejzu+vHgrdZtA6Xmngt4zP8hvbIDWNVd7APvwY=;
        b=YhWLyRXr4vdHePPCHf7rXOif0Xfdcc2mcv7/BN9cZoOalFmbKAjojQoBUuLZ7SG3D+
         DH06u1AYonZMajjLOGB4750L35RyX3R7BW+A/xg0u934JF3QugW0rmnZSwLJjHgbfHmB
         3am22Pjs+JYbNExD8Z9NT3OKVE5mNp7Y+HM74RGNQO+/egXPThsNLIygt9YfEvy3RU/l
         77tGODUk1RAR/Xn3r4Uv46DWpfsyfbVkZh2IS78Qp040Baj1YNScjcgmrn3mp3TYzoR7
         WQxmkCmh9aEcw3rPObzTQnYAFO/6WHcp0ntRbUfYBRrmTN3uUQOgN8+KYPKK6/21xZE7
         Lvfw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1710603049; x=1711207849;
        h=content-transfer-encoding:in-reply-to:from:references:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Ej0sxejzu+vHgrdZtA6Xmngt4zP8hvbIDWNVd7APvwY=;
        b=QjjVSyn0Ey5Dr6J7kBbj8ghh1XBKdjSyUxJqJAtQ3w0IisbE1+A+Tt96Iz/Qx4hQIJ
         zLdjiftb0AsxfVj2fijcwjQw1L78SjpFl5kI6GIMSBOyo0s3edFiBMOMXQ7OTx1QwNwN
         aCA145MgF0oed4B5vP3Zty7z5nhRHPsqDL2D/U2kHMln72U/1ks6LRZhG9lvY0KvLxG1
         8ylvNGTF9MwQAyYGtFyKxzSdFZynng6Mo0xeXWzp4lcqWsnwcje47DqACotmDI6NXMfu
         w4oP4hAg4YAa+uOERcNC4M+bC7UmJntbzJDsSMst1panXmJKSc0K32cPFxmZDtmj5mGe
         F5pA==
X-Forwarded-Encrypted: i=1; AJvYcCXQCUEyn4cizzPr0qNaaytEV2tcCneX/4oXHZ61ejRXaRxJlesScI0o+Rqs+z8gI+HorXNgJxwzaniw2uVt2yV/SZLQQ4Z0XnEjJ+HLBQKDVcG7l1WL7c3s61QoLvn2WsQbhd4Is+I=
X-Gm-Message-State: AOJu0Yxw4njO+yUg1tTzTZr8vtCeX6OJ6YRyo9dHpvklOMw5lBLJ387z
	D6k8bXOE/DU+G6x3LiygS5QGCqsBnRTXcyU3uxKrNI/ln6WYqtyPVwePOWdL
X-Google-Smtp-Source: AGHT+IE7W99bTMDAcq0SYXeqlobVjFTvbq5DImyBq6UWlY/WOP1oKxAx+q4LL42gbOqnus2drDbHLw==
X-Received: by 2002:a05:600c:4685:b0:412:ee8b:dead with SMTP id p5-20020a05600c468500b00412ee8bdeadmr4202281wmo.34.1710603049227;
        Sat, 16 Mar 2024 08:30:49 -0700 (PDT)
Received: from [192.168.8.100] ([185.69.144.99])
        by smtp.gmail.com with ESMTPSA id h15-20020a05600c314f00b0041408e16e6bsm1561556wmo.25.2024.03.16.08.30.48
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 16 Mar 2024 08:30:48 -0700 (PDT)
Message-ID: <fab71bfa-7657-4379-8c79-1f92766a7b17@gmail.com>
Date: Sat, 16 Mar 2024 15:28:57 +0000
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
 axboe@kernel.dk, io-uring@vger.kernel.org, linux-kernel@vger.kernel.org,
 syzkaller-bugs@googlegroups.com
References: <0000000000003e6b710613c738d4@google.com>
From: Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <0000000000003e6b710613c738d4@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 3/16/24 13:37, syzbot wrote:
> Hello,
> 
> syzbot has tested the proposed patch but the reproducer is still triggering an issue:
> KMSAN: uninit-value in io_sendrecv_fail

diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
index 3ae4bb988906..826989e2f601 100644
--- a/io_uring/io_uring.c
+++ b/io_uring/io_uring.c
@@ -1063,6 +1063,7 @@ static void io_preinit_req(struct io_kiocb *req, struct io_ring_ctx *ctx)
  	/* not necessary, but safer to zero */
  	memset(&req->cqe, 0, sizeof(req->cqe));
  	memset(&req->big_cqe, 0, sizeof(req->big_cqe));
+	memset(&req->cmd, 0, sizeof(req->cmd));
  }

What's the point of testing it? You said it yourself, it hides the
problem under the carpet but doesn't solve it. Do some valid IO first,
then send that failed request. If done_io is aliased with with some
interesting field of a previously completed request you're royally
screwed, but syz would be just happy about it.

It's likely that syz is complaining about is the early fail case
I told about yesterday.


> =====================================================
> BUG: KMSAN: uninit-value in io_sendrecv_fail+0x91/0x1e0 io_uring/net.c:1341
>   io_sendrecv_fail+0x91/0x1e0 io_uring/net.c:1341
>   io_req_defer_failed+0x3bd/0x610 io_uring/io_uring.c:1050
>   io_queue_sqe_fallback+0x1e3/0x280 io_uring/io_uring.c:2126
>   io_submit_fail_init+0x4e1/0x790 io_uring/io_uring.c:2304
>   io_submit_sqes+0x19cd/0x2fb0 io_uring/io_uring.c:2480
>   __do_sys_io_uring_enter io_uring/io_uring.c:3656 [inline]
>   __se_sys_io_uring_enter+0x409/0x4390 io_uring/io_uring.c:3591
>   __x64_sys_io_uring_enter+0x11b/0x1a0 io_uring/io_uring.c:3591
>   do_syscall_x64 arch/x86/entry/common.c:52 [inline]
>   do_syscall_64+0xcf/0x1e0 arch/x86/entry/common.c:83
>   entry_SYSCALL_64_after_hwframe+0x63/0x6b
> 
> Uninit was created at:
>   __alloc_pages+0x9a6/0xe00 mm/page_alloc.c:4592
>   __alloc_pages_node include/linux/gfp.h:238 [inline]
>   alloc_pages_node include/linux/gfp.h:261 [inline]
>   alloc_slab_page mm/slub.c:2190 [inline]
>   allocate_slab mm/slub.c:2354 [inline]
>   new_slab+0x2d7/0x1400 mm/slub.c:2407
>   ___slab_alloc+0x16b5/0x3970 mm/slub.c:3540
>   __kmem_cache_alloc_bulk mm/slub.c:4574 [inline]
>   kmem_cache_alloc_bulk+0x52a/0x1440 mm/slub.c:4648
>   __io_alloc_req_refill+0x248/0x780 io_uring/io_uring.c:1101
>   io_alloc_req io_uring/io_uring.h:405 [inline]
>   io_submit_sqes+0xaa1/0x2fb0 io_uring/io_uring.c:2469
>   __do_sys_io_uring_enter io_uring/io_uring.c:3656 [inline]
>   __se_sys_io_uring_enter+0x409/0x4390 io_uring/io_uring.c:3591
>   __x64_sys_io_uring_enter+0x11b/0x1a0 io_uring/io_uring.c:3591
>   do_syscall_x64 arch/x86/entry/common.c:52 [inline]
>   do_syscall_64+0xcf/0x1e0 arch/x86/entry/common.c:83
>   entry_SYSCALL_64_after_hwframe+0x63/0x6b
> 
> CPU: 0 PID: 5482 Comm: syz-executor.0 Not tainted 6.8.0-syzkaller-00721-g6c677dd4eac2 #0
> Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 02/29/2024
> =====================================================
> 
> 
> Tested on:
> 
> commit:         6c677dd4 io_uring/net: ensure async prep handlers alwa..
> git tree:       git://git.kernel.dk/linux.git io_uring-6.9
> console output: https://syzkaller.appspot.com/x/log.txt?x=17f26711180000
> kernel config:  https://syzkaller.appspot.com/x/.config?x=a271c5dca0ff14df
> dashboard link: https://syzkaller.appspot.com/bug?extid=f8e9a371388aa62ecab4
> compiler:       Debian clang version 15.0.6, GNU ld (GNU Binutils for Debian) 2.40
> 
> Note: no patches were applied.

-- 
Pavel Begunkov

