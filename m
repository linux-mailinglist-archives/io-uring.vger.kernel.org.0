Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 397C0613B99
	for <lists+io-uring@lfdr.de>; Mon, 31 Oct 2022 17:45:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231473AbiJaQpA (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 31 Oct 2022 12:45:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38772 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231419AbiJaQo7 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 31 Oct 2022 12:44:59 -0400
Received: from mx0a-00082601.pphosted.com (mx0a-00082601.pphosted.com [67.231.145.42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BD7D96246
        for <io-uring@vger.kernel.org>; Mon, 31 Oct 2022 09:44:58 -0700 (PDT)
Received: from pps.filterd (m0109334.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 29VDF9Xl009341
        for <io-uring@vger.kernel.org>; Mon, 31 Oct 2022 09:44:58 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=meta.com; h=from : to : cc :
 subject : date : message-id : references : in-reply-to : content-type :
 content-id : content-transfer-encoding : mime-version; s=s2048-2021-q4;
 bh=tFMoRtQhTgTsZDozkjMNnd2n8AIEkDFTM6CM6Ap7UIA=;
 b=F+GGTW+Zmf1tTiWUMmQvrNCU8LqYV10ts8im4Xxcr7wn5G9CCHBt1zgtPdFjB+dNdFB8
 2Eu2D92ralbnN6MbKNhkwZbpsQBb+JnHE5thZw9LS6EXejH4VJtrhI1Ox+eZBPpXCqov
 bOdtV2AkY76yNct8IrU5zr0YV8jNsuuPcrJ65yOxGjbMFEPcAqrkizJBMz8152o2HLkX
 BUj1F4tZ0RaVRtrvu86q1C5H6DRGBgbj/OBNKLrRE+vsBo4sin3CYj4qfPHEzKjuD6HN
 yVXRsUA7YSCpF4oYexTA9XarOZ5xtqcCT4x/ftSCKQkvf/UP5/w9yT337kI4q77FEqWe xA== 
Received: from nam12-mw2-obe.outbound.protection.outlook.com (mail-mw2nam12lp2045.outbound.protection.outlook.com [104.47.66.45])
        by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 3kh3g77r93-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <io-uring@vger.kernel.org>; Mon, 31 Oct 2022 09:44:58 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=UsWhVHUaQgdgQVpM2ocDK0f5sgIdiF/iOiBgSSNunZWI37q4u+nJn8sepkBr1vmJy8Q00LGrFjpZCy0KuhN17+hkqRWPloEwkUhblLhsd+dlNDSeiQt1gFDlsoI4intj5roHWgoyeicNO4GrKZxd8wZh+9ibTMoVZeUEQLdl8CYCF3HlIBJCdpo+NwzJgQ+Bv6S8CnBtt+YjYkGDdHkgitm5ZyMbmUkcQ2+A7b12EWkYXtkNMLCcNuo9/F0O+6f+ORqV3/gIJacPckv44OXlBHvLaOTO0oeeolutAsn5s9420uKX7qDvZCTsE2t/ZNdUlYYRw22wDMzfjwuU2wlpYA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=tFMoRtQhTgTsZDozkjMNnd2n8AIEkDFTM6CM6Ap7UIA=;
 b=dtDKtYfre0MKy1PYy01xOIw44mOR582+p/Tdhiljyc1gDGXc/jcuk7Ue7iz9lmD99OwJT+iEZrEHsH+9ONIM0/V0WMzkWjWy7DDWv1SA76zjPo52KQbd/YfqbNUlf449xkVXjnTYENtGJeGyB2ZmmBZmSb/z0QmbfG4MJLhcfotcj4IKgBoY2ql7Ya3F/H3kFpOm1h+XTeCiC3v2/5XVBLEgYiYiUutD4F4/UfZNKHbXWwauKe/dNJBAZzMpkj9RSo6HidrcMzBot5gD1R47mFWKtKhT5KJZJresSWWuS03ZunOL2QXJmc3BZy4I4ttUWnSo6qY/DYLA98pBnhTrGg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=meta.com; dmarc=pass action=none header.from=meta.com;
 dkim=pass header.d=meta.com; arc=none
Received: from SA1PR15MB4854.namprd15.prod.outlook.com (2603:10b6:806:1e1::19)
 by DM6PR15MB3259.namprd15.prod.outlook.com (2603:10b6:5:170::28) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5769.16; Mon, 31 Oct
 2022 16:44:55 +0000
Received: from SA1PR15MB4854.namprd15.prod.outlook.com
 ([fe80::1b85:7a88:90a4:572a]) by SA1PR15MB4854.namprd15.prod.outlook.com
 ([fe80::1b85:7a88:90a4:572a%6]) with mapi id 15.20.5769.019; Mon, 31 Oct 2022
 16:44:55 +0000
From:   Dylan Yudaken <dylany@meta.com>
To:     Dylan Yudaken <dylany@meta.com>,
        "axboe@kernel.dk" <axboe@kernel.dk>,
        "asml.silence@gmail.com" <asml.silence@gmail.com>
CC:     Kernel Team <Kernel-team@fb.com>,
        "io-uring@vger.kernel.org" <io-uring@vger.kernel.org>
Subject: Re: [PATCH for-next 04/12] io_uring: reschedule retargeting at
 shutdown of ring
Thread-Topic: [PATCH for-next 04/12] io_uring: reschedule retargeting at
 shutdown of ring
Thread-Index: AQHY7S6KH5nh0ASq+0qMfb8/p5fu/K4oqdoAgAAL/QA=
Date:   Mon, 31 Oct 2022 16:44:55 +0000
Message-ID: <e56548935adffbbe3ee19a0701a25ee5fb97a79b.camel@fb.com>
References: <20221031134126.82928-1-dylany@meta.com>
         <20221031134126.82928-5-dylany@meta.com>
         <83a1653e-a593-ec0e-eb0d-7850d1a0c694@kernel.dk>
In-Reply-To: <83a1653e-a593-ec0e-eb0d-7850d1a0c694@kernel.dk>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: SA1PR15MB4854:EE_|DM6PR15MB3259:EE_
x-ms-office365-filtering-correlation-id: 3040871b-04e1-41cb-8d8f-08dabb5f3d4e
x-fb-source: Internal
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 6b3HrJODmlcRsu5WDhp/1cTdUjqnfBDMcUBjNP0p5NZ+KfrwsYLPif9jm4q49YfFFUW6k+NdCp3iThLKU72JXJtUxZNccFX1MfMW5bLSMgaQ6MrBxV8qpLmHZvfX0xBSMxZsIHQcpogx7zkS6xlIM3H8171nv8yYXhA9oJY31hOYR2+oGCzMsaxtoJfLH+bo4LqBEiB4pgu11rWxicI9qq1RdMB1o+nh3KDXNLYpzGKUy6nsHsOuPJqEwNZ7E3U7lrmlUajCTmkrJpb6dftgCoHMG+Sq45ZcM1TH6tmsPgH/cKQED912zPZSriHx59a3W36sxldlbhRByqOExXXA/IfKtmuBDG5enBWMNqwmhjhAiVokeL2WeDA6whtwyJRJ9DRRDwlaX0gZ+yqw+n0igEpZeSY0tgd8z4k6S/kabr4dEJ0wR0Ta0PmiPQxTRlZrJut4mU+PZ4yDjm+7dnym11wWgDYzX0Ez8kNn6TFJAClQqBlu0SK0leD2nbrwbbxAHxpkwY43bQp92p19eK4YgHnnSh9apCSPlWdJsGhy1BFe2pf2JyEudlq8gSM4WBIlTBm3NM7GN9F+LIhDRkvidoKthzbrWgFPIHQjo/OOy7tnxJ44bAjTKznlrbwWom8U3uDUbqzOXZGSkvyxZaG6rs9DPX1WsFE0f1XI5frBcorUAZS4bUW1n9iW3Nq+Iqvvo6MxduGMmUNVK1hGdrJO6/9PaFVYtaYDBpJnFjOc4qMC4IgB4fj4lSOL54mLiE4FnkQA772Py2cbvHzSd5hZ4Q==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR15MB4854.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(39860400002)(376002)(346002)(136003)(396003)(366004)(451199015)(38070700005)(6512007)(9686003)(41300700001)(2906002)(4001150100001)(83380400001)(36756003)(5660300002)(186003)(38100700002)(122000001)(8936002)(54906003)(6486002)(478600001)(71200400001)(86362001)(66476007)(8676002)(76116006)(66946007)(53546011)(66446008)(64756008)(4326008)(6506007)(91956017)(66556008)(110136005)(316002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?WGk3RVhoMW5EdFJuTDVJY3hXMlp0WHpoWkpYeHRMd3ZXS3RXWVBaOUtzSmhM?=
 =?utf-8?B?aHYxSnNVbTBzL0dmWWVVTHU0ZHU2TFJOTzM1U1ZMU0NZYUltUHdHdERPVTBR?=
 =?utf-8?B?b0x5SkZVcmVjK21qMXhhY3VYRzNGWTR2NGxhOGFDS1lXaW4zd2k1VEFPS1Nx?=
 =?utf-8?B?cFNFR3NGcVByNmxmQ3gydVorMXE2R2hoN1d5TmFCZGJDSG9wY0FHcWNWVXV6?=
 =?utf-8?B?NE9PZEl0UVdyUmlBb01MdnNkbHBQNXJld0YzS3F4M0ZvaytwQkRnOHhvTEE1?=
 =?utf-8?B?OEV2WUg0b1RqSXorNUVNSmpncWQ3aDJheDR3MllsbzN0a3EvemMwL0ExZnVw?=
 =?utf-8?B?K2RGMXJzamV2aCsxWUNxanA3ZXVpdnUxV1NjR0VqVWFDOVMvNGc4ZVYwVU1C?=
 =?utf-8?B?QmRDS0tmMUVrMG00bUhPTFAvME5zZDFPRHJBU1kzTkRzanQyTnNNN20xM3pI?=
 =?utf-8?B?eVkvS3c4RVZ0dUlQNk4wUmg1clBXblpFN3QvVDgxdXFkT2ZiaWJJcnFFYSto?=
 =?utf-8?B?VkpMOXVXUUNpcnJ3ZUdrcnlwcXlJSTRBZmJFZitvaW55VXBFbGM4QVVjS0hh?=
 =?utf-8?B?V3N3Zy9qL3RWeXlTcnZoSlZuZmRURndiWFlpM3oxNCtHSWx5dkpSc2d6MXg0?=
 =?utf-8?B?RGs5QlJLVlp5UG5Kb0Z4NTRjbkFqcklNRDBmaEU5WTFjRUdLREY3WnhXZmxN?=
 =?utf-8?B?ajZaRUpQWTNTSEVJNHZCVEVzWGRCTWd6ZDVwcHZSaC9kSXhWRUxFRDRXMHQ5?=
 =?utf-8?B?MXZIT0RGZWlaOEoyemp2OS9MUCtTQlEyTmJReTVGT3hiMFVhT3hSMlBGNzhO?=
 =?utf-8?B?ZmdKT3huMUlCWFN3V2NwWWhvMWpPdmd4WEdRVXpVdTVwOS94eVRGdUZRNjMr?=
 =?utf-8?B?TGNsTm5iVWh5bDZaRS92akxKL29ldGx6YVlMSjRLbXVTWmxiTHlFaW4vc1l2?=
 =?utf-8?B?YWt1RFZvM0ZpcHBZOURoZFltcmh1YWpvd2l0WVdKUXFLQWNlaEJNeFlWVkwy?=
 =?utf-8?B?dEVQcENqVHlHdGFqcDR1YUE5RFhNS2Q5dlV6TmNLTnBKRW8zK0hpVUtiSkNk?=
 =?utf-8?B?UHZNZGJKVHJ1UTZuOWxwUEFZTzYvczd0VUJnQjdmUGVTVXlrbDZTTGV4THVV?=
 =?utf-8?B?cFpka2pEMkl0dW5DZkRwbmxWeXd4UTNGcUU5ZDBURTV4SnZwT2dHWWxld2FX?=
 =?utf-8?B?VjFYTlY4UG51RG02QkxlR1pwTWhLRDNrVU1TcTc0T1ZWQ25HOE1BN3JrYnFB?=
 =?utf-8?B?akh6M2FtdGdSTjFxUFNNZ2xQaEFpZXB6NkpRYm1JZmhjWVlFSzR0Sm9NTGw3?=
 =?utf-8?B?QjY0S2FiQVdRaDhmRjlCRURFdDJwZitUVTljcEp1NmcrSy9ocXZFN0lvUmhG?=
 =?utf-8?B?VGVpcU1LS2Y1OFVBVTJLV0RkcHBPM1lLSVpMeTJXeGFoVEN4Zzh6alhvY1Js?=
 =?utf-8?B?Zjc3TFU4T3lRaXg0YUk1aFE0OFdiTGhYNEp0c3N5YVBuN2ZYcDZVL05WekxU?=
 =?utf-8?B?YndmQ0haQXZyVFVidUpqaUhnaTJZelQrNFlESlZjaE5QZ0pOYnZUbmVZSVp2?=
 =?utf-8?B?V05WY2N3OFBwRkNOWUtMSTFJTktNa3FjTWJjQ3JXeitqNXd2TmMzNlMrZWRL?=
 =?utf-8?B?UlQ3a1h0c0FuTm5SU0VBdEZQNmt6aWRzcmxGL1l1Tmw1UDlhcmo1dWVpNDQy?=
 =?utf-8?B?aXh6bEZyQ3RZR0NnYUZISzFPeE1rcG9LcUxhb01wUGZKb3FCMCsyS2dXUDNP?=
 =?utf-8?B?VlNiRmxnQnI0aUdxZWxuMUpUM3BNUEFqUW9jTWpoM0twYmFkWTR1TVZXaHp4?=
 =?utf-8?B?V2ZUN2pUNGpENHE2aHZ3UVh0ai8wbExoMlZjZ3JOb0JLN3Bta0JZOGJFaW9w?=
 =?utf-8?B?ZDlsYlVWTk5mY2lzcVRDQUg0UmUyUzl5QXB0Y0k3dEJGOU9hcWlZNnF3T1pP?=
 =?utf-8?B?UXp0S2ZlSXlpRS9rdHFyUk9YMjZOejN4ekZSWkNTbXRuaEhOb3V0L281NXBT?=
 =?utf-8?B?YWQ0eEVOUGY2Q29vbW81UERvb2tGdjFURUpIM2JWbk5VWDhCVklvWlExNHJy?=
 =?utf-8?B?VnFZc25ZV1lWMTJLMWtHREF3bk1EdkxIT3B3SGdTK2NMZ0I5V1JjeXVnS0ZC?=
 =?utf-8?B?ZHdlK081cmlzV21sOGxHVWNucmZsdWcrZEFRYUIrb2pLQVdhb0laYnNtRFJQ?=
 =?utf-8?Q?XDT7SVb+pEyFAdo30nM++8E=3D?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <2B119225955ADA4880F5BAB64CFE8ED8@namprd15.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: meta.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SA1PR15MB4854.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3040871b-04e1-41cb-8d8f-08dabb5f3d4e
X-MS-Exchange-CrossTenant-originalarrivaltime: 31 Oct 2022 16:44:55.1035
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: M4LNPh4ZuDgh5kys3IfIFgrAu9PgX0mzxana6cUHJiK9plz1JkaofWy5dI5eWETn
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR15MB3259
X-Proofpoint-GUID: AN85hapYnG_JPxY6hG5txaKVc8DxFV8e
X-Proofpoint-ORIG-GUID: AN85hapYnG_JPxY6hG5txaKVc8DxFV8e
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.895,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-10-31_19,2022-10-31_01,2022-06-22_01
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

T24gTW9uLCAyMDIyLTEwLTMxIGF0IDEwOjAyIC0wNjAwLCBKZW5zIEF4Ym9lIHdyb3RlOgo+IE9u
IDEwLzMxLzIyIDc6NDEgQU0sIER5bGFuIFl1ZGFrZW4gd3JvdGU6Cj4gPiBkaWZmIC0tZ2l0IGEv
aW9fdXJpbmcvcnNyYy5jIGIvaW9fdXJpbmcvcnNyYy5jCj4gPiBpbmRleCA4ZDBkNDA3MTNhNjMu
LjQwYjM3ODk5ZTk0MyAxMDA2NDQKPiA+IC0tLSBhL2lvX3VyaW5nL3JzcmMuYwo+ID4gKysrIGIv
aW9fdXJpbmcvcnNyYy5jCj4gPiBAQCAtMjQ4LDEyICsyNDgsMjAgQEAgc3RhdGljIHVuc2lnbmVk
IGludAo+ID4gaW9fcnNyY19yZXRhcmdldF90YWJsZShzdHJ1Y3QgaW9fcmluZ19jdHggKmN0eCwK
PiA+IMKgwqDCoMKgwqDCoMKgwqByZXR1cm4gcmVmczsKPiA+IMKgfQo+ID4gwqAKPiA+IC1zdGF0
aWMgdm9pZCBpb19yc3JjX3JldGFyZ2V0X3NjaGVkdWxlKHN0cnVjdCBpb19yaW5nX2N0eCAqY3R4
KQo+ID4gK3N0YXRpYyB2b2lkIGlvX3JzcmNfcmV0YXJnZXRfc2NoZWR1bGUoc3RydWN0IGlvX3Jp
bmdfY3R4ICpjdHgsCj4gPiBib29sIGRlbGF5KQo+ID4gwqDCoMKgwqDCoMKgwqDCoF9fbXVzdF9o
b2xkKCZjdHgtPnVyaW5nX2xvY2spCj4gPiDCoHsKPiA+IC3CoMKgwqDCoMKgwqDCoHBlcmNwdV9y
ZWZfZ2V0KCZjdHgtPnJlZnMpOwo+ID4gLcKgwqDCoMKgwqDCoMKgbW9kX2RlbGF5ZWRfd29yayhz
eXN0ZW1fd3EsICZjdHgtPnJzcmNfcmV0YXJnZXRfd29yaywgNjAgKgo+ID4gSFopOwo+ID4gLcKg
wqDCoMKgwqDCoMKgY3R4LT5yc3JjX3JldGFyZ2V0X3NjaGVkdWxlZCA9IHRydWU7Cj4gPiArwqDC
oMKgwqDCoMKgwqB1bnNpZ25lZCBsb25nIGRlbDsKPiA+ICsKPiA+ICvCoMKgwqDCoMKgwqDCoGlm
IChkZWxheSkKPiA+ICvCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqBkZWwgPSA2MCAqIEha
Owo+ID4gK8KgwqDCoMKgwqDCoMKgZWxzZQo+ID4gK8KgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKg
wqDCoGRlbCA9IDA7Cj4gPiArCj4gPiArwqDCoMKgwqDCoMKgwqBpZiAobGlrZWx5KCFtb2RfZGVs
YXllZF93b3JrKHN5c3RlbV93cSwgJmN0eC0KPiA+ID5yc3JjX3JldGFyZ2V0X3dvcmssIGRlbCkp
KSB7Cj4gPiArwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgcGVyY3B1X3JlZl9nZXQoJmN0
eC0+cmVmcyk7Cj4gPiArwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgY3R4LT5yc3JjX3Jl
dGFyZ2V0X3NjaGVkdWxlZCA9IHRydWU7Cj4gPiArwqDCoMKgwqDCoMKgwqB9Cj4gPiDCoH0KPiAK
PiBXaGF0IGhhcHBlbnMgZm9yIGRlbCA9PSAwIGFuZCB0aGUgd29yayBydW5uaW5nIGFsYToKPiAK
PiBDUFUgMMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKg
wqDCoENQVSAxCj4gbW9kX2RlbGF5ZWRfd29yayguLiwgMCk7Cj4gwqDCoMKgwqDCoMKgwqDCoMKg
wqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoGRlbGF5ZWRfd29y
ayBydW5zCj4gwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKg
wqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqBwdXQgY3R4Cj4gcGVyY3B1X3JlZl9nZXQo
Y3R4KQoKVGhlIHdvcmsgdGFrZXMgdGhlIGxvY2sgYmVmb3JlIHB1dChjdHgpLCBhbmQgQ1BVIDAg
b25seSByZWxlYXNlcyB0aGUKbG9jayBhZnRlciBjYWxsaW5nIGdldChjdHgpIHNvIGl0IHNob3Vs
ZCBiZSBvay4KCj4gCj4gQWxzbyBJIHRoaW5rIHRoYXQgbGlrZWx5KCkgbmVlZHMgdG8gZ2V0IGRy
b3BwZWQuCj4gCgpJdCdzIG5vdCBhIGJpZyB0aGluZywgYnV0IHRoZSBvbmx5IHRpbWUgaXQgd2ls
bCBiZSBlbnF1ZXVlZCBpcyBvbiByaW5nCnNodXRkb3duIGlmIHRoZXJlIGlzIGFuIG91dHN0YW5k
aW5nIGVucXVldWUuIE90aGVyIHRpbWVzIGl0IHdpbGwgbm90CmdldCBkb3VibGUgZW5xdWV1ZWQg
YXMgaXQgaXMgcHJvdGVjdGVkIGJ5IHRoZSBfc2NoZWR1bGVkIGJvb2wgKHRoaXMgaXMKaW1wb3J0
YW50IG9yIGVsc2UgaXQgd2lsbCBjb250aW51YWxseSBwdXNoIGJhY2sgYnkgMSBwZXJpb2QgYW5k
IG1heWJlCm5ldmVyIHJ1bikKCgo=
