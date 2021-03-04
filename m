Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6C34A32DD79
	for <lists+io-uring@lfdr.de>; Thu,  4 Mar 2021 23:59:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230525AbhCDW7H (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 4 Mar 2021 17:59:07 -0500
Received: from esa6.hgst.iphmx.com ([216.71.154.45]:4842 "EHLO
        esa6.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229505AbhCDW7G (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 4 Mar 2021 17:59:06 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1614898747; x=1646434747;
  h=from:to:cc:subject:date:message-id:references:
   content-transfer-encoding:mime-version;
  bh=o8buLsWvLNR1JNQdF3XDslrVZwdn2u95v1qejgCe+ZI=;
  b=Y9DF6K40wILjIcrf1H+latStjtVGUfMzvUGQEfCso81EpZUKqiG71J9R
   rkILrIa8RB6ONEEa/i6tPy8ZlOSTemYGyzgUhR5nW48NaQvEV/SaxJkaq
   bgafZgnBgBrRTxYdoDKpa24vtk4jcUavBlyy1zcjtC/0/cfF//q0bRfNv
   ixc2Ll2jo/LIpN25jJ3gQObnb5CK86lSbXjR6Tn1AxwrozExWFPw2aWNU
   CkrPekCylZepzZFdiomGGooi6Y2HEpOEThRy5Zf7Uk4C2qnb2quuP2sG8
   2yKpNgyYyhHncIY2sqGgoQc7Y9TMZg4qboIEQ59FFiwpEfCOzy9IP8tx5
   A==;
IronPort-SDR: IsH+bBALosdzNeEwAkhsLi8fFYkOF57ZlYPIncF2Gt5QJW1v8z0H4Y640J04tcy8FO6fvUrNzO
 9ovCPwfNRajbLLDcG+BNZcGPsAXE960r+Ar478VH+dbVvjsT37d8UTW8unC0lotPs2UlWvoWvI
 JwzNS7Tzmzzmkc0IuZoZcz3mABSssOcW2jHEdYT7NppFpCDUu/puJmt8rk1gHYCtc/RbPNCMZs
 7P3Zj9wF0hqHI2lTQlgqy9hTKFIfv0ACrM0j17OYzQg5gpyYyrIWMV0v8NNNvQ8Zvze4XPQfHz
 2ks=
X-IronPort-AV: E=Sophos;i="5.81,223,1610380800"; 
   d="scan'208";a="162561686"
Received: from mail-sn1nam02lp2051.outbound.protection.outlook.com (HELO NAM02-SN1-obe.outbound.protection.outlook.com) ([104.47.36.51])
  by ob1.hgst.iphmx.com with ESMTP; 05 Mar 2021 06:59:06 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=f8dCgUEHNQZjmj+neoIPmCPoSowdsqTDnyMK6F216Gz3ioGnrPYagEipUXgpV7DYmoi6DpWgfcNQ5Fs8ss5DrjFKnXia0JcuU0Rv4uam11ehpT+ebGSkYbsq5dduSWg2Ue8ziDOFuzK0K55RBcsaMzNa+b9TcxBbgAHf6z3jf25kwwelGdAC6D8y/qxDAEhX5jwg/IJiCPSotUx1IEr14PhU5EJERhBG4Cg+uWmz2cpljIAWcLL8PYOmNaPsN/HGksgINi1KZHUOA6GSy6M41z/1HjX1DxQm61PDwJfmbo/dNvslWMCOSrXYXa2tfN8Ml6eFok9H8OpavOC+VXb61Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=47rkkKmmNs87uYgMqwJ177ALzt9f2HGuUXpsoyfu76k=;
 b=IjDSR2ZV3vl1tSb/muXjyR5sTCNDCMlZMm2v/30/5O+GJbg0Y3A719K/xqDUSWsLmiGHcdER9tRm6sKIfnrbr8DgN+q4B7DIybx5sfo/pMXxBzV1JAm2xULq19MHm07ZFd9e22EVhuqsJQ3mGSb6oZ8/2xjo8Myfw55ktfmxsxUGpT9LnCTG8GThQJ5NaorMr6oXVjPSvUQ+qBSfdXt00KLkKkVg/+QaXMWYV9dJaFYF3+8C7B+w/oHEtUOTiDFJKpdyR2MsRl8a7IudRLaBj+Bgn0kXHoVQktdsegqtnC4VQCXrrM0q8E/aMyKC0Nzc0trcLNiyqRPAeaBxW1HDFw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=47rkkKmmNs87uYgMqwJ177ALzt9f2HGuUXpsoyfu76k=;
 b=fZpVSH0iUHH6+dAJw7SVyZoZ2BH+jDorGbleocpeVFiVk3/d/ye7IllhRK3orkO32op79Yq1w0Yi3JtHi7lb7IAEumt/ZUbwh/peZnqYm9PjMLq9qUQj0xJfTuoJiRIeHojfBAZZmqsoG7O9fQI5Cw6cKrfnmrLwaG1UwgMnpEw=
Received: from BYAPR04MB4965.namprd04.prod.outlook.com (2603:10b6:a03:4d::25)
 by BY5PR04MB6600.namprd04.prod.outlook.com (2603:10b6:a03:1da::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3912.17; Thu, 4 Mar
 2021 22:59:04 +0000
Received: from BYAPR04MB4965.namprd04.prod.outlook.com
 ([fe80::c897:a1f8:197a:706b]) by BYAPR04MB4965.namprd04.prod.outlook.com
 ([fe80::c897:a1f8:197a:706b%5]) with mapi id 15.20.3890.031; Thu, 4 Mar 2021
 22:59:04 +0000
From:   Chaitanya Kulkarni <Chaitanya.Kulkarni@wdc.com>
To:     Kanchan Joshi <joshiiitr@gmail.com>
CC:     Kanchan Joshi <joshi.k@samsung.com>,
        "axboe@kernel.dk" <axboe@kernel.dk>, "hch@lst.de" <hch@lst.de>,
        "kbusch@kernel.org" <kbusch@kernel.org>,
        "io-uring@vger.kernel.org" <io-uring@vger.kernel.org>,
        "linux-nvme@lists.infradead.org" <linux-nvme@lists.infradead.org>,
        "anuj20.g@samsung.com" <anuj20.g@samsung.com>,
        "javier.gonz@samsung.com" <javier.gonz@samsung.com>
Subject: Re: [RFC 3/3] nvme: wire up support for async passthrough
Thread-Topic: [RFC 3/3] nvme: wire up support for async passthrough
Thread-Index: AQHXD/4Dj/1BYoXHfUas1RoZk+MM2w==
Date:   Thu, 4 Mar 2021 22:59:04 +0000
Message-ID: <BYAPR04MB49656F0B96D7D1190B293C1186979@BYAPR04MB4965.namprd04.prod.outlook.com>
References: <20210302160734.99610-1-joshi.k@samsung.com>
 <CGME20210302161010epcas5p4da13d3f866ff4ed45c04fb82929d1c83@epcas5p4.samsung.com>
 <20210302160734.99610-4-joshi.k@samsung.com>
 <BYAPR04MB496501DAED24CC28347A283086989@BYAPR04MB4965.namprd04.prod.outlook.com>
 <CA+1E3rLvrC4s2o3qDgHfRWN0JhnB5ZacHK572kjP+-5NmOPBhw@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: gmail.com; dkim=none (message not signed)
 header.d=none;gmail.com; dmarc=none action=none header.from=wdc.com;
x-originating-ip: [199.255.45.62]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: b1221161-6232-4bbb-c610-08d8df611beb
x-ms-traffictypediagnostic: BY5PR04MB6600:
x-microsoft-antispam-prvs: <BY5PR04MB6600ACC53F21007EE87E0A1886979@BY5PR04MB6600.namprd04.prod.outlook.com>
wdcipoutbound: EOP-TRUE
x-ms-oob-tlc-oobclassifiers: OLM:3968;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: DtKmXZVnsJlFCnMf1ko5wkCQ98ULtsQejE5+3Rqx5/iocov31UGC6OG4TK+Bd6/CWX9OynM2vxA5kwzCA4/tbIS8vm2EwIEjr2mXY+h3bnPP9z63DydEVoe8SNjUw673UqRNV+9dyFM0qhvhVIbGyVl+++cH5smtd0L39Q3lJf4l/2biddPJwhkLxWmz7E8yVZTwKCCmFCXoaJngz1GsHy9cFdBNkss9rLEDzDMSRp2Br0pJjmjz16Dezq0jiR4TjnP1AIgc1FqUvVyp5VbPVVhP9FIfS4zz97mM13p3tnZ65ZiVC6JK+GBs72pi9pwWQQgCEQrU7vUJAQGZ6Tr4Fi6v9Mqf57W+GsHBMcAGICrFNJSXBVEg7JyAyytr95PNKK1JNSYLnsSF7vh8mql043dFCuIuQVcuu2PcnmoyW6SSTc8M9aRi144nFBPljFvYoRAZq2MT5XqWzCfOqQCBqQ3f9FzcPmHB2YPZIiukJW7gAqJ5MEH3q3JaTxDlgIe80nxLYxmkMC1uholaX+iseA==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR04MB4965.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(39860400002)(136003)(346002)(396003)(376002)(53546011)(478600001)(6506007)(52536014)(55016002)(71200400001)(316002)(4744005)(8936002)(33656002)(8676002)(91956017)(54906003)(186003)(66946007)(86362001)(76116006)(7696005)(6916009)(4326008)(26005)(66556008)(66476007)(5660300002)(9686003)(66446008)(2906002)(64756008);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: =?us-ascii?Q?ALj/YGUfGcmLJNiS4/mYRFORhCE6vpUEIcubxfTzgYxB44gmZ9G2kDC65sV/?=
 =?us-ascii?Q?yXwHpDoETqJyk9SB34+3dm72/9wqjRcYpelwlKWrizNgL5oAqTebiUkbBP/W?=
 =?us-ascii?Q?+0Yyfl+n4xmCrAKTodEFkpHQuvdhaVCOMCrpyaphJhh6BVkwjmf3wf5SZ+R3?=
 =?us-ascii?Q?a8olzbzoAfNE9eNYV0f5jL9v/ohjHEq9dra+6fPUCJsdcNrhpUCwXD3AOmcj?=
 =?us-ascii?Q?ITikuGnmkzxuhEp5C8+dj4f3s7NOVQSzWubGLByYMPbGwo6+E2kSdvJUVoO1?=
 =?us-ascii?Q?6riT3h1YkLLrOCSFhWme8XLucdW/LvOJHOW1XQADn1pM0bRut/yMsziaEg4r?=
 =?us-ascii?Q?L6hqDHmPlRoVkth3g1ERzZKc4eXtxNhANXczROv0PE6yp/T46+837eK39i9N?=
 =?us-ascii?Q?Wd03dEeL7VN95TZ1n/KwXKENKZTB0hwfEX/h/L3L7XcdJAg6+IhHX2mjP8Ik?=
 =?us-ascii?Q?4DWujz3korOmRnEe9gc3FnYnCiMwQRe41YiCaSuVDnZDaVnXAcwCUrR/Ofb6?=
 =?us-ascii?Q?ipqY/Ya1Iq9NwWO3sUFkeITT0CMlQt5Hjvz0S2b8/pfoK82a/MFahlQOA2Uw?=
 =?us-ascii?Q?UPvcOa9yZ/Kgt0tcd3sYqfibOcjSAjMaWCswQp2owJgtNhjvnirRck/feb4A?=
 =?us-ascii?Q?lK5hLm9wBqSZRegp6JIhAswKM2Sv9AeYYgN5qLKBpFBBbULwQZ/NtqxBpICe?=
 =?us-ascii?Q?YT1r/++4BteS29RsdNcKSfRyLA4HGMOKcBvj7CwZ+nhNM4pp5k2hVnyaQolo?=
 =?us-ascii?Q?FjsTdySvZbKZNdqsboj5rc0kA5Ja2bl9OfOcCxN/LhWNZrM7M07Pzput4h1Z?=
 =?us-ascii?Q?2qj12ZAIPdxOabQkLZ3d9zLJG9KAlBhdjlwmNEP29IcrFqMLTfooq8hN2jNh?=
 =?us-ascii?Q?wTRpu+lPAQK6hwIQnmrU2XYAXtdCIBbyZye9lH1RK2AQE5R3t3yuSoNbU/C6?=
 =?us-ascii?Q?PJHtubk6EpkVYiuuOiA81jIJzDO6Lg8HL29ydK9LeycXFH1q8hB9KwP6jthb?=
 =?us-ascii?Q?zP5ri+PKiil2x3dswf7fCcptuNK1Vejtgd9TbRq4gL7O6O0kWEOwtsWvCnVB?=
 =?us-ascii?Q?7Wd7iDyUGkOXsLaaLUUzjPTdFJB7vRYSF5hK5FRYSqFKCEjZpx/QM9Skr+GJ?=
 =?us-ascii?Q?aKYc8zy9sXnwOL8GVfwBVZbvNc3ITozmWM+6t+H5Jsv4iGgOuGph7MzCcSjs?=
 =?us-ascii?Q?bH40wS7sxTyueY2AhY0fnmsYJ5Q2TK/LsZlINLha3jNqMxtgF8UsNxPx8gEM?=
 =?us-ascii?Q?xFovOZ4vtw7G89KLVYZrpDKY5giOQV3CnlfzJIp6tT8p0Ntz1M4GsdNkYjOO?=
 =?us-ascii?Q?jIqfmDGEO9lGoRnQn8kfRab4?=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BYAPR04MB4965.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b1221161-6232-4bbb-c610-08d8df611beb
X-MS-Exchange-CrossTenant-originalarrivaltime: 04 Mar 2021 22:59:04.5643
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: Qg9VRQJsXlFVgaNTa0P6prmadDw+50EBHITOvmFMWncMhpxQGEEPfZgGzWVwEEfTBQ+pKmcTmBYG1tGNsMzgQAE+tfhK8kX6lh6iP9gru0Q=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR04MB6600
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 3/4/21 03:01, Kanchan Joshi wrote:=0A=
> On Thu, Mar 4, 2021 at 3:14 AM Chaitanya Kulkarni=0A=
> <Chaitanya.Kulkarni@wdc.com> wrote:=0A=
>> On 3/2/21 23:22, Kanchan Joshi wrote:=0A=
>>> +     if (!ioucmd)=0A=
>>> +             cptr =3D &c;=0A=
>>> +     else {=0A=
>>> +             /*for async - allocate cmd dynamically */=0A=
>>> +             cptr =3D kmalloc(sizeof(struct nvme_command), GFP_KERNEL)=
;=0A=
>>> +             if (!cptr)=0A=
>>> +                     return -ENOMEM;=0A=
>>> +     }=0A=
>>> +=0A=
>>> +     memset(cptr, 0, sizeof(c));=0A=
>> Why not kzalloc and remove memset() ?=0A=
> Yes sure. Ideally I want to get rid of the allocation cost. Perhaps=0A=
> employing kmem_cache/mempool can help. Do you think there is a better=0A=
> way?=0A=
>=0A=
=0A=
Is this hot path ?=0A=
