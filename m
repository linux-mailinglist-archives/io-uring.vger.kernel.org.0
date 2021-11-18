Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D8C0345633E
	for <lists+io-uring@lfdr.de>; Thu, 18 Nov 2021 20:13:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230499AbhKRTQb (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 18 Nov 2021 14:16:31 -0500
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:13312 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229554AbhKRTQa (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 18 Nov 2021 14:16:30 -0500
Received: from pps.filterd (m0109333.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 1AIDNved027755;
        Thu, 18 Nov 2021 11:13:10 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=facebook;
 bh=rwLSmNZA5IDTB8c26CY8dQU43yli8CL1UMDwgo0y/yY=;
 b=Xi+1aG5pPXz5OTnQ7WZQ+Y6MleopBoMOpQmu2tAcsAxO6PlOQXsrZYZVCI4ZAmlpqMF5
 AEjLMJ538t0HvjCAJRtGumBNVTAv6N/xJ5PcgDXHwW4TD1YjWFRZujK5b6iDW6gewh7g
 esTXood0D8PQyI9iK1apyttJbQ66xzFRZRk= 
Received: from mail.thefacebook.com ([163.114.132.120])
        by mx0a-00082601.pphosted.com with ESMTP id 3cdqp4jsjp-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Thu, 18 Nov 2021 11:13:09 -0800
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (100.104.98.9) by
 o365-in.thefacebook.com (100.104.94.196) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.14; Thu, 18 Nov 2021 11:13:09 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ImuRdc9u5kvzXAjrq0Bw6ffSo+iYPb6Ky0ZukQpS48QBQz/RygfNbgT6YU5p3rvI1MzS/R/5GodeeTKk5nI3CD2fNBMhgifFdrsDTM+gecxsbsGUr9b9vQfJNbp5LV/bTpz/k1sLO6kRBbc2nj3/ZLEd3cOhZTCqGBwuQvjfRqW2w5cP2CGIvQ4D8Gob1bSWv43HTCvtcCTHKWY4pJB0j+uoZEnvK0LKSoYws+aXPX0wCnmeD9cau8V6S9dfpfkz4/GcG4IDR1qk6vIuFpmC9/WP4P63USVC+KCuqQ25trDFy3kgOrcFImppZy7Q9LqFrRob++XoEJW+yE2hkVFKPw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=rwLSmNZA5IDTB8c26CY8dQU43yli8CL1UMDwgo0y/yY=;
 b=Oplubm2W60s34OtDH1Grw3dgmsxhwHEsC7o+A/xjR3OaGnARJULkApxc7GFAOLuXLoexiXhIEY66FkPvGGMXfptduMmwjFt7jo+OkvrB8r3cX71WTHjc9CyOx2A0Vkp1TctRtkMjZ6OK101TSuI8+aOhM315CEYR0CN+kjOM28jie4gVhKYh58z3Hf3fk5Ky/LEs14rM9LzUPjm/wArVyaMLGgWNfbwk1dc3z/Eq/IDvCYvl75S2NV7apueu497N15M06k/zZQcpTaPHNLxHBoYot48l87l6ELEkqyd3Z8hGnN/RSWAi64MPnyicPmNlnreJyUkSr0kDx6sN+TkOAQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
Authentication-Results: gmail.com; dkim=none (message not signed)
 header.d=none;gmail.com; dmarc=none action=none header.from=fb.com;
Received: from SN6PR1501MB2064.namprd15.prod.outlook.com (2603:10b6:805:d::27)
 by SA1PR15MB4869.namprd15.prod.outlook.com (2603:10b6:806:1d0::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4649.15; Thu, 18 Nov
 2021 19:13:07 +0000
Received: from SN6PR1501MB2064.namprd15.prod.outlook.com
 ([fe80::a91b:fba1:b79c:812c]) by SN6PR1501MB2064.namprd15.prod.outlook.com
 ([fe80::a91b:fba1:b79c:812c%5]) with mapi id 15.20.4690.029; Thu, 18 Nov 2021
 19:13:05 +0000
Message-ID: <3c6e4801-61d2-d6b9-0e2b-869053f8adbc@fb.com>
Date:   Thu, 18 Nov 2021 11:13:02 -0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.3.0
Subject: Re: [PATCH bpf-next v1 1/8] io_uring: Implement eBPF iterator for
 registered buffers
Content-Language: en-US
To:     Kumar Kartikeya Dwivedi <memxor@gmail.com>
CC:     <bpf@vger.kernel.org>, Jens Axboe <axboe@kernel.dk>,
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
 <8d95bd01-7f1a-9350-cede-c6abd56a7927@fb.com>
 <20211118182845.b4b7qaj7ip3lmkcj@apollo.localdomain>
From:   Yonghong Song <yhs@fb.com>
In-Reply-To: <20211118182845.b4b7qaj7ip3lmkcj@apollo.localdomain>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MWHPR17CA0057.namprd17.prod.outlook.com
 (2603:10b6:300:93::19) To SN6PR1501MB2064.namprd15.prod.outlook.com
 (2603:10b6:805:d::27)
MIME-Version: 1.0
Received: from [IPV6:2620:10d:c085:21e1::1798] (2620:10d:c090:400::5:184a) by MWHPR17CA0057.namprd17.prod.outlook.com (2603:10b6:300:93::19) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4713.19 via Frontend Transport; Thu, 18 Nov 2021 19:13:04 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: fed9418d-7cff-4b91-bdb8-08d9aac77303
X-MS-TrafficTypeDiagnostic: SA1PR15MB4869:
X-Microsoft-Antispam-PRVS: <SA1PR15MB4869C12CED5280E0D317FF96D39B9@SA1PR15MB4869.namprd15.prod.outlook.com>
X-FB-Source: Internal
X-MS-Oob-TLC-OOBClassifiers: OLM:10000;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Eun4vViPOTABZ+Wb8GSgiPJedaoAnxoST9Nn6Cjf4uxTvb8B++WR1XpLbPS0SfjPvuSoPlO7q1xSaXaGGpkaAUTX1UHlHSCe6I74Q3CMqKW4/z695cTUE6Cujp5YN4veM2+q40xewRLpLBkwaG068OtMiNDLQc6RAVOpMxqi6SFn7Cif3t87/epC3fX7V/TYc54QgZRhS80bHPvUJyLb2k8ci22eqx0MPP67mwtoGTp2XO2XzTgYi41vLFCvZ5aqWzGMlJ0LDdhHRUXs0AOuXciMjO9cj7tjaoVy8iamnk0cGajSuSX/+6I3Z5PM7cGyu8Yz6YIGN4AQVkElsRbspSwEJhQE5UDk7W22+56XBULssYh+OuIbTpYc3gUAd+CRjREc1egklPfDSdNPGzKODkMh4U1IdxTTLAtk4sdhQMnkBym0u4oxANA8Nh8N9Ft9sAaAdwFIq6/v3taBWK2XC3SgzC0f3wREhXntjcxMwBuYyZH5Izg3ljKwK4rPyFGRTo7dVLAiCtG51sQaE952KFJzmeV3sl5iC+C6t1pTu6j5f9pCxhW6nP3tEa5djBFkYidK5EDCVbgXXiPp9pe8ygQUH858L8S6RTUuxd1hE2C9g5dZHpA2YEwCCOvBewGnGcOyhwS6309Ti6qaok3DUxKc+jJcO1SoFCgmnsxAeZ+FW9CmakWiu2O9uCQLkjkHCNCOPZyRQJw2iAoRv6pP8DRjopfEn66L8U1Bdqc9WP/ZH0Utb3Dt/v+gx60wQ88P
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR1501MB2064.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(86362001)(4326008)(66946007)(508600001)(2616005)(186003)(66556008)(8676002)(66476007)(38100700002)(8936002)(36756003)(83380400001)(53546011)(316002)(54906003)(7416002)(6916009)(2906002)(31696002)(52116002)(5660300002)(31686004)(6486002)(45980500001)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?VmdSajRTQUkvL3RnWUZZdzVRSmIvZkpDS1RUUEFRRkxXdTVHSlpwb0JQNmJB?=
 =?utf-8?B?U0pCR0hnTUpNQnRDUEJFN0NzSTIwWWpjd09raGNmV0hNQ3NtUnJqT2oxaHdv?=
 =?utf-8?B?dTJ1VG1lRFlLZFNJWFAyVnZ6dVdqZ1V1UVhOSFFqdDhKNTMzQ1V6MnpZdnIw?=
 =?utf-8?B?NEorU010QjRwKzZuQUFTQW43SUR6Um93Z01RSVM4U2hndmZNY2d4VlNuZStu?=
 =?utf-8?B?Qm1PQkhYTDF0dllqTHg0NFJZUW9YT1pSSjhSMStpZWNBdm5US05iNk1YWDRu?=
 =?utf-8?B?RjRkeTFXZFBWMVVuTkZHcUxyRlhWVUc5MUlxazQ4djRHS2RLY2ZGeTF6K3B1?=
 =?utf-8?B?a1VienBJcUNjYWc1akJUMm1mb2lVOGRoUVVVeG5lTy9yTkdNdGNTcHYzOXdC?=
 =?utf-8?B?T0oyK1RSSEE1bGlzNXNGK0ErdmN3eWNpYy9HRjA1cXhQbkluNmxDbFVWNE1R?=
 =?utf-8?B?Wm1rU3J0b0c5Qi9BWUdraWJqaGpHQ3B4c1dmTG5BbHhFWlllREVCbW9nM2Za?=
 =?utf-8?B?TTVJSlg0YWJrUEhMV1lubDV3cG96Y0tkaUJmTWpHRjN3Rmd1N0tYYkZkRkx4?=
 =?utf-8?B?QlJxSzJyR3JwSEtXbjBsaXdBTmRKWGdtM3IrbXFXVkxyYVpHVjUvUEExbmRq?=
 =?utf-8?B?Vy9QMzJaVGRONWYyVWs2M0NBZGZkT1doTGNWbzVPUytmTCtURjUzZllqekI2?=
 =?utf-8?B?dEVoZEpzMGxnc0Rnb3ZFWU9UV24wRHZ2VDdSdXlpc0tJT2ZRcHFBMDRWTDlF?=
 =?utf-8?B?cjRQeUtEQzdVaTNYb2dWSHRJSnl4S0VhaXdTL1NWME41NVljbXpyY2c3d1Vm?=
 =?utf-8?B?cXA3TmVhbndFeGFwU0Q3c0p1TGFmQzZUTUNFRHFqS1lQYWxJMFk4clVWYUFt?=
 =?utf-8?B?aVhUdnloR2JyRlpRRWptRTlnNW0yTUNQamkrOWo1aFJjWXAwdEt2RnJPdkhz?=
 =?utf-8?B?SFpiZ0wrZjA4L0pDNlUvcDk0cGN6N2tWVmVoeFZJbWpUbzRNZXNKbStXeXdn?=
 =?utf-8?B?c01ONmJTT3pMaXkveXJRNjN4QnU3ZnBua2dJZC9xeE1qeXE3dlNNenhwZnF0?=
 =?utf-8?B?VWk0V0RIMFF5QWFJM1FJRDNxTFhFcFVxbWV5ZUQrM1FqQlNzL2lxbWNrazk0?=
 =?utf-8?B?c2NMS0c4NU9nZVpLaWJaSE9UakRoWEMrZjh0K2NEZjBsaXRIQS9hV3hmTFVl?=
 =?utf-8?B?Vnk1NjZRM3pjZ3RCY1k2VmtOMDlSQkI0dzdBZHhzRFE1NDIza3p0MnpqSWN1?=
 =?utf-8?B?ZDdMYjhYWHpBR1ZMa0xhZlRpWkdDaEEvWjBwM1J3ZXJzcnJVb2tjTkc3RGs1?=
 =?utf-8?B?NzQzd0pBWGJYNzI1aWxIMmc3N00rSTVWbkNtWTVVWmNJOFZUOVo3WTc5dTFM?=
 =?utf-8?B?UVNlMkM3UmJJUU92L1gxdmw2bXNOVmowaW9YaFJsNGk1ajN0TVVZMi8wclVw?=
 =?utf-8?B?NVN6b0tBZG4zT05rajdOQVpQOFpoMGFrYkJrelJnSWdET2RrSTRQb0Qwd3R3?=
 =?utf-8?B?dzBZSndiNnFWRUltZkxPNnROUXBWYWZnTDlhcGRmcVNZY2QweFVraFgzbk4z?=
 =?utf-8?B?ZWJTRkhYOXVwT3F6b3A0V2pwQTZyQitQT3hDbm9HdlJQV2xRbHdSd2dRSEk3?=
 =?utf-8?B?VDQxNWJ3ZlphWVJVeWNmeFNkVXpFaGVydnVpMGR2UW5vTWI4YWk5YlZJVFdw?=
 =?utf-8?B?b3BKaUNEY1pIUzh1cGp6elFvQWlaYVNtUEM0MkhTNmUyNmhLM2FGenlqeGdp?=
 =?utf-8?B?YWo4L1hyS3VQemE3SjFCQTZWa3JJMGl3eitLa2U4U0Fkc2ZMdGJ3dXoxdWhB?=
 =?utf-8?B?OERqYW10UytTZHVMN2NSUlVZVTJBaTJxNllvSUZsR0hpVzRQcGZtSThjMU5a?=
 =?utf-8?B?WDkveHhCcnd2TlRoZnR5VXpQeUlnTVdpRVZoZHhSbHRpRXdFN0pnclZlQzIr?=
 =?utf-8?B?R1RqZTI1TlhDMDdTR1pCY2RWazB4eVZEYS9QMnRFYnFzb0VFUzRNYkREUTZZ?=
 =?utf-8?B?MXJHcjBMWWNLQlg4SDdia1BJcThSeEdWdlZXaG1oQnpvVlFiS3NYV3NrNDh5?=
 =?utf-8?B?elNQd04zTmlYMCtmVTFDVXV1bjg0OGtUSHhKbUtXVXJZOGgvUkN1cFRLU2dU?=
 =?utf-8?B?Qy9HUnhpSW1zeWhmeDI1VG5RK1NSeDgzbHZmT2k0QmdXQ3RERVQ4cFlNcDRX?=
 =?utf-8?B?U3c9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: fed9418d-7cff-4b91-bdb8-08d9aac77303
X-MS-Exchange-CrossTenant-AuthSource: SN6PR1501MB2064.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Nov 2021 19:13:05.5853
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: dzLPkq68hYswmDlWdmp0iYJXt4sAcrZMohz0zPM6mZu/FOf0vwhDYDFJnLUgls0q
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR15MB4869
X-OriginatorOrg: fb.com
X-Proofpoint-GUID: j8y5_N3V2agQ1vJT8ZDC84AxAo1Fnkva
X-Proofpoint-ORIG-GUID: j8y5_N3V2agQ1vJT8ZDC84AxAo1Fnkva
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.790,Hydra:6.0.425,FMLib:17.0.607.475
 definitions=2021-11-18_12,2021-11-17_01,2020-04-07_01
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 impostorscore=0
 spamscore=0 mlxlogscore=999 mlxscore=0 priorityscore=1501 phishscore=0
 bulkscore=0 malwarescore=0 suspectscore=0 adultscore=0 clxscore=1015
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2110150000 definitions=main-2111180102
X-FB-Internal: deliver
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org



On 11/18/21 10:28 AM, Kumar Kartikeya Dwivedi wrote:
> On Thu, Nov 18, 2021 at 10:51:59PM IST, Yonghong Song wrote:
>>
>>
>> On 11/15/21 9:42 PM, Kumar Kartikeya Dwivedi wrote:
>>> This change adds eBPF iterator for buffers registered in io_uring ctx.
>>> It gives access to the ctx, the index of the registered buffer, and a
>>> pointer to the io_uring_ubuf itself. This allows the iterator to save
>>> info related to buffers added to an io_uring instance, that isn't easy
>>> to export using the fdinfo interface (like exact struct page composing
>>> the registered buffer).
>>>
>>> The primary usecase this is enabling is checkpoint/restore support.
>>>
>>> Note that we need to use mutex_trylock when the file is read from, in
>>> seq_start functions, as the order of lock taken is opposite of what it
>>> would be when io_uring operation reads the same file.  We take
>>> seq_file->lock, then ctx->uring_lock, while io_uring would first take
>>> ctx->uring_lock and then seq_file->lock for the same ctx.
>>>
>>> This can lead to a deadlock scenario described below:
>>>
>>>         CPU 0				CPU 1
>>>
>>>         vfs_read
>>>         mutex_lock(&seq_file->lock)	io_read
>>> 					mutex_lock(&ctx->uring_lock)
>>>         mutex_lock(&ctx->uring_lock) # switched to mutex_trylock
>>> 					mutex_lock(&seq_file->lock)
>>
>> It is not clear which mutex_lock switched to mutex_trylock.
> 
> The one in vfs_read.
> 
>>  From below example, it looks like &ctx->uring_lock. But if this is
>> the case, we could have deadlock, right?
>>
> 
> Sorry, I will make the commit message clearer in the next version.
> 
> The sequence on CPU 0 is for normal read(2) on iterator.
> For CPU 1, it is an io_uring instance trying to do same on iterator attached to
> itself.
> 
> So CPU 0 does
> 
> sys_read
> vfs_read
>   bpf_seq_read
>   mutex_lock(&seq_file->lock)    # A
>    io_uring_buf_seq_start
>    mutex_lock(&ctx->uring_lock)  # B
> 
> and CPU 1 does
> 
> io_uring_enter
> mutex_lock(&ctx->uring_lock)    # B
>   io_read
>    bpf_seq_read
>    mutex_lock(&seq_file->lock)   # A
>    ...
> 
> Since the order of locks is opposite, it can deadlock. So I switched the
> mutex_lock in io_uring_buf_seq_start to trylock, so it can return an error for
> this case, then it will release seq_file->lock and CPU 1 will make progress.
> 
> The second problem without use of trylock is described below (for same case of
> io_uring reading from iterator attached to itself).
> 
> Let me know if I missed something.

Thanks for explanation. The above diagram is much better.

> 
>>>
>>> The trylock also protects the case where io_uring tries to read from
>>> iterator attached to itself (same ctx), where the order of locks would
>>> be:
>>>    io_uring_enter
>>>     mutex_lock(&ctx->uring_lock) <-----------.
>>>     io_read				    \
>>>      seq_read				     \
>>>       mutex_lock(&seq_file->lock)		     /
>>>       mutex_lock(&ctx->uring_lock) # deadlock-`
>>>
>>> In both these cases (recursive read and contended uring_lock), -EDEADLK
>>> is returned to userspace.
>>>
>>> In the future, this iterator will be extended to directly support
>>> iteration of bvec Flexible Array Member, so that when there is no
>>> corresponding VMA that maps to the registered buffer (e.g. if VMA is
>>> destroyed after pinning pages), we are able to reconstruct the
>>> registration on restore by dumping the page contents and then replaying
>>> them into a temporary mapping used for registration later. All this is
>>> out of scope for the current series however, but builds upon this
>>> iterator.
>>>
>>> Cc: Jens Axboe <axboe@kernel.dk>
>>> Cc: Pavel Begunkov <asml.silence@gmail.com>
>>> Cc: io-uring@vger.kernel.org
>>> Signed-off-by: Kumar Kartikeya Dwivedi <memxor@gmail.com>
>>> ---
>>>    fs/io_uring.c                  | 179 +++++++++++++++++++++++++++++++++
>>>    include/linux/bpf.h            |   2 +
>>>    include/uapi/linux/bpf.h       |   3 +
>>>    tools/include/uapi/linux/bpf.h |   3 +
>>>    4 files changed, 187 insertions(+)
>>>
[...]
> 
>>> [...]
>>> +static struct bpf_iter_reg io_uring_buf_reg_info = {
>>> +	.target            = "io_uring_buf",
>>> +	.feature	   = BPF_ITER_RESCHED,
>>> +	.attach_target     = bpf_io_uring_iter_attach,
>>> +	.detach_target     = bpf_io_uring_iter_detach,
>>
>> Since you have this extra `io_uring_fd` for the iterator, you may want
>> to implement show_fdinfo and fill_link_info callback functions here.
>>
> 
> Ack, but some questions:
> 
> What should it have? e.g. it easy to go from map_id to map fd if one wants
> access to the map attached to the iterator, but not sure how one can obtain more
> information about target fd from io_uring or epoll iterators.

Just to be clear, I am talking about uapi struct bpf_link_info.
I agree that fd is not really useful. So I guess it is up to you
whether you want to show fd to user or not. We can always
add it later if needed.

> 
> Should I delegate to their show_fdinfo and dump using that?
> 
> The type/target is already available in link_info, not sure what other useful
> information can be added there, which allows obtaining the io_uring/epoll fd.
> 
>>> +	.ctx_arg_info_size = 2,
>>> +	.ctx_arg_info = {
>>> +		{ offsetof(struct bpf_iter__io_uring_buf, ctx),
>>> +		  PTR_TO_BTF_ID },
>>> +		{ offsetof(struct bpf_iter__io_uring_buf, ubuf),
>>> +		  PTR_TO_BTF_ID_OR_NULL },
>>> +	},
>>> +	.seq_info	   = &bpf_io_uring_buf_seq_info,
>>> +};
>>> +
>>> +static int __init io_uring_iter_init(void)
>>> +{
>>> +	io_uring_buf_reg_info.ctx_arg_info[0].btf_id = btf_io_uring_ids[0];
>>> +	io_uring_buf_reg_info.ctx_arg_info[1].btf_id = btf_io_uring_ids[1];
>>> +	return bpf_iter_reg_target(&io_uring_buf_reg_info);
>>> +}
>>> +late_initcall(io_uring_iter_init);
>>> +
>>> +#endif
>>> diff --git a/include/linux/bpf.h b/include/linux/bpf.h
>>> index 56098c866704..ddb9d4520a3f 100644
>>> --- a/include/linux/bpf.h
>>> +++ b/include/linux/bpf.h
>>> @@ -1509,8 +1509,10 @@ int bpf_obj_get_user(const char __user *pathname, int flags);
>>>    	extern int bpf_iter_ ## target(args);			\
>>>    	int __init bpf_iter_ ## target(args) { return 0; }
>>> +struct io_ring_ctx;
>>>    struct bpf_iter_aux_info {
>>>    	struct bpf_map *map;
>>> +	struct io_ring_ctx *ctx;
>>>    };
>>
>> Can we use union here? Note that below bpf_iter_link_info in
>> uapi/linux/bpf.h, map_fd and io_uring_fd is also an union.
>>
> 
> So the reason I didn't use a union was the link->aux.map check in
> bpf_iter.c::__get_seq_info. Even if we switch to union bpf_iter_aux_info, it
> needs some way to determine whether link is for map type, so maybe a string
> comparison there? Leaving it out of union felt cleaner, also I move both
> io_ring_ctx and eventpoll file into a union in later patch.

I see. the seq_ops for map element iterator is different from others.
the seq_ops is not from main iter registration but from map_ops.

I think your change is okay. But maybe a comment to explain why
map is different from others in struct bpf_iter_aux_info.

> 
>>>    typedef int (*bpf_iter_attach_target_t)(struct bpf_prog *prog,
>>> diff --git a/include/uapi/linux/bpf.h b/include/uapi/linux/bpf.h
>>> index 6297eafdc40f..3323defa99a1 100644
>>> --- a/include/uapi/linux/bpf.h
>>> +++ b/include/uapi/linux/bpf.h
>>> @@ -91,6 +91,9 @@ union bpf_iter_link_info {
>>>    	struct {
>>>    		__u32	map_fd;
>>>    	} map;
>>> +	struct {
>>> +		__u32   io_uring_fd;
>>> +	} io_uring;
>>>    };
>>>    /* BPF syscall commands, see bpf(2) man-page for more details. */
>>> diff --git a/tools/include/uapi/linux/bpf.h b/tools/include/uapi/linux/bpf.h
>>> index 6297eafdc40f..3323defa99a1 100644
>>> --- a/tools/include/uapi/linux/bpf.h
>>> +++ b/tools/include/uapi/linux/bpf.h
>>> @@ -91,6 +91,9 @@ union bpf_iter_link_info {
>>>    	struct {
>>>    		__u32	map_fd;
>>>    	} map;
>>> +	struct {
>>> +		__u32   io_uring_fd;
>>> +	} io_uring;
>>>    };
>>>    /* BPF syscall commands, see bpf(2) man-page for more details. */
>>>
> 
> --
> Kartikeya
> 
