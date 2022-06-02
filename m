Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B350253C02F
	for <lists+io-uring@lfdr.de>; Thu,  2 Jun 2022 23:04:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239327AbiFBVEm (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 2 Jun 2022 17:04:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35524 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236571AbiFBVEl (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 2 Jun 2022 17:04:41 -0400
Received: from mx0a-00082601.pphosted.com (mx0b-00082601.pphosted.com [67.231.153.30])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CEA5E35262;
        Thu,  2 Jun 2022 14:04:40 -0700 (PDT)
Received: from pps.filterd (m0001303.ppops.net [127.0.0.1])
        by m0001303.ppops.net (8.17.1.5/8.17.1.5) with ESMTP id 252KlDRD024871;
        Thu, 2 Jun 2022 14:04:32 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=facebook;
 bh=vK5N4FSqLuOOqG/x7B42tMFpdwRtInkfFDnI0TD4uYw=;
 b=V4OhpRHhcluE7/Ayx4kadqRDVcLwQ0EWKYo/gK4TarBwWZw8ugtvDm0TAgRF6ZBojglv
 6BCt9n4N8OpKKzYWAPB/yQLEt35X7Cx7WYfpqR7m69shkKSOlQZQlGzcPRSO2seLuVJh
 1whY4RzTlzWkfynJG9jZTSYUg/LUpmmHVUY= 
Received: from nam11-bn8-obe.outbound.protection.outlook.com (mail-bn8nam11lp2175.outbound.protection.outlook.com [104.47.58.175])
        by m0001303.ppops.net (PPS) with ESMTPS id 3gevu4uhh9-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 02 Jun 2022 14:04:32 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=YjKp0vbjFu292cWBYQooDAb3LzgvVc8lVeKU4mSyDYqAsMdtSXgF3x2Yy2O3y6BXWH8qdfoHBU5Ton4/6+ZpTSqjNowhnNOZ8d/EYWfSq9SZzUeWMSshQFx5MxUIXXPPMAQth16VuKsMivyJ6i1vyKc3qls2dKwB4ZFqdsfTQO991ij6aX4IBrjqAWCMCqDj+FBSiiFx2YqOIH5uVDy8NiAr4WMMnBOqCjzfUGSB3QkFKfWHB/xVfIaf2vglLNQyH/yHj271qapQ8j4YNxEgszEqMV/M6SZkAWCy7ZfM2CIPahyzvST+uhMrn3utg/LGDRI3QKQGimCJdZlShGy3Zg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=vK5N4FSqLuOOqG/x7B42tMFpdwRtInkfFDnI0TD4uYw=;
 b=ORe2fSajRvPu7cScXB4bCGrfkocg8BJ5bvZ1GdBUiRHFEhjLSZbBbQlysRIHKglChCXm9aWAvHoXr9xBbGrWVGaILffATnVIvCRpvXWFPYyIAjZ/jetdtY9DdQJ1ne9MBiu5XNQdHcMQ/emWITtKz9+Bu6m34mnjak7gFevDWUoyqoqwCDTD5WR3QQ5AvU76xJWAhbBunjcRNB+2hxNWfzzapkjjuWe8g0Qjwg1I7JK8UdbIykqjUtpYLTcuK/tDOb1TAkXWvXE2t2m0Jkw3aF761U4T/M0EhKWoKBJQxtHne9jeRskD/5PIlstRItEPRE7h7CXOTGMvyJDFfVih7g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
Received: from MWHPR15MB1791.namprd15.prod.outlook.com (2603:10b6:301:4e::20)
 by BN6PR15MB1636.namprd15.prod.outlook.com (2603:10b6:404:114::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5314.13; Thu, 2 Jun
 2022 21:04:30 +0000
Received: from MWHPR15MB1791.namprd15.prod.outlook.com
 ([fe80::e17e:e90d:7675:24b8]) by MWHPR15MB1791.namprd15.prod.outlook.com
 ([fe80::e17e:e90d:7675:24b8%11]) with mapi id 15.20.5314.013; Thu, 2 Jun 2022
 21:04:30 +0000
Message-ID: <b831585a-c19e-630a-f768-10f4492362a4@fb.com>
Date:   Thu, 2 Jun 2022 14:04:27 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.9.1
Subject: Re: [PATCH v7 09/15] fs: Split off inode_needs_update_time and
 __file_update_time
Content-Language: en-US
To:     Matthew Wilcox <willy@infradead.org>
Cc:     io-uring@vger.kernel.org, kernel-team@fb.com, linux-mm@kvack.org,
        linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        david@fromorbit.com, jack@suse.cz, hch@infradead.org,
        axboe@kernel.dk
References: <20220601210141.3773402-1-shr@fb.com>
 <20220601210141.3773402-10-shr@fb.com>
 <YpizrjBiAvMiXduL@casper.infradead.org>
From:   Stefan Roesch <shr@fb.com>
In-Reply-To: <YpizrjBiAvMiXduL@casper.infradead.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: BYAPR02CA0020.namprd02.prod.outlook.com
 (2603:10b6:a02:ee::33) To MWHPR15MB1791.namprd15.prod.outlook.com
 (2603:10b6:301:4e::20)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 1dae17b6-8552-4aa4-66ea-08da44db7c37
X-MS-TrafficTypeDiagnostic: BN6PR15MB1636:EE_
X-Microsoft-Antispam-PRVS: <BN6PR15MB1636D51780C0968320FBC463D8DE9@BN6PR15MB1636.namprd15.prod.outlook.com>
X-FB-Source: Internal
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Cutf5EowIiKKRL/2jNGMjEo3qZiePIpgpFlQsXYK1SGy6ma+s7VdBkFvZh7pVJOjnOcm/6tJEVJmPQ73is90oPp/ONtoIOaDDGuPdyLxDjiePlz+Sr5ShPz8UMAdUNb6jKJgVadmeNssE/1qBI50g8A/uqLm1F+WZ78KK39FBqEeXsL5BxE/qURbXeohCX4QR3RIja9O1a7LL4E4bdVKw96ozQO04XKoY4M3LhjvCxMe0FzhT+3zSBvnuk1CWUrdqZe/6mOA/ewsIWj9ioBb6LwiyuRFoNKRZa4Alxfq1y6Ir32bm2DK4uQXposGRxP7goeIv37T2z70gtJGpu+a98eZ7E+tmHUp4dOp0XxWnejPW7xnlWP6WAo90f1TuQNl9k9lUTgMqtTc8WcekEc9H80+kAte97tp5vUEyhtCha6iymw0fGIqO7I+nb7CsPX0gCBMTCpCROIk2uj5mF7iAeRur4OT0ylXIbtSHZx96sPkgv35frzCstMCQmti38ON3iThjhdGQleqGtBEV1P+GcGpExcSAyh/ne+rkF0n8DvUvVAXA6HOS+7jv6PGFc8ckRN27HyPJTlowWvFxdOGCK89GSZx6S3sAc1pwhqjMZHo5bLjALb6BnnKEYkbQw7TQRHG3tI8gr9DVwq6CMbz1ngWIChSwn5OQUtmWiDfLhilUzuTU/w6J2lxiQZvOopuC0iSqDsuA5bHOCKo0ClRepYHvwsbOTmoPl88Vmp/Q3auqPF1SogHBg/voOF0Ykal
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR15MB1791.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(6512007)(6666004)(6506007)(53546011)(66946007)(66556008)(38100700002)(66476007)(2616005)(31696002)(6486002)(86362001)(316002)(508600001)(6916009)(186003)(83380400001)(5660300002)(2906002)(31686004)(4744005)(8676002)(4326008)(36756003)(8936002)(43740500002)(45980500001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?QjZvbENBTE1Yai9VUUxPaTR1a1dqcEpqZC9ybndMRURzYUs5V3VJY0lVbTky?=
 =?utf-8?B?bVZJUFc3M0J1VEtuZ0ZpNms2Mm5lWC9uSHZ1QWNBTUovRTQ3dGFlWWNFQWdR?=
 =?utf-8?B?RmI0VllEZzU1RUNpK1h1d3FZbm1zSHZLWWVrMkQwZFZOUFZJb2Q0ei90K21o?=
 =?utf-8?B?eHlIeXB3Y1ZiZjNzVlF5SDlWMWt0WGpMUmsrV241THhsaVh6WldPWDlIMTM2?=
 =?utf-8?B?bUxiSHRJY2ZobGR2QlA5YSt0YTdNbUlTZ1FscUozc2dyL1MwbVJua1VycFZ6?=
 =?utf-8?B?dVkyNlV3eUF2czY4dXZJUWM3bWpETlduV0J0dk1Fenkrc0g0ckpvd0NTa0Qy?=
 =?utf-8?B?QjRPdFI4OGVXblVCSTNnbEdiN2ttN3FZd3JYdjFiUVBIVFhMU0pISmxKVFB4?=
 =?utf-8?B?eEowZm9lN1dRUDArMVBCcXVsOStJL0JZaHJ0NG84eTZkMnpOMjNnQzg1Ylo1?=
 =?utf-8?B?NFlVUVFJcmhhMEhtUkhEYWhWOHhBTmVxdDFDc3dZeXdqWmNqZ3JvdWxUb1Q2?=
 =?utf-8?B?U1RDUjNOZWJoNFpLMDhYMzFIcFVFUVRwWTRQUzV6ZzJPVHFQejdIKzBtUm9u?=
 =?utf-8?B?SklqMlpORDViTllibXc4ODlKT3VuSHN1UHF5djZQcGVyVTRLTGtMNXFkN0g3?=
 =?utf-8?B?V05oVjNhUzFLb1R5aGZGL1ROdXpzcEFPV3d3NjY0TzMrdXg3TzdtT283R2hL?=
 =?utf-8?B?OFczTXRJS0hsOC9TRUlKbVN4U1NMS2JjZUZTNDBYcnBiTjk5NUlyVFJVbXJ6?=
 =?utf-8?B?RktKak5tVE9PRGl6NXBqM0lyYy9Ma3VzKzYyVk5PYzZEMWJqVEpYRkJZbnpJ?=
 =?utf-8?B?MncwWmJjdUNYOTRqaTh3ejRTWU1sMXpqUERBdUlObFBXQldSajl1RW5odmRS?=
 =?utf-8?B?czk4OHR2b2tRVkFnREl5eHRnUTZMZ1MxMDdvQTI2LzRSRDVCYkwvcmhacVpR?=
 =?utf-8?B?SVhDejAwR0VaZFdRQ1UrRVF4L3FBSnpLL0FrNGpwSFlkN3crRE9DNUFpS0tE?=
 =?utf-8?B?aFl3VUtYZGtrSEdUQlozNFVvMXVoRjQ5M1YxQ241eGNUQmQrbXV0d3BKQWgv?=
 =?utf-8?B?bkcrMTJvMHZXRGl2MUhadHQ3TFhKcFhlczlWaFRqa25rVXlTVEVFTnRLaWJY?=
 =?utf-8?B?WjJtMWpvMURoTVNKdE9NTnRYekZGeFdaRm14VHFlQTAvNS9jSEtIN29EZEZ0?=
 =?utf-8?B?eGtLZnlrazJ5UnRVdEVxVGliUkpOVlQ0TmpWWVpkWXJ0dTFmU1Bxb2FrcUFG?=
 =?utf-8?B?Lzk5MGh0TGNUUzFPZ1FlbWVrOTlNbHlRNzBtOXN0VTJ1b0NPM3VHQTdOYjJF?=
 =?utf-8?B?NFdnUjVHM3duOE5pTUp3YU1xNWtpcWgwMHhDKzA3dER2cUVzUzZMdjhaQjFh?=
 =?utf-8?B?RmRqMDdOdk5jU1VZUVRwbmgydWpkOWRNYUpZbjM2eVBTcFU2RHhZbVhpMnBC?=
 =?utf-8?B?OFZRNTdIMVBLajgvU0tLbDhVeEV0RlgzejlsMUx2QlVjcGJ5OVdIZmhDaEJ2?=
 =?utf-8?B?eUFGc2pkU2l0K0NGUExtSm9RV1JEVVdNRjNoUG95SUt0ekJieDRZWXdjcEVw?=
 =?utf-8?B?TWlkOXlOZE1xQ3E0Y3ZmbGVEU0J6ZHV0YnYrOExnL0hlbDVDR28rMW95dlBL?=
 =?utf-8?B?U3hPOGxtanhXbjYrTFJ3alJ3OHB1bDNTRXg4WEdrZmVpK0VJNGVPUXJsaFBo?=
 =?utf-8?B?TEp4MlZkNU1yOUplWFZueGEveUNNbHIrZkx5dE5ScDVXblNBMmU2enJicE96?=
 =?utf-8?B?MVlOQkRVaDJRaEtsZDR3bUhlUzU5RFFMM2FpTjlaSmZQSzIwUGp1S1BSbi95?=
 =?utf-8?B?NzBEaW9CRUd0aC90Tk5UNEMzM3NMOHhSdlNoeXQ0bDJCOXdXSHpmakpkcklE?=
 =?utf-8?B?bG1LdkdaZXdFUWM4VFRZVEg2U0tIQ3lrTTdZV1ZPZjlrNkhkVTdUbG1rZTFt?=
 =?utf-8?B?cDUyVGJqQ3llbC9RQkRsMzYzQm1mWWRjY3paeDRmLzFMY2FZQ0hDUFdUMkdy?=
 =?utf-8?B?N1NJR2xLUTE5WUJKMDFxS09lZ3RSeVNId1Z4ZGdDNWtES0JOMmJOQTJhcDdi?=
 =?utf-8?B?V2taRXd5dnA3MVZEN2dJaFpDNU13RXJSVDJOUjdWUDFsRmZ1QjBwWUJYSitR?=
 =?utf-8?B?L2QxZFhCcDVESDNaQS9OdEJ2aUpYZTl1M1ZidHlBVzFPMHBiV3ZhR2xoR1hQ?=
 =?utf-8?B?dk5IaDJjU0U4eE96NXQ1cEFvaEFvVGU2U09XdnNCV09ham9sckJNV0o4S255?=
 =?utf-8?B?Y3Noa2V6eWYzSGt4U3JsWmEydkRLZzlOT3NhRGpXL0dxL1pxYmxKQVh5c1hW?=
 =?utf-8?B?VlBobTRENURXdWRadlZPZDRwMXUrMlJXSHY4QVZnZUJyOTgwZ2tSMTdTZzNP?=
 =?utf-8?Q?EdbYaQDlgVHCi7Js=3D?=
X-OriginatorOrg: fb.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1dae17b6-8552-4aa4-66ea-08da44db7c37
X-MS-Exchange-CrossTenant-AuthSource: MWHPR15MB1791.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Jun 2022 21:04:30.0597
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: F983kC/n3gibe6r4cpwAFnZfNahLUHhaVcYSdtWNuX3ahlIH7tkcK5vDHBsfmj8Y
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN6PR15MB1636
X-Proofpoint-ORIG-GUID: fHtGK9QOKABxTYUFgs824rhtQ5MhgNaR
X-Proofpoint-GUID: fHtGK9QOKABxTYUFgs824rhtQ5MhgNaR
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.874,Hydra:6.0.517,FMLib:17.11.64.514
 definitions=2022-06-02_05,2022-06-02_01,2022-02-23_01
X-Spam-Status: No, score=-6.0 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_LOW,RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org



On 6/2/22 5:57 AM, Matthew Wilcox wrote:
> On Wed, Jun 01, 2022 at 02:01:35PM -0700, Stefan Roesch wrote:
>> + /**
>> +  * file_update_time - update mtime and ctime time
>> +  * @file: file accessed
>> +  *
>> +  * Update the mtime and ctime members of an inode and mark the inode for
>> +  * writeback. Note that this function is meant exclusively for usage in
>> +  * the file write path of filesystems, and filesystems may choose to
>> +  * explicitly ignore updates via this function with the _NOCMTIME inode
>> +  * flag, e.g. for network filesystem where these imestamps are handled
>> +  * by the server. This can return an error for file systems who need to
>> +  * allocate space in order to update an inode.
>> +  *
>> +  * Return: 0 on success, negative errno on failure.
>> +  */
> 
> Can you remove the extra leading space from each of these lines?
> 

I removed the extra space. Thanks for catching it.
