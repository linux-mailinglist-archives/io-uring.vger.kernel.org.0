Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9D7731FEC9F
	for <lists+io-uring@lfdr.de>; Thu, 18 Jun 2020 09:40:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728073AbgFRHkB (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 18 Jun 2020 03:40:01 -0400
Received: from esa3.hgst.iphmx.com ([216.71.153.141]:24295 "EHLO
        esa3.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728072AbgFRHkB (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 18 Jun 2020 03:40:01 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1592466001; x=1624002001;
  h=from:to:cc:subject:date:message-id:references:
   content-transfer-encoding:mime-version;
  bh=9hT9kvzRTHWAb+DadF1d3pEtWKpc97dbPwSU/judq+E=;
  b=IHzgLwAXJHSrP5wanyRV1gxvfDoFqHBdct6rAb0Bif5xqRBHJ9JPehua
   8UFJ8Pi9KskiBHDwRTKk3qKkbnzJbl8QDqDE1OEAgZ/3+scw7NTquEhic
   48NsGvieX1BuzcV9vdvrUcWFAmkjdzeCc00mDCXHnXlBOyQJC8MMx1pA3
   bRq9j7Z6U8ZbMgKulGPFM2lLEoy0PiTlHkR1ZsHmylUM56nxshuVWOvvB
   4ad2P9oQfJWzP0hSMQpAwvy0vpuoXuLkuq/Hb//l2tB7ezMz39zIc71AQ
   D8U+wiNaCNBTmyGTxOUWUHx+O6jv6Q8bEOHeYwFK+yYLnObopZVbCjRuf
   A==;
IronPort-SDR: bcPhnksmsCi51yECEl7BMEM4q6VRW3SDDa62ADnJxkkZjNpIotPK6WsSC78iPjox2yqVcHddwd
 CHB/XJ2LDbpGyCYxdvbVskQobPSm4rlxwxcmBAz321VHTpL51GtCYAVHmvadx+kDCIwwBjC2GS
 7iqrHGD0UYO2+9ZTKoJAjybO7URLWCyu6Hkp05kkoD4fftmWH+bV+Z1QtDJfOVEoLlrSrH9d5x
 qhlYww+INXV/cv3wmOYl+VAK0pBqCM+olKGYVT+p8NGLfCViDm2/nZNFrWOVGWNd3WTiam4xAP
 nFE=
X-IronPort-AV: E=Sophos;i="5.73,525,1583164800"; 
   d="scan'208";a="144618477"
Received: from mail-mw2nam10lp2107.outbound.protection.outlook.com (HELO NAM10-MW2-obe.outbound.protection.outlook.com) ([104.47.55.107])
  by ob1.hgst.iphmx.com with ESMTP; 18 Jun 2020 15:40:00 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=HfjCGnu1ehry2bVvRT5OS3uiiQHwG5KQkQj92pPGUOJltBn3Su3axpql5zGyI0+j4go1oxj3hvSFoVnwGewmT827fo638pze482SAQX413+eurFX6s6a40/1lNBPOL/tBq1I6XW9xE2qKziAfAi0Bm9+63I39+s9Irk2vmKDYYvdAFNdr63PVHItH0EWV0yi+rOjTDgOnPxDgEglS2WmAC3+A6OavT+5RfEiQSlW/+jBC6IJN8XiIQi4LXTfPz2ZNYecrp7EDUbUwkO6i9jX7RMA8JT0jm8lcceAXzblHSzZj0UT9e6CZ7exNqUWI1Ai84MyvCaAUAnQPEVoa55YjQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=qh3N+20nitalPhxv2W5Nr3gOnvCJOZUOpb//TMnNzaA=;
 b=drrBiePIhagcE1ZR76V2G6G97+pbD6IWMQrzgsjVxQ6HP/5tUN+oUyn7mHIuygrgbadVsdid69BHKfNbP4v1Y3W1/Ku7jmlWf12vbhlaJkUMsezf8LMX9vGLpPRq6CjYNMfUzMcYnyFJ7LeAhGJB0wuOrO8GDmphigEy+8iFxXqf+Ax9krslUvdQWATTc7boheyc7kSTK3qzLUBxBngae0k7dAAFJlCk2tf1dmeZB3UbVc5yQhCC+I8cjXGMPxAG1r6oaUAYZ//p96f6GIua2rtYDU4RwbS0NptW9ly6jUQn0l8tEbJNsUrA1uRTiuR2R+9FLi+Zvp+1EL19IrZcBw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=qh3N+20nitalPhxv2W5Nr3gOnvCJOZUOpb//TMnNzaA=;
 b=LZ7ah9CKKl9eo9bxatpBmqtXuIuYL4N29mgHRHdrSxUPhpcaGVKEDs6gFRoseK1bGw5l4DLKBjskIRxDs194NILsai10lq8Yb8lbVbvWmxUJ2aOLIPwUffU0uU9iDGWULz+QPiVwYYR42pIC114zKLD2BW1ZNiLa118twRk1ydY=
Received: from CY4PR04MB3751.namprd04.prod.outlook.com (2603:10b6:903:ec::14)
 by CY4PR0401MB3586.namprd04.prod.outlook.com (2603:10b6:910:8e::29) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3088.21; Thu, 18 Jun
 2020 07:39:58 +0000
Received: from CY4PR04MB3751.namprd04.prod.outlook.com
 ([fe80::c593:f271:eebe:ac7]) by CY4PR04MB3751.namprd04.prod.outlook.com
 ([fe80::c593:f271:eebe:ac7%9]) with mapi id 15.20.3088.028; Thu, 18 Jun 2020
 07:39:58 +0000
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
Subject: Re: [PATCH 3/3] io_uring: add support for zone-append
Thread-Topic: [PATCH 3/3] io_uring: add support for zone-append
Thread-Index: AQHWRMyUe8chR0VkUU2K4ON9AWdJKQ==
Date:   Thu, 18 Jun 2020 07:39:58 +0000
Message-ID: <CY4PR04MB37510E916B6F243D189B4EB0E79B0@CY4PR04MB3751.namprd04.prod.outlook.com>
References: <1592414619-5646-1-git-send-email-joshi.k@samsung.com>
 <CGME20200617172713epcas5p352f2907a12bd4ee3c97be1c7d8e1569e@epcas5p3.samsung.com>
 <1592414619-5646-4-git-send-email-joshi.k@samsung.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: samsung.com; dkim=none (message not signed)
 header.d=none;samsung.com; dmarc=none action=none header.from=wdc.com;
x-originating-ip: [199.255.47.7]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: f65a2c01-f6e3-4afb-792a-08d8135acd68
x-ms-traffictypediagnostic: CY4PR0401MB3586:
x-microsoft-antispam-prvs: <CY4PR0401MB3586A3C1048FA8395FD758A3E79B0@CY4PR0401MB3586.namprd04.prod.outlook.com>
wdcipoutbound: EOP-TRUE
x-ms-oob-tlc-oobclassifiers: OLM:1122;
x-forefront-prvs: 0438F90F17
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 0wuH81qlgwpD5YgjZiZWLwhsss0xCH5ERI8i2aIdPSNeyOGLn2BeDqD+AvmJGJkZo8Hv0NcaXk8kxLlcOou77iBcbiO+OxFprux3mCiRIF5cwV+BH0jirvMjCrwkBEIUsDRgERwVwn3R87yoNiZtMzAiazGRci7mkMA1//lbu/ByLEIpj0Re6ltygNoRWRDN0ukl7I+pvIOzFgdRuwXHHf+MoFSJRD3ceAI26Ysk25e1XW8jbHIUKLxwabtmMtIhFmRhNbSfLWNxzpbkPzX0FRFxoikHiyFXgMdElpm+u96M4+/Yk8xdOAbACr9AiGAfekNF9rEQSP7OVsh7R1f8OQ==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY4PR04MB3751.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(366004)(396003)(346002)(39860400002)(136003)(376002)(64756008)(66476007)(91956017)(76116006)(5660300002)(66946007)(66446008)(4326008)(71200400001)(55016002)(6506007)(53546011)(66556008)(9686003)(7696005)(33656002)(2906002)(83380400001)(86362001)(186003)(26005)(52536014)(8676002)(7416002)(316002)(54906003)(110136005)(8936002)(478600001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: iGNsRGefjuUGsYjbajN6xNNAU7bAFArakeW20ZdGpAylwOhPAeiYZW/305HlOl5GEja21vCfvFeYF30Yc+lBqmnIIOztB7WPOmMoPhH6cAN/CYpM7GlDxVNrfmGtBTaLRLXFt5lefAHW7CF5QalUw377igOB9h+LXAM4oBPBLN3iJU/yN87NoOWw17Qa95apkRbEi+Um2rtvwljelZsNYnLaMVYPIlg9Tj4bTFM1IUbLIn4z+mrEbh5uAHyAiv5ttxug3zGHSAmd3wOMED4XEPxRBim3ec47EW4vul5gydQPbA1WHYY7asVPr+lDOEcG0P6suCkqapMMSQJQdcFn1kDV+ueTRpeHyxBfd9Cy7muggNQi5JDHY+YhmzyxotjbjrhiDnkNDaR+qTxLeJsa7FTmvJl/hGcht/umx+CfWuxPGY7ecTr1nXoQc1jSE+Mc9jvJYZTRpl9eH/XL8HLAe0a1TjHV/gNmfEY2dfTdUIM=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f65a2c01-f6e3-4afb-792a-08d8135acd68
X-MS-Exchange-CrossTenant-originalarrivaltime: 18 Jun 2020 07:39:58.5536
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: Xu+c02sjtkU4uNRAUzrDGz4amiK/SWUQT2WqRy/iT0My/ThA9LxU38rnOa5spqA44VLf5sQLeqP1Tx5wHrrocA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY4PR0401MB3586
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 2020/06/18 2:27, Kanchan Joshi wrote:=0A=
> From: Selvakumar S <selvakuma.s1@samsung.com>=0A=
> =0A=
> Introduce three new opcodes for zone-append -=0A=
> =0A=
>    IORING_OP_ZONE_APPEND     : non-vectord, similiar to IORING_OP_WRITE=
=0A=
>    IORING_OP_ZONE_APPENDV    : vectored, similar to IORING_OP_WRITEV=0A=
>    IORING_OP_ZONE_APPEND_FIXED : append using fixed-buffers=0A=
> =0A=
> Repurpose cqe->flags to return zone-relative offset.=0A=
> =0A=
> Signed-off-by: SelvaKumar S <selvakuma.s1@samsung.com>=0A=
> Signed-off-by: Kanchan Joshi <joshi.k@samsung.com>=0A=
> Signed-off-by: Nitesh Shetty <nj.shetty@samsung.com>=0A=
> Signed-off-by: Javier Gonzalez <javier.gonz@samsung.com>=0A=
> ---=0A=
>  fs/io_uring.c                 | 72 +++++++++++++++++++++++++++++++++++++=
++++--=0A=
>  include/uapi/linux/io_uring.h |  8 ++++-=0A=
>  2 files changed, 77 insertions(+), 3 deletions(-)=0A=
> =0A=
> diff --git a/fs/io_uring.c b/fs/io_uring.c=0A=
> index 155f3d8..c14c873 100644=0A=
> --- a/fs/io_uring.c=0A=
> +++ b/fs/io_uring.c=0A=
> @@ -649,6 +649,10 @@ struct io_kiocb {=0A=
>  	unsigned long		fsize;=0A=
>  	u64			user_data;=0A=
>  	u32			result;=0A=
> +#ifdef CONFIG_BLK_DEV_ZONED=0A=
> +	/* zone-relative offset for append, in bytes */=0A=
> +	u32			append_offset;=0A=
=0A=
this can overflow. u64 is needed.=0A=
=0A=
> +#endif=0A=
>  	u32			sequence;=0A=
>  =0A=
>  	struct list_head	link_list;=0A=
> @@ -875,6 +879,26 @@ static const struct io_op_def io_op_defs[] =3D {=0A=
>  		.hash_reg_file		=3D 1,=0A=
>  		.unbound_nonreg_file	=3D 1,=0A=
>  	},=0A=
> +	[IORING_OP_ZONE_APPEND] =3D {=0A=
> +		.needs_mm               =3D 1,=0A=
> +		.needs_file             =3D 1,=0A=
> +		.unbound_nonreg_file    =3D 1,=0A=
> +		.pollout		=3D 1,=0A=
> +	},=0A=
> +	[IORING_OP_ZONE_APPENDV] =3D {=0A=
> +	       .async_ctx              =3D 1,=0A=
> +	       .needs_mm               =3D 1,=0A=
> +	       .needs_file             =3D 1,=0A=
> +	       .hash_reg_file          =3D 1,=0A=
> +	       .unbound_nonreg_file    =3D 1,=0A=
> +	       .pollout			=3D 1,=0A=
> +	},=0A=
> +	[IORING_OP_ZONE_APPEND_FIXED] =3D {=0A=
> +	       .needs_file             =3D 1,=0A=
> +	       .hash_reg_file          =3D 1,=0A=
> +	       .unbound_nonreg_file    =3D 1,=0A=
> +	       .pollout			=3D 1,=0A=
> +	},=0A=
>  };=0A=
>  =0A=
>  static void io_wq_submit_work(struct io_wq_work **workptr);=0A=
> @@ -1285,7 +1309,16 @@ static void __io_cqring_fill_event(struct io_kiocb=
 *req, long res, long cflags)=0A=
>  	if (likely(cqe)) {=0A=
>  		WRITE_ONCE(cqe->user_data, req->user_data);=0A=
>  		WRITE_ONCE(cqe->res, res);=0A=
> +#ifdef CONFIG_BLK_DEV_ZONED=0A=
> +		if (req->opcode =3D=3D IORING_OP_ZONE_APPEND ||=0A=
> +				req->opcode =3D=3D IORING_OP_ZONE_APPENDV ||=0A=
> +				req->opcode =3D=3D IORING_OP_ZONE_APPEND_FIXED)=0A=
> +			WRITE_ONCE(cqe->res2, req->append_offset);=0A=
> +		else=0A=
> +			WRITE_ONCE(cqe->flags, cflags);=0A=
> +#else=0A=
>  		WRITE_ONCE(cqe->flags, cflags);=0A=
> +#endif=0A=
>  	} else if (ctx->cq_overflow_flushed) {=0A=
>  		WRITE_ONCE(ctx->rings->cq_overflow,=0A=
>  				atomic_inc_return(&ctx->cached_cq_overflow));=0A=
> @@ -1961,6 +1994,9 @@ static void io_complete_rw_common(struct kiocb *kio=
cb, long res)=0A=
>  static void io_complete_rw(struct kiocb *kiocb, long res, long res2)=0A=
>  {=0A=
>  	struct io_kiocb *req =3D container_of(kiocb, struct io_kiocb, rw.kiocb)=
;=0A=
> +#ifdef CONFIG_BLK_DEV_ZONED=0A=
> +	req->append_offset =3D (u32)res2;=0A=
> +#endif=0A=
>  =0A=
>  	io_complete_rw_common(kiocb, res);=0A=
>  	io_put_req(req);=0A=
> @@ -1976,6 +2012,9 @@ static void io_complete_rw_iopoll(struct kiocb *kio=
cb, long res, long res2)=0A=
>  	if (res !=3D req->result)=0A=
>  		req_set_fail_links(req);=0A=
>  	req->result =3D res;=0A=
> +#ifdef CONFIG_BLK_DEV_ZONED=0A=
> +	req->append_offset =3D (u32)res2;=0A=
> +#endif=0A=
>  	if (res !=3D -EAGAIN)=0A=
>  		WRITE_ONCE(req->iopoll_completed, 1);=0A=
>  }=0A=
> @@ -2408,7 +2447,8 @@ static ssize_t io_import_iovec(int rw, struct io_ki=
ocb *req,=0A=
>  	u8 opcode;=0A=
>  =0A=
>  	opcode =3D req->opcode;=0A=
> -	if (opcode =3D=3D IORING_OP_READ_FIXED || opcode =3D=3D IORING_OP_WRITE=
_FIXED) {=0A=
> +	if (opcode =3D=3D IORING_OP_READ_FIXED || opcode =3D=3D IORING_OP_WRITE=
_FIXED ||=0A=
> +			opcode =3D=3D IORING_OP_ZONE_APPEND_FIXED) {=0A=
>  		*iovec =3D NULL;=0A=
>  		return io_import_fixed(req, rw, iter);=0A=
>  	}=0A=
> @@ -2417,7 +2457,8 @@ static ssize_t io_import_iovec(int rw, struct io_ki=
ocb *req,=0A=
>  	if (req->buf_index && !(req->flags & REQ_F_BUFFER_SELECT))=0A=
>  		return -EINVAL;=0A=
>  =0A=
> -	if (opcode =3D=3D IORING_OP_READ || opcode =3D=3D IORING_OP_WRITE) {=0A=
> +	if (opcode =3D=3D IORING_OP_READ || opcode =3D=3D IORING_OP_WRITE ||=0A=
> +			opcode =3D=3D IORING_OP_ZONE_APPEND) {=0A=
>  		if (req->flags & REQ_F_BUFFER_SELECT) {=0A=
>  			buf =3D io_rw_buffer_select(req, &sqe_len, needs_lock);=0A=
>  			if (IS_ERR(buf)) {=0A=
> @@ -2704,6 +2745,9 @@ static int io_write(struct io_kiocb *req, bool forc=
e_nonblock)=0A=
>  		req->rw.kiocb.ki_flags &=3D ~IOCB_NOWAIT;=0A=
>  =0A=
>  	req->result =3D 0;=0A=
> +#ifdef CONFIG_BLK_DEV_ZONED=0A=
> +	req->append_offset =3D 0;=0A=
> +#endif=0A=
>  	io_size =3D ret;=0A=
>  	if (req->flags & REQ_F_LINK_HEAD)=0A=
>  		req->result =3D io_size;=0A=
> @@ -2738,6 +2782,13 @@ static int io_write(struct io_kiocb *req, bool for=
ce_nonblock)=0A=
>  			__sb_writers_release(file_inode(req->file)->i_sb,=0A=
>  						SB_FREEZE_WRITE);=0A=
>  		}=0A=
> +#ifdef CONFIG_BLK_DEV_ZONED=0A=
> +		if (req->opcode =3D=3D IORING_OP_ZONE_APPEND ||=0A=
> +				req->opcode =3D=3D IORING_OP_ZONE_APPENDV ||=0A=
> +				req->opcode =3D=3D IORING_OP_ZONE_APPEND_FIXED)=0A=
> +			kiocb->ki_flags |=3D IOCB_ZONE_APPEND;=0A=
> +#endif=0A=
> +=0A=
>  		kiocb->ki_flags |=3D IOCB_WRITE;=0A=
>  =0A=
>  		if (!force_nonblock)=0A=
> @@ -4906,6 +4957,12 @@ static int io_req_defer_prep(struct io_kiocb *req,=
=0A=
>  	case IORING_OP_WRITEV:=0A=
>  	case IORING_OP_WRITE_FIXED:=0A=
>  	case IORING_OP_WRITE:=0A=
> +#ifdef CONFIG_BLK_DEV_ZONED=0A=
> +	fallthrough;=0A=
> +	case IORING_OP_ZONE_APPEND:=0A=
> +	case IORING_OP_ZONE_APPENDV:=0A=
> +	case IORING_OP_ZONE_APPEND_FIXED:=0A=
> +#endif=0A=
>  		ret =3D io_write_prep(req, sqe, true);=0A=
>  		break;=0A=
>  	case IORING_OP_POLL_ADD:=0A=
> @@ -5038,6 +5095,12 @@ static void io_cleanup_req(struct io_kiocb *req)=
=0A=
>  	case IORING_OP_WRITEV:=0A=
>  	case IORING_OP_WRITE_FIXED:=0A=
>  	case IORING_OP_WRITE:=0A=
> +#ifdef CONFIG_BLK_DEV_ZONED=0A=
> +	fallthrough;=0A=
> +	case IORING_OP_ZONE_APPEND:=0A=
> +	case IORING_OP_ZONE_APPENDV:=0A=
> +	case IORING_OP_ZONE_APPEND_FIXED:=0A=
> +#endif=0A=
>  		if (io->rw.iov !=3D io->rw.fast_iov)=0A=
>  			kfree(io->rw.iov);=0A=
>  		break;=0A=
> @@ -5086,6 +5149,11 @@ static int io_issue_sqe(struct io_kiocb *req, cons=
t struct io_uring_sqe *sqe,=0A=
>  		}=0A=
>  		ret =3D io_read(req, force_nonblock);=0A=
>  		break;=0A=
> +#ifdef CONFIG_BLK_DEV_ZONED=0A=
> +	case IORING_OP_ZONE_APPEND:=0A=
> +	case IORING_OP_ZONE_APPENDV:=0A=
> +	case IORING_OP_ZONE_APPEND_FIXED:=0A=
> +#endif=0A=
>  	case IORING_OP_WRITEV:=0A=
>  	case IORING_OP_WRITE_FIXED:=0A=
>  	case IORING_OP_WRITE:=0A=
> diff --git a/include/uapi/linux/io_uring.h b/include/uapi/linux/io_uring.=
h=0A=
> index 92c2269..6c8e932 100644=0A=
> --- a/include/uapi/linux/io_uring.h=0A=
> +++ b/include/uapi/linux/io_uring.h=0A=
> @@ -130,6 +130,9 @@ enum {=0A=
>  	IORING_OP_PROVIDE_BUFFERS,=0A=
>  	IORING_OP_REMOVE_BUFFERS,=0A=
>  	IORING_OP_TEE,=0A=
> +	IORING_OP_ZONE_APPEND,=0A=
> +	IORING_OP_ZONE_APPENDV,=0A=
> +	IORING_OP_ZONE_APPEND_FIXED,=0A=
>  =0A=
>  	/* this goes last, obviously */=0A=
>  	IORING_OP_LAST,=0A=
> @@ -157,7 +160,10 @@ enum {=0A=
>  struct io_uring_cqe {=0A=
>  	__u64	user_data;	/* sqe->data submission passed back */=0A=
>  	__s32	res;		/* result code for this event */=0A=
> -	__u32	flags;=0A=
> +	union {=0A=
> +		__u32	res2; /* res2 like aio, currently used for zone-append */=0A=
> +		__u32	flags;=0A=
> +	};=0A=
>  };=0A=
>  =0A=
>  /*=0A=
> =0A=
=0A=
=0A=
-- =0A=
Damien Le Moal=0A=
Western Digital Research=0A=
