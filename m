Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 629E5513C38
	for <lists+io-uring@lfdr.de>; Thu, 28 Apr 2022 21:54:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241073AbiD1T54 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 28 Apr 2022 15:57:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46894 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236900AbiD1T5z (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 28 Apr 2022 15:57:55 -0400
Received: from mx0b-00082601.pphosted.com (mx0b-00082601.pphosted.com [67.231.153.30])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2946DBF312;
        Thu, 28 Apr 2022 12:54:40 -0700 (PDT)
Received: from pps.filterd (m0109331.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 23SJflOo027073;
        Thu, 28 Apr 2022 12:54:22 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=facebook;
 bh=mt+dJpQXgmvk4NqSWetyrpuRdkj1Bb0gqTgVbzJZsTE=;
 b=QqLnI2T+E03dATGfCNWGwZjiPbvShitYrJYl6jLrp+Kx/yQ9L0bbGf5sG95/NjT3SFd3
 pF0tjkSLj3FAjcQ4ZCLqTV3AkPn56qvnl27C504bWTRHaRVt25JkPg288O+KJ2ULjTPw
 6pTWvb6z4gRSfGnVvHVb8OgcReVlfFBDW38= 
Received: from nam12-bn8-obe.outbound.protection.outlook.com (mail-bn8nam12lp2177.outbound.protection.outlook.com [104.47.55.177])
        by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 3fprsd7bmx-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 28 Apr 2022 12:54:22 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=laUzUH3992fWATQampOHAKS3LYHYyTJGLsC35Go232srKSN2xxbI4amxbp3h9V3g12/lFo2ju4xnLtdyShElFeBxBk8sgw884tNw3gBkAOL6jL99aCV9NnMDizfaRUH9d8v2EY9fVArCy0BzCurBbh+3QQDX+Dg6sQMWQWqfBwCPO7KP6ZoqYrfXF6DmSHoW4fMH1cMa5oqnadF+9lthx5F+vk4BXRpAbauY9zQeUzrzfnjt2MKZcoLmOXDkQnnD5JpKe58UafWMzGB/g6iYh6ulJk3cLSv4RbEmQgf9Kf/A4EcFtw8rwykzczUwK+Ppu1pCKEv4bBN0pSL3Nee3Dg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=mt+dJpQXgmvk4NqSWetyrpuRdkj1Bb0gqTgVbzJZsTE=;
 b=oVX/GJP6JhyRTIKKLCyy7Q5U/U2c3lXW5axD3ybzpsD3R2G6HPzCczZutsB+PsObAIoyT4sPPEAzrkF8vwEKnhH80POgRICMzBzkdfP/EgJnnGUb1QfPjpUTi42fWuszs9gxzUFKUazOwISEJctDwUn6ZzXDMoPfJMvj9c9ups6dNf47EisKv3finhsMQ+MCwIlWdakKPCJSHJOxDRFdcUZ8q6GBPmOutAPVOpOrgtRSAgkeHmYaVKOQN+aXrnxGQcj3LUNkq6iFP/c+Eo6qdvWq1DMO8IGXova1xXtv0lILDeKpG8O+rUYD+zknZd4RVd9b+Dwm4lA5polCYxecIA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
Received: from MW4PR15MB4410.namprd15.prod.outlook.com (2603:10b6:303:bf::10)
 by BYAPR15MB2598.namprd15.prod.outlook.com (2603:10b6:a03:14d::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5206.12; Thu, 28 Apr
 2022 19:54:19 +0000
Received: from MW4PR15MB4410.namprd15.prod.outlook.com
 ([fe80::687a:3f7e:150b:1091]) by MW4PR15MB4410.namprd15.prod.outlook.com
 ([fe80::687a:3f7e:150b:1091%7]) with mapi id 15.20.5206.013; Thu, 28 Apr 2022
 19:54:19 +0000
Message-ID: <b10249c9-f854-f2d6-8294-19dbfdfb9a92@fb.com>
Date:   Thu, 28 Apr 2022 12:54:17 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.8.0
Subject: Re: [RFC PATCH v1 02/18] mm: add FGP_ATOMIC flag to
 __filemap_get_folio()
Content-Language: en-US
To:     Matthew Wilcox <willy@infradead.org>
Cc:     io-uring@vger.kernel.org, kernel-team@fb.com, linux-mm@kvack.org,
        linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        david@fromorbit.com
References: <20220426174335.4004987-1-shr@fb.com>
 <20220426174335.4004987-3-shr@fb.com> <YmhCylsmrdSvXaUq@casper.infradead.org>
From:   Stefan Roesch <shr@fb.com>
In-Reply-To: <YmhCylsmrdSvXaUq@casper.infradead.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SJ0PR03CA0058.namprd03.prod.outlook.com
 (2603:10b6:a03:33e::33) To MW4PR15MB4410.namprd15.prod.outlook.com
 (2603:10b6:303:bf::10)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: e37c16e8-0c7c-4f3d-4405-08da2950e203
X-MS-TrafficTypeDiagnostic: BYAPR15MB2598:EE_
X-Microsoft-Antispam-PRVS: <BYAPR15MB2598E4C4A461DA82B8E06C33D8FD9@BYAPR15MB2598.namprd15.prod.outlook.com>
X-FB-Source: Internal
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: xjIiAbut1C+psL675CORBbQRGYOKCiqQBrRzGRAh8N35tIkaqKA8VmLRtWXt96h+yIOKR92iu5CB8GoosYrLRRl6SQ2BrEPvgyJEhOmMLg46psgVt/dOifOpzR6YCznu8q3zS75lCy0mKg4cwOWFGpem8arrOWbNeWopf+tL1lsSf20adjUYflXyrx466aolXxUhdGNT08tlfNcYncyuKP8+LeSxzxlO56W1hktLaELuXiPu0potfzERp1bqr0o+8VcLTa35+pQXbqK9IkeWVI2ZLx0l2SKqai+7MaqL9Fmy7dcowRay2ca7M3SNQHz9cwkFNADdhfiKMrlkUxEn5SrkcKBNP42Z1ed/rh9eR4oIeeQt99yrDqKjvVa9fR1Zr7OPGwVOzh8ceIuiEqrdDROCUO75PvIpR3tlWDnH8wCp/Rk7yWCtJ3pKqJngNb00frcQ6KaKGzX1yvrmn1+bVlNXTj0NGFoHrFSJY+3MvEz6nee19fag6XWy7LJgCAcX9eLE0l7OFKrLKn7n75euuj/mcCsmGGHQaRts+bfMRcKlZHqbnCyafAMYyHXcTjHrUhjWD1WKiqY2XSdrLl6WgPfzmYcnCPQBaCokzMddelo/hmvZWY/ng9gIfGXVCdbZ6EBZTfQZ6Z/AoV21Dk/vIemB9JUlXcq70geY/2ecYX/lWW/aEuKxHtHkQIpKfrLLSJikIkrNo/xol2NAVoLVs74037yoZ3BVhAgDwmHktsU=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MW4PR15MB4410.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(31686004)(4744005)(38100700002)(6916009)(316002)(36756003)(66556008)(66946007)(2906002)(66476007)(4326008)(8676002)(186003)(6506007)(508600001)(6486002)(53546011)(31696002)(2616005)(8936002)(5660300002)(6512007)(86362001)(43740500002)(45980500001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?VVk2RlYxNHV5aW52UVFGcVJ4OWpoMm50bS8yREtJYkphWWx0L3dCdmNIUXNZ?=
 =?utf-8?B?ZXduemFZSVFyak1JTHdQcEQ3LzNlSHdZQUEreWp1cmZValFoMWRMcUMrbmxX?=
 =?utf-8?B?MHBHeWgyamsyRVhlNFY0c1VldW5JOGtpZWhaSW9ZUFF1Sm9ndXN1NXN5RnlJ?=
 =?utf-8?B?TFVScTliaUJyY1V0bXdHcXk4VzQ5NHJiczRFMTNldzNFdDJqVitONHFQblkz?=
 =?utf-8?B?YkZBUGlRMnMwYklOc2gwNGNPNUxXWU5YQnlQd1RuU3NObzY2anZCeTRheGtH?=
 =?utf-8?B?T29jRkdEV1lNQVFSTWVjSzM1Sk1zN3IxNG5RL0V6Wjk2akNab0F4SEFRNk5x?=
 =?utf-8?B?eCtnZkQ3UTRwbFJDblV1OTMwRkhJdFNQNGVVR0RVeUxaZWFZV3JsZWNVajlK?=
 =?utf-8?B?N01CbURQOUJUOUtvNG4yT3lvSDVmQXlKZllHWUNsOFo4UjUzUzJWSzNwQkF6?=
 =?utf-8?B?ZHlBT1hQOGFyVWlsdjl3K05kaFNtZS9CQzk3aFEvcmx3OUF3MFdFZjRPQW9P?=
 =?utf-8?B?TUJmMFpNMUJOeWg0aFRxcmVMK0pqUHVjSkg0Z25VSlVKWk5uNWRoTjZpaHUz?=
 =?utf-8?B?VG1LOUhBQW9nb0FNWmlPa3NwYUs3UjRZV2YvVWJrSVl2UGFwVTNVaThwM1dT?=
 =?utf-8?B?NDNOT2tHRGdva0tLbjI2c08vSndmRXVPTDNnSG01a25tZmRLenIrL1hwVURX?=
 =?utf-8?B?L0NPVlZmTlplVFpLQ2dZQVlxVThEYkJtRVd2bVZCMEgvemNaUHdVZkxUT0Vt?=
 =?utf-8?B?bDNqVTNyc1ZwaGdBSFlHVmIwUG9TblZYNk5GTHJOTnA3TkxFUUg2UmJQT0lX?=
 =?utf-8?B?WGhkc1lXVEw3MFk1M212YU9wb0JYWTErVWNJN2VFOGpZemhZRjdhN2hhc0U1?=
 =?utf-8?B?QlE1a2cxeEJsTGxHZDJwY2lQaTBib2ZmWUphWnNMdVBzUHEyVjZFd2h1eU5r?=
 =?utf-8?B?M20xQ1B4TkVDRzdvTVkrSnY1NWRVNGtzbmxWZkNTeVdHTyt5NFRhSjFnYlhR?=
 =?utf-8?B?VVgzK1psQWNVTys4UWZwNTZtRWw3aGNGYXBRTHR3VnRYb1B4cFRoRDVSdi9J?=
 =?utf-8?B?RDFiYXhIYjNLTVZXenE1YVlwS2lWdldNalJaQmVEb2liQ01ldXlhQkt3OHVU?=
 =?utf-8?B?VXNLM2Y2bTdUSlBvcURLRWxyWXRHbDdKTFo1aDdQS1RYc2pIc3YwOG9wTUtq?=
 =?utf-8?B?aVZFMFBqZEEwRkJ2QVR1LzdtZ0tlSzJHZmdqd1VPMVkvTmZsSXRkSDN1YlU2?=
 =?utf-8?B?QVpGVFVFVkJKRzF3OHNxQnd5am9IcERvTUJ6YjVDdXBCaFlxYWZWdVhBRkZQ?=
 =?utf-8?B?bmJWOWh2ZndnOG90bXg1SThBeHB6a3gwTDJJY0pucHlyZml1ZTVWUTVRd0hk?=
 =?utf-8?B?SXpsaUhZM0lzbzdnWXhaWHZNbjBBVk5PRFhkV2F1WTVUWFVKNEMwakJVYjBR?=
 =?utf-8?B?ak9JTzdHRlJlWElkQTA2RHJwOWhDQ1F6Qk14Y1ZXcGdJWlJiNEZ3eGRINlRU?=
 =?utf-8?B?RHV5VEdEMDAzd2hCNk5oSjZpYUJxY0FHR3I1QXkya3daa3Q5b0xhQ1BOUlNG?=
 =?utf-8?B?R0VFcTk4UnBrUk44TkZVKzJsaENobU0xMklqQkUxeGhNVkNwOVgwc3FjeEdP?=
 =?utf-8?B?M0d2WWEyY0lZTytRdGJCNUIzMkRScWdWS0ZLN3AreUJ2elFzTjdFUFhVa3ln?=
 =?utf-8?B?WlA0VFJnK3lPQlFDNlNUSXlWUTI0ZmpQZlpMUnYrWjRPbnpua01jOXZaaStI?=
 =?utf-8?B?UWRBcU0yK3VwVWtPVmNoZ1NzYnVUckFVMXFNeWY4dCtINE51cUVrM2p0U2VJ?=
 =?utf-8?B?UXF0dkd5cDEwQXpIRjA3dUwyMkpmWWJ6VjJleDZHUzl5UThYTTJBR1ZURWdB?=
 =?utf-8?B?Wnd3RTl4THliWjFKZDU4YitvNEFIcVNURTBoeVBGYk1HYTlCYTl5NkhhR1I5?=
 =?utf-8?B?UFNnUExBdFZqMVdvdkwwcGIwcC9UZXpzZUZxNWpyemdLYmZPMnJKTGxSNU96?=
 =?utf-8?B?b2ZFMit3NWxyM01Tb0o4MlBmK21GS0crRndzMmRGeW5TajVYSStObXU5SVlR?=
 =?utf-8?B?Z0pFbTJrR3RJeW83ci9kVUpiTG12aUVpYnNkUXhra094RkwxelNQQkphT1N4?=
 =?utf-8?B?Ny9BcDFYVHBybFRmRVdvME95YkZBbHVwMDcrVXV4RmE0UE1BWW1UbjBMVk1H?=
 =?utf-8?B?S3lseGZ4bmtrdDAvWCtLNTYza01IMzVmVmp6RjJoWDdjbHF0Ky9idVVFZ25q?=
 =?utf-8?B?c2VVMzV4L0RMbkRxd1VzQkJQR29pTjhSQ0NXWXZXRDZrNTh5S3NDMy9IWmkr?=
 =?utf-8?B?bnVscmJiVHJjL1pBeDZGTWwzbFRPa041NVVFWnNRWmlmNUlWdzh2b3Jpekh3?=
 =?utf-8?Q?/IqXTKOBGZdMcuuw=3D?=
X-OriginatorOrg: fb.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e37c16e8-0c7c-4f3d-4405-08da2950e203
X-MS-Exchange-CrossTenant-AuthSource: MW4PR15MB4410.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Apr 2022 19:54:19.4677
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 6DJk6q6yKhBdWJ8NPndU6IJLrDBhL3725l+86g6jKWP3w9UvExZWXtcIHgCZn+oS
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR15MB2598
X-Proofpoint-GUID: iCkI1KYW_WZqDJ2zJI6wjThpnCvZPn4u
X-Proofpoint-ORIG-GUID: iCkI1KYW_WZqDJ2zJI6wjThpnCvZPn4u
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.858,Hydra:6.0.486,FMLib:17.11.64.514
 definitions=2022-04-28_04,2022-04-28_01,2022-02-23_01
X-Spam-Status: No, score=-3.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_LOW,RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org



On 4/26/22 12:06 PM, Matthew Wilcox wrote:
> On Tue, Apr 26, 2022 at 10:43:19AM -0700, Stefan Roesch wrote:
>> Define FGP_ATOMIC flag and add support for the new flag in the function
>> __filemap_get_folio().
> 
> No.  You don't get to use the emergency memory pools for doing writes.
> That completely screws up the MM.

The next version of the patch will remove this patch from the patch series and the
need of the atomic flag.
