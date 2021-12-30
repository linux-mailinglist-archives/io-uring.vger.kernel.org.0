Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C7CE9482019
	for <lists+io-uring@lfdr.de>; Thu, 30 Dec 2021 20:58:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242029AbhL3T6B (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 30 Dec 2021 14:58:01 -0500
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:60114 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S237051AbhL3T6B (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 30 Dec 2021 14:58:01 -0500
Received: from pps.filterd (m0044010.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.1.2/8.16.1.2) with ESMTP id 1BUJfuAa004847;
        Thu, 30 Dec 2021 11:57:58 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=facebook;
 bh=qcybHHIrUibuv35Yr2GHFcx990YFuEg/OvhkY5dfFeY=;
 b=S0op6L6TSUqebO17RZsYKDTUEvRLA2hstel/84WEyCPIn+xbIIgCg9bAp9okA7JIsCej
 DA+mN6b+qtx1O78pO8pDmyGSEXkV45kXGzFml6kpU7g6isZS0TlC8opJolw3X4C30BZ1
 xviTUJztddAdW7qxGAG/yJZdNwqhAMFitiU= 
Received: from mail.thefacebook.com ([163.114.132.120])
        by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 3d8ghb2mx3-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Thu, 30 Dec 2021 11:57:58 -0800
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (100.104.98.9) by
 o365-in.thefacebook.com (100.104.94.196) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.20; Thu, 30 Dec 2021 11:57:57 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=np+2+bpk8MqXHzILsDwu35TqXZ+4/k1pyyf0cXT6YS1L7WafJ8TeEZCc7wDMJS55QsTAvkg4LApSLvJmSqDzGDwY5B6E0RYXLyMKmskLFT+ONboWBXlSAOQygTyzKY063Oe5M5B62NQWtG5SO48tRgj+QrabzL6fdwZa4N3O6wdiblxxA1kFDE/7UKYcs7XYRKIzE3chI4dWNCx8IZCT7n/GOTGF9DPpVWB+bqTIhBEuK5s0LUKTN39UStnXTMDmpuYJAdfajuUpUYE0iqz7elGghtidtJZl6AkVSa7xAFhrm7cyuS3r5fb+PlrPiKpq44tcWtUa46mJGhKXq80EqA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=qcybHHIrUibuv35Yr2GHFcx990YFuEg/OvhkY5dfFeY=;
 b=AAuQ1Irlh2oJM/wGiLKaPQwLgsYEt//g9saZ1JJmKTsyqinxQGQLsawbLrQwTPuLlsYNPaN61/yrZPK9ztenDvQ+QHUxTEdfZyw+TzuonN8vDYcydzbrNIGjt6xk2mhwNgrKi9tHUl297SxCHagM65JsqKVLfgPyXnPKmBzKp4gI1GBHoTXMLuXbfWGRn9qfzUSt6i85F2Iy5M9UN27WpLiYP2d2tFQRij7m4KzSEnul9nuB6weqDmAEuTzkO3M0kt1xLyfevvZ/y6+RaeLKMpvAfk2oK3CEZT04cL8Ho/l8lSgxtYKeaL+V7s0/oQUt6SGuDnyL2ce/4n2YIqzFFg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
Received: from PH0PR15MB4413.namprd15.prod.outlook.com (2603:10b6:510:9f::16)
 by PH0PR15MB4640.namprd15.prod.outlook.com (2603:10b6:510:8c::24) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4844.13; Thu, 30 Dec
 2021 19:57:50 +0000
Received: from PH0PR15MB4413.namprd15.prod.outlook.com
 ([fe80::31b6:7571:66da:5cab]) by PH0PR15MB4413.namprd15.prod.outlook.com
 ([fe80::31b6:7571:66da:5cab%7]) with mapi id 15.20.4823.023; Thu, 30 Dec 2021
 19:57:50 +0000
Message-ID: <921728bf-a147-708d-78a4-b7302a4d5bd0@fb.com>
Date:   Thu, 30 Dec 2021 11:57:47 -0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.4.1
Subject: Re: [PATCH v10 2/5] fs: split off setxattr_copy and do_setxattr
 function from setxattr
Content-Language: en-US
To:     Al Viro <viro@zeniv.linux.org.uk>
CC:     <io-uring@vger.kernel.org>, <linux-fsdevel@vger.kernel.org>,
        <kernel-team@fb.com>, <torvalds@linux-foundation.org>,
        <christian.brauner@ubuntu.com>
References: <20211229203002.4110839-1-shr@fb.com>
 <20211229203002.4110839-3-shr@fb.com>
 <Yc0IHp2igNlXqyKV@zeniv-ca.linux.org.uk>
From:   Stefan Roesch <shr@fb.com>
In-Reply-To: <Yc0IHp2igNlXqyKV@zeniv-ca.linux.org.uk>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: CO1PR15CA0052.namprd15.prod.outlook.com
 (2603:10b6:101:1f::20) To PH0PR15MB4413.namprd15.prod.outlook.com
 (2603:10b6:510:9f::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 0276b4ea-7783-4d5e-56d4-08d9cbcea8b7
X-MS-TrafficTypeDiagnostic: PH0PR15MB4640:EE_
X-Microsoft-Antispam-PRVS: <PH0PR15MB4640F87437CCFCFE05DBE26CD8459@PH0PR15MB4640.namprd15.prod.outlook.com>
X-FB-Source: Internal
X-MS-Oob-TLC-OOBClassifiers: OLM:7219;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: ksgQc9aDjnw8XjrvzZAER38M2dYVbgFkbOJovdQ4TU94V7ALQBj1TXxH+4k4A9kDfO6RIsK6esJg5PrKq5d/QbVyYKmJQ7zs1S53kDnYz0QS8EixX2BcXu8DADXqkucsCjKjO/6v6LB3jzyWlpp6/NYqWPyFwMCN9ZVL0JtJbWna/1O8m6i4q6CbQ9r3XrUPQ/JpLn/82rg0F7H/GABgICIElcHMTtXqmMm4ty1MXwjj3GzBjOytdWhQlWyeNzS5+KigMOwND40vY52l2BM88EaFzdWJ6rf8GBOQtW++eQ7hOOHNEUjiiguAZJdegxXkOfXbODcmM9wA+8B8elqV24NGThRemWG1pv5PrL/N7yx0zRVJhtt3oYxuO5Z6XKMPbKTMiVqIKgA0fK6jRUv1urt5JAkmTT5rxAtORhRJ/OF/wDezLSfcnllUu/UXUP5MK8uC5hqyRUf6KPz9m7U/E29w8vWhXRAX9GuV9n1KpTNeWb8zq1dk3rjyH0LeGaRBlfd7C8E3qP/MSDvDEUdrK1G/t/ocJ3IGCTKZeaO8gNpWL36Aj60HgXDz0zzral7ai6diz9i3uIfnZZlkAap6eWJHffNFHQ44Tzo8WYOp6xTIezGFLRNGSWsUNnkbnN6lBdGZbou3gWX2MuwcwwVnHiiaHJhleectSRHx7V70sIZTDbg1j6W9YzAV13RhwvsLgPZN53Q+2UuvUM3sAi/rtmKx6OsICHQStHpAMbgQ4Ic=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR15MB4413.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(6666004)(5660300002)(36756003)(66946007)(38100700002)(6486002)(31686004)(8936002)(4744005)(66556008)(31696002)(66476007)(8676002)(508600001)(6512007)(186003)(86362001)(316002)(53546011)(6506007)(2906002)(4326008)(2616005)(6916009)(45980500001)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?K2x5MjBRbloyK2FUTFlIUWZLaG9EbmczVWtMcW54elA4MDVyZWJubmNTRTVI?=
 =?utf-8?B?YzhiclhoWklTKzZkbVlVc3dZSk82Y3p1dGVwUjRPQ0ZKQjJKN2Y1U2h5WUhV?=
 =?utf-8?B?ejFTdkVDWTdsQjk0NU85dFA2Wm1UWkFyTWZvSlFjd2JrQUdYU2JLY1JySXF0?=
 =?utf-8?B?aFJHK242NzM0ZzBKV1hXbnJ0L2J3c0RTVjhlMWVSZ2xWOVpSQlFVdlNqY0ww?=
 =?utf-8?B?ZTc5cUFyc1lBU2JoVmZyeFpmRlM4a3A4TThZZzdyaVZ2dFUwWk5ad1RpVjk4?=
 =?utf-8?B?UWtVUjFxOGczR2dUY2diQzN4U01OemNLUldQSzRqUW1kSGVjUnB2Rkh6c3Q3?=
 =?utf-8?B?OTdjZERERWJxN3k5R21ZT1l6d1VnemlVbG1Rd0wrUUZwRXZEL2hxSEpYQk5o?=
 =?utf-8?B?YjNsRVh4YXVpRmZ3cUlydGlkWHZKWmVXeUdrUTV6S3kxb283SzVOV2pMWmNT?=
 =?utf-8?B?dWFpWFpYb2I0L2RKM0xWZXZIb0MxK1dBK2tmTFJlV1crZ2kxalZ5RXlhSWt0?=
 =?utf-8?B?QkY2S3FXeFhjY1VybTZvMUozb0k2MlB6bVhLYUFvQ2ZqSDJtZ2RBVVV2Rkdm?=
 =?utf-8?B?UEVHM0tuNCtFTzg1Q085ZmhCSExHM25XV2FiNGVES1F1ZTJ2aVRmM0tGdUdH?=
 =?utf-8?B?NFY4d2pSVzk0NGdlYWIzZFJDTUtkL3kxSDgzczhKc3JqOGFRcjk0MXA0bGR2?=
 =?utf-8?B?L2JVZy9Jams2elhCMEE2MTBXSVdvdzdOL3NDMWg3dnlUeWpvZWd1bjVtaldR?=
 =?utf-8?B?THRjK0x6K2EwZnBxM20yY1pWQms2NFJXMVhlSXN6TkVBemlNMForMmpLaEcv?=
 =?utf-8?B?Y0FTcGFrcTVlMFVaS3RLbFBTUGg4L0ZlV0kxZGI3dFFqVmZramRiMktFT1RX?=
 =?utf-8?B?T0ZNTG9RaEY3ekh4RU9ZOXdPU0NtN0RWbUVTMno4bTNKTEM3YzI3NStoaHNu?=
 =?utf-8?B?L2JHRFRxbFh3WHEwZmFYcllpOHhONWp1eUNDay8vZzdnZy90V3IrSDVIbkVD?=
 =?utf-8?B?Q0VMcCtqZURqTDV5RmY2MUxaMG45Wko0MGlSOVp0SnFiL1lhUlRPNFoxcFls?=
 =?utf-8?B?VFgyMnB4KzRNWDhpY01HTHdLL2ppY01NM3plcEhFbUp3R3p1SEF2SzF5cElN?=
 =?utf-8?B?VVB1ajh4VEkxeHRwL1R4SnJDUXdUN1BPbk5HMHIwV2dKZUlIb2dzcXpCblFz?=
 =?utf-8?B?SjE4V1RiWVBVdjl0M0RtY3NBblB6SVlod0xKV3JPRmxQTVZONXdQWWE5WlFR?=
 =?utf-8?B?cTFYNHo2SzVocGtKdmVnQ0dTMTZlbGtZNUZGbmZEdnVZQjN1Q2FnTE5temFP?=
 =?utf-8?B?c1FNK0FWdHM3bGlnQjNHRDZxNkx2Q3NQVjFWd0tHdC9RSjVmakR6dEtQQmVu?=
 =?utf-8?B?NDYraUlYLytPVHpEaC82QnVKb1U5YW8wZ0RhSG9BcGRzTm11M2N3czJ5SnFq?=
 =?utf-8?B?NUNNR1QrZktXMEhrbWo5VWZVeWVWTFkwbXRGbUszYnJoakF6b0xyRGZ6NE00?=
 =?utf-8?B?K3grOUJ6VGdvOC9RTHlzYUdUcjdLUVo2VTBldk1aU2l1ajlPRFNqQng0WFdU?=
 =?utf-8?B?ZDhsb2d3VlVMZ1JrVWtWRmVTY25velhWeUNicmU2aGl5enpGZzQvVkp0cWNz?=
 =?utf-8?B?U0ZJNmk1TEZwQWJhUTh2Vk81c1BSNVRTNVhkWnA0ZmNFeU5PZUFGRDNqTWtE?=
 =?utf-8?B?RjNKdWplbDhxWkg5dU5LbmdBM3A3ZEpoYWZJeStLVkxZRVFLYzR5eWxneXJ1?=
 =?utf-8?B?UHNWSEdHY1NYT2QxYlBhN3BRNHZRSTd5cEVlTDFkbmFEL2NJVWd0dE1OejFF?=
 =?utf-8?B?Z0FQc3VzK2d0RnE1Z2ZhOU9jb01UbjhvQllOeXFWY2JZY1c0ajU3Y1VIU29X?=
 =?utf-8?B?S25tR2g3cVFod3oxV0ZDMUtUSFFFcUR3VHROTSs0RHRVTTNiaHo5UXRuVzdy?=
 =?utf-8?B?cXpBN3dibFdoWjVOK0h2ZUxqeVpqNDlGVHNySndwdlV2eWtXMWQwWTQwTGxk?=
 =?utf-8?B?cUhUeUFtNThsdkZEaTFqS2hENmJiaElMZENlSTBiVUdsTys1aTduUUpxZ1pK?=
 =?utf-8?B?RXNYUEhGMkNjRUdxVmJXV3RnaVBVRDk3YXErZmFWcjA2WGo0RVY2ZmZxdlBN?=
 =?utf-8?Q?PXcm/Ffu/iIs++E3z3IqGqNO9?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 0276b4ea-7783-4d5e-56d4-08d9cbcea8b7
X-MS-Exchange-CrossTenant-AuthSource: PH0PR15MB4413.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Dec 2021 19:57:50.5174
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: cTTnvw58bHNB7tdu8VOTU2nslnoeacYcbzcYvN3rC842pDQJ6qxtyuzidNtM2YNw
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR15MB4640
X-OriginatorOrg: fb.com
X-Proofpoint-GUID: kN9PpLxRKWrp_3vGc7wl4tnVXO3BvtqF
X-Proofpoint-ORIG-GUID: kN9PpLxRKWrp_3vGc7wl4tnVXO3BvtqF
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.790,Hydra:6.0.425,FMLib:17.11.62.513
 definitions=2021-12-30_08,2021-12-30_02,2021-12-02_01
X-Proofpoint-Spam-Details: rule=fb_outbound_notspam policy=fb_outbound score=0 priorityscore=1501
 mlxscore=0 phishscore=0 malwarescore=0 impostorscore=0 spamscore=0
 mlxlogscore=833 adultscore=0 clxscore=1015 bulkscore=0 suspectscore=0
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2110150000 definitions=main-2112300114
X-FB-Internal: deliver
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org



On 12/29/21 5:15 PM, Al Viro wrote:
> On Wed, Dec 29, 2021 at 12:29:59PM -0800, Stefan Roesch wrote:
>> +	if (ctx->size) {
>> +		if (ctx->size > XATTR_SIZE_MAX)
>>  			return -E2BIG;
>> -		kvalue = kvmalloc(size, GFP_KERNEL);
>> -		if (!kvalue)
>> +
>> +		ctx->kvalue = kvmalloc(ctx->size, GFP_KERNEL);
>> +		if (!ctx->kvalue)
>>  			return -ENOMEM;
>> -		if (copy_from_user(kvalue, value, size)) {
>> -			error = -EFAULT;
>> -			goto out;
>> +
>> +		if (copy_from_user(ctx->kvalue, ctx->value, ctx->size)) {
>> +			kvfree(ctx->kvalue);
>> +			return -EFAULT;
> 
> BTW, what's wrong with using vmemdup_user() here?

I was simply following the existing code. The next version will use the vmemdup_user function.
