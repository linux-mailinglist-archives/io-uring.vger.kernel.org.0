Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C9B4120EFDC
	for <lists+io-uring@lfdr.de>; Tue, 30 Jun 2020 09:52:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726994AbgF3HwV (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 30 Jun 2020 03:52:21 -0400
Received: from esa2.hgst.iphmx.com ([68.232.143.124]:43301 "EHLO
        esa2.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726038AbgF3HwV (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 30 Jun 2020 03:52:21 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1593503551; x=1625039551;
  h=from:to:cc:subject:date:message-id:references:
   content-transfer-encoding:mime-version;
  bh=yFl6ir1vxxBWhYPzcDad6KhbEMyI70xel9O+BwcenUI=;
  b=kXqcYOjbbjHqM7EvqSb081K32XcQu7pycQovROG4jwZrFabnpbogpY8q
   m4iaDDFiU8TbDYoMPPnd1PPWTsibht9/G7lH0M/LYRyiITDKub0xAIGNh
   eHXELp+fGY5Of0IaXdJvZZ5vbHnflB170+d9xihyoGSrRb0SgvxkM2R9B
   FFq35vEk1jsxkDvyFJYRom/cpATFfjpCkgV4dG/jQpEtUckmQef3p3nVb
   m3B9ZHrHyL/RlNsTiaK1G/PzjjE0bbJ6yF9ULM19POyZzTUpo51vuvgfH
   Ew54SWo/ZhsUPlNvy2P05iFh8gglZWFtV4KvcCwAQVvZja6Xv/gCt/5XX
   w==;
IronPort-SDR: CmVkNWpZE0keNNZXVZ9lOk1K0H7ROOsVQQ9R2y33WhddreWjgFYWd4Ln3ipgBqhA/k0b5bF9uw
 yD4TRjyfwkADQDRQwyw+fl964NQbcec6/4EHJ39KFn8v5fzqKet4w0q67dBsB8RnEWiEobU3Ct
 0FEo0RWqE1Z8uVlHgoOnLdwPah59lLpXyPDwQCvGNs+KYWNwB4IQfuZvLE0aEQ8KUVynFqcKDc
 kH3nnBAaDgtZxPP7v647PUFkPAo6lPzly9F0OIZEDJThsJKNdZWzk/PGQDs0hOa2BUSgoOXQBb
 Oqo=
X-IronPort-AV: E=Sophos;i="5.75,296,1589212800"; 
   d="scan'208";a="244276496"
Received: from mail-co1nam11lp2177.outbound.protection.outlook.com (HELO NAM11-CO1-obe.outbound.protection.outlook.com) ([104.47.56.177])
  by ob1.hgst.iphmx.com with ESMTP; 30 Jun 2020 15:52:20 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=g6rcALgckHB9H2iKQMrdSAJT/Ja0IvRPlnbobK9g+lcSnlqjGodsIJGI2oBAzFjEcssGpBFg5tU02QAAGrdOf8R1ZsTa3X+Esqb9xPzJ1qv+e6BEL7xYNe+mKQhSG6y4p1WFHA9BKjjsp2LJSutocoQZykxDxK809k0Lpc0szN0jgiSHYxnml+YMqV0HU0YTiZyHotXd+zd8I6CJAdjeXsjASRCOmeQXclBHzHWCn+fL3RAkqhnTC2jJFzVX/yitdMy2bADu/vgqMGHj7u0I320oFmyYgcjjMHIh8wXLxLYvri63YpWgKU6K/4GhmBTgUTB8wb7Erf8Y5prSQv95fg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=xVPs7rN8Zvij8d9gQTv/t4w3l14fbautazJl0umdLnA=;
 b=PTMgiqOFC7E3xfQzUqDSF0hza7ReSOixEpglOocXuvwWTe553kryh6umx9WgCrD3KLPt+x69WrRj90lFLEAArPwAZPJ8Ojoot3FJnyGHMUh13HOqEtcU/CDX5jYRi4qvQoQcBsYdW1PmsrVdFz67S+8pbDQEbbld1cgV2DnlOYbWIwjyzFsAai4f/EdEg9Xvv/azY8O+wTdG+x33J5JZ/JDxqAVzA9CqA3B5Cm0QERV4Y1nSdvQVZ+DQ/1ZR9CGGQVqMlTO0TyW7HHzIV29wSC5rAeQx2EIIBBDlKg9/w5xk7RD/ZgB7uEyXr1t2D6vOdR7CMjgqPHmW79KIVK2pQw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=xVPs7rN8Zvij8d9gQTv/t4w3l14fbautazJl0umdLnA=;
 b=DAk0wJSMvdurmqV+pDcqHl0OEOzH9KkZadAVnBnGqTgP3UAePGYIc2Ed5RFMVRlBIRDQOQw5v1olAoyh90XAOhQK1NbYTWcrus9m1ljHPL6IbD76llE9j75qxrcl61viHQR1OseaKtZjuPfsG9Yr5l8Hftd6iTgzuJGz8/nzq1E=
Received: from CY4PR04MB3751.namprd04.prod.outlook.com (2603:10b6:903:ec::14)
 by CY4PR0401MB3586.namprd04.prod.outlook.com (2603:10b6:910:8e::29) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3131.25; Tue, 30 Jun
 2020 07:52:11 +0000
Received: from CY4PR04MB3751.namprd04.prod.outlook.com
 ([fe80::c593:f271:eebe:ac7]) by CY4PR04MB3751.namprd04.prod.outlook.com
 ([fe80::c593:f271:eebe:ac7%9]) with mapi id 15.20.3131.024; Tue, 30 Jun 2020
 07:52:11 +0000
From:   Damien Le Moal <Damien.LeMoal@wdc.com>
To:     Kanchan Joshi <joshi.k@samsung.com>
CC:     "axboe@kernel.dk" <axboe@kernel.dk>,
        "viro@zeniv.linux.org.uk" <viro@zeniv.linux.org.uk>,
        "bcrl@kvack.org" <bcrl@kvack.org>,
        "asml.silence@gmail.com" <asml.silence@gmail.com>,
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
Date:   Tue, 30 Jun 2020 07:52:11 +0000
Message-ID: <CY4PR04MB37517AAE0B475F631C81B404E76F0@CY4PR04MB3751.namprd04.prod.outlook.com>
References: <1593105349-19270-1-git-send-email-joshi.k@samsung.com>
 <CGME20200625171834epcas5p226a24dfcb84cfa83fe29a2bd17795d85@epcas5p2.samsung.com>
 <1593105349-19270-2-git-send-email-joshi.k@samsung.com>
 <CY4PR04MB37511FB1D3B3491A2CED5470E7930@CY4PR04MB3751.namprd04.prod.outlook.com>
 <20200629183202.GA24003@test-zns>
 <CY4PR04MB3751213DD4B370F58A63368BE76F0@CY4PR04MB3751.namprd04.prod.outlook.com>
 <20200630074005.GA5701@test-zns>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: samsung.com; dkim=none (message not signed)
 header.d=none;samsung.com; dmarc=none action=none header.from=wdc.com;
x-originating-ip: [199.255.47.5]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 68ff1a5f-d425-424b-78dd-08d81cca7f34
x-ms-traffictypediagnostic: CY4PR0401MB3586:
x-ld-processed: b61c8803-16f3-4c35-9b17-6f65f441df86,ExtAddr
x-microsoft-antispam-prvs: <CY4PR0401MB3586DF0FEFCEC54D0EC27EDBE76F0@CY4PR0401MB3586.namprd04.prod.outlook.com>
wdcipoutbound: EOP-TRUE
x-ms-oob-tlc-oobclassifiers: OLM:9508;
x-forefront-prvs: 0450A714CB
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: D2G9s92DhHFWEt0bZlAcKnO+R7yYgV0OpvbyJoea/eipsbME9WFTgVeM+Ouv1a1QhZTa4YP6Hi76yBEGQO2i9KeNWQDSiQtsloBXDqCAIZ4axoQdr5cTb1US/bEhZuZbk8l0JUbc3yUnQAYqRocudDjMO0ISeCzHv2vM6hj2f/eJTYjemyc5qmhJ7QUKzOycDsPTWMbYboKeI22bMJM1A8SGfO2WTBsaxfzZK73dqJTfkdBS2v1jY/BSt0/IQ2ua6Nt21zZ0fMSs7otbzQbGlDHnmKbneCwbB3/ph8IBE4M08xxJFcQF6fsJHeNA7NCvNImb9h5emh8K0tvkpjc/wG0NDyChRw0g4EAtZI5t7j1y8UvqgdlbwvTRRpxiP8Vb
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY4PR04MB3751.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(376002)(136003)(346002)(366004)(39860400002)(396003)(7416002)(33656002)(478600001)(316002)(52536014)(5660300002)(54906003)(4326008)(71200400001)(53546011)(76116006)(26005)(2906002)(66556008)(186003)(86362001)(8676002)(6506007)(55016002)(6916009)(8936002)(66946007)(64756008)(83380400001)(66476007)(66446008)(7696005)(91956017)(9686003)(142933001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: alNZ4lG+jq7/l7YuBOQ9+pRyQkMWW7qLgFSJwqvSEHvYyWdGtYbuo+NsM/S7fIwvnKHTKwSKYMUq44+GNvHu9Vz0dsKZT+7JvTxB2+A10np0smWmdfWIYrjj/fJvwFV61rw6BU3uxgvkxOShGkv+R1z4/LZoIP0+zRb3qsbA1ottVYarCUnkBfdcaeUoRDrW1YTwh4lnwRx/AHHFgIberdTSiqmEdeasRtLd0WeXK95O+wgVYSe/RIthXevy5tVoKLm9wmqnlQT616edyA/DEpr6E+zMLCE4F54BgmR5iT+8pxNlu3qxaw6S5Gvw5ajMAbp3ds7lXv3e3E7ybHplMG7bwwFbXbjMeYQ1mES0oaYqcjlwjTlu6bfE7ucX2uvtoYbhj/vFWtUfG+IFHanweu6C0/ULG7/Vhd6KuSqq6LbxzJNnXEOGY7vH6KsQ/VhdWZsM7+3f9dE0M76sp7wVlBpYQ5w9NKOXENRTc7UOo5s=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: CY4PR04MB3751.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 68ff1a5f-d425-424b-78dd-08d81cca7f34
X-MS-Exchange-CrossTenant-originalarrivaltime: 30 Jun 2020 07:52:11.4262
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 5+Y9mRIAHIJEr15c4I12RKb4rRS33QaVNu8sslTzz3xcvkdl+UVoktq1dJ1JG8BbvIROg98Jh6aggtdI6YlQ5Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY4PR0401MB3586
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 2020/06/30 16:43, Kanchan Joshi wrote:=0A=
> On Tue, Jun 30, 2020 at 12:37:07AM +0000, Damien Le Moal wrote:=0A=
>> On 2020/06/30 3:35, Kanchan Joshi wrote:=0A=
>>> On Fri, Jun 26, 2020 at 02:50:20AM +0000, Damien Le Moal wrote:=0A=
>>>> On 2020/06/26 2:18, Kanchan Joshi wrote:=0A=
>>>>> Introduce RWF_ZONE_APPEND flag to represent zone-append. User-space=
=0A=
>>>>> sends this with write. Add IOCB_ZONE_APPEND which is set in=0A=
>>>>> kiocb->ki_flags on receiving RWF_ZONE_APPEND.=0A=
>>>>> Make direct IO submission path use IOCB_ZONE_APPEND to send bio with=
=0A=
>>>>> append op. Direct IO completion returns zone-relative offset, in sect=
or=0A=
>>>>> unit, to upper layer using kiocb->ki_complete interface.=0A=
>>>>> Report error if zone-append is requested on regular file or on sync=
=0A=
>>>>> kiocb (i.e. one without ki_complete).=0A=
>>>>>=0A=
>>>>> Signed-off-by: Kanchan Joshi <joshi.k@samsung.com>=0A=
>>>>> Signed-off-by: SelvaKumar S <selvakuma.s1@samsung.com>=0A=
>>>>> Signed-off-by: Arnav Dawn <a.dawn@samsung.com>=0A=
>>>>> Signed-off-by: Nitesh Shetty <nj.shetty@samsung.com>=0A=
>>>>> Signed-off-by: Javier Gonzalez <javier.gonz@samsung.com>=0A=
>>>>> ---=0A=
>>>>>  fs/block_dev.c          | 28 ++++++++++++++++++++++++----=0A=
>>>>>  include/linux/fs.h      |  9 +++++++++=0A=
>>>>>  include/uapi/linux/fs.h |  5 ++++-=0A=
>>>>>  3 files changed, 37 insertions(+), 5 deletions(-)=0A=
>>>>>=0A=
>>>>> diff --git a/fs/block_dev.c b/fs/block_dev.c=0A=
>>>>> index 47860e5..5180268 100644=0A=
>>>>> --- a/fs/block_dev.c=0A=
>>>>> +++ b/fs/block_dev.c=0A=
>>>>> @@ -185,6 +185,10 @@ static unsigned int dio_bio_write_op(struct kioc=
b *iocb)=0A=
>>>>>  	/* avoid the need for a I/O completion work item */=0A=
>>>>>  	if (iocb->ki_flags & IOCB_DSYNC)=0A=
>>>>>  		op |=3D REQ_FUA;=0A=
>>>>> +=0A=
>>>>> +	if (iocb->ki_flags & IOCB_ZONE_APPEND)=0A=
>>>>> +		op |=3D REQ_OP_ZONE_APPEND;=0A=
>>>>=0A=
>>>> This is wrong. REQ_OP_WRITE is already set in the declaration of "op".=
 How can=0A=
>>>> this work ?=0A=
>>> REQ_OP_ZONE_APPEND will override the REQ_WRITE op, while previously set=
 op=0A=
>>> flags (REQ_FUA etc.) will be retained. But yes, this can be made to loo=
k=0A=
>>> cleaner.=0A=
>>> V3 will include the other changes you pointed out. Thanks for the revie=
w.=0A=
>>>=0A=
>>=0A=
>> REQ_OP_WRITE and REQ_OP_ZONE_APPEND are different bits, so there is no=
=0A=
>> "override". A well formed BIO bi_opf is one op+flags. Specifying multipl=
e OP=0A=
>> codes does not make sense.=0A=
> =0A=
> one op+flags behavior is retained here. OP is not about bits (op flags ar=
e).=0A=
> Had it been, REQ_OP_WRITE (value 1) can not be differentiated from=0A=
> REQ_OP_ZONE_APPEND (value 13).=0A=
> We do not do "bio_op(bio) & REQ_OP_WRITE", rather we look at the=0A=
> absolute value "bio_op(bio) =3D=3D REQ_OP_WRITE".=0A=
=0A=
Sure, the ops are not bits like the flags, but (excluding the flags) doing:=
=0A=
=0A=
op |=3D REQ_OP_ZONE_APPEND;=0A=
=0A=
will give you op =3D=3D (REQ_OP_WRITE | REQ_OP_ZONE_APPEND). That's not wha=
t you want...=0A=
=0A=
=0A=
=0A=
-- =0A=
Damien Le Moal=0A=
Western Digital Research=0A=
