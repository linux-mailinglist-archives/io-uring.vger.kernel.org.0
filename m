Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E91CB32C5C2
	for <lists+io-uring@lfdr.de>; Thu,  4 Mar 2021 02:00:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237751AbhCDAYN (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 3 Mar 2021 19:24:13 -0500
Received: from mail-mw2nam10on2059.outbound.protection.outlook.com ([40.107.94.59]:19905
        "EHLO NAM10-MW2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S244277AbhCCMQK (ORCPT <rfc822;io-uring@vger.kernel.org>);
        Wed, 3 Mar 2021 07:16:10 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=EjttPBmJ14Q7INlyRA5Q5ge2dLOlRMfKyR0FFT782k8rflDQL8BGl2Bw6cnjro/0+s9QPel2o1NVdD7f5x6hV/bky6W1UN2KykyxYu3QGLH6bwFSGwKh6NL2GTUTTU0LkaBq4DlwpJxtzlgfsYCuC6GEbTOsN2ucnF2trS6ljShpb3IK8XKsqSj93fhdyxIb58PUNG6HXlxxdaSBw+K5KV/vSXsgacdJlt1dCTq9F9khiSj/5qazbyB2tkMB2brNlDuIrsTK2J3BvRs+Z6faisoc4RXkJvIITloJUXeLyc4Z4QLIO18VkwPz2+DqbGHEdC3Rv6jr/mmSTp4LA06rpQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=5U1KBd0u2+z+daJlvSXRQkqYpJOZi5lf3FfMgolvUdo=;
 b=Xvbou02/qJvdgh0Z/pL0HCkI1PT4EnY7FtP1VT1PCt4yEbrTqsuarsqcLEw8KhUcAyweJ7YsZ5vAr8Sj2VkPeh6hKsk25JdfqIj92/iHh9WtwoQ40JyhQtiWVpz6t3t3uVe3OkVixROQ3Zkz7YkmKF4U6jszMC1cS7AZ0H8I6H716Wcx8qca7FUOrU9k+lW75DoXEi/GkX+yj2Zg461phTVFhX/SilpyLW5ZkgpCEsSSu83jytcinyCWDHw+dh7+awMek9Y98NqR1exO0CUnRAJyzkje4NhurtU0fUMqwGMTlBmjQeQQXGwBKvGXoJYXjsO/l83TKLSCxbTUf7omBw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=windriver.com; dmarc=pass action=none
 header.from=windriver.com; dkim=pass header.d=windriver.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=windriversystems.onmicrosoft.com;
 s=selector2-windriversystems-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=5U1KBd0u2+z+daJlvSXRQkqYpJOZi5lf3FfMgolvUdo=;
 b=octWCJwS7n76vrZsPnjRB4W60s8TUx+XaYdQRRhOhbdbrPnJQWO8rVJvuj9wvFsvP1y7QbYjyCTwFln1JjZacytGCbCJcQfVwa5NjwM/vZbP43k2xLmjSmT5UjURZZjo0nul0M5PH+Nz82fQ/2QJsQWNt+2Uoesig2k3Gxcj4FU=
Received: from BYAPR11MB2632.namprd11.prod.outlook.com (2603:10b6:a02:c4::17)
 by BYAPR11MB3189.namprd11.prod.outlook.com (2603:10b6:a03:7c::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3912.17; Wed, 3 Mar
 2021 12:15:16 +0000
Received: from BYAPR11MB2632.namprd11.prod.outlook.com
 ([fe80::89a3:42c3:6509:4acd]) by BYAPR11MB2632.namprd11.prod.outlook.com
 ([fe80::89a3:42c3:6509:4acd%4]) with mapi id 15.20.3890.029; Wed, 3 Mar 2021
 12:15:16 +0000
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
Thread-Index: AQHXDWs6oOGJBWdteka1D+n0kQcjUqpuMluAgABWkYCAAmzQgIABNV+i
Date:   Wed, 3 Mar 2021 12:15:16 +0000
Message-ID: <BYAPR11MB2632D4973C567EDF64A6728BFF989@BYAPR11MB2632.namprd11.prod.outlook.com>
References: <000000000000a52fb105bc71e7b8@google.com>,<586d357d-8c4c-8875-3a1c-0599a0a64da0@kernel.dk>
In-Reply-To: <586d357d-8c4c-8875-3a1c-0599a0a64da0@kernel.dk>
Accept-Language: zh-CN, en-US
Content-Language: zh-CN
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: kernel.dk; dkim=none (message not signed)
 header.d=none;kernel.dk; dmarc=none action=none header.from=windriver.com;
x-originating-ip: [106.39.148.172]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 8691ea63-bef5-4ba3-2d36-08d8de3e017a
x-ms-traffictypediagnostic: BYAPR11MB3189:
x-microsoft-antispam-prvs: <BYAPR11MB3189EE7585104AD27E68B9C5FF989@BYAPR11MB3189.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:9508;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: qyMpuJdbhmyCO8kDXqXTrPvj6nqjgMUN6dv29NqZKc7KcboRmYPgnRTA1HH/5afSAC5dLUQ7GIK1H5q0cB5y3XdcdqfjT/0Hrpjf0BrwBuXgb8yuoag3z+IYw4JrMRjitVtg1XcdVf8TqHlLHlNQgfut8Te12+aZVn1Wab+D0++ZASuSzVuMhX+EBkZUGXepNgwpaA/ONcsM9FmMCEs6NSrL09YC/tZoLwxY+sL1vpwQtuLpyO3izphjKy3gNszqGB3FvaiY2Qemka9pIIUnxVtRjUxQIyMMPnprawUZYiRZnZ1YxEQdo9CZRN2tQEpwwVeV5dzPkh/2tIlDVGjox2toh4xXqdJ1WBnApM3HfLw2nnDbDS7fdqRPjhPq5z05Vk6plvb/reFwO0vx4prb1LQviogKdiHHOdffFrmMYy0edevpnnlNyO0HpYS0MR0zbZynIxgiDalVQb3WTidD4iDEuakc+6u+MsT2I7Rjh6gO99BbRZxRJUi0rWiIpLtPUrMyqtBbWUPmaGYlFxMaCg==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR11MB2632.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(376002)(366004)(396003)(346002)(136003)(39840400004)(91956017)(66946007)(76116006)(55016002)(5660300002)(6506007)(478600001)(66446008)(66476007)(224303003)(64756008)(66556008)(53546011)(110136005)(2906002)(316002)(7696005)(86362001)(9686003)(33656002)(26005)(8936002)(83380400001)(186003)(71200400001)(52536014);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: =?gb2312?B?Tmh2MGw4Z0kwbDRZR3p5dmczSkdVdWlKR0lQZmMvVkNNTzdjbFdQMElmQVBX?=
 =?gb2312?B?VVIrZTk2SVRhUVNyTlpvb2RkdHpNK0NzR3g3RDRqRlovWVBDekJUbzB2QlRY?=
 =?gb2312?B?T3crMzVIRXMweFhaN0ZhZmFnRTEzdzhUVWRrNWRPOEJFbGYraDhvcTZLSjJH?=
 =?gb2312?B?QVdWNkxLTStuSHZjekFmOE54TVMzY05CY1czNXJKZ1RrTVZ4cTBuSWlDS0dZ?=
 =?gb2312?B?TW1FR3d1MEZOQm5tYndoMzZmS0NYdjdsTXJzSllBV05waWozaDFlaFZ3R0da?=
 =?gb2312?B?RTFNQ1AzR1JFVXM4b0xrVHEyN3orRit0MHlhZENiMWs3b212UXNoOERLYUZG?=
 =?gb2312?B?ZDJlc01GRGhZZXpXV1pKd3RBYjVnUWtaaGtnbXZEeVp1ZTVJK0lCZ0h2eCtp?=
 =?gb2312?B?bEJyeEtHOTZ6Q1ZRUXFjZ2l2b3FiRkpLRjhRMEVLMUQ5aEU2OUVpbGNFaXY2?=
 =?gb2312?B?KytWMlJFVVhIVnorcW9PRUxETkoxeEFnS2NyMGI2cnpGYmtmQTNGWTZEcmVR?=
 =?gb2312?B?YW9hYVdnaUJEYkpIckZLTTVYVnNYYmFSbXErWkZOa3FqUzd3VGt6VlNaU1li?=
 =?gb2312?B?UUR3enNCRzZ5d3ZqT3RNdzdVWUxOZDVsVUxndEpjRTMzRnBvaEhOVGEya1dj?=
 =?gb2312?B?M0ZpVnlSL1YreHlqS1lkYnhKNzZLVEdLaFVHWXVzOGZjSUJOeU5Cd2k5bTJH?=
 =?gb2312?B?czd4eWJwL3dIMUFaL0VlRmNkTkRpaENpZHpiVWFVQlA1TjVFdXBjQUpSQk10?=
 =?gb2312?B?UXBiZUpGWTJtNTJYVGtOVzEydHl4SFNzNjltZnNxSXA1bGFxS01OWXBvSUJF?=
 =?gb2312?B?VTJ1RzBmbHZNakNXeDltZUpsTHYrVkNCV0VPNitOdTU4Tnl3VmFsd0RoOEgx?=
 =?gb2312?B?TEoySWNDWnFyb0lDTnJQMmtMbTZRZ0hSSDVSbnFEOGpVQTZYZTBjNnpNSVF5?=
 =?gb2312?B?TnB6bTlBbzBhVW52UXJiYWMyRXBnN1o5ZHQ4Ukl4dCs1RG5iOExLaHNxdjdC?=
 =?gb2312?B?NmorZFJPOXp0dXFPSjd4dVRHV0hRTyswTGhSZHNXQnZwblpPMnZWeGxOMjVR?=
 =?gb2312?B?dzNHdE9iSno0TkZHMjM0VjdMOEFEQkI1NTZjOFoxUFprdXZBdndEQnVqT2M0?=
 =?gb2312?B?MytNV2RWem50WmozQ1l1MGZPWDduSGZIK3VDeDlPVElvRTR3NGI0Yithc0ph?=
 =?gb2312?B?TmpLWHdtKzd3MUpWRkkrWlBLeC9tM3F6STRoT3BpU3VrNUQyUklQVjR5WVZU?=
 =?gb2312?B?ejRMY2dlUitqOURxM3UvbHZLd29MMllkQTc4WkZ0bGtDL0MrbVBBYitGd0NT?=
 =?gb2312?B?anlvZGluUWFyZCtpbmsyUjdxUDBvdldoS25xWWVEQU9oUjJueHlEZ0dOci8z?=
 =?gb2312?B?eUs1WjFMVGI5MjU3ekFRTStMVnJIWjV4K2h2STNRWTFmemMrRGFUcmFiaDBz?=
 =?gb2312?B?aTg1MGtiVlJ5YStKVDJGSVp1ckNleThmaTRyQUNGUlpEb1JsM2t4OEJtL2pv?=
 =?gb2312?B?bnd6MVUvL1pOY2lIWjRXbDZURENSWmhoT0F4NXdLbHc1R3F0VXRVM1ArbTNr?=
 =?gb2312?B?TmRZbEhCN1FiWUVIYXVSeUxOM1lFeUFpMUoxYXBuM2tsdnNjNGxGcW5zdUF5?=
 =?gb2312?B?bEZVb0d4djNINmRzZERJdVJ1cUl1TnJsM2JTRyszaVVtRU03RTlJcGp5blpn?=
 =?gb2312?B?U3dhdXYxcEdDUkczRFFCWVpvR2FNYXpUa3dOZUFRWjhVRmhtbVBjVjQwYzM3?=
 =?gb2312?Q?XzmFnjUHb6Uw5NIR68=3D?=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="gb2312"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: windriver.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BYAPR11MB2632.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8691ea63-bef5-4ba3-2d36-08d8de3e017a
X-MS-Exchange-CrossTenant-originalarrivaltime: 03 Mar 2021 12:15:16.5608
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ddb2873-a1ad-4a18-ae4e-4644631433be
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: G7W3tvt7R9tOLQVci5+Ts80HFf6CDo+P9JcjI4nFsiCkGRp7hRSwNbzH2Y9Qr6sradLG3OCW8G7Nbde249c4yuiR7q+sfKkNPe9LH+BS+lM=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR11MB3189
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

CgpfX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fCreivP7IyzogSmVucyBB
eGJvZSA8YXhib2VAa2VybmVsLmRrPgq3osvNyrG85DogMjAyMcTqM9TCM8jVIDE6MjAKytW8/sjL
OiBzeXpib3Q7IGFzbWwuc2lsZW5jZUBnbWFpbC5jb207IGlvLXVyaW5nQHZnZXIua2VybmVsLm9y
ZzsgbGludXgtZnNkZXZlbEB2Z2VyLmtlcm5lbC5vcmc7IGxpbnV4LWtlcm5lbEB2Z2VyLmtlcm5l
bC5vcmc7IHN5emthbGxlci1idWdzQGdvb2dsZWdyb3Vwcy5jb207IHZpcm9AemVuaXYubGludXgu
b3JnLnVrCtb3zOI6IFJlOiBwb3NzaWJsZSBkZWFkbG9jayBpbiBpb19wb2xsX2RvdWJsZV93YWtl
ICgyKQoKW1BsZWFzZSBub3RlOiBUaGlzIGUtbWFpbCBpcyBmcm9tIGFuIEVYVEVSTkFMIGUtbWFp
bCBhZGRyZXNzXQoKT24gMi8yOC8yMSA5OjE4IFBNLCBzeXpib3Qgd3JvdGU6Cj4gSGVsbG8sCj4K
PiBzeXpib3QgaGFzIHRlc3RlZCB0aGUgcHJvcG9zZWQgcGF0Y2ggYnV0IHRoZSByZXByb2R1Y2Vy
IGlzIHN0aWxsIHRyaWdnZXJpbmcgYW4gaXNzdWU6Cj4gcG9zc2libGUgZGVhZGxvY2sgaW4gaW9f
cG9sbF9kb3VibGVfd2FrZQo+Cj4gPT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09
PT09PT09PT0KPiBXQVJOSU5HOiBwb3NzaWJsZSByZWN1cnNpdmUgbG9ja2luZyBkZXRlY3RlZAo+
IDUuMTEuMC1zeXprYWxsZXIgIzAgTm90IHRhaW50ZWQKPiAtLS0tLS0tLS0tLS0tLS0tLS0tLS0t
LS0tLS0tLS0tLS0tLS0tLS0tLS0tLQo+IHN5ei1leGVjdXRvci4wLzEwMjQxIGlzIHRyeWluZyB0
byBhY3F1aXJlIGxvY2s6Cj4gZmZmZjg4ODAxMmUwOTEzMCAoJnJ1bnRpbWUtPnNsZWVwKXsuLi0u
fS17MjoyfSwgYXQ6IHNwaW5fbG9jayBpbmNsdWRlL2xpbnV4L3NwaW5sb2NrLmg6MzU0IFtpbmxp
bmVdCj4gZmZmZjg4ODAxMmUwOTEzMCAoJnJ1bnRpbWUtPnNsZWVwKXsuLi0ufS17MjoyfSwgYXQ6
IGlvX3BvbGxfZG91YmxlX3dha2UrMHgyNWYvMHg2YTAgZnMvaW9fdXJpbmcuYzo0OTIxCj4KPiBi
dXQgdGFzayBpcyBhbHJlYWR5IGhvbGRpbmcgbG9jazoKPiBmZmZmODg4MDEzYjAwMTMwICgmcnVu
dGltZS0+c2xlZXApey4uLS59LXsyOjJ9LCBhdDogX193YWtlX3VwX2NvbW1vbl9sb2NrKzB4YjQv
MHgxMzAga2VybmVsL3NjaGVkL3dhaXQuYzoxMzcKPgo+IG90aGVyIGluZm8gdGhhdCBtaWdodCBo
ZWxwIHVzIGRlYnVnIHRoaXM6Cj4gIFBvc3NpYmxlIHVuc2FmZSBsb2NraW5nIHNjZW5hcmlvOgo+
Cj4gICAgICAgIENQVTAKPiAgICAgICAgLS0tLQo+ICAgbG9jaygmcnVudGltZS0+c2xlZXApOwo+
ICAgbG9jaygmcnVudGltZS0+c2xlZXApOwo+Cj4gICoqKiBERUFETE9DSyAqKioKPgo+ICBNYXkg
YmUgZHVlIHRvIG1pc3NpbmcgbG9jayBuZXN0aW5nIG5vdGF0aW9uCj4KPlNpbmNlIHRoZSBmaXgg
aXMgaW4geWV0IHRoaXMga2VlcHMgZmFpbGluZyAoYW5kIEkgZGlkbid0IGdldCBpdCksID5JIGxv
b2tlZAo+Y2xvc2VyIGF0IHRoaXMgcmVwb3J0LiBXaGlsZSB0aGUgbmFtZXMgb2YgdGhlIGxvY2tz
IGFyZSB0aGUgPnNhbWUsIHRoZXkgYXJlCj5yZWFsbHkgdHdvIGRpZmZlcmVudCBsb2Nrcy4gU28g
bGV0J3MgdHJ5IHRoaXMuLi4KCkhlbGxvIEplbnMgQXhib2UKClNvcnJ5LCBJIHByb3ZpZGVkIHRo
ZSB3cm9uZyBpbmZvcm1hdGlvbiBiZWZvcmUuIApJJ20gbm90IHZlcnkgZmFtaWxpYXIgd2l0aCBp
b191cmluZywgIGJlZm9yZSB3ZSBzdGFydCB2ZnNfcG9sbCBhZ2FpbiwgIHNob3VsZCB3ZSBzZXQg
ICdwb2xsLT5oZWFkID0gTlVMTCcgID8gIAoKZGlmZiAtLWdpdCBhL2ZzL2lvX3VyaW5nLmMgYi9m
cy9pb191cmluZy5jCmluZGV4IDQyYjY3NTkzOTU4Mi4uY2FlNjA1YzE0NTEwIDEwMDY0NAotLS0g
YS9mcy9pb191cmluZy5jCisrKyBiL2ZzL2lvX3VyaW5nLmMKQEAgLTQ4MjQsNyArNDgyNCw3IEBA
IHN0YXRpYyBib29sIGlvX3BvbGxfcmV3YWl0KHN0cnVjdCBpb19raW9jYiAqcmVxLCBzdHJ1Y3Qg
aW9fcG9sbF9pb2NiICpwb2xsKQogCiAgICAgICAgaWYgKCFyZXEtPnJlc3VsdCAmJiAhUkVBRF9P
TkNFKHBvbGwtPmNhbmNlbGVkKSkgewogICAgICAgICAgICAgICAgc3RydWN0IHBvbGxfdGFibGVf
c3RydWN0IHB0ID0geyAuX2tleSA9IHBvbGwtPmV2ZW50cyB9OwotCisgICAgICAgICAgICAgICBw
b2xsLT5oZWFkID0gTlVMTDsKICAgICAgICAgICAgICAgIHJlcS0+cmVzdWx0ID0gdmZzX3BvbGwo
cmVxLT5maWxlLCAmcHQpICYgcG9sbC0+ZXZlbnRzOwogICAgICAgIH0KCiAKClRoYW5rcwpRaWFu
ZwoKPgo+I3N5eiB0ZXN0OiBnaXQ6Ly9naXQua2VybmVsLmRrL2xpbnV4LWJsb2NrIHN5emJvdC10
ZXN0Cj4KPi0tCj5KZW5zIEF4Ym9lCgo=
