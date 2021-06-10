Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E95033A21F6
	for <lists+io-uring@lfdr.de>; Thu, 10 Jun 2021 03:49:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229705AbhFJBv2 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 9 Jun 2021 21:51:28 -0400
Received: from mx0b-0064b401.pphosted.com ([205.220.178.238]:8602 "EHLO
        mx0b-0064b401.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229507AbhFJBv2 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 9 Jun 2021 21:51:28 -0400
Received: from pps.filterd (m0250811.ppops.net [127.0.0.1])
        by mx0a-0064b401.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 15A1jr1M002328;
        Thu, 10 Jun 2021 01:49:21 GMT
Received: from nam10-dm6-obe.outbound.protection.outlook.com (mail-dm6nam10lp2109.outbound.protection.outlook.com [104.47.58.109])
        by mx0a-0064b401.pphosted.com with ESMTP id 3934d9r653-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 10 Jun 2021 01:49:21 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=gnMEToLeOjyft3LR8cxAi1Ckg3tMQU7rlbp4N9ZdYJEmjjqhtNycSaGpd4l4f3BbUS64NFenOzwFSTkQCrvPhbYWlrUmGMvGX7VfoesjF/Jx8AVmQPfaLavBUtvTPvwPKz3AcY4UN6cQqlaoRzWrMp6wyrcqrtJUGJwua7Ffriz4lVX2J7tVATnyzFVSFVYa7gMMQqe84KO1jHZvZlcyA96/MSk551Flo2mqDjtm8B1myKz92TYQLXFiMnxB1S+zXJCrKwt1TAkDBFzU6B99pvb5+Ki5aEzJy04bUTbPo2IhgokLZjXpeJugxAYTZjz5IE/qWefnXGWADhq6Q4ksFg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=y4HovgU+gWjQufv3cGfNXvg/FcaPdfFo5BZ7D38JuaY=;
 b=Yac5cz5re0L8blKZC4l/N1Js1ZhIC2BOmKYQuaEz9CQ6fVzz61tG9u3XMO5hTGXkfzkz/Sm46eKuRBxlnZbBH1sr8wIe8Jz8xC+WU27IH4peAh6gApWFWB392gkK7qH8tgWpKHOh6USyzQKMyYA84yAquvFXJV0C3xN0w8vpL0RHGwsCT7l6SzT694BtL++++EemSHdXTx9qKbUWDCUby3BohikRWUU9t27fA0tn82n6SB9pZJpOs5xyIutI28CxjHWOLFY2b/WGimI7cRZ7SCAKBjptN+M4mcA75jBM/Jzkh6vkOf8/i3XzrHM0XuGlsMYdsxK2M2eiwfDXd15QMw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=windriver.com; dmarc=pass action=none
 header.from=windriver.com; dkim=pass header.d=windriver.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=windriversystems.onmicrosoft.com;
 s=selector2-windriversystems-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=y4HovgU+gWjQufv3cGfNXvg/FcaPdfFo5BZ7D38JuaY=;
 b=WaJJy9b6v3jl3dd8cKLn/RcOb+xKZCY/jPr6w8nwEeQHvnLvHqPm9YCytguzemUG+a0OS/xK769YDWHKgeD6xV2YHtTlPq4bREs8gu2MhBgVyMntXcXSrsiAgkbBTZADvOuhFBbSNXLUYNIUy+M0AtMql91bxaiIePzM6/9oF3Q=
Received: from DM6PR11MB4202.namprd11.prod.outlook.com (2603:10b6:5:1df::16)
 by DM8PR11MB5736.namprd11.prod.outlook.com (2603:10b6:8:11::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4219.21; Thu, 10 Jun
 2021 01:49:19 +0000
Received: from DM6PR11MB4202.namprd11.prod.outlook.com
 ([fe80::3590:5f5:9e9e:ed18]) by DM6PR11MB4202.namprd11.prod.outlook.com
 ([fe80::3590:5f5:9e9e:ed18%7]) with mapi id 15.20.4195.030; Thu, 10 Jun 2021
 01:49:18 +0000
From:   "Zhang, Qiang" <Qiang.Zhang@windriver.com>
To:     Pavel Begunkov <asml.silence@gmail.com>,
        Hillf Danton <hdanton@sina.com>,
        "axboe@kernel.dk" <axboe@kernel.dk>
CC:     "syzbot+6cb11ade52aa17095297@syzkaller.appspotmail.com" 
        <syzbot+6cb11ade52aa17095297@syzkaller.appspotmail.com>,
        "io-uring@vger.kernel.org" <io-uring@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: =?big5?B?UmU6IKZezmA6IKZezmA6IFtQQVRDSF0gaW8td3E6IEZpeCBVQUYgd2hlbiB3YWtl?=
 =?big5?Q?up_wqe_in_hash_waitqueue?=
Thread-Topic: =?big5?B?pl7OYDogpl7OYDogW1BBVENIXSBpby13cTogRml4IFVBRiB3aGVuIHdha2V1cCB3?=
 =?big5?Q?qe_in_hash_waitqueue?=
Thread-Index: AQHXUG0DVlNQX3He7UO9rugYN/DIOKryS+MAgAANvFKAABFMAIABABUrgBV8BgCAA60eVw==
Date:   Thu, 10 Jun 2021 01:49:18 +0000
Message-ID: <DM6PR11MB42025CAC6D19741D7B1F782DFF359@DM6PR11MB4202.namprd11.prod.outlook.com>
References: <20210524071844.24085-1-qiang.zhang@windriver.com>
 <20210524082536.2032-1-hdanton@sina.com>
 <DM6PR11MB4202B442C4C27740B6EE2D64FF269@DM6PR11MB4202.namprd11.prod.outlook.com>
 <916ad789-c996-258f-d3b7-b41d749618d8@gmail.com>
 <DM6PR11MB4202561CE9ECD5B7F8DD74AFFF259@DM6PR11MB4202.namprd11.prod.outlook.com>,<9af68623-57e4-cef0-bb61-347207fb0c45@gmail.com>
In-Reply-To: <9af68623-57e4-cef0-bb61-347207fb0c45@gmail.com>
Accept-Language: en-001, zh-CN, en-US
Content-Language: aa
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: gmail.com; dkim=none (message not signed)
 header.d=none;gmail.com; dmarc=none action=none header.from=windriver.com;
x-originating-ip: [60.247.85.82]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: f958e155-5883-49f0-df3e-08d92bb1f61f
x-ms-traffictypediagnostic: DM8PR11MB5736:
x-microsoft-antispam-prvs: <DM8PR11MB5736AE119BDEAC5856476916FF359@DM8PR11MB5736.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8882;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: jB8tqJkG2cup18v5+GfrKQVDD8OiA2+b+R07FnbD4sZp2Z/tqs1X6e4ftvy3XkENyJ+RvqeaFgJ0D5H7AdnXMLZqg3mq0cTP6Er9pk5+NpRT4I9joUwNQbtFOEVMcqzTU7tSx2/WA8GU9yHYnvccLfVnrnND0cSG+dJmBP0wnMlulXtgq2QEeMyAY1uxPPhvS0Go6aczeGpwsuuBjwsP4FkwrX4V2+asC6JAzDM91t2JVuhtt+81qH3/By1j7tR43kx2Q5+5jq8g9m6RyY3ziWnwXGrNNliXELRY3FFJdjRFq3HNxWtuFeIgGigbECqKpN3h5ah0lQh1DaRgm26JAAbOxC0wbYU+gtIsgdyW78Jg0TiXYtWY9WxdSNKKzzmqtyEQaWiDqWBLRTqyFr4u/qGf2SAV+4aaGp+kKjIOeHU2v9Sz534DxoLTmSqTskdraax0+mACQVGzXKxI8AlV6Qr3wCEcmqnenuIEsrXDvurJHPo8CGcuazBFC3SYumXsGOamj4G8QUvOysgSTWigx6HVOY5pcQQP5JpUqDCMybXi6IUFDbWft2VLdpQghBzU5Qucdt2Jz+aWIdWQqHPpkP+NZB1APt78eV+xrM4pukEzHlD2DmRVGQbTigYZAA+XxIEka8Oa2sf9NhGFabdt+g==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR11MB4202.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(39850400004)(366004)(346002)(376002)(136003)(396003)(52536014)(7696005)(53546011)(38100700002)(6506007)(5660300002)(224303003)(33656002)(2906002)(4326008)(86362001)(316002)(110136005)(54906003)(26005)(186003)(71200400001)(9686003)(64756008)(55016002)(66476007)(8936002)(66946007)(66446008)(83380400001)(66556008)(478600001)(122000001)(76116006)(586874002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: +OyePCFjRI6JZTJrqCns7bewYWxdSCnMePmZy1M5LmzGkiNlKQOyMpd53klhS/hlEpWBPeKEmHMYS1dTg+T9C9St7N8OcNgMzHhe2lSIMVD5BHMJHie3p4W9YBBp3zyVwze3FwMn2L+XwIsRCwMD5YaERPgPfbRtNc5ms/MsXyIeoF4McPgNwhjNQ9gCgBKUpHSCFJYrLUIK8b8xsI7sioj+y4oiu6IdLbRRj+TRop1xe/fe1Mu7MhllYxxYnp3o1w84YkveyuH2Fp3ET6MW8+CM0tPhp5s1WLSkX1X3Twu/DNK0LP3gW8sivbIIlbUnJTlD+l24o1rAGSHKqqVG3/cqeV9EwF9zWsmJmKKZTtzTgGlIJVRGJ/nUnqIWWZXDFy4MQGsWLLDRZ64MV1Af2UwggMSGy/oISuB0Q+ygRHtXQhBaB0Bf55H3Iy7uqrRQZUfpIS2kExM+c1TxfL5xtKkU71EMaRPsBWygIiV1+gCgdsKA5brmLH55Iei8aajrdbhJE1cWjunzJUa70Ghsh8n0KUFMiFpZ+V6+y0bsQt9xwbQVPqUbZON6W1UXGf1emeLgGBAjcNY1sa68vxQovQBzRffhj2zid4UFzsfBYJbvRpkUkXwgZ5HNaIkIAWNKoi+Mjw9d9ry1h6UMFlLqgcuf6V3A+Mqh7bpCfI9qMSG4ge9i7g/DdUfcB093fAY0EVh5eXOyrAkrxYcjmLCbMiaLHnS2u7Z+dMLNeLdZfpc=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="big5"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: windriver.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM6PR11MB4202.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f958e155-5883-49f0-df3e-08d92bb1f61f
X-MS-Exchange-CrossTenant-originalarrivaltime: 10 Jun 2021 01:49:18.6136
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ddb2873-a1ad-4a18-ae4e-4644631433be
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: CQI/JXslkdxNfRq5fZa/LvvggLQr+0V2JnzKg4a+VHTqNkDAJyf9nwcaQpAOGzWh7XrRdF7EjxCUJAjIgvVX0Y70cEa7YAzd8UZedChPkxY=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM8PR11MB5736
X-Proofpoint-GUID: dDuj629O6um2jbOGa4VkjGfSn1qz1kCf
X-Proofpoint-ORIG-GUID: dDuj629O6um2jbOGa4VkjGfSn1qz1kCf
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.761
 definitions=2021-06-09_14:2021-06-04,2021-06-09 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxscore=0 phishscore=0
 mlxlogscore=999 malwarescore=0 lowpriorityscore=0 spamscore=0 bulkscore=0
 impostorscore=0 suspectscore=0 priorityscore=1501 clxscore=1015
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2104190000 definitions=main-2106100009
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

CgpfX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fCkZyb206IFBhdmVsIEJl
Z3Vua292IDxhc21sLnNpbGVuY2VAZ21haWwuY29tPgpTZW50OiBUdWVzZGF5LCA4IEp1bmUgMjAy
MSAwMTozOApUbzogWmhhbmcsIFFpYW5nOyBIaWxsZiBEYW50b247IGF4Ym9lQGtlcm5lbC5kawpD
Yzogc3l6Ym90KzZjYjExYWRlNTJhYTE3MDk1Mjk3QHN5emthbGxlci5hcHBzcG90bWFpbC5jb207
IGlvLXVyaW5nQHZnZXIua2VybmVsLm9yZzsgbGludXgta2VybmVsQHZnZXIua2VybmVsLm9yZwpT
dWJqZWN0OiBSZTogpl7OYDogpl7OYDogW1BBVENIXSBpby13cTogRml4IFVBRiB3aGVuIHdha2V1
cCB3cWUgaW4gaGFzaCB3YWl0cXVldWUKCltQbGVhc2Ugbm90ZTogVGhpcyBlLW1haWwgaXMgZnJv
bSBhbiBFWFRFUk5BTCBlLW1haWwgYWRkcmVzc10KCk9uIDUvMjUvMjEgMzowMSBBTSwgWmhhbmcs
IFFpYW5nIHdyb3RlOgpbLi4uXQo+PiBIYXZlbid0IGxvb2tlZCBhdCB0aGUgdHJhY2UgYW5kIGRl
c2NyaXB0aW9uLCBidXQgSSBkbyB0aGluawo+PiB0aGVyZSBpcyBhIHByb2JsZW0gaXQgc29sdmVz
Lgo+Pgo+PiAxKSBpb193YWl0X29uX2hhc2goKSAtPiBfX2FkZF93YWl0X3F1ZXVlKCZoYXNoLT53
YWl0LCAmd3FlLT53YWl0KTsKPj4gMikgKG5vdGU6IHdxZSBpcyBhIHdvcmtlcikgd3FlJ3Mgd29y
a2VycyBleGl0IGRyb3BwaW5nIHJlZnMKPj4gMykgcmVmcyBhcmUgemVybywgZnJlZSBpby13cQo+
PiA0KSBAaGFzaCBpcyBzaGFyZWQsIHNvIG90aGVyIHRhc2svd3EgZG9lcyB3YWtlX3VwKCZ3cS0+
aGFzaC0+d2FpdCk7Cj4+IDUpIGl0IHdha2VzIGZyZWVkIHdxZQo+Pgo+PiBzdGVwIDQpIGlzIGEg
Yml0IG1vcmUgdHJpY2tpZXIgdGhhbiB0aGF0LCB0bDtkcjsKPj4gd3EzOndvcmtlcjEgICAgIHwg
bG9ja3MgYml0MQo+PiB3cTE6d29ya2VyMiAgICAgfCB3YWl0cyBiaXQxCj4+IHdxMjp3b3JrZXIx
ICAgICB8IHdhaXRzIGJpdDEKPj4gd3ExOndvcmtlcjMgICAgIHwgd2FpdHMgYml0MQo+Pgo+PiB3
cTM6d29ya2VyMSAgICAgfCBkcm9wICBiaXQxCj4+IHdxMTp3b3JrZXIyICAgICB8IGxvY2tzIGJp
dDEKPj4gd3ExOndvcmtlcjIgICAgIHwgY29tcGxldGVzIGFsbCB3cTEgYml0MSB3b3JrIGl0ZW1z
Cj4+IHdxMTp3b3JrZXIyICAgICB8IGRyb3AgIGJpdDEsIGV4aXQgYW5kIGZyZWUgaW8td3EKPj4K
Pj4gd3EyOndvcmtlcjEgICAgIHwgbG9ja3MgYml0MQo+PiB3cTEgICAgICAgICAgICAgfCBmcmVl
IGNvbXBsZXRlCj4+IHdxMjp3b3JrZXIxICAgICB8IGRyb3BzIGJpdDEKPj4gd3ExOndvcmtlcjMg
ICAgIHwgd2FrZWQgdXAsIGV2ZW4gdGhvdWdoIGZyZWVkCj4+Cj4+IENhbiBiZSBzaW1wbGlmaWVk
LCBkb24ndCB3YW50IHRvIHdhc3RlIHRpbWUgb24gdGhhdAo+Cj4gVGhhbmtzIFBhdmVsCj4KPiBZ
b3VyIGRlc2NyaXB0aW9uIGlzIGJldHRlci4gIEkgaGF2ZSBhbm90aGVyIHF1ZXN0aW9uOiB1bmRl
ciB3aGF0IGNpcmN1bXN0YW5jZXMgd2lsbCB0aHJlZSBpby13cSh3cTEsIHdxMiwgd3EzKSBiZSBj
cmVhdGVkIHRvIHNoYXJlIHRoaXMgQGhhc2g/Cgo+T29wcywgbWlzc2VkIHRoZSBlbWFpbC4gSXQn
cyBjcmVhdGVkIGJ5IGlvX3VyaW5nLCBhbmQgcGFzc2VkIHRvCj5pby13cSwgd2hpY2ggaXMgcGVy
LXRhc2sgYW5kIGNyZWF0ZWQgb24gZGVtYW5kIGJ5IGlvX3VyaW5nLgo+Cj5DYW4gYmUgYWNoaWV2
ZWQgYnkgYSBzbmlwcGV0IGp1c3QgYmVsb3csIHdoZXJlIHRocmVhZHMKPmhhdmVuJ3QgaGFkIGlv
X3VyaW5nIGluc3RhbmNlcyBiZWZvcmUuCj4KPnRocmVhZDE6IHJpbmcgPSBjcmVhdGVfaW9fdXJp
bmcoKTsKPnRocmVhZDI6IHN1Ym1pdF9zcWVzKHJpbmcpOwo+dGhyZWFkMzogc3VibWl0X3NxZXMo
cmluZyk7CgogVGhhbmsgeW91IGZvciB5b3VyIGV4cGxhbmF0aW9uLCBQYXZlbAoKPgo+IFRoaXMg
a2luZCBvZiBwcm9ibGVtIGFsc28gb2NjdXJzIGJldHdlZW4gdHdvIGlvLXdxKHdxMSwgd3EyKS4g
SXMgdGhlIGZvbGxvd2luZyBkZXNjcmlwdGlvbiBPS6FICgo+WWVwLCBhbmQgSSBmZWVsIGxpa2Ug
dGhlcmUgYXJlIGNhc2VzIHNpbXBsZXIgKGFuZAo+bW9yZSBsaWtlbHkpIHRoYW4gdGhlIG9uZSBJ
IGRlc2NyaWJlZC4KCj4KPiB3cTE6d29ya2VyMiAgICAgfCBsb2NrcyBiaXQxCj4gd3EyOndvcmtl
cjEgICAgIHwgd2FpdHMgYml0MQo+IHdxMTp3b3JrZXIzICAgICB8IHdhaXRzIGJpdDEKPgo+IHdx
MTp3b3JrZXIyICAgICB8IGNvbXBsZXRlcyBhbGwgd3ExIGJpdDEgd29yayBpdGVtcwo+IHdxMTp3
b3JrZXIyICAgICB8IGRyb3AgIGJpdDEsIGV4aXQgYW5kIGZyZWUgaW8td3EKPgo+IHdxMjp3b3Jr
ZXIxICAgICB8IGxvY2tzIGJpdDEKPiB3cTEgICAgICAgICAgICAgICAgICAgICAgIHwgZnJlZSBj
b21wbGV0ZQo+IHdxMjp3b3JrZXIxICAgICB8IGRyb3BzIGJpdDEKPiB3cTE6d29ya2VyMyAgICAg
fCB3YWtlZCB1cCwgZXZlbiB0aG91Z2ggZnJlZWQKCgo+LS0KPlBhdmVsIEJlZ3Vua292Cg==
