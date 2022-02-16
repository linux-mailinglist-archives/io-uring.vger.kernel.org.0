Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 737FC4B903D
	for <lists+io-uring@lfdr.de>; Wed, 16 Feb 2022 19:31:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236554AbiBPSbn (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 16 Feb 2022 13:31:43 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:47086 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230474AbiBPSbk (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 16 Feb 2022 13:31:40 -0500
Received: from mx0b-00082601.pphosted.com (mx0b-00082601.pphosted.com [67.231.153.30])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 16B3062D3;
        Wed, 16 Feb 2022 10:31:27 -0800 (PST)
Received: from pps.filterd (m0109331.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.1.2/8.16.1.2) with ESMTP id 21GFRa3j001935;
        Wed, 16 Feb 2022 10:31:24 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=facebook;
 bh=eGJCRFCPgRhGaR+fgS981JtKcpP5wqdEavxzZQRfeL4=;
 b=qHkTA31JJLVh3+wQKSVkpsZ+Kz9Wh3XP+FmbpJgD46sFXJTaQ+YxT0WjHRk71NQwxU2a
 5itgOZRRsh89UWy6G0vDPTC4z180O4eTgGA+WWZuCgn96amdnz4RSSm7dQHFcHgSdm4K
 D93hmMtsdaviJZdntp74oqo+gGvjTvjHDDY= 
Received: from mail.thefacebook.com ([163.114.132.120])
        by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 3e8n3d6gr0-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Wed, 16 Feb 2022 10:31:24 -0800
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (100.104.98.9) by
 o365-in.thefacebook.com (100.104.94.230) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.21; Wed, 16 Feb 2022 10:31:22 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=C1/zk4rbwPUBkP4PydKhMBOt6aU/3NH0nw9QLtPcI3XEkGjTB4MQs8pPMB7hUcLOaV7mEMWO9+u4i37XhW7UFoJdvcMZ40CTeNQzSqeyoCjrfI5ZfYoukInFz609nZLvPXCPImp/oNA77MzS2ssbVln7/5q5H7hDaefjnDwkmjqkGIVILJd9WF+0R9tar53TuCr6MMR7ia27a8naq6UasYa4pqF4pBG7aXw0oPopRGzy5bUxdmqDtvA0Axj5QuwmOtkQfzr4WQzBpP0ZueYQGSOm03BT/ut1dxNBSDOMaRlMQwrHy2MuWxa1UwdF+EKKT9Vwa41PsqEnDQ7Gk7m8kA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=eGJCRFCPgRhGaR+fgS981JtKcpP5wqdEavxzZQRfeL4=;
 b=fgmO6z+5NLfwudWemr2Tvk0JIqwci4adEJ0pmLkgphsVyF3/B5PcabMl6TvuSCjNN0O5cuHDmcf+iv/ta+Ha2TsfUnEq2rwHlDqsHB7VzCa437aC/pAbcZWx1DBudjqGKuFiBSJe1k3q/bcfUcLD9ivoYMfHV9sOwaaoZOZ4kcIOr+vwrvlctxgMFhj/tfhRlTM/bLxkWKSWUZ5wcRV4hibuSJgEZnabymL9pOC0MKq50nTUAlLAz2soCmg9SRe4YJyTZfCDyrG/zTOnQwSRDq6P4JQ3rKCWV8G6uk9HSaxKlSZN2gjh+Eni6DkrGTYADeFuXnzDfClabSxI6DKBgw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
Received: from MW4PR15MB4410.namprd15.prod.outlook.com (2603:10b6:303:bf::10)
 by DM6PR15MB2202.namprd15.prod.outlook.com (2603:10b6:5:8f::29) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4975.15; Wed, 16 Feb
 2022 18:31:21 +0000
Received: from MW4PR15MB4410.namprd15.prod.outlook.com
 ([fe80::f06e:4aba:69a7:6b91]) by MW4PR15MB4410.namprd15.prod.outlook.com
 ([fe80::f06e:4aba:69a7:6b91%6]) with mapi id 15.20.4995.015; Wed, 16 Feb 2022
 18:31:20 +0000
Message-ID: <ff6b5c97-c74b-1984-818d-339555fed94b@fb.com>
Date:   Wed, 16 Feb 2022 10:31:18 -0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.6.0
Subject: Re: [PATCH v1 01/14] fs: Add flags parameter to
 __block_write_begin_int
Content-Language: en-US
To:     Matthew Wilcox <willy@infradead.org>
CC:     <io-uring@vger.kernel.org>, <linux-fsdevel@vger.kernel.org>,
        <linux-block@vger.kernel.org>, <kernel-team@fb.com>
References: <20220214174403.4147994-1-shr@fb.com>
 <20220214174403.4147994-2-shr@fb.com> <YgqnYYRZKGMQK7N/@casper.infradead.org>
From:   Stefan Roesch <shr@fb.com>
In-Reply-To: <YgqnYYRZKGMQK7N/@casper.infradead.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MW4PR04CA0191.namprd04.prod.outlook.com
 (2603:10b6:303:86::16) To MW4PR15MB4410.namprd15.prod.outlook.com
 (2603:10b6:303:bf::10)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: e448e78a-51cf-413e-9f94-08d9f17a86f2
X-MS-TrafficTypeDiagnostic: DM6PR15MB2202:EE_
X-Microsoft-Antispam-PRVS: <DM6PR15MB220258061AAFAE51718914CFD8359@DM6PR15MB2202.namprd15.prod.outlook.com>
X-FB-Source: Internal
X-MS-Oob-TLC-OOBClassifiers: OLM:7219;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: NDP5sEBWfRyxWmSdMtIvCKwgDz/SNgQpIUCx3LtnkAWwJt8rlUWUxrSZ505BuXdVEagP6FF76QFLdnAq4rplwnd/uocWFBvZsa6xHm+AKWfOQac0dawN1RnbrQgYs8HlT9zKbrWTRJKuu3er9eQEsdJjJcx7NbI1jGzouiugRX9T+BMJA6qcFjNtZ0OqeC48hKbI83BOKWojI7ys4HZxxH6xE1jxyxG+RNh073e20eUKFzRIR1hljzWkcWjAjvutTBXMb3ckHaBmG59pJiRt/84EKTrtLOpnEoxLi9fxUUSLaO+/svp25/ezYKTVtsC6eZYNOIHKBjGaIqOIa4DivyQu8n4uV+Ds4p3hJG3CZKDID4DzUjqYfinsk0Q3nv37wBfKZag73LaqOV183coeIB6SZesIhYLOmmuZoWDSLi1Nx4LVU7EHC9DztqL8v9QPnsHvFpsL4yRoXqy8ipKIwL1NqJvVeyVz7AHlpd6GlVaqXx/gptqgbYt+Bx7Q0zxVH3ndaOUryCwKIeB9bz14shO3eqf0fSbQEjAOvN7d2exiv5qQfqJaChDBDamECN/J2147pxobBeB5sKszacDUmN6Ufol20u3mVFjahfp1z/QUuXLCGHcuGORe1goUnJZbnGfDTXJqsEaipAvWxYWsTE+PNjRJWGDp6Yh9Tp2EsILVtZx973dr60Y+9Pu4kOLCVb3ulQ3pQ//T2SUPsso0TIsGADzi2acJuj4azCYslOOCA6ipdRU+Qx946ulgMWaN
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MW4PR15MB4410.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(38100700002)(31686004)(83380400001)(186003)(4326008)(8676002)(4744005)(2616005)(5660300002)(8936002)(36756003)(2906002)(66476007)(316002)(31696002)(53546011)(6916009)(66946007)(6512007)(6506007)(86362001)(66556008)(6486002)(508600001)(43740500002)(45980500001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?WGlIRG1OemFzaWIxOWJ2ekd2UU43S2FGWkdDeTVwaHVSUldXcXF4aUV0M2Fh?=
 =?utf-8?B?TDVwMGZsc3JSYmZYVThhNmtMODN1QlFybXhNcHdQM3BQT1dBNGtXcVhKc3ZL?=
 =?utf-8?B?Q1E3VWowV1pTM2Nud0VTWmdJdXZndDBBZG55T3BkajdySHlWcVFTOTQ3RlU0?=
 =?utf-8?B?RE9RQjJxOHFFYnVvU0lhRUZUbGtyQ2RnSWV1dDBhQnZ1WGVLcHBhSmVJelBK?=
 =?utf-8?B?alAyY2orQStWOEw0eHNkSXVLbk5IWW0rYS96TEpKVEtzMGFXQ0F4QU5BRmpX?=
 =?utf-8?B?ZlZuZlJMS2pzd3RYVFBxNFg4aURybllqdTlyeXhPbDZTSFVoR2pUR3hpK0FK?=
 =?utf-8?B?K1hNakN5RUNRY2lMZ25zdFpTM3pCRmhxeEJSM3BkQUVjaXh0R2dDTXBzeXNh?=
 =?utf-8?B?RkQ1K1cwSTF3YW1oalpPUy9ZVURKZktDVkY2NU5zdnRmT2V2alJFbi92VzRY?=
 =?utf-8?B?S1ZzblZ3VW1wejhPUXZMTEU1M0R6ams0djEyeHQ2M2c0T0NKRVh4TDZ4L0xG?=
 =?utf-8?B?a1ZrWWM3aUFkZCt6U0lhV25pUUF5dnUveEpIWndqYjluSWVVOXZKMG96SXV0?=
 =?utf-8?B?cmY3eDJzQndhZmttNTVLUDhGMGdsT052aVhoL1BMY3NjbUM1cERXZGdEL1lK?=
 =?utf-8?B?aFZoV0NzYk16ajd2T1VMcUtSdWlsTGh6M0taemphTHlZUGFPeS9iM3F3cUNC?=
 =?utf-8?B?WGFrQWc0ZFdHNndQMkZwUTEyYnVzQUwvdVpGdFRsOVNtNVpUb3ByUXduM0c1?=
 =?utf-8?B?bmZrbENMeTVTV1Nqd1lZb3pKSWliOWgyV012V2R0TXJIRmd0REpvMHFJSjZC?=
 =?utf-8?B?aUNsMDZOTE5OREQ3am9FcEdzbUxidXBqbVBLcDBNeW4rWnJiamhNajhYVjZm?=
 =?utf-8?B?SnlzSloyU0FuTUo4dzd6UHN6RW1xZzAwNDF2eWZUdEpPNU00T1RwLzYrb04y?=
 =?utf-8?B?R0tXNmk5dzZCaFZ4OTVNZGhYRk84RE1FQitQTXNRemZWWTV1OXYwdVRTSGVP?=
 =?utf-8?B?dmJiNSszVHRXelFneVB1ZUdPdktRNmVxRllPOGJkb2hNZHNCcmR4NldWMXE3?=
 =?utf-8?B?b1YrSERxOWpGbEFUa0twelFLMXdXZytaZWJIa2I2WXJzcmZVMzdGQ0tKcXZt?=
 =?utf-8?B?UzlQZmZta3YrUlBQeStOTWd4U3dwam1QajRrTkpDbjdXQW1kWGlETTl0NTd6?=
 =?utf-8?B?aXZDNEUzMkhsNzNwZ3JCZ1JxTlBIeEozOWswUGdZaUNDTExoTGxtSjZIUXVw?=
 =?utf-8?B?STF1bmM5S3czb0FKMFc5TyswQ3NtTFRGNEpjRFVSQmlpUTlwU2RHWlBDbVNj?=
 =?utf-8?B?UVFKaVZhUjhGdWd3a2RkdXlFTjRleFhpVURtUnRaNmJrYmtRcmdvaGUzWEky?=
 =?utf-8?B?TDVSc1J4ODNlYWVLOGs4UzZLeHJCMUdhV2hYUS9Wc2RhdTRvREZxbXA1SG1F?=
 =?utf-8?B?T1lHWjdYM0FNa3ltTXJCek5kZDBacCtvc3lPMVhyeGw5WU9CalEwNVBySmkw?=
 =?utf-8?B?T0hqU3RSUGRIVkVkQ0JJQ3IzdzlUTTI5b1ZkaEwwQjk5WEZBQmtZQzJsSVRX?=
 =?utf-8?B?bHY5S0crWFNIcEhLR2ZGdU9LMzgzNWdVZEZDMlh3TWxWS0NBQkFJc1dXQ0Qv?=
 =?utf-8?B?YVVmNlZlYTlJVlNqdE1zVThXMGl0dFE3N0thc2RWRC9WVDgxZXZuWldmSFYz?=
 =?utf-8?B?Q2lUTHcwRUxBT2s3KzBkaHVTTzBhMnlCWEcyeWw1Ky9WblY5TG1XWDQydU9L?=
 =?utf-8?B?NnF2bThERjhRNUNFclpXVzNVZlRwRVBlTjFTUkVWWEV6U3BVU3kvbmdzNGV3?=
 =?utf-8?B?eXZVdTZTQXpTZ2E3c3pnakRwN2RuU0FVZUZBRStpTWtGemU2ck5zZ2ZRRjhs?=
 =?utf-8?B?SkE4UmFoZmRaT1BZU0x4VXRGd1pTUnU4WDcvTHlsYWdZaEcremdlZEkrYXBn?=
 =?utf-8?B?YUkxWGlWWXZ4QzR3VHNkc2pyUzVUa3RCRElCVkdEMURzVUdraE9WeDlJS2ZQ?=
 =?utf-8?B?SEJFa0N3ZzJSUEw0ZStwdGRvVWs5UXE2dGNOUjBBb0hWdzErS0ZRTmNGd0Ro?=
 =?utf-8?B?YWl1YXNmMFNLb1JqdlJxSjJmU3AxelNjdXJURVVQTkU2ejJEekE2cS9IYVVE?=
 =?utf-8?B?Vlh0elBvN2g1cnN1MlpZd0lxdTNyWEtWRE9sM01Qc0gzNXM3NkNoUUZOa3Jk?=
 =?utf-8?B?Y1E9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: e448e78a-51cf-413e-9f94-08d9f17a86f2
X-MS-Exchange-CrossTenant-AuthSource: MW4PR15MB4410.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Feb 2022 18:31:20.4487
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 4MX99Mj3TtJWFVcL7WF/L0gSogglwAS0KL1E0B8UbAFnIMbtvCRXt7aqtqlYVYxI
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR15MB2202
X-OriginatorOrg: fb.com
X-Proofpoint-ORIG-GUID: sIDiJCEPnW2u6-1aNxbzEWeFu1Lx6udI
X-Proofpoint-GUID: sIDiJCEPnW2u6-1aNxbzEWeFu1Lx6udI
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.816,Hydra:6.0.425,FMLib:17.11.62.513
 definitions=2022-02-16_08,2022-02-16_01,2021-12-02_01
X-Proofpoint-Spam-Details: rule=fb_outbound_notspam policy=fb_outbound score=0 lowpriorityscore=0
 suspectscore=0 malwarescore=0 bulkscore=0 clxscore=1015 adultscore=0
 impostorscore=0 phishscore=0 spamscore=0 priorityscore=1501 mlxscore=0
 mlxlogscore=412 classifier=spam adjust=0 reason=mlx scancount=1
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

I don't think that gfp flags are a great fit here. We only want to pass in
a nowait flag and this does not map nicely to a gfp flag. 

Instead of passing in a flag parameter we can also pass in a bool parameter,
however that has its limitations as it can't be extended in the future.

On 2/14/22 11:02 AM, Matthew Wilcox wrote:
> On Mon, Feb 14, 2022 at 09:43:50AM -0800, Stefan Roesch wrote:
>> This adds a flags parameter to the __begin_write_begin_int() function.
>> This allows to pass flags down the stack.
> 
> In general, I am not in favour of more AOP_FLAG uses.  I'd prefer to
> remove the two that we do have (reiserfs is the only user of
> AOP_FLAG_CONT_EXPAND and AOP_FLAG_NOFS can usually be replaced by
> passing in gfp_t flags).
