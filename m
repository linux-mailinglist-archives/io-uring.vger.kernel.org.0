Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 623D3513C44
	for <lists+io-uring@lfdr.de>; Thu, 28 Apr 2022 21:59:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351579AbiD1UC0 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 28 Apr 2022 16:02:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59606 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234890AbiD1UCZ (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 28 Apr 2022 16:02:25 -0400
Received: from mx0a-00082601.pphosted.com (mx0a-00082601.pphosted.com [67.231.145.42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B1C47BF538;
        Thu, 28 Apr 2022 12:59:09 -0700 (PDT)
Received: from pps.filterd (m0148461.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 23SJfgCW030491;
        Thu, 28 Apr 2022 12:59:04 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=facebook;
 bh=ZT1GJ+Vr4Czj2fKtcpR0vhKMu3AZtMdPW0aFes5MhDI=;
 b=MpsBuAVutztk3hqT2a2UcFvd8vCWd+XJxfx7HdKeasyx0Y7naqK5/2jBH4FzFXjfxfoB
 3W8dStJ/83JqG+QOuj5gf1y6pinecalAMuN5dJy5NxDrPWt6EE9WCnEJ8nfty7ot2j36
 oBhOK7mBuYvlPjxYiRefC1JwFNZh1yKeiWc= 
Received: from nam10-dm6-obe.outbound.protection.outlook.com (mail-dm6nam10lp2102.outbound.protection.outlook.com [104.47.58.102])
        by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 3fprsrya9g-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 28 Apr 2022 12:59:04 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=AEdW3j326JOiFAxGdkzoTBTo8VoGUINEEWgvB2JgZNfP3ABpbIWLkynGdRvFH0h7Jgk7jX73/a7Tmuk4LDz0WHEkQ4GMRlUnmeURSlW43k/VZHs3evIOaO/c18uokLGInyG29z22tmr7mN4VTofaL+5NKIfKRw5I/PjRzGrtLGG+C88/Bp4va1+XjOvuSARlIN5rWVRv+uW0414yudDE0kLBYunmcmqFO72SnSeC5z5vHsrX97JO1MC/OmT2jfGKuDP6nn97nCScG13fQqS8oAuD3M5GYgCHbctjZgcP8k83BAD8VwamI7yrzAv+iaS2620WKjvqLxTutrHWu+PHxQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ZT1GJ+Vr4Czj2fKtcpR0vhKMu3AZtMdPW0aFes5MhDI=;
 b=cN+RcoCuz1l8nchvXIoPThVy38zIVoz033S1+Wot8YdfoEGgHrqVgAGoKew6b2UvDOOa9ijhvfWp0mWg63e2AeYWKOa17u/POVKLiOTYspqhJfVl/u2lji+tGI+s5ima5PsjVrSR9/DY4m4FS6FetoofhiETjQIAxOq3RFTr6aYe23Qn/LzyJEDleNRhTjv+WEt+vyqvH9B/xLYUvFsZypxmaxDsiWSZFm3kpQGz7adnyef2aBy7omsaYeXmO2uS3Unur+54SsLFJDLB3RiLeAg86Cy62bZaDRKgASaQYZUwxlr5YRexMeqT8PNE2wr7oV/ChArAElpe6DG3v7yt2w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
Received: from MW4PR15MB4410.namprd15.prod.outlook.com (2603:10b6:303:bf::10)
 by MN2PR15MB2783.namprd15.prod.outlook.com (2603:10b6:208:127::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5186.23; Thu, 28 Apr
 2022 19:59:01 +0000
Received: from MW4PR15MB4410.namprd15.prod.outlook.com
 ([fe80::687a:3f7e:150b:1091]) by MW4PR15MB4410.namprd15.prod.outlook.com
 ([fe80::687a:3f7e:150b:1091%7]) with mapi id 15.20.5206.013; Thu, 28 Apr 2022
 19:59:01 +0000
Message-ID: <30f2920c-5262-7cb0-05b5-6e84a76162a7@fb.com>
Date:   Thu, 28 Apr 2022 12:58:59 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.8.0
Subject: Re: [RFC PATCH v1 11/18] xfs: add async buffered write support
Content-Language: en-US
To:     Dave Chinner <david@fromorbit.com>
Cc:     io-uring@vger.kernel.org, kernel-team@fb.com, linux-mm@kvack.org,
        linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org
References: <20220426174335.4004987-1-shr@fb.com>
 <20220426174335.4004987-12-shr@fb.com>
 <20220426225652.GS1544202@dread.disaster.area>
From:   Stefan Roesch <shr@fb.com>
In-Reply-To: <20220426225652.GS1544202@dread.disaster.area>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: BY3PR10CA0011.namprd10.prod.outlook.com
 (2603:10b6:a03:255::16) To MW4PR15MB4410.namprd15.prod.outlook.com
 (2603:10b6:303:bf::10)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 54c2b5f2-d073-44a5-f111-08da29518a2b
X-MS-TrafficTypeDiagnostic: MN2PR15MB2783:EE_
X-Microsoft-Antispam-PRVS: <MN2PR15MB27832055DD8D2D12D3C679AAD8FD9@MN2PR15MB2783.namprd15.prod.outlook.com>
X-FB-Source: Internal
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 5q00UkSbSZIdro40Sla+PdrCLXje1gJaUAqvNK5IJGOUJa6Eu2tSv6VDM30vPJ5LfJcc3SaymSj8m0pSBeJzpNFlLTQ9BWut3gnFhnEKkYd1Yq924WcqGiFATQdsWhxGvwbDZOCv0Fy+QQjiQkFpJq6eYXRwebiRLv9m7X2zv8j+ukrd/E0dyfiIx9KkXoAoq/df3ckaeFxME5O2NaZoo28maCqwGVE+zZvW+2A0M4KISvWlkFfBDqEmswG1P0UHBoA9KpDGdHgMOsK9QSEpjMkwNXwcxXFIRFmJ9kMtBAkqPkIn0A1rfjruq1sCW8rqL1tMfC8kGnfZtv45P1I6P1w4ursU0oMrhEE+Xj73pjlFAHbwu8L7IBpaV3QO2uErVtWggeVTpdUOdSpCzEPoJa2HYslleXi953EiFBuH7C0+dtryCGDJfFr0g4t+IJQGhmnL6d9ZRqs+w5NGk0Udd/qEg6U7XXdH/bWpcDNlWGFiQ6esmzLRag8avABd7pQrHnYpY+THjNyA3ph74rotfC9lKWYuZdm1BrA+/oW1u+zRAYwSnEbbIOKIv4eCU92cHB9JHkCOK2doZH7w81OEzHQFQzCPov82SmBnS1JioMfMViZGQH5NREZ7hRk6tHFJnHulCVvK4r/3Efk39iiYcT9C2UUfSR1HvtglQ0k75KDF1Cs1U1TfaLweJBVVCBIZEA1vORKS6xpT80hugumyWR0Sp+v6eyFqkCSx6VxByCY=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MW4PR15MB4410.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(508600001)(5660300002)(83380400001)(31686004)(8936002)(31696002)(2906002)(6486002)(2616005)(6916009)(316002)(86362001)(186003)(38100700002)(36756003)(6512007)(6506007)(66946007)(66556008)(66476007)(4326008)(8676002)(53546011)(45980500001)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?SlAwUkdrbHkzcDlDNyt3VkFSS2VzK1FiV1VDNHZQdUZMT1JaeXFwMGFTOTRY?=
 =?utf-8?B?Z1FXWG5EdXdlb2lId1JkN1p4aVowNkRvUHVrcW9LMGxhR09TTjVTMnNXYkJP?=
 =?utf-8?B?ZG92MDliN0dCUER4ZmQxVXNVc1NPMjFoZnl3c2p4akFxaERtSmVrZ2d5UnFX?=
 =?utf-8?B?NU5MYzd2NHdxMWJMNXdFUTJhS0k0c0hHck41bTFSUlRiajBCc3BrRGk0c0dY?=
 =?utf-8?B?RDFxdUlMUy8yZU9xTWNtSVp4YkorNk51YUVXdUhSRzRSc3k3R1VvY3c0ekJ3?=
 =?utf-8?B?cGliZXlHYmo3a0hvTTVPMEIzWEV4REtIeDR6d2cwMzhMYTU1cWZ0bmx6Z0du?=
 =?utf-8?B?Nkw4ckl1MmpIMStybnorRnNMQ3NPRzBGNlEra3FCanduNmhrS1hRS1NrSlFq?=
 =?utf-8?B?cW5EYkpwbDRZd0hTSTVuMUhGQ0UyMnJvbENIR1RrUWJKOUFIVjdTSTNyYXNr?=
 =?utf-8?B?eCtwWEFLN1RTT3ZuWDJ4NCtRdUEvb3dWdG1vR1BGaGowY3RZNjFzdXNEWk5B?=
 =?utf-8?B?Y0w1ZWFLWlFBbFlrUVUvKzkvcVNtajFEdGFBaFFLSGhSVTRSSWtKeHJKUmw2?=
 =?utf-8?B?VnZuanowVzNVcEdtRHhxai9oMS9ZVmR1WWZ2RGhWQi9WSjVwbVVXbDJqTWxF?=
 =?utf-8?B?NGlJdzd4bFhPZE9sbmQwRENzZGZzdUdjVnJZWU12aTBoYkdwbFhocHpsZmdQ?=
 =?utf-8?B?L0llU0NhdmZnTDdST3ZiV1VUdGdLWHphbkZ3OHZjbCtkMFhYNHBUdzhsRkFx?=
 =?utf-8?B?dzVHb1JtQkdOelVwMmxvaXhla3lBVDZXckFjSk1YRUd1YnVDNVhpVjlLd3Ew?=
 =?utf-8?B?QXNyMDdsQ2w0YTN5ZnJ5bHJ6SzdSdW1ZUmVWV1RuVGFFYjdrbDFiRUhTZlQz?=
 =?utf-8?B?S0l3WVV1ckYxMk1US3VUZm4zejhNeFVDS0F5azE3RXFCbEVZUk92RmJDanVs?=
 =?utf-8?B?RFhBQzg4UWM3S1FicUZ0cUdJVXl0SzJ5L0txNjZHaEx1TjdPOHhZcXgzME9M?=
 =?utf-8?B?N1NQd05vU2prcUlQY0VYMDFmQkxmZGZKS1g4QlJYNDNNRGR2bk1BL212UmF4?=
 =?utf-8?B?SjF5Zk1oSTQybGlFcHp2cU1zMFZqNWRWWkdqVjhHNXNLeG9BeVliYVA3TFQ0?=
 =?utf-8?B?aHRqK1huR2trL2tqeEdkVHMwclBBSEZVNnhaUUZSdHlBZHZrS2dzSURKbXVt?=
 =?utf-8?B?azhDNWFLSld3cDFkdDFvUDRJS05ISUQwOHVjdlhtQWhTcUFVNGkra3c4SVZa?=
 =?utf-8?B?RkVEcHVZRWdOWFZ5VFpYU1RVZ0RPR04rNWkyYXZ3RUw0TkdGTWdmR2JoOFI3?=
 =?utf-8?B?R3gxOS9odFJLajk0VGFuTTJVU0dyS1J5Zk1ubjg5aFZzSmR5YW9nODdVLzYx?=
 =?utf-8?B?YlpmbTA3STJ3UnkzeDhrWlFVVG5EejE5cUVOQ2VjQ05SekptZkk1VkZpMU5Z?=
 =?utf-8?B?eEhoQ1Izb29ITmFEb3IvNWkrai9ac29GVlgybzk3R1dldklwQjdNYjVkNnQ1?=
 =?utf-8?B?eDdRQnI5SE5oNXdmRVFZTElDU1NCU3BzWDJUaVV2U1p1ZTJnR25yOHd5emZO?=
 =?utf-8?B?bUx3YmdjR2tLMkovQi91Z251TmhOOHlUYS9pbDNiMExCeHB5MFZNOXNEWlJa?=
 =?utf-8?B?dXd3ZXdMR3lOSy9ISTUxMFAyVEd2WUZxNFRkMWh4T3FFTVBqUUt3UGhMTkFK?=
 =?utf-8?B?K285eFFMUTZnbkRyMzJYbXFYd1V2bXRVSWlMcWJlTFljTnNoWDY3anBzdkNL?=
 =?utf-8?B?aWpKa1V0OVBOc2d0NjNNdG0yOFJHWmQyaGw3ME9ObThlclhjVndNR3YwZTBz?=
 =?utf-8?B?aFlyQVFGbXBlZ25nK3lFcnRRNFFRck1HaHQ2RStsb2R1ODFQTkFIdWdZN0Uv?=
 =?utf-8?B?QTVPcHByakJXMUdSMzNGNWZ2VWFjZVlIUUljWGl0bTk4WFZOUG1vLzZjbDE3?=
 =?utf-8?B?cWhWN2Z0bW4vd3QwVmVZYThDNE9LdW1aOWlVR0h3d2gwS2JLQ0dTQUlWWXVy?=
 =?utf-8?B?RnRGSUdtUERTR29tMXphb244dStBL0V0cG1Jc2xjQlc3djVSaVpTVDBWbTJl?=
 =?utf-8?B?SXMzbFZidGplaDRuNDFscE0vU1RVWTI2aW92Ym5HcHZxbjBVY2dhRkZrd0Qy?=
 =?utf-8?B?RWlNOG5OMzRMd25SWEdpcThheDRRTHhCNHgwSFZIZGMvN2IvRnVMTlhxVStR?=
 =?utf-8?B?aU56NG0rK0UveHhzUHI4UEtxVmlybFhWK2NEbjhxYkRuSHJnK3gxODlGeVJF?=
 =?utf-8?B?NmkwQVdqenJiVm9DRTZxMDRwK0M1STdEY2dmdFpKcVg0Y2RrNmpLa0VKVFQ3?=
 =?utf-8?B?L1JsRklhNnRuVktrZXF4OTdrcmQxQUY5dW9ja1NpRllGWVNhVDNyTHpZK0ZH?=
 =?utf-8?Q?l1cI09s2tc89ifIo=3D?=
X-OriginatorOrg: fb.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 54c2b5f2-d073-44a5-f111-08da29518a2b
X-MS-Exchange-CrossTenant-AuthSource: MW4PR15MB4410.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Apr 2022 19:59:01.5290
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: WQsC5k9wM8n8NIHt5856x8nzCZeR5nIP/OcaXRGb/t5kJyjyaOm94juYCfUL8AOw
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR15MB2783
X-Proofpoint-ORIG-GUID: OM_QuAZVBiBw3duiUjO2gqjWI9yIJFDd
X-Proofpoint-GUID: OM_QuAZVBiBw3duiUjO2gqjWI9yIJFDd
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



On 4/26/22 3:56 PM, Dave Chinner wrote:
> On Tue, Apr 26, 2022 at 10:43:28AM -0700, Stefan Roesch wrote:
>> This adds the async buffered write support to XFS. For async buffered
>> write requests, the request will return -EAGAIN if the ilock cannot be
>> obtained immediately.
>>
>> Signed-off-by: Stefan Roesch <shr@fb.com>
>> ---
>>  fs/xfs/xfs_file.c | 10 ++++++----
>>  1 file changed, 6 insertions(+), 4 deletions(-)
>>
>> diff --git a/fs/xfs/xfs_file.c b/fs/xfs/xfs_file.c
>> index 6f9da1059e8b..49d54b939502 100644
>> --- a/fs/xfs/xfs_file.c
>> +++ b/fs/xfs/xfs_file.c
>> @@ -739,12 +739,14 @@ xfs_file_buffered_write(
>>  	bool			cleared_space = false;
>>  	int			iolock;
>>  
>> -	if (iocb->ki_flags & IOCB_NOWAIT)
>> -		return -EOPNOTSUPP;
>> -
>>  write_retry:
>>  	iolock = XFS_IOLOCK_EXCL;
>> -	xfs_ilock(ip, iolock);
>> +	if (iocb->ki_flags & IOCB_NOWAIT) {
>> +		if (!xfs_ilock_nowait(ip, iolock))
>> +			return -EAGAIN;
>> +	} else {
>> +		xfs_ilock(ip, iolock);
>> +	}
> 
> xfs_ilock_iocb().
> 

The helper xfs_ilock_iocb cannot be used as it hardcoded to use iocb->ki_filp to
get a pointer to the xfs_inode. However here we need to use iocb->ki_filp->f_mapping->host.
I'll split off new helper for this in the next version of the patch.

> -Dave.
> 
