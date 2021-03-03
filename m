Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 40FD232C5A9
	for <lists+io-uring@lfdr.de>; Thu,  4 Mar 2021 02:00:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238660AbhCDAYB (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 3 Mar 2021 19:24:01 -0500
Received: from esa3.hgst.iphmx.com ([216.71.153.141]:3950 "EHLO
        esa3.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231976AbhCCISz (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 3 Mar 2021 03:18:55 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1614759533; x=1646295533;
  h=from:to:cc:subject:date:message-id:references:
   content-transfer-encoding:mime-version;
  bh=soYDRWLl0HHrEGC18buOWlBqxgRLTopf3jSsB90/2fI=;
  b=MQwOPNPcs0FC/ULKTCp0blutS7mM0hivJZ06fSDseR1pXG0GIkEH2GwI
   bI/V7LnT1tvCJPtOxA+Nxo5i8VptmCjvzYfEMRLZ7+VskaS50qUWzsdrw
   hynaDNerYvt0CHT8ZYe4ssyserJkQLZzAnCke0jXg2Zdrj2ix1lzCqa0e
   JjNsW2VszDVd7VUFxjoYnaVYXYQebqT3rJVVld19XYDzREyror1+iK6EO
   vNU+J9VpnyVXpIaFGIPYf1hsEsXienzMEU9aaTXXpCtz0uSx8AyULGHFn
   IraFnZ+Z5hUH+x3FwHtGNvRYwYmWnIfhV2VnPis9ehIYe+Ql3Rr4KJSXt
   A==;
IronPort-SDR: atrET6+azEHppVjA/w0wf4/E0qY0/51g3Ym5tb8HhqobcDL/ePgi2ETd6Dsc7B5V9pM+o0RW9i
 mug3gG1KRcmADO+sxucgMIQJmKwj2KZfVJ+09xydL9WqWDeYECdz8XoZPdTua60uCCP17BR1hk
 L1MsptcoACcic/dZiPRvPTk8E1AT+Ee8P98qBbz3HhiJqiO0KZsiBbt6wuT4HnlzvqAz2mK1vL
 tnmrsXdPSP64QDLgDUYj0EMvc1WA9h+OuOAGgbiVtDEnesNPgN+3vozQ7CJDIVnhgDbuiB26y/
 Bxo=
X-IronPort-AV: E=Sophos;i="5.81,219,1610380800"; 
   d="scan'208";a="165713438"
Received: from mail-bn8nam12lp2177.outbound.protection.outlook.com (HELO NAM12-BN8-obe.outbound.protection.outlook.com) ([104.47.55.177])
  by ob1.hgst.iphmx.com with ESMTP; 03 Mar 2021 15:35:42 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=NqLFRU+E7Mdme3+HSl/qdSiy6zbodr9KaRFds36lZCPCPVojhN8HxA441kpXm8bzexwIldndAZNsMLcGAuCDv/5IIhCeoxLN+FtYA6oPj6gzctandNG6vy9ihgMpfXBVadLRlsM1WtEIa5/eD7nM+h4cTDpxOIuSNHGMROE4BN8+uzgpo86ykNeolSbp+2VEkzGJpRH4cBxgacrlwRyre9e9MqCxDNnxu6jM6mn3ReEbt+qSKR7bHJAR9GaTn9KskHtW8NTARxTe/SXjl994Y8h85AArAvyvOsApjAK1KerQ+y0aA0xgilHZnETwtJ0Gp/1t0fQjMbjk+2Rb/9hi0g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=LML9dFmYNDfi1EYJPtgWMnHgM3u/u+tjeMaZGZTbrko=;
 b=W958qUD8ku+tqGHXb5nkZm3HIGrTq/ro/HT145eB+BM+xX0TbkatO3DVDmqyXtBUYxyfLGDLWuzzRp5619qpe0mZX/SXza0gn0J0R7IryQluKpr0trQr1YqjRWathRIuob6kd9zkBO1ozBDioXxb8+XMM7mZWCtT8XQJAu0CdnYNS864qGku2hcTLbVt43wsaNxqpIGQI6+CYVGc0FU4mbDKutLmNiRsKO59LKxFtD25VexTD7uAo0gb54fnJDF1uz7NF7xlWmOsygFKqr2QhbtzqrDursoMMDfornPG7Wh9z4KGvhrqoIAviXAhP/DzbaqPdY9tS8T3mkQp7udbHA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=LML9dFmYNDfi1EYJPtgWMnHgM3u/u+tjeMaZGZTbrko=;
 b=sAlN0rlDL/7xY9oTSL0m3xF+1w9p5igAqLDatI/qefIsjoO52eC9NUd9w1VAWPYQpgEOaRtmZrsl5e1kEI8SIbFr0/jYyfz+EjWY04ejpxDB8KOwzTfud3z5bnwmqmfnAttDk5JQ+5VEuJgEWrguJcbcR8AeB1l2sDght188fyU=
Received: from BYAPR04MB4965.namprd04.prod.outlook.com (2603:10b6:a03:4d::25)
 by BYAPR04MB4870.namprd04.prod.outlook.com (2603:10b6:a03:4a::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3912.17; Wed, 3 Mar
 2021 07:35:41 +0000
Received: from BYAPR04MB4965.namprd04.prod.outlook.com
 ([fe80::c897:a1f8:197a:706b]) by BYAPR04MB4965.namprd04.prod.outlook.com
 ([fe80::c897:a1f8:197a:706b%5]) with mapi id 15.20.3890.029; Wed, 3 Mar 2021
 07:35:41 +0000
From:   Chaitanya Kulkarni <Chaitanya.Kulkarni@wdc.com>
To:     Kanchan Joshi <joshi.k@samsung.com>,
        "axboe@kernel.dk" <axboe@kernel.dk>, "hch@lst.de" <hch@lst.de>,
        "kbusch@kernel.org" <kbusch@kernel.org>
CC:     "io-uring@vger.kernel.org" <io-uring@vger.kernel.org>,
        "linux-nvme@lists.infradead.org" <linux-nvme@lists.infradead.org>,
        "anuj20.g@samsung.com" <anuj20.g@samsung.com>,
        "javier.gonz@samsung.com" <javier.gonz@samsung.com>
Subject: Re: [RFC 3/3] nvme: wire up support for async passthrough
Thread-Topic: [RFC 3/3] nvme: wire up support for async passthrough
Thread-Index: AQHXD/4Dj/1BYoXHfUas1RoZk+MM2w==
Date:   Wed, 3 Mar 2021 07:35:40 +0000
Message-ID: <BYAPR04MB4965E07D8D106CE6565DFB7386989@BYAPR04MB4965.namprd04.prod.outlook.com>
References: <20210302160734.99610-1-joshi.k@samsung.com>
 <CGME20210302161010epcas5p4da13d3f866ff4ed45c04fb82929d1c83@epcas5p4.samsung.com>
 <20210302160734.99610-4-joshi.k@samsung.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: samsung.com; dkim=none (message not signed)
 header.d=none;samsung.com; dmarc=none action=none header.from=wdc.com;
x-originating-ip: [199.255.45.62]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 0d602d4b-d912-457e-a133-08d8de16f271
x-ms-traffictypediagnostic: BYAPR04MB4870:
x-microsoft-antispam-prvs: <BYAPR04MB4870FAB6C164429CD1BD781886989@BYAPR04MB4870.namprd04.prod.outlook.com>
wdcipoutbound: EOP-TRUE
x-ms-oob-tlc-oobclassifiers: OLM:4303;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: YbnpwApkNTwN+utqVR63iVn9cSJ1JcOjamc91GjXCgSjSvxzrIoO6Dh9JYPk2kuaQWDtvW8zQNLi6CdzzMItasrgTPHK26l6INGdv29aCrDTP7tX3MQ6zf6NvGhJ6/0F9+ThuO7EeCxdhzkwLd7dNYai96BF6WVw7y5x1LBgqoRTl7PoJ5XNeu1hZBnACQsgtdvTTH0mzLGnQ3fNXjOV7gftVXojfFBb4HICU39SaRGDKjgSkumds+F7ZANdPP74fCTVaBiqs4fp6oNxYMv1G1b1kQXSCRweI2IxU1c+JgvXIrwHca6+3Ck4TMdtMSBobC0TznThOQJf3CuccaylidcpssiHisxDYNYRO97vn91d6VuGgSWPlXKSTFMVrA3PNCExIIlS1EMaqWRW8u/XeID8Nd1hTlFTOCfJWxliKcyoLBCpEpGjQdcH6krPeq+r+fx4+giao9EFgFs+/fvOqZ+zgRzgHT15Me8iNXBfw4tO68UkG8iwNnQ/Cs4v3Jk4rsp2+YhTWheaXsZW4k2GNQ==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR04MB4965.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(396003)(346002)(136003)(39860400002)(376002)(366004)(5660300002)(4326008)(66556008)(66476007)(66946007)(66446008)(8936002)(33656002)(64756008)(478600001)(2906002)(558084003)(186003)(26005)(86362001)(71200400001)(54906003)(6506007)(7696005)(8676002)(53546011)(9686003)(316002)(52536014)(55016002)(76116006)(110136005);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: =?us-ascii?Q?lSSdmN50cj/zENjugP4X/thdZvrSOkHzvEBl0fxEnzRbu5AlZUP4v/HqE4AE?=
 =?us-ascii?Q?ERh0ghLyKP7m6q5GOZbd8h6ORulMx22suklc4l42hdhXIr/B1kvasxP/HeoE?=
 =?us-ascii?Q?vhnuBoQ6Ru02pt3gHWr4hJFIBHg8c9XiYd09dsTrgIlNsZjRHRmDN/IiDO80?=
 =?us-ascii?Q?Ktew009iVZ99THVsGQdjIRz3fXkGNgENTQGJPXzCLM6tYmzXdkGEKcyCnFXr?=
 =?us-ascii?Q?DnC3RmSP+jSZRTkvIjQ+Fu8TYk0AtN6AA3pH4kl+hyY/UMwsRu7Kfh/aPRdG?=
 =?us-ascii?Q?MTQKOlwN8o372yLdBPBiYngN2DtAzEbdS/bpzT3XqoiQ3IhTFNOlSBxXB0+6?=
 =?us-ascii?Q?Cdv+fsIQUdAO+VUfGhHZVTyCjTTsv6tftKS1FJ/p4uCv9FLUxci2ITOTOB++?=
 =?us-ascii?Q?Ado/DVombcX9Lo7oMjm3Faca7/rFMOt4aL9EW2e/xmXvaa9qSNNRDbjTyZuW?=
 =?us-ascii?Q?Ti/PPaBpsKVZcL/0FbNONHbdtIheyVQTw7CVd7iM83WKPiTPHitzMRWRdepX?=
 =?us-ascii?Q?z+yNdUcLd/3UuhWiGX1jsdVNgJP2iC4SiVcGM1hbs6H+kvHc4LwIjFwjQOoO?=
 =?us-ascii?Q?9tI29Xq4Ingi1sO7VVKHWTriyiJdcD2Nxu+RgTAyp1MrvSENrOjH8WRUT9Kw?=
 =?us-ascii?Q?oMEoW+HK+UnlJ3TLhOZIWZ0G30dXBjnNmvqHF9+3R2MRsq0zRWo1V3/iySKz?=
 =?us-ascii?Q?NX6joi6xZSnympkdJuQmPfDslKjvuQjt1S/UnrlTVOrC5GTXot4FZ5FiJ02H?=
 =?us-ascii?Q?FnnpomysbevTmEc5zON9C3nd9wQIyxe2DSQktqsgjrFiJBhrVmdcwY3/Dv8K?=
 =?us-ascii?Q?XOjWa6qNBuyJ89Y3rUUyXtEhX+QwKbtDh3QnCsHKng/OunmHIIozinb+5fnc?=
 =?us-ascii?Q?a250LzKFcTRNkXry0QR5D7i/pMUi3sIkV3iMz7kzc7JY5w3Jjlrc/e8vZaid?=
 =?us-ascii?Q?c56GDMwj1sKCq6G+hIIq90wC1DwFM8lId9VcHBWE2egig49bQ60kQRiGNclE?=
 =?us-ascii?Q?MSQd9VjNb0reHNAtH1G7m3g7lrEASIV6CgG05YLCDJKMnWLSJ8g2uER/DMi9?=
 =?us-ascii?Q?VMOzeseWuEUwo9Fk9isxNe21v6JX4S9jBIhRVogOw21N3hJj/7g5OEvLsIwM?=
 =?us-ascii?Q?zfrz9uLpRloDJoEZap31RkcsBAhj37w9zkQnVkZvu48XhYMO0YS4XuLd0iiq?=
 =?us-ascii?Q?JTVZp5vFGfzg4A8Ha7W4Spu+3SlkDdhBMSi7hnc9VkzqYqstPPY+vHFrRHR7?=
 =?us-ascii?Q?OSHQq9YYDEPhE1bD6FdxcwL5MXUBIxLBIavQE/20UktXeQIOenW1sKRIGuzP?=
 =?us-ascii?Q?bS+ZxiYdThIlJBORvQiI3frn?=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BYAPR04MB4965.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0d602d4b-d912-457e-a133-08d8de16f271
X-MS-Exchange-CrossTenant-originalarrivaltime: 03 Mar 2021 07:35:40.9975
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: IUMown3Rpdb11S+dffAWFW4PD/Vfrhv5xVlm9iD2pEvAmmzib5MiAIyNNevXS41YSX80omrmJ99JL6vp74DpWqGbM1BbJ4FiLqkjNAIh7JY=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR04MB4870
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 3/2/21 23:22, Kanchan Joshi wrote:=0A=
> +	switch (bcmd->ioctl_cmd) {=0A=
> +	case NVME_IOCTL_IO_CMD:=0A=
> +		ret =3D nvme_user_cmd(ns->ctrl, ns, argp, ioucmd);=0A=
> +		break;=0A=
> +	default:=0A=
> +		ret =3D -ENOTTY;=0A=
> +	}=0A=
Switch for one case ? why not use if else ?=0A=
