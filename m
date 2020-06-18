Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7EF411FEC13
	for <lists+io-uring@lfdr.de>; Thu, 18 Jun 2020 09:16:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728035AbgFRHQZ (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 18 Jun 2020 03:16:25 -0400
Received: from esa1.hgst.iphmx.com ([68.232.141.245]:10181 "EHLO
        esa1.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725829AbgFRHQY (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 18 Jun 2020 03:16:24 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1592464583; x=1624000583;
  h=from:to:cc:subject:date:message-id:references:
   content-transfer-encoding:mime-version;
  bh=UmOgTQoXl5tIbp8dSJLesR1zp6F4A0cSU/tPePlLE8U=;
  b=VIobZH73YBENqhZWQeZ9xnNWLbN+cY4obg7/JmFQipbej7siQ4DDQO1z
   hE0j3h0r+ZsDEKP71lnP79vkc6g+X9XiUeWJIjJf7l1wp3v4zmd6M8PD9
   SHGR04ZS1F+rZXMLaX8cZIJPB9LqpopS8dzFQ/J9STsNGBkfRGTMU1kXH
   lIjVGV3kiT6cUaSoOuO0DVS6r1kMfgN3GlVvg0u7RJpahOOS74+KjOURF
   04m2KBG/zpmkE6JWbdrRZsilHsvDGzFgocQWHblHWCiwrJk5MiJ1H+PUM
   d7MKnQvzRoT0hYK2IDGt2LmvuB6BFazkULWZ+MZwCtwSrKab/Uwst1ne9
   w==;
IronPort-SDR: bnybSg7lsLSDcGihOWNV13Ev7N574Ecc3QaDmPvYVTtmvltVJzWa198ItMlYNBHP9E8xr0vi09
 Tgx+9PJlMGyPjLaXcQRCmrP9UOnNHd6Pn+BeAC8NiUEsGxGm0hMu8n2dISISOXoKL1H1Ak2UWR
 1YcFKjc9/8liVqZ3+C7t8HaojL7J+wM3niNKjzOv7Vx2xp3pjRth/Bwvy/dEjmAXQPWTw3Fxdv
 qEVD0H5eZFfOmVjEE2DfgFRYn9YW5u3kP9SKjXOVtYySnj+l0z7megc534vxnFcnvwpYRHuF2O
 8J8=
X-IronPort-AV: E=Sophos;i="5.73,525,1583164800"; 
   d="scan'208";a="249476478"
Received: from mail-bn8nam11lp2170.outbound.protection.outlook.com (HELO NAM11-BN8-obe.outbound.protection.outlook.com) ([104.47.58.170])
  by ob1.hgst.iphmx.com with ESMTP; 18 Jun 2020 15:16:20 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=jn6KmiOR50yia9/+2jBvYRkb8ubKC/17jkVcDheQ3klkx0sc+abJ6LSZ9bTXVyyP2WlOnKo1jiQs0221VWhHrE5yq7BZrg99c0Het3D6bDhnym/mtG4KS3zsMuB0Ez/qehJ++Foi4qLk3IsG5RhMTJBRAAUm71rJxPfZV1lms49MgEXtL8Lao1FqokyGxlzW5/J7OACszYvNmr02z17YE3GH6ij5hpBvxAh6R2nO3zC5bpdECmZD9903gfTRYpC8fkC5fRWHcBnc7yfVZFoMDISP/4nNYMApj2ois59DC2CmRkLRb64uBBU+q+cYz/zoiMDQHrUCg5roi8qK2FotoQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=18CGVoZdLCLw80LznaxyfFsKvtWaFkJce9iwmU5EG0Q=;
 b=TvkV3OLsSDA9k4I86xTlsWQdUdPe4eqSYDloC/alQDqPE7NvgfQDi+Ie9f576huAkcNdJZj6zTr7B5qBp7o18QUhT2S/GA0c+kjymOzSMbuYCjzuwHfUgGb48nADuQX2pk5m+aP8HDrzKvry9MwsHv+9H9Yk1+gm75edzWqLK2avkU/og2qZdoyeXuI69/wBgRZ5B9m/S4J5WaJptS9FC5DeNOQLtdSEsUVx55j2cwT+UgNxRj+njpKBJlVIb16npPdSB093kwdhcvlwy1O/QMoTVYHxe1lDrKpVDaYE2x8ft9eMQR6b2ubklQp+SajqELctcB65mexNFnv9MBpnFQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=18CGVoZdLCLw80LznaxyfFsKvtWaFkJce9iwmU5EG0Q=;
 b=LgJccMTeO1HEjrTt+hWo/Css7qMp6I+Npz5vvCzzlYZQN150oiZTGwzcX1BDrhcYa1y2zhce3oSkC97SeQHJ1v7fcJEq4OgStnz8e5BWMQsgMHEQBhTG9Q1WOfjJjoTEc9ot9yllfEUp2cBbzUxO6vDw9+lq8d6EvT3INbtxtDQ=
Received: from CY4PR04MB3751.namprd04.prod.outlook.com (2603:10b6:903:ec::14)
 by CY4PR04MB1048.namprd04.prod.outlook.com (2603:10b6:910:54::26) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3088.24; Thu, 18 Jun
 2020 07:16:19 +0000
Received: from CY4PR04MB3751.namprd04.prod.outlook.com
 ([fe80::c593:f271:eebe:ac7]) by CY4PR04MB3751.namprd04.prod.outlook.com
 ([fe80::c593:f271:eebe:ac7%9]) with mapi id 15.20.3088.028; Thu, 18 Jun 2020
 07:16:19 +0000
From:   Damien Le Moal <Damien.LeMoal@wdc.com>
To:     Kanchan Joshi <joshi.k@samsung.com>,
        "axboe@kernel.dk" <axboe@kernel.dk>,
        "viro@zeniv.linux.org.uk" <viro@zeniv.linux.org.uk>,
        "bcrl@kvack.org" <bcrl@kvack.org>
CC:     "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-aio@kvack.org" <linux-aio@kvack.org>,
        "io-uring@vger.kernel.org" <io-uring@vger.kernel.org>,
        "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>,
        "selvakuma.s1@samsung.com" <selvakuma.s1@samsung.com>,
        "nj.shetty@samsung.com" <nj.shetty@samsung.com>,
        "javier.gonz@samsung.com" <javier.gonz@samsung.com>
Subject: Re: [PATCH 1/3] fs,block: Introduce IOCB_ZONE_APPEND and direct-io
 handling
Thread-Topic: [PATCH 1/3] fs,block: Introduce IOCB_ZONE_APPEND and direct-io
 handling
Thread-Index: AQHWRMyK/3H+WyFyfUiNlOFPe93iKg==
Date:   Thu, 18 Jun 2020 07:16:19 +0000
Message-ID: <CY4PR04MB3751810405442801C115CAEBE79B0@CY4PR04MB3751.namprd04.prod.outlook.com>
References: <1592414619-5646-1-git-send-email-joshi.k@samsung.com>
 <CGME20200617172702epcas5p4dbf4729d31d9a85ab1d261d04f238e61@epcas5p4.samsung.com>
 <1592414619-5646-2-git-send-email-joshi.k@samsung.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: samsung.com; dkim=none (message not signed)
 header.d=none;samsung.com; dmarc=none action=none header.from=wdc.com;
x-originating-ip: [199.255.47.7]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: aab3b4d9-0699-4a85-771d-08d813577fb1
x-ms-traffictypediagnostic: CY4PR04MB1048:
x-microsoft-antispam-prvs: <CY4PR04MB1048506086264E0F19FF834BE79B0@CY4PR04MB1048.namprd04.prod.outlook.com>
wdcipoutbound: EOP-TRUE
x-ms-oob-tlc-oobclassifiers: OLM:8273;
x-forefront-prvs: 0438F90F17
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: PfgnKlgAUhDe06VIsGe5x9RpTHwGeQDkRXF8H7zcig35R2AoIXXEO/9ZjyxKYS+Pl7SCIWVz4rWOc/vdOBrh+b7FoXWeiFsQXw1tZHok9ClL9Hs1yI0CAKzrW9OpmvCTPaQ/+AEdrSwdrA2oCEXcifd+IFfiHQal50HD+o/oq20xicYp8+gx9baNY+QrSu6XCPzfLMAoZ8VxJTaCYVeHHjbSNfHTmRFs/YrGGsoyLHiEJlMpxb7MwwK23MYHvH+fHautfGMHaBaIbU5Nq+7oCSzesErSik3SKyl6e71P0OzaDzjD875ossXwN9AgYmoHOqMHdvaYB8V+/XTz6Prg11o2Dv/oc/SA6om7NzrdHZbBQdBEwb08BD9h0ugHB4Ci
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY4PR04MB3751.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(366004)(136003)(346002)(396003)(39860400002)(376002)(7416002)(316002)(91956017)(76116006)(6506007)(53546011)(55016002)(66946007)(8676002)(86362001)(7696005)(83380400001)(66556008)(71200400001)(66476007)(9686003)(26005)(8936002)(33656002)(66446008)(64756008)(52536014)(2906002)(478600001)(5660300002)(110136005)(4326008)(54906003)(186003)(142933001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: 5NDVdUePQJGLuO1j2jvBjawAmIDtY4WUDFsYzfn//DLHTK+BKZkngCzsa56bd4uyVXCuksLImmCSLRtQGKASjsS3AS6YdCVIgWYJ7V40mZ0J1QDjHmZjVBxLU80hUVuZNTHkuPZP/3Lep/6CW8w1rkHcikRcvZKFyXd0TZXch6Y521a1kwbsFQecnxwQemYmJgFguffix5OAiOaSgpdHxjHIxvBDAFfv7HtXz2AnJRqPh68y0F6jYq2YUNu9aVmXEaZJp/uQaBmrON8kY5kSxBo0Sy+WhbHj7b/Nmwm6OygJm0TRmdx59aBllzSkDi2IbR3CH2PP99wwicgVq+IzVYyMNcRuMYVfi2rClJwV+0PkULGH9MyS5f7HNF/4xBd6LT20cEnkcZjE+AFJuq5l/y2IC+vb2DhRCJ7R2AUumv8/5urPJUOenrD7Ri++1yj0N4KKcoUaaJlD5ZPZx1NVIFzNm7sRK0SVqXnIYqWw7U8=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-Network-Message-Id: aab3b4d9-0699-4a85-771d-08d813577fb1
X-MS-Exchange-CrossTenant-originalarrivaltime: 18 Jun 2020 07:16:19.6875
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: as5hoCgOEimoD+wr5X6HL/iQnjn5PwPCCGos5vlwvLK8R7rnOTcPDRuR6Fw4UzwioccUjFSbAyDVX62HGKXy/A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY4PR04MB1048
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 2020/06/18 2:27, Kanchan Joshi wrote:=0A=
> From: Selvakumar S <selvakuma.s1@samsung.com>=0A=
> =0A=
> Introduce IOCB_ZONE_APPEND flag, which is set in kiocb->ki_flags for=0A=
> zone-append. Direct I/O submission path uses this flag to send bio with=
=0A=
> append op. And completion path uses the same to return zone-relative=0A=
> offset to upper layer.=0A=
> =0A=
> Signed-off-by: SelvaKumar S <selvakuma.s1@samsung.com>=0A=
> Signed-off-by: Kanchan Joshi <joshi.k@samsung.com>=0A=
> Signed-off-by: Nitesh Shetty <nj.shetty@samsung.com>=0A=
> Signed-off-by: Javier Gonzalez <javier.gonz@samsung.com>=0A=
> ---=0A=
>  fs/block_dev.c     | 19 ++++++++++++++++++-=0A=
>  include/linux/fs.h |  1 +=0A=
>  2 files changed, 19 insertions(+), 1 deletion(-)=0A=
> =0A=
> diff --git a/fs/block_dev.c b/fs/block_dev.c=0A=
> index 47860e5..4c84b4d0 100644=0A=
> --- a/fs/block_dev.c=0A=
> +++ b/fs/block_dev.c=0A=
> @@ -185,6 +185,10 @@ static unsigned int dio_bio_write_op(struct kiocb *i=
ocb)=0A=
>  	/* avoid the need for a I/O completion work item */=0A=
>  	if (iocb->ki_flags & IOCB_DSYNC)=0A=
>  		op |=3D REQ_FUA;=0A=
> +#ifdef CONFIG_BLK_DEV_ZONED=0A=
> +	if (iocb->ki_flags & IOCB_ZONE_APPEND)=0A=
> +		op |=3D REQ_OP_ZONE_APPEND | REQ_NOMERGE;=0A=
> +#endif=0A=
=0A=
No need for the #ifdef. And no need for the REQ_NOMERGE either since=0A=
REQ_OP_ZONE_APPEND requests are defined as not mergeable already.=0A=
=0A=
>  	return op;=0A=
>  }=0A=
>  =0A=
> @@ -295,6 +299,14 @@ static int blkdev_iopoll(struct kiocb *kiocb, bool w=
ait)=0A=
>  	return blk_poll(q, READ_ONCE(kiocb->ki_cookie), wait);=0A=
>  }=0A=
>  =0A=
> +#ifdef CONFIG_BLK_DEV_ZONED=0A=
> +static inline long blkdev_bio_end_io_append(struct bio *bio)=0A=
> +{=0A=
> +	return (bio->bi_iter.bi_sector %=0A=
> +		blk_queue_zone_sectors(bio->bi_disk->queue)) << SECTOR_SHIFT;=0A=
=0A=
A zone size is at most 4G sectors as defined by the queue chunk_sectors lim=
it=0A=
(unsigned int). It means that the return value here can overflow due to the=
=0A=
shift, at least on 32bits arch.=0A=
=0A=
And as Pavel already commented, zone sizes are power of 2 so you can use=0A=
bitmasks instead of costly divisions.=0A=
=0A=
> +}=0A=
> +#endif=0A=
> +=0A=
>  static void blkdev_bio_end_io(struct bio *bio)=0A=
>  {=0A=
>  	struct blkdev_dio *dio =3D bio->bi_private;=0A=
> @@ -307,15 +319,20 @@ static void blkdev_bio_end_io(struct bio *bio)=0A=
>  		if (!dio->is_sync) {=0A=
>  			struct kiocb *iocb =3D dio->iocb;=0A=
>  			ssize_t ret;=0A=
> +			long res =3D 0;=0A=
>  =0A=
>  			if (likely(!dio->bio.bi_status)) {=0A=
>  				ret =3D dio->size;=0A=
>  				iocb->ki_pos +=3D ret;=0A=
> +#ifdef CONFIG_BLK_DEV_ZONED=0A=
> +				if (iocb->ki_flags & IOCB_ZONE_APPEND)=0A=
> +					res =3D blkdev_bio_end_io_append(bio);=0A=
=0A=
overflow... And no need for the #ifdef.=0A=
=0A=
> +#endif=0A=
>  			} else {=0A=
>  				ret =3D blk_status_to_errno(dio->bio.bi_status);=0A=
>  			}=0A=
>  =0A=
> -			dio->iocb->ki_complete(iocb, ret, 0);=0A=
> +			dio->iocb->ki_complete(iocb, ret, res);=0A=
=0A=
ki_complete interface also needs to be changed to have a 64bit last argumen=
t to=0A=
avoid overflow.=0A=
=0A=
And this all does not work anyway because __blkdev_direct_IO() and=0A=
__blkdev_direct_IO_simple() both call bio_iov_iter_get_pages() *before*=0A=
dio_bio_write_op() is called. This means that bio_iov_iter_get_pages() will=
 not=0A=
see that it needs to get the pages for a zone append command and so will no=
t=0A=
call __bio_iov_append_get_pages(). That leads to BIO split and potential=0A=
corruption of the user data as fragments of the kiocb may get reordered.=0A=
=0A=
There is a lot more to do to the block_dev direct IO code for this to work.=
=0A=
=0A=
=0A=
>  			if (dio->multi_bio)=0A=
>  				bio_put(&dio->bio);=0A=
>  		} else {=0A=
> diff --git a/include/linux/fs.h b/include/linux/fs.h=0A=
> index 6c4ab4d..dc547b9 100644=0A=
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
> =0A=
=0A=
=0A=
-- =0A=
Damien Le Moal=0A=
Western Digital Research=0A=
