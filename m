Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 11D4E1FEE09
	for <lists+io-uring@lfdr.de>; Thu, 18 Jun 2020 10:47:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728504AbgFRIrg (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 18 Jun 2020 04:47:36 -0400
Received: from esa5.hgst.iphmx.com ([216.71.153.144]:44835 "EHLO
        esa5.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728452AbgFRIre (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 18 Jun 2020 04:47:34 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1592470054; x=1624006054;
  h=from:to:cc:subject:date:message-id:references:
   content-transfer-encoding:mime-version;
  bh=f5afOsGFUTPtr1/A8OhNuSbC4Tnbf5zKqQ0xrbQUaJE=;
  b=MvROxAMj6sGUlNTOckmWl28KzF5tZz0xdD4K/t6bAOC8M4zWkmr1DJsx
   tYCUdud1YeANWKo2ZabD2DTMrJqiqiLdKCUUWdzmzmqDp+m8qxk8sF/O6
   uP5/QPp78QRyNuLzkBKcM+djjY4WKOLoq0hpbcqWFNmq2Aio+LXhp9WrY
   LFlR/ixiolGQRcwiRxMG71eKT0dWgBB2dwGs8bZoREMxkrBiVYC4DzUl1
   DhKHSzNCP+bBLshlDMb3250z2OOZRrLMM4WH1CycQpOBEYOXEYD2TqQHl
   +mirpgfxwIEc7SWGB+dzCh0krbRjB76MCcGyolFuMrUxAQOBGBlu8bCMB
   Q==;
IronPort-SDR: xVGfzDaeXy9LMyXE6Mf78oJ+eeELgzQsN2Gr8HZk0zC8Za45bWJSbbVFFg3VvV5Oa67qdlvOGL
 mtLKPL7PcxeC+H8k/Wyae159j2BlzKKP39V7IWzpmw1umJ2TCSKGl2WrECXxGe1v0jHEJD+l92
 dIoGOrRW3s+/SwBz9V7+qhXJcWA0d8i+9wFVl+A25UNmo25b0PMOKKyuEsmHJlsK0gwNNeS/Li
 xg6cFSgSWmZDArZ15LNk3eBX2CIhVVuiRTgtzL3LOKeWJPVcVoWnOQBrxBrY3dbJTyiX+WPi8U
 kUs=
X-IronPort-AV: E=Sophos;i="5.73,526,1583164800"; 
   d="scan'208";a="140560121"
Received: from mail-bl2nam02lp2059.outbound.protection.outlook.com (HELO NAM02-BL2-obe.outbound.protection.outlook.com) ([104.47.38.59])
  by ob1.hgst.iphmx.com with ESMTP; 18 Jun 2020 16:47:31 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=FabYLeW4VzHIkJX4h+Bg3RXBroY6IVLBwr5TNtIi0vRABvnkNnfsZO64NVIZVH9/LqWYbd89xqzkKkybydtncf3WczOIfsVs2RyC/RK/LLp8HyggZdHJV3SGRaqo2Ii3GzVlf4+g9PmpwZmY5UugPgzA5/W7duYj/Ob1kSEa445P6XxFkNyU5HIDTFOY6ZK3SU+3vhlUjDPjOFlpDXhXEn6oydJIFYQoE5xEoCk3J5JqTk3gwTMcGHOi6oc9k/InoPrL4SLTlfXMC2GuzO961GOhbf3aWL7h8txV/2+kISz0X6WE63sywbBL5ElLjyutPLtpplvLIAQqnI3LimLN7Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ZKCMJ1xdIXNECj82XRR8no1QmqRflaaza79jx70QrsU=;
 b=V2xXfKUMhfFrnUJWZktnWY6SDe9wgMApBw/XKPj8WJ+YK2e0T31FMDQhid7FZevM4E1ly76QdVSqvkTFFbbghnC3QvoNLqCik4+HPeYiWorJ1p79Wp7ds8JFJSznlS2DFavqMYSn7p/4noEgx34ckMTNeqMxv2p0S9gE8YMt25jdqnPjYXcFlxJjPZO4ZSkDnRpts2r09gmPY4enTQ88lpcQ+JG3bXegJFPC4HHUqFv4tcQlpeksuyWGdA49JzxhqkKdhWUGbLMSpguj9rrmZ+CgiM6PSJZUKzUpgox6WKc5x27uDMU5/fZNKRTFJNCd0u2JCbgy6klnGBKmsfsefQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ZKCMJ1xdIXNECj82XRR8no1QmqRflaaza79jx70QrsU=;
 b=ZYCxTUylhfJy0Yv6N9x1eaJlPiQBHiEhbyth3BQewo4c9FPtO9mqbdBKD7fxgqEohafTNGAiSDW8PiKbwAjrnKvj4j1vqeib+2ak9KVFfehD1jakKaWrcCNxGaTkFwxBaXjfo5rKL0dEAlsk//5EPhNoQhnd+9HzRF6oAbK8nWw=
Received: from CY4PR04MB3751.namprd04.prod.outlook.com (2603:10b6:903:ec::14)
 by CY4PR0401MB3586.namprd04.prod.outlook.com (2603:10b6:910:8e::29) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3088.21; Thu, 18 Jun
 2020 08:47:29 +0000
Received: from CY4PR04MB3751.namprd04.prod.outlook.com
 ([fe80::c593:f271:eebe:ac7]) by CY4PR04MB3751.namprd04.prod.outlook.com
 ([fe80::c593:f271:eebe:ac7%9]) with mapi id 15.20.3088.028; Thu, 18 Jun 2020
 08:47:29 +0000
From:   Damien Le Moal <Damien.LeMoal@wdc.com>
To:     "javier.gonz@samsung.com" <javier@javigon.com>
CC:     Kanchan Joshi <joshi.k@samsung.com>,
        "axboe@kernel.dk" <axboe@kernel.dk>,
        "viro@zeniv.linux.org.uk" <viro@zeniv.linux.org.uk>,
        "bcrl@kvack.org" <bcrl@kvack.org>,
        "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-aio@kvack.org" <linux-aio@kvack.org>,
        "io-uring@vger.kernel.org" <io-uring@vger.kernel.org>,
        "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>,
        "selvakuma.s1@samsung.com" <selvakuma.s1@samsung.com>,
        "nj.shetty@samsung.com" <nj.shetty@samsung.com>
Subject: Re: [PATCH 3/3] io_uring: add support for zone-append
Thread-Topic: [PATCH 3/3] io_uring: add support for zone-append
Thread-Index: AQHWRMyUe8chR0VkUU2K4ON9AWdJKQ==
Date:   Thu, 18 Jun 2020 08:47:29 +0000
Message-ID: <CY4PR04MB3751D5D6AFB0DA7B8A2DFF61E79B0@CY4PR04MB3751.namprd04.prod.outlook.com>
References: <1592414619-5646-1-git-send-email-joshi.k@samsung.com>
 <CGME20200617172713epcas5p352f2907a12bd4ee3c97be1c7d8e1569e@epcas5p3.samsung.com>
 <1592414619-5646-4-git-send-email-joshi.k@samsung.com>
 <CY4PR04MB37510E916B6F243D189B4EB0E79B0@CY4PR04MB3751.namprd04.prod.outlook.com>
 <20200618083529.ciifu4chr4vrv2j5@mpHalley.local>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: javigon.com; dkim=none (message not signed)
 header.d=none;javigon.com; dmarc=none action=none header.from=wdc.com;
x-originating-ip: [199.255.47.7]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 27803948-8030-42c8-b0c2-08d813643bb1
x-ms-traffictypediagnostic: CY4PR0401MB3586:
x-microsoft-antispam-prvs: <CY4PR0401MB3586B492C7D217E2923E7D51E79B0@CY4PR0401MB3586.namprd04.prod.outlook.com>
wdcipoutbound: EOP-TRUE
x-ms-oob-tlc-oobclassifiers: OLM:9508;
x-forefront-prvs: 0438F90F17
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: O5b3rCJXz6eTl/NyQrX3299lEL9SGo9YDctntDKFgfraHDpzEEyysaMnFeXal4ZQ2WWUeRhm1tEuxG8cteAcHyWUMvuwVRydDa+/ww2F8vWOchISfzj9o9L1T2YacuWzlamG2zz0MnkswtsWXbp+weh8WM2RSk9yvbxb7vI3DlYCFGCj4k/fHMOxfSwaM/bA5vfxJmk8jrpXearlzbJHF+AfJMQJJrSG1RtYzJH1v2lI61M8pG84gAWTtx5ymx5tkiyRAUvOtRTSiOSEzqvq/zyE7EQkDoeNNtT1R7o3aNWjoMOToZMiCFeGCJtEufC4cOT/sWAAUREww7IkOcUSgLrnCg1MXbMeACfzl09jbD2jx6YxISkXvBcrQ6Y5mo1/
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY4PR04MB3751.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(39860400002)(376002)(136003)(346002)(366004)(396003)(7416002)(8676002)(52536014)(478600001)(6916009)(8936002)(316002)(54906003)(26005)(71200400001)(4326008)(6506007)(53546011)(55016002)(66946007)(66446008)(76116006)(66476007)(91956017)(5660300002)(64756008)(2906002)(83380400001)(33656002)(186003)(86362001)(7696005)(66556008)(9686003)(491001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: x4EekzSmgj/BffgSVlMpfg8s+nSocyUwNJkYAIvDKyE4TT7IpD4N4MtgMCSzgZM2q4pD65xuI6w3JV5ySId2uxbHmoz3codPYxYzGYTMl5sN81zuO04+R3DiVs8wU55UBqwJjofCO7JgB4RV5AEqEN5u+Uu1I4bceBY28iiqxI3GbV30YzhI/kmQ5cPTZQdiJS1p9LYgsLR2kBlF45JvafLVCEz9gnXDu7DwAzooNX70a03cQAFJi1LfjGt1Yevk4WN/S+nGmdBgYeDAqnayFpN8UILl7RuIw0nTfOE0hXDgoG1wuhkrqFV1AZJbhIFvTmtTaLMqTPEG6FGfEr+x5wlxa+qgHG76kL8I6Osb/KPBJOs3UcTESW8qLwe/8W3ecOUNLfWJcaclJWkcz1bDqLQM+CK1mi1rCStQ4OfOlFfM5panaJh+83PumdtzgTvGB8lq9d6mZe3jB2TRpzIs/odh90NJ9zOR6MxuAjYJShw=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 27803948-8030-42c8-b0c2-08d813643bb1
X-MS-Exchange-CrossTenant-originalarrivaltime: 18 Jun 2020 08:47:29.0624
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: C2BY3/DQpKiWKaE9kPDe/OL0+rAKDh74nHPV9nkJZVPjKjXF632yF9W15/ihOecILckJ77q7LroeZjgafb07jQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY4PR0401MB3586
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 2020/06/18 17:35, javier.gonz@samsung.com wrote:=0A=
> On 18.06.2020 07:39, Damien Le Moal wrote:=0A=
>> On 2020/06/18 2:27, Kanchan Joshi wrote:=0A=
>>> From: Selvakumar S <selvakuma.s1@samsung.com>=0A=
>>>=0A=
>>> Introduce three new opcodes for zone-append -=0A=
>>>=0A=
>>>    IORING_OP_ZONE_APPEND     : non-vectord, similiar to IORING_OP_WRITE=
=0A=
>>>    IORING_OP_ZONE_APPENDV    : vectored, similar to IORING_OP_WRITEV=0A=
>>>    IORING_OP_ZONE_APPEND_FIXED : append using fixed-buffers=0A=
>>>=0A=
>>> Repurpose cqe->flags to return zone-relative offset.=0A=
>>>=0A=
>>> Signed-off-by: SelvaKumar S <selvakuma.s1@samsung.com>=0A=
>>> Signed-off-by: Kanchan Joshi <joshi.k@samsung.com>=0A=
>>> Signed-off-by: Nitesh Shetty <nj.shetty@samsung.com>=0A=
>>> Signed-off-by: Javier Gonzalez <javier.gonz@samsung.com>=0A=
>>> ---=0A=
>>>  fs/io_uring.c                 | 72 +++++++++++++++++++++++++++++++++++=
++++++--=0A=
>>>  include/uapi/linux/io_uring.h |  8 ++++-=0A=
>>>  2 files changed, 77 insertions(+), 3 deletions(-)=0A=
>>>=0A=
>>> diff --git a/fs/io_uring.c b/fs/io_uring.c=0A=
>>> index 155f3d8..c14c873 100644=0A=
>>> --- a/fs/io_uring.c=0A=
>>> +++ b/fs/io_uring.c=0A=
>>> @@ -649,6 +649,10 @@ struct io_kiocb {=0A=
>>>  	unsigned long		fsize;=0A=
>>>  	u64			user_data;=0A=
>>>  	u32			result;=0A=
>>> +#ifdef CONFIG_BLK_DEV_ZONED=0A=
>>> +	/* zone-relative offset for append, in bytes */=0A=
>>> +	u32			append_offset;=0A=
>>=0A=
>> this can overflow. u64 is needed.=0A=
> =0A=
> We chose to do it this way to start with because struct io_uring_cqe=0A=
> only has space for u32 when we reuse the flags.=0A=
> =0A=
> We can of course create a new cqe structure, but that will come with=0A=
> larger changes to io_uring for supporting append.=0A=
> =0A=
> Do you believe this is a better approach?=0A=
=0A=
The problem is that zone size are 32 bits in the kernel, as a number of sec=
tors.=0A=
So any device that has a zone size smaller or equal to 2^31 512B sectors ca=
n be=0A=
accepted. Using a zone relative offset in bytes for returning zone append r=
esult=0A=
is OK-ish, but to match the kernel supported range of possible zone size, y=
ou=0A=
need 31+9 bits... 32 does not cut it.=0A=
=0A=
Since you need a 64-bit sized result, I would also prefer that you drop the=
 zone=0A=
relative offset as a result and return the absolute offset instead. That ma=
kes=0A=
life easier for the applications since the zone append requests also must u=
se=0A=
absolute offsets for zone start. An absolute offset as a result becomes=0A=
consistent with that and all other read/write system calls that all use abs=
olute=0A=
offsets (seek() is the only one that I know of that can use a relative offs=
et,=0A=
but that is not an IO system call).=0A=
=0A=
=0A=
> =0A=
> Javier=0A=
> =0A=
=0A=
=0A=
-- =0A=
Damien Le Moal=0A=
Western Digital Research=0A=
