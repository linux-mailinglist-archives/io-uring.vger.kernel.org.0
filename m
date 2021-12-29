Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E6E064816B2
	for <lists+io-uring@lfdr.de>; Wed, 29 Dec 2021 21:35:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230167AbhL2Ufd (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 29 Dec 2021 15:35:33 -0500
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:56324 "EHLO
        mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229767AbhL2Ufc (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 29 Dec 2021 15:35:32 -0500
Received: from pps.filterd (m0109331.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.1.2/8.16.1.2) with ESMTP id 1BTHE4Af011666;
        Wed, 29 Dec 2021 12:35:30 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=facebook;
 bh=JuJvmCl4/prNueG9mzu1m9sblWTAT9cFBOeD9czq2lY=;
 b=lnkzPOitpkbaVu4/SaWLdylvkH+Mjsd4kE8V5Xo1VvijOlu3e9ISCuKyZ1amLir+wV8Z
 c49zoN400u1CXAyDiIbohuIXF46DkPgQzKiy2LRQSd7wC3RjXfa7fWNpOjEj1Y1qKPX+
 cToGQoQPfs8i3cvSnYROo2c4sRVeiKhBM18= 
Received: from mail.thefacebook.com ([163.114.132.120])
        by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 3d81tt0urr-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Wed, 29 Dec 2021 12:35:30 -0800
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (100.104.98.9) by
 o365-in.thefacebook.com (100.104.94.229) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.20; Wed, 29 Dec 2021 12:35:28 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=AJHMNPL3MmrfFTdcTee3O+pyIz9tpFR55oTFaNHmR2RQUmfyk5Nm0JkZwM5iypX35EuqCI2rgk+LFUIVuzj6ngllE8nSHNuEj1J1U9h4n7bc35ei90ag7NQ0NSLTqjJZd1LDqL5yrdG7hBmQXK/baU/3XOCPfxEfpL2XQHeBr9JpOjmXDDO1n4NSijDbfiMpkzyXy8Rxz7ONhtR/I79ynkNaatLPtA+RP/POCGY8EpuLLot7nb6DC1k0X7advorejyfMnE7ZEDr47dxMm1cr0h7j9E8LoQzA/E4lS1LqC7fNPAMjlLxp5dELVzAKHTZGohNoqWQQV9tnWAFD3aDfwQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=JuJvmCl4/prNueG9mzu1m9sblWTAT9cFBOeD9czq2lY=;
 b=hJxdaaz7CUU+GiJrucX0dIgiyie2fH6tjIGGUeSksMBFmTioHrmzwAfEX8U5vzgp6ZazbptaYDaYQE+0Za41cT2IJ4w8BSuRTX19t1P9/6CT/hnt8mQaUOf8DDWWejFE3zUfbR9HPQu/eI2N8gmNXlXSzW/T6hvbOkraLcdEREPHwP8H8z7GCR6rcgLk2MDsVbU6GNGwRAL/6NLk5vx9pY1HomqQz5/SiVX1uSipRBxITnZsIUDZZ/+ISkdYsxMar0++vpp8hTBSXPo68JzlYb3ZF2ZbDmzuZWR+194h6aIbwpr8PjowCuyKTABrE9PbxNjkAGhlv/VhHoUxg1J04g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
Received: from PH0PR15MB4413.namprd15.prod.outlook.com (2603:10b6:510:9f::16)
 by PH0PR15MB4894.namprd15.prod.outlook.com (2603:10b6:510:c2::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4823.19; Wed, 29 Dec
 2021 20:35:27 +0000
Received: from PH0PR15MB4413.namprd15.prod.outlook.com
 ([fe80::31b6:7571:66da:5cab]) by PH0PR15MB4413.namprd15.prod.outlook.com
 ([fe80::31b6:7571:66da:5cab%7]) with mapi id 15.20.4823.023; Wed, 29 Dec 2021
 20:35:27 +0000
Message-ID: <b0b011e9-218c-823e-45f8-90529546ab10@fb.com>
Date:   Wed, 29 Dec 2021 12:35:24 -0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.3.2
Subject: Re: [PATCH v9 4/5] io_uring: add fsetxattr and setxattr support
Content-Language: en-US
To:     Christian Brauner <christian.brauner@ubuntu.com>
CC:     <io-uring@vger.kernel.org>, <linux-fsdevel@vger.kernel.org>,
        <kernel-team@fb.com>, <torvalds@linux-foundation.org>
References: <20211228184145.1131605-1-shr@fb.com>
 <20211228184145.1131605-5-shr@fb.com>
 <20211229145158.ir7h7uii4l46zctu@wittgenstein>
From:   Stefan Roesch <shr@fb.com>
In-Reply-To: <20211229145158.ir7h7uii4l46zctu@wittgenstein>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MW4P223CA0003.NAMP223.PROD.OUTLOOK.COM
 (2603:10b6:303:80::8) To PH0PR15MB4413.namprd15.prod.outlook.com
 (2603:10b6:510:9f::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: d341de93-ed42-4681-9550-08d9cb0abf58
X-MS-TrafficTypeDiagnostic: PH0PR15MB4894:EE_
X-Microsoft-Antispam-PRVS: <PH0PR15MB4894102308282ADC083E3053D8449@PH0PR15MB4894.namprd15.prod.outlook.com>
X-FB-Source: Internal
X-MS-Oob-TLC-OOBClassifiers: OLM:8882;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: LGGPhPujqpq/fr8NEZumx7ANiI8y8EIirWF3fGMBRxVcVkmo/Cbw3E8/GhlD8AH95e2k74Neof/5VkzR/SYKeUG3ygSNYn3OmvPbMaVOnivLgkARUamoUSh5jFvennj9yyYMPmoFXl/DLNa9LEqNa/8YlHfoYuOmgrLkIe+9SVIhQOf/zWFZZRiaMfNbcZUHwAWaFV7OHtXi1o5n1Hd2b4ApiTIhQpN05g7WDtvK/+U1NFSgzD9z4UCqqVAtp0Ij9wZZAkPUOEwTqVYZyCg47KXDnHM4uVTkyoVsgKB8HNaapnV2GSVI5bWn2LIzvvP4ZPwVPcqqdeQjAUZB2WbDMeXptWQyXj2ecEsbIml1mwWe+/c2eh8udCb9Nqdo9HsX45N4h0qP24QZtUrrOPSfmaoM4RM5t9qPxMnPxuQYTXWW4xvat+auoGhxoQdYzVKfvcfZA6XnqSPARx9iXDSipCKFZFlt4mWrA0Uyo6DEVg5TEUmkhwsKxM0F4d4Hgbx1+SO5S4DHiEy+Oerdkpehov/re20Pr3/3n8N7pa032KCcVQUlYjLOLtlYv5mElnXBkTsu/lT4/3ZjZG16hdWJMZ8ZAEjZEfiSB0HlymwFSi+sy82NB8CPC2tai+L876tyH4k37/0+VJHzG0wblj860IDZkupa2tem5c0g359gzV+KExs9pS+6UxIvH72jPMUb8D2n9rqYUQ89QOVMmd5SxOsdlRFSPZ0GdZ4gFOVnsCs=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR15MB4413.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(53546011)(6666004)(6486002)(316002)(8676002)(38100700002)(5660300002)(31696002)(186003)(6916009)(6512007)(86362001)(8936002)(66946007)(6506007)(508600001)(4326008)(31686004)(36756003)(2906002)(83380400001)(2616005)(66556008)(66476007)(45980500001)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?am83dU9LRnFhelA4Q2Fad2NpUG9YZnd4QWloSzMvMnNMWE1rOWdXUkhsS2lN?=
 =?utf-8?B?Q0xoOHEwTUd5UXZlOHZkTDFVVU5OSjU4aDY5UzdmZXhXZjlLbVdUT0RKUVhy?=
 =?utf-8?B?T2VzN1Y4L0tVMS9JdWZja0NRUEV5TEFhK1lxUTVZUlhnRk0vT0ZlVS9pOEk0?=
 =?utf-8?B?QkhtMGJ4SzhtTThpc0pmT3hiT1czeFpqWUQ1b3pmWmJaQjJzanhVWFRtekRM?=
 =?utf-8?B?OFA3Q0llYVRQRTlwREdHT0o2OWZGWFFCS0wrb2dXK0NCczBVbEY0d01tUkMv?=
 =?utf-8?B?V0xXRE05K25UQnk4Sjllb2drOFhTZ2FZT2hYdW5xQzdxS3JQWUxPZlFlSEp1?=
 =?utf-8?B?MkZicGZsWEZqK1FEQldxTUdoTVU4UjVZNnB3ZUJMUVhMOXV5bHdLeDdwYkxG?=
 =?utf-8?B?KzZMVWhDL0NNTFl3QmRObFVSSWkweG1VU1o1R2EvVlh3dHkwTWRkc0VrSjk3?=
 =?utf-8?B?WDJ6ZmRqdDJiOUg5SWV1SU5rY3dFdExsMW1weVlYZGlmKzJWMkJ5bk1LbEdp?=
 =?utf-8?B?aDhURG9aRVRxaGUwOWZIOGFMcUpUNkNpM0V3M1FRY0ZrOEIvajZ6Y2tnV1U2?=
 =?utf-8?B?UU10d0V5VnpGbkJBRENVWTJ5WXdEQUlDbTl3Nit6WjNrRm9zTS82QzNJRjdy?=
 =?utf-8?B?NU44OVB1SUFEZXVoMzR0aE5vZHlwQ0VoSkNDcW9IYkhac3VZQWlsanpkUHJt?=
 =?utf-8?B?ek5RbGVTdHBURXVTMkREYnlIaUM2cWswZjdwb29nNUdVS3JraE9NVFgzSXpS?=
 =?utf-8?B?Y3UxbHVFTEpVUmhNc0dzMG5OUzZxR3lnajExQnBSZEE5cDRpU3R5ZERrQ2RC?=
 =?utf-8?B?UkZ6NTQreU1BcW95VkU5Rjh6Tm1JSysrcnc2ZWx4Z1lHS2ZRcDhvK2YwZE1G?=
 =?utf-8?B?UmhmbWh1cUdHeExjV2lWVzZVK0xVN0VMQXNWcUlkMURJakVaRzNrd2RUWFVN?=
 =?utf-8?B?MGlsNVNuc2VPbUZ1M1JZMmYyaTh1M0Ftdm9lekQyQ2lJUlVBeDJSZmF3YmZy?=
 =?utf-8?B?VEthM1V4a0tCajdDRnFEWWRoTVFhN0FpQlN4L054VmhLRkRSbmlsb2UzNlJi?=
 =?utf-8?B?aldGQ283VXluTGZOajJoRlE1ak1CU2twWE04N1lZUjUvbWVMejJySE1nSFNZ?=
 =?utf-8?B?V0tHbUZWWU1DRkp5eS9LTjNKakxFemF0MFUvUTdMNTVPV1ZoaWljOXUwRm1t?=
 =?utf-8?B?U1pTejdjd2RIazZBTGJpRlljUzFhbjVHdkRSQzUrdGRyTW4zOWVnbHJrQXpH?=
 =?utf-8?B?d1dEdENIclk0dkxDYXYrWENpSDVmeG93RndJNFkzMitsQW8zeEgrUk5TaHJi?=
 =?utf-8?B?SHpSbXV1NnZxdCtTSnpZN3Z2WThoeHRBYUgrQ2dFL3pTaHM3UTZ4OTJaUHNw?=
 =?utf-8?B?K1RaMG1ZaFBDOVVPaGVOSlN2SDZBRG51OEpMTEIxMWpKVW5WSGJNOFFpZzNN?=
 =?utf-8?B?S29IN2RCb0hhTDdrc2FVZ1c4d3V2WThWc0RwMmpnVlVGZHVMbmlrL3FvSnF4?=
 =?utf-8?B?MFFWNEk0NGxvNEJUREhmNUdObUdaenNreWg4ZHJzZHFXclFZTnVVL3ZWMlox?=
 =?utf-8?B?YkdPTmdsUmFDRUJKVHllSWplODFxaGdSd3RPb0lHWkdXdGIvWENHSS9IbU5p?=
 =?utf-8?B?V08xeEpTWU95QkI1bU9PN0xaTnFZc2s1ODgrY2txWi9Melgrd1Z0MnlqYTNI?=
 =?utf-8?B?MmtxVEtnc0JDQjRLUUlQT0UxcmxDUTh5RG1ZTUZLVURNRGJOR2hDMXlNbXdF?=
 =?utf-8?B?MmZLUmlmcXlnWGJQVmNBb1J3Y00yaFgxaEpCazlFTXNnaUZNV0FhYjZYVTRD?=
 =?utf-8?B?V040eUYzTFJrU0w1MnVXZkp5TXF5OTQzRUp0UHZ5N04zanJENUJBT0ZPcEY1?=
 =?utf-8?B?Y2Vnd3I5aElubloyUjJudVROaUwzd2xIRWxzV05nWDgrWjRMRDFtdHRCampx?=
 =?utf-8?B?SXprajlvTFo1TmpDNzAxWlNUNUtvZ1pJZk1nWXBXalJiUTQxVitnR1ljczRL?=
 =?utf-8?B?YTlhclBxSC9kTllYVmsybTZhTEdERGRDWnh0b3lWRmUvQ3BjSGlER243aUlm?=
 =?utf-8?B?NTFnaW11eUQvMDd5ZlFaWU9wV21ja0FhQ1R0dVVhTWlwcFJLTjNPRVdJeHdT?=
 =?utf-8?Q?uUZnSvFhfbxER2RdR8M+kRyAn?=
X-MS-Exchange-CrossTenant-Network-Message-Id: d341de93-ed42-4681-9550-08d9cb0abf58
X-MS-Exchange-CrossTenant-AuthSource: PH0PR15MB4413.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Dec 2021 20:35:27.1094
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: hb2fMWZpBlTvS/waZyuEZBoXV16iIFOmAmYgYY8jYz/3MAo+Lvto/af3VV3BpOys
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR15MB4894
X-OriginatorOrg: fb.com
X-Proofpoint-ORIG-GUID: lZhtscLDICMuY7VYUSqW8W2C3BIFTS0H
X-Proofpoint-GUID: lZhtscLDICMuY7VYUSqW8W2C3BIFTS0H
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.790,Hydra:6.0.425,FMLib:17.11.62.513
 definitions=2021-12-29_06,2021-12-29_01,2021-12-02_01
X-Proofpoint-Spam-Details: rule=fb_outbound_notspam policy=fb_outbound score=0 clxscore=1015
 mlxscore=0 lowpriorityscore=0 suspectscore=0 phishscore=0 impostorscore=0
 malwarescore=0 bulkscore=0 spamscore=0 mlxlogscore=902 priorityscore=1501
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2110150000 definitions=main-2112290111
X-FB-Internal: deliver
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org



On 12/29/21 6:51 AM, Christian Brauner wrote:
> On Tue, Dec 28, 2021 at 10:41:44AM -0800, Stefan Roesch wrote:
>> This adds support to io_uring for the fsetxattr and setxattr API.
>>
>> Signed-off-by: Stefan Roesch <shr@fb.com>
>> ---
>>  fs/io_uring.c                 | 165 ++++++++++++++++++++++++++++++++++
>>  include/uapi/linux/io_uring.h |   6 +-
>>  2 files changed, 170 insertions(+), 1 deletion(-)
>>
>> diff --git a/fs/io_uring.c b/fs/io_uring.c
>> index c8258c784116..2a0138a2876a 100644
>> --- a/fs/io_uring.c
>> +++ b/fs/io_uring.c
>> @@ -82,6 +82,7 @@
>>  #include <linux/audit.h>
>>  #include <linux/security.h>
>>  #include <linux/atomic-ref.h>
>> +#include <linux/xattr.h>
>>  
>>  #define CREATE_TRACE_POINTS
>>  #include <trace/events/io_uring.h>
>> @@ -726,6 +727,12 @@ struct io_async_rw {
>>  	struct wait_page_queue		wpq;
>>  };
>>  
>> +struct io_xattr {
>> +	struct file			*file;
>> +	struct xattr_ctx		ctx;
>> +	struct filename			*filename;
>> +};
>> +
>>  enum {
>>  	REQ_F_FIXED_FILE_BIT	= IOSQE_FIXED_FILE_BIT,
>>  	REQ_F_IO_DRAIN_BIT	= IOSQE_IO_DRAIN_BIT,
>> @@ -866,6 +873,7 @@ struct io_kiocb {
>>  		struct io_symlink	symlink;
>>  		struct io_hardlink	hardlink;
>>  		struct io_getdents	getdents;
>> +		struct io_xattr		xattr;
>>  	};
>>  
>>  	u8				opcode;
>> @@ -1118,6 +1126,10 @@ static const struct io_op_def io_op_defs[] = {
>>  	[IORING_OP_GETDENTS] = {
>>  		.needs_file		= 1,
>>  	},
>> +	[IORING_OP_FSETXATTR] = {
>> +		.needs_file = 1
>> +	},
>> +	[IORING_OP_SETXATTR] = {},
>>  };
>>  
>>  /* requests with any of those set should undergo io_disarm_next() */
>> @@ -3887,6 +3899,140 @@ static int io_renameat(struct io_kiocb *req, unsigned int issue_flags)
>>  	return 0;
>>  }
>>  
>> +static int __io_setxattr_prep(struct io_kiocb *req,
>> +			const struct io_uring_sqe *sqe)
>> +{
>> +	struct io_xattr *ix = &req->xattr;
>> +	const char __user *name;
>> +	int ret;
>> +
>> +	if (unlikely(req->ctx->flags & IORING_SETUP_IOPOLL))
>> +		return -EINVAL;
>> +	if (unlikely(sqe->ioprio))
>> +		return -EINVAL;
>> +	if (unlikely(req->flags & REQ_F_FIXED_FILE))
>> +		return -EBADF;
>> +
>> +	ix->filename = NULL;
>> +	name = u64_to_user_ptr(READ_ONCE(sqe->addr));
>> +	ix->ctx.value = u64_to_user_ptr(READ_ONCE(sqe->addr2));
>> +	ix->ctx.kvalue = NULL;
>> +	ix->ctx.size = READ_ONCE(sqe->len);
>> +	ix->ctx.flags = READ_ONCE(sqe->xattr_flags);
>> +
>> +	ix->ctx.kname = kmalloc(sizeof(*ix->ctx.kname), GFP_KERNEL);
>> +	if (!ix->ctx.kname)
>> +		return -ENOMEM;
>> +
>> +	ret = setxattr_copy(name, &ix->ctx);
>> +	if (ret) {
>> +		kfree(ix->ctx.kname);
>> +		return ret;
>> +	}
>> +
>> +	req->flags |= REQ_F_NEED_CLEANUP;
>> +	return 0;
>> +}
>> +
>> +static int io_setxattr_prep(struct io_kiocb *req,
>> +			const struct io_uring_sqe *sqe)
>> +{
>> +	struct io_xattr *ix = &req->xattr;
>> +	const char __user *path;
>> +	int ret;
>> +
>> +	ret = __io_setxattr_prep(req, sqe);
>> +	if (ret)
>> +		return ret;
>> +
>> +	path = u64_to_user_ptr(READ_ONCE(sqe->addr3));
>> +
>> +	ix->filename = getname_flags(path, LOOKUP_FOLLOW, NULL);
>> +	if (IS_ERR(ix->filename)) {
>> +		ret = PTR_ERR(ix->filename);
>> +		ix->filename = NULL;
>> +	}
>> +
>> +	return ret;
>> +}
>> +
>> +static int io_fsetxattr_prep(struct io_kiocb *req,
>> +			const struct io_uring_sqe *sqe)
>> +{
>> +	return __io_setxattr_prep(req, sqe);
>> +}
>> +
>> +static int __io_setxattr(struct io_kiocb *req, unsigned int issue_flags,
>> +			struct path *path)
>> +{
>> +	struct io_xattr *ix = &req->xattr;
>> +	int ret;
>> +
>> +	ret = mnt_want_write(path->mnt);
>> +	if (!ret) {
>> +		ret = do_setxattr(mnt_user_ns(path->mnt), path->dentry, &ix->ctx);
>> +		mnt_drop_write(path->mnt);
>> +	}
>> +
>> +	return ret;
>> +}
>> +
>> +static int io_fsetxattr(struct io_kiocb *req, unsigned int issue_flags)
>> +{
>> +	struct io_xattr *ix = &req->xattr;
>> +	int ret;
>> +
>> +	if (issue_flags & IO_URING_F_NONBLOCK)
>> +		return -EAGAIN;
>> +
>> +	ret = __io_setxattr(req, issue_flags, &req->file->f_path);
>> +
>> +	req->flags &= ~REQ_F_NEED_CLEANUP;
>> +	kfree(ix->ctx.kname);
>> +
>> +	if (ix->ctx.kvalue)
>> +		kvfree(ix->ctx.kvalue);
>> +	if (ret < 0)
>> +		req_set_fail(req);
>> +
>> +	io_req_complete(req, ret);
>> +	return 0;
>> +}
>> +
>> +static int io_setxattr(struct io_kiocb *req, unsigned int issue_flags)
>> +{
>> +	struct io_xattr *ix = &req->xattr;
>> +	unsigned int lookup_flags = LOOKUP_FOLLOW;
>> +	struct path path;
>> +	int ret;
>> +
>> +	if (issue_flags & IO_URING_F_NONBLOCK)
>> +		return -EAGAIN;
>> +
>> +retry:
>> +	ret = do_user_path_at_empty(AT_FDCWD, ix->filename, lookup_flags, &path);
>> +	if (!ret) {
>> +		ret = __io_setxattr(req, issue_flags, &path);
>> +		path_put(&path);
>> +		if (retry_estale(ret, lookup_flags)) {
>> +			lookup_flags |= LOOKUP_REVAL;
>> +			goto retry;
>> +		}
>> +	}
>> +	putname(ix->filename);
>> +
>> +	req->flags &= ~REQ_F_NEED_CLEANUP;
>> +	kfree(ix->ctx.kname);
>> +
>> +	if (ix->ctx.kvalue)
>> +		kvfree(ix->ctx.kvalue);
>> +	if (ret < 0)
>> +		req_set_fail(req);
>> +
>> +	io_req_complete(req, ret);
>> +	return 0;
>> +}
> 
> (One suggestin below.)
> 
> Looks good,
> Acked-by: Christian Brauner <christian.brauner@ubuntu.com>
> 
> You could minimize the redudancy by implementing a simple helper
> callable from both io_fsetxattr() and io_setxattr() if you think it's
> worth with. So sm like:
> 
> From 2f837aa2a19b5cd8e73fffb9b87b6e6b22c5cae7 Mon Sep 17 00:00:00 2001
> From: Christian Brauner <christian.brauner@ubuntu.com>
> Date: Wed, 29 Dec 2021 15:22:34 +0100
> Subject: [PATCH] UNTESTED
> 

I added the helper function. I made a similar change for the get case.


> ---
>  fs/io_uring.c | 36 +++++++++++++++++-------------------
>  1 file changed, 17 insertions(+), 19 deletions(-)
> 
> diff --git a/fs/io_uring.c b/fs/io_uring.c
> index 7204b8d593e4..c88916b8cccc 100644
> --- a/fs/io_uring.c
> +++ b/fs/io_uring.c
> @@ -4118,6 +4118,21 @@ static int __io_setxattr(struct io_kiocb *req, unsigned int issue_flags,
>  	return ret;
>  }
>  
> +static void __io_setxattr_finish(struct io_kiocb *req, int ret)
> +{
> +	struct xattr_ctx *ctx = &req->xattr.ctx;
> +
> +	req->flags &= ~REQ_F_NEED_CLEANUP;
> +
> +	kfree(ctx->kname);
> +	if (ctx->kvalue)
> +		kvfree(ctx->kvalue);
> +
> +	if (ret < 0)
> +		req_set_fail(req);
> +
> +	io_req_complete(req, ret);
> +}
> +
>  static int io_fsetxattr(struct io_kiocb *req, unsigned int issue_flags)
>  {
>  	struct io_xattr *ix = &req->xattr;
> @@ -4127,16 +4142,7 @@ static int io_fsetxattr(struct io_kiocb *req, unsigned int issue_flags)
>  		return -EAGAIN;
>  
>  	ret = __io_setxattr(req, issue_flags, &req->file->f_path);
> -
> -	req->flags &= ~REQ_F_NEED_CLEANUP;
> -	kfree(ix->ctx.kname);
> -
> -	if (ix->ctx.kvalue)
> -		kvfree(ix->ctx.kvalue);
> -	if (ret < 0)
> -		req_set_fail(req);
> -
> -	io_req_complete(req, ret);
> +	__io_setxattr_finish(req, ret);
>  	return 0;
>  }
>  
> @@ -4162,15 +4168,7 @@ static int io_setxattr(struct io_kiocb *req, unsigned int issue_flags)
>  	}
>  	putname(ix->filename);
>  
> -	req->flags &= ~REQ_F_NEED_CLEANUP;
> -	kfree(ix->ctx.kname);
> -
> -	if (ix->ctx.kvalue)
> -		kvfree(ix->ctx.kvalue);
> -	if (ret < 0)
> -		req_set_fail(req);
> -
> -	io_req_complete(req, ret);
> +	__io_setxattr_finish(req, ret);
>  	return 0;
>  }
>  
> 
