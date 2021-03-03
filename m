Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 43B3C32C5C3
	for <lists+io-uring@lfdr.de>; Thu,  4 Mar 2021 02:00:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244277AbhCDAYO (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 3 Mar 2021 19:24:14 -0500
Received: from mail-dm6nam11on2065.outbound.protection.outlook.com ([40.107.223.65]:31072
        "EHLO NAM11-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S238746AbhCCMq0 (ORCPT <rfc822;io-uring@vger.kernel.org>);
        Wed, 3 Mar 2021 07:46:26 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=XdKt5SdJ4xc04GpHjkaq8MYpJ5/BUGTYFqV5CCFpVPbHB7Ge+FYt72pkYFqFQ3FOaeovxowKm3yBRMesm2C9QqEs2Ckne307W/StxLvGmjI8EJa49qjFQCADBdoBBDWFczcrzG+hg5pvqmEkxh+2FkdpTtzDraT9VwqltZ9C/F4vDMPo+W/Xm3d6gjKzlYKqTkrq2451Ot7E4OLcgsjad2gRqs8taYBzR1KArbEhKn2Z6CLAf+LizB1hZf/5Uo35mblCWIuzkdGsEMQIze6e8wCJUHehPtDvYsBhKr1JYx7mpGGyGE+Wbp4U58MvcAvJB4q59CXGiaF9w9FfehKe3g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=k0A5U7knXA9j7h7Ia+B4z/jzrCVidvM3cu/NXDPVHEs=;
 b=Tgfkq5GcSI+jGXHlDJt2h30FTyfbA117Phanxh77mqtvpPgzc74BL6opJbLhW0T+hjUFDja6G4Khp412Vx5IpFg0dSEwYxHXP07qTTgV3vI7tQ8w2UqIF3r29eM+RaYTNCbHnA+FKMrUo92OUl0V2ZJabIE8pxKZqC0EQzSv8ZY3ZolZLvU4WX/acXBq0dmHxrXDEf5A9LzexPrVjubfZrcSrojx7LpdI7r1IQ4E9uCccgTAXZfk0ldkLdhX+hAyJYejWhGotT4+QdWjNZfx+iT4Tw/F/RwzWW2Bynbgfof50mmE+hXcSKHCyTrx0o5bZQpHsebqSk5BJRfaSP1kzQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=windriver.com; dmarc=pass action=none
 header.from=windriver.com; dkim=pass header.d=windriver.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=windriversystems.onmicrosoft.com;
 s=selector2-windriversystems-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=k0A5U7knXA9j7h7Ia+B4z/jzrCVidvM3cu/NXDPVHEs=;
 b=cDLmY+r+Iau+o3R+/ZbT2x3Wum7rgf2qbxXErQkCspy/Dy/u+nOudRHqKTACbQXTVG/WG2ygXqqrVxS4aNSJa5hyDvLNdVCJzVEGoecFOLHaeRkWg8hAhCck1OYOKPdBm3TWBAdAiv71MViJ0T6TjUa6SFlxhD/Q4O/JI1k2eZo=
Received: from BYAPR11MB2632.namprd11.prod.outlook.com (2603:10b6:a02:c4::17)
 by BY5PR11MB4484.namprd11.prod.outlook.com (2603:10b6:a03:1c3::27) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3890.28; Wed, 3 Mar
 2021 12:45:10 +0000
Received: from BYAPR11MB2632.namprd11.prod.outlook.com
 ([fe80::89a3:42c3:6509:4acd]) by BYAPR11MB2632.namprd11.prod.outlook.com
 ([fe80::89a3:42c3:6509:4acd%4]) with mapi id 15.20.3890.029; Wed, 3 Mar 2021
 12:45:10 +0000
From:   "Zhang, Qiang" <Qiang.Zhang@windriver.com>
To:     Jens Axboe <axboe@kernel.dk>,
        syzbot <syzbot+28abd693db9e92c160d8@syzkaller.appspotmail.com>,
        "asml.silence@gmail.com" <asml.silence@gmail.com>,
        "io-uring@vger.kernel.org" <io-uring@vger.kernel.org>,
        "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "syzkaller-bugs@googlegroups.com" <syzkaller-bugs@googlegroups.com>,
        "viro@zeniv.linux.org.uk" <viro@zeniv.linux.org.uk>
Subject: =?gb2312?B?u9i4tDogcG9zc2libGUgZGVhZGxvY2sgaW4gaW9fcG9sbF9kb3VibGVfd2Fr?=
 =?gb2312?Q?e_(2)?=
Thread-Topic: possible deadlock in io_poll_double_wake (2)
Thread-Index: AQHXDWs6oOGJBWdteka1D+n0kQcjUqpuMluAgABWkYCAAmzQgIABNV+igAAPPw0=
Date:   Wed, 3 Mar 2021 12:45:10 +0000
Message-ID: <BYAPR11MB2632EF56CC5B6000521A03A1FF989@BYAPR11MB2632.namprd11.prod.outlook.com>
References: <000000000000a52fb105bc71e7b8@google.com>,<586d357d-8c4c-8875-3a1c-0599a0a64da0@kernel.dk>,<BYAPR11MB2632D4973C567EDF64A6728BFF989@BYAPR11MB2632.namprd11.prod.outlook.com>
In-Reply-To: <BYAPR11MB2632D4973C567EDF64A6728BFF989@BYAPR11MB2632.namprd11.prod.outlook.com>
Accept-Language: zh-CN, en-US
Content-Language: zh-CN
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: kernel.dk; dkim=none (message not signed)
 header.d=none;kernel.dk; dmarc=none action=none header.from=windriver.com;
x-originating-ip: [106.39.148.172]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 95778b52-2810-41a5-2e81-08d8de422ece
x-ms-traffictypediagnostic: BY5PR11MB4484:
x-microsoft-antispam-prvs: <BY5PR11MB4484DC55DABDD220A9273EADFF989@BY5PR11MB4484.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:9508;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: c4MIoFlbl3+c42fLZp9tCGOWqVvQ6cahpkRMNr7sHlG6Vx/sU4Z79OqzANneFCjLuo9H/Zo5Rp+t8KNJ8/KEMHtyUMpqTh/leRBiP3D6807OQAR573+UmaMi6lAo8jfLzAZNdMS0WepIX8Iks/HqwuOH/ptod6Dk/N88cPx2d9MYj2V4sd31DGSJm83igTVS9xE7+dqYa7SmltaLXYY1f9uZXcgNosh/pxd0nZiUr2VqegU/+SeForH+fLgg6oh55zlOkFXefL3jj5ojZ+Zix+sqnyUqJrej6Y78jyJ4pdDzn9m6vBvsBQy6tQrECTyy6Hl+zlGZ8SNhGXBz5yMGbOkoqg1QVOOsoqSKRmmbAgybYhWdVziF7eaT1z2rNUmLWWBZQSA/WV9RghzI0ePJgqtdARSgyYsvd3LYLAUDxswcATQkBbuYZH5iU2iSPvsV4WhXy1PewMvOkTq4mIoTyrfpbq8FZu/oFGAeTpKqbOmwgAVYCuFYvAq6nthlAmdpxAHRTAwedzjFCPRSoC3KYQ==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR11MB2632.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(346002)(376002)(39850400004)(366004)(136003)(396003)(91956017)(9686003)(6506007)(86362001)(2906002)(55016002)(8936002)(83380400001)(71200400001)(53546011)(224303003)(52536014)(478600001)(5660300002)(316002)(33656002)(110136005)(64756008)(66446008)(66476007)(7696005)(2940100002)(66946007)(66556008)(186003)(76116006)(26005);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: =?gb2312?B?MTFhclpmSVZyWVNjTUM0NTRxaFBBS3VURHVMbFdDVHphUlYyblpwVitLVHZr?=
 =?gb2312?B?ZjR4enFmakw3UVpCUUkwZnlwYVc4aWR2VDA4RmxzS2RWUnJQMDI2L21JbjJz?=
 =?gb2312?B?Q1IwK2hMczAzU0llNUhCV0lmMjVhc291c01GVEJQKy9zU09hWnV2Vi9BdW9G?=
 =?gb2312?B?QTlaVFBoRVlJMGJhV3YrVWEyMmc0ak5PWk51OVJjaGRYSFQxb0JXSG8xWVN1?=
 =?gb2312?B?QzNiaUlOYmlSZFhCdlFpbkQ2N2IvMmRjcjcvdnVLNXpNNk54OGVSYWhJWjd4?=
 =?gb2312?B?aG84TFI0djMzLzd0Sk5lbEFQVDZjSFRrMngzZ0V1Y3hNeHZRQTVMOWNKYURi?=
 =?gb2312?B?Vkp2U2llbmZIY0FFVlE4M2pVL0E3K1d0NWdIc2QzK0lMaEtsNStiRjA3YnV3?=
 =?gb2312?B?KzhCVnRITmZzUjFMTjJWU2ZpNHExbWpERmJEdWNzcWNnQUpDa0tUZWhOQmFm?=
 =?gb2312?B?bGVkeHZtT3BxV3l4TFMzTzdiY0ZOWWV2TXM4cklzREhuUjVXa2tEc1BRdk43?=
 =?gb2312?B?Q0VzVDZSMzROQTNEVnJ6SzFURk4rQXV4V1oxV3psdm1IcTZsd2dkaEhxZ0lN?=
 =?gb2312?B?bUxhcHBLci92TmpRWk1pKzNrdTA5RDk4Tnk2czYzZ1NyMENaTmlRN3Yxa2pt?=
 =?gb2312?B?cTJzYmJpNGJIdmlhbGVSQXNqQkpYMzNkWW9JUFQ0MHhIeGg5Y01OV01PUHZF?=
 =?gb2312?B?RUNQZW5jbEdjME1YSVRFa1BKZUZOZWM0ZERKei93QUVBZzBwdzFaY2pXSnpL?=
 =?gb2312?B?ZnUwSFNEZEp2bHJGMHM3Wjl5djFuT0VmbU9kQ0YxdkJ6S01CMGZIcmVxVWN0?=
 =?gb2312?B?ZjRGc05qeWYxblB2dEJEU3R6VDJpTk42WlprRHlscFFKZUk2V0Rsdk1ienpG?=
 =?gb2312?B?ZXFjeHFKbllGcnZzLy93UFlMUTBzdzJxOFpOQTJicWJyV2RsMlNIeXBIU1NV?=
 =?gb2312?B?WlVLRFB4VkJhMGV2NjRTMVl1aU5xdTJ1bVJoTnBQV3djQk0yZjhoYXZJdVdv?=
 =?gb2312?B?aHNsUWhZbGZraktscWp1MnduZkREdjRxYk9EYnZOOThabmwyTHRkOTEyRXp2?=
 =?gb2312?B?OGxvYk5jT1V0TklrbS9sWE01YmZOVUI5ZkIxYnI0VXh1R0MwTStEM0pDVXpM?=
 =?gb2312?B?anNuTmhZa05KNWJRRTFadjQzR2RBakh4Tm8xUXlkVU1ZbDVnSkdMc0dNWWlm?=
 =?gb2312?B?eXNmOFM3R3dvdytxeVYxMVM1VnpLTTJFQWExenhpOGJwdnZpUXhmWEVCYkcz?=
 =?gb2312?B?VkFrUnMvQWFtejM3ZDNaWTRSdGZpNUtBNFpJNDlDbWgrWGcvZWJCcDVnK29j?=
 =?gb2312?B?eWY3UVlvak9kNUVPQ00vUjMvQ1FDaTRVcGVQK1Q4WG00N0l1aUZtV2pybU9W?=
 =?gb2312?B?akhkbi9yVzFjRTlhTUhZeXJwWWFDMDlrRnJyUFpTYVJUd2t4dnJkLzZSVElH?=
 =?gb2312?B?VitVN2R5cThiMVVCdW1pckZFL1BzQXJobklVNFRJYXRqTms0L1NSNE04VjR4?=
 =?gb2312?B?UGVRNTRKREFweWNNWWxOTDRSaXJLK2k0YXo3alVmS0ROKytac05HbTBGNUVK?=
 =?gb2312?B?M084N043NmRUTGlXQ3ZCdGRYMFlMQm5oaEh4UnVDVlRWbGhZeFpVSis1RkZE?=
 =?gb2312?B?WlpqYWNtdSsrbHpaZnJjNkRlTVJKUUFiZ2liQ0JvWmFDNGdjcDR5ckxKRUNO?=
 =?gb2312?B?SU9qaUV0UjZvMXNUWFFPSXFET0g2NFZaYllqRG5XOUxKRXNCbFBneUlnS0dL?=
 =?gb2312?Q?nzCeS1SnvoZyFh87hM=3D?=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="gb2312"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: windriver.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BYAPR11MB2632.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 95778b52-2810-41a5-2e81-08d8de422ece
X-MS-Exchange-CrossTenant-originalarrivaltime: 03 Mar 2021 12:45:10.6467
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ddb2873-a1ad-4a18-ae4e-4644631433be
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 0pi0C+s80bGss3KKm4Wzwj7OI8V9FLQrI07WZDVRMZtatKA9rQz6RrP3/+c5GBtWFo2rGxsU3Ow/FJdeffbExYq1ZuwH/TDFf5xxUYpwnR4=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR11MB4484
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

CgpfX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fCreivP7IyzogWmhhbmcs
IFFpYW5nIDxRaWFuZy5aaGFuZ0B3aW5kcml2ZXIuY29tPgq3osvNyrG85DogMjAyMcTqM9TCM8jV
IDIwOjE1CsrVvP7IyzogSmVucyBBeGJvZTsgc3l6Ym90OyBhc21sLnNpbGVuY2VAZ21haWwuY29t
OyBpby11cmluZ0B2Z2VyLmtlcm5lbC5vcmc7IGxpbnV4LWZzZGV2ZWxAdmdlci5rZXJuZWwub3Jn
OyBsaW51eC1rZXJuZWxAdmdlci5rZXJuZWwub3JnOyBzeXprYWxsZXItYnVnc0Bnb29nbGVncm91
cHMuY29tOyB2aXJvQHplbml2LmxpbnV4Lm9yZy51awrW98ziOiC72Li0OiBwb3NzaWJsZSBkZWFk
bG9jayBpbiBpb19wb2xsX2RvdWJsZV93YWtlICgyKQoKCgpfX19fX19fX19fX19fX19fX19fX19f
X19fX19fX19fX19fX19fX19fCreivP7IyzogSmVucyBBeGJvZSA8YXhib2VAa2VybmVsLmRrPgq3
osvNyrG85DogMjAyMcTqM9TCM8jVIDE6MjAKytW8/sjLOiBzeXpib3Q7IGFzbWwuc2lsZW5jZUBn
bWFpbC5jb207IGlvLXVyaW5nQHZnZXIua2VybmVsLm9yZzsgbGludXgtZnNkZXZlbEB2Z2VyLmtl
cm5lbC5vcmc7IGxpbnV4LWtlcm5lbEB2Z2VyLmtlcm5lbC5vcmc7IHN5emthbGxlci1idWdzQGdv
b2dsZWdyb3Vwcy5jb207IHZpcm9AemVuaXYubGludXgub3JnLnVrCtb3zOI6IFJlOiBwb3NzaWJs
ZSBkZWFkbG9jayBpbiBpb19wb2xsX2RvdWJsZV93YWtlICgyKQoKW1BsZWFzZSBub3RlOiBUaGlz
IGUtbWFpbCBpcyBmcm9tIGFuIEVYVEVSTkFMIGUtbWFpbCBhZGRyZXNzXQoKT24gMi8yOC8yMSA5
OjE4IFBNLCBzeXpib3Qgd3JvdGU6Cj4gSGVsbG8sCj4KPiBzeXpib3QgaGFzIHRlc3RlZCB0aGUg
cHJvcG9zZWQgcGF0Y2ggYnV0IHRoZSByZXByb2R1Y2VyIGlzIHN0aWxsIHRyaWdnZXJpbmcgYW4g
aXNzdWU6Cj4gcG9zc2libGUgZGVhZGxvY2sgaW4gaW9fcG9sbF9kb3VibGVfd2FrZQo+Cj4gPT09
PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT0KPiBXQVJOSU5HOiBwb3Nz
aWJsZSByZWN1cnNpdmUgbG9ja2luZyBkZXRlY3RlZAo+IDUuMTEuMC1zeXprYWxsZXIgIzAgTm90
IHRhaW50ZWQKPiAtLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLQo+
IHN5ei1leGVjdXRvci4wLzEwMjQxIGlzIHRyeWluZyB0byBhY3F1aXJlIGxvY2s6Cj4gZmZmZjg4
ODAxMmUwOTEzMCAoJnJ1bnRpbWUtPnNsZWVwKXsuLi0ufS17MjoyfSwgYXQ6IHNwaW5fbG9jayBp
bmNsdWRlL2xpbnV4L3NwaW5sb2NrLmg6MzU0IFtpbmxpbmVdCj4gZmZmZjg4ODAxMmUwOTEzMCAo
JnJ1bnRpbWUtPnNsZWVwKXsuLi0ufS17MjoyfSwgYXQ6IGlvX3BvbGxfZG91YmxlX3dha2UrMHgy
NWYvMHg2YTAgZnMvaW9fdXJpbmcuYzo0OTIxCj4KPiBidXQgdGFzayBpcyBhbHJlYWR5IGhvbGRp
bmcgbG9jazoKPiBmZmZmODg4MDEzYjAwMTMwICgmcnVudGltZS0+c2xlZXApey4uLS59LXsyOjJ9
LCBhdDogX193YWtlX3VwX2NvbW1vbl9sb2NrKzB4YjQvMHgxMzAga2VybmVsL3NjaGVkL3dhaXQu
YzoxMzcKPgo+IG90aGVyIGluZm8gdGhhdCBtaWdodCBoZWxwIHVzIGRlYnVnIHRoaXM6Cj4gIFBv
c3NpYmxlIHVuc2FmZSBsb2NraW5nIHNjZW5hcmlvOgo+Cj4gICAgICAgIENQVTAKPiAgICAgICAg
LS0tLQo+ICAgbG9jaygmcnVudGltZS0+c2xlZXApOwo+ICAgbG9jaygmcnVudGltZS0+c2xlZXAp
Owo+Cj4gICoqKiBERUFETE9DSyAqKioKPgo+ICBNYXkgYmUgZHVlIHRvIG1pc3NpbmcgbG9jayBu
ZXN0aW5nIG5vdGF0aW9uCj4KPlNpbmNlIHRoZSBmaXggaXMgaW4geWV0IHRoaXMga2VlcHMgZmFp
bGluZyAoYW5kIEkgZGlkbid0IGdldCBpdCksID5JIGxvb2tlZAo+Y2xvc2VyIGF0IHRoaXMgcmVw
b3J0LiBXaGlsZSB0aGUgbmFtZXMgb2YgdGhlIGxvY2tzIGFyZSB0aGUgPnNhbWUsIHRoZXkgYXJl
Cj5yZWFsbHkgdHdvIGRpZmZlcmVudCBsb2Nrcy4gU28gbGV0J3MgdHJ5IHRoaXMuLi4KCj5IZWxs
byBKZW5zIEF4Ym9lCgpTb3JyeSBmb3IgSSBtYWtlICBub2lzZSwgcGxlYXNlIGlnbm9yZSB0aGlz
IGluZm9ybWF0aW9uLgoKPlNvcnJ5LCBJIHByb3ZpZGVkIHRoZSB3cm9uZyBpbmZvcm1hdGlvbiBi
ZWZvcmUuCj5JJ20gbm90IHZlcnkgZmFtaWxpYXIgd2l0aCBpb191cmluZywgIGJlZm9yZSB3ZSBz
dGFydCA+dmZzX3BvbGwgYWdhaW4sICBzaG91bGQgd2Ugc2V0ICAncG9sbC0+aGVhZCA9IE5VTEwn
ICA/Cj4KPmRpZmYgLS1naXQgYS9mcy9pb191cmluZy5jIGIvZnMvaW9fdXJpbmcuYwo+aW5kZXgg
NDJiNjc1OTM5NTgyLi5jYWU2MDVjMTQ1MTAgMTAwNjQ0Cj4tLS0gYS9mcy9pb191cmluZy5jCj4r
KysgYi9mcy9pb191cmluZy5jCj5AQCAtNDgyNCw3ICs0ODI0LDcgQEAgc3RhdGljIGJvb2wgaW9f
cG9sbF9yZXdhaXQoc3RydWN0ID5pb19raW9jYiAqcmVxLCBzdHJ1Y3QgaW9fcG9sbF9pb2NiICpw
b2xsKQo+Cj4gICAgICAgIGlmICghcmVxLT5yZXN1bHQgJiYgIVJFQURfT05DRShwb2xsLT5jYW5j
ZWxlZCkpIHsKPiAgICAgICAgICAgICAgICBzdHJ1Y3QgcG9sbF90YWJsZV9zdHJ1Y3QgcHQgPSB7
IC5fa2V5ID0gcG9sbC0+ZXZlbnRzID59Owo+LQo+KyAgICAgICAgICAgICAgIHBvbGwtPmhlYWQg
PSBOVUxMOwo+ICAgICAgICAgICAgICAgIHJlcS0+cmVzdWx0ID0gdmZzX3BvbGwocmVxLT5maWxl
LCAmcHQpICYgPnBvbGwtPmV2ZW50czsKPiAgICAgICAgfQoKCgo+VGhhbmtzCj5RaWFuZwoKPgo+
I3N5eiB0ZXN0OiBnaXQ6Ly9naXQua2VybmVsLmRrL2xpbnV4LWJsb2NrIHN5emJvdC10ZXN0Cj4K
Pi0tCj5KZW5zIEF4Ym9lCgo=
