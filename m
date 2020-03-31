Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2A2D519993C
	for <lists+io-uring@lfdr.de>; Tue, 31 Mar 2020 17:10:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727703AbgCaPKD convert rfc822-to-8bit (ORCPT
        <rfc822;lists+io-uring@lfdr.de>); Tue, 31 Mar 2020 11:10:03 -0400
Received: from eu-smtp-delivery-151.mimecast.com ([146.101.78.151]:25503 "EHLO
        eu-smtp-delivery-151.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726526AbgCaPKD (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 31 Mar 2020 11:10:03 -0400
Received: from AcuMS.aculab.com (156.67.243.126 [156.67.243.126]) (Using
 TLS) by relay.mimecast.com with ESMTP id
 uk-mta-241-7LJDl3bsPG2iDAnR1ZjiSg-1; Tue, 31 Mar 2020 16:09:57 +0100
X-MC-Unique: 7LJDl3bsPG2iDAnR1ZjiSg-1
Received: from AcuMS.Aculab.com (fd9f:af1c:a25b:0:43c:695e:880f:8750) by
 AcuMS.aculab.com (fd9f:af1c:a25b:0:43c:695e:880f:8750) with Microsoft SMTP
 Server (TLS) id 15.0.1347.2; Tue, 31 Mar 2020 16:09:56 +0100
Received: from AcuMS.Aculab.com ([fe80::43c:695e:880f:8750]) by
 AcuMS.aculab.com ([fe80::43c:695e:880f:8750%12]) with mapi id 15.00.1347.000;
 Tue, 31 Mar 2020 16:09:56 +0100
From:   David Laight <David.Laight@ACULAB.COM>
To:     "io-uring@vger.kernel.org" <io-uring@vger.kernel.org>
Subject: FW: [RFC PATCH 00/12] Changes to code that reads iovec from userspace
Thread-Topic: [RFC PATCH 00/12] Changes to code that reads iovec from
 userspace
Thread-Index: AdYHYETxpoUzI3CTQc6sOiLf8VKhPgADiMtA
Date:   Tue, 31 Mar 2020 15:09:56 +0000
Message-ID: <b80d0e07e155401fad27fae2aa83b013@AcuMS.aculab.com>
References: <a2c781bbd5c44fd19483076fd0296943@AcuMS.aculab.com>
In-Reply-To: <a2c781bbd5c44fd19483076fd0296943@AcuMS.aculab.com>
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



> -----Original Message-----
> From: David Laight
> Sent: 31 March 2020 14:52
> To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
> Cc: netdev@vger.kernel.org
> Subject: [RFC PATCH 00/12] Changes to code that reads iovec from userspace
> 
> This is RFC because we seem to be in a merge window.
> 
> The canonical code to read iov[] is currently:
> 	struct iovec iovstack[UIO_FASTIOV];
> 	struct iovec *iov;
> 	...
> 	iov = iovstack;
> 	rc = import_iovec(..., UIO_FASTIOV, &iov, &iter);
> 	if (rc < 0)
> 		return rc;
> 	...
> 	kfree(iov);
> 
> Note that the 'iov' parameter is used for two different things.
> On input it is an iov[] can can be used.
> On output it is an iov[] array that must be freed.
> 
> If 'iovstack' is passed, the count is actually always UIO_FASTIOV (8)
> although in some places the array definition is in a different file
> (never mind function) from the constant used.
> 
> import_iovec() itself is just a wrapper to rw_copy_check_uvector().
> So everything is passed through to a second function.
> Several items are 'passed by reference' - adding to the code paths.
> 
> On success import_iovec() returned the transfer count.
> Only one caller looks at it, the count is also in iter.count.
> 
> The new canonical code is:
> 	struct iov_cache cache;
> 	struct iovec *iov;
> 	...
> 	iov = iovec_import(..., &cache, &iter);
> 	if (IS_ERR(iov))
> 		return PTR_ERR(iov);
> 	...
> 	kfree(iov);
> 
> Since 'struct iov_cache' is a fixed size there is no need to pass in
> a length (correct or not!). It can still be NULL (used by the scsi code).
> 
> iovec_import() contains the code that used to be in rw_copy_check_uvector()
> and then sets up the iov_iter.
> 
> rw_copy_check_uvector() is no more.
> The only other caller was in mm/process_vm_access.c when reading the
> iov[] for the target process addresses when copying from a differ process.
> This can extract the iov[] from an extra 'struct iov_iter'.
> 
> In passing I noticed an access_ok() call on each fragment.
> I hope this is just there to bail out early!
> It is also skipped in process_vm_rw(). I did a quick look but couldn't
> see an obvious equivalent check.
> 
> Patches 1 and 2 tidy up existing code.
> Patches 3 and 4 add the new interface.
> Patches 5 through 10 change all the callers.
> Patch 11 removes a 'hack' that allowed fs/io_uring be updated before the socket code.
> Patch 12 removes the old interface.
> 
> I suspect the changes need to trickle through a merge window.
> 
> 	David

-
Registered Address Lakeside, Bramley Road, Mount Farm, Milton Keynes, MK1 1PT, UK
Registration No: 1397386 (Wales)

