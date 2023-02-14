Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 91E96696D72
	for <lists+io-uring@lfdr.de>; Tue, 14 Feb 2023 19:58:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231422AbjBNS6y (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 14 Feb 2023 13:58:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51362 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229516AbjBNS6x (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 14 Feb 2023 13:58:53 -0500
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 824D225964;
        Tue, 14 Feb 2023 10:58:50 -0800 (PST)
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 31EHwoDh012585;
        Tue, 14 Feb 2023 18:58:48 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : references : in-reply-to : content-type :
 content-id : content-transfer-encoding : mime-version; s=corp-2022-7-12;
 bh=1jAwK1QFspMmAR44BbUZbUMpoVJScdoKPyZlHtrPE+Q=;
 b=Zbks9BkOo71A3JnVPPrMIrjM848J6AVpVCVfj/Zvx/QkHBqEbERH1cctZh2dNISlif6x
 dCecZn4UZEFopt1XD/JAmUAA0Zui+ScluxGvYmacVNd1EXw7DmFrDmI52iNwyl67990K
 dt+lhZzkW3eX4WOjoxYnS+HsFBzMwzN+0dr+YyNwhcJI+t387sTABMIjsavWwhTaN3IG
 TULbJHCUDnBZ2TMo/EWDmOROu2bNiJT+yo6tzWOLNlZx7+m/Y+0mR54jgjrpf7LhX2Ow
 r9GY14FeWwwu7O5CMspiFykMlCBRFa9G55oTReKBptS++jduGbMDaPjl3Q83qcJ7k0nD Wg== 
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3np2mte8rh-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 14 Feb 2023 18:58:48 +0000
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 31EIFldn001303;
        Tue, 14 Feb 2023 18:58:47 GMT
Received: from nam10-mw2-obe.outbound.protection.outlook.com (mail-mw2nam10lp2105.outbound.protection.outlook.com [104.47.55.105])
        by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3np1f5qu03-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 14 Feb 2023 18:58:47 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=BEswl9DuFl0xF6ZqJhjLudJxhaVbatIi9fFz1I1FgSJ4a6iGFcEAyaAo1/a9nDYZ3WViv3obJPwyYoCutnhJ1szDsiNjPvf9yAIp6oTmF1f9/PJHHp3Wf2wuMPOBeEJQm3fI4UkwBk45Gh9K8eZRS43YoJ9i9Nr/fKtRVkpIQKCDCRQ5teVBVDsze5wfI3KcvASdv+usbUgqvPR4WQeYAHISGH1ACKv5by+M5bYz5oYhgZf+OfANbu2dWzqumZ5Ncsu3ZwGCno5CvNEx86wvUJsM6JkThKPRqoRJm6l7wbe/BcsK4ISJUUWtdeE5Up4px8J11F4FfXbmXEmEX6d0zw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=1jAwK1QFspMmAR44BbUZbUMpoVJScdoKPyZlHtrPE+Q=;
 b=NKOu8m5ytfzVgAo1ix0e+J9UURZUGEDpDhLtq3fqqPQ0mBoos5UL8ymzvn6nvUFJ7vp4nA5TUJAfovfxL9Eg9T5nz0Yusd/x9LAciKD5M91fHx4siqv8IsROLQFuLvpyP6dN/jBMwYqhaPTPu02gtVx24cmxGM3jSii8arlOKzLflWRjjIza09gvI0kZTDjrF9Juu6Pt+uYCI0Yp34kDih/Xi/YVrqqPXMAPBLlJKGE7Zxsanh33aZcU9lLh86jROCA0NUm69zTkmzvPq32BnM7KCJ1pKoayXdYePdUb5xIfgQYi9NbqsUywuVIjOxG+pKOVwCLHhLopWs3/oOoT1A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=1jAwK1QFspMmAR44BbUZbUMpoVJScdoKPyZlHtrPE+Q=;
 b=rZCbBOK2wkR6CW0nYZIkhh+5TS89b06pygMRv4baNPG2qZ7S/jIdbQ1ntaJzxhE4CJaZtWlQIc7EAilGYgkxKFskYB10PY7hHpTSBONnRTITtkSfWbvcBF4m/MTTCTMH9GrRWaej4PtNg9ZUfV/deX5D3o2OTR9Y2H8XYnoIcdA=
Received: from DM5PR10MB1419.namprd10.prod.outlook.com (2603:10b6:3:8::16) by
 DS0PR10MB7431.namprd10.prod.outlook.com (2603:10b6:8:15a::7) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6111.10; Tue, 14 Feb 2023 18:58:45 +0000
Received: from DM5PR10MB1419.namprd10.prod.outlook.com
 ([fe80::d40b:5b2b:4c3d:539f]) by DM5PR10MB1419.namprd10.prod.outlook.com
 ([fe80::d40b:5b2b:4c3d:539f%11]) with mapi id 15.20.6111.010; Tue, 14 Feb
 2023 18:58:45 +0000
From:   Saeed Mirzamohammadi <saeed.mirzamohammadi@oracle.com>
To:     Jens Axboe <axboe@kernel.dk>
CC:     "io-uring@vger.kernel.org" <io-uring@vger.kernel.org>,
        "asml.silence@gmail.com" <asml.silence@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: Phoronix pts fio io_uring test regression report on upstream v6.1
 and v5.15
Thread-Topic: Phoronix pts fio io_uring test regression report on upstream
 v6.1 and v5.15
Thread-Index: AQHZLIV4mOt/DdJ4vU+NNe3w1KZyBa6v2J4igAAIpYCAAS+O5oAd4tuA
Date:   Tue, 14 Feb 2023 18:58:45 +0000
Message-ID: <15BBDF79-8063-40BE-AC19-52FA69C98492@oracle.com>
References: <20230119213655.2528828-1-saeed.mirzamohammadi@oracle.com>
 <af6f6d3d-b6ea-be46-d907-73fa4aea7b80@kernel.dk>
 <DM5PR10MB14190335EEB0AEF2B48DF6BAF1CE9@DM5PR10MB1419.namprd10.prod.outlook.com>
 <0f7cd96e-7f89-4833-c0af-f90b2c5cf67d@kernel.dk>
 <BCEB787A-38B7-4301-A3CE-A780F3AAB45D@oracle.com>
 <75e32a84-3a0d-d53f-af1b-b54c1036656c@kernel.dk>
In-Reply-To: <75e32a84-3a0d-d53f-af1b-b54c1036656c@kernel.dk>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Apple Mail (2.3696.120.41.1.1)
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: DM5PR10MB1419:EE_|DS0PR10MB7431:EE_
x-ms-office365-filtering-correlation-id: f91794dd-5bdd-4dea-c8af-08db0ebd7fad
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: oM/5poB5c5BTLZWtwPfWcuA12wdrfBk/dhdl2f+n2093GRaiZZM56jFYJ6M4MXLp7gmbMnRWEkiGtlj+Jh/CBvAfhoSgPWps6AElrAtR2zqUEvH6aR67C4sB1XN7QIDRa9RMWOwO6OlE8BLBXDmBe257avD4o4EocPHXugD/BndYkeT5Ks9cNqzdpbMJW3z3k+0+XgOC8ARVeIMFJf47z2TB0ngmJIGrfFQfbkfO+DN3o8GpRUsjRV6dtgdzd0n9BxTGeBw2gVQgmemtFOdUYj8AO0nR37IqRzXcaWp08KOvdFyFhkmyVnDpKLlIQeYTCMiZPRocermafkiPvPlx6KtgCJHh4NzvVv1bN7sixBOGITlq8uHAJzWbpQCVg/lbSIVwjjwry1RzuhnyRa2KlaktWChsLMCBRuFH+XCEzuT5n/PD/HJhOkNiaQILFjgx+ToE3I774iydCDDxNWqKAnPTGyDOdc+INyPltfKY4Qn7VnQxHwV/P+FjUXf2/c4kp92VYykCp59gejDuzwhNP4GuFSO6D02Gu8JRZoageSFQudWwKuDyOafMZJ4GoOhMmA88yS9MJ/+58qOCnDXsqsPpFVEe1PfZb3U3jJ1yxl/vuVtg7rIxxazZcZ9gROH8zcjxjQQ0I4TIHMUCsYjFhTeDWvwmKstDltOTZvwjf13EWpX1sE7dWKnJ6YlIEZh7pffOORnA8wPr4E1ksnoBwwykE2auzHBJh2tp0fBhjF4=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR10MB1419.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(39860400002)(376002)(366004)(396003)(136003)(346002)(451199018)(2906002)(6506007)(36756003)(41300700001)(33656002)(38100700002)(66946007)(8676002)(6916009)(91956017)(66556008)(86362001)(64756008)(66476007)(5660300002)(76116006)(66446008)(8936002)(38070700005)(478600001)(6486002)(186003)(2616005)(316002)(122000001)(71200400001)(4326008)(83380400001)(53546011)(6512007)(44832011)(54906003)(45980500001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?OGdWSGNJR1hTRUxWdjk2NnliTWZGdmNTSURkblY0VXN4MkU3azN0N1RzN09o?=
 =?utf-8?B?aWxjdG56OUx1WVZyN1dCcnpvdWVsUFE1a2d5V2FyQ3gyb1ZzS3FYR1pJN1hP?=
 =?utf-8?B?SlpabHp4a24wZ3N6b2NFZDVEZzlwRXdOZFZiUzM4dXVsanY3WlVSMjh6d0pi?=
 =?utf-8?B?V1hDcHlLeWZjU3NDZFhRTCtHK1RRTUV6L0hxckNhdGs3SkY1VEFMaVJlVjNz?=
 =?utf-8?B?TTFRU1NRTm5uOVcybjJoRWhiUnNUcUJrZ0hScGdub1JPbTFJNjFLSDFSQnNz?=
 =?utf-8?B?RWRTUlEyeFBSRjdIUFVDVUZVbWw5eVpLdEhMZEtyNm9xekIva1hBRTIwVWNH?=
 =?utf-8?B?UmNZNUlkNFF0bFVKUDA3eXJrbGN5VEJmWVJYNWh2YUhGb2dVTDAwUFdVdFlW?=
 =?utf-8?B?VGhrTUx3aW4yKzVxaHpnY2oyKzhjektiS3BqZ3RmVVRHSWhvVElDUXBWR082?=
 =?utf-8?B?V3M0WC9WZ0lLUWJBM0JNQzJ4eGZwbTFVaWxyNFN0KzlOZFQrZHBFN01vWGdO?=
 =?utf-8?B?NzBIWVNVankwa01hOGJQYlR1eUxRbElNUHpMWTFOdWYvUU0xMG9sNHBGc0Vt?=
 =?utf-8?B?WUFyRkF3ZEdXVEVZWDJIMEkxK2VXTlJpcnpYaWhhTm5aYWV1R1l0ZDNPcGwv?=
 =?utf-8?B?dW16WUg1VnhUYXBLL2hISkxLK2E4d2dHajhkYjdZL2ZZVjRhbGl5b2hRZ1hi?=
 =?utf-8?B?MlpWRzg4bjgwKzFaeVV6WGY4WmVUMzY4NUNkQ01ONWVzSmtML1F5aGNjYU9I?=
 =?utf-8?B?ZzZ3RHR5MnRUMVdMUlBIdEoySlBJcGRGRCsrTzdFWEFNZStpRDc2SW5ydUNM?=
 =?utf-8?B?cUpoUUhFTUVGR1hmNmRmdktZQlhFMjlRaXdyK01SSm9YMEhiQTNRb0xuZUUx?=
 =?utf-8?B?bmkvT3JCTXRkM1A3TVF4TExIRGtpRTc0SzdXVFBLS0g4a1lZMlZ3WUZJeU9Y?=
 =?utf-8?B?TFVjL3ZTZGxwb2xpYnZ6QTJUNy9wWVN1Ulp0MlV3Z21GT1UwWFVGR20rQ1g3?=
 =?utf-8?B?VlRRWkEyT0R3bFFrUGFsSW40YUhTOTFCOUs3YzdyVzNONm4xcFNTOVFRMTdG?=
 =?utf-8?B?enZNdXdCSnZZOVNiWldmK2FlRlJHVFRhNUxzWFlCa0hXMHhqd3pmbTBTZlNZ?=
 =?utf-8?B?dmxDZTY1a1o3Zm9NSkFEUWUxRlZpaWxLY24yMkFWNnM5UmhaNkluMWtjSWZn?=
 =?utf-8?B?TmxvN1d5SFU1WkZ1c0NEcDNlQUxlSXk4ZE15eW5wa3R0c3h6SDdVN21ZTjJ6?=
 =?utf-8?B?TDAzZWNTbkErOHB5V1JPWkZla3ViYnR5S2JqN3ZvU2lXSCtrRUNHR3Bvcjds?=
 =?utf-8?B?RjlOWjlRYy9BWG1SSkpwUDNBa0srVDE0eHdmemVMaXBZbEVmZzVoT1YzdXJt?=
 =?utf-8?B?WFVRcVBGcG5lNmlET0J0WTdvQ2tmUkljbXBOYXJsOGlUK05UWjRKMy9pU21V?=
 =?utf-8?B?SlN6RUJZVkhRVHovSWM5UDZIalRuSzdxU3hVdTlGNDFGSklKclIwcFhnOWQz?=
 =?utf-8?B?cEloOEpwUklIMzNyeWJoS2JONlpxbDZxUm1kN0czVVhzWWFQa2RmelZTOWdO?=
 =?utf-8?B?bCtjNldtcFhzeDQwNzd3R0JiNHRPUzk1Vkp4aTFFTlNPRjU4OTYrRzAxdUc5?=
 =?utf-8?B?RWxSQytISHQ5THJTSUFFVE5nRDBMV1lJQ1BlblRnZ0dJbEpIbzBzam80L2E2?=
 =?utf-8?B?S2phekVJSWNaQkRWL2Q0UldpNVhyRmRvaTRIbzBMNk1hd0MvRFJWMVJoL3ZY?=
 =?utf-8?B?eWNwMHRPV0RNQktWNTQvWXZSdnh4NVA3cld1S1Z3RURUWGxqdTl6QmRLR2Ex?=
 =?utf-8?B?QllNcHRsNE5VMmhJdnVmOS96bEw3OFJMa2tHODRQM1FuRjRLYlpsWjZkTCt2?=
 =?utf-8?B?UFdkaFV0czlodFNDODlGb0JrWFV4bEJGUE9KNEZsNnlydVE5OG9FVTRuY0pt?=
 =?utf-8?B?M1dHaGJ1OVdQY0pTQ0Q5N1ZBT1FNUUoyUHdzek5Hd0dqa0M5NUNmbHN0V0xN?=
 =?utf-8?B?NWlFdm1yMXB2aVhPN2g4YXd4c0tKUXFEemsxVTVZd1lrcnZ0SFpoVmF1dG50?=
 =?utf-8?B?bld2bi9OVUU4dmJZVEQ1dGxscWI5STZUQU5ZVGNHN3BvRE92NXk2QWdBN1d4?=
 =?utf-8?B?cC94WWZjaVVVWUxjcVZDVFVhQlVIdFJQd2xsSVhoVE9FY3NEUGdseWdwM1B5?=
 =?utf-8?B?cjB6T3BUbmlwOTZMSlJaOGIwaEozWmV3R3cwd1Jab1FNVlU5RjFSalc2VHlx?=
 =?utf-8?B?RW1QRE1aVXNDaDRObkVVd0tYYUhRPT0=?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <A06787D1095F1745BC784833307D1E34@namprd10.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: 7oyJxY/A46gWL8rZ0WHDJItNGjndW59DWLFYt2z8G+XpEUBdKxX3N8rmOSZnOiYgKZRzkVlc0Q9osw2xufCA163yNa11XfTcfmIoR0QQViWzasbS9UBAQy3fT5ysBkyRKfJOMcHkECD3Z4/0ix9lG7b5jTiStmkt/yng+xgk7jr+3MT0W91RW1+hKcQu2kQv+/F12NdbG3oFprMsRlGznXTLKUtsEoo59/wjntB1g2h9cjmR4c34ZWdbdxS61wjvIxLjKkjCfzxXq/a18njfb8MTo0kZ5deDhnrE7e1rFYbbqVSKnglI0S+0tVM2shAsAkuGAAsNm3Z+nTb8aWWAcAwG7S8VPNXh2iXOGzpgEnAep7rVakeluneh3N9rSv1B7R6LztUGqZvU2GANfA9e9Cza3ZPEwDgFozYxqdtikf3vc2ymppvcfD0qQS8Eh/cAK/xOUDuGGUCX1gEndlUR8lE8bJ3cTP/UQzsCOCiJLylSrNfXjbdDhIcxtMEElvitt1u4YwFlK/Rx+Bi2i2A9+2K/d4GATz2P395NWNKZz0WqAO40TR3w6TOuOGmV0NJbkEF4lq7GiLjG2UkWcpClud4LjbER+R5ARerzphT400r516AkC4Dhsqdo/6DE76fkO8RPWq2iaVBY73s5XRWfqs813qZFvckAaSftGWVILHaJOnDvtHw8GkPktiYkR8Mwye+PS6CcyLRu4L/ZYKKJxClJs5b4koAwOgO+Yhv2ssqvjqO2pGjlP/mJHGFVjealubflI+DDdQImJTZLB0qyOrrck2saJ+rf9kQECqkyFcN6Q/ZhQtW+OOYzebZGmP2b
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM5PR10MB1419.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f91794dd-5bdd-4dea-c8af-08db0ebd7fad
X-MS-Exchange-CrossTenant-originalarrivaltime: 14 Feb 2023 18:58:45.6604
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: ubs3vCFO//P+azKDK/Yb+JVekJ0CR3BFoNAcqU3iO+ZxROvsjfzs8Gpcgj4F/sPuhwBAd4vEBY4zi81hmUeQaZ3aYql/aKxwYv1jamrYpZk=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR10MB7431
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.930,Hydra:6.0.562,FMLib:17.11.170.22
 definitions=2023-02-14_13,2023-02-14_01,2023-02-09_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 suspectscore=0
 phishscore=0 spamscore=0 bulkscore=0 mlxlogscore=999 malwarescore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2212070000 definitions=main-2302140164
X-Proofpoint-GUID: 4tkJOlV5ETQpZkNBpZmrJNbd8xFsCoJt
X-Proofpoint-ORIG-GUID: 4tkJOlV5ETQpZkNBpZmrJNbd8xFsCoJt
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

SGkgSmVucywNCg0KPiBPbiBKYW4gMjYsIDIwMjMsIGF0IDEwOjM1IEFNLCBKZW5zIEF4Ym9lIDxh
eGJvZUBrZXJuZWwuZGs+IHdyb3RlOg0KPiANCj4gT24gMS8yNi8yMyAxMTowNOKAr0FNLCBTYWVl
ZCBNaXJ6YW1vaGFtbWFkaSB3cm90ZToNCj4+IEhpIEplbnMsDQo+PiANCj4+PiBPbiBKYW4gMjUs
IDIwMjMsIGF0IDQ6MjggUE0sIEplbnMgQXhib2UgPGF4Ym9lQGtlcm5lbC5kaz4gd3JvdGU6DQo+
Pj4gDQo+Pj4gT24gMS8yNS8yMyA1OjIyP1BNLCBTYWVlZCBNaXJ6YW1vaGFtbWFkaSB3cm90ZToN
Cj4+Pj4gSGkgSmVucywNCj4+Pj4gDQo+Pj4+IEkgYXBwbGllZCB5b3VyIHBhdGNoICh3aXRoIGEg
bWlub3IgY29uZmxpY3QgaW4geGZzX2ZpbGVfb3BlbigpIHNpbmNlIEZNT0RFX0JVRl9XQVNZTkMg
aXNuJ3QgaW4gdjUuMTUpIGFuZCBkaWQgdGhlIHNhbWUgc2VyaWVzIG9mIHRlc3RzIG9uIHRoZSB2
NS4xNSBrZXJuZWwuIEFsbCB0aGUgaW9fdXJpbmcgYmVuY2htYXJrcyByZWdyZXNzZWQgMjAtNDUl
IGFmdGVyIGl0LiBJIGhhdmVuJ3QgdGVzdGVkIG9uIHY2LjEgeWV0Lg0KPj4+IA0KPj4+IEl0IHNo
b3VsZCBiYXNpY2FsbHkgbWFrZSB0aGUgYmVoYXZpb3IgdGhlIHNhbWUgYXMgYmVmb3JlIG9uY2Ug
eW91IGFwcGx5DQo+Pj4gdGhlIHBhdGNoLCBzbyBwbGVhc2UgcGFzcyBvbiB0aGUgcGF0Y2ggdGhh
dCB5b3UgYXBwbGllZCBmb3IgNS4xNSBzbyB3ZQ0KPj4+IGNhbiB0YWtlIGEgY2xvc2VyIGxvb2su
DQo+PiANCj4+IEF0dGFjaGVkIHRoZSBwYXRjaC4NCj4gDQo+IEkgdGVzdGVkIHRoZSB1cHN0cmVh
bSB2YXJpYW50LCBhbmQgaXQgZG9lcyB3aGF0IGl0J3Mgc3VwcG9zZWQgdG8gYW5kDQo+IGdldHMg
cGFyYWxsZWwgd3JpdGVzIG9uIE9fRElSRUNULiBVbnBhdGNoZWQsIGFueSBkaW8gd3JpdGUgcmVz
dWx0cyBpbjoNCj4gDQo+ICAgICAgICAgICAgIGZpby01NjYgICAgIFswMDBdIC4uLi4uICAgMTMx
LjA3MTEwODogaW9fdXJpbmdfcXVldWVfYXN5bmNfd29yazogcmluZyAwMDAwMDAwMDcwNmNiNmMw
LCByZXF1ZXN0IDAwMDAwMDAwYjIxNjkxYzQsIHVzZXJfZGF0YSAweGFhYWIwZThlNGMwMCwgb3Bj
b2RlIFdSSVRFLCBmbGFncyAweGUwMDQwMDAwLCBoYXNoZWQgcXVldWUsIHdvcmsgMDAwMDAwMDAy
YzVhZWI3OQ0KPiANCj4gYW5kIGFmdGVyIHRoZSBwYXRjaDoNCj4gDQo+ICAgICAgICAgICAgIGZp
by0zNzYgICAgIFswMDBdIC4uLi4uICAgIDI0LjU5MDk5NDogaW9fdXJpbmdfcXVldWVfYXN5bmNf
d29yazogcmluZyAwMDAwMDAwMDdiZGI2NTBhLCByZXF1ZXN0IDAwMDAwMDAwNmI1MzUwZTAsIHVz
ZXJfZGF0YSAweGFhYWIxYjNlM2MwMCwgb3Bjb2RlIFdSSVRFLCBmbGFncyAweGUwMDQwMDAwLCBu
b3JtYWwgcXVldWUsIHdvcmsgMDAwMDAwMDBlM2U4MTk1NQ0KPiANCg0KVGhhbmtzIGZvciBsb29r
aW5nIGludG8gdGhpcy4NCg0KPiB3aGVyZSB0aGUgaGFzaGVkIHF1ZXVlZCBpcyBzZXJpYWxpemVk
IGJhc2VkIG9uIHRoZSBpbm9kZSwgYW5kIHRoZSBub3JtYWwNCj4gcXVldWUgaXMgbm90IChlZyB0
aGV5IHJ1biBpbiBwYXJhbGxlbCkuDQo+IA0KPiBBcyBtZW50aW9uZWQsIHRoZSBmaW8gam9iIGJl
aW5nIHVzZWQgaXNuJ3QgcmVwcmVzZW50YXRpdmUgb2YgYW55dGhpbmcNCj4gdGhhdCBzaG91bGQg
YWN0dWFsbHkgYmUgcnVuLCB0aGUgYXN5bmMgZmxhZyByZWFsbHkgb25seSBleGlzdHMgZm9yDQo+
IGV4cGVyaW1lbnRhdGlvbi4gRG8geW91IGhhdmUgYSByZWFsIHdvcmtsb2FkIHRoYXQgaXMgc2Vl
aW5nIGEgcmVncmVzc2lvbj8NCj4gSWYgeWVzLCBkb2VzIHRoYXQgcmVhbCB3b3JrbG9hZCBjaGFu
Z2UgcGVyZm9ybWFuY2Ugd2l0aCB0aGUgcGF0Y2g/DQoNCkkgdGVzdGVkIHdpdGhvdXQgdGhlIGFz
eW5jIGZsYWcgYnV0IGRpZG7igJl0IHNlZSBhbnkgY2hhbmdlIGluIHRoZSBwZXJmb3JtYW5jZS4N
Cg0KSSBoYXZlbuKAmXQgdGVzdGVkIGFueSByZWFsIHdvcmtsb2FkIHlldC4gSeKAmWxsIHNoYXJl
IHdpdGggeW91IGlmIEkgbm90aWNlZCBhbnl0aGluZy4NCg0KVGhhbmtzLA0KU2FlZWQNCg0KcC5z
LiBJIGV4cGVyaWVuY2VkIG11bHRpcGF0aGQgaXNzdWVzIHdpdGggdGhlIHBhdGNoIHRoYXQgSSBo
YWQgdG8gd29yayB0aHJvdWdoLiBOZXZlciB3aXRob3V0IHRoZSBwYXRjaC4NCg0KPiANCj4gLS0g
DQo+IEplbnMgQXhib2UNCg0K
