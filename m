Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 25562482017
	for <lists+io-uring@lfdr.de>; Thu, 30 Dec 2021 20:57:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240744AbhL3T5O (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 30 Dec 2021 14:57:14 -0500
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:53600 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S237051AbhL3T5N (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 30 Dec 2021 14:57:13 -0500
Received: from pps.filterd (m0044010.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.1.2/8.16.1.2) with ESMTP id 1BUJfuw7004865;
        Thu, 30 Dec 2021 11:57:09 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=facebook;
 bh=HEtkxo3SJUym0OTpnuPMRcpwsHoT6qTW0hhXJLYJM68=;
 b=fyBuuIQmGKRDzZB1ZoLqXP6WaPx7fJGMSuv6yrGuyx/PWKAaVojWM618ACqi3OGKmUAW
 UYvy1K7y6U1RHfOAcmsZvOLzvTTpl1uuQT3fhfd4XmtsQQ16nr+cKTnfLaSZKnKiduJ4
 mlzIOnjrodXVGMA0wE3tEBfQI49/6LLb5wI= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 3d8ghb2mcv-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Thu, 30 Dec 2021 11:57:09 -0800
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (100.104.31.183)
 by o365-in.thefacebook.com (100.104.35.172) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.20; Thu, 30 Dec 2021 11:57:08 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=obXaiXDk1nOnkcPiNbD11vJyCJVRFXa8vOGe2yfUeOy8+jXGdapQ9zWYPkK4I+lve8haIM0Vbq13n5+oslJGSfSmFa5E4W2slG70eP5t09RgQZf4jFiEy2rYo4IgdrgkQROqubhYj1oKVM6prypMxBRAeWRteyqGlBJLouRz/njpzopiDbkrdjdwi1HzHzz1R/UzuPpyXYJZV4TU9AJtDUnkL2iJ5rdTaetXEsZKClw2Yhy232m5GCmDXwHGmYzE9FmPIkV/sFE78+BEgOvSVwKJojyTwpQ0TVIxOtEUE1c1T7DHbXBR8Azav0OwFfJHtbHFLzhGMeKOtM7k7gGLVw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=HEtkxo3SJUym0OTpnuPMRcpwsHoT6qTW0hhXJLYJM68=;
 b=CUXqRo8ifjzcTB5SeBgCT/hIaMWls5ekE1G+c8vPY31vK6tp+guzgLmtjKVkuOWBsZUzGoG8dAimfWxre+ttrM3jA9D5Sq4EQu/94aDjrDQNC49GzHo+VQiHHT71ETLRFa2KIlc205vfVV1dSnk/KBPDzxWGsozdWabcTlAck2W2BOYJQoBn7cHoGD2VtzRRDMqUHy0hT6I5jKd09kFuRqdY2x9ERxefc0toCPI+r53CBr+qBF6SQ6cnEWQqHsxZYxVuwO7AgJnPvI+x7phjOwqR+4KL84f+hvMu7bw3hNGeRRs3uwHO9yzFY/VBfbT+MYSBazu0Wy8sqeV5kHCkvw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
Received: from PH0PR15MB4413.namprd15.prod.outlook.com (2603:10b6:510:9f::16)
 by PH0PR15MB4640.namprd15.prod.outlook.com (2603:10b6:510:8c::24) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4844.13; Thu, 30 Dec
 2021 19:57:06 +0000
Received: from PH0PR15MB4413.namprd15.prod.outlook.com
 ([fe80::31b6:7571:66da:5cab]) by PH0PR15MB4413.namprd15.prod.outlook.com
 ([fe80::31b6:7571:66da:5cab%7]) with mapi id 15.20.4823.023; Thu, 30 Dec 2021
 19:57:06 +0000
Message-ID: <51c8608e-fc03-7ca6-d086-41488a4f39c4@fb.com>
Date:   Thu, 30 Dec 2021 11:57:03 -0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.4.1
Subject: Re: [PATCH v10 1/5] fs: split off do_user_path_at_empty from
 user_path_at_empty()
Content-Language: en-US
To:     Al Viro <viro@zeniv.linux.org.uk>
CC:     <io-uring@vger.kernel.org>, <linux-fsdevel@vger.kernel.org>,
        <kernel-team@fb.com>, <torvalds@linux-foundation.org>,
        <christian.brauner@ubuntu.com>
References: <20211229203002.4110839-1-shr@fb.com>
 <20211229203002.4110839-2-shr@fb.com>
 <Yc0CBiduomJ8TCSm@zeniv-ca.linux.org.uk>
From:   Stefan Roesch <shr@fb.com>
In-Reply-To: <Yc0CBiduomJ8TCSm@zeniv-ca.linux.org.uk>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: CO1PR15CA0050.namprd15.prod.outlook.com
 (2603:10b6:101:1f::18) To PH0PR15MB4413.namprd15.prod.outlook.com
 (2603:10b6:510:9f::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: bcf223f8-e991-4d1d-7166-08d9cbce8e6c
X-MS-TrafficTypeDiagnostic: PH0PR15MB4640:EE_
X-Microsoft-Antispam-PRVS: <PH0PR15MB46404E36547A5B031E173576D8459@PH0PR15MB4640.namprd15.prod.outlook.com>
X-FB-Source: Internal
X-MS-Oob-TLC-OOBClassifiers: OLM:989;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 3nemihFWH5yuP24WcBhJOBILrmT+p60+3ujaYbER+e6X9qE8yJwmYkiP4hSlsLzoc2J5Ho1liwJxtlTUs9YQCF8ak/ygGE+msol+ozJP7WHm63WFs4CL5x/agJ80/zUShb97eexA2EVqHUMc7Etl7h6ZFCvBAVG5XHANRHzfp3xzaYTrNTsJXZlSbV2HA4z93fc37TL6VhKrt2YvNLa/pybZdIy6Hbrb7t53c3rh9ZkPu54vXilLiNSbT1E7WDriVhja0gD6NLFAR8Xs7383ZasYS9lx62DDWnNKvyFmRRw1NTuV2kqvLm0I8f+0gK1qN+GopB5d2q45UXbJAAQbfA9PG0uFK1EskoLc3ie6pLGqZaYkZVNqzDh1C7FLQrE49Husz9RKAg1++QyxqaOdVZnA0BMeBsqentdOwdS8rQGpPHL/A4X3Tf9zpSjVvbdthg0QeVrZxwQPLpZ09DK/zkevB1s5ywvrDdCJXKljxR6DVnfCNqB8a7h6rEybkycoHTAkrdGemIwP0Di/iRen+ucR8CpJawvHTxvKCGNAgUE8dyOVCfruao/tzB+H292Fm96GMCb7QbQlxdpPjcSP/8yRRIRWz50ul1d7FIZ1D4KgvPlot7LoDBCVMrTwY9M+xKzB1Kv77Oin+/wlUWSqMwFzk1f7flHTIP7v12O/Wudvk6vDLHm4ZIsikth0PGdUsWbDcwSqfKtzQsRC7wmnfCwHBp5H4+4DeBua9LsxByQ=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR15MB4413.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(6666004)(5660300002)(36756003)(66946007)(38100700002)(6486002)(31686004)(8936002)(4744005)(66556008)(31696002)(66476007)(8676002)(508600001)(6512007)(186003)(86362001)(316002)(53546011)(6506007)(2906002)(4326008)(2616005)(6916009)(45980500001)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?MGY0emJZTGZ6Nld2ak9RL2VBczhkK0NZQlVOZzR1MUVzWUQwYTY5bjM4ZmZt?=
 =?utf-8?B?Sm5HczdQMWdpV3FxUHJ4bWo5bjVrMFFCMHNMdmVZbndZcUtHRjY1VnBtdmFv?=
 =?utf-8?B?d1hnSm94Wjg4aXlIQ1pmVmRiZHpabStmQmVQeURJeXhIUjJaTFhEVVNuZ1Yy?=
 =?utf-8?B?bERNMUZjaUpqUGxPd2hMR2YrZzNZMm9XeDQ4VUJGU28vZlF3ejRzcEFrT1FL?=
 =?utf-8?B?dlo0VHpVb0VPc2NoZWZUYnVqWkovTjFUUzQrWE5nelQvWGJNcWlBUUhsbjNx?=
 =?utf-8?B?QVNFeDVkRFdUVnJBUE8xbWFsV1NPcjQ3ZGtHd0RsQnRISW96UE5BYXhFRXFt?=
 =?utf-8?B?K1ZqYlo3dnRaeG15L1dkOHkrMkJYclVFUmVMOWYzaWFLU1dPdVd4ZEl5NGVn?=
 =?utf-8?B?QjhwWnEwalcxU25sMXlvV0tvTUkwaHZOUlRCOUJqTytCeE9HOCtJZWRrbUQr?=
 =?utf-8?B?bEpkU2IxRWtrVzlWbGZHSXFmS0tVdW5wM0NUbzM5a3pYdGhHUk1BWUpGZHlM?=
 =?utf-8?B?RlFiVnU1dTBYZkR4VnJiSDJQZ1FBbFp5TW1BNUE4eFZlNG5oSTl6NDRBVFhq?=
 =?utf-8?B?d3paMmtTN004MmU5Vmc2cnRRMnljZ1BFbjJtM28xbEFtVE1xb0hZUTQxTnR4?=
 =?utf-8?B?YkNhKytDeGxmWTdjSnNNdjlpNUZ3c1RHQUNkcTQ5Q2hueHdzR09rRm8ydTE3?=
 =?utf-8?B?WWJjVEw3dlppdS9pSlhLSWZNdVJCNnlpMkhrenZmc0M5aW56a1lCVm1IYVBU?=
 =?utf-8?B?TXkwazdFeXhaU2JtY0JvYnNBeERrUDJOTlBSd1Y3NU1SV3JNNE9CUFd2Z0dF?=
 =?utf-8?B?OWJabmRneGxUenh1bWgzZktWb0ZCSGxmQWkwb240S3lGckM1dUI5dDA5KytF?=
 =?utf-8?B?bEdRdC9VZE1kL2VxYUJJRU9ocVE0c0JUSEs5OEdLY0dOUVBOMDI2bUgxNDhs?=
 =?utf-8?B?L2hMTVFqNzhabDNqN0loZ0kwdHJvcUd4WEZQaUUzVC9UNkFpY2ZPR3BXd0ZN?=
 =?utf-8?B?bndja3FIaHhrQXRWVk5DSzFoNkpFdUR0RnoxWEpLc2JCRTArekJURnhYc0pl?=
 =?utf-8?B?QnJWcGVsZEdhNWdrT3FSRVptNUYwVVQ5TnY3VWgzdGxYbXNla1huZkRuc0Nh?=
 =?utf-8?B?cU84Z1lQUmZGUXFnR1hxZzFmc3JIQkF4YThyNzJQbFJTSUZBMThCQXdVSWNz?=
 =?utf-8?B?cU1ITGJCaDNwZ05Kc28xeGJaamxFOUlCRS9SVG9MWkcxT0oxdzdVTFVxMDFH?=
 =?utf-8?B?YXpJczRodGhndXlrQ0RQZHNJVml1MnhKVFozdXUvVHBWZEFPY3drRStBOEZw?=
 =?utf-8?B?dXRXS3lBeWJaMU4xTGFKcmFSMk9YMUZrZHZFNTNnZWptQ1JLbllXZDhaK3NF?=
 =?utf-8?B?enlrcWd0T3NjbTlXL21SWkxLOURGTTMwWVk5SGdlUlR4QzI4VkNFQlBxQUpo?=
 =?utf-8?B?bTlJNVZ4NHJMcFpxV2IyaDF2OG82VVBnYkJ6ODdINkYvdlZBeHdXZ1dpTURI?=
 =?utf-8?B?VzlLZ09yWHJmZ3Bzd1QraXJEWG1sU0pQeDhjV2N6TUxaSUhtb2hCeFhrclR6?=
 =?utf-8?B?QXhuV095RXZXcnlUcXFydHQ1TE1GUUc5UVVjUi9lSDFLM0M5Yll2dzZoMC9D?=
 =?utf-8?B?M2dDeUpjVnJtbEY5Y21XcmVBRzExdFp2dzF6OG5mREs5U2dWSXA2RnVtU1Ax?=
 =?utf-8?B?bzNuQ09NSWVScFNVcEF4S1FQRnRLcHlUTk1OdW9ETWtHKzlIVXZkS1hnZ1Av?=
 =?utf-8?B?SE15aSt3UFoya1A0cGtkbzgzaGdoMWlBWUwzaExiNUJuZlJlK0R4QkVoYk9q?=
 =?utf-8?B?d3k0eUIzQ3dZeDhHYzJTVlNuK2s3SWtCOWVnYUk0NTI4Uk9EVnV2ODI5ZWxU?=
 =?utf-8?B?REtKUHduOGFPQ1J0TXNTN0RBRStqd3owazZRTlVEaC96OTZBdzJIM2NZUmxF?=
 =?utf-8?B?MXBEK3ZrUlkwZkFsYnJXbXdaRXJUUnFzODQweHJhbzFaL3lpeTRsbHhZS1RG?=
 =?utf-8?B?SHBucGhGUjJ3Sm1TS2QwUFFJeEJaZEliMGZLTXZqYVQrdTZaMWNoTmpGM0Zo?=
 =?utf-8?B?bzJLMGZ4Ujhtem9uSm1IWEpSRDZGOG5KYVRvNFM5Qk80d05zMk1Kb09OQ2pV?=
 =?utf-8?Q?UleBSd7453L1+1IJTZ0VAajsf?=
X-MS-Exchange-CrossTenant-Network-Message-Id: bcf223f8-e991-4d1d-7166-08d9cbce8e6c
X-MS-Exchange-CrossTenant-AuthSource: PH0PR15MB4413.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Dec 2021 19:57:06.4683
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: fI7wcrtthTphNQ8lLA6uowtzTPZPRDpsretkhIvSlqWBPb95vjPylxw1Tq6tw0tO
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR15MB4640
X-OriginatorOrg: fb.com
X-Proofpoint-GUID: vp6lwtHtm6sZwc8ZxoRgDYEtRDJ_v1t9
X-Proofpoint-ORIG-GUID: vp6lwtHtm6sZwc8ZxoRgDYEtRDJ_v1t9
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.790,Hydra:6.0.425,FMLib:17.11.62.513
 definitions=2021-12-30_08,2021-12-30_02,2021-12-02_01
X-Proofpoint-Spam-Details: rule=fb_outbound_notspam policy=fb_outbound score=0 priorityscore=1501
 mlxscore=0 phishscore=0 malwarescore=0 impostorscore=0 spamscore=0
 mlxlogscore=604 adultscore=0 clxscore=1015 bulkscore=0 suspectscore=0
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2110150000 definitions=main-2112300114
X-FB-Internal: deliver
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org



On 12/29/21 4:49 PM, Al Viro wrote:
> On Wed, Dec 29, 2021 at 12:29:58PM -0800, Stefan Roesch wrote:
>> This splits off a do_user_path_at_empty function from the
>> user_path_at_empty_function. This is required so it can be
>> called from io_uring.
> 
> Umm...  Why do you bother with that wrapper?  filename_lookup() is already
> there and already non-static.  Granted, its user outside of fs/namei.c
> is ugly as hell, but looking at this series, I'd rather have the damn
> thing call filename_lookup() directly.  _Or_, if you really feel like
> doing that wrapper, make it inline in internal.h and have fs_parser.c
> use call the same thing - it also passes NULL as the last argument.
> 
> Said that, I really don't see the point of having that wrapper in the
> first place.

I'll remove the wrapper in the next version.
