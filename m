Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5EEB61FEC8C
	for <lists+io-uring@lfdr.de>; Thu, 18 Jun 2020 09:34:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728115AbgFRHeK (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 18 Jun 2020 03:34:10 -0400
Received: from esa2.hgst.iphmx.com ([68.232.143.124]:53394 "EHLO
        esa2.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727010AbgFRHeJ (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 18 Jun 2020 03:34:09 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1592465650; x=1624001650;
  h=from:to:cc:subject:date:message-id:references:
   content-transfer-encoding:mime-version;
  bh=Jrd76W3vWf5YvMODpLz3UJc2qBFNhXF5ghev1kZQVZ4=;
  b=XmSuAbvrGrgGvRBVJgGnhRCMYYFQ6rUTrMqdG/NDTyceiqYkU77Fq/bx
   dbpy4F511rKKaW9E/cia7s5czad3RNnsMetwAE6IpMabnghuNlkvSXCjR
   9R0uPz7MsnaZWDHVpS9I7B4QAc+JZEmEAMXMtc5sjf8HxltBMg3cixfjB
   pxPmOmOk8+oiM2VhiW+8smCpx1l4hXkkLUUQ79BVu5zO/IxgWJ0y8S0TN
   pD1KPpaerQKRS0XdGbBsJw0CDrADPeIkWb28DUdj9csKnGaRy9kWJtCmt
   ZFpB6L1njNf4S++K8jUlSbfdDhlqfXtslqK6niy//RkMPkSL6WDDwVrhw
   w==;
IronPort-SDR: BYHn6QN5h9R3n9mCFBVAMmQAWyhR5+6/9ru9SGuKlceSGfcMsWG762ZwOwR/8FlyjB82+TaEk2
 MT5lLN2L28tjLqwk+JfHWb4H18h/PqELfRxyYf0agU7wm3Eyq1t3BDZx4tB8Inxrsx+2GB80ml
 nANoML5gx4aIY4rsYrnPpar7LeLguHvO7EaQOByi0ykKThCZ33RIZ525PFzOlUX/tJomvhS9+8
 g9p7W86wXMK0KjqaigtFsRt8lXy7gbkl3IE/uAIfpP9+F/XhjPOYC5eRgynIipve8e8yQhLxrK
 8y8=
X-IronPort-AV: E=Sophos;i="5.73,525,1583164800"; 
   d="scan'208";a="243255797"
Received: from mail-dm6nam12lp2170.outbound.protection.outlook.com (HELO NAM12-DM6-obe.outbound.protection.outlook.com) ([104.47.59.170])
  by ob1.hgst.iphmx.com with ESMTP; 18 Jun 2020 15:34:18 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=MxSbRDrJ74ZsVrG1EcwLJceU48OLZVAD6qs9zPsUG93MK/AfWvWT6FEZ7NJzpg5wBEFO9xrZY0B/5UzvNPawbPBWZ0mHLP3M23GIYlZ1/enWk/0VAKGFBLgzwwbZec2zt70PWvFxlwwiiaC87fBEG5+9VaF1TbHf46MOn88T6PodXiTBXzeM01BXfomv7JPJdDqnZA+93DY+r3WPN0xzIWfgLIsbLY5uCzRs0bEyJ51ZcxOVXaPFEI477qzEUOm3uXdJ0xFkAyt/EyPospY7jSE+3EVe66JSpBQWhnR4T6XtY43oaoATdSxfG4Q/g8zizUFrO07SKg9iCfXv8zwgPw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=DxEbsjfut2DvNvAKenKWv+MRXjpECuOqiGSUQHWq/OA=;
 b=YcmiLkbBv3Z9JbeVWuo6BffdDJgJyLqF4TaoEFssqWdVwBBdFLu1qFd87r2vdpQK/mHGGL53PCkEAQi1QQKF8Bj77Y0cK320ZoVJxRWSpoiJ1D9mwYwl98UA1upJWqWM4Wui5M2sppKI9X4FBhQtjGuK7bLoykQtPsGGJN6uB8YklS1LHiAk+tWvc1F3yk2dgnDz66M1WySeTcj0Lrn75QZGBckHVukm/6ASWFhCT6XaRNbdH/zpQ6SS6zlFyg8IQ0VfySCNuYHhoNyynWWV/aSeLOeOFEzWSZ2w6J5Y0J91Q6SRIuZe4BhLZLa2g3rZXSAc2Ka42Y0Ba+UOzK9JDQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=DxEbsjfut2DvNvAKenKWv+MRXjpECuOqiGSUQHWq/OA=;
 b=GW6PXRV39yUPeRnK3L9bh47AmrzW/5xcPthOLglqn69RlTSm11/ojssxjGGswTEcq6ZHa/8F56JD+ZVCBjZu+vW1uKVqW50CkKw/TL0w4Nvh4uNDZ+okN2EqBiDUllegz9WNcNWHJP/2YXfAoSOzYXsvfUBnikWYbR9H7skwWkM=
Received: from CY4PR04MB3751.namprd04.prod.outlook.com (2603:10b6:903:ec::14)
 by CY4PR04MB0566.namprd04.prod.outlook.com (2603:10b6:903:b5::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3109.22; Thu, 18 Jun
 2020 07:33:57 +0000
Received: from CY4PR04MB3751.namprd04.prod.outlook.com
 ([fe80::c593:f271:eebe:ac7]) by CY4PR04MB3751.namprd04.prod.outlook.com
 ([fe80::c593:f271:eebe:ac7%9]) with mapi id 15.20.3088.028; Thu, 18 Jun 2020
 07:33:57 +0000
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
        "javier.gonz@samsung.com" <javier.gonz@samsung.com>,
        Arnav Dawn <a.dawn@samsung.com>
Subject: Re: [PATCH 2/3] aio: add support for zone-append
Thread-Topic: [PATCH 2/3] aio: add support for zone-append
Thread-Index: AQHWRMyOokzJw5oqGEuSZawTmRChPw==
Date:   Thu, 18 Jun 2020 07:33:57 +0000
Message-ID: <CY4PR04MB3751B6D692F59810AF6D52D7E79B0@CY4PR04MB3751.namprd04.prod.outlook.com>
References: <1592414619-5646-1-git-send-email-joshi.k@samsung.com>
 <CGME20200617172706epcas5p4dcbc164063f58bad95b211b9d6dfbfa9@epcas5p4.samsung.com>
 <1592414619-5646-3-git-send-email-joshi.k@samsung.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: samsung.com; dkim=none (message not signed)
 header.d=none;samsung.com; dmarc=none action=none header.from=wdc.com;
x-originating-ip: [199.255.47.7]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: a8a0e410-a02f-46cf-c38b-08d81359f640
x-ms-traffictypediagnostic: CY4PR04MB0566:
x-microsoft-antispam-prvs: <CY4PR04MB0566700A35C05FBBF7B5F32EE79B0@CY4PR04MB0566.namprd04.prod.outlook.com>
wdcipoutbound: EOP-TRUE
x-ms-oob-tlc-oobclassifiers: OLM:1284;
x-forefront-prvs: 0438F90F17
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: jkHOfEFHOmous4CVU0B9OoRuh4U/GCNf+9iz56SMKxVEkSdhZ5MctnBX97aQBcSLkivysihLOBajKtj1wfZqeBEpEl5+Inpzi3ATuQ37U4cJxZMZdTYCcl7MzED8Bv3FJxFgUknqDzVzi86/eZn3zhKAUwv6+GUAqWNqHiMQxoMal/XsjS+InVPBpBCD5Hq/7hvgexm4heJr9bDeiSCBhx3pkvylD+rDAoYBAc5VgbixxFRO4wjerdBH5c5KWP2/4z2AUfdFkkieOmV+pf4lCueHfK5OWSVWPAt0Dv6cRJlARWcG566V8AjKEUo5uxNkzgDZ0HXjNNE1WliLRkfiDg==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY4PR04MB3751.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(136003)(346002)(366004)(39860400002)(376002)(396003)(110136005)(8676002)(5660300002)(8936002)(71200400001)(7416002)(2906002)(52536014)(478600001)(4326008)(55016002)(9686003)(316002)(66946007)(66476007)(66556008)(66446008)(64756008)(91956017)(76116006)(7696005)(26005)(186003)(33656002)(53546011)(6506007)(86362001)(54906003);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: BPEWvbSf0svhs+9q7KsevJ4UHdRMaGO/6fCui7Ie1y2hOPwO1K7/TQw6pTA7pZBFNDUsrinOwWLJXMrs8E8iwpObBoEe/wFuI5wNqlliC2cLBv6Q4KyesEPbEMq52VKpn5TpL5I1pLQ6nlxAeXLU2TcJqD1Vu9Y1HqPDS25J+5+ToLkhaHTCfDI/H4BSQmlDq2TlLzXbeVH4xTUh/0a0hGvDEHAxbx1gKI7IwErPgmvHWqY0StS8GzreobWgfFOf+6XUroCFbWnkkRlwrytKZ5hvABI7ZP4FiVWybgzyFkIO/g9rUDlNAQZbVDBI/m5SsYpp5nPTkbstuy9NwiT5eSh+pjsmsObJ9RCA+3DloiqiDxTzEpUYbmWfw4R0/9S378BWTFT5sXl6I0bb9tsk6Lrv8Ra1g92JweAQ2xkYru8Ivik2xbO+jXwOGonliZUfWjDhiYwxlT11A4Z5jHEa3s5zmhvGb7eKPvJioM636Bc=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a8a0e410-a02f-46cf-c38b-08d81359f640
X-MS-Exchange-CrossTenant-originalarrivaltime: 18 Jun 2020 07:33:57.5292
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: smPS/Rh1zGKTJFYZ275wTM4NCv5Ld1vd96HwxyX59hTFT9nfj/UO3auKEfiDFV9Q2pPuPxYSud2QR8IzW9kKJA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY4PR04MB0566
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 2020/06/18 2:27, Kanchan Joshi wrote:=0A=
> Introduce IOCB_CMD_ZONE_APPEND opcode for zone-append. On append=0A=
> completion zone-relative offset is returned using io_event->res2.=0A=
> =0A=
> Signed-off-by: Kanchan Joshi <joshi.k@samsung.com>=0A=
> Signed-off-by: Arnav Dawn <a.dawn@samsung.com>=0A=
> Signed-off-by: SelvaKumar S <selvakuma.s1@samsung.com>=0A=
> Signed-off-by: Nitesh Shetty <nj.shetty@samsung.com>=0A=
> Signed-off-by: Javier Gonzalez <javier.gonz@samsung.com>=0A=
> ---=0A=
>  fs/aio.c                     | 8 ++++++++=0A=
>  include/uapi/linux/aio_abi.h | 1 +=0A=
>  2 files changed, 9 insertions(+)=0A=
> =0A=
> diff --git a/fs/aio.c b/fs/aio.c=0A=
> index 7ecddc2..8b10a55d 100644=0A=
> --- a/fs/aio.c=0A=
> +++ b/fs/aio.c=0A=
> @@ -1579,6 +1579,10 @@ static int aio_write(struct kiocb *req, const stru=
ct iocb *iocb,=0A=
>  			__sb_start_write(file_inode(file)->i_sb, SB_FREEZE_WRITE, true);=0A=
>  			__sb_writers_release(file_inode(file)->i_sb, SB_FREEZE_WRITE);=0A=
>  		}=0A=
> +#ifdef CONFIG_BLK_DEV_ZONED=0A=
> +		if (iocb->aio_lio_opcode =3D=3D IOCB_CMD_ZONE_APPEND)=0A=
> +			req->ki_flags |=3D IOCB_ZONE_APPEND;=0A=
> +#endif=0A=
>  		req->ki_flags |=3D IOCB_WRITE;=0A=
>  		aio_rw_done(req, call_write_iter(file, req, &iter));=0A=
>  	}=0A=
> @@ -1846,6 +1850,10 @@ static int __io_submit_one(struct kioctx *ctx, con=
st struct iocb *iocb,=0A=
>  		return aio_fsync(&req->fsync, iocb, true);=0A=
>  	case IOCB_CMD_POLL:=0A=
>  		return aio_poll(req, iocb);=0A=
> +#ifdef CONFIG_BLK_DEV_ZONED=0A=
> +	case IOCB_CMD_ZONE_APPEND:=0A=
> +		return aio_write(&req->rw, iocb, false, compat);=0A=
> +#endif=0A=
>  	default:=0A=
>  		pr_debug("invalid aio operation %d\n", iocb->aio_lio_opcode);=0A=
>  		return -EINVAL;=0A=
> diff --git a/include/uapi/linux/aio_abi.h b/include/uapi/linux/aio_abi.h=
=0A=
> index 8387e0a..541d96a 100644=0A=
> --- a/include/uapi/linux/aio_abi.h=0A=
> +++ b/include/uapi/linux/aio_abi.h=0A=
> @@ -43,6 +43,7 @@ enum {=0A=
>  	IOCB_CMD_NOOP =3D 6,=0A=
>  	IOCB_CMD_PREADV =3D 7,=0A=
>  	IOCB_CMD_PWRITEV =3D 8,=0A=
> +	IOCB_CMD_ZONE_APPEND =3D 9,=0A=
>  };=0A=
>  =0A=
>  /*=0A=
> =0A=
=0A=
No need for all the #ifdefs.=0A=
=0A=
-- =0A=
Damien Le Moal=0A=
Western Digital Research=0A=
