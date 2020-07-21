Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F0CB622744F
	for <lists+io-uring@lfdr.de>; Tue, 21 Jul 2020 03:00:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728252AbgGUBAG (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 20 Jul 2020 21:00:06 -0400
Received: from esa1.hgst.iphmx.com ([68.232.141.245]:49520 "EHLO
        esa1.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726618AbgGUBAF (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 20 Jul 2020 21:00:05 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1595293205; x=1626829205;
  h=from:to:cc:subject:date:message-id:references:
   content-transfer-encoding:mime-version;
  bh=6Tb9B5i897n6/t4K5OuA5zEwHX1JqCR0pGAq3im9c8I=;
  b=d93TQ6W+jke6XAtQ9oDSRe05EQIWw8qXIMmcGsngDbPXJ9S1xKB4bR6B
   UfIc2XYU3ML6+VExZr7RzFN53UpAOOQGrpeNm/FIV0ox7m4/E1hVjfCIG
   gaD35H9lotQV8prJppNSfo4Zd26m+j4w+yYT37nnRzZqWHaQKGp6HRHa+
   QIkzHDHd0PVAEBDVhSS0b4F6ZQnetofVj8CQQ025U1GVQaXYW/JpmCNRF
   9flm0ChcDaWTdhxBGN6xc0nN7pnAt0hO4DmhysfZZlS8FrzADxvbsD9ZF
   tHfyOTA/rM6vJ33gnT1wVbIaz/kKoF3qrznrCawOLedLjIIQ7I5RsG6Fl
   g==;
IronPort-SDR: xer2PCHgzLrObSTorY1ECQMNYCgETlb9NXGAVQE6JR6UrxDrjb1PQhx6MEQ6p2060ayF1lE20I
 KS/ShyQsSAmAwDxzpqRtZRHIPdfUARSDXW1pxiq3PM0RxpIl7raFwTJhCoeD7x19vtO9Qd8hlh
 mUnqnCsGTYBAbDo8CMtgEjL4fexEA24rFSOG0SJAvtojU3++h8gameUe0aRgdpLiay50SN5xSG
 jAkb6Xmcr+ICdzqrlKXAcuCypttqaaIogNqVh4q/lDCOlUND+0HzNrCqxpMTRElqnhCkYobpP6
 y2U=
X-IronPort-AV: E=Sophos;i="5.75,375,1589212800"; 
   d="scan'208";a="252240659"
Received: from mail-bl2nam02lp2054.outbound.protection.outlook.com (HELO NAM02-BL2-obe.outbound.protection.outlook.com) ([104.47.38.54])
  by ob1.hgst.iphmx.com with ESMTP; 21 Jul 2020 09:00:02 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=RE2UytG2PR51yKdeDh3rhDjTAV2qjRMiEpWScIBx3Qp08dyCqk2dSv8y3PB39cUmzouU7XFJbXwuRbhHnLM3JMOHK+FDiVrmFle9UEfB8M7DDLlXsa5K8MgYVqjN9daHG82qGyYYJWlyaPuzif0POJdTBj3DL1hHKbCycBu+y6nXO650Kaf4rzXrx9gVecToTjmFHLqp9k4Hutdarc+W/x58lkVj1TMEsi8rfC7wji2b7Ab0lBlXvEFHo3qWrrZPZSUeiIoMHogXieIIKPL0g8kWmaZ2HY+YtNGBbfCEbNYieGXU47fTgn3DGIHVpnVWzAWHKCH66zRsMvItDlSYNg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Gqdckb4AQKvh8p7elmN1cyvKgQyBFIqaHPcbvJi8iHs=;
 b=kwwXNkSXOiwJo2eGtUAwO10/ov1H/gjyEiq4Fovw/ST2YbQKj+LN7wxGPzENmplD6BpE5bI6l9v1Bw5mhBvBLd8ZBN+ZjZxNXnNlMPqlc39P0RGeI002oa/I60C8CNWSYRZGsPY7ay/VUq5lVrej3Ug8knKqE1AlMIMIgKPX7dfDRSJr0kq7qhO3wkuKrMPuel7HRluoNL064E0p9kgZ7X57RXkXpv4jnSQT4sByTXynwJVC2UtP5yUvOGv14T+e94SBht5iYGORbTUp9KuJtVtLuaucHF5pjfYLmbuQofEtDShYjp59rILVoL2VVhUZdL5XkDq3sWLBBuKhiUdBHQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Gqdckb4AQKvh8p7elmN1cyvKgQyBFIqaHPcbvJi8iHs=;
 b=lxTe20lQIF+r5UzOq/NF8MkfJ0Avp8daRAYBmI25lh9HwpAgC5eaB8vEBZvkOvNLM7FomktE46upvLoX6/KwwlOJQ3pYrVeT3ZDKrHaE3bvml6a+9INMuVEAmIJqClWRBM1x45D80H9wp7yPlk9zdPiLfTmJUn11NxuF4/eOCFM=
Received: from CY4PR04MB3751.namprd04.prod.outlook.com (2603:10b6:903:ec::14)
 by CY4PR04MB1255.namprd04.prod.outlook.com (2603:10b6:910:58::35) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3195.25; Tue, 21 Jul
 2020 01:00:00 +0000
Received: from CY4PR04MB3751.namprd04.prod.outlook.com
 ([fe80::d9e5:135e:cfd9:4de0]) by CY4PR04MB3751.namprd04.prod.outlook.com
 ([fe80::d9e5:135e:cfd9:4de0%7]) with mapi id 15.20.3195.025; Tue, 21 Jul 2020
 00:59:59 +0000
From:   Damien Le Moal <Damien.LeMoal@wdc.com>
To:     Kanchan Joshi <joshiiitr@gmail.com>,
        Matthew Wilcox <willy@infradead.org>
CC:     "hch@infradead.org" <hch@infradead.org>,
        Jens Axboe <axboe@kernel.dk>,
        Kanchan Joshi <joshi.k@samsung.com>,
        "viro@zeniv.linux.org.uk" <viro@zeniv.linux.org.uk>,
        "bcrl@kvack.org" <bcrl@kvack.org>,
        "asml.silence@gmail.com" <asml.silence@gmail.com>,
        "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
        Matias Bj??rling <mb@lightnvm.io>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-aio@kvack.org" <linux-aio@kvack.org>,
        "io-uring@vger.kernel.org" <io-uring@vger.kernel.org>,
        "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>,
        Selvakumar S <selvakuma.s1@samsung.com>,
        Nitesh Shetty <nj.shetty@samsung.com>,
        Javier Gonzalez <javier.gonz@samsung.com>
Subject: Re: [PATCH v3 4/4] io_uring: add support for zone-append
Thread-Topic: [PATCH v3 4/4] io_uring: add support for zone-append
Thread-Index: AQHWUv1xEGaGdzUuiUilHzifWt+jQw==
Date:   Tue, 21 Jul 2020 00:59:59 +0000
Message-ID: <CY4PR04MB37513C3424E81955EE7BFDA4E7780@CY4PR04MB3751.namprd04.prod.outlook.com>
References: <2270907f-670c-5182-f4ec-9756dc645376@kernel.dk>
 <CA+1E3r+H7WEyfTufNz3xBQQynOVV-uD3myYynkfp7iU+D=Svuw@mail.gmail.com>
 <f5e3e931-ef1b-2eb6-9a03-44dd5589c8d3@kernel.dk>
 <CA+1E3rLna6VVuwMSHVVEFmrgsTyJN=U4CcZtxSGWYr_UYV7AmQ@mail.gmail.com>
 <20200710131054.GB7491@infradead.org>
 <20200710134824.GK12769@casper.infradead.org>
 <20200710134932.GA16257@infradead.org>
 <20200710135119.GL12769@casper.infradead.org>
 <CA+1E3rKOZUz7oZ_DGW6xZPQaDu+T5iEKXctd+gsJw05VwpGQSQ@mail.gmail.com>
 <CA+1E3r+j=amkEg-_KUKSiu6gt2TRU6AU-_jwnB1C6wHHKnptfQ@mail.gmail.com>
 <20200720171416.GY12769@casper.infradead.org>
 <CA+1E3rLNo5sFH3RPFAM4_SYXSmyWTCdbC3k3-6jeaj3FRPYLkQ@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: gmail.com; dkim=none (message not signed)
 header.d=none;gmail.com; dmarc=none action=none header.from=wdc.com;
x-originating-ip: [129.253.182.57]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 697ee685-469b-4147-7fae-08d82d116481
x-ms-traffictypediagnostic: CY4PR04MB1255:
x-ld-processed: b61c8803-16f3-4c35-9b17-6f65f441df86,ExtAddr
x-microsoft-antispam-prvs: <CY4PR04MB125568430664817147B6F12AE7780@CY4PR04MB1255.namprd04.prod.outlook.com>
wdcipoutbound: EOP-TRUE
x-ms-oob-tlc-oobclassifiers: OLM:9508;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: hE5fU0w3zhCryY8r5jJ7iQrfPiHGGL36iBZmWOHKzmgyCNXV8Vaq4EDWnumA5HYrxVnniBsYz+NVPUDOEt1hXKJbSPwl5HZ9mm6acQGCGadxLtA2Tr2EQcT9GXUrIrJpnWYifcwx2ReKvG2ys+1V1sKXXNJE4REujb4fjroMAmmtnNjHGHLLCqUNSd33CkVI8azsH6jQ9WlCVSC02/oy3rrGmz0TU7x6hcpQg43m75pgF1G2vQGcWISDq7tbghQmm2QUi8URrVbqSHTpeMlUrTluE37xkL31nf8dafBkAXUxfAWubMIIm64eV4tslHfW
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY4PR04MB3751.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(366004)(346002)(136003)(396003)(39860400002)(376002)(7696005)(316002)(33656002)(26005)(66946007)(186003)(54906003)(8936002)(5660300002)(91956017)(9686003)(6506007)(53546011)(83380400001)(110136005)(8676002)(4326008)(71200400001)(52536014)(66476007)(66556008)(64756008)(66446008)(7416002)(2906002)(55016002)(76116006)(478600001)(86362001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: yRt0mkOb+FagyyNO4iTV3m1fc8nBX4OsbUjdnPXkUY3HzETTd0CwkdzAvgvZqY20GR0QGzS6JWhe56L8oC0anE0xO7zg4Q6Bs7PeS9oKr88HdSHRJfOf5JIqqx9D0pffVtcIrJEnf+hrckgHlvEJ3evPjNuCtV49/fjyIQsIwiJE4otnmYXBE3T18pyWVLlTBy7ZUCdcCUF6H4pXR6XW4Et6Vl6aaH46wMmZD03n/A3KDQ8yhN+bGQrD3bv7gFxRjtia0jmeVpWdDHeZD+hBv6w0w4hGBtGbwKK7syfPrUGXTQYF8JzH6lBaoX9733WPA4VkFMNKyb2WXxWqeFuPSwWXuK6J6DHj3WWH9RRSGz5CkdB6YNo8bO2n4xvPOSsndRoYfbn816R4DSI0gFQbbjKxxxHA6PY3qBFp9rwFodCdd/RSpB4eKpcG1lyqSQJhvau4D89Vy53sWGvg9ufWL1hX1UlFSQ6RWD9JmRCQ4j+vyFTBeCYiuY/rl4srRKMA
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: CY4PR04MB3751.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 697ee685-469b-4147-7fae-08d82d116481
X-MS-Exchange-CrossTenant-originalarrivaltime: 21 Jul 2020 00:59:59.5078
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: GEICYzG/tZFpqYr3NnXiuCM/KWc4xxI4A23WKlKc4cxL23fk2Iv31ezFWCu8DJvf3RKge4/kXlx68G1GtvCH1A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY4PR04MB1255
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 2020/07/21 5:17, Kanchan Joshi wrote:=0A=
> On Mon, Jul 20, 2020 at 10:44 PM Matthew Wilcox <willy@infradead.org> wro=
te:=0A=
>>=0A=
>> On Mon, Jul 20, 2020 at 10:19:57PM +0530, Kanchan Joshi wrote:=0A=
>>> On Fri, Jul 10, 2020 at 7:41 PM Kanchan Joshi <joshiiitr@gmail.com> wro=
te:=0A=
>>>> If we are doing this for zone-append (and not general cases), "__s64=
=0A=
>>>> res64" should work -.=0A=
>>>> 64 bits =3D 1 (sign) + 23 (bytes-copied: cqe->res) + 40=0A=
>>>> (written-location: chunk_sector bytes limit)=0A=
>>=0A=
>> No, don't do this.=0A=
>>=0A=
>>  struct io_uring_cqe {=0A=
>>         __u64   user_data;      /* sqe->data submission passed back */=
=0A=
>> -       __s32   res;            /* result code for this event */=0A=
>> -       __u32   flags;=0A=
>> +       union {=0A=
>> +               struct {=0A=
>> +                       __s32   res;    /* result code for this event */=
=0A=
>> +                       __u32   flags;=0A=
>> +               };=0A=
>> +               __s64           res64;=0A=
>> +       };=0A=
>>  };=0A=
>>=0A=
>> Return the value in bytes in res64, or a negative errno.  Done.=0A=
> =0A=
> I concur. Can do away with bytes-copied. It's either in its entirety=0A=
> or not at all.=0A=
> =0A=
=0A=
SAS SMR drives may return a partial completion. So the size written may be =
less=0A=
than requested, but not necessarily 0, which would be an error anyway since=
 any=0A=
condition that would lead to 0B being written will cause the drive to fail =
the=0A=
command with an error.=0A=
=0A=
Also, the completed size should be in res in the first cqe to follow io_uri=
ng=0A=
current interface, no ?. The second cqe would use the res64 field to return=
 the=0A=
written offset. Wasn't that the plan ?=0A=
=0A=
-- =0A=
Damien Le Moal=0A=
Western Digital Research=0A=
