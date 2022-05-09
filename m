Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2E47C51FC33
	for <lists+io-uring@lfdr.de>; Mon,  9 May 2022 14:10:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233744AbiEIMKN (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 9 May 2022 08:10:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48082 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233707AbiEIMKM (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 9 May 2022 08:10:12 -0400
Received: from mx0a-00082601.pphosted.com (mx0a-00082601.pphosted.com [67.231.145.42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 84F171B33D6
        for <io-uring@vger.kernel.org>; Mon,  9 May 2022 05:06:19 -0700 (PDT)
Received: from pps.filterd (m0044012.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 248NkLaJ017868
        for <io-uring@vger.kernel.org>; Mon, 9 May 2022 05:06:19 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : references : in-reply-to : content-type : content-id
 : content-transfer-encoding : mime-version; s=facebook;
 bh=+XpTe+M4+2po7nFrXytr+WVYXmqVFjaSBSr+UfE0MGw=;
 b=T71R20uulWgcYnwtzK6B94dMLsNXJrL1z4mGQLLFCxwUxW23OMW/Qdd/Yty00WB1I0Ai
 TPuZWXmDV9P86T+VSkRJ4cb7kV7MoG4At7mLx4h2XO5FxEcM7Xj3+QCSOtWuUETKqetT
 GMQxzcwmpN7c2yn8FvUz2G32a5SJcNiJMYA= 
Received: from nam12-mw2-obe.outbound.protection.outlook.com (mail-mw2nam12lp2044.outbound.protection.outlook.com [104.47.66.44])
        by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 3fwpfmr26j-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <io-uring@vger.kernel.org>; Mon, 09 May 2022 05:06:19 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ID8tQaQHxBne+LWjKGU16BnMdGe0/YK6XULmqSOlWVbhkNLcT2T1dHMuJYqrwGrI8Y0BW815j51pbw95z1tIaxamx4bNjO7V+DSsTiDe6y240YoVFtoeG10sFJKCMloGQTaY8fV8+m2m50QlRzUkpPzEOKAMrxIK3TqTjI6XLOdLDwZ5ipIrGReIY8jOSYd7Zy3t0D0v+w4CBbQIu4nOMS/dQJzRha7NB3rucWmbVVMQA+c1MxwJQCYQQrky2bzJBOmc5oxOct/moJWSwnn9dh6wNpFSFeR7MSa10Z/Xt3rCre4mljadrbfCs6o5aKVPX76L9mobPRVIg+dqyTHJFQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=+XpTe+M4+2po7nFrXytr+WVYXmqVFjaSBSr+UfE0MGw=;
 b=oJSbudCi+60vKvtJYXNb5n3+HfJu8tEDbFN6CrBEMwNt0ALWqtKK9CaYCFmACw6PWXO1+t0cfZ0tzfzhW9xCXvw2G26gBmK0hmAtstofndKwBpS4FWVnCPrkXXEcmpqKD5S95rCNxfyonSffTm/jGbpv3gvMVJcJkxf6qc3JBgayru5Fp8opolYYPPBAyYWQn6YQK8r8cPw0YTM79Hc4jyYLN7zj//qQ6X2aBA4uYRNmzaLW8pDjBiU6DepDM9mbqAhIP0N9OHdoXyYMIt1gHgmAPPY2S99wvIeDgfIKIoJ/ETLNl4tpdfkvyWI7YtQ3i+qa7tfFe3bY9oacTTmFtQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
Received: from SA1PR15MB4854.namprd15.prod.outlook.com (2603:10b6:806:1e1::19)
 by BN8PR15MB3265.namprd15.prod.outlook.com (2603:10b6:408:72::25) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5227.23; Mon, 9 May
 2022 12:06:16 +0000
Received: from SA1PR15MB4854.namprd15.prod.outlook.com
 ([fe80::787e:eb9b:380a:2f0d]) by SA1PR15MB4854.namprd15.prod.outlook.com
 ([fe80::787e:eb9b:380a:2f0d%2]) with mapi id 15.20.5227.023; Mon, 9 May 2022
 12:06:16 +0000
From:   Dylan Yudaken <dylany@fb.com>
To:     "axboe@kernel.dk" <axboe@kernel.dk>,
        "io-uring@vger.kernel.org" <io-uring@vger.kernel.org>
CC:     "asml.silence@gmail.com" <asml.silence@gmail.com>
Subject: Re: [PATCH 03/16] io_uring: make io_buffer_select() return the user
 address directly
Thread-Topic: [PATCH 03/16] io_uring: make io_buffer_select() return the user
 address directly
Thread-Index: AQHYXZ4E/YKtPTC2Xke82fW2vRIHv60WfyGA
Date:   Mon, 9 May 2022 12:06:16 +0000
Message-ID: <6d2c33ba9d8da5dba90f3708f0527f360c18c74c.camel@fb.com>
References: <20220501205653.15775-1-axboe@kernel.dk>
         <20220501205653.15775-4-axboe@kernel.dk>
In-Reply-To: <20220501205653.15775-4-axboe@kernel.dk>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 1572cbd3-6e62-4f8e-2610-08da31b451e6
x-ms-traffictypediagnostic: BN8PR15MB3265:EE_
x-microsoft-antispam-prvs: <BN8PR15MB3265F2565ABEAB2061400B1AB6C69@BN8PR15MB3265.namprd15.prod.outlook.com>
x-fb-source: Internal
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: QsEWFS4inSiyfTPMmNzJDWDh1ezTlPzSvFqNI5hYCGPBcV+6/1UHrqZcT1iXGrDusr6aH1nN/uvCgnomNJ5gbzrLuTCUWbgqHspDRAnFQUbPqK/bmDawBEYLQJ7ah50Yz4jH+iR4r67htM9xdGi0GSgN3UnY4jYcNTjX2XIVX/B8Zw16F2urc4hRt+V6GhwGO1SSJ/lh57HnVUZdCRuuVDVisCoAUTyxGAz4dFuq9MZ1eNi10Un80bfnraan68MeCLFqdKQkDnXkeuucNRSNgz55cenOJia5I8Mo2iho4wCF8cEshgx8HljFhSuu+E/Wk6w56aUy5gGn1kwY6+XMIX3B8GaKmBIh3DdTfY51c7D/IQbZifXBdOZzhMPUBCDc2vbomf0QsWOOu63o+LD/Ve8yIoYr3zswZ+zIbx+zzrKY+iFvRe/AIJfKUzi8EyZcSPOO3rRR4n2u3IfASnuY9nFHNDhXaJXxUjlZ1FMuqkrPnpdgWr9Pc9Nay0Mbf1iio7Tm2MM6yzVajf5z4AEErvwgPm2yoCxzOa50FNhu7tbi1v2OX/LQdBNbKFm8WvOEneQxRyXRQVN113XXlEVe16cMp5MQnROZTpDRRgEjZbmEATVT8VvGNGqi3AIdJ2Jtk9fJbf5XLc/XaESz3LJXmy7HzwA07T86xPiUrSaSZMd2xryq8dKSccbwxcvPU3Zdhs8uChV+Ih2GsjchqTxVzA==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR15MB4854.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(2616005)(110136005)(122000001)(38100700002)(91956017)(5660300002)(36756003)(38070700005)(83380400001)(6506007)(8936002)(86362001)(66446008)(64756008)(508600001)(6512007)(66556008)(6486002)(316002)(66946007)(66476007)(76116006)(4326008)(8676002)(71200400001)(186003)(2906002)(4744005);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?S2ozQno2TVA3RktHRGVNdFRWODlzR2NHeVlCOVk3d0ZWbmkwSlVOUGRZeXND?=
 =?utf-8?B?VFJLcnpiM1NzMm5iRnRTdUZrZVZJNXdlTjlaUW95MHhZWTJoZkVtK0QzYlZY?=
 =?utf-8?B?UnR0V0plM1Z0d2gxbXJFMzJFcmlKTTZCZG9PbUh3TGhpaEhyNXM1YkNhd01L?=
 =?utf-8?B?RWRKdHJJNmRjNlR2ZVhqS1VZS0NOZkVDcmJ0eUdwQzBMMkhEZlpSNHpDQ1N4?=
 =?utf-8?B?ZE9jVDFjTXYrR3lpWU1xdXdmWDVvWENqdzgzVHZUdGM2Tm91ZzdpQXJsdVdo?=
 =?utf-8?B?RWo5bllVSVIvTVhLRFlYUE8ydlYzMUZRM0ZHWWNaMUMwTzUwWXBoT3U4eTBu?=
 =?utf-8?B?NTdGR0EyOWVZMkhvbWhOWkQzVi9vZlRSamdxWHZxcUVYRE9tWUJ6aWlJb2Rw?=
 =?utf-8?B?WCtTTHA2UGR2ZzV5OVlHME5GYnRxMDgzVmN4ZjBFNlErN2xVdjdiNVVBN2g2?=
 =?utf-8?B?Y3dHSmtMdUxSM3huWktyRjBweTZMYTZzZ2cwejNGSS9ucHRmS0dHUEhXTDlN?=
 =?utf-8?B?Wm5SeHBRRm05WGpaQitUVHdvc0FoQ1VRRTg3ODJ5aHRyamZ1M0pGSnJuZXhp?=
 =?utf-8?B?RUtUOEdxY0t2RGpmTWpnNkY2WlNSNk1FSkdsZUxhd3puU0xwejdmd0RNT2lM?=
 =?utf-8?B?NWUraDMxUU51OUhOdzVZVUxFUEVQSDU5UERDcEFoM2JLalQ1UnBiWjFYUk1U?=
 =?utf-8?B?anVKb2ZscmJSZFM2dnQvUU9IelU0RDBPVG0zZVpEdHNPbHpDcEJmQkhDSkpK?=
 =?utf-8?B?TUhkWkFaNkh4ZU8rcmVqZG9qakVQUUlxTlQrTXJ2S3hQbldqREZiN2ZvajBN?=
 =?utf-8?B?NW1XcFluSW5FaStuRU9KNGtTd1h3RHY0eGFpMVhjMkFSam5zNkFJcHdyZjVD?=
 =?utf-8?B?dGxudVpodDhhcXFtZW5vczB2eExiMnBzWVhPSTlMcXFNOUtVc3ZSQzJ0dkpt?=
 =?utf-8?B?ZEM5WEMyQlM5WE8zS243Qk5IMWZHdEdNNVppSFRibzhoL05kQXE5djY2emhr?=
 =?utf-8?B?QVFjUHNUcnRpR3YvN3E1dEpwMk9zbDFYTUxqSDFnTVJxbS8rd3RaVVExV29O?=
 =?utf-8?B?di90RHpBVVVsbVdYcnA4MVp1QUlaWFVObXFjdkpTV2NPSHZwNEJsK2RhbDBh?=
 =?utf-8?B?RDg4dyttMlhwUS9mNjB3akhxTU5jL3Y4djB5K1cyNERnTUxubG5QSk1qd1lW?=
 =?utf-8?B?cUJhd0crVVlya1FNMjREVGhDMjJKYXdlOWNnL2hFVEtpREF6TTdxck8yZnFw?=
 =?utf-8?B?RU9aOGl5d3ZDdVU4MWpwSS9NYUxDVmFTbHNRMlBHSHR3MFBZZXlGcWRodzJv?=
 =?utf-8?B?d291SWtaTEw3Q3pmSFg3Y1lUenIyamVIc0UrVDZnZXVjekpKdTA2Vm84WlVL?=
 =?utf-8?B?WHljblVLdENGSzlJd0hJa0NibXN0VHh5eS8wMm1xMTBDbm5RRlR4a0tuc1U3?=
 =?utf-8?B?VmluK1FqVG1GM2RtaWtUTlRXaXpxZUgxTW1wdHRYWG1lS0lpaWd2M1ZFQ3pF?=
 =?utf-8?B?L0o1VkJaYkZwOGVOSmRJM0EvTFpJS2F5dzN5R0FGc0QxTlV5QXZRLzZiZWNw?=
 =?utf-8?B?Q2hpMWVpWk1FM2hhQWxHVk9LQnNTMFdhTWVsNDhkUE5GVFNtVUlja29IaGdp?=
 =?utf-8?B?ZmU1K0dNV2VJN0pZSFBtblloZU9LQXNJSjRMUHVzUHJoVGNtNEQ2a2U2Tk9X?=
 =?utf-8?B?VnFJaENNZlpoYkJjVC95M3BqZzRORjkrSVhvNlRHdDhoRGJVaDM0a0hXMHY3?=
 =?utf-8?B?Mjc1MnpMUEtTdWhocllHdHFibnVGVFlVTWNMZWpSMmVqblcrenluM1RFK2tU?=
 =?utf-8?B?MlgxZXFwZ29RRGtqSHc3QVVROS9sNWI3V3hYVllqdFdUU0t1KzhKc0ZMbjlK?=
 =?utf-8?B?SlpSeW04YjJsaFlUUVJUbWorYTB2b3ZMWm1VdDB2R29HeUdaRGt2ZiswbTVa?=
 =?utf-8?B?VEpvOXd4cUtZWVAzaE5BbmpWYlU0Q3VJVFdlUjM1Q2FhY255RGRrUW9IRXlp?=
 =?utf-8?B?RHMrTFNpMFJndzhHUEFqOGFVYU1ncDBXdjV5Tzg1MlJmRHQ0Y25lblhpbEEr?=
 =?utf-8?B?bjk0MGJVRTVINEZuZVBidHE3eVV6VEVNVUtqVDZ5UHJ2SnpOMmlXVnp5ei9H?=
 =?utf-8?B?ZWVBMlNwZ21Ta1pYU3VWOTZaeFl4V3lmdGg1UklidU9hODROaWlmMkRXK0xS?=
 =?utf-8?B?SU0vNTRlcElvdDRJUTg1bXFsTEVYcU9CeW5LN2VPVUxKeTVjRTJZaVQ3WXFN?=
 =?utf-8?B?YjdLWjc5d3pnMm9NV1FDNFNCNFBWbFN4VjZ2ZWhOOEJRVk0rT2Z0cmZzTnFO?=
 =?utf-8?B?UjJlOTlKV2pJeVRqNUN5TWR3dEwyd0R5MDBIUW1Zd3VMREFhb2ZQOHNSOE1L?=
 =?utf-8?Q?q6UqImNFaXqxn6LQ=3D?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <BD8F7592454B2B4ABFB9CEBA5A329AF3@namprd15.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: fb.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SA1PR15MB4854.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1572cbd3-6e62-4f8e-2610-08da31b451e6
X-MS-Exchange-CrossTenant-originalarrivaltime: 09 May 2022 12:06:16.3945
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: LFedtfpBhCfeI1Pd+PFoE1jg2O5pJHluvGEzaTYR68OU9IMuml5Km33tRmFPXiuj
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN8PR15MB3265
X-Proofpoint-ORIG-GUID: _vJI7zdKmBIJeFZUP4U0vgI_M7C2ic2c
X-Proofpoint-GUID: _vJI7zdKmBIJeFZUP4U0vgI_M7C2ic2c
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.858,Hydra:6.0.486,FMLib:17.11.64.514
 definitions=2022-05-09_03,2022-05-09_01,2022-02-23_01
X-Spam-Status: No, score=-3.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

T24gU3VuLCAyMDIyLTA1LTAxIGF0IDE0OjU2IC0wNjAwLCBKZW5zIEF4Ym9lIHdyb3RlOgo+IFRo
ZXJlJ3Mgbm8gcG9pbnQgaW4gaGF2aW5nIGNhbGxlcnMgcHJvdmlkZSBhIGtidWYsIHdlJ3JlIGp1
c3QKPiByZXR1cm5pbmcKPiB0aGUgYWRkcmVzcyBhbnl3YXkuCj4gCj4gU2lnbmVkLW9mZi1ieTog
SmVucyBBeGJvZSA8YXhib2VAa2VybmVsLmRrPgo+IC0tLQo+IMKgZnMvaW9fdXJpbmcuYyB8IDQy
ICsrKysrKysrKysrKysrKysrKy0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLQo+IMKgMSBmaWxlIGNo
YW5nZWQsIDE4IGluc2VydGlvbnMoKyksIDI0IGRlbGV0aW9ucygtKQo+IAoKLi4uCgo+IEBAIC02
MDEzLDEwICs2MDA2LDExIEBAIHN0YXRpYyBpbnQgaW9fcmVjdihzdHJ1Y3QgaW9fa2lvY2IgKnJl
cSwKPiB1bnNpZ25lZCBpbnQgaXNzdWVfZmxhZ3MpCj4gwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKg
wqDCoMKgwqByZXR1cm4gLUVOT1RTT0NLOwo+IMKgCj4gwqDCoMKgwqDCoMKgwqDCoGlmIChyZXEt
PmZsYWdzICYgUkVRX0ZfQlVGRkVSX1NFTEVDVCkgewo+IC3CoMKgwqDCoMKgwqDCoMKgwqDCoMKg
wqDCoMKgwqBrYnVmID0gaW9fYnVmZmVyX3NlbGVjdChyZXEsICZzci0+bGVuLCBzci0+YmdpZCwK
PiBpc3N1ZV9mbGFncyk7Cj4gLcKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoGlmIChJU19F
UlIoa2J1ZikpCj4gLcKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKg
wqByZXR1cm4gUFRSX0VSUihrYnVmKTsKPiAtwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKg
YnVmID0gdTY0X3RvX3VzZXJfcHRyKGtidWYtPmFkZHIpOwo+ICvCoMKgwqDCoMKgwqDCoMKgwqDC
oMKgwqDCoMKgwqB2b2lkIF9fdXNlciAqYnVmOwoKdGhpcyBub3cgc2hhZG93cyB0aGUgb3V0ZXIg
YnVmLCBhbmQgc28gZG9lcyBub3Qgd29yayBhdCBhbGwgYXMgdGhlIGJ1Zgp2YWx1ZSBpcyBsb3N0
LgpBIGJpdCBzdXJwcmlzZWQgdGhpcyBkaWQgbm90IHNob3cgdXAgaW4gYW55IHRlc3RzLgoKPiAr
Cj4gK8KgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoGJ1ZiA9IGlvX2J1ZmZlcl9zZWxlY3Qo
cmVxLCAmc3ItPmxlbiwgc3ItPmJnaWQsCj4gaXNzdWVfZmxhZ3MpOwo+ICvCoMKgwqDCoMKgwqDC
oMKgwqDCoMKgwqDCoMKgwqBpZiAoSVNfRVJSKGJ1ZikpCj4gK8KgwqDCoMKgwqDCoMKgwqDCoMKg
wqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqByZXR1cm4gUFRSX0VSUihidWYpOwo+IMKgwqDCoMKg
wqDCoMKgwqB9Cj4gwqAKPiDCoMKgwqDCoMKgwqDCoMKgcmV0ID0gaW1wb3J0X3NpbmdsZV9yYW5n
ZShSRUFELCBidWYsIHNyLT5sZW4sICZpb3YsCj4gJm1zZy5tc2dfaXRlcik7Cgo=
