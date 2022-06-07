Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 71E9D5403F8
	for <lists+io-uring@lfdr.de>; Tue,  7 Jun 2022 18:42:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345133AbiFGQmC (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 7 Jun 2022 12:42:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44868 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344075AbiFGQmB (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 7 Jun 2022 12:42:01 -0400
Received: from mx0a-00082601.pphosted.com (mx0a-00082601.pphosted.com [67.231.145.42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1288210051D;
        Tue,  7 Jun 2022 09:41:57 -0700 (PDT)
Received: from pps.filterd (m0044010.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 257G4BZR015562;
        Tue, 7 Jun 2022 09:41:40 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=facebook;
 bh=unM1XoUjNCh+V0jlaf5h6UfncjoFdglEzDvDCAVWE5E=;
 b=jAzGZQIKcISKe/+OxbpmlL6PEok/C2GxxgJ9MMXUcevKrDAD2BnFvkNH0ApazosFRVqA
 r4makAsOEcMsJehF8Uy9I+1IMZGnImP1yNISeHIwM6AO/8Z+jyXEVmLp7IYoDOOr8VKW
 8QLxrGWEk72XpF29tTq8UqzUQYMb+SPSsmU= 
Received: from nam11-bn8-obe.outbound.protection.outlook.com (mail-bn8nam11lp2177.outbound.protection.outlook.com [104.47.58.177])
        by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 3gj13ck9at-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 07 Jun 2022 09:41:40 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=aMbwdwJ0FEOrSEBIjFsvZcSGJIF0Jaj95X2DAg0KJsjWwp9GyA3F6awiwWOt6lxirrI1Rc7nh5wZ3dQxNsex/IDYyFXA2Zmz0oek48mnJAcCS+g/Rz0KdEk0Pk3Z2bKJmGceRc/cRO1ocCMgevCEonkVQO2VUS1hrmqLj7wb5uHETg6BhnDFHpqa0PVVk0rcrOeSVkeFvtFQ5SNxHdqqN+mb76LQUocvCf/UmstEEX7pXVLMCERPMarPiipggJoRe0rMTpot/o+sVzYV+YZPwwZg3LCuzCMTUHQ/2u9STYsHkUiGoV5T6/0GcizlSm6mQ3Qlr3pOB8MWc+e4szMEFQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=unM1XoUjNCh+V0jlaf5h6UfncjoFdglEzDvDCAVWE5E=;
 b=gZjz6fG5PkDhCpGj3pLu6Ch4wPi5DDVQK8io3G/pkt5RbxH9OCc3DG4ldK8BSLje8S1Qihrgx/wjtzSPk2dh6ff8aSHWEXI3v5oZJUemD3jde2Joj25UZ/WIcq9mwfCCkyWQ50rtlC28V/A7goabRDbO83bX8TZ5dw3d0NBHQnjpFQPdN0rRjmQAoyp73JdEnIO8QGeFNW5+gKszTvOJSdO0Zk09ZMiSN+YGquGmRoaaMinxdyQeT+IwWyySqiqSs+z3CJ1gS+4FnbK+YWHgxkW5aBA/4FFvG4+1wVT0RCxopNYrPT324XLxEc5GnxCx23PM1tf3J+2YMrzBkW+sNQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
Received: from MWHPR15MB1791.namprd15.prod.outlook.com (2603:10b6:301:4e::20)
 by SA0PR15MB4064.namprd15.prod.outlook.com (2603:10b6:806:89::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5314.19; Tue, 7 Jun
 2022 16:41:36 +0000
Received: from MWHPR15MB1791.namprd15.prod.outlook.com
 ([fe80::e17e:e90d:7675:24b8]) by MWHPR15MB1791.namprd15.prod.outlook.com
 ([fe80::e17e:e90d:7675:24b8%11]) with mapi id 15.20.5314.019; Tue, 7 Jun 2022
 16:41:36 +0000
Message-ID: <774288d8-3282-6264-383b-96251f3858f2@fb.com>
Date:   Tue, 7 Jun 2022 09:41:34 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.10.0
Subject: Re: [PATCH v7 00/15] io-uring/xfs: support async buffered writes
Content-Language: en-US
To:     Jens Axboe <axboe@kernel.dk>, Dave Chinner <david@fromorbit.com>
Cc:     io-uring@vger.kernel.org, kernel-team@fb.com, linux-mm@kvack.org,
        linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        jack@suse.cz, hch@infradead.org
References: <20220601210141.3773402-1-shr@fb.com>
 <545ab14b-a95a-de2e-dbc6-f5688b09b47c@kernel.dk>
 <20220603024329.GI1098723@dread.disaster.area>
 <324b506e-ad35-797d-d7d7-cfc8bec26e8e@kernel.dk>
From:   Stefan Roesch <shr@fb.com>
In-Reply-To: <324b506e-ad35-797d-d7d7-cfc8bec26e8e@kernel.dk>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: BY5PR17CA0037.namprd17.prod.outlook.com
 (2603:10b6:a03:167::14) To MWHPR15MB1791.namprd15.prod.outlook.com
 (2603:10b6:301:4e::20)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 68711eaf-3120-49ba-0ecf-08da48a49690
X-MS-TrafficTypeDiagnostic: SA0PR15MB4064:EE_
X-Microsoft-Antispam-PRVS: <SA0PR15MB40648680664ADF4D962A5AAFD8A59@SA0PR15MB4064.namprd15.prod.outlook.com>
X-FB-Source: Internal
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: hwLNNsrswil2+VOxsKkwBQARie7f7UZPfmFb/ERmGuycMnwzdkBV4QriLptjmKHvhHyISUybFJBJp0oWoR2Tq3e0cnszmcN6wN7hh8JKa3aa+PJziXwqMn7IrTVRwf+zimONp8tYsaFiMkHLEk17Ci1jKbxdekgT7XVBXF84vob79AoQZfbXs5Oj8pZltZgRq+umSMP0/pXrdxWGOGIpjxBu6o4/YHSnhCGmFCmqVds7aynfuDlpL80WsbZt7QhOMyDUBClMAlcUeBi9h1WeQB5m9ixLFimyIEHaDdFtSA3dQMJV/P/F8KFTjRJkRRuMV6e4mSkrx31mMnGuo5FA4AkU3t2fmNknR3kHzsEoCrVpF0DGzKyodY9XgmS4fOErUAHnjqAPv7Fd37BgFTJlk2GWFruO4RdRlWm1+MsD5SM5iGdRReY9SCd33M7DQ2dJtHbr69eyziWN2KroQA3OyWx2NTQ59BElzPgcV0SEkZGU/PbKbKkByQq6Sz3KkFKb7Q2gxFNDP9GzVQfbeelB5a6WYaM34kLMAOEVJS34WnIUk4/FRfso8d2dgVdZt1RJSUGUxklyGva1qxCgDojWEpFOrWt2cwen8x/up+J96NPXeHmRU6Er90CfQbEBktLhzREp83g4npOD3MD8N6YNk725HHZLKWcD3KP9lUx+iQOUfXq1VCCy6ntnHNf4D34xhz2wixPPw9NTwIcIk2jUeuNA6heosY+ESj4M5wLmKPk=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR15MB1791.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(86362001)(38100700002)(5660300002)(31686004)(4326008)(8676002)(66946007)(66476007)(66556008)(6506007)(6486002)(110136005)(316002)(8936002)(53546011)(83380400001)(186003)(2906002)(508600001)(2616005)(36756003)(31696002)(6512007)(45980500001)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?YUlkS3ppajRXNTFoN3JVTjN0dERmTHUxUlh3UVhNbFFuNktnRFN0T1NyN3ZO?=
 =?utf-8?B?cHAwU3ZwT3RtNjFRdzNMYVczUWlQZUN1NjlvVi9oNXJ2MkhEUXY1ZEdHUHFy?=
 =?utf-8?B?UldTODhKa1FBSDZkM0w4WWdXOW8vMW5pL21oOHNuYVpnWVUwcklaU1YwQUEx?=
 =?utf-8?B?bDhDQmo3S3l1WHFMbCtqVnEzRUU1aGg4YUJ5WUFUNkhxektGNzhzQzBTUlhr?=
 =?utf-8?B?QjJSK3JyQ3Fnb3IvL055cXA3RENTcEEwMHBrNWNOeDdCNTFEVXhwWHlGMjhu?=
 =?utf-8?B?Rm9kazlwL3YyWHF1UDlxaXlOcnBWUHF4SHc0bFlWeG40RTcwUWhtQ3hMc1Iy?=
 =?utf-8?B?NDVPM09HYnErTndqWVg4NXprbmNJMWVMSlRCM2hJcDFKVkcrWFp0ZjBCNnFv?=
 =?utf-8?B?VjVPUnFmVGRYVy9lTXVrOStkU1VENlBOS1o3NjRlV2Y2cUtZUnVOT1F6S1Vs?=
 =?utf-8?B?VDhyS1VsL2RkS3hoRVpFc0FOcUFsWFBnZCtsR2lKY09UbkhnLzFvZHQxVTdl?=
 =?utf-8?B?VTNsU0VZUC8wbnZPdnBJTEZXTXUxajdCZUdKQmFtcTFIVVFwV1p1dG94T2l2?=
 =?utf-8?B?VzhFdURQdDh3ZUgwbWtGT0g1alFuRnRLMk9UNmZVZXB0eGlDRDQrYVlBd0xz?=
 =?utf-8?B?WGMrdTV0U2plRDdFU1U5ZXFydlZITU9tRzlNMnhpQTdPMG9DOWNvQUpRMElN?=
 =?utf-8?B?anRKNkMrcHVvSFJTZzZVcmRPOVVWZXRXVGFiR1ZjaW9oQ2lrQndYRklXMEl0?=
 =?utf-8?B?UDZ1M2NJZW1YV2QxVzhHVXAxRDZaWC9XMm9WNjNlRTQ0MTZnUXRSaEsvNXgz?=
 =?utf-8?B?MFNYeDZ2UlRnK3JWczNqc3ZkUkhKcm1NRG9YNERLRVVVSEZWVWlKbmduanY2?=
 =?utf-8?B?TjE0MGlpeHMyUlZWcFQyckMrY0RjQmQ2MHlmQUFPN3A4RGxyUmloSXcwZkpJ?=
 =?utf-8?B?a0E2ajR4N1pMNytkL2lNaWQrV3Y1SHVUbmFxOVJXdDZmbHpCeGFSTGtCM1ps?=
 =?utf-8?B?UHlYTWI5N01mQ0ZEcFo0MzJ4cFRSK2Ezdk1WbUtWRjFMNjVhd0RTQzNIUFUr?=
 =?utf-8?B?T1RCaDVTd01rOVBkUm4xMzBCcDNiR2VNbXM5a2RmSWlmWE9vYUkzMlNSNDB2?=
 =?utf-8?B?S09KNHpEMTl6aWpGNTRkdlZyazFjNHFGVzR6VGl3Y0dtUi9BallNdlptT1Bi?=
 =?utf-8?B?L0ZkcnB0RUdlMG1TZ2xuWDdFeWNUSnh6NjdPOTlFazhJdVNHdG1nU2hZcFdj?=
 =?utf-8?B?QTRoMmkxL3NYcGQ3TmR5TVphbThRQ3JwTHd3ZW9XSEM0ejE4cTFhQy9SK0xH?=
 =?utf-8?B?V05OTFMyY3FXckZDVWZnWVliS0xtSXYvSi9ZcnJ4ZFRQYWhzTElzTy9TcUtp?=
 =?utf-8?B?dFNSOS9pM25pUEQ2L2JvWlBCMVZiWkkyWmMwVkhDUjdDZEpaQnREQWNqVUtF?=
 =?utf-8?B?bE81T25zZU1QRms4bEdkb1VtNU9vbUk1eWRoMTNFalBaSFRVUmh6QXAzN0Vj?=
 =?utf-8?B?LytkYUFyMnRuazFHK25EZUpTVmF0UlRzZzJsTi81NzlJUzUzTExYTUFIbGdu?=
 =?utf-8?B?aTdnNFVZd0RNV0JTZXArQmtHR0tVTURLRUlIQ3U2S21zc3hjVFFlc0h4U2dX?=
 =?utf-8?B?Vm9nZElweW9BajlnUUF5azlJRW5OaU1CeThuRWFiazRIaEpZSWVHa3dmMUZn?=
 =?utf-8?B?NTc0a2RDUGI1dDFrcEV0MU02WmlzZGJsUTRFSjNMUWs0R1hjU2Q2ekdZc0Mv?=
 =?utf-8?B?WEJ2T1V2c1ptTjZrdmJ3bS82dlR1b29PT2hGZUtXbW5zRXdZcUVnYzkxc2R5?=
 =?utf-8?B?Y2dUV2licGEyZU0rd2NBVlZudVQyYlUzUW1xRHB4YlBldzF5R3NiSjhnTW1x?=
 =?utf-8?B?b041OVRtR3A5TS9QczZFRGFzeks4Z3BxYjRsQjJ0c3FHU3AxV09ic2I3dEFG?=
 =?utf-8?B?UHdGT1VWd290alQrNkNIWHNXV1U3WXJqcVJvcktQUXk4ZHUrUzIzei9YNFVP?=
 =?utf-8?B?cHc0bXhvTk5QUzYrdHl5a0JhZ2hVWXNVeXhIdy80N3hLVnh3ZVNqaDREVld3?=
 =?utf-8?B?ck1EWk44RytlckF2MjhoYjFYOG5VcnlsU1kzbWxaeUlwSDhIckhHdDRaT09p?=
 =?utf-8?B?bHg4dEQrT0V5WjBDTTYzZlhkRmt4blVPNW00OWd4RE01MlgrZmNjZTJEVjFV?=
 =?utf-8?B?QncraFYrODdmSVN5bU9UeVNiN1ltaG5YL0YvNmpXS2tHRjNObExjYm5ZYkp2?=
 =?utf-8?B?akU1eEkxQ2pSTVZmRmx0RGM2REV2WkJadzdxMjRmUTFWdjQzSjV0TGFjTU43?=
 =?utf-8?B?Z3dqZG40MzNUalV3UXBTSGJlY1JuR1VqdXltNTNVSVViaGNZM1pBUHErRlpR?=
 =?utf-8?Q?F8t1A0huKDoPzqiw=3D?=
X-OriginatorOrg: fb.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 68711eaf-3120-49ba-0ecf-08da48a49690
X-MS-Exchange-CrossTenant-AuthSource: MWHPR15MB1791.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Jun 2022 16:41:36.6081
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Xj4nRlFw34fe9I57OmiRyKvmeNecXykh4xC3HjAouKR2TyK7lotmmBU4MKOYgbqo
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA0PR15MB4064
X-Proofpoint-GUID: Kl5qJ6QgNRmBUoORrJv7oCaIaK_TEwIm
X-Proofpoint-ORIG-GUID: Kl5qJ6QgNRmBUoORrJv7oCaIaK_TEwIm
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.874,Hydra:6.0.517,FMLib:17.11.64.514
 definitions=2022-06-07_07,2022-06-07_02,2022-02-23_01
X-Spam-Status: No, score=-5.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_LOW,RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org



On 6/3/22 6:04 AM, Jens Axboe wrote:
> On 6/2/22 8:43 PM, Dave Chinner wrote:
>> On Thu, Jun 02, 2022 at 02:09:00AM -0600, Jens Axboe wrote:
>>> On 6/1/22 3:01 PM, Stefan Roesch wrote:
>>>> This patch series adds support for async buffered writes when using both
>>>> xfs and io-uring. Currently io-uring only supports buffered writes in the
>>>> slow path, by processing them in the io workers. With this patch series it is
>>>> now possible to support buffered writes in the fast path. To be able to use
>>>> the fast path the required pages must be in the page cache, the required locks
>>>> in xfs can be granted immediately and no additional blocks need to be read
>>>> form disk.
>>>
>>> This series looks good to me now, but will need some slight rebasing
>>> since the 5.20 io_uring branch has split up the code a bit. Trivial to
>>> do though, I suspect it'll apply directly if we just change
>>> fs/io_uring.c to io_uring/rw.c instead.
>>>
>>> The bigger question is how to stage this, as it's touching a bit of fs,
>>> mm, and io_uring...
>>
>> What data integrity testing has this had? Has it been run through a
>> few billion fsx operations with w/ io_uring read/write enabled?
> 
> I'll let Stefan expand on this, but just mention what I know - it has
> been fun via fio at least. Each of the performance tests were hour long
> each, and also specific test cases were written to test the boundary
> conditions of what pages of a range where in page cache, etc. Also with
> data verification.
> 

I performed the following tests:
- fio tests with various block sizes and different modes (psysnc, io_uring, libaio)
- fsx tests with one billion ops
- individual test program
  - to test with different block sizes
  - test short writes
  - test holes
  - test without readahead

> Don't know if fsx specifically has been used it.
> 
