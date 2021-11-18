Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 420A4456356
	for <lists+io-uring@lfdr.de>; Thu, 18 Nov 2021 20:19:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233353AbhKRTWL (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 18 Nov 2021 14:22:11 -0500
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:21864 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S230179AbhKRTWL (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 18 Nov 2021 14:22:11 -0500
Received: from pps.filterd (m0089730.ppops.net [127.0.0.1])
        by m0089730.ppops.net (8.16.1.2/8.16.1.2) with SMTP id 1AIHEdnO014616;
        Thu, 18 Nov 2021 11:18:54 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=facebook;
 bh=6cDJBycZbpb5/vbgmlxwpiDCSmbwt4vDgIiJTrX6RZo=;
 b=Ocoaonl1cewgU1QcfZm5OV7MjDaa3RgWI9QGuR2WKGJGy+AmsyD8lKBfk2fE147bRJqY
 aGZTEJcoP+OHNk0YWLEL786AXrV3+Dk9BBVhf8Mm4AId9AD6kQNl4WyEvNAPQ/+PzeC5
 Dl6dd9xcG8dxEZZwLUCpe2V2RxgjNeHFdis= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by m0089730.ppops.net with ESMTP id 3cdj39cx37-15
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Thu, 18 Nov 2021 11:18:54 -0800
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (100.104.31.183)
 by o365-in.thefacebook.com (100.104.35.175) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.14; Thu, 18 Nov 2021 11:18:43 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=EKz2nzMaHmKYh5yxakL7nCMeZHxEibzRXJi2am7hEN3fPvwDE9YTWqAHYrpHhQ7fMKK/b6oVGHLw/RQ8lQx2OIj3fCQozRSXHurc6Hwi8MQaDV6GT2+F2b0sbOpbdlQ0N+TfIKB02ngjjuG2+nbq2Kf0TLBX4RIhvbMBYWhfmjxRJQL/xH/UuO9XH/DfHzXdfLcU22+4M2O+1FOpY18b2KNZ2/pfrHLNBk6FHWoZ1/ktuifFi+zZhmxhzRsOdRtco2khZwvqbBVlrwIIjKWmUEjcv0qh3HLoo4EWWNXQfGexHPfYcDPZsW5ClDTdl0Q0Iffk758ajo7wKhv7XG9ghA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=6cDJBycZbpb5/vbgmlxwpiDCSmbwt4vDgIiJTrX6RZo=;
 b=bPHjByegYcbiqxe/NmFyj7tVqil8aDVi2N8qwGt4kVDeZrrfUJnTcxpLszEd/NDlj2zid7eT7aDq8K79k+QTxkpjihiqElb+oqcprcP5jOBg785ct1F0MH2xwShe5mhoGncX+z0oLjvcrq5Prn1nL1SU0w2CIy+PUctSFu5eCJMxkNjWvei6V+ueNULaGWhJQFAGL/nTb/4q0sbfR7/6NerFymGdnbY/CegxyQm6Q0vkUt0LkNJewMQv3di+Tg5sv3B9dGvyWiKWlv2FMZtYNM/5lUh/DwpdL+1XN9O9su0y+fb66bCDM7E5c6P+BvFrFxxgbH+rQCRlxv75dDSB8w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
Received: from SN6PR1501MB2064.namprd15.prod.outlook.com (2603:10b6:805:d::27)
 by SN7PR15MB4205.namprd15.prod.outlook.com (2603:10b6:806:100::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4713.22; Thu, 18 Nov
 2021 19:18:43 +0000
Received: from SN6PR1501MB2064.namprd15.prod.outlook.com
 ([fe80::a91b:fba1:b79c:812c]) by SN6PR1501MB2064.namprd15.prod.outlook.com
 ([fe80::a91b:fba1:b79c:812c%5]) with mapi id 15.20.4690.029; Thu, 18 Nov 2021
 19:18:43 +0000
Message-ID: <cdd2b65d-6be0-54b9-0c5f-1c425bc181c2@fb.com>
Date:   Thu, 18 Nov 2021 11:18:39 -0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.3.0
Subject: Re: [PATCH bpf-next v1 2/8] bpf: Add bpf_page_to_pfn helper
Content-Language: en-US
To:     Kumar Kartikeya Dwivedi <memxor@gmail.com>
CC:     <bpf@vger.kernel.org>, Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Pavel Emelyanov <ovzxemul@gmail.com>,
        Alexander Mihalicyn <alexander@mihalicyn.com>,
        Andrei Vagin <avagin@gmail.com>, <criu@openvz.org>,
        <io-uring@vger.kernel.org>, <linux-fsdevel@vger.kernel.org>
References: <20211116054237.100814-1-memxor@gmail.com>
 <20211116054237.100814-3-memxor@gmail.com>
 <7efcf912-46be-1ed4-7e12-88c2baeaab12@fb.com>
 <20211118183022.tiijkhno57uwtytm@apollo.localdomain>
From:   Yonghong Song <yhs@fb.com>
In-Reply-To: <20211118183022.tiijkhno57uwtytm@apollo.localdomain>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MWHPR22CA0062.namprd22.prod.outlook.com
 (2603:10b6:300:12a::24) To SN6PR1501MB2064.namprd15.prod.outlook.com
 (2603:10b6:805:d::27)
MIME-Version: 1.0
Received: from [IPV6:2620:10d:c085:21e1::1798] (2620:10d:c090:400::5:184a) by MWHPR22CA0062.namprd22.prod.outlook.com (2603:10b6:300:12a::24) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4713.21 via Frontend Transport; Thu, 18 Nov 2021 19:18:41 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 7ec88587-04f3-4a8c-58df-08d9aac83c2a
X-MS-TrafficTypeDiagnostic: SN7PR15MB4205:
X-Microsoft-Antispam-PRVS: <SN7PR15MB420550601F2865E72EE5D342D39B9@SN7PR15MB4205.namprd15.prod.outlook.com>
X-FB-Source: Internal
X-MS-Oob-TLC-OOBClassifiers: OLM:7219;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Rgtv0ZqTmSiVPLK9SIDtRBVW2cOUgzHtn+avl3T/GrtLBLl3Uv87bXe6JzpyoBAZN/Ly1XwE2mEDBeXH1sJ4hpjve5t2w1pF4jdAWBLEz39QMRcGRdfBzlAUv0smbqhYG098bmWXlaUKltmaYDRXOJZ69R4kQws0DwvSem882EBmVNJd3XKIm8uMxCxvd128VVpl6RpFdLtQiej1Jna3lZxIU3F2/roKdsnCFhSD6H/lgsehXRw79E4mMrl0cMSmwtesBxPxYQ0b/wVEqmt2T/vnqRhWhe4swMtt+SmRtNX3huAKbW12ld/o3rmZeb0plvdpO7/OWd5DEeYLgyXq7P/KGp2FK6kM/s4LnpX+fM773D3zZ4Rn33VZPmQKh8HCIRw8WWZQ21llttwRh1F5Rs4NaJvoftceQVAUMOg2bdQHJZ7JKGlLcyeDo0A6ot1xppUhNA4sFDA4jPhjp41HktdkMsbP+NmqpBWDZPr/NiZHleeqL6dPogYZgzZvWHdY5lq+oZ1bItB+TXDiNdXqfwmgRP25ZIKFlbtKN5WYV8yslavMealT0kbt4hemNeLi0lSNVPLpWHfyMRDQlj9mUBTL3F0aQPiAAQYqUpTGJMxYGmZ/7z6dAS2SNkCABT2//9vlhJfZaFH0ZZdRIDMdzqMsbVw8X3IvPq88PWhI1Wfdi8icNPTduTpYucHIDlZz7ou9PjBRNdtEavqXCkw6HjcHlsTTyktERQ54D5GR3fp4q9QpT9TQWwiJ/xIaC3ya
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR1501MB2064.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(66476007)(66556008)(53546011)(38100700002)(8676002)(6916009)(36756003)(186003)(2616005)(54906003)(316002)(8936002)(31696002)(66946007)(6486002)(2906002)(31686004)(508600001)(7416002)(52116002)(5660300002)(86362001)(4326008)(45980500001)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?bXpEMXIwK3BGK0VmbWV0Z3Q5U0gvTjB2bDJXQTBRT3BtQ2JFM3VhVldYZGxi?=
 =?utf-8?B?dGRacHRDRmR2TzdoeER3Um41NmVPRnk5b3EzOXBwR0E2RTlBcTQrWHkrRUZw?=
 =?utf-8?B?VDlYUEFqOEVDc05Tekh0c3lhTXpFYUpVVlZCNlVyZ2RxZDB3MHRMb0x5YTg5?=
 =?utf-8?B?TjU1TmJzWVYwRGs0UHU4SzdVKzJDdXlwMFdYVk5ueG00QWhoMW1XaTFVb1VT?=
 =?utf-8?B?NGt3WmptRFpxTnRBcFRyUXRsRnB1Mk1wVyswSVlnRlIzZGZ2RmtvenVJdCt2?=
 =?utf-8?B?Z1hGRnMycS8zZkhJQjdaRUhuMFZ0Z3pqZGZ3YSs0dDJWNjZ2djRGUSt4RW1s?=
 =?utf-8?B?QWFocjQ4ZmhROEg2dnlXT0plQm9kaStHb09jWG45WHVmWGhTRm14d01ERDMv?=
 =?utf-8?B?cHFPZG1MdWFrcWpaWmpYWlhZYk1DcVAycUhVNDFtcldBNXZtbDh0d3ltVXM1?=
 =?utf-8?B?aFJSRUN2VlhPRHpLRi9tRjFQZDZLMjloSktBWnJHbHVRb0pmS1VqOTVuWmRp?=
 =?utf-8?B?YUUzbnBBVDVGUHVSRllVZVMybkp6UjIxUEFOcCtxV3QzQ2dxbmNFMktDQTB3?=
 =?utf-8?B?dFB4Rm4wa3pJTUhLYkxQZVJDMUhXU3pLZmppY0F6MlgxNTMxa2hEZWNnWlF3?=
 =?utf-8?B?d2VtWmhWTTFFMHByQ3plYlVic1kxZGtxZ1ZiQ0g0N0N1clJMVTV1bmVKclhG?=
 =?utf-8?B?N0NuZG9CM1lEWmhlRFhpeGtZVUdMYitNY3QyVEJZWTdlOTkvRkpMYkY1TVll?=
 =?utf-8?B?ajR2WGVSWm9oZkxQZWh5d3kzemdndUh0SVVkMVhzdkRiWWtUbUNqSE5LanNW?=
 =?utf-8?B?cFRzYkJoZHo3ekk2Y3E4NWw4S21LOWNmV0diamRhVW1ySEVVakZxM2x1MmhZ?=
 =?utf-8?B?WFFmUG1nWG5SSWZ6VzQ5cVl6b1ZUR1lZSXlrNS82VXdoQzhBU0hTSGtnT1lQ?=
 =?utf-8?B?dDZocDNFYkNSOTdLTUV0bVd3RDVreHlteG5DUkRjNHppTS92QzlKZVRZb2E0?=
 =?utf-8?B?TDV6Wm5Vc013ZTllUHlHd1ozc3ZnRUxZT3laUnFoS243UWg1TW5jN2U4YmNH?=
 =?utf-8?B?V09JZ0dyNXpPN2JSOFpQRXZzQkVMd0NoSnRURUYrRTVqQUx3SUQ0d0IvR3Nv?=
 =?utf-8?B?OEd2ck9NUjVVd05xRVhDcklMZ2lwa2hTZkpKVGtuL1BKanRPdThoOENScHhY?=
 =?utf-8?B?c2dZOUFzWTZoTDNyeG9iT3dRSXlUT3c3NmhEVzNkNHppZHlJazM5ZE9WSC8w?=
 =?utf-8?B?KysrZ2Ura2ptRjQ2K3FMeTU4Z0UwV2phbVRFVGx4QmQ3bytMTnZRbFZFOFBX?=
 =?utf-8?B?R2poSWtJN2RsaGN2TnFDQXF3SCtLeGlybzJHOXpXRlh0UUlHVGlpUlQ2VmZP?=
 =?utf-8?B?dStndEtLQjc2TGpsUXlTcWtodEV1YlJhKy9ubGtqOWNVend3bEhxY2doUEVj?=
 =?utf-8?B?amx6UmJtV3VIUVBGU2djRW5KSmlMaHlpOENZWmxJM2dWRkxsb0Jsb0ZvZmpW?=
 =?utf-8?B?TGxuOFh1c1lyMmhCMGhnd1dtSVBsNGg0M0krRmVIWUwrWk9vN2JqUkVmYnhy?=
 =?utf-8?B?SGZoSE1ESy9zNlRYRWRwbWdMREdqZU1CMUFjamZyWWJFbC9XSkN6S2JVL0th?=
 =?utf-8?B?ekJPK1JDRERjdkFyODJONURQVHBWZm05VklEQnczL3N1dWZlRVpkUkpEU0FG?=
 =?utf-8?B?UDhINkt2NHhDc0tZdEM4QmEvN0JpUS94M0wvOTJKNmI1T0kzeTJ1ajFMUFZU?=
 =?utf-8?B?YkZCSTBZcDdTUzVIRGp1Wm1oSXpuY0JlcHZXSHhHTis5eHk5aFppUWpWdENS?=
 =?utf-8?B?OUZvbDZzczY2MFhiWTcyOG50RUx2YTdiQUVXd2ZXN2ZyYTIrSjF5WHJISE0w?=
 =?utf-8?B?N1JPeUUyZ2tzZ1A5TGdHWlRMUlQydjl4VG9VUytOUmE4K3ZSanI2Tk1xRGFN?=
 =?utf-8?B?TmhnbWJIZEhxajFCNEk3cDFOeDJ5dmNXN1Y1eTRyZGhpMnJFK3dXZUVqNEJH?=
 =?utf-8?B?Vi9UQjR2YjQ0WmRjZDR2K0wvVDQvMEw0NzBvaFN6YXF0SDJKZWNzNGFzRGIw?=
 =?utf-8?B?MDd4a0duUTFXdWt3dTF3N1dLZWtCc1MvTE9NUFcyb3M4QjY4QXhHYUgyZk93?=
 =?utf-8?B?cXZ2NFd6ODRKbTFUbU1wRzUxR0cvSHltZnZzVDNHR2NHNSt4MmxiQWFjUDlj?=
 =?utf-8?B?bXc9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 7ec88587-04f3-4a8c-58df-08d9aac83c2a
X-MS-Exchange-CrossTenant-AuthSource: SN6PR1501MB2064.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Nov 2021 19:18:43.0634
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: mmndDOw38he8M2C1BLDKgBcPZetPNpKE37LHiORCAuBQ4rlrnjD69PG2L+FrSHOo
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR15MB4205
X-OriginatorOrg: fb.com
X-Proofpoint-GUID: I2Tf094Skwk8kFRQByM2dkuTuIgS07YX
X-Proofpoint-ORIG-GUID: I2Tf094Skwk8kFRQByM2dkuTuIgS07YX
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.790,Hydra:6.0.425,FMLib:17.0.607.475
 definitions=2021-11-18_12,2021-11-17_01,2020-04-07_01
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 clxscore=1015
 suspectscore=0 lowpriorityscore=0 mlxscore=0 malwarescore=0
 mlxlogscore=999 bulkscore=0 phishscore=0 spamscore=0 adultscore=0
 impostorscore=0 priorityscore=1501 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2110150000 definitions=main-2111180102
X-FB-Internal: deliver
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org



On 11/18/21 10:30 AM, Kumar Kartikeya Dwivedi wrote:
> On Thu, Nov 18, 2021 at 10:57:15PM IST, Yonghong Song wrote:
>>
>>
>> On 11/15/21 9:42 PM, Kumar Kartikeya Dwivedi wrote:
>>> In CRIU, we need to be able to determine whether the page pinned by
>>> io_uring is still present in the same range in the process VMA.
>>> /proc/<pid>/pagemap gives us the PFN, hence using this helper we can
>>> establish this mapping easily from the iterator side.
>>>
>>> It is a simple wrapper over the in-kernel page_to_pfn helper, and
>>> ensures the passed in pointer is a struct page PTR_TO_BTF_ID. This is
>>> obtained from the bvec of io_uring_ubuf for the CRIU usecase.
>>>
>>> Signed-off-by: Kumar Kartikeya Dwivedi <memxor@gmail.com>
>>> ---
>>>    fs/io_uring.c                  | 17 +++++++++++++++++
>>>    include/linux/bpf.h            |  1 +
>>>    include/uapi/linux/bpf.h       |  9 +++++++++
>>>    kernel/trace/bpf_trace.c       |  2 ++
>>>    scripts/bpf_doc.py             |  2 ++
>>>    tools/include/uapi/linux/bpf.h |  9 +++++++++
>>>    6 files changed, 40 insertions(+)
>>>
>>> diff --git a/fs/io_uring.c b/fs/io_uring.c
>>> index 46a110989155..9e9df6767e29 100644
>>> --- a/fs/io_uring.c
>>> +++ b/fs/io_uring.c
>>> @@ -11295,6 +11295,23 @@ static struct bpf_iter_reg io_uring_buf_reg_info = {
>>>    	.seq_info	   = &bpf_io_uring_buf_seq_info,
>>>    };
>>> +BPF_CALL_1(bpf_page_to_pfn, struct page *, page)
>>> +{
>>> +	/* PTR_TO_BTF_ID can be NULL */
>>> +	if (!page)
>>> +		return U64_MAX;
>>> +	return page_to_pfn(page);
>>> +}
>>> +
>>> +BTF_ID_LIST_SINGLE(btf_page_to_pfn_ids, struct, page)
>>> +
>>> +const struct bpf_func_proto bpf_page_to_pfn_proto = {
>>> +	.func		= bpf_page_to_pfn,
>>> +	.ret_type	= RET_INTEGER,
>>> +	.arg1_type	= ARG_PTR_TO_BTF_ID,
>>> +	.arg1_btf_id	= &btf_page_to_pfn_ids[0],
>>
>> Does this helper need to be gpl_only?

The typically guideline whether the same info can be retrieved from
userspace. If yes, no gpl is needed. Otherwe, it needs to be gpl.

Also, the helper is implemented in io_uring.c and the helper
is used by tracing programs. Maybe we can put the helper
in bpf_trace.c? The helper itself is not tied to io_uring, right?

>>
> 
> Not sure about it, it wraps over a macro.
> 
>>> +};
>>> +
>>>    static int __init io_uring_iter_init(void)
>>>    {
>>>    	io_uring_buf_reg_info.ctx_arg_info[0].btf_id = btf_io_uring_ids[0];
>> [...]
> 
> --
> Kartikeya
> 
