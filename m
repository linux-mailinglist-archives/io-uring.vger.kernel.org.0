Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 16A492340F3
	for <lists+io-uring@lfdr.de>; Fri, 31 Jul 2020 10:14:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731834AbgGaIO1 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 31 Jul 2020 04:14:27 -0400
Received: from esa4.hgst.iphmx.com ([216.71.154.42]:49520 "EHLO
        esa4.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731522AbgGaIO0 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 31 Jul 2020 04:14:26 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1596183265; x=1627719265;
  h=from:to:cc:subject:date:message-id:references:
   content-transfer-encoding:mime-version;
  bh=w8N9/fNDKoEUsRyUaywAQOVfNdW7Zpoh1TPo6fZflCU=;
  b=Jkw6cGLC2qLsgrfHbfojS1Z6K5tKWWr6JDgY//ghErK8Gz3+984GBNTk
   2UAAP/2FPJLZ/55g2n5o3TZHohG5HwYObo8aiQwNhYa5p79ZnLE1Pqvz4
   JNJ5yo9+57bKdbp1nKg+5tdSzMZDDgrXS54ni0vBcNXYctdcoQy/uNsww
   HkyZHz94BkM3sRIq00xbkL+p3JPfwYk99Dtvb7/qgEx1fopAs4zaIbccU
   1B3fAs5hO1Xzg5AEBrrmSRCAGEcEnRwBirB/1ZQEsda+tcvAtfztxwtis
   uAna7IqkAm18ZUrTF5e3az2c0YrpXhTxU6Kysoo+y2CURziBDGsz6V4Ok
   g==;
IronPort-SDR: uBJpJVK5qupXcnq2qec+No96Bn1Su7vZUKrObZeMz9TxmZEoxQs3MrVcZADYxMrwrzropmqvR4
 0siwJAJiFCU24eDELkpYEZdKiFC3kj+Yn4eDabXVjNBQPQGiCq+p/WyOaAaNujCVquG/h+Sfb6
 QUaulFBO0mIe3SbodRF7p/JDr72uz3u7jguWcPyfOq7gGmeBa9oWaRRurllOdneThZBjR2GiLA
 O3cWiyGR+C2P3GxiC3qtx8RqnXVd1Htl/Du6g7vNYZv4WZjwhfOiXbgiWGSVQk84Z5wwfaEV1I
 zB0=
X-IronPort-AV: E=Sophos;i="5.75,417,1589212800"; 
   d="scan'208";a="143823494"
Received: from mail-dm6nam11lp2171.outbound.protection.outlook.com (HELO NAM11-DM6-obe.outbound.protection.outlook.com) ([104.47.57.171])
  by ob1.hgst.iphmx.com with ESMTP; 31 Jul 2020 16:14:23 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Fp3KlrD0YfcZA9RcdLG0l60N2c6WeYyAeu/Ue21xan1ZW1tszvHvpuiyDhGCtunLs0eEftsVRk/VBXQfEPAsmtrhpQOshnWK5Tzbpa7qzbYrtqeZAWP5DTyFfm/WuMMNvvLUQgcW82JAd7qMHjSZsbpl24mckwRZVKbGxCje3y1CPyF6EB9BajLrw0QIr5W6EnkJ8FGc6urYejkFq60n0qFvjDkL0T7ulvn4wlOn+LiT+cJtQzknlnu04N6yx1AZi6LxzgowDof2nWJB+7Tb4Cy048aSPLtKbm+QUo5Z9IZq7LZDT/aJVamRRBzqwLYjK9hKSCBUBZoa0JTm1c8KUg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=aGJ38TF5L8LfGiFWM+86oM00tsRNUhHIwOuAYpXyoEI=;
 b=DwRfpCsfhI87yi4IcIfdtdB1vvUK/76hBHjg778Hm6XtswzUDwiolGNmXWh/RtA7m6XvSMbzC2hNCO6fA8I9WtI2P1ssfrM5h0PNEfQZmXZGbaCwxtfd1q8awJnpBfCLdTbrKtfwrBw1tXRUW+PslJPYSVkHVeoxKxxltEMwLa4+Tic1A5nXENDdHPEhr72vfe4WbbFKosBVSrWksoCge9NyFTKEnHriwsJt66ZQW4oVySGdZTFxG7Mm3hMXPmsgJ57e67hTwYBjmCbofGuwk69FbPzfS6533nZ9ccBgkTU045hMMOTlkhxG0nzvuuStQP/Gu6driwSgGpSG91q8OQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=aGJ38TF5L8LfGiFWM+86oM00tsRNUhHIwOuAYpXyoEI=;
 b=TmpI7OVMM3pE8/B0Njtx8iyOw74KW8SXkJPt+ddpFl4L3FG3lHH3LHdIqZ5g2SAb7QxCGUCYM3G4W4/pJlWF/OYcjZyeUfAxn+6GAOLC5LAF5DJJvsX+25zbCNpaEv4G3L8Swc1bybC9ivBoE/VYEaIB5UlLmpRO1qu0By3nZgE=
Received: from MWHPR04MB3758.namprd04.prod.outlook.com (2603:10b6:300:fb::8)
 by MWHPR04MB0879.namprd04.prod.outlook.com (2603:10b6:301:42::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3239.17; Fri, 31 Jul
 2020 08:14:22 +0000
Received: from MWHPR04MB3758.namprd04.prod.outlook.com
 ([fe80::718a:d477:a4f1:c137]) by MWHPR04MB3758.namprd04.prod.outlook.com
 ([fe80::718a:d477:a4f1:c137%7]) with mapi id 15.20.3239.017; Fri, 31 Jul 2020
 08:14:22 +0000
From:   Damien Le Moal <Damien.LeMoal@wdc.com>
To:     Kanchan Joshi <joshiiitr@gmail.com>
CC:     "hch@infradead.org" <hch@infradead.org>,
        Jens Axboe <axboe@kernel.dk>,
        Pavel Begunkov <asml.silence@gmail.com>,
        Kanchan Joshi <joshi.k@samsung.com>,
        "viro@zeniv.linux.org.uk" <viro@zeniv.linux.org.uk>,
        "bcrl@kvack.org" <bcrl@kvack.org>,
        Matthew Wilcox <willy@infradead.org>,
        "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-aio@kvack.org" <linux-aio@kvack.org>,
        "io-uring@vger.kernel.org" <io-uring@vger.kernel.org>,
        "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>,
        "linux-api@vger.kernel.org" <linux-api@vger.kernel.org>,
        SelvaKumar S <selvakuma.s1@samsung.com>,
        Nitesh Shetty <nj.shetty@samsung.com>,
        Javier Gonzalez <javier.gonz@samsung.com>,
        Johannes Thumshirn <Johannes.Thumshirn@wdc.com>
Subject: Re: [PATCH v4 6/6] io_uring: add support for zone-append
Thread-Topic: [PATCH v4 6/6] io_uring: add support for zone-append
Thread-Index: AQHWYdbcc0q15qREKECGO7brHi6zEg==
Date:   Fri, 31 Jul 2020 08:14:22 +0000
Message-ID: <MWHPR04MB375863C20C1EF2CB27E62703E74E0@MWHPR04MB3758.namprd04.prod.outlook.com>
References: <b0b7159d-ed10-08ad-b6c7-b85d45f60d16@kernel.dk>
 <e871eef2-8a93-fdbc-b762-2923526a2db4@gmail.com>
 <80d27717-080a-1ced-50d5-a3a06cf06cd3@kernel.dk>
 <da4baa8c-76b0-7255-365c-d8b58e322fd0@gmail.com>
 <65a7e9a6-aede-31ce-705c-b7f94f079112@kernel.dk>
 <d4f9a5d3-1df2-1060-94fa-f77441a89299@gmail.com>
 <CA+1E3rJ3SoLU9aYcugAQgJnSPnJtcCwjZdMREXS3FTmXgy3yow@mail.gmail.com>
 <f030a338-cd52-2e83-e1da-bdbca910d49e@kernel.dk>
 <CA+1E3rKxZk2CatTuPcQq5d14vXL9_9LVb2_+AfR2m9xn2WTZdg@mail.gmail.com>
 <MWHPR04MB3758DC08EA17780E498E9EC0E74E0@MWHPR04MB3758.namprd04.prod.outlook.com>
 <20200731064526.GA25674@infradead.org>
 <MWHPR04MB37581344328A42EA7F5ED13EE74E0@MWHPR04MB3758.namprd04.prod.outlook.com>
 <CA+1E3rLM4G4SwzD6RWsK6Ssp7NmhiPedZDjrqN3kORQr9fxCtw@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: gmail.com; dkim=none (message not signed)
 header.d=none;gmail.com; dmarc=none action=none header.from=wdc.com;
x-originating-ip: [129.253.182.57]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: f78441f6-822e-4509-3638-08d83529bb26
x-ms-traffictypediagnostic: MWHPR04MB0879:
x-ld-processed: b61c8803-16f3-4c35-9b17-6f65f441df86,ExtAddr
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <MWHPR04MB0879F1DF3BA69A681BC9C4D4E74E0@MWHPR04MB0879.namprd04.prod.outlook.com>
wdcipoutbound: EOP-TRUE
x-ms-oob-tlc-oobclassifiers: OLM:10000;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: fng2fgnS3hAEue6bztyLPK7OvkR+53v2RKMsCSMoMiDDATVVffCuqwfPzXryUGeg1k66bvsfBuCAwjKZsGd/Yt37uePWneM/dP68tb3IaTDwmKL+HbXsmGzdP9mfadDnRttAcXXQALQYhHQNluANKzaS/LDVIaAD1uEBY30hPeVNKtDbZlJo84mJ0pOJe9NNDT/C+vUFSiAmnU51qSanD5lZKhZ0KolbS9bxX6OOWMayklcwDo8vmBO6TXxZDezUHPRXM2TVYLkuGWNBD/Vl1GwiMkGnHC0lahCyAUz4GHELYrXLPM32a+rWtVZpjyx3026nUCBJipfAJMA8a5pokA==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR04MB3758.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(39860400002)(366004)(376002)(396003)(346002)(136003)(316002)(5660300002)(9686003)(86362001)(55016002)(6916009)(6506007)(8936002)(54906003)(33656002)(83380400001)(53546011)(71200400001)(4326008)(478600001)(7696005)(186003)(64756008)(66446008)(66476007)(52536014)(7416002)(66556008)(66946007)(76116006)(26005)(91956017)(8676002)(2906002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: C8lmsBnUcnBdthwdE0qV3xDD+WNmqfNKhw/d+7JfpGpVG9FGqLAuVmgHU7cSxgteSZhif3mETqDCR/WrlNCjF80tXtCIDFR1N9HUFy741t3bMnX0KIDpyIu1NyfUzPgQxpPoknA2h9Iy842f7VMv43x/LxNqRUN3QpqYoRb/hRABeyOeDPvBJoNOpMg6wCvrR5c2VyXFrK+a1v2Aa9jhMtqH5npqkex6+2BuZVRM9+SBQraj1740EvWWW48oIc7QbyrHjPKEX3TEJMJsvyUJ2HPQfphTJ3fGAme5g3tVjX5FckRt+4BbMOaXmVA1LbGuVZaM2JcL/VuMUE/6v9ttjKGhkGu8+26441fI1URDwrvcIGT19uk4SXaH2yw9OZ9SMMjvbvHc7+ILaoN/kEwtE5+8yOeL+YDEm50iFCoWnfXpqkioKFcV6w2x1sjdRfGGDAMSKxWdx9As2/ZPwa6ZeaFbVSgoKEbjBxXOfoy3CWpcVaO7/hAc2tXslgRSBU/JVaMLJ13KIrMdpnO+ubWxShaHJy6ZbKy8QRm/qrWSxlRBgBHl8sPWpIOnevIYiHJYjSdk/t8E56FtcOktOHeoq3gUZl0x3tECaVe/6y0NjA58HT9JLpx2pr0XAoDfzo6U4zpnFQczva1BzMhOoffWZw==
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MWHPR04MB3758.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f78441f6-822e-4509-3638-08d83529bb26
X-MS-Exchange-CrossTenant-originalarrivaltime: 31 Jul 2020 08:14:22.1030
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: dqyMjdRWZCRxLPLB3QQc8kWxOH+glnqDW2ky0shuMsW2RyaKrFx77R6rPAdOI9ICqO/a9hb+oY0kLpDPfomo3w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR04MB0879
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 2020/07/31 16:59, Kanchan Joshi wrote:=0A=
> On Fri, Jul 31, 2020 at 12:29 PM Damien Le Moal <Damien.LeMoal@wdc.com> w=
rote:=0A=
>>=0A=
>> On 2020/07/31 15:45, hch@infradead.org wrote:=0A=
>>> On Fri, Jul 31, 2020 at 06:42:10AM +0000, Damien Le Moal wrote:=0A=
>>>>> - We may not be able to use RWF_APPEND, and need exposing a new=0A=
>>>>> type/flag (RWF_INDIRECT_OFFSET etc.) user-space. Not sure if this=0A=
>>>>> sounds outrageous, but is it OK to have uring-only flag which can be=
=0A=
>>>>> combined with RWF_APPEND?=0A=
>>>>=0A=
>>>> Why ? Where is the problem ? O_APPEND/RWF_APPEND is currently meaningl=
ess for=0A=
>>>> raw block device accesses. We could certainly define a meaning for the=
se in the=0A=
>>>> context of zoned block devices.=0A=
>>>=0A=
>>> We can't just add a meaning for O_APPEND on block devices now,=0A=
>>> as it was previously silently ignored.  I also really don't think any=
=0A=
>>> of these semantics even fit the block device to start with.  If you=0A=
>>> want to work on raw zones use zonefs, that's what is exists for.=0A=
>>=0A=
>> Which is fine with me. Just trying to say that I think this is exactly t=
he=0A=
>> discussion we need to start with. What interface do we implement...=0A=
>>=0A=
>> Allowing zone append only through zonefs as the raw block device equival=
ent, all=0A=
>> the O_APPEND/RWF_APPEND semantic is defined and the "return written offs=
et"=0A=
>> implementation in VFS would be common for all file systems, including re=
gular=0A=
>> ones. Beside that, there is I think the question of short writes... Not =
sure if=0A=
>> short writes can currently happen with async RWF_APPEND writes to regula=
r files.=0A=
>> I think not but that may depend on the FS.=0A=
> =0A=
> generic_write_check_limits (called by generic_write_checks, used by=0A=
> most FS) may make it short, and AFAIK it does not depend on=0A=
> async/sync.=0A=
=0A=
Johannes has a patch (not posted yet) fixing all this for zonefs,=0A=
differentiating sync and async cases, allow short writes or not, etc. This =
was=0A=
done by not using generic_write_check_limits() and instead writing a=0A=
zonefs_check_write() function that is zone append friendly.=0A=
=0A=
We can post that as a base for the discussion on semantic if you want...=0A=
=0A=
> This was one of the reason why we chose to isolate the operation by a=0A=
> different IOCB flag and not by IOCB_APPEND alone.=0A=
=0A=
For zonefs, the plan is:=0A=
* For the sync write case, zone append is always used.=0A=
* For the async write case, if we see IOCB_APPEND, then zone append BIOs ar=
e=0A=
used. If not, regular write BIOs are used.=0A=
=0A=
Simple enough I think. No need for a new flag.=0A=
=0A=
-- =0A=
Damien Le Moal=0A=
Western Digital Research=0A=
