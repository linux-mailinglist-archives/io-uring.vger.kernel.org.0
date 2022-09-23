Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A4C065E7D1B
	for <lists+io-uring@lfdr.de>; Fri, 23 Sep 2022 16:32:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230074AbiIWOcT (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 23 Sep 2022 10:32:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45814 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232234AbiIWOcI (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 23 Sep 2022 10:32:08 -0400
Received: from mx0b-00082601.pphosted.com (mx0b-00082601.pphosted.com [67.231.153.30])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 997371406CC
        for <io-uring@vger.kernel.org>; Fri, 23 Sep 2022 07:32:07 -0700 (PDT)
Received: from pps.filterd (m0148460.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 28NAkkwQ000611
        for <io-uring@vger.kernel.org>; Fri, 23 Sep 2022 07:32:06 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : references : in-reply-to : content-type : content-id
 : content-transfer-encoding : mime-version; s=facebook;
 bh=rODqFlO+rQuNxGlJPiIEOBakQxS/XTjXp2EzonIP7Og=;
 b=q9mhQ1/aAIDIQWeI+wAsT74bsPilFVPXpf/YZgRxvBVjcIYncZHO0Nq6/Z9J6PgLnz8n
 Ys2ExH3xGlLFw9bK2xusZIksb7aHKaasGJcC/fQ30lvibbA29QgmzUr10OjMmmN6aFj0
 F5QxEpt7SjnNIkmzb9BJxsoXEA+xrUXRAt4= 
Received: from nam11-co1-obe.outbound.protection.outlook.com (mail-co1nam11lp2175.outbound.protection.outlook.com [104.47.56.175])
        by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 3jr18hstsp-3
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <io-uring@vger.kernel.org>; Fri, 23 Sep 2022 07:32:06 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=FOG9fV1cyE+9WJxwaP4Dl6cSjxjkYYBLlQ8GcrnyGUt07AjIy31W9fyNyjXgU0+lRFOOylU9A5frYN4XsOPIjaL3q01aTnC41CYsCDuZL8WgdlmJdcZK+QnkHS59JPser0/nFSzUxJQxtyITurH2wFgdXdl/1Yt19trAe+NHMsHp8Lk4pGyxQ1c+46RHGL1g1J8OZWdMFF+weAShQMBvfhhSzTTSXaj/EtNzw6/l8ZvzTCzDZBBxz575KCwci3obmkRY0cqI+Wp5wuCnvPniCUt0e1/eXOKoFVlIshJpruzSkhmcH/EXmCsyAOyP0fUJ5QCtsJy/Gs4dBq1vHQdKxA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=rODqFlO+rQuNxGlJPiIEOBakQxS/XTjXp2EzonIP7Og=;
 b=QJwd6xhF3ef+vPi3bX5xZ2cwDSzzKdao34uBd7hmADr3b5yMXClZlwaG6o4Da22rsUuSJNiUsbDKdotvKdsmEajpko9oIcc8fFyy+N/EHyWe8NdVUKKe3jtWR9RBpxOarDSfu0WhL39ZgxQ5a1an6H4rHSLW/oVrl8wHuT0jWXNwX5l51Dxa/k4rbbaR3UXPo4QntDwijd5nc1PdQ4yX8I5QX+g4bVkYTlFlmQRM7fXJeOxD2dQ7byckUGKihCPHDCblXL7xRsf3IsvdJDn1HgbCJawWjFVovKrxkcmCy8UYsf7zu1mdP9mbZ0sMx+0I8KrEWlh7lGTa3g4W0Ui31A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
Received: from SA1PR15MB4854.namprd15.prod.outlook.com (2603:10b6:806:1e1::19)
 by SA1PR15MB4484.namprd15.prod.outlook.com (2603:10b6:806:197::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5654.20; Fri, 23 Sep
 2022 14:32:03 +0000
Received: from SA1PR15MB4854.namprd15.prod.outlook.com
 ([fe80::411e:21ef:d04f:9c68]) by SA1PR15MB4854.namprd15.prod.outlook.com
 ([fe80::411e:21ef:d04f:9c68%8]) with mapi id 15.20.5654.020; Fri, 23 Sep 2022
 14:32:03 +0000
From:   Dylan Yudaken <dylany@fb.com>
To:     "asml.silence@gmail.com" <asml.silence@gmail.com>,
        "io-uring@vger.kernel.org" <io-uring@vger.kernel.org>
CC:     "axboe@kernel.dk" <axboe@kernel.dk>
Subject: Re: [PATCH for-next] io_uring: fix CQE reordering
Thread-Topic: [PATCH for-next] io_uring: fix CQE reordering
Thread-Index: AQHYz1Q0t7Zeqn+K6EGNYfMgTSMJ1K3tE9OA
Date:   Fri, 23 Sep 2022 14:32:02 +0000
Message-ID: <2815cf233c3171204823eda9a18f7c67894b7db9.camel@fb.com>
References: <ec3bc55687b0768bbe20fb62d7d06cfced7d7e70.1663892031.git.asml.silence@gmail.com>
In-Reply-To: <ec3bc55687b0768bbe20fb62d7d06cfced7d7e70.1663892031.git.asml.silence@gmail.com>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: SA1PR15MB4854:EE_|SA1PR15MB4484:EE_
x-ms-office365-filtering-correlation-id: 879a769e-2753-4070-2975-08da9d7061db
x-fb-source: Internal
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: buc8LO+t1pXGdoVlVaQRO2WSPNayuv44BlBR+2P7oGh1eXY0HYkjSdlDoux9g+JHadYmGDrMLBEDPbpr78AKafQV7OVzcFyOLYIOKAwrd5edFhE9Alb/DJ4gSrRWAtqTeGRKXWGj8Q3vrU75AofgTce9WurCUwoIO8DulpjPDGgaqt9YKrnLBllL97ponfu/LwvYWmRcVnFFqrLihRQlNLOWwnceAOkiH3RTa04EGEye/ygJbsmEXW1H+T2eqfglB2IIpo4GutitcLuaItVNh/hPGPb/UpHfJi0KCAOe1qbIH9VAJzW2eHQWv4KRo8tp1Uun8eV5wM0WNm18o27YMv1SSHsiDFZKX1tnDEXvG06uyCVlWURGGvW4K83xZ8mG0UbKauUqcJ8nNotYyA0Y2j+UJNMc6I40cn0/PRGi8gaxaAP7DjcmBCpyP/ihow0WKfQTIF6tbId5BviU1rtc+Xz/ahnbl83D2ysJqDRrHJK/9yOaObVopGVoSFPtbPVIoSC7PfJy0xWFE2HxTnp0tULUiWGTsKfZ/jyWCYRpbx0am+yiY5NRGNswCpaWFlzgacEXq35ALlXG4v77dZ6ApWbWgSlXIp8uch1JBFdSwDk4WpvIunysGN8n2fe5hHmd40Vjyu8pUxv95IMkxa1bGfNjfSzWVW33JEY+8pHUFXA1YwnETVXd/GwpsVG/BUWXssVNzT1WN1ujkjKbe2yCKQXo2lvzsj3Xdqbjw5TI5JvfpmpXhP/T/w+3B4vXd9j1bUUWoeFD+TSC3+KL1qbRlQ==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR15MB4854.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(39860400002)(366004)(396003)(376002)(346002)(136003)(451199015)(91956017)(2616005)(110136005)(71200400001)(8676002)(4326008)(186003)(41300700001)(38070700005)(76116006)(66556008)(86362001)(64756008)(66446008)(66476007)(36756003)(4744005)(66946007)(38100700002)(6506007)(5660300002)(478600001)(122000001)(6486002)(8936002)(83380400001)(316002)(6512007)(2906002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?UndNRWF2cG1IV0JQWW52Qy8vdlM4di9XSCszV2RTaGdjdm95SVdDaytrMXVu?=
 =?utf-8?B?WmZBRTBwMUMvR0YzQUp4elBROCsrQlg3KzU5SHEyUEVRMysxQ2cxZXRoVStx?=
 =?utf-8?B?Rm1kVVRBemowSGI3STdZSnAxbWpXcGMvWnRMWXhiYzFkQkNlS0xuUnJHbW9F?=
 =?utf-8?B?RElVM1lYZ3FHdXFVSVhUK3dkaEdRZEIxbUc3Tm93ZG13TFZFWDNpN0pjTis1?=
 =?utf-8?B?T3lwak1RYmdYZ043Mzd0TEZKVVczUERjZ2lobEkyWEZtR25XK3FuZGJIU3JF?=
 =?utf-8?B?cDQ2WEV0aWIxa2gybS9SVzdtWWgvcUFOclRkakxPbW1CQWtsR0FvdDhnRjlF?=
 =?utf-8?B?dFJ1a0doVm9DYmtQWm1vdnQ1WTRIR25Lak9RYjA2Qi9pdDU5NENVNGFVWnN4?=
 =?utf-8?B?dFBadk9nZWRMdEkwdWQvMkNhTjA4ZXBzVDY3NUkzMFZBVUNrRVZwVExONHNR?=
 =?utf-8?B?SUN0MFlwbFJhaE9VMU5vMlFSU1dFYk1qK3dTQ2dQaXp0elU4Tm45MXdxUHk3?=
 =?utf-8?B?T2tTcUNsbG05ZWlwd0F4QjdGWkp5VGtVTlhSU1M2VlZ2Yk90QUZ4SkpvRWpR?=
 =?utf-8?B?ak1BYmhMUC9xVklOaStNYnN1aFlJTFdzUnViU2g2YW1GZzJiYWR2cmY4RUF4?=
 =?utf-8?B?bXBHRGRyUElUMHkvNHBUOTNMM0VMR0NEY0R6NStydE51YitHT3dGcmFlSjU0?=
 =?utf-8?B?TUxPaU1XS1kxdGJ1MDZ5M0dpSkVIU0FVYXZDaW1zU0V5QVhmWkVmanRHNk5S?=
 =?utf-8?B?TkR0YUR3bDJ0TUlSRlMzZ1VRRVpkT0Q2M2Q1cEQ1VlcrNzdjay9kd092dXN1?=
 =?utf-8?B?M29Ud015ZjNmZElSQmxEVzJobnhwcXRrK1Q4bjRYMEdhdlQ1ajBWaXdjaWFl?=
 =?utf-8?B?Qk9KNDVoZlRhUWhmbjFBa3dVTnBEV3Uva0VIdUgxU2x5Y25JSDhDbC9ocXhx?=
 =?utf-8?B?MWZReitqSXI0TGJkYmVyVFNFRTVUVEFtY1dxSWYxSUxIL1lwcFZleEZOek05?=
 =?utf-8?B?REgveTFONEtpS1BMYWpscG8vdkpvdjhtY2NjZ3VPNUR4V2JyTjRJNVMvWTFO?=
 =?utf-8?B?cnhaWDg3MnY2V1dKQkg3RldodjJRWWJYbkx0SS9rZHlsRVdmTTlPcDdNL3Np?=
 =?utf-8?B?ajhOSUx1OE5RWXg0R2NGTEk4d2lRdEd4amhmb1RaNU5wbFA1djVRQmlUN0xJ?=
 =?utf-8?B?S00yS1E2ejVvNURFQjVjakhKZE5Ib01NL2tIR1lMbkErN09BVHZ2aDNscmFG?=
 =?utf-8?B?RWV0dDZzOW52eUUwS0Q5ZUNDQkd5WXZ0ejNHZEQvS2M3b1lvM2NnWVhOeHVC?=
 =?utf-8?B?a1gvUittdE1xMTJZSE1WUmZPVnVJbkZHVjBaWWVHZ3pacUVZbGs0OHdobjEz?=
 =?utf-8?B?QldRTFNiMFlGa3VvTmhuZ3RGUTNvMytUaVVkUE5ldUFHL0laeGl6RUV6NTlV?=
 =?utf-8?B?VjRyTmJhaGk0VEIzamFleVQ2QmR0aURSRWFrRkFDRFp2TDVtNjJCZ1NNTjk3?=
 =?utf-8?B?Y0s3TmdKT1dNdndYOGRvbEpqaFNoS3l1Zi9PWFJGSzUvRFVMUFRDNXlwcHdJ?=
 =?utf-8?B?ZlFrSkR6ZUUvN0libVdORFMyM0IxQU1wYkdzV1BmbXVESk1KZ2N0SlNMYmpk?=
 =?utf-8?B?OEtWcytXUnhaVGVlR2t3Q3VpZm1lQWZGdG8vcVhERk16R3hQZHRCL09sWWd2?=
 =?utf-8?B?UEkvMGd6WEdSUW1OTkRjL2xaN2o2OTNlYjRlRUNld1Zrb0pxODJDWk9ZcFZK?=
 =?utf-8?B?cTdzVFJ2ZGhJdElhS25WVjNJRlV6aGw5SElyNjk0R1lOWTFvdXZybGNGUzVk?=
 =?utf-8?B?Wm5VNW9VYk80U2pKQnhCTzFBdDVqaldjODNEaWljdlRsZXdpS1c5Y3R6MmUr?=
 =?utf-8?B?OVJtdHhUK0kydUMvdXVRTGVLalNwbjd2UjV1eSs5V2xZamo1VFlGUFNaK0hO?=
 =?utf-8?B?UGxTOWpaTjFIZ2FtOHZlemxYem5iTkxma3lNcEs5MElxQ0RpcDBETEY5eHBx?=
 =?utf-8?B?RWt1U05Da09xUTZvL01qWWFnOGtPWWZwT3BRM3RRQWpYRnE1bUdrVjhWMko3?=
 =?utf-8?B?ajc5aFFLektucmdDbUdqZ0pGNVdMdUpXOC9vMG1RRDVVY0NtRFI4Zk1ScCsv?=
 =?utf-8?B?Wk5NQXIwcGhPbTgxeG1qSXVleVAvb1FuTDhmTTl1YjRsMVRzZUtkbitNTmY2?=
 =?utf-8?B?emc9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <A68231716F756648BAF97FE247318217@namprd15.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: fb.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SA1PR15MB4854.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 879a769e-2753-4070-2975-08da9d7061db
X-MS-Exchange-CrossTenant-originalarrivaltime: 23 Sep 2022 14:32:02.9841
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: W6vbhy78WOfuxDHp+Ngj64a3korbYOzBCV16OYvYnmR0Cbhmf2RPuUj52Zdo5gc7
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR15MB4484
X-Proofpoint-ORIG-GUID: BB_ndPdJ6prbik_KKY2iN_uKUsZ2Wnu9
X-Proofpoint-GUID: BB_ndPdJ6prbik_KKY2iN_uKUsZ2Wnu9
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.895,Hydra:6.0.528,FMLib:17.11.122.1
 definitions=2022-09-23_04,2022-09-22_02,2022-06-22_01
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

T24gRnJpLCAyMDIyLTA5LTIzIGF0IDE0OjUzICswMTAwLCBQYXZlbCBCZWd1bmtvdiB3cm90ZToN
Cj4gT3ZlcmZsb3dpbmcgQ1FFcyBtYXkgcmVzdWx0IGluIHJlb3JkZWluZywgd2hpY2ggaXMgYnVn
Z3kgaW4gY2FzZSBvZg0KPiBsaW5rcywgRl9NT1JFIGFuZCBzby4NCj4gDQoNCk1heWJlIHRoZSBj
b21taXQgbWVzc2FnZSBnb3QgY3V0IG9mZj8NCg0KDQpJIHRoaW5rIHRoaXMgaXMgcHJvYmFibHkg
b2ssIHRoZSBkb3duc2lkZSBiZWluZyB0aGF0IENRRSdzIHdpdGggbm8NCm9yZGVyaW5nIGNvbnN0
cmFpbnRzIHdpbGwgaGF2ZSBvcmRlcmluZyBmb3JjZWQgb24gdGhlbS7CoEFuIGFsdGVybmF0aXZl
DQp3b3VsZCBiZSBmb3IgZWFjaCBjYXNlIChlZyBsaW5rZWQsIHplcm9jb3B5LCBtdWx0aXNob3Qp
IHRvIGVpdGhlciBwYXVzZQ0Kb3IgZm9yY2UgQ1FFJ3MgdG8gYmUgb3ZlcmZsb3cgb25lcy4gVGhp
cyB3b3VsZG50IHNsb3cgZG93biB0aGUgb3RoZXINCmNvZGVwYXRocy4gSSBkb24ndCBoYXZlIGFu
IGlkZWEgZm9yIGhvdyBkaWZmaWN1bHQgdGhpcyBtaWdodCBiZS4NCg0KQnkgdGhlIHdheSwgaWYg
eW91IGRvIGdvIHdpdGggdGhpcyBhcHByb2FjaCB0aGVuIEkgYmVsaWV2ZSB5b3UgY2FuDQpyZXZl
cnQgdGhlc2UgcGF0Y2hlczoNCmEyZGE2NzYzNzZmZSAoImlvX3VyaW5nOiBmaXggbXVsdGlzaG90
IHBvbGwgb24gb3ZlcmZsb3ciKQ0KY2JkMjU3NDg1NDVjICgiaW9fdXJpbmc6IGZpeCBtdWx0aXNo
b3QgYWNjZXB0IG9yZGVyaW5nIikNCg0KYW5kIGRvIHNvbWV0aGluZyBzaW1pbGFyIGZvciBtdWx0
aXNob3QgcmVjZWl2ZS4NCg0KDQpEeWxhbg0K
