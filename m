Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7AF4E47C903
	for <lists+io-uring@lfdr.de>; Tue, 21 Dec 2021 23:00:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237672AbhLUV77 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 21 Dec 2021 16:59:59 -0500
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:57168 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S237693AbhLUV76 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 21 Dec 2021 16:59:58 -0500
Received: from pps.filterd (m0001303.ppops.net [127.0.0.1])
        by m0001303.ppops.net (8.16.1.2/8.16.1.2) with ESMTP id 1BLKleOb001498;
        Tue, 21 Dec 2021 13:59:57 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=facebook;
 bh=1U4KsZ4xWwNGQfRQGywAKf+3SyJgUfjbDIvqBntsJjg=;
 b=Pgt/Y3YW8q9HWiPH6FxHDmjBcmhrDzMb28BPwWEBbn1QpM9mSlCTpacdaHsjp853tylT
 Mu4u0rqjya+YX1h3HCCR7AZvAbVYPXOSDIadgesY4pk1Ibayw/jke5/yWELeOnhX5Jho
 PmRDR5Xk9ZKNo/+fNMZZ45RGePsFsofxZKc= 
Received: from mail.thefacebook.com ([163.114.132.120])
        by m0001303.ppops.net (PPS) with ESMTPS id 3d3p930g8r-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Tue, 21 Dec 2021 13:59:57 -0800
Received: from NAM02-DM3-obe.outbound.protection.outlook.com (100.104.98.9) by
 o365-in.thefacebook.com (100.104.94.228) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.20; Tue, 21 Dec 2021 13:59:55 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=MbO25Y98kZf6nj1SVutqOqI3H4wvYGVbvEOsoGq1MecfNTMt2oMJdtLdYtuuRHnnpOEHjjKvHcIriRUp14Eykyz2Z9CZXOOK+Vm/wnmGA2SAfUl96ZSGPK/1InbbZWkM5OWk4M85MQQvmyBJnU1GEUrlI701rkOM1Sp93YME4DlqHzFtNQhpWxu4YicCjJWvgAETfkN5r7+oH9H9pFyakwpNapPAQAAYKTMbe45jGN4GlUn3ZmDe5NG7H0T0Iqu8u+oSzH5lELu2D33+9CL12NHIxfdhCjuyfnfShP3HboksR2BUKsveOVe0/LFtUYsL2Jk2rnboVibrvzLO52oD4w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=1U4KsZ4xWwNGQfRQGywAKf+3SyJgUfjbDIvqBntsJjg=;
 b=HtO/dPdkax/shh3511R5xcQoC8Nkjg10Lz2GA4LpLyeLxPYQ3hoMcwLAIXmYLkyIbnBSzpyuubHPJr9sU3c5d/R09iD+YJtT3+Frv45XvORH/R23E5wtPrlVt7Lz1Qlr+1WSO+r+W9PVzIE6dorHf3uIOra/z1huPZSd2Lj0/An6LYUVA+FXBq70WXzaF7SvZYYfrRVKT1aM4UAOrpZkfikjAvLKZnGfrpe1MUcZyetdfVRBI0E75yfMkRYvoIo90EMS1sqgdIAnWxF3FEXMA1JyFGrhslQq9PJ3UxeYrjs4Jzpw1XINVdoD2m3ZV5kKfGREPZSUyWvLOcfWWh/6PA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
Received: from MW4PR15MB4410.namprd15.prod.outlook.com (2603:10b6:303:bf::10)
 by MW3PR15MB3756.namprd15.prod.outlook.com (2603:10b6:303:47::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4801.17; Tue, 21 Dec
 2021 21:59:54 +0000
Received: from MW4PR15MB4410.namprd15.prod.outlook.com
 ([fe80::989e:71eb:eac8:1f72]) by MW4PR15MB4410.namprd15.prod.outlook.com
 ([fe80::989e:71eb:eac8:1f72%7]) with mapi id 15.20.4801.022; Tue, 21 Dec 2021
 21:59:54 +0000
Message-ID: <aff6327e-9727-e1a5-79bc-99557d9086aa@fb.com>
Date:   Tue, 21 Dec 2021 13:59:51 -0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.3.2
Subject: Re: [PATCH v5 3/5] fs: split off do_getxattr from getxattr
Content-Language: en-US
To:     Linus Torvalds <torvalds@linux-foundation.org>
CC:     io-uring <io-uring@vger.kernel.org>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        Kernel Team <kernel-team@fb.com>,
        Pavel Begunkov <asml.silence@gmail.com>
References: <20211221164959.174480-1-shr@fb.com>
 <20211221164959.174480-4-shr@fb.com>
 <CAHk-=whChmLy02-degmLFC9sgwpdgmF=XoAjeF1bTdHcEc8bdQ@mail.gmail.com>
 <a30eda4f-ebf2-5e46-d980-cd9d46d83e60@fb.com>
 <CAHk-=wjqUaF=Vj9f44m7SNxhANwoTCnukm6+HqWnbhhr2KHRsg@mail.gmail.com>
From:   Stefan Roesch <shr@fb.com>
In-Reply-To: <CAHk-=wjqUaF=Vj9f44m7SNxhANwoTCnukm6+HqWnbhhr2KHRsg@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MW4P221CA0014.NAMP221.PROD.OUTLOOK.COM
 (2603:10b6:303:8b::19) To MW4PR15MB4410.namprd15.prod.outlook.com
 (2603:10b6:303:bf::10)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: b39ab603-a53f-40cc-20d5-08d9c4cd384f
X-MS-TrafficTypeDiagnostic: MW3PR15MB3756:EE_
X-Microsoft-Antispam-PRVS: <MW3PR15MB37566986C0B30BA021753141D87C9@MW3PR15MB3756.namprd15.prod.outlook.com>
X-FB-Source: Internal
X-MS-Oob-TLC-OOBClassifiers: OLM:4125;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: OTw4iGn9lNg9oAHP7kTNZyXBbof0KXnvmD5Os1odociReVGNGtgP6xZHZB6bEXX+kb4nT23bFwmmyJn+Uwyand+DZKG8imlfQ2BGqA5KpkOPhDWiXDHrWNEjzpcOJydrPRpQTvp8QZ6zYeAHbPJe3mUNTweVv5KSc4rlGouKETCv2fPDee+O53gyGxlKsFvc9Bfufy08/gneC/vZeYVWsHOoy0aeFnZWGR/iWNNP035hAOAC8abzLadtpK3148PxUgKQAulI+8fmkBebu/Ix4K3lpuGonepFry5V21xS7aR8DZydbaHwO946Gl+9kQ8TPL8RAKH/VHH57sgdJqq0wKu4fo+VgMaxEQTI+00bF1XY+vy+shTqQLRnnrMwOMhmf6DGcYNovxi55Yym5E4XXuuB6H6EodTu4b7jjZrqtDV7NXwN60M80j282TfQv6NE1fJFbAR4psmXu5WZ7MUbj1Y9HZxmhWvP+SUPvJlvtu4IhZb+YvImetaYq78V2xweZv0P0L3nV6J0sw51SAd6pGybBSwExlCugdn9+gBJ/3LEkuS8OtDLYEVn8ng8Sc+0KbMy63ZQllyicDUz6F1NBmiPBgShg07Dwx3pg5qCxOTy6PBXfSDHOWK3jyP2dr42+K38C84L5u6fHlK5BNnifustPZYkpIfT68JImT1rx5OVMYpqgIeT9StUbi+NyYEecv4KWqmke7IVU7/nThQatbt5KxgQKdTpvI8iI0sBzyU=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MW4PR15MB4410.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(66476007)(6666004)(83380400001)(186003)(4326008)(8936002)(316002)(66556008)(8676002)(36756003)(53546011)(2616005)(6506007)(66946007)(6512007)(54906003)(4744005)(31686004)(6916009)(38100700002)(2906002)(6486002)(86362001)(5660300002)(31696002)(508600001)(45980500001)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?VU9xRzcvUDNUM1hhRHRNUWJCYUVza3RsbWFNa2tVOEpnZ254Sm1jSFdkR0Fj?=
 =?utf-8?B?cjlMaVo1UGdKbFlaREZZU2xUSFZ1L1orT2xseHBld0VhVFIxc1ZydFpNRTF1?=
 =?utf-8?B?YUluSVRIemRrRzFRQ0c0ZFY5MTcwVWJicytzQnJBU3B6bWFLcWVISmFzODBv?=
 =?utf-8?B?UTBtY1ZEV1lSZ1hMSnlWWk9QSlJzcTcydG5zVFJ4WC9XR2RScm1UWXRTODlJ?=
 =?utf-8?B?N3dkbG5LM1dhQXpvWUw3VWIycFVRNXEvMDY4TzlGNktXRmx2aUtQUGN4UDBY?=
 =?utf-8?B?UXhBUGZJdHg4VEI2aWQrY2hFYzBLUmx6Mkh6VTZJZjEvYXFRVmp2RnZyQUxv?=
 =?utf-8?B?SW5HeEREZlRPSEc5SlRHM1ByR1lXTm1nVkxPSkxuN0ZPQzg4TGJKanYvSnB1?=
 =?utf-8?B?TTBpajZJdXR3R1VBOVJoVno0U2xLSXlWcERJUzg5d3Zjejk2bFozZzIzdTZW?=
 =?utf-8?B?RlE3UDFpMWtaODFLaktSbVdhUTdEM1NEeDhkRGFHUmwwTFkzZmRBSkk5RUw0?=
 =?utf-8?B?QjMzYTFxOExjd0JjSC9uQVhVUVNGQy9XcXNtTE8rTVFjS1VLYjJRNEJVbG5u?=
 =?utf-8?B?b1RiUWpRMVpIc3NOUXlFZTdmd1oweVBqNTVsaGdLU3lPY1pnbEtQd3drVFg0?=
 =?utf-8?B?V3NNeXdwbHBrYmhxb25jeDRTczFaazhhT1lSQTFsazltSUhWeTRLUlRRSHN3?=
 =?utf-8?B?N1VJRmZmUzJaWUJiUi9naGFLRjhlQml0MXJYOFZDOUNzcFRyTDZjN04rWm1Y?=
 =?utf-8?B?emhWVy93dE1paGlwSHRJR2RKSThHaGxTZHBVYlBib0hqTXB0dWpYQ2NJYkkr?=
 =?utf-8?B?TGkrb2tGNEd1bjlnZzNLYjlweHRGQmpyOHVJTTBGZS9SU29EL3lPUHVRaHc5?=
 =?utf-8?B?VWp6QkRCcVFmV2F0YlFhYmhncG1kSGMyTkZlVDdhUnNkalZTSHcrSGIwUDZW?=
 =?utf-8?B?Y3RHUXp6ME16R3lWOE1nOC9BLzZrNzFtTjFxM0dDaEdzaWF5a1l3aklEYmxG?=
 =?utf-8?B?RnRxSEF0czZMeE5LOStWQnN6bEJMSDFBaTJyYlB0eXBucTNYMllDblE0eEdw?=
 =?utf-8?B?K3V2ZjMwZUorR285RjBSNiswUlQ3WE1FRVNIaXVqNGpvRkdMSEJjL0hrQ2tm?=
 =?utf-8?B?ZkZsei9nS3FWZzRBVnNTVERvNERvVExRODFieG9Zc0w5bUk0enpMYklPcDV1?=
 =?utf-8?B?YXVvTm9mVjNmSkZQV1o1Q3hQOWtTM2xQUVYyRkt1WmhCaDgzRjNNcEdjd3Zr?=
 =?utf-8?B?QU41V2VJMFJYVjRieFd1N0c4Ri96V0RveDg1dkl2ZHpyQ0VDODZ0SWxUMzdy?=
 =?utf-8?B?VkNTS2VISU9nYWEzOGZodTJFMDk4YUVvMVA1WUpnNEN6Ky9TRzgzYW5wT0tC?=
 =?utf-8?B?VnJ6K3ZJVU9yeCtFRVI0dzd2NEF6Q0FDbkk3bXlqcFU5elhma210QlEveWNF?=
 =?utf-8?B?djl6Vkh0S0kwTkF3N3VTQy9wSmhlSFo5Q1pLK1lzZmczZ1lTMWU0aHh2NGtG?=
 =?utf-8?B?WVk2L29sR2ZOODdUQ2dMVjREcjVlRHFYRkNBQnRWRWp3SnVacXcrVDNhNm11?=
 =?utf-8?B?Ui81cytVbkg2Sk9pQldHTnpra1dWN1V4VDdUdnJ6ZDEyNWU5SzN5SlJZS21T?=
 =?utf-8?B?bmpEL0oxaTZpcG80d2NLajVsWW42Qm5nVFVWd1F3YmVLeHJJTDlMN1Q5cFIv?=
 =?utf-8?B?dk05QW5neEFDTTVqd1BWNGhoSGZiYVFFOWZnMjZXNnArMW56S1BhMEpmWExD?=
 =?utf-8?B?TStZUE1mWUMvM0JqK3oveFpRQ2FqYisxa0x0RFBCS2xXTXBXSFpKekJ0VXY5?=
 =?utf-8?B?ZStFZVMxME1rZkl2K0VoM2tNYXB1SkdpSTN1S2N1OW5pRnhudUtqYzhNNGpS?=
 =?utf-8?B?K0gvUStQaWFUbUd0K3ZwWVd1UHVxRGVEZVV1WklpNEZncnNXdWkwVzBmL2Fr?=
 =?utf-8?B?L25QeEFtWWs3cFBCYmpxV04zcTNVT0dGdHd2b1E3N3lEeTJ1aWRSZzY3a25L?=
 =?utf-8?B?azMvaks4Vkx0R1Nkdnl3UE5Hd3FVdERXOXZYV2ppdE9EbzBMVFhrVis3M095?=
 =?utf-8?B?VGRrYXA0VGhPV1YvOE1xNjRoNmxTWmtIRndPQTViQml2T3NXWGJ2aWZKT2pz?=
 =?utf-8?Q?xBMW0OeQZERYxipFxxffNP89s?=
X-MS-Exchange-CrossTenant-Network-Message-Id: b39ab603-a53f-40cc-20d5-08d9c4cd384f
X-MS-Exchange-CrossTenant-AuthSource: MW4PR15MB4410.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Dec 2021 21:59:54.3716
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: p+tymvf2Z4C/ngY68xwi7arVFxOXgOW8wdgy3Q54VRpeMSZPn1Vb9R1AvPAy8FJ/
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW3PR15MB3756
X-OriginatorOrg: fb.com
X-Proofpoint-GUID: 4qi9Mng4HclbZA3XcGZJ5EO05fGztfpm
X-Proofpoint-ORIG-GUID: 4qi9Mng4HclbZA3XcGZJ5EO05fGztfpm
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.790,Hydra:6.0.425,FMLib:17.11.62.513
 definitions=2021-12-21_06,2021-12-21_01,2021-12-02_01
X-Proofpoint-Spam-Details: rule=fb_outbound_notspam policy=fb_outbound score=0 mlxscore=0
 malwarescore=0 bulkscore=0 adultscore=0 lowpriorityscore=0
 priorityscore=1501 impostorscore=0 suspectscore=0 spamscore=0
 mlxlogscore=855 phishscore=0 clxscore=1015 classifier=spam adjust=0
 reason=mlx scancount=1 engine=8.12.0-2110150000
 definitions=main-2112210108
X-FB-Internal: deliver
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org



On 12/21/21 11:18 AM, Linus Torvalds wrote:
> On Tue, Dec 21, 2021 at 11:15 AM Stefan Roesch <shr@fb.com> wrote:
>>
>> Linus, if we remove the constness, then we either need to cast away the constness (the system call
>> is defined as const) or change the definition of the system call.
> 
> You could also do it as
> 
>         union {
>                 const void __user *setxattr_value;
>                 void __user *getxattr_value;
>         };
>

Pavel brought up a very good point. By adding the kname array into the 
xarray_ctx we increase the size of io_xattr structure too much. In addition
this will also increase the size of the io_kiocb structure. The original
solution did not increase the size.

Per opcode we limit the storage space to 64 bytes. However the array itself
requires 256 bytes.
 
> if you wanted to..
> 
>                  Linus
> 
