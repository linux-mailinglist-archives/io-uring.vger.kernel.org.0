Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CA61860FC55
	for <lists+io-uring@lfdr.de>; Thu, 27 Oct 2022 17:50:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235626AbiJ0Puq (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 27 Oct 2022 11:50:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53380 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234105AbiJ0Pup (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 27 Oct 2022 11:50:45 -0400
Received: from mx0a-00082601.pphosted.com (mx0a-00082601.pphosted.com [67.231.145.42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AB5F817F9BD
        for <io-uring@vger.kernel.org>; Thu, 27 Oct 2022 08:50:42 -0700 (PDT)
Received: from pps.filterd (m0109333.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 29RCQmcR023342
        for <io-uring@vger.kernel.org>; Thu, 27 Oct 2022 08:50:42 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=meta.com; h=from : to : cc :
 subject : date : message-id : references : in-reply-to : content-type :
 content-id : content-transfer-encoding : mime-version; s=s2048-2021-q4;
 bh=xFc76bl311J9CnAxuBVVpngsYRnhin4uDifm+hMj/Vk=;
 b=a3PzY0cp6eMtI0ucQGH5lTmPgescw6CZ5STAxhsG6s7hnv2ni5L73/jlx+XPn5I7sH35
 A7SK/41ugqjD+hdSEVHgLjhhIFOLH+Updm1gZjfhkLnTt2/oVC/+6FNeKzQdOQxceoDF
 OjzamCSqvwEI3P1KX8baUuVhZenywcJnFehFWyzhVhx1i+00ugaCuLRcG5Ku2sD5HJq2
 KnaNZdPq9ZH+BfdW7ZyBYww0cuJ1k3d7oL4WpmIblASV/QXq00sEb9EMIQj+jNmKD6OB
 j58Ws+MYjm6fXy5RVVvrHFDGCz5kb44Ed8yWcZ7s876Z76C0oOfVWRtwWeRCnGe8ODkB 1g== 
Received: from nam04-dm6-obe.outbound.protection.outlook.com (mail-dm6nam04lp2043.outbound.protection.outlook.com [104.47.73.43])
        by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 3kfahwtbds-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <io-uring@vger.kernel.org>; Thu, 27 Oct 2022 08:50:41 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=DaCxCXrGVnBpJHzcBYYG/PohiNo/5gU2dAFygo36Y7ZHNwYfd1ve1JQr8cYmifvr7Wms2sTwKLaI2VOwKwEZlyHW4oe3GXu8bPxcVhbQfn5lIMt3IuRkJ96SnhIZSY3rv8bJi21XrWDLJ5mf24k3jZRTl881QR/Usadcj/DkfAdPuZoYg4P4aAZxMMcIw8hvITMIJO7CiUY66XF6BOgGIKWKPDWe/bxmZXr8pBjx9joK1D8j5ZYaQKeKFD+2zmNgY2TqQsFcj+vDw1M3z0BRLTQbrRfuyuD9LYnGh/y3iayh72f2PSTruHtvfqbVQp+Yc2ah/dmwnpd4q4cFB0P44Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=xFc76bl311J9CnAxuBVVpngsYRnhin4uDifm+hMj/Vk=;
 b=cKBzrzqmNj1mj/xXWXQ+U21aXuNT3EpRZPXRntUI22Z1euY3xDwHlTz1d5MWfxSdJHIL46fRqRLZM8RS85g/o3Qyn7cmT29pVvhu2rh3MTOLhQvmJ4y3io+Nul9wSA/XhT/n2bYRn7A3wPh1MBwpv0WcJNL0VhmiMPXaW3XtTub6z/bXuZViJXVkjOQfB75TSpgX997ciLuabX0rSm0MQCM5wG05/ScmWG4I96j0/VVRknOlPwq2BBbIApFcMCym20W9GperS7ciBDZ5n62qcV6mg7j0QsbRaERIU0ZA8OFHI+ZrboqStX2yXatbHD3jryBr0Z27RVSmsiK7TgBL7g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=meta.com; dmarc=pass action=none header.from=meta.com;
 dkim=pass header.d=meta.com; arc=none
Received: from SA1PR15MB4854.namprd15.prod.outlook.com (2603:10b6:806:1e1::19)
 by BL3PR15MB5412.namprd15.prod.outlook.com (2603:10b6:208:3b4::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5723.29; Thu, 27 Oct
 2022 15:50:38 +0000
Received: from SA1PR15MB4854.namprd15.prod.outlook.com
 ([fe80::1b85:7a88:90a4:572a]) by SA1PR15MB4854.namprd15.prod.outlook.com
 ([fe80::1b85:7a88:90a4:572a%6]) with mapi id 15.20.5746.028; Thu, 27 Oct 2022
 15:50:38 +0000
From:   Dylan Yudaken <dylany@meta.com>
To:     Dylan Yudaken <dylany@meta.com>,
        "axboe@kernel.dk" <axboe@kernel.dk>,
        "asml.silence@gmail.com" <asml.silence@gmail.com>
CC:     Kernel Team <Kernel-team@fb.com>,
        "io-uring@vger.kernel.org" <io-uring@vger.kernel.org>
Subject: Re: [PATCH 2/2] io_uring: unlock if __io_run_local_work locked inside
Thread-Topic: [PATCH 2/2] io_uring: unlock if __io_run_local_work locked
 inside
Thread-Index: AQHY6hKq/idf2gkJXk2m6fv64t2b3K4iYBYAgAADe4A=
Date:   Thu, 27 Oct 2022 15:50:38 +0000
Message-ID: <aff511d235d730ee0a31fc29dc6bb94ff3bdd80c.camel@fb.com>
References: <20221027144429.3971400-1-dylany@meta.com>
         <20221027144429.3971400-3-dylany@meta.com>
         <bc3a9ac6-9e31-6a8f-1511-95eef4209da3@kernel.dk>
In-Reply-To: <bc3a9ac6-9e31-6a8f-1511-95eef4209da3@kernel.dk>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: SA1PR15MB4854:EE_|BL3PR15MB5412:EE_
x-ms-office365-filtering-correlation-id: dd2efb20-251c-47eb-e35c-08dab832fe89
x-fb-source: Internal
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 4ayRhFa8EKMss2AvWu1L75QHpP/PpIy1YqN2vbRl4NSNnSGRWy3UeYH8/0L56XtihlccTdwdIKeDdrxcS9FNR0hPar3yz15u0GQD7XhGxUKPteJkxtjjnS/RUFBxhTkeDtS6iU1pjzeywGXC/HJvM+o12uly+Tknc4pHakmaKjdl/XuOGdNv11xr19Gdn1enfXg5w8Ir5UMTuunDurYSdg4ibkUckQumim+uuGoK45ferpyA37xBe1MSO5XrEDGPJqPR2NIcOhxEHC1dj/ehZLqydh+3BovtB65/N4Bwgj36wWgQ6CaYeQYEaj0Sgp1y6lrdaThoPnweB+UKILJjCFsdfNDq1BGp/6ZJcTfIgjC9QiyoBU+XThAf+rnXNCLaoWHcK6H+uvGJAZH4STI5UpNrlp0PImZFtNaxPS/klP493wYT17jDHMx1kGl3vIBgp6a/XgyCy0JhqqbpUUcj2ZkKLqGz68b4aDSwpPn3DlU/DSz2lSScqZ6Tn2d+pXh2jJefkyXe59LIE+Q4IpNbEiALKlQp39LkA6NLxTqjXAiyHDnPqpNu5gUV3fZRsKQcEkDeMq0tGgBpkr83ClUZpovP+8B7LLjUE8ZhF8AH7lLnnLogqSqpqkupn7lYwFQ9Ogofh0NJiXTamCA2yK3vWxmkdGbt7JLoIKtK5p5hiDDJqlZuhGBMj94FcP6tPv7WY5TbbkhfbWcHN4cZkEehtwe0AruKyE7Oex5X5VyFIXO8YFpoudEHBE3gUA9n0OOO79m5RMdKzNTKBZ35su2jZg==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR15MB4854.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(136003)(376002)(366004)(346002)(39860400002)(396003)(451199015)(71200400001)(2906002)(4744005)(186003)(6486002)(38070700005)(478600001)(110136005)(54906003)(316002)(36756003)(83380400001)(76116006)(64756008)(66476007)(66556008)(66446008)(53546011)(4326008)(8676002)(6506007)(91956017)(66946007)(8936002)(5660300002)(6512007)(9686003)(4001150100001)(26005)(41300700001)(86362001)(38100700002)(122000001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?ZGlNQ0VDU3IyZU1vbkI1TC9DdklxSUZxUURZZVlaWHh1dTdSVnB4S09obW1E?=
 =?utf-8?B?WWJteFpmOTJMbThrVCtGM1l4OWZJT3MzOC9uWmRGdUtIb3VQcFB5dXJRQ1FM?=
 =?utf-8?B?MDJNSTFlUDZKMUdadmZnQkVKeWRXc3FtN0hrVE9jY1NiZUxtbGZMNzR2WWpB?=
 =?utf-8?B?NHBRU2ZaNzladEt2bURaRVpnd09BY3RxZko2OEhxaEdWMlBybFFVSm1YS1BP?=
 =?utf-8?B?ZTJNZ1NhVHdoRXpzOXIrTzQvUDBlbzhMNUtLNFE0aG1LSGMxM1JDMitPY3po?=
 =?utf-8?B?SUMwWTFRdFNUQ1dmZFNWaFFEWXlWSTFISTNkaURCTkRFNUw3VEhra0loK1ht?=
 =?utf-8?B?bXFxM3VHQ0ljV3NhV3BWc1JtUHRmWklQT3pudzB3eTBFc3NoeW1obFpEREVP?=
 =?utf-8?B?M2EwNkQzbzY1YTZOeHo3K1g0VDVBa09VcnB0dC94bzgzai9EZlg0S2hTVFEz?=
 =?utf-8?B?VjFVbXBsWlJrSmxWUTRLVEN1Y0hIOWhJb2JnMFBuQlFYYUs1bnJ2VlNSQVJ2?=
 =?utf-8?B?bEYzaUFndEt3NWRBNnNEVHdpUGdQZUkzZWVuejliRm9Xa1VrS3FCWk9pWDho?=
 =?utf-8?B?TFVkaXVSTjA5SUtISWtRVk5odHhXcjlhdFBCK2VvRm54UVJkaGRPR1lRM0FE?=
 =?utf-8?B?UEdOa3QrRmdOUGl6M2QvZjl6SkRleVlqbmVPaFVzVWpUTE9DdytqZHhwcVBS?=
 =?utf-8?B?dDJyOFNMdHNQd1VING5PTC96NG1BWTl2NlRrYS9SbTk3Z0RmeWdKYlU3WXBS?=
 =?utf-8?B?UERsM2wxaGttdjc4ekdZSVRza25hTlFST0hINVNwVXZoY1Z1K3h3LzhsVy9l?=
 =?utf-8?B?ZHV4M2JNc2NzUlJhZ2ViV3p4czBaR3FUT3BtbFRHT2lqTjFmZWs2NSszMDBp?=
 =?utf-8?B?dytiMFIrU2I3S0NwRW1JMjFhZURZMTZmMy92K05PdkFwUGNlYkt3NzBCbnMz?=
 =?utf-8?B?Wk5hNEFOQjN3bFNvYVErT3R5NXMzdjFRM05jeWZuQS9ncjJMTUV6aC9aNGl3?=
 =?utf-8?B?NWx1Y0FpNVlCUERrYlRxVlR5RGl5bFY0VE1pVDZpZzJYMEJiSDJJWExHQTdE?=
 =?utf-8?B?dnpUcGxsbFRhdGM3MTd4MmFRNUprQ3Fid25IL2RHT1prRGsvblROTmp1b0tn?=
 =?utf-8?B?bGJuREJPMmNCM3h5Q2RlVnUvNkQ0czc3SllOMllPOGdEMFM0NWFJTFdKRE5L?=
 =?utf-8?B?OU1vNXJ1MExJb3dxMFNpdE9wcWxaeGtvYldnQlVqMVVzMFYzVGdtbGVRMThl?=
 =?utf-8?B?T1JnbUJSMjBoY3o5d0lFZUhQa0hLdnhPQVNiT2ZWUWsyZHpZUy9odTJHL0lz?=
 =?utf-8?B?UE1wVTY5c0g3NlhyLzEvQmVzcFI5dXh6Um9yeUIzaW55K083OVhEd0M1NG9w?=
 =?utf-8?B?dkpCSmhnR2J2aVV1Z0JlcGxmL09iT2oxWTdHdHBodXZxQ3V3NEZ3R2tPUktw?=
 =?utf-8?B?TXZYd1pLd25rWGdkdDU1bFBDSExvVmJvTGNua2FxTHErNjRmRGZiSkhMc3R5?=
 =?utf-8?B?QmRLN2ZTbU02SlVxUjZrZEtYay9SWWo3czJCUmdrODNSQmJxdmlNTG9KU1lt?=
 =?utf-8?B?Rk1odmF3dW9zN2pUc2YrbVozNGV0WTkva0FPcUhyVlNRb0VLWHZjMXQxVUFp?=
 =?utf-8?B?eWJDUndkSzVyRUIyaGU5ajE5S0FPM1JIWW5mTXBWL0c0aENzZFBnZjkwMkYx?=
 =?utf-8?B?empPVmgrUXJ2UWdjRXVVNTFScEtVdWFDcDE3OXhqU2NMcURlTVlkZkJPMWd4?=
 =?utf-8?B?dGs1M1NVL3kzSUIxUnlxaXdNaEhVVWF3QmtiYWp5UXhQTzF3Wi9wam5UYUho?=
 =?utf-8?B?dFN1YkIvbGVwVjQyK2xIZ0dpNUhQc0ZvT0lMWVlyVllxMURSanVZYjN2aTgz?=
 =?utf-8?B?dkhjVlBCVXorMHBrNnI2SzcwSFhwVlZ3R3p4ZEFqSUI4Nll3S3gvemhZVGtB?=
 =?utf-8?B?UHA3ZG15SFRpZXlvSDFOaVcxMDRzTmtEeVY3ald1ZmQ2YTB1Tlpld0lxbWdH?=
 =?utf-8?B?d2N6ZWJGZmhPbVVyMnErbDI3Z3JrTlFvNkNHM0F6Q0xzak1jMmlvT2Vua1Br?=
 =?utf-8?B?RjIzbkhmTEJZT2xJblBUMFRjY0pJMlYvbjczU0lrcmdJNzFVN3M2K29TOVky?=
 =?utf-8?Q?ieD4G7m+A3EruPnerC8KR17rt?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <4E0BF9F943660742A39E8B558B2F4D05@namprd15.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: meta.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SA1PR15MB4854.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: dd2efb20-251c-47eb-e35c-08dab832fe89
X-MS-Exchange-CrossTenant-originalarrivaltime: 27 Oct 2022 15:50:38.4202
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: EFbAPEFUuoQjq+meTWoYP0OmglYfMl2Um0r/xO7rvo8SUjByNoxVPdapKNdIEKl9
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL3PR15MB5412
X-Proofpoint-GUID: j_uYUQuThP5KhH-aTvQzkSyu1-WQW2F3
X-Proofpoint-ORIG-GUID: j_uYUQuThP5KhH-aTvQzkSyu1-WQW2F3
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.895,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-10-27_07,2022-10-27_01,2022-06-22_01
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

T24gVGh1LCAyMDIyLTEwLTI3IGF0IDA5OjM4IC0wNjAwLCBKZW5zIEF4Ym9lIHdyb3RlOg0KPiBP
biAxMC8yNy8yMiA4OjQ0IEFNLCBEeWxhbiBZdWRha2VuIHdyb3RlOg0KPiA+IEl0IGlzIHBvc3Np
YmxlIGZvciB0dyB0byBsb2NrIHRoZSByaW5nLCBhbmQgdGhpcyB3YXMgbm90IHByb3BvZ2F0ZWQN
Cj4gPiBvdXQgdG8NCj4gPiBpb19ydW5fbG9jYWxfd29yay4gVGhpcyBjYW4gY2F1c2UgYW4gdW5s
b2NrIHRvIGJlIG1pc3NlZC4NCj4gPiANCj4gPiBJbnN0ZWFkIHBhc3MgYSBwb2ludGVyIHRvIGxv
Y2tlZCBpbnRvIF9faW9fcnVuX2xvY2FsX3dvcmsuDQo+ID4gDQo+ID4gRml4ZXM6IDhhYzVkODVh
ODliNCAoImlvX3VyaW5nOiBhZGQgbG9jYWwgdGFza193b3JrIHJ1biBoZWxwZXIgdGhhdA0KPiA+
IGlzIGVudGVyZWQgbG9ja2VkIikNCj4gPiBTaWduZWQtb2ZmLWJ5OiBEeWxhbiBZdWRha2VuIDxk
eWxhbnlAbWV0YS5jb20+DQo+ID4gLS0tDQo+ID4gDQo+ID4gK8KgwqDCoMKgwqDCoMKgaWYgKFdB
Uk5fT04oIWxvY2tlZCkpDQo+ID4gK8KgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoG11dGV4
X2xvY2soJmN0eC0+dXJpbmdfbG9jayk7DQo+ID4gK8KgwqDCoMKgwqDCoMKgcmV0dXJuIHJldDsN
Cj4gPiDCoH0NCj4gDQo+IElmIHlvdSB0aGluayB3YXJuaW5nIG9uICFsb2NrZWQgaXMgYSBnb29k
IGlkZWEsIGl0IHNob3VsZCBiZSBhDQo+IFdBUk5fT05fT05DRSgpLiBPciBpcyB0aGlzIGxlZnRv
dmVyIGRlYnVnZ2luZz8NCj4gDQoNCkl0J3Mgbm90IGxlZnRvdmVyLiBCYXNpY2FsbHkgaXQgc2hv
dWxkIG5vdCBiZSAoYWZhaWspIHRoYXQgdHcgd2lsbA0KdW5sb2NrIHRoZSBtdXRleCwgYnV0IEkg
ZGlkbid0IHdhbnQgdG8gbGVhdmUgYSBkYW5nbGluZyB1bmxvY2tlZCBtdXRleC4NCg0KTWF5YmUg
dGhhdCBpcyBiZWluZyB0b28gY29uc2VydmF0aXZlIGFuZCB3ZSBjYW4ganVzdCBraWxsIGJvdGgg
bGluZXMgLQ0Kd2UgbmV2ZXIgdXNlZCB0byBjaGVjayBmb3IgdGhpcy4NCg0KSGFwcHkgZm9yIGVp
dGhlciB3YXkNCg0KRHlsYW4NCg==
