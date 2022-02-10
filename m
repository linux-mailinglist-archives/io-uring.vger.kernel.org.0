Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D9ED34B149C
	for <lists+io-uring@lfdr.de>; Thu, 10 Feb 2022 18:53:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245363AbiBJRxT (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 10 Feb 2022 12:53:19 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:54450 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242006AbiBJRxR (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 10 Feb 2022 12:53:17 -0500
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12on2082.outbound.protection.outlook.com [40.107.244.82])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5353B192;
        Thu, 10 Feb 2022 09:53:17 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=FLjBDqRdASFq+7yXUzz7134wuUnsp07k5QSUMv6edoSAA2befunYWsHOhz8YFg2R9ysSHy5rUEMZxdcO0HDRBYxFxl2p1S5y+8CzRGvui7dXTTJvAEcIHuEwM88m+U7sqiEUk2mO5Qb8thBC2CyooZVFoGeImatAwj18eWFVqFWs3W6F29wRuyjicCWFF3R5R/tXgtatuCEbcv/MwyOb598M37zSd9oUUKRrhjV/Mi0Kyul/1eh/S1SwpZAWC7sXC7J9ZKOsut4XSve4APFh7wxBhXwELgmvEG5luSudPKbDvvu/aJcAiUThjLnBRlJmqyoGM1+bWDkhfJtZNXnrjg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=B7hXij75t/6O6i6Fs2R0VGZKjne6CvOt/JIz3FjvgvQ=;
 b=LNkrtWTsP1f+M+FDjpOKZD73hSIXcU0aqgZxbylCQ3pTpdY4DqXzyQm6VI830BMxZuQeX8ulOGJVS0fDPVYsnUkeZS5JG/NrDwz0k5yHiBG57TuDHXzPFq9Ux4C1Vwg9wSS0mDg1frRpWmQmNv7iVRCspwyLt4eHkaux0AD628jxzYzdI+3lRlJ3W78tkHL9NqoXkA3y21M9qedGjf37Gouwkx8RotcdOsd0FrQvcDK1nzcI5v8901PEYtoBbxJw/q2Imi57zjf9P5QFbCgC8rN7x8fQO6ZABcvfQ+SBS2utij1Bgd6HHkNq/K3neeBK85p4w/hf2vn9/m0HIwNv5w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=B7hXij75t/6O6i6Fs2R0VGZKjne6CvOt/JIz3FjvgvQ=;
 b=K9lLamiP+/Uiyx2UuLowQYuPb56zWyQ7zT16PDYHo97JPNa88kA+ZhecYakI5B2awJ577PWxjsfADIDR2klQBvdaRCxKRC8bG2xE2qW+Q1JcGRYCQIFVCQY9FSh4468LFBkf2ZUBhGdk2ByxQcdrdWPIJ1r0FHjacBo0QSStBPCR12jG52lAuCJYItPcxsqlmyezEdOMu+Go2UJSVytlWEuPhb0ikCqlHUtarym0E8KQYbeVjkpPH60BYGz+4RxUzrdLJjSe3FUL8/wLH8nYrf/4eAfWYDcEABirnOW8Wdoi84zcNvCFQbIzYIIgCwbQciVTR3C4ZXYyxpwL6rzMcQ==
Received: from MW2PR12MB4667.namprd12.prod.outlook.com (2603:10b6:302:12::28)
 by LV2PR12MB5990.namprd12.prod.outlook.com (2603:10b6:408:170::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4951.18; Thu, 10 Feb
 2022 17:53:15 +0000
Received: from MW2PR12MB4667.namprd12.prod.outlook.com
 ([fe80::846c:d3cd:5a30:c35]) by MW2PR12MB4667.namprd12.prod.outlook.com
 ([fe80::846c:d3cd:5a30:c35%5]) with mapi id 15.20.4951.019; Thu, 10 Feb 2022
 17:53:15 +0000
From:   Chaitanya Kulkarni <chaitanyak@nvidia.com>
To:     "Alexander V. Buev" <a.buev@yadro.com>,
        "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>
CC:     "io-uring@vger.kernel.org" <io-uring@vger.kernel.org>,
        Jens Axboe <axboe@kernel.dk>, Christoph Hellwig <hch@lst.de>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Pavel Begunkov <asml.silence@gmail.com>,
        Mikhail Malygin <m.malygin@yadro.com>,
        "linux@yadro.com" <linux@yadro.com>
Subject: Re: [PATCH v2 3/3] block: fops: handle IOCB_USE_PI in direct IO
Thread-Topic: [PATCH v2 3/3] block: fops: handle IOCB_USE_PI in direct IO
Thread-Index: AQHYHn9pXxd5giLH50m+wY3EYZM5/6yNESmA
Date:   Thu, 10 Feb 2022 17:53:15 +0000
Message-ID: <350c1e5c-5995-b571-0a37-b5e4ad615282@nvidia.com>
References: <20220210130825.657520-1-a.buev@yadro.com>
 <20220210130825.657520-4-a.buev@yadro.com>
In-Reply-To: <20220210130825.657520-4-a.buev@yadro.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 17016f26-3d98-41b9-67c3-08d9ecbe36df
x-ms-traffictypediagnostic: LV2PR12MB5990:EE_
x-microsoft-antispam-prvs: <LV2PR12MB5990211ECF2D6E64A5173811A32F9@LV2PR12MB5990.namprd12.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:655;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: AbHO+k6S+G6Ek4OryKKh3osgPE6IU8/1oWOMG2QupGsF1kh44V8WbDbGg4xK5mibROPHziLrCvAx1FqU50sao7OaYbfYtxgoywuQAiu6ZqFdr5nQlCWia5zM+6V8UtQkwjjOX0TqSHpneW9nx2dg6UgnlzfiJ7B6FyNrJ8vQWr9M4k5hTuvwXDdnQ8Et/9YzlVXSIfFsU/BFDa5JXbBp2hVLYwRbh9HlqoV/Rpg1E7bJh9GlGCCZpFpevXoDyTSn7zHXrLhH+zcHE2W48msmzg+dUZp3v/GHnJYel3Kg3c4nOpV2Ic6n8CoVRxJCnx+J1gxhDEXa/seBcwrkAIkYzcUsbkPHez5vny5jXaI7fYdPAz3xyhf1xG88mwcI6nv6ZBG9h4ykW5BA7lH8MFNSTHwk+8Pgjp7U4R9RTSKmpuBKFpHZpprW7gt4XOc9RzeHKIHEo0NhbCTC9bRXB/qTjOrnFnd6vfJ5h+zfFGAr1nza6oZcfbaRRiy7H8KvhW0uDZLVxYnxcpx0SjxO53eeQQR02XaXXfHIh4sYf7MZ1rSu3NNE6Bq+IJe6BoyK4n3uOmzbKrR7N65+DEtIEpMDNt/jvgtLx2WOW+cIaX9vuDHiCpDLW7bgWXWpd7CYVIG9NoE7SV4gRscpZwpKglGAqmt0XEunbIT0KthEHJLQnCXRR43IahL3OCzc96orLYqVdhjWMwtI24mcqvv4IK6UAIIL26h+7DPPe/EnKv2Zqn409f3xfjoKpkK22kvLpAqpO5o1zotNR7DP3fqcca3kOg==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MW2PR12MB4667.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(91956017)(86362001)(76116006)(8676002)(2616005)(36756003)(66556008)(6512007)(66946007)(64756008)(110136005)(6506007)(8936002)(4326008)(38100700002)(66476007)(66446008)(122000001)(5660300002)(316002)(186003)(26005)(6486002)(2906002)(38070700005)(31696002)(508600001)(71200400001)(31686004)(54906003)(83380400001)(53546011)(45980500001)(43740500002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?SkgvZzZGNktIQXZlU3hHWlhaa0lKVGhZa3NObTQ2Vmd1MzlwVE1pZlF4U2ZS?=
 =?utf-8?B?TUJFT1lzVlZWbWM2SGJBQk5tRzNsL294NzcxZWgxdzVhcVR1cGl6dHpPMSt4?=
 =?utf-8?B?cU5zdG4rcVZFdUZienpWdnNnWElvT1dZVkxKVjZ4MFI3WkhBVU04WmtVZFND?=
 =?utf-8?B?U2xjZlowV1ZJajR3TnBDcWRTWjFlaUdsR2xLY3BtMUxZd3NnRGtpcmgrK3JN?=
 =?utf-8?B?TXlTbXlCZ1dkbEFaSFl0UzRXSGRtalViSUFIUDMwc2VmTFZtSFREZWFBRWFX?=
 =?utf-8?B?b2xVRkF0UStrMTZyM2lFUUtRcHpSRnBQWnlJUWpFaUlmRGVYa0lTb2Z5dmp4?=
 =?utf-8?B?eWQrUXd1VnJKOU1DM2xkdlFoVFNBWFhIZ0RLQ0Nua3R5WHNLdUhoVWVScFRQ?=
 =?utf-8?B?dXQ5NUJ4MnJiRGNONjlHbnFkdHRxWlY2YmVScml0VU94TkE0NXJsdUZVUFYz?=
 =?utf-8?B?NTdqS3hpbEd3enY5cHJndFR2R2VIWmdYb25HVzF0UjY5ZXphSjlIMExNdERY?=
 =?utf-8?B?Z1pLZlFBWmlxbFZqVDJUdFAyWE44TTFxQTRURDdBMXZ4RzAvY2xFVnJETy9R?=
 =?utf-8?B?Mm5teUF5b3FEVkduK3VoYWxKKytjbHdYM2RvRkdqYVA1eWMvY013ZlFrcjNP?=
 =?utf-8?B?eXZscEc5OGZiMXZ6SlkrZEs3N3VLaDR2OGt3ZVdyMi9UMGlhSWs3SCttcVJk?=
 =?utf-8?B?dU91WjFuN3RvWUtZenBIYTA1QTgrck1RZmtZeTJVOUxUREcrbVpRU2h3aFFP?=
 =?utf-8?B?RVR2dS9adURCemVUS3FTNEliTG1pbUZxN2N2anVRTlh6Z0Z1d205WG1uRW9I?=
 =?utf-8?B?Yy91QXBBalhzYjJCMzRPV0RjQmljcUJwb2d5SWJrT0JTSHBCTEsxM0NJKzZy?=
 =?utf-8?B?aXErSGJyNEo3K1N3ZHkxZHVZRUNRbTZXSzUwc2RRVWxVaURmRUxsbWZRRlNF?=
 =?utf-8?B?NGNjZE9JM2lncFI2MjVGNi8xQ1dHbGZkVVNIbnFoejZvQzJOM01GdXA0cjhQ?=
 =?utf-8?B?U1pZbHU5L1V1U0lwbmY4VC9wSiswMlNWR3hPdERSSkpxbDZKVVBNVG9kMlJp?=
 =?utf-8?B?cFh0OEJRMURJaDJzNlRjQVFEWEhmKzFjcU1Wd2VURXA0MDk3enY4UmU0bG5P?=
 =?utf-8?B?ODN6dCt0UW56bzlJSmdTZG0waUt0UlhBNDZ4TjdiL2JHakJWOW1Pc0JOcHor?=
 =?utf-8?B?bldhaitTSVRJYkh6SXB0V3NRQ0lqcVFBTGV0bkNGVWNZRGxCWGVnSDByeGky?=
 =?utf-8?B?SkgyR0NVY0dEdlA1ek02Q3dwdy82Y3RJWEZRVExoanBPU3NjcEw1SzVjck00?=
 =?utf-8?B?UTdYSGhvQ1Yyekk0YnFXa0R2NysxZU11bVEvM01XWkNPUmx2eG1CWlQwcXZ5?=
 =?utf-8?B?cnJ5bnZmNzFrQzlXK010cTJJREVBbXozL1lDRG5ZOEhlZEp0MjA5ek5oay9B?=
 =?utf-8?B?aGE4TWhIZmN0Z2NSR0VKK01oZmJaS01MU1h6b0RkY1kzTzBab0ExNTVqa1dB?=
 =?utf-8?B?MWd3Uit6aWtEZ2sxdjVyUkVhUzVGazFpMFBFenB5UjVVaHN4VUxaUnZjZ1lD?=
 =?utf-8?B?QjV0VEpQQ2NXUWY5ZWZVc1p2b1dsTUN4Wm8wckxzbVdhSmYwMFMrNlJwVDR3?=
 =?utf-8?B?R3NWeklRdjFwSHIrVVc0NGZabXF4eDVVQXJZQ1lhZXRzcHVsMWRONitrV2U3?=
 =?utf-8?B?cWhNamdNYUZvY3hXQ3Z0S3E0RnRMaWdrbzdwMk1OWnhkRUd6UE5odmRJTTlj?=
 =?utf-8?B?TWdnK2FHNDQ5SDFHQzE0WWo5S1VsU1NBTWl1ZGVFUDROeE1zanRmV1RyZUli?=
 =?utf-8?B?bUlDUHpoSkFWWXpzdXhKYlJRRmxqVGMyaHcvUmdsQldzT2krb2dvejhkYXR4?=
 =?utf-8?B?bTlFbzgxNjlDOEFrT2NEVzhzQjBtam9sRUprWGF2OFJmdEU2aHcyWEQrZUpE?=
 =?utf-8?B?UHRJL0FzUTAvNkJUa0dJb1ZGdmtURklqMm1zUkoyR1l5c0w5V0RSQTk5ZnNw?=
 =?utf-8?B?cFFXTFMvelpVNnpEVHc0ZHJRR3hZcVlsM29ZMXdZbmQwSXhMSU1nREhma2FV?=
 =?utf-8?B?VHZ0UlphKy9rNHd3QUdOc09JenJmbDZrdzVVWTNKNThLU1JRTVhPUnBHRlVD?=
 =?utf-8?B?T1dyMHdvbXhiNUU4RWI5OU9rbFgwSk9UZDNjc1c4ZUVwNGlUWTdmOVB4ek5I?=
 =?utf-8?B?Qmc9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <D8D89C9201B52448ABC8F2F8FAEAB082@namprd12.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MW2PR12MB4667.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 17016f26-3d98-41b9-67c3-08d9ecbe36df
X-MS-Exchange-CrossTenant-originalarrivaltime: 10 Feb 2022 17:53:15.7094
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: w4FRkMprrMTYV32WsR6fsIB15tZv/+dLnNHYLRNcV+p69fWDI3rplWw/jCtvhSGNm2k/uT6D71IyOX0Xl97sDQ==
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

T24gMi8xMC8yMiA1OjA4IEFNLCBBbGV4YW5kZXIgVi4gQnVldiB3cm90ZToNCj4gQ2hlY2sgdGhh
dCB0aGUgc2l6ZSBvZiBpbnRlZ3JpdHkgZGF0YSBjb3JyZXNwb25kIHRvIGRldmljZSBpbnRlZ3Jp
dHkNCj4gcHJvZmlsZSBhbmQgZGF0YSBzaXplLiBTcGxpdCBpbnRlZ3JpdHkgZGF0YSB0byB0aGUg
ZGlmZmVyZW50IGJpbydzDQo+IGluIGNhc2Ugb2YgdG8gYmlnIG9yZ2luYWwgYmlvICh0b2dldGhl
ciB3aXRoIG5vcm1hbCBkYXRhKS4NCj4gDQo+IFNpZ25lZC1vZmYtYnk6IEFsZXhhbmRlciBWLiBC
dWV2IDxhLmJ1ZXZAeWFkcm8uY29tPg0KPiAtLS0NCj4gICBibG9jay9mb3BzLmMgfCA2MiArKysr
KysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrDQo+ICAgMSBm
aWxlIGNoYW5nZWQsIDYyIGluc2VydGlvbnMoKykNCj4gDQo+IGRpZmYgLS1naXQgYS9ibG9jay9m
b3BzLmMgYi9ibG9jay9mb3BzLmMNCj4gaW5kZXggNGY1OWUwZjViZjMwLi45OWM2NzBiOWY3ZDQg
MTAwNjQ0DQo+IC0tLSBhL2Jsb2NrL2ZvcHMuYw0KPiArKysgYi9ibG9jay9mb3BzLmMNCj4gQEAg
LTE2LDYgKzE2LDcgQEANCj4gICAjaW5jbHVkZSA8bGludXgvc3VzcGVuZC5oPg0KPiAgICNpbmNs
dWRlIDxsaW51eC9mcy5oPg0KPiAgICNpbmNsdWRlIDxsaW51eC9tb2R1bGUuaD4NCj4gKyNpbmNs
dWRlIDxsaW51eC9ibGstaW50ZWdyaXR5Lmg+DQo+ICAgI2luY2x1ZGUgImJsay5oIg0KPiAgIA0K
PiAgIHN0YXRpYyBpbmxpbmUgc3RydWN0IGlub2RlICpiZGV2X2ZpbGVfaW5vZGUoc3RydWN0IGZp
bGUgKmZpbGUpDQo+IEBAIC00NCw2ICs0NSwxOSBAQCBzdGF0aWMgdW5zaWduZWQgaW50IGRpb19i
aW9fd3JpdGVfb3Aoc3RydWN0IGtpb2NiICppb2NiKQ0KPiAgIA0KPiAgICNkZWZpbmUgRElPX0lO
TElORV9CSU9fVkVDUyA0DQo+ICAgDQo+ICtzdGF0aWMgaW50IF9fYmlvX2ludGVncml0eV9hZGRf
aW92ZWMoc3RydWN0IGJpbyAqYmlvLCBzdHJ1Y3QgaW92X2l0ZXIgKnBpX2l0ZXIpDQo+ICt7DQo+
ICsJc3RydWN0IGJsa19pbnRlZ3JpdHkgKmJpID0gYmRldl9nZXRfaW50ZWdyaXR5KGJpby0+Ymlf
YmRldik7DQo+ICsJdW5zaWduZWQgaW50IHBpX2xlbiA9IGJpb19pbnRlZ3JpdHlfYnl0ZXMoYmks
IGJpby0+YmlfaXRlci5iaV9zaXplID4+IFNFQ1RPUl9TSElGVCk7DQo+ICsJc2l6ZV90IGl0ZXJf
Y291bnQgPSBwaV9pdGVyLT5jb3VudC1waV9sZW47DQo+ICsJaW50IHJldDsNCj4gKw0KPiArCWlv
dl9pdGVyX3RydW5jYXRlKHBpX2l0ZXIsIHBpX2xlbik7DQo+ICsJcmV0ID0gYmlvX2ludGVncml0
eV9hZGRfaW92ZWMoYmlvLCBwaV9pdGVyKTsNCj4gKwlwaV9pdGVyLT5jb3VudCA9IGl0ZXJfY291
bnQ7DQo+ICsJcmV0dXJuIHJldDsNCj4gK30NCj4gKw0KPiAgIHN0YXRpYyB2b2lkIGJsa2Rldl9i
aW9fZW5kX2lvX3NpbXBsZShzdHJ1Y3QgYmlvICpiaW8pDQo+ICAgew0KPiAgIAlzdHJ1Y3QgdGFz
a19zdHJ1Y3QgKndhaXRlciA9IGJpby0+YmlfcHJpdmF0ZTsNCj4gQEAgLTEwMSw2ICsxMTUsMTQg
QEAgc3RhdGljIHNzaXplX3QgX19ibGtkZXZfZGlyZWN0X0lPX3NpbXBsZShzdHJ1Y3Qga2lvY2Ig
KmlvY2IsDQo+ICAgCWlmIChpb2NiLT5raV9mbGFncyAmIElPQ0JfSElQUkkpDQo+ICAgCQliaW9f
c2V0X3BvbGxlZCgmYmlvLCBpb2NiKTsNCj4gICANCj4gKwlpZiAoaW9jYi0+a2lfZmxhZ3MgJiBJ
T0NCX1VTRV9QSSkgew0KPiArCQlyZXQgPSBfX2Jpb19pbnRlZ3JpdHlfYWRkX2lvdmVjKCZiaW8s
IGlvY2ItPnBpX2l0ZXIpOw0KPiArCQlpZiAocmV0KSB7DQo+ICsJCQliaW9fcmVsZWFzZV9wYWdl
cygmYmlvLCBzaG91bGRfZGlydHkpOw0KPiArCQkJZ290byBvdXQ7DQo+ICsJCX0NCj4gKwl9DQo+
ICsNCj4gICAJc3VibWl0X2JpbygmYmlvKTsNCj4gICAJZm9yICg7Oykgew0KPiAgIAkJc2V0X2N1
cnJlbnRfc3RhdGUoVEFTS19VTklOVEVSUlVQVElCTEUpOw0KPiBAQCAtMjUyLDYgKzI3NCwxNiBA
QCBzdGF0aWMgc3NpemVfdCBfX2Jsa2Rldl9kaXJlY3RfSU8oc3RydWN0IGtpb2NiICppb2NiLCBz
dHJ1Y3QgaW92X2l0ZXIgKml0ZXIsDQo+ICAgCQlwb3MgKz0gYmlvLT5iaV9pdGVyLmJpX3NpemU7
DQo+ICAgDQo+ICAgCQlucl9wYWdlcyA9IGJpb19pb3ZfdmVjc190b19hbGxvYyhpdGVyLCBCSU9f
TUFYX1ZFQ1MpOw0KPiArDQo+ICsJCWlmIChpb2NiLT5raV9mbGFncyAmIElPQ0JfVVNFX1BJKSB7
DQo+ICsJCQlyZXQgPSBfX2Jpb19pbnRlZ3JpdHlfYWRkX2lvdmVjKGJpbywgaW9jYi0+cGlfaXRl
cik7DQo+ICsJCQlpZiAocmV0KSB7DQo+ICsJCQkJYmlvLT5iaV9zdGF0dXMgPSBCTEtfU1RTX0lP
RVJSOw0KPiArCQkJCWJpb19lbmRpbyhiaW8pOw0KPiArCQkJCWJyZWFrOw0KPiArCQkJfQ0KPiAr
CQl9DQo+ICsNCj4gICAJCWlmICghbnJfcGFnZXMpIHsNCj4gICAJCQlzdWJtaXRfYmlvKGJpbyk7
DQo+ICAgCQkJYnJlYWs7DQo+IEBAIC0zNTgsNiArMzkwLDE1IEBAIHN0YXRpYyBzc2l6ZV90IF9f
YmxrZGV2X2RpcmVjdF9JT19hc3luYyhzdHJ1Y3Qga2lvY2IgKmlvY2IsDQo+ICAgCQl0YXNrX2lv
X2FjY291bnRfd3JpdGUoYmlvLT5iaV9pdGVyLmJpX3NpemUpOw0KPiAgIAl9DQo+ICAgDQo+ICsJ
aWYgKGlvY2ItPmtpX2ZsYWdzICYgSU9DQl9VU0VfUEkpIHsNCj4gKwkJcmV0ID0gX19iaW9faW50
ZWdyaXR5X2FkZF9pb3ZlYyhiaW8sIGlvY2ItPnBpX2l0ZXIpOw0KPiArCQlpZiAocmV0KSB7DQo+
ICsJCQliaW8tPmJpX3N0YXR1cyA9IEJMS19TVFNfSU9FUlI7DQo+ICsJCQliaW9fZW5kaW8oYmlv
KTsNCj4gKwkJCXJldHVybiByZXQ7DQo+ICsJCX0NCj4gKwl9DQo+ICsNCj4gICAJaWYgKGlvY2It
PmtpX2ZsYWdzICYgSU9DQl9ISVBSSSkgew0KPiAgIAkJYmlvLT5iaV9vcGYgfD0gUkVRX1BPTExF
RCB8IFJFUV9OT1dBSVQ7DQo+ICAgCQlzdWJtaXRfYmlvKGJpbyk7DQo+IEBAIC0zNzcsNiArNDE4
LDI3IEBAIHN0YXRpYyBzc2l6ZV90IGJsa2Rldl9kaXJlY3RfSU8oc3RydWN0IGtpb2NiICppb2Ni
LCBzdHJ1Y3QgaW92X2l0ZXIgKml0ZXIpDQo+ICAgCWlmICghaW92X2l0ZXJfY291bnQoaXRlcikp
DQo+ICAgCQlyZXR1cm4gMDsNCj4gICANCj4gKwlpZiAoaW9jYi0+a2lfZmxhZ3MgJiBJT0NCX1VT
RV9QSSkgew0KPiArCQlzdHJ1Y3QgYmxvY2tfZGV2aWNlICpiZGV2ID0gaW9jYi0+a2lfZmlscC0+
cHJpdmF0ZV9kYXRhOw0KPiArCQlzdHJ1Y3QgYmxrX2ludGVncml0eSAqYmkgPSBiZGV2X2dldF9p
bnRlZ3JpdHkoYmRldik7DQo+ICsJCXVuc2lnbmVkIGludCBpbnRlcnZhbHM7DQo+ICsNCj4gKwkJ
aWYgKHVubGlrZWx5KCEoYmkgJiYgYmktPnR1cGxlX3NpemUgJiYNCj4gKwkJCQliaS0+ZmxhZ3Mg
JiBCTEtfSU5URUdSSVRZX0RFVklDRV9DQVBBQkxFKSkpIHsNCj4gKwkJCXByX2VycigiRGV2aWNl
ICVkOiVkIGlzIG5vdCBpbnRlZ3JpdHkgY2FwYWJsZSIsDQo+ICsJCQkJTUFKT1IoYmRldi0+YmRf
ZGV2KSwgTUlOT1IoYmRldi0+YmRfZGV2KSk7DQo+ICsJCQlyZXR1cm4gLUVJTlZBTDsNCj4gKwkJ
fQ0KPiArDQo+ICsJCWludGVydmFscyA9IGJpb19pbnRlZ3JpdHlfaW50ZXJ2YWxzKGJpLCBpdGVy
LT5jb3VudCA+PiA5KTsNCj4gKwkJaWYgKHVubGlrZWx5KGludGVydmFscyAqIGJpLT50dXBsZV9z
aXplID4gaW9jYi0+cGlfaXRlci0+Y291bnQpKSB7DQo+ICsJCQlwcl9lcnIoIkludGVncml0eSAm
IGRhdGEgc2l6ZSBtaXNtYXRjaCBkYXRhPSV6dSBpbnRlZ3JpdHk9JXp1IGludGVydmFscz0ldSB0
dXBsZT0ldSIsDQo+ICsJCQkJaXRlci0+Y291bnQsIGlvY2ItPnBpX2l0ZXItPmNvdW50LA0KPiAr
CQkJCWludGVydmFscywgYmktPnR1cGxlX3NpemUpOw0KPiArCQkJCXJldHVybiAtRUlOVkFMOw0K
PiArCQl9DQo+ICsJfQ0KPiArDQoNCklzIHRoZXJlIGFueSByZWFzb24gYWJvdmUgY29kZSBpcyBu
b3QgbW92ZWQgaW50byBpbmxpbmUgaGVscGVyID8NCg0KPiAgIAlucl9wYWdlcyA9IGJpb19pb3Zf
dmVjc190b19hbGxvYyhpdGVyLCBCSU9fTUFYX1ZFQ1MgKyAxKTsNCj4gICAJaWYgKGxpa2VseShu
cl9wYWdlcyA8PSBCSU9fTUFYX1ZFQ1MpKSB7DQo+ICAgCQlpZiAoaXNfc3luY19raW9jYihpb2Ni
KSkNCj4gDQoNCg==
