Return-Path: <io-uring+bounces-5801-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 3202FA09318
	for <lists+io-uring@lfdr.de>; Fri, 10 Jan 2025 15:14:27 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 22518188E18E
	for <lists+io-uring@lfdr.de>; Fri, 10 Jan 2025 14:14:09 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1780C20FAB2;
	Fri, 10 Jan 2025 14:13:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="BiLqDGDg"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-io1-f45.google.com (mail-io1-f45.google.com [209.85.166.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1548B20FAA4
	for <io-uring@vger.kernel.org>; Fri, 10 Jan 2025 14:13:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736518436; cv=none; b=pe9u8yhlgG6ctxe2jUfJguiHxXKDmdbEdAoxJsrOK1B9V5mTnqKGlj9cOLNBr/RuBO4XUdzl7551jwp+/W1s7dCwaj8Ro6ESBpSHqrQHf9sIynpjSJ2q8IQLD941Spj9Qit9+X334KQkDSbA5Xj2xqo0MPPnAQNPKJwI9W/fycA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736518436; c=relaxed/simple;
	bh=GqXiZC8Q03fXEhTNC5E+HAxJzyGu+PEpWyQpAb0infQ=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=C/KpJz4wqqCdBJrvCeh2mkJwEqBwdN3zoZwTEqBQz9vQMofBlsz9H8UHeDWSh/6GRHv4p8+KJkeoAk1OCbIZDmJ8m1Oc4EXfmoX03elZvBEvYyrNJ65ufxOvwoZFd93kaZxEc5pKD0k3GLn/hf81jDZmZS9ZQKr/Wxg4QVWqRjk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=BiLqDGDg; arc=none smtp.client-ip=209.85.166.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-io1-f45.google.com with SMTP id ca18e2360f4ac-844bff5ba1dso136096839f.1
        for <io-uring@vger.kernel.org>; Fri, 10 Jan 2025 06:13:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1736518431; x=1737123231; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=KCVfqNYWcHSv0lxlvLw+6Ijrxf3JTr98ENM4vgw9N3I=;
        b=BiLqDGDgjIEU9g58KCRTp3KvcpBpKXqwuDA2KtekaIvlwrBm6Xm9SiEWeXn3zZh64y
         q8HVeng/mPrVOGg2ZAqEdT5zPEO4AZ2lbfdiwQtnuC1L5v1U3YSpmngthpEuJ6z0kdBr
         lbRfLcHLvZLSxRywLes4wUFzilhfVlGZB+v3L5rreJTsBlwMBSQnZ8NmXMw6sHMLgE+P
         OTIsZuIpGZGe7SXGQRc2v97PUWGxCeoWn/ZEVKzTUt3AQi1w9Dd6jkjCMzyzUTKuqMnX
         vAzZSZXwUk96L8g+ayiB7w5eTDNcPTKKYnaJ6ctXMtMTopJT2ZZItEHhMwRAw5uKwfr7
         GCPg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1736518431; x=1737123231;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=KCVfqNYWcHSv0lxlvLw+6Ijrxf3JTr98ENM4vgw9N3I=;
        b=pAl5gSx0yu3tP55pmNFFrM9kh4zNssBzcvfWfaLeYrEWKIkjAMz4ZIcXdP5xbHjDUS
         PO0jDuejHsmISDMzIxSxtt7e+wBDj3U6BiinsN/86WhVLETNQQCmMkQzSXwyDIAdccPQ
         RU1WC0+G6n/vuLZ01T8gN7RBzpIufnWgM8LnK7tbZ2i+0mHzRXCd/DjWtTphMkgb7MMi
         r6Ntdz+KGY+bzXtK5LkWy8tHdpJKfSXqIL4BRN98Cnsi99TeAUML/IYy3aQflE9yTnAs
         ToWHUKvz0THVpj9o+lDHl0Vi1PBVgKPTPpsYZ7WEvo+1urkeGKuVuktq4b1uhZWM0aDr
         Giaw==
X-Forwarded-Encrypted: i=1; AJvYcCXUETYOo2Id9EMb++7TjHfsUAZREBJoPhvxEHq4pFdaewZuRuDkujj2GkQ5lVc9cficPoiAS5jkOg==@vger.kernel.org
X-Gm-Message-State: AOJu0YwbYHPa4vrDp2S/Z0oW9SA8nVEYq+g2utZwUCikzNwldljsvcot
	Amjs1oQ19p7vuAnOELlpHd4GP6kCKKbM/JdB5onkxnZd1NTC7Hg6k3I0/DabjbU=
X-Gm-Gg: ASbGncurClivteFRnWRcj58DvNZeJ7LIzdCOAAQkumbV1D++tgHFPB2dcstX212A3BK
	9f3MY4qhU6aJRRrmKgPJ4dOJ3CcYGoUCQTnpAHFiAxcCkUaKy4h8xtgBvXxMdoMXtop0SNmKELT
	PNHr5Ht5wm2yEemuNGWnZTE9XR6Mb6UBynT0c47UJtnfH/k0+GZpOrux9UU/QCMZg9McLHhtMQM
	cASFJ7P3ctB5Px1MOMKWt7sHBOxRh4uKwPUSf3VgZ2PcqsNyJic
X-Google-Smtp-Source: AGHT+IG2ilqqYkzZpubOsfcVTdLTgfrGPfLYExv41dgo1hTyaTstWZtQSTyawT7LoU4MeERWklR6ag==
X-Received: by 2002:a05:6e02:1f02:b0:3a7:c5b1:a55e with SMTP id e9e14a558f8ab-3ce3a7a8aa1mr88181845ab.0.1736518430882;
        Fri, 10 Jan 2025 06:13:50 -0800 (PST)
Received: from [192.168.1.116] ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id 8926c6da1cb9f-4ea1b717903sm909606173.84.2025.01.10.06.13.50
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 10 Jan 2025 06:13:50 -0800 (PST)
Message-ID: <8bcf5df2-91b9-4675-8305-77aa7ad999c8@kernel.dk>
Date: Fri, 10 Jan 2025 07:13:49 -0700
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [syzbot] [kernel?] KASAN: slab-use-after-free Read in
 thread_group_cputime
To: Pavel Begunkov <asml.silence@gmail.com>,
 Dmitry Vyukov <dvyukov@google.com>,
 syzbot <syzbot+3d92cfcfa84070b0a470@syzkaller.appspotmail.com>,
 io-uring@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, syzkaller-bugs@googlegroups.com
References: <678125df.050a0220.216c54.0011.GAE@google.com>
 <CACT4Y+YKGy5a=8=HgyX38To+1yME59n9r=1pJahRVvx_n6F-Bw@mail.gmail.com>
 <CAN-bNdcDs6aMS50Awc_tuUrtUe2-KA=5de1bT_uZbungNG0qHg@mail.gmail.com>
Content-Language: en-US
From: Jens Axboe <axboe@kernel.dk>
In-Reply-To: <CAN-bNdcDs6aMS50Awc_tuUrtUe2-KA=5de1bT_uZbungNG0qHg@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 1/10/25 7:13 AM, Pavel Begunkov wrote:
> On 1/10/25 13:56, Dmitry Vyukov wrote:
>> On Fri, 10 Jan 2025 at 14:51, syzbot
>> <syzbot+3d92cfcfa84070b0a470@syzkaller.appspotmail.com> wrote:
>>>
>>> Hello,
>>>
>>> syzbot found the following issue on:
>>>
>>> HEAD commit:    ccb98ccef0e5 Merge tag 'platform-drivers-x86-v6.13-4' of g..
>>> git tree:       upstream
>>> console output: https://syzkaller.appspot.com/x/log.txt?x=1377fac4580000
>>> kernel config:  https://syzkaller.appspot.com/x/.config?x=1c541fa8af5c9cc7
>>> dashboard link: https://syzkaller.appspot.com/bug?extid=3d92cfcfa84070b0a470
>>> compiler:       Debian clang version 15.0.6, GNU ld (GNU Binutils for Debian) 2.40
>>>
>>> Unfortunately, I don't have any reproducer for this issue yet.
>>>
>>> Downloadable assets:
>>> disk image: https://storage.googleapis.com/syzbot-assets/6e96673b1b94/disk-ccb98cce.raw.xz
>>> vmlinux: https://storage.googleapis.com/syzbot-assets/528385411880/vmlinux-ccb98cce.xz
>>> kernel image: https://storage.googleapis.com/syzbot-assets/b061a4d50538/bzImage-ccb98cce.xz
>>>
>>> IMPORTANT: if you fix the issue, please add the following tag to the commit:
>>> Reported-by: syzbot+3d92cfcfa84070b0a470@syzkaller.appspotmail.com
>>>
>>> ==================================================================
>>> BUG: KASAN: slab-use-after-free in thread_group_cputime+0x409/0x700 kernel/sched/cputime.c:341
>>> Read of size 8 at addr ffff88803578c510 by task syz.2.3223/27552
>>>
>>> CPU: 1 UID: 0 PID: 27552 Comm: syz.2.3223 Not tainted 6.13.0-rc5-syzkaller-00004-gccb98ccef0e5 #0
>>> Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 09/13/2024
>>> Call Trace:
>>>   <TASK>
>>>   __dump_stack lib/dump_stack.c:94 [inline]
>>>   dump_stack_lvl+0x241/0x360 lib/dump_stack.c:120
>>>   print_address_description mm/kasan/report.c:378 [inline]
>>>   print_report+0x169/0x550 mm/kasan/report.c:489
>>>   kasan_report+0x143/0x180 mm/kasan/report.c:602
>>>   thread_group_cputime+0x409/0x700 kernel/sched/cputime.c:341
>>>   thread_group_cputime_adjusted+0xa6/0x340 kernel/sched/cputime.c:639
>>>   getrusage+0x1000/0x1340 kernel/sys.c:1863
>>>   io_uring_show_fdinfo+0xdfe/0x1770 io_uring/fdinfo.c:197
>>
>> This looks to be more likely an io-uring issue rather than cputime.c
>>
>> #syz set subsystems: io-uring
>>
>> +maintainers
> 
> Thanks. It probably needs something like below.
> 
> diff --git a/io_uring/sqpoll.c b/io_uring/sqpoll.c
> index 6df5e649c413..5768e31e99b1 100644
> --- a/io_uring/sqpoll.c
> +++ b/io_uring/sqpoll.c
> @@ -268,8 +268,12 @@ static int io_sq_thread(void *data)
>         DEFINE_WAIT(wait);
> 
>         /* offload context creation failed, just exit */
> -       if (!current->io_uring)
> +       if (!current->io_uring) {
> +               mutex_lock(&sqd->lock);
> +               sqd->thread = NULL;
> +               mutex_unlock(&sqd->lock);
>                 goto err_out;
> +       }
> 
>         snprintf(buf, sizeof(buf), "iou-sqp-%d", sqd->task_pid);
>         set_task_comm(current, buf);

Indeed - can you send that out and I can include it in this weeks pull?

-- 
Jens Axboe


