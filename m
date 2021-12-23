Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4059E47E897
	for <lists+io-uring@lfdr.de>; Thu, 23 Dec 2021 21:01:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350192AbhLWUBF (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 23 Dec 2021 15:01:05 -0500
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:52586 "EHLO
        mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1350191AbhLWUBE (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 23 Dec 2021 15:01:04 -0500
Received: from pps.filterd (m0109331.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.1.2/8.16.1.2) with ESMTP id 1BNHwJ7B004405;
        Thu, 23 Dec 2021 12:01:02 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=facebook;
 bh=8DX6lOTbJVD8cqrnjBZutU/+yScTaXJJcWIf/kofuAI=;
 b=nST56IvuP30R+vC8EEoCRdmX51xvo8wxrI/8AahBoofk2Mn+uGQK8hySIbKmnIfW3Oqy
 /ykUKeY2qNAOAC2ZtgVUkmJ+CsqKRc9H3R8gPsb3Vbp1Qry7/kCqds6ugARRGrzgqy1h
 RRut+R7HuJ/X/P5s1SRbs844zuqRSZredI8= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 3d4fnbww82-4
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Thu, 23 Dec 2021 12:01:02 -0800
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (100.104.31.183)
 by o365-in.thefacebook.com (100.104.35.174) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.20; Thu, 23 Dec 2021 12:00:57 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=NZBz6wdHunlp4FwSPQNlOf4WsmOQgyl4/FOHNaJWNarR7s4DBt96kiU5hO3/0AHCF16dlhXQHF89lf2+pZ1dR9niVZkeef2K8j7W7U0yd5XLBQ0aAd1MeiIZJ/0Rupz/VagJ1F6GETDI56/m1bQnFjwQwJ+mBniblpep6sq39FviM6EtNRMBrHLVYkuQhW+GCuFmn14T0eYXGJAA1yYApRCmijJQ1yCA9uRts5WYnuokSkge0+qTfCL5hosXnLxfihN+FFoqIRG5n15nhaldYSm48/mWA/qpSjfeQY8vGBuZv7uhHq3eGXmfOUHR+PEsoQAFj1t8/+tx0MZBJzbOYQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=8DX6lOTbJVD8cqrnjBZutU/+yScTaXJJcWIf/kofuAI=;
 b=ZHcM0lmt23XLkgZPiR/1nlZvIP7yB7KysAgEEu3HnMIrJPTZHH576Zowd9FY7x2Ccyi3qc9QdZBLHXsuEmbHc6dLnGuSji4mR6lr/V8roGDp/byB2XqmpQAYkufMvJDF4ONDdInaWSgk2geMUpJimt/WENHtkusVPsPdCjWoILh9NKCr3bP495P2N37bh+vQHtqt5KkWoP6XTPTgYf9W3x28VH8F6a757YhT+L/Lc89cFsFWA4xsX+ZQtmZEGQMn/6GKDOhEJ3d4lKD3ik4sM7sy56tt46urZzVBGK8Simjv1RUAoiTaXAfWWmpEUJy6AM09krs6XUhZZrXjcA/dOg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
Received: from MW4PR15MB4410.namprd15.prod.outlook.com (2603:10b6:303:bf::10)
 by MW4PR15MB4562.namprd15.prod.outlook.com (2603:10b6:303:107::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4801.20; Thu, 23 Dec
 2021 20:00:56 +0000
Received: from MW4PR15MB4410.namprd15.prod.outlook.com
 ([fe80::989e:71eb:eac8:1f72]) by MW4PR15MB4410.namprd15.prod.outlook.com
 ([fe80::989e:71eb:eac8:1f72%8]) with mapi id 15.20.4823.019; Thu, 23 Dec 2021
 20:00:56 +0000
Message-ID: <7eef0d06-4bc2-0ef3-302b-a1fb1d22bd4a@fb.com>
Date:   Thu, 23 Dec 2021 12:00:53 -0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.3.2
Subject: Re: [PATCH v6 4/5] io_uring: add fsetxattr and setxattr support
Content-Language: en-US
To:     Christian Brauner <christian.brauner@ubuntu.com>
CC:     <io-uring@vger.kernel.org>, <linux-fsdevel@vger.kernel.org>,
        <kernel-team@fb.com>, <torvalds@linux-foundation.org>
References: <20211222210127.958902-1-shr@fb.com>
 <20211222210127.958902-5-shr@fb.com>
 <20211223145201.4jfjt6wv2dxmai5x@wittgenstein>
From:   Stefan Roesch <shr@fb.com>
In-Reply-To: <20211223145201.4jfjt6wv2dxmai5x@wittgenstein>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MW4PR04CA0082.namprd04.prod.outlook.com
 (2603:10b6:303:6b::27) To MW4PR15MB4410.namprd15.prod.outlook.com
 (2603:10b6:303:bf::10)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 1bb485ce-d4a1-47de-0fce-08d9c64eee70
X-MS-TrafficTypeDiagnostic: MW4PR15MB4562:EE_
X-Microsoft-Antispam-PRVS: <MW4PR15MB456240B88F44BAA239DCFE79D87E9@MW4PR15MB4562.namprd15.prod.outlook.com>
X-FB-Source: Internal
X-MS-Oob-TLC-OOBClassifiers: OLM:8273;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Vq2YhF+VIXt1MjQwrJQCa5QsLNkmsYb01WCe5A0a2xycpzdxbtWce8W51pp7C+TlyI2c9lLtvye7PJOm3CsHMf7Vz2ghwkBcJRkEgz2eGV2Ed0JoOR4sSTKKInQtvUuvwcblggQNOyeggLmvhCSIe4Z8ST7HETZ+n2nalp59IHcPfOg/wt4c9TQOQcIuqsE7x4alX0XUjQ/plAtspxWwJxE03y/wGR3zmLuWCOCdc7nHbfXVRZ8Fyhe6HBk7/yDQI2Afn3mujbbUajPnmN/MH4S9wf5zZaiV6WddK+saq4B6TnJrGwj9uoQpPcQyLvtGwUq1zzcFQftvK2ayn+TZA5WlPpWxLLcHWQuHF+n8MQGj788wqyjrTvgFQvKLfhzddRzd+czXdg6qKINuxTz1A/euv7/z6+3Cr/8LDM1SPNSkXwnCkPIfhLdwc2Ng/34il0ocQC/blKH6uGmVS95PP5l9qF1TfNczCFtNbTUFGT+C4SYtXOwd+8yKa0WmFvCb1RsBjh8fyD9NucUvc7n9M0tDMM5mJ6VUuTmBmTXBpxoGo3nKf4/5UMlF12Hjr3wERCZNj81JE5t2M6wyi4zETWL1u/sw1FH3rKgpRldxlu5ngx12sGknXyl3FcDXQo8tNPABcEoBIKUUCONLC2JB2OW1wlERyZEmYoDDCvy2s1J0j/xzCydI4e6tliJOgeAJjUmWGmn3Z9FYrvuEYIxuB1ydJyyJZEIXAPERTD+a0IY=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MW4PR15MB4410.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(8676002)(5660300002)(6486002)(2906002)(53546011)(36756003)(316002)(38100700002)(6512007)(83380400001)(6506007)(2616005)(31696002)(66556008)(6916009)(31686004)(508600001)(66476007)(66946007)(4326008)(8936002)(186003)(86362001)(6666004)(45980500001)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?dExGRm51Wkl3TktmQlQ3QWhnNU9yZnFvcHNNdFhHY2FpMVdTN3dDaXFpS25F?=
 =?utf-8?B?c1VkSUFsdlFqNXpuWms0c1ZtMkhOb2ZJOGM3ZWpYeWw3M2Qvc0RKT0h4NzJH?=
 =?utf-8?B?Q1JzKytzMVFzRkx2N2VUNjJ6aTdMVXArb3AvNk5HcjJPU0pXUXdHdVZreExl?=
 =?utf-8?B?RXZ6Nkphc1p5YjFIbi9wRi94SVF5WlNrc040RHRSaGs3czlpQzh0WXVtUjUr?=
 =?utf-8?B?eHh1YlUwMVRpd09idFlWeWZsTUl1bURnQ0VMTVIyMGIwSDNVbEcwZnV0dlVZ?=
 =?utf-8?B?ZmdMWDhvRGVHNGdoa1JyVkdnUlo3YnhaTjRFOEV6ZDBQcGVNeUk1emhKYzM3?=
 =?utf-8?B?Ti9yV0hnSzBUSEV1MC9WdmMwTU5YbHpEcXB2WWxOSDdza040RlppVzQxREwy?=
 =?utf-8?B?T2pSdXR1L2NqSmJwdEpSWUxFbFRvMjF0bFUvVE5wUWJrWjB1cW5KVHV3Yngz?=
 =?utf-8?B?LzI1SVFqeC9QbEZRdDJJR25wbWJLRkg2MThsTXI4alJtbzRjYTFYc2JRTXBD?=
 =?utf-8?B?MnEraFRmMyt0NlVwRnJWQ2JUdGVmK3c5MExpMUtVWVNtMjFGTkp4M1VwYW4z?=
 =?utf-8?B?ZXBRMzdNME96SWFrcm1JZjhGc2NzcW9sbm5YNnEveVducWtxcUdWK24vZ25j?=
 =?utf-8?B?SWZkczhxdm5zWmdmMnpBTm44MGhTRDF3dUMwVlo2Znk2M0RqRlpzMEpJMFhV?=
 =?utf-8?B?ekp2cXkyVkRaQmVNSW9wemk1L2FDbkxhMXNkL1JYTDNzcUtXWmh5a0hZVWRl?=
 =?utf-8?B?cEN4QTd1Z0NWSkhFeWx5R1ByYVNORTE3L1VKaDRFWHVsUlpyazhjbXcxNFJh?=
 =?utf-8?B?Qk81anE3bGJrSENOcjhLd2tSaDBzSjYyeEtWQ3Jqd2dKbXAzV1JKTG04NDNJ?=
 =?utf-8?B?dFd6Z0IrOWhWQWxzb3BlY2xDWGxzcjFKaTVMOC94WXJOYWVNTlAxV2dROXR6?=
 =?utf-8?B?UXNOY29ucUoycFEvUXRRU3RoNzJoclNRMm85MHpLYS91MjFUYzVYTUREa3Z5?=
 =?utf-8?B?Rk91MThMZ1FoZGRHaGNsNnZTYzlpdldFOExjUXl0d3orQVBNeGhmZlN4U2Ev?=
 =?utf-8?B?MjZjd1JGL015WG1XZkxDZmFXMTNlYXloZW5YMW9aOGU3L20yZHVIN3IxTENn?=
 =?utf-8?B?VEJaYUM5Vlk0a0xJODNvQXVXTnVWekJENHF5akdLVGtJU3gvUi83d0ozaHc1?=
 =?utf-8?B?REh2a0QzaXdESXd3cEJIb2JDdzhLKzlkVXQ4U0RBcGxiMWRHZjdFU1NOVG0x?=
 =?utf-8?B?OC81OEtKSVZmb01SWXdpbjlRUURUWnYxTzhsSGVPN2x2M3NXV3EvdnBDNURJ?=
 =?utf-8?B?NGtZWW1aYUZydWZjdmxHZWQrc3NaRmZIMU9vK2dDNzdtM3dTaTU0RitMVGU0?=
 =?utf-8?B?K2ZPVXhRcTY0c3MwdmU4V0dnczJzRzdwa09CcWZkaVUrYTFNaWRGLy9xZDZZ?=
 =?utf-8?B?VTZ4ZEpsajJ2RHVkL0VwNXpZV2FQSkZXL3lRbUh4SUVuQTJkVklkK1NzY3JN?=
 =?utf-8?B?Slgwdk5tbEpRTEt5VU1JK09SYjJNdmNwMWNIT0FEMUdkRGwvRUo1anRMQ0pE?=
 =?utf-8?B?d1VMM2FmMlllQnpyWjl4WEZCOFVHaC9FVGpSNjhOMWJTUGEzYnVHQTVxTDlL?=
 =?utf-8?B?UTErVitockdXK1QxdG85dnZnTTlRcHZaNDMwL0UyU3A0ejhSRVcvUGtGblpK?=
 =?utf-8?B?VWNJaWZNTHZIY2daK3ROMmY0S2dGYTdyYm1Xdk95enZCNjVBWStDVWh5YW1n?=
 =?utf-8?B?NmRZMDZFZnltYVJETHlVYUVoRmRZUnZQT1F5ZC84bWRSQ3hKVmF2ekVQbXlR?=
 =?utf-8?B?RXBzZkZwS0paMXQ0WE95VEtwQ09zUFVCMFlyMVgzeXRvQW9TRkp2RVJpWGZ4?=
 =?utf-8?B?dHJiUTlDWkhWNFZkY0VnT09uaGszemhid252VG90WHVZazJBRFVwVDBUSG5M?=
 =?utf-8?B?VTZndFpHcmk5SnRBV1d3eTI0YWxCZWs1Yk8xakEwY0Zvdk5NcnhZYnYrTHM5?=
 =?utf-8?B?ZWZOaGlNYlJ0NGM4Tmd0c0k4ZDZOUjdRc1FadVVkRkFEZmh4K0p2MVZnQ2xx?=
 =?utf-8?B?WWFZcXBMaXVIK0ZlYnpYay9yeFFHSjdSZ0pHbmhpc09Mcy82WTZxZloySE05?=
 =?utf-8?Q?vju5l/OjHHiarWWZ8Rs2+IFlq?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 1bb485ce-d4a1-47de-0fce-08d9c64eee70
X-MS-Exchange-CrossTenant-AuthSource: MW4PR15MB4410.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Dec 2021 20:00:56.1268
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 8R2XCNIWNeaFKjc7XW4U9UZo/SyLQBwRge5rRpw+I0emFAO963SqJrdVfdgSL+9f
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW4PR15MB4562
X-OriginatorOrg: fb.com
X-Proofpoint-ORIG-GUID: OAccmW94CHceVnr7Q8lkDtcqfi2AkME5
X-Proofpoint-GUID: OAccmW94CHceVnr7Q8lkDtcqfi2AkME5
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.790,Hydra:6.0.425,FMLib:17.11.62.513
 definitions=2021-12-23_04,2021-12-22_01,2021-12-02_01
X-Proofpoint-Spam-Details: rule=fb_outbound_notspam policy=fb_outbound score=0 lowpriorityscore=0
 spamscore=0 priorityscore=1501 clxscore=1015 impostorscore=0 mlxscore=0
 suspectscore=0 adultscore=0 mlxlogscore=999 bulkscore=0 malwarescore=0
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2110150000 definitions=main-2112230102
X-FB-Internal: deliver
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org



On 12/23/21 6:52 AM, Christian Brauner wrote:
> On Wed, Dec 22, 2021 at 01:01:26PM -0800, Stefan Roesch wrote:
>> This adds support to io_uring for the fsetxattr and setxattr API.
>>
>> Signed-off-by: Stefan Roesch <shr@fb.com>
>> ---
>>  fs/io_uring.c                 | 170 ++++++++++++++++++++++++++++++++++
>>  include/uapi/linux/io_uring.h |   6 +-
>>  2 files changed, 175 insertions(+), 1 deletion(-)
>>
>> diff --git a/fs/io_uring.c b/fs/io_uring.c
>> index c8258c784116..8b6c70d6cacc 100644
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
>> @@ -726,6 +727,13 @@ struct io_async_rw {
>>  	struct wait_page_queue		wpq;
>>  };
>>  
>> +struct io_xattr {
>> +	struct file			*file;
>> +	struct xattr_ctx		ctx;
>> +	void				*value;
>> +	struct filename			*filename;
>> +};
>> +
>>  enum {
>>  	REQ_F_FIXED_FILE_BIT	= IOSQE_FIXED_FILE_BIT,
>>  	REQ_F_IO_DRAIN_BIT	= IOSQE_IO_DRAIN_BIT,
>> @@ -866,6 +874,7 @@ struct io_kiocb {
>>  		struct io_symlink	symlink;
>>  		struct io_hardlink	hardlink;
>>  		struct io_getdents	getdents;
>> +		struct io_xattr		xattr;
>>  	};
>>  
>>  	u8				opcode;
>> @@ -1118,6 +1127,10 @@ static const struct io_op_def io_op_defs[] = {
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
>> @@ -3887,6 +3900,144 @@ static int io_renameat(struct io_kiocb *req, unsigned int issue_flags)
>>  	return 0;
>>  }
>>  
>> +static int __io_setxattr_prep(struct io_kiocb *req,
>> +			const struct io_uring_sqe *sqe,
>> +			struct user_namespace *user_ns)
>> +{
>> +	struct io_xattr *ix = &req->xattr;
>> +	const char __user *name;
>> +	void *ret;
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
>> +	ix->ctx.size = READ_ONCE(sqe->len);
>> +	ix->ctx.flags = READ_ONCE(sqe->xattr_flags);
>> +
>> +	ix->ctx.kname = kmalloc(XATTR_NAME_MAX + 1, GFP_KERNEL);
>> +	if (!ix->ctx.kname)
>> +		return -ENOMEM;
>> +	ix->ctx.kname_sz = XATTR_NAME_MAX + 1;
>> +
>> +	ret = setxattr_setup(user_ns, name, &ix->ctx);
> 
> Looking at this a bit closer, the setxattr_setup() function converts the
> vfs caps prior to vfs_setxattr(). That shouldn't be done there though.
> The conversion should be done when mnt_want_write() is held in
> __io_setxattr() exactly how we do for setxattr()-based calls in
> fs/xattr.c. This will guard against changes of relevant mount properties
> (current or future). It will also allow you to simplify your
> setxattr_setup() function a bit and you don't need to retrieve the
> mount's idmapping until __io_setxattr().
> 
> Right now you're splitting updating the xattrs over the prep and commit
> stage and I worry that in fully async contexts this is easy to miss. So
> I'd rather do it in one place. Since we can't move it all into
> vfs_setxattr() similar to what we did for fscaps because it's used in a
> bunch of contexts where the conversion isn't wanted we should simply
> expose do_setxattr() similar to do_getxattr() you're adding.
> 
> So on top of your current patchset I'd suggest you do something like the
> following (completely untested):
> 


Thanks for your review and the code. I only changed the below code that the
do_setxattr does not use a kvalue, I assume you wanted to use xattr_val.


> From 6bcd3efc3293bb91599ee73272262ac596ab4608 Mon Sep 17 00:00:00 2001
> From: Christian Brauner <christian.brauner@ubuntu.com>
> Date: Thu, 23 Dec 2021 15:23:14 +0100
> Subject: [PATCH] UNTESTED
> 
> ---
>  fs/internal.h |  8 +++++---
>  fs/io_uring.c | 21 +++++++++-----------
>  fs/xattr.c    | 55 ++++++++++++++++++++++++++++++++++-----------------
>  3 files changed, 51 insertions(+), 33 deletions(-)
> 
> diff --git a/fs/internal.h b/fs/internal.h
> index ea0433799dbc..08259fa98b2e 100644
> --- a/fs/internal.h
> +++ b/fs/internal.h
> @@ -222,6 +222,8 @@ ssize_t do_getxattr(struct user_namespace *mnt_userns,
>  		    void __user *value,
>  		    size_t size);
>  
> -void *setxattr_setup(struct user_namespace *mnt_userns,
> -		     const char __user *name,
> -		     struct xattr_ctx *ctx);
> +int do_setxattr(struct user_namespace *mnt_userns, struct dentry *dentry,
> +		struct xattr_ctx *ctx, void *xattr_val);
> +
> +int setxattr_copy(const char __user *name, struct xattr_ctx *ctx,
> +		  void **xattr_val);
> diff --git a/fs/io_uring.c b/fs/io_uring.c
> index 5dd01f19d915..c910c29e1632 100644
> --- a/fs/io_uring.c
> +++ b/fs/io_uring.c
> @@ -4040,12 +4040,11 @@ static int io_getxattr(struct io_kiocb *req, unsigned int issue_flags)
>  }
>  
>  static int __io_setxattr_prep(struct io_kiocb *req,
> -			const struct io_uring_sqe *sqe,
> -			struct user_namespace *user_ns)
> +			const struct io_uring_sqe *sqe)
>  {
>  	struct io_xattr *ix = &req->xattr;
>  	const char __user *name;
> -	void *ret;
> +	int ret;
>  
>  	if (unlikely(req->ctx->flags & IORING_SETUP_IOPOLL))
>  		return -EINVAL;
> @@ -4065,13 +4064,12 @@ static int __io_setxattr_prep(struct io_kiocb *req,
>  		return -ENOMEM;
>  	ix->ctx.kname_sz = XATTR_NAME_MAX + 1;
>  
> -	ret = setxattr_setup(user_ns, name, &ix->ctx);
> -	if (IS_ERR(ret)) {
> +	ret = setxattr_copy(name, &ix->ctx, &ix->value);
> +	if (ret) {
>  		kfree(ix->ctx.kname);
> -		return PTR_ERR(ret);
> +		return ret;
>  	}
>  
> -	ix->value = ret;
>  	req->flags |= REQ_F_NEED_CLEANUP;
>  	return 0;
>  }
> @@ -4083,7 +4081,7 @@ static int io_setxattr_prep(struct io_kiocb *req,
>  	const char __user *path;
>  	int ret;
>  
> -	ret = __io_setxattr_prep(req, sqe, current_user_ns());
> +	ret = __io_setxattr_prep(req, sqe);
>  	if (ret)
>  		return ret;
>  
> @@ -4101,7 +4099,7 @@ static int io_setxattr_prep(struct io_kiocb *req,
>  static int io_fsetxattr_prep(struct io_kiocb *req,
>  			const struct io_uring_sqe *sqe)
>  {
> -	return __io_setxattr_prep(req, sqe, file_mnt_user_ns(req->file));
> +	return __io_setxattr_prep(req, sqe);
>  }
>  
>  static int __io_setxattr(struct io_kiocb *req, unsigned int issue_flags,
> @@ -4112,9 +4110,8 @@ static int __io_setxattr(struct io_kiocb *req, unsigned int issue_flags,
>  
>  	ret = mnt_want_write(path->mnt);
>  	if (!ret) {
> -		ret = vfs_setxattr(mnt_user_ns(path->mnt), path->dentry,
> -				ix->ctx.kname, ix->value, ix->ctx.size,
> -				ix->ctx.flags);
> +		ret = do_setxattr(mnt_user_ns(path->mnt), path->dentry,
> +				  &ix->ctx, ix->value);
>  		mnt_drop_write(path->mnt);
>  	}
>  
> diff --git a/fs/xattr.c b/fs/xattr.c
> index a675c7f0ea0c..03a44c5895d1 100644
> --- a/fs/xattr.c
> +++ b/fs/xattr.c
> @@ -542,40 +542,59 @@ EXPORT_SYMBOL_GPL(vfs_removexattr);
>   * Extended attribute SET operations
>   */
>  
> -void *setxattr_setup(struct user_namespace *mnt_userns, const char __user *name,
> -		struct xattr_ctx *ctx)
> +int setxattr_copy(const char __user *name, struct xattr_ctx *ctx,
> +		  void **xattr_val)
>  {
>  	void *kvalue = NULL;
>  	int error;
>  
>  	if (ctx->flags & ~(XATTR_CREATE|XATTR_REPLACE))
> -		return ERR_PTR(-EINVAL);
> +		return -EINVAL;
>  
>  	error = strncpy_from_user(ctx->kname, name, ctx->kname_sz);
>  	if (error == 0 || error == ctx->kname_sz)
> -		return  ERR_PTR(-ERANGE);
> +		return  -ERANGE;
>  	if (error < 0)
> -		return ERR_PTR(error);
> +		return error;
>  
>  	if (ctx->size) {
>  		if (ctx->size > XATTR_SIZE_MAX)
> -			return ERR_PTR(-E2BIG);
> +			return -E2BIG;
>  
>  		kvalue = kvmalloc(ctx->size, GFP_KERNEL);
>  		if (!kvalue)
> -			return ERR_PTR(-ENOMEM);
> +			return -ENOMEM;
>  
>  		if (copy_from_user(kvalue, ctx->value, ctx->size)) {
>  			kvfree(kvalue);
> -			return ERR_PTR(-EFAULT);
> +			return -EFAULT;
>  		}
> -
> -		if ((strcmp(ctx->kname, XATTR_NAME_POSIX_ACL_ACCESS) == 0) ||
> -		    (strcmp(ctx->kname, XATTR_NAME_POSIX_ACL_DEFAULT) == 0))
> -			posix_acl_fix_xattr_from_user(mnt_userns, kvalue, ctx->size);
>  	}
>  
> -	return kvalue;
> +	*xattr_val = kvalue;
> +	return 0;
> +}
> +
> +static void setxattr_convert(struct user_namespace *mnt_userns,
> +			     struct xattr_ctx *ctx, void *kvalue)
> +{
> +	if (ctx->size &&
> +	    ((strcmp(ctx->kname, XATTR_NAME_POSIX_ACL_ACCESS) == 0) ||
> +	     (strcmp(ctx->kname, XATTR_NAME_POSIX_ACL_DEFAULT) == 0)))
> +		posix_acl_fix_xattr_from_user(mnt_userns, kvalue, ctx->size);
> +}
> +
> +int do_setxattr(struct user_namespace *mnt_userns, struct dentry *dentry,
> +		struct xattr_ctx *ctx, void *xattr_val)
> +{
> +	void *kvalue = NULL;
> +	int error;
> +
> +	setxattr_convert(mnt_userns, ctx, kvalue);
> +	error = vfs_setxattr(mnt_userns, dentry, ctx->kname,
> +			     kvalue, ctx->size, ctx->flags);
> +	kvfree(kvalue);
> +	return error;
>  }
>  
>  static long
> @@ -591,14 +610,14 @@ setxattr(struct user_namespace *mnt_userns, struct dentry *d,
>  		.kname_sz = sizeof(kname),
>  		.flags    = flags,
>  	};
> -	void *kvalue;
> +	void *kvalue = NULL;
>  	int error;
>  
> -	kvalue = setxattr_setup(mnt_userns, name, &ctx);
> -	if (IS_ERR(kvalue))
> -		return PTR_ERR(kvalue);
> +	error = setxattr_copy(name, &ctx, &kvalue);
> +	if (error)
> +		return error;
>  
> -	error = vfs_setxattr(mnt_userns, d, kname, kvalue, size, flags);
> +	error = do_setxattr(mnt_userns, d, &ctx, kvalue);
>  
>  	kvfree(kvalue);
>  	return error;
> 
