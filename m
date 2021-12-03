Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EFA11467CE6
	for <lists+io-uring@lfdr.de>; Fri,  3 Dec 2021 18:58:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1357558AbhLCSB5 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 3 Dec 2021 13:01:57 -0500
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:10396 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1353587AbhLCSB4 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 3 Dec 2021 13:01:56 -0500
Received: from pps.filterd (m0148461.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 1B3HlWJ8013574;
        Fri, 3 Dec 2021 09:58:19 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=facebook;
 bh=pOtdMFBkBaJlXE9IF9GMEmu87hBrpM2PBg8ClFV6gQA=;
 b=k7Wps0BHn3TNDteMFKDqeZ/5SPgiMr+NBHsyMNEyUeby8smJ2am+kAxtr/oktNi0Hmev
 q5aRWvdg3NrUdk+svf5C8WkaWybYNNdItZJSEQh2QMPIRNR/AGhw+nDETelidUCalbgW
 fnXFIj9uepF/aDAveUJqEeN9Pmc/55mqJtE= 
Received: from mail.thefacebook.com ([163.114.132.120])
        by mx0a-00082601.pphosted.com with ESMTP id 3cqck4cm7k-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Fri, 03 Dec 2021 09:58:19 -0800
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (100.104.98.9) by
 o365-in.thefacebook.com (100.104.94.228) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.20; Fri, 3 Dec 2021 09:58:18 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Q2cgzevvrXcB6iqM5XjOSSWFW9VyZlrAigqrsFcwIi7n4ty6wMnmpWgyEZ77dI7gatkSYKSrOeHSYg+tlENYLKIZ5bJEHQyzUpn0HmhFy9DBubXyzu7yGAnA+JP943q3+lOf2rIp1mKrSaHTLXuUtVzZbkxErmvgKJKB5cHBN8+os+jUQCO2MGvWQCvBql6flxWnpNd24Sk63m06TS8grGkt2QpPJ30z0IIgxmraoy1e6myr6h4XCGQjX7cUTtxbwYEEGlsteGB7hwaXmkr7uv+TSUB0OEJlUdV1B+dn1Gnq4WbzMwiPAinTwi4kqr9uf/jqjKllkLdZXOCl5Y1ldw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=pOtdMFBkBaJlXE9IF9GMEmu87hBrpM2PBg8ClFV6gQA=;
 b=AWvsh1ElRBOqOiN5pY2LghhvF/3VCVCakaXK7qCSY/CbROOSiz1aMtkPVLjcqCHE9+6A8/MRCWEjrmlz9Tg/wrtHTSNSWbXaIDE9jcrMJq635tG9KNgUXctqFkKo2N7+D8QUj2ZcTG5yS1OBCtyG9CD+B9H6JloEoT98QbIEZOnWfT8uG0AIe68XJPYbfK894GY976MQd4YwF4RgVgXXNBl2ILK8r8JlQW0sLDqhdJYJe41eNbD14CqCUDYbXP+njfYrR1uMAYdGkZIjtzok4GCZd1dc65R2OLWAFI23PmkmJkrTEeIPU5Ttp7enfeSP6sqpG4//huvlJAW+KLb80A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
Received: from MW4PR15MB4410.namprd15.prod.outlook.com (2603:10b6:303:bf::10)
 by MW2PR1501MB2185.namprd15.prod.outlook.com (2603:10b6:302:12::32) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4734.22; Fri, 3 Dec
 2021 17:58:17 +0000
Received: from MW4PR15MB4410.namprd15.prod.outlook.com
 ([fe80::f8de:1089:be1d:7bf]) by MW4PR15MB4410.namprd15.prod.outlook.com
 ([fe80::f8de:1089:be1d:7bf%8]) with mapi id 15.20.4713.031; Fri, 3 Dec 2021
 17:58:17 +0000
Message-ID: <d9673acf-faa6-2851-9ca3-fbd2cdcbc9c1@fb.com>
Date:   Fri, 3 Dec 2021 09:58:15 -0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.3.0
Subject: Re: [PATCH v1 0/5] io_uring: add xattr support
Content-Language: en-US
To:     Stefan Metzmacher <metze@samba.org>, Clay Harris <bugs@claycon.org>
CC:     <io-uring@vger.kernel.org>, <linux-fsdevel@vger.kernel.org>
References: <20211129221257.2536146-1-shr@fb.com>
 <20211130010836.jqp5nuemrse43aca@ps29521.dreamhostps.com>
 <2ba45a80-ce7a-a105-49e5-5507b4453e05@fb.com>
 <56e1aa77-c4c1-2c37-9fc0-96cf0dc0f289@samba.org>
From:   Stefan Roesch <shr@fb.com>
In-Reply-To: <56e1aa77-c4c1-2c37-9fc0-96cf0dc0f289@samba.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MW4P223CA0002.NAMP223.PROD.OUTLOOK.COM
 (2603:10b6:303:80::7) To MW4PR15MB4410.namprd15.prod.outlook.com
 (2603:10b6:303:bf::10)
MIME-Version: 1.0
Received: from [IPV6:2620:10d:c085:21d6::1400] (2620:10d:c090:400::5:8022) by MW4P223CA0002.NAMP223.PROD.OUTLOOK.COM (2603:10b6:303:80::7) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4755.17 via Frontend Transport; Fri, 3 Dec 2021 17:58:16 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 2f246e4c-6758-45f3-b656-08d9b6867bf1
X-MS-TrafficTypeDiagnostic: MW2PR1501MB2185:
X-Microsoft-Antispam-PRVS: <MW2PR1501MB2185908493BFED9E0D36E0FFD86A9@MW2PR1501MB2185.namprd15.prod.outlook.com>
X-FB-Source: Internal
X-MS-Oob-TLC-OOBClassifiers: OLM:8882;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: A2Q9kUDZUJqafBwfZiHzRWRpoKdb8/Sw4WZ+y/seoe0nTtppg3cc3gEl7qF+JuCuODvht/rk6lTmLkVmiynU1o58qEp4/XAEa0z91eU+ey+KdD/9FxhwPIhAxbou5mtG9OI/Iyhm7HACMgUK8R6s1jOsXSQozO9u7iwmnxeniEznZc2NZSfRacy5b6N5UUYPzV4L294b317Xasx2GXl6YOfyIvWfII0qZs5yLdXVIN9bc6tHdX9AU+5d9JjPtc0TCjqj0Nb2flE/uTJjQ0WW3nUviN6IrZJyPUmzLJ4CSIltNjftz01tKGYDNWDCz4YXOH0hk5a0qSUGsTkbLBMZGlLgJqrfT1QDOheB182f4cs3H6MsZdfcVppdaP5lms/a0H9VkNnrRewAIv6r3+UKli7P581/9ryGLX8+MHkhj6W60sUxpbgPU6MXVmu6/uHECE9niK5JeMfooVNez2c/TCZU6mCc9jJPzyGbmrBjwMG3YADFhWyX/9dj1Tla8wCMbDp0BYTVYfUIalv9DxdhKvc83iKawWse7mGfXlnQr9D/RciV3KQI2MOgjtmvN++OmHY48AlS02V6UQWrz2Bxznm9Y02FkXYv4iDSdyp9GoTNnZWnNrdnyWbmU2faNk8X+UD2NVFHAFlVPN8/g4lkSGYWscHSutfrzjLMSLiv1Gsw8IbMSFFfYIfGXbxG41ErhTvp+mK8eF2FClm4/+2O1qKmF0WN6XhdkJ1B5Ji9UgE=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MW4PR15MB4410.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(83380400001)(2906002)(86362001)(6486002)(36756003)(508600001)(31686004)(31696002)(66556008)(186003)(66476007)(4326008)(8676002)(5660300002)(8936002)(316002)(38100700002)(53546011)(2616005)(110136005)(66946007)(45980500001)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?VlBtcHBPZzlhaTMrOWhnSG85dzlBcXliSXNrenIyMGtDbmNWVXZzVGpmR0dS?=
 =?utf-8?B?V3doNVgwT1RqNVZCVS9WVWc4WFJSOVZUdWxJVXNyc2FOSCsvdlFjS09PS3p3?=
 =?utf-8?B?N3JrbkVJdWtjMXlwRGhDRmkycXh1Sy91MHZNaVJGU0lXSGdFWExBVFN6aUo1?=
 =?utf-8?B?WWpxVU51RzRJNnExWmhzemdCZzlna0puU0dUOS9xTkhDTW1lbXlCNEptZElw?=
 =?utf-8?B?T0l1c2Z2eTBoVXpoSDd5QUUvUU1lMmJBNEh1OTdueVRncGlhVXltWXIvYURh?=
 =?utf-8?B?b1hvazhyQTh0ZjJERFRWUlNtNmtLM1E3QjhOU1NibkRKN0labUpSVWFuRUVT?=
 =?utf-8?B?cks4ZzlhNGZaQ1dnaEgxZmdIYWFSUU1HbGdUZ1NkRWlreTRLNGszZkd5b0tu?=
 =?utf-8?B?SmV0SG5vN3JrTmV5RHBlWUlGZHpZTXQvVjhGYklKNE4wSHl5alh1aGlyaHMz?=
 =?utf-8?B?YngvVFBXY2o1ZFpQMjZnbk92SkRIdDQvY2NYbFhGUVhaM3dwQWFvbmZCeVVu?=
 =?utf-8?B?enIrdE5LUDlJSmp2NFJaY2hnaUp1K1NqbUxMdXFyeGl5OFlFbEVqRWUvWkNC?=
 =?utf-8?B?eEVRelNoemh1anN0K2tmRE1tZm5iaXJjWDh5a0VCZHNlZzVlandwSHZqUWhC?=
 =?utf-8?B?R1NRM3VKajJ2amxhRWExeTQyanJKQmNBNEJ6U05KZWUyd0NXZTd6Q0JlQXp1?=
 =?utf-8?B?UXB6SElkSXJ1dzBacTcrUVdrRlVqVDE3a2JmUnFpN0d5K20rV3ZLbWN6S0E2?=
 =?utf-8?B?V2R1TThJb01SeC9zV1JnODcyRHJXbTRib3VxZGpFK3ErNjkvR0huT0kxU0VR?=
 =?utf-8?B?TUZsOEJtTVFCMVRjblJ5LzFJWDZBZURJU1dVYm5YbXo5MXNjcm15RjZ6Ympz?=
 =?utf-8?B?cHdGMlZyVDdacW9xbDgxdlVKbmlxd3JxdHZGQ2wrUnI3b011anJ5Q2p2akcr?=
 =?utf-8?B?ZHUvNzg3ai9nWVFPUzVXb0phditSR3IyazVXMm5tN3ppS1MybGNpVkxnOUNt?=
 =?utf-8?B?MkhhSURjcjZHMlI1UndBdDVDSDhERGxYOUxtTzBocS9rbTl1eXZWa1hzbWd2?=
 =?utf-8?B?ZHlhNGNSdVlZR1F6WXFDTE0rSVdlZktmdmFWelpmR1JQaGhvYisxenJTSkh1?=
 =?utf-8?B?NExOWWVlRGJVUzh5MzJsWE8rVDdoaWVxNUJTTkN3cWkrcnpQb25leSt5cldC?=
 =?utf-8?B?YXZyQ2FqbXo3SU4wczFlYWJhR2pKKzlDa3k3d293MXNreEF2YWdqcU9jdE45?=
 =?utf-8?B?NVY2NzVmblI1VEdPZmkraE81YnZ0OG4zTTNxS1FuTC93blEwTGFTeHVtTTV0?=
 =?utf-8?B?TGZ4Q0w2djZEUlFDZzB0a3RKY0FWbmlVZVROOUNZOHNPbjQ2N1ZUUHo2MHNw?=
 =?utf-8?B?TGJpczNTVUt1V2kwMjVmSUUxNHB1ZS83amg5eFhvR2ZrY1FLQ2hsUjdtRURi?=
 =?utf-8?B?RS9adVhYaXdVMlp0VTVWV0NYbmFsNjRHOU9zMzB5bGs4bWZFWFREZm9DYTNY?=
 =?utf-8?B?YmxxNUgxeW9CN0J4a0xTaWE5YzFVNHRnKzU3VmRlb2l4aFh1aElpMGt1WnQ2?=
 =?utf-8?B?WHhtR0ZyU09BcTNwUTZ6UTF5WGs3aisvTEludERJVFE1dFdXNFpyNmRDNVRh?=
 =?utf-8?B?L0Jpd1ZncFlzU3JJZHlnOTl0ZEJxM1lRdTdVTmtKcTc3U2Y5Ync2N2VWVXVQ?=
 =?utf-8?B?Q0JveFhldUtFZzZVOVdEOUxSMWZpTEl0blBvZVh3MGN0Wk9XVUtpUnYzM2Y0?=
 =?utf-8?B?YUoyRUJ2UlN1d2N0RmpTRWI4OHd1eEdncTd2Q3FkdG1UYklXT0VqWExldDRa?=
 =?utf-8?B?QXdzR3pYSFNGVDJXcUYzVWxrVXpqT3g0V1MvSHZQeW54TWRycFNieUZEUnVB?=
 =?utf-8?B?VDMwbjJjTVlRS0FIM1pIY2xRZXhjd1JjTHhhM00yRm1QUzFVNXhxandHN0R2?=
 =?utf-8?B?MjkwbVZqV2R1TFFFV2FNRmJtUnVja2FnNGMzQWFvU3JUOElnSlhzT3hhZzZQ?=
 =?utf-8?B?SE9sUDRoYTlCMmlTQS8vdmU5dFpMWUJCUm9rTk91ZHhEd2ZJdFA4TjFTL3Fz?=
 =?utf-8?B?N3hqK1RVb1k2UUs1K3FGOEpyR3pvSUFiT256WWF4SjNLc1hqdUY2eG83Qm05?=
 =?utf-8?Q?Bn2bVEGB2Jx2Ubh7eU4mW0D2f?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 2f246e4c-6758-45f3-b656-08d9b6867bf1
X-MS-Exchange-CrossTenant-AuthSource: MW4PR15MB4410.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Dec 2021 17:58:17.2430
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: vztHNYmCFQRJGso2P8wlcR4L+V7k6P/4vKcMr2LtvUYmnmpTGQ5JWD+JH9+U1/ew
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW2PR1501MB2185
X-OriginatorOrg: fb.com
X-Proofpoint-ORIG-GUID: jecd3z1n6F-yvmEWpTDWZxfhIpSqSfuv
X-Proofpoint-GUID: jecd3z1n6F-yvmEWpTDWZxfhIpSqSfuv
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.790,Hydra:6.0.425,FMLib:17.11.62.513
 definitions=2021-12-03_07,2021-12-02_01,2021-12-02_01
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 spamscore=0 adultscore=0
 impostorscore=0 mlxscore=0 suspectscore=0 bulkscore=0 phishscore=0
 lowpriorityscore=0 clxscore=1011 malwarescore=0 priorityscore=1501
 mlxlogscore=859 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2110150000 definitions=main-2112030114
X-FB-Internal: deliver
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Hi Stefan,

On 12/1/21 4:19 AM, Stefan Metzmacher wrote:
> Hi Stefan,
> 
>> On 11/29/21 5:08 PM, Clay Harris wrote:
>>> On Mon, Nov 29 2021 at 14:12:52 -0800, Stefan Roesch quoth thus:
>>>
>>>> This adds the xattr support to io_uring. The intent is to have a more
>>>> complete support for file operations in io_uring.
>>>>
>>>> This change adds support for the following functions to io_uring:
>>>> - fgetxattr
>>>> - fsetxattr
>>>> - getxattr
>>>> - setxattr
>>>
>>> You may wish to consider the following.
>>>
>>> Patching for these functions makes for an excellent opportunity
>>> to provide a better interface.  Rather than implement fXetattr
>>> at all, you could enable io_uring to use functions like:
>>>
>>> int Xetxattr(int dfd, const char *path, const char *name,
>>> 	[const] void *value, size_t size, int flags);
>>>
>>> Not only does this simplify the io_uring interface down to two
>>> functions, but modernizes and fixes a deficit in usability.
>>> In terms of io_uring, this is just changing internal interfaces.
>>>
>>> Although unnecessary for io_uring, it would be nice to at least
>>> consider what parts of this code could be leveraged for future
>>> Xetxattr2 syscalls.
>>
>> Clay, 
>>
>> while we can reduce the number of calls to 2, providing 4 calls will
>> ease the adoption of the interface. 
>>
>> If you look at the userspace interface in liburing, you can see the
>> following function signature:
>>
>> static inline void io_uring_prep_fgetxattr(struct io_uring_sqe *sqe,
>> 		                           int         fd,
>> 					   const char *name,
>> 					   const char *value,
>> 					   size_t      len)
>>
>> This is very similar to what you proposed.
> 
> What's with lsetxattr and lgetxattr, why are they missing.
> 
> I'd assume that even 6 helper functions in liburing would be able
> to use just 2 low level iouring opcodes.
>

I'm open to also adding lsetxattr and lgetxattr. Do you have a use case in mind?
 
> *listxattr is also missing, are there plans for them?
> 

*listxattr is currently not planned.

> metze
> 
