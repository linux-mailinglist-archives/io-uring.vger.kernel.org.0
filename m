Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6497C199941
	for <lists+io-uring@lfdr.de>; Tue, 31 Mar 2020 17:10:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730598AbgCaPKr convert rfc822-to-8bit (ORCPT
        <rfc822;lists+io-uring@lfdr.de>); Tue, 31 Mar 2020 11:10:47 -0400
Received: from eu-smtp-delivery-151.mimecast.com ([207.82.80.151]:25763 "EHLO
        eu-smtp-delivery-151.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726526AbgCaPKr (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 31 Mar 2020 11:10:47 -0400
Received: from AcuMS.aculab.com (156.67.243.126 [156.67.243.126]) (Using
 TLS) by relay.mimecast.com with ESMTP id
 uk-mta-100-DUOCA3GCPkWogsU4pXKQFw-1; Tue, 31 Mar 2020 16:10:42 +0100
X-MC-Unique: DUOCA3GCPkWogsU4pXKQFw-1
Received: from AcuMS.Aculab.com (fd9f:af1c:a25b:0:43c:695e:880f:8750) by
 AcuMS.aculab.com (fd9f:af1c:a25b:0:43c:695e:880f:8750) with Microsoft SMTP
 Server (TLS) id 15.0.1347.2; Tue, 31 Mar 2020 16:10:42 +0100
Received: from AcuMS.Aculab.com ([fe80::43c:695e:880f:8750]) by
 AcuMS.aculab.com ([fe80::43c:695e:880f:8750%12]) with mapi id 15.00.1347.000;
 Tue, 31 Mar 2020 16:10:42 +0100
From:   David Laight <David.Laight@ACULAB.COM>
To:     "io-uring@vger.kernel.org" <io-uring@vger.kernel.org>
Subject: FW: [RFC PATCH 11/12] fs:io_uring: Remove #defines added for
 bisection.
Thread-Topic: [RFC PATCH 11/12] fs:io_uring: Remove #defines added for
 bisection.
Thread-Index: AdYHYzIoB2cZDalwSka88IaGUSKwXAAC1TlQ
Date:   Tue, 31 Mar 2020 15:10:42 +0000
Message-ID: <20d2c35a119b4eda91b202c96a458efe@AcuMS.aculab.com>
References: <401b481ca75544d79f85df616f5118ab@AcuMS.aculab.com>
In-Reply-To: <401b481ca75544d79f85df616f5118ab@AcuMS.aculab.com>
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
> Subject: [RFC PATCH 11/12] fs:io_uring: Remove #defines added for bisection.
> 
> 
> Signed-off-by: David Laight <david.laight@aculab.com>
> ---
>  fs/io_uring.c | 4 ----
>  1 file changed, 4 deletions(-)
> 
> diff --git a/fs/io_uring.c b/fs/io_uring.c
> index 27d66cf..7b71b50 100644
> --- a/fs/io_uring.c
> +++ b/fs/io_uring.c
> @@ -77,10 +77,6 @@
>  #include <linux/eventpoll.h>
>  #include <linux/fs_struct.h>
> 
> -/* Temporary for commit bisection */
> -#define sendmsg_copy_msghdr(a, b, c, d) sendmsg_copy_msghdr(a, b, c, (void *)d)
> -#define recvmsg_copy_msghdr(a, b, c, d, e) recvmsg_copy_msghdr(a, b, c, d, (void *)e)
> -
>  #define CREATE_TRACE_POINTS
>  #include <trace/events/io_uring.h>
> 
> --
> 1.8.1.2

-
Registered Address Lakeside, Bramley Road, Mount Farm, Milton Keynes, MK1 1PT, UK
Registration No: 1397386 (Wales)

