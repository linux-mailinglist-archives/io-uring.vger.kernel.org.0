Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 939A045E343
	for <lists+io-uring@lfdr.de>; Fri, 26 Nov 2021 00:20:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347193AbhKYXXM (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 25 Nov 2021 18:23:12 -0500
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:56996 "EHLO
        mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231786AbhKYXVL (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 25 Nov 2021 18:21:11 -0500
Received: from pps.filterd (m0109332.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 1APKjkCg017763;
        Thu, 25 Nov 2021 15:17:59 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=message-id : date :
 subject : to : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=facebook;
 bh=KnDLLYfRtb9uYZyz4L58j6ujXFWZkDehshYhzjpyo3g=;
 b=f9cnXl3IKRQIha8b01ld8byTa8OT7/0YrYe8HKWxL/pG8FWREuxEe3ELJFCo63DDL92g
 C42MjLAFOk3bRz3aX4NsGUUcSN2i2AKFjBjQd0Uv5h1lsutE4RzUa2kA0IDofTxtJnPh
 6GRxsbXQip3dNNZoPozYjd70VXnB/gsSn+c= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 3cj5sg4eps-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Thu, 25 Nov 2021 15:17:59 -0800
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (100.104.31.183)
 by o365-in.thefacebook.com (100.104.35.172) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.20; Thu, 25 Nov 2021 15:17:58 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=VfIP55crOjcK+MlCjs0qBnZfRlMHRE5iltoIYTSXeIQRmFSfj+3wsM8/JN5WhA7Pav4mSteiglhr6qk8DTapBDTWOiAsMUuCiKgzrYwjPoGoMo8hXI8GUbHO7grv9DV255Vkl29DOAdAvUOevsnlMXAPO+zLlBtI4kfDPhkzivvxavME/bxIkIzOyTqEmu+pXcsrwrro1kO3VW4v0hunwZ3s9GGFnJhqbRxhizt2LhfD9qCC+Vy6Drj09ev5VByQEF+ia170ZDflUZprRPBm9hd4h6M2g89JyAAnbL+VI2dPpe0Md6AyFLrF8FBf0JBK+YUsE0ORLPbwGHK/AHt0Uw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=KnDLLYfRtb9uYZyz4L58j6ujXFWZkDehshYhzjpyo3g=;
 b=hkLS/J5xSARjiE5YYyXUBoZWKG4bPserN3UC3s1nZPOL6pKJtqSFlvxF7CLCxVwZnd0/hSHjtyoPtGGf8PA726f4Is7H0wI272BUldV9erlOvaA1u6H93l6JK8GVCd8dtuV7MlEfkTOiedyRqnkhEjw65PMX5uhxhPO86aS6Utgh2GufdYxQED8Xpv2Vwobv811z6+04rukVmg1ioWGyFs8vIY1YndukGNU/LKhPJ36phn7DQ5EIAzZ6FhdnHNICHmbWLoF47rpO8yLLIRrBWr25/OvxYr938+PSl+0AU3rTfCyDiUSaIKktvA1K3P4QHMDbEax9N5/tJLnk7WoKlg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
Received: from MW4PR15MB4410.namprd15.prod.outlook.com (2603:10b6:303:bf::10)
 by CO6PR15MB4194.namprd15.prod.outlook.com (2603:10b6:5:352::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4734.22; Thu, 25 Nov
 2021 23:17:56 +0000
Received: from MW4PR15MB4410.namprd15.prod.outlook.com
 ([fe80::f8de:1089:be1d:7bf]) by MW4PR15MB4410.namprd15.prod.outlook.com
 ([fe80::f8de:1089:be1d:7bf%7]) with mapi id 15.20.4713.025; Thu, 25 Nov 2021
 23:17:56 +0000
Message-ID: <7167e89d-f907-44b0-4e73-da7e3f525417@fb.com>
Date:   Thu, 25 Nov 2021 15:17:53 -0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.3.0
Subject: Re: [PATCH v1 1/3] fs: add parameter use_fpos to iterate_dir function
Content-Language: en-US
To:     Pavel Begunkov <asml.silence@gmail.com>,
        <io-uring@vger.kernel.org>, <linux-fsdevel@vger.kernel.org>
References: <20211123181010.1607630-1-shr@fb.com>
 <20211123181010.1607630-2-shr@fb.com>
 <58998990-ab49-3a9b-522f-27980276f8c3@gmail.com>
From:   Stefan Roesch <shr@fb.com>
In-Reply-To: <58998990-ab49-3a9b-522f-27980276f8c3@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: MW2PR16CA0060.namprd16.prod.outlook.com
 (2603:10b6:907:1::37) To MW4PR15MB4410.namprd15.prod.outlook.com
 (2603:10b6:303:bf::10)
MIME-Version: 1.0
Received: from [IPV6:2620:10d:c085:21c8::10ac] (2620:10d:c090:400::5:4a57) by MW2PR16CA0060.namprd16.prod.outlook.com (2603:10b6:907:1::37) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4734.22 via Frontend Transport; Thu, 25 Nov 2021 23:17:55 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: d74dc5d5-508c-4078-5a06-08d9b069d00c
X-MS-TrafficTypeDiagnostic: CO6PR15MB4194:
X-Microsoft-Antispam-PRVS: <CO6PR15MB4194B9568EF8406EB2C831F4D8629@CO6PR15MB4194.namprd15.prod.outlook.com>
X-FB-Source: Internal
X-MS-Oob-TLC-OOBClassifiers: OLM:2201;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: d/2FLq9sEIyGhghssAFVXWYZBlxpMFZIPzR5bpjMzPUSK3zHpw1kjgImqFg5+lRkke7HETJ/aV5Q2+/QVNXI1vdnbmHkml2BZyXcbhusu+O8Rnk4wJ/qRUx38T7mPVlRhrx6mhCGrx/iMMeZiuOFid+JrOdp0WlyEOk7C0y7CdVekJcUwbhmfeTDNvfrwK0vYIrck9eBos0x6ft7MnlSHObLb6X7Ood00MzLLs69HyqB51Krr3FmJxfYcJgF1ft+ag8wvxRYPZSPio/SXlkTY0sQehhFZ0p4xvJB6WSv7LYCMJwxHLy95DGnG7mpbyaBHMQd8/DNVcbLcuyYQrHWsaRDcsleVzE8YUEv6w7EOBJnQFc8oLUGPd5M7h8Y+7yHkt+KQ37LTmm5RF0lbNpWTUhUAT5el/XCksGyXfYW1THLobE8SWH4bGCGyZXDQZWQ9Zfbkt9zsfFXV98UZl5gZkQGLsMLPdlpz2hukoIK9C7Ixs1QYRtX/3BSvH3uLxvRlZUXbouZkr7mWxtCYwXci/jyWSnmK1wazhkKZ5L0pWDx79ZlGnTfi9vMWd83GlQQVh9E3AVKR5c6CyJOhIRRPJh4qqizcUScB1N6Anw+7WH+dic0d8vAKtSsBVgRC6ztB+cSuQKIxhVR+ZmJStrw6o2ROwPSNpgNYuXVe2dZIEfEToIGZrjCGkFfbq/4+RQ0SZ9S//VZgJ3nTspDQOGehv/PaFQgZH6y9aq5SxDKbN8=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MW4PR15MB4410.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(508600001)(83380400001)(316002)(66946007)(2906002)(86362001)(8676002)(36756003)(31686004)(38100700002)(66476007)(6486002)(66556008)(53546011)(31696002)(5660300002)(8936002)(2616005)(186003)(45980500001)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?V3ZmUndMWThXQXN3Z3FObVovdEJtb1A2TTczTG5XT2NjWjY0cUFIUHBIOThC?=
 =?utf-8?B?eHlXSkJVbktBZDB1KytTUnhPVUdhOXlPVjJ2V3NJVXJVemYxWU5DUXFQeUFa?=
 =?utf-8?B?ZHpZMnZ6ZDhuWDJhRFpFL0FVbEMrVTYzeEJQMCtxU0loVGVTZDNSTkMvL2FW?=
 =?utf-8?B?WmJlOWhybXI2aXArWmdMUVFQMTVtU1hRWjVWUTJXcEg4Y2pwMlBZcjhYeDdG?=
 =?utf-8?B?VkFPTndISmNpeitwZDcwQmJtQWlUdHFQS2p0YzJQK1pqMUtUTm5jS0Rmcy90?=
 =?utf-8?B?cTBnUTdwZjk1NTlpMHFnQXo2dFBqNDIxSStjZW93STBsYUVHczl5SXhzVURT?=
 =?utf-8?B?MFhFbWxNeDFobmFOVHpEOHhxY0drQzQ2aXR0WFdBS3RwVGpsTG0wSFB1SVF5?=
 =?utf-8?B?RytaV0ZnUXk4WmdwbXlWV25DelNOVytHcmNKSVBrVEhuSW5PeTEyT3JoYVA1?=
 =?utf-8?B?WjIzYjhjTjJwYmVtSis2czFORFROYmt5SDZRY3FHYmY5akFZWWJQMmJQZGdJ?=
 =?utf-8?B?T3hhcmJGSmNYOVpBSkVYZlRYeUowVTVWYS80MGhPcURuT2pjWlZuVDEySGhz?=
 =?utf-8?B?L3RqUEk1T0FsYlNGcEpMcnZlU2hKVGhoaTdRRHcxVlVWdkhSRktUN3Iyd09p?=
 =?utf-8?B?bzB0TVJ2T0oxVWdsREhmbDBDVlhNQklmYUFvbDg2d0dDcmNrZnhNSi81dkV5?=
 =?utf-8?B?UmRKcDlMa1RsN2tHQXA5NW53K0QyRUdSM0FkekVEMFVrZmpWaU42QUUxMlN3?=
 =?utf-8?B?QlZNVEprbVE3M2d6NHpWQmNYb2RxNVR1YnVrQ20xeFdoTCtXR1ZLZG9ha3dv?=
 =?utf-8?B?dDl1cFJjem9JVmZXd2V3NnNKR3l3LzY5K3BnOGltVmJXRUZVSVRla3FGUXIy?=
 =?utf-8?B?VmZHdkppbGtaekxXVFVHVVA0OGdVMDR2d0NBcmZ0T3BDZll4NFpZV1p4NU5n?=
 =?utf-8?B?MkdZcitLQmwxSzRRYlVZb05kOGNEdmNkWTM2aWY5bjBNTlcxNzVIVUN6cTlH?=
 =?utf-8?B?dDExbEkxbFpXNGhiR0Z4aG1IWm1wbjRlc3BpT1V4cHB5YXgwS04vM24zamEv?=
 =?utf-8?B?OWJPSkloSVBORzJyMmhRU1pybFJQTytUNGRpbW9BbjRwTmZCQ2tHWmRBMTJw?=
 =?utf-8?B?NCtmcUxoQkNmWGZVYVdTMUJUVVdSbTQ2ZTlWV1JscktwalZBZ0pybmJSbVBP?=
 =?utf-8?B?S0RQU2FZRzQ4aFFIMnB1aEpkWUJTODRiaDVZbHByZUpYYVNRajhiVkNBSDlN?=
 =?utf-8?B?ZDFIUVZWajhTNXNRSGhCRElRb1FEWG9pY0xkb25WM3l6YjF3bHVaQmFpOTlN?=
 =?utf-8?B?WElxMmlJRWsveVcxaitUMTZsZ1lMOU5rUDYrQXRpYUpaTkFWLzdlY2hISXor?=
 =?utf-8?B?RG5TRWxseEJkWDNhMjdDTWNiMjYzTnArM0UxYlpxbWQ4bmF2TlFDcU9UMmNy?=
 =?utf-8?B?Tno2ZkowRmU0eTdFdXM4UWpYWjBzVFJ0QzFiU29Ra1g2NEhRakJjR2xSbFZS?=
 =?utf-8?B?Q2djNEh5dXYyWlZmQmtFKzJWZTBnc2VEeDMyRmNoRTlwQjhZbVNVTjl1Z1ps?=
 =?utf-8?B?ci9BZi90VS9SQlZOTVAyUTNSN2g2bzRlcGwzbTJNd0t3WEVQZllpRHNWeVVB?=
 =?utf-8?B?Q21WVG0xMk1KdXFpWE5KQUpUSE9FVjZxeGZiYkFGcVlPZjJ6VUwwOTJNQnA3?=
 =?utf-8?B?UmNFN1lhUnVmKzBxemJIKzFaK1o4RUh6Y0ZaOUJpMVk3VFNoYllDa1UwMUtO?=
 =?utf-8?B?UXhvMDEwR2dDem1aeXhqQzZuS0NONWFOeVpjclFPTDRleWFORjRjcXdFeUF2?=
 =?utf-8?B?d3dLSEFnclFJdUtjOU5hOEtVcUoyM2QyOVpEbnVISUxIdjZjRitId1JuUmRH?=
 =?utf-8?B?UnhxVk5XbldzbWk2OXU3SFlJaEE1Ylh4YWprMksxdi8vSVNvb24rWWxUamFh?=
 =?utf-8?B?bEtFWFV4NUZVR2RxNUJ4a3Y1RktmeDhpcUZIZWhkQlZhdzFzK2xZWWxWK3Fr?=
 =?utf-8?B?MUZjRmpyY1Q3d1d4dHNoL0JTaWhvVkczdHNrTUN5RGNzWEQ3TnJyajI3S1Bh?=
 =?utf-8?B?eDdqbC9zeE9taGsvRWUwL1lVSFV2MXlMV2pHK01Db1lDTW96Z3NZZ0lrVFlp?=
 =?utf-8?Q?m765eNdULQGKDA9YCuiFumsvs?=
X-MS-Exchange-CrossTenant-Network-Message-Id: d74dc5d5-508c-4078-5a06-08d9b069d00c
X-MS-Exchange-CrossTenant-AuthSource: MW4PR15MB4410.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Nov 2021 23:17:56.0182
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 9zKpHdsVQKGjdh7MJpNCEnHtSXoFSFwReT6Fg6+mMmayS15ejSRMg9sbapDFRLYq
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO6PR15MB4194
X-OriginatorOrg: fb.com
X-Proofpoint-GUID: 86oDQ3TpKvjMidpjj6CAKwYYIgFmTlGC
X-Proofpoint-ORIG-GUID: 86oDQ3TpKvjMidpjj6CAKwYYIgFmTlGC
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.790,Hydra:6.0.425,FMLib:17.0.607.475
 definitions=2021-11-25_07,2021-11-25_02,2020-04-07_01
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 impostorscore=0
 suspectscore=0 malwarescore=0 lowpriorityscore=0 spamscore=0
 priorityscore=1501 phishscore=0 clxscore=1011 bulkscore=0 mlxlogscore=865
 adultscore=0 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2110150000 definitions=main-2111250132
X-FB-Internal: deliver
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org



On 11/25/21 7:47 AM, Pavel Begunkov wrote:
> On 11/23/21 18:10, Stefan Roesch wrote:
>> This adds the use_fpos parameter to the iterate_dir function.
>> If use_fpos is true it uses the file position in the file
>> structure (existing behavior). If use_fpos is false, it uses
>> the pos in the context structure.
> 
> Looks sane, one question below
> 
>>
>> This change is required to support getdents in io_uring.
>>
>> Signed-off-by: Stefan Roesch <shr@fb.com>
>> ---
>>   fs/exportfs/expfs.c    |  2 +-
>>   fs/nfsd/nfs4recover.c  |  2 +-
>>   fs/nfsd/vfs.c          |  2 +-
>>   fs/overlayfs/readdir.c |  6 +++---
>>   fs/readdir.c           | 28 ++++++++++++++++++++--------
>>   include/linux/fs.h     |  2 +-
>>   6 files changed, 27 insertions(+), 15 deletions(-)
>>
> [...]
>> diff --git a/fs/readdir.c b/fs/readdir.c
>> index 09e8ed7d4161..8ea5b5f45a78 100644
>> --- a/fs/readdir.c
>> +++ b/fs/readdir.c
>> @@ -21,6 +21,7 @@
>>   #include <linux/unistd.h>
>>   #include <linux/compat.h>
>>   #include <linux/uaccess.h>
>> +#include "internal.h"
> 
> Don't see this header is used in this patch. Just to be clear,
> it is here only for 2/3, right?
>

This is not needed. It will be removed with the next version (v3)
of the patch.
 
> [...]
> 
