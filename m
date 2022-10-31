Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B6810613B9A
	for <lists+io-uring@lfdr.de>; Mon, 31 Oct 2022 17:45:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230234AbiJaQp5 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 31 Oct 2022 12:45:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39240 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230000AbiJaQp4 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 31 Oct 2022 12:45:56 -0400
Received: from mx0a-00082601.pphosted.com (mx0a-00082601.pphosted.com [67.231.145.42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2EE79E001
        for <io-uring@vger.kernel.org>; Mon, 31 Oct 2022 09:45:56 -0700 (PDT)
Received: from pps.filterd (m0044010.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 29VDG9Pb019303
        for <io-uring@vger.kernel.org>; Mon, 31 Oct 2022 09:45:55 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=meta.com; h=from : to : cc :
 subject : date : message-id : references : in-reply-to : content-type :
 content-id : content-transfer-encoding : mime-version; s=s2048-2021-q4;
 bh=gI/32HVTlCyzTII9usAXRX0roGxbAk6JD4YIhu6emWM=;
 b=FhoKeliADr2SdWV8r9ZRkVzvDUzVXx7AOCKbH4m/Kfi4Ppa9535V/2RM9pyrft17pcKP
 YhpPkoW35zmG8SkMCC4+NOprSRb6CQrT8QBSmEkukNcEV1VeYJ42v8kdQLpc3m1kaT6H
 jTGTxtDGxaEPGMujjxC1sWfYd+n3kvKmk5cQl+J4i/UroS997pkAgmjdiLxvDxO2EyiZ
 uy+Ka0XvxbibHlQ/ThsyApXXtVWyUhV7qT8V4R4MSyCwJZ3NzX4E1mbDgPa0i9k6g0vJ
 bIiDPbwWWSNipjBfH0TpqNRWeOhTyuEWIit0MlNi7Q/y6it0ZG+2wg0WTMrVphqOEacv JA== 
Received: from nam10-bn7-obe.outbound.protection.outlook.com (mail-bn7nam10lp2102.outbound.protection.outlook.com [104.47.70.102])
        by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 3kgygu8mhv-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <io-uring@vger.kernel.org>; Mon, 31 Oct 2022 09:45:55 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=bjZBPLy2aIes9GZnRgyGjD8n4j0ZZSjk95OjgU7dOwRXVnHWhJTbNdoQDk3btC3odXqTDwjugyOhcB+wyoohViGALmyu2UzBCYjSg2E2N8Qfk3K29AXF/bpDJ7dxwvgTgyEJAu/iz0bVGQWAfcROjkdUwePhIEQL/k+S07EhoMh/Z4dfY2qj6mIhtb7XSqchU3YQ7PiWHY+SdjEdV7exwnS0UsprL8ad+zDF25i3cSTXOJLmdyM22q2SXJOFoAkOAVHbpjm8RI2EJ2m+A6xPrz+m4ZmUadX/ML562iN07Mzm+RQDSpsmPAyexHlRiUquJErwaWkPveekVzdowiZmMw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=gI/32HVTlCyzTII9usAXRX0roGxbAk6JD4YIhu6emWM=;
 b=Ots8GC/q+cV9XKSqGkcQRcGwouwBjhddGckMuIJ0IciMRdlLRqBupMFXQ6uYfz6HUd7DrHE0Z428HnsB4HVG1SFGELT5/pcJJtw5nJMia9iBHVNDnOcHWWxiQW0xgeBzwkB7UTK7wio/HCNGf9JvVqpsRrjHaNmzEjN5UJvJJZYoQrSkh5+MqK8ot8FNOoAtohQK3ips6uW6/vf5II6A7VlRJnCKmswWpOO1ypNJOLUJRUdznWxxsxYqABsUUeFkGgKiKAY4obK3giDAc4j9X+93cr2Z3hA/6zsKxpZibLW3Gm9CcAMaOBjyZLifppQhVjwpuXdl2Z+ovoTarABMLw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=meta.com; dmarc=pass action=none header.from=meta.com;
 dkim=pass header.d=meta.com; arc=none
Received: from SA1PR15MB4854.namprd15.prod.outlook.com (2603:10b6:806:1e1::19)
 by BN7PR15MB2257.namprd15.prod.outlook.com (2603:10b6:406:87::32) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5769.15; Mon, 31 Oct
 2022 16:45:51 +0000
Received: from SA1PR15MB4854.namprd15.prod.outlook.com
 ([fe80::1b85:7a88:90a4:572a]) by SA1PR15MB4854.namprd15.prod.outlook.com
 ([fe80::1b85:7a88:90a4:572a%6]) with mapi id 15.20.5769.019; Mon, 31 Oct 2022
 16:45:51 +0000
From:   Dylan Yudaken <dylany@meta.com>
To:     Dylan Yudaken <dylany@meta.com>,
        "axboe@kernel.dk" <axboe@kernel.dk>,
        "asml.silence@gmail.com" <asml.silence@gmail.com>
CC:     Kernel Team <Kernel-team@fb.com>,
        "io-uring@vger.kernel.org" <io-uring@vger.kernel.org>
Subject: Re: [PATCH for-next 01/12] io_uring: infrastructure for retargeting
 rsrc nodes
Thread-Topic: [PATCH for-next 01/12] io_uring: infrastructure for retargeting
 rsrc nodes
Thread-Index: AQHY7S6I7Nw2KzgD3ki7rcI48+nheq4oqgUAgAAMFQA=
Date:   Mon, 31 Oct 2022 16:45:51 +0000
Message-ID: <a7c41b4e2c38bf33cd80254b57a6a1034c57ad9a.camel@fb.com>
References: <20221031134126.82928-1-dylany@meta.com>
         <20221031134126.82928-2-dylany@meta.com>
         <987d3d6b-7ea6-4fca-0688-060507706777@kernel.dk>
In-Reply-To: <987d3d6b-7ea6-4fca-0688-060507706777@kernel.dk>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: SA1PR15MB4854:EE_|BN7PR15MB2257:EE_
x-ms-office365-filtering-correlation-id: 239e3b3b-de8b-4b8a-9bf4-08dabb5f5ec6
x-fb-source: Internal
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: dAlFsITUkfhWK6cacgDO/2yYlml0qrfAAKHigO+trSw3cAxvkdaDlGRdsJM3LUL5nqvjCXdcqBCaePCTmUtfavNEGKZcVpotwzn+Fq+PsNeCo3/ACk2+O61eXvzo5thHUoStXgi9ulBCuPZ3GrAIn+J5F2QWubIVkmcj3BL1JC8+/BKvzHa6A+pfsCjCJW62fcOFENWGUuhyu582tZhOxI5hblMFeLeWwpSqmSZYIiAATNggXLmslBgYJRj/xDJeaxq/IPaxsRBCqkIPb9E0awm0M2iJfC4SIme+JAitSS78Skx5NbR7wilcv6zx8Xy/TUphSOBHHO/+avBDyEVA4R/DkfJxTgJPYZrqfECQMtlnMyFqzo7zc/ElZfp2nUPDXPKn7db9qhPrgVcoZuYbflCazIz0PpuaEyZwVda3FWkI6/FRgOEXjQvEodV85ItcWRFghwaOWzICYh/vDzXeH5drXv1BWoN4+L6qtpxkGxvUY0U50wWVPP9E7YlUf5D/G4ZXXZuJvvaj8UuLgeEdH+NXuQmFzu4jwdFvQjmGG0UGB/waPKINw7P5O6ROvBkoNBnaFToLpqpk8l+v+R1hJFax/q5xkhBt0XJSIhK8OKXNoGPZU+h2exaNYn1/jRe/CNDv3lyPPLTqKoWflGQZB67Z3yz+MTDdik8f5Ls7F1+Y8IToC6Mdcx70aFKBX65bGuW5eBNXAoV2gSkJhiwfLIJPmChWT4n7Dzgys24xVGdqzRD1YqJszXmPxmvDBNey+F8Bjb1wpGtr5jnNLBdtig==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR15MB4854.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(346002)(136003)(396003)(376002)(39860400002)(366004)(451199015)(4744005)(6486002)(2906002)(71200400001)(4001150100001)(122000001)(83380400001)(36756003)(38070700005)(86362001)(38100700002)(9686003)(53546011)(6512007)(186003)(91956017)(8676002)(64756008)(316002)(478600001)(66946007)(66446008)(76116006)(6506007)(41300700001)(66556008)(66476007)(4326008)(8936002)(110136005)(54906003)(5660300002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?UU9ZbURkMmVsdXVlSWRTVUNtdTNIZVBUVEJsZVRCS09ndGVoM0U2UzMwcnVW?=
 =?utf-8?B?Mk1wM09jaHQ3WGVjeHRaenJiMEVnS25kbmd0NGVNTGpYLzhESzBPVWh5Tnh4?=
 =?utf-8?B?SVlzcUxLUy83cnVGZDdXakxXU1FlNmkzaHdVcExaZUFOZDVNOHluVXZPdW1i?=
 =?utf-8?B?WEhTdWJxYXNoSnVEZXY0UVB1cm5YZmRzRXl0SDRHUXptMGlNL3VsKzZjSWtF?=
 =?utf-8?B?RGF5RGJOQzJNd016WXNTTTNxNUlIR2NuS3hGdUxuQkQxYXVhbTJabmFZNEFh?=
 =?utf-8?B?ZnNyUkVJeE1tOUNpU0lHQ1Rjejk1Ym9OcTRoemprV0hIdWpGblpxUVdDMGc3?=
 =?utf-8?B?b2wxVDJ6WlJiRFZIbEhJWU05L1AyVnRQeFFZc0Z5N2pxeDAvd0xhdVdkb2ps?=
 =?utf-8?B?d0FoVzZsZHlhaFhIZDhOS0dMd01RZDg4d2JjTTR6cWtBTm1sN3NOUU04cVdV?=
 =?utf-8?B?cXg0RWxsSldwckhnNXhaekVCOXBDUVpNaDlNT0xHTk16MXowUS8zVmdLS3Zx?=
 =?utf-8?B?WTNxemdacE5oOHZwQmlGaUw4U2kra0pUZ0NDYzlUNHZNSDFiRkVNSlppcDRp?=
 =?utf-8?B?UUtnclg5M3hTUHh0Qko5TlZZc1o0TWM3SkFrWWRUWFFyaUJoRnJVeGJCRW15?=
 =?utf-8?B?K0x3SzBLOWg3T1o3VDRrZ203Z3RFeitpek1URE41R1BRSElBRkhYM2ZYU21z?=
 =?utf-8?B?QUJUbzJEUVZPRDFhQ3A3cHFURVF3aXR2bnRITTdSb3EwenkwT0JLcVpTd0Ev?=
 =?utf-8?B?Z20yaDVoQXJ4NFVBN3kxMDU3MjZXZ3hQS0Z4eW9kZXlpd1hqbHBXcXJjbHdD?=
 =?utf-8?B?eUYxS0JHbzU0ZlR5WXdIU0dFa25OT2ZaU2RkcnlPdjJxNitiTEMyRk1Hd3Vp?=
 =?utf-8?B?VGprWmdrcS9nSjZoZE5rN0VTVFdYNUVtSWJZYmNiMlJKWmIrVGZTTHRTbXp3?=
 =?utf-8?B?Z1UyUmdmTDAxbExLZ2Y0WHZydlJJYlpVQno3K3FPVjZNaVdrOWp4VlRjbWVV?=
 =?utf-8?B?akFMeGpnQ0JDeWVqaEJhelNhOVFabW5rYjV3QVVPSER0WVBFSzk3RTBtZTV2?=
 =?utf-8?B?OUNaTWo3Rm1oRDh2cjVud2ZEZ1Jad1FWR2k3WmJQTmdNUjRLVm9LRzJVM3Fx?=
 =?utf-8?B?UkRqaDg0YkNyRXo0VUp1Q3hEa2czQ21TZitUcHl2Q3YzMUtzejBSWnZRQWUy?=
 =?utf-8?B?VkVMZDd2ekNhMFNia3FxVXd1aTBPZTlwNW4waWd1VjVoNnROd2FvR2ptcGJm?=
 =?utf-8?B?NTVodkRGRnBhVERVbllwVWZvYUJwRUFHVmU4YXgxY1RQZXIxUHJzTXdCV3VU?=
 =?utf-8?B?T24yWTl5SDRIdDVxcWdiM0J5OFpKcUp4S1Npd1hvNjV6ZkxzR0FDOGpFRm1m?=
 =?utf-8?B?eHlPS1ZqSDBtRmVIMmgvVkt0NkxySm5MMHprSDhFakV0TDVwa3RYbTlrMDdV?=
 =?utf-8?B?U2tFSzg2K0dlTjgvL1VCdEI4OUI1dlN5SGUreklLMkFkYndvTW1Pb3lrV0o2?=
 =?utf-8?B?THBnR0tpYldROHlFNkRKRlFPUS92cW1MNW9EMGU5RHZPTHc2L1B3UjBLNFRa?=
 =?utf-8?B?OTBGK0NlcHlHbVJ2WW9hcjhXT2F5RVB6dWNtbVBNczByQUpOZDNqQXVFc0xk?=
 =?utf-8?B?dmV0TXBEUzVOa0hZOFRDN0h6R1lwRDhJdG1mMG90VjFuNUpwTmRpb3lIcDF5?=
 =?utf-8?B?N3pab2JkcDVScEMrbWpSVnMweWw2eE13NUdzaTlIN3FQOE9aYlhmekViVWNB?=
 =?utf-8?B?WHEwbVV5eUZUNlArc3d2dVBuMlRoZHNCWUFYUlA2cFpVQ093SFVHbUxpc2E0?=
 =?utf-8?B?T1g5RGRJZzgxR0pxYThZMzdZM1p1TkRaWXdxcFFhdFUyZ0d1dHdFZmNDaktr?=
 =?utf-8?B?K2ljRE5Rd285akJHVG0yZSsvNlhTeDZSdm41SGtvM1FLbzBGTnZoMXQ2VXk4?=
 =?utf-8?B?WUpJNjJ5VHhibGxDNDc3SGdqY0I3TWJXUEl6Zm81UTAxeC9obkRXZGtocVhZ?=
 =?utf-8?B?S09HUzNLeEphUzIxakJCSGo0OTVPUXl1S3MzOUhHNi9xMEVJcisyYWwxWFlY?=
 =?utf-8?B?WW5Pc0xhYTh3RUpTekRMb0wvUnVOYll5VGl0aS9CS1hHVU5xYm82NzRlalZH?=
 =?utf-8?B?TWlUWmZsQmJEWmpiQUpzM3dEdkNyQTh6TzZxYTRHT0Zhd0d3OHErNzlxbFl3?=
 =?utf-8?Q?tvpOVBZw+0RBJlaF1BC7T8k=3D?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <607B5A9DA7B88C448AFC47E25218BE33@namprd15.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: meta.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SA1PR15MB4854.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 239e3b3b-de8b-4b8a-9bf4-08dabb5f5ec6
X-MS-Exchange-CrossTenant-originalarrivaltime: 31 Oct 2022 16:45:51.2239
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: PriHLY8daHvBb6hWQyvGQmz5isMMjz80DQuBDf0oW6T50j5jWqs4eGe9eMZAZ9km
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN7PR15MB2257
X-Proofpoint-ORIG-GUID: AC0aC7Xz-5YzbdZzHbkipHhmmLfNrgVC
X-Proofpoint-GUID: AC0aC7Xz-5YzbdZzHbkipHhmmLfNrgVC
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

T24gTW9uLCAyMDIyLTEwLTMxIGF0IDEwOjAyIC0wNjAwLCBKZW5zIEF4Ym9lIHdyb3RlOg0KPiBP
biAxMC8zMS8yMiA3OjQxIEFNLCBEeWxhbiBZdWRha2VuIHdyb3RlOg0KPiA+ICtzdGF0aWMgdm9p
ZCBpb19yc3JjX3JldGFyZ2V0X3NjaGVkdWxlKHN0cnVjdCBpb19yaW5nX2N0eCAqY3R4KQ0KPiA+
ICvCoMKgwqDCoMKgwqDCoF9fbXVzdF9ob2xkKCZjdHgtPnVyaW5nX2xvY2spDQo+ID4gK3sNCj4g
PiArwqDCoMKgwqDCoMKgwqBwZXJjcHVfcmVmX2dldCgmY3R4LT5yZWZzKTsNCj4gPiArwqDCoMKg
wqDCoMKgwqBtb2RfZGVsYXllZF93b3JrKHN5c3RlbV93cSwgJmN0eC0+cnNyY19yZXRhcmdldF93
b3JrLCA2MCAqDQo+ID4gSFopOw0KPiA+ICvCoMKgwqDCoMKgwqDCoGN0eC0+cnNyY19yZXRhcmdl
dF9zY2hlZHVsZWQgPSB0cnVlOw0KPiA+ICt9DQo+IA0KPiBDYW4gdGhpcyBldmVyIGJlIGNhbGxl
ZCB3aXRoIHJzcmNfcmV0YXJnZXRfd29yayBhbHJlYWR5IHBlbmRpbmc/IElmDQo+IHNvLA0KPiB0
aGF0IHdvdWxkIHNlZW0gdG8gbGVhayBhIGN0eCByZWYuDQo+IA0KDQpOb3QgaW4gdGhpcyBwYXRj
aC4NCkluIHRoZSBsYXRlciBwYXRjaCBpdCBjYW4gKGJ1dCBvbmx5IG9uIHNodXRkb3duKSBhbmQg
aXQgY2hlY2tzIGZvciBpdC4NCg==
