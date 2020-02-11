Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id ED2A0158C55
	for <lists+io-uring@lfdr.de>; Tue, 11 Feb 2020 11:07:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727805AbgBKKHL convert rfc822-to-8bit (ORCPT
        <rfc822;lists+io-uring@lfdr.de>); Tue, 11 Feb 2020 05:07:11 -0500
Received: from eu-smtp-delivery-151.mimecast.com ([207.82.80.151]:55813 "EHLO
        eu-smtp-delivery-151.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727728AbgBKKHL (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 11 Feb 2020 05:07:11 -0500
Received: from AcuMS.aculab.com (156.67.243.126 [156.67.243.126]) (Using
 TLS) by relay.mimecast.com with ESMTP id uk-mta-6-3p5GBDr0P_ySFL9gRCGzAA-1;
 Tue, 11 Feb 2020 10:07:06 +0000
Received: from AcuMS.Aculab.com (fd9f:af1c:a25b:0:43c:695e:880f:8750) by
 AcuMS.aculab.com (fd9f:af1c:a25b:0:43c:695e:880f:8750) with Microsoft SMTP
 Server (TLS) id 15.0.1347.2; Tue, 11 Feb 2020 10:07:06 +0000
Received: from AcuMS.Aculab.com ([fe80::43c:695e:880f:8750]) by
 AcuMS.aculab.com ([fe80::43c:695e:880f:8750%12]) with mapi id 15.00.1347.000;
 Tue, 11 Feb 2020 10:07:06 +0000
From:   David Laight <David.Laight@ACULAB.COM>
To:     'Pavel Begunkov' <asml.silence@gmail.com>,
        Jens Axboe <axboe@kernel.dk>,
        "io-uring@vger.kernel.org" <io-uring@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH] io_uring: fix iovec leaks
Thread-Topic: [PATCH] io_uring: fix iovec leaks
Thread-Index: AQHV3emh7zgsynhUKk2BR9GeKazohKgVyZ8A
Date:   Tue, 11 Feb 2020 10:07:06 +0000
Message-ID: <1255e56851a54c8c805695f1160bec9f@AcuMS.aculab.com>
References: <03aa734fcea29805635689cc2f1aa648f23b5cd3.1581102250.git.asml.silence@gmail.com>
In-Reply-To: <03aa734fcea29805635689cc2f1aa648f23b5cd3.1581102250.git.asml.silence@gmail.com>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ms-exchange-transport-fromentityheader: Hosted
x-originating-ip: [10.202.205.107]
MIME-Version: 1.0
X-MC-Unique: 3p5GBDr0P_ySFL9gRCGzAA-1
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: aculab.com
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

From: Pavel Begunkov
> Sent: 07 February 2020 19:05
> Allocated iovec is freed only in io_{read,write,send,recv)(), and just
> leaves it if an error occured. There are plenty of such cases:
> - cancellation of non-head requests
> - fail grabbing files in __io_queue_sqe()
> - set REQ_F_NOWAIT and returning in __io_queue_sqe()
> - etc.
> 
> Add REQ_F_NEED_CLEANUP, which will force such requests with custom
> allocated resourses go through cleanup handlers on put.

This looks horribly fragile.

	David

-
Registered Address Lakeside, Bramley Road, Mount Farm, Milton Keynes, MK1 1PT, UK
Registration No: 1397386 (Wales)

