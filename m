Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C8957301F35
	for <lists+io-uring@lfdr.de>; Sun, 24 Jan 2021 23:24:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726473AbhAXWXS convert rfc822-to-8bit (ORCPT
        <rfc822;lists+io-uring@lfdr.de>); Sun, 24 Jan 2021 17:23:18 -0500
Received: from eu-smtp-delivery-151.mimecast.com ([185.58.86.151]:42571 "EHLO
        eu-smtp-delivery-151.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726103AbhAXWXR (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sun, 24 Jan 2021 17:23:17 -0500
Received: from AcuMS.aculab.com (156.67.243.126 [156.67.243.126]) (Using
 TLS) by relay.mimecast.com with ESMTP id
 uk-mta-221-V_JHwXlIPZiqhlLQqW69Yw-1; Sun, 24 Jan 2021 22:21:37 +0000
X-MC-Unique: V_JHwXlIPZiqhlLQqW69Yw-1
Received: from AcuMS.Aculab.com (fd9f:af1c:a25b:0:43c:695e:880f:8750) by
 AcuMS.aculab.com (fd9f:af1c:a25b:0:43c:695e:880f:8750) with Microsoft SMTP
 Server (TLS) id 15.0.1347.2; Sun, 24 Jan 2021 22:21:38 +0000
Received: from AcuMS.Aculab.com ([fe80::43c:695e:880f:8750]) by
 AcuMS.aculab.com ([fe80::43c:695e:880f:8750%12]) with mapi id 15.00.1347.000;
 Sun, 24 Jan 2021 22:21:38 +0000
From:   David Laight <David.Laight@ACULAB.COM>
To:     'Lennert Buytenhek' <buytenh@wantstofly.org>,
        Jens Axboe <axboe@kernel.dk>
CC:     "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "io-uring@vger.kernel.org" <io-uring@vger.kernel.org>,
        "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
        "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Subject: RE: [RFC PATCH] io_uring: add support for IORING_OP_GETDENTS64
Thread-Topic: [RFC PATCH] io_uring: add support for IORING_OP_GETDENTS64
Thread-Index: AQHW8X6IGyYpVbXZsUSWaK/6c3T86ao3WrlQ
Date:   Sun, 24 Jan 2021 22:21:38 +0000
Message-ID: <a99467bab6d64a7f9057181d979ec563@AcuMS.aculab.com>
References: <20210123114152.GA120281@wantstofly.org>
In-Reply-To: <20210123114152.GA120281@wantstofly.org>
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

> One open question is whether IORING_OP_GETDENTS64 should be more like
> pread(2) and allow passing in a starting offset to read from the
> directory from.  (This would require some more surgery in fs/readdir.c.)

Since directories are seekable this ought to work.
Modulo horrid issues with 32bit file offsets.

You'd need to return the final offset to allow another
read to continue from the end position.

	David

-
Registered Address Lakeside, Bramley Road, Mount Farm, Milton Keynes, MK1 1PT, UK
Registration No: 1397386 (Wales)

