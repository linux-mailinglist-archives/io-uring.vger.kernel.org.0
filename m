Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 913B41FFF86
	for <lists+io-uring@lfdr.de>; Fri, 19 Jun 2020 03:03:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729140AbgFSBDk (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 18 Jun 2020 21:03:40 -0400
Received: from esa2.hgst.iphmx.com ([68.232.143.124]:33800 "EHLO
        esa2.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729302AbgFSBDj (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 18 Jun 2020 21:03:39 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1592528629; x=1624064629;
  h=from:to:cc:subject:date:message-id:references:
   content-transfer-encoding:mime-version;
  bh=uTZheYLe+avvcAdr9w6H6EHKGUVcgJyqDufWzgn3UmA=;
  b=bc/da6vhnLItSYPUHM1SJob7j1ek2bIBuQ0Wg6gIf3lkAjL0NMzn3YgW
   EmbbcBINYQ7ceHOtQ5Gd6EPg5xJLfq4UX78vVC+BNwaP1ld+kQA9r/7C6
   2nUIUA6FFG1ArcCEVp0w/Ak0xc8jK0BxLMxC0Dh9Nb8DXX6F0qs24fpoq
   BIBAlFbnEhKg2C9YEaJagZ6hBy4GRjQdurDqjhjchtTDCm2+QPq8Ux/Ob
   XQ28uOIZtgEO+ylyuTdeQyTNTJlnIC1heXiROfMobZUaFa26Il8pJFoTw
   IAIkv8D/dIjQiNTYwocCIb5NdDXxAlu1/oaghmHlH7lWICK1A8Y28S4C5
   A==;
IronPort-SDR: wwbqC9msmR4iji5ztoM85AR/qaKe8O4SDMLI2dnJpt3c9Rleb/fhHBTUDB08ptf4moID1JqII0
 73aE43/5oWNWxKqROJonH4apYDaC+OVVDu1cEzuWFsrXvwDZTYYpZKNOAW89CZ8vrwUUvUgbBm
 wIE1WL53OPfEEg/jHuB4RaoJnvzqJ2tWPeY1NTTczuXT7ngcI3JMRLrxEL+FQPy0H3Ad+5yh1K
 OJq3TnTINuJRadASh8kdxnW+8nLYNlXjQwzHXjqyf6qPtmso2b59NoEkwlW6mH9WGR36UGwDcs
 zU4=
X-IronPort-AV: E=Sophos;i="5.75,253,1589212800"; 
   d="scan'208";a="243341481"
Received: from mail-bn3nam04lp2053.outbound.protection.outlook.com (HELO NAM04-BN3-obe.outbound.protection.outlook.com) ([104.47.46.53])
  by ob1.hgst.iphmx.com with ESMTP; 19 Jun 2020 09:03:46 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Q7eLf0mid6wFj6uEnnAXIiPbFZTkJs3s4fFd4DUDVCdfb/jmte9sE5LI1fawWns36pG9Coy96uCdeMYceWf9k38T6sa8aedSpCjhrNeruc+U5KWojOYSHtO0lhHVQvIORxU1TofmWI6nEFXO5NPCftOjQyDRTybczyGx7Z1oBJFrn75GMgNH6AWTndEegbar0tE2Kl54yP/kjxWZihTFwyMF3MrN+7gpNskADNjXzSIYAA1H0IQkDH0SGx7QxWpfY4pa2FspYpz4vA1ku3ur7sW3zFE796TvuAM1gn0DfBosK5GUVEqP7/NXB1QQ+hdrwKOOV0CXkf+Z1S7BrfHurg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=uTZheYLe+avvcAdr9w6H6EHKGUVcgJyqDufWzgn3UmA=;
 b=JVhPGtc5e1LR/Dzl2+WW6x5wEiJ6KzKX5nPRNU2uJithcmmlj2gqyREjMWPgr9wtuXyARJDCoNkC+GUOdO1ooSYTJqK1QAhwc85NrmbhrO+Cg9xVOAS/kz/wXJTGyfaf0Lvl4x5Xp9lj0TJeEyavqY6ZuoPpMEOpRuqCMBLPVXGwG9yO+v7EkjzdcRDuOWk9nME2+6W3wxx0g3tcYlz6AXopyNbnkhZ4dDGA8jt6PFAJ89ZWmhuOMZ1XWwfjAQGM1n+cxoi3OVdofnnHhGRb2ZancLRcZSmISbZciXIQDlRxxMjr5SCYDg+W66K4iiSWUOL0g4v4RNUqkPr9OAzyCQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=uTZheYLe+avvcAdr9w6H6EHKGUVcgJyqDufWzgn3UmA=;
 b=U+vb5uu3Eb4lf5VSsScIXq1pNTMtFp9+ry20aIuu16AsLzMpd2NEx/GwBAVh6L7CVbbWNt5tgXYAgxXo9AORdaNQHNrpr+oLTB0Oddjo2ZNG7RysCUixmh5HMg2knUT/d6zIy8V0hAnOuyR1fBfGFEVK64iIaqjqdM9moLdu3kQ=
Received: from CY4PR04MB3751.namprd04.prod.outlook.com (2603:10b6:903:ec::14)
 by CY4PR04MB1049.namprd04.prod.outlook.com (2603:10b6:910:56::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3088.24; Fri, 19 Jun
 2020 01:03:35 +0000
Received: from CY4PR04MB3751.namprd04.prod.outlook.com
 ([fe80::c593:f271:eebe:ac7]) by CY4PR04MB3751.namprd04.prod.outlook.com
 ([fe80::c593:f271:eebe:ac7%9]) with mapi id 15.20.3109.023; Fri, 19 Jun 2020
 01:03:34 +0000
From:   Damien Le Moal <Damien.LeMoal@wdc.com>
To:     =?iso-8859-1?Q?Matias_Bj=F8rling?= <mb@lightnvm.io>,
        Kanchan Joshi <joshi.k@samsung.com>
CC:     "axboe@kernel.dk" <axboe@kernel.dk>,
        "viro@zeniv.linux.org.uk" <viro@zeniv.linux.org.uk>,
        "bcrl@kvack.org" <bcrl@kvack.org>,
        "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-aio@kvack.org" <linux-aio@kvack.org>,
        "io-uring@vger.kernel.org" <io-uring@vger.kernel.org>,
        "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>,
        "selvakuma.s1@samsung.com" <selvakuma.s1@samsung.com>,
        "nj.shetty@samsung.com" <nj.shetty@samsung.com>,
        "javier.gonz@samsung.com" <javier.gonz@samsung.com>,
        Keith Busch <Keith.Busch@wdc.com>,
        Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH 0/3] zone-append support in aio and io-uring
Thread-Topic: [PATCH 0/3] zone-append support in aio and io-uring
Thread-Index: AQHWRMyErNBfEVsLrU+xBQX5pX+rOw==
Date:   Fri, 19 Jun 2020 01:03:34 +0000
Message-ID: <CY4PR04MB37518B422D0E9539DD20E8F9E7980@CY4PR04MB3751.namprd04.prod.outlook.com>
References: <CGME20200617172653epcas5p488de50090415eb802e62acc0e23d8812@epcas5p4.samsung.com>
 <1592414619-5646-1-git-send-email-joshi.k@samsung.com>
 <f503c488-fa00-4fe2-1ceb-7093ea429e45@lightnvm.io>
 <20200618192153.GA4141485@test-zns>
 <12a630ce-599b-3877-8079-10b319b55d45@lightnvm.io>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: lightnvm.io; dkim=none (message not signed)
 header.d=none;lightnvm.io; dmarc=none action=none header.from=wdc.com;
x-originating-ip: [129.253.182.57]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 7183cb54-41aa-46e8-19e8-08d813ec979c
x-ms-traffictypediagnostic: CY4PR04MB1049:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <CY4PR04MB1049F97CA6E0A677B15F50DAE7980@CY4PR04MB1049.namprd04.prod.outlook.com>
wdcipoutbound: EOP-TRUE
x-ms-oob-tlc-oobclassifiers: OLM:9508;
x-forefront-prvs: 0439571D1D
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: cXZbVURiBoiivH2Xwq06670JJfgSfKw1c8/pzIDrzREF3ywwaHjVQ0aBfpj6nhQhHfTM3CnmtHLuhVLQqt2sXlZQ0a4TzKVnxcGwpmm81R9jILjxplkG23tWreKPgkWYKx0UrOge7Ghb9vn6XS29N0s8pUth+12NPLJTaQQarE9Ua9bSjt4EwW6HJOufhyhCUrmgz956gDyeM1qW2i4/lDhMgKtVKop6lwuc0Scmjtrn8syYQUJhfMLaZz8HyHWlf52M/VbvYdqkNhqyRstbS8ag5TQWE8rFemCLEPQiAfiOiR7spARiOeEhhna0apv3gIw3geBNXLsflwIYkY3RyA==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY4PR04MB3751.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(396003)(376002)(346002)(366004)(39860400002)(136003)(83380400001)(26005)(4326008)(8676002)(316002)(55016002)(9686003)(2906002)(110136005)(478600001)(33656002)(54906003)(7696005)(8936002)(7416002)(5660300002)(76116006)(64756008)(86362001)(66446008)(71200400001)(53546011)(52536014)(66556008)(6506007)(66476007)(186003)(66946007)(91956017)(66574015);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: AAWUTBktaUQV/AML/ePrW8SzU7mjcV4cAME3Vggz72btLQ4hGbkRmSXDGj2A55/55DgBOUN37/sMFcQP4w3iKfmyE7ZBXYp90i7VnhGs3LoCIgmqb7NWWN5BePmEKm3lblGmI0tN3PGnyDvb8Mhpxuk5Zhz+6xL5mBSeIl5wFlANtmGde5W8Q9KnQE+CG4jURacgy+8Fm2oM8daTJ85gfA0vzv1T5hmo1zY+8CCjKhsnF6mIjIuTfP/+6BIpvx76dzrbZNZeWTAAK0Z1atd9VTaVmr2+iMXzLkdizWzWS5t2MV29QtcNL5BKQhUUziOWgTj4HVPKo4J/uolwDErqCxfpmyw3nCi3R0HfVQ1l08DvmdeepuoT73Tii8uWZr3hbyX5ZlNwNpt9wV5AwhVe/9qHI1IVTfcD/CWUyHHs2+iFTQMW2dQ65X4VcGX7pZ6TNoCJ+vGjDPr5MscHiZ2aMXeo0SPljXbaJt5TfymxPgJn7GwTfKuxj6ZHqifQsVK0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7183cb54-41aa-46e8-19e8-08d813ec979c
X-MS-Exchange-CrossTenant-originalarrivaltime: 19 Jun 2020 01:03:34.8525
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: Jp+Bq8GfbVHG4E39RaMW3FOWGzeMCmmlJdjFEVB/wrZEqkIff/kr1gsUm5Shn6+G0F0v8GM5H+JwgREbGjXbxw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY4PR04MB1049
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 2020/06/19 5:04, Matias Bj=F8rling wrote:=0A=
> On 18/06/2020 21.21, Kanchan Joshi wrote:=0A=
>> On Thu, Jun 18, 2020 at 10:04:32AM +0200, Matias Bj=F8rling wrote:=0A=
>>> On 17/06/2020 19.23, Kanchan Joshi wrote:=0A=
>>>> This patchset enables issuing zone-append using aio and io-uring =0A=
>>>> direct-io interface.=0A=
>>>>=0A=
>>>> For aio, this introduces opcode IOCB_CMD_ZONE_APPEND. Application =0A=
>>>> uses start LBA=0A=
>>>> of the zone to issue append. On completion 'res2' field is used to =0A=
>>>> return=0A=
>>>> zone-relative offset.=0A=
>>>>=0A=
>>>> For io-uring, this introduces three opcodes: =0A=
>>>> IORING_OP_ZONE_APPEND/APPENDV/APPENDV_FIXED.=0A=
>>>> Since io_uring does not have aio-like res2, cqe->flags are =0A=
>>>> repurposed to return zone-relative offset=0A=
>>>=0A=
>>> Please provide a pointers to applications that are updated and ready =
=0A=
>>> to take advantage of zone append.=0A=
>>>=0A=
>>> I do not believe it's beneficial at this point to change the libaio =0A=
>>> API, applications that would want to use this API, should anyway =0A=
>>> switch to use io_uring.=0A=
>>>=0A=
>>> Please also note that applications and libraries that want to take =0A=
>>> advantage of zone append, can already use the zonefs file-system, as =
=0A=
>>> it will use the zone append command when applicable.=0A=
>>=0A=
>> AFAIK, zonefs uses append while serving synchronous I/O. And append bio=
=0A=
>> is waited upon synchronously. That maybe serving some purpose I do=0A=
>> not know currently. But it seems applications using zonefs file=0A=
>> abstraction will get benefitted if they could use the append =0A=
>> themselves to=0A=
>> carry the I/O, asynchronously.=0A=
> Yep, please see Christoph's comment regarding adding the support to zonef=
s.=0A=
=0A=
For the asynchronous processing of zone append in zonefs, we need to add=0A=
plumbing in the iomap code first. Since this is missing currently, zonefs c=
an=0A=
only do synchronous/blocking zone append for now. Will be working on that, =
if we=0A=
can come up with a semantic that makes sense for posix system calls. zonefs=
 is=0A=
not a posix compliant file system, so we are not strongly tied by posix=0A=
specifications. But we still want to make it as easy as possible to underst=
and=0A=
and use by the user.=0A=
=0A=
=0A=
-- =0A=
Damien Le Moal=0A=
Western Digital Research=0A=
