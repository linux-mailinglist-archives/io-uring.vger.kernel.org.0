Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 36B4A2D4C9D
	for <lists+io-uring@lfdr.de>; Wed,  9 Dec 2020 22:16:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388061AbgLIVPp convert rfc822-to-8bit (ORCPT
        <rfc822;lists+io-uring@lfdr.de>); Wed, 9 Dec 2020 16:15:45 -0500
Received: from eu-smtp-delivery-151.mimecast.com ([185.58.86.151]:52714 "EHLO
        eu-smtp-delivery-151.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2388032AbgLIVPf (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 9 Dec 2020 16:15:35 -0500
Received: from AcuMS.aculab.com (156.67.243.126 [156.67.243.126]) (Using
 TLS) by relay.mimecast.com with ESMTP id uk-mta-1-vL2RsGv_OTGtY0uYhYIEhw-1;
 Wed, 09 Dec 2020 21:13:55 +0000
X-MC-Unique: vL2RsGv_OTGtY0uYhYIEhw-1
Received: from AcuMS.Aculab.com (fd9f:af1c:a25b:0:43c:695e:880f:8750) by
 AcuMS.aculab.com (fd9f:af1c:a25b:0:43c:695e:880f:8750) with Microsoft SMTP
 Server (TLS) id 15.0.1347.2; Wed, 9 Dec 2020 21:13:54 +0000
Received: from AcuMS.Aculab.com ([fe80::43c:695e:880f:8750]) by
 AcuMS.aculab.com ([fe80::43c:695e:880f:8750%12]) with mapi id 15.00.1347.000;
 Wed, 9 Dec 2020 21:13:54 +0000
From:   David Laight <David.Laight@ACULAB.COM>
To:     'Pavel Begunkov' <asml.silence@gmail.com>,
        Jens Axboe <axboe@kernel.dk>
CC:     Alexander Viro <viro@zeniv.linux.org.uk>,
        "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
        "io-uring@vger.kernel.org" <io-uring@vger.kernel.org>,
        "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Matthew Wilcox <willy@infradead.org>
Subject: RE: [PATCH 2/2] block: no-copy bvec for direct IO
Thread-Topic: [PATCH 2/2] block: no-copy bvec for direct IO
Thread-Index: AQHWzdK4ncolaTTBdk+ENIJV/tZKlanvQ9gw
Date:   Wed, 9 Dec 2020 21:13:54 +0000
Message-ID: <9e80d0f0adc84cc9995e58e2d6aad580@AcuMS.aculab.com>
References: <cover.1607477897.git.asml.silence@gmail.com>
 <51905c4fcb222e14a1d5cb676364c1b4f177f582.1607477897.git.asml.silence@gmail.com>
In-Reply-To: <51905c4fcb222e14a1d5cb676364c1b4f177f582.1607477897.git.asml.silence@gmail.com>
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

From: Pavel Begunkov
> Sent: 09 December 2020 02:20
> 
> The block layer spends quite a while in blkdev_direct_IO() to copy and
> initialise bio's bvec. However, if we've already got a bvec in the input
> iterator it might be reused in some cases, i.e. when new
> ITER_BVEC_FLAG_FIXED flag is set. Simple tests show considerable
> performance boost, and it also reduces memory footprint.
...
> @@ -398,7 +422,11 @@ __blkdev_direct_IO(struct kiocb *iocb, struct iov_iter *iter, int nr_vecs)
>  		bio->bi_end_io = blkdev_bio_end_io;
>  		bio->bi_ioprio = iocb->ki_ioprio;
> 
> -		ret = bio_iov_iter_get_pages(bio, iter);
> +		if (iov_iter_is_bvec(iter) && iov_iter_bvec_fixed(iter))
> +			ret = bio_iov_fixed_bvec_get_pages(bio, iter);
> +		else
> +			ret = bio_iov_iter_get_pages(bio, iter);
> +

Is it necessary to check iov_iter_is_bvec() as well as iov_iter_bvec_fixed() ?
If so it is probably worth using & not && so the compiler stands
a chance of generating a & (B | C) == B instead of 2 conditionals.
(I think I saw the bits in the same field being tested.

	David

-
Registered Address Lakeside, Bramley Road, Mount Farm, Milton Keynes, MK1 1PT, UK
Registration No: 1397386 (Wales)

