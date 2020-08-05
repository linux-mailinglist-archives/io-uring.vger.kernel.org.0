Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2C37E23C6FF
	for <lists+io-uring@lfdr.de>; Wed,  5 Aug 2020 09:35:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726439AbgHEHfe (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 5 Aug 2020 03:35:34 -0400
Received: from esa3.hgst.iphmx.com ([216.71.153.141]:65066 "EHLO
        esa3.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725981AbgHEHfd (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 5 Aug 2020 03:35:33 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1596612932; x=1628148932;
  h=from:to:cc:subject:date:message-id:references:
   content-transfer-encoding:mime-version;
  bh=J+z1I8ZPMmGYjymyRZfVPw5uHnrMEV2dueD1zGfq5Z8=;
  b=JVMl5thLJSxozDOqCHWCOI9ZKpcRiXUDQzZJc1P3D+pB69/HZ6fXb54c
   inifkM/vz1zLgitL/CvkhB+PXXC692Gj4W1j4jbYYt/m+nSYa3W0ywxKK
   NTjug0Z9Q/7FRtQ4FrwSVTrOzJqggZtvkqi9AmCOFW+yp34Ao2pZOU8UV
   12t+0ilkLhr5njlhlbjxhVDghkvfadXKHzmY6pdPfQt/gordUPZCQI0nK
   gmWUm/Z53mq6hHvjEtmlf30Mw2FvBoeV4zrlWzRU6Eo6u8E2iQryXKpNi
   CuJC88G7ll+P0ycWoWOUPUpZZx40oiTvwohXi/iCQNQSQNOYP8SKF/P/9
   A==;
IronPort-SDR: PrDjXGuBNoL9LNnDIQa3rEKCTt3Ynw1P0FMHf0wmCYu1Dl0jPQLkpuhygyRIFsPDOo1VGElf8s
 v+Nf/yLB/XosUscWu8DhbVUSbN6kJQg2AvvTPGBp00P/v9HY8FwckHXeytPJu5V/lX6e3JYy8i
 VWn7ULfa/Xiql81KtMiKvb9ECnp2KQ0u97mrVS8NMR18aBOHIMKsvLEwv1z5CJjI6cbfKszlpX
 krlcbzdZC+5bfY8RhwVT10uZRqNAH6568lqIcaALJhQKtbSeWagJCsuggYXr8taV8kgRLCsn45
 HgI=
X-IronPort-AV: E=Sophos;i="5.75,436,1589212800"; 
   d="scan'208";a="148494169"
Received: from mail-bn8nam11lp2171.outbound.protection.outlook.com (HELO NAM11-BN8-obe.outbound.protection.outlook.com) ([104.47.58.171])
  by ob1.hgst.iphmx.com with ESMTP; 05 Aug 2020 15:35:30 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=iM0Mv9JB7sKepbzK96eaFV0pyacLkNBKbqTtUPQV0SJORhlaX/ZnC7AU3SnPc4dFuGr+bcb2bit/dRruHWfd8NA++jG/NcusrCeowhtiWKAgSOcsGxbRNIvKsHyUCIyoQVOKA0Ake9VMu+VP+rNyTXFSQkDZ77vspPPB/2p6xxIkbRhoJds+6KDA5y/Oofw6nKXnvQh84x4nhXE+Yt8B8Mu4UhoDAUr+NnUkqYIJbT6cZqWYt6rVHAAdme2HPoAKJG6dEl2B6LyiPDGrOUKBsAbJKBX3IcsyqqDS8jO5Kd6hI59bZ0pYpzDlSx4AQH/khiLlYn3+5ssnbPP7HpFOag==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=eXVU9EEOq/oaekqqkXSh+ZD1Jtgh5ixXb2crzHYN3oA=;
 b=Edp5dgYmqcAs8eWhDGocN0wGvpYcaXsZA+8culSEldxXHQhjCl6pcIElOKZK/wFuJMxIezdcKNqZwYExaSZxo8g/WtoG9lI+FAWjVVLuAYhudLUVQ2Zi3iPhI4fFOKu8AUteTFJR3kZ7gstlWWcw9uc/yf+DqxdcHL7rtt26EylRWgzeN3/CM7Ibc3eS+34zh3Y/6tvoCbkOV+ddckKRWY6RzKXCVAPBLmLrfdfII44EC2biUYdQj8BiTVwyJo9ul3Gnr/0YsOzLCBXGtRm9mpgbYEzCyURvVoR8arw0OFq3JP7g4TRZrqRkuWjPlb8hFN9AMYZZ78oghLrdUtpTAg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=eXVU9EEOq/oaekqqkXSh+ZD1Jtgh5ixXb2crzHYN3oA=;
 b=PQHLuIJgjU57UlMNHABnQCaHs+HETK1Q0W2FdBZ6obLT7yc/8KOBh+14wCh0eUPuHZgtFHeV6ayNpJ0QrZe5fDexwJLAmxiXY9DTx6l2KFYpZMeJ7S2lADDlMUKI/T/Txuk9yqWuIy8vmRcLTMdrw/Vtq9F1uK1JD16kR1AN2B4=
Received: from CY4PR04MB3751.namprd04.prod.outlook.com (2603:10b6:903:ec::14)
 by CY1PR04MB2316.namprd04.prod.outlook.com (2a01:111:e400:c618::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3239.20; Wed, 5 Aug
 2020 07:35:28 +0000
Received: from CY4PR04MB3751.namprd04.prod.outlook.com
 ([fe80::7d15:9936:4b3b:f8a2]) by CY4PR04MB3751.namprd04.prod.outlook.com
 ([fe80::7d15:9936:4b3b:f8a2%12]) with mapi id 15.20.3239.022; Wed, 5 Aug 2020
 07:35:28 +0000
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
Date:   Wed, 5 Aug 2020 07:35:28 +0000
Message-ID: <CY4PR04MB37517D633920E4D31AC6EA0DE74B0@CY4PR04MB3751.namprd04.prod.outlook.com>
References: <CA+1E3rKxZk2CatTuPcQq5d14vXL9_9LVb2_+AfR2m9xn2WTZdg@mail.gmail.com>
 <MWHPR04MB3758DC08EA17780E498E9EC0E74E0@MWHPR04MB3758.namprd04.prod.outlook.com>
 <20200731064526.GA25674@infradead.org>
 <MWHPR04MB37581344328A42EA7F5ED13EE74E0@MWHPR04MB3758.namprd04.prod.outlook.com>
 <CA+1E3rLM4G4SwzD6RWsK6Ssp7NmhiPedZDjrqN3kORQr9fxCtw@mail.gmail.com>
 <MWHPR04MB375863C20C1EF2CB27E62703E74E0@MWHPR04MB3758.namprd04.prod.outlook.com>
 <20200731091416.GA29634@infradead.org>
 <MWHPR04MB37586D39CA389296CE0252A4E74E0@MWHPR04MB3758.namprd04.prod.outlook.com>
 <20200731094135.GA4104@infradead.org>
 <MWHPR04MB3758A4B2967DB1FABAAD9265E74E0@MWHPR04MB3758.namprd04.prod.outlook.com>
 <20200731125110.GA11500@infradead.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: infradead.org; dkim=none (message not signed)
 header.d=none;infradead.org; dmarc=none action=none header.from=wdc.com;
x-originating-ip: [129.253.182.57]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 7c5ee32e-3e2b-4cd0-19a8-08d83912202f
x-ms-traffictypediagnostic: CY1PR04MB2316:
x-ld-processed: b61c8803-16f3-4c35-9b17-6f65f441df86,ExtAddr
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <CY1PR04MB2316F28B05308E886B8B0B55E74B0@CY1PR04MB2316.namprd04.prod.outlook.com>
wdcipoutbound: EOP-TRUE
x-ms-oob-tlc-oobclassifiers: OLM:6790;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 1mhJCBUHxv+a7bC+ikN2LluOEd9E0Sp8YCBO5OXbLfQj9ZFqaildWPh4H6TuPA9awi+t6AHp6HcETYMHTjIKCb3ZUH9bZXluUvCFbTWkxs1d2e0m4yn0eVhZJ7n0D6j0aaEKYiyDy8/yvrPCRHI1DOGWkVVT5S385RHOBX3gkLj0SB66m3+AEwRS9+vPsGSBoZs/+VyjZoegVHN+64IxlwVmkE9q2zguZqFJ4KGx81ghnITmpKA2FZy0k419z3x5ugy6UD/FKCQ4JxOWXREWqf0VruT7aOCoSASU3QwB/1iR3UtvIz9MMXFiheO+acU1AjxGaGIAufMDzOkYvAM4Ug==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY4PR04MB3751.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(346002)(396003)(376002)(39860400002)(136003)(366004)(91956017)(5660300002)(7416002)(55016002)(76116006)(33656002)(26005)(6506007)(53546011)(86362001)(8936002)(8676002)(6916009)(83380400001)(186003)(316002)(71200400001)(52536014)(66946007)(4326008)(478600001)(7696005)(2906002)(66446008)(66476007)(64756008)(66556008)(54906003)(9686003);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: e/tPt+QkjW8ESmtNwREqozt7A9IWoLXTCKmtB05H3ZWWrMXGMwhRB6zUGUri7Rqwggp+ZDTf+aWImA8+IIncxn40+EVCSsSApCMR3VxMCdfTYIYTCreeNucPP4/gXY9sH01x7Jw9ytGS4rrdcP1vZMtvODYdU7HX1aO9O6U5OyWQ9AUdTI19tbQtkOOYxuwOMMsn/9+rHrHoIEmy3IKlut2EyH91QPlTNq5pCSWvOE3Jxh8hAIjJRsk2pfEdj8GkUUZTlTo5Ctyy5bypOhiCQjoqqaxCyUpLyG6In0v2edpDaadU3CbBzFnHr9+dynVAf9ZZHfmBX9cSOburm/rqazvboabnivcvqRRoIubUOIT0jlJmEiRbJzffHo+iNYVzRumGdTpAaKY1AUM3BWSrzg5bZH/ta7pKM3dlhNZ42DYDNiyKwoGgiMTZC1McNCA2bTC10tkU2SUakkFr4BuZfQHf4/omvQeQpWW2/LwWVXikPvfwFGJjIF1F56KR617aiJ7DDdqaTAOm2xUd5src5cBipl52KVyiejIhFAUirXWUsLUfSuwvaIo/NXVdh8b8OvqkTkALei1Q0ES0izzEX6iFRg2Ggawrbd0gIQ9GPjva4FLPJWUGJvaYJ59/W4EfHlPyrVefqrMetiQkmeOjwg==
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: CY4PR04MB3751.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7c5ee32e-3e2b-4cd0-19a8-08d83912202f
X-MS-Exchange-CrossTenant-originalarrivaltime: 05 Aug 2020 07:35:28.4097
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: BMpuCMfCv6xEvP9Wgnv2LeoOeK49oqnYXjEUrTXs8ol6jdDZh5ePnHtQ8euwoBHj6wJbj84ST4qzW2TIh3E9dA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY1PR04MB2316
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 2020/07/31 21:51, hch@infradead.org wrote:=0A=
> On Fri, Jul 31, 2020 at 10:16:49AM +0000, Damien Le Moal wrote:=0A=
>>>=0A=
>>> Let's keep semantics and implementation separate.  For the case=0A=
>>> where we report the actual offset we need a size imitation and no=0A=
>>> short writes.=0A=
>>=0A=
>> OK. So the name of the flag confused me. The flag name should reflect "D=
o zone=0A=
>> append and report written offset", right ?=0A=
> =0A=
> Well, we already have O_APPEND, which is the equivalent to append to=0A=
> the write pointer.  The only interesting addition is that we also want=0A=
> to report where we wrote.  So I'd rather have RWF_REPORT_OFFSET or so.=0A=
=0A=
That works for me. But that rules out having the same interface for raw blo=
ck=0A=
devices since O_APPEND has no meaning in that case. So for raw block device=
s, it=0A=
will have to be through zonefs. That works for me, and I think it was your =
idea=0A=
all along. Can you confirm please ?=0A=
=0A=
>> But I think I am starting to see the picture you are drawing here:=0A=
>> 1) Introduce a fcntl() to get "maximum size for atomic append writes"=0A=
>> 2) Introduce an aio flag specifying "Do atomic append write and report w=
ritten=0A=
>> offset"=0A=
> =0A=
> I think we just need the 'report written offset flag', in fact even for=
=0A=
> zonefs with the right locking we can handle unlimited write sizes, just=
=0A=
> with lower performance.  E.g.=0A=
> =0A=
> 1) check if the write size is larger than the zone append limit=0A=
> =0A=
> if no:=0A=
> =0A=
>  - take the shared lock  and issue a zone append, done=0A=
> =0A=
> if yes:=0A=
> =0A=
>  - take the exclusive per-inode (zone) lock and just issue either normal=
=0A=
>    writes or zone append at your choice, relying on the lock to=0A=
>    serialize other writers.  For the async case this means we need a=0A=
>    lock than can be release in a different context than it was acquired,=
=0A=
>    which is a little ugly but can be done.=0A=
=0A=
Yes, that would be possible. But likely, this will also need calls to=0A=
inode_dio_wait() to avoid ending up with a mix of regular write and zone ap=
pend=0A=
writes in flight (which likely would result in the regular write failing as=
 the=0A=
zone append writes would go straight to the device without waiting for the =
zone=0A=
write lock like regular writes do).=0A=
=0A=
This all sound sensible to me. One last point though, specific to zonefs: i=
f the=0A=
user opens a zone file with O_APPEND, I do want to have that necessarily me=
an=0A=
"use zone append". And same for the "RWF_REPORT_OFFSET". The point here is =
that=0A=
both O_APPEND and RWF_REPORT_OFFSET can be used with both regular writes an=
d=0A=
zone append writes, but none of them actually clearly specify if the=0A=
application/user tolerates writing data to disk in a different order than t=
he=0A=
issuing order... So another flag to indicate "atomic out-of-order writes" (=
=3D=3D=0A=
zone append) ?=0A=
=0A=
Without a new flag, we can only have these cases to enable zone append:=0A=
=0A=
1) No O_APPEND: ignore RWF_REPORT_OFFSET and use regular writes using ->aio=
_ofst=0A=
=0A=
2) O_APPEND without RWF_REPORT_OFFSET: use regular write with file size as=
=0A=
->aio_ofst (as done today already), do not report the write offset on compl=
etion.=0A=
=0A=
3) O_APPEND with RWF_REPORT_OFFSET: use zone append, implying potentially o=
ut of=0A=
order writes.=0A=
=0A=
And case (3) is not nice. I would rather prefer something like:=0A=
=0A=
3) O_APPEND with RWF_REPORT_OFFSET: use regular write with file size as=0A=
->aio_ofst (as done today already), report the write offset on completion.=
=0A=
=0A=
4) O_APPEND with RWF_ATOMIC_APPEND: use zone append writes, do not report t=
he=0A=
write offset on completion.=0A=
=0A=
5) O_APPEND with RWF_ATOMIC_APPEND+RWF_REPORT_OFFSET: use zone append write=
s,=0A=
report the write offset on completion.=0A=
=0A=
RWF_ATOMIC_APPEND could also always imply RWF_REPORT_OFFSET. ANy aio with=
=0A=
RWF_ATOMIC_APPEND that is too large would be failed.=0A=
=0A=
Thoughts ?=0A=
=0A=
-- =0A=
Damien Le Moal=0A=
Western Digital Research=0A=
