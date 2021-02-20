Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6E8F932067F
	for <lists+io-uring@lfdr.de>; Sat, 20 Feb 2021 18:51:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229828AbhBTRpr convert rfc822-to-8bit (ORCPT
        <rfc822;lists+io-uring@lfdr.de>); Sat, 20 Feb 2021 12:45:47 -0500
Received: from eu-smtp-delivery-151.mimecast.com ([185.58.86.151]:48058 "EHLO
        eu-smtp-delivery-151.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229810AbhBTRpq (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sat, 20 Feb 2021 12:45:46 -0500
Received: from AcuMS.aculab.com (156.67.243.126 [156.67.243.126]) (Using
 TLS) by relay.mimecast.com with ESMTP id
 uk-mta-261-9s6Dn3PkOTySVu2_pMSh9w-1; Sat, 20 Feb 2021 17:44:07 +0000
X-MC-Unique: 9s6Dn3PkOTySVu2_pMSh9w-1
Received: from AcuMS.Aculab.com (fd9f:af1c:a25b:0:43c:695e:880f:8750) by
 AcuMS.aculab.com (fd9f:af1c:a25b:0:43c:695e:880f:8750) with Microsoft SMTP
 Server (TLS) id 15.0.1347.2; Sat, 20 Feb 2021 17:44:06 +0000
Received: from AcuMS.Aculab.com ([fe80::43c:695e:880f:8750]) by
 AcuMS.aculab.com ([fe80::43c:695e:880f:8750%12]) with mapi id 15.00.1347.000;
 Sat, 20 Feb 2021 17:44:06 +0000
From:   David Laight <David.Laight@ACULAB.COM>
To:     'Lennert Buytenhek' <buytenh@wantstofly.org>,
        Jens Axboe <axboe@kernel.dk>,
        Al Viro <viro@zeniv.linux.org.uk>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
        "io-uring@vger.kernel.org" <io-uring@vger.kernel.org>
CC:     Matthew Wilcox <willy@infradead.org>
Subject: RE: [PATCH v3 0/2] io_uring: add support for IORING_OP_GETDENTS
Thread-Topic: [PATCH v3 0/2] io_uring: add support for IORING_OP_GETDENTS
Thread-Index: AQHXBfFRAjVxpRid2k+E4G2FbTp65qphUAow
Date:   Sat, 20 Feb 2021 17:44:06 +0000
Message-ID: <247d154f2ba549b88a77daf29ec1791f@AcuMS.aculab.com>
References: <20210218122640.GA334506@wantstofly.org>
In-Reply-To: <20210218122640.GA334506@wantstofly.org>
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
> Sent: 18 February 2021 12:27
> 
> These patches add support for IORING_OP_GETDENTS, which is a new io_uring
> opcode that more or less does an lseek(sqe->fd, sqe->off, SEEK_SET)
> followed by a getdents64(sqe->fd, (void *)sqe->addr, sqe->len).
> 
> A dumb test program for IORING_OP_GETDENTS is available here:
> 
> 	https://krautbox.wantstofly.org/~buytenh/uringfind-v2.c
> 
> This test program does something along the lines of what find(1) does:
> it scans recursively through a directory tree and prints the names of
> all directories and files it encounters along the way -- but then using
> io_uring.  (The io_uring version prints the names of encountered files and
> directories in an order that's determined by SQE completion order, which
> is somewhat nondeterministic and likely to differ between runs.)
> 
> On a directory tree with 14-odd million files in it that's on a
> six-drive (spinning disk) btrfs raid, find(1) takes:
> 
> 	# echo 3 > /proc/sys/vm/drop_caches
> 	# time find /mnt/repo > /dev/null
> 
> 	real    24m7.815s
> 	user    0m15.015s
> 	sys     0m48.340s
> 	#
> 
> And the io_uring version takes:
> 
> 	# echo 3 > /proc/sys/vm/drop_caches
> 	# time ./uringfind /mnt/repo > /dev/null
> 
> 	real    10m29.064s
> 	user    0m4.347s
> 	sys     0m1.677s
> 	#

While there may be uses for IORING_OP_GETDENTS are you sure your
test is comparing like with like?
The underlying work has to be done in either case, so you are
swapping system calls for code complexity.
I suspect that find is actually doing a stat() call on every
directory entry and that your io_uring example is just believing
the 'directory' flag returned in the directory entry for most
modern filesystems.

If you write a program that does openat(), readdir(), close()
for each directory and with a long enough buffer (mostly) do
one readdir() per directory you'll get a much better comparison.

You could even write a program with 2 threads, one does all the
open/readdir/close system calls and the other does the printing
and generating the list of directories to process.
That should get the equivalent overlapping that io_uring gives
without much of the complexity.

	David

-
Registered Address Lakeside, Bramley Road, Mount Farm, Milton Keynes, MK1 1PT, UK
Registration No: 1397386 (Wales)

