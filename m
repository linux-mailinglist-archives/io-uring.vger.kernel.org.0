Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8230D20AA7C
	for <lists+io-uring@lfdr.de>; Fri, 26 Jun 2020 04:50:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728149AbgFZCuZ (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 25 Jun 2020 22:50:25 -0400
Received: from esa6.hgst.iphmx.com ([216.71.154.45]:51530 "EHLO
        esa6.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728092AbgFZCuY (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 25 Jun 2020 22:50:24 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1593139824; x=1624675824;
  h=from:to:cc:subject:date:message-id:references:
   content-transfer-encoding:mime-version;
  bh=s4gMhy1qnNvZf+LwNWDGm/0qJ05slrV1YqIS+/L8cOM=;
  b=LzFDTeqDSgNBKuNKxQfd9KKM4dHQ/9HXJ+UYvJyNRg6kIeVsJfm0WHZP
   sZaWDBnwJVHT/0X/8fIgm7oLddU67QdwhETWC+L8K/Y4whX13QYWImga9
   NmOWvpcii2onpOj4gkV4OdojKclWbpy1Wm5Ulg85XTJfRi8py+Rw7ycoD
   vHWlKp6plx1eUmlYhqUMBTJTtP22KITA+T1EDEGPb9aROk5rVgOpHeHk7
   njG/nuYmP+nRvpRwhL5v38cUioc1QcjaFcShhOQJUNKbrcfd9o6ijhV2m
   nBF6Rttmab+d5jA7ycPJMp9VvBxK9woeWimHdH6KaGsc76XN+mqYoB3c+
   A==;
IronPort-SDR: flwY8hXZLJRo3kOMaHGbyHDp8NcqeeLTsUOqEI0/c0HRqYHQYwo+Nfh+QNpd4KyYcZXQ1M7xPO
 hWOFXnUkQ489dNbUf5dwUOXh7+hpLL9OrG/sGtHQUJP6to7SEIoMluy0mz5zs74BNYMQvc5eiv
 hyC2slm+7xVT3pE2NETcyVlIIitr/QmRHG6yIKFhC+036S66F1Yxai3qiIBgdYKMV73U4POPuf
 ENPPZFGyC9rFvfPwi/ld0f2n7YRy5d3E6l4JnP0NySF+NWpXRKet0m5sUDqJD7hFLKzFCLZ/3f
 d1A=
X-IronPort-AV: E=Sophos;i="5.75,281,1589212800"; 
   d="scan'208";a="142333618"
Received: from mail-sn1nam02lp2059.outbound.protection.outlook.com (HELO NAM02-SN1-obe.outbound.protection.outlook.com) ([104.47.36.59])
  by ob1.hgst.iphmx.com with ESMTP; 26 Jun 2020 10:50:23 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=aZaQ7gfuCCWm4C1YaQ4o7YcG1LleEt5Vt/Dxxvr7XqFSMDZoygYRWLWAzL+W2UavSLciHbfXInQqEUQ7E1UUAgzAvP0bKun4p0qH3zSWpVGrwFqM1pbJkBqiEFpPatdSmvBE8yPNL7eKY4yzY/2LDciAAedVCrIEI4AazWaXSlkwfUMISs46tYUZGUZHo1jCxcDnyGuUv9j14pXxxRTGaUrmTMs3llH9o4Sg+ZPjgFd7ojP5308R6G/QPzV1Xx5tKs4GgwVq/hqavsjp8GViKXeZG9ksMpzAviYtF6rqHlUKlCqrPoQX33XH2ygQ+9I99PZvzy6nLt587zqjbKdlUA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=24ccLei63YfXchUra2if3f6BWwOMd92RmSP4rytoSGM=;
 b=lZmWQCmaW+L5p3S1cQakS1vbUTy7Rg87Nb6bNKluJ/anvUvDocs8U1Ej4nZwhA5+08GvJE6Ln9syrz817MOjdEuZQWYC7cc9DZCgC6wwXVP752UDrvQ26+rO5bVnL+tQNxB5z7f8AkI37upwM/UOmvt1MYnmPKzq6aV3uouvX2fp0xq8Q6Smr41bHlDcZNHdiHAojaGvcyiL2nqFE0/Yd+dY+tts+G1hgFfQkgXEymVBM/7xpaviGd6l9Jg9mptK5m+/YBYPXpDIu/22ZU2OZ/yjQHt3i1sjzI5zpU8fVJVenIajDRDUKbkid3sKeeRdxLbqDyPKz9yaEIzSfDofpQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=24ccLei63YfXchUra2if3f6BWwOMd92RmSP4rytoSGM=;
 b=hIKt7psNEiscYRekUiYjL/nG9JsMbpR2lO8l69Ekow18oe1KxO2jlBTTZ241aP+n6ovzF7gIyTugMueKHYl/ax6dPZxjuCzRMBbY1gRPzDkiMyhGBF7fOGrHZDKxgq05dTUFWRfKYJF2jOHn/8v9LHuSzEeDyr5wqZoHY3ZuqhY=
Received: from CY4PR04MB3751.namprd04.prod.outlook.com (2603:10b6:903:ec::14)
 by CY4PR0401MB3634.namprd04.prod.outlook.com (2603:10b6:910:8f::25) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3131.21; Fri, 26 Jun
 2020 02:50:20 +0000
Received: from CY4PR04MB3751.namprd04.prod.outlook.com
 ([fe80::c593:f271:eebe:ac7]) by CY4PR04MB3751.namprd04.prod.outlook.com
 ([fe80::c593:f271:eebe:ac7%9]) with mapi id 15.20.3131.024; Fri, 26 Jun 2020
 02:50:20 +0000
From:   Damien Le Moal <Damien.LeMoal@wdc.com>
To:     Kanchan Joshi <joshi.k@samsung.com>,
        "axboe@kernel.dk" <axboe@kernel.dk>,
        "viro@zeniv.linux.org.uk" <viro@zeniv.linux.org.uk>,
        "bcrl@kvack.org" <bcrl@kvack.org>
CC:     "asml.silence@gmail.com" <asml.silence@gmail.com>,
        "hch@infradead.org" <hch@infradead.org>,
        "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
        "mb@lightnvm.io" <mb@lightnvm.io>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-aio@kvack.org" <linux-aio@kvack.org>,
        "io-uring@vger.kernel.org" <io-uring@vger.kernel.org>,
        "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>,
        "selvakuma.s1@samsung.com" <selvakuma.s1@samsung.com>,
        "nj.shetty@samsung.com" <nj.shetty@samsung.com>,
        "javier.gonz@samsung.com" <javier.gonz@samsung.com>,
        Arnav Dawn <a.dawn@samsung.com>
Subject: Re: [PATCH v2 1/2] fs,block: Introduce RWF_ZONE_APPEND and handling
 in direct IO path
Thread-Topic: [PATCH v2 1/2] fs,block: Introduce RWF_ZONE_APPEND and handling
 in direct IO path
Thread-Index: AQHWSxStAvYl2c5t2kCK+9TjcP8ZXw==
Date:   Fri, 26 Jun 2020 02:50:20 +0000
Message-ID: <CY4PR04MB37511FB1D3B3491A2CED5470E7930@CY4PR04MB3751.namprd04.prod.outlook.com>
References: <1593105349-19270-1-git-send-email-joshi.k@samsung.com>
 <CGME20200625171834epcas5p226a24dfcb84cfa83fe29a2bd17795d85@epcas5p2.samsung.com>
 <1593105349-19270-2-git-send-email-joshi.k@samsung.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: samsung.com; dkim=none (message not signed)
 header.d=none;samsung.com; dmarc=none action=none header.from=wdc.com;
x-originating-ip: [129.253.182.57]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 21f25d9c-2757-49b5-8e89-08d8197baa8c
x-ms-traffictypediagnostic: CY4PR0401MB3634:
x-ld-processed: b61c8803-16f3-4c35-9b17-6f65f441df86,ExtAddr
x-microsoft-antispam-prvs: <CY4PR0401MB3634CF042DDE801209C2E8EAE7930@CY4PR0401MB3634.namprd04.prod.outlook.com>
wdcipoutbound: EOP-TRUE
x-ms-oob-tlc-oobclassifiers: OLM:5516;
x-forefront-prvs: 0446F0FCE1
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: mg/JCsb+ZFmrcxEzDb8IsqCtHFt3tyL6uRPPba0lRlw3zoSdIvtyDQmJcOYwTNE5bkIAZ4ohB7H5vvEyLXkzLmryKXYXrJOXqkLJs30aQVJh5kHTLVBzfS8X4yFa8rFNJPPB4gEx68S1fxN1RCxvSFcXdg9XDCYQUE6yWTsm8p4gckVrMajvX97oi5um4vNeJEcYHAIlCXPLnz1uJgonjGIcIHZUXsL6Bci9iwJbVTuqQUm7l8UTAWPFDSiewfOaUl3ITHFLOwKdi/JYBn1b4yG3HUKxNBNO57ny/lY+/oH9R7eCxijZ/8bdihshyq70YQLe7NdXvh5d1U4NZMlzcBIrx76bYFWhgZSuRW/BWhw1zK940rT1f4UHwE72yrla
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY4PR04MB3751.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(39860400002)(346002)(376002)(366004)(136003)(396003)(53546011)(6506007)(316002)(110136005)(71200400001)(54906003)(26005)(478600001)(2906002)(7696005)(186003)(4326008)(83380400001)(55016002)(9686003)(52536014)(33656002)(66476007)(86362001)(66556008)(64756008)(8936002)(76116006)(8676002)(91956017)(66946007)(66446008)(5660300002)(7416002)(142933001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: G/ld9yUq8eCCu1J/hA+rRKRPn/VFCVxB8mdOgKMY52wyb+baELf3ZtNNwOwbGcmN2xwQE+cSxW2C3d27o6RlCbXlh0ayJM+Zk8i0+XFFY5+Cddz1C75pJxRAGY0G6IFhInBuNjM/uIQI2kSz/99c+lsM6ARM43F0DhjiAElQsZnP1uAK5GmMI65oJtptfDE8ZZ/n4RWIh5e54W/7v0qG3dLsXp7gjGzU7G+e1eAeJ69R9+I8Dtf+NNHdHTCdiYJFe9WwKyiADJAHIpGgTT7splNTIOa+YuQj9lIVjZVI/E89zAg4TDfnapL0gAP8UTgkD+8HQWLAZNOsWJiWFRDgUU/XUoHO36RTzJPgpZRtMubYIhXIcUUWsfElh24teJQH1lNTyglyCd2PXmSkaXWrvYL24nOZ6/0bhHTqV/MfH6fita7QHn9MTxq/+Ru1n88RcZ744VxJu8ySRpBRMLZYmYTlzLk0Or5O4RHQYiVyylkpIMNsiZddMvXX+sNjyMeW
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: CY4PR04MB3751.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 21f25d9c-2757-49b5-8e89-08d8197baa8c
X-MS-Exchange-CrossTenant-originalarrivaltime: 26 Jun 2020 02:50:20.3996
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: XL9oHlsTs99rz/TWJE3ddGr5auCnzT6WLC5+5iMmker/mALoNYCKX6tIoTBuqnKoeor6rDIE5OFiKA8QPZqqfQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY4PR0401MB3634
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 2020/06/26 2:18, Kanchan Joshi wrote:=0A=
> Introduce RWF_ZONE_APPEND flag to represent zone-append. User-space=0A=
> sends this with write. Add IOCB_ZONE_APPEND which is set in=0A=
> kiocb->ki_flags on receiving RWF_ZONE_APPEND.=0A=
> Make direct IO submission path use IOCB_ZONE_APPEND to send bio with=0A=
> append op. Direct IO completion returns zone-relative offset, in sector=
=0A=
> unit, to upper layer using kiocb->ki_complete interface.=0A=
> Report error if zone-append is requested on regular file or on sync=0A=
> kiocb (i.e. one without ki_complete).=0A=
> =0A=
> Signed-off-by: Kanchan Joshi <joshi.k@samsung.com>=0A=
> Signed-off-by: SelvaKumar S <selvakuma.s1@samsung.com>=0A=
> Signed-off-by: Arnav Dawn <a.dawn@samsung.com>=0A=
> Signed-off-by: Nitesh Shetty <nj.shetty@samsung.com>=0A=
> Signed-off-by: Javier Gonzalez <javier.gonz@samsung.com>=0A=
> ---=0A=
>  fs/block_dev.c          | 28 ++++++++++++++++++++++++----=0A=
>  include/linux/fs.h      |  9 +++++++++=0A=
>  include/uapi/linux/fs.h |  5 ++++-=0A=
>  3 files changed, 37 insertions(+), 5 deletions(-)=0A=
> =0A=
> diff --git a/fs/block_dev.c b/fs/block_dev.c=0A=
> index 47860e5..5180268 100644=0A=
> --- a/fs/block_dev.c=0A=
> +++ b/fs/block_dev.c=0A=
> @@ -185,6 +185,10 @@ static unsigned int dio_bio_write_op(struct kiocb *i=
ocb)=0A=
>  	/* avoid the need for a I/O completion work item */=0A=
>  	if (iocb->ki_flags & IOCB_DSYNC)=0A=
>  		op |=3D REQ_FUA;=0A=
> +=0A=
> +	if (iocb->ki_flags & IOCB_ZONE_APPEND)=0A=
> +		op |=3D REQ_OP_ZONE_APPEND;=0A=
=0A=
This is wrong. REQ_OP_WRITE is already set in the declaration of "op". How =
can=0A=
this work ?=0A=
=0A=
> +=0A=
>  	return op;=0A=
>  }=0A=
>  =0A=
> @@ -295,6 +299,14 @@ static int blkdev_iopoll(struct kiocb *kiocb, bool w=
ait)=0A=
>  	return blk_poll(q, READ_ONCE(kiocb->ki_cookie), wait);=0A=
>  }=0A=
>  =0A=
> +static inline long blkdev_bio_end_io_append(struct bio *bio)=0A=
> +{=0A=
> +	sector_t zone_sectors =3D blk_queue_zone_sectors(bio->bi_disk->queue);=
=0A=
> +=0A=
> +	/* calculate zone relative offset for zone append */=0A=
=0A=
The name of the function may be better spelling out zone_append instead of =
just=0A=
append. But see next comment.=0A=
=0A=
> +	return bio->bi_iter.bi_sector & (zone_sectors - 1);=0A=
> +}=0A=
> +=0A=
>  static void blkdev_bio_end_io(struct bio *bio)=0A=
>  {=0A=
>  	struct blkdev_dio *dio =3D bio->bi_private;=0A=
> @@ -307,15 +319,19 @@ static void blkdev_bio_end_io(struct bio *bio)=0A=
>  		if (!dio->is_sync) {=0A=
>  			struct kiocb *iocb =3D dio->iocb;=0A=
>  			ssize_t ret;=0A=
> +			long res2 =3D 0;=0A=
>  =0A=
>  			if (likely(!dio->bio.bi_status)) {=0A=
>  				ret =3D dio->size;=0A=
>  				iocb->ki_pos +=3D ret;=0A=
> +=0A=
=0A=
Blank line not needed.=0A=
=0A=
> +				if (iocb->ki_flags & IOCB_ZONE_APPEND)> +					res2 =3D blkdev_bio_en=
d_io_append(bio);=0A=
=0A=
The name blkdev_bio_end_io_append() implies a bio end_io callback function,=
=0A=
which is not the case. What about naming this blkdev_bio_res2() and move th=
e if=0A=
inside it ?=0A=
=0A=
>  			} else {=0A=
>  				ret =3D blk_status_to_errno(dio->bio.bi_status);=0A=
=0A=
add "res2 =3D 0;" here and drop the declaration initialization. That will a=
void=0A=
doing the assignment twice for zone append case.=0A=
=0A=
>  			}=0A=
>  =0A=
> -			dio->iocb->ki_complete(iocb, ret, 0);=0A=
> +			dio->iocb->ki_complete(iocb, ret, res2);=0A=
>  			if (dio->multi_bio)=0A=
>  				bio_put(&dio->bio);=0A=
>  		} else {=0A=
> @@ -382,6 +398,7 @@ __blkdev_direct_IO(struct kiocb *iocb, struct iov_ite=
r *iter, int nr_pages)=0A=
>  		bio->bi_private =3D dio;=0A=
>  		bio->bi_end_io =3D blkdev_bio_end_io;=0A=
>  		bio->bi_ioprio =3D iocb->ki_ioprio;=0A=
> +		bio->bi_opf =3D is_read ? REQ_OP_READ : dio_bio_write_op(iocb);=0A=
=0A=
Personally, I would prefer a plain "if () else". Or even better: change=0A=
dio_bio_write_op() into dio_bio_op() and just have:=0A=
=0A=
		bio->bi_opf =3D dio_bio_op(iocb);=0A=
=0A=
>  =0A=
>  		ret =3D bio_iov_iter_get_pages(bio, iter);=0A=
>  		if (unlikely(ret)) {=0A=
> @@ -391,11 +408,9 @@ __blkdev_direct_IO(struct kiocb *iocb, struct iov_it=
er *iter, int nr_pages)=0A=
>  		}=0A=
>  =0A=
>  		if (is_read) {=0A=
> -			bio->bi_opf =3D REQ_OP_READ;=0A=
>  			if (dio->should_dirty)=0A=
>  				bio_set_pages_dirty(bio);=0A=
>  		} else {=0A=
> -			bio->bi_opf =3D dio_bio_write_op(iocb);=0A=
>  			task_io_account_write(bio->bi_iter.bi_size);=0A=
>  		}=0A=
>  =0A=
> @@ -465,12 +480,17 @@ __blkdev_direct_IO(struct kiocb *iocb, struct iov_i=
ter *iter, int nr_pages)=0A=
>  static ssize_t=0A=
>  blkdev_direct_IO(struct kiocb *iocb, struct iov_iter *iter)=0A=
>  {=0A=
> +	bool is_sync =3D is_sync_kiocb(iocb);=0A=
>  	int nr_pages;=0A=
>  =0A=
> +	/* zone-append is supported only on async-kiocb */=0A=
> +	if (is_sync && iocb->ki_flags & IOCB_ZONE_APPEND)=0A=
> +		return -EINVAL;=0A=
> +=0A=
>  	nr_pages =3D iov_iter_npages(iter, BIO_MAX_PAGES + 1);=0A=
>  	if (!nr_pages)=0A=
>  		return 0;=0A=
> -	if (is_sync_kiocb(iocb) && nr_pages <=3D BIO_MAX_PAGES)=0A=
> +	if (is_sync && nr_pages <=3D BIO_MAX_PAGES)=0A=
>  		return __blkdev_direct_IO_simple(iocb, iter, nr_pages);=0A=
>  =0A=
>  	return __blkdev_direct_IO(iocb, iter, min(nr_pages, BIO_MAX_PAGES));=0A=
> diff --git a/include/linux/fs.h b/include/linux/fs.h=0A=
> index 6c4ab4d..3202d9a 100644=0A=
> --- a/include/linux/fs.h=0A=
> +++ b/include/linux/fs.h=0A=
> @@ -315,6 +315,7 @@ enum rw_hint {=0A=
>  #define IOCB_SYNC		(1 << 5)=0A=
>  #define IOCB_WRITE		(1 << 6)=0A=
>  #define IOCB_NOWAIT		(1 << 7)=0A=
> +#define IOCB_ZONE_APPEND	(1 << 8)=0A=
>  =0A=
>  struct kiocb {=0A=
>  	struct file		*ki_filp;=0A=
> @@ -3456,6 +3457,14 @@ static inline int kiocb_set_rw_flags(struct kiocb =
*ki, rwf_t flags)=0A=
>  		ki->ki_flags |=3D (IOCB_DSYNC | IOCB_SYNC);=0A=
>  	if (flags & RWF_APPEND)=0A=
>  		ki->ki_flags |=3D IOCB_APPEND;=0A=
> +	if (flags & RWF_ZONE_APPEND) {=0A=
> +		/* currently support block device only */=0A=
> +		umode_t mode =3D file_inode(ki->ki_filp)->i_mode;=0A=
> +=0A=
> +		if (!(S_ISBLK(mode)))=0A=
> +			return -EOPNOTSUPP;=0A=
> +		ki->ki_flags |=3D IOCB_ZONE_APPEND;=0A=
> +	}=0A=
>  	return 0;=0A=
>  }=0A=
>  =0A=
> diff --git a/include/uapi/linux/fs.h b/include/uapi/linux/fs.h=0A=
> index 379a612..1ce06e9 100644=0A=
> --- a/include/uapi/linux/fs.h=0A=
> +++ b/include/uapi/linux/fs.h=0A=
> @@ -299,8 +299,11 @@ typedef int __bitwise __kernel_rwf_t;=0A=
>  /* per-IO O_APPEND */=0A=
>  #define RWF_APPEND	((__force __kernel_rwf_t)0x00000010)=0A=
>  =0A=
> +/* per-IO O_APPEND */=0A=
> +#define RWF_ZONE_APPEND	((__force __kernel_rwf_t)0x00000020)=0A=
> +=0A=
>  /* mask of flags supported by the kernel */=0A=
>  #define RWF_SUPPORTED	(RWF_HIPRI | RWF_DSYNC | RWF_SYNC | RWF_NOWAIT |\=
=0A=
> -			 RWF_APPEND)=0A=
> +			 RWF_APPEND | RWF_ZONE_APPEND)=0A=
>  =0A=
>  #endif /* _UAPI_LINUX_FS_H */=0A=
> =0A=
=0A=
=0A=
-- =0A=
Damien Le Moal=0A=
Western Digital Research=0A=
