Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 01B0745E348
	for <lists+io-uring@lfdr.de>; Fri, 26 Nov 2021 00:21:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242701AbhKYXYr (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 25 Nov 2021 18:24:47 -0500
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:12960 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1347042AbhKYXWq (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 25 Nov 2021 18:22:46 -0500
Received: from pps.filterd (m0044012.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 1AP8OnnH007829;
        Thu, 25 Nov 2021 15:19:34 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=message-id : date :
 subject : to : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=facebook;
 bh=rzOzxaK4F2/Zb/5eQVp26kbaBr/rBL1ps7X+D2MW/EA=;
 b=OiOGHuObBCQR55ys36Y/f/9dhLUTMfubVkWiW4PLRz3CY8ZNI2EeUgfK8Q+keJC1HnS4
 yCjQvwDXxFGcszxj+GnzCJH/AdrF6UKr9LZpa11xhwbYdD7Wy4GtaYm6t/6pU3q/KrAB
 EMArISFyB7DtLO8XtEVf/CTfduoqqk8SUvs= 
Received: from mail.thefacebook.com ([163.114.132.120])
        by mx0a-00082601.pphosted.com with ESMTP id 3cj6y0v4em-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Thu, 25 Nov 2021 15:19:34 -0800
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (100.104.98.9) by
 o365-in.thefacebook.com (100.104.94.228) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.20; Thu, 25 Nov 2021 15:19:33 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=mOX5aaRi6S+C4wMbm0WZvUjY3L+1LIJg8+4v9ZXwlP8rDBztdhdbnspKWkX5EizYmQWA4VFYpdToQN1awE8ucFRj8jSUU2vqcNx1ZeWJekK5Q/G+/DFzbp2Xw0YK14Hdk7LudYeMIj3+rXviqsS7+/mTbuIM6xEf/7PeeGF/erGtrkCMzAX0aSveBXo/BsMmdlK/3WOThyL7g0D4Ef9IWGcdaZE0AJyAwVTsm1vXjLrrbZw1QS11O9lDISU0VnkeJGiJov3qUVWTU6zaM4guFU9M1pDCJYUJ5tbSn8Ub2CNtGnSN7B7B+WQz02uoetnXvxDohZEv0m5OYKXZpFmkNg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=rzOzxaK4F2/Zb/5eQVp26kbaBr/rBL1ps7X+D2MW/EA=;
 b=hjcCFVUchLT4Txx/OwpZvjqBq9o01sQhSXNjIOSnd3Xfu+VXC65Ozz6X0F1htkzY7tuQ9RlN2vgFSCd86jDAieXbZOM4NDqcr2Z9OAqfZYMATvrCNWISUNss7AsYQsIzNB3FFuySQL7kvnZTAT9WP3Uj6xSpxVmAPrZjsfCdb30mDUfifcfm4tFPplkPSaRPjlfVCS+zXfgbHs/Wep30D+3qZM3/N4Rp9JgNyZ4g0kT8gE8Y8rCYvo7FVG3Z7QMSNd7l5zRhOTaB7bOxn/MadSUctXpmjM+6CTG5ixfQjOKw65xE8B7+2fNvVXf/fyHWFqW+oqirYD52kVJsnDiAXQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
Received: from MW4PR15MB4410.namprd15.prod.outlook.com (2603:10b6:303:bf::10)
 by MWHPR15MB1520.namprd15.prod.outlook.com (2603:10b6:300:bd::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4713.22; Thu, 25 Nov
 2021 23:19:31 +0000
Received: from MW4PR15MB4410.namprd15.prod.outlook.com
 ([fe80::f8de:1089:be1d:7bf]) by MW4PR15MB4410.namprd15.prod.outlook.com
 ([fe80::f8de:1089:be1d:7bf%7]) with mapi id 15.20.4713.025; Thu, 25 Nov 2021
 23:19:31 +0000
Message-ID: <c7eccd90-4688-17bc-83be-5d31f543f40d@fb.com>
Date:   Thu, 25 Nov 2021 15:19:29 -0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.3.0
Subject: Re: [PATCH v1 1/3] fs: add parameter use_fpos to iterate_dir function
Content-Language: en-US
To:     Pavel Begunkov <asml.silence@gmail.com>,
        <io-uring@vger.kernel.org>, <linux-fsdevel@vger.kernel.org>
References: <20211123181010.1607630-1-shr@fb.com>
 <20211123181010.1607630-2-shr@fb.com>
 <a2fd9431-d61c-d222-03cb-dbc481fa1996@gmail.com>
From:   Stefan Roesch <shr@fb.com>
In-Reply-To: <a2fd9431-d61c-d222-03cb-dbc481fa1996@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: MW2PR16CA0061.namprd16.prod.outlook.com
 (2603:10b6:907:1::38) To MW4PR15MB4410.namprd15.prod.outlook.com
 (2603:10b6:303:bf::10)
MIME-Version: 1.0
Received: from [IPV6:2620:10d:c085:21c8::10ac] (2620:10d:c090:400::5:4a57) by MW2PR16CA0061.namprd16.prod.outlook.com (2603:10b6:907:1::38) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4734.20 via Frontend Transport; Thu, 25 Nov 2021 23:19:31 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 8fe70151-60c9-4b8f-028a-08d9b06a08fd
X-MS-TrafficTypeDiagnostic: MWHPR15MB1520:
X-Microsoft-Antispam-PRVS: <MWHPR15MB1520A3373F44DF00C58D0185D8629@MWHPR15MB1520.namprd15.prod.outlook.com>
X-FB-Source: Internal
X-MS-Oob-TLC-OOBClassifiers: OLM:7219;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 5RucUrT6Gkfpt/JBmvxT6wqznoEgkQXIz02BuA1+6DL/RKvJQfq9ZNN0klWCuIGE90JJEhatMEC7uA32BFyifWJBOkwB827ITbq6cPt7rW/S6eZzBr9pHMQggzlo4hoOq1gy0uhabEoFz2A3fRInDFek41WJ0o7fhvTYaYDN9LxIIzWKSasnFN47ha+YZGU9NB6LoJV6O/g5wLpyveDJTBW19Vo59vA+ulFdJEMvaDdKOvXUo+icHiCG8ZNLnmZMg72E2hHHz9HvVppw56md4fqt1wy8QqEQrxYDWyBSFdCDSDLey6pmNPJUXxgdRMiSShiMUUk2fTsVmX/QNxYlRca7Npj+K7YayeYxAByMmjCi/3i0ItbGwr9ElswfbBZOSrTAHbG6gW9x3OKM+MkhDjwdlg9cGpxI+b/Uc5c+G7HY6fLoxi2wg9TcFtXGn1hkf4oDpm3DKlOejFAORWNbE2sJyz2azcPKg+uY57ZvxwWuZaPmm4do7abNBd+XDRHbd+CqsOqP804CoGgH26QxmeLHfPoJqTRDTIwCTofYfloWXOwZsH+FGibJtH87/mVJplaQu5rPFLk3TekSH9Mj7e/OvH614bo/clXfIf7w45LoOaz4Eipc0Ej7hy8LdM1HX3yKTTm0tF7rK5N3tQYEuiOHsRPvLXm7Xyn4b5mm/Owy79kQbxUWzUUn2X0R7hytVUVE553HJwFKGCCIYUZTYxPdMKntNnknFEfEGa2zOXs=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MW4PR15MB4410.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(36756003)(38100700002)(66946007)(316002)(6486002)(2906002)(53546011)(31696002)(508600001)(86362001)(186003)(8936002)(66476007)(66556008)(2616005)(8676002)(83380400001)(31686004)(5660300002)(45980500001)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?ZktxVmhoT3VrVEJMRXRSQ0c1eVdDSFh2WUFjQlhqNkxSRmEwSWc2RFAybk91?=
 =?utf-8?B?RGJQcWxQOEZtOC9hNlRycWxvSG9CSXlZeTJJME91b1hqZmFJL3VHUWJHUlZ6?=
 =?utf-8?B?OUhFZDA5UEJoRWJQU3hvcU4xSGszemRVRE45Q0NoeUYxais0aWgxTTgwbWNa?=
 =?utf-8?B?ZkxzS1BqRDFWazNpOHh3NVlmT05OdnVkK3RGU1A0SnlkVHQxVDRrUG9iaVcr?=
 =?utf-8?B?d2dFYjdFUmUxT01oK0hWMElSNmpGbUtaYm5kejBjZGRmSU9LY1c1S2hGVk1w?=
 =?utf-8?B?cFdnRkRrbTQ0VWVLRmFyajJoZTltN05HeUZ1b3lIem1GWnBjUVMxNVlEbXBS?=
 =?utf-8?B?ZFJYRG5iMVZtU1hLLzFyajdqV0QzcDdMQ0hheHI5Nk1nVTYxZkV1TE1DM2g4?=
 =?utf-8?B?Vkl4MFVGaVIvTUJqMC8xakVNdUZUVnlpUU9remtkbWJPMW5xb1prdlZ1dTdo?=
 =?utf-8?B?ZEwzS2ZTZXBHUlpiOW56NHZUMTRMRytkalBIYjFKc3JMNndXMzhOd2Rob3Jn?=
 =?utf-8?B?d3IydGZNRzBiUTFHem9LcEpiaVVETTZIbWZqZHR0ZHVuZGNmU25va2FDdEwy?=
 =?utf-8?B?eGRHcEVWbU9yUkVSNndPanFpUUJJUDE3bmRWN0ZwVmZYVVVGNXRmN3JNZDhn?=
 =?utf-8?B?c04xOE0wWDhiRm1ERXU3QnNYREtIb25rRlZOcURkWnVKbzJMaC9xZUxxSlVF?=
 =?utf-8?B?eHlOQVZybktadWNCck12TXRveXphcmJETm1URUk1YjRWTDllUzFDZ0ZXTzgw?=
 =?utf-8?B?Q0VHOUZtVzFKcXdPTXhGekc2Q0doeGFrR0Z1VFQ3T2laU2RmZDFOUlU2MXJw?=
 =?utf-8?B?a0J2OU5YVWJVb3NTRS94REVCYnI3ZUZZSFJaR0hKcWlYcW5sVGJtNFEyQTBu?=
 =?utf-8?B?SElDMGVSZE5ibHdhTjArRzl1bW1BZ1RoNitHOFJQODdxb3JnVkRuL0o0QXhD?=
 =?utf-8?B?VmRWdUJneWlyMEdhMXZYeDQzek5xelV5T29NTzJjY3kyNmk3eHNONEVWVDl1?=
 =?utf-8?B?di8rVmJDay9WZFhNcDlXRWZxaFZjM1B4OEtpcjl4aDNRemVaSU8yYTFlaXhM?=
 =?utf-8?B?bHpuNzJwT3NWTFZIOHNiN2Fka0kxdTdxSUU5STJGRm5aTll6Q3c1R3h1dm9W?=
 =?utf-8?B?MDkrY0hPZFBjWmE2bEUyandpakdZZUd4c29MZmlISGNaU25Bc2ZqNnpSV3RV?=
 =?utf-8?B?NndaVkFJVHR5Y0VicGRmUlJCbzJ5d2dEcGdreFluUm5oWEErMUVwamp4cGFk?=
 =?utf-8?B?R2R2blp2cEwyWnM4TmV2RTNaUklJaXZlV0tjVjFxdUszK1l0N3JlYTZuY3Ra?=
 =?utf-8?B?UldDWVY3djN1RWNzZE1renViTThVY0FTWlcvVjhBZFFGYVVhYjNwT1JhQU4z?=
 =?utf-8?B?UU1XWGZUcHZSVCsyNGJuSGVSRWw2WHVPM1ova0RKc09MOUg2UGl2ZTdBZlVH?=
 =?utf-8?B?ZTJjUWU3cVhLaWhMQi9XUzlITEJOdVJZazVuT3JPRy9wRWNCbWlDZDNSNzVl?=
 =?utf-8?B?d2NoRmtFbDh3a0t2M3pIV2V3RFAxdnFZNGZJMHJlZ2VUMmVudGd0c1o2dWhH?=
 =?utf-8?B?V1dWOEE5OURYSmdlWnVKMis2bzNKMkhVZUZndmpWWkNTSTF2TXB6bTc2bnRu?=
 =?utf-8?B?V3hYUDdYOWVSNS9OZGFuTmhydXBwQWhQQkVaSUN4S29LK2JsOFlnZlRCYWIy?=
 =?utf-8?B?a0lkQmxkLytqWFdFYU9CaWNGcG5qUFZjNVhBdTlGSUN4ZGRzREsvRm4zT2Vm?=
 =?utf-8?B?alRXcW9KbE1jaWlhd24ybEpOcjFaeElkT1dvNXd5c3N6MEVNbXhSTk9BSFVi?=
 =?utf-8?B?RTUzdldmT0cxRm1Fa2xidEkxckhHWGJXVU8yMHdlM0dzeGFpQnFlaEIrdkE5?=
 =?utf-8?B?WmYySGk1U0E0U2d3SEZYRTBJNXY3clVsYWdtelc2TlpQSlRnd1RJV3NxL1A0?=
 =?utf-8?B?NVN3T1o3OTBXY3FPZmlPdHNLNmVRN0doRjRzbms3R3pvVnRtUmtMY1ZaNjZ4?=
 =?utf-8?B?SmhaNE5heEFnTUlzbHplblExN0JXQ3ZhOFVLcjBUbldjcUNzYTRTdTY2Qmox?=
 =?utf-8?B?c3dEcmg4YnFxWEF2UFRBdU1ZSVZHN2FtcnhXcG1HeThXTzZNWGVySENKQ2VW?=
 =?utf-8?Q?83tF/mOcwMMy1ENf/NG9Et1gm?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 8fe70151-60c9-4b8f-028a-08d9b06a08fd
X-MS-Exchange-CrossTenant-AuthSource: MW4PR15MB4410.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Nov 2021 23:19:31.4412
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: JqnkYKmHnJhRuT4Ox0nr39AhHS+zWocxSAKUR0D2aJ9mHUsqQf2TfTwAiMs5ApOm
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR15MB1520
X-OriginatorOrg: fb.com
X-Proofpoint-ORIG-GUID: OEyN6IT2SQp6RGdvoCISObflRUZSRdYT
X-Proofpoint-GUID: OEyN6IT2SQp6RGdvoCISObflRUZSRdYT
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.790,Hydra:6.0.425,FMLib:17.0.607.475
 definitions=2021-11-25_07,2021-11-25_02,2020-04-07_01
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 suspectscore=0
 clxscore=1015 bulkscore=0 adultscore=0 lowpriorityscore=0 mlxlogscore=999
 mlxscore=0 priorityscore=1501 phishscore=0 malwarescore=0 spamscore=0
 impostorscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2110150000 definitions=main-2111250132
X-FB-Internal: deliver
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org



On 11/25/21 7:55 AM, Pavel Begunkov wrote:
> On 11/23/21 18:10, Stefan Roesch wrote:
>> This adds the use_fpos parameter to the iterate_dir function.
>> If use_fpos is true it uses the file position in the file
>> structure (existing behavior). If use_fpos is false, it uses
>> the pos in the context structure.
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
>>     #include <asm/unaligned.h>
>>   @@ -36,8 +37,14 @@
>>       unsafe_copy_to_user(dst, src, len, label);        \
>>   } while (0)
>>   -
>> -int iterate_dir(struct file *file, struct dir_context *ctx)
>> +/**
>> + * iterate_dir - iterate over directory
>> + * @file    : pointer to file struct of directory
>> + * @ctx     : pointer to directory ctx structure
>> + * @use_fpos: true : use file offset
>> + *            false: use pos in ctx structure
>> + */
>> +int iterate_dir(struct file *file, struct dir_context *ctx, bool use_fpos)
>>   {
>>       struct inode *inode = file_inode(file);
>>       bool shared = false;
>> @@ -60,12 +67,17 @@ int iterate_dir(struct file *file, struct dir_context *ctx)
>>         res = -ENOENT;
>>       if (!IS_DEADDIR(inode)) {
>> -        ctx->pos = file->f_pos;
>> +        if (use_fpos)
>> +            ctx->pos = file->f_pos;
> 
> One more thing I haven't noticed before, should pos be sanitised
> somehow if passed from the userspace? Do filesystems handle it
> well?
> 

I checked a couple of filesystems and they all check that the pos value is reasonable.

> 
>> +
>>           if (shared)
>>               res = file->f_op->iterate_shared(file, ctx);
>>           else
>>               res = file->f_op->iterate(file, ctx);
>> -        file->f_pos = ctx->pos;
>> +
>> +        if (use_fpos)
>> +            file->f_pos = ctx->pos;
>> +
>>           fsnotify_access(file);
>>           file_accessed(file);
>>       }
> 
> 
