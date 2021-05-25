Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3228738F7CE
	for <lists+io-uring@lfdr.de>; Tue, 25 May 2021 04:01:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229976AbhEYCDB (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 24 May 2021 22:03:01 -0400
Received: from mx0a-0064b401.pphosted.com ([205.220.166.238]:7418 "EHLO
        mx0a-0064b401.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229550AbhEYCDB (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 24 May 2021 22:03:01 -0400
Received: from pps.filterd (m0250809.ppops.net [127.0.0.1])
        by mx0a-0064b401.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 14P1xqVl006812;
        Mon, 24 May 2021 19:01:20 -0700
Received: from nam11-co1-obe.outbound.protection.outlook.com (mail-co1nam11lp2171.outbound.protection.outlook.com [104.47.56.171])
        by mx0a-0064b401.pphosted.com with ESMTP id 38rmkbr3mw-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 24 May 2021 19:01:20 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=mfKo51hHxUI5WtzQV9wEY1lnbqYSsIo/tXAd7fc+6SzkqUGX17xGPb8XOx2bHNxFS6JGGGPu0ZiHqm2W5jW2dqIz4bNSxOHs4ZH+57URwF3czwNfdQ17FnLOf/kJ9HUVmeHCx3jUaxtKaCO5sSJ953MnTM/MF4OutPnVXGokAdA+mWdr9P4cnD7l1WKnSLfgqQZpl4VprXvBHXhxl4NKZEBneAJwb0l5WJjO350zBlFvaD3sXnkQ3O52PqRuZHQneh9JT6vLtMQzA7svKeVKMPVlGMP/u7vAjCtDSzCauek4SPR38aw5//vHL4NEZX5nu/yDKLieKHqs40uPzZ+ioA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=rMcgJAY2xVkQo8fnJjp3FOojH4yyaxnAL/kjXpKW2kc=;
 b=S3Do61FDq8+ts6/3tnQoiOwLZKFsqpZrIIamxi8lgGXMDR89AdrOb7+xPYhefH+++jJjH3nAzu1VyEt86Cs+T5e+piYzY1qLQ+kBwCcCR2tWwmvTk3zuzzvb4XlyG0ly5kr2hTTB+YLzGk4aIJfm8esEyVNBg6YNUIVWEH6IGlyhgEEVO6/Qs4A5IW+Jo51AVhzYKte0VSHNVxTdnoFKgfXyXdBnBvoDw8n3Rn88VBuOanA0U2SnTQ23ebZIb7Y7AeOcrEn5kAlkVVf5N4BjkEDU/YWHx7bpWFFwYc0xCkhALnBGPTZ6JT69Rj8iWhSMdBPTe8nzlXP5z8V8wW3lgQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=windriver.com; dmarc=pass action=none
 header.from=windriver.com; dkim=pass header.d=windriver.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=windriversystems.onmicrosoft.com;
 s=selector2-windriversystems-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=rMcgJAY2xVkQo8fnJjp3FOojH4yyaxnAL/kjXpKW2kc=;
 b=nqVMZeY0/bsnWp27X18nAHPUyUHtKqv830C0qrOeHetqHar7yIJzQlwKZmwapIViKHos3yfwOo3WfK9JOBvckivPU0I4rJv8DWVs2znGjqBNGXcKCPVtN/SZbiAqsLUVqHooCg5kJTHPAmID6Qrs5kTuhJBLpPJEHu35Frp+/rk=
Received: from DM6PR11MB4202.namprd11.prod.outlook.com (2603:10b6:5:1df::16)
 by DM5PR1101MB2108.namprd11.prod.outlook.com (2603:10b6:4:53::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4150.27; Tue, 25 May
 2021 02:01:18 +0000
Received: from DM6PR11MB4202.namprd11.prod.outlook.com
 ([fe80::3590:5f5:9e9e:ed18]) by DM6PR11MB4202.namprd11.prod.outlook.com
 ([fe80::3590:5f5:9e9e:ed18%7]) with mapi id 15.20.4150.027; Tue, 25 May 2021
 02:01:18 +0000
From:   "Zhang, Qiang" <Qiang.Zhang@windriver.com>
To:     Pavel Begunkov <asml.silence@gmail.com>,
        Hillf Danton <hdanton@sina.com>,
        "axboe@kernel.dk" <axboe@kernel.dk>
CC:     "syzbot+6cb11ade52aa17095297@syzkaller.appspotmail.com" 
        <syzbot+6cb11ade52aa17095297@syzkaller.appspotmail.com>,
        "io-uring@vger.kernel.org" <io-uring@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: =?gb2312?B?u9i4tDogu9i4tDogW1BBVENIXSBpby13cTogRml4IFVBRiB3aGVuIHdha2V1?=
 =?gb2312?Q?p_wqe_in_hash_waitqueue?=
Thread-Topic: =?gb2312?B?u9i4tDogW1BBVENIXSBpby13cTogRml4IFVBRiB3aGVuIHdha2V1cCB3cWUg?=
 =?gb2312?Q?in_hash_waitqueue?=
Thread-Index: AQHXUG0DVlNQX3He7UO9rugYN/DIOKryS+MAgAANvFKAABFMAIABABUr
Date:   Tue, 25 May 2021 02:01:17 +0000
Message-ID: <DM6PR11MB4202561CE9ECD5B7F8DD74AFFF259@DM6PR11MB4202.namprd11.prod.outlook.com>
References: <20210524071844.24085-1-qiang.zhang@windriver.com>
 <20210524082536.2032-1-hdanton@sina.com>
 <DM6PR11MB4202B442C4C27740B6EE2D64FF269@DM6PR11MB4202.namprd11.prod.outlook.com>,<916ad789-c996-258f-d3b7-b41d749618d8@gmail.com>
In-Reply-To: <916ad789-c996-258f-d3b7-b41d749618d8@gmail.com>
Accept-Language: zh-CN, en-US
Content-Language: zh-CN
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: gmail.com; dkim=none (message not signed)
 header.d=none;gmail.com; dmarc=none action=none header.from=windriver.com;
x-originating-ip: [60.247.85.82]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: adfbc61c-6f46-40e7-79be-08d91f20fc3d
x-ms-traffictypediagnostic: DM5PR1101MB2108:
x-microsoft-antispam-prvs: <DM5PR1101MB2108A8CF47C80700049A0A62FF259@DM5PR1101MB2108.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8273;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 4Wv/VynpLOoMKc85ihnRkrAVVPnxHc/3tm6Jw5D5Y/OxjPtH+D5k06W10LOnX/QrH0DiKiz1SIcCBp619V2gH+T5i3PD5FQ3tbjM9f2us2YcLgzHR8mvOsyQVcc9XF29iXG/5teSgXH++crxieNghxeHL2otbm/yPzq5HIlrL0ENrYOSJvv/5D13PEssSfTNr3ni+mub48XZs9/5g3b3WcSYBkWD9dzh2rCiROdulVI1jq6vqGd0K66qT7y2BS2W63dmrdXPtr9mt8eKpVpUR6HxPSNuxgVpIXIaEYVLxLf4TZvOzP4zUwm9ikcaOmHKc5OuCGMAIPm9eT7RyfRV4eP08i79RE98RC9pD4EfWiiAy7Bx8rMzRs606ldbuolZq2jrPhBCIkbEjmFjI1WOkJNXTmLcrm9i1dkregu+nRbf0RAJumy22b5AUOl7Buc2kEM9FxTQFS0YHAbYZYf2qvYCV6TrMvuofW8rsDsRY+ajTQHhr7au7zQ7izfntpGitSWEi/oL8TqzPTFHfgOcVdVWKhxm+oKzHieWfX5YY7MdkFPphZzRj9iVN8rreNM/fs6lbHevIfnTHB/dHJf0RA==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR11MB4202.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(396003)(376002)(346002)(39840400004)(136003)(55016002)(2906002)(7696005)(8936002)(52536014)(224303003)(76116006)(122000001)(26005)(83380400001)(6506007)(5660300002)(53546011)(66946007)(54906003)(110136005)(38100700002)(71200400001)(66476007)(316002)(33656002)(4326008)(86362001)(186003)(66446008)(66556008)(478600001)(64756008)(9686003);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: =?gb2312?B?L253SnpzaThpcGdnWXE2V1p2cUFGQXNLdUZPZjdaVXhzdXdzL3JESytoc0Jx?=
 =?gb2312?B?RUgyMXNGUFJaaFl4WkE2UnhUUTJneGljTkRhamRYS3BZeERwOTE0T0JWVHBV?=
 =?gb2312?B?UGlDYUJRRFFJVkNOTldET0g4ZzFrVkxXcVNGNVlmOEs2NDdnN2ttUmt5OEk5?=
 =?gb2312?B?ZGFHR01aVVJSZG5QSDZIMG1JeklBUG5lL25IQ2lpWlM3bUhScE9Tbk5iZXZ3?=
 =?gb2312?B?VmxzUnR3OElBdEFSbHd3UFJKd0VDMHVlZ2ZKdndKU2liYWErd1Fpa29SV0RI?=
 =?gb2312?B?c1crSE1NKzd5SzhtdEYyNWlkZVlKSE5CdXVQK2Z2a0FBVlgvbDZUY0ZhSDhP?=
 =?gb2312?B?R096Mmh3eVFpbEk5RUpEZG1xZVN1dGQySlM5TGlSaFZqNlhUWHFxSEYzMkZ6?=
 =?gb2312?B?cjRmeWVIdldyL3d0eXRxNWR4KytXakF2amNRMTgrelVsejdQVnBZK3Y4djl4?=
 =?gb2312?B?VG10dVMvYVRlR3dnQVJRYjJOVGppVWk2cmwwYk5wNXhjQmNVck5oWVpkVUxr?=
 =?gb2312?B?MlBvbzdQQkljM3p2cnlFemxla09uamh4Y002L2x2cnFOWWRCbzYrQTBDSG1r?=
 =?gb2312?B?OWhPam9FS1NVQ0hKVEFkYnhvcGx6R0R0bzF2V282Z0RGbTM5ZjlCcGNjb3Nr?=
 =?gb2312?B?SXc3REJyNDdJNGV5YndQZW9POWg5MHJqY2hkOHFSdm1sTEJ0cmVkMmhtTlhj?=
 =?gb2312?B?cGZlU2VuWDdMRm9kZzlReXZNQS9mT3JYS3ViWFFkY2l5MHNEeUdrQUxvdDl2?=
 =?gb2312?B?NWd1emJlK2h6bVdxRmtGbkhpWldlM3kvNGU4WmlJdkhSKzNtaVA1UDU4bS94?=
 =?gb2312?B?NVpzNnM4N0hFMDJwNVJiQXJoOTREbU5WZ1FQYmx0MW54Q1Eya2Y3eEZLKzQ4?=
 =?gb2312?B?MElxazZYbS9Oczd2aXE2bXRaM2l4K1loRU9LQjlkS00zWGlvclRiWW1tc2NU?=
 =?gb2312?B?a3hDNEg5MlhoN1FlY1h1Kytrb0YvczQ5Zy9sR1ViNkVHeHBEUDJmZjZDRlpU?=
 =?gb2312?B?bTVYMEdYU3pJaTNLTzROK1pSSE9PdEt0eEN2d1J2Q21DcUNpS3VMcWJiOTla?=
 =?gb2312?B?SVdpNncycCtERTVCSGF5WHBpZjYrUUMvUlJLU2p4ek9OZkFMNVdFY0xHVE0v?=
 =?gb2312?B?ZTNqSHRMTFF3YzVOVE1BWmpvVnF3K0ZJV0gwQXdWZldUM1gzdUhrdUJxNnc1?=
 =?gb2312?B?a3JUT3BFeXJWYVVQTkNrd1N3VnZLeDFpSUhxSlRyT3BwMW5MbjUxQThMd3I5?=
 =?gb2312?B?VThDOFNVYlcyd1RBaS8wMU9kMEIyeDIvTXg3M2hudXY0cGRxdmIyT3ZBZUdJ?=
 =?gb2312?B?YytMbXVwOXdZOENlMkhwNHN4UHZNOWhteE1YY3ZGNHNEc2FQM1V2V1orM1FK?=
 =?gb2312?B?cXIzL1FjaGVuRFNjRzVjemtNejVLNTlhd0NVZUxHek9CZU9jdlhDYlRsQzdE?=
 =?gb2312?B?eW4wNEVDam9lTW1wOHdnSE5lc2o4b1VDQXdqVTFqY0tWVXZXSVIyNTRzS3h0?=
 =?gb2312?B?SDBhcGdTWDJ1a2NtRkN5NHdWYU1WbklMVnRsNHUxb1VWakZxY3d2UDZ5SXpl?=
 =?gb2312?B?SXBNR1pPTzdaYTZyTklMSGJIMXFSVGdpM05wSzhPaW51MWpWVEVJcTFHemQy?=
 =?gb2312?B?QTFLdlA4S0tmT09GQkVMVmJvQ1NldW1xdlJzQWVZb2cyd1ZjcCtrSDQ4U3cx?=
 =?gb2312?B?SWd5VHlyUWVVNUhEcWFDMXlqQXpuamN1S0JzUjJPTEdNazJmSHk2dEo5ZVhp?=
 =?gb2312?Q?l+uA0GfOsFNIA9YoZo=3D?=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="gb2312"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: windriver.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM6PR11MB4202.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: adfbc61c-6f46-40e7-79be-08d91f20fc3d
X-MS-Exchange-CrossTenant-originalarrivaltime: 25 May 2021 02:01:17.8529
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ddb2873-a1ad-4a18-ae4e-4644631433be
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: rkj0FkFiOhN0on8IBBeqfLkEX5sLCgnnh1YNnM2gez9nyj4p8f67YkGepJzqBhS5DBwavBLq2FOCcTIYJDyqDCdkWLRArIkrm5Te9DdvOj0=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR1101MB2108
X-Proofpoint-ORIG-GUID: sproU1LL2ugAigxXrbOx-cnuOAnJZE7D
X-Proofpoint-GUID: sproU1LL2ugAigxXrbOx-cnuOAnJZE7D
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.761
 definitions=2021-05-24_11:2021-05-24,2021-05-24 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 phishscore=0 mlxlogscore=998
 mlxscore=0 malwarescore=0 bulkscore=0 impostorscore=0 clxscore=1015
 lowpriorityscore=0 adultscore=0 priorityscore=1501 spamscore=0
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2104190000 definitions=main-2105250011
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

CgpfX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fCreivP7IyzogUGF2ZWwg
QmVndW5rb3YgPGFzbWwuc2lsZW5jZUBnbWFpbC5jb20+Creiy83KsbzkOiAyMDIxxOo11MIyNMjV
IDE4OjE2CsrVvP7IyzogWmhhbmcsIFFpYW5nOyBIaWxsZiBEYW50b247IGF4Ym9lQGtlcm5lbC5k
awqzrcvNOiBzeXpib3QrNmNiMTFhZGU1MmFhMTcwOTUyOTdAc3l6a2FsbGVyLmFwcHNwb3RtYWls
LmNvbTsgaW8tdXJpbmdAdmdlci5rZXJuZWwub3JnOyBsaW51eC1rZXJuZWxAdmdlci5rZXJuZWwu
b3JnCtb3zOI6IFJlOiC72Li0OiBbUEFUQ0hdIGlvLXdxOiBGaXggVUFGIHdoZW4gd2FrZXVwIHdx
ZSBpbiBoYXNoIHdhaXRxdWV1ZQoKW1BsZWFzZSBub3RlOiBUaGlzIGUtbWFpbCBpcyBmcm9tIGFu
IEVYVEVSTkFMIGUtbWFpbCBhZGRyZXNzXQoKT24gNS8yNC8yMSAxMDoxOSBBTSwgWmhhbmcsIFFp
YW5nIHdyb3RlOgpbLi4uXQo+PiBTY3JhdGNoIHNjYWxwIG9uZSBpbmNoIG9mZiB0byB3b3JrIG91
dCBob3cgdGhpcyBpcyBhIGN1cmUgZ2l2ZW4gYSkgdWFmIG1ha2VzCj4+IG5vIHNlbnNlIHdpdGhv
dXQgZnJlZSBhbmQgYikgaG93IGlvIHdvcmtlcnMgY291bGQgc3Vydml2ZQo+PiB3YWl0X2Zvcl9j
b21wbGV0aW9uKCZ3cS0+d29ya2VyX2RvbmUpLgo+Pgo+PiBJZiB0aGV5IGNvdWxkIE9UT0ggdGhl
biB0aGlzIGlzIG5vdCB0aGUgcGlsbCBmb3IgdGhlIGxlYWsgaW4gd29ya2VyX3JlZnMuCj4KPiBI
ZWxsbyBQYXZlbCBCZWd1bmtvdiwgSGlsbGYgRGFudG9uCj4KPiBTb3JyeSB0aGVyZSBpcyBhIHBy
b2JsZW0gd2l0aCB0aGUgY2FsbHRyYWNlIGRlc2NyaWJlZCBpbiBteSBtZXNzYWdlLiBQbGVhc2Ug
aWdub3JlIHRoaXMgbW9kaWZpY2F0aW9uCj4KPkhhdmVuJ3QgbG9va2VkIGF0IHRoZSB0cmFjZSBh
bmQgZGVzY3JpcHRpb24sIGJ1dCBJIGRvIHRoaW5rCj50aGVyZSBpcyBhIHByb2JsZW0gaXQgc29s
dmVzLgo+Cj4xKSBpb193YWl0X29uX2hhc2goKSAtPiBfX2FkZF93YWl0X3F1ZXVlKCZoYXNoLT53
YWl0LCAmd3FlLT53YWl0KTsKPjIpIChub3RlOiB3cWUgaXMgYSB3b3JrZXIpIHdxZSdzIHdvcmtl
cnMgZXhpdCBkcm9wcGluZyByZWZzCj4zKSByZWZzIGFyZSB6ZXJvLCBmcmVlIGlvLXdxCj40KSBA
aGFzaCBpcyBzaGFyZWQsIHNvIG90aGVyIHRhc2svd3EgZG9lcyB3YWtlX3VwKCZ3cS0+aGFzaC0+
d2FpdCk7Cj41KSBpdCB3YWtlcyBmcmVlZCB3cWUKPgo+c3RlcCA0KSBpcyBhIGJpdCBtb3JlIHRy
aWNraWVyIHRoYW4gdGhhdCwgdGw7ZHI7Cj53cTM6d29ya2VyMSAgICAgfCBsb2NrcyBiaXQxCj53
cTE6d29ya2VyMiAgICAgfCB3YWl0cyBiaXQxCj53cTI6d29ya2VyMSAgICAgfCB3YWl0cyBiaXQx
Cj53cTE6d29ya2VyMyAgICAgfCB3YWl0cyBiaXQxCj4KPndxMzp3b3JrZXIxICAgICB8IGRyb3Ag
IGJpdDEKPndxMTp3b3JrZXIyICAgICB8IGxvY2tzIGJpdDEKPndxMTp3b3JrZXIyICAgICB8IGNv
bXBsZXRlcyBhbGwgd3ExIGJpdDEgd29yayBpdGVtcwo+d3ExOndvcmtlcjIgICAgIHwgZHJvcCAg
Yml0MSwgZXhpdCBhbmQgZnJlZSBpby13cQo+Cj53cTI6d29ya2VyMSAgICAgfCBsb2NrcyBiaXQx
Cj53cTEgICAgICAgICAgICAgfCBmcmVlIGNvbXBsZXRlCj53cTI6d29ya2VyMSAgICAgfCBkcm9w
cyBiaXQxCj53cTE6d29ya2VyMyAgICAgfCB3YWtlZCB1cCwgZXZlbiB0aG91Z2ggZnJlZWQKPgo+
Q2FuIGJlIHNpbXBsaWZpZWQsIGRvbid0IHdhbnQgdG8gd2FzdGUgdGltZSBvbiB0aGF0CgpUaGFu
a3MgUGF2ZWwKCllvdXIgZGVzY3JpcHRpb24gaXMgYmV0dGVyLiAgSSBoYXZlIGFub3RoZXIgcXVl
c3Rpb246IHVuZGVyIHdoYXQgY2lyY3Vtc3RhbmNlcyB3aWxsIHRocmVlIGlvLXdxKHdxMSwgd3Ey
LCB3cTMpIGJlIGNyZWF0ZWQgdG8gc2hhcmUgdGhpcyBAaGFzaD8KClRoaXMga2luZCBvZiBwcm9i
bGVtIGFsc28gb2NjdXJzIGJldHdlZW4gdHdvIGlvLXdxKHdxMSwgd3EyKS4gSXMgdGhlIGZvbGxv
d2luZyBkZXNjcmlwdGlvbiBPS6O/Cgp3cTE6d29ya2VyMiAgICAgfCBsb2NrcyBiaXQxCndxMjp3
b3JrZXIxICAgICB8IHdhaXRzIGJpdDEKd3ExOndvcmtlcjMgICAgIHwgd2FpdHMgYml0MQoKd3Ex
OndvcmtlcjIgICAgIHwgY29tcGxldGVzIGFsbCB3cTEgYml0MSB3b3JrIGl0ZW1zCndxMTp3b3Jr
ZXIyICAgICB8IGRyb3AgIGJpdDEsIGV4aXQgYW5kIGZyZWUgaW8td3EKCndxMjp3b3JrZXIxICAg
ICB8IGxvY2tzIGJpdDEKd3ExICAgICAgICAgICAgICAgICAgICAgICB8IGZyZWUgY29tcGxldGUK
d3EyOndvcmtlcjEgICAgIHwgZHJvcHMgYml0MQp3cTE6d29ya2VyMyAgICAgfCB3YWtlZCB1cCwg
ZXZlbiB0aG91Z2ggZnJlZWQKClpoYW5nCj4KPi0tCj5QYXZlbCBCZWd1bmtvdgo=
