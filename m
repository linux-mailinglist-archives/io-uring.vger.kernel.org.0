Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8F9D347C747
	for <lists+io-uring@lfdr.de>; Tue, 21 Dec 2021 20:15:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233446AbhLUTPr (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 21 Dec 2021 14:15:47 -0500
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:34262 "EHLO
        mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229659AbhLUTPr (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 21 Dec 2021 14:15:47 -0500
Received: from pps.filterd (m0148460.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.1.2/8.16.1.2) with ESMTP id 1BLIvYDK011827;
        Tue, 21 Dec 2021 11:15:46 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=facebook;
 bh=c8bDkDHhccs+RKJe2OYo4AIIpnHaAN+QP+AQ9+GFhig=;
 b=BjQQmERk8RFZdi6JaHn+53c0u6ChkIiia0QWi3h+mJerFYCfaFgP90vK+y5Ehtrqcobd
 fFdfYDyrPeHXUmsBeZu9dwFikFLYjLlJObuM132TpgMo3jkjiWH9xtzNMgwIKUKlL0Ao
 szVRMRF+Mhuck9CWHcaKgWBZ+gEG3QejWww= 
Received: from mail.thefacebook.com ([163.114.132.120])
        by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 3d3dm83fpq-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Tue, 21 Dec 2021 11:15:46 -0800
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (100.104.98.9) by
 o365-in.thefacebook.com (100.104.94.199) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.20; Tue, 21 Dec 2021 11:15:44 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=XZXkvU8RpM1dS2BE0Bgi1HHolxb47dKgTggm2qnMF6/utL3koPNTo7ZX3yrnvC5uQ3q+zwxuk6hL/7ahbsPfOUf0fqtkLC8Wh5c8/YPnkOM5jOCuHmnOObffkdzdupLUrNe5Odz4i4nv6spfkqzhLfEKUxcJN4o+dDArQrRmA2wMqONFejkZwooQBUx/Rwm/PJOfa5GZgWcK8t5btIBxBvL2Vy4UN5I1B4nvsUKUxBL8kMpOyRGo/gwELi88CQYtJ7T1ohrhvOLkcPscw9xn57Yu7Y8a9E9ffgEsjvtTzdp8Gfe8RH9NhStkpzzD7Oi72B9vLLQvTPOJ/MCN333uYA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=c8bDkDHhccs+RKJe2OYo4AIIpnHaAN+QP+AQ9+GFhig=;
 b=cQ53lSGkPekRRi8ZYh/o0etDU10l4bdEmmBUer/cUU99zEG6Xb9h+9MOjLeyKFQn7im6il1uGWlSwag9k/J9HaydgRrPgilM9kQ3Z+fj2OLraSkEo7Td5cv59c81h8DHHgdYVx74Cwly2H6Rbym675//989X8CT/YJbnRnDkNRNkkGKN5KgtsggBOnzbXdbNvdExTQ9oQ5bAuItMejS2gl0hVQP1qYyZMYFecMaqkt8j1FF29f4XgMfuL0rfyWvsPkX2TWalrOPIYibSPocZ27UnbIfFm7CXIH4z3ggRUknEsAopL1wLXc5CkGDoQctJY7FRb64+ksrP5VRKecn9Pw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
Received: from MW4PR15MB4410.namprd15.prod.outlook.com (2603:10b6:303:bf::10)
 by MWHPR15MB1903.namprd15.prod.outlook.com (2603:10b6:301:59::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4801.14; Tue, 21 Dec
 2021 19:15:43 +0000
Received: from MW4PR15MB4410.namprd15.prod.outlook.com
 ([fe80::989e:71eb:eac8:1f72]) by MW4PR15MB4410.namprd15.prod.outlook.com
 ([fe80::989e:71eb:eac8:1f72%7]) with mapi id 15.20.4801.022; Tue, 21 Dec 2021
 19:15:43 +0000
Message-ID: <a30eda4f-ebf2-5e46-d980-cd9d46d83e60@fb.com>
Date:   Tue, 21 Dec 2021 11:15:41 -0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.3.2
Subject: Re: [PATCH v5 3/5] fs: split off do_getxattr from getxattr
Content-Language: en-US
To:     Linus Torvalds <torvalds@linux-foundation.org>
CC:     io-uring <io-uring@vger.kernel.org>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        Kernel Team <kernel-team@fb.com>
References: <20211221164959.174480-1-shr@fb.com>
 <20211221164959.174480-4-shr@fb.com>
 <CAHk-=whChmLy02-degmLFC9sgwpdgmF=XoAjeF1bTdHcEc8bdQ@mail.gmail.com>
From:   Stefan Roesch <shr@fb.com>
In-Reply-To: <CAHk-=whChmLy02-degmLFC9sgwpdgmF=XoAjeF1bTdHcEc8bdQ@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MW4PR03CA0120.namprd03.prod.outlook.com
 (2603:10b6:303:b7::35) To MW4PR15MB4410.namprd15.prod.outlook.com
 (2603:10b6:303:bf::10)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 03630fb2-a5ee-44a5-a742-08d9c4b6489d
X-MS-TrafficTypeDiagnostic: MWHPR15MB1903:EE_
X-Microsoft-Antispam-PRVS: <MWHPR15MB19037F03B888B359726C06C5D87C9@MWHPR15MB1903.namprd15.prod.outlook.com>
X-FB-Source: Internal
X-MS-Oob-TLC-OOBClassifiers: OLM:5797;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: yL5lZA/+6u3aAEMKX1kUApt1Mc38o4hJtTplCcML7ZJ0HWy86506Bx8rMbhbS9l1VEvXerX5aHpR+KiOEKqisYgEYenx1s/yweHcEMEcmNjVuBCCpy1mjxzJDjn9vOe5Ju5lxGp633RqkmuWcoklT9WbFchSg+vI7xIOCQDVboerq67V97GJZeZjX9mQDOlDROG1hE+2/f9pxDRkSwnbsJ/aSqhRPDj1AjDhAR/robBYYlOet7kkLDE8iEyRivXBQW0mxm6dse3Xum+yskYI062K1kbddzUTyrDIfPl1eEUmfgy1xfysUeH5maKLQJgzQNRFXQU4vmIRQRwQlr6gn2yYOt1Rh19xEPhSGIYXvQbnI4D2juWqRVc6jbqgx5FprliqXkHp2vbTqbo5xnjDQsIBX/tRDNQhvfnLwX48zxFSV5+BHlXuM2Mtc+siGlT4Fy5aF6W1wyej0oX9M/SGRhAGCLfDDosHPearJJ2Slt2cKp/aZdxZl+p0Ix3AfMil1ztXuAhkfi6cg7/HhWe2kdXCd3AzUy3dgqs1dfltlIBXyFSqhB8eKpnKpzFQSphVuL2cP3eQCu6x+UDpfehLMjYmIJzSN1t+FvQEw154Y8qwWk3uBtkchPAs8qtD+EytFfzz6miKwA1Hd+Go5ZYs1hdHPl+wBNABfL9wpmYLJXCZsutHflb8y+ZbXs8k4KhvCZX28sGhVsI0JKcJ1OkC8/pzlekSWfiaqrtb535sVu4=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MW4PR15MB4410.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(66556008)(6512007)(2616005)(38100700002)(54906003)(4326008)(508600001)(36756003)(8676002)(8936002)(31696002)(66476007)(6916009)(31686004)(2906002)(186003)(4744005)(316002)(66946007)(6486002)(53546011)(5660300002)(6506007)(86362001)(45980500001)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?b2F3R2d2U0N1aENVa1NkMTNzWi92OEc5eTNVckdxSGdPbjV6SVlheHZvZkVv?=
 =?utf-8?B?LzROSEdlYTFYM0NTWUVZYXNjTjdwcjV3dm1mSG04YXlTa0dqeUZGSEpPUVBM?=
 =?utf-8?B?RVRDeWpkdzVTRUJMcFIxZ2lTZTZ0VWlmMExsVktwUDRsM1ZIQ3E2RWJQUnFT?=
 =?utf-8?B?aFdnbWNLcXFLcWJPZEtjcXVqbXMxS3lBWkxLWTcrQmFMRDJ0SURrR1VkcnVT?=
 =?utf-8?B?L01EZ3N2ZnR1emFkQ3dPdXQzWS9KSVFyYVgzUjZpV1RLdkU4eitNeTE4RVFC?=
 =?utf-8?B?MDJJcFM4LzB6RHNOanVkUXVTaHpydllnYXJIREwyaEZ0c0kyMFcwSllVQ0pB?=
 =?utf-8?B?N3dHeTJxTnh4eFVEZFJMSnNCZVJTZVQwekZuaXlmYkNhV3Z5U040UDVublRm?=
 =?utf-8?B?U2xxMXZwNUI4cHFjRHVsTW5ydHBrclJycldPVndESnZ4clBacGx1RkxDWm51?=
 =?utf-8?B?NzROUkEvaWlYaEFoLzBobmVlekpyS1A1cG1XSHZnVFlOQlU3N2pVNVF6ODho?=
 =?utf-8?B?SmRzaWFnQnVNc1hDbGQvL2FsaEw1eU9vMjY2L1pyM0NYSGoreFRrNlEzTkpr?=
 =?utf-8?B?bXBRTjM2NjEwYzhBRGlMcitQRiszVWE5M2tiYVlsU095ZTQ0d3BxRTBid09Y?=
 =?utf-8?B?NVU1MTFFTXlMQnNyTm8xWmFINkNQcWoxSk9CSFhBczRHbjVZbDgzaG9rZzlE?=
 =?utf-8?B?bnF5a21nK1l3WiswUTRyQmFFeXhueGpqMGlHQXhEQmlENWczQ2tmNHNVWUp0?=
 =?utf-8?B?MHgxcUx4bWZNUEdRYTVHOHpoNVpHam0wS2ErVzJFbG13WGx3d3RaM0VTalVT?=
 =?utf-8?B?Q1R6bUVSZWNFS2d2azl3NVRBR2RMdlNjVFRJOWkxd3ErNDJIWUxFOEN4dGcx?=
 =?utf-8?B?WDFNYy93M29yaDA3dDU1T3RVc09wd2gxUzRVbTA1bExROUQrNklJYXF2Q3FP?=
 =?utf-8?B?Y3hxTjVUR0sxeHFVamJoUzlOdDlqaDVwU3ZKUzJyYksyamhUekN3QzJaKzVW?=
 =?utf-8?B?TTZkRnVhQU5sU3FNRFNtNjVyM3JHYzZxWmcvd0ZzbjBWRml2UDY1N2xSNlZj?=
 =?utf-8?B?QUI0emNDbkgwSVEzR1RSTVFzb0F4OTByZjlNUklPMlB0K3MrS1lyUmkrL1pV?=
 =?utf-8?B?bU1YT1lBZHVQcndZZnR1QUFydDNsUnBwU25GZ2dnTHF2ZDUzejFMU0dTRE83?=
 =?utf-8?B?SnlYMldtU2tVYi9xRU4zNVZZeURsNlMvekQ4QWhZNDgramdMcGU5WjJhTTRt?=
 =?utf-8?B?NFdkT1JOdys0eWpwT0RKd3p2ekg2OHFCcXc0TFNMK2Z0QllYZVB6YnJPR25M?=
 =?utf-8?B?WFBFc0dYUnJJWHk0YVVmYzZJZnZBZm41NlJvQThnU2R6eGJCYjdXa05abWJ2?=
 =?utf-8?B?VjJ5a0ZHRlZJU0w2RExHYld3NXltbVZGcEVFYjBMZm5GRGlSTkUyR25VS1g4?=
 =?utf-8?B?MThveUhXZERJSG96MjdHd05KempQVkJzaS9ScGRjcWM5Zk5acEpCc1lZVTRy?=
 =?utf-8?B?R2U4cU0yekJNK2JoaHRETWZzazNwZEtRazdLUXRuTkRNRUhudFp0aGFzYkds?=
 =?utf-8?B?TkdKbWpmSVpEbjRVZEhhYmpQem9yaE54bzFIOWlHN2JoZlJTRGNBOHcrbjRy?=
 =?utf-8?B?WDErSEpWeUxJOFdHNTJRTzNFMlZXUDlHQkVrSWxmQVNqdTJsaEhBbTdrenNj?=
 =?utf-8?B?Rjg2NFRvVFdVZGtZUkFoUG4wSWZiTE53aXdBa2FJWjMxL040RitWNHFkKzdq?=
 =?utf-8?B?Z2dsL2JLTDF2bE9rdzNTN3NBSk1XRStUdXcvUEczWEs1YXhwYnhKYlBVbHh5?=
 =?utf-8?B?SUI0WlFGOWE1TGw1SGF1TEFFT3ZPY2Erb08wY00yU3lUMW9WQjBqMzh3Tjh3?=
 =?utf-8?B?MUtDM1JvK0FLS2tTcnlpR040eWR4RjV4SE8rbjlFd1JIYVdEcG1oeUdlNkJw?=
 =?utf-8?B?Y0Q0aUVoU3dVQVhYNDBaUVJMc0MzUjBFYmdCaVBGNUFMOWh3eHViRkJneEQw?=
 =?utf-8?B?RVJ4d3diWEkxWVZUamJ3NGdQcjVUa2IwUFkwM0I1QUVzYjhOaUdVNXl2amNB?=
 =?utf-8?B?RFRGRlI2cGVhZVNiUFBUSS83YTFxa0RYZmNJYVN6QXpSclpyVDZkK2x5YjE1?=
 =?utf-8?Q?ykPhXNnwaZGwVTpcGwY/mIZ2N?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 03630fb2-a5ee-44a5-a742-08d9c4b6489d
X-MS-Exchange-CrossTenant-AuthSource: MW4PR15MB4410.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Dec 2021 19:15:43.2893
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 0QSO0ikoipNFut6wHW1hzXj+9Ep4gA8onP/uaknxmuehoSOSFxn0EskROUXqqDNZ
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR15MB1903
X-OriginatorOrg: fb.com
X-Proofpoint-GUID: UWu05yYF0Ddno1zx9_464z07QKmHJHjz
X-Proofpoint-ORIG-GUID: UWu05yYF0Ddno1zx9_464z07QKmHJHjz
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.790,Hydra:6.0.425,FMLib:17.11.62.513
 definitions=2021-12-21_05,2021-12-21_01,2021-12-02_01
X-Proofpoint-Spam-Details: rule=fb_outbound_notspam policy=fb_outbound score=0 mlxlogscore=996
 suspectscore=0 malwarescore=0 clxscore=1015 bulkscore=0 impostorscore=0
 phishscore=0 lowpriorityscore=0 mlxscore=0 adultscore=0 spamscore=0
 priorityscore=1501 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2110150000 definitions=main-2112210094
X-FB-Internal: deliver
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org



On 12/21/21 9:22 AM, Linus Torvalds wrote:
> On Tue, Dec 21, 2021 at 8:50 AM Stefan Roesch <shr@fb.com> wrote:
>>
>> This splits off do_getxattr function from the getxattr
>> function. This will allow io_uring to call it from its
>> io worker.
> 
> Hmm.
> 
> My reaction to this one is
> 
>  "Why isn't do_getxattr() using 'struct xattr_ctx' for its context?"
> 
> As far as I can tell, that's *exactly* what it wants, and it would be
> logical to match up with the setxattr side.
> 
> Yeah, yeah, setxattr has a 'const void __user *value' while getxattr
> obviously has just a 'void __user *value'. But if the cost of having a
> unified interface is that you lose the 'const' part for the setxattr,
> I think that's still a good thing.
> 
> Yes? No? Comments?

Linus, if we remove the constness, then we either need to cast away the constness (the system call
is defined as const) or change the definition of the system call.


> 
>               Linus
> 
