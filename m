Return-Path: <io-uring+bounces-5800-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id B9FEEA0930E
	for <lists+io-uring@lfdr.de>; Fri, 10 Jan 2025 15:12:49 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 6E31F1887D07
	for <lists+io-uring@lfdr.de>; Fri, 10 Jan 2025 14:12:52 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id ADE0F20FAA5;
	Fri, 10 Jan 2025 14:12:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="GN3H9JQH"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ed1-f52.google.com (mail-ed1-f52.google.com [209.85.208.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DABF5207A15;
	Fri, 10 Jan 2025 14:12:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736518365; cv=none; b=sGVpxmjcBlnL3OIQnzZel7MkQYLD16mNynZi4wHgEQMZ4zWHuAFcYDtnFVkxNEyKFcCihXrTRNdldvu0vYMy13qlm2TFFt8BuVjXPz7foVrLqTDhMU3JvNB68nMJtm898ni/9XFm+V7NA1P7bgdbIVEV4O699kkm1UPCOI9cS5E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736518365; c=relaxed/simple;
	bh=MLYADhfUZr0o4LZOnUbijh2eFmTexJ2yh5YhhQmFJjQ=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=Knsn9ZtGEnvkPZetJOJcrW6KBCU/ualGvNetk/H+RBl5Z6Cr5eXhtjU3GXEfDkQtct/A9iQrM15HnS8A80MtCMCKZPPwoHZ88wR+NKvpcL3wou71AWJ7MtFvZU5jjtNDiUlElDrLnJBH9SrlvKUmBXcj1W5o6agcH2ZYs+z9nRs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=GN3H9JQH; arc=none smtp.client-ip=209.85.208.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-ed1-f52.google.com with SMTP id 4fb4d7f45d1cf-5d3f28881d6so2957943a12.1;
        Fri, 10 Jan 2025 06:12:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1736518362; x=1737123162; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=PDFBd9BoP7Zg/jWXopDLPJOHkYIQl0O3aYhBQPEXp4E=;
        b=GN3H9JQHm4kDN5uMqXH2eauHYlaaPUUaZXNyfEJ7AxqE+7s4qs9opNxOacwOYOjtt1
         pJJ8r9S/apITuSbmELnVAn01QtKaWdfP7ckx06HtoK6cyAQJHj/TLrMbgJKANDQmCk+n
         U9Ay0fZvRSSyIGzq/Oq2bSDxWrTEQUetwRS3vAB/sBuJDaz/Dhqyvlrvev+Qfo3s7QLD
         nwAMUCYjbJ11zlC313gNTbaX1nh+9004dOG/YM/Oo5sR61cZ9wIyoUIU8iXVRdHr06fi
         l6dDIOugd8ba2r+Rq97QvH5qw+mP9jCIgfLG1xr0h9llH9jNWn72x30b585+kAZH0gfu
         dwgQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1736518362; x=1737123162;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=PDFBd9BoP7Zg/jWXopDLPJOHkYIQl0O3aYhBQPEXp4E=;
        b=LcqOKlapaMKsZ/ZuL46aMWHN7X77N7E1tf4XGrdsNBqeqnncrn1dBlQZeUnSoJ2Mng
         UK83d+4MnK9DbnfiTrhsX04ce1DeLCngxlNjyts+VwFLVxngA7Q3Eft37o56yzwQTd8G
         axst5yikManPgs2Xf56GxliShtDN3LMWxQpC2N8K/c/OBs5qSdb84MXUNQJA7YE8D1Os
         hLWcEURqORdqCpnyWgk2s0EZhEkkIfKnGyYJZCympdNvtHeANPBDb8nIHswwkcE+iyrn
         sqUHt0iXkVkE4TkW31DrrSRpH8PH3etAdXvtgNOpDyYzsZiMBl8JiS7Tr0oDH/92ezgB
         joIw==
X-Forwarded-Encrypted: i=1; AJvYcCXVoz3fR89R4SW0GTkLStVgvn7r4pSvawO/XRS8+Y+Iqml7BudGyOuneaZwc2WhbIFCUrvmHb5UkQ==@vger.kernel.org
X-Gm-Message-State: AOJu0YwcuFttjWxKH+aCK2cTIsZu62VQ3NNWwmX9CzCZZyW4bY0UGvhD
	GFDWLSVpaCPItiELz50Mc8ycudhsbqlSgAnXuGmf4db8nyHpYkReDhrBO/WR9IguiFNYhqBmbXf
	bEqBKPf8vRKm6NHWIKeHousj0WdY=
X-Gm-Gg: ASbGncsB5yWv64Lq+nEyLuAjWXfSWBVt16MLIbk8RCWTEmUD9rwrDzTUd5rmTk4Yhha
	Myjq+lSPmUyYWf9287cLAfAEHrrT8Azty7+rbNPn3UVSQhA9SGviqYg==
X-Google-Smtp-Source: AGHT+IFVPRTH4y8mzjK0eMzZkHhiETzjzlAFtV1Qis7i0TvVS/vIBePAyoVEv/I7LTz09Q/A440qcgjPetERIWgm7x0=
X-Received: by 2002:a05:6402:4310:b0:5d6:48ef:c19f with SMTP id
 4fb4d7f45d1cf-5d972e708a1mr24176708a12.29.1736518361945; Fri, 10 Jan 2025
 06:12:41 -0800 (PST)
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <678125df.050a0220.216c54.0011.GAE@google.com> <CACT4Y+YKGy5a=8=HgyX38To+1yME59n9r=1pJahRVvx_n6F-Bw@mail.gmail.com>
In-Reply-To: <CACT4Y+YKGy5a=8=HgyX38To+1yME59n9r=1pJahRVvx_n6F-Bw@mail.gmail.com>
From: Pavel Begunkov <asml.silence@gmail.com>
Date: Fri, 10 Jan 2025 14:13:22 +0000
X-Gm-Features: AbW1kvYPKXj4tvDbsCyE-7zEUZjE25qflzBr8T1K6acs46DKY6Qaz7upgCvuPh8
Message-ID: <CAN-bNdcDs6aMS50Awc_tuUrtUe2-KA=5de1bT_uZbungNG0qHg@mail.gmail.com>
Subject: Re: [syzbot] [kernel?] KASAN: slab-use-after-free Read in thread_group_cputime
To: Dmitry Vyukov <dvyukov@google.com>, 
	syzbot <syzbot+3d92cfcfa84070b0a470@syzkaller.appspotmail.com>, 
	Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"

On 1/10/25 13:56, Dmitry Vyukov wrote:
> On Fri, 10 Jan 2025 at 14:51, syzbot
> <syzbot+3d92cfcfa84070b0a470@syzkaller.appspotmail.com> wrote:
>>
>> Hello,
>>
>> syzbot found the following issue on:
>>
>> HEAD commit:    ccb98ccef0e5 Merge tag 'platform-drivers-x86-v6.13-4' of g..
>> git tree:       upstream
>> console output: https://syzkaller.appspot.com/x/log.txt?x=1377fac4580000
>> kernel config:  https://syzkaller.appspot.com/x/.config?x=1c541fa8af5c9cc7
>> dashboard link: https://syzkaller.appspot.com/bug?extid=3d92cfcfa84070b0a470
>> compiler:       Debian clang version 15.0.6, GNU ld (GNU Binutils for Debian) 2.40
>>
>> Unfortunately, I don't have any reproducer for this issue yet.
>>
>> Downloadable assets:
>> disk image: https://storage.googleapis.com/syzbot-assets/6e96673b1b94/disk-ccb98cce.raw.xz
>> vmlinux: https://storage.googleapis.com/syzbot-assets/528385411880/vmlinux-ccb98cce.xz
>> kernel image: https://storage.googleapis.com/syzbot-assets/b061a4d50538/bzImage-ccb98cce.xz
>>
>> IMPORTANT: if you fix the issue, please add the following tag to the commit:
>> Reported-by: syzbot+3d92cfcfa84070b0a470@syzkaller.appspotmail.com
>>
>> ==================================================================
>> BUG: KASAN: slab-use-after-free in thread_group_cputime+0x409/0x700 kernel/sched/cputime.c:341
>> Read of size 8 at addr ffff88803578c510 by task syz.2.3223/27552
>>
>> CPU: 1 UID: 0 PID: 27552 Comm: syz.2.3223 Not tainted 6.13.0-rc5-syzkaller-00004-gccb98ccef0e5 #0
>> Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 09/13/2024
>> Call Trace:
>>   <TASK>
>>   __dump_stack lib/dump_stack.c:94 [inline]
>>   dump_stack_lvl+0x241/0x360 lib/dump_stack.c:120
>>   print_address_description mm/kasan/report.c:378 [inline]
>>   print_report+0x169/0x550 mm/kasan/report.c:489
>>   kasan_report+0x143/0x180 mm/kasan/report.c:602
>>   thread_group_cputime+0x409/0x700 kernel/sched/cputime.c:341
>>   thread_group_cputime_adjusted+0xa6/0x340 kernel/sched/cputime.c:639
>>   getrusage+0x1000/0x1340 kernel/sys.c:1863
>>   io_uring_show_fdinfo+0xdfe/0x1770 io_uring/fdinfo.c:197
>
> This looks to be more likely an io-uring issue rather than cputime.c
>
> #syz set subsystems: io-uring
>
> +maintainers

Thanks. It probably needs something like below.

diff --git a/io_uring/sqpoll.c b/io_uring/sqpoll.c
index 6df5e649c413..5768e31e99b1 100644
--- a/io_uring/sqpoll.c
+++ b/io_uring/sqpoll.c
@@ -268,8 +268,12 @@ static int io_sq_thread(void *data)
        DEFINE_WAIT(wait);

        /* offload context creation failed, just exit */
-       if (!current->io_uring)
+       if (!current->io_uring) {
+               mutex_lock(&sqd->lock);
+               sqd->thread = NULL;
+               mutex_unlock(&sqd->lock);
                goto err_out;
+       }

        snprintf(buf, sizeof(buf), "iou-sqp-%d", sqd->task_pid);
        set_task_comm(current, buf);

--
Pavel Begunkov

