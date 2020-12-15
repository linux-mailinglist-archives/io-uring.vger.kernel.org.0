Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 28C602DAA50
	for <lists+io-uring@lfdr.de>; Tue, 15 Dec 2020 10:44:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727137AbgLOJjb convert rfc822-to-8bit (ORCPT
        <rfc822;lists+io-uring@lfdr.de>); Tue, 15 Dec 2020 04:39:31 -0500
Received: from eu-smtp-delivery-151.mimecast.com ([185.58.86.151]:60614 "EHLO
        eu-smtp-delivery-151.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726185AbgLOJja (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 15 Dec 2020 04:39:30 -0500
Received: from AcuMS.aculab.com (156.67.243.126 [156.67.243.126]) (Using
 TLS) by relay.mimecast.com with ESMTP id
 uk-mta-17-jpEXzE1ONrSs8CdvF1T67g-1; Tue, 15 Dec 2020 09:37:52 +0000
X-MC-Unique: jpEXzE1ONrSs8CdvF1T67g-1
Received: from AcuMS.Aculab.com (fd9f:af1c:a25b:0:43c:695e:880f:8750) by
 AcuMS.aculab.com (fd9f:af1c:a25b:0:43c:695e:880f:8750) with Microsoft SMTP
 Server (TLS) id 15.0.1347.2; Tue, 15 Dec 2020 09:37:53 +0000
Received: from AcuMS.Aculab.com ([fe80::43c:695e:880f:8750]) by
 AcuMS.aculab.com ([fe80::43c:695e:880f:8750%12]) with mapi id 15.00.1347.000;
 Tue, 15 Dec 2020 09:37:53 +0000
From:   David Laight <David.Laight@ACULAB.COM>
To:     'Pavel Begunkov' <asml.silence@gmail.com>,
        "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>
CC:     Jens Axboe <axboe@kernel.dk>,
        Christoph Hellwig <hch@infradead.org>,
        Matthew Wilcox <willy@infradead.org>,
        Ming Lei <ming.lei@redhat.com>,
        Johannes Weiner <hannes@cmpxchg.org>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        "Darrick J . Wong" <darrick.wong@oracle.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Jonathan Corbet <corbet@lwn.net>,
        "linux-xfs@vger.kernel.org" <linux-xfs@vger.kernel.org>,
        "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
        "io-uring@vger.kernel.org" <io-uring@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "target-devel@vger.kernel.org" <target-devel@vger.kernel.org>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>
Subject: RE: [PATCH v1 2/6] iov_iter: optimise bvec iov_iter_advance()
Thread-Topic: [PATCH v1 2/6] iov_iter: optimise bvec iov_iter_advance()
Thread-Index: AQHW0njgRO60UNrAz0qHNwIRx20dYqn35EKA
Date:   Tue, 15 Dec 2020 09:37:53 +0000
Message-ID: <262132648a8f4e7a9d1c79003ea74b3f@AcuMS.aculab.com>
References: <cover.1607976425.git.asml.silence@gmail.com>
 <5c9c22dbeecad883ca29b31896c262a8d2a77132.1607976425.git.asml.silence@gmail.com>
In-Reply-To: <5c9c22dbeecad883ca29b31896c262a8d2a77132.1607976425.git.asml.silence@gmail.com>
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
> Sent: 15 December 2020 00:20
> 
> iov_iter_advance() is heavily used, but implemented through generic
> iteration. As bvecs have a specifically crafted advance() function, i.e.
> bvec_iter_advance(), which is faster and slimmer, use it instead.
> 
> Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
> ---
>  lib/iov_iter.c | 19 +++++++++++++++++++
>  1 file changed, 19 insertions(+)
> 
> diff --git a/lib/iov_iter.c b/lib/iov_iter.c
> index 1635111c5bd2..5b186dc2c9ea 100644
> --- a/lib/iov_iter.c
> +++ b/lib/iov_iter.c
> @@ -1067,6 +1067,21 @@ static void pipe_advance(struct iov_iter *i, size_t size)
>  	pipe_truncate(i);
>  }
> 
> +static void iov_iter_bvec_advance(struct iov_iter *i, size_t size)
> +{
> +	struct bvec_iter bi;
> +
> +	bi.bi_size = i->count;
> +	bi.bi_bvec_done = i->iov_offset;
> +	bi.bi_idx = 0;
> +	bvec_iter_advance(i->bvec, &bi, size);
> +
> +	i->bvec += bi.bi_idx;
> +	i->nr_segs -= bi.bi_idx;
> +	i->count = bi.bi_size;
> +	i->iov_offset = bi.bi_bvec_done;
> +}
> +
>  void iov_iter_advance(struct iov_iter *i, size_t size)
>  {
>  	if (unlikely(iov_iter_is_pipe(i))) {
> @@ -1077,6 +1092,10 @@ void iov_iter_advance(struct iov_iter *i, size_t size)
>  		i->count -= size;
>  		return;
>  	}
> +	if (iov_iter_is_bvec(i)) {
> +		iov_iter_bvec_advance(i, size);
> +		return;
> +	}
>  	iterate_and_advance(i, size, v, 0, 0, 0)
>  }

This seems to add yet another comparison before what is probably
the common case on an IOVEC (ie normal userspace buffer).

Can't the call to bver_iter_advance be dropped into the 'advance'
path for BVEC's inside iterate_and_advance?

iterate_and_advance itself has three 'unlikely' conditional tests
that may be mis-predicted taken before the 'likely' path.
One is for DISCARD which is checked twice on the object I just
looked at - the test in iov_iter_advance() is pointless.

	David

-
Registered Address Lakeside, Bramley Road, Mount Farm, Milton Keynes, MK1 1PT, UK
Registration No: 1397386 (Wales)

