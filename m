Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 442BF3E55CE
	for <lists+io-uring@lfdr.de>; Tue, 10 Aug 2021 10:47:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236479AbhHJIrj convert rfc822-to-8bit (ORCPT
        <rfc822;lists+io-uring@lfdr.de>); Tue, 10 Aug 2021 04:47:39 -0400
Received: from eu-smtp-delivery-151.mimecast.com ([185.58.86.151]:41406 "EHLO
        eu-smtp-delivery-151.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233460AbhHJIri (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 10 Aug 2021 04:47:38 -0400
Received: from AcuMS.aculab.com (156.67.243.121 [156.67.243.121]) (Using
 TLS) by relay.mimecast.com with ESMTP id
 uk-mta-275-lqUBwIiNOQKJbW6sqSZqNw-1; Tue, 10 Aug 2021 09:47:14 +0100
X-MC-Unique: lqUBwIiNOQKJbW6sqSZqNw-1
Received: from AcuMS.Aculab.com (fd9f:af1c:a25b:0:994c:f5c2:35d6:9b65) by
 AcuMS.aculab.com (fd9f:af1c:a25b:0:994c:f5c2:35d6:9b65) with Microsoft SMTP
 Server (TLS) id 15.0.1497.23; Tue, 10 Aug 2021 09:47:13 +0100
Received: from AcuMS.Aculab.com ([fe80::994c:f5c2:35d6:9b65]) by
 AcuMS.aculab.com ([fe80::994c:f5c2:35d6:9b65%12]) with mapi id
 15.00.1497.023; Tue, 10 Aug 2021 09:47:13 +0100
From:   David Laight <David.Laight@ACULAB.COM>
To:     'Al Viro' <viro@zeniv.linux.org.uk>,
        Pavel Begunkov <asml.silence@gmail.com>
CC:     "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
        "Jens Axboe" <axboe@kernel.dk>,
        "io-uring@vger.kernel.org" <io-uring@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH 0/2] iter revert problems
Thread-Topic: [PATCH 0/2] iter revert problems
Thread-Index: AQHXjTbk1nsSHvSB3kSUkMDvGdtDEqtsbGoA
Date:   Tue, 10 Aug 2021 08:47:13 +0000
Message-ID: <1fc5348f7598404088d4ecda3bbb397a@AcuMS.aculab.com>
References: <cover.1628509745.git.asml.silence@gmail.com>
 <YRFPR25scNRYaRzW@zeniv-ca.linux.org.uk>
In-Reply-To: <YRFPR25scNRYaRzW@zeniv-ca.linux.org.uk>
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

From: Al Viro
> Sent: 09 August 2021 16:53
> 
> On Mon, Aug 09, 2021 at 12:52:35PM +0100, Pavel Begunkov wrote:
> > For the bug description see 2/2. As mentioned there the current problems
> > is because of generic_write_checks(), but there was also a similar case
> > fixed in 5.12, which should have been triggerable by normal
> > write(2)/read(2) and others.
> >
> > It may be better to enforce reexpands as a long term solution, but for
> > now this patchset is quickier and easier to backport.
> 
> 	Umm...  Won't that screw the cases where we *are* doing proper
> reexpands?  AFAICS, with your patches that flag doesn't go away once
> it had been set...

From what I remember the pointer into the iov[] gets incremented
as it is processed - which makes 'backing up' hard.
The caller also has to remember the original pointer because
it might point to kmalloced memory.

So if the 'iter' always contained a pointer to the base of the iov[]
then various bits of code could be simplified.

Another useful change would be to embed the short iov_cache[8]
inside 'iter'.
Almost all the callers allocate both together (usually on stack)
so the stack use won't change.
I have local patches for most of this (somewhere) but the io_uring
changes start being non-trivial.

	David

-
Registered Address Lakeside, Bramley Road, Mount Farm, Milton Keynes, MK1 1PT, UK
Registration No: 1397386 (Wales)

