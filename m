Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1A1035E543B
	for <lists+io-uring@lfdr.de>; Wed, 21 Sep 2022 22:12:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230306AbiIUUM2 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 21 Sep 2022 16:12:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57016 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229970AbiIUUM1 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 21 Sep 2022 16:12:27 -0400
Received: from mx0a-00082601.pphosted.com (mx0b-00082601.pphosted.com [67.231.153.30])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7975FA4042
        for <io-uring@vger.kernel.org>; Wed, 21 Sep 2022 13:12:25 -0700 (PDT)
Received: from pps.filterd (m0001303.ppops.net [127.0.0.1])
        by m0001303.ppops.net (8.17.1.5/8.17.1.5) with ESMTP id 28LJRev6022221
        for <io-uring@vger.kernel.org>; Wed, 21 Sep 2022 13:12:24 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : references : in-reply-to : content-type : content-id
 : content-transfer-encoding : mime-version; s=facebook;
 bh=Gog62r2raTXQaofYUTLgx4UAxDLULWQ93TFe/B/QzUw=;
 b=JBEHBbcxZBs9jIEiTSd26WIUfrHoSU+txnpf/xmvLC8UGia01y24LVTj5+3OXkS+PkTT
 7u8EnjsDbjNReIH5D8MM4FnfW9KhfBO+1oiVRJK2HKndU+wEO17zxEQ6B76cZK+rVF2W
 nFSnwq7AZywTjzm1EyQk/6kS2mQJUFNjvYw= 
Received: from nam10-bn7-obe.outbound.protection.outlook.com (mail-bn7nam10lp2105.outbound.protection.outlook.com [104.47.70.105])
        by m0001303.ppops.net (PPS) with ESMTPS id 3jqvjuwg5a-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <io-uring@vger.kernel.org>; Wed, 21 Sep 2022 13:12:24 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=HUjfaTXqzIpiO5iE8FrgYEiW03+5sL1Is2f5DwRDV5a+xgU8ZyZ9kc4Ib3oURfF0J1T7UJe/s/74oKqgniZRykT5Sw4mU8sVGylsWK89cG51DGRysenad2DmyY+xXtH9KCNtMFCB78NHwMGTAwwRR7nB26Zc2ET0zbUfjmoMfTDFdTvhgzqOuBz2JUJzZRqOeZ7ZenZngTEy1YtmWVKbRsR11VUU8BxlQD/4v0Iv7BKWqzERgFiyeKjRsLJNdeSRDYsoBeh7cPgoe31+5+518vu54yseAaQJisHHFfsP6VD71rCmeU3V4qJl2hQ52lTev9zv/YWpmAlbuV481y4Y8Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Gog62r2raTXQaofYUTLgx4UAxDLULWQ93TFe/B/QzUw=;
 b=oDCm7r/OqHBuc/Pbd7y6Aop60I+qMUdFxXkU1VvI/jQLiG3ck0wfnBLNqdY0GWil/IkMS+z8F9jFZAhkHWog5yhcDptSdUlIQ7o4HqRNTmpxcwGSTpKMo3c0SGCVxWoR/FbstdHWndIqG7my3xi+2qJgkj8S0+joIWk+xvv+cBLToYuikExnX5AmRdIb2KtUEhytOYUlnqhxEMUif+sHm2++chz2ZWCaifGY2tfy1Q5lNFro7WDVeXz3qyVEzHTm5bkURmjroPrrtJtZLMQoTYZ+vHiy1yldB/X3F6dmSZxJdxh/o+Fiamsk0pdFzbRcAV8kq5io1kLm7WKf6Ww5uA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
Received: from SA1PR15MB4854.namprd15.prod.outlook.com (2603:10b6:806:1e1::19)
 by CY4PR15MB1223.namprd15.prod.outlook.com (2603:10b6:903:10a::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5654.16; Wed, 21 Sep
 2022 20:12:22 +0000
Received: from SA1PR15MB4854.namprd15.prod.outlook.com
 ([fe80::411e:21ef:d04f:9c68]) by SA1PR15MB4854.namprd15.prod.outlook.com
 ([fe80::411e:21ef:d04f:9c68%8]) with mapi id 15.20.5654.017; Wed, 21 Sep 2022
 20:12:22 +0000
From:   Dylan Yudaken <dylany@fb.com>
To:     "axboe@kernel.dk" <axboe@kernel.dk>,
        "io-uring@vger.kernel.org" <io-uring@vger.kernel.org>
CC:     Stefan Roesch <shr@fb.com>
Subject: Re: [PATCH for-next] io_uring: ensure local task_work marks task as
 running
Thread-Topic: [PATCH for-next] io_uring: ensure local task_work marks task as
 running
Thread-Index: AQHYze8Asm6A2pnNJE6Bk3katYH+tq3qUQoA
Date:   Wed, 21 Sep 2022 20:12:21 +0000
Message-ID: <7122df71330d01191fc5d8e211e4f3d15fd32cba.camel@fb.com>
References: <5e86f644-2076-1a59-cc2a-6a9f2b927afc@kernel.dk>
In-Reply-To: <5e86f644-2076-1a59-cc2a-6a9f2b927afc@kernel.dk>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: SA1PR15MB4854:EE_|CY4PR15MB1223:EE_
x-ms-office365-filtering-correlation-id: 9108d181-d787-4496-7653-08da9c0d97c7
x-fb-source: Internal
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 4DOVpp158DfZwYMtYimh/u1NYcCrT0he+zNvCW62izoPL+Ej8vE6S+TsHLcGk6ib7RZ7hYkE4OTiDBr9CmgMr6KtUnP1IDCSdtuOFdA+OUFERBFCufqswg8tW90+oElCGjlSmv7obn/ECIl78lwc/6D/9f/qz7muNMuvaq+Is6sc7qy7ItoF1NCJUNaSCqh07fIz9+MjWKAeSaZTJTTno6+pdvB2AIEgOoXazlGbJKa/iva4rFlGB3CqDWXjPaYS+Lq21MkkOndB5FpeRrH2yWoxC2p5onIaIISHEUCmHeRIbie2jf+pAbRNQ8dpMfCNW5ai4HdVLzo6X7r4zOzSm9jC7cWKXWI2/miA/yvAHN3Rq+DfWsX0zA2OLnLc9qjKpAQVc+OGx62iZihkxtTVS83dJkg2DFZFv15MrR/1XvuZdMLQP9JBXCv7ouIeR4faeukBTJVcKgpJYnViIBQRHJbwtScu1YvDcGCO2z80UuFOArG6LdSSBctd/42Fl5WSe+pXU4AM7d6eLwT/b2vsG6gTEcPbXdcpOjtAIOH/woWIR317H4HpXV58Mrc1qVhqScMgRF9A1PIxlZQUe7P5+skJlQXNkkRgLTuKC3ZWE6puBHz0WV3FE8c6Yrcvq8lm+oq80qfcif6EJuZiKMAB2K22402o8IlufWNIhaxj4J0AnR6dV/CwB0CDTvZuo6YC/D5CMCB8V3tkNVVlCS0te/SB1hpzc2DtgrKHi9TbJAuT0lw9BDV/8Ooh1HGWIxO9Pt8pbDpc2AveiGoyu/MqyQ==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR15MB4854.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(376002)(39860400002)(136003)(366004)(396003)(346002)(451199015)(83380400001)(38100700002)(86362001)(2906002)(36756003)(122000001)(66476007)(76116006)(91956017)(110136005)(478600001)(66446008)(66556008)(38070700005)(64756008)(4326008)(66946007)(8676002)(45080400002)(41300700001)(2616005)(71200400001)(8936002)(186003)(6506007)(316002)(6512007)(5660300002)(6486002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?ZWZtZ2dIM2tzaUxyMXYrRFk0c0R0bGxad0JCdERSN3Axc3lDdUZGUWo5M0RW?=
 =?utf-8?B?Y0FFM2V0VDZIU1JqUkM1TFNTVDNzV2txam5ZSjVMRkNxMDJoL2dBS3FnT2VW?=
 =?utf-8?B?U1AxSDFDOE1nQm5yem9wcGxVT3d6TWxHT1hrTDg3RWY1VEtCcmRpdkdUbE1r?=
 =?utf-8?B?eXExVE0zc0U1NHk5U2xETS9tVVRZYWRyT2dNK1lDTHpoV0t2ZjU2WE1TQUl0?=
 =?utf-8?B?YUlERGhWV2g2V1RqaEcrRXIrS1dhRGx6ZG1QRzhzaWwyVy9CUGYvY1I1c040?=
 =?utf-8?B?VFhxQjAzdi8xWmpZOUJFRjMrenE0R2tmaHdHWWtuaEpCYkZFY3ZoaEhSbDlQ?=
 =?utf-8?B?RzY2d05ybGFSTy8wWDFGN0xyRWRSS1RqeUN1WHd6c05MenBUcDQwUDUwUFJn?=
 =?utf-8?B?bG5xQjRURjQrczNyL0dPNmVPM1NxNU9RekxVYzdNVGd5WWp1YjhQZ3ljRmJP?=
 =?utf-8?B?Mkk5Y2YxRFhkNmpoZmcyelRaRDljbUM0ck5RNlUxZzV1TUJ3d0FhS0JYVGcw?=
 =?utf-8?B?QjNIMHlWUmF0clpyTmRWeXYyemFBakhmbjZWQTIyVnNva09xaVRsbzFyRWFL?=
 =?utf-8?B?TllkbXpwcFJIbHNQcGhQSU53ZExUU0IvMFhVby9iV3pIU3B5WENXejZoa3ZK?=
 =?utf-8?B?TDJCNGI4a2dLY0xJeVBMWkN1U1JOVy93VG4xeVlnNWNyVlEybWw5K05DRmxt?=
 =?utf-8?B?eFhsaW9CbEUrUzIrdFZvNW9qMFBmaU9nY29pZDZxSDF2c28zSXRQemFBTnVu?=
 =?utf-8?B?QXRpK3lHTGU4TUlEa1YwdWFSMk5OeENKODFHTnN0anZxcEpyYXY3eG9vbHVK?=
 =?utf-8?B?czN6UXdvdkNpSDNpK0s3K0RuaFVrNzAvRUsxdDkrcGJnZGxjTjM2YUZSMVFi?=
 =?utf-8?B?RWRKbjdaVHNhM2o4RVZrR0RmMElqK0owTkZWcm5kcnZXanpuajF4VzRic1pR?=
 =?utf-8?B?emFPeVhWUkZGamhwaUg3bkUrKzN3Z2UrY1ZHWTJJUDRZYkhzdExTZzVHMjRI?=
 =?utf-8?B?Y1E4L2hTUG1NYmpLc2s4ZzhwN0ZyYXlhUHRwV3FBUThqeHR3d1grdWxXTVRn?=
 =?utf-8?B?VlJJYzhFUzVSVzF1Y2docXMwbzBsVTRsKzJKRzBkY0h3N25Ia0h0VHZ4a2Rx?=
 =?utf-8?B?WStxUDU5K2J6VDNPemJnS1lDY3BHTS9zUWtmenpoTzFyWEpIa1FjRWZ3Z2hD?=
 =?utf-8?B?WE4xaWMxK2lOd3hkNmtxZEEwVWYwQTVwNTBvZ21NWFZwci80N2VlbDlvNEJN?=
 =?utf-8?B?TGM4aDR3dDNMRnl0R1BLS2VsZU0vSER6OG9BK1FMU0hmQ3hjdlRrZjFTbmtQ?=
 =?utf-8?B?RkVzTTMrWXVhMXpxMHVsNUljbVpEV3RyaXRITTNwSjRjc1FuaDY2aElLcXln?=
 =?utf-8?B?NnJ6YmppcG5iaUYzdUFPNEg1K3JVL0M1OHArVXplM1pZWXpYbXo0QjU1Kzlq?=
 =?utf-8?B?WnMyK1RSWUpQYlJYRGZ1WXo3bkwrcDF2L0FrM2xldjAzYXJ4ZmdmTGxRNzBM?=
 =?utf-8?B?T3I1ODlNQWpySm9seXZPSVFiazNKZWlweU83SUt6Wnp5Vmg0U2Z3bmlFK25z?=
 =?utf-8?B?QWFHUlN2Q2QrK3NON0Z3MG9VTjdzWFhFalRaeVZycjMzN3lmVWFiWUVCekJE?=
 =?utf-8?B?TkpsbUlyWDJsVUw4K2F1NTNnUkZxVmY1OThUbjFHS3VqQjR3cXd6eDNVN2Ez?=
 =?utf-8?B?SDBPVlp1TWlESUdKT0FmdW1VVkhDUlFJM3FCZ3JTajdWMXladmF2UzFZbGlL?=
 =?utf-8?B?ekZmeTA4ak81dFEzMTZJd3gweUs1ei82VkNGSUlqV1JIajl4UE9CRnVCdHZI?=
 =?utf-8?B?MTJqSHpPUGVsaFhhUjJsbUZNVWdrdVNBK2Q0M2lqeUM2djF2WVlscGcvYmZC?=
 =?utf-8?B?T2V3bUU2OEg2dHQ2WWczZm5IemdvSThtZEZubi9MbUt4emVuRHNhenpvcTd5?=
 =?utf-8?B?MVlGTjdMb0dMRHJ4RjEzNmQvNE9qdzhuVGVxNlkxbkZ1VU1zVkdUVHNQZGwy?=
 =?utf-8?B?bmNlV1RWRm5YV09SdDBzcUtwK21DWnpFTS9wTGhqN01PQTVFV1V3N00xb2hq?=
 =?utf-8?B?Tm1BbEJXczZNUmRVQ1E3RnU4SGJieG1jeklXQ25JM2s0djNOMWQwRGFMVnN0?=
 =?utf-8?B?R2E1eVJqcWFmUElwZmVPOEsrdXA1UWVHUDNnM1JxYXI3YmhnSk5DMUJMci9k?=
 =?utf-8?B?MVE9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <B30783BAAD4D3148A1440DAFA6DB3A24@namprd15.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: fb.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SA1PR15MB4854.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9108d181-d787-4496-7653-08da9c0d97c7
X-MS-Exchange-CrossTenant-originalarrivaltime: 21 Sep 2022 20:12:22.0817
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: cTNRJIVXTr18TBuZ3+/hLAuX/8ZKtSUh3HrGPvSf9g8nW5fijGVXA7K0KvrdiVHg
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY4PR15MB1223
X-Proofpoint-ORIG-GUID: kJcDrj4T33RUmnFNdKljzySAtTvElOPZ
X-Proofpoint-GUID: kJcDrj4T33RUmnFNdKljzySAtTvElOPZ
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.895,Hydra:6.0.528,FMLib:17.11.122.1
 definitions=2022-09-21_11,2022-09-20_02,2022-06-22_01
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

T24gV2VkLCAyMDIyLTA5LTIxIGF0IDEzOjE4IC0wNjAwLCBKZW5zIEF4Ym9lIHdyb3RlOg0KPiBp
b191cmluZyB3aWxsIHJ1biB0YXNrX3dvcmsgZnJvbSBjb250ZXh0cyB0aGF0IGhhdmUgYmVlbiBw
cmVwYXJlZCBmb3INCj4gd2FpdGluZywgYW5kIGluIGRvaW5nIHNvIGl0J2xsIGltcGxpY2l0bHkg
c2V0IHRoZSB0YXNrIHJ1bm5pbmcgYWdhaW4NCj4gdG8gYXZvaWQgaXNzdWVzIHdpdGggYmxvY2tp
bmcgY29uZGl0aW9ucy4gVGhlIG5ldyBkZWZlcnJlZCBsb2NhbA0KPiB0YXNrX3dvcmsgZG9lc24n
dCBkbyB0aGF0LCB3aGljaCBjYW4gcmVzdWx0IGluIHNwZXdzIG9uIHRoaXMgYmVpbmcNCj4gYW4g
aW52YWxpZCBjb25kaXRpb246DQo+IA0KPiDigKjigKhbwqAgMTEyLjkxNzU3Nl0gZG8gbm90IGNh
bGwgYmxvY2tpbmcgb3BzIHdoZW4gIVRBU0tfUlVOTklORzsgc3RhdGU9MQ0KPiBzZXQgYXQgWzww
MDAwMDAwMGFkNjRhZjY0Pl0gcHJlcGFyZV90b193YWl0X2V4Y2x1c2l2ZSsweDNmLzB4ZDANCj4g
W8KgIDExMi45ODMwODhdIFdBUk5JTkc6IENQVTogMSBQSUQ6IDE5MCBhdCBrZXJuZWwvc2NoZWQv
Y29yZS5jOjk4MTkNCj4gX19taWdodF9zbGVlcCsweDVhLzB4NjANCj4gW8KgIDExMi45ODcyNDBd
IE1vZHVsZXMgbGlua2VkIGluOg0KPiBbwqAgMTEyLjk5MDUwNF0gQ1BVOiAxIFBJRDogMTkwIENv
bW06IGlvX3VyaW5nIE5vdCB0YWludGVkIDYuMC4wLXJjNisNCj4gIzE2MTcNCj4gW8KgIDExMy4w
NTMxMzZdIEhhcmR3YXJlIG5hbWU6IFFFTVUgU3RhbmRhcmQgUEMgKGk0NDBGWCArIFBJSVgsIDE5
OTYpLA0KPiBCSU9TIHJlbC0xLjE1LjAtMC1nMmRkNGI5YjNmODQwLXByZWJ1aWx0LnFlbXUub3Jn
IDA0LzAxLzIwMTQNCj4gW8KgIDExMy4xMzM2NTBdIFJJUDogMDAxMDpfX21pZ2h0X3NsZWVwKzB4
NWEvMHg2MA0KPiBbwqAgMTEzLjEzNjUwN10gQ29kZTogZWUgNDggODkgZGYgNWIgMzEgZDIgNWQg
ZTkgMzMgZmYgZmYgZmYgNDggOGIgOTANCj4gMzAgMGIgMDAgMDAgNDggYzcgYzcgOTAgZGUgNDUg
ODIgYzYgMDUgMjAgOGIgNzkgMDEgMDEgNDggODkgZDEgZTggM2ENCj4gNDkgNzcgMDAgPDBmPiAw
YiBlYiBkMSA2NiA5MCAwZiAxZiA0NCAwMCAwMCA5YyA1OCBmNiBjNCAwMiA3NCAzNSA2NQ0KPiA4
YiAwNSBlZA0KPiBbwqAgMTEzLjIyMzk0MF0gUlNQOiAwMDE4OmZmZmZjOTAwMDA1MzdjYTAgRUZM
QUdTOiAwMDAxMDI4Ng0KPiBbwqAgMTEzLjIzMjkwM10gUkFYOiAwMDAwMDAwMDAwMDAwMDAwIFJC
WDogZmZmZmZmZmY4MjQ2NzgyYyBSQ1g6DQo+IGZmZmZmZmZmODI3MGJjYzgNCj4gSU9QUz0xMzMu
MTVLLCBCVz01MjBNaUIvcywgSU9TL2NhbGw9MzIvMzENCj4gW8KgIDExMy4zNTM0NTddIFJEWDog
ZmZmZmM5MDAwMDUzN2I1MCBSU0k6IDAwMDAwMDAwZmZmZmRmZmYgUkRJOg0KPiAwMDAwMDAwMDAw
MDAwMDAxDQo+IFvCoCAxMTMuMzU4OTcwXSBSQlA6IDAwMDAwMDAwMDAwMDAzYmMgUjA4OiAwMDAw
MDAwMDAwMDAwMDAwIFIwOToNCj4gYzAwMDAwMDBmZmZmZGZmZg0KPiBbwqAgMTEzLjM2MTc0Nl0g
UjEwOiAwMDAwMDAwMDAwMDAwMDAxIFIxMTogZmZmZmM5MDAwMDUzN2I0OCBSMTI6DQo+IGZmZmY4
ODgxMDNmOTcyODANCj4gW8KgIDExMy40MjQwMzhdIFIxMzogMDAwMDAwMDAwMDAwMDAwMCBSMTQ6
IDAwMDAwMDAwMDAwMDAwMDEgUjE1Og0KPiAwMDAwMDAwMDAwMDAwMDAxDQo+IFvCoCAxMTMuNDI4
MDA5XSBGUzrCoCAwMDAwN2Y2N2FlN2ZjNzAwKDAwMDApIEdTOmZmZmY4ODg0MmZjODAwMDAoMDAw
MCkNCj4ga25sR1M6MDAwMDAwMDAwMDAwMDAwMA0KPiBbwqAgMTEzLjQzMjc5NF0gQ1M6wqAgMDAx
MCBEUzogMDAwMCBFUzogMDAwMCBDUjA6IDAwMDAwMDAwODAwNTAwMzMNCj4gW8KgIDExMy41MDMx
ODZdIENSMjogMDAwMDdmNjdiOGI5YjNiMCBDUjM6IDAwMDAwMDAxMDJiOWIwMDUgQ1I0Og0KPiAw
MDAwMDAwMDAwNzcwZWUwDQo+IFvCoCAxMTMuNTA3MjkxXSBEUjA6IDAwMDAwMDAwMDAwMDAwMDAg
RFIxOiAwMDAwMDAwMDAwMDAwMDAwIERSMjoNCj4gMDAwMDAwMDAwMDAwMDAwMA0KPiBbwqAgMTEz
LjUxMjY2OV0gRFIzOiAwMDAwMDAwMDAwMDAwMDAwIERSNjogMDAwMDAwMDBmZmZlMGZmMCBEUjc6
DQo+IDAwMDAwMDAwMDAwMDA0MDANCj4gW8KgIDExMy41NzQzNzRdIFBLUlU6IDU1NTU1NTU0DQo+
IFvCoCAxMTMuNTc2ODAwXSBDYWxsIFRyYWNlOg0KPiBbwqAgMTEzLjU3ODMyNV3CoCA8VEFTSz4N
Cj4gW8KgIDExMy41Nzk3OTldwqAgc2V0X3BhZ2VfZGlydHlfbG9jaysweDFiLzB4OTANCj4gW8Kg
IDExMy41ODI0MTFdwqAgX19iaW9fcmVsZWFzZV9wYWdlcysweDE0MS8weDE2MA0KPiBbwqAgMTEz
LjY3MzA3OF3CoCA/IHNldF9uZXh0X2VudGl0eSsweGQ3LzB4MTkwDQo+IFvCoCAxMTMuNjc1NjMy
XcKgIGJsa19ycV91bm1hcF91c2VyKzB4YWEvMHgyMTANCj4gW8KgIDExMy42NzgzOThdwqAgPyB0
aW1lcnF1ZXVlX2RlbCsweDJhLzB4NDANCj4gW8KgIDExMy42Nzk1NzhdwqAgbnZtZV91cmluZ190
YXNrX2NiKzB4OTQvMHhiMA0KPiBbwqAgMTEzLjY4MzAyNV3CoCBfX2lvX3J1bl9sb2NhbF93b3Jr
KzB4OGEvMHgxNTANCj4gW8KgIDExMy43NDM3MjRdwqAgPyBpb19jcXJpbmdfd2FpdCsweDMzZC8w
eDUwMA0KPiBbwqAgMTEzLjc0NjA5MV3CoCBpb19ydW5fbG9jYWxfd29yay5wYXJ0Ljc2KzB4MmUv
MHg2MA0KPiBbwqAgMTEzLjc1MDA5MV3CoCBpb19jcXJpbmdfd2FpdCsweDJlNy8weDUwMA0KPiBb
wqAgMTEzLjc1MjM5NV3CoCA/DQo+IHRyYWNlX2V2ZW50X3Jhd19ldmVudF9pb191cmluZ19yZXFf
ZmFpbGVkKzB4MTgwLzB4MTgwDQo+IFvCoCAxMTMuODIzNTMzXcKgIF9feDY0X3N5c19pb191cmlu
Z19lbnRlcisweDEzMS8weDNjMA0KPiBbwqAgMTEzLjgyNzM4Ml3CoCA/IHN3aXRjaF9mcHVfcmV0
dXJuKzB4NDkvMHhjMA0KPiBbwqAgMTEzLjgzMDc1M13CoCBkb19zeXNjYWxsXzY0KzB4MzQvMHg4
MA0KPiBbwqAgMTEzLjgzMjYyMF3CoCBlbnRyeV9TWVNDQUxMXzY0X2FmdGVyX2h3ZnJhbWUrMHg1
ZS8weGM4DQo+IA0KPiBFbnN1cmUgdGhhdCB3ZSBtYXJrIGN1cnJlbnQgYXMgVEFTS19SVU5OSU5H
IGZvciBkZWZlcnJlZCB0YXNrX3dvcmsNCj4gYXMgd2VsbC4NCj4gDQo+IEZpeGVzOiBjMGUwZDZi
YTI1ZjEgKCJpb191cmluZzogYWRkIElPUklOR19TRVRVUF9ERUZFUl9UQVNLUlVOIikNCj4gUmVw
b3J0ZWQtYnk6IFN0ZWZhbiBSb2VzY2ggPHNockBmYi5jb20+DQo+IFNpZ25lZC1vZmYtYnk6IEpl
bnMgQXhib2UgPGF4Ym9lQGtlcm5lbC5kaz4NCj4gDQo+IC0tLQ0KPiANCj4gZGlmZiAtLWdpdCBh
L2lvX3VyaW5nL2lvX3VyaW5nLmMgYi9pb191cmluZy9pb191cmluZy5jDQo+IGluZGV4IDM4NzVl
YTg5N2NkZi4uZjM1OWUyNGI0NmMzIDEwMDY0NA0KPiAtLS0gYS9pb191cmluZy9pb191cmluZy5j
DQo+ICsrKyBiL2lvX3VyaW5nL2lvX3VyaW5nLmMNCj4gQEAgLTEyMTUsNiArMTIxNSw3IEBAIGlu
dCBpb19ydW5fbG9jYWxfd29yayhzdHJ1Y3QgaW9fcmluZ19jdHggKmN0eCkNCj4gwqDCoMKgwqDC
oMKgwqDCoGlmIChsbGlzdF9lbXB0eSgmY3R4LT53b3JrX2xsaXN0KSkNCj4gwqDCoMKgwqDCoMKg
wqDCoMKgwqDCoMKgwqDCoMKgwqByZXR1cm4gMDsNCj4gwqANCj4gK8KgwqDCoMKgwqDCoMKgX19z
ZXRfY3VycmVudF9zdGF0ZShUQVNLX1JVTk5JTkcpOw0KPiDCoMKgwqDCoMKgwqDCoMKgbG9ja2Vk
ID0gbXV0ZXhfdHJ5bG9jaygmY3R4LT51cmluZ19sb2NrKTsNCj4gwqDCoMKgwqDCoMKgwqDCoHJl
dCA9IF9faW9fcnVuX2xvY2FsX3dvcmsoY3R4LCBsb2NrZWQpOw0KPiDCoMKgwqDCoMKgwqDCoMKg
aWYgKGxvY2tlZCkNCj4gDQoNCg0KUmV2aWV3ZWQtYnk6IER5bGFuIFl1ZGFrZW4gPGR5bGFueUBm
Yi5jb20+DQoNCg==
