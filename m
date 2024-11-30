Return-Path: <io-uring+bounces-5161-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id E417A9DF353
	for <lists+io-uring@lfdr.de>; Sat, 30 Nov 2024 22:40:58 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 9B135162C93
	for <lists+io-uring@lfdr.de>; Sat, 30 Nov 2024 21:40:55 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AEFC51AB6F7;
	Sat, 30 Nov 2024 21:40:51 +0000 (UTC)
X-Original-To: io-uring@vger.kernel.org
Received: from eu-smtp-delivery-151.mimecast.com (eu-smtp-delivery-151.mimecast.com [185.58.85.151])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8D0401AA1E0
	for <io-uring@vger.kernel.org>; Sat, 30 Nov 2024 21:40:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=185.58.85.151
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733002851; cv=none; b=JBlU9Qn6Bk0yoPUHGIz2UjgYmqh7IFCqLX8HDahK4X0AfyjATqhzfgBj+lNX3wteLuJdsJeZ7c1f0XL2gtx5idtw08wT3QQCd46/H4Ec+1WoyNzL2GQS9+iBjDQCRjSdmaWpUMppHCkovMPTI5j91oxeHtV+jtruKSx/ZbFUdoA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733002851; c=relaxed/simple;
	bh=D5xcJAsDkXmo34++46K3Zh1aU9K5vOZ0aFsvamdr0Ys=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 MIME-Version:Content-Type; b=e6TSX4qFd/Nb4YZBM27q6uUeuIvF06lBIV3uUy60t99VwcAXeUWQKrlCSAo9pZ9oGCGfWqob8J2SJqT6wO9QRe73k+we1m2QmMk5WFSRTM9h7ivBpk2W5y6LRzjoHi2jFzKElm57wxZSj4qPsX9JoX5G5rEHpMcnaychvJptTvI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=ACULAB.COM; spf=pass smtp.mailfrom=aculab.com; arc=none smtp.client-ip=185.58.85.151
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=ACULAB.COM
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=aculab.com
Received: from AcuMS.aculab.com (156.67.243.121 [156.67.243.121]) by
 relay.mimecast.com with ESMTP with both STARTTLS and AUTH (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 uk-mta-188-g14xKN3oMnyOJnv5xybuBA-1; Sat, 30 Nov 2024 21:40:38 +0000
X-MC-Unique: g14xKN3oMnyOJnv5xybuBA-1
X-Mimecast-MFC-AGG-ID: g14xKN3oMnyOJnv5xybuBA
Received: from AcuMS.Aculab.com (10.202.163.4) by AcuMS.aculab.com
 (10.202.163.4) with Microsoft SMTP Server (TLS) id 15.0.1497.48; Sat, 30 Nov
 2024 21:40:14 +0000
Received: from AcuMS.Aculab.com ([::1]) by AcuMS.aculab.com ([::1]) with mapi
 id 15.00.1497.048; Sat, 30 Nov 2024 21:40:14 +0000
From: David Laight <David.Laight@ACULAB.COM>
To: 'Kees Cook' <kees@kernel.org>, Eric Biederman <ebiederm@xmission.com>
CC: Linus Torvalds <torvalds@linux-foundation.org>, Alexander Viro
	<viro@zeniv.linux.org.uk>, Christian Brauner <brauner@kernel.org>, Jan Kara
	<jack@suse.cz>, "linux-mm@kvack.org" <linux-mm@kvack.org>,
	"linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>, Ingo Molnar
	<mingo@redhat.com>, Peter Zijlstra <peterz@infradead.org>, Juri Lelli
	<juri.lelli@redhat.com>, Vincent Guittot <vincent.guittot@linaro.org>,
	Dietmar Eggemann <dietmar.eggemann@arm.com>, Steven Rostedt
	<rostedt@goodmis.org>, Ben Segall <bsegall@google.com>, Mel Gorman
	<mgorman@suse.de>, Valentin Schneider <vschneid@redhat.com>, Jens Axboe
	<axboe@kernel.dk>, Pavel Begunkov <asml.silence@gmail.com>, Andrew Morton
	<akpm@linux-foundation.org>, Chen Yu <yu.c.chen@intel.com>, Shuah Khan
	<skhan@linuxfoundation.org>, =?iso-8859-1?Q?Micka=EBl_Sala=FCn?=
	<mic@digikod.net>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, "io-uring@vger.kernel.org"
	<io-uring@vger.kernel.org>, "linux-hardening@vger.kernel.org"
	<linux-hardening@vger.kernel.org>
Subject: RE: [PATCH] exec: Make sure task->comm is always NUL-terminated
Thread-Topic: [PATCH] exec: Make sure task->comm is always NUL-terminated
Thread-Index: AQHbQuM3vGxCxoQWAEqauiNGu7/fqLLQWTBw
Date: Sat, 30 Nov 2024 21:40:14 +0000
Message-ID: <b11a985992a44152bf8106c084747ed4@AcuMS.aculab.com>
References: <20241130044909.work.541-kees@kernel.org>
In-Reply-To: <20241130044909.work.541-kees@kernel.org>
Accept-Language: en-GB, en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ms-exchange-transport-fromentityheader: Hosted
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: V53-XAFTV8j_7i1VigBErSemrOASPj0caUyxGDfV4Q4_1733002836
X-Mimecast-Originator: aculab.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

From: Kees Cook
> Sent: 30 November 2024 04:49
>
> Instead of adding a new use of the ambiguous strncpy(), we'd want to
> use memtostr_pad() which enforces being able to check at compile time
> that sizes are sensible, but this requires being able to see string
> buffer lengths. Instead of trying to inline __set_task_comm() (which
> needs to call trace and perf functions), just open-code it. But to
> make sure we're always safe, add compile-time checking like we already
> do for get_task_comm().
...
> Here's what I'd prefer to use to clean up set_task_comm(). I merged
> Linus and Eric's suggestions and open-coded memtostr_pad().
> ---
>  fs/exec.c             | 12 ++++++------
>  include/linux/sched.h |  9 ++++-----
>  io_uring/io-wq.c      |  2 +-
>  io_uring/sqpoll.c     |  2 +-
>  kernel/kthread.c      |  3 ++-
>  5 files changed, 14 insertions(+), 14 deletions(-)
>=20
> diff --git a/fs/exec.c b/fs/exec.c
> index e0435b31a811..5f16500ac325 100644
> --- a/fs/exec.c
> +++ b/fs/exec.c
> @@ -1200,16 +1200,16 @@ char *__get_task_comm(char *buf, size_t buf_size,=
 struct task_struct *tsk)
>  EXPORT_SYMBOL_GPL(__get_task_comm);
>=20
>  /*
> - * These functions flushes out all traces of the currently running execu=
table
> - * so that a new one can be started
> + * This is unlocked -- the string will always be NUL-terminated, but
> + * may show overlapping contents if racing concurrent reads.
>   */
> -
>  void __set_task_comm(struct task_struct *tsk, const char *buf, bool exec=
)
>  {
> -=09task_lock(tsk);
> +=09size_t len =3D min(strlen(buf), sizeof(tsk->comm) - 1);
> +
>  =09trace_task_rename(tsk, buf);
> -=09strscpy_pad(tsk->comm, buf, sizeof(tsk->comm));
> -=09task_unlock(tsk);
> +=09memcpy(tsk->comm, buf, len);
> +=09memset(&tsk->comm[len], 0, sizeof(tsk->comm) - len);
>  =09perf_event_comm(tsk, exec);

Why not do strscpy_pad() into a local char[16] and then do a 16 byte
memcpy() into the target buffer?

Then non-constant input data will always give a valid '\0' terminated strin=
g
regardless of how strscpy_pad() is implemented.

=09David

-
Registered Address Lakeside, Bramley Road, Mount Farm, Milton Keynes, MK1 1=
PT, UK
Registration No: 1397386 (Wales)


