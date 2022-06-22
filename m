Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CA31755486D
	for <lists+io-uring@lfdr.de>; Wed, 22 Jun 2022 14:15:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236241AbiFVJbw (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 22 Jun 2022 05:31:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32862 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1351641AbiFVJbt (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 22 Jun 2022 05:31:49 -0400
Received: from mx0b-00082601.pphosted.com (mx0b-00082601.pphosted.com [67.231.153.30])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 29ADC3980F
        for <io-uring@vger.kernel.org>; Wed, 22 Jun 2022 02:31:49 -0700 (PDT)
Received: from pps.filterd (m0109331.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 25LN9Jou016198
        for <io-uring@vger.kernel.org>; Wed, 22 Jun 2022 02:31:48 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : references : in-reply-to : content-type : content-id
 : content-transfer-encoding : mime-version; s=facebook;
 bh=QWyBEr5pSXBDDSDxOm8BxObw8L1R6sknhfrz27/Bpsw=;
 b=S+C5b/Mr57dEINocpa4pXlvwWztjpu5Io+R9dTqfKhsvOdYddEmS32xP7VUKibIN1SIr
 B0//WP4Jv/9QIWV8IEE/HTC4Bc7lrijXYxIEaQ/BkPqmNha7murj9Yj5/OENSDejWHQ9
 3CDHKByNG0ejlml8TUO+Cj7yA6za8Rmly4I= 
Received: from nam12-bn8-obe.outbound.protection.outlook.com (mail-bn8nam12lp2171.outbound.protection.outlook.com [104.47.55.171])
        by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 3gukcgc56u-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <io-uring@vger.kernel.org>; Wed, 22 Jun 2022 02:31:48 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=UXP71+InuZnwAjW3WpeQCPxya6KDReOpMdF8I9/EWM8/6K1UtbAkxCQag03l/e3q8z03gB1KEMPl4XQey/OY8YV3nuxEbv6t0q3bmuU0uTq2UDnjEv5CWgB3KlfdvNPwqpcxs+Uj9qzFbzc/+dISlQ6bvwZm9g1I3NpIjO5oNphFUI8ZV9+iTUIC0oh/fB4h9EpdNJ3Ef0fDEcxlqJTi+XidGjM+uqY4TRa4tcULAM2jshRGeUWPa2a4I74KaSUSufEmx5VRTuCEP6SXHLP9arzXaBxnL594Vd9Z3R/ubiZ9JkRLKra6DGdnIBZDViYmMLreZm2jyzYwjkScLWAJxQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=QWyBEr5pSXBDDSDxOm8BxObw8L1R6sknhfrz27/Bpsw=;
 b=eQNciBClnYbKgUJ1eBTSpSTybljxHlDOgZfz0rJQocMjdx+jebqc+ylHnKh6YavQ39mGPr4H2Ih+oCqs7/aPknpFG4cAiZRGia7d8SNnEi1bPQ95BLw5rBnAGNhXUNi6Yvsmald7rzp+B1WvvuBGuEcm4MIe6p+Y59+P00eeHija72o281Nn+lNq5UGy7pMbkmqfx2h0kVJYYtBvKL0BV4XtSI5NNZcIzxxcGgo+QjNSGtcEGLNNMvEWp5yGH+XPW3Rc1l77/pkKlz0iIdySrIlzUcKVsrMRIS1ryGyyQvc9X15yLopYsege3JDTmD0f4NuJTHBf/AwlrrjhzfPG8w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
Received: from SA1PR15MB4854.namprd15.prod.outlook.com (2603:10b6:806:1e1::19)
 by DM6PR15MB2298.namprd15.prod.outlook.com (2603:10b6:5:88::28) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5353.22; Wed, 22 Jun
 2022 09:31:45 +0000
Received: from SA1PR15MB4854.namprd15.prod.outlook.com
 ([fe80::f0a8:296c:754f:2369]) by SA1PR15MB4854.namprd15.prod.outlook.com
 ([fe80::f0a8:296c:754f:2369%7]) with mapi id 15.20.5353.022; Wed, 22 Jun 2022
 09:31:45 +0000
From:   Dylan Yudaken <dylany@fb.com>
To:     "axboe@kernel.dk" <axboe@kernel.dk>,
        "hao.xu@linux.dev" <hao.xu@linux.dev>,
        "asml.silence@gmail.com" <asml.silence@gmail.com>,
        "io-uring@vger.kernel.org" <io-uring@vger.kernel.org>
CC:     Kernel Team <Kernel-team@fb.com>
Subject: Re: [PATCH RFC for-next 0/8] io_uring: tw contention improvments
Thread-Topic: [PATCH RFC for-next 0/8] io_uring: tw contention improvments
Thread-Index: AQHYhMF7oWPfkzp4hU2ITxG7G8J9C61ZURGAgAAfZACAAAisgIABsyEA
Date:   Wed, 22 Jun 2022 09:31:45 +0000
Message-ID: <02e7f2adc191cd207eb17dd84efa10f86d965200.camel@fb.com>
References: <20220620161901.1181971-1-dylany@fb.com>
         <15e36a76-65d5-2acb-8cb7-3952d9d8f7d1@linux.dev>
         <f8c8e52996aaa8fb8c72ae46f0e87e733a9053aa.camel@fb.com>
         <1c29ad13-cc42-8bc5-0f12-3413054a4faf@linux.dev>
In-Reply-To: <1c29ad13-cc42-8bc5-0f12-3413054a4faf@linux.dev>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 306bb290-4029-4b49-5f8f-08da54320622
x-ms-traffictypediagnostic: DM6PR15MB2298:EE_
x-microsoft-antispam-prvs: <DM6PR15MB229884347DA4E0FDA77B6867B6B29@DM6PR15MB2298.namprd15.prod.outlook.com>
x-fb-source: Internal
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: MPXA385hRLHv/mcssyVZauhCn01+SPR1YPPtOnu8/M83G46cguOgwJv6SQEBwVw0ZwvG0dY9IP1RtUIVnxXxw1ejlEnKE5xQP1ltc5ir56dQYg5tatccogXx62l2RCwbEFdz8QpAoCCH/k0Ref3KTUJ3up1+nraQc1IcG+Yx7rMuPKvn2NvFoR0XmojTKc2DZXZBRQkHahjjY2aAmZ5Es8NPi86K5wKLcp0/FgCFOkT9hhj9WoJbyTRVzAhiTj3nkqdepErjsvSL82teB80aefMkPzHpJiTVEsvZFcZNWjj+q2Mz62nv9DIJYU2Rn97WvRYRENY25PBv+HfmtF/GawN03cLCEULTWzdg6EU5iALwhobrhs9e3nGG7S3ZwgQmGOrPekOcWXYPaCKkCnQsDxFEbrRgQ4/nrrLH3WWpmMz2SbAxsW7JCIT9SJW7Oz0Tsm8fA9IZT4wXZ3aJ0hXhY4aCQRze8fij2Ptp+0XJc15ODqUduhQbXYZtxmgBEv7xUmjqWKYER5YW3RNY8lqFGmyuSXpnWIIhHrhK0FAb0XbYIs5RqElgqKP43pAnCguDPOFSUfjUs9TXg9sc8NZTeYavGgFUnBxtTy/bGzZWr617t8UxR7QDfTmp3QpfBhAqvFQqlOC7wOu2dg8O6EG1fuZcZrH+XM0jGP1L1mC0lK5u3xfUsINboyrEqoWtFWV4p91gFkUahcAJrE6Wn9NW1RErx0hqYsTJ/mzW1bgRc6v2Y8PKEXOFrro8vxK5jBMKFkcb9j97ej3Cb32/pDf+iIdRmy7oUg8huhtreyfs57Q=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR15MB4854.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(366004)(396003)(376002)(346002)(39860400002)(136003)(71200400001)(5660300002)(66476007)(478600001)(2616005)(110136005)(66946007)(66446008)(66556008)(36756003)(8676002)(64756008)(6486002)(76116006)(316002)(186003)(53546011)(4326008)(83380400001)(966005)(6506007)(91956017)(6512007)(122000001)(2906002)(41300700001)(86362001)(38100700002)(8936002)(38070700005);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?akJxcVEwSi9IWUdBTzFiQmZZc2kvYjFlb1UwNU9BMjkzSUU4VTZ6VTNXZ1Ru?=
 =?utf-8?B?VmZYMmhJWDBhRWZKM2thTUJ6Sy9KNmRpdzVmbDVPeld0dytTVXVGd0phZjJD?=
 =?utf-8?B?MFRjeDVtTnc5ajZrZ0dsSTlsbGFCeGlmUHptMHlYSW5Jb05WVk9nOThmK0lT?=
 =?utf-8?B?d1AzVnRXVkI4bGwyN0VZaGYrcUUxT1NHM281V0FhdFNaZEFURDhiZ1VsSWJU?=
 =?utf-8?B?VG0rSmQ4U2RFNjd4Qlc5b1haSXVMcXpJV1ZYNXZaemNISTNxV1d1Rk5JV0dV?=
 =?utf-8?B?b0xmc1M0RUY5a1lUcGI3cGgrQlFtMmlNSEo0aFFqR204SWhONnpUOGwrVDAv?=
 =?utf-8?B?RTVPaXBTYXF2Z2dZSnZrYkk3N3Vnd1dRTWZQMG5CV2dpdk9kdE1adnR6cExV?=
 =?utf-8?B?OG9YVCthdUZYUWo3eDEvbVRnbmx2dC91WEJSUjI0UVBCN3BpbzhnMDZPb1p5?=
 =?utf-8?B?NnlsZjVwNXUrdmoxdzY5SjVsWk9SS3c4bVR6b21BSWVaaUk3N1hFQnZtQVIz?=
 =?utf-8?B?dVJuRzdYSDJoMGNLRHl6ZEMyY3VDcUtwZmpxUFlLL1dUV3dtdC9icnVJSXdy?=
 =?utf-8?B?d1NqcHFoL2pxenB3MUZTcDVCSzRqQmRERk5ZMHdPbXRsMlRjeklIM2dZTFdp?=
 =?utf-8?B?QW5FRHdrSkNrbzNBa2Y5dDE0eXZYRFZsSmpXaUlmUzNmS2NYQ2E2QTRubU1z?=
 =?utf-8?B?R2MwN2t5VkpCcjFDbFdrWS9lbmt6RFNjRGMxblRNN0NxUTJ2alFpUVhacnE1?=
 =?utf-8?B?NUtDRjgrK1lwOTlDSlBFSUpoL3h3bUNzUlVybjdSdG82TmFaZ2pjejFNblNv?=
 =?utf-8?B?cHFpaU5EL3hxbW9iTUFlTUVMQnloZExNZlFRdDZIaEd5Zko0VWRUYUhOR093?=
 =?utf-8?B?NnV4d2YyOXBPcTV4bWRUZ04wTmdVYVVLMUdvRGZMOUlERTVaYWlDKzZRZ21l?=
 =?utf-8?B?OCtGL2NzeUx0VnRqVDR3RXJ4YVBDMFVLblNtVml2YzRmQmJNcExuVTlqVzFt?=
 =?utf-8?B?SzR1Snk3ditkUjc2U0xGcjFyMk84RkJKMXBOcDEzbkIzTFBCVVFLREM2Y1U0?=
 =?utf-8?B?cSsxajlxVkxrR0grRlE3aUNKOVlFRVE3TlR0TkY0VFVmMGwxK3RuVUxUaVJL?=
 =?utf-8?B?YTNrUnhKVXNQMDIyUjNiTlZzK3RtZ24vMnVqZXhMV0hvVm8wY3VqS05tTU10?=
 =?utf-8?B?bHBZQjNseVkxYUM0QWpUR2VaSVcwUktWSW5nZ2tIRFlydWJDY28vSVdrcFN1?=
 =?utf-8?B?bE9DWkwrQldFNTFXOGYzY3ZWbmV5MTdzNFJhOEVWUld5QTZnNHZURGZkRERY?=
 =?utf-8?B?TlNDV2xDNHZ2ZEdGVkdrdERUZ25jRktkbkh3cmh0cXU0b0cvL0duU0R2Umgz?=
 =?utf-8?B?TUFwdGF4SjBLckNtRTVQVmczWC9ybWJONlFrQlZSQldJQUhWdEs5N0o0Vzhh?=
 =?utf-8?B?UFAxZlNVN3hIS2RpM09ocExuYnpmTEMwV1NFSklLTjcycnBiQ0tka0U1WDhI?=
 =?utf-8?B?NUgrc003Rk9sVllGNHEyWWVEVVpGWW1TTmpnTDdVREZlZmNOSmVYR00rT3Js?=
 =?utf-8?B?N0NNTkg1V25JT3hXdUplVGhmZmhlemNwMUM5bTVFQUsySjFxaGIwZUVwdTBW?=
 =?utf-8?B?UWN1YnFGdVF1M3EvZTBDMjdPMFQ5RkdldkJmWjZoNWlhNzFSWG9WaG1YcVl5?=
 =?utf-8?B?NkhydHpleG9aVHZ6S2lhbEhlNjZqYlIxVi9HbWlnYmg4VEl3UC9qVTlnZEFK?=
 =?utf-8?B?cU10U0pYdWVLUzdVdjI0SjFWREtBT1dmZE91bmZDV0NBMlBDQWRObGwycEdq?=
 =?utf-8?B?WDQ2T3B3eitGUE1YMHZCMmM5VVNLZ2FJb3cwQ2NuNHBEK09jV01LSHR5S1hY?=
 =?utf-8?B?LzNrUkdBTTlOeFFYVklyazFZR09WZTlSWi85T1ZmSXFrRmVaUjdqdEtvYkpW?=
 =?utf-8?B?ZUczdDVXb0lJYTZ0QUMwWWgxRzV3OXNxYmU3S3oxcko0bmoya2Rrd0Y5d0NO?=
 =?utf-8?B?WW8wUmhrbit5dzFlV3kxUUVyQXBSUkk4MXM2dURSQzlwSWwxZnF0OFFYTE43?=
 =?utf-8?B?eTN6dmdhRHg4WHdZMXFjV2cxSFUrWDBIYUd2KzVMZUpQK2NPRi9WUGd4dkV0?=
 =?utf-8?B?UmVRNmIySGgxcVhKZlJXcmtENjFQeXBFV0hxMDJqd3ZSVFJBMlRDOG1Hb0Zo?=
 =?utf-8?B?aHlGaDVOZ3ZFekdPT3pEcHA2R1F6UFBSb0l4U205VHRVeHdkUGUwelE4bmlP?=
 =?utf-8?B?Ly9yMG4zclhJR3hwN0JZTUxZakdiQ1AyTjVsUGdPS3o3VXAwSzlLM2pRbEt2?=
 =?utf-8?B?aFRwbnJiR3NWaDlWM28yUVdrcGRIcENBMy9TcUdlR1pIamV2UmpEdWFJSFpN?=
 =?utf-8?Q?+OvC7r67TZUTHDXo=3D?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <207B6D96271075418FD2B6097765D49A@namprd15.prod.outlook.com>
X-OriginatorOrg: fb.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SA1PR15MB4854.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 306bb290-4029-4b49-5f8f-08da54320622
X-MS-Exchange-CrossTenant-originalarrivaltime: 22 Jun 2022 09:31:45.4204
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: RTWBGhcYlLarmnz/ght9aVA9myxSpG0xtjoPsy+qxPCKGT/VGMf78jLQZqNOFidM
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR15MB2298
X-Proofpoint-GUID: NMaITLWZzhjb71ib0W8DAdFoWsYSM66Z
X-Proofpoint-ORIG-GUID: NMaITLWZzhjb71ib0W8DAdFoWsYSM66Z
Content-Transfer-Encoding: base64
X-Proofpoint-UnRewURL: 0 URL was un-rewritten
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.883,Hydra:6.0.517,FMLib:17.11.64.514
 definitions=2022-06-22_02,2022-06-22_01,2022-02-23_01
X-Spam-Status: No, score=-2.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

T24gVHVlLCAyMDIyLTA2LTIxIGF0IDE1OjM0ICswODAwLCBIYW8gWHUgd3JvdGU6DQo+IE9uIDYv
MjEvMjIgMTU6MDMsIER5bGFuIFl1ZGFrZW4gd3JvdGU6DQo+ID4gT24gVHVlLCAyMDIyLTA2LTIx
IGF0IDEzOjEwICswODAwLCBIYW8gWHUgd3JvdGU6DQo+ID4gPiBPbiA2LzIxLzIyIDAwOjE4LCBE
eWxhbiBZdWRha2VuIHdyb3RlOg0KPiA+ID4gPiBUYXNrIHdvcmsgY3VycmVudGx5IHVzZXMgYSBz
cGluIGxvY2sgdG8gZ3VhcmQgdGFza19saXN0IGFuZA0KPiA+ID4gPiB0YXNrX3J1bm5pbmcuIFNv
bWUgdXNlIGNhc2VzIHN1Y2ggYXMgbmV0d29ya2luZyBjYW4gdHJpZ2dlcg0KPiA+ID4gPiB0YXNr
X3dvcmtfYWRkDQo+ID4gPiA+IGZyb20gbXVsdGlwbGUgdGhyZWFkcyBhbGwgYXQgb25jZSwgd2hp
Y2ggc3VmZmVycyBmcm9tDQo+ID4gPiA+IGNvbnRlbnRpb24NCj4gPiA+ID4gaGVyZS4NCj4gPiA+
ID4gDQo+ID4gPiA+IFRoaXMgY2FuIGJlIGNoYW5nZWQgdG8gdXNlIGEgbG9ja2xlc3MgbGlzdCB3
aGljaCBzZWVtcyB0byBoYXZlDQo+ID4gPiA+IGJldHRlcg0KPiA+ID4gPiBwZXJmb3JtYW5jZS4g
UnVubmluZyB0aGUgbWljcm8gYmVuY2htYXJrIGluIFsxXSBJIHNlZSAyMCUNCj4gPiA+ID4gaW1w
cm92bWVudCBpbg0KPiA+ID4gPiBtdWx0aXRocmVhZGVkIHRhc2sgd29yayBhZGQuIEl0IHJlcXVp
cmVkIHJlbW92aW5nIHRoZSBwcmlvcml0eQ0KPiA+ID4gPiB0dw0KPiA+ID4gPiBsaXN0DQo+ID4g
PiA+IG9wdGltaXNhdGlvbiwgaG93ZXZlciBpdCBpc24ndCBjbGVhciBob3cgaW1wb3J0YW50IHRo
YXQNCj4gPiA+ID4gb3B0aW1pc2F0aW9uIGlzLg0KPiA+ID4gPiBBZGRpdGlvbmFsbHkgaXQgaGFz
IGZhaXJseSBlYXN5IHRvIGJyZWFrIHNlbWFudGljcy4NCj4gPiA+ID4gDQo+ID4gPiA+IFBhdGNo
IDEtMiByZW1vdmUgdGhlIHByaW9yaXR5IHR3IGxpc3Qgb3B0aW1pc2F0aW9uDQo+ID4gPiA+IFBh
dGNoIDMtNSBhZGQgbG9ja2xlc3MgbGlzdHMgZm9yIHRhc2sgd29yaw0KPiA+ID4gPiBQYXRjaCA2
IGZpeGVzIGEgYnVnIEkgbm90aWNlZCBpbiBpb191cmluZyBldmVudCB0cmFjaW5nDQo+ID4gPiA+
IFBhdGNoIDctOCBhZGRzIHRyYWNpbmcgZm9yIHRhc2tfd29ya19ydW4NCj4gPiA+ID4gDQo+ID4g
PiANCj4gPiA+IENvbXBhcmVkIHRvIHRoZSBzcGlubG9jayBvdmVyaGVhZCwgdGhlIHByaW8gdGFz
ayBsaXN0DQo+ID4gPiBvcHRpbWl6YXRpb24gaXMNCj4gPiA+IGRlZmluaXRlbHkgdW5pbXBvcnRh
bnQsIHNvIEkgYWdyZWUgd2l0aCByZW1vdmluZyBpdCBoZXJlLg0KPiA+ID4gUmVwbGFjZSB0aGUg
dGFzayBsaXN0IHdpdGggbGxpc3kgd2FzIHNvbWV0aGluZyBJIGNvbnNpZGVyZWQgYnV0IEkNCj4g
PiA+IGdhdmUNCj4gPiA+IGl0IHVwIHNpbmNlIGl0IGNoYW5nZXMgdGhlIGxpc3QgdG8gYSBzdGFj
ayB3aGljaCBtZWFucyB3ZSBoYXZlIHRvDQo+ID4gPiBoYW5kbGUNCj4gPiA+IHRoZSB0YXNrcyBp
biBhIHJldmVyc2Ugb3JkZXIuIFRoaXMgbWF5IGFmZmVjdCB0aGUgbGF0ZW5jeSwgZG8geW91DQo+
ID4gPiBoYXZlDQo+ID4gPiBzb21lIG51bWJlcnMgZm9yIGl0LCBsaWtlIGF2ZyBhbmQgOTklIDk1
JSBsYXQ/DQo+ID4gPiANCj4gPiANCj4gPiBEbyB5b3UgaGF2ZSBhbiBpZGVhIGZvciBob3cgdG8g
dGVzdCB0aGF0PyBJIHVzZWQgYSBtaWNyb2JlbmNobWFyaw0KPiA+IGFzDQo+ID4gd2VsbCBhcyBh
IG5ldHdvcmsgYmVuY2htYXJrIFsxXSB0byB2ZXJpZnkgdGhhdCBvdmVyYWxsIHRocm91Z2hwdXQN
Cj4gPiBpcw0KPiA+IGhpZ2hlci4gVFcgbGF0ZW5jeSBzb3VuZHMgYSBsb3QgbW9yZSBjb21wbGlj
YXRlZCB0byBtZWFzdXJlIGFzIGl0J3MNCj4gPiBkaWZmaWN1bHQgdG8gdHJpZ2dlciBhY2N1cmF0
ZWx5Lg0KPiA+IA0KPiA+IE15IGZlZWxpbmcgaXMgdGhhdCB3aXRoIHJlYXNvbmFibGUgYmF0Y2hp
bmcgKHNheSA4LTE2IGl0ZW1zKSB0aGUNCj4gPiBsYXRlbmN5IHdpbGwgYmUgbG93IGFzIFRXIGlz
IGdlbmVyYWxseSB2ZXJ5IHF1aWNrLCBidXQgaWYgeW91IGhhdmUNCj4gPiBhbg0KPiA+IGlkZWEg
Zm9yIGJlbmNobWFya2luZyBJIGNhbiB0YWtlIGEgbG9vaw0KPiA+IA0KPiA+IFsxXTogaHR0cHM6
Ly9naXRodWIuY29tL0R5bGFuWkEvbmV0YmVuY2gNCj4gDQo+IEl0IGNhbiBiZSBub3JtYWwgSU8g
cmVxdWVzdHMgSSB0aGluay4gV2UgY2FuIHRlc3QgdGhlIGxhdGVuY3kgYnkgZmlvDQo+IHdpdGgg
c21hbGwgc2l6ZSBJTyB0byBhIGZhc3QgYmxvY2sgZGV2aWNlKGxpa2UgbnZtZSkgaW4gU1FQT0xM
DQo+IG1vZGUoc2luY2UgZm9yIG5vbi1TUVBPTEwsIGl0IGRvZXNuJ3QgbWFrZSBkaWZmZXJlbmNl
KS4gVGhpcyB3YXkgd2UNCj4gY2FuDQo+IHNlZSB0aGUgaW5mbHVlbmNlIG9mIHJldmVyc2Ugb3Jk
ZXIgaGFuZGxpbmcuDQo+IA0KPiBSZWdhcmRzLA0KPiBIYW8NCg0KSSBzZWUgbGl0dGxlIGRpZmZl
cmVuY2UgbG9jYWxseSwgYnV0IHRoZXJlIGlzIHF1aXRlIGEgYmlnIHN0ZGV2IHNvIGl0J3MNCnBv
c3NpYmxlIG15IHRlc3Qgc2V0dXAgaXMgYSBiaXQgd29ua3kNCg0KbmV3Og0KICAgIGNsYXQgKG1z
ZWMpOiBtaW49MjAyNywgbWF4PTEwNTQ0LCBhdmc9NjM0Ny4xMCwgc3RkZXY9MjQ1OC4yMA0KICAg
ICBsYXQgKG5zZWMpOiBtaW49MTQ0MCwgbWF4PTE2NzE5aywgYXZnPTExOTcxNC43Miwgc3RkZXY9
MTUzNTcxLjQ5DQpvbGQ6DQogICAgY2xhdCAobXNlYyk6IG1pbj0yNzM4LCBtYXg9MTA1NTAsIGF2
Zz02NzAwLjY4LCBzdGRldj0yMjUxLjc3DQogICAgIGxhdCAobnNlYyk6IG1pbj0xMjc4LCBtYXg9
MTY2MTBrLCBhdmc9MTIxMDI1LjczLCBzdGRldj0yMTE4OTYuMTQNCg0K
