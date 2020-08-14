Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B26CD24466C
	for <lists+io-uring@lfdr.de>; Fri, 14 Aug 2020 10:27:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726269AbgHNI1S (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 14 Aug 2020 04:27:18 -0400
Received: from esa1.hgst.iphmx.com ([68.232.141.245]:60111 "EHLO
        esa1.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726124AbgHNI1S (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 14 Aug 2020 04:27:18 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1597393637; x=1628929637;
  h=from:to:cc:subject:date:message-id:references:
   content-transfer-encoding:mime-version;
  bh=Oo0f9Mk9zMH4JUXFuE9qY5xunAF/Mf5A2XnOhkrDxQo=;
  b=C4ZRvomB5o2WwEJZD+dOchNQOJe+dmIPnetqmHnJraCdbQ2Y1MYDgTdz
   bYjAYqC/x+Vqp7aosKwXwmkrc4ADHQci897znEU7rDct6L74kkF9X6ODG
   5pC6PrrFWu2UkjSuLn7cMkQGHNIt1oOtR7jCDPZnwlVWEsq/8UF7hMggo
   xCbd1o6dg3ZwdOgHKDgu6Kj9LWdyiVwbLMelcCaGS8TipHhJ5TubOtqdP
   m5z+QaBY/W+mH31HgJVyK7QIuk2cGc3SCrmAPA6ZhMhpsxCgCSiA5C0qY
   i7olOCpyhJg1vMruZOzNF5wYJlbZSXK1ZJ+VJ2Vs7ewj8nBFbZZpsSqKr
   g==;
IronPort-SDR: k/pLI4Sv4qHTyphAzvqjysy1i9QoiK7reL9cUIGjnwo2xZo80OLE0IZWGQOZEkyHWdDhsq47DH
 cypej5kgsYeDMlvuP2smQv2rGdOp8NkiuJDjSINne7TdsZr/cTpvnDQ8RVSKH5WYV0fRzPbFUz
 UqyTzP5EjflBoHc9mh5W35d8JCC0or/0fv9iz2Wkn9KBT8Tb6vdpsDCxjEF3uoWKkzMAYRYcMD
 LoRJ8grsN45ojOGFRqOEyMDyrh+J4BskqW+JkYsDvEewI67OesPmgQjQjwW0nQ45as6ePbAkOc
 5Zg=
X-IronPort-AV: E=Sophos;i="5.76,311,1592841600"; 
   d="scan'208";a="254345869"
Received: from mail-dm6nam11lp2169.outbound.protection.outlook.com (HELO NAM11-DM6-obe.outbound.protection.outlook.com) ([104.47.57.169])
  by ob1.hgst.iphmx.com with ESMTP; 14 Aug 2020 16:27:15 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=SxdCxN3ub2LYWnq4znV9nanN9SlX6maRifDgK0Yt5O2988/SfplaeusoyF1ZnZvhUNKC2RLHoJVP0O9QYPHNdRPi+Ahy4n1wVmeNkniSxPsTA/9h9621qV8TrCAV8CyT9jBOXPSIPTS5qWpmbxqzop1WLa1ebn3hoFQJEboCWcPl0bRu8YiuNyhvRuHSRD2oK3lLCiCVxhTnOvXvMsHQ15+GYG7eoc/0OOleOIShHe+Lnzp33FD5ZWlNmXHp+am6C/7dl/5XpffV9V+19p40KD9ptpJ+uI60Z9X+9iefjKtGH5nJd5Ocg40fF3HMmPbtLoX9pcidwX1Pa+VfJHh3zw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Nuefnf2xje4g4Tsecj7wFAY2Akwzz0AA1g1Frn/Z5uI=;
 b=UmCxzUih8JGKWGzYk1BJr6/GG/glIoPf1fYLOgsArutB/TMo8nX/vOiOLkQIS4w4L3WS2sANWpFSYyvurVvi+ye/P0m+q+XvFE22fCay7PHSiTOabBvCkIooAlie9lFcwZQGt4116UN/wto3I7RWzk1juVPN+soS/fFD9kY8sQ7S75SNtXdlvhYi44qwR1Ne7vUyYGaFtCl6+Xt7hNuhpNNDwau3IgjwM6q3xzOeHUCSZeXpbcxvYFjvEf7vu/lKu4KeJHJ16BoMyrb887xgSvr7m0t3P/97Jr1vNm3a1lHg5wKkgGJBiK6HE5n4UMKRKEXVvhXjXh0uOUZibuhdIg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Nuefnf2xje4g4Tsecj7wFAY2Akwzz0AA1g1Frn/Z5uI=;
 b=RGPaDGnpzOXs2RB4HAxf/ZwYfm710th11AH9cq2q0ydqSrW/gvUGbb6ziiEQDdNxv661MIfYiyn3q5B0iBB+92nmiYlHGkGhoEMNrsFCX+nrWPU+75rS0//VtOGlecyO9ITEBYQUZoUc1XA9B4mjc1LVNjrhqpw9i+yrX0LfDEI=
Received: from CY4PR04MB3751.namprd04.prod.outlook.com (2603:10b6:903:ec::14)
 by CY4PR04MB1033.namprd04.prod.outlook.com (2603:10b6:910:54::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3283.22; Fri, 14 Aug
 2020 08:27:13 +0000
Received: from CY4PR04MB3751.namprd04.prod.outlook.com
 ([fe80::7d15:9936:4b3b:f8a2]) by CY4PR04MB3751.namprd04.prod.outlook.com
 ([fe80::7d15:9936:4b3b:f8a2%12]) with mapi id 15.20.3283.016; Fri, 14 Aug
 2020 08:27:13 +0000
From:   Damien Le Moal <Damien.LeMoal@wdc.com>
To:     "hch@infradead.org" <hch@infradead.org>
CC:     Kanchan Joshi <joshiiitr@gmail.com>, Jens Axboe <axboe@kernel.dk>,
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
Date:   Fri, 14 Aug 2020 08:27:13 +0000
Message-ID: <CY4PR04MB3751DE1ECCA4099902AABAA6E7400@CY4PR04MB3751.namprd04.prod.outlook.com>
References: <20200731064526.GA25674@infradead.org>
 <MWHPR04MB37581344328A42EA7F5ED13EE74E0@MWHPR04MB3758.namprd04.prod.outlook.com>
 <CA+1E3rLM4G4SwzD6RWsK6Ssp7NmhiPedZDjrqN3kORQr9fxCtw@mail.gmail.com>
 <MWHPR04MB375863C20C1EF2CB27E62703E74E0@MWHPR04MB3758.namprd04.prod.outlook.com>
 <20200731091416.GA29634@infradead.org>
 <MWHPR04MB37586D39CA389296CE0252A4E74E0@MWHPR04MB3758.namprd04.prod.outlook.com>
 <20200731094135.GA4104@infradead.org>
 <MWHPR04MB3758A4B2967DB1FABAAD9265E74E0@MWHPR04MB3758.namprd04.prod.outlook.com>
 <20200731125110.GA11500@infradead.org>
 <CY4PR04MB37517D633920E4D31AC6EA0DE74B0@CY4PR04MB3751.namprd04.prod.outlook.com>
 <20200814081411.GA16943@infradead.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: infradead.org; dkim=none (message not signed)
 header.d=none;infradead.org; dmarc=none action=none header.from=wdc.com;
x-originating-ip: [2400:2411:43c0:6000:28a1:79eb:9c3c:a78e]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: b3f2aec5-95de-4316-1988-08d8402bd898
x-ms-traffictypediagnostic: CY4PR04MB1033:
x-ld-processed: b61c8803-16f3-4c35-9b17-6f65f441df86,ExtAddr
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <CY4PR04MB10335C3589BBEA3C1E378294E7400@CY4PR04MB1033.namprd04.prod.outlook.com>
wdcipoutbound: EOP-TRUE
x-ms-oob-tlc-oobclassifiers: OLM:8273;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: uUIPcXKI51tmcJOP8x+IpoiWEaBdXpCOKSHZ4ejlFCXOVeTUCooTpLK17mcMWZbIgNUrkgZtDLIWTA8m/FT+cxlz50ffTndKVvCSS5ROqo5q8JSRjxl4hf2QVnGNgXLiqpNH6KqAwYGZBCTjLPzgH15GrNUnZ5hYc+ANnybWf8bEOHuRztzNJhQDEygvQED1nBTabnNMdRVqYkX+kLulZ8Y/Pjz3MyYJZcAaKZxf+7P0Zr9PvdPtCRyT2fUK17H4olBwrStnYCC7IE/zwtX+wrW+OEk0Fdz0PpAemTYZAwyJ2umV1tn3x8DzAk0e5Qy8Oag/BN0SAH2rjukOXP6VPg==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY4PR04MB3751.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(376002)(366004)(39860400002)(346002)(136003)(396003)(64756008)(76116006)(91956017)(66556008)(66476007)(66446008)(7416002)(2906002)(52536014)(5660300002)(8936002)(6916009)(66946007)(8676002)(33656002)(83380400001)(6506007)(53546011)(54906003)(7696005)(316002)(478600001)(71200400001)(9686003)(186003)(55016002)(86362001)(4326008);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: dR3Mcc58b1uHIJSUAHzaQ9b1fkCZdutxIHzUxhqF0nlXLF9srksTvlqp4lfwWCnKW0rFmtBvk+/LEPQZVAV0vPKmnGb1PjYUUXd0+ayvuxRaj4GNn1esYYm3SHA1sjfIF3fGupLGjTzCezPq9tdfgkrWqIkDoMpe85bdf2NMNeL+E3mdtIuqfvHqQ7J56QVpgMjuvCn+zr7sbbScTgOCZcEw4cF2wCQIcCaSeVgu5JpTWc14zPFUM4iw6S58tqFmzuvTOnbONBj0vVRbDX8ihWkFTTw3L7LbQoG6oelPG7/jYTjDE5xpdeyAUSlqw0C62irdgwXNsaHqMFsDHHV9yFe7fdRDOnOmGIp61bA2UDJ/yQE9j6pMekrSMM9zhiMq3qoX8jWj6qPJ34hJWSSiwSUbH1h9Zawk3Ctxjw3wEpn9r72ToK1a0ommwb3qGFNVsJdwRwxe3aTA9Pw70L6zWvnaE20GfhdQW6IR2OWUWUbBrZ0o4Y1/mrU7LrXeJe3t+e5/DNjqwQvpwcFR/HFA/VhSypxMzG44MCYS6uvnor+0SWL/C0EyMrBuRitqdBTwP7940+89oLAKYnQQ5v4wJQm6fDt4ce0oO9jZeTSk3PMpH52O4PsU8x65MmVnu66m7Y+fbqGgfA2u4M2L3+DuhKjohHXpL/P61M/MWM7vqV/9g14tRB+6dmQMZ2mvcG5moJsxRjnXpbohFsbrypzjjg==
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: CY4PR04MB3751.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b3f2aec5-95de-4316-1988-08d8402bd898
X-MS-Exchange-CrossTenant-originalarrivaltime: 14 Aug 2020 08:27:13.2884
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: r2lQ9zUUgC2hzw+B8OLSUOevj5dcZWGC66awE4RBb0COw9oIor7J92zN9ET7FPcJCtJfQsFf3wgwuyoi/FvQ2Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY4PR04MB1033
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 2020/08/14 17:14, hch@infradead.org wrote:=0A=
> On Wed, Aug 05, 2020 at 07:35:28AM +0000, Damien Le Moal wrote:=0A=
>>> the write pointer.  The only interesting addition is that we also want=
=0A=
>>> to report where we wrote.  So I'd rather have RWF_REPORT_OFFSET or so.=
=0A=
>>=0A=
>> That works for me. But that rules out having the same interface for raw =
block=0A=
>> devices since O_APPEND has no meaning in that case. So for raw block dev=
ices, it=0A=
>> will have to be through zonefs. That works for me, and I think it was yo=
ur idea=0A=
>> all along. Can you confirm please ?=0A=
> =0A=
> Yes.  I don't think think raw syscall level access to the zone append=0A=
> primitive makes sense.  Either use zonefs for a file-like API, or=0A=
> use the NVMe pass through interface for 100% raw access.=0A=
> =0A=
>>>  - take the exclusive per-inode (zone) lock and just issue either norma=
l=0A=
>>>    writes or zone append at your choice, relying on the lock to=0A=
>>>    serialize other writers.  For the async case this means we need a=0A=
>>>    lock than can be release in a different context than it was acquired=
,=0A=
>>>    which is a little ugly but can be done.=0A=
>>=0A=
>> Yes, that would be possible. But likely, this will also need calls to=0A=
>> inode_dio_wait() to avoid ending up with a mix of regular write and zone=
 append=0A=
>> writes in flight (which likely would result in the regular write failing=
 as the=0A=
>> zone append writes would go straight to the device without waiting for t=
he zone=0A=
>> write lock like regular writes do).=0A=
> =0A=
> inode_dio_wait is a really bad implementation of almost a lock.  I've=0A=
> started some work that I need to finish to just replace it with proper=0A=
> non-owner rwsems (or even the range locks Dave has been looking into).=0A=
=0A=
OK.=0A=
=0A=
>> This all sound sensible to me. One last point though, specific to zonefs=
: if the=0A=
>> user opens a zone file with O_APPEND, I do want to have that necessarily=
 mean=0A=
>> "use zone append". And same for the "RWF_REPORT_OFFSET". The point here =
is that=0A=
>> both O_APPEND and RWF_REPORT_OFFSET can be used with both regular writes=
 and=0A=
>> zone append writes, but none of them actually clearly specify if the=0A=
>> application/user tolerates writing data to disk in a different order tha=
n the=0A=
>> issuing order... So another flag to indicate "atomic out-of-order writes=
" (=3D=3D=0A=
>> zone append) ?=0A=
> =0A=
> O_APPEND pretty much implies out of order, as there is no way for an=0A=
> application to know which thread wins the race to write the next chunk.=
=0A=
=0A=
Yes and no. If the application threads do not synchronize their calls to=0A=
io_submit(), then yes indeed, things can get out of order. But if the=0A=
application threads are synchronized, then the offset set for each append A=
IO=0A=
will be in sequence of submission, so the user will not see its writes=0A=
completing at different write offsets than this implied offsets.=0A=
=0A=
If O_APPEND is the sole flag that triggers the use of zone append, then we =
loose=0A=
this current implied and predictable positioning of the writes. Even for a=
=0A=
single thread by the way.=0A=
=0A=
Hence my thinking to preserve this, meaning that O_APPEND alone will see zo=
nefs=0A=
using regular writes. O_APPEND or RWF_APPEND + RWF_SOME_NICELY_NAMED_FLAG_f=
or_ZA=0A=
would trigger the use of zone append, with the implied effect that writes m=
ay=0A=
not end up in the same order as they are submitted. So the flag name could =
be:=0A=
RWF_RELAXED_ORDER or something like that (I am bad at naming...).=0A=
=0A=
And we also have RWF_REPORT_OFFSET which applies to all cases of append wri=
tes,=0A=
regardless of the command used.=0A=
=0A=
Does this make sense ?=0A=
=0A=
=0A=
-- =0A=
Damien Le Moal=0A=
Western Digital Research=0A=
