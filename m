Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1B6BC2449AF
	for <lists+io-uring@lfdr.de>; Fri, 14 Aug 2020 14:20:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726593AbgHNMUo (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 14 Aug 2020 08:20:44 -0400
Received: from esa1.hgst.iphmx.com ([68.232.141.245]:28073 "EHLO
        esa1.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726455AbgHNMUl (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 14 Aug 2020 08:20:41 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1597407640; x=1628943640;
  h=from:to:cc:subject:date:message-id:references:
   content-transfer-encoding:mime-version;
  bh=SpU33UC7nJ5osmUOvPg8hYf6pn9V/4aszvqU9n1JFvQ=;
  b=TbaUT2aiUcL+LnP/HiIVVlRfh8LsK6tgAvPI+fONjBWiJAPWInDeV+ID
   tSBKGEDBjpjlQB9CHofq9SJApu9T2L04mcbUDrl8TzIEidtKCbLOc+FUY
   7DuQVAzDOWnkMEg7eb4FrxAqVwZo+8j/UYWPtLxjWBh6PwR4p83n8Lhju
   Y7cjxA7m6zIT0O94vdG62eCIzDOWcb5QuKWJntr9qbasKyODTb1JYUO2f
   wgeAmLAofjOnN0Ooz/pEYgZQX6NAXrrYlzKwUZj0s3opuEfrMOPIsFKfL
   TSrieIxCc+iPVLBvNvcyryhPzZZYL1m5SFejmJwYJ6KNE7kaE+CSyLmQw
   A==;
IronPort-SDR: j4shW0UZ08ARf5SMTahy3FEb8KJ7PGDhrwbKbpiWD3fmbmLbp/q2hRXUi5JZ3e5YcrLrgopDu0
 zMxp1dgCv19a6FFA0+55z8I3BUMDUPyi5vSuxlxOhYyWg5+L/fXJod4NASSXYUUN77j7jkmvsE
 qBIfxcabP2HrlQhtCGUxkpGJHpoli69y0AfxXgNBxXRUMhqcEPSidOQwccWydhv6cV03VNcpft
 rtolQyXlZO76CxuPTVehWyFz/CYx3HF2/4Ard2Y7ryOiQfD/OzzI5Ad6RoKytqW8+ZrvCcarLM
 e9M=
X-IronPort-AV: E=Sophos;i="5.76,312,1592841600"; 
   d="scan'208";a="254359538"
Received: from mail-sn1nam02lp2054.outbound.protection.outlook.com (HELO NAM02-SN1-obe.outbound.protection.outlook.com) ([104.47.36.54])
  by ob1.hgst.iphmx.com with ESMTP; 14 Aug 2020 20:20:38 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=EyWYmbLhwFCMf2f5Ytq7y8Q/ikg/lKRU2fy2tzpgTX2egiUJaaf/nTmRJTswhK+wF6T77HxOZg4Q1TdP7Gn8XdLuxM/S19L9S4TleCWdiJD4zXc7EV6bu1khwsIjPUJPQnMSW0y+RT/HfYA3zHtA49LFXXG4i54ZT9wj3kx63h4htvXGbE7n+wCxeKlYaaH3FR6THQGrTQqbHLSA3HJjVNJ/qgXCQndU4T44e7dhT23CWKHHS3xC/BoqoZUlxeFJKEnFA71krnTQlTj61fH17/DNJzhv8kFHsDg9bjFQv4r2yxhgP9XMwIOF0GZFf4bGMrB6RNJOu4jhQ3NfFQt/9Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=uOkfuM6GGqXLNE+Kyh2J35ZVZ48rg0h6dRf5B05rLHg=;
 b=TuwfRcCIHYAiwYCw+QKgmPbtLnsrKBwstlIiHBQlgp2wPlYng+0EtThObcpEQ/Y0iNif2IxnwT4Thd1IApycVtJKGmbMU8cH3Xvm4rzB99aZWwrJotkItz9/p/N0NEs2LdMw9omzwb4zrgq4ebGDOB3BOLzB/s6FgTxRvGvBLEXiERHjJ1SqkyzEj/dHLzBDe6VUVxkIrArLtr8r1A7OYwGtgXQ/ZYbcuAx2JD8m1HQdfEdUmucYuVnpQbjFm5R7SCD5eksQGYjlt4kI1gtzE9cPlkwO0j3Rarl7Qu45Br7r96A5HycBno7p+TfiaxEQV+d3Q1M/mVXobC7p/ZpZNQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=uOkfuM6GGqXLNE+Kyh2J35ZVZ48rg0h6dRf5B05rLHg=;
 b=e6TDlPgobaoVtGRmmKsL/SuPjL7pL2/nGHIH3WuXuHCvu0V1Xh1IKoNOx7ZG78QiI8OsY1HI2X9LXlw6oiyfx6YjQOSLMD21U37IqEWsqdy1e9hN2WSnrAk/fcPmZwI7FbER8UKWwVVAI3158mwvQPkZRWxs9opQamv2vnkl4zY=
Received: from CY4PR04MB3751.namprd04.prod.outlook.com (2603:10b6:903:ec::14)
 by CY4PR04MB3749.namprd04.prod.outlook.com (2603:10b6:903:e8::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3283.16; Fri, 14 Aug
 2020 12:20:34 +0000
Received: from CY4PR04MB3751.namprd04.prod.outlook.com
 ([fe80::7d15:9936:4b3b:f8a2]) by CY4PR04MB3751.namprd04.prod.outlook.com
 ([fe80::7d15:9936:4b3b:f8a2%12]) with mapi id 15.20.3283.016; Fri, 14 Aug
 2020 12:20:34 +0000
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
Date:   Fri, 14 Aug 2020 12:20:34 +0000
Message-ID: <CY4PR04MB37518A2859396BCE0EEF5270E7400@CY4PR04MB3751.namprd04.prod.outlook.com>
References: <CA+1E3rLM4G4SwzD6RWsK6Ssp7NmhiPedZDjrqN3kORQr9fxCtw@mail.gmail.com>
 <MWHPR04MB375863C20C1EF2CB27E62703E74E0@MWHPR04MB3758.namprd04.prod.outlook.com>
 <20200731091416.GA29634@infradead.org>
 <MWHPR04MB37586D39CA389296CE0252A4E74E0@MWHPR04MB3758.namprd04.prod.outlook.com>
 <20200731094135.GA4104@infradead.org>
 <MWHPR04MB3758A4B2967DB1FABAAD9265E74E0@MWHPR04MB3758.namprd04.prod.outlook.com>
 <20200731125110.GA11500@infradead.org>
 <CY4PR04MB37517D633920E4D31AC6EA0DE74B0@CY4PR04MB3751.namprd04.prod.outlook.com>
 <20200814081411.GA16943@infradead.org>
 <CY4PR04MB3751DE1ECCA4099902AABAA6E7400@CY4PR04MB3751.namprd04.prod.outlook.com>
 <20200814120422.GA1872@infradead.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: infradead.org; dkim=none (message not signed)
 header.d=none;infradead.org; dmarc=none action=none header.from=wdc.com;
x-originating-ip: [2400:2411:43c0:6000:28a1:79eb:9c3c:a78e]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 60a007b8-7631-4937-0298-08d8404c71c1
x-ms-traffictypediagnostic: CY4PR04MB3749:
x-ld-processed: b61c8803-16f3-4c35-9b17-6f65f441df86,ExtAddr
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <CY4PR04MB37498277FACF8FA7D74534FCE7400@CY4PR04MB3749.namprd04.prod.outlook.com>
wdcipoutbound: EOP-TRUE
x-ms-oob-tlc-oobclassifiers: OLM:8882;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: +8VIX4sxnrCHn1MtFSekaqr3J8hYhB//Kg4lMRRdKxSU3Cd/sZryCB5hGnN5AxnBQeA7N6HvuOKOGZextCB1kYHj0f15UfXeDaDV//K/noHHToziJABtJxaCVtt6WBNLkFLKQG+I9M6kk9m2pcIHbfEwlQOM3llqdn8rH3nw870wrglRrlaZ6CaGGbq4XlKCff8KFk4LnHsO8DhZg30xebKUvzVUEecN7sIphTT06jbA6erdWwyC8vDcatA5HmLT0C0ukNdTRY+bCXw6VDBooYczVuwr8sAkq/cd+hHYVGb6VbYE0f7w3fqc6sbF+yp9MKplRXq5tSIdVjLuIW/jxw==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY4PR04MB3751.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(376002)(346002)(396003)(39860400002)(366004)(136003)(5660300002)(83380400001)(186003)(7696005)(86362001)(53546011)(66946007)(6506007)(9686003)(8936002)(6916009)(55016002)(76116006)(4326008)(91956017)(33656002)(478600001)(54906003)(7416002)(52536014)(71200400001)(2906002)(8676002)(66446008)(64756008)(66476007)(316002)(66556008);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: xNTB23psWOekOB6FuTJOEP0k7JByKq+gzYGWTAtc94yeLwCx+bphDOkWJNGdfEJgYTbrLsPku0ATOvE7qUIUzScNQCkTXVCzAPbMrWgOL9qNstG8YyQE1pjklMIz4yDZbCI/JcCv8hNawRTqURDqMiXEGx5W4slFmK5GFkStGDFD7x2biMevpsahd7FzTfzaY3v9yEzW4heYmoAcQ9PMdjoF+7ZkiUdcgm6cC/+5hpgquLyOZ2XkU0NJ0YnuRUI68MKKLBC61DSQf5Yj4S99FT+phKQRM+gzZAchDJEaZKfOlIiknXvtHsFWpAbVC4T3ILeRiU532003LS898gd+97EomN7ODx1MJej3UTHeod0U5Nei1brknNNG9kwqgrHs7U38IIoGcMHythNbj2m8nhOcytUvbnWHaab5r3dQ+fRFHEUrx9hE4IZDtHH+QR4bFP6tPaSpWIC1f3xDO8peTPM22JomaT59r72XNjhGYnfl/f+nbWcE21hFeEV48saf5clKEhhbOduYeq1Khe57o42mx0D9BGjYe3jZWiDPNprBlStfT23DrWFRKex3fg+WEHxJqcRHYg5qd3oCVAX7t1TMDaU8g4dNGk55iVjrsDBhea5heX/7EARIxbEEqkCHqJSCThy/gLiCZVfRiwd5iknBXT5KIKHgyOr3ilZTi/CNo7PqCL17Tk6fisdUbv4zYnfNjzw91Tu9B0Oy6h+eMQ==
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: CY4PR04MB3751.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 60a007b8-7631-4937-0298-08d8404c71c1
X-MS-Exchange-CrossTenant-originalarrivaltime: 14 Aug 2020 12:20:34.2692
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: +5lB5ETxnlTMmNcsRFAuY5oTAXWcmN+BospLiwJ1W3wBYasFhBPEOsJWIClPd/jKhd5GlZycOj3x/7h46kkscg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY4PR04MB3749
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 2020/08/14 21:04, hch@infradead.org wrote:=0A=
> On Fri, Aug 14, 2020 at 08:27:13AM +0000, Damien Le Moal wrote:=0A=
>>>=0A=
>>> O_APPEND pretty much implies out of order, as there is no way for an=0A=
>>> application to know which thread wins the race to write the next chunk.=
=0A=
>>=0A=
>> Yes and no. If the application threads do not synchronize their calls to=
=0A=
>> io_submit(), then yes indeed, things can get out of order. But if the=0A=
>> application threads are synchronized, then the offset set for each appen=
d AIO=0A=
>> will be in sequence of submission, so the user will not see its writes=
=0A=
>> completing at different write offsets than this implied offsets.=0A=
> =0A=
> Nothing gurantees any kind of ordering for two separate io_submit calls.=
=0A=
> The kernel may delay one of them for any reason.=0A=
=0A=
Ah. Yes. The inode locking is at the single aio issuing level, not the io_s=
ubmit=0A=
syscall level... So yes, in the end, the aios offsets and their execution o=
rder=0A=
can be anything. I see it now. So O_APPEND implying zone append is fine for=
 zonefs.=0A=
=0A=
> =0A=
> Now if you are doing two fully synchronous write calls on an=0A=
> O_APPEND fd, yes they are serialized.  But using Zone Append won't=0A=
> change that.=0A=
=0A=
Yep. That zonefs already does.=0A=
=0A=
OK. So I think I will send a writeup of the semantic discussed so far. We a=
lso=0A=
still need a solution for io_uring interface for the written offset report =
and=0A=
we can implement.=0A=
=0A=
=0A=
-- =0A=
Damien Le Moal=0A=
Western Digital Research=0A=
