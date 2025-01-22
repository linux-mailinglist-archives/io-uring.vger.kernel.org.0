Return-Path: <io-uring+bounces-6042-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 2C5B2A192F4
	for <lists+io-uring@lfdr.de>; Wed, 22 Jan 2025 14:51:23 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 5D253188D7C0
	for <lists+io-uring@lfdr.de>; Wed, 22 Jan 2025 13:51:23 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C9A9A1E4AB;
	Wed, 22 Jan 2025 13:51:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="hSSmsHHi"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-wr1-f47.google.com (mail-wr1-f47.google.com [209.85.221.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CDEDE2135A8
	for <io-uring@vger.kernel.org>; Wed, 22 Jan 2025 13:51:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737553868; cv=none; b=CyhfXCGiq3Iqx3mEF2JRHikOmnBbZpUTo0z0HErcnVMtaDPC82VXAo1kGAagbxhkCok9ju9rNG+GWdRYGH9tzSQiCB+o9yfDGzFYcDgDt89zgifJDKMpkS+YzfhkdiqwVMAvfmZsQLP0J4QPY7RKlxNi5P6rpta5nuzqCUp583A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737553868; c=relaxed/simple;
	bh=WwNffDyTpn5l7pNJxB7XpfD1sNbIY0eMqdXVedc72pk=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=BnF5fPVOBCrZJX0v7IJAU9jm54PpsLqf2JdUprdoi0lKcM/K7EXhj5AbpABI+LcHvGSsS6RipWqJraHL13ZiRa3nrBkPwdgK7JYSunqounsc0qBQphpuSBpNtEaok0ZcfUKx3IYKe3Y/zkbAGCyOJmZlC73hLRmr/9myHE+o/38=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=hSSmsHHi; arc=none smtp.client-ip=209.85.221.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-wr1-f47.google.com with SMTP id ffacd0b85a97d-3862c78536bso341412f8f.2
        for <io-uring@vger.kernel.org>; Wed, 22 Jan 2025 05:51:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1737553865; x=1738158665; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=zVX2FJ2hCr5swG6CFbz13/hPQt22h2FbZGX8nYTRstg=;
        b=hSSmsHHimzX6bCUzukAAdbj9GRq4EL0c5e8bYX6o2SKW0uwIlSqYDIQ3VkIBpwGri9
         bFF2e3o7QB8NJq+XigPmGBDHVfbASvCjrnj4qfLS3Z9cocqiMvXHxEvCBEMpAN3EyYnc
         ubh9+LDgd09/uzmoAWKKyxEBciN4Nsh8+XQI144q/qiLqR+Z8MMMWQdm1fB4mcvE/nGV
         srBrNvwOvmKaVHgs2EA4h+iqtKdc6fyuf+nF1aPB/GXcyHX1fF+dw5iWZhkEdgU8cVkN
         iSfWIinyzDg490ZgrIxVH9clAD5JAxQwKm0J0s8B0d9hy7sIb8isQsWNjXUvKA9Gmu/Q
         juOA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1737553865; x=1738158665;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=zVX2FJ2hCr5swG6CFbz13/hPQt22h2FbZGX8nYTRstg=;
        b=TijHiYRN51fne3mKsUw/V0Fr/1kvMe5+pUTFxV64Q9yRtpAZJAfcZbGzPVmdKHSpXZ
         qPXptuxmG27jMFUW5eExy8Iea4BzOrGc3d/0XgF4av1OT2gOngh9/mrc/+0CJ+rojJ0c
         1omJDeJ/bY1j4hoJZiC/+l7WXcU3AjVnFx44kJockmcORaW2RQoYgzgSUWk2O1I6RsVd
         tDJXn/bDM9UTnx2HLJODzpBm8p89tGgfH+ln44/26brHR49x03Zs58okxZ9biRN10Z4d
         SY6k+KjFGkNNu48fFBOQf1H+TJlOTczeroyNOUNsfq2hAp/o5wIzBON8e7SUQYhuG/zp
         nmCA==
X-Forwarded-Encrypted: i=1; AJvYcCU2gc2Yc1/Q5It1gQBHLkhmiteossVt3a/C4jLg8qapXTZu8CJTkrJNtHdB+h3cbZtDELmqaRoS1g==@vger.kernel.org
X-Gm-Message-State: AOJu0YxUTAUJd0sDgF4Z5EYoISr5kHckoWdOqUWxaxeUMZw/skOvWjcf
	xVNwVqOPC7tB0gxwpkmxlZ7IsxzdwNBCH+QGbXb19IMDgsHXuCm6qzhhQtyS20BCFT32j9CQdJ3
	RKbyHHvX2MtBnoCUgfN5/NtDtmvU=
X-Gm-Gg: ASbGncuhjZFN1RTLJBVwLy+va5ogR0pN73L62X6yU4RZeTwediGeeV0wPDEWStUHpHW
	VrKjF6Q1hdthJc2qsK/5iXOPlTyvAf2/WjW+klBpD1+FP539xoLqOkpDksV3l2DHks8CglquTuD
	7Q9HUZdj4So/BDF1Ac
X-Google-Smtp-Source: AGHT+IG7kF++06UO3VS6y6oI6g/IIKgNnz7ft8/xBBfb7wwOwNPItOTgMnwum+wAp3Qd9ADUgiwmaVuhHYz+sSkHEQE=
X-Received: by 2002:a5d:47c5:0:b0:38a:8784:9137 with SMTP id
 ffacd0b85a97d-38bf57a8f56mr7575141f8f.9.1737553864742; Wed, 22 Jan 2025
 05:51:04 -0800 (PST)
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <ec2a6ca08c614c10853fbb1270296ac4@huawei.com> <98125b67-7b63-427f-b822-a12779d50a13@kernel.dk>
 <c14929fc328f43baa7ac2ad8f85a8f2b@huawei.com>
In-Reply-To: <c14929fc328f43baa7ac2ad8f85a8f2b@huawei.com>
From: Andrey Ryabinin <ryabinin.a.a@gmail.com>
Date: Wed, 22 Jan 2025 14:49:51 +0100
X-Gm-Features: AWEUYZmZpJb_nJXGrc0VFB4A-A68-6fMudm0dEEboziQ_Zudc-pl8fDXoa4w9hg
Message-ID: <CAPAsAGwzBeGXbVtWtZKhbUDbD4b4PtgAS9MJYU2kkiNHgyKpfQ@mail.gmail.com>
Subject: Re: KASAN reported an error while executing accept-reust.t testcase
To: lizetao <lizetao1@huawei.com>
Cc: Jens Axboe <axboe@kernel.dk>, io-uring <io-uring@vger.kernel.org>, 
	Pavel Begunkov <asml.silence@gmail.com>, 
	"juntong.deng@outlook.com" <juntong.deng@outlook.com>, 
	"kasan-dev@googlegroups.com" <kasan-dev@googlegroups.com>, Andrey Konovalov <andreyknvl@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Sun, Jan 12, 2025 at 7:45=E2=80=AFAM lizetao <lizetao1@huawei.com> wrote=
:
>
> Hi,
>
> > -----Original Message-----
> > From: Jens Axboe <axboe@kernel.dk>
> > Sent: Sunday, January 12, 2025 1:13 AM
> > To: lizetao <lizetao1@huawei.com>; io-uring <io-uring@vger.kernel.org>
> > Cc: Pavel Begunkov <asml.silence@gmail.com>
> > Subject: Re: KASAN reported an error while executing accept-reust.t tes=
tcase
> >
> > On 1/11/25 7:07 AM, lizetao wrote:
> > > Hi all,
> > >
> > > When I run the testcase liburing/accept-reust.t with CONFIG_KASAN=3Dy
> > > and CONFIG_KASAN_EXTRA_INFO=3Dy, I got a error reported by KASAN:
> >
> > Looks more like you get KASAN crashing...
> >
> > > Unable to handle kernel paging request at virtual address
> > > 00000c6455008008 Mem abort info:
> > >   ESR =3D 0x0000000096000004
> > >   EC =3D 0x25: DABT (current EL), IL =3D 32 bits
> > >   SET =3D 0, FnV =3D 0
> > >   EA =3D 0, S1PTW =3D 0
> > >   FSC =3D 0x04: level 0 translation fault Data abort info:
> > >   ISV =3D 0, ISS =3D 0x00000004, ISS2 =3D 0x00000000
> > >   CM =3D 0, WnR =3D 0, TnD =3D 0, TagAccess =3D 0
> > >   GCS =3D 0, Overlay =3D 0, DirtyBit =3D 0, Xs =3D 0 user pgtable: 4k=
 pages,
> > > 48-bit VAs, pgdp=3D00000001104c5000 [00000c6455008008]
> > > pgd=3D0000000000000000, p4d=3D0000000000000000 Internal error: Oops:
> > > 0000000096000004 [#1] PREEMPT SMP Modules linked in:
> > > CPU: 6 UID: 0 PID: 352 Comm: kworker/u128:5 Not tainted
> > > 6.13.0-rc6-g0a2cb793507d #5 Hardware name: linux,dummy-virt (DT)
> > > Workqueue: iou_exit io_ring_exit_work
> > > pstate: 10000005 (nzcV daif -PAN -UAO -TCO -DIT -SSBS BTYPE=3D--) pc =
:
> > > __kasan_mempool_unpoison_object+0x38/0x170
> > > lr : io_netmsg_cache_free+0x8c/0x180
> > > sp : ffff800083297a90
> > > x29: ffff800083297a90 x28: ffffd4d7f67e88e4 x27: 0000000000000003
> > > x26: 1fffe5958011502e x25: ffff2cabff976c18 x24: 1fffe5957ff2ed83
> > > x23: ffff2cabff976c10 x22: 00000c6455008000 x21: 0002992540200001
> > > x20: 0000000000000000 x19: 00000c6455008000 x18: 00000000489683f8
> > > x17: ffffd4d7f68006ac x16: ffffd4d7f67eb3e0 x15: ffffd4d7f67e88e4
> > > x14: ffffd4d7f766deac x13: ffffd4d7f6619030 x12: ffff7a9b012e3e26
> > > x11: 1ffffa9b012e3e25 x10: ffff7a9b012e3e25 x9 : ffffd4d7f766debc
> > > x8 : ffffd4d80971f128 x7 : 0000000000000001 x6 : 00008564fed1c1db
> > > x5 : ffffd4d80971f128 x4 : ffff7a9b012e3e26 x3 : ffff2cabff976c00
> > > x2 : ffffc1ffc0000000 x1 : 0000000000000000 x0 : 0002992540200001 Cal=
l
> > > trace:
> > >  __kasan_mempool_unpoison_object+0x38/0x170 (P)
> > >  io_netmsg_cache_free+0x8c/0x180
> > >  io_ring_exit_work+0xd4c/0x13a0
> > >  process_one_work+0x52c/0x1000
> > >  worker_thread+0x830/0xdc0
> > >  kthread+0x2bc/0x348
> > >  ret_from_fork+0x10/0x20
> > > Code: aa0003f5 aa0103f4 8b131853 aa1303f6 (f9400662) ---[ end trace
> > > 0000000000000000 ]---
> > >
> > >
> > > I preliminary analyzed the accept and connect code logic. In the
> > > accept-reuse.t testcase, kmsg->free_iov is not used, so when calling
> > > io_netmsg_cache_free(), the
> > > kasan_mempool_unpoison_object(kmsg->free_iov...) path should not be
> > > executed.
> > >
> > >
> > > I used the hardware watchpoint to capture the first scene of modifyin=
g kmsg-
> > >free_iov:
> > >
> > > Thread 3 hit Hardware watchpoint 7: *0xffff0000ebfc5410 Old value =3D=
 0
> > > New value =3D -211812350 kasan_set_track (stack=3D<optimized out>,
> > > track=3D<optimized out>) at ./arch/arm64/include/asm/current.h:21
> > > 21          return (struct task_struct *)sp_el0;
> > >
> > > # bt
> > > kasan_set_track
> > > kasan_save_track
> > > kasan_save_free_info
> > > poison_slab_object
> > > __kasan_mempool_poison_object
> > > kasan_mempool_poison_object
> > > io_alloc_cache_put
> > > io_netmsg_recycle
> > > io_req_msg_cleanup
> > > io_connect
> > > io_issue_sqe
> > > io_queue_sqe
> > > io_req_task_submit
> > > ...
> > >
> > >
> > > It's a bit strange. It was modified by KASAN. I can't understand this=
.
> > > Maybe I missed something? Please let me know. Thanks.
> >
> > Looks like KASAN with the extra info ends up writing to io_async_msghdr=
-
> > >free_iov somehow. No idea... For the test case in question, ->free_iov=
 should
> > be NULL when initially allocated, and the io_uring code isn't storing t=
o it. Yet
> > it's non-NULL when you later go and free it, after calling
> > kasan_mempool_poison_object().
>
> I also think so and would Juntong and Ryabinin or others KASAN developers=
 be interested
> In this problem?
>

Hi, thanks for reporting.
KASAN stores some info about freed slab object in the object itself
until it is reallocated or the slab page is released.
And since the  b556a462eb8d ("kasan: save free stack traces for slab
mempools") we do the same thing in kasan_mempool_poison_object().
In the most use cases this wasn't the problem, because callers expect
uninitialized objects from mempool.

However, this isn't the case for io_alloc_cache. AFAICS io_uring code
expects that io_alloc_cache_put/get leaves objects unmodified.
So I'm thinking we'd need to add some parameter to the
kasan_mempool_poison_object() to avoid modifying objects.

