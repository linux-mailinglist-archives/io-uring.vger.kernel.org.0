Return-Path: <io-uring+bounces-2743-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 5110D9504B6
	for <lists+io-uring@lfdr.de>; Tue, 13 Aug 2024 14:15:48 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 0D72F286F26
	for <lists+io-uring@lfdr.de>; Tue, 13 Aug 2024 12:15:47 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 672E61993B9;
	Tue, 13 Aug 2024 12:14:55 +0000 (UTC)
X-Original-To: io-uring@vger.kernel.org
Received: from mail-io1-f71.google.com (mail-io1-f71.google.com [209.85.166.71])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D03EA19939E
	for <io-uring@vger.kernel.org>; Tue, 13 Aug 2024 12:14:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.71
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723551295; cv=none; b=olqF7v2Gcv/jUsCq2cAkxWFmGK71pwEeCh9aLB03tCa4BNcjf/OkCFK7SrTKqIhc1DJmXREUR9JIjTKJKKf1+25ithM2dJEudKxlrOnw0zsq6f9r/lFkJcxfEo7OEW8ugdwYR1fSNnhrfNJkjvodR8U+Zn3lwr6GDnniLG1CgQI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723551295; c=relaxed/simple;
	bh=BF7+auRmhS59UVfpPnQolec5KFKABaoOdzGbjVqYsFg=;
	h=MIME-Version:Date:In-Reply-To:Message-ID:Subject:From:To:Cc:
	 Content-Type; b=IdSjwQ05qOFq7L67MEx353NVlxbReZ//WOsp60VNue38CbZm2jVOj3QXck5tnXDlB3nO3f3DPF3s1LPPw37h84coPP+xZpLwrv9aefbeyeKSWyHwgzNK0AYfCHXvTFSIjAEVDOhV8hPKbG2rGv82Fb7ogIslyNuX5DgJ1yv5VEM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.166.71
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-io1-f71.google.com with SMTP id ca18e2360f4ac-81f8293cdb1so675653939f.2
        for <io-uring@vger.kernel.org>; Tue, 13 Aug 2024 05:14:53 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1723551293; x=1724156093;
        h=cc:to:from:subject:message-id:in-reply-to:date:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=5kHQRdAqhQGpvXY9jr6N7W3WQ10E9TIY4QITICoXhGM=;
        b=S9VwXjIEEi5Jn0DcsatItSCJvlHouEMeUhCPiYhjXmBELzJuiJgLlieNGmzfOYJE2A
         wz45ncdMjBAcB//FdRuKpFcJEAAoHa/yd/4xjaK39FiezegC/AMI4ETbBYYtmGP5hkcZ
         6QN6dpM3uykSu6Lgp7j9gw5wYlgZG/i/7Dvi0uNbugdC8pdvNbn1HmLF26Ozm3uTwKZk
         KsLqQ/DQzlmo7RGndHi9SjecXUBO6ZgHRM6pe7m+TvGCgrpc091ZrnKuDI629jTMAp1K
         YhVgC+THb1uAwms9JXTSnVVrF7zGzp7nW+EtEUJBtJYGzZ1JKBaWOuRVxguhlywGYyRM
         euXw==
X-Forwarded-Encrypted: i=1; AJvYcCVRdW9DxD48iiu05DRk9OZt0joh4tSJkphoHxZ8UTCzRaRFoFK91z07HMGqMcIjcrid3sIq777+Kg2RmI6liLhPjkiU7luX/Cc=
X-Gm-Message-State: AOJu0YwZ1pBE+e5UAr43YlqMox45892dN637K+9ZjVXVfU/yq3hDz8BC
	9j8l4QFdwm5bdiY4ph0z/AIQHz27i58vWcgCyCAe9bh4UH21QhkxeGweZITKA9yt7WxeKq7xzA8
	JKKlcOcnvrf04IrJo4IPK0oVD9FCDMUEAeNw29Un77semvPCE5YYvp+s=
X-Google-Smtp-Source: AGHT+IF9ojnQ28Q0LX2a3iwzX3+GLfAK5YrX0Fr9zx6P15yvkhePGKgeUw3DUrkslDrDjP18FLxuqPfGSFxJ6oMo2IJrNBAszpCP
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Received: by 2002:a05:6602:3fd4:b0:807:f0fb:11a4 with SMTP id
 ca18e2360f4ac-824c987550fmr7200839f.1.1723551292870; Tue, 13 Aug 2024
 05:14:52 -0700 (PDT)
Date: Tue, 13 Aug 2024 05:14:52 -0700
In-Reply-To: <43b7c2c4-9bba-444a-ba27-9a8f3623a953@kernel.dk>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <0000000000009063fb061f8f8e5c@google.com>
Subject: Re: [syzbot] [io-uring?] KCSAN: data-race in io_sq_thread /
 io_sq_thread_park (9)
From: syzbot <syzbot+2b946a3fd80caf971b21@syzkaller.appspotmail.com>
To: axboe@kernel.dk
Cc: asml.silence@gmail.com, axboe@kernel.dk, io-uring@vger.kernel.org, 
	linux-kernel@vger.kernel.org, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"

> On 8/13/24 2:50 AM, syzbot wrote:
>> Hello,
>> 
>> syzbot found the following issue on:
>> 
>> HEAD commit:    6a0e38264012 Merge tag 'for-6.11-rc2-tag' of git://git.ker..
>> git tree:       upstream
>> console output: https://syzkaller.appspot.com/x/log.txt?x=1019759d980000
>> kernel config:  https://syzkaller.appspot.com/x/.config?x=cb57e6ebf675f9d2
>> dashboard link: https://syzkaller.appspot.com/bug?extid=2b946a3fd80caf971b21
>> compiler:       Debian clang version 15.0.6, GNU ld (GNU Binutils for Debian) 2.40
>> 
>> Unfortunately, I don't have any reproducer for this issue yet.
>> 
>> Downloadable assets:
>> disk image: https://storage.googleapis.com/syzbot-assets/753a842a966b/disk-6a0e3826.raw.xz
>> vmlinux: https://storage.googleapis.com/syzbot-assets/e12e23519777/vmlinux-6a0e3826.xz
>> kernel image: https://storage.googleapis.com/syzbot-assets/bce0584a8cb4/bzImage-6a0e3826.xz
>> 
>> IMPORTANT: if you fix the issue, please add the following tag to the commit:
>> Reported-by: syzbot+2b946a3fd80caf971b21@syzkaller.appspotmail.com
>> 
>> ==================================================================
>> BUG: KCSAN: data-race in io_sq_thread / io_sq_thread_park
>> 
>> write to 0xffff888111459638 of 8 bytes by task 10761 on cpu 1:
>>  io_sq_thread+0xdab/0xff0 io_uring/sqpoll.c:383
>>  ret_from_fork+0x4b/0x60 arch/x86/kernel/process.c:147
>>  ret_from_fork_asm+0x1a/0x30 arch/x86/entry/entry_64.S:244
>> 
>> read to 0xffff888111459638 of 8 bytes by task 10329 on cpu 0:
>>  io_sq_thread_park+0x1b/0x80 io_uring/sqpoll.c:47
>>  io_ring_exit_work+0x197/0x500 io_uring/io_uring.c:2786
>>  process_one_work kernel/workqueue.c:3231 [inline]
>>  process_scheduled_works+0x483/0x9a0 kernel/workqueue.c:3312
>>  worker_thread+0x526/0x700 kernel/workqueue.c:3390
>>  kthread+0x1d1/0x210 kernel/kthread.c:389
>>  ret_from_fork+0x4b/0x60 arch/x86/kernel/process.c:147
>>  ret_from_fork_asm+0x1a/0x30 arch/x86/entry/entry_64.S:244
>> 
>> value changed: 0xffff8881223d0000 -> 0x0000000000000000
>
> It's just a debug check.
>
> #syz test

This crash does not have a reproducer. I cannot test it.

>
> diff --git a/io_uring/sqpoll.c b/io_uring/sqpoll.c
> index b3722e5275e7..3b50dc9586d1 100644
> --- a/io_uring/sqpoll.c
> +++ b/io_uring/sqpoll.c
> @@ -44,7 +44,7 @@ void io_sq_thread_unpark(struct io_sq_data *sqd)
>  void io_sq_thread_park(struct io_sq_data *sqd)
>  	__acquires(&sqd->lock)
>  {
> -	WARN_ON_ONCE(sqd->thread == current);
> +	WARN_ON_ONCE(data_race(sqd->thread) == current);
>  
>  	atomic_inc(&sqd->park_pending);
>  	set_bit(IO_SQ_THREAD_SHOULD_PARK, &sqd->state);
>
> -- 
> Jens Axboe
>

