Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5A36A2293BE
	for <lists+io-uring@lfdr.de>; Wed, 22 Jul 2020 10:39:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726506AbgGVIjM convert rfc822-to-8bit (ORCPT
        <rfc822;lists+io-uring@lfdr.de>); Wed, 22 Jul 2020 04:39:12 -0400
Received: from eu-smtp-delivery-151.mimecast.com ([207.82.80.151]:27018 "EHLO
        eu-smtp-delivery-151.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727034AbgGVIjM (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 22 Jul 2020 04:39:12 -0400
Received: from AcuMS.aculab.com (156.67.243.126 [156.67.243.126]) (Using
 TLS) by relay.mimecast.com with ESMTP id uk-mta-2-069i4kReMsq9RSpkpaVvZA-1;
 Wed, 22 Jul 2020 09:39:07 +0100
X-MC-Unique: 069i4kReMsq9RSpkpaVvZA-1
Received: from AcuMS.Aculab.com (fd9f:af1c:a25b:0:43c:695e:880f:8750) by
 AcuMS.aculab.com (fd9f:af1c:a25b:0:43c:695e:880f:8750) with Microsoft SMTP
 Server (TLS) id 15.0.1347.2; Wed, 22 Jul 2020 09:39:07 +0100
Received: from AcuMS.Aculab.com ([fe80::43c:695e:880f:8750]) by
 AcuMS.aculab.com ([fe80::43c:695e:880f:8750%12]) with mapi id 15.00.1347.000;
 Wed, 22 Jul 2020 09:39:07 +0100
From:   David Laight <David.Laight@ACULAB.COM>
To:     'Christoph Hellwig' <hch@lst.de>, Andy Lutomirski <luto@kernel.org>
CC:     Jens Axboe <axboe@kernel.dk>,
        linux-arch <linux-arch@vger.kernel.org>,
        Linux API <linux-api@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        "io-uring@vger.kernel.org" <io-uring@vger.kernel.org>
Subject: RE: io_uring vs in_compat_syscall()
Thread-Topic: io_uring vs in_compat_syscall()
Thread-Index: AQHWX/GrvZMJhuIwWE2T9O3qn36ZwKkTQzqg
Date:   Wed, 22 Jul 2020 08:39:06 +0000
Message-ID: <8fefa815a3924fb3b893371c988781ad@AcuMS.aculab.com>
References: <b754dad5-ee85-8a2f-f41a-8bdc56de42e8@kernel.dk>
 <8987E376-6B13-4798-BDBA-616A457447CF@amacapital.net>
 <20200721070709.GB11432@lst.de>
 <CALCETrXWZBXZuCeRYvYY8AWG51e_P3bOeNeqc8zXPLOTDTHY0g@mail.gmail.com>
 <20200721143412.GA8099@lst.de>
 <CALCETrWMQpKe7jqw2t39yn4HgGhGTSEFGK6MPR4wPs=tBBhjbg@mail.gmail.com>
 <20200722063050.GA24968@lst.de>
In-Reply-To: <20200722063050.GA24968@lst.de>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ms-exchange-transport-fromentityheader: Hosted
x-originating-ip: [10.202.205.107]
MIME-Version: 1.0
Authentication-Results: relay.mimecast.com;
        auth=pass smtp.auth=C51A453 smtp.mailfrom=david.laight@aculab.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: aculab.com
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

From: Christoph Hellwig
> Sent: 22 July 2020 07:31
...
> > I agree that MSG_CMSG_COMPAT is nasty, but I think the concept is
> > sound -- rather than tracking whether we're compat by using a
> > different function or a per-thread variable, actually explicitly
> > tracking the mode seems sensible.
> 
> I very strongly disagree.  Two recent projects I did was to remove
> the compat_exec mess, and the compat get/setsockopt mess, and each
> time it removed hundreds of lines of code duplicating native
> functionality, often in slightly broken ways.  We need a generic
> out of band way to transfer the information down and just check in
> in a few strategic places, and in_compat_syscall() does the right
> thing for that.

Hmmm... set_fs(KERNEL_DS) is a per-thread variable that indicates
that the current system call is being done by the kernel.

So you are pulling two different bits of code in opposite directions.

It has to be safer to track the flag through with the request.
Then once any conversion has been done the flag can be corrected.

Imagine something like a bpf hook on a compat syscall.
Having read the user buffer into kernel space it may decide
to reformat it to the native layout to process it.
After which the code has a native format buffer even though
in_compat_syscall() returns true.

To the native/compat flag is actually a property of the buffer
much the same as whether it is user/kernel.

The other property of the buffer is whether embedded addresses
are user or kernel.
If the buffer has been read from userspace then they are user.
If the request originated in the kernel they are kernel.
This difference may matter in the future.

	David

-
Registered Address Lakeside, Bramley Road, Mount Farm, Milton Keynes, MK1 1PT, UK
Registration No: 1397386 (Wales)

