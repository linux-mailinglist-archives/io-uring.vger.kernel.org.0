Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 79EEA200085
	for <lists+io-uring@lfdr.de>; Fri, 19 Jun 2020 05:08:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728855AbgFSDIi (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 18 Jun 2020 23:08:38 -0400
Received: from esa5.hgst.iphmx.com ([216.71.153.144]:33891 "EHLO
        esa5.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727065AbgFSDIg (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 18 Jun 2020 23:08:36 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1592536117; x=1624072117;
  h=from:to:cc:subject:date:message-id:references:
   content-transfer-encoding:mime-version;
  bh=5tx7MYVrmeAPaRRdrPyiPXXW3+cpGEblJM68gghZJak=;
  b=d+PbxyhFTb29vUEsu+Qq6nhzoWHxPROuUkjES4NR1eA6PR7J91S1pavh
   Yi0GCzPXG4LTXSAm5PpzjVnPQVWzrkovYv7x8tavKex0tSIhHZgmuWHtF
   l5jlCoeDzDs+XCRByquc3OUOPxWZ6c9pFNpUPdLqZml1MD2n83z33sFeJ
   GfX4mRRdOUzeE/kLiDhGPnwWsUns2ZHcSKhcpvMUGR1FKkEtpnFclq3Gr
   SlPK8lrjrPleCLxU+7MYQdsfeg3EXB60PBTNDEmtKCcCCCWWosa5FpVp2
   4eS+wpXbVqiu8VPlPtR6y4mBraGWYfTutY2SRPB9nrq8iUm4ur4EAorO7
   g==;
IronPort-SDR: fUThbbkSQNjXUFL+1mFzroCsQqv9aLCpWp+uu2M+x0DsMtq00ngcSlok3TDgDDj5BTDXO7ul5L
 INSfBypDg44qrwoWsJpv16//vQuhpPTirhKPlw1jbb1ucgrSDpIJdCEdnTX1xUXw+kHlF1XPSo
 kYJhAMb50aJM1KvD9SgJ8hA+7YGd92Xoke5CLDZUFKfywOm4OgJNmKgSF3vSwcKCrMpwp77IqV
 0jwDprdi5pYJ5gqYjnUEVCVyKeyS5+CY3U3ksF/OXPwhVb9B94DbUqXlEUdVhVOmjy75UTfz0Y
 S5w=
X-IronPort-AV: E=Sophos;i="5.75,253,1589212800"; 
   d="scan'208";a="140640724"
Received: from mail-co1nam04lp2053.outbound.protection.outlook.com (HELO NAM04-CO1-obe.outbound.protection.outlook.com) ([104.47.45.53])
  by ob1.hgst.iphmx.com with ESMTP; 19 Jun 2020 11:08:36 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=BGWf/mZtLL9a58iRhZYeFKtLKEt4eFbXNyUKT13Z2qXp/TbiyIADq3MuaDZy2R7+2fZXVNioQEX0yaXcrPeADSscMV86l8yleakLMiOiZMSHfxJSdL4948q6RwnqrYETLFwvV2yxnlrJ4NKFOw8fps/l+dOSAdHMvkl6U15iVMoVkpcqHc5nK2vz5Bqh4oMMiT4oxJTR/f9z65Z2e0zBgCIKRuskgC2lWcUap1lo6TvbqFuspOEUw4qeffpUwUqszv5QgMtWPt0p3v0iZW9zxI9xahTkjLbpUyhkWNEUbJowhr5i7CaeaIRVE752Zt5XLM9s0WSrVr3Vdl1dOFKAIw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=H3DO+cmFnzR8do8BgU9ESA7ESlaS6meuMU+qG/OTPU8=;
 b=QR7Trp08RkPJTq7uRTfEeBBHH7wBDnrDYbRQDOs+HxGVuXDDiYMJcLpkoSVu65ZsLg3CXkTwfLc1Bwcu3TxP/wYiMwDPRvyyLu0X2z6WcAVNiMSAulqMJ9VkemwEjdFXPgvxSygeFB6dkJPD0EIauIsoI6xZt9R3g6F83PiO1DBU4mdMFYaNRlz3lKSf7NFjXqRMClAtB2aWkogiA/O8T4f+12eJ7nSNUpTMAYxqLwTQ+I/xV9td2iwqmCvAhJddOJCiGgIaV0vWIjLcF/pei/r8CiQUYOQcAtNSGQ9imjA+vR2gcYaaMSyQMUMK/zjZKAYO037nYLH9mPhGlIDCSw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=H3DO+cmFnzR8do8BgU9ESA7ESlaS6meuMU+qG/OTPU8=;
 b=UfNglZeTxXX3ZVatv5ilOC3oxI5UjE9H12uhiOYypHYvX+9ekRruIrgOISO6GgdbxvDQjjOsIBCynAok45SioCOO/VXiVdHBAadaQQNBSo0ol59BabjfLRlMYxdddWX7AF4uuYOZMsgG0EX+J8dqAqQzLWIjTBAa+rwvnHM2A5Y=
Received: from CY4PR04MB3751.namprd04.prod.outlook.com (2603:10b6:903:ec::14)
 by CY4PR04MB1049.namprd04.prod.outlook.com (2603:10b6:910:56::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3088.24; Fri, 19 Jun
 2020 03:08:33 +0000
Received: from CY4PR04MB3751.namprd04.prod.outlook.com
 ([fe80::c593:f271:eebe:ac7]) by CY4PR04MB3751.namprd04.prod.outlook.com
 ([fe80::c593:f271:eebe:ac7%9]) with mapi id 15.20.3109.023; Fri, 19 Jun 2020
 03:08:33 +0000
From:   Damien Le Moal <Damien.LeMoal@wdc.com>
To:     Kanchan Joshi <joshi.k@samsung.com>,
        "hch@infradead.org" <hch@infradead.org>
CC:     "axboe@kernel.dk" <axboe@kernel.dk>,
        "viro@zeniv.linux.org.uk" <viro@zeniv.linux.org.uk>,
        "bcrl@kvack.org" <bcrl@kvack.org>,
        "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-aio@kvack.org" <linux-aio@kvack.org>,
        "io-uring@vger.kernel.org" <io-uring@vger.kernel.org>,
        "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>,
        "selvakuma.s1@samsung.com" <selvakuma.s1@samsung.com>,
        "nj.shetty@samsung.com" <nj.shetty@samsung.com>,
        "javier.gonz@samsung.com" <javier.gonz@samsung.com>
Subject: Re: [PATCH 0/3] zone-append support in aio and io-uring
Thread-Topic: [PATCH 0/3] zone-append support in aio and io-uring
Thread-Index: AQHWRMyErNBfEVsLrU+xBQX5pX+rOw==
Date:   Fri, 19 Jun 2020 03:08:33 +0000
Message-ID: <CY4PR04MB37515E4FCD1EAA5880E2E1A2E7980@CY4PR04MB3751.namprd04.prod.outlook.com>
References: <CGME20200617172653epcas5p488de50090415eb802e62acc0e23d8812@epcas5p4.samsung.com>
 <1592414619-5646-1-git-send-email-joshi.k@samsung.com>
 <20200618065634.GB24943@infradead.org> <20200618175258.GA4141152@test-zns>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: samsung.com; dkim=none (message not signed)
 header.d=none;samsung.com; dmarc=none action=none header.from=wdc.com;
x-originating-ip: [129.253.182.57]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 7ba96318-441b-4b32-b60a-08d813fe0d33
x-ms-traffictypediagnostic: CY4PR04MB1049:
x-ld-processed: b61c8803-16f3-4c35-9b17-6f65f441df86,ExtAddr
x-microsoft-antispam-prvs: <CY4PR04MB1049B0A63ADD6BE636D81212E7980@CY4PR04MB1049.namprd04.prod.outlook.com>
wdcipoutbound: EOP-TRUE
x-ms-oob-tlc-oobclassifiers: OLM:10000;
x-forefront-prvs: 0439571D1D
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 7fr/BocJ4xJiQqMJOrO7aTDqd9cgzZXJ57u807OGrV3taZTVyM+a/Qar+t9VDy7D/55EH/JLRNkKoIyszCH8sT2Ut4FsVC2lDLCT+hSXsvpZxGay+Gs7uWuJmT6ypQKKhW5RoWQGK52BXuUVOINkI3HBAi0T/XpZgB4ucwL1Bg5QG2kQwWZpgQGwOJmyc0X+6waqJMOdaqtbPPwuy98Ft0uaMqJ8UexCjjErybPuCnGbbDsKw3RLO945YWAUwUjOKzDwd6NkRIkxw+T0WebDXKR/2GvRwtnj1SqcFoU0fJL0cYGVUn6oV1ki69e2h3Z9G/YR947E4CLPZHFkPO1WqA==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY4PR04MB3751.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(136003)(366004)(39860400002)(346002)(376002)(396003)(76116006)(5660300002)(6506007)(66556008)(52536014)(66476007)(186003)(66946007)(91956017)(7416002)(64756008)(71200400001)(53546011)(66446008)(86362001)(110136005)(2906002)(9686003)(55016002)(478600001)(4326008)(8676002)(83380400001)(316002)(26005)(8936002)(54906003)(7696005)(33656002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: 2bNb0vOZPx/90Fkgnj9C+ZEi97Qauy+tPrU3d9Ug2OM+5SuAyZ5xtKOuU7oCe5WuWttXJ9qYXbYr6iOX5CzMBLhUMuwcsC4UKvVazrnZnWEVXAW9pP7uUg4X4LQffLi+w2gdTKOcqCkto6HOu6Tr29MEfIQc2xJMqurzMVCCLslq8qvE4VoqP6xL+57pSqM7iPvrl4NsnofVsN9gSVMmYxQiDCY8TtdSlKCK37zWWQzfdqIyj40oBj9Ouj8zwAcdKIdvCdsuTZiNHATT7Fdr1/vR8qv4US63ZvD5hvj1MfdygEX9kFHgPXFmA9u+2Zg53Hty6HYFo+5XsVp0CNYUvoRlqnfoQnWiGGWVilQ4GeH/Lwtk7+EQRDsmrzxX0weYIF5EbsAraPczlsf7VlsfyD1VU7fuzv1TvIhRe3coM0WDC/YEpKLBWEA3rn5xaSq3ZEkubX1EcLrONMUZY4QIFhbEL3aOZtIzZvyaj5QgaZbruWAdWiFcWC/vdbULgbiS
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7ba96318-441b-4b32-b60a-08d813fe0d33
X-MS-Exchange-CrossTenant-originalarrivaltime: 19 Jun 2020 03:08:33.5909
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: MY0lI43d7+EtG7UXHNOU9tUs9YdWL/HLUBwrX124jxNbFS3io0MJvXnVtVKIkFzgIBgAJMDYWAc5qfWXMUhxvw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY4PR04MB1049
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 2020/06/19 2:55, Kanchan Joshi wrote:=0A=
> On Wed, Jun 17, 2020 at 11:56:34PM -0700, Christoph Hellwig wrote:=0A=
>> On Wed, Jun 17, 2020 at 10:53:36PM +0530, Kanchan Joshi wrote:=0A=
>>> This patchset enables issuing zone-append using aio and io-uring direct=
-io interface.=0A=
>>>=0A=
>>> For aio, this introduces opcode IOCB_CMD_ZONE_APPEND. Application uses =
start LBA=0A=
>>> of the zone to issue append. On completion 'res2' field is used to retu=
rn=0A=
>>> zone-relative offset.=0A=
>>>=0A=
>>> For io-uring, this introduces three opcodes: IORING_OP_ZONE_APPEND/APPE=
NDV/APPENDV_FIXED.=0A=
>>> Since io_uring does not have aio-like res2, cqe->flags are repurposed t=
o return zone-relative offset=0A=
>>=0A=
>> And what exactly are the semantics supposed to be?  Remember the=0A=
>> unix file abstractions does not know about zones at all.=0A=
>>=0A=
>> I really don't think squeezing low-level not quite block storage=0A=
>> protocol details into the Linux read/write path is a good idea.=0A=
> =0A=
> I was thinking of raw block-access to zone device rather than pristine fi=
le=0A=
> abstraction. And in that context, semantics, at this point, are unchanged=
=0A=
> (i.e. same as direct writes) while flexibility of async-interface gets=0A=
> added.=0A=
=0A=
The aio->aio_offset use by the user and kernel differs for regular writes a=
nd=0A=
zone append writes. This is a significant enough change to say that semanti=
c=0A=
changed. Yes both cases are direct IOs, but specification of the write loca=
tion=0A=
by the user and where the data actually lands on disk are different.=0A=
=0A=
There are a lot of subtle things that can happen that makes mapping of zone=
=0A=
append operations to POSIX semantic difficult. E.g. for a regular file, usi=
ng=0A=
zone append for any write issued to a file open with O_APPEND maps well to =
POSIX=0A=
only for blocking writes. For asynchronous writes, that is not true anymore=
=0A=
since the order of data defined by the automatic append after the previous =
async=0A=
write breaks: data can land anywhere in the zone regardless of the offset=
=0A=
specified on submission.=0A=
=0A=
> Synchronous-writes on single-zone sound fine, but synchronous-appends on=
=0A=
> single-zone do not sound that fine.=0A=
=0A=
Why not ? This is a perfectly valid use case that actually does not have an=
y=0A=
semantic problem. It indeed may not be the  most effective method to get hi=
gh=0A=
performance but saying that it is "not fine" is not correct in my opinion.=
=0A=
=0A=
> =0A=
>> What could be a useful addition is a way for O_APPEND/RWF_APPEND writes=
=0A=
>> to report where they actually wrote, as that comes close to Zone Append=
=0A=
>> while still making sense at our usual abstraction level for file I/O.=0A=
> =0A=
> Thanks for suggesting this. O and RWF_APPEND may not go well with block=
=0A=
> access as end-of-file will be picked from dev inode. But perhaps a new=0A=
> flag like RWF_ZONE_APPEND can help to transform writes (aio or uring)=0A=
> into append without introducing new opcodes.=0A=
=0A=
Yes, RWF_ZONE_APPEND may be better if the semantic of RWF_APPEND cannot be=
=0A=
cleanly reused. But as Christoph said, RWF_ZONE_APPEND semantic need to be=
=0A=
clarified so that all reviewer can check the code against the intended beha=
vior,=0A=
and comment on that intended behavior too.=0A=
=0A=
> And, I think, this can fit fine on file-abstraction of ZoneFS as well.=0A=
=0A=
May be. Depends on what semantic you are after for user zone append interfa=
ce.=0A=
Ideally, we should have at least the same for raw block device and zonefs. =
But=0A=
zonefs may be able to do a better job thanks to its real regular file=0A=
abstraction of zones. As Christoph said, we started looking into it but lac=
ked=0A=
time to complete this work. This is still on-going.=0A=
=0A=
-- =0A=
Damien Le Moal=0A=
Western Digital Research=0A=
