Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6EC80233F95
	for <lists+io-uring@lfdr.de>; Fri, 31 Jul 2020 09:00:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731547AbgGaHAO (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 31 Jul 2020 03:00:14 -0400
Received: from esa5.hgst.iphmx.com ([216.71.153.144]:39092 "EHLO
        esa5.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731572AbgGaG7u (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 31 Jul 2020 02:59:50 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1596178790; x=1627714790;
  h=from:to:cc:subject:date:message-id:references:
   content-transfer-encoding:mime-version;
  bh=9CpsMgBHq9VYBvidyhoQ4MvqAsHK3mqMI8EE8wIrVD0=;
  b=ScmkLQdvP8Djv9HVTyObwJ4jdYKMHH1GxSJH6Yj/o/RgOo35rGQrQjwk
   01LU4eXtaV9+ixBo/tOw/T0TJeqPI6FX1/f0rZVbiqPmW0mdI380Gdd1b
   uLdUG1C8AiW2o0sQgA3jMu+WHLM4RXgT5QrPDt/P9tiB42YXtP74zLCk4
   WjSmabVves7G1XfWb6tBc8YyIBexxWt+aLAE55fJnAW+tv4lU6sUN7Nx1
   sPlRQsMoTNLIemwCgmqtHUVeRqCp1COoydqPH5N6zmWTaXwljFGM48+/I
   oKmw1WbzCHYfCtzw/KXSJ9EW9300mJGl8O6JzXQ6WKXiGctikO7IxS5ss
   w==;
IronPort-SDR: zohnI3JABE59zJCqLsBnOG/sQbDFyXRrXDs3gLkA3dlsEb7L3EljuXQ9khAmW80ZGsrz3fCv99
 qIKiY6vxijYojAcH9CZFCyp3DcphWBRq04PGe3VLnvrGqVtpqrBjtKjfxKl4157rW6FAsoC/ER
 TAqd94vP0Vjln8940EfS2JMP6i4sfDwafoD8kYd6Yqj54TR3v18x4YHHRsQqGKQUxEDoQ3RkEt
 tH0WterxITJwPMyRTvVdm+3zVwbFNxQGeH+q74ZcFf6zJFbqnnH8bOKellFnkfUw2ApADpA9Xg
 y/o=
X-IronPort-AV: E=Sophos;i="5.75,417,1589212800"; 
   d="scan'208";a="143903671"
Received: from mail-sn1nam02lp2056.outbound.protection.outlook.com (HELO NAM02-SN1-obe.outbound.protection.outlook.com) ([104.47.36.56])
  by ob1.hgst.iphmx.com with ESMTP; 31 Jul 2020 14:59:48 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=dhfdnHFsc/5WssPTscfmlkJJDt9nf1NfJgfOy07HSFiwpLp/f8BGlQZMKZr0MnouTGc3TlovbMNdMFBrhGJRKd5vlraInCBxN9sSUz5Dn1bhBRg0xoxtIL5IPZS3p4CJJlqY6ZdLdDIAd67cyqSdAEqjXFfZKnRH5ArKSUMVtBy9m9gVF9V7ciXpyYcApqVTBq6+O+vpy6Bjcqhh2Jqlp6GQdgjGbK9RwhbaehewvETGbz/YChxBRXma2xFr1DPzRykk77bwtJg4NpNoZTg2YO5BYnLBmFUmGzUNXSn2khpCTViZVWeyiBWh+GaDMNKXcafs+P+5WtAcWkP/9jCRYw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=VHofBGPchJ3wPpn3RBb8zlBcgYl7N7un/W9/Wq4tKpg=;
 b=AdM80lmyWuAF2i7Rw8jWc59GKx2ZjV+b6MKzllQEHkA/ypqotLOAHOZAagNs9mVZVUQVmXM+6Bi/IOQodvrHXgEdW+8nB9/OBrukUwxmGlHi6QFxI8+NhZmDHO9KLObtUjI9qD8p6O/mVGCLBiAcv3YZn97r/x7A4hC5kQCxBWecg4CHdxF/VE8e31hXKPt9Q922MFF3cAe6YQUonphXk0krlDifUgr6yCVde3abeguYE+M85Ewj9V7bhCbZkrqvZ6PzMakfvMW1zC6rqPQbmaP/PKRtqRa9aNXKzNs/Z6X/y35Td7cuCbwU2aQ3CXO4Kju3yw1bMfxO9L0rmfI94Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=VHofBGPchJ3wPpn3RBb8zlBcgYl7N7un/W9/Wq4tKpg=;
 b=upaN17NRRcedLapmTMQIl5KWqBwfiAYj878rueO2oU7d8Vqb4ekk2Jp1JkIMYgCMyLXR7x2CCAKBjdh5gxBlJ9Bbj1SvrTfIGVberpCRSlXArqgp3RnW8tKr55chDqBY7cNgFlQ3i28EE6AMkO8ELgwMipdPT3UATsWuYt5RM9E=
Received: from MWHPR04MB3758.namprd04.prod.outlook.com (2603:10b6:300:fb::8)
 by MWHPR0401MB3690.namprd04.prod.outlook.com (2603:10b6:301:7c::36) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3216.27; Fri, 31 Jul
 2020 06:59:46 +0000
Received: from MWHPR04MB3758.namprd04.prod.outlook.com
 ([fe80::718a:d477:a4f1:c137]) by MWHPR04MB3758.namprd04.prod.outlook.com
 ([fe80::718a:d477:a4f1:c137%7]) with mapi id 15.20.3239.017; Fri, 31 Jul 2020
 06:59:45 +0000
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
        Javier Gonzalez <javier.gonz@samsung.com>
Subject: Re: [PATCH v4 6/6] io_uring: add support for zone-append
Thread-Topic: [PATCH v4 6/6] io_uring: add support for zone-append
Thread-Index: AQHWYdbcc0q15qREKECGO7brHi6zEg==
Date:   Fri, 31 Jul 2020 06:59:45 +0000
Message-ID: <MWHPR04MB37581344328A42EA7F5ED13EE74E0@MWHPR04MB3758.namprd04.prod.outlook.com>
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
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: infradead.org; dkim=none (message not signed)
 header.d=none;infradead.org; dmarc=none action=none header.from=wdc.com;
x-originating-ip: [129.253.182.57]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 49c1687e-6dc7-4614-28d7-08d8351f4f03
x-ms-traffictypediagnostic: MWHPR0401MB3690:
x-ld-processed: b61c8803-16f3-4c35-9b17-6f65f441df86,ExtAddr
x-microsoft-antispam-prvs: <MWHPR0401MB36903E16FC03944744043A27E74E0@MWHPR0401MB3690.namprd04.prod.outlook.com>
wdcipoutbound: EOP-TRUE
x-ms-oob-tlc-oobclassifiers: OLM:10000;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: qWHfSirrLB5R96wjjw0emvqvfwaQo79IxwUPYV6TyRdUDWXJrhTW1xLRlNNmkvoqGs9GFsIs4lDtxYnQqD1+Ht6HRN4v0/7S9dU9oDP/y9TzitZiP/FLGJuptXcsjcPqIXzR2F3KObr6QBZ//XheVjNqrXMzQmN+uY1FqA5Et5CcgEXur8ueHWl93YxiXOqs35aFavmMpohtex1pFLdCReLmr/jJuEMcUigEnUvP879Z7Ev0M/fWvP2OtCdsu6r20Sd13sO90Wr36y4zDYromPZfXXwMCPKPoaxAyMDqACckqun29TflBVGlO9RYr5o16ytNiqiN0V40uEvCn3ZHlQ==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR04MB3758.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(136003)(366004)(39860400002)(376002)(396003)(346002)(316002)(66476007)(9686003)(53546011)(6506007)(64756008)(26005)(5660300002)(186003)(2906002)(33656002)(91956017)(52536014)(76116006)(55016002)(66556008)(66946007)(66446008)(6916009)(54906003)(4326008)(8936002)(83380400001)(8676002)(86362001)(71200400001)(7696005)(7416002)(478600001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: uTq0oLVTZXSZGs1hy3Y+nCWaBsfhGUz5nT2ug0aSZk9/6loV/W+BzPyYYxCNF3K1TqHgJdefmM/NhNsbw9BGsjvGqzofQ21w/zqGyl9AcfGDj5mX1VVmcUcYMVsr9AaF2bO2VjYcjCo363h0f4C0BRhUta3bSgUIlgDPUNQmMHbz5URuojuQwX0Sy6fFkzycCTjn8XkHHIvZ2Jhf0EnJmijb5Rbc8xqyKdQZbvjwnYrsGeviER926oxCjC/Zos099KOEXWZS/8ZMzLjFR3CZL/wVsi6tws1/lE57eojjlY60R9eERgJF6g6+0i1+2nKzDwazTcV1XnvgPdZ9n2xF6lrIceiRNBmf6MRC78tDqxjHkbMD5jiOZ5lmCoKHT9fN8r2HfFxVfZGBU6gBtnMG1zaPxBORwEeTrTsbQPQZe7OQOuag0PFATjJzs5io4OF5o9MVJ5XeYYIZGItBg56zFhDrExa2gA2WWGE31DgfZmyPcRG37AfBRrz+jl5apCJp
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MWHPR04MB3758.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 49c1687e-6dc7-4614-28d7-08d8351f4f03
X-MS-Exchange-CrossTenant-originalarrivaltime: 31 Jul 2020 06:59:45.7471
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: AvboYHtrLbKs+86+TxmHj1OAmoe5H16sB2Y4gTL81Gq38qACI/xWh0GE6Do0Pc4jOhXPC+5B+BVEca62htty/A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR0401MB3690
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 2020/07/31 15:45, hch@infradead.org wrote:=0A=
> On Fri, Jul 31, 2020 at 06:42:10AM +0000, Damien Le Moal wrote:=0A=
>>> - We may not be able to use RWF_APPEND, and need exposing a new=0A=
>>> type/flag (RWF_INDIRECT_OFFSET etc.) user-space. Not sure if this=0A=
>>> sounds outrageous, but is it OK to have uring-only flag which can be=0A=
>>> combined with RWF_APPEND?=0A=
>>=0A=
>> Why ? Where is the problem ? O_APPEND/RWF_APPEND is currently meaningles=
s for=0A=
>> raw block device accesses. We could certainly define a meaning for these=
 in the=0A=
>> context of zoned block devices.=0A=
> =0A=
> We can't just add a meaning for O_APPEND on block devices now,=0A=
> as it was previously silently ignored.  I also really don't think any=0A=
> of these semantics even fit the block device to start with.  If you=0A=
> want to work on raw zones use zonefs, that's what is exists for.=0A=
=0A=
Which is fine with me. Just trying to say that I think this is exactly the=
=0A=
discussion we need to start with. What interface do we implement...=0A=
=0A=
Allowing zone append only through zonefs as the raw block device equivalent=
, all=0A=
the O_APPEND/RWF_APPEND semantic is defined and the "return written offset"=
=0A=
implementation in VFS would be common for all file systems, including regul=
ar=0A=
ones. Beside that, there is I think the question of short writes... Not sur=
e if=0A=
short writes can currently happen with async RWF_APPEND writes to regular f=
iles.=0A=
I think not but that may depend on the FS.=0A=
=0A=
=0A=
-- =0A=
Damien Le Moal=0A=
Western Digital Research=0A=
