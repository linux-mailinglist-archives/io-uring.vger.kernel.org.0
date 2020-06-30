Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 026D220EA54
	for <lists+io-uring@lfdr.de>; Tue, 30 Jun 2020 02:37:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728062AbgF3AhU (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 29 Jun 2020 20:37:20 -0400
Received: from esa1.hgst.iphmx.com ([68.232.141.245]:49489 "EHLO
        esa1.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726899AbgF3AhT (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 29 Jun 2020 20:37:19 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1593477438; x=1625013438;
  h=from:to:cc:subject:date:message-id:references:
   content-transfer-encoding:mime-version;
  bh=94NUDgzJspE7b79qyazCkvEL33BuRqQhjDStP5FN1dc=;
  b=bOcYeEklb+QyfMMwnT4Sj46lvFq8mtdaTD8j60myjJMilD/AGUpRMPhU
   K4Ji8mQR+aCWoOOvMyCqSErGrxt5uTVG7XxFCVSG0rFUXdgJTlJg4U3IV
   KZRvm1wHjTUmvLqmpdLK1sO9zdi9ohCDWUanST55ZWDu9o5QGzCRK2qaO
   3qEYCze/qbosH9YXLQHkDV1pPuNNTL1ZERoyt3AFmax0294ofxPZ33QUb
   ovGASq+vPa8KT1zPVrTC/tXfgVVjjHdxaB0dWz+Ge+3Bl4nmeltoctEOM
   eRr0Ovcx/RA3WxVqM27hZxAoXZAYbOvLyKMjfEJT/LangFk+Hc4LUMwNC
   g==;
IronPort-SDR: sposJSDnpqD2+AfkM7QGhoy7wktazGegbadBcxRnQ7CObY09ddd45BRsrS7PcAc4BtwWKrsHA3
 D8523uS1uatlt56fgrJ8dIKQSjR19nTkeSj/dmofy7kuM8UZkEZwh05Bo0ZUrfVAV9qJbbWZUN
 RrEPVsvnXT9s7AGllA+RK33YhJGsRB2/lxoJh+f5zTz2kDaOkOKGitmCysmBcxLmvND39GV0Ur
 drTpV5KjCteegudDrNm3/oGxdK/x3jgQuAAYUGC8v0TCwjxdrai5o8SlPW3mzRNHL3h7Am2h6p
 tz0=
X-IronPort-AV: E=Sophos;i="5.75,296,1589212800"; 
   d="scan'208";a="250458418"
Received: from mail-mw2nam10lp2103.outbound.protection.outlook.com (HELO NAM10-MW2-obe.outbound.protection.outlook.com) ([104.47.55.103])
  by ob1.hgst.iphmx.com with ESMTP; 30 Jun 2020 08:37:08 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=QDOSx3AA/ZPClhIiXaULlUf9ryVriGzZTqRZSjZyBE3WuFFuHBtQwO00sa1EDi/mUGGkH1G5vcjgZ9gpn7+nidc72+rseuukESVPQucxegEB9i/pVZ9sp9YF0ZHnRPb2tLdb1A4FjyFdMWtLNXUhTjGuuKpkCnUnNsVHFJhMQIOPaUkM0HgE9rx8MVL+kh5GK4IXTfnr/KS9oO/TyyxRfH3yvlZfCy086ZeEp3duLNcHkHZ9L2m9vqWlJWyrKi/XoQRrbJNJrAPGZr+DKdx62Dpjum3l5NyuK6Au9Md1R3M4PsmDZ/OWBp+yclEu/elEUFK4hzYjlULZ5n06moHlLQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=YmWMQOVuaFcY8lbgjPkNm3PlxqZ43HAmsT1qfOpFgGE=;
 b=AV/exT0i9E78ThAM9Y/PMCtIZfMkIeXE4v9uRU+4krE3iw40fOwPKc8R6j7A4XIsIjBXwR8YOROAP/QaipROCJrzhm2EUe1EsM54y8qG9a09ILsek8Ko7k1xhuFRXW7g0bCNnIA94kofS3pDYZ3xgEYioCuofDEsbZPyGUxaKJKoP1D0ayC/sQ1m67ByHv5nOd9h85dcHJDKLbyoy/eawW9LVEaVBV5jHV+qjE2VO4ah8sut5Lx8+eqANvg1j5w45m4j7d9M9qSpYpUxRk6XeQnr/vQYPIfufAcE7YJJWKIddBF+lIOT8kD46+oDuUfa++iyDF0F9rs8qFvoqx4EQw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=YmWMQOVuaFcY8lbgjPkNm3PlxqZ43HAmsT1qfOpFgGE=;
 b=DNck0QxCwbui6MA+3joqNcGffS/Vgltz87i2RjnssCLTB0qKTksdn2gSXfRXSBNwyfbMp0XBp43mCQJ3MRaAoHQNfdDPWRwrUzUDpL/NC9+hNzYVE37tNTveIPxGcHYJJqn6tHzSBw7tkb7LVA8Sv1umoPMwLXy59amBEr6zfmQ=
Received: from CY4PR04MB3751.namprd04.prod.outlook.com (2603:10b6:903:ec::14)
 by CY4PR0401MB3585.namprd04.prod.outlook.com (2603:10b6:910:8a::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3131.25; Tue, 30 Jun
 2020 00:37:07 +0000
Received: from CY4PR04MB3751.namprd04.prod.outlook.com
 ([fe80::c593:f271:eebe:ac7]) by CY4PR04MB3751.namprd04.prod.outlook.com
 ([fe80::c593:f271:eebe:ac7%9]) with mapi id 15.20.3131.024; Tue, 30 Jun 2020
 00:37:07 +0000
From:   Damien Le Moal <Damien.LeMoal@wdc.com>
To:     Kanchan Joshi <joshi.k@samsung.com>
CC:     "axboe@kernel.dk" <axboe@kernel.dk>,
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
        "nj.shetty@samsung.com" <nj.shetty@samsung.com>,
        "javier.gonz@samsung.com" <javier.gonz@samsung.com>,
        Arnav Dawn <a.dawn@samsung.com>
Subject: Re: [PATCH v2 1/2] fs,block: Introduce RWF_ZONE_APPEND and handling
 in direct IO path
Thread-Topic: [PATCH v2 1/2] fs,block: Introduce RWF_ZONE_APPEND and handling
 in direct IO path
Thread-Index: AQHWSxStAvYl2c5t2kCK+9TjcP8ZXw==
Date:   Tue, 30 Jun 2020 00:37:07 +0000
Message-ID: <CY4PR04MB3751213DD4B370F58A63368BE76F0@CY4PR04MB3751.namprd04.prod.outlook.com>
References: <1593105349-19270-1-git-send-email-joshi.k@samsung.com>
 <CGME20200625171834epcas5p226a24dfcb84cfa83fe29a2bd17795d85@epcas5p2.samsung.com>
 <1593105349-19270-2-git-send-email-joshi.k@samsung.com>
 <CY4PR04MB37511FB1D3B3491A2CED5470E7930@CY4PR04MB3751.namprd04.prod.outlook.com>
 <20200629183202.GA24003@test-zns>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: samsung.com; dkim=none (message not signed)
 header.d=none;samsung.com; dmarc=none action=none header.from=wdc.com;
x-originating-ip: [199.255.47.5]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 06c0ab7e-e7ad-4f1d-95f1-08d81c8db7fa
x-ms-traffictypediagnostic: CY4PR0401MB3585:
x-ld-processed: b61c8803-16f3-4c35-9b17-6f65f441df86,ExtAddr
x-microsoft-antispam-prvs: <CY4PR0401MB3585E746C1667BE5EF95E1CFE76F0@CY4PR0401MB3585.namprd04.prod.outlook.com>
wdcipoutbound: EOP-TRUE
x-ms-oob-tlc-oobclassifiers: OLM:6790;
x-forefront-prvs: 0450A714CB
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: EoUGPV2yBxHBw0/h/paCK4uYcE7z8n7FVtRM2fV4owbRZoDfIoMq2iKAAL/48xcSkclB9XxWWyEw5xBK3WxM1fV4AQsRyEgAzUnipAIxl7y4/3YTukIYuAUo0ilzhijtvGJ1gPezccsbRoyxftixXCfkVcFDg/B9OD2/wXBXcdZIYFbBI2gl2kRHJS94QpqFk7KleTyg2NaK8CiKopiiLHoVHgWdRhZ9e1ER1SYWbG+gjfVoPU5VDhzvNTCA2LA3qq+sz0tUAuKlAsQy8KdhsUkoBjlX/Ssk72K/6jivps+FJkIn+bzViMIcUZK3ww2phNinDaudASzbzXep3z4o+gAOuwpilugWvdk0HBxTBX5KrXqmA9UcuWHtX3zRcgfB
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY4PR04MB3751.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(346002)(396003)(136003)(376002)(39860400002)(366004)(83380400001)(6506007)(7696005)(53546011)(54906003)(316002)(76116006)(66446008)(64756008)(66556008)(66476007)(91956017)(6916009)(66946007)(186003)(26005)(71200400001)(8676002)(86362001)(2906002)(7416002)(8936002)(478600001)(4326008)(55016002)(9686003)(5660300002)(33656002)(52536014)(142933001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: YVDMOcQMkUGnfQOllFEvDD9szp+s9u8RH8YfNL71McptW2FPQ5ur/wAuq+PJipwiaR07OIU1BiulHYNUEjBBJTSa/4IupbxwuvI/xSxmZz5oiotN/HSKKB3QTWs/R4gZNK3X7aUlGPpoXiYBZTzTT3LiOVHgLzonBgfD3XtkrkmDQAysq7DBCVkMGZfUFs36pdZLKJPfFc0yhplrWg7bdO3dqtDfoqo9+z7CxbQskrWdREYKiObvf/jLHYn5xezXOYUL8QXcJWwImrV+zaAI69jJ1U+Na2A3CPh1MTMb3dLJ0CMSJWrOrf2tueXgz8ajOW0g+bF9k0gr9G46dMhb+IWGBW9AqqiXw0fJz5GxDHbAj85t85U+ey4M0bySSyy/mArredG1bhVDzE5F8WwTSgeVwBjXjkqgktGLPqCEzHPc7WNDs6tl3x5j7KJSggoylMIcyjSG4F5lizlvN2RXVHGynhseriB2PvlFpdRrvaQ=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: CY4PR04MB3751.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 06c0ab7e-e7ad-4f1d-95f1-08d81c8db7fa
X-MS-Exchange-CrossTenant-originalarrivaltime: 30 Jun 2020 00:37:07.4924
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: KFosDTofffRpTi5froaY52jK4ofSFaOlAAbrtFaQhLhETQ7ZneeS8S1PIaryU9ZTCZXlmhU6wisvo/mRwyffTw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY4PR0401MB3585
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 2020/06/30 3:35, Kanchan Joshi wrote:=0A=
> On Fri, Jun 26, 2020 at 02:50:20AM +0000, Damien Le Moal wrote:=0A=
>> On 2020/06/26 2:18, Kanchan Joshi wrote:=0A=
>>> Introduce RWF_ZONE_APPEND flag to represent zone-append. User-space=0A=
>>> sends this with write. Add IOCB_ZONE_APPEND which is set in=0A=
>>> kiocb->ki_flags on receiving RWF_ZONE_APPEND.=0A=
>>> Make direct IO submission path use IOCB_ZONE_APPEND to send bio with=0A=
>>> append op. Direct IO completion returns zone-relative offset, in sector=
=0A=
>>> unit, to upper layer using kiocb->ki_complete interface.=0A=
>>> Report error if zone-append is requested on regular file or on sync=0A=
>>> kiocb (i.e. one without ki_complete).=0A=
>>>=0A=
>>> Signed-off-by: Kanchan Joshi <joshi.k@samsung.com>=0A=
>>> Signed-off-by: SelvaKumar S <selvakuma.s1@samsung.com>=0A=
>>> Signed-off-by: Arnav Dawn <a.dawn@samsung.com>=0A=
>>> Signed-off-by: Nitesh Shetty <nj.shetty@samsung.com>=0A=
>>> Signed-off-by: Javier Gonzalez <javier.gonz@samsung.com>=0A=
>>> ---=0A=
>>>  fs/block_dev.c          | 28 ++++++++++++++++++++++++----=0A=
>>>  include/linux/fs.h      |  9 +++++++++=0A=
>>>  include/uapi/linux/fs.h |  5 ++++-=0A=
>>>  3 files changed, 37 insertions(+), 5 deletions(-)=0A=
>>>=0A=
>>> diff --git a/fs/block_dev.c b/fs/block_dev.c=0A=
>>> index 47860e5..5180268 100644=0A=
>>> --- a/fs/block_dev.c=0A=
>>> +++ b/fs/block_dev.c=0A=
>>> @@ -185,6 +185,10 @@ static unsigned int dio_bio_write_op(struct kiocb =
*iocb)=0A=
>>>  	/* avoid the need for a I/O completion work item */=0A=
>>>  	if (iocb->ki_flags & IOCB_DSYNC)=0A=
>>>  		op |=3D REQ_FUA;=0A=
>>> +=0A=
>>> +	if (iocb->ki_flags & IOCB_ZONE_APPEND)=0A=
>>> +		op |=3D REQ_OP_ZONE_APPEND;=0A=
>>=0A=
>> This is wrong. REQ_OP_WRITE is already set in the declaration of "op". H=
ow can=0A=
>> this work ?=0A=
> REQ_OP_ZONE_APPEND will override the REQ_WRITE op, while previously set o=
p=0A=
> flags (REQ_FUA etc.) will be retained. But yes, this can be made to look=
=0A=
> cleaner.=0A=
> V3 will include the other changes you pointed out. Thanks for the review.=
=0A=
> =0A=
=0A=
REQ_OP_WRITE and REQ_OP_ZONE_APPEND are different bits, so there is no=0A=
"override". A well formed BIO bi_opf is one op+flags. Specifying multiple O=
P=0A=
codes does not make sense.=0A=
=0A=
-- =0A=
Damien Le Moal=0A=
Western Digital Research=0A=
