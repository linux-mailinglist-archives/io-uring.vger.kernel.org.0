Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CE4B520AC8F
	for <lists+io-uring@lfdr.de>; Fri, 26 Jun 2020 08:56:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728483AbgFZG4W (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 26 Jun 2020 02:56:22 -0400
Received: from esa3.hgst.iphmx.com ([216.71.153.141]:19080 "EHLO
        esa3.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726311AbgFZG4V (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 26 Jun 2020 02:56:21 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1593154581; x=1624690581;
  h=from:to:cc:subject:date:message-id:references:
   content-transfer-encoding:mime-version;
  bh=jwtzg9dpOAL5DG2mEVmYyb6zsqg179n96232ZR0ucHI=;
  b=q4kOrEH+eNk0GsSOjHwLRHKEKL6zeTYFL9lId7vu7W8Epp20zThh9u2r
   oBXkdLEfS32Xcf06CPUptczy9DWrIyftupKmvvx2w6/FPFeWva0MlP4oK
   6sqhIU5944YyFZoEMc5s0Vx7+VAt6NArrj2u8KrVWC9pnXcVbbkQsRjkg
   0UzkcPOPGCFEVtyTqiyDn+G8ODW3fyhGaBXEXEJY9NmO4KULiJ74nUuxl
   0swUGYMsZAh0WAl0LQ5PBEvkDcouTu4mLhaB/gyXMe5pSyHOojEpimjgu
   /irNVeNPX+CQ+OsrCtJFW/b0xAxNAeTgF4Ozzn5+TyVhDFHkL4jMzSmLX
   A==;
IronPort-SDR: A9OIiQqXY/x9j3WlHZF6+M2uHlAJGZ9wnChvpUWZIY1I4HAlwrdP1Q4q9L1wjobUi4oPqs0nRy
 +hjF7yzGCNSK0jkTImRsuwZoBhbWh7cIT8F/R/0mI9lKvgQixuOeCmE3G/GCbrjZE9sVFxA7j6
 iAtgKhYVv06rq6UhQ2E72ihgsUGMHR1QBHKPD8sYpvAg3p7/9Z4jivKB1qfHXG1zosH1efNFZc
 eV/5fKM3ezc2p8oS1MMx4Y1UWYcueKn3k5S2gqqzQ07Hyblv3XmS76e+eHGOSfhpVULYADZ1PT
 akk=
X-IronPort-AV: E=Sophos;i="5.75,282,1589212800"; 
   d="scan'208";a="145305695"
Received: from mail-bn7nam10lp2106.outbound.protection.outlook.com (HELO NAM10-BN7-obe.outbound.protection.outlook.com) ([104.47.70.106])
  by ob1.hgst.iphmx.com with ESMTP; 26 Jun 2020 14:56:19 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=RO3U8tesOTx2kP/jk/DC1qbDm2Gaf8ZH7WsJkudJpELIBH3vp4WE0jc+vqBJmz0QVgNK3wTypY7C9nuITzSYPkmzDO7sEyj9sHxpAuGiX3RRFo1Qe38wF2XyzcXvYwqfdQCW+e8pTjzlMwLU6S2IDHoTYgRJw1ficlNvYet0z4nQI3TFgDD9rNDXGdAndl9aJABaw++W6yySrLw0qCZC3a7+ByqdAxncyA05oSAfgVtpIwE88TC7ESdNgUmfistgVTF41okNvj0BLent5g6IidYj8zK1ffEK7c3GwYCIZ8wcnXz35GD1xSrp/qEmYkTI1vJALSYfVdKr6B6UmbIgrA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=g9POS3sahzFP0F1JK+SqCZnq+ydMT6eVi0ovl9FME2U=;
 b=oacwvPP2p80NQ02OGD+PAOy+EMb1VSknL6zUILsFF6NN0U76TOEqyltNbvSpk/EQA7YcBq0ry6YkUUPtaEMjWUilkTxbMs4P6PX41pZ4R/KDTZt7nH9hcUvnTz0CNCFeOXuWKf71rx8M/EPGhEX4dzvDFAaQHkL2KcOyvPLraxjTpfrW8xigeO5RkTsYGIOU4yR8b8ZpqAteBbeVmrXkOxshQoElU9MJ5tQmv+K2HT140jwjrcNJCIRUUxf7M5SsrA0fOsZR6lkvRLpvNlqhxxFNMe5bUKqaisMnmASb5uQ5xRUGZVlJtBirTk+kRRhcfH2SRQNlgQqrhBF4tqMJ3Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=g9POS3sahzFP0F1JK+SqCZnq+ydMT6eVi0ovl9FME2U=;
 b=YLRDowhm/RDwT9XCklXBGqeJEclnOyhsDLE0ISeP8bMrpoK1tHRJZBWj1vxHXzSJJap/l8K5U0h1Ui3atlsKbkbO/VrE8hghsPMYglb8fJRFzsLoK0XVAb+y2Xb6CFP5V+CC4V24/cIRm2QWv1V1ZlRl7bCXFCTjth+Lvy6/+58=
Received: from CY4PR04MB3751.namprd04.prod.outlook.com (2603:10b6:903:ec::14)
 by CY4PR04MB1033.namprd04.prod.outlook.com (2603:10b6:910:54::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3131.21; Fri, 26 Jun
 2020 06:56:17 +0000
Received: from CY4PR04MB3751.namprd04.prod.outlook.com
 ([fe80::c593:f271:eebe:ac7]) by CY4PR04MB3751.namprd04.prod.outlook.com
 ([fe80::c593:f271:eebe:ac7%9]) with mapi id 15.20.3131.024; Fri, 26 Jun 2020
 06:56:17 +0000
From:   Damien Le Moal <Damien.LeMoal@wdc.com>
To:     "javier.gonz@samsung.com" <javier.gonz@samsung.com>
CC:     Kanchan Joshi <joshi.k@samsung.com>,
        "axboe@kernel.dk" <axboe@kernel.dk>,
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
        "nj.shetty@samsung.com" <nj.shetty@samsung.com>
Subject: Re: [PATCH v2 0/2] zone-append support in io-uring and aio
Thread-Topic: [PATCH v2 0/2] zone-append support in io-uring and aio
Thread-Index: AQHWSxSr/CSwBNGukEytKjLpVVok/w==
Date:   Fri, 26 Jun 2020 06:56:17 +0000
Message-ID: <CY4PR04MB375154780F0B8073AB83DA9CE7930@CY4PR04MB3751.namprd04.prod.outlook.com>
References: <CGME20200625171829epcas5p268486a0780571edb4999fc7b3caab602@epcas5p2.samsung.com>
 <1593105349-19270-1-git-send-email-joshi.k@samsung.com>
 <CY4PR04MB37511E3B19035012A143D006E7930@CY4PR04MB3751.namprd04.prod.outlook.com>
 <20200626063717.4dhsydpcnezjhj3o@mpHalley.localdomain>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: samsung.com; dkim=none (message not signed)
 header.d=none;samsung.com; dmarc=none action=none header.from=wdc.com;
x-originating-ip: [129.253.182.57]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 16285ad9-4944-40a5-5cfe-08d8199e0634
x-ms-traffictypediagnostic: CY4PR04MB1033:
x-ld-processed: b61c8803-16f3-4c35-9b17-6f65f441df86,ExtAddr
x-microsoft-antispam-prvs: <CY4PR04MB1033B50076D0E9DAB52C77F9E7930@CY4PR04MB1033.namprd04.prod.outlook.com>
wdcipoutbound: EOP-TRUE
x-ms-oob-tlc-oobclassifiers: OLM:8273;
x-forefront-prvs: 0446F0FCE1
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: z+43yMsK/yyry1DMey2eG4u2RPMQQ4/xWiioRw9p+UUjyrX8kDaj+58CgGLG4YtNT33OZDgGcM+oGAczkLXpiffiLWdbqoCcm50u7yHX78I2A+zzIOoIoC6yoCCHlfMwh7ynjj7VDmSp8kV56uM5RjvWCLkVTQNEr9/1BNXayXV/1XI1zfZ8wJYYxPcQ2Ez5+f6rTz1Z6kAt57UhVa6A8Ie3mXXkRjlAWbYgsgDTjJ8c7BlAEJYVY7sFEcN+9EFOoXGLF73e4BTixOTLsZ94jWzvgNzyQ5y0r9SJPsL0YL0JZuSMVS2cYgpXT2gsN/SSXV68wJi5rxRocwD/ZWc+ww==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY4PR04MB3751.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(376002)(396003)(136003)(366004)(39860400002)(346002)(33656002)(83380400001)(53546011)(86362001)(64756008)(9686003)(6916009)(55016002)(5660300002)(66946007)(52536014)(66446008)(8936002)(66476007)(66556008)(76116006)(7416002)(8676002)(91956017)(54906003)(26005)(6506007)(316002)(4326008)(2906002)(478600001)(7696005)(71200400001)(186003);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: L1XZ5NEHPz+PHhh/pdsO1x3leYRnCkdR+TsOSsQ5jg06CbS3B3LvcZhzoL0nuK2Yhg73k7YE4XCS9loeDNz+v1KiSgmJL6+raAeTiK6z2CT9yQaqoGU/t5ogXuaoiJ3DBsTIDAhIhkhPSyEt2PPHzmWDoOlg+Ot83xie6ESE3voq+W4uxrA4PKcRN0E9ChBeLFndQnxgjJB9/n1TdJQGD3NDHtbkhcIiTmPUMrHp/PNvItRgqxIHkc+F6ReMG/yKFpGSzYMyG4GeDoLLNinQPA3Oc0IH6A0jjqnM2IKrb14kaj0P+BFNU7yeQc3en4nyt3bGcj5vi5H4NMKzMQ5c5srFDUj+nUe4IeAU+13kSyar7CJrGVHg6j13mdUh7DnTsnAfFpwo1w5pChhZk0NP5ZLUHBSO0EzODQZp+ajbiuhVnFOx4/J040a7sgPs17qLkElGJUP0VrUyr9HFYCZgbqUBCuAvwxCrsQG//PqXvo6SnGCtUZbjhDVbfyikVMkk
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: CY4PR04MB3751.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 16285ad9-4944-40a5-5cfe-08d8199e0634
X-MS-Exchange-CrossTenant-originalarrivaltime: 26 Jun 2020 06:56:17.1727
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: LXoMt0IpoyMPME9HK9GjbqNZQ170FLH/MPhucLiinVVH6vP1DdA9/SAzmobB0nNTSEVbUU2V+aOr8gU9A4b9ng==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY4PR04MB1033
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 2020/06/26 15:37, javier.gonz@samsung.com wrote:=0A=
> On 26.06.2020 03:11, Damien Le Moal wrote:=0A=
>> On 2020/06/26 2:18, Kanchan Joshi wrote:=0A=
>>> [Revised as per feedback from Damien, Pavel, Jens, Christoph, Matias, W=
ilcox]=0A=
>>>=0A=
>>> This patchset enables zone-append using io-uring/linux-aio, on block IO=
 path.=0A=
>>> Purpose is to provide zone-append consumption ability to applications w=
hich are=0A=
>>> using zoned-block-device directly.=0A=
>>>=0A=
>>> The application may specify RWF_ZONE_APPEND flag with write when it wan=
ts to=0A=
>>> send zone-append. RWF_* flags work with a certain subset of APIs e.g. u=
ring,=0A=
>>> aio, and pwritev2. An error is reported if zone-append is requested usi=
ng=0A=
>>> pwritev2. It is not in the scope of this patchset to support pwritev2 o=
r any=0A=
>>> other sync write API for reasons described later.=0A=
>>>=0A=
>>> Zone-append completion result --->=0A=
>>> With zone-append, where write took place can only be known after comple=
tion.=0A=
>>> So apart from usual return value of write, additional mean is needed to=
 obtain=0A=
>>> the actual written location.=0A=
>>>=0A=
>>> In aio, this is returned to application using res2 field of io_event -=
=0A=
>>>=0A=
>>> struct io_event {=0A=
>>>         __u64           data;           /* the data field from the iocb=
 */=0A=
>>>         __u64           obj;            /* what iocb this event came fr=
om */=0A=
>>>         __s64           res;            /* result code for this event *=
/=0A=
>>>         __s64           res2;           /* secondary result */=0A=
>>> };=0A=
>>>=0A=
>>> In io-uring, cqe->flags is repurposed for zone-append result.=0A=
>>>=0A=
>>> struct io_uring_cqe {=0A=
>>>         __u64   user_data;      /* sqe->data submission passed back */=
=0A=
>>>         __s32   res;            /* result code for this event */=0A=
>>>         __u32   flags;=0A=
>>> };=0A=
>>>=0A=
>>> Since 32 bit flags is not sufficient, we choose to return zone-relative=
 offset=0A=
>>> in sector/512b units. This can cover zone-size represented by chunk_sec=
tors.=0A=
>>> Applications will have the trouble to combine this with zone start to k=
now=0A=
>>> disk-relative offset. But if more bits are obtained by pulling from res=
 field=0A=
>>> that too would compel application to interpret res field differently, a=
nd it=0A=
>>> seems more painstaking than the former option.=0A=
>>> To keep uniformity, even with aio, zone-relative offset is returned.=0A=
>>=0A=
>> I am really not a fan of this, to say the least. The input is byte offse=
t, the=0A=
>> output is 512B relative sector count... Arg... We really cannot do bette=
r than=0A=
>> that ?=0A=
>>=0A=
>> At the very least, byte relative offset ? The main reason is that this i=
s=0A=
>> _somewhat_ acceptable for raw block device accesses since the "sector"=
=0A=
>> abstraction has a clear meaning, but once we add iomap/zonefs async zone=
 append=0A=
>> support, we really will want to have byte unit as the interface is regul=
ar=0A=
>> files, not block device file. We could argue that 512B sector unit is st=
ill=0A=
>> around even for files (e.g. block counts in file stat). Bu the different=
 unit=0A=
>> for input and output of one operation is really ugly. This is not nice f=
or the user.=0A=
>>=0A=
> =0A=
> You can refer to the discussion with Jens, Pavel and Alex on the uring=0A=
> interface. With the bits we have and considering the maximun zone size=0A=
> supported, there is no space for a byte relative offset. We can take=0A=
> some bits from cqe->res, but we were afraid this is not very=0A=
> future-proof. Do you have a better idea?=0A=
=0A=
If you can take 8 bits, that gives you 40 bits, enough to support byte rela=
tive=0A=
offsets for any zone size defined as a number of 512B sectors using an unsi=
gned=0A=
int. Max zone size is 2^31 sectors in that case, so 2^40 bytes. Unless I am=
=0A=
already too tired and my math is failing me...=0A=
=0A=
zone size is defined by chunk_sectors, which is used for raid and software =
raids=0A=
too. This has been an unsigned int forever. I do not see the need for chang=
ing=0A=
this to a 64bit anytime soon, if ever. A raid with a stripe size larger tha=
n 1TB=0A=
does not really make any sense. Same for zone size...=0A=
=0A=
> =0A=
> =0A=
>>>=0A=
>>> Append using io_uring fixed-buffer --->=0A=
>>> This is flagged as not-supported at the moment. Reason being, for fixed=
-buffer=0A=
>>> io-uring sends iov_iter of bvec type. But current append-infra in block=
-layer=0A=
>>> does not support such iov_iter.=0A=
>>>=0A=
>>> Block IO vs File IO --->=0A=
>>> For now, the user zone-append interface is supported only for zoned-blo=
ck-device.=0A=
>>> Regular files/block-devices are not supported. Regular file-system (e.g=
. F2FS)=0A=
>>> will not need this anyway, because zone peculiarities are abstracted wi=
thin FS.=0A=
>>> At this point, ZoneFS also likes to use append implicitly rather than e=
xplicitly.=0A=
>>> But if/when ZoneFS starts supporting explicit/on-demand zone-append, th=
e check=0A=
>>> allowing-only-block-device should be changed.=0A=
>>=0A=
>> Sure, but I think the interface is still a problem. I am not super happy=
 about=0A=
>> the 512B sector unit. Zonefs will be the only file system that will be i=
mpacted=0A=
>> since other normal POSIX file system will not have zone append interface=
 for=0A=
>> users. So this is a limited problem. Still, even for raw block device fi=
les=0A=
>> accesses, POSIX system calls use Byte unit everywhere. Let's try to use =
that.=0A=
>>=0A=
>> For aio, it is easy since res2 is unsigned long long. For io_uring, as d=
iscussed=0A=
>> already, we can still 8 bits from the cqe res. All  you need is to add a=
 small=0A=
>> helper function in userspace iouring.h to simplify the work of the appli=
cation=0A=
>> to get that result.=0A=
> =0A=
> Ok. See above. We can do this.=0A=
> =0A=
> Jens: Do you see this as a problem in the future?=0A=
> =0A=
> [...]=0A=
> =0A=
> Javier=0A=
> =0A=
=0A=
=0A=
-- =0A=
Damien Le Moal=0A=
Western Digital Research=0A=
