Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CD0FE3087BB
	for <lists+io-uring@lfdr.de>; Fri, 29 Jan 2021 11:19:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232330AbhA2KOS convert rfc822-to-8bit (ORCPT
        <rfc822;lists+io-uring@lfdr.de>); Fri, 29 Jan 2021 05:14:18 -0500
Received: from eu-smtp-delivery-151.mimecast.com ([185.58.86.151]:53788 "EHLO
        eu-smtp-delivery-151.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232535AbhA2KIF (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 29 Jan 2021 05:08:05 -0500
Received: from AcuMS.aculab.com (156.67.243.126 [156.67.243.126]) (Using
 TLS) by relay.mimecast.com with ESMTP id
 uk-mta-137-v6Jt3agKMwqMraTT9paTTw-1; Fri, 29 Jan 2021 09:41:42 +0000
X-MC-Unique: v6Jt3agKMwqMraTT9paTTw-1
Received: from AcuMS.Aculab.com (fd9f:af1c:a25b:0:43c:695e:880f:8750) by
 AcuMS.aculab.com (fd9f:af1c:a25b:0:43c:695e:880f:8750) with Microsoft SMTP
 Server (TLS) id 15.0.1347.2; Fri, 29 Jan 2021 09:41:36 +0000
Received: from AcuMS.Aculab.com ([fe80::43c:695e:880f:8750]) by
 AcuMS.aculab.com ([fe80::43c:695e:880f:8750%12]) with mapi id 15.00.1347.000;
 Fri, 29 Jan 2021 09:41:36 +0000
From:   David Laight <David.Laight@ACULAB.COM>
To:     'Lennert Buytenhek' <buytenh@wantstofly.org>,
        Al Viro <viro@zeniv.linux.org.uk>
CC:     Jens Axboe <axboe@kernel.dk>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "io-uring@vger.kernel.org" <io-uring@vger.kernel.org>,
        "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
        "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Subject: RE: [RFC PATCH] io_uring: add support for IORING_OP_GETDENTS64
Thread-Topic: [RFC PATCH] io_uring: add support for IORING_OP_GETDENTS64
Thread-Index: AQHW8X6IGyYpVbXZsUSWaK/6c3T86ao3WrlQgAZW5gCAAK5iEA==
Date:   Fri, 29 Jan 2021 09:41:36 +0000
Message-ID: <a375e8ae82bb4b28ac97557f40f6e9c1@AcuMS.aculab.com>
References: <20210123114152.GA120281@wantstofly.org>
 <a99467bab6d64a7f9057181d979ec563@AcuMS.aculab.com>
 <20210128230710.GA190469@wantstofly.org>
In-Reply-To: <20210128230710.GA190469@wantstofly.org>
Accept-Language: en-GB, en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ms-exchange-transport-fromentityheader: Hosted
x-originating-ip: [10.202.205.107]
MIME-Version: 1.0
Authentication-Results: relay.mimecast.com;
        auth=pass smtp.auth=C51A453 smtp.mailfrom=david.laight@aculab.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: aculab.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

From: Lennert Buytenhek
> Sent: 28 January 2021 23:07
> 
> On Sun, Jan 24, 2021 at 10:21:38PM +0000, David Laight wrote:
> 
> > > One open question is whether IORING_OP_GETDENTS64 should be more like
> > > pread(2) and allow passing in a starting offset to read from the
> > > directory from.  (This would require some more surgery in fs/readdir.c.)
> >
> > Since directories are seekable this ought to work.
> > Modulo horrid issues with 32bit file offsets.
> 
> The incremental patch below does this.  (It doesn't apply cleanly on
> top of v1 of the IORING_OP_GETDENTS patch as I have other changes in
> my tree -- I'm including it just to illustrate the changes that would
> make this work.)
> 
> This change seems to work, and makes IORING_OP_GETDENTS take an
> explicitly specified directory offset (instead of using the file's
> ->f_pos), making it more like pread(2), and I like the change from
> a conceptual point of view, but it's a bit ugly around
> iterate_dir_use_ctx_pos().  Any thoughts on how to do this more
> cleanly (without breaking iterate_dir() semantics)?

I had a further thought...
I presume the basic operation is:
	lock(file);
	do_getents(); // Updates file->offset
	unlock(file);

Which means you can implement an offset by saving, updating
and restoring file->offset while the lock is held.

This is a bit like the completely broken pread() in uclibc
which uses two lseek() calls to set and restore the offset.
Whoever wrote that needs shooting - worse than useless.

Glibc is as bad:
	// Don't even ask what glibc's clock_nanosleep() does, you don't want to know.
	while (syscall(SYS_clock_nanosleep, CLOCK_MONOTONIC, TIMER_ABSTIME, &ts, NULL)

   David

-
Registered Address Lakeside, Bramley Road, Mount Farm, Milton Keynes, MK1 1PT, UK
Registration No: 1397386 (Wales)

