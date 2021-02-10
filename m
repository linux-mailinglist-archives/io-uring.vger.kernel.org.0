Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CFAE93170E5
	for <lists+io-uring@lfdr.de>; Wed, 10 Feb 2021 21:06:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232091AbhBJUGn (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 10 Feb 2021 15:06:43 -0500
Received: from esa2.hgst.iphmx.com ([68.232.143.124]:41345 "EHLO
        esa2.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231948AbhBJUGm (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 10 Feb 2021 15:06:42 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1612987681; x=1644523681;
  h=from:to:cc:subject:date:message-id:references:
   content-transfer-encoding:mime-version;
  bh=H5qLHXBBhq3HpdxpFsggXn117evRIkIFGJnt1Vi6ZVY=;
  b=AsAZDXvkZ2pWMUUpnpyR1zZo4AmTOzowD8wH1AOTPuClpNO08A55QyG5
   vHjMIY6dhf8kgzYpZ2EL4zZxdIHucfH0H5tLBFJjKR8/Gz/34t3UI3V/9
   Sxf+7e1WHKhgMaj66rxfQU5UY+GxikfGQvPw/ti1OmsKArQmmr5rXrksw
   +fSBpFRbkhawqaGVJKmc+QulT46Am9K6p3ZsMnJ3CQTeFgTxM2R499BrL
   ZYY6i5FJxHUNZPtVO48cxdPlZ5s3b2qNje7aGgYvr/WeZBHm08a6lBRRp
   0zZAPvROuRUPuANgA5nbgKPhSWUcU/MF1pWRn3LmlcM6VLxX7fHZ0FQvV
   Q==;
IronPort-SDR: hcVCbrEcQU9kI0uaxzb+sQoSNXI7mPtLfnD/l1N5anLMYJ2S2CF08L1zgA/5+spUXGb63EOsan
 lHpYtPEFgXqtmuiTPqwujQ6SlqkwKltvz0T8shAJtJpNM6q4VEPw4qF7z2OUrzHWdPlI6ckQAq
 mBYPbjGmJVWMpKsfcKH1AuONabGDRtt2GTRiq8LSsEdpvWLzZ876wYZErz94jPwcfKC7Rep4Ct
 /NKOcyUvk9Y8vEpvCIPLFyin/1VWhJfDZyYqMc4W5fWBpaeaefT/5W6WeC6vI8kP6ABP93CBwS
 ZtU=
X-IronPort-AV: E=Sophos;i="5.81,169,1610380800"; 
   d="scan'208";a="263812715"
Received: from mail-bn7nam10lp2109.outbound.protection.outlook.com (HELO NAM10-BN7-obe.outbound.protection.outlook.com) ([104.47.70.109])
  by ob1.hgst.iphmx.com with ESMTP; 11 Feb 2021 04:06:20 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=oCZ22FQYi4jQDH6tP6Ii2/vDdc88SWUZVPCjr2cP4FvJFORcDIqr4tBdxu4El3AJUJQgJT4UpIROu1hdP3MlVM1tY+kXd4A23oOGuhIZChvg15E61OrqNZ3yVpSLAJxeuRpTEtCx86c8QfGFsJqMq26N7w9xyDatmWsg1muHJvVZhyUtByTTTBPBYoebxTxNdw6Wh4wUhNjhglhmOZ5GwqMNWi2NhshWWYPNhzv2HF9mU5h29oimXGduCyaXX/qd4cROzB6ieNdQU+mgX3rsROvFWJ1EsHpUKkJJU912etdohR/VPC3/OnLL07Oj7VPB8D1F7Tr3tZYsRnD1FUyfiw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=iBlHW6nfslb6xBxdlDiNn4FoeRGpW87k+6FiDncm1Lw=;
 b=ZGzQWOUg/zx29R3HpHr1ca2Pm9U8oyuGpLNW8KzT1eykCajUOUnWrhSIfT1SVUDN79/VGA78CEfR5X8xGWK70OrjrXq5QtE4aXbVLiwjqHuCvQr5lU0CG4HaVYyFUHQB323kMkMRth+BR7/L9+V3N2Jt0MtVvs1I8cp4O12+yQOVvhI4BeknRwKhvBpIpPImYPldyicGe+/uADXZM9qZe9prF255swdqMrmw3tEvAtEcojsK7XYDjmGupF9TiCpoKkHqokizxRbMPbFldQ+ULLbLWG79Y/hcTZKLoAQIZmnmq1pKS+FPPCrSbhydVWVkck50ueJ5Wlf02AHey61TRA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=iBlHW6nfslb6xBxdlDiNn4FoeRGpW87k+6FiDncm1Lw=;
 b=DJpkT+ftdrlt+qU2BNK2PTIkgKXW6A6JDMTQ6jtob1e00WJXimVeFff307CHg/MUSp4tLrQ52AOV8FMClBxpeGgNaAmdNKveIdV56BhWsfz7/q8kIuiZmSGgP18H1XM4zHpLrH23KAOEQShCs84ykLR5kyFfHe9+cRqw0CDKcnM=
Received: from BYAPR04MB4965.namprd04.prod.outlook.com (2603:10b6:a03:4d::25)
 by SJ0PR04MB7390.namprd04.prod.outlook.com (2603:10b6:a03:293::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3825.19; Wed, 10 Feb
 2021 20:05:34 +0000
Received: from BYAPR04MB4965.namprd04.prod.outlook.com
 ([fe80::1d83:38d9:143:4c9c]) by BYAPR04MB4965.namprd04.prod.outlook.com
 ([fe80::1d83:38d9:143:4c9c%5]) with mapi id 15.20.3825.027; Wed, 10 Feb 2021
 20:05:34 +0000
From:   Chaitanya Kulkarni <Chaitanya.Kulkarni@wdc.com>
To:     Colin King <colin.king@canonical.com>,
        Jens Axboe <axboe@kernel.dk>,
        Pavel Begunkov <asml.silence@gmail.com>,
        "io-uring@vger.kernel.org" <io-uring@vger.kernel.org>
CC:     "kernel-janitors@vger.kernel.org" <kernel-janitors@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH][next] io_uring: remove redundant initialization of
 variable ret
Thread-Topic: [PATCH][next] io_uring: remove redundant initialization of
 variable ret
Thread-Index: AQHW/+ehFf9c4aFcnESr8ZjAhmSO9A==
Date:   Wed, 10 Feb 2021 20:05:34 +0000
Message-ID: <BYAPR04MB4965CDA76126E201ACEA6BB6868D9@BYAPR04MB4965.namprd04.prod.outlook.com>
References: <20210210200007.149248-1-colin.king@canonical.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: canonical.com; dkim=none (message not signed)
 header.d=none;canonical.com; dmarc=none action=none header.from=wdc.com;
x-originating-ip: [199.255.45.62]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 31a7a15d-f2e6-43b1-7511-08d8cdff39ca
x-ms-traffictypediagnostic: SJ0PR04MB7390:
x-microsoft-antispam-prvs: <SJ0PR04MB7390AFEFC7A36F475DCDEA40868D9@SJ0PR04MB7390.namprd04.prod.outlook.com>
wdcipoutbound: EOP-TRUE
x-ms-oob-tlc-oobclassifiers: OLM:529;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: ij+ZxfJfZMgwr/R9IpJ1Fyz2AcVYbiR3MdGddpcEYrYT+5prFtWbaKxnn+ArIJmXaJPqWlAKSaWukKw+I9txoeAhi5wXsguZmfYKXC5Tr1MjzgbFd5GMyRTQ09CtFvHINExL8NDtDCXiq7X7YR8RF30gi+WuKne3d7nAtN5oHM0LviznoIssN63HrPi+aYOGg0aey6oI2DVX4Mu0omlRanoRJptkuyHOvBOmZw0s8MP/q27B1d8qfIKD4hgARj+Ta38Vz3xcPiIOIYI/DpnoYnvK9LwdxfacO2+2L7TFcFdx7eOYG0x9UnyQ1eggaClQpGL/afxWAnxsbXmU1LX0bZrABN2oQCoKkQ35O1/KSsxtj+Ah03M0gsuq634bDcvqlAVy5NO+2vRQixm80DyOHZd6YvvLWd9j/9yVYt5betkt3fscjbKbDwuzYBD6oMshXDxWyW6wUEtyJFvuR+89GgG2uX4WpNhdd1ROR7cUe4FJrNXpsDcCIXuvS4M2pUt9l6f6r45gPg4ZA5gVe7nnLw==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR04MB4965.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(136003)(39860400002)(376002)(396003)(346002)(71200400001)(76116006)(186003)(316002)(64756008)(53546011)(33656002)(66446008)(7696005)(8936002)(83380400001)(26005)(6506007)(8676002)(110136005)(2906002)(5660300002)(86362001)(52536014)(55016002)(66946007)(478600001)(54906003)(4744005)(9686003)(66476007)(66556008)(4326008);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: =?us-ascii?Q?lOv4W47cUARqdFRYUWfN86Lq9IfWflUAUGAz3mLP2KeYKm+dfLw+FP/CmEeU?=
 =?us-ascii?Q?CK7tBZv1T5RIqyOauAbjejD6ncPj+J65NDoQ0DpjzrzW8/myG1oMzyvj+lXf?=
 =?us-ascii?Q?16vM4dHfjiaOsSPVSjSyT9f8gg03CPCWUN9xbi6BOztAjsBx5h8k2wXe1DLq?=
 =?us-ascii?Q?BBKj3Yvapq1teRUzsy5LTY3cOTmle55uIqCabsfRQ8nIA1hmCXPFUaOZlRfV?=
 =?us-ascii?Q?HmNmapuETUS4u+7LYzNrlAjYf0PoxAQgpHBxLC2uZ9q0ozivxzrvc0tWbdNy?=
 =?us-ascii?Q?mK91S170wMLXtV2Onrl0wcqb3RSCwrxV33I+uWB8ZPvV13PziJ9FS1bIlFIK?=
 =?us-ascii?Q?yWvhTodeNO3FgJ3hwLDVx8GaXhXXKehJKkLEq8fiYiLoIsaTw4UACub7Wxsy?=
 =?us-ascii?Q?/y09i60sTdzJOdH9/QKPJkUqiqvFk6UgepFkIz2+J1hZKAEB5Og0ECqlaX/S?=
 =?us-ascii?Q?qXW15emT4YUccT3KIIsqut9iqBU3rwafGclh5E+abqR1E42ePvkhYOk/zbVS?=
 =?us-ascii?Q?j03BUNiDCx+XV+DsZohF0m2g8wMP/RofsCfIeh1FpOg300PWJQh+nFtCl1R9?=
 =?us-ascii?Q?PvbfOLGAbPCAxwCozQJGst4tgVjLa1vr3wVZwAXg22oG2+xEjMt+RZsdWeKX?=
 =?us-ascii?Q?NIqZL4Sp3bgKYSQEDNx06Ou/0zPuZiE8dbH30mYnjBT4sv9gHsFdXpwd3ymn?=
 =?us-ascii?Q?RtUxlaO6c0PGzLWECnI5tEnY1c28W3hIVnJxATz5s2YQAP6C9utOx/mL9r0N?=
 =?us-ascii?Q?HSJ9g1nP4EeZxgi2OZiS1l+LifNcsgh1T/jsEC+KrlmRbU8N5gOAwnzT+zwU?=
 =?us-ascii?Q?VK8h8neB+FzrTlE+HR6umOIUp5yWYfaczgRmEn0q3RYEOsjRJGoeCepwrekk?=
 =?us-ascii?Q?XPAtHeaiyv9wA7208xJ3+yv+y8r05GR9P0i8A0z+Blk1DBjCEztGs26rg0T5?=
 =?us-ascii?Q?GbXmpD4m26LxfaRXXWmlFny8k1l4GsX9GeztHQOb36nlTpLV9jZLytOiwgDJ?=
 =?us-ascii?Q?FLsauH5ok1JhnSN6xrG7fY/oVZJtWhSlEUAGVaCsxJGWFVsoFOFLqezH2U9P?=
 =?us-ascii?Q?PwFmQl3UCec0GZdQVRyfIwQqQOKU2cOePZIVO07cNBIyqh49+Ot9m2c1qJfA?=
 =?us-ascii?Q?Dj8sBUBmeFrmvFxBHA7nRmtaLOmR+8KD7ZJxvhJWCCIVn0Fq7mXjUw9srdrK?=
 =?us-ascii?Q?SQ79jn6mj0Oaje8fXdTzh9UhsgT9sEUYj8bjFjOCG3xXnp0ldjnyhoPqYmPy?=
 =?us-ascii?Q?luqitaegoRHj2nMpbWTK0FNA+Xhf3xNLrrPfSdji9XY/g+mwz1AH09L9ZzrX?=
 =?us-ascii?Q?+c2eAAM5orgjDw8vRaH4dpccJyHp0cYtMD5KdFjRz8+NLw=3D=3D?=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BYAPR04MB4965.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 31a7a15d-f2e6-43b1-7511-08d8cdff39ca
X-MS-Exchange-CrossTenant-originalarrivaltime: 10 Feb 2021 20:05:34.1939
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: AoNzZ1QpWJtMKL/yhzgc2DHF1ci2FqkTqd1iKudlsXJWRwIHIWkhdd8kFv+l1OWXsCCVilzupNgtQlR1bfapwLflWD9en2B/XWTYboAvDEU=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR04MB7390
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 2/10/21 12:02, Colin King wrote:=0A=
> From: Colin Ian King <colin.king@canonical.com>=0A=
>=0A=
> The variable ret is being initialized with a value that is never read=0A=
> and it is being updated later with a new value.  The initialization is=0A=
> redundant and can be removed.=0A=
>=0A=
> Addresses-Coverity: ("Unused value")=0A=
> Fixes: b63534c41e20 ("io_uring: re-issue block requests that failed becau=
se of resources")=0A=
> Signed-off-by: Colin Ian King <colin.king@canonical.com>=0A=
Looks good.=0A=
=0A=
Reviewed-by: Chaitanya Kulkarni <chaitanya.kulkarni@wdc.com>=0A=
=0A=
