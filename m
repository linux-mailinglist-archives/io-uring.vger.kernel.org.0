Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B2C9C20F002
	for <lists+io-uring@lfdr.de>; Tue, 30 Jun 2020 09:56:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730183AbgF3H4u (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 30 Jun 2020 03:56:50 -0400
Received: from esa5.hgst.iphmx.com ([216.71.153.144]:26562 "EHLO
        esa5.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730067AbgF3H4t (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 30 Jun 2020 03:56:49 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1593503809; x=1625039809;
  h=from:to:cc:subject:date:message-id:references:
   content-transfer-encoding:mime-version;
  bh=bNqJDdp8vr8UF77RWTHUO4gOLTkdRagymdi3ToUTYHI=;
  b=oWM4brxFtCs7jxtrSOzKmgJCvswDFujb2exGeEORCJYmlVtM5nrUUTIL
   crhTFlNMa0SyORxHC/9v3IsZJFGxPH/1ZZAGe9oTCnqU4lQ1zSRUm6DlJ
   t/mGrnv5kl1Yi563xujuPbMn+Y96PDOsMlJv8iWZXoa6uGVvFkwk69ZbN
   cjFtinyb/arAGrvoVYNOjd9E+/gD1NaG+3qNE+xw6BIp7MJMXqY1zJrmu
   XzkwDgo+qR+cAPQfJGvz8+B2Z2fT9g1gMybq1QrlOqg+geG5uDp/KJDy9
   QBaniDsLzgg8KyYtpfA1Wrg1NgUgmcvONaIVdBJnvJlb2FNNccvpPYFjy
   g==;
IronPort-SDR: ddakNfOhIG6FftB9Q2IiLbSOamzS2aty6ybLDwbAuO5z91AhapoE6KkX63ODIJalQMy6PLp3KP
 V9hzynsmciC3RsFrQjJ9HPhumdDPizscWdlGqduT2ulb1K8jX04FkTcyLKoxbAS0GO+D7E5t3a
 lQM0c6+rrMWLwZd8kJvx0r6byCUaXpknoC8S0Z3G3H2jTBXlS2AUqnVKusXZ70y23il0VyY99P
 mzp3SK1c/h+/kWN+aDkf/ElmaPVMhadRHgVKgL6J4eUVha7nvUycogT5DU5NAMndSfNuJSlxDI
 VD8=
X-IronPort-AV: E=Sophos;i="5.75,296,1589212800"; 
   d="scan'208";a="141465301"
Received: from mail-co1nam11lp2175.outbound.protection.outlook.com (HELO NAM11-CO1-obe.outbound.protection.outlook.com) ([104.47.56.175])
  by ob1.hgst.iphmx.com with ESMTP; 30 Jun 2020 15:56:48 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=TCKcg5aq6RKkHsxdWbnp2w3jeZmAYRFSObxKFnRGGxUXuD+3y63hKI8kBl97VBCJ9HEFktgdQBvXHRupPqQwgoMAeFzX61CsHyPywrt5sVumH6ltu/hQ1/RVgnavqIrI2nSQqcM8zCZJPQuhghdXJqNuKFbeKJ6g9K/zksJE7wou9XJYNk4aqqeJFQWfV8259neLAOC2uK/16kXTWFS/YP7mNSEUBlq5PQswpldv+sgh/OgYrJ5ZfT8ej0VUBclekcPTd3OHydo3cellBhjQ5CHO0GNqvXLSQBm4oMrXVaI9sEiYIGfJo0jyltbAiLqtDMndFLiRRwaFTpeB5mF2TA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=rV3b+p1CFPM/X7ivXpfE63fU65FzZ8owCmqx6MWEmF8=;
 b=mehmoBeIwXSpMfdNeNJknFSs+DJMzyKbFdzRD+Qtess2uXnfVqiIugPlgv4pSzWEUNsI/68ZGDgD2FvERVWcivyOp5WUVQbj3/IW3IcRSq0aqOQnstrJnhMH4TtXtaqklsQHIeC5sFBLC2SxTtAnS2IudoOAYVqO+5ikWTd7+9AcK/+Ps0Mwh4UT1LaAdwqjYPN9xHI8I9+ANmAQ87sqvZ5z2rJ87lJ3EKD2EVWPSP9GgWZoyjOchjDtnCD1Rrqd+2Lb21jSyL0jMhiJumBT2zV9zohmVCfB6FrU9EITXT8+dqIlzS27I1tnnQJspT2+3ITihaDkQhfPWFaK7v+AHw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=rV3b+p1CFPM/X7ivXpfE63fU65FzZ8owCmqx6MWEmF8=;
 b=ESRSubAZ8/3CMm8J+c0TyqZljiFFNqZT2M4/0bL44oRsh2csxYyrD96JzwWnU9zoSEJD0Y2te+rNoe9HgeA7cFqmGY0q06ZnloYK7KJB0eIrIXuhsZAnjkMgeyxp3bpOBA1mWdZTTiaKGt/EqT4bjwq9nlq+DC5wiRIrEd6/5uI=
Received: from CY4PR04MB3751.namprd04.prod.outlook.com (2603:10b6:903:ec::14)
 by CY4PR0401MB3586.namprd04.prod.outlook.com (2603:10b6:910:8e::29) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3131.25; Tue, 30 Jun
 2020 07:56:46 +0000
Received: from CY4PR04MB3751.namprd04.prod.outlook.com
 ([fe80::c593:f271:eebe:ac7]) by CY4PR04MB3751.namprd04.prod.outlook.com
 ([fe80::c593:f271:eebe:ac7%9]) with mapi id 15.20.3131.024; Tue, 30 Jun 2020
 07:56:46 +0000
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
Date:   Tue, 30 Jun 2020 07:56:46 +0000
Message-ID: <CY4PR04MB375162ABFFA5BB660869C57DE76F0@CY4PR04MB3751.namprd04.prod.outlook.com>
References: <1593105349-19270-1-git-send-email-joshi.k@samsung.com>
 <CGME20200625171834epcas5p226a24dfcb84cfa83fe29a2bd17795d85@epcas5p2.samsung.com>
 <1593105349-19270-2-git-send-email-joshi.k@samsung.com>
 <CY4PR04MB37511FB1D3B3491A2CED5470E7930@CY4PR04MB3751.namprd04.prod.outlook.com>
 <20200629183202.GA24003@test-zns>
 <CY4PR04MB3751213DD4B370F58A63368BE76F0@CY4PR04MB3751.namprd04.prod.outlook.com>
 <20200630074005.GA5701@test-zns>
 <CY4PR04MB37517AAE0B475F631C81B404E76F0@CY4PR04MB3751.namprd04.prod.outlook.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: samsung.com; dkim=none (message not signed)
 header.d=none;samsung.com; dmarc=none action=none header.from=wdc.com;
x-originating-ip: [199.255.47.5]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: ef6c4885-49fe-4186-13bc-08d81ccb2350
x-ms-traffictypediagnostic: CY4PR0401MB3586:
x-ld-processed: b61c8803-16f3-4c35-9b17-6f65f441df86,ExtAddr
x-microsoft-antispam-prvs: <CY4PR0401MB3586AC89852B3B829035844EE76F0@CY4PR0401MB3586.namprd04.prod.outlook.com>
wdcipoutbound: EOP-TRUE
x-ms-oob-tlc-oobclassifiers: OLM:9508;
x-forefront-prvs: 0450A714CB
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: ci+mstYvc/PmnPqyQVTXPMQcpeAYDYAKZL4nlVkjgau+oW8Y0ysS26CtTAYS+VHDKeOzJH7hv0DncIR+lSwa+2+tyPsMbpAVmSEBVm/e05/q3BGSQe22modlshrrC4F7FZVbbFQa7VnynoQJuk+KMJfATrUkhs3yS7ss6J9yRF4FDjHGydES4SdB+2jr3dYZOW2EOSQcAU/hINloI4Iqe6jYEzRwsqhrDCnb1FF14z1gIZtEd3IHXg/JeTgcgks/PzGzCD3MxWyLz5G8CFhGCo82u4Oxkv0yQCDUbGTDkjUp4MG6E02cEq0/gJIZbb5oxlAi2IgXmyMCh3yVesFN2jrvt5ZS6Qs9ExS5+rV9JeANtOxHjXYERMyzPJeBVbMe
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY4PR04MB3751.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(396003)(39860400002)(366004)(346002)(136003)(376002)(186003)(86362001)(8676002)(6506007)(53546011)(76116006)(66556008)(26005)(2906002)(66446008)(66476007)(66946007)(64756008)(83380400001)(9686003)(7696005)(91956017)(6916009)(55016002)(8936002)(478600001)(316002)(7416002)(33656002)(4326008)(71200400001)(5660300002)(52536014)(54906003)(142933001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: Ng9sE1vliRPbV9krRonmJiTNamSC1ursxm5NoMAhrltzUqcNqUHXtxj7C+rY+NPsSj6KvpjHGqMPdYnycSrJFz2PSH+ABHU01KwBhSikKIel4QpBhu5SYGXjAiDiP9SQIGbuti9oPl15tPLrS3305lfA7X3jf4P1n0v4PUWiRP08TM/XiPjlPq8DfcF0IZm5zPaGNFrMTVEh1esV1W2ntR0s5keGMyyArKC17soHXFBA9PBhbz7hAMIsWqoDN37kb0y2AvR0yNd0ZrFAiwIcVXJsPNAjmXpW9Y0I+1wgps5TkCldjQ0BEhGqzCQbiLWnqecGgo1XRQokJoGQ92Kfx34g0VT6EA652TQFQRmPvXvb4ZuN3sX0sxQjEIcdVOcuKgW12kb0tU8iqK/d9LQ7EqIidiENLk4Cw/SNc9ANg9VZqYj7jyvV3vnst5cK9nfUmGEaPIx8Hkyx5f+F2qTm/3znKBwael53GtmwZBtlKus=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: CY4PR04MB3751.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ef6c4885-49fe-4186-13bc-08d81ccb2350
X-MS-Exchange-CrossTenant-originalarrivaltime: 30 Jun 2020 07:56:46.7575
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: Oel1TyFBPffNjd/EW26jLc03XRmOBdxS7JoFdwWR9NHAj/qsr4NgDDUsfZmYD+aCwvys2pjVjOPJ/+38fqm/xw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY4PR0401MB3586
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 2020/06/30 16:53, Damien Le Moal wrote:=0A=
> On 2020/06/30 16:43, Kanchan Joshi wrote:=0A=
>> On Tue, Jun 30, 2020 at 12:37:07AM +0000, Damien Le Moal wrote:=0A=
>>> On 2020/06/30 3:35, Kanchan Joshi wrote:=0A=
>>>> On Fri, Jun 26, 2020 at 02:50:20AM +0000, Damien Le Moal wrote:=0A=
>>>>> On 2020/06/26 2:18, Kanchan Joshi wrote:=0A=
>>>>>> Introduce RWF_ZONE_APPEND flag to represent zone-append. User-space=
=0A=
>>>>>> sends this with write. Add IOCB_ZONE_APPEND which is set in=0A=
>>>>>> kiocb->ki_flags on receiving RWF_ZONE_APPEND.=0A=
>>>>>> Make direct IO submission path use IOCB_ZONE_APPEND to send bio with=
=0A=
>>>>>> append op. Direct IO completion returns zone-relative offset, in sec=
tor=0A=
>>>>>> unit, to upper layer using kiocb->ki_complete interface.=0A=
>>>>>> Report error if zone-append is requested on regular file or on sync=
=0A=
>>>>>> kiocb (i.e. one without ki_complete).=0A=
>>>>>>=0A=
>>>>>> Signed-off-by: Kanchan Joshi <joshi.k@samsung.com>=0A=
>>>>>> Signed-off-by: SelvaKumar S <selvakuma.s1@samsung.com>=0A=
>>>>>> Signed-off-by: Arnav Dawn <a.dawn@samsung.com>=0A=
>>>>>> Signed-off-by: Nitesh Shetty <nj.shetty@samsung.com>=0A=
>>>>>> Signed-off-by: Javier Gonzalez <javier.gonz@samsung.com>=0A=
>>>>>> ---=0A=
>>>>>>  fs/block_dev.c          | 28 ++++++++++++++++++++++++----=0A=
>>>>>>  include/linux/fs.h      |  9 +++++++++=0A=
>>>>>>  include/uapi/linux/fs.h |  5 ++++-=0A=
>>>>>>  3 files changed, 37 insertions(+), 5 deletions(-)=0A=
>>>>>>=0A=
>>>>>> diff --git a/fs/block_dev.c b/fs/block_dev.c=0A=
>>>>>> index 47860e5..5180268 100644=0A=
>>>>>> --- a/fs/block_dev.c=0A=
>>>>>> +++ b/fs/block_dev.c=0A=
>>>>>> @@ -185,6 +185,10 @@ static unsigned int dio_bio_write_op(struct kio=
cb *iocb)=0A=
>>>>>>  	/* avoid the need for a I/O completion work item */=0A=
>>>>>>  	if (iocb->ki_flags & IOCB_DSYNC)=0A=
>>>>>>  		op |=3D REQ_FUA;=0A=
>>>>>> +=0A=
>>>>>> +	if (iocb->ki_flags & IOCB_ZONE_APPEND)=0A=
>>>>>> +		op |=3D REQ_OP_ZONE_APPEND;=0A=
>>>>>=0A=
>>>>> This is wrong. REQ_OP_WRITE is already set in the declaration of "op"=
. How can=0A=
>>>>> this work ?=0A=
>>>> REQ_OP_ZONE_APPEND will override the REQ_WRITE op, while previously se=
t op=0A=
>>>> flags (REQ_FUA etc.) will be retained. But yes, this can be made to lo=
ok=0A=
>>>> cleaner.=0A=
>>>> V3 will include the other changes you pointed out. Thanks for the revi=
ew.=0A=
>>>>=0A=
>>>=0A=
>>> REQ_OP_WRITE and REQ_OP_ZONE_APPEND are different bits, so there is no=
=0A=
>>> "override". A well formed BIO bi_opf is one op+flags. Specifying multip=
le OP=0A=
>>> codes does not make sense.=0A=
>>=0A=
>> one op+flags behavior is retained here. OP is not about bits (op flags a=
re).=0A=
>> Had it been, REQ_OP_WRITE (value 1) can not be differentiated from=0A=
>> REQ_OP_ZONE_APPEND (value 13).=0A=
>> We do not do "bio_op(bio) & REQ_OP_WRITE", rather we look at the=0A=
>> absolute value "bio_op(bio) =3D=3D REQ_OP_WRITE".=0A=
> =0A=
> Sure, the ops are not bits like the flags, but (excluding the flags) doin=
g:=0A=
> =0A=
> op |=3D REQ_OP_ZONE_APPEND;=0A=
> =0A=
> will give you op =3D=3D (REQ_OP_WRITE | REQ_OP_ZONE_APPEND). That's not w=
hat you want...=0A=
=0A=
And yes, REQ_OP_WRITE | REQ_OP_ZONE_APPEND =3D=3D REQ_OP_ZONE_APPEND... But=
 still=0A=
not a reason for not setting the op correctly :)=0A=
=0A=
=0A=
=0A=
-- =0A=
Damien Le Moal=0A=
Western Digital Research=0A=
