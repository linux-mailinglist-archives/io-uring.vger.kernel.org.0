Return-Path: <io-uring+bounces-5598-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 97EE49FB5E3
	for <lists+io-uring@lfdr.de>; Mon, 23 Dec 2024 21:53:56 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id BDE841885946
	for <lists+io-uring@lfdr.de>; Mon, 23 Dec 2024 20:53:48 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 548CD1CEE8E;
	Mon, 23 Dec 2024 20:53:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=purestorage.com header.i=@purestorage.com header.b="gYmBetze"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pj1-f44.google.com (mail-pj1-f44.google.com [209.85.216.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 59BDA1B5823
	for <io-uring@vger.kernel.org>; Mon, 23 Dec 2024 20:53:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734987192; cv=none; b=XFGZtqTooJUjuz139cgMaFqq2sjhlFqL2jcsW85x4TgwCvST5+tVRvXr6oQqUrfg4pCz9apiG3HyuZf/qtumP5GtqZYYjVh9tnfn3sIyC/SRMV/Ow8TJ2ZhhnbaEJ1g05hnDFFkXqG+wFPMfUz6kBB2PFdqDBeZJMPGUgEy71S8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734987192; c=relaxed/simple;
	bh=TWJ9TzS1vI0IQ5rlA53vuVQ/LGtGL4sU1Q5sYw066PU=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=RmVB7bCR8TV9n1xXHhZCXc0jiaDXneRdowQAikpyLVETBT3zHPMQZlpFXzUzYDWISSmZFk5W+r+FjOK8jFRJ5TjjA9qr+HEoGB25VhLJTrfnNcMQkbzxD70nryj9kROzGtDI6a1+UJN5WvsI2wvStliKPexaLhPdeY0J00ZrB34=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=purestorage.com; spf=fail smtp.mailfrom=purestorage.com; dkim=pass (2048-bit key) header.d=purestorage.com header.i=@purestorage.com header.b=gYmBetze; arc=none smtp.client-ip=209.85.216.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=purestorage.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=purestorage.com
Received: by mail-pj1-f44.google.com with SMTP id 98e67ed59e1d1-2ee8ecb721dso802249a91.3
        for <io-uring@vger.kernel.org>; Mon, 23 Dec 2024 12:53:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=purestorage.com; s=google2022; t=1734987189; x=1735591989; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=0Nhj9knVFWKgfOyDcQ4dW41LW41FRJnmwV/sgtvm0OE=;
        b=gYmBetze9bEvsnkrc0cykzhk8IAAYcW8+4jmY96671e/AOqrIgKxnRDR1qw0Je8oeo
         8A8XvuR265K3l96bqnz89NDUrAXNqi+Sf/mocrxzJb7Toy2s4m6EY+TM+jOKmcFOO4kT
         MKGjJ9vnyb33ynuMpJEFCaMsdEC2l0eMqZi0K0qRwYOqyLssB4kgfdjnRIF+FrV7jNjQ
         e3DBAqUGtyG2jkvjbjgtgQgnd14843lMOfxsfJpZeUiEk9wSEj32mCf5aIxaOqkf0pCp
         VWz4dBpmh2TEJv7zdkZH8mwJm6cjrQg24XvruyMKvOIt+T+VqrYNUqS471B3SlNv8oKG
         LP3Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1734987189; x=1735591989;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=0Nhj9knVFWKgfOyDcQ4dW41LW41FRJnmwV/sgtvm0OE=;
        b=ZfReS/J12/4HwCrB0P+ZuZwh1bewlLPV9NSdU5n3wNtAowleCqHmHcMi1ImvLfrtPz
         YrvuryngFObmQATKrJUbmNvXccarahE+hGNooFyNxlaO4ISWIfdDy6Y7uaOtjUD0gR14
         TxR8DpQ5t+Kt2GE9aQWvcSK8iXVaCp0Ads7H+W0AU7mZMMopiMHdEIbobIFuGpHm0s6l
         I1/eBicQiX1nnld0p7Mp7A5bRPPN4GQGZiBzrx+SVaHMje2q87c0aC2wvq9zao8MW2XP
         0TI+RsEuxLvi3qQqlRwcnrz5aRq4wfZVr58wOlFw5MMqrllk48PecIscLJsH3ngzmob3
         rC6g==
X-Forwarded-Encrypted: i=1; AJvYcCXnniQSwHbK+duel0cKvkY+W+gIM70MfAuWZdCqWgAbWK1ZujpIDRzWtOJl1m7esgCNkLHMlIcn/Q==@vger.kernel.org
X-Gm-Message-State: AOJu0Yy4HPnW48w7TiwWXhsaFdBDEp1IvU0IepYB+fey41lZBwuV/74v
	bnXFpeKoyY2+vO5GlESSV1Bm785X4bNFSaQx3p171cC5vf+zlOXKQoZha1LspW7PmL6nwizNAVo
	CICcSA9kv/tAT1VnhOa/ojDo6iErdJuuZLGgaSg==
X-Gm-Gg: ASbGncs2hpOaO9uvH3m0/3SLgmkFA2CdRez9Ai/j+y4u+X2CRh/Wunswtxv9ghUqaza
	VCl0Mha5A/XyhxbMFyAItlQIzsfLdBk8wHoq3Z8I=
X-Google-Smtp-Source: AGHT+IEwNYCz/q03cvl0NmtG4zb4kLejw2dkqOB7byKTe0SGTZPM1XYnnV5uCQbPfb5f49c+qAMeH5NQ/7BzxSQo2Lo=
X-Received: by 2002:a17:90b:1345:b0:2ee:cbc9:d50b with SMTP id
 98e67ed59e1d1-2f452eac10amr8154667a91.4.1734987189478; Mon, 23 Dec 2024
 12:53:09 -0800 (PST)
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <6769bf7b.050a0220.226966.0041.GAE@google.com> <2f80272f-6cab-489d-ba2b-c1d545ac3485@kernel.dk>
In-Reply-To: <2f80272f-6cab-489d-ba2b-c1d545ac3485@kernel.dk>
From: Caleb Sander <csander@purestorage.com>
Date: Mon, 23 Dec 2024 12:52:58 -0800
Message-ID: <CADUfDZqtiT8B_LvTRuzT9QB+7z+7pNqYJd_n2gQYK1d8cKkxqA@mail.gmail.com>
Subject: Re: [syzbot] [io-uring?] BUG: unable to handle kernel NULL pointer
 dereference in percpu_ref_put_many
To: Jens Axboe <axboe@kernel.dk>
Cc: syzbot <syzbot+3dcac84cc1d50f43ed31@syzkaller.appspotmail.com>, 
	asml.silence@gmail.com, io-uring@vger.kernel.org, 
	linux-kernel@vger.kernel.org, syzkaller-bugs@googlegroups.com, 
	"linux-nvme@lists.infradead.org" <linux-nvme@lists.infradead.org>, Hannes Reinecke <hare@suse.de>, 
	Sagi Grimberg <sagi@grimberg.me>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

This is probably the same bug that is being addressed by
https://lore.kernel.org/lkml/20241218185000.17920-2-leocstone@gmail.com/T/

On Mon, Dec 23, 2024 at 12:35=E2=80=AFPM Jens Axboe <axboe@kernel.dk> wrote=
:
>
> On 12/23/24 12:52 PM, syzbot wrote:
> > Hello,
> >
> > syzbot found the following issue on:
> >
> > HEAD commit:    eabcdba3ad40 Merge tag 'for-6.13-rc3-tag' of git://git.=
ker..
> > git tree:       upstream
> > console output: https://syzkaller.appspot.com/x/log.txt?x=3D10871f44580=
000
> > kernel config:  https://syzkaller.appspot.com/x/.config?x=3Dc22efbd20f8=
da769
> > dashboard link: https://syzkaller.appspot.com/bug?extid=3D3dcac84cc1d50=
f43ed31
> > compiler:       gcc (Debian 12.2.0-14) 12.2.0, GNU ld (GNU Binutils for=
 Debian) 2.40
> > syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=3D141bccf85=
80000
> > C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=3D135f7730580=
000
>
> I ran this one but his this instead:
>
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> BUG: KASAN: slab-out-of-bounds in nvmet_root_discovery_nqn_store+0x110/0x=
180
> Write of size 256 at addr ffff000009e71180 by task refcrash/775
>
> CPU: 0 UID: 0 PID: 775 Comm: refcrash Not tainted 6.13.0-rc4 #2
> Hardware name: linux,dummy-virt (DT)
> Call trace:
>  show_stack+0x1c/0x30 (C)
>  __dump_stack+0x24/0x30
>  dump_stack_lvl+0x60/0x80
>  print_address_description+0x88/0x220
>  print_report+0x4c/0x60
>  kasan_report+0x94/0xf0
>  kasan_check_range+0x248/0x288
>  __asan_memset+0x30/0x60
>  nvmet_root_discovery_nqn_store+0x110/0x180
>  configfs_write_iter+0x220/0x2e8
>  do_iter_readv_writev+0x2e0/0x458
>  vfs_writev+0x220/0x728
>  do_writev+0xf8/0x1a8
>  __arm64_sys_writev+0x80/0x98
>  invoke_syscall+0x7c/0x258
>  el0_svc_common+0x108/0x1d0
>  do_el0_svc+0x4c/0x60
>  el0_svc+0x4c/0xa0
>  el0t_64_sync_handler+0x70/0x100
>  el0t_64_sync+0x170/0x178
>
> Allocated by task 1:
>  kasan_save_track+0x2c/0x60
>  kasan_save_alloc_info+0x3c/0x48
>  __kasan_kmalloc+0x80/0x98
>  __kmalloc_node_track_caller_noprof+0x2f0/0x590
>  kstrndup+0x4c/0xb8
>  nvmet_subsys_alloc+0x1c4/0x498
>  nvmet_init_discovery+0x20/0x48
>  nvmet_init+0x18c/0x1c0
>  do_one_initcall+0x1a4/0x718
>  do_initcall_level+0x178/0x348
>  do_initcalls+0x58/0xa0
>  do_basic_setup+0x7c/0x98
>  kernel_init_freeable+0x268/0x380
>  kernel_init+0x24/0x148
>  ret_from_fork+0x10/0x20
>
> The buggy address belongs to the object at ffff000009e71180
>  which belongs to the cache kmalloc-64 of size 64
> The buggy address is located 0 bytes inside of
>  allocated 37-byte region [ffff000009e71180, ffff000009e711a5)
>
> The buggy address belongs to the physical page:
> page: refcount:1 mapcount:0 mapping:0000000000000000 index:0x0 pfn:0x49e7=
1
> anon flags: 0x3ffe00000000000(node=3D0|zone=3D0|lastcpupid=3D0x1fff)
> page_type: f5(slab)
> raw: 03ffe00000000000 ffff0000070028c0 fffffdffc0523d80 dead000000000005
> raw: 0000000000000000 0000000000200020 00000001f5000000 0000000000000000
> page dumped because: kasan: bad access detected
>
> Memory state around the buggy address:
>  ffff000009e71080: 00 00 00 00 00 00 00 00 fc fc fc fc fc fc fc fc
>  ffff000009e71100: 00 00 00 00 00 00 00 fc fc fc fc fc fc fc fc fc
> >ffff000009e71180: 00 00 00 00 05 fc fc fc fc fc fc fc fc fc fc fc
> Zero length message leads to an empty skb
>                                ^
>  ffff000009e71200: 00 00 00 00 00 00 00 00 fc fc fc fc fc fc fc fc
>  ffff000009e71280: 00 00 00 00 00 00 00 00 fc fc fc fc fc fc fc fc
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> Disabling lock debugging due to kernel taint
>
> which makes me think something else is the culprit here. The test case
> doesn't do much outside of creating two rings, it doesn't actually use
> them.
>
> CC'ing likely suspects on the nvme front. This is on 6.13-rc4 fwiw.
>
> --
> Jens Axboe
>

