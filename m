Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1515438E329
	for <lists+io-uring@lfdr.de>; Mon, 24 May 2021 11:19:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232422AbhEXJUz (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 24 May 2021 05:20:55 -0400
Received: from mx0a-0064b401.pphosted.com ([205.220.166.238]:40564 "EHLO
        mx0a-0064b401.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232397AbhEXJUz (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 24 May 2021 05:20:55 -0400
Received: from pps.filterd (m0250810.ppops.net [127.0.0.1])
        by mx0a-0064b401.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 14O9EQGT020003;
        Mon, 24 May 2021 02:19:16 -0700
Received: from nam04-bn8-obe.outbound.protection.outlook.com (mail-bn8nam08lp2041.outbound.protection.outlook.com [104.47.74.41])
        by mx0a-0064b401.pphosted.com with ESMTP id 38qrtb0e67-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 24 May 2021 02:19:16 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=c5f95zOcW0cNCrmt5Voht4PIrIOYQNCEyVD4XNrLHXcQo7B9w1soov183QwL6uCcqexKplHfydUH0C39wUDaTy3s+UjsGXT1S1noen09yzB/hYIcF5KqaPvrSgWEH5+5l3RGpx47CZfErbj5M1bYjN+d2x0zaQTXL3UOaxm5aw2nlvpxYPoImmv+95lyGq4aEMJ2aePiFl0HliomKrbOwCJ5F33YZ+IvMyfuwBTbjXOAn9t7aTDbyluw8G4ogFyncnt4fZ66GuM7Q9OE3aEoos3a7cJ2LgQm2+bjYnPtlZK5rChwRCjrsbtzVCBYoptgx3Td0ORrAqyOxyzpfnsh6A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=hc1w4z2vtzO76f9myZkD4GiZhx6ADdsKFymXjj7mUpc=;
 b=nFmx+637jVc7ra0f76l96W9J/xXVTe9+2GPUcVBH5+c4t/zY6ICsXKoVtD2rwIotOvn/pCQBMYgtYLswzIU8wb4NtopEtfnJI0goJKloZ7imvA2NexBRkTLNlqZ+N4o0wldXHuvlj1t4sk+bYW06qj+Efs6K5S5K1QGy+hZx7H5K6GcYYkxYD4tLLsK0RYWi5p+ffcgK/wd2i379ytqshC4ZNsjXRIPHW63tHDzR0nQY83h2SuCsXC5qiFXUi3nn5+f2atvtStIws7VbAcn/koBB2F3ZFfFmqHSNfmTrL64fBMzG++0NuQct4E60owZWtPXBBAdvgrCqsFBy/GhuZg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=windriver.com; dmarc=pass action=none
 header.from=windriver.com; dkim=pass header.d=windriver.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=windriversystems.onmicrosoft.com;
 s=selector2-windriversystems-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=hc1w4z2vtzO76f9myZkD4GiZhx6ADdsKFymXjj7mUpc=;
 b=DPl3rfsEJqzPyGrd0TMYQTboOmWbk4l0zhJP/1VzKw+em8Dqj8xkPLaBet9qCymxOEWAJ+2PZYK1tzDY3KD9+tsP71kmDKjenod11jVOskRQ7DBHvVZ3aNWnkc3nvO2N6dSZsYZkLKc0uvK6JP8LPTjTURQUhpj/DutJYTjryuw=
Received: from DM6PR11MB4202.namprd11.prod.outlook.com (2603:10b6:5:1df::16)
 by DM5PR11MB1242.namprd11.prod.outlook.com (2603:10b6:3:14::8) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.4150.26; Mon, 24 May 2021 09:19:14 +0000
Received: from DM6PR11MB4202.namprd11.prod.outlook.com
 ([fe80::3590:5f5:9e9e:ed18]) by DM6PR11MB4202.namprd11.prod.outlook.com
 ([fe80::3590:5f5:9e9e:ed18%7]) with mapi id 15.20.4150.027; Mon, 24 May 2021
 09:19:14 +0000
From:   "Zhang, Qiang" <Qiang.Zhang@windriver.com>
To:     Hillf Danton <hdanton@sina.com>,
        "asml.silence@gmail.com" <asml.silence@gmail.com>,
        "axboe@kernel.dk" <axboe@kernel.dk>
CC:     "syzbot+6cb11ade52aa17095297@syzkaller.appspotmail.com" 
        <syzbot+6cb11ade52aa17095297@syzkaller.appspotmail.com>,
        "io-uring@vger.kernel.org" <io-uring@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: =?gb2312?B?u9i4tDogW1BBVENIXSBpby13cTogRml4IFVBRiB3aGVuIHdha2V1cCB3cWUg?=
 =?gb2312?Q?in_hash_waitqueue?=
Thread-Topic: [PATCH] io-wq: Fix UAF when wakeup wqe in hash waitqueue
Thread-Index: AQHXUG0DVlNQX3He7UO9rugYN/DIOKryS+MAgAANvFI=
Date:   Mon, 24 May 2021 09:19:14 +0000
Message-ID: <DM6PR11MB4202B442C4C27740B6EE2D64FF269@DM6PR11MB4202.namprd11.prod.outlook.com>
References: <20210524071844.24085-1-qiang.zhang@windriver.com>,<20210524082536.2032-1-hdanton@sina.com>
In-Reply-To: <20210524082536.2032-1-hdanton@sina.com>
Accept-Language: zh-CN, en-US
Content-Language: zh-CN
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: sina.com; dkim=none (message not signed)
 header.d=none;sina.com; dmarc=none action=none header.from=windriver.com;
x-originating-ip: [60.247.85.82]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: b1256c97-8f20-429a-9711-08d91e94ffdf
x-ms-traffictypediagnostic: DM5PR11MB1242:
x-microsoft-antispam-prvs: <DM5PR11MB12423ADABA9F825BFCF2AFF6FF269@DM5PR11MB1242.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:9508;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: cZhAF1w+K01f4q2Bp2R30sviidgx8hYIcOwVUs73NtqSd9L8y7sFtXt0TPtok3KwH85xK33VerdNOjaVdd0yrvppNnrMd/90OhCx+zKEEY0sf7/lmiqyEG4Sj4/9ICv2s6WHKHFTB0vb1jMwtU0Y5GBXW3CV4HoI1+7nw2BB+zqMdhvIzG9EBo/6J0/ocJ2wwehhFlG0vwx2m15X1LUtV82uSn0YsGnXV3awT4+qtjT8JVepNea40I6o6AeKzx6zXh8sPXGr19WXvewA66uDr8zN8SlgaLyfnNegNIdicGYT/J0gwpJ6i2tA3AhaCB0KuvWbgF1ItWVQt1ZjuWXkQBnq1bOOxD6OpIaMNna9IRLo3txgJ56IiatX6ILK0VPFHFLngpGolMxQxyZMsWUmZiHeNDMULY5CJywjxddEbs9yIJ1D5WpxGNC1fngjPn5rE9gOFzr6YsxZLheBrjNh1TA3aa+Hnp7bJIufco9xq3UGiwvFUdU8+D7cMt/gSKLR+WkZSq7jtzRe3Ef1HTDjm4QuAOHAGKzRGKRTATxVsYiKAk00FOmvhu08+5I1H5ytDllOwnk9fkFuFcK7+XSit1ke4SWI6wltS84xEExxfzs=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR11MB4202.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(396003)(136003)(366004)(376002)(346002)(39840400004)(8936002)(86362001)(38100700002)(2906002)(66446008)(55016002)(52536014)(5660300002)(26005)(186003)(64756008)(224303003)(122000001)(71200400001)(316002)(4326008)(66946007)(54906003)(6506007)(33656002)(76116006)(110136005)(7696005)(9686003)(478600001)(83380400001)(66556008)(66476007);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: =?gb2312?B?U1lYS3ZWLzdIdE1RS3orYUxORjQ1N2lHalJVRGVmc2svblRSTHFzRnZiOHc2?=
 =?gb2312?B?UW1GNFRZc05KM3pNM2dMZ1pmSHBTaExZTkg2V0N2NDgzTE9SRWNTeXVpcE1j?=
 =?gb2312?B?eW96OENLaW1RZ3cvbkRWU0p3SHNieWtHM21wdGdUcjJjNGpCUGdqTXQ4TlJa?=
 =?gb2312?B?VEU4NkFOMXI4dDYzNXpSWkNTaUo1N2s1VTVSTFlHSjhBL0RYYWlRU3FweDZF?=
 =?gb2312?B?bm85b2JkbHI2c2g4NE92RTNHNm1zWlQyNHRRUVVpV05uN0xnNURGMGRaMGQr?=
 =?gb2312?B?VUdkTndCTEJQdTdOTURqSFVUYlkyNDZRL0x2bnZTbHJ4SnMzVGdVVzNoalg4?=
 =?gb2312?B?cDRCRzhuRW85blo2MDJGcGRhd3JoYVVJUlZ2L2FlZDc4QWc1WFUrbHBxNVFS?=
 =?gb2312?B?ckdPUGlzRlZwdU4wWG9SdWN4dzN4Yzh0ZzNGTUN6Um04ZEQ5dTE4cjRXbGlB?=
 =?gb2312?B?OUpSeGVQK1BXTUFTTFZxSi9yQTUrdEllSmRrZlZyVXlQTkdEN3BTMmV2VHpW?=
 =?gb2312?B?dEJJUkpRWFk2cGlCb3lRR0ZkMXhLcDhvMVdqMkJKNi9aRGpZME9RbXgyNERP?=
 =?gb2312?B?MHJHc0tqeFhJaUxRWHdIQ2FRc3psRldCWUxOQkZoWU45K3lsWFlQMFVaNlJY?=
 =?gb2312?B?dUdGRkdDYXYvMnYrMUxJSlFmOENKOEZWMll0OVM0dUxqK2ZFR084UXl3b1NL?=
 =?gb2312?B?TC9sSlFQb0pYZlZ2VGp0eUVrcFYzb253cDF6OEtrSSs0WERRRmhCdlFRUit1?=
 =?gb2312?B?eHA1Y2JaN1BuWEJPcWErZDZ5QVNFY1VscXVEaXR1c2M4NkNIRm5McXdFZDA0?=
 =?gb2312?B?STlHWGJkc2Nwcm9ObTM5YzVueFpsaHZhNVZaWWl2MU5vb2VGM2pEUTArbFdE?=
 =?gb2312?B?dnRrdFlIOENZZDMydW8rSnNKaWhOcE11VGxVQ1lST3NDNGtrUEM3cDVtaUFK?=
 =?gb2312?B?K3E1RU1HODFzY3M4VHhXVmZlUDBKcHYrdnhNTEUxY2h1bUFueDNFSHBnRlEx?=
 =?gb2312?B?U3hiK1RDdjUyK2tCTnd1NEt5TlI4Yndyd2pXRHVZSXBsYkdqUFVpUkVUTnBt?=
 =?gb2312?B?ME9yU0t1RFJhdVlFREJ5QTBOaXB0RnRSU3FrdWtwUXBJMDIrOHhhSEU1V0hD?=
 =?gb2312?B?TzI0blI0NDJUL1VRdTFLaFE1VVk1Q0xObHNVR3lXZk9lREduUTY0TFBaRXB2?=
 =?gb2312?B?QWJMUnUvRFRWeXVoMFlnSUVsOVVoVjhJa05uTjJFZXRwOXN0R29XbC9Kaitr?=
 =?gb2312?B?ODhlNCtYZmtMQk16cG4yT3dwVEhyYlRXUEE1ZzJ4cGRKTTRTY25xYURwNEx1?=
 =?gb2312?B?RGE3UUZLaU9DZkRMZlJXeEorbmhsWnFSd1lBNllweEpYcThPenA3MXlCdlNr?=
 =?gb2312?B?SjJNR0hHYm5EOEJUdkxndjhBdDZXampBSHdrSElEOEJoaXRsSUdpdUR0dWRZ?=
 =?gb2312?B?NkF3T2dzdGJ4QWE0cWhQTTFhWUxoTk55TU5WWTlCSWJZcVpwd1BkTDJVcFU3?=
 =?gb2312?B?VFZQWDdLL1IwYkhCejVNZEFvb0tpMnA2dTI5VTBXK0N4T3VxcjZsZHhlcmtk?=
 =?gb2312?B?RjJoNitKQ1pxeFNmeEVTU0NrdTlvcnh0ZytzYmJDaDRBbWNMYk1wQVA3VDRE?=
 =?gb2312?B?Y0RoU2lmSXJZclJFU2pBdHJwUGtyb2hDK0lLVGdncEIwaGNKMlRKVFRtZ2t3?=
 =?gb2312?B?TVJGRmw0SXhvM3hOUDdGeDhzQWM3RkROY2ttSEl0cTgreDRuTVZRQldsOWVx?=
 =?gb2312?Q?t23A7PtwiMtjS5eXYE=3D?=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="gb2312"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: windriver.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM6PR11MB4202.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b1256c97-8f20-429a-9711-08d91e94ffdf
X-MS-Exchange-CrossTenant-originalarrivaltime: 24 May 2021 09:19:14.5412
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ddb2873-a1ad-4a18-ae4e-4644631433be
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: AqXkc4+cokUdEarWlarHQ8Cv8N/cAuMzMhuXDbJDDMpUvWNVtBzgKpjDEIPNIpMfMP1OtJVNKGXhvDUhxSXk3nlEWZUs44C4pD3LvBcz4YY=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR11MB1242
X-Proofpoint-GUID: 5Q8hs0DqWUY3okBT5RF9OfJSLC0utra_
X-Proofpoint-ORIG-GUID: 5Q8hs0DqWUY3okBT5RF9OfJSLC0utra_
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.761
 definitions=2021-05-24_05:2021-05-24,2021-05-24 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 clxscore=1011
 priorityscore=1501 lowpriorityscore=0 spamscore=0 phishscore=0
 suspectscore=0 mlxlogscore=999 impostorscore=0 adultscore=0 malwarescore=0
 bulkscore=0 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2104190000 definitions=main-2105240070
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

CgpfX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fCreivP7IyzogSGlsbGYg
RGFudG9uIDxoZGFudG9uQHNpbmEuY29tPgq3osvNyrG85DogMjAyMcTqNdTCMjTI1SAxNjoyNQrK
1bz+yMs6IFpoYW5nLCBRaWFuZwqzrcvNOiBheGJvZUBrZXJuZWwuZGs7IGFzbWwuc2lsZW5jZUBn
bWFpbC5jb207IHN5emJvdCs2Y2IxMWFkZTUyYWExNzA5NTI5N0BzeXprYWxsZXIuYXBwc3BvdG1h
aWwuY29tOyBpby11cmluZ0B2Z2VyLmtlcm5lbC5vcmc7IGxpbnV4LWtlcm5lbEB2Z2VyLmtlcm5l
bC5vcmcK1vfM4jogUmU6IFtQQVRDSF0gaW8td3E6IEZpeCBVQUYgd2hlbiB3YWtldXAgd3FlIGlu
IGhhc2ggd2FpdHF1ZXVlCgpbUGxlYXNlIG5vdGU6IFRoaXMgZS1tYWlsIGlzIGZyb20gYW4gRVhU
RVJOQUwgZS1tYWlsIGFkZHJlc3NdCgpPbiBNb24sIDI0IE1heSAyMDIxIDE1OjE4OjQ0ICswODAw
Cj4gRnJvbTogWnFpYW5nIDxxaWFuZy56aGFuZ0B3aW5kcml2ZXIuY29tPgo+Cj4gVGhlIHN5emJv
dCByZXBvcnQgYSBVQUYgd2hlbiBpb3Utd3JrIGFjY2Vzc2luZyB3cWUgb2YgdGhlIGhhc2gKPiB3
YWl0cXVldWUuIGluIHRoZSBjYXNlIG9mIHNoYXJpbmcgYSBoYXNoIHdhaXRxdWV1ZSBiZXR3ZWVu
IHR3bwo+IGlvLXdxLCB3aGVuIG9uZSBvZiB0aGUgaW8td3EgaXMgZGVzdHJveWVkLCBhbGwgaW91
LXdyayBpbiB0aGlzCj4gaW8td3EgYXJlIGF3YWtlbmVkLCBhbGwgd3FlIGJlbG9uZ2luZyB0byB0
aGlzIGlvLXdxIGFyZSByZW1vdmVkCj4gZnJvbSBoYXNoIHdhaXRxdWV1ZSwgYWZ0ZXIgdGhhdCwg
YWxsIGlvdS13cmsgYmVsb25naW5nIHRvIHRoaXMKPiBpby13cSBiZWdpbiBydW5uaW5nLCBzdXBw
b3NlIGZvbGxvd2luZyBzY2VuYXJpb3MsIHdxZVswXSBhbmQgd3FlWzFdCj4gYmVsb25nIHRvIHRo
aXMgaW8td3EsIGFuZCB0aGVzZSB3b3JrIGhhcyBzYW1lIGhhc2ggdmFsdWUuCj4KPiAgICAgQ1BV
MCAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgIENQVTEK
PiBpb3Utd3JrMCh3cWVbMF0pICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAg
ICBpb3Utd3JrMSh3cWVbMV0pCj4KPiB3aGlsZSB0ZXN0X2JpdCBJT19XUV9CSVRfRVhJVCAgICAg
ICAgICAgICAgICAgd2hpbGUgdGVzdF9iaXQgSU9fV1FfQklUX0VYSVQKPiAgICAgICAgICAgICAg
ICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICBpb193b3JrZXJfaGFuZGxlX3dv
cmsKPiAgc2NoZWR1bGVfdGltZW91dCAoc2xlZXAgYmUgYnJlYWsgYnkgd2FrZXVwICAgICAgICAg
aW9fZ2V0X25leHRfd29yawo+ICAgYW5kIHRoZSBJT19XUV9CSVRfRVhJVCBiZSBzZXQpICAgICAg
ICAgICAgICAgICAgICAgIHNldF9iaXQgaGFzaAo+Cj4gdGVzdF9iaXQgSU9fV1FfQklUX0VYSVQg
KHJldHVybiB0cnVlKQo+ICB3cWUtPndvcmtfbGlzdCAoaXMgbm90IGVtcHR5KQo+ICAgaW9fZ2V0
X25leHRfd29yawo+ICAgIGlvX3dxX2lzX2hhc2hlZAo+ICAgICB0ZXN0X2FuZF9zZXRfYml0IGhh
c2ggKGlzIHRydWUpICAgICAgICAgICAgICAgKGhhc2ghPS0xVSYmIW5leHRfaGFzaGVkKSB0cnVl
Cj4gICAgKHRoZXJlIGlzIG5vIHdvcmsgb3RoZXIgdGhhbiBoYXNoIHdvcmspCj4gICAgIGlvX3dh
aXRfb25faGFzaCAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgIGNsZWFyX2JpdCBoYXNo
Cj4gICAgICBzcGluX2xvY2sgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAg
ICAgICB3cV9oYXNfc2xlZXBlciAoaXMgZmFsc2UpCj4gICAgICBsaXN0X2VtcHR5KCZ3cWUtPndh
aXQuZW50cnkpIChpcyB0cnVlKQo+ICAgICAgX19hZGRfd2FpdF9xdWV1ZSAgICAgICAgICAgICAg
ICAgICAgICAgICAgICAgKGhhc2gtPndhaXQgaXMgZW1wdHksbm90IHdha2V1cAo+ICAgICAgICAg
ICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgYW5kIElPX1dRX0JJVF9F
WElUIGhhcyBiZWVuIHNldCwKPiAgICAgICAuLi4uLi4uLiAgICAgICAgICAgICAgICAgICAgICAg
ICAgICAgICAgICAgICAgICAgICAgdGhlIHdxZS0+d29ya19saXN0IGlzIGVtcHR5IGV4aXQKPiAg
ICAodGhlcmUgaXMgbm8gd29yayBvdGhlciB0aGFuIGhhc2ggd29yayAgICAgICAgIHdoaWxlIGxv
b3ApCj4gICAgICAgaW9fZ2V0X25leHRfd29yayB3aWxsIHJldHVybiBOVUxMKQo+ICAgIHJldHVy
biBOVUxMICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAodGhlIHdx
ZS0+d29ya19saXN0IGlzIGVtcHR5Cj4gICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAg
ICAgICAgICAgICAgICAgICB0aGUgaW9fd29ya2VyX2hhbmRsZV93b3JrIGlzIG5vdAo+ICAgICAg
ICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICBjYWxsZWQpCj4g
aW9fd29ya2VyX2V4aXQgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgIGlv
X3dvcmtlcl9leGl0Cj4KPiBJbiB0aGUgYWJvdmUgc2NlbmFyaW8sIHdxZSBtYXkgYmUgbWlzdGFr
ZW5seSByZW1vdmluZwo+IG9wcG9ydHVuaXRpZXMgZnJvbSB0aGUgcXVldWUsIHRoaXMgbGVhZHMg
dG8gd2hlbiB0aGUgd3FlIGlzCj4gcmVsZWFzZWQsIGl0IHN0aWxsIGluIGhhc2ggd2FpdHF1ZXVl
LiB3aGVuIGEgaW91LXdyayBiZWxvbmdpbmcKPiB0byBhbm90aGVyIGlvLXdxIGFjY2VzcyBoYXNo
IHdhaXRxdWV1ZSB3aWxsIHRyaWdnZXIgVUFGLAo+IFRvIGF2b2lkIHRoaXMgcGhlbm9tZW5vbiwg
YWZ0ZXIgYWxsIGlvdS13cmsgdGhyZWFkIGJlbG9uZ2luZyB0byB0aGUKPiBpby13cSBleGl0LCBy
ZW1vdmUgd3FlIGZyb20gdGhlIGhhc2ggd2FpcXVldWUsIGF0IHRoaXMgdGltZSwKPiB0aGVyZSB3
aWxsIGJlIG5vIG9wZXJhdGlvbiB0byBxdWV1ZSB0aGUgd3FlLgo+Cj4gUmVwb3J0ZWQtYnk6IHN5
emJvdCs2Y2IxMWFkZTUyYWExNzA5NTI5N0BzeXprYWxsZXIuYXBwc3BvdG1haWwuY29tCj4gU2ln
bmVkLW9mZi1ieTogWnFpYW5nIDxxaWFuZy56aGFuZ0B3aW5kcml2ZXIuY29tPgo+IC0tLQo+ICBm
cy9pby13cS5jIHwgOSArKysrKystLS0KPiAgMSBmaWxlIGNoYW5nZWQsIDYgaW5zZXJ0aW9ucygr
KSwgMyBkZWxldGlvbnMoLSkKPgo+IGRpZmYgLS1naXQgYS9mcy9pby13cS5jIGIvZnMvaW8td3Eu
Ywo+IGluZGV4IDUzNjFhOWI0YjQ3Yi4uOTExYTEyNzRhYWJkIDEwMDY0NAo+IC0tLSBhL2ZzL2lv
LXdxLmMKPiArKysgYi9mcy9pby13cS5jCj4gQEAgLTEwMDMsMTMgKzEwMDMsMTYgQEAgc3RhdGlj
IHZvaWQgaW9fd3FfZXhpdF93b3JrZXJzKHN0cnVjdCBpb193cSAqd3EpCj4gICAgICAgICAgICAg
ICBzdHJ1Y3QgaW9fd3FlICp3cWUgPSB3cS0+d3Flc1tub2RlXTsKPgo+ICAgICAgICAgICAgICAg
aW9fd3FfZm9yX2VhY2hfd29ya2VyKHdxZSwgaW9fd3Ffd29ya2VyX3dha2UsIE5VTEwpOwo+IC0g
ICAgICAgICAgICAgc3Bpbl9sb2NrX2lycSgmd3EtPmhhc2gtPndhaXQubG9jayk7Cj4gLSAgICAg
ICAgICAgICBsaXN0X2RlbF9pbml0KCZ3cS0+d3Flc1tub2RlXS0+d2FpdC5lbnRyeSk7Cj4gLSAg
ICAgICAgICAgICBzcGluX3VubG9ja19pcnEoJndxLT5oYXNoLT53YWl0LmxvY2spOwo+ICAgICAg
IH0KPiAgICAgICByY3VfcmVhZF91bmxvY2soKTsKPiAgICAgICBpb193b3JrZXJfcmVmX3B1dCh3
cSk7Cj4gICAgICAgd2FpdF9mb3JfY29tcGxldGlvbigmd3EtPndvcmtlcl9kb25lKTsKPiArCj4g
KyAgICAgZm9yX2VhY2hfbm9kZShub2RlKSB7Cj4gKyAgICAgICAgICAgICBzcGluX2xvY2tfaXJx
KCZ3cS0+aGFzaC0+d2FpdC5sb2NrKTsKPiArICAgICAgICAgICAgIGxpc3RfZGVsX2luaXQoJndx
LT53cWVzW25vZGVdLT53YWl0LmVudHJ5KTsKPiArICAgICAgICAgICAgIHNwaW5fdW5sb2NrX2ly
cSgmd3EtPmhhc2gtPndhaXQubG9jayk7Cj4gKyAgICAgfQo+ICAgICAgIHB1dF90YXNrX3N0cnVj
dCh3cS0+dGFzayk7Cj4gICAgICAgd3EtPnRhc2sgPSBOVUxMOwo+ICB9Cj4gLS0KPiAyLjE3LjEK
Cj5TY3JhdGNoIHNjYWxwIG9uZSBpbmNoIG9mZiB0byB3b3JrIG91dCBob3cgdGhpcyBpcyBhIGN1
cmUgZ2l2ZW4gYSkgdWFmIG1ha2VzCj5ubyBzZW5zZSB3aXRob3V0IGZyZWUgYW5kIGIpIGhvdyBp
byB3b3JrZXJzIGNvdWxkIHN1cnZpdmUKPndhaXRfZm9yX2NvbXBsZXRpb24oJndxLT53b3JrZXJf
ZG9uZSkuCj4KPklmIHRoZXkgY291bGQgT1RPSCB0aGVuIHRoaXMgaXMgbm90IHRoZSBwaWxsIGZv
ciB0aGUgbGVhayBpbiB3b3JrZXJfcmVmcy4KCkhlbGxvIFBhdmVsIEJlZ3Vua292LCBIaWxsZiBE
YW50b24KClNvcnJ5IHRoZXJlIGlzIGEgcHJvYmxlbSB3aXRoIHRoZSBjYWxsdHJhY2UgZGVzY3Jp
YmVkIGluIG15IG1lc3NhZ2UuIFBsZWFzZSBpZ25vcmUgdGhpcyBtb2RpZmljYXRpb24gCgpUaGFu
a3MKUWlhbmc=
