Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B7B514B1492
	for <lists+io-uring@lfdr.de>; Thu, 10 Feb 2022 18:50:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245322AbiBJRt7 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 10 Feb 2022 12:49:59 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:53036 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245319AbiBJRt5 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 10 Feb 2022 12:49:57 -0500
Received: from NAM02-DM3-obe.outbound.protection.outlook.com (mail-dm3nam07on2048.outbound.protection.outlook.com [40.107.95.48])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2ED4A10EA;
        Thu, 10 Feb 2022 09:49:58 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Tcb4qCkEgDmV09uREvl9tFSE8tkL8mwctFYsbZ1A3OqW0L0WEnBMWHxmT/qKrsqd+SscLP8m/g0SqvB6C6Es5urDh0jESyw/byqSmd7T7R9TnlvyCbmU2mHQ47xooJ6DX6kFPcAhvej5clt6Q/FCmMe3D4Ph07YGP0o66Y8YgBlw8nzqSsluAI4f0AWgFddbIOfDs5drUSVqgLZW3qG7kAUnTUKJMABtcjVxQgie1uBrLMZMKgnObKyME7P7TXnxj6Af/WK80q0qQy5dqlg/sCgsADoravmufCpXZ4U0c4PoA6ho+KV2GqbMCVpQPGpIZg9tKUPKMHGjuiNic+mubA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Ijlw5IsvCSStvxyAh51LhZSDHe2KNbEVAE+j1kKoPeY=;
 b=ng0+r8KwS/bOET/gznsRnDu7ELzLSc/rGMfHS57Qxh3ikCzr+//A/lI7hGEBCYml+lumRon+elBfpXU4KA54iF++P8PhVwBC+XHaYq8fOgtDs7GhgAhz7WfwTBEjtgA8p9CBTI1UfGz0R51IXRb19rRX9LZZ/W/01DZimK+R9j6K3ySSOYyJCFb9CSKjKtQNbLrzaJgu4IVIb8KW8EiViyFIwIhBJ2XCRpZRHrDL+l+IVP9ZHKyGFzJ+VVY6ILnfXfyYY9CDcAuuOuV4BRpwGzbc2tT3fg/XQSuVjtYV1SLaQrP+E1s0FU9GHP7XbjovO9DVATkz45Qs8gJmALUXNQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Ijlw5IsvCSStvxyAh51LhZSDHe2KNbEVAE+j1kKoPeY=;
 b=aMap9c3lOMXB5MhctT6Wdjfx8HXAhAWs1Xwamzx7KqYMdWDod0o53DFfCxTwFlZCZLJYOSIA+vm22BmkDBHAgxfGHpW6gIfBZgEPLqgLKvG/dfZKOTvaBHpmi7HRRQyVZFiiXBnwIs6k2BpkkVJfYmNFVANu+f4hZz22o0qH0TJJIMsL4VwoWd/KIBkOd1m8UN4s3PPwYaeF30pdzizlvHd6iGWNdoSsq2cdWCPAnAN/svqEgfsSPGUrWIHo38nO1XwZMJ+j6O9PmbWu5AuGoIXGWWW1DTQsbbUbY7EC6fw1B2h8+nQZc92kFag2Kk21H3E7ke7M5wkejZvZFemA6A==
Received: from MW2PR12MB4667.namprd12.prod.outlook.com (2603:10b6:302:12::28)
 by LV2PR12MB5990.namprd12.prod.outlook.com (2603:10b6:408:170::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4951.18; Thu, 10 Feb
 2022 17:49:56 +0000
Received: from MW2PR12MB4667.namprd12.prod.outlook.com
 ([fe80::846c:d3cd:5a30:c35]) by MW2PR12MB4667.namprd12.prod.outlook.com
 ([fe80::846c:d3cd:5a30:c35%5]) with mapi id 15.20.4951.019; Thu, 10 Feb 2022
 17:49:56 +0000
From:   Chaitanya Kulkarni <chaitanyak@nvidia.com>
To:     "Alexander V. Buev" <a.buev@yadro.com>,
        "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>
CC:     "io-uring@vger.kernel.org" <io-uring@vger.kernel.org>,
        Jens Axboe <axboe@kernel.dk>, Christoph Hellwig <hch@lst.de>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Pavel Begunkov <asml.silence@gmail.com>,
        Mikhail Malygin <m.malygin@yadro.com>,
        "linux@yadro.com" <linux@yadro.com>
Subject: Re: [PATCH v2 1/3] block: bio-integrity: add PI iovec to bio
Thread-Topic: [PATCH v2 1/3] block: bio-integrity: add PI iovec to bio
Thread-Index: AQHYHn9o5s108zN6rkGzpedtR9WWC6yNEDqA
Date:   Thu, 10 Feb 2022 17:49:56 +0000
Message-ID: <b540bd54-d1be-6de1-485b-ae82b135cdfc@nvidia.com>
References: <20220210130825.657520-1-a.buev@yadro.com>
 <20220210130825.657520-2-a.buev@yadro.com>
In-Reply-To: <20220210130825.657520-2-a.buev@yadro.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: c364e84a-aeb5-49e0-de6d-08d9ecbdbfe4
x-ms-traffictypediagnostic: LV2PR12MB5990:EE_
x-microsoft-antispam-prvs: <LV2PR12MB5990D01BC71134933E38FC9DA32F9@LV2PR12MB5990.namprd12.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:7219;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: AmkLnzUHiMmiAYkCu1i5/jdlP5L3AO5zWQy19TnM6FYlcs8RIal/TSdgXWnylZK3LrUQQMFMdnO6g84j1E6LDD4fQPooWBmTj9RfFSDsdxAbvKk2HPsStTpdb+idMMdzmf/LnHQU289Z1d6hrjC3ZRoFZELKR/peeMZsaLqrL2G/X351eEBWFTHLykOyuOs1vIF6vI41ImQPdet+eT1mEgR/YUPRJi4zj++l9Bcs4gDgqErlL+PYevMvHEMSI+v/vdqElD78xWXsmAcRTgOjNN6Hq4pSX+olWeZJsfemCJd6BOiovT8TIqHeHVT6GF6AQN0ub5M5bPhIruTY4CUhC/HJr8Wv91xCnU7ACJY8SKEdE+h4/L0moAhVU2KqHLxj7OKNkFawm7jdD/hMtTopmvaRDbivZ6VmO9by38HQHSUcIzMqIm5k6Emee/vZb+T1Wbm3dPefLJmNdnwK1YkdmZMHNWVptzcmMRmMF6JlmLQ6mtzhrbMr7zbNBNqomEfFMAoAvf9nr3ezDMgYT+DNsqygMZgW+/eII7F7iuBiWBhaOZz+WctPDNkVNPYRjT/oeWegF6ApV67j6JsvIzdTHhqoQBMnhtzMkXfjWVmUKpf+Dqq8i/f8f4e+KwJ5u1y7GZ24R6nsmF0bI2M+bdzs+TjSNKKfFp2zyw8xGOTuBFKtubvvB2LffISpd8+jrqAQxMjiSdd9BAtxGx4dz9tF4WInJN/XiV98LJjUoS06hDtIoZ6MJvbYl8WfLsLCpqaz7h64JRF8nUgqmLC3DLwV0w==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MW2PR12MB4667.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(91956017)(86362001)(76116006)(8676002)(2616005)(36756003)(66556008)(6512007)(66946007)(64756008)(110136005)(6506007)(8936002)(4326008)(38100700002)(66476007)(66446008)(122000001)(5660300002)(316002)(186003)(26005)(6486002)(2906002)(38070700005)(31696002)(508600001)(71200400001)(31686004)(54906003)(83380400001)(53546011)(45980500001)(43740500002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?dm4xSCsrY3J2RDhrN1RXSkI2TXVtZW9RQ01WS0JDTlZ0MXVCT2RyYTJ6QjNt?=
 =?utf-8?B?QU44d2hVMk5ISnNpZ0pkTGQvWCtIMXYvSG9vM0hYWXc5MEYydVdBRlIzMi9B?=
 =?utf-8?B?QzVubVMxdDBRc2tGWWM4M2svREc2YkRpYXhkRVdjMUJnS0FYK0JnUm02bFUw?=
 =?utf-8?B?cjZ6MXdLMnhCZTVkZEZmL1UxNzN3cGVwcktraHRFYU1Vc3AzYm42RjJIRWFD?=
 =?utf-8?B?L2tqT2F3WXhheGdCS0lPRTZjZjludXNNZWhURG1QQWdiTHErNjlyR01SeWds?=
 =?utf-8?B?amhQS2RCOHM3SEdkaTYyOG1sNW5GTzJXWjN5VExnbU9ndlphcXIvdmUvdkp4?=
 =?utf-8?B?NW5TYnJsYmRCVmQzTGEwVjJ3alVVV3pNWHhZVDBrM3ZpcGdsRGJ1bjRvbUJZ?=
 =?utf-8?B?TGNPUFNTZ1ZZNWFhTGVDT0ZpbFB3aUk2MHdBcEhDVG8zZi9mdG94b1d4a0pw?=
 =?utf-8?B?UHZQWHpmNmo1N2N4RlVZVjVKcC9GOWRyRmtQZzJQcU9ScE1KaWdSdXA3cXNR?=
 =?utf-8?B?RjFqWHBGNjVIMjhMblE2RWYxd25wa3JTRUtsTTRlNDBUWFBiQXdYV3pKdzJr?=
 =?utf-8?B?QW1nMTJFVjhTVzcvMElyenhXT2RrTnNla3dub21lRHA0Y1ZNaElaNlFYVnhS?=
 =?utf-8?B?bzc0K0F5aytWeFhrKzN5b0xzUnFEQUdxd0FlbXlkbFFKNUNRc3A2WW5uYUpV?=
 =?utf-8?B?dHZ3UzZCWGV5RmltSjUvOUtqN3RtNnlwWEhOZzduSUJMZVBlMmNoMnNHeTg5?=
 =?utf-8?B?MTBZbmFNekw0dzR6dm8vVk9xakY2ZVZwSFhYcWc3RXR2NXlCVERzdVMyTHZ5?=
 =?utf-8?B?MzlFc3NtdDM2dE16V3dBbnM4Wmx3dnozZnhQRlpJZXBRM0tBc1MxMEFHcXl5?=
 =?utf-8?B?aldWckJwYXNSODdOeDJNTDJsR2lENE9ZRHJwTloyZ0dVWktROTcyQ0JpR0dW?=
 =?utf-8?B?WE1zQ2d1VUpqT21PNE5YNEwxQll2Q05wbDVjTzVGSXJyUmtuTkZSVVNzcWpv?=
 =?utf-8?B?QUpIUWRtZVY5NlhqR011V3hpazFGY2Z4cXZyNVZsYWxFK2RJK3Q0SnRMbXU2?=
 =?utf-8?B?end2MTcyajJPTHhWWldrMVgrb0VGaE93MGlUT0VWVjRXcDJ4bnlaQzFiZUd2?=
 =?utf-8?B?Yjc5WjFwSVVTMG53TEFOZHNuYVU4Mk5zMGwzZWxjeVJUWVdOdkZzeGVKdmNQ?=
 =?utf-8?B?QmpSbkVSbi9DbDJUNXRLRm9vME5zUE1TbmhoYlo0M1V3bVUwQ3J5YVlUZloy?=
 =?utf-8?B?MExJNjgxcjRQVHhibE5WUmg0ME5MeElkMDE5SGNGZWdXbGxBWk5UQ2F3UVA5?=
 =?utf-8?B?dnZyZjlQSVV2WjR6d2REVkx6UmJ2cFUzT1czb0hreWU5V3NNUXV0VGQ0b29S?=
 =?utf-8?B?cFA3ZVJEQ0dmTmh0cExremdwRy9UaC9HbkJtUDNxcnBYK0RPNERuSEVLemRN?=
 =?utf-8?B?N3R5cVJKeVJXN0wrckhpZzhLUGt5TjlLajc5NjNWSXFveGg1NkNlYVJneTZM?=
 =?utf-8?B?WjlEUUlrWWR2Z01lelIySENsWlMwT2p1MXJhcGtEQ3RnNWFjU2tWRjNkL1Vo?=
 =?utf-8?B?YjE3a2ttRGxqL3Y5bzFXc3Z5TTRDM1hNNkRwaDdCMmd6bEhvOUhCa3VEVnkr?=
 =?utf-8?B?Z1grUVRWbnIweXlldTdmOXhieUU4VnQzdWpZbW1yRDdCd0tIOVNrd0Y3ckR2?=
 =?utf-8?B?M1BsQmNmeW9hUHo3Mi9uZzNMZThkNzhXY0gzSXNGeGRHS29tUFJzUkRBYkhM?=
 =?utf-8?B?cmdZTzRtNGNsU1U4T2UvcjN5ZkllVTBHbXBLa2xpZ3NIR01aN1J6S3FCN2tp?=
 =?utf-8?B?MGxuQ042ZVdxb2NKRHc0eXFDTUJYbm9wclRMUXp3WUFIZVAzeDB4eEo2aHZp?=
 =?utf-8?B?cGxlRVpHWk5KRWtVYWtWWVdVazE3emc0VllBZUpMQ25jbkRNaXQzVGwxa0FW?=
 =?utf-8?B?ZDlRWUJmM25idkMxNFdTdzUzVjVYeEhPM01zc3M1dUpZYURPK0FzSWhMQTA5?=
 =?utf-8?B?MFo5cEpjK1puU0tGd2EzNmhoQUwwN3gvaXhNMVFvSlJySHdTeFJHMWpxdmp0?=
 =?utf-8?B?TE9CcmhpRXNndUhWZ3RGeHRvRU9iWVZ5K25RbmVMRW0rVDVpTUo0Rk1PbHhC?=
 =?utf-8?B?VTFQUUsvSDRMVzBPUUR1Znp3TUZucktIOVVOWWhwRHFjWDNjMkxFUDdySWU3?=
 =?utf-8?B?M1E9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <B37245B128C08D41AC6E31184F54BE3D@namprd12.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MW2PR12MB4667.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c364e84a-aeb5-49e0-de6d-08d9ecbdbfe4
X-MS-Exchange-CrossTenant-originalarrivaltime: 10 Feb 2022 17:49:56.0963
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: A22BPc+F9zpRAUcjEYeNnbVmaCtOeaQouPCgR2dXZzk3GJu1gtEBbJ5mL+HfPlL8YTmhL0MpQ3QfQRw/8Y+lXQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LV2PR12MB5990
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        NICE_REPLY_A,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

T24gMi8xMC8yMiA1OjA4IEFNLCBBbGV4YW5kZXIgVi4gQnVldiB3cm90ZToNCj4gQWRkZWQgZnVu
Y3Rpb25zIHRvIGF0dGFjaCB1c2VyIFBJIGlvdmVjIHBhZ2VzIHRvIGJpbw0KPiBhbmQgcmVsZWFz
ZSB0aGlzIHBhZ2VzIHZpYSBiaW9faW50ZWdyaXR5X2ZyZWUuDQo+IA0KDQpjb25zaWRlciA6LQ0K
DQpBZGRlZCBmdW5jdGlvbnMgdG8gYXR0YWNoIHVzZXIgUEkgaW92ZWMgcGFnZXMgdG8gYmlvIGFu
ZCByZWxlYXNlIHRoaXMNCnBhZ2VzIHZpYSBiaW9faW50ZWdyaXR5X2ZyZWUuDQoNCj4gU2lnbmVk
LW9mZi1ieTogQWxleGFuZGVyIFYuIEJ1ZXYgPGEuYnVldkB5YWRyby5jb20+DQo+IC0tLQ0KPiAg
IGJsb2NrL2Jpby1pbnRlZ3JpdHkuYyB8IDE1MSArKysrKysrKysrKysrKysrKysrKysrKysrKysr
KysrKysrKysrKysrKysNCj4gICBpbmNsdWRlL2xpbnV4L2Jpby5oICAgfCAgIDggKysrDQo+ICAg
MiBmaWxlcyBjaGFuZ2VkLCAxNTkgaW5zZXJ0aW9ucygrKQ0KPiANCj4gZGlmZiAtLWdpdCBhL2Js
b2NrL2Jpby1pbnRlZ3JpdHkuYyBiL2Jsb2NrL2Jpby1pbnRlZ3JpdHkuYw0KPiBpbmRleCAwODI3
YjE5ODIwYzUuLjhlNTdhZWE5YzllYiAxMDA2NDQNCj4gLS0tIGEvYmxvY2svYmlvLWludGVncml0
eS5jDQo+ICsrKyBiL2Jsb2NrL2Jpby1pbnRlZ3JpdHkuYw0KPiBAQCAtMTAsNiArMTAsNyBAQA0K
PiAgICNpbmNsdWRlIDxsaW51eC9tZW1wb29sLmg+DQo+ICAgI2luY2x1ZGUgPGxpbnV4L2V4cG9y
dC5oPg0KPiAgICNpbmNsdWRlIDxsaW51eC9iaW8uaD4NCj4gKyNpbmNsdWRlIDxsaW51eC91aW8u
aD4NCj4gICAjaW5jbHVkZSA8bGludXgvd29ya3F1ZXVlLmg+DQo+ICAgI2luY2x1ZGUgPGxpbnV4
L3NsYWIuaD4NCj4gICAjaW5jbHVkZSAiYmxrLmgiDQo+IEBAIC05MSw2ICs5MiwxOSBAQCBzdHJ1
Y3QgYmlvX2ludGVncml0eV9wYXlsb2FkICpiaW9faW50ZWdyaXR5X2FsbG9jKHN0cnVjdCBiaW8g
KmJpbywNCj4gICB9DQo+ICAgRVhQT1JUX1NZTUJPTChiaW9faW50ZWdyaXR5X2FsbG9jKTsNCj4g
ICANCj4gK3ZvaWQgYmlvX2ludGVncml0eV9yZWxlYXNlX3BhZ2VzKHN0cnVjdCBiaW8gKmJpbykN
Cj4gK3sNCj4gKwlzdHJ1Y3QgYmlvX2ludGVncml0eV9wYXlsb2FkICpiaXAgPSBiaW9faW50ZWdy
aXR5KGJpbyk7DQo+ICsJdW5zaWduZWQgc2hvcnQgaTsNCj4gKw0KPiArCWZvciAoaSA9IDA7IGkg
PCBiaXAtPmJpcF92Y250OyArK2kpIHsNCg0KKytpIGlzIGNvbW1vbiBpbiBrZXJuZWwgY29kZS4u
DQoNCj4gKwkJc3RydWN0IGJpb192ZWMgKmJ2Ow0KPiArDQo+ICsJCWJ2ID0gYmlwLT5iaXBfdmVj
ICsgaTsNCg0KaXMgaXQgcG9zc2libGUgdG8gYmlwLT5iaXBfdmVjKysgaW5zdGVhZCBvZiBhYm92
ZSA/DQoNCj4gKwkJcHV0X3BhZ2UoYnYtPmJ2X3BhZ2UpOw0KPiArCX0NCj4gK30NCj4gKw0KPiAg
IC8qKg0KPiAgICAqIGJpb19pbnRlZ3JpdHlfZnJlZSAtIEZyZWUgYmlvIGludGVncml0eSBwYXls
b2FkDQo+ICAgICogQGJpbzoJYmlvIGNvbnRhaW5pbmcgYmlwIHRvIGJlIGZyZWVkDQo+IEBAIC0x
MDUsNiArMTE5LDEwIEBAIHZvaWQgYmlvX2ludGVncml0eV9mcmVlKHN0cnVjdCBiaW8gKmJpbykN
Cj4gICANCj4gICAJaWYgKGJpcC0+YmlwX2ZsYWdzICYgQklQX0JMT0NLX0lOVEVHUklUWSkNCj4g
ICAJCWtmcmVlKGJ2ZWNfdmlydChiaXAtPmJpcF92ZWMpKTsNCj4gKwllbHNlIHsNCj4gKwkJaWYg
KGJpcC0+YmlwX2ZsYWdzICYgQklQX1JFTEVBU0VfUEFHRVMpDQo+ICsJCQliaW9faW50ZWdyaXR5
X3JlbGVhc2VfcGFnZXMoYmlvKTsNCj4gKwl9DQo+ICAgDQoNCndoeSBub3QgdXNlIGlmKCkgLi4u
IGVsc2UgaWYgKCkge30gPw0KDQo+ICAgCV9fYmlvX2ludGVncml0eV9mcmVlKGJzLCBiaXApOw0K
PiAgIAliaW8tPmJpX2ludGVncml0eSA9IE5VTEw7DQo+IEBAIC0zNzcsNiArMzk1LDEzOSBAQCB2
b2lkIGJpb19pbnRlZ3JpdHlfYWR2YW5jZShzdHJ1Y3QgYmlvICpiaW8sIHVuc2lnbmVkIGludCBi
eXRlc19kb25lKQ0KPiAgIAlidmVjX2l0ZXJfYWR2YW5jZShiaXAtPmJpcF92ZWMsICZiaXAtPmJp
cF9pdGVyLCBieXRlcyk7DQo+ICAgfQ0KPiAgIA0KPiArc3RhdGljIGlubGluZQ0KPiArc3RydWN0
IHBhZ2UgKipfX2Jpb19pbnRlZ3JpdHlfdGVtcF9wYWdlcyhzdHJ1Y3QgYmlvICpiaW8sIHVuc2ln
bmVkIGludCBucl9uZWVkZWRfcGFnZSkNCj4gK3sNCj4gKwlzdHJ1Y3QgcGFnZSAqKnBhZ2VzID0g
MDsNCg0KdXNlIG9mIE5VTEwgcGxlYXNlIGFuZCByZXZlcnNlIHRyZWUgb3JkZXIgZGVjbGFyYXRp
b24gLi4NCg0KPiArCXVuc2lnbmVkIGludCBucl9hdmFpbF9wYWdlOw0KPiArCXN0cnVjdCBiaW9f
aW50ZWdyaXR5X3BheWxvYWQgKmJpcCA9IGJpb19pbnRlZ3JpdHkoYmlvKTsNCj4gKw0KPiArCWlm
IChiaXAtPmJpcF9tYXhfdmNudCA+IG5yX25lZWRlZF9wYWdlKSB7DQo+ICsJCW5yX2F2YWlsX3Bh
Z2UgPSAoYmlwLT5iaXBfbWF4X3ZjbnQgLSBucl9uZWVkZWRfcGFnZSkgKg0KPiArCQkJc2l6ZW9m
KHN0cnVjdCBiaW9fdmVjKS9zaXplb2Yoc3RydWN0IHBhZ2UgKik7DQo+ICsJfSBlbHNlDQo+ICsJ
CW5yX2F2YWlsX3BhZ2UgPSAwOw0KPiArDQoNCkknZCBpbml0aWFsaXplIG5yX2F2YWlsX3BhZ2Vz
IGF0IHRoZSB0aW1lIG9mIGRlY2xhcmF0aW9uIGFuZCByZW1vdmUgZWxzZQ0KcGFydC4NCg0KPiAr
CWlmIChucl9hdmFpbF9wYWdlID49IG5yX25lZWRlZF9wYWdlKQ0KPiArCQlwYWdlcyA9IChzdHJ1
Y3QgcGFnZSAqKikgKGJpcC0+YmlwX3ZlYyArIG5yX25lZWRlZF9wYWdlKTsNCj4gKwllbHNlIHsN
Cj4gKwkJaWYgKGJpby0+YmlfbWF4X3ZlY3MgLSBiaW8tPmJpX3ZjbnQpIHsNCj4gKwkJCW5yX2F2
YWlsX3BhZ2UgPSAoYmlvLT5iaV9tYXhfdmVjcyAtIGJpby0+YmlfdmNudCkgKg0KPiArCQkJCXNp
emVvZihzdHJ1Y3QgYmlvX3ZlYykvc2l6ZW9mKHN0cnVjdCBwYWdlICopOw0KPiArCQkJaWYgKG5y
X2F2YWlsX3BhZ2UgPj0gbnJfbmVlZGVkX3BhZ2UpDQo+ICsJCQkJcGFnZXMgPSAoc3RydWN0IHBh
Z2UgKiopIChiaW8tPmJpX2lvX3ZlYyArIGJpby0+YmlfdmNudCk7DQo+ICsJCX0NCj4gKwl9DQo+
ICsNCg0KSG93IGFib3V0IGZvbGxvd2luZyBtdWNoIGNsZWFyIGFuZCByZW1vdmVzIG5lZWQgZm9y
IGVsc2UgcGFydCA/DQoNCiAgICAgICAgIGlmIChucl9hdmFpbF9wYWdlID49IG5yX25lZWRlZF9w
YWdlKQ0KICAgICAgICAgICAgICAgICByZXR1cm4gKHN0cnVjdCBwYWdlICoqKSAoYmlwLT5iaXBf
dmVjICsgDQpucl9uZWVkZWRfcGFnZSk7DQoNCiAgICAgICAgIGlmIChiaW8tPmJpX21heF92ZWNz
IC0gYmlvLT5iaV92Y250KSB7DQogICAgICAgICAgICAgICAgIG5yX2F2YWlsX3BhZ2UgPSAoYmlv
LT5iaV9tYXhfdmVjcyAtIGJpby0+YmlfdmNudCkgKg0KICAgICAgICAgICAgICAgICAgICAgICAg
IHNpemVvZihzdHJ1Y3QgYmlvX3ZlYykvc2l6ZW9mKHN0cnVjdCBwYWdlICopOw0KICAgICAgICAg
ICAgICAgICBpZiAobnJfYXZhaWxfcGFnZSA+PSBucl9uZWVkZWRfcGFnZSkNCiAgICAgICAgICAg
ICAgICAgICAgICAgICByZXR1cm4gKHN0cnVjdCBwYWdlICoqKSAoYmlvLT5iaV9pb192ZWMgKyAN
CmJpby0+YmlfdmNudCk7DQogICAgICAgICB9DQoNCiAgICAgICAgIHJldHVybiBOVUxMOw0KDQpJ
IHRoaW5rIGlmIHlvdSB1c2UgYWJvdmUgdGhlbiB3ZSBkb24ndCBoYXZlIHRvIG5lZWQgcGFnZXMg
dmFyaWFibGUgb24NCnRoZSBzdGFjayBpbiB0aGUgZmFzdCBwYXRoLg0KDQo+ICsJcmV0dXJuIHBh
Z2VzOw0KPiArfQ0KPiArDQo+ICsvKioNCj4gKyAqIGJpb19pbnRlZ3JpdHlfYWRkX2lvdmVjIC0g
QWRkIFBJIGlvIHZlY3Rvcg0KPiArICogQGJpbzoJYmlvIHdob3NlIGludGVncml0eSB2ZWN0b3Ig
dG8gdXBkYXRlDQo+ICsgKiBAcGlfaXRlcjoJaW92X2l0ZXIgcG9pbnRlZCB0byBkYXRhIGFkZGVk
IHRvIEBiaW8ncyBpbnRlZ3JpdHkNCj4gKyAqDQo+ICsgKiBEZXNjcmlwdGlvbjogUGlucyBwYWdl
cyBmb3IgKnBpX2lvdiBhbmQgYXBwZW5kcyB0aGVtIHRvIEBiaW8ncyBpbnRlZ3JpdHkuDQo+ICsg
Ki8NCj4gK2ludCBiaW9faW50ZWdyaXR5X2FkZF9pb3ZlYyhzdHJ1Y3QgYmlvICpiaW8sIHN0cnVj
dCBpb3ZfaXRlciAqcGlfaXRlcikNCj4gK3sNCj4gKwlzdHJ1Y3QgYmxrX2ludGVncml0eSAqYmkg
PSBiZGV2X2dldF9pbnRlZ3JpdHkoYmlvLT5iaV9iZGV2KTsNCj4gKwlzdHJ1Y3QgYmlvX2ludGVn
cml0eV9wYXlsb2FkICpiaXA7DQo+ICsJc3RydWN0IHBhZ2UgKipwaV9wYWdlID0gMCwgKipiaW9f
cGFnZTsNCj4gKwl1bnNpZ25lZCBpbnQgbnJfdmVjX3BhZ2UsIGludGVydmFsczsNCj4gKwlpbnQg
cmV0Ow0KPiArCXNzaXplX3Qgc2l6ZTsNCj4gKwlzaXplX3Qgb2Zmc2V0LCBsZW4sIHBnX251bSwg
cGFnZV9jb3VudDsNCj4gKw0KPiArCWlmICh1bmxpa2VseSghYmkgJiYgYmktPnR1cGxlX3NpemUg
JiYgYmktPmludGVydmFsX2V4cCkpIHsNCj4gKwkJcHJfZXJyKCJEZXZpY2UgaXMgbm90IGludGVn
cml0eSBjYXBhYmxlIik7DQo+ICsJCXJldHVybiAtRUlOVkFMOw0KPiArCX0NCj4gKw0KPiArCWlu
dGVydmFscyA9IGJpb19pbnRlZ3JpdHlfaW50ZXJ2YWxzKGJpLCBiaW9fc2VjdG9ycyhiaW8pKTsN
Cj4gKwlpZiAodW5saWtlbHkoaW50ZXJ2YWxzICogYmktPnR1cGxlX3NpemUgPCBwaV9pdGVyLT5j
b3VudCkpIHsNCj4gKwkJcHJfZXJyKCJJbnRlcnZhbHMgbnVtYmVyIGlzIHdyb25nLCBpbnRlcnZh
bHM9JXUsIHR1cGxlX3NpemU9JXUsIHBpX2xlbj0lenUiLA0KPiArCQkJaW50ZXJ2YWxzLCBiaS0+
dHVwbGVfc2l6ZSwgcGlfaXRlci0+Y291bnQpOw0KPiArCQlyZXR1cm4gLUVJTlZBTDsNCj4gKwl9
DQo+ICsNCj4gKwlucl92ZWNfcGFnZSA9IChwaV9pdGVyLT5jb3VudCArIFBBR0VfU0laRSAtIDEp
ID4+IFBBR0VfU0hJRlQ7DQo+ICsJLyogZGF0YSBvZiBzaXplIE4gcGFnZXMgY2FuIGJlIHBpbm5l
ZCB0byBOKzEgcGFnZSAqLw0KPiArCW5yX3ZlY19wYWdlICs9IDE7DQo+ICsNCj4gKwliaXAgPSBi
aW9faW50ZWdyaXR5X2FsbG9jKGJpbywgR0ZQX05PSU8sIG5yX3ZlY19wYWdlKTsNCj4gKwlpZiAo
SVNfRVJSKGJpcCkpDQo+ICsJCXJldHVybiBQVFJfRVJSKGJpcCk7DQo+ICsNCj4gKwkvKiBnZXQg
c3BhY2UgZm9yIHBhZ2UgcG9pbnRlcnMgYXJyYXkgKi8NCj4gKwliaW9fcGFnZSA9IF9fYmlvX2lu
dGVncml0eV90ZW1wX3BhZ2VzKGJpbywgbnJfdmVjX3BhZ2UpOw0KPiArDQo+ICsJaWYgKGxpa2Vs
eShiaW9fcGFnZSkpDQo+ICsJCXBpX3BhZ2UgPSBiaW9fcGFnZTsNCj4gKwllbHNlIHsNCj4gKwkJ
cGlfcGFnZSA9IGtjYWxsb2MobnJfdmVjX3BhZ2UsIHNpemVvZihzdHJ1Y3QgcGlfcGFnZSAqKSwg
R0ZQX05PSU8pOw0KDQpvdmVybGF5IGxvbmcgbGluZSBhYm92ZS4uDQoNCj4gKwkJaWYgKCFwaV9w
YWdlKSB7DQo+ICsJCQlyZXQgPSAtRU5PTUVNOw0KPiArCQkJZ290byBlcnJvcjsNCj4gKwkJfQ0K
PiArCX0NCj4gKw0KPiArCWJpcC0+YmlwX2l0ZXIuYmlfc2l6ZSA9IHBpX2l0ZXItPmNvdW50Ow0K
PiArCWJpcC0+YmlvX2l0ZXIgPSBiaW8tPmJpX2l0ZXI7DQo+ICsJYmlwX3NldF9zZWVkKGJpcCwg
YmlvLT5iaV9pdGVyLmJpX3NlY3Rvcik7DQo+ICsNCj4gKwlpZiAoYmktPmZsYWdzICYgQkxLX0lO
VEVHUklUWV9JUF9DSEVDS1NVTSkNCj4gKwkJYmlwLT5iaXBfZmxhZ3MgfD0gQklQX0lQX0NIRUNL
U1VNOw0KPiArDQo+ICsJc2l6ZSA9IGlvdl9pdGVyX2dldF9wYWdlcyhwaV9pdGVyLCBwaV9wYWdl
LCBMT05HX01BWCwgbnJfdmVjX3BhZ2UsICZvZmZzZXQpOw0KDQpzYW1lIGFzIGFib3ZlIGNvbW1l
bnQuLi4NCg0KPiArCWlmICh1bmxpa2VseShzaXplIDw9IDApKSB7DQo+ICsJCXByX2VycigiRmFp
bGVkIHRvIHBpbiBQSSBidWZmZXIgdG8gcGFnZSAoJXppKSIsIHNpemUpOw0KPiArCQlyZXQgPSAo
c2l6ZSkgPyBzaXplIDogLUVGQVVMVDsNCj4gKwkJZ290byBlcnJvcjsNCj4gKwl9DQo+ICsNCj4g
KwkvKiBjYWxjIGNvdW50IG9mIHBpbmVkIHBhZ2VzICovDQo+ICsJaWYgKHNpemUgPiAoUEFHRV9T
SVpFIC0gb2Zmc2V0KSkNCj4gKwkJcGFnZV9jb3VudCA9IERJVl9ST1VORF9VUChzaXplIC0gKFBB
R0VfU0laRSAtIG9mZnNldCksIFBBR0VfU0laRSkgKyAxOw0KPiArCWVsc2UNCj4gKwkJcGFnZV9j
b3VudCA9IDE7DQo+ICsNCj4gKwkvKiBmaWxsIGJpbyBpbnRlZ3JpdHkgYmlvdmVjcyB0aGUgZ2l2
ZW4gcGFnZXMgKi8NCj4gKwlsZW4gPSBwaV9pdGVyLT5jb3VudDsNCj4gKwlmb3IgKHBnX251bSA9
IDA7IHBnX251bSA8IHBhZ2VfY291bnQ7ICsrcGdfbnVtKSB7DQo+ICsJCXNpemVfdCBwYWdlX2xl
bjsNCj4gKw0KPiArCQlwYWdlX2xlbiA9IFBBR0VfU0laRSAtIG9mZnNldDsNCj4gKwkJaWYgKHBh
Z2VfbGVuID4gbGVuKQ0KPiArCQkJcGFnZV9sZW4gPSBsZW47DQo+ICsJCXJldCA9IGJpb19pbnRl
Z3JpdHlfYWRkX3BhZ2UoYmlvLCBwaV9wYWdlW3BnX251bV0sIHBhZ2VfbGVuLCBvZmZzZXQpOw0K
PiArCQlpZiAodW5saWtlbHkocmV0ICE9IHBhZ2VfbGVuKSkgew0KPiArCQkJcmV0ID0gLUVOT01F
TTsNCj4gKwkJCWdvdG8gZXJyb3I7DQo+ICsJCX0NCj4gKwkJbGVuIC09IHBhZ2VfbGVuOw0KPiAr
CQlvZmZzZXQgPSAwOw0KPiArCQliaXAtPmJpcF9mbGFncyB8PSBCSVBfUkVMRUFTRV9QQUdFUzsN
Cj4gKwl9DQo+ICsNCj4gKwlpb3ZfaXRlcl9hZHZhbmNlKHBpX2l0ZXIsIHNpemUpOw0KPiArDQo+
ICsJaWYgKHBpX3BhZ2UgIT0gYmlvX3BhZ2UpDQo+ICsJCWtmcmVlKHBpX3BhZ2UpOw0KPiArDQo+
ICsJcmV0dXJuIDA7DQo+ICsNCj4gK2Vycm9yOg0KPiArCWlmIChiaW9faW50ZWdyaXR5KGJpbykp
DQo+ICsJCWJpb19pbnRlZ3JpdHlfZnJlZShiaW8pOw0KPiArDQo+ICsJaWYgKHBpX3BhZ2UgJiYg
cGlfcGFnZSAhPSBiaW9fcGFnZSkNCj4gKwkJa2ZyZWUocGlfcGFnZSk7DQo+ICsNCj4gKwlyZXR1
cm4gcmV0Ow0KPiArfQ0KPiArRVhQT1JUX1NZTUJPTF9HUEwoYmlvX2ludGVncml0eV9hZGRfaW92
ZWMpOw0KPiArDQo+ICAgLyoqDQo+ICAgICogYmlvX2ludGVncml0eV90cmltIC0gVHJpbSBpbnRl
Z3JpdHkgdmVjdG9yDQo+ICAgICogQGJpbzoJYmlvIHdob3NlIGludGVncml0eSB2ZWN0b3IgdG8g
dXBkYXRlDQo+IGRpZmYgLS1naXQgYS9pbmNsdWRlL2xpbnV4L2Jpby5oIGIvaW5jbHVkZS9saW51
eC9iaW8uaA0KPiBpbmRleCAxMTdkN2YyNDhhYzkuLmNlMDA4ZWVlYjE2MCAxMDA2NDQNCj4gLS0t
IGEvaW5jbHVkZS9saW51eC9iaW8uaA0KPiArKysgYi9pbmNsdWRlL2xpbnV4L2Jpby5oDQo+IEBA
IC0zMTcsNiArMzE3LDcgQEAgZW51bSBiaXBfZmxhZ3Mgew0KPiAgIAlCSVBfQ1RSTF9OT0NIRUNL
CT0gMSA8PCAyLCAvKiBkaXNhYmxlIEhCQSBpbnRlZ3JpdHkgY2hlY2tpbmcgKi8NCj4gICAJQklQ
X0RJU0tfTk9DSEVDSwk9IDEgPDwgMywgLyogZGlzYWJsZSBkaXNrIGludGVncml0eSBjaGVja2lu
ZyAqLw0KPiAgIAlCSVBfSVBfQ0hFQ0tTVU0JCT0gMSA8PCA0LCAvKiBJUCBjaGVja3N1bSAqLw0K
PiArCUJJUF9SRUxFQVNFX1BBR0VTCT0gMSA8PCA1LCAvKiByZWxlYXNlIHBhZ2VzIGFmdGVyIGlv
IGNvbXBsZXRpb24gKi8NCj4gICB9Ow0KPiAgIA0KPiAgIC8qDQo+IEBAIC03MDcsNiArNzA4LDcg
QEAgZXh0ZXJuIHN0cnVjdCBiaW9faW50ZWdyaXR5X3BheWxvYWQgKmJpb19pbnRlZ3JpdHlfYWxs
b2Moc3RydWN0IGJpbyAqLCBnZnBfdCwgdW4NCj4gICBleHRlcm4gaW50IGJpb19pbnRlZ3JpdHlf
YWRkX3BhZ2Uoc3RydWN0IGJpbyAqLCBzdHJ1Y3QgcGFnZSAqLCB1bnNpZ25lZCBpbnQsIHVuc2ln
bmVkIGludCk7DQo+ICAgZXh0ZXJuIGJvb2wgYmlvX2ludGVncml0eV9wcmVwKHN0cnVjdCBiaW8g
Kik7DQo+ICAgZXh0ZXJuIHZvaWQgYmlvX2ludGVncml0eV9hZHZhbmNlKHN0cnVjdCBiaW8gKiwg
dW5zaWduZWQgaW50KTsNCj4gK2V4dGVybiBpbnQgYmlvX2ludGVncml0eV9hZGRfaW92ZWMoc3Ry
dWN0IGJpbyAqYmlvLCBzdHJ1Y3QgaW92X2l0ZXIgKml0ZXIpOw0KDQpjYW4gd2UgZHJvcCBleHRl
cm4ga2V5d29yZCA/DQoNCj4gICBleHRlcm4gdm9pZCBiaW9faW50ZWdyaXR5X3RyaW0oc3RydWN0
IGJpbyAqKTsNCj4gICBleHRlcm4gaW50IGJpb19pbnRlZ3JpdHlfY2xvbmUoc3RydWN0IGJpbyAq
LCBzdHJ1Y3QgYmlvICosIGdmcF90KTsNCj4gICBleHRlcm4gaW50IGJpb3NldF9pbnRlZ3JpdHlf
Y3JlYXRlKHN0cnVjdCBiaW9fc2V0ICosIGludCk7DQo+IEBAIC03NDcsNiArNzQ5LDEyIEBAIHN0
YXRpYyBpbmxpbmUgdm9pZCBiaW9faW50ZWdyaXR5X2FkdmFuY2Uoc3RydWN0IGJpbyAqYmlvLA0K
PiAgIAlyZXR1cm47DQo+ICAgfQ0KPiAgIA0KPiArc3RhdGljIGlubGluZSBpbnQgYmlvX2ludGVn
cml0eV9hZGRfaW92ZWMoc3RydWN0IGJpbyAqYmlvLA0KPiArCQkJCQlzdHJ1Y3QgaW92X2l0ZXIg
KnBpX2l0ZXIpDQo+ICt7DQo+ICsJcmV0dXJuIDA7DQo+ICt9DQo+ICsNCj4gICBzdGF0aWMgaW5s
aW5lIHZvaWQgYmlvX2ludGVncml0eV90cmltKHN0cnVjdCBiaW8gKmJpbykNCj4gICB7DQo+ICAg
CXJldHVybjsNCj4gDQoNCg==
