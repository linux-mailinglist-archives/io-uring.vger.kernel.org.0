Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C8BB1616361
	for <lists+io-uring@lfdr.de>; Wed,  2 Nov 2022 14:08:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229624AbiKBNIS (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 2 Nov 2022 09:08:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47390 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229531AbiKBNIR (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 2 Nov 2022 09:08:17 -0400
Received: from mx0b-00082601.pphosted.com (mx0b-00082601.pphosted.com [67.231.153.30])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 787E81FFA7
        for <io-uring@vger.kernel.org>; Wed,  2 Nov 2022 06:08:16 -0700 (PDT)
Received: from pps.filterd (m0109332.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 2A2BQTjx011520
        for <io-uring@vger.kernel.org>; Wed, 2 Nov 2022 06:08:15 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=meta.com; h=from : to : cc :
 subject : date : message-id : references : in-reply-to : content-type :
 content-id : content-transfer-encoding : mime-version; s=s2048-2021-q4;
 bh=d0rIBAw/HcIs3krSA84pTeeQkCJUhxoftu/57Xi5S3M=;
 b=hMCIS2+bHOxmF8ay61tKPpp/ifapa6APLy6zVIvSfkh0/LPQ/emvfJIzCfBufFo74Tfo
 9c2YdzGL9u9k8LVbbaQjDBJAFk/qbf+KRM8pIpyiHTKEwcBdEU0WPnJHj8wGjZuLpHEm
 bmmVVVe1pIhQrVNF+DOkv1v+oFvoQI7aMaOwvFWlWdYbMO7p5R64o67LQcFgO/pKxdRH
 sREazKb8SIHL491OEu1OarTZvavdxKL0+43+/MZuLBA3TThY4nWbcjFgLNVFJKt6ygqb
 ff/Sj9sffV/3mRnsWm3ubze6m3SFGc8G1Oy/GSyEOq+mNhnSewqZO6xcDCkwc2t2qnID 1Q== 
Received: from nam10-bn7-obe.outbound.protection.outlook.com (mail-bn7nam10lp2101.outbound.protection.outlook.com [104.47.70.101])
        by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 3kk7dc0v37-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <io-uring@vger.kernel.org>; Wed, 02 Nov 2022 06:08:15 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=AXGZL+l7VcKX1aAC82cFCTEeONRRxEzU19dqLUqNOtppe8/aCe4ThQCffiUT9i9NSfpxzfHXiwWVhHcmMNwkd5Lr2zDsijwgadkEuxT9lcnfEjofe64Vj3PaN22pzIyCIiDmtL6QPg8P323eJiZW79kyZP5Q8Pypf1//GqZ65IotDyWjMb0Wpgv6DpZUswTYz90SmgIv8Mrp+cBoJwt3sqc2lOsWxUT6FX1g8sHXjJiKovHAySIeIij6f8fxZ9pfzTxzMPPFBVW1fOByRUNBeJI33FqXTjF1+sQDBIQ9q9mxuwAm17U+jqT9CEssRkbSyOs0eivhAVWeiDEmTj29bw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=d0rIBAw/HcIs3krSA84pTeeQkCJUhxoftu/57Xi5S3M=;
 b=dr7S8uyiR5syp5NP+tXu2u+I220oYBkbzdG58uBJaD58EFDj/lTzRgzom3Kl7Jnh9dRVProlotnxO3jCoeQ25EuH8Np1QtRoLfgOxWVj8AsNEJVKuFrwyXnDL+YX/7ImYd1JPCrYATEVoeQy72pqpCQ2PZryjsPStthacrGFj/VXIWvuPm+H4LkOROQ8/FzvedsMOsGyj0xpm6RwmdfHWxO+3kJWGQWLLRCFJZ/rIUN+5swxZ85+LNXRDqgip0cZLzrBE5q33lKLHNoUyI4VohyOLnrDqn0EYDTg1FIvxyOTTS3/0D2+L2+ZFkLh9L5vm5UdzqmzMEc/6wdQzqOu7Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=meta.com; dmarc=pass action=none header.from=meta.com;
 dkim=pass header.d=meta.com; arc=none
Received: from SA1PR15MB4854.namprd15.prod.outlook.com (2603:10b6:806:1e1::19)
 by MW2PR1501MB1961.namprd15.prod.outlook.com (2603:10b6:302:12::27) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5769.21; Wed, 2 Nov
 2022 13:08:12 +0000
Received: from SA1PR15MB4854.namprd15.prod.outlook.com
 ([fe80::1b85:7a88:90a4:572a]) by SA1PR15MB4854.namprd15.prod.outlook.com
 ([fe80::1b85:7a88:90a4:572a%6]) with mapi id 15.20.5769.021; Wed, 2 Nov 2022
 13:08:12 +0000
From:   Dylan Yudaken <dylany@meta.com>
To:     Dylan Yudaken <dylany@meta.com>,
        "axboe@kernel.dk" <axboe@kernel.dk>,
        "asml.silence@gmail.com" <asml.silence@gmail.com>
CC:     Kernel Team <Kernel-team@fb.com>,
        "io-uring@vger.kernel.org" <io-uring@vger.kernel.org>
Subject: Re: [PATCH for-next 00/12] io_uring: retarget rsrc nodes periodically
Thread-Topic: [PATCH for-next 00/12] io_uring: retarget rsrc nodes
 periodically
Thread-Index: AQHY7S6F+05s+GjitkGmCz0WSjZSm64rhp4AgAAXVoA=
Date:   Wed, 2 Nov 2022 13:08:12 +0000
Message-ID: <876cfb7b0835969c2a35d54208c992642f24dd3d.camel@fb.com>
References: <20221031134126.82928-1-dylany@meta.com>
         <4f198467-e017-1ec8-ea3c-d6a67c48dd6e@gmail.com>
In-Reply-To: <4f198467-e017-1ec8-ea3c-d6a67c48dd6e@gmail.com>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: SA1PR15MB4854:EE_|MW2PR1501MB1961:EE_
x-ms-office365-filtering-correlation-id: 57f885c8-c424-4a43-9135-08dabcd34bd1
x-fb-source: Internal
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: NExXfTH7pllIVXGy4A16ry6CzXqsx7uXasRUPREhrfxwtWazte5Mu4s/6T7f8aesJrcUrjdI6ao7MePUn+muNDxCo8gnSNm1xKUbfcOtlwUL6xW50a2n2KkTvP1OD6EiDgYVlvMVJORjPPLUNJ9daEgzybEruXHFuT0U+0uUY6rbTIiMOY6FYG0L0NW1pQ5iMkIpTbpxihXnpM7dA+63SwF29Y7ZEM4DO5TjnTypdJCXiqqyd2fZsBfK9A4HSI4gCrvL0jRTfyzhbJgLCA7dWJsiPCM6EfvId9H5Twav8M0sGglsZWSX9A6cV7WWPaDnkFkuoMtoLbiMQeP1dbI5E/InWM3plE+yoH79RhGqeBvn0sXhb9MiYKY/r2q114o8dmbbVo3pMq0aZRw41HsWGE5axRi+JDNND/4t7XXKgh4yEClKrMCYgAcsnuqkJFT+h2jt08n51NZb/Xhkr6wZVhtyNMv29OZrUbQC2Ua+hGaL0synlzMI4Zon0Uept0N3Ks4kvGU661w27MGi9mo01vCdBc+6XcsjwtNmN7UE4LXINHu24ZmK4m/Rf3rZZRh2f6eH+d6IRITeKUgWybrhZP+KJAAfT/E7jfuL2XJW2QTlqCuaJi1AyR4dSzSm9436+BCmsDeJ4BuDmPrRDTOu7ZHApbJ5u+Bw/p98lFFBMu8Mguotp5HJb7eTOaowIsSV5sv8rV2dj+oC42vi9KAxXbrC4EIZNHp4G/5oJkfM4i2Vo0wYzQ1fAHnXIOvtm/XALxNsSjto1YMzcslzojIn6w==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR15MB4854.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(136003)(346002)(39860400002)(366004)(396003)(376002)(451199015)(83380400001)(2906002)(6506007)(4326008)(53546011)(8676002)(41300700001)(9686003)(6512007)(36756003)(38070700005)(122000001)(54906003)(316002)(86362001)(38100700002)(8936002)(66446008)(478600001)(64756008)(186003)(66946007)(5660300002)(66556008)(91956017)(66476007)(6486002)(110136005)(76116006)(71200400001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?Y1J4aGlJd0xiWkEzRG9pUEI3QVVsLzliVURzMGJvcXlmN0hYVHAvc09LS3Er?=
 =?utf-8?B?NkRieWk0VmsybkNKU0Y2bnl1SDQ2Zk0xSkltaXJrYmpqSFVwQVFkUGdIOVZs?=
 =?utf-8?B?YXllSHoxblA3T0dCelFsdFdxNTQ0WS9teTlTUmZhVVhmcHAxZFdLTGlDNUo3?=
 =?utf-8?B?Kzk5ck5RUGJRREQrVHV2VXVTMFdtbXBwbUM5RFMyWlg2UTZZVEtmM2o1K3hD?=
 =?utf-8?B?V3owQ21mK1lBWVBRNURrYXhhbXE3bzRpanZhZGZoOXVEcjlkUnBCa0diQVJl?=
 =?utf-8?B?RHZJQ1lxbGJXNG9QSTYxVnB1YVBNNHpNbGI5K3ROYTJXN0VPN2M3OGdwamND?=
 =?utf-8?B?b1pzTk1nTUZ6NFpwY1lnS29TTlpIQmtIVFVQdjVaREx6UW5LQnl3R2RjNmtj?=
 =?utf-8?B?ZjAvOFRYOXVHWHNpVWxoUDBBWEdDZm9SY3l5ZW52WlVPVW9FOThNWnNFMXpO?=
 =?utf-8?B?cFI2VzZzTVN6TjZOR3BJQkUrTUNZaThjK0UrZmNWNHJORWJFdjgySGJpdnRa?=
 =?utf-8?B?cFZZbnFzWVR2ZHpjS1RQUTJHcG5aK0VvMTNGZ2VkaU1hMndiQm5Id21wcjRa?=
 =?utf-8?B?RFdTd2VZYzlrRHc0dVN0SzhNaW43d0lROWJWbU5hdnI1NEhnUWFXNU96N1lK?=
 =?utf-8?B?VUxCaCsrY3c2aDAzTkF4eWhVZnJXOU9BQ0x0VnR1SjlzUTNOZUJ0bzN0WTZ4?=
 =?utf-8?B?RFpxM2RUM2R6dUh4QVdUSElXSDhmS2xrbVVRSS9EZkwzbFJPRlhXd2NMUTRi?=
 =?utf-8?B?OXlSak1veU53Sm41UnNSd09TbXdGVSs3aFdiRHpWQ2hSYUFhV1lzRXVqWTdx?=
 =?utf-8?B?cXJKRExiVFo1MW5yNDZDOEhldWhLVHNHZGZKT0tteFpZZ0JTLzMzZzhZK1RB?=
 =?utf-8?B?MXdZbmJOVEk2dmhEZ0ZMZ1ptNlFhdXJtN09BVzhpUkRValJta3J6d2Rnc25Y?=
 =?utf-8?B?SXljUXcwdVl0UUVvV2l1S05sbHNYWVBkMVg0bGU4dndld2FteThtM3E0WWpE?=
 =?utf-8?B?d25nU0NZYVJZOW5BK1lFU3A3MCtIeUg5T0d5VWNtWWNORlZpblp1NjdjTzA0?=
 =?utf-8?B?c20vdkx6Ly9zWEJNZGtGSjc3R3RGN3pZRktNNFd3Y2I2VHd5Y3AzOFBSbitk?=
 =?utf-8?B?TlduR2U1TW9rN1NrZjd3YitESkZTOVRZalNtekk1Wnl1SjFXaTFka1NMbk45?=
 =?utf-8?B?ZzJ5ci9vaWpSQ2ZKSlkremkrdFZtYVRCQ1RGSEdrRnFNQUlqQlFnQ20ySGFF?=
 =?utf-8?B?QXFkRWdUMm1nNDl2Z3MxbDYxN1hjWnJxcENKOUF6c1RLQ0w1bWtIMnRweGFi?=
 =?utf-8?B?eDF3UkFReUxOUXBBQm5GajJlc1p1YWIyenJ3ZEREWVR2eDd5RW9vaS96bFVZ?=
 =?utf-8?B?YngxcUZNbGV5T1RuemFMVnZlY2RxYUd5ZjVRWUsvTEdhVk5hUlpydGx1SGV3?=
 =?utf-8?B?U3BVRERXN01rSm5sTDdUV0hQZm9adERKSlIwMUM0VkFhc2ViV3lGaW1xTCtY?=
 =?utf-8?B?alZ2Y1VEK0JZY0M2eTZMVFV5aTRVakZOOCtMNXRVd1J5U093enpMcmp4dU0v?=
 =?utf-8?B?bHlSVWpQVE8zRWxnc0o1bTZaREdwTHEzUzhjSGdkSFZpWGVHd1U2bE10OGdR?=
 =?utf-8?B?QlBGR0NGdXlCUDc1ZU1uUElVM3A3SHdJY0QzSWhMUXFXS3hMTlhCd2poNmdR?=
 =?utf-8?B?Sjdxd2lOMmpvSTNVRTJIY3phblNDaUdsWkFtZHJYUkVvNUpGbDVKMlRvb1F0?=
 =?utf-8?B?TXI1cDNBbGY1ZVBYb3IzMndjcFNoOUFDMkhjNHVwdTJvSFhKVnVsQmEyakJi?=
 =?utf-8?B?MDNrWTQ5UGVsaFpOK04rS1VHa0pUNGxJbmtoSXlKbi9JaThuZHA1eW82aXpZ?=
 =?utf-8?B?Nko1bThHaFc2UTVWQmNBUzlQTVF6NGo5UDRGUG9NQU8xcGQ2S0tCc0R6MXJC?=
 =?utf-8?B?aU55TldUL0swYTMyWlJid3pESEVhUEdJYUhaTjkxNWQ0N0hXWWlBNVZiYW8v?=
 =?utf-8?B?MkdwZkVwUkJncFBTZDlNTS9QdWtkczFIYkdaTm9qblFaTWgwNGUzMDlwSC9V?=
 =?utf-8?B?cllDOVF0aFZxUDJZVmRPendtdU5SbFRpT2d6RXRyQW1ENUV4NzVjeDJpcGFR?=
 =?utf-8?B?dVFwNmZIWGttNjNMY3hmbDRTWHdxOTZud0FnSW10QXdPeEQrT2FXTTJSaWh6?=
 =?utf-8?Q?o3lHc0L78H2xhhT1y437EXU=3D?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <EC32D76A4996CA4BBD3648D44500E166@namprd15.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: meta.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SA1PR15MB4854.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 57f885c8-c424-4a43-9135-08dabcd34bd1
X-MS-Exchange-CrossTenant-originalarrivaltime: 02 Nov 2022 13:08:12.2180
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: iCOb2lAcuIMw59sPrHGc6L/P/3tu05mDy4UJ7oiLc86a+WmR5yCq9UY8cRCSeZgt
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW2PR1501MB1961
X-Proofpoint-ORIG-GUID: mIeamR92FrPnZ23fKhcKaAe453Ufgh58
X-Proofpoint-GUID: mIeamR92FrPnZ23fKhcKaAe453Ufgh58
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.895,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-11-02_09,2022-11-02_01,2022-06-22_01
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

T24gV2VkLCAyMDIyLTExLTAyIGF0IDExOjQ0ICswMDAwLCBQYXZlbCBCZWd1bmtvdiB3cm90ZToN
Cj4gT24gMTAvMzEvMjIgMTM6NDEsIER5bGFuIFl1ZGFrZW4gd3JvdGU6DQo+ID4gVGhlcmUgaXMg
YSBwcm9ibGVtIHdpdGggbG9uZyBydW5uaW5nIGlvX3VyaW5nIHJlcXVlc3RzIGFuZCByc3JjDQo+
ID4gbm9kZQ0KPiA+IGNsZWFudXAsIHdoZXJlIGEgc2luZ2xlIGxvbmcgcnVubmluZyByZXF1ZXN0
IGNhbiBibG9jayBjbGVhbnVwIG9mDQo+ID4gYWxsDQo+ID4gc3Vic2VxdWVudCBub2Rlcy4gRm9y
IGV4YW1wbGUgYSBuZXR3b3JrIHNlcnZlciBtYXkgaGF2ZSBib3RoIGxvbmcNCj4gPiBydW5uaW5n
DQo+ID4gYWNjZXB0cyBhbmQgYWxzbyB1c2UgcmVnaXN0ZXJlZCBmaWxlcyBmb3IgY29ubmVjdGlv
bnMuIFdoZW4gc29ja2V0cw0KPiA+IGFyZQ0KPiA+IGNsb3NlZCBhbmQgcmV0dXJuZWQgKGVpdGhl
ciB0aHJvdWdoIGNsb3NlX2RpcmVjdCwgb3IgdGhyb3VnaA0KPiA+IHJlZ2lzdGVyX2ZpbGVzX3Vw
ZGF0ZSkgdGhlIHVuZGVybHlpbmcgZmlsZSB3aWxsIG5vdCBiZSBmcmVlZCB1bnRpbA0KPiA+IHRo
YXQNCj4gPiBvcmlnaW5hbCBhY2NlcHQgY29tcGxldGVzLiBGb3IgdGhlIGNhc2Ugb2YgbXVsdGlz
aG90IHRoaXMgbWF5IGJlDQo+ID4gdGhlDQo+ID4gbGlmZXRpbWUgb2YgdGhlIGFwcGxpY2F0aW9u
LCB3aGljaCB3aWxsIGNhdXNlIGZpbGUgbnVtYmVycyB0byBncm93DQo+ID4gdW5ib3VuZGVkIC0g
cmVzdWx0aW5nIGluIGVpdGhlciBPT01zIG9yIEVORklMRSBlcnJvcnMuDQo+ID4gDQo+ID4gVG8g
Zml4IHRoaXMgSSBwcm9wb3NlIHJldGFyZ2V0aW5nIHRoZSByc3JjIG5vZGVzIGZyb20gb25nb2lu
Zw0KPiA+IHJlcXVlc3RzIHRvDQo+ID4gdGhlIGN1cnJlbnQgbWFpbiByZXF1ZXN0IG9mIHRoZSBp
b191cmluZy4gVGhpcyBvbmx5IG5lZWRzIHRvIGhhcHBlbg0KPiA+IGZvcg0KPiA+IGxvbmcgcnVu
bmluZyByZXF1ZXN0cyB0eXBlcywgYW5kIHNwZWNpZmljYWxseSB0aG9zZSB0aGF0IGhhcHBlbiBh
cw0KPiA+IGENCj4gPiByZXN1bHQgb2Ygc29tZSBleHRlcm5hbCBldmVudC4gRm9yIHRoaXMgcmVh
c29uIEkgZXhjbHVkZSB3cml0ZS9zZW5kDQo+ID4gc3R5bGUNCj4gPiBvcHMgZm9yIHRoZSB0aW1l
IGJlaW5nIGFzIGV2ZW4gdGhvdWdoIHRoZXNlIGNhbiBjYXVzZSB0aGlzIGlzc3VlIGluDQo+ID4g
cmVhbGl0eSBpdCB3b3VsZCBiZSB1bmV4cGVjdGVkIHRvIGhhdmUgYSB3cml0ZSBibG9jayBmb3Ig
aG91cnMuDQo+ID4gVGhpcw0KPiA+IHN1cHBvcnQgY2FuIG9idmlvdXNseSBiZSBhZGRlZCBsYXRl
ciBpZiBuZWVkZWQuDQo+IA0KPiBJcyB0aGVyZSBhIHBhcnRpY3VsYXIgcmVhc29uIHdoeSBpdCB0
cmllcyB0byByZXRhcmdldCBpbnN0ZWFkIG9mDQo+IGRvd25ncmFkaW5nPyBUYWtpbmcgYSBmaWxl
IHJlZiAvIGV0Yy7CoA0KDQpEb3duZ3JhZGluZyBjb3VsZCB3b3JrIC0gYnV0IGl0IGlzIGxlc3Mg
Z2VuZXJhbCBhcyBpdCB3aWxsIG5vdCB3b3JrIGZvcg0KYnVmZmVycyAoYW5kIHdoYXRldmVyIGZ1
dHVyZSByZXNvdXJjZXMgZ2V0IGFkZGVkIHRvIHRoaXMgc3lzdGVtKS4gSWYgaXQNCmNvdWxkIGF2
b2lkIHBlcmlvZGljIHdvcmsgdGhhdCB3b3VsZCBiZSBnb29kIGJ1dCBJIGRvbid0IHJlYWxseSBz
ZWUgaG93DQp0aGF0IHdvdWxkIGhhcHBlbg0KDQo+IHNvdW5kcyBtb3JlIHJvYnVzdCwgZS5nLg0K
PiB3aGF0IGlmIHdlIHNlbmQgYSBsaW5nZXJpbmcgcmVxdWVzdCBhbmQgdGhlbiByZW1vdmUgdGhl
IGZpbGUNCj4gZnJvbSB0aGUgdGFibGU/wqANCg0KVGhpcyB3aWxsIHdvcmsgYXMgdGhlIGZpbGUg
d2lsbCBubyBsb25nZXIgbWF0Y2gsIGFuZCBzbyBjYW5ub3QNCnJldGFyZ2V0LiANCg0KDQo+IEl0
IGFsc28gZG9lc24ndCBuZWVkIGNhY2hpbmcgdGhlIGZpbGUgaW5kZXguDQoNClllYWggdGhhdCB3
b3VsZCBiZSBhIGJpZyBiZW5lZml0LiBQZXJoYXBzIHdlIHNob3VsZCBkbyB0aGF0IGZvciBzb21l
DQpvcHMgKGFjY2VwdC9wb2xsKSBhbmQgcmV0YXJnZXQgZm9yIG90aGVycyB0aGF0IGNhbiBoYXZl
IGZpeGVkIGJ1ZmZlcnM/DQpJdCB3aWxsIG1ha2UgdGhlIGNvZGUgYSBiaXQgc2ltcGxlciB0b28g
Zm9yIHRoZSBzaW1wbGUgb3BzLsKgDQoNClRoYXQgYmVpbmcgc2FpZCByZW1vdmluZyB0aGUgUkVR
X0ZfRklYRURfRklMRSBmbGFnIGZyb20gdGhlIHJlcSBzb3VuZHMNCmxpa2UgaXQgbWlnaHQgYmUg
cHJvYmxlbWF0aWMgYXMgZmxhZ3MgaGFkIGhpc3RvcmljYWxseSBiZWVuIGNvbnN0YW50Pw0KDQo+
IA0KPiANCj4gPiBJbiBvcmRlciB0byByZXRhcmdldCBub2RlcyBhbGwgdGhlIG91dHN0YW5kaW5n
IHJlcXVlc3RzIChpbiBib3RoDQo+ID4gcG9sbA0KPiA+IHRhYmxlcyBhbmQgaW8td3EpIG5lZWQg
dG8gYmUgaXRlcmF0ZWQgYW5kIHRoZSByZXF1ZXN0IG5lZWRzIHRvIGJlDQo+ID4gY2hlY2tlZA0K
PiA+IHRvIG1ha2Ugc3VyZSB0aGUgcmV0YXJnZXRpbmcgaXMgdmFsaWQuIEZvciBleGFtcGxlIGZv
ciBGSVhFRF9GSUxFDQo+ID4gcmVxdWVzdHMNCj4gPiB0aGlzIGludm9sdmVzIGVuc3VyaW5nIHRo
ZSBmaWxlIGlzIHN0aWxsIHJlZmVyZW5jZWQgaW4gdGhlIGN1cnJlbnQNCj4gPiBub2RlLg0KPiA+
IFRoaXMgTyhOKSBvcGVyYXRpb24gc2VlbXMgdG8gdGFrZSB+MW1zIGxvY2FsbHkgZm9yIDMwayBv
dXRzdGFuZGluZw0KPiA+IHJlcXVlc3RzLiBOb3RlIGl0IGxvY2tzIHRoZSBpb191cmluZyB3aGls
ZSBpdCBoYXBwZW5zIGFuZCBzbyBubw0KPiA+IG90aGVyIHdvcmsNCj4gPiBjYW4gb2NjdXIuIElu
IG9yZGVyIHRvIGFtb3J0aXplIHRoaXMgY29zdCBzbGlnaHRseSwgSSBwcm9wb3NlDQo+ID4gcnVu
bmluZyB0aGlzDQo+ID4gb3BlcmF0aW9uIGF0IG1vc3QgZXZlcnkgNjAgc2Vjb25kcy4gSXQgaXMg
aGFyZCBjb2RlZCBjdXJyZW50bHksIGJ1dA0KPiA+IHdvdWxkDQo+ID4gYmUgaGFwcHkgdG8gdGFr
ZSBzdWdnZXN0aW9ucyBpZiB0aGlzIHNob3VsZCBiZSBjdXN0b21pemFibGUgKGFuZA0KPiA+IGhv
dyB0byBkbw0KPiA+IHN1Y2ggYSB0aGluZykuDQo+ID4gDQo+ID4gV2l0aG91dCBjdXN0b21pemFi
bGUgcmV0YXJnZXRpbmcgcGVyaW9kLCBpdCdzIGEgYml0IGRpZmZpY3VsdCB0bw0KPiA+IHN1Ym1p
dA0KPiA+IHRlc3RzIGZvciB0aGlzLiBJIGhhdmUgYSB0ZXN0IGJ1dCBpdCBvYnZpb3VzbHkgdGFr
ZXMgYSBtYW55IG1pbnV0ZXMNCj4gPiB0byBydW4NCj4gPiB3aGljaCBpcyBub3QgZ29pbmcgdG8g
YmUgYWNjZXB0YWJsZSBmb3IgbGlidXJpbmcuDQo+IA0KPiBXZSBtYXkgYWxzbyB3YW50IHRvIHRy
aWdnZXIgaXQgaWYgdGhlcmUgYXJlIHRvbyBtYW55IHJzcmMgbm9kZXMNCj4gcXVldWVkDQoNCklu
IG15IHRlc3RpbmcgdGhpcyBoYXNuJ3QgcmVhbGx5IGJlZW4gbmVjZXNzYXJ5IGFzIHRoZSBpbmRp
dmlkdWFsIG5vZGVzDQpkbyBub3QgdGFrZSB1cCB0b28gbXVjaCBzcGFjZS4gQnV0IEkgYW0gaGFw
cHkgdG8gYWRkIHRoaXMgaWYgeW91IHRoaW5rDQppdCB3aWxsIGhlbHAuDQoNCg0KQWxzbyAtIHRo
YW5rcyBmb3IgdGhlIHBhdGNoIHJldmlld3MsIHdpbGwgZ2V0IHRob3NlIGludG8gYSB2MiBvbmNl
IHRoZQ0KZ2VuZXJhbCBhcHByb2FjaCBpcyBpcm9uZWQgb3V0Lg0KDQpEeWxhbg0KDQo=
