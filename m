Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F13064BC162
	for <lists+io-uring@lfdr.de>; Fri, 18 Feb 2022 21:50:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239550AbiBRUvA (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 18 Feb 2022 15:51:00 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:47968 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233019AbiBRUu7 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 18 Feb 2022 15:50:59 -0500
Received: from mx0a-00082601.pphosted.com (mx0a-00082601.pphosted.com [67.231.145.42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 72B2498F6D;
        Fri, 18 Feb 2022 12:50:42 -0800 (PST)
Received: from pps.filterd (m0148461.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.1.2/8.16.1.2) with ESMTP id 21IKfhux023123;
        Fri, 18 Feb 2022 12:50:40 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=facebook;
 bh=1vkvcsl+szA7WZsES/c3bwuCStj9dCKkqnL88FTcYsQ=;
 b=VdWTiUSpE8IcfZ6AdeaNhjsih1D8iT69YulOsga5vg5AoB8PzeUz/cd/mfEDq1WjyfbS
 247vXsccenB7sZraVASwtFQFYaOoZ4bSJl97jhPmzBd07j1HWlcgTvwnWxnAlbHQR8hp
 88zLDnxaI70DDgdspyTZU6gDF2lnTe4h5h0= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 3ea1mp614n-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Fri, 18 Feb 2022 12:50:39 -0800
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (100.104.31.183)
 by o365-in.thefacebook.com (100.104.36.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.21; Fri, 18 Feb 2022 12:50:38 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=WKS3q4bZ1O5a+GYl4bxxHEORCPQ5OJT42wlHjP+uqgZqsco4BLY1aS267aL+FXn48+jMVtilUYWfxQHdwf8uqpZTfhzoVZx1pkukiNGEG3+SGchds4MT3njUmm1yvNrbpt65AkDWUQ5I/iaBpVDVxZOhW+eP7VxgE+317Tebz2PoiQja698g0lbsXL5Ke6nK9uQPYZYrdq2K90dKtfiK69JZTNPHcoLNEeRiEWy66pwy1Eg2YAgqZzE9O9CKXHE9Q0VRVruypqwrHAFKgpsSm5j4JTi4TPdeLidk2zQJyvJFLsGlqFxI+BSC8a9rbjPiSeDQXkq3Xu8skiE701osjw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=1vkvcsl+szA7WZsES/c3bwuCStj9dCKkqnL88FTcYsQ=;
 b=nym7FVegqbtrVGCbAt/vSntYFdzFbYCLLeeRefxVa8lJGPvsJeMClyRi9qquKBPs5u7G1yb0u8WA54Ty3u+5Jrl83LHLPch9ZIKoZMGZmEuN1GVcQKVgk9yZqz+rOc6c6LtJyq7aFuGIUxWLRktUGl0wmQtgR6EJrWjsR7q37pWw5pH7X2G2uOj3C8Hnhr4m09nmlsfmtci6zp4RF0I1X0vcJMwBlHuQnLvmT/n557x0Qm25Sryq4MtVa7whH1nXH1fVLhEcRZEfM+TaJF+gomTfn/wM78tPUW236+9s74WRvLOF2bhSBo86fQb0WrolrvEagn6hZMJ5jqhFFs5dMQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
Received: from MW4PR15MB4410.namprd15.prod.outlook.com (2603:10b6:303:bf::10)
 by BL0PR1501MB1985.namprd15.prod.outlook.com (2603:10b6:207:1c::30) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4995.19; Fri, 18 Feb
 2022 20:50:31 +0000
Received: from MW4PR15MB4410.namprd15.prod.outlook.com
 ([fe80::f06e:4aba:69a7:6b91]) by MW4PR15MB4410.namprd15.prod.outlook.com
 ([fe80::f06e:4aba:69a7:6b91%6]) with mapi id 15.20.4995.015; Fri, 18 Feb 2022
 20:50:31 +0000
Message-ID: <6310fba5-6bbf-8488-1096-0eb2d8574583@fb.com>
Date:   Fri, 18 Feb 2022 12:50:27 -0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.6.0
Subject: Re: [PATCH v2 04/13] fs: split off __alloc_page_buffers function
Content-Language: en-US
To:     Matthew Wilcox <willy@infradead.org>
CC:     <io-uring@vger.kernel.org>, <linux-fsdevel@vger.kernel.org>,
        <linux-block@vger.kernel.org>, <kernel-team@fb.com>
References: <20220218195739.585044-1-shr@fb.com>
 <20220218195739.585044-5-shr@fb.com> <YhAEsGZj363ooo+h@casper.infradead.org>
From:   Stefan Roesch <shr@fb.com>
In-Reply-To: <YhAEsGZj363ooo+h@casper.infradead.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MW4PR04CA0293.namprd04.prod.outlook.com
 (2603:10b6:303:89::28) To MW4PR15MB4410.namprd15.prod.outlook.com
 (2603:10b6:303:bf::10)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: d5115ca9-4178-4112-078f-08d9f3204d2c
X-MS-TrafficTypeDiagnostic: BL0PR1501MB1985:EE_
X-Microsoft-Antispam-PRVS: <BL0PR1501MB1985080E90C80C431EAD4AAAD8379@BL0PR1501MB1985.namprd15.prod.outlook.com>
X-FB-Source: Internal
X-MS-Oob-TLC-OOBClassifiers: OLM:1107;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: N4moHCcuCLOdWeFfgRe6BUUgKV0HSJsUdd4SXBY4L0yaV+Fl26MOS33Z1qwtivVGu+c6zDgwQSP/u2fQvvysk2dTBgnVdCfO/cis6WTM7drZDyE7RALyISDZQQMWCbdzjoRIg1T3ArgaacdcJ97EG2D6RD3em2U579EoHuhVhOyPuTf/nx3c+eSJFQgQj4x28WTlKL9SGXzg942hEuvS96SOSv7GZ7n1vqYLDup7KO0lnF1suWiYUX9mQs+soSiq2Sn3AHOvXufEkRgsxWCoxu0LkKK+OUblqPBKC3e0C/Cp41P4RKGdvzNmpuImxC7Y2iF8IHL6LmGIFQZ8oaxnTZN1mXYnsRq3+vdi7E8xuPeALDZ8AFpD2hwTAi+GZEtr7b5OtYqFFu4nB6qc15/uMofiTNtlrATz8TkwNNsx6GSQZp/xdYcyQesKYPjaSCL5H7FfRq/BxCsSdgeJbHxFaueJI0LdptWbMBMdkuvQzMuyOaBdn/zpNRTmr/0c9gVWzgGbaex3HSjxbKxHVVRl7Fb2OLDBfR3vuzcxQB25+PcKqEMEUNOnvyYHmPheDWi91DIMElqEt5UO6jFPEAY3NQ4QUVR88sOryIT8j17sZaWXzi6rLgIQGoPgzatC6LMrtzeY0p6kL3v0AZNI1oIJYxYTTpfF6VPiPInNQFRTUCzN1R5AEq149wQKCOcYGLTOzCWkwFLl0Gp9kllOE0A1Ep+t7dRWoyL8zNtkuBZ5+hqc2749oP4yIQP0mhsVB2VR
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MW4PR15MB4410.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(508600001)(6666004)(4744005)(2906002)(6486002)(5660300002)(31686004)(66946007)(8936002)(36756003)(2616005)(186003)(66476007)(86362001)(66556008)(4326008)(8676002)(38100700002)(83380400001)(316002)(53546011)(6916009)(6512007)(6506007)(31696002)(43740500002)(45980500001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?Y2xDYllnYms0RzN2YkMxQUVLRE5xVDdzdDkxZHhHZFBNck03cWtFU1l0dmhi?=
 =?utf-8?B?YUFUL1ZxN1REaFNWeFNEMjFkU2lic1dmR3QzZEo2dm5OOVhLL3JSY1pKN09x?=
 =?utf-8?B?OFZZNFRDN28yb1ZXUkZzekhuaGtRZHBZUlYyQiszNzlIeU00WWVuVjBCREpG?=
 =?utf-8?B?YzczMERJcEpQdGdOWjFFeWxiZjJEL0pvd3RveStkbkJSUlZFSFhzK0tUQlFU?=
 =?utf-8?B?TElUMFV2OWRDT1dEVUp6L2t5cVdVY3NEMDZGejhIWkluQ2xRTjQ4MjU3UFBw?=
 =?utf-8?B?NDY1eVVlS3ZZWnVJeSt4ODE3NmFuTVM3ejBkYmZ3L25HclI0NUtGUkRPVFNm?=
 =?utf-8?B?bVRKQkI5RWNseGJLcGp4d0FDWUlwNWZ2MGlqaGpqUnI3WkFMVHV4RGhSdEdI?=
 =?utf-8?B?d0FYRHhsMkFtNUpBWW5NTysyZFU0dytzU1pKbXpJbGxNdVRvaG04UWhWVjRa?=
 =?utf-8?B?dnpPcU4zeG96cDM3Z1N1NmhzRXF2VTJCUU5Ubk1wbEdPVkZiUTdybTR3UnBR?=
 =?utf-8?B?WXNKbVozSjFSUkx0azNkVkxJbXRyNVBJLzFGQm5Eay92bHBhQUtKWFpXNGx3?=
 =?utf-8?B?S2VFbGNiMCtNbGlBTXpPVE1Sdy9oL3pPYWhEMFpzZU9YNlhnM1R3WW8wL1A5?=
 =?utf-8?B?ZXp3V09FVlcrZXhvb1A3cG1KbWwreDZlcHVTejUzb0l6alhxVXN3UEd3eHIw?=
 =?utf-8?B?RFU4a2xZYzl6ZlNQWlc5bW9tN1FXQ211ZDA4cS83SVhGaDVmOUJ6V0xzTy84?=
 =?utf-8?B?VW5TUFpXS3hydFpnVjl1NUhkaHcvV3ZXQnpHWGRZcVQ4THRVRWJSMG5GRTVr?=
 =?utf-8?B?VHgwak8zSXc2bWNtbitRYVMySStwTEc4NDNpaEFSQW5GUnZrakVRVTc3d1hG?=
 =?utf-8?B?RHE1ZlZiZnFPQ1ZnakxzVGg2K29qYm9UUXFuM08wN3BYNGZ2a0RUa0dvN2xO?=
 =?utf-8?B?bHNEei9naWZSckdwWVQzRjR6TWZoanBpVnhkZDd3d2dKL0srdlV3djNiQVQ5?=
 =?utf-8?B?MnBDaDk5Q2l1bGNrWlk4aDhzc29ITFVZUDhBSFRwYms0VVN3MlAwNnJQTEJ0?=
 =?utf-8?B?YnJsdnpVMCt2QnNKUFFBOWdjSWxidSs4R1laVjZKRE1Da1ZBMVFnaG5VL2Jz?=
 =?utf-8?B?RTZoSE9tMmRSbFlFRTQ2Y3lBTmJZYXgwMFVocjN1emtZQ3JySkdpcmRJckZh?=
 =?utf-8?B?N1BOVCtUVGEySmlOSm9sWVArYTJ4OGFuNjBsUzNPM0hTUVRTOHdQclZGK3o2?=
 =?utf-8?B?bU1uUk9BaG52YWlaMTZSWGxqNnQ1S0tnYUdFUkttRlIxbTArajNhbXFUcGdP?=
 =?utf-8?B?TFg3YnNKUndFU3ZlYzJ1VGEvem1LdHhSTXlTYTJ2VldQVW1Hdkt0WFVScXZr?=
 =?utf-8?B?NFd1UjN2RTBsQy9HeXJ3eFF6bnBleHhBcUpiR2tvMGl2cmE3bVhDekd1UW82?=
 =?utf-8?B?OXdBYk8wUnNRbjB2bkdRalgxTE1heGJkelNyZEtNYmF4a0s5K2dvRzJDaldI?=
 =?utf-8?B?RWp5R1JTNkI2SEVtVXlaU1V6UVpBNVFFMXFOTG1pK3k1emZzZlYzWUg5eERs?=
 =?utf-8?B?b0o1QmQzc0phZFFBMTJ5NzBlc1k0SDZESDhEN0pjMHJ6S3NONnQ1czI0WVQ1?=
 =?utf-8?B?NThkVW5rNzVITmsxR2FZeWd5aUxqNG5TS1NTbnRtVXVnRFo3YkZGaXprY2RE?=
 =?utf-8?B?Tk9kOXNUVG5pYmI3VnBaTDg3MmxlZDhBRGFaTWREeE1mTlZza1NQajRiQzNs?=
 =?utf-8?B?U0dBMlFnT01qZy9DY3V1RG80WUJNbVQwSjh2alhLZEpMOXZBd0lSM1cyQ0l2?=
 =?utf-8?B?L3h4NmhmSytXMEl6L0Rnb1lvQWN2bHVCUjVKcUtYMEhCdEJoalluc1ZBRWV3?=
 =?utf-8?B?dG0zR2JwZmlFWUMyRm52b1hZVmZvREZHb3Q3VXRFY0EwT2xOSnRXMEhXQVdl?=
 =?utf-8?B?K1k0bUtIYUVUMmtrbktTRlZCaFQ4V3pySnQ1Sm4wdG5XeHVnd050azNsbVRk?=
 =?utf-8?B?R0RVa2kxOTdOblI3SUZjQVRxTnFubkJ2d2lWVFhiTm11cTdYSnlJZHU5MEZk?=
 =?utf-8?B?WWkwVCtTZU5EcWdkU0Vyb3l5SjBKUjR0dkhXT0psM3AwVTFkaVFmVjU4UFJ2?=
 =?utf-8?B?Q083RmdYVm5xWXB4N0tnR000U1ZiMERZdlorMGpPMFp1S1pxRm41V2Y4TkVB?=
 =?utf-8?B?dFE9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: d5115ca9-4178-4112-078f-08d9f3204d2c
X-MS-Exchange-CrossTenant-AuthSource: MW4PR15MB4410.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Feb 2022 20:50:31.0276
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: k5h9Z7MhwogAH8Yil1y+qZtka6Meus1pBTD9nm3YRZATm2hkJ2NrEPN6iTCGxaNk
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL0PR1501MB1985
X-OriginatorOrg: fb.com
X-Proofpoint-GUID: QDykotvQJXA7haKQGW8xE4NmO8tFUnK0
X-Proofpoint-ORIG-GUID: QDykotvQJXA7haKQGW8xE4NmO8tFUnK0
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.816,Hydra:6.0.425,FMLib:17.11.62.513
 definitions=2022-02-18_09,2022-02-18_01,2021-12-02_01
X-Proofpoint-Spam-Details: rule=fb_outbound_notspam policy=fb_outbound score=0 clxscore=1015
 suspectscore=0 mlxlogscore=698 mlxscore=0 malwarescore=0 phishscore=0
 spamscore=0 bulkscore=0 lowpriorityscore=0 impostorscore=0 adultscore=0
 priorityscore=1501 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2201110000 definitions=main-2202180127
X-FB-Internal: deliver
X-Spam-Status: No, score=-2.9 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_LOW,RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org



On 2/18/22 12:42 PM, Matthew Wilcox wrote:
> On Fri, Feb 18, 2022 at 11:57:30AM -0800, Stefan Roesch wrote:
>> This splits off the __alloc_page_buffers() function from the
>> alloc_page_buffers_function(). In addition it adds a gfp_t parameter, so
>> the caller can specify the allocation flags.
> 
> This one only has six callers, so let's get the API right.  I suggest
> making this:
> 
> struct buffer_head *alloc_page_buffers(struct page *page, unsigned long size,
> 		gfp_t gfp)
> {
> 	gfp |= __GFP_ACCOUNT;
> 
> and then all the existing callers specify either GFP_NOFS or
> GFP_NOFS | __GFP_NOFAIL.
> 


I can make that change, but i don't see how i can decide in block_write_begin()
to use different gfp flags when an async buffered write request is processed?
