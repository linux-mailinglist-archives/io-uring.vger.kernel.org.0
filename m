Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8DB2732C5A2
	for <lists+io-uring@lfdr.de>; Thu,  4 Mar 2021 02:00:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1356763AbhCDAX5 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 3 Mar 2021 19:23:57 -0500
Received: from esa3.hgst.iphmx.com ([216.71.153.141]:44131 "EHLO
        esa3.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1582119AbhCCHfb (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 3 Mar 2021 02:35:31 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1614756928; x=1646292928;
  h=from:to:cc:subject:date:message-id:references:
   content-transfer-encoding:mime-version;
  bh=IMzAVPqthlt/xoFj4vPsCqFxU8xdKdgb2SxUpUFWWLg=;
  b=UQoDCayitDZmNnyS/heDKFudFvWw19EwVmWPXdImL4nwPl8R0VozciN0
   1Jy2RSGoIJAJ2Yvn/QOpAOhAFoPyMM8mLLHJGteW/4qsZKn6wviUM91mO
   x3lQquwsEIQV+LV4WXuyDVoKi3XoluEMNwuc3K8rBzteFnJqCbN9wrx5r
   8GBf7r2TUfpi9WoIMsgF16T9QQjMU0+HDgQrx2i+KTkj78zaSf7cFb16/
   azTY4d1HzWsQ2BP5SOSom+xkUQVFo+Zr4+z4bz7vvaTkM4pRwCluhCbA4
   JV7q8+LAssgjJzeN+mMvUcbKB0gGzjWq125pkqF0bDk1iKKPkqNKapavB
   A==;
IronPort-SDR: xuOTryOqhlm00zjywhkRtksVpYMP4tAD3lg90Zy5t0gYdEypUn4gWvpb7B2j9AEvB4LELN3S7F
 bYEEtreiRFG2CcABne9Wb7eFNoPGeFGSds3CbjcJ2WqN3kgdKZRIXdqtAduXnwNrQMnfJ12Pwb
 aZgqpdQo54UlH4EKOAWxLwCjrqhI2DKBHL17NGJm1vkufLz2v3RzS7OleB6CAMHDrC/lxTC5ad
 UXVAsJ4nbngJ0AJwRPN/alx4WwQrTUx2sWiwA9jK8whEjgrW4o/YSHxwIdUYU7sL3j8pWSfzvq
 f4E=
X-IronPort-AV: E=Sophos;i="5.81,219,1610380800"; 
   d="scan'208";a="165713332"
Received: from mail-mw2nam10lp2104.outbound.protection.outlook.com (HELO NAM10-MW2-obe.outbound.protection.outlook.com) ([104.47.55.104])
  by ob1.hgst.iphmx.com with ESMTP; 03 Mar 2021 15:34:19 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=TM1rE9VWzyMakq0Q8/xaQS6z35kNXmBc48eJDtCg/v8aL9FHGJz/msaH0cXos6RzgOUcLxGdpQCTz2PJN7PMgYWHxAd40G7qe3z1SiZKD77rRLrmwwggEd0FgMZat3kc8IDHhgW+niWaOhgrUQWs6uF9LCbp11xk5jAGVD+1DZOl/s8ABZHLv251w8fv5qLTAJ4eVkQXcOCWTGFDP8EfMhGog0Smo5pa2LFecTyDXNkNceYlVebrVinS6KZ5EOLgw3T3Zsp8nXTxmRKlBMpvOnvYyN8+yn13QXph8qsN3ML+a6KIsorWn6YSZP6WGTBdv+C0sTSc4uKPN7ToCwgXiQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=jEgZoCUyG0pCFqJyLXwo0Ldj64o5HCj0HfDBDZ+Fp8s=;
 b=bseyt0zoAjmKkwDQpxoQh55NRQ9bI5q4kzIZg4JUAs1TKBWXj+UJC5Iple5OycmXYhSNcF/FX9sFDfMutGOslS+npVriDr9soCtkCyZnOsHqRSdnVwEl4/nuTYMZ0QNYAxCPclpbOx69HA9Ui0yjANlVznp4NMsd2uyyb5YrcYtBKgFidvQWWAAmSGZefPczo2utDBL3ZTQ/n6AOZsGujStCfLSGzCswbSF1qfIuYQJpEe/fYEjci1igzHt2lQu4WgRsVmqJfCiuPlAmpQ58q7Z0qoFuL9SYXvpP7tnYlefx5bw6LSULq0Knzio+Hb/nopbrwLYOQU60q1G1ytug4A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=jEgZoCUyG0pCFqJyLXwo0Ldj64o5HCj0HfDBDZ+Fp8s=;
 b=E8+BMv7C320Lh1DamKSHxFMfVbyi9r3CPvwUmq+N+ttCYtN8mwisU9FkQdIjGZrMr9RIPV9NwyiGPUywHK9ZDQ2nfQJOUM28zYqAwjmifcz4Z5oe+gNPxONVRCUX/jR8PCQ8ZAr7wIg+vF9razBXxn8zTO/VwK4aXLeMwtx49xM=
Received: from BYAPR04MB4965.namprd04.prod.outlook.com (2603:10b6:a03:4d::25)
 by BYAPR04MB4870.namprd04.prod.outlook.com (2603:10b6:a03:4a::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3912.17; Wed, 3 Mar
 2021 07:34:18 +0000
Received: from BYAPR04MB4965.namprd04.prod.outlook.com
 ([fe80::c897:a1f8:197a:706b]) by BYAPR04MB4965.namprd04.prod.outlook.com
 ([fe80::c897:a1f8:197a:706b%5]) with mapi id 15.20.3890.029; Wed, 3 Mar 2021
 07:34:18 +0000
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
Date:   Wed, 3 Mar 2021 07:34:18 +0000
Message-ID: <BYAPR04MB496501DAED24CC28347A283086989@BYAPR04MB4965.namprd04.prod.outlook.com>
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
x-ms-office365-filtering-correlation-id: f531e314-5c6d-4433-6485-08d8de16c16b
x-ms-traffictypediagnostic: BYAPR04MB4870:
x-microsoft-antispam-prvs: <BYAPR04MB48709E0FB8893F8F59E7B87286989@BYAPR04MB4870.namprd04.prod.outlook.com>
wdcipoutbound: EOP-TRUE
x-ms-oob-tlc-oobclassifiers: OLM:4303;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: ePbH4BLcLSCRXkUijBK3x0WY/z70MsjeVQyMteH0lUQ8p3DofLt9jZGO+wmpOiMBuUFLcxutc4iaeqFY6V7rd9LHXYISYh/iX4d/O4xj2SQ8aGpLOKvAEQfYGeWVuK2L1H9DRFB0xZeSHgqwmSCDKpd8a5yi16U6jFEoGr1s6Ub2hP9FlSmD+m8EHtSpoRquDm3jiatS0j7WsqITTkFfqdn17JElaGgPf3agBmhQJOx9uiQU5OboVQzioh3UBQYB002aNaSvP5eUIgK92tkXAo8ov7NCtbpSU3ga2kpHhiXGJd799MhQP1VXFByWfn/XuIfxayvp1683KXs1maihwt6sqNIwtb4UWxqQXCyNONWYz4o6A4z2oPgaL/NB+z7pGr+upwUeH4aYeeIN+LeqaPIcjgiwwRTQHOlum2LeXVIkoSMSiRwcYHApdmozP1AAUU9/I3E+C5zXmXkIBH1ubAGdBTQkLKw93L8mteRd99Pyd0a69Gtqz224se8pa60ScwFNVnyTgR4BpVtPUiKxug==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR04MB4965.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(396003)(346002)(136003)(39860400002)(376002)(366004)(5660300002)(4326008)(66556008)(66476007)(66946007)(66446008)(8936002)(33656002)(64756008)(478600001)(2906002)(558084003)(186003)(26005)(86362001)(71200400001)(54906003)(6506007)(7696005)(8676002)(53546011)(9686003)(316002)(52536014)(55016002)(76116006)(110136005);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: =?us-ascii?Q?WLkPe+Yzb6YtyQjM/gBuxHfXuorsMqn7vRbO5LmKSXvjriD8IGHZPRA9MSiD?=
 =?us-ascii?Q?CdwvKU9EWR3u/rfbS0hASCbgvj6NZR4OYOpia9Bd6ESFurE2sqQwy8sgQwKT?=
 =?us-ascii?Q?DaTiMYPkA0GQa08mb6AEc5bge4H3DaW7Lx8YrSac4juYh+1aGOaa++kFQPml?=
 =?us-ascii?Q?lhVEPym8FwaHLvuHcb2E3dXbQm4XXtL4nRQTfnurygjqx9N5+pv1khwfd+D6?=
 =?us-ascii?Q?fF0g/7x7SzLoLcemvRv8ppFcA829iP1vTgyMRmFFrk3NtldOKiHbgrAC1v1o?=
 =?us-ascii?Q?RSHAoB0K6ufc8bLbhLrEHaA/XzSy4yJSsujdG9dP9k/7c0ljQI6mYMFdMMmp?=
 =?us-ascii?Q?+gGt64kVGkIrolWf6HQjtaLO4MB+1dcKg/usyb84zVO9qd98ajVVDzKY3D6Q?=
 =?us-ascii?Q?UiFayOiaAoLwbyvjgmWIqbQVFEQD5x4FOfNsuRLG/L/RQK0Q4HZAdoHJ5tIJ?=
 =?us-ascii?Q?fY3NBOHg+HtjmRxiDh/ocA0drMa0XcQuGRiBkzfIPmySJAJP2W5XSf7YvQUC?=
 =?us-ascii?Q?sa1PhY1uD4oZxfNz+5R8DWi9gdlfYofM7BW8gSqkMdZ6C+3B91iJaTyD4+kj?=
 =?us-ascii?Q?b7zL9UvsVtOWtM0d2Nr6bUxs5oYw9Fo0ANr4rn+x8oLuU/fslWGznYG02NxY?=
 =?us-ascii?Q?QPMgxTAmW8+yu7+0gCNi/xhZw3dsIMM5O6Al3spGYbezpMl98iCTeiI+OEg/?=
 =?us-ascii?Q?Bdyk4TNquSFL7rl5xzcVVDL5VNz07Oy12+E+9i8Kruu2qsitWbnoDc7rTrFY?=
 =?us-ascii?Q?NaOKlqCxEanyXfTfoHsskmWu1qguNTObqP/sHio2BG3aLpVv8lO4FhmVuUGD?=
 =?us-ascii?Q?OqaHoX2lWj0n3pVrQJJl9Q0YmkkmeTA1b2YkPDaSm25oxepErBQY4VBSZ5HJ?=
 =?us-ascii?Q?AKE+rjtXuGdTkM0/j4uufkxsEhnJTE1iTjTg5F/pQtkz7Q0zK5YTf6mH2cR3?=
 =?us-ascii?Q?xcRQ7kHdHVF832F79lDGfbO0vDJEZ2zTVJLDqyhaD0e3SW4p2iu2zgHR7gs3?=
 =?us-ascii?Q?ah7b2wskkd8/XLHhsw2yNTYzj68cVfpoIrzREFF3eiZ5EYxFv/W9Uj+L5Gyr?=
 =?us-ascii?Q?RiGrAOLPGNjycQowX5CABU3yeSYLDlzbRitx5JhDYzlHxubyOimF9IGIWNv+?=
 =?us-ascii?Q?LEqUlmvpZn2l5IMsOv56olZ47tg1RDnsj0P2XrKl5Q84qYoETWGmYzrsT0Jb?=
 =?us-ascii?Q?IunYK/BC6B+sfdResv9xXLD9TQ3Ou6J27KPNrkDfxSKRfP7keV348WZwiN+9?=
 =?us-ascii?Q?7gSRqMMAbxAwxbajx5IDkATuo7yOLuKz4h23u69fwkeN2mAPl+uvgtQxCcet?=
 =?us-ascii?Q?UhZQlW+P7B+0H7ZcCQNbkZLe?=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BYAPR04MB4965.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f531e314-5c6d-4433-6485-08d8de16c16b
X-MS-Exchange-CrossTenant-originalarrivaltime: 03 Mar 2021 07:34:18.7643
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: k7foRy+0Qu+0xjPEVHywF83Ibfvpd6LZQIt0FM2a3PuEtg9Kr4M864NTEQwysnqQs+9s8iXE/Ph2TLfalXKZLIV0fmdVKyCuD5SgYKqG+18=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR04MB4870
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 3/2/21 23:22, Kanchan Joshi wrote:=0A=
> +	if (!ioucmd)=0A=
> +		cptr =3D &c;=0A=
> +	else {=0A=
> +		/*for async - allocate cmd dynamically */=0A=
> +		cptr =3D kmalloc(sizeof(struct nvme_command), GFP_KERNEL);=0A=
> +		if (!cptr)=0A=
> +			return -ENOMEM;=0A=
> +	}=0A=
> +=0A=
> +	memset(cptr, 0, sizeof(c));=0A=
Why not kzalloc and remove memset() ?=0A=
