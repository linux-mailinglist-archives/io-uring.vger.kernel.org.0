Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8F21250A04D
	for <lists+io-uring@lfdr.de>; Thu, 21 Apr 2022 15:04:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230151AbiDUNG6 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 21 Apr 2022 09:06:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56666 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230094AbiDUNG5 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 21 Apr 2022 09:06:57 -0400
Received: from mx0a-00082601.pphosted.com (mx0b-00082601.pphosted.com [67.231.153.30])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0D92833A26
        for <io-uring@vger.kernel.org>; Thu, 21 Apr 2022 06:04:07 -0700 (PDT)
Received: from pps.filterd (m0001303.ppops.net [127.0.0.1])
        by m0001303.ppops.net (8.16.1.2/8.16.1.2) with ESMTP id 23L7umXj008103
        for <io-uring@vger.kernel.org>; Thu, 21 Apr 2022 06:04:07 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : references : in-reply-to : content-type : content-id
 : content-transfer-encoding : mime-version; s=facebook;
 bh=dmJTzpc4dwtRHHi3mWw8dbQdklI3gUWSsaUnm7LvABo=;
 b=FGJAYpDkx1Un6ulj1Ye4IdnJxg81PdQ114SD+xnP5ZnF9yxIrTa7BNtC51mqp9M9+0iJ
 8PuEF/cb/N7OhGJDsO09hcmYdF+JTqm2rngkJg5+xfPKKVJ5Q2FPYoWuEKkKLqVlXCPK
 FKGwvIdZqpqgWxw6yXCiF5EN2oAA9IcJ5TI= 
Received: from nam10-mw2-obe.outbound.protection.outlook.com (mail-mw2nam10lp2105.outbound.protection.outlook.com [104.47.55.105])
        by m0001303.ppops.net (PPS) with ESMTPS id 3fj7k3jc5t-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <io-uring@vger.kernel.org>; Thu, 21 Apr 2022 06:04:06 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=aP3YweubTYbYA5a6+gFynON2sBYYx3U9ixOyYwPrOOJUVUlLhqz2QTFG+ca2YR7Fn3yTS+8CYUVxwo4GRDEKpb5CkiHajMqQh+4OnZzqAfARySTsX+WenvmBb8y5lpBdaobOmOI5xeeBwRqmBR9RCcYm3l/nqq2BMBlqpb7zn6E7mPCgmWR3LMWl0ofWHpLdDxRhoQ7QfcNcN2aaKL5LiScVmTJAdnekhyjXnjl4lgQsXSigsyiRh2J5qvaioQLayP7+of5yLp+H8InrLfPDExHDWKDK8OUEuBLUFoV7OtbefhJriuoQKIXe9WnpICzWB7eUje1p22Vqn9f20nvjxQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=dmJTzpc4dwtRHHi3mWw8dbQdklI3gUWSsaUnm7LvABo=;
 b=F1f0jRnUSP16BBm2lHprVVWE5Q3U9vr8+LiWogLHZRuS/nlSGppteTLDx4xSCJUJDD7tDQaDhdtYZGTSVUsEgxGZM9idIsrzCyWoobu9Vo4NvTjKvvkHRrOB4vHYDlHYLGJQvdW84WVtsdh1uUZ0PVB6t1WHI0QeflqG/DYx5jp8P3RmZ1N5MMdjV4onBwIB2VcAf0urYDieMCqoWJxyFU1xU6D5lxAn5U6CgRx+xXAuBSIOVNQQUyNWfzFN96NnFr62HNLmpKEkRqC4zKZQkVMqFMhmWst5Djs1I/zFKLrOOSiwTr/ugi8OIu7nWxPiOtB1PxX1YRqjKbj1DQOXog==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
Received: from SA1PR15MB4854.namprd15.prod.outlook.com (2603:10b6:806:1e1::19)
 by BY3PR15MB4802.namprd15.prod.outlook.com (2603:10b6:a03:3b5::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5186.15; Thu, 21 Apr
 2022 13:04:04 +0000
Received: from SA1PR15MB4854.namprd15.prod.outlook.com
 ([fe80::9c42:4b28:839d:9788]) by SA1PR15MB4854.namprd15.prod.outlook.com
 ([fe80::9c42:4b28:839d:9788%6]) with mapi id 15.20.5186.015; Thu, 21 Apr 2022
 13:04:04 +0000
From:   Dylan Yudaken <dylany@fb.com>
To:     "ammarfaizi2@gmail.com" <ammarfaizi2@gmail.com>
CC:     Kernel Team <Kernel-team@fb.com>,
        "axboe@kernel.dk" <axboe@kernel.dk>,
        "asml.silence@gmail.com" <asml.silence@gmail.com>,
        "io-uring@vger.kernel.org" <io-uring@vger.kernel.org>
Subject: Re: [PATCH liburing 5/5] overflow: add tests
Thread-Topic: [PATCH liburing 5/5] overflow: add tests
Thread-Index: AQHYVWCvzNloH2P+Y0eKmXA3OhR8uKz6P4iAgAAWQ4A=
Date:   Thu, 21 Apr 2022 13:04:04 +0000
Message-ID: <58eb54d2d596b5f9ffbed4b3e82848de1fa77b80.camel@fb.com>
References: <20220421091427.2118151-1-dylany@fb.com>
         <20220421091427.2118151-6-dylany@fb.com>
         <b98c1c0c-fcc8-4c0a-86bd-e95f0c0ab25a@gmail.com>
In-Reply-To: <b98c1c0c-fcc8-4c0a-86bd-e95f0c0ab25a@gmail.com>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: f8a3647f-1d9b-4a6e-179d-08da23976974
x-ms-traffictypediagnostic: BY3PR15MB4802:EE_
x-microsoft-antispam-prvs: <BY3PR15MB4802433ABB083E69058D69F3B6F49@BY3PR15MB4802.namprd15.prod.outlook.com>
x-fb-source: Internal
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: ZROvLJC/gtI0Hyq4DfaI3264riKPg+YtnOTo4JEIFRQFD35jGy4rmrXXswkntJY07CiJAKgS9N8la4B9Un2ZZbstEX1G82FLj8YbgsCj8qc2vMeM/OyymFhGn9c+Lc+UFy2WpMYf0FABsu4GWzbrab+PWZgIrh+AvENHuf0iPlSBBMZI7nlGHweWTpAtLQxt2Townnev7BauBQBoqgt6iPmCQiUfvD1NuTX/jdVr5RlXZrc/7gTMIUCgeZtcRujaOG6OieUEPm7PV9pbW8XUZsQyQW1jYRRBu+SFvvEi7d9gzhW2LM5MFlS+G0YgMXeezfJ2zkeYDg+p8D1UEnZSM3Jic349dLqPE3QZ3kvyvD2A13M+v7Gn6BHsdfXr1bcLpyi2lyYzxBd7P4/z/mgMxLh3dHTDG7s7C0b8750Z7YiqfjGL1fIhZqVb3XOi8E7mBx+atBMTLN2k096LgrZjf0p+2JfE2itczRHiyaMcPt9d02hPPas4365yhx00ik7bW41SfW3buEXfrbfpKclFr1rWVj1RaJ/7O0gyxyacSZCs1pyArA++nl4FP5W2RQE2wsJNvgcV+p2I6QXNzrenftDtvKF4FokYInlp3xeGWMQ5qbKcFOnfvnSMiXtoKsI/Y+Q0BD9U7tRhmVCmPOQjQ+FYeKlWmk0D34bfKF44dy4Srgm38L331v1mSDdcznbX5MuYlzIEpbXBgw6928WWng==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR15MB4854.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(66946007)(76116006)(64756008)(66476007)(66556008)(4326008)(71200400001)(8676002)(66446008)(5660300002)(6916009)(6486002)(83380400001)(2906002)(91956017)(36756003)(6512007)(6506007)(2616005)(86362001)(122000001)(316002)(8936002)(38100700002)(186003)(38070700005)(508600001)(54906003)(53546011);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?UFloTVgvZ2N2V0pDdURUS0pUNFpFOEFNTjlzUi9kMHgzTTFScDB6WW85U0dv?=
 =?utf-8?B?VFg4NS9JQ1B3M2VlaHdpdlpXOU8yZllvT0JDWnRYM1VmYndVd05heHNyRkVm?=
 =?utf-8?B?MzEvT29YNThOK1MxbGZReDRVWDdrendMZXRQSVJMWStwK2t5eXczMGZxdjBr?=
 =?utf-8?B?LzFzQktpQzEyLzdqZEFuOStxMmhWNW5ULzUwVjhMeDRMeU9lcnhNU1BiTEJK?=
 =?utf-8?B?NlZzeURmWkdiY1JPeGs0R0dhamtmYzJ0ejB1cmdpd3lKekdDVVhOdFdZWmt2?=
 =?utf-8?B?bGk3YW5RS2lkT1lXSDhOUytlYm0wc2xrcytKK3U0R0hDRFlKNmdZbmVhRTVx?=
 =?utf-8?B?QWFqZ2p4aGQzV0thQTB2MFBxd2wwOXdlWkpYbVB1WEhXWXBpK0dKU2tseUtQ?=
 =?utf-8?B?ckxpKzVreGhpbzlpUkVhVklJYWlXQmpHb0xKWWc0MWZhcncrNkV6WE41elBJ?=
 =?utf-8?B?S0N5bmFkckdTc2k2QnM0TklGNHowVGxrVDY0bVQydmc4VElSbmR4cUQ5TTdE?=
 =?utf-8?B?ZjhhTGNXNGRKZ1NCVFFjemkxMXFZYTZ5eDM5eS9xZFdUZzgyWE91T0hrbFZS?=
 =?utf-8?B?WXFQVXhTei9hY0RqL0tmTWY1a2hyL0kwTmw4OXNjNXY0MkhxSFVhRUc4Ny9M?=
 =?utf-8?B?VjByWkxVVXhaWXhkK2xVSWNRYStQZUNNUkxiNVpIMjROZU9NTzNTMVhZTVRN?=
 =?utf-8?B?ZElLUVVvNisvSnJGM1Y3dU9tVGpGbDhpYmhEVzBWVlpuWWlZeGVHR0Fpb2Fk?=
 =?utf-8?B?bHZ1SDRrc3lyTWhrbTRPU0E1WS9Sc283UHNqSzJnUFVNdC9WWGRsNENjT1RR?=
 =?utf-8?B?VEZSSktIQ1ExNTA2bkNLejc4VmgzbzhYQVh3bmxnRkJOL2s0WlNDNEFTSTJk?=
 =?utf-8?B?bXF6QkllWkNzU096b2hmRHV5bXJpcDNLTEhVU2JqMlRuV0J6cU1kbS92WFM3?=
 =?utf-8?B?SENhUnlBSnFMNW1jWG5oakJYOUdBVFk4bWtBcXY3UERpZGp5VFc3eW5hc2k0?=
 =?utf-8?B?THNiLzlrK2pzQjh2TGJYSzNjVzBxZmMrS2NzY21RcDUzUE5FOXlSWnlUN1dl?=
 =?utf-8?B?VEVzbXlBbWM2M01qc0JnRjdUQXcvV20yb01vR1JrY1U4ZVdsdFFwd08rSEVS?=
 =?utf-8?B?SVNXVTBKTjZaeGRiRzFWNTdNaXorc1loS0ZkbE5xdEJNYXlxeC9EQ0JrYmN0?=
 =?utf-8?B?anhsMGxGRW1VVGtESStCUSszb25tTFExR3JZcW4xLzA4RDRjTXJYd0dmS041?=
 =?utf-8?B?cUkvWUNVTEN5TmtvVkRhSzBOUmtoOWE0Y1Q2dWtFWWxGeVNSYkoyUDJDYkht?=
 =?utf-8?B?MnZxU1M4cFB1YU5POFFhSFNYRld6TW5lUXh3b1Brbnp5TUJhdks0TjZJUEVD?=
 =?utf-8?B?cEhub1RYS1VTU2p2ZHRWeWJlUE1rRTFxcS9yTmRzZDR5UG9ndE0vbDJCcXVC?=
 =?utf-8?B?ZXJPbWJIekM3V29WbWxkcXlSQUlRR0luQndiYWltc1o1TXRMb0NvQmdSazJB?=
 =?utf-8?B?amw1WUhZdW1XZmxWWjJUMEkzdkE3OHgwMmFQSnlzby9ydSs5WVZYVGtzaUVl?=
 =?utf-8?B?ZzBwQjNyMzRDYk9kVUNReFBrYm03ckphbjBZSG8xeW1TMGZJcWxNbDVJMkw1?=
 =?utf-8?B?aWM4dUxiaTFrV1RlK0QvYTRJSkxGdEtlTm9EWVhqOHBmV1BuMUV1WTQrd2FM?=
 =?utf-8?B?azJUWlJ2OHFpcG5SOHFyaWNWbFlGVjluYzkzaVI1bGMyR1BzMEVQOEFaSzQz?=
 =?utf-8?B?UEQxK2J6bWY1TXo2NmRjdGpxN2xDbFBtRVVVck9jdmtMTlFiZWdvVUIrVjA3?=
 =?utf-8?B?K21JV1pwKzFUSExCN0tFblBsTTczUlFBNE00R2luR1lDeXNwNTlmRWxmT3JQ?=
 =?utf-8?B?UUpkcjlkWTM5MGplRGQ3eFpLK05McmkxYzhVb282alB4M3BaNDc0VXRsQ0xk?=
 =?utf-8?B?enNoQm9OcDV4VzZLS2xKNlpLMkQ3dlFRTzhTcjR5QUlPU0FEQmwrNkE0Rll1?=
 =?utf-8?B?ZWp1YVFpRGRmd2lMQzdGTHYxVjlReTFtRVh0bkNwdjM0dHE2NlNHeXV6ck9o?=
 =?utf-8?B?bnd5RmluSjdHZGRkU1BYUGltWDBqbDEveWtUWTlsQTVyMnBRcUh1SU5qN3FD?=
 =?utf-8?B?cjd1R254NzBOQWZwWW1Bd0dwaFhwOTYvaXBONWhEU2JmZ0gyZEhhd0tabklJ?=
 =?utf-8?B?Y04yUC9ORWJlNEVBL1FSOXV4L2lZS2lmUXNDczdETHJXek1yQzlSOElPeEtl?=
 =?utf-8?B?cFdTMUlYanhPV2s1QUpodHY1Z3JOMExmVTNGYXVwNGg2N0ZlT1grenRBSmJK?=
 =?utf-8?B?WVNRRXNuZGRKK2RNVDE5dnpTSWk1d0phdERqYXVHN0kzNUVUa1Q3aU9pSHJT?=
 =?utf-8?Q?MfYgXt4Oor6HrSDE=3D?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <E436DFDEF7BCA14DA05CE32B41DAE0A1@namprd15.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: fb.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SA1PR15MB4854.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f8a3647f-1d9b-4a6e-179d-08da23976974
X-MS-Exchange-CrossTenant-originalarrivaltime: 21 Apr 2022 13:04:04.2440
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: O8IKht7HBfeAkk5oq7LExwSPT68fDylWWDzgpgiMdlI1wC00YzDq/JGIIS/HGUeS
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY3PR15MB4802
X-Proofpoint-ORIG-GUID: HakZqOBtMTm_xPSin-yvSeSrB082-7mj
X-Proofpoint-GUID: HakZqOBtMTm_xPSin-yvSeSrB082-7mj
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.858,Hydra:6.0.486,FMLib:17.11.64.514
 definitions=2022-04-21_01,2022-04-21_01,2022-02-23_01
X-Spam-Status: No, score=-2.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

T24gVGh1LCAyMDIyLTA0LTIxIGF0IDE4OjQ0ICswNzAwLCBBbW1hciBGYWl6aSB3cm90ZToNCj4g
T24gNC8yMS8yMiA0OjE0IFBNLCBEeWxhbiBZdWRha2VuIHdyb3RlOg0KPiA+IEFkZCB0ZXN0cyB0
aGF0IHZlcmlmeSB0aGF0IG92ZXJmbG93IGNvbmRpdGlvbnMgYmVoYXZlDQo+ID4gYXBwcm9wcmlh
dGVseS4NCj4gPiBTcGVjaWZpY2FsbHk6DQo+ID4gwqAgKiBpZiBvdmVyZmxvdyBpcyBjb250aW51
YWxseSBmbHVzaGVkLCB0aGVuIENRRXMgc2hvdWxkIGFycml2ZQ0KPiA+IG1vc3RseSBpbg0KPiA+
IMKgIG9yZGVyIHRvIHByZXZlbnQgc3RhcnZhdGlvbiBvZiBzb21lIGNvbXBsZXRpb25zDQo+ID4g
wqAgKiBpZiBDUUVzIGFyZSBkcm9wcGVkIGR1ZSB0byBHRlBfQVRPTUlDIGFsbG9jYXRpb24gZmFp
bHVyZXMgaXQgaXMNCj4gPiDCoCBwb3NzaWJsZSB0byB0ZXJtaW5hdGUgY2xlYW5seS4gVGhpcyBp
cyBub3QgdGVzdGVkIGJ5IGRlZmF1bHQgYXMNCj4gPiBpdA0KPiA+IMKgIHJlcXVpcmVzIGRlYnVn
IGtlcm5lbCBjb25maWcsIGFuZCBhbHNvIGhhcyBzeXN0ZW0td2lkZSBlZmZlY3RzDQo+ID4gDQo+
ID4gU2lnbmVkLW9mZi1ieTogRHlsYW4gWXVkYWtlbiA8ZHlsYW55QGZiLmNvbT4NCj4gPiAtLS0N
Cj4gDQo+IER5bGFuLCB0aGlzIGJyZWFrcyAtV2Vycm9yIGJ1aWxkIHdpdGggY2xhbmctMTUuDQo+
IA0KPiBgYGANCj4gwqDCoCBjcS1vdmVyZmxvdy5jOjE4ODoxNTogZXJyb3I6IHZhcmlhYmxlICdk
cm9wX2NvdW50JyBzZXQgYnV0IG5vdA0KPiB1c2VkIFstV2Vycm9yLC1XdW51c2VkLWJ1dC1zZXQt
dmFyaWFibGVdDQo+IMKgwqDCoMKgwqDCoMKgwqDCoMKgIHVuc2lnbmVkIGludCBkcm9wX2NvdW50
ID0gMDsNCj4gwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoCBe
DQo+IMKgwqAgMSBlcnJvciBnZW5lcmF0ZWQuDQo+IMKgwqAgbWFrZVsxXTogKioqIFtNYWtlZmls
ZToyMTA6IGNxLW92ZXJmbG93LnRdIEVycm9yIDENCj4gwqDCoCBtYWtlWzFdOiAqKiogV2FpdGlu
ZyBmb3IgdW5maW5pc2hlZCBqb2JzLi4uLg0KPiBgYGANCj4gDQo+IE1heWJlIHlvdSBtaXNzIHNv
bWV0aGluZyB0aGF0IHlvdSBmb3Jnb3QgdG8gdXNlIHRoZSB2YWx1ZSBvZg0KPiBAZHJvcF9jb3Vu
dD8NCj4gDQoNCkFoIC0gSSBoYWQgc29tZSBkZWJ1ZyBzdGF0ZW1lbnRzIHRoYXQgd2VyZSB1c2lu
ZyBpdCBidXQgZGlkIG5vdCByZW1vdmUNCml0IHdoZW4gcmVtb3ZpbmcgdGhvc2UgKHRoZSB2ZXJz
aW9ucyBvZiBnY2MvY2xhbmcgSSBoYXZlIGRvIG5vdA0KY29tcGxhaW4pLiBJIHdpbGwgY2xlYW4g
aXQgdXAgaW4gdjIuDQpUaGFua3MgZm9yIHNwb3R0aW5nIGl0IQ0K
