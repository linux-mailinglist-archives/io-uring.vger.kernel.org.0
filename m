Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A259727B94D
	for <lists+io-uring@lfdr.de>; Tue, 29 Sep 2020 03:24:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727234AbgI2BYG (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 28 Sep 2020 21:24:06 -0400
Received: from esa3.hgst.iphmx.com ([216.71.153.141]:3322 "EHLO
        esa3.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725272AbgI2BYG (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 28 Sep 2020 21:24:06 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1601342645; x=1632878645;
  h=from:to:cc:subject:date:message-id:references:
   content-transfer-encoding:mime-version;
  bh=GatKgLvDnq3CAisnfkrjYiQalCL7YgWkOW/2oQKLm6k=;
  b=ifLnSiR+CJ6i1yHETSypG+fY3Q5zdl67oIV0nV6buScA6tLPcj2jx0yf
   Tb3ZmoiK9J5CkOO9vovu37l7F5EkFO4z6ys/m0uVhn6MRbfl20567bk1p
   NBIFps7tBA7QEgTWIf2YUkQFvyohcMFLe/tBYslxbkf4f1rNxpqrE3XWv
   j6ukaKbXsstiQPJ1JSS6odZWTnhs7Yp8MxgcFSOwcQSQFfgBvkUuwAkGY
   Xj5LKMT2lezSLJUpaIt/+faMW4ueNce6RMBkj7Hwjy220UiWdXosFrr9T
   8iDNA/4jvuY51oJWYAbC9SXHL3uhmvTSDy/7qhv+ZkVthlpovr8Fh+RY9
   Q==;
IronPort-SDR: VzmFKI2narIHQmMi4XTkZjUteh1hIgEa21aNadmCycq4qrXfzGHOyjqs8HafEMMgBdssqY7H1o
 MCjxTbqVcF/QSyoFz2sXhq/h4AksDDjKC4VZItQE2zlUy/Bxq9UGiwlFIL6hIa4yAmrcbJjgKa
 2e+iEkSGf+ZfDaZJfBTeCGXjVuzOFkBYOGxh327vvQj6h7dmBlo4G2FGin1d3gxXI2wB21eWgR
 YrHdmv4gbO86P3eU/xI5UQ3U427jHJDu8gtYWR9a2ZrCgCHKCNp8XY0s2fihgmOrNTAD+oSJwB
 l/I=
X-IronPort-AV: E=Sophos;i="5.77,316,1596470400"; 
   d="scan'208";a="152871160"
Received: from mail-co1nam11lp2169.outbound.protection.outlook.com (HELO NAM11-CO1-obe.outbound.protection.outlook.com) ([104.47.56.169])
  by ob1.hgst.iphmx.com with ESMTP; 29 Sep 2020 09:24:04 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=DpnZVi7qeXnOHq2+z43nHnuRt7Rx1hzAlaIlcd6D0CHuYOe+DuBjODavG1AxF99qAW4ZMtrltt3ocKip4WV47+yphhGSEjIStKJmA6En07V/POnxvQGUDqMMuFk6XUmcOECFvElQzVRT/iEkn0UQsLdix2gA7Dzs+vkY3EJjxhY28KdKaKf+DupqlbGrErKMxyOKlg2T7k/ewjbFeHklN6ugJrbNy/LVCfNUgraH+jJblZZdr3gEWbOHLFrfu1AY44TenydO54vcciaKKICWMtUvNJXWzAQMDrp3e2Y4lq//VgC+CNueGioK0fiuZseXnqCiSOSRYJp5IM7a+Ic9qg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=oNUYlCv9mxPUSKcfUEasj1k2ZsB0NlgwJVKR6iLhG64=;
 b=MEZTGFgyMX5DWvvVjmZvLGoJRyekgS/9KqRjC0ZBU4qA3v5KkhtIVR9h1PHTMmDruqHTHSbT3xNMl+fICS4GX45nH4hrdojfOlfzY2lvZAYuBg5EsdFUI0mPW1rzNo+fEwtemr+TJUfgyWvjIHNrKGw7fkHL62OB+oWI7Gn6pjAQZFeff5NThs7bRtnvgFfPlE69fvwU//ec/XLmMlTviehDP7XMzz9n7XbOrs0Ks53/yneX7BbqRdpd+RmM1SsIpTGKDgq2k1NmXJ57Wy8ySeg/vRkygTYmPZEs6xntSXAyW4bmZwVuaYZXJsIJzaqxCbI1uo5GWksQ9ezQHSckqg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=oNUYlCv9mxPUSKcfUEasj1k2ZsB0NlgwJVKR6iLhG64=;
 b=V3iKxQo+mGuoh7ngvE75ESRze7admyF7Z8dk11egBDU3+n4d4y4VyPNZAU+KG7goL88/pvgBi6TZVKxnEjaQ083V4/NfO+KW9Fu9J7WKs4+nUvMcfH7/vraaFetKhVLqNcA/xLlw0D4j8AngR1BBdn7FFusFuwpNm2nnPv7UwRY=
Received: from CY4PR04MB3751.namprd04.prod.outlook.com (2603:10b6:903:ec::14)
 by CY4PR04MB0567.namprd04.prod.outlook.com (2603:10b6:903:b1::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3412.20; Tue, 29 Sep
 2020 01:24:02 +0000
Received: from CY4PR04MB3751.namprd04.prod.outlook.com
 ([fe80::9124:2453:fe9c:9a7]) by CY4PR04MB3751.namprd04.prod.outlook.com
 ([fe80::9124:2453:fe9c:9a7%12]) with mapi id 15.20.3412.029; Tue, 29 Sep 2020
 01:24:02 +0000
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
        Johannes Thumshirn <Johannes.Thumshirn@wdc.com>,
        Naohiro Aota <Naohiro.Aota@wdc.com>
Subject: Re: [PATCH v4 6/6] io_uring: add support for zone-append
Thread-Topic: [PATCH v4 6/6] io_uring: add support for zone-append
Thread-Index: AQHWYdbcc0q15qREKECGO7brHi6zEg==
Date:   Tue, 29 Sep 2020 01:24:02 +0000
Message-ID: <CY4PR04MB3751BFF86D1F7F1D22A143E6E7320@CY4PR04MB3751.namprd04.prod.outlook.com>
References: <CA+1E3rLM4G4SwzD6RWsK6Ssp7NmhiPedZDjrqN3kORQr9fxCtw@mail.gmail.com>
 <MWHPR04MB375863C20C1EF2CB27E62703E74E0@MWHPR04MB3758.namprd04.prod.outlook.com>
 <20200731091416.GA29634@infradead.org>
 <MWHPR04MB37586D39CA389296CE0252A4E74E0@MWHPR04MB3758.namprd04.prod.outlook.com>
 <20200731094135.GA4104@infradead.org>
 <MWHPR04MB3758A4B2967DB1FABAAD9265E74E0@MWHPR04MB3758.namprd04.prod.outlook.com>
 <20200731125110.GA11500@infradead.org>
 <CY4PR04MB37517D633920E4D31AC6EA0DE74B0@CY4PR04MB3751.namprd04.prod.outlook.com>
 <20200814081411.GA16943@infradead.org>
 <CA+1E3r+WXC_MK5Zf2OZEv17ddJDjtXbhpRFoeDns4F341xMhow@mail.gmail.com>
 <20200908151801.GA16742@infradead.org>
 <CA+1E3r+MSEW=-SL8L+pquq+cFAu+nQOULQ+HZoQsCvdjKMkrNw@mail.gmail.com>
 <MWHPR04MB3758A78AFAED3543F8D38266E7360@MWHPR04MB3758.namprd04.prod.outlook.com>
 <CA+1E3rJANOsPOzjtJHSViVMq+Uc-sB0iZoExxBG++v2ghaL4uA@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: gmail.com; dkim=none (message not signed)
 header.d=none;gmail.com; dmarc=none action=none header.from=wdc.com;
x-originating-ip: [2400:2411:43c0:6000:6569:68aa:23ff:5875]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 4c516681-1b90-415a-5ea3-08d864165980
x-ms-traffictypediagnostic: CY4PR04MB0567:
x-ld-processed: b61c8803-16f3-4c35-9b17-6f65f441df86,ExtAddr
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <CY4PR04MB056705C5A68F41795B409ACDE7320@CY4PR04MB0567.namprd04.prod.outlook.com>
wdcipoutbound: EOP-TRUE
x-ms-oob-tlc-oobclassifiers: OLM:10000;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: Gu5mAxaevN052jQ6JB77NiU0QdmnPf0ApL+FKDkrWpix80JBw9DXDeyUraWDeD7mGFR/Spu+qPGaX/Uf9fgUAZ16/rB565oiL5gOyTtmu1ZgdRMGN8gI+MemzvRu27SPza3vTkjXGstqmBWOTlYaP73gtg0xoWciMjd19KsHzQn3Iot5wEWKUX6kQhBK35etvDBiwH75Wjjs+tvyYfQyoBtS5J4Ns/gPRHX669o7zaoq79V++7htmQsqiFvb9VALVDFPieidusWuUolFFjJ4/O1GfHe4QipPI35NhCs6plGy4UHM08mv6+hEkmyvHEMlJXd88aZ+GJb3j+tV7i7y8btauHj0AwSn8JAfm737fwFP1t6LLyUNz7ZEzH6qBfdf
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY4PR04MB3751.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(396003)(376002)(346002)(136003)(39860400002)(366004)(5660300002)(7696005)(316002)(55016002)(186003)(4326008)(7416002)(91956017)(6916009)(76116006)(66476007)(64756008)(66446008)(83380400001)(54906003)(66556008)(66946007)(52536014)(33656002)(8676002)(2906002)(478600001)(9686003)(53546011)(6506007)(86362001)(71200400001)(8936002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: zi1zd0PAcgIxqMmmVsYHjuc8+bpEEXtOyFJMlapIkFuur27gshQZwiveEFqMxgkNMJ9e/W4/wVEWbjcqxV53AgbzdS+nTV63W1dhy2J3abvn/DkMBZM0kSGCePwar8kI4hDf1exit9B7FEg4WWeoouKHAkAf7J+jmVDcg/2TuxYRTCw3+rZcB6L4S3A0fbOnbM1FZNMkqFkK0Jhzxb83bs3IdqhqWBlF0f26XP2o1DL8bS/CB2gN2pAewSUn03lgnSXAVeYVq84/B1j77gXXpC9P0CqFaQ7W5VMsM9SHw3ZlyU+EelXxk6nCDwwMyPlXNwQQkjgKUKXBPBiLWcx3qZrxWijBwgwICkhQoD5g341ncDCFqQz9hKb2Enr2K08mbDhXDPuH9cuGRr02qP0MPbd/tGeI+cAGZVOq9e/RVEBdTFShxp+DQSXn/gjpVxLVHlmPBrq0jeN9AER7OS/qmUyhd2GG7dX1m/1iW6pDCS0vfY8XjMThAr7VUvc3/X53Y4IeRs8+8gezbuOAM2nY01XhXkNiXriXmtsUtiesoKRnPp21LysI8JY6yxI5T/liF6t0E5xSYq/hBKhLPr6XX5kbAXdPjKkBKS1JwvRQewdvnqHAHOs6ipUG2lQrBHzEHip5I6psjGUusKamZg10ApVSLzzvetQVb3BFFO5z6o10EFX568MaNZMeMeNmTNS668cwckNswCTGec6IhrJeow==
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: CY4PR04MB3751.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4c516681-1b90-415a-5ea3-08d864165980
X-MS-Exchange-CrossTenant-originalarrivaltime: 29 Sep 2020 01:24:02.2880
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: JAV7ULBYyoo6bnUUzudpgsKRMmGDXB1nBiBZyHnmXVallE4qNBykPWhBS7D+TltUmMdi6IU481gM43vIvWq3kw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY4PR04MB0567
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 2020/09/29 3:58, Kanchan Joshi wrote:=0A=
[...]=0A=
> ZoneFS is better when it is about dealing at single-zone granularity,=0A=
> and direct-block seems better when it is about grouping zones (in=0A=
> various ways including striping). The latter case (i.e. grouping=0A=
> zones) requires more involved mapping, and I agree that it can be left=0A=
> to application (for both ZoneFS and raw-block backends).=0A=
> But when an application tries that on ZoneFS, apart from mapping there=0A=
> would be additional cost of indirection/fd-management (due to=0A=
> file-on-files).=0A=
=0A=
There is no indirection in zonefs. fd-to-struct file/inode conversion is ve=
ry=0A=
fast and happens for every system call anyway, regardless of what the fd=0A=
represents. So I really do not understand what your worry is here. If you a=
re=0A=
worried about overhead/performance, then please show numbers. If something =
is=0A=
wrong, we can work on fixing it.=0A=
=0A=
> And if new features (zone-append for now) are available only on=0A=
> ZoneFS, it forces application to use something that maynot be most=0A=
> optimal for its need.=0A=
=0A=
"may" is not enough to convince me...=0A=
=0A=
> Coming to the original problem of plumbing append - I think divergence=0A=
> started because RWF_APPEND did not have any meaning for block device.=0A=
> Did I miss any other reason?=0A=
=0A=
Correct.=0A=
=0A=
> How about write-anywhere semantics (RWF_RELAXED_WRITE or=0A=
> RWF_ANONYMOUS_WRITE flag) on block-dev.=0A=
=0A=
"write-anywhere" ? What do you mean ? That is not possible on zoned devices=
,=0A=
even with zone append, since you at least need to guarantee that zones have=
=0A=
enough unwritten space to accept an append command.=0A=
=0A=
> Zone-append works a lot like write-anywhere on block-dev (or on any=0A=
> other file that combines multiple-zones, in non-sequential fashion).=0A=
=0A=
That is an over-simplification that is not helpful at all. Zone append is n=
ot=0A=
"write anywhere" at all. And "write anywhere" is not a concept that exist o=
n=0A=
regular block devices anyway. Writes only go to the offset that the user=0A=
decided, through lseek(), pwrite() or aio->aio_offset. It is not like the b=
lock=0A=
layer decides where the writes land. The same constraint applies to zone ap=
pend:=0A=
the user decide the target zone. That is not "anywhere". Please be precise =
with=0A=
wording and implied/desired semantic. Narrow down the scope of your concept=
=0A=
names for clarity.=0A=
=0A=
And talking about "file that combines multiple-zones" would mean that we ar=
e now=0A=
back in FS land, not raw block device file accesses anymore. So which one a=
re we=0A=
talking about ? It looks like you are confusing what the application does a=
nd=0A=
how it uses whatever usable interface to the device with what that interfac=
e=0A=
actually is. It is very confusing.=0A=
=0A=
>>> Also it seems difficult (compared to block dev) to fit simple-copy TP=
=0A=
>>> in ZoneFS. The new=0A=
>>> command needs: one NVMe drive, list of source LBAs and one destination=
=0A=
>>> LBA. In ZoneFS, we would deal with N+1 file-descriptors (N source zone=
=0A=
>>> file, and one destination zone file) for that. While with block=0A=
>>> interface, we do not need  more than one file-descriptor representing=
=0A=
>>> the entire device. With more zone-files, we face open/close overhead to=
o.=0A=
>>=0A=
>> Are you expecting simple-copy to allow requests that are not zone aligne=
d ? I do=0A=
>> not think that will ever happen. Otherwise, the gotcha cases for it woul=
d be far=0A=
>> too numerous. Simple-copy is essentially an optimized regular write comm=
and.=0A=
>> Similarly to that command, it will not allow copies over zone boundaries=
 and=0A=
>> will need the destination LBA to be aligned to the destination zone WP. =
I have=0A=
>> not checked the TP though and given the NVMe NDA, I will stop the discus=
sion here.=0A=
> =0A=
> TP is ratified, if that is the problem you are referring to.=0A=
=0A=
Ah. Yes. Got confused with ZRWA. Simple-copy is a different story anyway. L=
et's=0A=
not mix it into zone append user interface please.=0A=
=0A=
> =0A=
>> filesend() could be used as the interface for simple-copy. Implementing =
that in=0A=
>> zonefs would not be that hard. What is your plan for simple-copy interfa=
ce for=0A=
>> raw block device ? An  ioctl ? filesend() too ? As as with any other use=
r level=0A=
>> API, we should not be restricted to a particular device type if we can a=
void it,=0A=
>> so in-kernel emulation of the feature is needed for devices that do not =
have=0A=
>> simple-copy or scsi extended copy. filesend() seems to me like the best =
choice=0A=
>> since all of that is already implemented there.=0A=
> =0A=
> At this moment, ioctl as sync and io-uring for async. sendfile() and=0A=
> copy_file_range() takes two fds....with that we can represent copy=0A=
> from one source zone to another zone.=0A=
> But it does not fit to represent larger copy (from N source zones to=0A=
> one destination zone).=0A=
=0A=
nvme passthrough ? If that does not fit your use case, then think of an=0A=
interface, its definition/semantic and propose it. But again, use a differe=
nt=0A=
thread. This is mixing up zone-append and simple copy, which I do not think=
 are=0A=
directly related.=0A=
=0A=
> Not sure if I am clear, perhaps sending RFC would be better for=0A=
> discussion on simple-copy.=0A=
=0A=
Separate this discussion from zone append please. Mixing up 2 problems in o=
ne=0A=
thread is not helpful to make progress.=0A=
=0A=
=0A=
-- =0A=
Damien Le Moal=0A=
Western Digital Research=0A=
