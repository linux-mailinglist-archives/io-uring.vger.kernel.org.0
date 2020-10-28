Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2857129D51C
	for <lists+io-uring@lfdr.de>; Wed, 28 Oct 2020 22:58:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727690AbgJ1V6a (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 28 Oct 2020 17:58:30 -0400
Received: from mail-bn8nam11on2061.outbound.protection.outlook.com ([40.107.236.61]:17589
        "EHLO NAM11-BN8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728802AbgJ1V63 (ORCPT <rfc822;io-uring@vger.kernel.org>);
        Wed, 28 Oct 2020 17:58:29 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=WUk6gJLJLuDvDG+45r+qG6dXqZYiXitHi0S1l3RO3DFs/Y5KQvx85KhV+FKiU+9L4WjGgmlTwSAmubOpRan34kP+fKh/f1xZZkR506BTVZ/g3gl1yES4NLaZ/LtbmP8ndnR/4JQYmThJIOLhcwCTQQwT43VlpchCkq888+qR5zYgxPHOGd0VKfg22D3IJBbtOlYL6c+dCuAFi+NYHBCrsJeI2/1AujkP+0yFZJIaSsbykYk2OK2EHOCk9N8qhnsyJKE7JdlIuXwu8u688cR0UlZrKbYPMFIO/mpk0VcpAxuRQo/9Jky1aVagDCB4vyVa7orFHxV1QNtbH92tiXw8Lw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=UuVywQtfSgvvNzElvBrO1UvcAUxUw9DemPCrIucXMkg=;
 b=hYd1kxhX1AXq2qALBGU4bHudaczau7aE0CKjBc2kbbDqibhtdf/ZSVIU87CxYVk72A6iikDyk5KWin5+UohhpY3bHxdQNUUSTQ74/VDblRp8tvvJFvJH3eiRRgUeiee/X6gNrWpkXbVsY8fGTMjPtw6wNiY5GmrHpIbjz5ITuTV5LbQ3ydbjEW9wj+mAMgSLBpp0+Fl+eplyB8EnEmVRZZoDdZ2m2NvFm/sQX7V+LzaBPIsAMdU1cTqTGX5oh69G5Z5DHRfc/neHus5iC42FWBO/JTA7BtpsPSBdadLebJe9rwh3DEAD3KIsVEhki8PscXBh0t5CWwbWMiYxbzDZAA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=windriver.com; dmarc=pass action=none
 header.from=windriver.com; dkim=pass header.d=windriver.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=windriversystems.onmicrosoft.com;
 s=selector2-windriversystems-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=UuVywQtfSgvvNzElvBrO1UvcAUxUw9DemPCrIucXMkg=;
 b=nvOY36EhGou9en4GRAGwCFoEMOoTrNYUUf4XcLPhgBUCwcCa2OiK3228lFVnqfsLNH3iVFz4wzPmCh47E6TvrsPtqRTroazT6QZwke05mz4HYneGETbzbdTW6YFRVwRHwz+/xymaF5mETgv/Od2gCPB5lTa+fWfeeHNhOLOihIw=
Received: from BYAPR11MB2632.namprd11.prod.outlook.com (2603:10b6:a02:c4::17)
 by SJ0PR11MB5184.namprd11.prod.outlook.com (2603:10b6:a03:2d5::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3499.18; Wed, 28 Oct
 2020 02:47:54 +0000
Received: from BYAPR11MB2632.namprd11.prod.outlook.com
 ([fe80::80e9:e002:eeff:4d05]) by BYAPR11MB2632.namprd11.prod.outlook.com
 ([fe80::80e9:e002:eeff:4d05%3]) with mapi id 15.20.3455.030; Wed, 28 Oct 2020
 02:47:53 +0000
From:   "Zhang, Qiang" <Qiang.Zhang@windriver.com>
To:     Jens Axboe <axboe@kernel.dk>
CC:     "io-uring@vger.kernel.org" <io-uring@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: =?gb2312?B?u9i4tDogW1BBVENIXSBpby13cTogc2V0IHRhc2sgVEFTS19JTlRFUlJVUFRJ?=
 =?gb2312?Q?BLE_state_before_schedule=5Ftimeout?=
Thread-Topic: [PATCH] io-wq: set task TASK_INTERRUPTIBLE state before
 schedule_timeout
Thread-Index: AQHWrA6So/PefgDq40imjt0Gr/M086mrc9IAgADN/6k=
Date:   Wed, 28 Oct 2020 02:47:53 +0000
Message-ID: <BYAPR11MB2632A45DB4DA30E34D412528FF170@BYAPR11MB2632.namprd11.prod.outlook.com>
References: <20201027030911.16596-1-qiang.zhang@windriver.com>,<bc138db4-4609-b8e6-717a-489cf2027fc0@kernel.dk>
In-Reply-To: <bc138db4-4609-b8e6-717a-489cf2027fc0@kernel.dk>
Accept-Language: zh-CN, en-US
Content-Language: zh-CN
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: kernel.dk; dkim=none (message not signed)
 header.d=none;kernel.dk; dmarc=none action=none header.from=windriver.com;
x-originating-ip: [60.247.85.82]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 5b2dc80c-9a92-46ea-4498-08d87aebde3c
x-ms-traffictypediagnostic: SJ0PR11MB5184:
x-microsoft-antispam-prvs: <SJ0PR11MB5184DA12F8C35736CA6CF491FF170@SJ0PR11MB5184.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8882;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: Y7wx/mlwmD2OtPMBr+HTu87E+nwVT/f9EvXz4GvaeVFViPOalDpJPd2EwJtsdR8Uh2H63zgeDTefNJa+zj9QSr9OZiv64I4EiBffmha+PDxFkMUxmaQhPZpp7J2Qkxk3c9KI+atc8mWct1yFzWYeaYk2dfGYTktMYT57Zco5pSOKOAvZ8tdkY77LBEuu2MtYbGrX61DCwtQc8B6GMNAP5EgEJXYdhkJuL7mFVkk2WdHWsf3KkMurC/MdhWsGKQqgv3YdgHybyPIpCpuMXjrwelP9EHkmxG3IVQqWPZPIno41dhHe1Z1jkTBK9h6xLDQ9HoesoowZghp21zCrOThXzg==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR11MB2632.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(136003)(396003)(39850400004)(366004)(376002)(346002)(2906002)(8936002)(91956017)(9686003)(55016002)(224303003)(478600001)(4326008)(26005)(186003)(53546011)(54906003)(316002)(7696005)(52536014)(6506007)(66946007)(33656002)(76116006)(66446008)(66556008)(66476007)(64756008)(71200400001)(86362001)(6916009)(5660300002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: cdO5OiIS65WcCBemq2rI7cbDts26d7jXtrzS23xEz6flg7TDWH6DAE51KpPTLmB0jH/L3i9sFMdWe8Xw/cs9s3YPP+VMQPhxCg2smc5yKrH4LcOzIFC1qx+d3C823f4o4qXkMfys6t28zCBpTy98Y/iXZdIV9HxsaQYGkxqZgFEGOeiY92jzle/GP89oejoJPQfM7+oVN+I6IytnLhslK+MwBfs/rHzts8FGuKvEe9Xzx+y8033adbFk8cdtokHbYq1RNPiw8fpZDylvKee/0FcRS/B4SHTwa6uimbY8C5T0cxbk6uGYpONZHhtab0t1QYesTiXpB9+n12blOATb8TRsQbWKZpwDfyVLG/8hmMWHGOUhKcOoIGiJCKGtCjjoL5TmUz/EnD3NcMLpZys4XqJWdu3yJHrj0sgNTbH3WFAwS+Ljm3BjgMnWGPqsTKQ6t6ko7ipXzruvHXd0M8hdA1Ay0rwwl4h7jpbfBXRnPySoTuQhwxAQW5EONeG/zueCjHJr1P1xwgU9qriTzTcYPGtTPeLdt/2v5Ttqg0HyVAaWgIv3sgJG31WC4SVkllYfjVPz3qcrFemGRBu4i1qhD8s0LMcLB0Eim959UGEzwoVJeIajSt31yOv+/KbiDxL50/LiraCB6+NJvtPLzdbZ2A==
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="gb2312"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BYAPR11MB2632.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5b2dc80c-9a92-46ea-4498-08d87aebde3c
X-MS-Exchange-CrossTenant-originalarrivaltime: 28 Oct 2020 02:47:53.4751
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ddb2873-a1ad-4a18-ae4e-4644631433be
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 1O7OlhOiD7b18B6NpcMY03eTaDHW1NCH74rqWnrMFGAD26+MDOuWAKfjHAqKE0aSM4bDcqG0O7PuekmGJy+5S2N9KgiQKZffs4/OQFqJ9vA=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR11MB5184
X-OriginatorOrg: windriver.com
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

CgpfX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fCreivP7IyzogSmVucyBB
eGJvZSA8YXhib2VAa2VybmVsLmRrPgq3osvNyrG85DogMjAyMMTqMTDUwjI3yNUgMjE6MzUKytW8
/sjLOiBaaGFuZywgUWlhbmcKs63LzTogaW8tdXJpbmdAdmdlci5rZXJuZWwub3JnOyBsaW51eC1r
ZXJuZWxAdmdlci5rZXJuZWwub3JnCtb3zOI6IFJlOiBbUEFUQ0hdIGlvLXdxOiBzZXQgdGFzayBU
QVNLX0lOVEVSUlVQVElCTEUgc3RhdGUgYmVmb3JlIHNjaGVkdWxlX3RpbWVvdXQKCk9uIDEwLzI2
LzIwIDk6MDkgUE0sIHFpYW5nLnpoYW5nQHdpbmRyaXZlci5jb20gd3JvdGU6Cj4gRnJvbTogWnFp
YW5nIDxxaWFuZy56aGFuZ0B3aW5kcml2ZXIuY29tPgo+Cj4gSW4gJ2lvX3dxZV93b3JrZXInIHRo
cmVhZCwgaWYgdGhlIHdvcmsgd2hpY2ggaW4gJ3dxZS0+d29ya19saXN0JyBiZQo+IGZpbmlzaGVk
LCB0aGUgJ3dxZS0+d29ya19saXN0JyBpcyBlbXB0eSwgYW5kIGFmdGVyIHRoYXQgdGhlCj4gJ19f
aW9fd29ya2VyX2lkbGUnIGZ1bmMgcmV0dXJuIGZhbHNlLCB0aGUgdGFzayBzdGF0ZSBpcyBUQVNL
X1JVTk5JTkcsCj4gbmVlZCB0byBiZSBzZXQgVEFTS19JTlRFUlJVUFRJQkxFIGJlZm9yZSBjYWxs
IHNjaGVkdWxlX3RpbWVvdXQgZnVuYy4KPgo+SSBkb24ndCB0aGluayB0aGF0J3Mgc2FmZSAtIHdo
YXQgaWYgc29tZW9uZSBhZGRlZCB3b3JrIHJpZ2h0IGJlZm9yZSB5b3UKPmNhbGwgc2NoZWR1bGVf
dGltZW91dF9pbnRlcnJ1cHRpYmxlPyBTb21ldGhpbmcgYWxhOgo+Cj4KPmlvX3dxX2VucXVldWUo
KQo+ICAgICAgICAgICAgICAgICAgICAgICAgc2V0X2N1cnJlbnRfc3RhdGUoVEFTS19JTlRFUlJV
UFRJQkxFKCk7Cj4gICAgICAgICAgICAgICAgICAgICAgICBzY2hlZHVsZV90aW1lb3V0KFdPUktF
Ul9JRExFX1RJTUVPVVQpOwo+Cj50aGVuIHdlJ2xsIGhhdmUgd29yayBhZGRlZCBhbmQgdGhlIHRh
c2sgc3RhdGUgc2V0IHRvIHJ1bm5pbmcsIGJ1dCB0aGUKPndvcmtlciBpdHNlbGYganVzdCBzZXRz
IHVzIHRvIG5vbi1ydW5uaW5nIGFuZCB3aWxsIGhlbmNlIHdhaXQKPldPUktFUl9JRExFX1RJTUVP
VVQgYmVmb3JlIHRoZSB3b3JrIGlzIHByb2Nlc3NlZC4KPgo+VGhlIGN1cnJlbnQgc2l0dWF0aW9u
IHdpbGwgZG8gb25lIGV4dHJhIGxvb3AgZm9yIHRoaXMgY2FzZSwgYXMgdGhlCj5zY2hlZHVsZV90
aW1lb3V0KCkganVzdCBlbmRzIHVwIGJlaW5nIGEgbm9wIGFuZCB3ZSBnbyBhcm91bmQgYWdhaW4K
CmFsdGhvdWdoIHRoZSB3b3JrZXIgdGFzayBzdGF0ZSBpcyBydW5uaW5nLCAgZHVlIHRvIHRoZSBj
YWxsIHNjaGVkdWxlX3RpbWVvdXQsIHRoZSAKY3VycmVudCB3b3JrZXIgc3RpbGwgcG9zc2libGUg
dG8gYmUgc3dpdGNoZWQgb3V0LgppZiBzZXQgY3VycmVudCB3b3JrZXIgdGFzayBpcyBuby1ydW5u
aW5nLCB0aGUgY3VycmVudCB3b3JrZXIgYmUgc3dpdGNoZWQgb3V0LCBidXQKdGhlIHNjaGVkdWxl
IHdpbGwgY2FsbCBpb193cV93b3JrZXJfc2xlZXBpbmcgZnVuYyAgdG8gd2FrZSB1cCBmcmVlIHdv
cmtlciB0YXNrLCBpZiAKd3FlLT5mcmVlX2xpc3QgaXMgbm90IGVtcHR5LiAgCgo+Y2hlY2tpbmcg
Zm9yIHdvcmsuIFNpbmNlIHdlIGFscmVhZHkgdW51c2VkIHRoZSBtbSwgdGhlIG5leHQgaXRlcmF0
aW9uCj53aWxsIGdvIHRvIHNsZWVwIHByb3Blcmx5IHVubGVzcyBuZXcgd29yayBjYW1lIGluLgo+
Cj4tLQo+SmVucyBBeGJvZQoK
