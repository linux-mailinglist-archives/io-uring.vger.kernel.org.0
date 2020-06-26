Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9992D20AA97
	for <lists+io-uring@lfdr.de>; Fri, 26 Jun 2020 05:12:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728264AbgFZDMC (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 25 Jun 2020 23:12:02 -0400
Received: from esa3.hgst.iphmx.com ([216.71.153.141]:8079 "EHLO
        esa3.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728169AbgFZDMC (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 25 Jun 2020 23:12:02 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1593141121; x=1624677121;
  h=from:to:cc:subject:date:message-id:references:
   content-transfer-encoding:mime-version;
  bh=Bk5+td77EAsD0UKh0Nz2EOvteisKKEWeM5/eHX+iHBs=;
  b=GxxuRBQg4PqMj2N+VNDUSTshVpNrWNZlsCsO6IAD4KXrqOcRRsDvl4jP
   cre63KiOTkGy6eteqoQOdSpBFWnWmidgFuWvVbUxDKlFLhnBNS+l7zAVL
   zXdA2EvQmVW/321hxRvgvksuv18sKRAVt1daHJ0tn/eSF9W6ghvetYgPc
   3mCtFotCZbhFE4eHN0pGjXSYIkv/UYfvt5wWp+PZ7RccKjKPbleP4/Bpo
   p4KDsrHzN3VHVwe4l3JjeYSYWoWkNDa1K4bg74mQDOvFfrOAa+rCfjdhT
   zVSU3SqyCkfhSQ2js+ejuARGiiKmj9zjfBWPcmTZQNxlQhX8znVjWZTb5
   Q==;
IronPort-SDR: DjgDAbwsfELa4A7O5TznIZQT/665idtHhAHug4HjVqmTJ/44e8DI6vAfAzAIDv+ZjGqI8bjXw+
 h/Z8jqgdQtl2D1M4Filsj15CTptIXwSs/eOBUVtZDFNJLA/d2enV6/4pbN8T39OltsQdKW5HSE
 azrBpXbSyPyTvos3bieeP0hn4w6/yr63XNjCdVrEVCO0gkJllxg2Ba8RztxAgP3b1w9tf/32Gq
 WSzLdMtEin7/sJRDow9YDuVo6sGES7LHnuPCT+nScNwWqMCVMUmHuO7ZSrqb9fxAaMLApxgPqK
 mxY=
X-IronPort-AV: E=Sophos;i="5.75,282,1589212800"; 
   d="scan'208";a="145294131"
Received: from mail-dm6nam11lp2168.outbound.protection.outlook.com (HELO NAM11-DM6-obe.outbound.protection.outlook.com) ([104.47.57.168])
  by ob1.hgst.iphmx.com with ESMTP; 26 Jun 2020 11:11:57 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=XCNAd4TwuHvqNUeTsqdQbkxBhAGbFdZoUMt0zTE50CU35B/wlJPEPAsk1cB4M9xuoWnAobGGJtnKmBpg46TqIwd2CggCpW4bxG4a0vdwWBAeOGL0/LjuSz8zBYVCKbC6AuoObtsCMSy/ILbQyYolYOU7jImyDmfcXSEVPm3Vy2dSbtPT7Kz11xxY/Qq4PbUSTkpZ+ymshPP+78x6avcPtdtr2nUqtGDRMvaZI8K/7q9zw052lx+BTU1QcS+WAS217l6vURj+K2A53s3o599Sd2RgLwfu6yV2KNw7UCmIDu0M4zX2HAoKRqBuMUxLO8vrpK7Gql8ewLpcUxgT/40MjQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ZxvenclH9+SC/nTu+bl5WIHGUjrYUUxRyLmBWMoKieE=;
 b=h3xfjNk7V9OozA1fPZ7NKLq3cPvT39L1kplZeCt8eVYATqCxafwwpsTvhZd2wVo+kLoRIEUijzq3Ib1D96ZsbnATciIS/ZNz1d7eKzUxfBPXxA4tDnfopvfDrFaixPUZxcAtSIKuAhzZq2w9FHwdII46YPz7Kp1YGl12WhV9Aw3Ok1h5bTu1jWgD4fAOAOA9mHyuRMW4P5sz78IjZV50Yuq1o14JuNjXpmLuURSbDxnaPql1mSqdiNnrRD5IdiM6ucya8/uVYbvjC6CzrIUlF8O9e4iCa4jqO31DZlggDfH9lGU1zFJIjovKodiX0uw1b4EpTeR/RSyLplhUWnP59g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ZxvenclH9+SC/nTu+bl5WIHGUjrYUUxRyLmBWMoKieE=;
 b=f9bnKX2B93yqAUaGWNnlkbZU2GgPFod56R1UnefzaD4iwjANuUk+ZWko+caEGMfO2rWcdrM+3me2WXA2oxZdzvPrW1UhzER8L2xOwjE9KL3IGhQp7D1L/M8VrrhmAkVR//87pAstl/ArT73yg9jMeDfwkrzDyQFW911hHA5MBqE=
Received: from CY4PR04MB3751.namprd04.prod.outlook.com (2603:10b6:903:ec::14)
 by CY4PR04MB0968.namprd04.prod.outlook.com (2603:10b6:910:51::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3109.26; Fri, 26 Jun
 2020 03:11:55 +0000
Received: from CY4PR04MB3751.namprd04.prod.outlook.com
 ([fe80::c593:f271:eebe:ac7]) by CY4PR04MB3751.namprd04.prod.outlook.com
 ([fe80::c593:f271:eebe:ac7%9]) with mapi id 15.20.3131.024; Fri, 26 Jun 2020
 03:11:55 +0000
From:   Damien Le Moal <Damien.LeMoal@wdc.com>
To:     Kanchan Joshi <joshi.k@samsung.com>,
        "axboe@kernel.dk" <axboe@kernel.dk>,
        "viro@zeniv.linux.org.uk" <viro@zeniv.linux.org.uk>,
        "bcrl@kvack.org" <bcrl@kvack.org>
CC:     "asml.silence@gmail.com" <asml.silence@gmail.com>,
        "hch@infradead.org" <hch@infradead.org>,
        "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
        "mb@lightnvm.io" <mb@lightnvm.io>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-aio@kvack.org" <linux-aio@kvack.org>,
        "io-uring@vger.kernel.org" <io-uring@vger.kernel.org>,
        "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>,
        "selvakuma.s1@samsung.com" <selvakuma.s1@samsung.com>,
        "nj.shetty@samsung.com" <nj.shetty@samsung.com>,
        "javier.gonz@samsung.com" <javier.gonz@samsung.com>
Subject: Re: [PATCH v2 0/2] zone-append support in io-uring and aio
Thread-Topic: [PATCH v2 0/2] zone-append support in io-uring and aio
Thread-Index: AQHWSxSr/CSwBNGukEytKjLpVVok/w==
Date:   Fri, 26 Jun 2020 03:11:55 +0000
Message-ID: <CY4PR04MB37511E3B19035012A143D006E7930@CY4PR04MB3751.namprd04.prod.outlook.com>
References: <CGME20200625171829epcas5p268486a0780571edb4999fc7b3caab602@epcas5p2.samsung.com>
 <1593105349-19270-1-git-send-email-joshi.k@samsung.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: samsung.com; dkim=none (message not signed)
 header.d=none;samsung.com; dmarc=none action=none header.from=wdc.com;
x-originating-ip: [129.253.182.57]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: be0f1a80-03a7-4263-f4f8-08d8197eae32
x-ms-traffictypediagnostic: CY4PR04MB0968:
x-ld-processed: b61c8803-16f3-4c35-9b17-6f65f441df86,ExtAddr
x-microsoft-antispam-prvs: <CY4PR04MB09687D6A8BF9AE24BB1E4E7BE7930@CY4PR04MB0968.namprd04.prod.outlook.com>
wdcipoutbound: EOP-TRUE
x-ms-oob-tlc-oobclassifiers: OLM:8882;
x-forefront-prvs: 0446F0FCE1
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: hvsJgPE4G/EutzXVUjOoRNCkNxUOxp1Bu2g6J7vB6hwxdAzzem7s/m1cXZB2E5rX4Xxx2BtQrmbWsa1ogTPdhBCUiPWsdyLRT0Cu95YtZVO7P3F8zGm36gYuxJzcrnHeZG8/0MRK1dNvVh26PnvwHcEzbbUvHTAEgyjRQ+nPifsV5BBGXYNpB65Marnujbu0hLo+gMtITSZPLF05/11Ot8+CCvmvRAH4aWKjbPH8BBg7zJxi9hcnKr+qooBKDCgkHKinfck5QcebCHN7si3y1X+yBZcrn0P1l/mo7FLwQyFPj4rDeZj3kJo+HnQQOkSi3UCRar1M3DmfupeDvqci3jiuXVf0FiB+jvQPIlxmu3VaIkRSIwhxJ53wDlntvGy2uH0IlgnJddcbL+9L6k0tsg==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY4PR04MB3751.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(366004)(136003)(376002)(396003)(346002)(39860400002)(478600001)(64756008)(54906003)(110136005)(4326008)(7416002)(2906002)(316002)(66446008)(66476007)(66556008)(66946007)(26005)(52536014)(76116006)(9686003)(7696005)(966005)(5660300002)(91956017)(6506007)(53546011)(186003)(8676002)(33656002)(83380400001)(8936002)(86362001)(71200400001)(55016002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: EcmMb4subWrr4twc7Ui0BUimyyDnaDfmdHwVJBKRp10/yI3Z1hUDFE11ayl/YQMfl4PbNHrtRT6960PAyjFXkLNMTMIU1kX9y4EtX5+ikFM7KQZSLuwMNgtxwqHng+OO+HQjVzemaXg2CG8fmTm5PLfnnxGXtIigN0zTq+C1GwChJEuf2s7jXmC3L8ZLtgYvGk41YYq/vk3MzBhnebhfg8AtbOXAPRcv5J4E6aVQRgXweT4vOh7Si1Y6G06pNoeL2yyDXIEzOeL1SLOMqTH51QbsyEvTe9pdH9PbE7M7Pn7EQjZD3AC6/+PD8Vj98xCauUtqS3RbyFn9reI5iWtf9vq6SL7uoN6TNT1geW+BAiqAY34U8Eaac40ydJ8yniBUjrLYSt6LKfTSkHHOoRjPE4RQybqvp0DJW29peSheErtoNzdYprdtJ9YeZASEW4Rp38tIqS/VDk7Qjwa5bf1poFqxKQZQMWtGvDpbkLJQ0keQ/wFFol5MNmA5EealXulQ
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-Network-Message-Id: be0f1a80-03a7-4263-f4f8-08d8197eae32
X-MS-Exchange-CrossTenant-originalarrivaltime: 26 Jun 2020 03:11:55.0374
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: AR0CQazvgMODZfZ4w0uVJkzPs6UUELyKxc3yNU+x7GoYdSy09uwWzFx88ds3ZMLA6IaDxPG7bVaSNPg1sz9UpQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY4PR04MB0968
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 2020/06/26 2:18, Kanchan Joshi wrote:=0A=
> [Revised as per feedback from Damien, Pavel, Jens, Christoph, Matias, Wil=
cox]=0A=
> =0A=
> This patchset enables zone-append using io-uring/linux-aio, on block IO p=
ath.=0A=
> Purpose is to provide zone-append consumption ability to applications whi=
ch are=0A=
> using zoned-block-device directly.=0A=
> =0A=
> The application may specify RWF_ZONE_APPEND flag with write when it wants=
 to=0A=
> send zone-append. RWF_* flags work with a certain subset of APIs e.g. uri=
ng,=0A=
> aio, and pwritev2. An error is reported if zone-append is requested using=
=0A=
> pwritev2. It is not in the scope of this patchset to support pwritev2 or =
any=0A=
> other sync write API for reasons described later.=0A=
> =0A=
> Zone-append completion result --->=0A=
> With zone-append, where write took place can only be known after completi=
on.=0A=
> So apart from usual return value of write, additional mean is needed to o=
btain=0A=
> the actual written location.=0A=
> =0A=
> In aio, this is returned to application using res2 field of io_event -=0A=
> =0A=
> struct io_event {=0A=
>         __u64           data;           /* the data field from the iocb *=
/=0A=
>         __u64           obj;            /* what iocb this event came from=
 */=0A=
>         __s64           res;            /* result code for this event */=
=0A=
>         __s64           res2;           /* secondary result */=0A=
> };=0A=
> =0A=
> In io-uring, cqe->flags is repurposed for zone-append result.=0A=
> =0A=
> struct io_uring_cqe {=0A=
>         __u64   user_data;      /* sqe->data submission passed back */=0A=
>         __s32   res;            /* result code for this event */=0A=
>         __u32   flags;=0A=
> };=0A=
> =0A=
> Since 32 bit flags is not sufficient, we choose to return zone-relative o=
ffset=0A=
> in sector/512b units. This can cover zone-size represented by chunk_secto=
rs.=0A=
> Applications will have the trouble to combine this with zone start to kno=
w=0A=
> disk-relative offset. But if more bits are obtained by pulling from res f=
ield=0A=
> that too would compel application to interpret res field differently, and=
 it=0A=
> seems more painstaking than the former option.=0A=
> To keep uniformity, even with aio, zone-relative offset is returned.=0A=
=0A=
I am really not a fan of this, to say the least. The input is byte offset, =
the=0A=
output is 512B relative sector count... Arg... We really cannot do better t=
han=0A=
that ?=0A=
=0A=
At the very least, byte relative offset ? The main reason is that this is=
=0A=
_somewhat_ acceptable for raw block device accesses since the "sector"=0A=
abstraction has a clear meaning, but once we add iomap/zonefs async zone ap=
pend=0A=
support, we really will want to have byte unit as the interface is regular=
=0A=
files, not block device file. We could argue that 512B sector unit is still=
=0A=
around even for files (e.g. block counts in file stat). Bu the different un=
it=0A=
for input and output of one operation is really ugly. This is not nice for =
the user.=0A=
=0A=
> =0A=
> Append using io_uring fixed-buffer --->=0A=
> This is flagged as not-supported at the moment. Reason being, for fixed-b=
uffer=0A=
> io-uring sends iov_iter of bvec type. But current append-infra in block-l=
ayer=0A=
> does not support such iov_iter.=0A=
> =0A=
> Block IO vs File IO --->=0A=
> For now, the user zone-append interface is supported only for zoned-block=
-device.=0A=
> Regular files/block-devices are not supported. Regular file-system (e.g. =
F2FS)=0A=
> will not need this anyway, because zone peculiarities are abstracted with=
in FS.=0A=
> At this point, ZoneFS also likes to use append implicitly rather than exp=
licitly.=0A=
> But if/when ZoneFS starts supporting explicit/on-demand zone-append, the =
check=0A=
> allowing-only-block-device should be changed.=0A=
=0A=
Sure, but I think the interface is still a problem. I am not super happy ab=
out=0A=
the 512B sector unit. Zonefs will be the only file system that will be impa=
cted=0A=
since other normal POSIX file system will not have zone append interface fo=
r=0A=
users. So this is a limited problem. Still, even for raw block device files=
=0A=
accesses, POSIX system calls use Byte unit everywhere. Let's try to use tha=
t.=0A=
=0A=
For aio, it is easy since res2 is unsigned long long. For io_uring, as disc=
ussed=0A=
already, we can still 8 bits from the cqe res. All  you need is to add a sm=
all=0A=
helper function in userspace iouring.h to simplify the work of the applicat=
ion=0A=
to get that result.=0A=
=0A=
> =0A=
> Semantics --->=0A=
> Zone-append, by its nature, may perform write on a different location tha=
n what=0A=
> was specified. It does not fit into POSIX, and trying to fit may just und=
ermine=0A=
> its benefit. It may be better to keep semantics as close to zone-append a=
s=0A=
> possible i.e. specify zone-start location, and obtain the actual-write lo=
cation=0A=
> post completion. Towards that goal, existing async APIs seem to fit fine.=
=0A=
> Async APIs (uring, linux aio) do not work on implicit write-pointer and d=
emand=0A=
> explicit write offset (which is what we need for append). Neither write-p=
ointer=0A=
=0A=
What do you mean by "implicit write pointer" ? Are you referring to the beh=
avior=0A=
of AIO write with a block device file open with O_APPEND ? The yes, it does=
 not=0A=
work. But that is perfectly fine for regular files, that is for zonefs.=0A=
=0A=
I would prefer that this paragraph simply state the semantic that is implem=
ented=0A=
first. Then explain why the choice. But first, clarify how the API works, w=
hat=0A=
is allowed, what's not etc. That will also simplify reviewing the code as o=
ne=0A=
can then check the code against the goal.=0A=
=0A=
> is taken as input, nor it is updated on completion. And there is a clear =
way to=0A=
> get zone-append result. Zone-aware applications while using these async A=
PIs=0A=
> can be fine with, for the lack of better word, zone-append semantics itse=
lf.=0A=
> =0A=
> Sync APIs work with implicit write-pointer (at least few of those), and t=
here is=0A=
> no way to obtain zone-append result, making it hard for user-space zone-a=
ppend.=0A=
=0A=
Sync API are executed under inode lock, at least for regular files. So ther=
e is=0A=
absolutely no problem to use zone append. zonefs does it already. The probl=
em is=0A=
the lack of locking for block device file.=0A=
=0A=
> =0A=
> Tests --->=0A=
> Using new interface in fio (uring and libaio engine) by extending zbd tes=
ts=0A=
> for zone-append: https://github.com/axboe/fio/pull/1026=0A=
> =0A=
> Changes since v1:=0A=
> - No new opcodes in uring or aio. Use RWF_ZONE_APPEND flag instead.=0A=
> - linux-aio changes vanish because of no new opcode=0A=
> - Fixed the overflow and other issues mentioned by Damien=0A=
> - Simplified uring support code, fixed the issues mentioned by Pavel=0A=
> - Added error checks=0A=
> =0A=
> Kanchan Joshi (1):=0A=
>   fs,block: Introduce RWF_ZONE_APPEND and handling in direct IO path=0A=
> =0A=
> Selvakumar S (1):=0A=
>   io_uring: add support for zone-append=0A=
> =0A=
>  fs/block_dev.c          | 28 ++++++++++++++++++++++++----=0A=
>  fs/io_uring.c           | 32 ++++++++++++++++++++++++++++++--=0A=
>  include/linux/fs.h      |  9 +++++++++=0A=
>  include/uapi/linux/fs.h |  5 ++++-=0A=
>  4 files changed, 67 insertions(+), 7 deletions(-)=0A=
> =0A=
=0A=
=0A=
-- =0A=
Damien Le Moal=0A=
Western Digital Research=0A=
