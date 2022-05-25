Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B17385345ED
	for <lists+io-uring@lfdr.de>; Wed, 25 May 2022 23:42:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344375AbiEYVmE (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 25 May 2022 17:42:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33600 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235808AbiEYVmE (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 25 May 2022 17:42:04 -0400
Received: from mx0a-00082601.pphosted.com (mx0b-00082601.pphosted.com [67.231.153.30])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 625D524598;
        Wed, 25 May 2022 14:42:02 -0700 (PDT)
Received: from pps.filterd (m0001303.ppops.net [127.0.0.1])
        by m0001303.ppops.net (8.17.1.5/8.17.1.5) with ESMTP id 24PGtZlD012035;
        Wed, 25 May 2022 14:41:55 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=facebook;
 bh=2wE1q5CW3niJj78WlObaq2qwil1iQS+OcubtluYoFZU=;
 b=pNeZLDf+PJzEFxiNFhmdwCbPhdb3knRn0EUO3s5NoQGjzcxE7tbV415p+JMo2qasHvu9
 Wy1e7OD2sYecRiYglufipQ6YlpGfQiyG+GMBVlsD9fmZTjq2NrpRoV/+c1Mp89Q7F45x
 +Gv00fHBbvGwCopb8LV3NoiH2B6yffshDpg= 
Received: from nam12-bn8-obe.outbound.protection.outlook.com (mail-bn8nam12lp2169.outbound.protection.outlook.com [104.47.55.169])
        by m0001303.ppops.net (PPS) with ESMTPS id 3g9qtua6tt-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 25 May 2022 14:41:55 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=OR52xM9/29lbN+pZNkdsgGCk2XrmpWR2J6R1J4JEDys9YICjqCASECavxdH9kB2oxk52uo6Iuk1s+gp44eL08lZljlRv7QLYJVAlxp0ImkqOkOiMDRDMo4WEn5YDocfjHon5jPVvKTIR5ZrT3CgXM4z8YbqVeKgZ9w0HZaOwRejUwRvL4OVdKqE1MohesgekoYP6GHNJDVY5WFraP5A3ndCGA/6spxXjx+SCMV5dpqRhJIqJDHrxA+1rb3M594lFL8EUUXw9JX0TloooAEdIO0HScfjyanFLfl5O0dxiajJ2H7pjYBEoMR9lK1ZTjQWrYF/geYRO3i4Ddh3LhqPbRA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=2wE1q5CW3niJj78WlObaq2qwil1iQS+OcubtluYoFZU=;
 b=ZK0Dg+d2lQU9MqGdzkBxjLnbE1Zk5VCG/+hfrp8PXRGPx+zbr7L9xwCvMBhjP+Wx/LQxuEzKMlqBZAZbMlMJbNTEElhLGPdOlBE2R3uBsf7TU7GIeLX1aNYUQhTTXWQaB1bdpKTyy51tYVM9N5cabAfCjvZZ75fwAI4L9Pn9zSOVilPkz4NQuscTwxTR1yxu5H1qJwkIBBLmez25UePVq0/HCBP2evRkVvoFpx1yd8zO7uHWj/OVcmFi2EIi0nH6m3u/H2q/Hvjv5XjM4px9nAeqGBbczzlB7yRTbaEG3O1Nt6pK8Unep2Dy1VaYfjfZd7xKZca3eBHNFwa8JiG0uA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
Received: from MWHPR15MB1791.namprd15.prod.outlook.com (2603:10b6:301:4e::20)
 by BN7PR15MB2260.namprd15.prod.outlook.com (2603:10b6:406:8a::27) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5293.13; Wed, 25 May
 2022 21:41:53 +0000
Received: from MWHPR15MB1791.namprd15.prod.outlook.com
 ([fe80::e17e:e90d:7675:24b8]) by MWHPR15MB1791.namprd15.prod.outlook.com
 ([fe80::e17e:e90d:7675:24b8%11]) with mapi id 15.20.5293.013; Wed, 25 May
 2022 21:41:53 +0000
Message-ID: <136e9c53-9cb0-ffda-c00e-5c403dc3dede@fb.com>
Date:   Wed, 25 May 2022 14:41:51 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.9.1
Subject: Re: [RFC PATCH v4 16/17] xfs: Add async buffered write support
Content-Language: en-US
To:     Christoph Hellwig <hch@infradead.org>
Cc:     io-uring@vger.kernel.org, kernel-team@fb.com, linux-mm@kvack.org,
        linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        david@fromorbit.com, jack@suse.cz
References: <20220520183646.2002023-1-shr@fb.com>
 <20220520183646.2002023-17-shr@fb.com> <YonnogxhDz2jeFBt@infradead.org>
From:   Stefan Roesch <shr@fb.com>
In-Reply-To: <YonnogxhDz2jeFBt@infradead.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: BYAPR07CA0096.namprd07.prod.outlook.com
 (2603:10b6:a03:12b::37) To MWHPR15MB1791.namprd15.prod.outlook.com
 (2603:10b6:301:4e::20)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 30255931-c3ea-4980-41f9-08da3e9761c2
X-MS-TrafficTypeDiagnostic: BN7PR15MB2260:EE_
X-Microsoft-Antispam-PRVS: <BN7PR15MB2260FCD683B1BB3E1D09997CD8D69@BN7PR15MB2260.namprd15.prod.outlook.com>
X-FB-Source: Internal
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: pInFh2TGDivSXDFHOakCr3SJVIPouZ4ZF3o6pk+xNwBKaouJB4NG878Oa8Z13dbyJUnaMid1aXfSOogyg0aCuCiCzr0Cfnxy8kQZnm/AF3yZGD9vsDn4sdieWfHFr7ACr4MvgcMH29KT7WA8rwj4mdK8KWDZpzREaPaVRfOhKbNsNVyAYimpesQaERB5bAWddOXPCvgI8nsJ2VZcrd7X0FVf/uvL8J9txsMWW8Yoswqc9gSOj3/1XFiAcwRWmBFhlxEppRfsSwy+uzXBiY8/DIz7njbGf79BHAeBQnxzi7XY38ylSPjuSz+lI0S2srkyEJkmu9CsmjVvaQSeyw0+r8g8JOoxMLFZqjVJHl+gMnbU6uWMuW5pcsjnb+Q9kEhvqmG/7XdfLO+TSZOGZVBct4DRX4C0fiFAmJXu/fEEKQD6/oS2u2TE/hni5GpwKWjEZjh9H9xjkahI3Av07Cmzutkm38mtq2rlb14GD+itCotS6/Mp7fnE8UGll1L8VoiwkoHGeuOTiUpJFiRDGkJ+QnaAEuwE8lHE1TiAv3xIe0YnsXWCgj7/8kMUUxhU+jLJmCW27ijrHUt2zk18lWI4PcxYW3GkceG92KqMD6Erm4d0bjmQXdWpW/9yIPfMXSCC6twCov8K3JwdEv4cM+Uym4IlkUqWupfhKiKrlp9Qk5qP5gSDAc1XNt1MxZIkeM8PhFaNUi50tVOs0T9CABOJVkhyB85YDyFOtM0Lc/qQftj6A1Ocs7ciCLRues86dDSS
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR15MB1791.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(6506007)(53546011)(31696002)(2906002)(86362001)(6512007)(6486002)(508600001)(8936002)(83380400001)(4744005)(31686004)(38100700002)(6916009)(316002)(2616005)(186003)(36756003)(4326008)(8676002)(66556008)(66476007)(66946007)(5660300002)(43740500002)(45980500001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?R3VHUG00N3B4MDY1bWhZVWZ2cHVkcWVxcTB4WHQ2YUJDRTRxaWpwK2doT2NM?=
 =?utf-8?B?L3B6aWt6MlFmcG1rOFNEdTlYV2VBMXBaclgwU08xc3gydVhOWWROUkNwU1Nz?=
 =?utf-8?B?RURlenpkMVdlTkkxUWl0OEpPbDNqYlhWODNpY1EvVllJNDlmb2Y4TWdRb2l0?=
 =?utf-8?B?TS83NmVoU0tPMU5KU0ZNS3pwREdWeVV2ZFZPWldjQVBFSEVhdW80NzQ3MlhR?=
 =?utf-8?B?cmlHampiWlFZTnh5eVlBYWdsM3VMQlpNVDd5S0pheXhQejJLbkVHVmo4ZXNZ?=
 =?utf-8?B?Y1ZsN1IxcENiWmFabGpXS0JlOVhJQW5mN0kvVzh1TWdmK1M3TGdwaVp5bks1?=
 =?utf-8?B?RzdRdXkxL2VrV1Y4T0ttSUlDVWNNUGZNZHNYcjR4VDhVd0RiQWNsUlFSUzIr?=
 =?utf-8?B?MUFxZTBKemVPSlhMWmQ2QnVaQkUzck84ZXVHUmZZWC9yN2VyNEo3RTl5M21V?=
 =?utf-8?B?OWZxY3lRV0lxTWErcHVuMXk4RHQwaGloQkRVWVVPdFdLRk5zUG1VNUwxRlZu?=
 =?utf-8?B?a1B4bExVS21ZOEhKYk1JVnVVeC84WkJkRVRranU2S08wam43eGg3SDVXd09i?=
 =?utf-8?B?UG1ITHNXMjkrdzY4TDBsSStUNXJmc29GM3JjUzNzTTZYcS9aSDZtR05uY3BD?=
 =?utf-8?B?dmJON2cyVzhoR3VHbHNCMnlSNWNQcnZqN0ZEbk41dHNSQzg3MzFhbmdPZUdp?=
 =?utf-8?B?cStHd2tDTXdhYjN5ZEFlR1hiMUdua2IwekpIVTJKcm02d2U4dWRPWEpJUnRo?=
 =?utf-8?B?SC9kb1VGR1JpYi9obkN1cjZtYXJQdUJOeHRoWGYzai9reU83Yk5RblVxekZB?=
 =?utf-8?B?bStLaHZNNm55WndBNElRZHVKZDNOa3cxaHNqajczL1VERVZ4NTkyTDZRL0po?=
 =?utf-8?B?K2RkOGVENXJIUjZvRXpBUVhMYWlXNklaNlByWHRqVmUvRm5LSjhoTlNVYUhU?=
 =?utf-8?B?MTBMUXNqYXQ3WGxVSG9ad0pQcURFTDFSMllTY0p2ei9ZQXV4Y1F3RW1YSWJZ?=
 =?utf-8?B?YkRkek8rdUNiNURaWEZFeUIvZU1NSzJ4RDMra0U3NlBPa3lDN1V4UHNwdkdh?=
 =?utf-8?B?MVZOUmZQQnpCak1kMEdMbEU0SkVneC9PbkdxRzJqUTJhei9HR25tNytEaC9a?=
 =?utf-8?B?SWdHQ21rQ0ZCUGlqbVU5dHVCcFdEMmtoRkZyTW83c0NhOVNlYjJLbEVpalpi?=
 =?utf-8?B?ZitlRHRhaExCeWhjWEZDTmxlTmZjNEdOeUJTY1k5VzBKWmMzUkx2M2VvQVNI?=
 =?utf-8?B?K1dpN09GcGVQdnQybnNQYnBsTnpTeVVEd3RNMFlzaUc4SmNVSEJxc2o2dURx?=
 =?utf-8?B?M1RaTDh3WVJzVlZTNThwSXEwQXNtT0ZKb0FoenBlTDVEK0ZLT2FxT1UvdGNG?=
 =?utf-8?B?WmtpcFpxR3JJSmNlRGRhRUFYbSsxV2tPQlVLRWFtM3pCdTZJWlFBSTQ0OCt3?=
 =?utf-8?B?RGlONndBRWtXNVI0N1VMNVJtNzFKR2NDR01hTGNRTmYwaHlENGpXbWpTaWZr?=
 =?utf-8?B?cXVLWlpScVVMdURmNUt5czBVNktydExiWk1vN0c1aVVZc0pxRktHTGhFQTE2?=
 =?utf-8?B?VWlRT2YyWjlzRHNBOGdyaVdwcE1iY05qS0NGVlRodFMzMHFYVTdQY1E3VjBs?=
 =?utf-8?B?TERVbXUxTlhWTmlEUUFvMHFlVWZpSGNpV0I2RTkrYmNqUTk3TzdFQVBCZURj?=
 =?utf-8?B?cGVGaWtDRjlXVFRNU2twcGp0MmZXKy9kdHpQS3ZqWHhSWHJnZmdGTW1XN1RM?=
 =?utf-8?B?YlI0a3dMQ001SFpORjNiaVkyUFdLajFvVFNZVkFlN0xBU0ljZGo1NVMzbFJL?=
 =?utf-8?B?RzZlUjBOTlJXeGc1MGlqZGZSU2Q2Skx5NUJ3SEh6eVQ1QkgwdkNrWnBTTkVw?=
 =?utf-8?B?QVlrVlpGVlZ1YllZSUFKUUVjM1h2NUNxV1RVSHB0NzU3ZTFuRUp1WE1HTGQz?=
 =?utf-8?B?T2sxeU82KzRSMHRMZHo0WFZkeCs2eDJEMHk4R3RNMnVzdzlKSVcvNEprQ21s?=
 =?utf-8?B?TjFpaTUzRDQzT1hRanRBelI2aFo2NFZxZlZzSndqeHRhakRRdGVxdlpQNk02?=
 =?utf-8?B?MUFqRUVpaGlZQTBXNGdEYzNOcGd0ejN0RDBYeWF4U2NvMEVkY1RBTitWOGtr?=
 =?utf-8?B?WitZbC9EOVVYOXo5RGV6alBERTBpaGttZm5WbDZLZDRqTGdKVnhPeHVaSFlj?=
 =?utf-8?B?Q1R1WEdpbDg1VHNQekRJSDR6SlRQc0w1Wi9uSHdnbkUyeDZJT2ZsOU92NFN5?=
 =?utf-8?B?b2lpa1lQNVJDMlMrd3hUTndxZjI1ejNrTmFMb2xpZ0QybnV3dzNkVERNODZu?=
 =?utf-8?B?YUp3YXpacjVRU3pkM1Bqcnk3MGxJYzV2ak40YWpTd1pPc3FieUpreW1PUHpU?=
 =?utf-8?Q?isTAqHj4MhLzmoWI=3D?=
X-OriginatorOrg: fb.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 30255931-c3ea-4980-41f9-08da3e9761c2
X-MS-Exchange-CrossTenant-AuthSource: MWHPR15MB1791.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 May 2022 21:41:52.8857
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 9ufF5wFzscVUB9HNg+jr9TNV4RnSoWDGbv3q/iSM5tRLoTReCyd7BJ3AQ0jUDV6v
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN7PR15MB2260
X-Proofpoint-GUID: Jgt6hK_hIHdRpPLBS-w2kRdbJQklZhqQ
X-Proofpoint-ORIG-GUID: Jgt6hK_hIHdRpPLBS-w2kRdbJQklZhqQ
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.874,Hydra:6.0.486,FMLib:17.11.64.514
 definitions=2022-05-25_06,2022-05-25_02,2022-02-23_01
X-Spam-Status: No, score=-3.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_LOW,RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org



On 5/22/22 12:34 AM, Christoph Hellwig wrote:
> On Fri, May 20, 2022 at 11:36:45AM -0700, Stefan Roesch wrote:
>> This adds the async buffered write support to XFS. For async buffered
>> write requests, the request will return -EAGAIN if the ilock cannot be
>> obtained immediately.
>>
>> This splits off a new helper xfs_ilock_inode from the existing helper
>> xfs_ilock_iocb so it can be used for this function. The exising helper
>> cannot be used as it hardcoded the inode to be used.
> 
> Actually this should also be a prep patch - but the please try to
> follow the rule that standalone enablement like refactoring or new
> funtionality for helpers is one patch, the actual use of it for a new
> feature should preferably one patch for the whole feature.

Made a separate patch for changes to Separate patch for changes to xfs_ilock_inode().
