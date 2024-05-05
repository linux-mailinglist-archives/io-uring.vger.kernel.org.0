Return-Path: <io-uring+bounces-1762-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id C53418BC35D
	for <lists+io-uring@lfdr.de>; Sun,  5 May 2024 22:02:19 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 022971C21388
	for <lists+io-uring@lfdr.de>; Sun,  5 May 2024 20:02:19 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1E5F36EB4A;
	Sun,  5 May 2024 20:02:14 +0000 (UTC)
X-Original-To: io-uring@vger.kernel.org
Received: from eu-smtp-delivery-151.mimecast.com (eu-smtp-delivery-151.mimecast.com [185.58.85.151])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 80A0F6DCE8
	for <io-uring@vger.kernel.org>; Sun,  5 May 2024 20:02:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=185.58.85.151
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714939334; cv=none; b=echbtHxh9G6C0gqdsx0b+zs04ymIjjGPixTaB2iMq5I8+NZV0nj1Vcpe49Gz6c8Oi7IadLhfSMaeyz5egql1TH5+sbRPJq8WURaFztMGBwXv6o13UnnjKau84t7J8g5DQfYIjKl4K6xBCwRSp4ZjlMioXlIEWOlGF2Chj6wuSNc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714939334; c=relaxed/simple;
	bh=E3EXz8OizJveGJXsu2m1+CDPXknNWRauEOO9iEs/AhA=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 MIME-Version:Content-Type; b=a6jOqWJrrYXpzMsGCh2orXtKkpqR1BsNOnREplKen7MCrKiCZ5kRJMgSk5dxtO9aNUMl8huBr2YzGqs3i7aIHe/BFcQTL5temil5kTtY4kKli0LtWJ4SkdSWcgoI7wutXCFAzI6nMU8AnLKlLrfkfmr7X/AyxVOM+2UixChsz/8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=ACULAB.COM; spf=pass smtp.mailfrom=aculab.com; arc=none smtp.client-ip=185.58.85.151
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=ACULAB.COM
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=aculab.com
Received: from AcuMS.aculab.com (156.67.243.121 [156.67.243.121]) by
 relay.mimecast.com with ESMTP with both STARTTLS and AUTH (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 uk-mta-214-jGM-Qg1LN-mdByA-tf6CNA-1; Sun, 05 May 2024 21:02:07 +0100
X-MC-Unique: jGM-Qg1LN-mdByA-tf6CNA-1
Received: from AcuMS.Aculab.com (10.202.163.4) by AcuMS.aculab.com
 (10.202.163.4) with Microsoft SMTP Server (TLS) id 15.0.1497.48; Sun, 5 May
 2024 21:01:32 +0100
Received: from AcuMS.Aculab.com ([::1]) by AcuMS.aculab.com ([::1]) with mapi
 id 15.00.1497.048; Sun, 5 May 2024 21:01:32 +0100
From: David Laight <David.Laight@ACULAB.COM>
To: 'Linus Torvalds' <torvalds@linux-foundation.org>
CC: "axboe@kernel.dk" <axboe@kernel.dk>, "brauner@kernel.org"
	<brauner@kernel.org>, "christian.koenig@amd.com" <christian.koenig@amd.com>,
	"dri-devel@lists.freedesktop.org" <dri-devel@lists.freedesktop.org>,
	"io-uring@vger.kernel.org" <io-uring@vger.kernel.org>, "jack@suse.cz"
	<jack@suse.cz>, "keescook@chromium.org" <keescook@chromium.org>,
	"laura@labbott.name" <laura@labbott.name>, "linaro-mm-sig@lists.linaro.org"
	<linaro-mm-sig@lists.linaro.org>, "linux-fsdevel@vger.kernel.org"
	<linux-fsdevel@vger.kernel.org>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, "linux-media@vger.kernel.org"
	<linux-media@vger.kernel.org>, "minhquangbui99@gmail.com"
	<minhquangbui99@gmail.com>, "sumit.semwal@linaro.org"
	<sumit.semwal@linaro.org>,
	"syzbot+045b454ab35fd82a35fb@syzkaller.appspotmail.com"
	<syzbot+045b454ab35fd82a35fb@syzkaller.appspotmail.com>,
	"syzkaller-bugs@googlegroups.com" <syzkaller-bugs@googlegroups.com>,
	"viro@zeniv.linux.org.uk" <viro@zeniv.linux.org.uk>
Subject: RE: [PATCH v2] epoll: be better about file lifetimes
Thread-Topic: [PATCH v2] epoll: be better about file lifetimes
Thread-Index: AQHanxYFUxCiqg1u6ES4w5URbGMRFrGJB6+A
Date: Sun, 5 May 2024 20:01:32 +0000
Message-ID: <12120faf79614fc1b9df272394a71550@AcuMS.aculab.com>
References: <CAHk-=wgMzzfPwKc=8yBdXwSkxoZMZroTCiLZTYESYD3BC_7rhQ@mail.gmail.com>
 <20240505175556.1213266-2-torvalds@linux-foundation.org>
In-Reply-To: <20240505175556.1213266-2-torvalds@linux-foundation.org>
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
X-Mimecast-Originator: aculab.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

From: Linus Torvalds
> Sent: 05 May 2024 18:56
>=20
> epoll can call out to vfs_poll() with a file pointer that may race with
> the last 'fput()'. That would make f_count go down to zero, and while
> the ep->mtx locking means that the resulting file pointer tear-down will
> be blocked until the poll returns, it means that f_count is already
> dead, and any use of it won't actually get a reference to the file any
> more: it's dead regardless.
>=20
> Make sure we have a valid ref on the file pointer before we call down to
> vfs_poll() from the epoll routines.

How much is the extra pair of atomics going to hurt performance?
IIRC a lot of work was done to (try to) make epoll lockless.

Perhaps the 'hook' into epoll (usually) from sys_close should be
done before any of the references are removed?
(Which is different from Q6/A6 in man epoll - but that seems to be
documenting a bug!)
Then the ->poll() callback can't happen (assuming it is properly
locked) after the ->release() one.

It seems better to add extra atomics to the close/final-fput path
rather than ever ->poll() call epoll makes.

I can get extra references to a driver by dup() open("/dev/fd/n")
and mmap() - but epoll is definitely fd based.
(Which may be why it has the fd number in its data.)

Is there another race between EPOLL_CTL_ADD and close() (from a
different thread)?

=09David

-
Registered Address Lakeside, Bramley Road, Mount Farm, Milton Keynes, MK1 1=
PT, UK
Registration No: 1397386 (Wales)


