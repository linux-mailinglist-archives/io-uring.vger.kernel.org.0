Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5A18A4BC101
	for <lists+io-uring@lfdr.de>; Fri, 18 Feb 2022 21:09:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235115AbiBRUJh (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 18 Feb 2022 15:09:37 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:59144 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230146AbiBRUJg (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 18 Feb 2022 15:09:36 -0500
Received: from mx0b-00082601.pphosted.com (mx0b-00082601.pphosted.com [67.231.153.30])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1F3CB24B2A3;
        Fri, 18 Feb 2022 12:09:18 -0800 (PST)
Received: from pps.filterd (m0109331.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.1.2/8.16.1.2) with ESMTP id 21ICvp8b008091;
        Fri, 18 Feb 2022 12:09:04 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=facebook;
 bh=dr0QMPkpbKT5qCzyvZSrbC1Ys4Nk8vpTgT44zZIaJZc=;
 b=jvoGTL0UvKHox7+HGT34oASyjyLPW5D7UpqUAA4/Tw+EVYT9wrEhOk4NaThWlcuNviB8
 Fy9aHNFTmhSMmD2AvhJTIaJ9QKH5sjB1bmhbRj4DeMeg1vebnrZiUvYSLWAmiMmfn5wS
 uvG0UzCEbabXbDHtFXjNP4F08MmXfchsK7s= 
Received: from mail.thefacebook.com ([163.114.132.120])
        by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 3e9yf2xffb-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Fri, 18 Feb 2022 12:09:03 -0800
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (100.104.98.9) by
 o365-in.thefacebook.com (100.104.94.228) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.21; Fri, 18 Feb 2022 12:08:32 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=eYtTqwSPEnmip/mc18RyELczZ5Di5kiEqsztXGUTTd3q5r6BHs3WEeKNaNj+Q3gXFui8B3jK61kN/6zJrxK9CTXYt7Zifse7fHiXDJH4ldPyhgtgNMXRRofP9D32GU1oPQLJXMV8OK477Nf2WGCO3DGULSZBlCyquOtHHex76G3XuyIP9nURVF445UEunuYTQnjyy3Ja6kWSsvCcupZ+eDTnMb7L8dJlP3MT/9CUHvKE6w0OGqyy9r/1cQzamkuPmZvH/hQeB02sd6cb7Yhvf9rV7PwjYU4d3huKLrkUVRq6uNPhJtMvZSNd8U/v6OSOIghhbFvWEF/xU0uFaxdXuQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=dr0QMPkpbKT5qCzyvZSrbC1Ys4Nk8vpTgT44zZIaJZc=;
 b=RChWTkd9YKz6NeYOl1H0JvklttZH4cQKtG7efQMCCbuSrteHrbACHsc95PPSV/QHkdkwAg/IrMCv+uX4C0gGZl23Fkw/fSXY0/YUwhts8ELb/1L6sqCSwZmei/7n4mEJHyEWwb9GCikXtO3djr5Q3QBA4XlklTgtKx+qCq9vC2wrNBtbbY+Lpala/yZe+sOofS76rhc7c4om47BykkIXvx7K4X8RFfdLyQ9msEy2CcUAMrnAtvBJ8rCJo+GM3FOWWORhcFLdE4qTxlM/4wObFr3SnptUJRtlQcOcMA8/17pTpOYPFs41No1Gqfot1yppx0l4lRqE+lj6KTdZcfw6TA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
Received: from MW4PR15MB4410.namprd15.prod.outlook.com (2603:10b6:303:bf::10)
 by SJ0PR15MB4325.namprd15.prod.outlook.com (2603:10b6:a03:380::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4995.24; Fri, 18 Feb
 2022 20:08:30 +0000
Received: from MW4PR15MB4410.namprd15.prod.outlook.com
 ([fe80::f06e:4aba:69a7:6b91]) by MW4PR15MB4410.namprd15.prod.outlook.com
 ([fe80::f06e:4aba:69a7:6b91%6]) with mapi id 15.20.4995.015; Fri, 18 Feb 2022
 20:08:30 +0000
Message-ID: <d6a89358-c43c-9576-91bd-d90db4d2aa42@fb.com>
Date:   Fri, 18 Feb 2022 12:08:27 -0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.6.0
Subject: Re: [PATCH v2 01/13] fs: Add flags parameter to
 __block_write_begin_int
Content-Language: en-US
To:     Matthew Wilcox <willy@infradead.org>
CC:     <io-uring@vger.kernel.org>, <linux-fsdevel@vger.kernel.org>,
        <linux-block@vger.kernel.org>, <kernel-team@fb.com>
References: <20220218195739.585044-1-shr@fb.com>
 <20220218195739.585044-2-shr@fb.com> <Yg/6qDCDuCLGkYux@casper.infradead.org>
From:   Stefan Roesch <shr@fb.com>
In-Reply-To: <Yg/6qDCDuCLGkYux@casper.infradead.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MWHPR1401CA0003.namprd14.prod.outlook.com
 (2603:10b6:301:4b::13) To MW4PR15MB4410.namprd15.prod.outlook.com
 (2603:10b6:303:bf::10)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: d80ab2dc-e387-4690-8dec-08d9f31a6ea8
X-MS-TrafficTypeDiagnostic: SJ0PR15MB4325:EE_
X-Microsoft-Antispam-PRVS: <SJ0PR15MB43259CE90236E5E25B6D1A51D8379@SJ0PR15MB4325.namprd15.prod.outlook.com>
X-FB-Source: Internal
X-MS-Oob-TLC-OOBClassifiers: OLM:1002;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: SPBMHuW7+YCD5/8BbogrEa1uGifI2Us+RDH7xv5ThawSEp7ptmP0vY7M8IP1M25s97SIVUWWjJ6kXCb9mn6J7iR3pBJyLMiHnr3EsVY96pbWliAkaTwUwKyy6wXGnldo7RpygXFJmu8z4lbBhdvfcXKv/AMKEjMIAAk74vFirdc1Flqyvo8PDy5EmMMnA8TT87MtW7wHpm/k7XzBT6MAJCXHI4MF/S6eGVIjoMwQrAd7+a3WVFqlqCHPXJEVSyVYHweoIaiehGTnylFvW8dXgkId/Gr7Uk68/UaI9cZwfYWw+VYoXf6vtYWZNBrfH0Nc9UOAEJ2C2xG+W+Tb00LRogLuz2dOJnlye/POMamY+L8/xN+8H7fw4OVZ5Aa2V1PlRLFl3ws9n63r9f3varAKGfkzGqgO+18UDD0U2xPR5R7VXgfRZmmdkwq56Jbetqd6i5D87Plh+l7ce201BZ+mefa+Rag4ojUKA5Lng5d6V+bemsEBMSW1TXFWeMCPQqGaeL9InTd+6rWf6zYJg3MN6k+QgjuNDEufYp+kj8CNo6XBhlO4icA0ZKUCH6GEcDbsDGBC95XvIg6efwFvGDu4TyrHPFjkDPslosHtkWc/uglGtiWzGxU+L5qTAoM74CfFmcGOF6q6Lpx1WwY0/wDnsQYFu9w2sxASUzvrMmmjEeoAzLHQECvu8I/a4GhEPGZCi1WHfgK8MF7JvHySF+VRhCs7a0kR3R/Sub+5LJlgKcI=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MW4PR15MB4410.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(6506007)(5660300002)(86362001)(2906002)(6486002)(66476007)(4744005)(66556008)(8676002)(66946007)(6666004)(8936002)(4326008)(31696002)(31686004)(36756003)(186003)(2616005)(508600001)(83380400001)(316002)(38100700002)(6916009)(53546011)(6512007)(43740500002)(45980500001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?dWh0Ty91SjA3T28yKzdxN1hNZ3JUSzBKQW9IUDB0ZktyMjlPM3BaaFd1TE5Q?=
 =?utf-8?B?MFNyM3ZBLzdGYUV2OHZ5T3RGaklQUEE4K2pvL3Y1MHhvSjJvbnhtT2djRi9S?=
 =?utf-8?B?MUNGOGlFYmtwaDVFYzE1Q0xtdzgxZERHK0VMVVdsdEVLd3QwNktvelpHZHB3?=
 =?utf-8?B?REdvV09WWnZOUFQ4Sjk5SW92R3VxZjJxUkh4VTVZbU9Tc2xMb1lNUUcvQnV0?=
 =?utf-8?B?bHg2NFdRNDF0R0RhV3VxWWhHL29mM0wvK29mbVBnNHlEVUdWMUlxdWVLVzZr?=
 =?utf-8?B?QmZzSWd0amx5V1V6Y2RLK0lROE1SQzczR0M4dDdlZ2hJSzdDRnlxd0lGdzB6?=
 =?utf-8?B?dVNXb3FlcVQ3bFJyTTBIRGFwR2JtZjAycEMzSjdUQWwzZC93b2NxQ2xJMGVG?=
 =?utf-8?B?OGppcEVOemRwTmFyekNNMmMxMFlxeUVxRTg1SDlVaHZrK2RKWm9vSjhaV2lC?=
 =?utf-8?B?WHFaUWYzWEhwdEV0SW9sMnRyVHJaa044ODdHNkg2eDRSZ1o4ZFpBdXhyclNY?=
 =?utf-8?B?cnlDTGhaeFdYSlpkUWlUSlc0YXc2NmxhNzY0LzRxNXFiZEhyMXUzc3M0d3JG?=
 =?utf-8?B?cXRrOXh6TVR0YkVwNlpmKzBnRkFjTE5NUHpJUkJndUsvK0kwYXVuc1BJQzRr?=
 =?utf-8?B?TmtsQitsZE1yNlppZzR4RURadFRUM3ZycWs1UHIyM3kvVGw2QVo3YzBnWEJC?=
 =?utf-8?B?dHRjTmUrVnd2VWRlZmFzVUg3ZEtraXFRb3lvcUVTWlpOeGdxZi94WG5WSWdj?=
 =?utf-8?B?dEZxNVFWZnlLVWh0NDNRRkxwU1hzZXVhOVRJYVZJVnZrVTRQdTBkS3Jpb0Ru?=
 =?utf-8?B?S3ZYdXh2UmFGL1dOMXMvVUtXWHNMdzI0ZE16a0NPUHprelM0WWljNTZWK1hG?=
 =?utf-8?B?NTEzSG4zcHhQV2J6OEpPekk1UGlGVmZRbFBkRlhGNHZjbVFIVW1McWNjUmJ4?=
 =?utf-8?B?S3lKemVRWTlpVmxDQ0dFUlZPK2FhMUxVZGlzdU1uQ0kzaHZYdi9SdTE2aHZi?=
 =?utf-8?B?bzBOTCsrOVo5UURDZFg0ekxOcytjSzIvTTBYc3F2bno5MFFWYlVRVUh0ZjI0?=
 =?utf-8?B?UktxdytGUTM1aTNNNUN1RXczV2YyMVZVaFljSkNVbnhpUUhSNHN1R2NaTDZX?=
 =?utf-8?B?S2pNNVQ0NzY0Nys4bmZDL3d4MDB6NVNtNFhWM01HVklreXVDZnc1aWpEVk9p?=
 =?utf-8?B?UjNtL1VlUnd5a2V4aVpEd2xveWgrM1dIdEhjcVk2Sk9qamZHNHRJdlRnRHpK?=
 =?utf-8?B?T0hIU1drbzdvd0xXMWNkMWtmeDJEZlV3dDE2VHBPSUN4VGNlamJkZmxqNmpJ?=
 =?utf-8?B?dEdadEZDRzJsaFZ3RVdFWDNtbVJQRWVTcjA0VnZUeUt1SlZUTHI2aXYyQzds?=
 =?utf-8?B?bkNuc05jQUtWS0d2ZE5GUHdMejVxekxUdExJT09CbDFlZzVxU0tQS1R6T0RQ?=
 =?utf-8?B?L0tuNG1kejBXVzNiM01mSXhKMHJkRHBrSWV1OVAybW5JZmtHRXp6elB2SDVp?=
 =?utf-8?B?SXdMRHhWTGs0VmdCSXpNUVlvUCs5VzZ1MWVWRU90d1YyVGZtYXE5T1YzaElL?=
 =?utf-8?B?eC9xWlhHVDdrbmdlWElnb3o0NGh4T0pBWDBJL25ZR29MRHZCR1hpcUdmWGJB?=
 =?utf-8?B?ZWlwamd6ZTdYclB6RGljV0ZGeWVNb1ZyNkQzMVhDRHdxQVk5M1ZQWWRQY1Nz?=
 =?utf-8?B?WWQzLzh1bUhJM1UrbWlwT1Q3T3d4UitxYjZvcHhCQUtBN0RqYzhQMDVXVXVR?=
 =?utf-8?B?bElmYmhVMlkxZkRMemdyMHpvVWlja1Rha3VySkhvU2tNeWd3TXUzbUJ6eWtz?=
 =?utf-8?B?ZDZ3S3FHRWs2enVpbml1RFZBM3JWUHA3QStQSjBIeG9qY0VnT2VoV3ZBK1pX?=
 =?utf-8?B?aFlydEdHOGdpM1RNRlFTUWw0bjFFYVZmbk0rWDE5by9iYVl1TkRReVBITUp4?=
 =?utf-8?B?dTZnYzlGOW9nVXg4cUhQK2JLZnNreUlZR0g4cCtsajR3bmU1R3NhTGh5WFNt?=
 =?utf-8?B?VlRWRnNXNnlVMnJ5VlQwcy84OCtCVDd0ekNncEZuVS9mVjhaWTN6bWhiUEZz?=
 =?utf-8?B?QUNYcEwvdFZkV1EzVm1jVGpxcjFWZ2F3dktBaXBOWmd5RndqZ1hpZVZ1Sk1s?=
 =?utf-8?Q?RrWHJcZEY0DRJxbd6STIUVOgd?=
X-MS-Exchange-CrossTenant-Network-Message-Id: d80ab2dc-e387-4690-8dec-08d9f31a6ea8
X-MS-Exchange-CrossTenant-AuthSource: MW4PR15MB4410.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Feb 2022 20:08:30.2437
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: RlXEjSfbuvF6ldg1UgKf7MyHafh1sIRy0rJzbWQ4B768vzDFO1cqR5MZ2zY0tNgI
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR15MB4325
X-OriginatorOrg: fb.com
X-Proofpoint-GUID: TkucSdkp8IjbR7NKX4t8DgBInge-dRlJ
X-Proofpoint-ORIG-GUID: TkucSdkp8IjbR7NKX4t8DgBInge-dRlJ
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.816,Hydra:6.0.425,FMLib:17.11.62.513
 definitions=2022-02-18_09,2022-02-18_01,2021-12-02_01
X-Proofpoint-Spam-Details: rule=fb_outbound_notspam policy=fb_outbound score=0 phishscore=0
 spamscore=0 adultscore=0 lowpriorityscore=0 bulkscore=0 priorityscore=1501
 mlxlogscore=559 malwarescore=0 impostorscore=0 mlxscore=0 suspectscore=0
 clxscore=1015 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2201110000 definitions=main-2202180124
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



On 2/18/22 11:59 AM, Matthew Wilcox wrote:
> On Fri, Feb 18, 2022 at 11:57:27AM -0800, Stefan Roesch wrote:
>> This adds a flags parameter to the __begin_write_begin_int() function.
>> This allows to pass flags down the stack.
> 
> Still no.

Currently block_begin_write_cache is expecting an aop_flag. Are you asking to
first have a patch that replaces the existing aop_flag parameter with the gfp_t?
and then modify this patch to directly use gfp flags?
