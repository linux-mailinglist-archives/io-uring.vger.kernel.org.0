Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 30E38482039
	for <lists+io-uring@lfdr.de>; Thu, 30 Dec 2021 21:18:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242057AbhL3USv (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 30 Dec 2021 15:18:51 -0500
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:63740 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S242062AbhL3USt (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 30 Dec 2021 15:18:49 -0500
Received: from pps.filterd (m0001303.ppops.net [127.0.0.1])
        by m0001303.ppops.net (8.16.1.2/8.16.1.2) with ESMTP id 1BUJg1UJ006335;
        Thu, 30 Dec 2021 12:18:47 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=facebook;
 bh=HoBNnAm1m9jAoz2YwHKGYNm3Qy3+AuSVtzvDkuJWsrI=;
 b=GiTaqGTCmyMxgeDTAZi8nTRhLol0xXhFCBtIPIe1ET7ysPHMNWz9TSDuXzIxCw98P4qv
 /V3V7+am4kGjwl0SexsxN4unh7c/qSeu/IeMLqzUWhAb32onRbaUUh1qnR0Ar4Lb7uEM
 UhOEjSstS/2N5s5izVy5MI7qvoGs0bXiDP4= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by m0001303.ppops.net (PPS) with ESMTPS id 3d9et9aq9v-3
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Thu, 30 Dec 2021 12:18:47 -0800
Received: from NAM02-SN1-obe.outbound.protection.outlook.com (100.104.31.183)
 by o365-in.thefacebook.com (100.104.35.175) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.20; Thu, 30 Dec 2021 12:18:45 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ZTJ+UCFFWrHSUyptG9n0q/yd5ZSbgNCuWhnQo4a05aOvWF4NcYFpbQHpHK2t/GlFKkruXbtP3En7agAmu+UtWwbNo6ADOOcFkA6qJOreT7Zi6YCV8o9Gua5qqUR6RJ7mGQFnLnyi1+iP63wmLtMBHWKFukhkGuY4Z2+0DyIutm1a3K/kY6UE2I25amgcb17+5rO2hKajRRN3FkFyPtGSV6Cd/Dna6kf0G4etbHhklUYCPyBpbZeUQak08ZNXweqwB4ishdVrc20yODqeRNDiQ8t47sbMsWbY+GWE6emGBzHCwEhU3jcgOijKqSK0JE0im5pXrui4D+TvsXNIz7UC1A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=HoBNnAm1m9jAoz2YwHKGYNm3Qy3+AuSVtzvDkuJWsrI=;
 b=IObIhmrD1vSNOaqw1QjKuAq1mFZQ+gsGetstpxREMtViBVwMNJfVzGRmHuT0XEkVWuy68RMG8umhxtNktrroWp4Hnt6ArA0SQd9X3adUGbRxHsQg8aRn9Tysczy56Gq5Jt8QpzuWZklkb4SlM5bPCPn7XEWNrsUUJj6V7ji/rUNp4xTNGiaKj/HTftDJgbKSAn7xBFAhkJ+cWJ1XC9jZjhZYVPms2qQ5SOKsGf/3iKKrdDw1HIBpWrSjOaZb8G46gSPj24kXc1N7GsGDgtoKFCv2gLYQKpC7KePhmUOZK6a1hgSESeewzhIPTEIm+sGK4oZ/SEeCXqOy4AyPlD9pHg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
Received: from PH0PR15MB4413.namprd15.prod.outlook.com (2603:10b6:510:9f::16)
 by PH0PR15MB4783.namprd15.prod.outlook.com (2603:10b6:510:8d::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4823.19; Thu, 30 Dec
 2021 20:18:43 +0000
Received: from PH0PR15MB4413.namprd15.prod.outlook.com
 ([fe80::31b6:7571:66da:5cab]) by PH0PR15MB4413.namprd15.prod.outlook.com
 ([fe80::31b6:7571:66da:5cab%7]) with mapi id 15.20.4823.023; Thu, 30 Dec 2021
 20:18:43 +0000
Message-ID: <e5283ab6-545f-471c-69d2-aeffa3ffe182@fb.com>
Date:   Thu, 30 Dec 2021 12:18:39 -0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.4.1
Subject: Re: [PATCH v10 4/5] io_uring: add fsetxattr and setxattr support
Content-Language: en-US
To:     Al Viro <viro@zeniv.linux.org.uk>
CC:     <io-uring@vger.kernel.org>, <linux-fsdevel@vger.kernel.org>,
        <kernel-team@fb.com>, <torvalds@linux-foundation.org>,
        <christian.brauner@ubuntu.com>
References: <20211229203002.4110839-1-shr@fb.com>
 <20211229203002.4110839-5-shr@fb.com>
 <Yc0Ws8LevbWc+N1q@zeniv-ca.linux.org.uk>
From:   Stefan Roesch <shr@fb.com>
In-Reply-To: <Yc0Ws8LevbWc+N1q@zeniv-ca.linux.org.uk>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MW3PR06CA0007.namprd06.prod.outlook.com
 (2603:10b6:303:2a::12) To PH0PR15MB4413.namprd15.prod.outlook.com
 (2603:10b6:510:9f::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 747c32ba-e4b4-4ad9-6061-08d9cbd19376
X-MS-TrafficTypeDiagnostic: PH0PR15MB4783:EE_
X-Microsoft-Antispam-PRVS: <PH0PR15MB4783B967330B778EDF86FD7BD8459@PH0PR15MB4783.namprd15.prod.outlook.com>
X-FB-Source: Internal
X-MS-Oob-TLC-OOBClassifiers: OLM:8882;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: l5sRQqRlQlVd4LeynHEfUKbKiwq8frXeUgBuq40URs2uT2CK+j184Bm0w1l3vkl5OIGRto9phXQPq/7466ECeCXKtGy2WxHmyilNDXlK3qEa/jlzXErbkFJ3IWWQ3LXwSyZmk2m/izNlENySJEvoAPVj1ed+g2LYEC8Y+kj+X+NleTKJ59uriPJYaaByEcXe5qZbVD9cS5INDxovbqeSS1ynOQ63pgK7777HvscGSFscXmnYdF4zmgNgC4m0840rrpcV8KFztROHxq3yPj/s3zUddLY2Q8Vxvbuvt/Wu5Ksbd4k9az9gva/uLnLv1npwg65Ps0cF7XXrlgf2k40MOrQCFY9bn7E2icmLPoJ7e0j1Kw85iIB/3lftHvGtfCq/G9ApFS6UFFvtNmM2keGRIzLqE9hVOKG+u+LRI3bJw0rNB5snnm7826eDwM9DxSIEVBB/IAsK6Bf/rk0LlzAv18Sslr5wkws/QdLfJ5iG0W53ArF6hThf9atwyUavWnjKzabvJJVVLvUw3EqlTkt5Q2Rjx5gLmRifkph6gZBp+YGLYE/z9it3Hva/W+j7nL57ifRKn3FX0c8ppqB8KJVgS0ouhrIVKsIoDC4IYP8oIwKBhdKFGWvHhva+gAVjzXy7ds72xnn2vqMlIBLD7bXlypKUZyuYy4tODk12HCQAMaiat4n9LhATaZF2IhfXmKewiihwwZZ+DULT/qJnKK3dwtMzX13cMUsa66ClF1Y8m1Y=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR15MB4413.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(5660300002)(31696002)(66946007)(2616005)(6512007)(36756003)(186003)(508600001)(66476007)(31686004)(4326008)(66556008)(6486002)(8676002)(8936002)(83380400001)(86362001)(38100700002)(53546011)(6666004)(6916009)(6506007)(316002)(2906002)(43740500002)(45980500001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?MVNEVnErZDR0R2VCMGwxcVZCR0xFQytSVVl2bmhzZXUzWHBmOXJyd281YXR1?=
 =?utf-8?B?WVNqckVLS1NGU2VjM0d2UTlYRkVaN2xHVThNeXY3azdXVGpvaTRUZ21GY3dJ?=
 =?utf-8?B?YzdNMHBMSFFhV2dNNFNUZzNVSzY2Q2xGZTg2NjVHVi81WVlFNnM4eXJldGhV?=
 =?utf-8?B?UXJvMmRraVluT0J0ZTFPalFHRURudmExYmV2eCtsZGNLN1J1UDA2Ly93aWNQ?=
 =?utf-8?B?UmQyWS9GYVI3ZFE3TlBQcE5vUVYzdlo3d1BxR3FpakVlN0hBNG5DZzh4THMr?=
 =?utf-8?B?eDJCaU8wdk5WK3IzdXFHaStuN3FQVE9vVFEzSXZoSDE5Rjl4VEJXQlFoNk1B?=
 =?utf-8?B?Y0FwV1pjYzBJME5OODQrRSttajhaeEVSTW9la1VjQzVVT1M4YTZFVDUvRm1L?=
 =?utf-8?B?MkpEMUNBMllvazVPTzMzdHB3M1JKOWhhNmRTZTJObDJyb1VUbmJ6eHNXQzFL?=
 =?utf-8?B?UElyZWl1NURYZXJraURvcXBveFFVOUt3ancwOU9RYnZKNnVsRVFERUdTZlpF?=
 =?utf-8?B?SU5WSFh5MW4wNVE5bmpxMGlEcEg3a2s2NkY5aDRnME40QTU0N0ZFK3lIVTkv?=
 =?utf-8?B?bFpkeHlBd3dvVGRjYStDZlZBc1JPcTE0NTk2TzF6OXd2WXRQUG1GUU9NUGhQ?=
 =?utf-8?B?K0RwbjFwTllGdGtSd0huSzcyL1Z6YzdzYlpHTTMzMmtJN3oyMGhsMGpmOWVV?=
 =?utf-8?B?Wkg0STd6NDJkdjZ6UlJIejVoS2lqb1JRckxiVUk3V0pkVEpsTGt6WU55bDBR?=
 =?utf-8?B?TGlsQk1KZ1IwQVVpM2tZVUlkL2VyaWZrMWQzRkFEa1FUMEt0dzNMWnRySmhz?=
 =?utf-8?B?alRWdWMzejhvY1M4aEIyazRWUTZvaitZSnhYVWtOUG1nQmc1aXltYVRDSjh0?=
 =?utf-8?B?WmREalVWVEZSeEwxMjlOVW1EdGxEWSszRHp5KzdSMU8wQ3NmNjFubjNDWGpt?=
 =?utf-8?B?bVVsVlc5c01ubkpNeTduZk5FZVZ5czFxY3ZsVUVPVWJTOHZzTmNQQVF0SGNQ?=
 =?utf-8?B?b0I3N3V6U2tJa0J1NWZSMFE3NEZKYUpQYUF6aG5jbmFpb2kzSVpCNnpGRFhN?=
 =?utf-8?B?OStqZnZNRHQ1NXAzT25wdXZnSmdCdlNRRjJaeHZ6WC93bGdVbUNjVnFrL0Z0?=
 =?utf-8?B?VzAwekhmK0hKaDhTS3NHcTNXMzFlVVlSSVFpblNYZDkzK0JqYVJUSG41cjdM?=
 =?utf-8?B?LzdVZFFFc05MSkEwKzVHMDhCZkl2RGZlWVMxM2d6OUUwdERyUS9wb2htaU5V?=
 =?utf-8?B?Nk9DeGNjUFRuQmlqdDlCOW8xdHd6eXB2ZzN0K1VrZmU4VUNrSlFRSFdrYTlp?=
 =?utf-8?B?b3k5R0lqeEh4SUF1dnMxMTB5S2g1M1FZUjkzSDE4ZDc5b21TRi8wTWcxQ1RE?=
 =?utf-8?B?VDRyN2VydEMyaElRYzkwRXZ1TEtiZ0xIUFlVYVFLZnE0ZkMzNUtld1JOaWEy?=
 =?utf-8?B?SG5UaWd5bzRFUklmYnpsRHptbnJtb1lzY3VtR1loellOQStsRFJEYnlkenp2?=
 =?utf-8?B?UWFBMWp1cmFUcXB6WUZFR0g4QU5WWGNUNFVmOGtYdVhWQkp6SHo1ZmRWNk5D?=
 =?utf-8?B?ZTdIUHh1ZzhuU1RveFVKQWZJYUxlc1l2Z2svZjVUc2lrSHNxdlEwOXRJNWMr?=
 =?utf-8?B?SlFleXd2eWFrV2VXbEpqT3RuR09ieVRmOXEyOWJ4VmdaaWRRZ2p6N3pMMzB4?=
 =?utf-8?B?V0U3TVE5RldWVVY4VE85SkVML0dxcUltYXE1dlFmQXdwYzdWWjQvY0RxRUhF?=
 =?utf-8?B?L1dUdnQxY1RTQ2l0bnNvUkVJWWFxZWpQZHBkYWc1SEREOXd3Mm54b2xwNlg2?=
 =?utf-8?B?azJCczNGcUlCVnYyUHE5Q0hUQWZDNjVyOWNsSlF4Tzk0VUZZWWNjVUoybmM3?=
 =?utf-8?B?cnQ5eDFhU3owR1FjMTJIUzNpRmRzbFFqSFB6SEJoVDFQTTRRbGJwZHhxRHU3?=
 =?utf-8?B?dWN6VTlsbWFTMjhUQjVOblpHL1lGblV4bVJ5M2dvNHBxRU1ab04zT3NtTVNs?=
 =?utf-8?B?TXBUTUtBY256c0k1RFl1OExFclIrNWhaSFJ4TUwremJxNEhNNGdnQ2lSR2tP?=
 =?utf-8?B?N1RWNTk3MXZqQTRGQWRTSzd2NnJqYXFISlFuQ1phV3dLSGNVUlFSSUhXN2N6?=
 =?utf-8?Q?GorfXuFqaZUsq/9ZLWmTpkK5V?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 747c32ba-e4b4-4ad9-6061-08d9cbd19376
X-MS-Exchange-CrossTenant-AuthSource: PH0PR15MB4413.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Dec 2021 20:18:43.3653
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Oy+6y0DZpASB0Q7Xh3w8tOcq5oZ1RfSyABFZEcxWWxZYWhX9hIGzqw+OTBBv/9Ev
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR15MB4783
X-OriginatorOrg: fb.com
X-Proofpoint-GUID: YFwd5iz_8e0F4e7GH91C0s4TdrHx2ZsB
X-Proofpoint-ORIG-GUID: YFwd5iz_8e0F4e7GH91C0s4TdrHx2ZsB
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.790,Hydra:6.0.425,FMLib:17.11.62.513
 definitions=2021-12-30_08,2021-12-30_02,2021-12-02_01
X-Proofpoint-Spam-Details: rule=fb_outbound_notspam policy=fb_outbound score=0 priorityscore=1501
 bulkscore=0 mlxscore=0 spamscore=0 mlxlogscore=999 malwarescore=0
 lowpriorityscore=0 adultscore=0 impostorscore=0 suspectscore=0
 phishscore=0 clxscore=1015 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2110150000 definitions=main-2112300115
X-FB-Internal: deliver
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org



On 12/29/21 6:17 PM, Al Viro wrote:
> On Wed, Dec 29, 2021 at 12:30:01PM -0800, Stefan Roesch wrote:
> 
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
> 
> OK, so you
> 	* allocate a buffer for xattr name
> 	* have setxattr_copy() copy the name in *and* memdup the contents
> 	* on failure, you have the buffer for xattr name freed and return
> an error.  memdup'ed stuff is left for cleanup, presumably.
> 
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
> 
> ... and here you use it and bring the pathname in.  Should the latter
> step fail, you restore ->filename to NULL and return an error.
> 
> Could you explain what kind of magic could allow the caller to tell
> whether ix->ctx.kname needs to be freed on error?  I don't see any way
> that could possibly work...

At the end of the function __io_setxattr_prep() we set the flag REQ_F_NEED_CLEANUP.

If the processing fails for some reason, the cleanup code in io_clean_op() gets called
and the data structures get de-allocated.

In case the request is processed successfully, the memory gets de-allocated in io_setxattr()
and io_fsetxattr() with the helper function __io_setxattr_finish(). The helper function clears
the flag REQ_F_NEED_CLEANUP, so clean up is not necessary.

This is the general pattern of cleanup in io-uring.

I can certainly add a cleanup function, that is called in all 3 cases:
- io_setxattr,
- io_fsetxattr
- io_clean_op







