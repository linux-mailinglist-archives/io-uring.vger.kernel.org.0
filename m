Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2AC0E5B2549
	for <lists+io-uring@lfdr.de>; Thu,  8 Sep 2022 20:05:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229742AbiIHSFX (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 8 Sep 2022 14:05:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60472 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229546AbiIHSFW (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 8 Sep 2022 14:05:22 -0400
Received: from mx0a-00082601.pphosted.com (mx0b-00082601.pphosted.com [67.231.153.30])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 52684A5988;
        Thu,  8 Sep 2022 11:05:17 -0700 (PDT)
Received: from pps.filterd (m0089730.ppops.net [127.0.0.1])
        by m0089730.ppops.net (8.17.1.5/8.17.1.5) with ESMTP id 288HWFbe008779;
        Thu, 8 Sep 2022 11:05:14 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : mime-version :
 content-type : content-transfer-encoding; s=facebook;
 bh=IIJKvKLlcrJkLyhvChco9AscVRg7ZQkl9otUZEsLdr8=;
 b=FsnH1wKiywbwGMf5BJsTjSS15tWHXVZ5Mvu68T4BMJeHOx9wGSBk3sUc43LO22f5RNRD
 JEn12m5cSzRNKLbtLiJpoKgHgVWZD8xJgV3jk8TMEBfA7SKxRlAM0ZxIYXacXSFMO5it
 x/PCGCpnA1YTHRTewZ1hjjhgLYwdjrWugWA= 
Received: from nam10-bn7-obe.outbound.protection.outlook.com (mail-bn7nam10lp2104.outbound.protection.outlook.com [104.47.70.104])
        by m0089730.ppops.net (PPS) with ESMTPS id 3jfbruby7y-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 08 Sep 2022 11:05:14 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=XIRt/jDi5eGEMw6kpv7NgK8oTv3pnwk7Z9Lqn3g4QfAB/T11vFH9/QePthbvqMcyRMRZkRHoL9R+V42mX/C5TfDCB9c4i5WemnJpH5kLxEJT3/ikkmYdIrhNjce5bjRI1L7LhiwD+ltjWYRsyrAFkQ6l8bFGlMLXrv3nRs2w4Fm22jS5GF43d/LDC45RJM5Hh1HJhif1l1htA42Y+4uQgKM5TSmII6dSivtMYgsX8CNy8sDXnyEUNWUD+EEwZvedF+x5N+vQuYj6kZGSn6D8q7x8YfvHH/55TTvlJMwz9d5DRaovyxSLYSC4E/SjHNymwflZmxrrS0Ou7LzLWYfFuQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=HcXsC4pS25b9fU/3A4MBO+71mM9Z4R1QwoDHLcysHbk=;
 b=ReuDSjmD+FVhXUboVZpZYFADFJD43fo35EDhfBWQVMd2NQg19/tdu8nfAEKzhpcl8misld3KskCqBEIexWJ/6wXR7g3aLGuvc8KQF8y8Mi5CRo61OPLd0kDEDaTv+3Bfgoe6Dv5HQN4CS204eKXuzNhxKfSibLEDINN0aajuNJnuikkQfJWcpbsjZFqplKugBosUOnJSLmJ0CcLVzZx9+lO6AtsB6A4yMayiozJltiBNsLLv7x1160KPThsi48pDGmD9V3vQKmfArfUk2xhoAfDf+iDzSs/u7UcQDZ0aHuCHEbfwmAyFAhQBgb2t1LCL2wK6jxEUs5SpvxcYHrs/Fw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
Received: from DM6PR15MB2316.namprd15.prod.outlook.com (2603:10b6:5:8d::10) by
 MWHPR15MB1296.namprd15.prod.outlook.com (2603:10b6:320:22::19) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5612.19; Thu, 8 Sep 2022 18:05:12 +0000
Received: from DM6PR15MB2316.namprd15.prod.outlook.com
 ([fe80::c052:c6b9:41f8:e5ae]) by DM6PR15MB2316.namprd15.prod.outlook.com
 ([fe80::c052:c6b9:41f8:e5ae%3]) with mapi id 15.20.5612.014; Thu, 8 Sep 2022
 18:05:12 +0000
Message-ID: <04d3adef-e0f3-e253-9522-b4a0f0995b0a@fb.com>
Date:   Thu, 8 Sep 2022 11:05:09 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.13.0
Subject: Re: [PATCH v2 02/12] btrfs: implement a nowait option for tree
 searches
Content-Language: en-US
To:     Josef Bacik <josef@toxicpanda.com>
Cc:     kernel-team@fb.com, io-uring@vger.kernel.org,
        linux-btrfs@vger.kernel.org, axboe@kernel.dk, fdmanana@gmail.com
References: <20220908002616.3189675-1-shr@fb.com>
 <20220908002616.3189675-3-shr@fb.com>
 <Yxnr0/7w8VC6ObEJ@localhost.localdomain>
From:   Stefan Roesch <shr@fb.com>
In-Reply-To: <Yxnr0/7w8VC6ObEJ@localhost.localdomain>
X-ClientProxiedBy: SJ0PR13CA0049.namprd13.prod.outlook.com
 (2603:10b6:a03:2c2::24) To DM6PR15MB2316.namprd15.prod.outlook.com
 (2603:10b6:5:8d::10)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6PR15MB2316:EE_|MWHPR15MB1296:EE_
X-MS-Office365-Filtering-Correlation-Id: 47943ec7-009b-421d-1e4a-08da91c4ac63
X-FB-Source: Internal
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: cFaIr4WRkoHYhYr95MIKlBWh7drw5Wd+Nq72rtUBtAWbuLwR91YqPZag+Aui1xons5S0X6QJDGLq7N9UNSnTovLs8PMDEtzMsU/PjSTJsuP52TyhFAHN8Ilb+0xNXIjq+mIHqRkzkKGnoE8cimSiWUpEL7S1UnQ9+fwgbO6OAmR0Tt29Pluj6rDElWTiof/ynYMt6PIQOy90B/y32UFJqjo2uUJ+Hu2bVlxcb8m7AQMdNWyGEGPSqDzqMXuXUXIVU8UA8U6qlBjxkvuCfH+Rf/lZAagTw6bXnKXLSyye/6NAe9g5d+e6iRd99PKHQSF5yJaIb6zkunRWIgJJuUE5UIroHwDx8cHa8GqijBq9NtL9mHeKsIXp4PWcfGw4Bjsu51tQI+7fj+sqk2qKi/7KKjlkcyKcgzjpoJ0vEWE5XALG3hnG/HL3MYtrqaw0Qo3Gu53BKFr2SsQqnqFw34DWsqfhnXEfGAolWuU3Yibku/v3QNABfvm8BBOeSy+3FI7wTgU3swTAz5s1qWnwQnEoYXUIVxZlRK5p3jPHfIBmNKawEW2eMVFP7USjDeP5uOdVymM71uJYeMsn6mzE+xYinaFMo0b2faGzAU5EPdndPUIvErXDMLgEOfTwSmUACWGNZtcTctbcPIRPV1zE8GF8LrNg38lhTuUfEG1WpPmoQsFlbHqUZDvd/4nVwAXcrVPh/HjnYyXzmNl3q/92gprVNbX/hYOGr0VTgvqrTyI2Ea2/4kqP6q5q1TJ61IHggmQ2BLq/Hq382trWz4ukQG7MdPmO9t9z17wjs01aaezVDO4=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR15MB2316.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(346002)(39860400002)(136003)(366004)(376002)(396003)(6512007)(6506007)(53546011)(6486002)(6666004)(41300700001)(83380400001)(478600001)(2616005)(186003)(2906002)(8936002)(5660300002)(6916009)(316002)(4326008)(8676002)(66946007)(66556008)(66476007)(38100700002)(31696002)(36756003)(31686004)(86362001)(43740500002)(45980500001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?NjBXUGY4Q0poY1lEYmlEZjZIYjVIcFlWUWVRWWtzc0J6a044aGxWenozUENJ?=
 =?utf-8?B?OFIvUXpmVHFqQ3ViN1BKVUNwb2N4YThURW01VzVXdkF0c1Q3SWh3VldmRFZo?=
 =?utf-8?B?OEUzdnpSd2JJY1BMaGJXbUtzRm9FWVVLdWVkVytFcXNLQ0ViZHU0VkZaZW5W?=
 =?utf-8?B?WG1rZ3hMbTl5V1R1bDdsdlJqSkR4UWo1VTM0K09ZNVNMNUZLTFpDcnVRN2d4?=
 =?utf-8?B?YkkzQ1EwdmpnQWZwMGdNQnB6SU0yVWliWndVZ0ZHejlQL1daQmVxOGdkekxH?=
 =?utf-8?B?b2NrZ3IyUW4xeWlCQ0pvUENObWlzaWxvUDVVRG9QYmx4VHAxdXVHc3ptNWVl?=
 =?utf-8?B?MGxrTnd5bEdORHViTGpzOUFTeDF3NlQ5S0hyU3VUVmhnRWlteFFIalVjelRX?=
 =?utf-8?B?Q3hwQmFGaDdubnFYQlA3VUZSdmVuUzd2MkxOUnZ1NWRFbFpMdkdBQ3Rkdzgz?=
 =?utf-8?B?TE5BN3RxQXVmU2tRQlpuOG1nOTg3TDdobEpldnZFeTc1SGlscTNKbXJpNW8y?=
 =?utf-8?B?RVlOSXF1SnpJaUlrRXo2YmRkL0ZKQ3N5SnUyc0xwRDlEWTlwcm8yNFNkcWZp?=
 =?utf-8?B?SHZFN2g3UHJ4SGNuTysyL0hqYUhiKzB4RE11N3VESXRzN1hiV21HRVl1RDdp?=
 =?utf-8?B?QW1PTTdFYVBManpkc2k0UHh1K1pZcWo2d1dqWTl2Y1FFWnhzOXlzd1U0ZEVE?=
 =?utf-8?B?cXNZZFNGT0Y4enV4aGo0UFViaTQrcnZhRW1UenEvTmJpVTVkb3Zjd2VhWGxF?=
 =?utf-8?B?MXQ0UmlVTER5eGdqQmIyOEZ1OWhKbmJBcHg3eVVLUTBOYVZsZktNMTIwT3d0?=
 =?utf-8?B?QUxLWXlBZEpJRXVwK2tReTg0eVJ5Mkkzbys4RllpT2U0c0FzUE8wRDJNd01J?=
 =?utf-8?B?OVlWWGoxTWZrN0tCcE80ck1lN3FPN2lIa2Z6MkVFVkhYV1BCdUlqSXVaZllw?=
 =?utf-8?B?VU1pc0lmUHRYd2NYcmFsQ0FKaXprRmVoRkt4UjlxbkFmckI3b0t3UGJUZ2tp?=
 =?utf-8?B?NE9oQmN2T2lmTmsxMmxvZEVFVXBCMmluemQydFl2NmllWU4yaStxa201aXo0?=
 =?utf-8?B?UHp5dzdVWkN2NEdXRktWMXNraDFTMmFYVnJRVXhIQUQ0SDNVTTJxcC9nUGxl?=
 =?utf-8?B?bDhPQ0FNaHhnREVVcHFoUWMrVlBBRXJGZER1cSsyL215d2dBMHJ0TFlwb2sr?=
 =?utf-8?B?SW9rbnN2M21qMEgrMllyRVhOZ1VwMitDOEQvT2NhM2txelZRdENGNzUrNVhN?=
 =?utf-8?B?MFkwNlJTQlljUEQxRlR6NThmSSs1UHlsaXJXOTVYVkZUaHVLcnljME5rZkR6?=
 =?utf-8?B?QUhQNElDYzlxakh4SGlQY2xEZ3IvOHJDSEsyamVyR3ZXMXpTMG1sZnM1czdX?=
 =?utf-8?B?a0tMLzJOd3ZweVJ0MWtFNi9TaWFCdldWWVhYeTNDNmR5dVV1aFFSU0liUFc5?=
 =?utf-8?B?emgrVnBncWFqMXZIbjhGTmFXdFFxVFlBem5DSDc2QU9rYkduNTRFUzRVelFj?=
 =?utf-8?B?QTVTdGdmZU1sWXQ3dktuYXJwSzk5OTI5Zlo4ZWVCMGo2dnhQdEh1M3VhOGJ3?=
 =?utf-8?B?RWU1bDJZTEhRSWFYVnFGU3lRQ2U1RitRT1dCR3lKZFI2SEhla2FUZVlUd05M?=
 =?utf-8?B?TmF5YUhmLzFBaXVtdWZLZHdiMTFrNmllMDV0UlpKL0JNTUJyK2NJRW1ibWVG?=
 =?utf-8?B?K0o3OUdJWUdBK0Y3c1VseFAxeSsrdDEwaXdKdmt0RE85aElLMWhSaXhGaWNJ?=
 =?utf-8?B?eFMzQ0ZMeHMwRW1uUU54MlowMXZ2dk5SaVFqN3ozZ1hqSlJpRys2cytKOERj?=
 =?utf-8?B?YStZSVB5MHNwUHlWbXlLTFRNMllkMktHV2RGVThIVjQyTVVwcThNdlpjam11?=
 =?utf-8?B?YTBoRCtTTDl1Vzc4QndhT0pybUNpeXhLaHBROEtrV3FiY1g2bnZXaXdBLzJh?=
 =?utf-8?B?cnEvOEtzR21lVXlaN0ptQ3J5bjRLNFlRN0JSTDV2ajhJRUZRQm9hWjJrYllR?=
 =?utf-8?B?Q2lKSEl4RnIxN2FLNm5aVWlQL0lKTFRUV1FHY0JUOXc1Z2JjUU5vMm1jYm1v?=
 =?utf-8?B?OU1iSFFnMGNBbkdiaWl5ZkdmSlQzOFBnWHF1S3NyRDlXdUM3SFdLczIwNU1U?=
 =?utf-8?Q?Qj4cTPhXwL0/ZCzGxok91s+1y?=
X-OriginatorOrg: fb.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 47943ec7-009b-421d-1e4a-08da91c4ac63
X-MS-Exchange-CrossTenant-AuthSource: DM6PR15MB2316.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Sep 2022 18:05:12.0172
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ifTpRzOhO3eJLOErvNaX3DOmcUVWh7AbfusJPDkyPgHxql7uKuSgZldtrmgarvtr
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR15MB1296
X-Proofpoint-ORIG-GUID: lfzNuTVxqUrqU0VVz4PrtilsltIJrYgr
X-Proofpoint-GUID: lfzNuTVxqUrqU0VVz4PrtilsltIJrYgr
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.895,Hydra:6.0.528,FMLib:17.11.122.1
 definitions=2022-09-08_10,2022-09-08_01,2022-06-22_01
X-Spam-Status: No, score=-5.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org



On 9/8/22 6:19 AM, Josef Bacik wrote:
> >=20
> On Wed, Sep 07, 2022 at 05:26:06PM -0700, Stefan Roesch wrote:
>> From: Josef Bacik <josef@toxicpanda.com>
>>
>> For NOWAIT IOCB's we'll need a way to tell search to not wait on locks
>> or anything.  Accomplish this by adding a path->nowait flag that will
>> use trylocks and skip reading of metadata, returning -EWOULDBLOCK in
>> either of these cases.  For now we only need this for reads, so only the
>> read side is handled.  Add an ASSERT() to catch anybody trying to use
>> this for writes so they know they'll have to implement the write side.
>>
>> Signed-off-by: Josef Bacik <josef@toxicpanda.com>
>> Signed-off-by: Stefan Roesch <shr@fb.com>
>=20
> Should update my changelog to say use -EAGAIN instead of -EWOULDBLOCK.  T=
hanks,
>=20

The next version will have that change.

> Josef
