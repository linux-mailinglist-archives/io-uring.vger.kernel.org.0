Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D3A88234359
	for <lists+io-uring@lfdr.de>; Fri, 31 Jul 2020 11:35:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732181AbgGaJe4 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 31 Jul 2020 05:34:56 -0400
Received: from esa4.hgst.iphmx.com ([216.71.154.42]:12090 "EHLO
        esa4.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732136AbgGaJez (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 31 Jul 2020 05:34:55 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1596188094; x=1627724094;
  h=from:to:cc:subject:date:message-id:references:
   content-transfer-encoding:mime-version;
  bh=bM4Gg5XPcJgxEu/r5mip+jIN3imTx4BCloMfOBuu2zw=;
  b=gCRezeufNh3/yhxwCujbgpfhcysaeawuyyXf3lRflBOeVs7z/KoGkELJ
   faGhw4nuyl+HW5KnkMTBuRC3qPj8Hu5Rw1f+XBejZSrvAtSMVkMcDD8Og
   iWN7Z9tDpI8L+VxBnqKeYVG9q3S95GTFKFNjXKuEFQt0NpmToLdzmcCSk
   AAiCRHAYvybXtHKLXFoGbCcWKw1ZY3I+qDdHJlNlf6poi+gPiwfaKZ9/D
   0wOzBDAaATXu6JPLhKFYq1WEhWnS9k5n8uGVR+SVExE5Ufn+K0KhhqClR
   qIY1hWZYaMCx2De3tWhxk7Nd2KcnmEjTdtN8lfzi9O1uWu1gj14pfea82
   w==;
IronPort-SDR: qbEtWBB37A+NxFC4aDWo/Kv6FEyQA/ilS6FZNp9s+lCQvdWF/65xyXBmxwBvbF+wZQ/iOLoTwO
 1J/vdm5X2EVM0WMvU/qGn5ruO97x8ljMbNb1o4pDhjuCzvdXT7UVR9fRZ5uTb4MR8ZLzsGM3S2
 /o7Tt903OoKJKU3BxB6w7CcFTSbx0wZ/s08nJzR/MaOmWa7YNxrXi2nVy53bWW23S2IcyFVIFi
 ykjgES9CHZvWw0dCR7b9X83lAnVLMbxquS3ickIksbkZPqb6/SKuojAN9EwABc5hQoNjNmbgBD
 5iY=
X-IronPort-AV: E=Sophos;i="5.75,417,1589212800"; 
   d="scan'208";a="143828125"
Received: from mail-bl2nam02lp2059.outbound.protection.outlook.com (HELO NAM02-BL2-obe.outbound.protection.outlook.com) ([104.47.38.59])
  by ob1.hgst.iphmx.com with ESMTP; 31 Jul 2020 17:34:51 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=cvL4W6/GhGwd8tNcOOVhvlfQXR5Mbxfw/UWr5seeLHEvY+nxzH8e6l/Pz2wvpqAFTiLabF1X7+iL0E2UKXxZz1Tb8usGK3DPUA3kKLgqbiI97qh5+cMFEakJJt4MngVQMi50F0dQ24ao/F5hTdtQhx99FWLCjl7Q/9bXScv29T9vma6BZUkeFYWqX+ZrtKVm0ng1Jdf3VEOu+9Z2vKQSYPxNc7L2UK96VMYlB7eJ8AywzP9CQOu9uerIurIs3BiBnrzfa8ubD+B8Pz16PbpdpliqEa7qEJ6I3SJE3xTUEiWxpv89wq2dP7j6yB4AbmgDG9Djw2lY6s2poIyCU+5wlA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Gilc1CLecBZm2BnQA/UkGhP+bTfpEOl24OIhy+XfKTc=;
 b=CodO5S3qu7iXojadHN1SnA+WJN2MYgmDI0eo0gNV59Z8G4AW1IEm2XM7bmJuIvaw/7DA0mMEgLtq76WCQgjt6vvUQpZf4rTUqfpcyH99x0rZOi4M6EVpGlRsz09gdzg92I9BkRwkUZ4SotHaz6qioDKEhNauKIsB6ETngWOXbzVeUFFEv8VG0xME3BWMS+9zLAlWNX0yTIH2kARf2yCDqg0bPJ7YewRQgki3iBPMyFN48Sc//UkOomfA4IEGemUnbSVgJQuYjA0DGZTKolLjQA4E9kfeoLTk1hxRizE8ELtPJUMCUamtUXCcgmguDkOyJEBvqW4WGG6wjnYKSvrndw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Gilc1CLecBZm2BnQA/UkGhP+bTfpEOl24OIhy+XfKTc=;
 b=vJ8JAYQPg/0NEy1OqysUVDujCoMyIdvkpb4aDCtY5l0tdE4kkcuk3470dY+7pO3o15mH0Ew5YlmY+ukjRcLd/2a4+MBtKjjac/5Zs2emKdR4kT6i+OmO5aw49ECCQoWXS5GbEreBvEh53l21qy7qqm659sJps+ilq2J6sujsrKc=
Received: from MWHPR04MB3758.namprd04.prod.outlook.com (2603:10b6:300:fb::8)
 by MWHPR04MB0576.namprd04.prod.outlook.com (2603:10b6:300:72::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3216.20; Fri, 31 Jul
 2020 09:34:50 +0000
Received: from MWHPR04MB3758.namprd04.prod.outlook.com
 ([fe80::718a:d477:a4f1:c137]) by MWHPR04MB3758.namprd04.prod.outlook.com
 ([fe80::718a:d477:a4f1:c137%7]) with mapi id 15.20.3239.017; Fri, 31 Jul 2020
 09:34:50 +0000
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
        Johannes Thumshirn <Johannes.Thumshirn@wdc.com>
Subject: Re: [PATCH v4 6/6] io_uring: add support for zone-append
Thread-Topic: [PATCH v4 6/6] io_uring: add support for zone-append
Thread-Index: AQHWYdbcc0q15qREKECGO7brHi6zEg==
Date:   Fri, 31 Jul 2020 09:34:50 +0000
Message-ID: <MWHPR04MB37586D39CA389296CE0252A4E74E0@MWHPR04MB3758.namprd04.prod.outlook.com>
References: <65a7e9a6-aede-31ce-705c-b7f94f079112@kernel.dk>
 <d4f9a5d3-1df2-1060-94fa-f77441a89299@gmail.com>
 <CA+1E3rJ3SoLU9aYcugAQgJnSPnJtcCwjZdMREXS3FTmXgy3yow@mail.gmail.com>
 <f030a338-cd52-2e83-e1da-bdbca910d49e@kernel.dk>
 <CA+1E3rKxZk2CatTuPcQq5d14vXL9_9LVb2_+AfR2m9xn2WTZdg@mail.gmail.com>
 <MWHPR04MB3758DC08EA17780E498E9EC0E74E0@MWHPR04MB3758.namprd04.prod.outlook.com>
 <20200731064526.GA25674@infradead.org>
 <MWHPR04MB37581344328A42EA7F5ED13EE74E0@MWHPR04MB3758.namprd04.prod.outlook.com>
 <CA+1E3rLM4G4SwzD6RWsK6Ssp7NmhiPedZDjrqN3kORQr9fxCtw@mail.gmail.com>
 <MWHPR04MB375863C20C1EF2CB27E62703E74E0@MWHPR04MB3758.namprd04.prod.outlook.com>
 <20200731091416.GA29634@infradead.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: infradead.org; dkim=none (message not signed)
 header.d=none;infradead.org; dmarc=none action=none header.from=wdc.com;
x-originating-ip: [129.253.182.57]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 1dd3e151-5092-4d3d-4846-08d83534f8c7
x-ms-traffictypediagnostic: MWHPR04MB0576:
x-ld-processed: b61c8803-16f3-4c35-9b17-6f65f441df86,ExtAddr
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <MWHPR04MB0576909014EC1DC3D39CCB67E74E0@MWHPR04MB0576.namprd04.prod.outlook.com>
wdcipoutbound: EOP-TRUE
x-ms-oob-tlc-oobclassifiers: OLM:7691;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: lUliu0xoxQXWckuQqvOKh4/Ifa/18ip6aKJs9JpVMVf5asTxkkD0VFLIKvVxq8V7jxKex/zx+5w0uJaYWEXX3hpE/PkxUOP9jwc32Mzxnt0NGHVrc1eoZScQJjmJA07Ba8rdkS7aEb9yu6GAL6mUIpcVJ67mgrXJ2W/TxSTrNauPpvo72QzuPdj4JGdbLLTTMGAmUPl/r4zCHiqtUYyYJyJJWuBTjzj5KkefKFWYlGT/euyHJr0ihPRnlTnWzX4Zp98ju183IbOdUQBY/gdHRy2DURqbuwMd6qBN3j8gojkaZL73+ivmtGT3cU/sXJ+m7Gmg59nC9UCmy0PpWQubTg==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR04MB3758.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(39860400002)(396003)(376002)(136003)(346002)(366004)(55016002)(54906003)(8676002)(316002)(7696005)(53546011)(6506007)(33656002)(7416002)(9686003)(52536014)(5660300002)(91956017)(4326008)(66476007)(64756008)(66946007)(66446008)(76116006)(86362001)(71200400001)(66556008)(8936002)(478600001)(2906002)(26005)(83380400001)(186003)(6916009);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: m7KaDbYs2ze1NN+AXVY+f4/EuoW0mdMXtjmw3MS7qlpFFV4PfmUFo2d7kku0kIOTgcrFI+QxInuNVj5bD2Zmwi2Se/XM92QD1jDH2rY1adcZTVeV3OaWJfs0PSqHAOv+zecjKbRzkCk3gJCwPznwmCERhZzWCpx5aYt8EToT3BpqyGDfdALNCzAxdCObDJpYTzGJ7MQ3m+po9FVNPMuzrV1fzjPSOLVrCJpG8RmtGEWuYoXNjJ4nE/1sXzNV7WJzLS2dRmj+9bcqKKRdSRc01DxLZ8swoRAWhJ+f4IYqLQSgbo0ZNbc8gXOlVlSLbSjh5IU7Qx9h8wX7r/gD0uJ7EXl1wwmSP5jcsUe93w3ai3le6bpVJsOn7LetzQ2A+/sqiThjU0jNzeYL5m0ANxo8GAn4e6AoM2i0izVL4tbvcdqDsNQbzrLFPH9Bb3wiOKYfnQ/lh3zX9X3W2YwxJRuELTMg24OBxnEiDs5nklU5tT65G0Ar0HjoNA9qa/x/41K6
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MWHPR04MB3758.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1dd3e151-5092-4d3d-4846-08d83534f8c7
X-MS-Exchange-CrossTenant-originalarrivaltime: 31 Jul 2020 09:34:50.0466
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: AJohajFNoekyP6chzkPBcSLZbZu0Xny3OoH+T/pf6oKBEbZyT2XWpcT2cFS+NIlgoNx+fqTXebcQeMNe2mSsMg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR04MB0576
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 2020/07/31 18:14, hch@infradead.org wrote:=0A=
> On Fri, Jul 31, 2020 at 08:14:22AM +0000, Damien Le Moal wrote:=0A=
>>=0A=
>>> This was one of the reason why we chose to isolate the operation by a=
=0A=
>>> different IOCB flag and not by IOCB_APPEND alone.=0A=
>>=0A=
>> For zonefs, the plan is:=0A=
>> * For the sync write case, zone append is always used.=0A=
>> * For the async write case, if we see IOCB_APPEND, then zone append BIOs=
 are=0A=
>> used. If not, regular write BIOs are used.=0A=
>>=0A=
>> Simple enough I think. No need for a new flag.=0A=
> =0A=
> Simple, but wrong.  Sync vs async really doesn't matter, even sync=0A=
> writes will have problems if there are other writers.  We need a flag=0A=
> for "report the actual offset for appending writes", and based on that=0A=
> flag we need to not allow short writes (or split extents for real=0A=
> file systems).  We also need a fcntl or ioctl to report this max atomic=
=0A=
> write size so that applications can rely on it.=0A=
> =0A=
=0A=
Sync writes are done under the inode lock, so there cannot be other writers=
 at=0A=
the same time. And for the sync case, since the actual written offset is=0A=
necessarily equal to the file size before the write, there is no need to re=
port=0A=
it (there is no system call that can report that anyway). For this sync cas=
e,=0A=
the only change that the use of zone append introduces compared to regular=
=0A=
writes is the potential for more short writes.=0A=
=0A=
Adding a flag for "report the actual offset for appending writes" is fine w=
ith=0A=
me, but do you also mean to use this flag for driving zone append write vs=
=0A=
regular writes in zonefs ?=0A=
=0A=
The fcntl or ioctl for getting the max atomic write size would be fine too.=
=0A=
Given that zonefs is very close to the underlying zoned drive, I was assumi=
ng=0A=
that the application can simply consult the device sysfs zone_append_max_by=
tes=0A=
queue attribute. For regular file systems, this value would be used interna=
lly=0A=
only. I do not really see how it can be useful to applications. Furthermore=
, the=0A=
file system may have a hard time giving that information to the application=
=0A=
depending on its underlying storage configuration (e.g. erasure=0A=
coding/declustered RAID).=0A=
=0A=
=0A=
=0A=
-- =0A=
Damien Le Moal=0A=
Western Digital Research=0A=
