Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D6878456368
	for <lists+io-uring@lfdr.de>; Thu, 18 Nov 2021 20:22:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231912AbhKRTZT (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 18 Nov 2021 14:25:19 -0500
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:39458 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233532AbhKRTZF (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 18 Nov 2021 14:25:05 -0500
Received: from pps.filterd (m0148461.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 1AIFv0Js032440;
        Thu, 18 Nov 2021 11:21:47 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=facebook;
 bh=oeNh8aSQWs0pDktSkjeiUT09J9hKO6icQPauBcOanC8=;
 b=kY5BrvpvA6PWbgEMY018AT24g6rDeApYOAr8ENLghmMyL3zwgavkHyaGDTmbSgpdNDVN
 53NUjPWCZhAngrHkzUNOr9MQtvBQv+vnYBWryzQj3Mdto3tIFyedYeaqEwa4nrJcuEO/
 A6VP1rfojF6448rdpMlKoAw0bovCZqNvJ4A= 
Received: from mail.thefacebook.com ([163.114.132.120])
        by mx0a-00082601.pphosted.com with ESMTP id 3cdswy9qjf-3
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Thu, 18 Nov 2021 11:21:47 -0800
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (100.104.98.9) by
 o365-in.thefacebook.com (100.104.94.198) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.14; Thu, 18 Nov 2021 11:21:46 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=FjtLHJ8Fyo5CARrRg1B0e1bzZsPHGvVZIQTn42t1i78Fys7OxK7/CRElUXPt1IiZNs3lmMyAI6bJedw4e0K1hmXJTfFIl24zDYju6lHC3S/0wZLBYpdYuPto8f0iowEfvCWzAh3pWoV/rPTec37O0usJGGua3w94nvCJWh2PKF+vIw9Zew7cqk5VFD6eIzCofWgQ7ZkgixNYUnqecZfm9i5ncZl1lYP58wg4ZdzmF+asBP5aDqc0hBCdkrs5xaQwgPr5EGr/6hYBLSfBEEx36SBk+R0zk5psTpv1n/UfYjHX/zNpgxIZ8bfu0tqYw1iXHngpXitFAYhTBr6DQ8vXcA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=oeNh8aSQWs0pDktSkjeiUT09J9hKO6icQPauBcOanC8=;
 b=UlrrLxfVXLdkVBEupAPP/zN4VrrhTMGgHnIi7A9hcNwXeQ1QsY5CZZC1vhJU1j0Su6HcqT+ejBxqnia+aGPj1nypLeA1bdd2rFbew7Xy0v3jgRLf9+eVScKrGpxF9HQc5zbQ+CAA7oOCb1F2QSkG0USIPgeXOkdFzRSMXb4gQXVAmolgDeS6BnVvXczogiomNbasLeu88bjiS99qZ6frlObkSsxILNCfPyJ6aibdDnPbTgOa7M32DqbN+egZOh/lFWRHU8W4VCWYwew7+P84U+HtbJyhRTgBhL4ykKqoE1IO5XEPVCmq1BPMpPYACe4ciL8+FSZF7pVmhQp4i9EYAQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
Authentication-Results: gmail.com; dkim=none (message not signed)
 header.d=none;gmail.com; dmarc=none action=none header.from=fb.com;
Received: from SN6PR1501MB2064.namprd15.prod.outlook.com (2603:10b6:805:d::27)
 by SA1PR15MB4918.namprd15.prod.outlook.com (2603:10b6:806:1d1::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4669.10; Thu, 18 Nov
 2021 19:21:45 +0000
Received: from SN6PR1501MB2064.namprd15.prod.outlook.com
 ([fe80::a91b:fba1:b79c:812c]) by SN6PR1501MB2064.namprd15.prod.outlook.com
 ([fe80::a91b:fba1:b79c:812c%5]) with mapi id 15.20.4690.029; Thu, 18 Nov 2021
 19:21:45 +0000
Message-ID: <feae7c3d-6712-8b54-cecc-741ed2c6a3c9@fb.com>
Date:   Thu, 18 Nov 2021 11:21:42 -0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.3.0
Subject: Re: [PATCH bpf-next v1 5/8] selftests/bpf: Add test for io_uring BPF
 iterators
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
 <20211116054237.100814-6-memxor@gmail.com>
 <92be1024-971f-0ae3-11b7-2988f3b37100@fb.com>
 <20211118183330.c2wnjgciv34mitlv@apollo.localdomain>
From:   Yonghong Song <yhs@fb.com>
In-Reply-To: <20211118183330.c2wnjgciv34mitlv@apollo.localdomain>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MW4PR04CA0180.namprd04.prod.outlook.com
 (2603:10b6:303:85::35) To SN6PR1501MB2064.namprd15.prod.outlook.com
 (2603:10b6:805:d::27)
MIME-Version: 1.0
Received: from [IPV6:2620:10d:c085:21e1::1798] (2620:10d:c090:400::5:184a) by MW4PR04CA0180.namprd04.prod.outlook.com (2603:10b6:303:85::35) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4713.19 via Frontend Transport; Thu, 18 Nov 2021 19:21:44 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 0355a85e-93b8-4d7b-d850-08d9aac8a8d4
X-MS-TrafficTypeDiagnostic: SA1PR15MB4918:
X-Microsoft-Antispam-PRVS: <SA1PR15MB491888AF364E552CB58E7C62D39B9@SA1PR15MB4918.namprd15.prod.outlook.com>
X-FB-Source: Internal
X-MS-Oob-TLC-OOBClassifiers: OLM:454;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: egK1mT3W1bHLO+uyIdPCEs3FLIh7KPkI4p07E5rbaIi9U3XhyQLcWIQKx90G65P43AdAvelmReEWUCi64ZSCpwgaU4QKdm7uFmhG6iSVAxTmb52lxn2MNiGu7VcOJAg0GrblRhGkt2G4q0o5pMLTpuupQREjYgck2UItcscI8uWC51OJaSDUDaJxHC86TshL+q29qIBF/oV0socZpGc5fJd27DA3Pq2hyPyjNbeQjZI3tgltdfltbM3abeBGht+w/DmFY7G5b/q7Q2mRmG8d9tlmNpIdLFevjG4MQENCP2Q9Q4j1ORXy4VHF8DnfnA04kpNCcrztvkHVSdqX4zXdbM4hAoMfWJ+rwcmMW/pNJ1L4V2SxAvaTLjKDiyvvZLd7vsVEg9NzRTc2d820OMAk+T1kq6YclTQn8twqGl8LIX6aFfliTsHvd1HV/AdRPL56wVhEXs3G6pL3NPJD+hgKdSqrrBV1u9S42fMhFh1KWgsSCMWmbruIxSiZS6l8rMh7xVKedRnHbe+DipRG075zF9uNGiCgTH0jM0KapqTSCfZfa29PwtgDo6uowUhxP6I4Jfu8V6zuYLUqc09E+tk1PJxaaIJJylwZF4yOop0Tg0rd9iDBcnHue4FRr6l13pTOulnnfJNdgLnkgLaWYynuVypR2FM0RtdK7nEJ6XBHtlHTCMYfVXowNQtKCyMxkcRMxDxKUkKlmi01wj4ZqnW45sOBTEtYhqBi3hJtEImZ0/vWUudfqLKKMo/D97eMtpkP
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR1501MB2064.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(6916009)(186003)(508600001)(4326008)(8936002)(2906002)(316002)(2616005)(8676002)(66946007)(83380400001)(66476007)(7416002)(86362001)(38100700002)(54906003)(5660300002)(53546011)(31686004)(52116002)(31696002)(36756003)(6486002)(66556008)(45980500001)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?V0JnZU5DN3JHWXpoblpQWUQyajFSaXgyV2tKdFE0TnBCNmp0T3U2dWdZbmdZ?=
 =?utf-8?B?TzBPVDJkWjVsZW04UnVYV210MGlVN0pVMDFwMkRCNWpCZEJLTHpHTW5nY3Zm?=
 =?utf-8?B?OEJpVGNwaDFacm81MUttVVQ1eXZ3OFpIMzFQUVZrK2FWZGcvbUtZVG91VXNa?=
 =?utf-8?B?bnFjM3dXRHJrZW91T01sZ3RlanI4OXZXSkZONEJuOXBKVWhac09IYzZrVWJU?=
 =?utf-8?B?cXdNT0RCM0tRUCsxZE15bTZwVjZaWGdmU29HMUUzY0VSSmRKd3VHRW8xczF4?=
 =?utf-8?B?N2lCVEpxWmxIaGFiTW13bytOWnoyZFU3NXpEaHhlU2xhaUJLV2R3a2tMand4?=
 =?utf-8?B?NFJMVzFYZ0NtWHVtVXJoem85RElab1RIeS91TjkxeVJsayt0d3ZsVmlUOU5z?=
 =?utf-8?B?YUZoN1p5dk5ZV3c0Y0ZMTTB2NnRldzZ4eDVSWWZydEFmajY3WFd0cnE0ckNv?=
 =?utf-8?B?eFRYSlRYdjhCUWtodVlYUXF3Z0pWYkNFQlh1aElvL1Vvajk3Qm9JM0RUNWto?=
 =?utf-8?B?VDVQQXF4Lzd0QlNYdzNlbDBMajYreGpsU1NXY2tNSlFLR0VFVTNoRmpVRHRB?=
 =?utf-8?B?aXVRTlhCRERndm8xOGJ2V29DWHZObyswSWh3MDhSY1VzcjNxQnlIU0FtT0pY?=
 =?utf-8?B?SGhjbnlIU2dob1FZeEoraUNDTFcwTzdrWEVCU0UwSzRhdTBpcG1Ca21xWmI3?=
 =?utf-8?B?Z3pXc0xTUWdaUDQxOFBHMDJGZUY3UENyQVB6Y1VFQ0l5QUZqZVgxN1FzM2Ex?=
 =?utf-8?B?V0IyTUVnWFE5WnpId1RlSkpyZ2RpWjJ4c29uWERlOGtsUnJ2K2UxQ0hwaHpM?=
 =?utf-8?B?WVBwK0RLeVFXeDFLbVN6R2g2RDlFL20zUWtVNURUalZNSENEakZVTjlHQVNP?=
 =?utf-8?B?NWFKRmlmVWluT2dqL1l0VkluVG5CSWVSZnFOYnVhallFQkxzMWczVTYyaXJH?=
 =?utf-8?B?ODFlNjVmMHVyVWpCdm5vNDZoVVdxQVNyNVhiQW92OE5NSDlROEdkU1VXSUpw?=
 =?utf-8?B?VUpSNHRFR0hqT1orMU4vQXZMWmVXL3JCY2NKMU9oaU5KMnpuc0FkK1BnTlRr?=
 =?utf-8?B?NHRVU1p0dUQ3MkR6YlNYditzRzJCajJVOE9ZdGMrVzBqZkV4UkI2VDdReE92?=
 =?utf-8?B?NjJJRW1kcm9tMDBaSUI4YWR3OE1HMGR4NmJER3BXRU9MQjNYVC8ydjJIR2lT?=
 =?utf-8?B?d2tsdUx1MTk0em1Zd1hwa0phbzI2c29KTjdJU3lWQlRhbjhUbFgxbkxyWkhX?=
 =?utf-8?B?L0FJeXZ1TFlPNEF0eGFOeEFVRHdqa204WFVvTXJacVJ0bjJJcWorcGNIVUJv?=
 =?utf-8?B?WmlHbDJ4ZDNKc0hMN0hTTUFnSHdmaWpaR3g4V050VGtLNWt1bVFpSllNQy9z?=
 =?utf-8?B?dEFNa0pXSnZZbDgvTVYzRE5TZ215TlZqRDRGb2lsUi9JQjQvM3I2VjNhYUMw?=
 =?utf-8?B?TkdUUitlbDBPNXVwMS9WNXIxQlJrcTBnUWE1cjk3NlBvMEdoN05nNE9vOW9L?=
 =?utf-8?B?dEQxZ3phRWpzY3l5NFZrS0g0aWdPeEQ1QlptRk1sem92K0FnVktFUEJXTFJD?=
 =?utf-8?B?cGFMK0dJa0ZvQ04vZjVGYU1BcCtrWUl3VDRjem5QUWFsWjZqNHZZNE1BWVhM?=
 =?utf-8?B?WXdxU3BWVXdTS0J0M1FpVW1kTG14T1R2ZGZjQjMrWUx3eVRaa3BkZzltVVQz?=
 =?utf-8?B?bitNa0VkbnpMMXVkQTh5b3VKWWFEd0d1eGtWNHExalBQeVBiWnhrMFduMW54?=
 =?utf-8?B?RWhoWGk1ZXlNdEpJakRBaE40aWdOSTNWRmtBRHp0ZjNBL094b1Q4dXZqUk91?=
 =?utf-8?B?UW9maGtreWhJRXkzWC95ajZDc1pHcU1vaVU3eUN3d0xxZXl2QWtGaG9GVXRx?=
 =?utf-8?B?Q0E1MjJ6M1NuSlNlM1FEbC9hK3plUXJYdFQya09pU1pFMDZnUFdpWFMzVDE1?=
 =?utf-8?B?OWVWYzhpMUs4cSthaEdLTVZPV29FY1MyRFNwTDlpTWo5dDVTVFU5WkNIQmhX?=
 =?utf-8?B?TXMxM1B1UmdYSEo5VG1sWnRxVVpaRVRNRW5kUVQxb0wwK0pkTW0xVEd4OTBv?=
 =?utf-8?B?MCtvcTJMWVRzWVFnSE5tZFh4dnYrU3BON0VVZjF6ODY4SVoxRTFBWTJDQ1N1?=
 =?utf-8?B?OWVHL1pKaGFPdysyUlNwUU1TTXAxYjYyKzY4T2RZMlRrNE81ZHp5Ynh1OUw3?=
 =?utf-8?B?bkE9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 0355a85e-93b8-4d7b-d850-08d9aac8a8d4
X-MS-Exchange-CrossTenant-AuthSource: SN6PR1501MB2064.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Nov 2021 19:21:45.3787
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: gJltBpu4euO3JgrM3f+Zr16MsqevYy0F0mPftUkndLTfD7T3+f1lqySa/RfYW0dm
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR15MB4918
X-OriginatorOrg: fb.com
X-Proofpoint-GUID: x9FjHnfNXfPmqLWhwN45tunW26HA0RgO
X-Proofpoint-ORIG-GUID: x9FjHnfNXfPmqLWhwN45tunW26HA0RgO
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.790,Hydra:6.0.425,FMLib:17.0.607.475
 definitions=2021-11-18_12,2021-11-17_01,2020-04-07_01
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 impostorscore=0
 mlxscore=0 spamscore=0 phishscore=0 adultscore=0 malwarescore=0
 bulkscore=0 priorityscore=1501 mlxlogscore=996 suspectscore=0
 clxscore=1015 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2110150000 definitions=main-2111180102
X-FB-Internal: deliver
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org



On 11/18/21 10:33 AM, Kumar Kartikeya Dwivedi wrote:
> On Thu, Nov 18, 2021 at 11:24:19PM IST, Yonghong Song wrote:
>>
>>
>> On 11/15/21 9:42 PM, Kumar Kartikeya Dwivedi wrote:
>>> This exercises the io_uring_buf and io_uring_file iterators, and tests
>>> sparse file sets as well.
>>>
>>> Cc: Jens Axboe <axboe@kernel.dk>
>>> Cc: Pavel Begunkov <asml.silence@gmail.com>
>>> Cc: io-uring@vger.kernel.org
>>> Signed-off-by: Kumar Kartikeya Dwivedi <memxor@gmail.com>
>>> ---
>>>    .../selftests/bpf/prog_tests/bpf_iter.c       | 226 ++++++++++++++++++
>>>    .../selftests/bpf/progs/bpf_iter_io_uring.c   |  50 ++++
>>>    2 files changed, 276 insertions(+)
>>>    create mode 100644 tools/testing/selftests/bpf/progs/bpf_iter_io_uring.c
>>>
[...]
>>> +
>>> +	ret = snprintf(str, sizeof(buf) - len, "E:%zu\n", ARRAY_SIZE(iovs));
>>> +	if (!ASSERT_GE(ret, 0, "snprintf") || !ASSERT_LT(ret, sizeof(buf) - len, "snprintf"))
>>> +		goto end_close_fd;
>>> +
>>> +	iter_fd = bpf_iter_create(bpf_link__fd(skel->links.dump_io_uring_buf));
>>> +	if (!ASSERT_GE(iter_fd, 0, "bpf_iter_create"))
>>> +		goto end_close_fd;
>>> +
>>> +	ret = read_fd_into_buffer(iter_fd, rbuf, sizeof(rbuf));
>>> +	if (!ASSERT_GT(ret, 0, "read_fd_into_buffer"))
>>> +		goto end_close_iter;
>>> +
>>> +	ASSERT_OK(strcmp(rbuf, buf), "compare iterator output");
>>> +
>>> +	puts("=== Expected Output ===");
>>> +	printf("%s", buf);
>>> +	puts("==== Actual Output ====");
>>> +	printf("%s", rbuf);
>>> +	puts("=======================");
>>
>> Maybe you can do an actual comparison and use ASSERT_* macros to check
>> result?
>>
> 
> I already did that in the line above first "puts". The printing is just for
> better debugging, to show the incorrect output in case test fails. Also in epoll
> test in the next patch the order of entries is not fixed, since they are sorted
> using struct file pointer.

I see, maybe the following which prints out details only if failure?

	if (!ASSERT_OK(strcmp(rbuf, buf), "compare iterator output")) {
		puts("=== ...");
		...
	}

> 
>>> +
>>> +end_close_iter:
>>> +	close(iter_fd);
>>> +end_close_fd:
>>> +	close(fd);
>>> +end:
>>> +	while (i--)
>>> +		munmap(iovs[i].iov_base, iovs[i].iov_len);
>>> +	bpf_iter_io_uring__destroy(skel);
>>> +}
>>> +
[...]
