Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 79478227586
	for <lists+io-uring@lfdr.de>; Tue, 21 Jul 2020 04:19:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726705AbgGUCTH (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 20 Jul 2020 22:19:07 -0400
Received: from esa1.hgst.iphmx.com ([68.232.141.245]:55666 "EHLO
        esa1.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726042AbgGUCTH (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 20 Jul 2020 22:19:07 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1595297946; x=1626833946;
  h=from:to:cc:subject:date:message-id:references:
   content-transfer-encoding:mime-version;
  bh=d/jr3mqmrPDcHtydREmtm/Ogsdyk4U0CVRw/4fKXKzI=;
  b=oYanvhFNGf7eeacpi1lVj+S179qibMWbgqIEYIoYuLoz8J80QljlHvFM
   IyO0pP1oyv97l8EohTUY+7eWxA7hatFjpihgXWIek0sDGaTZ8juNIwboG
   HcrVJVnx6x1POKwqIFXB6sh43fFTMZt29r0Oi3/148k1zxz/TWkcoTs6k
   rBITUtrH84Uu9G0D0wZu5+hLGqtgGWmD+EVsNVANKEv+lsYlVkAE00uGM
   MBux/X3s8EzgIZOhHVyfDPAxRVVNtLP24tzUBHchU14oQUXPErJxnLxZ5
   9CvD20nbW2qoQmUg8dtjL9XKgTRPjypm1sUcCBnkpO9UQkalFODiTgtXm
   Q==;
IronPort-SDR: IMasm45IrxfmgBkR1INEaDQbODV27Nm5xjh2IO804RshWmjNk0kRLzbVIpIUXG39d3nR0GAEIe
 oQxFWkdCbTw1ihjZbMMC5Y5TNDC/27Y4ffQ8pX4rn1hq7z35CpXj0i6HZjkdy+1t08vZtELRBL
 2oh7wTSz00Lja27a/itiIjwN54LbTdwUYLEyp+aepedcbcSzBLNN6L1GP1QRjmK9aJQJjiwzGW
 GUWMa0zT4wU5aTaokz3HlXOxDtpEkuLcW5KdRF8kJo3Vjh/nxi3ey092OBsx33iPnaFeTz3MkF
 r/8=
X-IronPort-AV: E=Sophos;i="5.75,377,1589212800"; 
   d="scan'208";a="252247185"
Received: from mail-dm6nam11lp2174.outbound.protection.outlook.com (HELO NAM11-DM6-obe.outbound.protection.outlook.com) ([104.47.57.174])
  by ob1.hgst.iphmx.com with ESMTP; 21 Jul 2020 10:19:05 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=TaS5f53KbHt1LtUgXChcE2VeUaC2g8NQ2NzCxzNyOzr54so47+ocefRk+DXZYTUXwhYR/AA1Hjoeagly+d/qxCDJ8qjf2Mm0M9fqo65FnV/5FfZeBFogRMeahvuK4N9sj48ZGCBPcEgq944V3voI3VnhjB42WlHrY2FNQnBkUn9u3c80uU++9ODNY3NNMET9qDmSu7b4WtJFy819ggS9xc2WN+tIOQ/3f/jp94kw/6/JOJcurehn5EqPSCCrx8DhVEeLIu+ZFp3OUt5LHSKB4cBW0uC3TeF7VmOJpxLTo3AQMWP8g+vew4ieW3NiggIlYD40u7SIFSDJAp/c5laF7w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=FdlkKoYD+h/eCt5NgD9SkySOZEgkZ45JeKa3TF3qwhs=;
 b=aJYKvMcNl6aFGAwphlBlp1xag0AkD9+afJXc8vqGM/CXBQkLx2q7SKqw8qTdcULSwYtvK5+VGdNTt+LfrEjD/bOMoH/BSysedINXVa3gVv2g4xcDA/BobejK1utlspP2tQncLff1uErkrlfXsMrx7Rn4sio5tOQNTVhKsrzC9N60y8lW2Eec3VeJ63KTLnqnCVNXEmJ/Y4SrzAVtNZpqxl7bPujAsFHJBKkiOhpZXdslNc5RtwU0gjR7lU0rq9GIV3XiUxXSz8UWLMzYubEn1NeF1uIfnH0xaz4tnxJxE6YBDKmG2oEC8dKv6IUimNMhvKmFL25fohihq5lwtZuhcg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=FdlkKoYD+h/eCt5NgD9SkySOZEgkZ45JeKa3TF3qwhs=;
 b=Gpj6UzEOL9ViQclEvrCDUtVOnHBZ477AmHX3q4B8XvC14nrXqZsQ1IP2uc0qNYQg8aLzX4AYTBsX98yWg6xSvV6qkByMHX9LM459wF6E+GqyjmurNoEFH2OG/B/PMY4Ywv7MlsQjgMv7jquXzk20o2EEs7ZIK2FBRqA1yWA0coM=
Received: from CY4PR04MB3751.namprd04.prod.outlook.com (2603:10b6:903:ec::14)
 by CY4PR04MB1113.namprd04.prod.outlook.com (2603:10b6:903:b9::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3195.17; Tue, 21 Jul
 2020 02:19:04 +0000
Received: from CY4PR04MB3751.namprd04.prod.outlook.com
 ([fe80::d9e5:135e:cfd9:4de0]) by CY4PR04MB3751.namprd04.prod.outlook.com
 ([fe80::d9e5:135e:cfd9:4de0%7]) with mapi id 15.20.3195.025; Tue, 21 Jul 2020
 02:19:04 +0000
From:   Damien Le Moal <Damien.LeMoal@wdc.com>
To:     Matthew Wilcox <willy@infradead.org>
CC:     Kanchan Joshi <joshiiitr@gmail.com>,
        "hch@infradead.org" <hch@infradead.org>,
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
Date:   Tue, 21 Jul 2020 02:19:04 +0000
Message-ID: <CY4PR04MB3751A6F034A6458AFA7A6550E7780@CY4PR04MB3751.namprd04.prod.outlook.com>
References: <CA+1E3rLna6VVuwMSHVVEFmrgsTyJN=U4CcZtxSGWYr_UYV7AmQ@mail.gmail.com>
 <20200710131054.GB7491@infradead.org>
 <20200710134824.GK12769@casper.infradead.org>
 <20200710134932.GA16257@infradead.org>
 <20200710135119.GL12769@casper.infradead.org>
 <CA+1E3rKOZUz7oZ_DGW6xZPQaDu+T5iEKXctd+gsJw05VwpGQSQ@mail.gmail.com>
 <CA+1E3r+j=amkEg-_KUKSiu6gt2TRU6AU-_jwnB1C6wHHKnptfQ@mail.gmail.com>
 <20200720171416.GY12769@casper.infradead.org>
 <CA+1E3rLNo5sFH3RPFAM4_SYXSmyWTCdbC3k3-6jeaj3FRPYLkQ@mail.gmail.com>
 <CY4PR04MB37513C3424E81955EE7BFDA4E7780@CY4PR04MB3751.namprd04.prod.outlook.com>
 <20200721011509.GB15516@casper.infradead.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: infradead.org; dkim=none (message not signed)
 header.d=none;infradead.org; dmarc=none action=none header.from=wdc.com;
x-originating-ip: [129.253.182.57]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: e68f927a-cd10-4ccd-7204-08d82d1c7071
x-ms-traffictypediagnostic: CY4PR04MB1113:
x-ld-processed: b61c8803-16f3-4c35-9b17-6f65f441df86,ExtAddr
x-microsoft-antispam-prvs: <CY4PR04MB11130D34E87A06E898C30AC2E7780@CY4PR04MB1113.namprd04.prod.outlook.com>
wdcipoutbound: EOP-TRUE
x-ms-oob-tlc-oobclassifiers: OLM:8882;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: Y7CuOKxOxG6CmZ6sFnPOJYA29G97AbLfNYJfdqOL4Gx6YnnPgVwDNub9PREbyyX6wshGzg40TEC1AikMNU5xW/Wnc5Ao1DPHxENxN1uwc3Q4jwmicj40L+S5J9yGtG0Ey8UClfxBrqfgAwSlI1YEE+QjFkt74t/iRXKMLP5kJFJby3IPXys12BdsJlWVV8S/i/RCclYqwxZMBclFEfeN8d9jr/2Z1c2hl7dtVBCGqJFEYR8ek5rjzX/SO/Z9K1hbBLi+XQjOJWi4sMN9qJbvhAcFTuqoyfsohfghBBSl0lQZLv5eB37TeBwTWV/vNXR77TScx+/HZJuYO/dlaxzEug==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY4PR04MB3751.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(39860400002)(136003)(366004)(396003)(376002)(346002)(55016002)(9686003)(83380400001)(4326008)(8936002)(186003)(91956017)(33656002)(478600001)(26005)(6916009)(7416002)(53546011)(7696005)(8676002)(52536014)(86362001)(5660300002)(66446008)(64756008)(66556008)(66476007)(76116006)(316002)(2906002)(6506007)(71200400001)(66946007)(54906003);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: OxsXhwyiecvyDFvyjqzdxT0roy9sM+cwYz3HyvQZP6rQzi9kjmrdqL8wR9N2qzYe1OuF2OchoSGJAvFYRgJJvSGQlgGIrWq97ty7xIRZCCICg2ABdSIGFJE/csMbkiko/vputjctZoQXrJ6M6TEZnPXuqOY1igl8ONEP4q53Rx6aWTvFAmaXGN2lBsihILIRed/hR7G5btPFs7NqrYMO9gKNKjROj+29zOPr9vFHLFIg2h52pb1pI+KWSTCYPUn3gDZSgCPkbO1uzlxVCNKL5vQTxPsfq0soCwbN99IeFmhcuR/GMHfWKvmUHwtYZa9e3E6tn2UIVEv4m0e3WxNcZRkEDRV8fhSHfwfXDjKYwGdaNE3RghtyR8/1TxO4vaogxUi8vR+DxFbPS9OX55mqa3m+Xb2pEwF5NKjnd9i7+TzS1SpB0SCT1JCRdIiMSd8t6YeVREMkK7MhOMj8BwKCaTcSbZxaKMAn1HxnH9XppQkc7n8KAwSSXQikyPdwEsY+
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: CY4PR04MB3751.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e68f927a-cd10-4ccd-7204-08d82d1c7071
X-MS-Exchange-CrossTenant-originalarrivaltime: 21 Jul 2020 02:19:04.0582
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: Ydrf1pWtGJ+Km92pDj2i4cmqcaSmwHjZ3BCG22reCv33zOioRVaJ538n/j9O87eS3ti8aFIJn+TeK314uXIKpg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY4PR04MB1113
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 2020/07/21 10:15, Matthew Wilcox wrote:=0A=
> On Tue, Jul 21, 2020 at 12:59:59AM +0000, Damien Le Moal wrote:=0A=
>> On 2020/07/21 5:17, Kanchan Joshi wrote:=0A=
>>> On Mon, Jul 20, 2020 at 10:44 PM Matthew Wilcox <willy@infradead.org> w=
rote:=0A=
>>>>  struct io_uring_cqe {=0A=
>>>>         __u64   user_data;      /* sqe->data submission passed back */=
=0A=
>>>> -       __s32   res;            /* result code for this event */=0A=
>>>> -       __u32   flags;=0A=
>>>> +       union {=0A=
>>>> +               struct {=0A=
>>>> +                       __s32   res;    /* result code for this event =
*/=0A=
>>>> +                       __u32   flags;=0A=
>>>> +               };=0A=
>>>> +               __s64           res64;=0A=
>>>> +       };=0A=
>>>>  };=0A=
>>>>=0A=
>>>> Return the value in bytes in res64, or a negative errno.  Done.=0A=
>>>=0A=
>>> I concur. Can do away with bytes-copied. It's either in its entirety=0A=
>>> or not at all.=0A=
>>>=0A=
>>=0A=
>> SAS SMR drives may return a partial completion. So the size written may =
be less=0A=
>> than requested, but not necessarily 0, which would be an error anyway si=
nce any=0A=
>> condition that would lead to 0B being written will cause the drive to fa=
il the=0A=
>> command with an error.=0A=
> =0A=
> Why might it return a short write?  And, given how assiduous programmers=
=0A=
> are about checking for exceptional conditions, is it useful to tell=0A=
> userspace "only the first 512 bytes of your 2kB write made it to storage"=
?=0A=
> Or would we rather just tell userspace "you got an error" and _not_=0A=
> tell them that the first N bytes made it to storage?=0A=
=0A=
If the write hits a bad sector on disk half-way through, a SAS drive may re=
turn=0A=
a short write with a non 0 residual. SATA drives will fail the entire comma=
nd=0A=
and libata will retry the failed command. That said, if the drive fails to =
remap=0A=
a bad sector and return an error to the host, it is generally an indicator =
that=0A=
one should go to the store to get a new drive :)=0A=
=0A=
Yes, you have a good point. Returning an error for the entire write would b=
e=0A=
fine. The typical error handling for a failed write to a zone is for the us=
er to=0A=
first do a zone report to inspect the zone condition and WP position, resyn=
c its=0A=
view of the zone state and restart the write in the same zone or somewhere =
else.=0A=
So failing the entire write is OK.=0A=
I am actually not 100% sure what the bio interface does if the "restart=0A=
remaining" of a partially failed request fails again after all retry attemp=
ts.=0A=
The entire BIO is I think failed. Need to check. So the high level user wou=
ld=0A=
not see the partial failure as that stays within the scsi layer.=0A=
=0A=
>> Also, the completed size should be in res in the first cqe to follow io_=
uring=0A=
>> current interface, no ?. The second cqe would use the res64 field to ret=
urn the=0A=
>> written offset. Wasn't that the plan ?=0A=
> =0A=
> two cqes for one sqe seems like a bad idea to me.=0A=
=0A=
Yes, this is not very nice. I got lost in the thread. I thought that was th=
e plan.=0A=
=0A=
=0A=
-- =0A=
Damien Le Moal=0A=
Western Digital Research=0A=
