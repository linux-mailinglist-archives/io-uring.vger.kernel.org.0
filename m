Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8883445615E
	for <lists+io-uring@lfdr.de>; Thu, 18 Nov 2021 18:22:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234073AbhKRRZ2 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 18 Nov 2021 12:25:28 -0500
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:33264 "EHLO
        mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231740AbhKRRZ1 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 18 Nov 2021 12:25:27 -0500
Received: from pps.filterd (m0148460.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 1AI7B3Fc019337;
        Thu, 18 Nov 2021 09:22:05 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=facebook;
 bh=famYqlMML8/oEaDWwBGY/tp8DXgcfxLJV83/yRr0+l8=;
 b=RTA+N11g+NBKrP568QOomh3YA9mBbKBgSqCZm1ENmSwY1sm7KigDvLRznlaIpix5Sdfe
 BxBdHRIxmZfJolsjpRaRcitMs5W3swZWKnThTXbk5E/1qNcXhpnR0fYxe4uOpe0p+wl7
 yO/1KOAmFtcPjWB4Y0pffaxMX5OStmbYcag= 
Received: from mail.thefacebook.com ([163.114.132.120])
        by mx0a-00082601.pphosted.com with ESMTP id 3cdj6ykx4b-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Thu, 18 Nov 2021 09:22:04 -0800
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (100.104.98.9) by
 o365-in.thefacebook.com (100.104.94.196) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.14; Thu, 18 Nov 2021 09:22:03 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=crEh4rkpYWreS1xsG6RPIY4TTu7wNQaJg6U1RrOL7cDHFaV/fnPiQlwBCEXMV/rslZo96PuXvDtpADIUFPy05UO/cqv96+qPKLUKmmCYye6oik0J1NZnnW1GE3f7/bsYLaA9qVpH9/dDEhRj/UAQWNXANL/CMnjczAzdU5jtcLqpbrEYsGcp6RYntsOuuQC2mnDxxQkFKL64vAXVBIz8LUvGNNbjCY3qDFOD/IYkI1i027KZyKt+r8Anati56bXrSnU3CZQSpqy1QRl0MMc7VCI//r6b9iT7ZLLets7oH/w20EQxo0oNPqQvW0Wmlu8DuvlrJs9x+Ad+Eq4ZLHCd9Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=famYqlMML8/oEaDWwBGY/tp8DXgcfxLJV83/yRr0+l8=;
 b=miuInoaElGjdu/+Xu9I3i/VmfgyNQgt2gA4xHUgGplUpJ58feYkull89kHD2P24LFEzHz/n/3A9Xp2jB3HwZwWQ6jZFrH2Ntql3nQGZHS2KooOaCvr1bvkDq8bfDwH8ngfJHOd65r4gAwIJhiTTR4ji3sfXXbDjQnoEdNzr9P+zTzlW6jO+JIRIoAuhjQjOxfHXe+P+aBMmQZyyCdXMcSd/z3PFXw1U5NIuXqxn1Lwm0kBtzr7MSJMl3kM5wLD0hmGA8GQkDIDS4eNY6zEAZQrVd7Q5OPT6Fq88QuSwUD/pjm/xy3Cb39EMiy2sNmY3WwfSRJw8IX3W1xpzGVQsN1g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
Received: from SN6PR1501MB2064.namprd15.prod.outlook.com (2603:10b6:805:d::27)
 by SA1PR15MB4808.namprd15.prod.outlook.com (2603:10b6:806:1e3::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4690.27; Thu, 18 Nov
 2021 17:22:02 +0000
Received: from SN6PR1501MB2064.namprd15.prod.outlook.com
 ([fe80::a91b:fba1:b79c:812c]) by SN6PR1501MB2064.namprd15.prod.outlook.com
 ([fe80::a91b:fba1:b79c:812c%5]) with mapi id 15.20.4690.029; Thu, 18 Nov 2021
 17:22:02 +0000
Message-ID: <8d95bd01-7f1a-9350-cede-c6abd56a7927@fb.com>
Date:   Thu, 18 Nov 2021 09:21:59 -0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.3.0
Subject: Re: [PATCH bpf-next v1 1/8] io_uring: Implement eBPF iterator for
 registered buffers
Content-Language: en-US
To:     Kumar Kartikeya Dwivedi <memxor@gmail.com>, <bpf@vger.kernel.org>
CC:     Jens Axboe <axboe@kernel.dk>,
        Pavel Begunkov <asml.silence@gmail.com>,
        <io-uring@vger.kernel.org>, Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Pavel Emelyanov <ovzxemul@gmail.com>,
        Alexander Mihalicyn <alexander@mihalicyn.com>,
        Andrei Vagin <avagin@gmail.com>, <criu@openvz.org>,
        <linux-fsdevel@vger.kernel.org>
References: <20211116054237.100814-1-memxor@gmail.com>
 <20211116054237.100814-2-memxor@gmail.com>
From:   Yonghong Song <yhs@fb.com>
In-Reply-To: <20211116054237.100814-2-memxor@gmail.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MWHPR17CA0073.namprd17.prod.outlook.com
 (2603:10b6:300:c2::11) To SN6PR1501MB2064.namprd15.prod.outlook.com
 (2603:10b6:805:d::27)
MIME-Version: 1.0
Received: from [IPV6:2620:10d:c085:21e1::1798] (2620:10d:c090:400::5:184a) by MWHPR17CA0073.namprd17.prod.outlook.com (2603:10b6:300:c2::11) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4713.19 via Frontend Transport; Thu, 18 Nov 2021 17:22:01 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 931f59e5-ac58-4613-b28c-08d9aab7ef73
X-MS-TrafficTypeDiagnostic: SA1PR15MB4808:
X-Microsoft-Antispam-PRVS: <SA1PR15MB480834734D8109365911772ED39B9@SA1PR15MB4808.namprd15.prod.outlook.com>
X-FB-Source: Internal
X-MS-Oob-TLC-OOBClassifiers: OLM:10000;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 0ZXmktSE8f9HUSmQpQ54+WmADnQ11XuflanY1b5LlmRKk0cMORx3ahWW2Ac11JvkE+qP7oTW3zTLoCrpexmP88QytAlLx0gvw2e07girpRiHNk3ULbulXXnRCbWcPVxJSdLlhJqRaq4kVEqXTCPb2HByxkZilR14RUlk8Jak2zASyLbiEDbEF5uNZN3afwq1Tn04sqc5ubVJQoIK/wxlP2iuQW6Oidf/7ijLwQiEcL8WhDQuu+/0Nlhr+05c8Nd1RmFMhYPzsktFPwd6C16gIL2PjGSkjmt/W71QV1XtBHSx2ZIj10cGwjDqMA2Mf9Iz7zTPcT+kpn6/bSG6mJpRPzo69hsIHUrDm2T3WB+mihztiPGALbMW2feoGeuaQZI0YZ4ENH0OcqGjF3Mi6cuEt8YSzZxt4UwAJfqHtwf+9pJXr/WVXNuGZUqJan48l+FgV01hKO6Z3faVLzOulbW+cjAo90AnrviJdIhStzhVOpR5l8K9W52t0+Nbdb4JOEMPxVcalfH5+z+muWj+o7DgibOxXCspBItvrWo7imiy5fjR0g9om0nNQzEq0aLlvofKReo4yDwA61pvyAC/l/CxiLx+Y4iLDujqiUbG7YbqgYlYrt1vVnUBZntEF+05q3RLgCsYbDxSdg68S2BU1ISSU6PvgB3e56xF8RSykX8vUuYYG9TPqQQIroqNQ/4YpWNWkona+9QJ5KxvS8Iebr4/r/Z/0nBv/YtllnLIT6zC6/jTBUkrG0uumgR3K3zu6xlc7MATpuWIeVOAUc1cQUpehA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR1501MB2064.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(31686004)(66946007)(54906003)(186003)(52116002)(5660300002)(4326008)(316002)(36756003)(66476007)(2616005)(6486002)(66556008)(2906002)(8676002)(31696002)(508600001)(7416002)(83380400001)(8936002)(38100700002)(53546011)(86362001)(43860200002)(45980500001)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?d0h4Qlk2bDFoWHA1MU51eHpwL1lEV2tIQ3c2ZzQrSjlJK3dVWGJLdXRYcGN0?=
 =?utf-8?B?R2xMNFdXdDVKYzZYdkZSNnNsWDlaTTg4MUhXVzdDa2R3SFIyQjVGaTdsMi92?=
 =?utf-8?B?dDhzeWJybVpwVU9MTDdNYjNOUkxLb3gwM2NmelBsRExxcWcyNldvSXd4elQy?=
 =?utf-8?B?TVpMN1kvSHhBLzY1QXpkbEdYSHZGcmdxZ2hsTFFUSVhmZURISmErMjNodEw0?=
 =?utf-8?B?dmlJUkZwb3BNRzVFVlBua0hGbURzOWc0SkdIL2pQNVBDRFZ0NDViNVlKeC9q?=
 =?utf-8?B?ZjR4a2JtRnZuQTBuOCs4dXcvYXZUZGszK0Q4Wm9uN0dhZjA0RWdqV0MyUzNv?=
 =?utf-8?B?R0dTbHU5UXdOZm5uaHRLcGNZekoyT2xLdlVHSWQ5TWNXbEtURFo3cCtSandk?=
 =?utf-8?B?VmplM1FxUk0ySEtrZGhEYXFiYTJXQlNZb0Y5TWNRZ1U4MzMxSTBQQitVbUcy?=
 =?utf-8?B?MkN1NmJ3VEtCM0U1RU5SN1hXaGhjemo0dTdJZDNvaENwNDhiRVVlRk9OMXNj?=
 =?utf-8?B?RCtTNXF4UzdMWjE4amNJMzNKbnNZK1BUT1pFVDlxRzBjL1laV1Jsd1JqdVYr?=
 =?utf-8?B?RVBwV1VocWZuYUJia01oaWZXOUpuSUV3TzZVUW16eFdNSmxMTnJlUmdCSGE0?=
 =?utf-8?B?ZGpSMFFwOWxPUWt2L2pOeEVXdGtWa3Y3N2MxaGZsYW40ZzFGNlhQK1dNc045?=
 =?utf-8?B?RVppOTlOdnJveTdhSlFIdmh2WGRTTjFxN3paaW9ZWnV6c01oY1k2NDFDWlB3?=
 =?utf-8?B?dXdONDJPVUFhZkVteDJINXcraWFoK3lzOGhDeEFqcjJiZzIxUzltM3c3TTNT?=
 =?utf-8?B?c0huTGRmVjI5anJoT2xtaXhXcGRSelNSYzZ5cE8vWWp6d3F1NEFGU2ZSa3U5?=
 =?utf-8?B?Wmh6cldJa3AzQmVyZ0sybkw4am4rVGlSS3R3ZERKdUM0TGVERHZkRE53S3ky?=
 =?utf-8?B?MU10YkVUM1lPcG5BcmVvOHJ0NHBZZVNjNll0QVVLaGgxQkZkb1owWjBPYzc1?=
 =?utf-8?B?bEt0alJyU2ZrQkZUWW14UEl3VmhyTTJXc2FLNEdsV0d4a0FibytoTXA5TjBT?=
 =?utf-8?B?K3B2VENJU0Y4bnQxRFYzdkZCcUhKNHg1UUN0dnlZeDQ2NXZvNm9hRWhBZFR2?=
 =?utf-8?B?SEVYVkl6N0x2c09Ralc1L2dkSjBmcExTdWRBeU9pVHFmUVNYZFNPTmwwaGZx?=
 =?utf-8?B?OU1EaEoxZUd0bmpKZTU0aVBSRW1CYVVxTW5DL3ZGUmgyT1NLckNkNmxrYWww?=
 =?utf-8?B?QU03REpmZG9PUkZmUlBkVm5ndWhHQjhiOXBaV0NVQThONGt1VTJtY3FpcVlV?=
 =?utf-8?B?TVRmMks5MFFGYlRFNHdVcGJ3L0ZWZ1dHQlZwN2FBdm9iUUZEeDVuTERUWStZ?=
 =?utf-8?B?a1I2dDlEc3MvdlRPSkltNnp4Rmc5SjFBTVVGUS9BeURaU04zU3crUUpydzN0?=
 =?utf-8?B?K1luNSt0cm5mL21oLzJqbTZSWlNBMXJiR3E3WUhmZU44Y3ZDL0FFMEY3bjFF?=
 =?utf-8?B?OHREMXYyc1FtaDFZWFdNM1hlYzB6SmQwNTNmV2R0MHhWNzBrTGxIQ0ErY04x?=
 =?utf-8?B?OVcveGNwWE9YSERLamJMY2xKdGRveHhDd1hrVFZMWFY2N2hTd2hkbnhBZU9w?=
 =?utf-8?B?R2xZaHgwd0E2OHl4VjJFdytkVWJ3ZWJ6ZCtZQ1V1VFpZVjFmTDFjN3ZrKzVZ?=
 =?utf-8?B?VzdSRmgrZWN2ZnhCQ3E0em1GSDZzY0I1bDJEKy9QRm9qajI1MkJmcHcyOTRt?=
 =?utf-8?B?dDNvN2VaczkxeEZROW5aS0p5NWRCWEwwRnZ4VzV4RDFJQm41eWRpZXpvMXdI?=
 =?utf-8?B?czhZNFBjdjVGdVVJems4UlBNRGRKR3dyYUg5Z2hVR0lYRTRsQlFzRzFjRUYr?=
 =?utf-8?B?S1hlRGRFNXFuSXlRVHN6WG1RVExkY2pNRnM0aXlRUUNEaXB1eUdRaWFHZ0tP?=
 =?utf-8?B?dnRVMFRyeTVWbWV1TStQT0Rocm8xWHhib0dBYXBFblc0eFNMRHZxUWllbXVM?=
 =?utf-8?B?azdEZGNZTE5veXZZbmxsUXhOdXNIY3g3Zm9TUUFpd0IzREF1NUxOcFdUbVBM?=
 =?utf-8?B?N2l1VnZrcEJ6SlVZUUVkZnU4U0MyOTh2UW1XWTEzY0xhY2xwTWVheDZyeW11?=
 =?utf-8?B?RnlYYnFBWmtseUREeXdJYVBtMG9YNlBXandIUXJqSCsvdEk2eGh4WGZZMWtL?=
 =?utf-8?B?OXc9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 931f59e5-ac58-4613-b28c-08d9aab7ef73
X-MS-Exchange-CrossTenant-AuthSource: SN6PR1501MB2064.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Nov 2021 17:22:02.3589
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: FRYScfnrpOgYCIyUB5hza3UWUW6wvNAsS8DaPhwhTTRs3UZGOQ6lZbadfwG8V8Jk
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR15MB4808
X-OriginatorOrg: fb.com
X-Proofpoint-GUID: OLH1YMRG4LelBjrgFkFohu5rSt4KEWQo
X-Proofpoint-ORIG-GUID: OLH1YMRG4LelBjrgFkFohu5rSt4KEWQo
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.790,Hydra:6.0.425,FMLib:17.0.607.475
 definitions=2021-11-18_12,2021-11-17_01,2020-04-07_01
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 spamscore=0 clxscore=1011
 mlxlogscore=999 phishscore=0 adultscore=0 impostorscore=0 malwarescore=0
 suspectscore=0 bulkscore=0 priorityscore=1501 lowpriorityscore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2110150000 definitions=main-2111180092
X-FB-Internal: deliver
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org



On 11/15/21 9:42 PM, Kumar Kartikeya Dwivedi wrote:
> This change adds eBPF iterator for buffers registered in io_uring ctx.
> It gives access to the ctx, the index of the registered buffer, and a
> pointer to the io_uring_ubuf itself. This allows the iterator to save
> info related to buffers added to an io_uring instance, that isn't easy
> to export using the fdinfo interface (like exact struct page composing
> the registered buffer).
> 
> The primary usecase this is enabling is checkpoint/restore support.
> 
> Note that we need to use mutex_trylock when the file is read from, in
> seq_start functions, as the order of lock taken is opposite of what it
> would be when io_uring operation reads the same file.  We take
> seq_file->lock, then ctx->uring_lock, while io_uring would first take
> ctx->uring_lock and then seq_file->lock for the same ctx.
> 
> This can lead to a deadlock scenario described below:
> 
>        CPU 0				CPU 1
> 
>        vfs_read
>        mutex_lock(&seq_file->lock)	io_read
> 					mutex_lock(&ctx->uring_lock)
>        mutex_lock(&ctx->uring_lock) # switched to mutex_trylock
> 					mutex_lock(&seq_file->lock)

It is not clear which mutex_lock switched to mutex_trylock.
 From below example, it looks like &ctx->uring_lock. But if this is
the case, we could have deadlock, right?

> 
> The trylock also protects the case where io_uring tries to read from
> iterator attached to itself (same ctx), where the order of locks would
> be:
>   io_uring_enter
>    mutex_lock(&ctx->uring_lock) <-----------.
>    io_read				    \
>     seq_read				     \
>      mutex_lock(&seq_file->lock)		     /
>      mutex_lock(&ctx->uring_lock) # deadlock-`
> 
> In both these cases (recursive read and contended uring_lock), -EDEADLK
> is returned to userspace.
> 
> In the future, this iterator will be extended to directly support
> iteration of bvec Flexible Array Member, so that when there is no
> corresponding VMA that maps to the registered buffer (e.g. if VMA is
> destroyed after pinning pages), we are able to reconstruct the
> registration on restore by dumping the page contents and then replaying
> them into a temporary mapping used for registration later. All this is
> out of scope for the current series however, but builds upon this
> iterator.
> 
> Cc: Jens Axboe <axboe@kernel.dk>
> Cc: Pavel Begunkov <asml.silence@gmail.com>
> Cc: io-uring@vger.kernel.org
> Signed-off-by: Kumar Kartikeya Dwivedi <memxor@gmail.com>
> ---
>   fs/io_uring.c                  | 179 +++++++++++++++++++++++++++++++++
>   include/linux/bpf.h            |   2 +
>   include/uapi/linux/bpf.h       |   3 +
>   tools/include/uapi/linux/bpf.h |   3 +
>   4 files changed, 187 insertions(+)
> 
> diff --git a/fs/io_uring.c b/fs/io_uring.c
> index b07196b4511c..46a110989155 100644
> --- a/fs/io_uring.c
> +++ b/fs/io_uring.c
> @@ -81,6 +81,7 @@
>   #include <linux/tracehook.h>
>   #include <linux/audit.h>
>   #include <linux/security.h>
> +#include <linux/btf_ids.h>
>   
>   #define CREATE_TRACE_POINTS
>   #include <trace/events/io_uring.h>
> @@ -11125,3 +11126,181 @@ static int __init io_uring_init(void)
>   	return 0;
>   };
>   __initcall(io_uring_init);
> +
> +#ifdef CONFIG_BPF_SYSCALL
> +
> +BTF_ID_LIST(btf_io_uring_ids)
> +BTF_ID(struct, io_ring_ctx)
> +BTF_ID(struct, io_mapped_ubuf)
> +
> +struct bpf_io_uring_seq_info {
> +	struct io_ring_ctx *ctx;
> +	unsigned long index;
> +};
> +
> +static int bpf_io_uring_init_seq(void *priv_data, struct bpf_iter_aux_info *aux)
> +{
> +	struct bpf_io_uring_seq_info *info = priv_data;
> +	struct io_ring_ctx *ctx = aux->ctx;
> +
> +	info->ctx = ctx;
> +	return 0;
> +}
> +
> +static int bpf_io_uring_iter_attach(struct bpf_prog *prog,
> +				    union bpf_iter_link_info *linfo,
> +				    struct bpf_iter_aux_info *aux)
> +{
> +	struct io_ring_ctx *ctx;
> +	struct fd f;
> +	int ret;
> +
> +	f = fdget(linfo->io_uring.io_uring_fd);
> +	if (unlikely(!f.file))
> +		return -EBADF;
> +
> +	ret = -EOPNOTSUPP;
> +	if (unlikely(f.file->f_op != &io_uring_fops))
> +		goto out_fput;
> +
> +	ret = -ENXIO;
> +	ctx = f.file->private_data;
> +	if (unlikely(!percpu_ref_tryget(&ctx->refs)))
> +		goto out_fput;
> +
> +	ret = 0;
> +	aux->ctx = ctx;
> +
> +out_fput:
> +	fdput(f);
> +	return ret;
> +}
> +
> +static void bpf_io_uring_iter_detach(struct bpf_iter_aux_info *aux)
> +{
> +	percpu_ref_put(&aux->ctx->refs);
> +}
> +
> +/* io_uring iterator for registered buffers */
> +
> +struct bpf_iter__io_uring_buf {
> +	__bpf_md_ptr(struct bpf_iter_meta *, meta);
> +	__bpf_md_ptr(struct io_ring_ctx *, ctx);
> +	__bpf_md_ptr(struct io_mapped_ubuf *, ubuf);
> +	unsigned long index;
> +};

I would suggest to change "unsigned long index" to either u32 or u64.
This structure is also the bpf program context and in bpf program 
context, "index" will be u64. Then on 32bit system, we potentially
could have issues.

> +
> +static void *__bpf_io_uring_buf_seq_get_next(struct bpf_io_uring_seq_info *info)
> +{
> +	if (info->index < info->ctx->nr_user_bufs)
> +		return info->ctx->user_bufs[info->index++];
> +	return NULL;
> +}
> +
> +static void *bpf_io_uring_buf_seq_start(struct seq_file *seq, loff_t *pos)
> +{
> +	struct bpf_io_uring_seq_info *info = seq->private;
> +	struct io_mapped_ubuf *ubuf;
> +
> +	/* Indicate to userspace that the uring lock is contended */
> +	if (!mutex_trylock(&info->ctx->uring_lock))
> +		return ERR_PTR(-EDEADLK);
> +
> +	ubuf = __bpf_io_uring_buf_seq_get_next(info);
> +	if (!ubuf)
> +		return NULL;
> +
> +	if (*pos == 0)
> +		++*pos;
> +	return ubuf;
> +}
> +
> +static void *bpf_io_uring_buf_seq_next(struct seq_file *seq, void *v, loff_t *pos)
> +{
> +	struct bpf_io_uring_seq_info *info = seq->private;
> +
> +	++*pos;
> +	return __bpf_io_uring_buf_seq_get_next(info);
> +}
> +
> +DEFINE_BPF_ITER_FUNC(io_uring_buf, struct bpf_iter_meta *meta,
> +		     struct io_ring_ctx *ctx, struct io_mapped_ubuf *ubuf,
> +		     unsigned long index)

Again, change "unsigned long" to "u32" or "u64".

> +
> +static int __bpf_io_uring_buf_seq_show(struct seq_file *seq, void *v, bool in_stop)
> +{
> +	struct bpf_io_uring_seq_info *info = seq->private;
> +	struct bpf_iter__io_uring_buf ctx;
> +	struct bpf_iter_meta meta;
> +	struct bpf_prog *prog;
> +
> +	meta.seq = seq;
> +	prog = bpf_iter_get_info(&meta, in_stop);
> +	if (!prog)
> +		return 0;
> +
> +	ctx.meta = &meta;
> +	ctx.ctx = info->ctx;
> +	ctx.ubuf = v;
> +	ctx.index = info->index ? info->index - !in_stop : 0;
> +
> +	return bpf_iter_run_prog(prog, &ctx);
> +}
> +
> +static int bpf_io_uring_buf_seq_show(struct seq_file *seq, void *v)
> +{
> +	return __bpf_io_uring_buf_seq_show(seq, v, false);
> +}
> +
> +static void bpf_io_uring_buf_seq_stop(struct seq_file *seq, void *v)
> +{
> +	struct bpf_io_uring_seq_info *info = seq->private;
> +
> +	/* If IS_ERR(v) is true, then ctx->uring_lock wasn't taken */
> +	if (IS_ERR(v))
> +		return;
> +	if (!v)
> +		__bpf_io_uring_buf_seq_show(seq, v, true);
> +	else if (info->index) /* restart from index */
> +		info->index--;
> +	mutex_unlock(&info->ctx->uring_lock);
> +}
> +
> +static const struct seq_operations bpf_io_uring_buf_seq_ops = {
> +	.start = bpf_io_uring_buf_seq_start,
> +	.next  = bpf_io_uring_buf_seq_next,
> +	.stop  = bpf_io_uring_buf_seq_stop,
> +	.show  = bpf_io_uring_buf_seq_show,
> +};
> +
> +static const struct bpf_iter_seq_info bpf_io_uring_buf_seq_info = {
> +	.seq_ops          = &bpf_io_uring_buf_seq_ops,
> +	.init_seq_private = bpf_io_uring_init_seq,
> +	.fini_seq_private = NULL,
> +	.seq_priv_size    = sizeof(struct bpf_io_uring_seq_info),
> +};
> +
> +static struct bpf_iter_reg io_uring_buf_reg_info = {
> +	.target            = "io_uring_buf",
> +	.feature	   = BPF_ITER_RESCHED,
> +	.attach_target     = bpf_io_uring_iter_attach,
> +	.detach_target     = bpf_io_uring_iter_detach,

Since you have this extra `io_uring_fd` for the iterator, you may want
to implement show_fdinfo and fill_link_info callback functions here.

> +	.ctx_arg_info_size = 2,
> +	.ctx_arg_info = {
> +		{ offsetof(struct bpf_iter__io_uring_buf, ctx),
> +		  PTR_TO_BTF_ID },
> +		{ offsetof(struct bpf_iter__io_uring_buf, ubuf),
> +		  PTR_TO_BTF_ID_OR_NULL },
> +	},
> +	.seq_info	   = &bpf_io_uring_buf_seq_info,
> +};
> +
> +static int __init io_uring_iter_init(void)
> +{
> +	io_uring_buf_reg_info.ctx_arg_info[0].btf_id = btf_io_uring_ids[0];
> +	io_uring_buf_reg_info.ctx_arg_info[1].btf_id = btf_io_uring_ids[1];
> +	return bpf_iter_reg_target(&io_uring_buf_reg_info);
> +}
> +late_initcall(io_uring_iter_init);
> +
> +#endif
> diff --git a/include/linux/bpf.h b/include/linux/bpf.h
> index 56098c866704..ddb9d4520a3f 100644
> --- a/include/linux/bpf.h
> +++ b/include/linux/bpf.h
> @@ -1509,8 +1509,10 @@ int bpf_obj_get_user(const char __user *pathname, int flags);
>   	extern int bpf_iter_ ## target(args);			\
>   	int __init bpf_iter_ ## target(args) { return 0; }
>   
> +struct io_ring_ctx;
>   struct bpf_iter_aux_info {
>   	struct bpf_map *map;
> +	struct io_ring_ctx *ctx;
>   };

Can we use union here? Note that below bpf_iter_link_info in 
uapi/linux/bpf.h, map_fd and io_uring_fd is also an union.

>   
>   typedef int (*bpf_iter_attach_target_t)(struct bpf_prog *prog,
> diff --git a/include/uapi/linux/bpf.h b/include/uapi/linux/bpf.h
> index 6297eafdc40f..3323defa99a1 100644
> --- a/include/uapi/linux/bpf.h
> +++ b/include/uapi/linux/bpf.h
> @@ -91,6 +91,9 @@ union bpf_iter_link_info {
>   	struct {
>   		__u32	map_fd;
>   	} map;
> +	struct {
> +		__u32   io_uring_fd;
> +	} io_uring;
>   };
>   
>   /* BPF syscall commands, see bpf(2) man-page for more details. */
> diff --git a/tools/include/uapi/linux/bpf.h b/tools/include/uapi/linux/bpf.h
> index 6297eafdc40f..3323defa99a1 100644
> --- a/tools/include/uapi/linux/bpf.h
> +++ b/tools/include/uapi/linux/bpf.h
> @@ -91,6 +91,9 @@ union bpf_iter_link_info {
>   	struct {
>   		__u32	map_fd;
>   	} map;
> +	struct {
> +		__u32   io_uring_fd;
> +	} io_uring;
>   };
>   
>   /* BPF syscall commands, see bpf(2) man-page for more details. */
> 
