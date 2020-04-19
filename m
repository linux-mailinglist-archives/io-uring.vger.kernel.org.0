Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7F9581AFE63
	for <lists+io-uring@lfdr.de>; Sun, 19 Apr 2020 23:18:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726067AbgDSVSK convert rfc822-to-8bit (ORCPT
        <rfc822;lists+io-uring@lfdr.de>); Sun, 19 Apr 2020 17:18:10 -0400
Received: from eu-smtp-delivery-151.mimecast.com ([207.82.80.151]:55442 "EHLO
        eu-smtp-delivery-151.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725959AbgDSVSK (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sun, 19 Apr 2020 17:18:10 -0400
Received: from AcuMS.aculab.com (156.67.243.126 [156.67.243.126]) (Using
 TLS) by relay.mimecast.com with ESMTP id
 uk-mta-196-qkGxLyqRNSu7MfwxJtx5NA-1; Sun, 19 Apr 2020 22:18:06 +0100
X-MC-Unique: qkGxLyqRNSu7MfwxJtx5NA-1
Received: from AcuMS.Aculab.com (fd9f:af1c:a25b:0:43c:695e:880f:8750) by
 AcuMS.aculab.com (fd9f:af1c:a25b:0:43c:695e:880f:8750) with Microsoft SMTP
 Server (TLS) id 15.0.1347.2; Sun, 19 Apr 2020 22:18:06 +0100
Received: from AcuMS.Aculab.com ([fe80::43c:695e:880f:8750]) by
 AcuMS.aculab.com ([fe80::43c:695e:880f:8750%12]) with mapi id 15.00.1347.000;
 Sun, 19 Apr 2020 22:18:06 +0100
From:   David Laight <David.Laight@ACULAB.COM>
To:     'Aleksa Sarai' <cyphar@cyphar.com>,
        Josh Triplett <josh@joshtriplett.org>
CC:     "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "io-uring@vger.kernel.org" <io-uring@vger.kernel.org>,
        "linux-arch@vger.kernel.org" <linux-arch@vger.kernel.org>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        Arnd Bergmann <arnd@arndb.de>, Jens Axboe <axboe@kernel.dk>
Subject: RE: [PATCH v4 2/3] fs: openat2: Extend open_how to allow
 userspace-selected fds
Thread-Topic: [PATCH v4 2/3] fs: openat2: Extend open_how to allow
 userspace-selected fds
Thread-Index: AQHWFjeEcgUetSiAV0WbnffNc+KTs6iAvc2Q
Date:   Sun, 19 Apr 2020 21:18:05 +0000
Message-ID: <7f02bf52254443e380c33cae7c1fd5f0@AcuMS.aculab.com>
References: <cover.1586830316.git.josh@joshtriplett.org>
 <f969e7d45a8e83efc1ca13d675efd8775f13f376.1586830316.git.josh@joshtriplett.org>
 <20200419104404.j4e5gxdn2duvmu6s@yavin.dot.cyphar.com>
In-Reply-To: <20200419104404.j4e5gxdn2duvmu6s@yavin.dot.cyphar.com>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ms-exchange-transport-fromentityheader: Hosted
x-originating-ip: [10.202.205.107]
MIME-Version: 1.0
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: aculab.com
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

From: Aleksa Sarai
> Sent: 19 April 2020 11:44
> 
> On 2020-04-13, Josh Triplett <josh@joshtriplett.org> wrote:
> > Inspired by the X protocol's handling of XIDs, allow userspace to select
> > the file descriptor opened by openat2, so that it can use the resulting
> > file descriptor in subsequent system calls without waiting for the
> > response to openat2.
> >
> > In io_uring, this allows sequences like openat2/read/close without
> > waiting for the openat2 to complete. Multiple such sequences can
> > overlap, as long as each uses a distinct file descriptor.
> 
> I'm not sure I understand this explanation -- how can you trigger a
> syscall with an fd that hasn't yet been registered (unless you're just
> hoping the race goes in your favour)?

I suspect (there are no comments in the io_uring code to say what it does)
that the io_uring code uses a thread of the user process to sequentially
execute IO requests that the main application has added to a queue.

So it might make sense to queue up open/read/close.
But that ought to be within the io_uring code.

	David

-
Registered Address Lakeside, Bramley Road, Mount Farm, Milton Keynes, MK1 1PT, UK
Registration No: 1397386 (Wales)

