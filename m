Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 62F5932E078
	for <lists+io-uring@lfdr.de>; Fri,  5 Mar 2021 05:14:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229564AbhCEEOO (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 4 Mar 2021 23:14:14 -0500
Received: from esa3.hgst.iphmx.com ([216.71.153.141]:21353 "EHLO
        esa3.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229458AbhCEEON (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 4 Mar 2021 23:14:13 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1614917653; x=1646453653;
  h=from:to:cc:subject:date:message-id:references:
   content-transfer-encoding:mime-version;
  bh=lngAJebvLNIKPqe21Pd/Zt4nK4VJXY566p8PQgl/fZ4=;
  b=DW9Xy1asNXfJgiTzW62YttGSAm8I48XL8fqa4rTa/3FSxqCTeBmMZlBw
   kV/0Bg4QNWPmv9szmIAHix7rNJh80QDxu8FHxt38IkkP3/1jshgZqov8K
   7BCZogt5RvAWv7A5FrXV64RTKfrDeKMFrv0d3z79OPDVRmoDx/WUkVTOf
   spcQ7Y4TqR00SMCsTDjrKoT2HWeIyE+IfDeJ3n/Zf8YNXZXnpVcgoPPLX
   uqUQeiLQbbRWxe7j1nIajPdN9hKY1gO/83Izegr1xaoFWHMVSIl29fpKS
   uOobCqGS5w/XjVm50Hi2wm5IWlcECPIlzmG6XZH92ns0OKt7vAjmYRKMM
   g==;
IronPort-SDR: 2y9CE7oPO5CmkVI1lNg/mH48zHaYKhMa7Q7zCYGb9ZnmNEzj86mTQtD6TzrdM+Su7iZIKcJ6Tj
 o8zLxIyMqaPjgoZ0jPffVNuvRs7u3dQgPCgiJA3pIEhVPsM/y6ditjAsnF0+u81oCFi6Ml/gFh
 yslWQqmEBkohjDzwVt3YOu3Z3kluJ/FtT5M1a+WLb8E3IPbpDqavvX6OJeOHYbRqEkQGEwi7iE
 FUBtaYH9E2/TyHYudCqm5+kZK2sf7iHBUTADYjGiGajD1oxyOBipCiqFX0XZkS1lPGmXHE9o3q
 xtM=
X-IronPort-AV: E=Sophos;i="5.81,224,1610380800"; 
   d="scan'208";a="165897514"
Received: from mail-mw2nam10lp2109.outbound.protection.outlook.com (HELO NAM10-MW2-obe.outbound.protection.outlook.com) ([104.47.55.109])
  by ob1.hgst.iphmx.com with ESMTP; 05 Mar 2021 12:14:12 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=MRxgLLxQUlW6gt6mrOPEbgxM7KxfiHZUzgXFus88O++CP+XPYkU4PFy0wAC/lT/I3ZHlrPtRSwOHfjJ97fFFjshqQs5BAZ2ZvdrYrnBaXcdispInjNq31o9U3FddELjn4dHRNQC6Y4m0+s19ThCivqm2WH0l1PyLUkOM2l69NwMU0/uWf2QsCnDaz+oa46z6OF9ATI4nZrQeitALMy6XKwL/Xo7VPHhb0CkJPHXK0b9nAZxbW/tOV/0VnKPzYTNl7Fym/hLIRc1WnPWrtlw7XzQuVkxzJFEhv14IJoIWF9VsfBChe7CSzLQiU88WH9A1iJGrMjhbJmEcYPzRUqYvKQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=RScwyRXRLizNHR00xBc7A82nfvR9o/ArcmXzNbmpy9k=;
 b=HqeQB7HYaGog+024yagdfLeqZI4KhfTo1rZork29Cdn6C2KnzE0EORtU6fXU1N3MqneFgA7/d6ihmVj+lo1T0QslqoX14VBwlepvLbt1OUJne4TDowHLaMFzyzqen/5m4UZa/v2TwjaGHUb4qKZTqB8ihViPYYjaiem14d9oL/6/tviW2y1lT+c9HdVxTB+CVboy1RfGJct8fr8MOnkq0v5QjQCgxotIRvdd0PQtwcxwfYpGvAIt2LeiFM4Yrc4w/lYvZH7PCCbbA1gC2eUWVbJXoSPhuOlq14DKeIBFjDelBeRWmlEO/cRB/zDYFPiUEtXijq3Zm8PfUDC0CnVEnA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=RScwyRXRLizNHR00xBc7A82nfvR9o/ArcmXzNbmpy9k=;
 b=aNsfzNngWZTE8/+yz8J44gBa8a3nsJVWsZNP2geXV9HhOFyERmFMBCyciDhNvGNMw4zaDEFOOnD2J28IRMFuYZ9dfv0J8p/kTYloRvfz9wjPlJsAiFoBDGK4VfIPWJDIXBCJ+dn4iiEmtxrPBqz0gEhbE1tRsdwE97O4BHs+aZc=
Received: from BYAPR04MB4965.namprd04.prod.outlook.com (2603:10b6:a03:4d::25)
 by BYAPR04MB3861.namprd04.prod.outlook.com (2603:10b6:a02:ac::33) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3890.20; Fri, 5 Mar
 2021 04:14:11 +0000
Received: from BYAPR04MB4965.namprd04.prod.outlook.com
 ([fe80::c897:a1f8:197a:706b]) by BYAPR04MB4965.namprd04.prod.outlook.com
 ([fe80::c897:a1f8:197a:706b%5]) with mapi id 15.20.3890.034; Fri, 5 Mar 2021
 04:14:11 +0000
From:   Chaitanya Kulkarni <Chaitanya.Kulkarni@wdc.com>
To:     Kanchan Joshi <joshiiitr@gmail.com>
CC:     Kanchan Joshi <joshi.k@samsung.com>,
        "axboe@kernel.dk" <axboe@kernel.dk>, "hch@lst.de" <hch@lst.de>,
        "kbusch@kernel.org" <kbusch@kernel.org>,
        "io-uring@vger.kernel.org" <io-uring@vger.kernel.org>,
        "linux-nvme@lists.infradead.org" <linux-nvme@lists.infradead.org>,
        "anuj20.g@samsung.com" <anuj20.g@samsung.com>,
        "javier.gonz@samsung.com" <javier.gonz@samsung.com>
Subject: Re: [RFC 2/3] nvme: passthrough helper with callback
Thread-Topic: [RFC 2/3] nvme: passthrough helper with callback
Thread-Index: AQHXD/4EOPP4CH9isESsU82uWJlGPw==
Date:   Fri, 5 Mar 2021 04:14:11 +0000
Message-ID: <BYAPR04MB49658E6ACD06FAC7F6F26A6886969@BYAPR04MB4965.namprd04.prod.outlook.com>
References: <20210302160734.99610-1-joshi.k@samsung.com>
 <CGME20210302161005epcas5p23f28fe21bab5a3e07b9b382dd2406fdc@epcas5p2.samsung.com>
 <20210302160734.99610-3-joshi.k@samsung.com>
 <BYAPR04MB496566944851825B251CA93686989@BYAPR04MB4965.namprd04.prod.outlook.com>
 <CA+1E3rLCSWDmLa1rrZ986xnbx6fcsGgBE6NPP59eJj4swY+gQg@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: gmail.com; dkim=none (message not signed)
 header.d=none;gmail.com; dmarc=none action=none header.from=wdc.com;
x-originating-ip: [199.255.45.62]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 8291c884-5e99-4059-43cc-08d8df8d2152
x-ms-traffictypediagnostic: BYAPR04MB3861:
x-microsoft-antispam-prvs: <BYAPR04MB3861B319BE32CFB3BD50870186969@BYAPR04MB3861.namprd04.prod.outlook.com>
wdcipoutbound: EOP-TRUE
x-ms-oob-tlc-oobclassifiers: OLM:6430;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: A6uhaPs6+L2FdcvOKXJOFbCwdQCD0YHjKtUmfmGxdIrYFHWxVkKLqRccqdftDiqWFVUc5CNoXWzsm9hiFD1cJ+hAa6P2we74WgEK+V3oak+HiDzL/UQ9rU+bSXIHRXgP3sHaiALvKn+JRXH62v4osUUw2ePwq4hW/7jPx4MrclaacMidXTfwHaLVUr/30rkwkdRxihHIbZH2+iv7oQUViPvcdbYQGtfm7qFZB/IXlDyvmS/rFW03JnmdKK6a9FDyV9zxh3LN3vsRkboNiJomfje9JWFi3a/235sdzmNbH3bnxjcN3QSkTiu3GH0yxRzmCJ0lJEE/P+tkHBUm8sK5Lu/E8acejPBLt9QDp2xvQEwSPbifLtguCqonGtEsjyKYPMyZir35/LZh6rRq6Qf0zSUHkm1paR2CsuKjvPp4pgqByn6tskyCAe7kJBmL6/YnAaD1xZz2A3mOd8LMv7ZlbCrB2vcSoeK9YiuYuCJup1nmUATqBxU1DNJ4r1B7ntcLSyu6Q+wtutgIGWGobIPrAA==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR04MB4965.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(396003)(366004)(39860400002)(376002)(136003)(346002)(2906002)(478600001)(83380400001)(316002)(33656002)(86362001)(54906003)(26005)(71200400001)(6916009)(4326008)(52536014)(7696005)(66946007)(55016002)(6506007)(66556008)(66476007)(5660300002)(8936002)(186003)(76116006)(64756008)(66446008)(91956017)(53546011)(8676002)(9686003);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: =?us-ascii?Q?HAZVDIZRKgKpgWZRCJ3O7G0hyuu1G3DG9CDsj6Omg7MtH683zBikl2vTntUf?=
 =?us-ascii?Q?MoH9HDGeAAmYGzrQ62mDIE+4LXz0JvHb03m2usoUG0I5UJ41cE2fATQXS3YI?=
 =?us-ascii?Q?6qWmRyfOnECgmaT7ajIhYp8viDBzoZn4orx/elYq74RGITsPAhWaiCkDbhjE?=
 =?us-ascii?Q?By0uomVOboIv2AA8RYDTmUQN6FgFgSTYHyqk1N1Gs+PxQxRdJ0MtZJj0Pjh4?=
 =?us-ascii?Q?uLtiZsNQFHbbmMyOklcmir/x8j3M9wLSz2S8mKHm1jlVjdOSh5vYynplvJY3?=
 =?us-ascii?Q?ykmh7MJvXC1U6U1E3bwdIIe6XQIdID+JUTdrXLB8SOXjD+zZIotl6/eKEDEj?=
 =?us-ascii?Q?S0OtH8X3i7XaoZ2qYrX91eK0ZiSzqcwjOJ3g/v3cUJQWMigElQMM+P9Dsblo?=
 =?us-ascii?Q?ogrbI0b6rFvRetaqKSUZM+yhnSHlCeM2QlZOpRpCWd4ZO/k5FFQBCzNkQ2vm?=
 =?us-ascii?Q?cQ/eXaeicWRtFDbZ7XPdJP5FjEFgl7aEkLzSA162wkikzmTt0OoGHxKzF6cB?=
 =?us-ascii?Q?Q6Q97gyBf1Qxzbf7TqNJ9opmqFZYlK8vbWcbrMc37jvD/EMq938/zkcrze6I?=
 =?us-ascii?Q?MEpt1t4UnGDd1nwRCxa/84ypseJmTLQuGMSyjYV/DKiKmJHWHHFAl+X/f9N/?=
 =?us-ascii?Q?jLnkYzsGZzuCFSarV1i5g7yD5fRomms2q6NXLtTaF2bteJGXQenTyMIENl/P?=
 =?us-ascii?Q?NkpyBhu3pXlu+S8qjYGk7kLdZjqxUis1FOTIRnN+CcZuUrvr0oQV/iv0jQTN?=
 =?us-ascii?Q?QbSarEEvWPd6AthjAPnlVAo1S9Z4ICjO7PCklYNFq6gGJJcn3BfFpqcU/iCQ?=
 =?us-ascii?Q?m2PZZRzt/czdFDxEIyo85mVHWAy03/JtMKYJirXBjHLTeClnj6KVKl8G4M72?=
 =?us-ascii?Q?cCXOfaXvHwWeHVDnV4d6qrr+7pmjubFkUhuPSuiuH/9RpByPAi0Va4Ox60PP?=
 =?us-ascii?Q?hsxugUdMLRhyLr9Yz2mKSPoStEPug25Dh7Cm/jNbD8Cn0U7tSFU8pD6mmpqf?=
 =?us-ascii?Q?TpNKpRLXq4NzMEgb8ssYU+MNJ2CziOEj6y9/tLXKm4LFxiwg0wwBCY9aYq9/?=
 =?us-ascii?Q?EQs3bFg4oNZqMDxXX1O8O+QQdeTa45GK4ldOnsFPpkOoTQmhxitdcYdN9cWw?=
 =?us-ascii?Q?N4pFIQQMSS/Qqg8WMnaqV/zXdlAOU7ZzR8rsIhIlzTHnpH/sVVGj+32A3esa?=
 =?us-ascii?Q?UkNbgX2DyBrZbPpg6fkvn64fm0KDItGHFWjfTVHs45CmEwTUIDJCzQVQiWyn?=
 =?us-ascii?Q?6LpIM+oPMTuB2O6ZDCwUuNFLNmW9GLWvY/SxP7sK9T2e6wkmA5KRWQ8wn1v5?=
 =?us-ascii?Q?l6WYDNbvJP3IyiAEAcZSXK/q?=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BYAPR04MB4965.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8291c884-5e99-4059-43cc-08d8df8d2152
X-MS-Exchange-CrossTenant-originalarrivaltime: 05 Mar 2021 04:14:11.3628
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: iqd83NXh2H1xTkBkDLL7okq5jJv9fp7O9+6nYeaGiFIt87spHsiP4yeH1NRsFa0BS/u6u3LK/dK9IJhi4OqOqgBP3aRca0ZuVh/mKkvaTmk=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR04MB3861
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 3/4/21 03:14, Kanchan Joshi wrote:=0A=
> On Wed, Mar 3, 2021 at 8:52 PM Chaitanya Kulkarni=0A=
> <Chaitanya.Kulkarni@wdc.com> wrote:=0A=
>> On 3/2/21 23:22, Kanchan Joshi wrote:=0A=
>>> -void nvme_execute_passthru_rq(struct request *rq)=0A=
>>> +void nvme_execute_passthru_rq_common(struct request *rq,=0A=
>>> +                     rq_end_io_fn *done)=0A=
>>>  {=0A=
>>>       struct nvme_command *cmd =3D nvme_req(rq)->cmd;=0A=
>>>       struct nvme_ctrl *ctrl =3D nvme_req(rq)->ctrl;=0A=
>>> @@ -1135,9 +1136,17 @@ void nvme_execute_passthru_rq(struct request *rq=
)=0A=
>>>       u32 effects;=0A=
>>>=0A=
>>>       effects =3D nvme_passthru_start(ctrl, ns, cmd->common.opcode);=0A=
>>> -     blk_execute_rq(disk, rq, 0);=0A=
>>> +     if (!done)=0A=
>>> +             blk_execute_rq(disk, rq, 0);=0A=
>>> +     else=0A=
>>> +             blk_execute_rq_nowait(disk, rq, 0, done);=0A=
>>>       nvme_passthru_end(ctrl, effects);=0A=
>> This needs a detailed explanation in order to prove the correctness.=0A=
> Do you see something wrong here?=0A=
> blk_execute_rq() employs the same helper (i.e. nowait one) and uses=0A=
> additional completion-variable to make it sync.=0A=
>=0A=
=0A=
There is no gurantee that command will finish between call to=0A=
blk_execute_rq_nowait()=0A=
and nvme_passthru_end() is there ?=0A=
=0A=
=0A=
