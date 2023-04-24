Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 517306ECC6D
	for <lists+io-uring@lfdr.de>; Mon, 24 Apr 2023 14:56:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231299AbjDXMz7 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 24 Apr 2023 08:55:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52210 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231733AbjDXMz4 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 24 Apr 2023 08:55:56 -0400
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12on2067.outbound.protection.outlook.com [40.107.244.67])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7CC50DB
        for <io-uring@vger.kernel.org>; Mon, 24 Apr 2023 05:55:54 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=PFwrKApt3XGIOBu346yvKwYl5Qjtpsu3kCKCHxfRyECv1uycwkwkQ0M6KyznNPy/kP77Uo0M+LNv0yx9JXWXNjKh4Ump1+4KmOxipzT85hlXSnzV+ULe5h8Nmgg4pYkRjY+aTLoWCeV+pTV0hozl8hs113X6HyU5Gbxp4nD8jseJ3zCSWrKj+1ZM/+w7MmN8ROTnh00xsW4kuEQDwB+OWDPZQ4SA6nPDUYhugu8OoE635YMkylii+YQvzH1bz6Oua7vWqMwf7dFKj9zSKjnE9XedIPM470cdqyAVAyoyM3Bl2P4XizqOdmWADu2zh/qZGwCiMYAk40Cxl+Uue5g+qA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=3Fq96zF17s0aWD4y8FH1iVojvCQAOwqmlCOBOs5Dtto=;
 b=kUTeXIvE3FOfv3jYlIlGV16vzi5ngzG4YP43gW47CMcZwbCerOClltZiAt7vnrPAbWGKL7MVxcLgdMTfxGomEB31YFrH0f5xeqCayBWPtic7Kiid6LwF98vjl07sY1sw+owsb6zkkswqdZmBVefB0KC6w01C2XW76HtJNVVituSouyip2cvlcqD/vSIYFCQtY5Nd+fI6Vq+OCL8tTLBiZ+YID+7aPGNWciZjXXoqER/c54U50Dx3xEWk+ubmI16w30WposOu5mkalFH70wgaI4nIRcsH+a3YTH7G9J9j5wI/j4kqPbEKytVYsMH8swytrrRznaQfQv9nor3swIkD0g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=ddn.com; dmarc=pass action=none header.from=ddn.com; dkim=pass
 header.d=ddn.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ddn.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=3Fq96zF17s0aWD4y8FH1iVojvCQAOwqmlCOBOs5Dtto=;
 b=EzuHyH83XAs8/Xue2wqK2oJpG+sd9ZFSWhU6RtALUThtSh4mD+A6t28seLW6KRj87f19bN2C21H0tBGDk9SGG/CtVEQrFafAml9uvTigY7X2u1UPr2LxdxjO63vL/PAv/yHx/bCUvVDvG1mmP5QPOaHkZr4UInhQV8F8YvdlXUo=
Received: from DM5PR1901MB2037.namprd19.prod.outlook.com (2603:10b6:4:aa::29)
 by SJ1PR19MB6284.namprd19.prod.outlook.com (2603:10b6:a03:459::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6319.33; Mon, 24 Apr
 2023 12:55:50 +0000
Received: from DM5PR1901MB2037.namprd19.prod.outlook.com
 ([fe80::8cb3:ef5b:f815:7d8c]) by DM5PR1901MB2037.namprd19.prod.outlook.com
 ([fe80::8cb3:ef5b:f815:7d8c%4]) with mapi id 15.20.6319.033; Mon, 24 Apr 2023
 12:55:48 +0000
From:   Bernd Schubert <bschubert@ddn.com>
To:     Jens Axboe <axboe@kernel.dk>,
        "io-uring@vger.kernel.org" <io-uring@vger.kernel.org>
CC:     Ming Lei <ming.lei@redhat.com>,
        Pavel Begunkov <asml.silence@gmail.com>,
        Miklos Szeredi <miklos@szeredi.hu>
Subject: Re: SQPOLL / uring_cmd_iopoll
Thread-Topic: SQPOLL / uring_cmd_iopoll
Thread-Index: AQHZdJ31NW7cB5aBVU+6YmLVne2Nba82lucAgAC/1wCAAxg0AA==
Date:   Mon, 24 Apr 2023 12:55:48 +0000
Message-ID: <af7415b6-039d-cd9d-2d2d-591d97ba344b@ddn.com>
References: <cbfa6c3f-11bd-84f7-bdb0-4342f8fd38f3@ddn.com>
 <749cda6f-9e64-f89b-9d1d-e1943d7b339a@kernel.dk>
 <7a9525cd-a0b0-e23c-d0ff-a9f010f009ba@ddn.com>
In-Reply-To: <7a9525cd-a0b0-e23c-d0ff-a9f010f009ba@ddn.com>
Accept-Language: en-GB, en-US
Content-Language: en-GB
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.10.0
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=ddn.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: DM5PR1901MB2037:EE_|SJ1PR19MB6284:EE_
x-ms-office365-filtering-correlation-id: b261a4e7-9b7f-4269-5fcd-08db44c33a22
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 3PIsU27deYRAEsHaOpFwS3CcBDWvD3IQhkKglYnKAsje+/EMcq1CkFY9Huzt9Zu8zvEjnag9iDa+YTnaAOPxUQ2anUwuy2SRrQuphsn0pfnIp1OLmqx+0gJtlpOTfcEcoa+1TLV/wVdJFQYZupEgBlnj3UEozbgHzHqDJkACIE391zo2WZ2jhIahN6ltL38JXf5Ocd/PUfkTExvI/+FBmDM2gRDrKjsspu0RRPKMzCwRP+VOONZIxOCk+5+k6bgXwQi/QjVd+ZsFzA7wG+vxzp3Swy2zU0Rgwr3U2OfgZKHUilSJyUnbxE4UKlmK+7TZnRe0YEwkkFU53FxnDzY8UfotAyLZac6z4otSyMROT7JG5vV0r2Msto3XLpI3R+mj3bOwOpFrY88pqkB5JHNPa5lmUGXDki489mUQKA7lTntJwIC1ikJvNPEATbcL8nlChz+Woi5eJnRNlfESbGzTPTVuaUZOkqcc1GED9yZKhGuLwZ/ZgCsBD4dAou1RWhlMJWCahzWy5afC4GVs/MncQeHvHncVJ/R4P+M9fp5u8H4nr/RU0+gWB+ie6jcMSHJ6nK0tkNn8UyAzB0vkJVuMjJnBX8ITf7m14dVwGffpfTJMfMj/Ejov+jYlW66U+jv5bGvObWrnFZttf2A5D7U1zAqHtFAeM2tPZz7I9UBG5lMCDrFiblFh0kU9DXTdvVtW
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR1901MB2037.namprd19.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(136003)(396003)(39850400004)(366004)(346002)(376002)(451199021)(6512007)(6506007)(53546011)(8676002)(8936002)(4326008)(64756008)(66446008)(66476007)(66556008)(66946007)(76116006)(54906003)(316002)(36756003)(110136005)(91956017)(41300700001)(478600001)(71200400001)(6486002)(5660300002)(122000001)(38100700002)(31686004)(38070700005)(86362001)(2906002)(2616005)(31696002)(186003)(83380400001)(43740500002)(45980500001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?eGo0aUlSbkZTUlI0Ulo1clc5ZWRYMVpXMDJmc1ZWODJ6QzNHTGNVRkxwSEFn?=
 =?utf-8?B?VkFxYm52T2dGRktQYkhwQlNsUko1OFdQUzdJTHlEYXB0dERZQmNWWGlkY2Qv?=
 =?utf-8?B?UTErODVETmpFRjZvZURmR05MZ0paMEx1eDdtTlFXQi9TWWlXS1RrQk5zLys0?=
 =?utf-8?B?bGZvcE5MWlFIcGtpMkRVdDU4Nng1L0VOMFVzcGsyenVCMCszdytoWkRYMkVr?=
 =?utf-8?B?L2tHbEhrekM4WlRTaXVNWTFUZnNXYXVxbHAvbG9rVlU0eXJtdHpWcjVmRUY0?=
 =?utf-8?B?SUpLWTVuaUhLSlh2ZEMzWmxSa25Na1gyNXZGT3cra2ZvSHRRR0Z1WVlSM3Fx?=
 =?utf-8?B?aGkxSjVSMTFyTkFSV0ozSGQ0UzIzMWNGRXMyejNxMDBoalVROFJ6TEpSeFgv?=
 =?utf-8?B?MTE0MnpscGtOTTE5R2FzVm5id2gyU1d4TUU2SG9lZm5oVUFVWXNjN1RPVHor?=
 =?utf-8?B?YkoreElzaDEzT2Fpc3lyNWxZeU1QeDNZTkJKRk1tUk9RQXRIRyszemc4UjQz?=
 =?utf-8?B?OW1KTmo0TElyNm9rQ0J2d0p1TGlzVEtpYzdRK0RLb25FNDYvNVIzaFNEWk9T?=
 =?utf-8?B?bzdjcHFCMGNqa1J3M3prYmtGV0NCL3ZuVHdRTTluWHZjbG9Kc2Nrb1RSdTNC?=
 =?utf-8?B?bTl4Uk5uWmxyb0pyZnBaK1BrclpENitSUUhZQUpsZkR4RHRMY0lidmhuSnEy?=
 =?utf-8?B?WEJHeWNKVkY2K3Y0TEpZRm1VNDlTRlM4RXhmMWxTYmNMWVN0dHZoQVRWT3FN?=
 =?utf-8?B?VzZCYmVNNExPVnQrZEFkbElQRGVKVmYzZWJYL1hFeWJrY2VtRzZPQmdQOG5M?=
 =?utf-8?B?RnJDd0pDYVBPV1BaZHBmK1YzaGh4aENJaGNuK2hacHJRaW1oajlRWklFejB2?=
 =?utf-8?B?Z2VuYktlN3V4Q3BTb2lLeW1lV1MxeVdGek5WcXZiS1NrUE1RN3Qxdk0zbWd2?=
 =?utf-8?B?Y0dDaG5VeXVtSG1XNS8xZkZIZ2dacnVNTlJzZkcxcmpXSVVPd0tiSDc3Z2Uz?=
 =?utf-8?B?T2ZpWkcxNkhxdGV6SFdiUHFvbnJxQVpadjRsVkJkQ2c3SVFNVi9sQ05ySGNV?=
 =?utf-8?B?cURJM2ZENWd0dG93T1FNMVc4dHRwczduYitjeEJacEhEQ1VjeVg2SjEwWGRW?=
 =?utf-8?B?WlM4NjJPNFk5WWRlbGdqMVNsKy9SbUpJaURmWEV6WWVJdmpJall5cEZIODVT?=
 =?utf-8?B?cjZyMXduN3kzcTJWbis1QjR3bHowZFFkMkRoMVo3RWVjT2VTcEpZSVhwSTVT?=
 =?utf-8?B?Z3R5dmNRMDBiUlVkQmpVQUZSUG15S2c3ZTlPeFRaQmZZTUdiYlY4a2x3TGt6?=
 =?utf-8?B?Mzh0MkNTc2xONFJmNGFTMGRaZlo3eW1TMk42ZkNLUTc1ZDJXb3lWd0FsWnRu?=
 =?utf-8?B?dzM3MlBVZUFCNzE5RWp2QjdEaS9NUlByTlJrUUY1MWdReEpBYU81d21FWC9V?=
 =?utf-8?B?cWpNcjBHcjY5V2t0MHNEZ01jL1BMcFNSNklCcWplcUJMYitJQ2pHMG13alNL?=
 =?utf-8?B?NERCRG9xSFhUMEQvRzh5QTMxYmYyRDNCT0V0TDZhcFBpRkNETWovd0ZMMUs1?=
 =?utf-8?B?ZmZrN0ZOcXJPY3FUUVZxKzYrQm9SSWd5bzhqeEx2ZnNoK3FKcXJtbWpYb3J4?=
 =?utf-8?B?cFFXaUZnWTRpTFlaaG9HVUl2aWwvUDZqOGJpZGtQcTB1ak9Ya1lPcGFseVZx?=
 =?utf-8?B?dVdwazdXd0VhZWw3R3U2eXpzNUtWcG9aYnRSWUVyR2NRbk5lZkFZb3JNcktU?=
 =?utf-8?B?TXgyRkNFUWR5Ui9kZW9VZFBMMXBOWlhSK052d3E4VVAwOFlMd1JRcHNFcXN6?=
 =?utf-8?B?WWsyWmtUVEw1Q2tUWGhQcThRZm8rM0JLWVozM05DSWNxTi92a2QvZWJyeEIy?=
 =?utf-8?B?cEVhSVBRcmZqQUFjclZHN2djT0dxQ0RJZXpLWU1kc1lGVmExWjIwVVRVcXB3?=
 =?utf-8?B?Y3JPRE82dG1wYURKYkEwMEU3djUybmwwRW1ZSDEzUzk4Mnl5KzgyYk5JTVZu?=
 =?utf-8?B?dmhDK2owOG1CenJNaFVUZzNQdEZOb0tJTndiUG9jaU54VVJnOU9oZjBnbnND?=
 =?utf-8?B?TzFLR0FUM0dLdFZORUlmVzhMR2tyTnQ3a1hOclRjMkZRNGkxM3pSSWUzTHE0?=
 =?utf-8?B?akR3Z3lHWWt1YWdNVWQzU1pIN3YwdEcrSXBPQXoyOVk2c3VkTGovcTdLczNS?=
 =?utf-8?Q?Gb53YxH5kXPJSSwfQxBUhrk=3D?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <00AEF47F5CC48143943A7C7FF69BE099@namprd19.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: ddn.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM5PR1901MB2037.namprd19.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b261a4e7-9b7f-4269-5fcd-08db44c33a22
X-MS-Exchange-CrossTenant-originalarrivaltime: 24 Apr 2023 12:55:48.7231
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 753b6e26-6fd3-43e6-8248-3f1735d59bb4
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 493enhqkrOrBmdMHGaEJ+0YSOGXrupAtgHwBpEDz/ru/fkiaa6QryYFN651Dxx42epLqlKDKBL6qc1LXSp3kvw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ1PR19MB6284
X-Spam-Status: No, score=-3.3 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

T24gNC8yMi8yMyAxNTo0MCwgQmVybmQgU2NodWJlcnQgd3JvdGU6DQo+IE9uIDQvMjIvMjMgMDQ6
MTMsIEplbnMgQXhib2Ugd3JvdGU6DQoNCj4gDQo+IEp1c3QgZ2F2ZSBpdCBhIHF1aWNrIGZpbGUg
Y3JlYXRpb24vcmVtb3ZhbCBydW4gd2l0aCBzaW5nbGUgdGhyZWFkZWQgDQo+IGJvbm5pZSsrDQo+
IGFuZCBwZXJmb3JtYW5jZSBpcyBhY3R1YWxseSBsb3dlciB0aGFuIGJlZm9yZSAoYXJvdW5kIDgw
MDAgY3JlYXRlcy9zIA0KPiB3aXRob3V0DQo+IElPUklOR19TRVRVUF9TUVBPTEwgKGFkZGluZyBJ
T1JJTkdfU0VUVVBfSU9QT0xMIGRvZXNuJ3QgaGVscCBlaXRoZXIpIGFuZA0KPiBhYm91dCA1MDAw
IGNyZWF0ZXMvcyB3aXRoIElPUklOR19TRVRVUF9TUVBPTEwpLiBXaXRoIHBsYWluIC9kZXYvZnVz
ZQ0KPiBpdCBpcyBhYm91dCAyMDAwIGNyZWF0ZXMvcy4NCj4gTWFpbiBpbXByb3ZlbWVudCBjb21l
cyBmcm9tIGVuc3VyaW5nIHJlcXVlc3Qgc3VibWlzc2lvbg0KPiAoYXBwbGljYXRpb24pIGFuZCBy
ZXF1ZXN0IGhhbmRsaW5nIChyaW5nL3RocmVhZCkgYXJlIG9uIHRoZSBzYW1lIGNvcmUuDQo+IEkn
bSBydW5uaW5nIGludG8gc29tZSBzY2hlZHVsZXIgaXNzdWVzLCB3aGljaCBJIHdvcmsgYXJvdW5k
IGZvciBub3cgdXNpbmcNCj4gbWlncmF0ZV9kaXNhYmxlKCkvbWlncmF0ZV9lbmFibGUoKSBpbiBi
ZWZvcmUvYWZ0ZXIgZnVzZSByZXF1ZXN0IHdhaXRxLA0KPiB3aXRob3V0IHRoYXQgcGVyZm9ybWFu
Y2UgZm9yIG1ldGFkYXRhIHJlcXVlc3RzIGlzIHNpbWlsYXIgdG8gcGxhaW4NCj4gL2Rldi9mdXNl
Lg0KDQoNCkJ0dywgSSBoYXZlIGFuIGlkZWEuIEZvciBzeW5jIHJlcXVlc3RzIHRoZSBpbml0aWFs
IHRocmVhZCBjb3VsZCBkbyB0aGUgDQpwb2xsaW5nLCBsaWtlDQoNCnJpZ2h0IG5vdyBpdCBpczoN
CmFwcCAtPiB2ZnMvZnVzZSAtPiBmaWxsIHJpbmcgcmVxIC0+IGlvX3VyaW5nX2NtZF9kb25lIC0+
IHdhaXRxLXdhaXQNCg0KY291bGQgYmVjb21lDQphcHAgLT52ZnMvZnVzZSAgLT4gZmlsbCByaW5n
IHJlcSAtPiBpb191cmluZ19jbWRfZG9uZSAtPiBwb2xsIHJpbmcgZm9yIFNRDQoNCk9idmlvdXNs
eSwgaXQgaXMgYSBiaXQgbW9yZSBjb21wbGV4IHdoZW4gdGhlcmUgYXJlIG11bHRpcGxlIHJlcXVl
c3RzIG9uIA0KdGhlIHNhbWUgcmluZy4NCg0KDQpGb3IgYXN5bmMgaXQgY291bGQgYmUNCmFwcCBw
YWdlIGNhY2hlZCB3cml0ZQ0KCS0+IHZmcy9mdXNlIC0+IGZpbGwgcmluZyByZXEsIHdpdGggbWF4
IDFNQiByZXF1ZXN0cw0KCQktPiBpb191cmluZ19jbWRfZG9uZQ0KCQktPiBjaGVjayBpZiB0aGVy
ZSBhcmUgY29tcGxldGVkIGV2ZW50cw0KCQktPiBiYWNrIHRvIGFwcCwgcG9zc2libHkgbmV4dCBy
ZXF1ZXN0DQoJLT4gYXN5bmMgcG9sbCB0YXNrL3RocmVhZCAoc2ltaWxhciB0byBTUVBPTEwsIGlm
IHRoZSByaW5nIHdhcyBub3QgDQpwb2xsZWQgZm9yIHNvbWUgYW1vdW50IG9mIHRpbWUpDQoNCg0K
DQpJIHdpbGwgaW52ZXN0aWdhdGUgaWYgdGhpcyBpcyBmZWFzaWJsZSBvbmNlIEknbSBkb25lIHdp
dGggb3RoZXIgY2hhbmdlcy4NCg0KDQoNCkJlcm5kDQoNCg0K
