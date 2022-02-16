Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 76A904B9052
	for <lists+io-uring@lfdr.de>; Wed, 16 Feb 2022 19:35:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237618AbiBPSfy (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 16 Feb 2022 13:35:54 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:35606 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237674AbiBPSfl (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 16 Feb 2022 13:35:41 -0500
Received: from mx0a-00082601.pphosted.com (mx0a-00082601.pphosted.com [67.231.145.42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 696912ABD03;
        Wed, 16 Feb 2022 10:35:29 -0800 (PST)
Received: from pps.filterd (m0109334.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.1.2/8.16.1.2) with ESMTP id 21GFeE0g016365;
        Wed, 16 Feb 2022 10:35:27 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=facebook;
 bh=Et8DuX7NVTuusXjrCIkv9BaK38IS2YcpHXj7cUZIlb4=;
 b=mDnykMnfgmlopmeTs3hBMtXlA7FzYynEcm56G8BBZIKCagLfvMRtbxa+XPgzLHWY2tZC
 L6xTtcn+KAkio7wFpzZODYotWSp7/Hog2oD0ev9XYlsNKGaSxIh/ky7LmglAD3t+H3K0
 N6jG0Xlha/6yYPMYYWWCL8Hq3+qc0/lissk= 
Received: from mail.thefacebook.com ([163.114.132.120])
        by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 3e8n3gxj7m-15
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Wed, 16 Feb 2022 10:35:27 -0800
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (100.104.98.9) by
 o365-in.thefacebook.com (100.104.94.196) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.21; Wed, 16 Feb 2022 10:35:24 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ed33+VihiSFQrVSGLFtvhO6L7VpewZVGWTjnXkQQVh1YEVpi3EAcsu+m8Uyd1uDDfTJkYCKztZO7VMheY+UQ82bkoabUpsByR5zfZvsZ2pTFl90dgvb+AkghCTm2Hdd0Q6Qv1MmptTa/PWhalGSwtI+7nmLBXcV/GmXOQK0h2qBt2uyu3O7237Mz2u60a9AAqcJytfeklKiq50NeCoT4Y7dzimRHjKxoWv3bCTfViRpB/3+Z4WZyXxxObb72CjkgS4NDZsCIra3Xkp0TjNFLg2oIOLDYXD3QToM+G2HeDRRgBiFhZeaF8DpDllFm6te1CrVPt8TR9u1eORserEqJkA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Et8DuX7NVTuusXjrCIkv9BaK38IS2YcpHXj7cUZIlb4=;
 b=m1OAg3AbLF3CeYdeQh1BARgya2MUORHNBsb4bOKlwjYQtO1ZtePM/QF0hKJTlR06toJVxZBdmBfY2zFSlwdAioCbMsgENP1cwUOWnQ8Unq+unIaS7MNM/rFc/7RlH7XkVS75dwQ94KpaVYLVUNbXGCbCNJaSyQm6ZJ13SvP1dqT5vmCmemWG9Ozns5jmTl2in+yWcNrijGlhC5RxBvHmfFBbxQOKKMrhE771Jf6J/pFOvo5HtcaHxzXWbnK40iTfbnOgabT66y72LKM/myeL7koA8KPoM6YCtNf+2jlo4tUgeZBb8bt++VsuUiurxd0dbVP2f9GHN8sLgkHLFUu1Wg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
Received: from MW4PR15MB4410.namprd15.prod.outlook.com (2603:10b6:303:bf::10)
 by MWHPR15MB1245.namprd15.prod.outlook.com (2603:10b6:320:23::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4995.16; Wed, 16 Feb
 2022 18:35:19 +0000
Received: from MW4PR15MB4410.namprd15.prod.outlook.com
 ([fe80::f06e:4aba:69a7:6b91]) by MW4PR15MB4410.namprd15.prod.outlook.com
 ([fe80::f06e:4aba:69a7:6b91%6]) with mapi id 15.20.4995.015; Wed, 16 Feb 2022
 18:35:19 +0000
Message-ID: <b7c2ecc4-164e-b6b4-152e-c7ce60dc3277@fb.com>
Date:   Wed, 16 Feb 2022 10:35:16 -0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.6.0
Subject: Re: [PATCH v1 07/14] fs: Add aop_flags parameter to
 create_page_buffers()
Content-Language: en-US
To:     Matthew Wilcox <willy@infradead.org>
CC:     <io-uring@vger.kernel.org>, <linux-fsdevel@vger.kernel.org>,
        <linux-block@vger.kernel.org>, <kernel-team@fb.com>
References: <20220214174403.4147994-1-shr@fb.com>
 <20220214174403.4147994-8-shr@fb.com> <Ygqb7j8PUIg8dU2v@casper.infradead.org>
 <a577fac3-1ad8-fb91-6ded-a5f2ed1b62a7@fb.com>
 <Yg1Dqw4YYK+HuI0h@casper.infradead.org>
From:   Stefan Roesch <shr@fb.com>
In-Reply-To: <Yg1Dqw4YYK+HuI0h@casper.infradead.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MW4PR04CA0048.namprd04.prod.outlook.com
 (2603:10b6:303:6a::23) To MW4PR15MB4410.namprd15.prod.outlook.com
 (2603:10b6:303:bf::10)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 01863588-d03a-4a0a-1f9d-08d9f17b1511
X-MS-TrafficTypeDiagnostic: MWHPR15MB1245:EE_
X-Microsoft-Antispam-PRVS: <MWHPR15MB1245B66E81D6228ACECC1B73D8359@MWHPR15MB1245.namprd15.prod.outlook.com>
X-FB-Source: Internal
X-MS-Oob-TLC-OOBClassifiers: OLM:4941;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 0iKAZxhGVgL90cmG0LXAhSyBtVvZxAHc5CUjT3eivOPjPuoOZM6xmMO7er8SQL1z9Yt2907AoVnEm+jjdUJnkfxdv9TZhIGCMQZxkqpbihX2jsnqXEVfOhOmFuWI1jisbHcLZrQ27j4teepHAL+Dlsh/leht3nDKzK5N2F1Sv5RQrxkIMpUTSmD6Z6OziRNtdgprjoLZdmxE0tdVHWLFXWd39agxPvtS8GjgzIYtl+DHzWzoawQJLreOUX73algmP/iwkV/ThgSoDPdv8zrRPRc2fB4i3fUiOKamDh3pi1eLhO6d59UJKejEcubYgILTrFTS5teEwbTi3xuV9B/FamWcoCiiv5n5j4WxRNmojhRXaqHtolFctgh1UehYYO8ZGimDSafIFddENuuL/T9rf6fVj0LTHOivfMCJJCLBsiptE1z0TpICNDsCXiVmHEou0gswj8msIppeUI6xgQ8Y8brrnjKypNd5u5JMabG94erVTR3hRerZcf11wWnFfJbH1hfsDWM1CWxJoYvx+A7oOFyLVCS2icUEnsnXdEZcP/pqEg7sVuaJJToizBlY+gVOm0ymq5ks3+lBzYdhjIph1QWJOCPRf1rwvnpiWM9w7UKx5dWH2vSUkGiEDs+Dn02LK46lLLF3KRvi772TCK+zhs3VzWBAxLkeNsMmP301x4b60MYNxe2pFO1bAvCZUnxqiawqOz+kCqE5/xNizGvkuhg8VlK/V+k3vj707qiXDD08XNxAy7BEmiAh0s9nFCIA
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MW4PR15MB4410.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(2616005)(186003)(5660300002)(4326008)(8676002)(66476007)(83380400001)(66556008)(66946007)(6486002)(31686004)(6506007)(36756003)(53546011)(316002)(6916009)(6666004)(508600001)(38100700002)(2906002)(31696002)(8936002)(86362001)(6512007)(45980500001)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?YUZIREJpRmRFdVRaZVUrbjFkUlBtOFVMcE1lR21xd2pkZWpDa0lIVlNVM2dk?=
 =?utf-8?B?YmN0dWg4akxvZXRwRVpyQ0k5NTRYR1ZLT3RqNmREaHJyUUN2RU4vZTFTR2cz?=
 =?utf-8?B?SDVqRE1heGhXaVFMQWZIcWg2VEprRnlUZkNjM3FMNjVkT1kzNGpOOERYTWdC?=
 =?utf-8?B?cm1kdUFqUXZpYmxKcWdRQTAxS21ZZzg1QXFzWlhiY3oxcGJOb3JRWk9WV01s?=
 =?utf-8?B?ZUREQ1ZpUDFIWVpTOEJ4cVl5Z0doV0hSQUZhMjB1elNSRjY2RnN2RHNRbVJm?=
 =?utf-8?B?dEFPRVIzV3JLc2FoLy9aQTQ1UWJSQ3ZxNkRTdnQ4U2Y0MU9HOTZJUXN2aHRF?=
 =?utf-8?B?SHhOeHRSZFBTTUhhMzVEOVdpMFVMRFNvanlVdllCVGdIeHlUcmxVb3BBYjFV?=
 =?utf-8?B?NnllT1B3S3lhSVRZYThFZy9OeVVmSzYzcS9PdUUyWDRNOUEySnoxRnMwMmFQ?=
 =?utf-8?B?Y2ZUZmhFbE5RZE81WmlBa01TaDgrcWh1MEZkOXo4Y0w0VHJJVjZQdjNDY3Ry?=
 =?utf-8?B?SFhGbUJ6MVVYaDFCTzk0bjFScllZVmY2OUQrOXl3ZmxXY0w1TlR2bmIyd3ZP?=
 =?utf-8?B?Skc0YWdGMmpqMkVqNnRBWDNscXBranNRbFhlVXZsSUFjdHM4RERHakQ5Q2U1?=
 =?utf-8?B?cG1rOEIrNTRGckluNklpNEFDaXA3cnZxTERHNG1WdEMzQUxhVE5EYkN4TWxl?=
 =?utf-8?B?cU50NnVRL0JQQTJEZW5MNCtYSWphU0dkYWh0UEg3c2VNUUF1bmNYUUp4ZHJD?=
 =?utf-8?B?eU9NbUNEakpQMGxlQ1B2bkpIN3BnU04yVEpKR3FtUTVGZUtPREFGRWNlR1dn?=
 =?utf-8?B?b2ZreDgyNHpjc3dJczA4eGNuL29USnFBWm9vZ2pCOXpQbUFoWHJzSGswSUVF?=
 =?utf-8?B?THdHY3YvY1U3WTFDMWlpc082dXVlenMzdDRPL1l3ZTJ2RGhML3luZStkdkdq?=
 =?utf-8?B?SzVxK0ppclJPdEhmTFpyb24zOWgxWUFGKzFsdW5vQjRtMWcwTytpK3kyTkow?=
 =?utf-8?B?SEoycG1nUjFGdXFSN1p4QjFyMVdxRSsyYkUxOWxvRmkvTmM4NGVBem1XM0N0?=
 =?utf-8?B?NFVLanQvSUY4OUo4cEZvdXJ2Rk5rcHRNMUQxME9kNm4xaTdDY2F3OVFKUmE3?=
 =?utf-8?B?Q3Q4MDV5UnRRdFcvOC8vY1BPaWNtanh5Y2JjdUxBL1lhZ1Y5VlF2R0JucVJJ?=
 =?utf-8?B?QnZaSG5GZG9qd2JXY0h2Y0wvV2FMejhnZ1pYOHEwSk1QQ20wTzZvWXl1UGZa?=
 =?utf-8?B?dVpVdWdUdDV6YjRnb1pWb1VlQjJxbHpnc0NOcVR0UTlYOFJxZlpPakl3VUha?=
 =?utf-8?B?aC8rM0oxa2l5TU8rSU80cHd2aHNWclUrcGkvUDJROG45eHlUK2E4Y0pwanha?=
 =?utf-8?B?M1U3T2VMUkl3RU5PbEM1RGRVeTE2Si9HSGR0bFZPR0dIWDFuQWRtR0RpTDlL?=
 =?utf-8?B?bUJjRytZN1hJOWkvQnN1MS9TZEFxelRWb3BTVDMxV09oQ21hNUU1NVNHeDNO?=
 =?utf-8?B?QUs1ZWVoZ3RmV0hHZTFWLzVXRmE3Y2ZpTkVwTnBHajBMcE5FOUtQZldoRThZ?=
 =?utf-8?B?MVFKcEQ4cWUxVWdxbXVEaVE4dE5Ba1g4d3BTaFYvVzBRazVITmxGaE9kYlkv?=
 =?utf-8?B?eGE4YWxlajFLVDZQTjZzYnJWYTBBYkFHWFMvTnhpWHg4dVRkSWhsKzYvcSt1?=
 =?utf-8?B?c3Y5MUVtY21pa0Q5YkhWZm5GWjZLTEdyY0hncVRZNEdzay9URVN6KytCTzh4?=
 =?utf-8?B?V215YXhWcUdEeDJvdkhvWnRadjBibmUxWjJWMWYyMUIyRVpSTDM0VkhpU05T?=
 =?utf-8?B?RnFIYXB1Z2JZUVpTRW5lTHBDM01HLzJHb1RGL0NyU09pejY0NGdscytpdjNF?=
 =?utf-8?B?aVZWLzc0WkVXUk1jTHpCK3REc3dXQmZWZnoxWGxlWnZkRStLQU5iYnFzYUhq?=
 =?utf-8?B?ZlVSTkgrek5WZ1pHVzZ0WDNyS1ZOa3NTMVdUQzJ2RU9kMmxJU2E5RldDYS9w?=
 =?utf-8?B?SC9FcGJSYzY5cHF0MW5YY0hsS0cwTlBpVzlyR2ZqUCtZS0RaQUR0Ty91QTZ0?=
 =?utf-8?B?WVl0akdVV0ExZ2FORUJteUwxS3gwQ3pBWU1MbG94a3lreEdUWEVRdnlaZW5i?=
 =?utf-8?B?R3VUSUJhcEdvWkQwWkt0NXdrVTVmS0ZISk5zTkJwY1p4VFpkM3YwMXlVdENx?=
 =?utf-8?B?YlE9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 01863588-d03a-4a0a-1f9d-08d9f17b1511
X-MS-Exchange-CrossTenant-AuthSource: MW4PR15MB4410.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Feb 2022 18:35:18.7757
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: cPe++ocoqPQRcweZtYbehzFlrFdfo5OXH3mI5NBxl0b+AbNLIvtMsL/MLWeM49rx
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR15MB1245
X-OriginatorOrg: fb.com
X-Proofpoint-ORIG-GUID: GdveDee4LsZyyKsC_eAcbwpPVARoOl7M
X-Proofpoint-GUID: GdveDee4LsZyyKsC_eAcbwpPVARoOl7M
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.816,Hydra:6.0.425,FMLib:17.11.62.513
 definitions=2022-02-16_08,2022-02-16_01,2021-12-02_01
X-Proofpoint-Spam-Details: rule=fb_outbound_notspam policy=fb_outbound score=0 priorityscore=1501
 bulkscore=0 mlxlogscore=756 lowpriorityscore=0 adultscore=0 malwarescore=0
 clxscore=1015 impostorscore=0 mlxscore=0 spamscore=0 phishscore=0
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2201110000 definitions=main-2202160104
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



On 2/16/22 10:34 AM, Matthew Wilcox wrote:
> On Wed, Feb 16, 2022 at 10:30:33AM -0800, Stefan Roesch wrote:
>> On 2/14/22 10:14 AM, Matthew Wilcox wrote:
>>> On Mon, Feb 14, 2022 at 09:43:56AM -0800, Stefan Roesch wrote:
>>>> This adds the aop_flags parameter to the create_page_buffers function.
>>>> When AOP_FLAGS_NOWAIT parameter is set, the atomic allocation flag is
>>>> set. The AOP_FLAGS_NOWAIT flag is set, when async buffered writes are
>>>> enabled.
>>>
>>> Why is this better than passing in gfp flags directly?
>>>
>>
>> I don't think that gfp flags are a great fit here. We only want to pass in
>> a nowait flag and this does not map nicely to a gfp flag. 
> 
> ... what?  The only thing you do with this flag is use it to choose
> some gfp flags.  Pass those gfp flags in directly.
> 
>>>> +		gfp_t gfp = GFP_NOFS | __GFP_ACCOUNT;
>>>> +
>>>> +		if (aop_flags & AOP_FLAGS_NOWAIT) {
>>>> +			gfp |= GFP_ATOMIC | __GFP_NOWARN;
>>>> +			gfp &= ~__GFP_DIRECT_RECLAIM;
>>>> +		} else {
>>>> +			gfp |= __GFP_NOFAIL;
>>>> +		}
> 
> The flags you've chosen here are also bonkers, but I'm not sure that
> it's worth explaining to you why if you're this resistant to making
> obvious corrections to your patches.


Sorry my comment was for patch 1 not patch 7.
