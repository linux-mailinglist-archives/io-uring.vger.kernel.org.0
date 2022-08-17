Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 131A3596E23
	for <lists+io-uring@lfdr.de>; Wed, 17 Aug 2022 14:07:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236579AbiHQMEL (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 17 Aug 2022 08:04:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36048 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239174AbiHQMEK (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 17 Aug 2022 08:04:10 -0400
Received: from mx0b-00082601.pphosted.com (mx0b-00082601.pphosted.com [67.231.153.30])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4CE964BD22
        for <io-uring@vger.kernel.org>; Wed, 17 Aug 2022 05:04:05 -0700 (PDT)
Received: from pps.filterd (m0109332.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 27H0J3Qw007505
        for <io-uring@vger.kernel.org>; Wed, 17 Aug 2022 05:04:04 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : references : in-reply-to : content-type : content-id
 : content-transfer-encoding : mime-version; s=facebook;
 bh=KoH8Fu2GfvVbflj85gcJmHVUGaHUAyvp/fYgzhh8SJc=;
 b=CPF8R4D82qAjDqlcux7qpJmSnLWfVHTwRZU/K3BH4JeVAg2qTG/eEedeJtzC0ndwyMOO
 Ny+rGe/mMaR7KSZE3hd/hmpxUxUtS01eCAjG6OVymVrau7gVIoa2AylHHT6MEcysE54d
 psGktXgnKHfcjcxaS6k7sZMgIrw2Rfvlfug= 
Received: from nam12-bn8-obe.outbound.protection.outlook.com (mail-bn8nam12lp2171.outbound.protection.outlook.com [104.47.55.171])
        by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 3j0np5an7j-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <io-uring@vger.kernel.org>; Wed, 17 Aug 2022 05:04:04 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ciBFO4k69t7hPZ7W69o0AO/iNdKcT2UUW210ziDnxZJ6fyKjf818dWPCY3VvzR/Tzn/uuES2NS1srfxiesfROHH7PofuhZYCPgBJR4x3rIF4fg30O5TpYiPnBXlZ+olYDI5g9SFW/aVEdsEdyQHf5yk5MfCi/sjAOfJP1FnEG+CokgnI1gYxgdRuhADNMnMSOb2mrADPkk6Osj3iEfY4m7JRUKdRQ0Xtg3aXSVgo5JiuxaPLEd2ezg5ueTu/pn6QVNdMtjrjcznkuRmldtTXVJ8PHiV6aZ7Y6w6/fWXQCjieKZ0pgCIF4nPiIJKK2nBz7wIrgpvp02UUe7jvYENFYQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=KoH8Fu2GfvVbflj85gcJmHVUGaHUAyvp/fYgzhh8SJc=;
 b=bSneIg2UUXqgPalERPDSnBFpib6n1z+OjwgkI5tRsnzWKEwm90rX4K+wP4EAC83arxjm/jfsCTfXhBmeE3Td2kWnMxDfsYUo2GJRU+K7pNtKe0YxsR1LuQcBjxGraK5NBekbSLkF+YNrQ3nIqVvD6R616iJhd27EnzUl+JkCUA4sZQ21Cp69Z6C75Z+PjECDryux6JTiibate1GUryKr0Y77NBvgfiDAe2Mt1L3+gquieSXl1WkcZtcFJfzWGTFuHf/3pJTUxuWo+msViSxqdoqvemTjS2+DbOtz4JbY0hUpuMiEyed1qxffgcEBqu/mxuO0IMmCUQYrEMOrfafCjQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
Received: from SA1PR15MB4854.namprd15.prod.outlook.com (2603:10b6:806:1e1::19)
 by BY5PR15MB4274.namprd15.prod.outlook.com (2603:10b6:a03:1b4::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5525.10; Wed, 17 Aug
 2022 12:04:01 +0000
Received: from SA1PR15MB4854.namprd15.prod.outlook.com
 ([fe80::b916:6bc5:47d:c7ac]) by SA1PR15MB4854.namprd15.prod.outlook.com
 ([fe80::b916:6bc5:47d:c7ac%6]) with mapi id 15.20.5525.019; Wed, 17 Aug 2022
 12:04:01 +0000
From:   Dylan Yudaken <dylany@fb.com>
To:     "asml.silence@gmail.com" <asml.silence@gmail.com>,
        "io-uring@vger.kernel.org" <io-uring@vger.kernel.org>
CC:     "axboe@kernel.dk" <axboe@kernel.dk>,
        "metze@samba.org" <metze@samba.org>
Subject: Re: [RFC 2/2] io_uring/net: allow to override notification tag
Thread-Topic: [RFC 2/2] io_uring/net: allow to override notification tag
Thread-Index: AQHYsUPejHDhGmwbL06/vh5zIpHdCa2xNFcAgAG204CAABUtAA==
Date:   Wed, 17 Aug 2022 12:04:01 +0000
Message-ID: <4bd2100042b18eda569fc31f434f48cc922a7b84.camel@fb.com>
References: <cover.1660635140.git.asml.silence@gmail.com>
         <6aa0c662a3fec17a1ade512e7bbb519aa49e6e4d.1660635140.git.asml.silence@gmail.com>
         <4d344ba991c604f0ae28511143c26b3c9af75a2a.camel@fb.com>
         <96d18b77-06d8-3795-8569-34de5c8779f1@gmail.com>
In-Reply-To: <96d18b77-06d8-3795-8569-34de5c8779f1@gmail.com>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 3dfaa097-4e65-4af6-6c90-08da804892c7
x-ms-traffictypediagnostic: BY5PR15MB4274:EE_
x-fb-source: Internal
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: ey+9uVC1N0G85Qt3Zi8IyFtsl5iOXHr6v5hd6VH5Hq3xkMBRthnd+jJoAungS3KMi6mBNi2shTvxQEXkwXO5S5BcZDG/Uv+qLQqhGqGyBH2HKevwSZVM08dO06PwdMNu3yGx0RRlVZKj/scblZAw07wuD293wjFSsgM9yM8K/UzZVF56h9DVLeuKXTjdGtu9sn0Bw15sgowr0KvdfHZvPTQHV01dofYUCQNueGqbzaW2ZvxMwzoIsISdI4E12avKQmEYGsrOe66xd+PeMEDaAERw0lHjs3FgKzsvXmQoqU0uzb4xLlMvhn1yGBgRXCcRef4pDZPZZ0zPqxkO9CsDBk4nE7728cFzXIFMkyEgv1FD1pQokfuP6nS0/+0tvtMq3aEi6g/Br/AAmFMcloXUWJtIGd7XrxYYZT+5NzGzIFHFgYgrVgq1XuBqO4EqqgQjrfMHm4X8GcKy1H/E6i4efIIEbGF9c0TiTUA9VFG/TV2EYPb3A/1KjaXda7GYnfpt9W8YZAWa3rmLGvI7lVXAKHHeYOSh60GCxYGGtBvl8NQgl05SuAQ+1hXOSMXBcjEy4LPa3OQpcNvnSRWZ4QHoZhILwsWAnicuZ5tBQU32FIDnxY4pM9taMqpWXWWEmKChCfDJfqpFbEa+bv7mRH/KCPRl0reBYAYfJtRcOWMNPgDvLi3sqjP1j44xIflofBFDPPmJGeMA1hqXA8TkLkZ3x+Ijm3q5ApLT2Gu9WXr5ft3blw3dp6F0V0gCajVfl3buqU9hTrCEnEerE+s/cq07WHqpofCq9i92pARD+F4Vk+8=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR15MB4854.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(396003)(346002)(136003)(39860400002)(366004)(376002)(64756008)(83380400001)(186003)(38070700005)(316002)(66476007)(122000001)(38100700002)(5660300002)(66946007)(91956017)(76116006)(66556008)(8676002)(66446008)(6512007)(8936002)(15650500001)(53546011)(54906003)(2616005)(2906002)(4326008)(41300700001)(86362001)(478600001)(71200400001)(6506007)(110136005)(6486002)(36756003);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?NDR5b005V1hMRk8vNzJ5WTRydU1HQS9VMCtjWGp3djBka2JBcGRScSs1ZWhZ?=
 =?utf-8?B?YzFacXV2ZEdVbzl4djEyRUd0UGRBK24zVkEvN0lQSkRKdmNGOXVERmRXUCtW?=
 =?utf-8?B?SWlwYk5IVTBNZkx2RElTTFUweFc3MVpsMzdHVWVZWGs0aDk2YUc1U05Ra0RI?=
 =?utf-8?B?N3Fzb0ZMTURBS3VjTTY5Y3M4am5ZZHhUcDNHVU9LdjQxdFdiMEZieTVBeE9P?=
 =?utf-8?B?TmdUUzVVbWxnZkVmbTU4Z2hzUmg5WlBtTjd4d1B1bURpZDQ1RkJQNFF6TndB?=
 =?utf-8?B?MUhhdFFCSFNxRzVZWlRraDVGczZLU0xiVnhJT3dOQmpnZ0I3VTdSejFab1Qr?=
 =?utf-8?B?VDJwbE1TNktzaHVTZnlBSTlIMlRWK01UcWNhQnd4NmtKWHphOGR6cmR0K2Ft?=
 =?utf-8?B?UDI0cjJxVHVMbXpuTzU0YktFSXc0N3BWNVIydEpseXRUTTR4OFI5Uis1RTMw?=
 =?utf-8?B?WURrU2FjTkYwWEIvdVlseVRWRE92SXhQTDQ4UkhuVk4xTFI2VEs3UnozMW8x?=
 =?utf-8?B?SitTM1M3UU5Zc0ZocVJRdHhudFpJa0M5bmVQekN3M0hVMnNEQlg3d2l4NlU0?=
 =?utf-8?B?ZHU4Vm1GNFNkUXI3cmJkQTJaY0VCekZCN3lhU2JNMWtlNlV0MHppeWZnejhX?=
 =?utf-8?B?N2M0R2ZoODZOd2pHM3F2elZ5cFh0V1hLWG16WFlYZ0pLanF6R1R5VFdkWU1G?=
 =?utf-8?B?L2s3TVdxRGYrZ2RRUWNKMGRNcUN0T0hndU0yaVFTWDlWZlpzUWF5b0RtVjc4?=
 =?utf-8?B?a2VObVVkcmF4OTNpaVNEWVZTSTNiWXV4QnRneEFWWmxYUUtJS3FJWTJLdTI1?=
 =?utf-8?B?Q3lTa2JsUWxFelRqYW9nbkVMWGgvOGZOS3dBbmV1eVYrcEFYVzZLVjNoaUVK?=
 =?utf-8?B?SlBKcDhVZXFLZ1M3NVdsaXhjRThIYlpFWFZ0OU9ZaDYzSzhZWDNMVjh1b3JU?=
 =?utf-8?B?dmxFbHZBSUFkR1o3QmQrVkpCbitSVHBFTTlaS0d2Z3dOVHdrano2dEpVeGpW?=
 =?utf-8?B?SExnc1N1SGw2VXFVMlVYY2NqdFl0VXFNVkNKL0RrL2hrTUNWSGNBeEJQM1dO?=
 =?utf-8?B?OVRWdVNFeDdTVHFYVmxJb24wQS9RcnVadWNTMUxaUTlRc1RJMjhzb1ROVTZI?=
 =?utf-8?B?TTcxVXpDL1AycW1BUHk5YXJUTGZGVUlRWjVGZFNKS2JiYm9VQUNpZVdYQXlC?=
 =?utf-8?B?SnNWM3JoelVEUUFzUFhRS1VzUDFkNnk2N3N3a25sb1c4T0lSQWN4UTUvSjdD?=
 =?utf-8?B?MGlwd3BDbUMyekRTZXh3UVg4MXdPTnJ6aTkyVWVzUXFMSGpCUmFad253MWJC?=
 =?utf-8?B?MGtRQWp4L3lKM29wNDZqTjdUYlZGb04yaUkzVEM5YjVrcnptQ29oQzVrSTFH?=
 =?utf-8?B?d04xNk0raHh0REdnUXBlUWMxKzA2VWdpSmhaMFUybk5jZWVhUWZxRHRFcnl3?=
 =?utf-8?B?by9OKzA5cFFDYm9NWkFMeWNWU2Q5aDFtN0taaUpVZTZEbTJUdncyelpHbnhk?=
 =?utf-8?B?YTZqSUtqTzN5ZFlXOURSQWlzL0Rka0NyZjVmVmtuL3JVaGZUQ0tEQm9HUEtG?=
 =?utf-8?B?WGxIeEczNDJ1ZW9rQXRtMGMrZmFySXBtTWVKNnJ2aSs1ZmVDN3pteklkOGs5?=
 =?utf-8?B?dGNGNVRaelBhQVhxTVpiRytEdHhWa3J2TG1waTVtWkEwWGdsTUpFZ01uVDJo?=
 =?utf-8?B?MmJjczJFcWpocjMyd09TWC9iTWFxejhkWkRDM0dJdkxkSTExZExtYWtncER0?=
 =?utf-8?B?R3d2OXVEYUdBL25Da2ZzRjNudlhlZFk3RXFNbW5LTHF6cjNFNU8yMTUybm9q?=
 =?utf-8?B?T3FVcFlMeDRUVmROL01DMmlnL2dVY2h4VkdLMU9VRGdxNjRjSFVFY1k4Y1Br?=
 =?utf-8?B?ejZ5RTdUVHNTYW9wbmxaM2FlYzVocG5hWGZLTkpNTkZOWnlLRUlTN0M2VFl5?=
 =?utf-8?B?UVVNVSs3MTVYb2NkNHpJeFo5UG1UTVlBbjBwYU85cytSTHZQTVdRV29rdmdD?=
 =?utf-8?B?MTZwSURXUGg3cmVFWHFIbDBkVm5Iek0xcTd6VG16dTNrSjZjL1B1SmlDcGc0?=
 =?utf-8?B?THVkeHIxZVE5UzJmeUpiMXVwL2dHbjFpclFtRGp3QjhHOGdVcm9tdXdIRkhY?=
 =?utf-8?B?aW01UmlJVFUwc0hYK1FacnBuY3RUUTZoSy9hWDJnMll1bWMrTk9yWDFLYzhY?=
 =?utf-8?B?WXc9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <88FB8FA55169FE48B3321F0CA22A15CA@namprd15.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: fb.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SA1PR15MB4854.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3dfaa097-4e65-4af6-6c90-08da804892c7
X-MS-Exchange-CrossTenant-originalarrivaltime: 17 Aug 2022 12:04:01.4577
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: h6FzdAn7BTGz0c8JWSqpJ4IzK/n0vXU26XyuAS/9/GXGdH6z2jT2CGXdvWoHnfF9
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR15MB4274
X-Proofpoint-GUID: siTva4DaOUTaMQRMPVySZnAKNnC23p0G
X-Proofpoint-ORIG-GUID: siTva4DaOUTaMQRMPVySZnAKNnC23p0G
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.883,Hydra:6.0.517,FMLib:17.11.122.1
 definitions=2022-08-17_05,2022-08-16_02,2022-06-22_01
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

T24gV2VkLCAyMDIyLTA4LTE3IGF0IDExOjQ4ICswMTAwLCBQYXZlbCBCZWd1bmtvdiB3cm90ZToN
Cj4gT24gOC8xNi8yMiAwOTozNywgRHlsYW4gWXVkYWtlbiB3cm90ZToNCj4gPiBPbiBUdWUsIDIw
MjItMDgtMTYgYXQgMDg6NDIgKzAxMDAsIFBhdmVsIEJlZ3Vua292IHdyb3RlOg0KPiA+ID4gQ29u
c2lkZXJpbmcgbGltaXRlZCBhbW91bnQgb2Ygc2xvdHMgc29tZSB1c2VycyBzdHJ1Z2dsZSB3aXRo
DQo+ID4gPiByZWdpc3RyYXRpb24gdGltZSBub3RpZmljYXRpb24gdGFnIGFzc2lnbm1lbnQgYXMg
aXQncyBoYXJkIHRvDQo+ID4gPiBtYW5hZ2UNCj4gPiA+IG5vdGlmaWNhdGlvbnMgdXNpbmcgc2Vx
dWVuY2UgbnVtYmVycy4gQWRkIGEgc2ltcGxlIGZlYXR1cmUgdGhhdA0KPiA+ID4gY29waWVzDQo+
ID4gPiBzcWUtPnVzZXJfZGF0YSBvZiBhIHNlbmQoK2ZsdXNoKSByZXF1ZXN0IGludG8gdGhlIG5v
dGlmaWNhdGlvbg0KPiA+ID4gQ1FFIGl0DQo+ID4gPiBmbHVzaGVzIChhbmQgb25seSB3aGVuIGl0
J3MgZmx1c2hlcykuDQo+ID4gDQo+ID4gSSB0aGluayBmb3IgdGhpcyB0byBiZSB1c2VmdWwgSSB0
aGluayBpdCB3b3VsZCBhbHNvIGJlIG5lZWRlZCB0bw0KPiA+IGhhdmUNCj4gPiBmbGFncyBvbiB0
aGUgZ2VuZXJhdGVkIENRRS4NCj4gPiANCj4gPiBJZiB0aGVyZSBhcmUgbW9yZSBDUUVzIGNvbWlu
ZyBmb3IgdGhlIHNhbWUgcmVxdWVzdCBpdCBzaG91bGQgaGF2ZQ0KPiA+IElPUklOR19DUUVfRl9N
T1JFIHNldC4gT3RoZXJ3aXNlIHVzZXIgc3BhY2Ugd291bGQgbm90IGJlIGFibGUgdG8NCj4gPiBr
bm93DQo+ID4gaWYgaXQgaXMgYWJsZSB0byByZXVzZSBsb2NhbCBkYXRhLg0KPiANCj4gSWYgeW91
IHdhbnQgdG8gaGF2ZToNCj4gDQo+IGV4cGVjdF9tb3JlID0gY3FlLT5mbGFncyAmIElPUklOR19D
UUVfRl9NT1JFOw0KPiANCj4gVGhlbiBpbiB0aGUgY3VycmVudCBmb3JtIHlvdSBjYW4gcGVyZmVj
dGx5IGRvIHRoYXQgd2l0aA0KPiANCj4gLy8gTVNHX1dBSVRBTEwNCj4gZXhwZWN0X21vcmUgPSAo
Y3FlLT5yZXMgPT0gaW9fbGVuKTsNCj4gLy8gIU1TR19XQUlUQUxMLA0KPiBleHBlY3RfbW9yZSA9
IChjcWUtPnJlcyA+PSAwKTsNCj4gDQo+IEJ1dCBtaWdodCBiZSBtb3JlIGNvbnZlbmllbnQgdG8g
aGF2ZSBJT1JJTkdfQ1FFX0ZfTU9SRSBzZXQsDQo+IG9uZSBwcm9ibGVtIGlzIGEgc2xpZ2h0IGNo
YW5nZSBvZiAoaW1wbGljaXQpIHNlbWFudGljcywgaS5lLg0KPiB3ZSBkb24ndCBleGVjdXRlIGxp
bmtlZCByZXF1ZXN0cyB3aGVuIGZpbGxpbmcgYSBJT1JJTkdfQ1FFX0ZfTU9SRQ0KPiBDUUUgKyBD
UUUgb3JkZXJpbmcgaW1wbGllZCBmcm9tIHRoYXQuDQo+IA0KPiBJdCdzIG1heWJlIHdvcnRoIHRv
IG5vdCByZWx5IG9uIHRoZSBsaW5rIGZhaWxpbmcgY29uY2VwdCBmb3INCj4gZGVjaWRpbmcgd2hl
dGhlciB0byBmbHVzaCBvciBub3QuDQoNCklzIHRoZSBvcmRlcmluZyBndWFyYW50ZWVkIHRoZW4g
dG8gYmUgPHNlbmQgY3FlPiwgPG5vdGlmIGNxZT4/DQpJZiBzbyBJIHdvdWxkIHB1dCB0aGUgSU9S
SU5HX0NRRV9GX01PUkUgbW9yZSBhcyBhIG5pY2UgdG8gaGF2ZSBmb3INCmNvbnNpc3RlbmN5IHdp
dGggb3RoZXIgb3BzDQoNCj4gDQo+IA0KPiA+IEFkZGl0aW9uYWxseSBpdCB3b3VsZCBuZWVkIHRv
IHByb3ZpZGUgYSB3YXkgb2YgZGlzYW1iaWd1YXRpbmcgdGhlDQo+ID4gc2VuZA0KPiA+IENRRSB3
aXRoIHRoZSBmbHVzaCBDUUUuDQo+IA0KPiBEbyB5b3UgbWVhbiBsaWtlIElPUklOR19DUUVfRl9O
T1RJRiBmcm9tIDEvMj8NCj4gDQoNCkFwb2xvZ2llcyAtIEkgbWlzc2VkIHRoYXQgDQoNCg==
