Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6E35752F293
	for <lists+io-uring@lfdr.de>; Fri, 20 May 2022 20:25:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346856AbiETSZi (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 20 May 2022 14:25:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59916 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233230AbiETSZg (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 20 May 2022 14:25:36 -0400
Received: from mx0a-00082601.pphosted.com (mx0a-00082601.pphosted.com [67.231.145.42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 18561190D19;
        Fri, 20 May 2022 11:25:36 -0700 (PDT)
Received: from pps.filterd (m0044012.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 24KHT2XR016678;
        Fri, 20 May 2022 11:25:28 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=facebook;
 bh=5dahqSPU2EkvWRqQVaIy6vHlCDgdakmPa2G75LHtz2s=;
 b=LgtlDWzlMmHud+gec43daJLBYH19H4XPN+95rTnemjMKxQYVbfrRJ1ZNzVZBpazSZ/kB
 s+TUOQzAGVItEGMb0UNqGISnTxzZD6XjG/APGZ/rCaTXZq0KuJgjGUDG0TZ1XfS6vOJ7
 82QQ+LiKpSZ5LoX/5tOdyj+SxVA8TP/ziYI= 
Received: from nam11-dm6-obe.outbound.protection.outlook.com (mail-dm6nam11lp2174.outbound.protection.outlook.com [104.47.57.174])
        by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 3g5pj51s7f-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 20 May 2022 11:25:28 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Cz/ydEIfgZSfQUOb8ATS1zndJJLgH4F+0pPMHbzN0nMToBYQhMOMX9heuEMm1LAezWct6x28vKOASMBqa04owAznyjcbIsL1kr7x3vT3p+KYogGsvCBm88312ao3rztA4DkhBNHVkCqpfwarItc4hVWv0soRqZqBez+yNsu845ROgkpOi70pufUlPnKkGKyc9wwCpdgS23b/wWGvADc48hLELBJpHM8S5ZNBt+2B9829hDg3yywxlO9SMMUbwY+AuX5g7dOtv0DZ8V1u2TXHY0eeL3e0XGjo8TyC8xbI/I2DHhziUkeX73HAKnevL4vZeOS/6FBm6lj/UDjq2KETFQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=5dahqSPU2EkvWRqQVaIy6vHlCDgdakmPa2G75LHtz2s=;
 b=Y5+fnpPebYcnq8GuHSFV0xT9uAojrlzkaLQTgIUTdh27llCClLaVsnOtnwpvIMR9BfcWQCuIRQKcoL84IalHk48oiMX+uAcB8bY2HZoky4KkFndQrE/uNg0FgBnX+NuBRkIC2Tnt8ZyUqMzunlCMxxT3YSKecxGcxjeiPVvIVbCJTU9yaPQJAgaKn9ACm1MIGxio7A2v9GYs/Um0VmgxS+dWnguapt+KIHDdHaU9JoJdvyLw73yRgaEq7v6cCwLcvGDQJ7LQWPxfE6tN98/oZhjCnmIt5lRc/AXclaBZJzCZ8zpCjudx8ZoY0DcMfISpaIu78dZHqhnO3s6HbSewNA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
Received: from MW4PR15MB4410.namprd15.prod.outlook.com (2603:10b6:303:bf::10)
 by BYAPR15MB3477.namprd15.prod.outlook.com (2603:10b6:a03:10e::25) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5273.18; Fri, 20 May
 2022 18:25:25 +0000
Received: from MW4PR15MB4410.namprd15.prod.outlook.com
 ([fe80::606b:25cf:e181:9f99]) by MW4PR15MB4410.namprd15.prod.outlook.com
 ([fe80::606b:25cf:e181:9f99%4]) with mapi id 15.20.5273.016; Fri, 20 May 2022
 18:25:25 +0000
Message-ID: <fd9bee0b-9bcb-b7a3-4e36-bb99c79014c2@fb.com>
Date:   Fri, 20 May 2022 11:25:23 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.8.0
Subject: Re: [RFC PATCH v3 02/18] iomap: Add iomap_page_create_gfp to allocate
 iomap_pages
Content-Language: en-US
To:     Christoph Hellwig <hch@infradead.org>
Cc:     io-uring@vger.kernel.org, kernel-team@fb.com, linux-mm@kvack.org,
        linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        david@fromorbit.com, jack@suse.cz
References: <20220518233709.1937634-1-shr@fb.com>
 <20220518233709.1937634-3-shr@fb.com> <YoX9YgEsnL743FiD@infradead.org>
From:   Stefan Roesch <shr@fb.com>
In-Reply-To: <YoX9YgEsnL743FiD@infradead.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: BYAPR11CA0098.namprd11.prod.outlook.com
 (2603:10b6:a03:f4::39) To MW4PR15MB4410.namprd15.prod.outlook.com
 (2603:10b6:303:bf::10)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: a611dec6-2911-484d-5840-08da3a8e1beb
X-MS-TrafficTypeDiagnostic: BYAPR15MB3477:EE_
X-Microsoft-Antispam-PRVS: <BYAPR15MB3477B025DC2EDF9AF60C4C50D8D39@BYAPR15MB3477.namprd15.prod.outlook.com>
X-FB-Source: Internal
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: lWWBpDK207YPnJvq1xxTtypbQOMJTj2h47R20yLd+NQKPiawi++Y1mbHzQbHspdrFiuNYXwQYkfqpf79our+wVUT3o7fgGm7dwiArUaVXtypLDACWThA6typbJ/hwJNUYkgU8ZOfjpcPp6XK2viah9BwLGbBAvhSeW+6hiY7FFwV7Q+XFvTzlBq4A3Z/Qs/BxcyGf5N3p9czrvSJBfFR1SuGbFhkSyqLi/27G+4EF20sL5HR1w4vcxRhLHnf0RyfldzGv9LdPjmbCvHPJAslRqbgm/IVBPcpNr6BLkLyPRWfe8KpSNkgJtxdFsS5S3eAL12wvl2nexJutEf/t8xSQR8qR+jPzgfas1dUW9VjMiPgKG3HF72F7T3jT/5U5HifLQMspc6J1+DLpwWjGPeFMwR1eRiUtziE4+n7yQXEH1Tdbqcmtt8hPcrb0t3daIWJEVPzk3LqQUbhM98LfyliMu4FbBKE5k2iDfKJGCXXmb1gMRwFtGgEngiqSiaY14oVt21DqHSXk+BUNWKlevjhRx26FWDE2WSNRO+PXd8cTsmpmzO3zLABK+gi+/NLy8+k5T4U2QdmCFnjnaQzOITCc8W+wyeaTU2/P9cBOJh/Y5WWzAML1FSMJm3ibBCMKVpSMnWq/kNuyZjr1T3lN6TtJ+jFvd5fVUWhPVbL7F/a6yqqHXfL9ouVYCynHYo2GuUm84ByQCBB8SWrG1LK69jPVqSi/zHGOf0rQVNGsQRYIrsGzgqQYaiWHCIie1Ao708k
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MW4PR15MB4410.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(83380400001)(2616005)(2906002)(31696002)(6512007)(6486002)(53546011)(86362001)(6506007)(66946007)(66556008)(5660300002)(186003)(38100700002)(31686004)(36756003)(66476007)(8936002)(6916009)(4326008)(8676002)(508600001)(316002)(45980500001)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?Nk04Y0twZXpiZ3BMWkowdHpxTWFQNy9IUHMxV04vOWlXRDZNb2NzK3hxWEc3?=
 =?utf-8?B?aGJsTFJzWU93ZE9SeUVhZk5hWGVQS1padUVQeHIycExzOW5FRVZlQ3VoMEV3?=
 =?utf-8?B?N3hEWjM4bmNONVRFQWhGRXdMc01tdGZ1c3QvSm5ZZnFRbm5xTXpiakE5dHM1?=
 =?utf-8?B?ZlJiYVQ2QWRZVUMyc3Z3aWFnUDJKVDMwbmtTMDBURDRDZENiWnhodDgycnln?=
 =?utf-8?B?VU5kUDU4Y2tGaDYzb0pQdjdqUVYvT1ZHbUJnZ0lUMzNrblAwdWxzcitjaVBo?=
 =?utf-8?B?Q242NzM5emx1OVlwb1V6eGd2ZEMzcUZoWTkxa0xBMFZVNHRXZnlqN1RRblgw?=
 =?utf-8?B?MitBNlNlV3QyNHpmZ1VRWm1hRXRXSHZqUWFIUlhQMzh1Z3V2RktyMlpZQlhP?=
 =?utf-8?B?NnBLbGR2OFBrdXhUZkVGUU9nOW9jUGNWUEtkcXcvMHBONmV1MG9XRTVuaHB1?=
 =?utf-8?B?NVBvbmFrMmt3VTNtY1NnN3VZejNDTnBONEVVSXU0SERjc0dncWdKK3gySlpy?=
 =?utf-8?B?bDlGaVJodjU0bWpDbUJORjU0L0NUVlh2MWsvVE9RZWx6VC9McVRDVHorV240?=
 =?utf-8?B?elFPZFlySnVPV3krWkp3Qks0WStjZTRrTXRDR3F5MkxxRlp1dkE2aWZxWGxv?=
 =?utf-8?B?ZkVTWU9qQmpWc2Rla0FDV0hLbkxYTWJVZzd6YjBWcXRnTzZDbHY4Z1paVm1D?=
 =?utf-8?B?dDlocE96NnBpZFdIbG5TcTNXaS8yTytYTFltNGgxdlorR0h2ODUrUWIzemdk?=
 =?utf-8?B?UHhYRy8reW1uNlFVWElsR3gvY1hiK1EvOUsvR1JnQVJHQ2hCSTlieSt2WXpn?=
 =?utf-8?B?Q2Y0Rk1nLytuNzJ1ZTJkeFhWTDFEcHFQb2dXRjRyQkR2ZENDR29VNGcwYTNI?=
 =?utf-8?B?NFlldjgzWk5KZEdQQkk2OEorR3R1a1JHQnVBaXloSmpBT0hjQXpqZ2tBWXFw?=
 =?utf-8?B?Z2VpTTVEVlN3UFVKQWN1OHIzOUJZSHpqVE1POHQ3TWdLZTVHUTlmRmNvY3Bm?=
 =?utf-8?B?Z0src1hjeDE4N05oaTV0YlY0Mk9lM0ZoT3JDdzdhQkdML0R1SndlRXRUN3lL?=
 =?utf-8?B?eHpWS3QrMGlndi9Jd3QzaTF5Z0pQVU0zUElHeTJaS2J1YUJNdWZkSHpyQWxL?=
 =?utf-8?B?K0hDNmdldHhtZzh0SFV2TVhleGU4cVBOczdyamZMVVdTckJKanVoUXZpL3lq?=
 =?utf-8?B?ejBzanhTam5nSHpLajAwdEs4ZHB4d1dQM1VQNkJkYnpaZmkwRlhFRnpkbDV5?=
 =?utf-8?B?VDZTMGI5YTRtNkRYNlIwSDRyYjNKMUtrMTg3emFicnZQdHFmajVzMWtNNVBK?=
 =?utf-8?B?OTFZRVloMTJkbjJ5SWhBR2V4MzVzL1VDYUxDTjJFNjRUMFI0MkZ4Q1cycTh1?=
 =?utf-8?B?dEo1Yk5ySmhxVXVXenlmNXRlWjlhTE4vYXNHK1FwTlpEOXVaM2pyWjFaNU41?=
 =?utf-8?B?aURTU3ZSRXNxbTVzQVF1UW9CeWVHZDkwRHRnaTNrSkhyY2JwVm9BRXJyQXNI?=
 =?utf-8?B?eDBwVWw1THRqWEdILzFaR1dHTVZNdUw1cGxydjVnYmZVSStpeDJwQzZiSlpJ?=
 =?utf-8?B?V0VlWE90V05XYlFyZC9zTkRaNmFWamJIbWdZRXNrRmpYR2FITzRvdy9XUFB1?=
 =?utf-8?B?WnE4bGFsMjgvWDFUQUgxZlVTTDRmMm1yOEpOQmQ5VUpMR1NyU3R2WW5sd3dl?=
 =?utf-8?B?TVdlWUduWWRIMGEwMUFWVXRkNExhT1dpdkZ3Y3p0QjBSMEcvY1N0K2l6cU45?=
 =?utf-8?B?SktKQzVtU2ZuQ0xkcXpibEFaRW0vL0xwOHpTdWpyeGsvZkN5T1BBRTVRSjNX?=
 =?utf-8?B?TC9YVzB6UTh3RVc0bTZKYnc4bW5nZzBJd0drUmVJR3B0eExEcVZMRkpxYkdn?=
 =?utf-8?B?aTEyMkxvWWM1VUtrZTYvMmU4ankvQjBjcWdHTFBZam03L3laMDdFNzNHNzJQ?=
 =?utf-8?B?T3ltWDZaaU5ERHdUWmtzUndzZlBPWWFKR2dJNElCVk56Y3ZPWjk0VUVncDhq?=
 =?utf-8?B?d0RUQ3J6Qkp4Rk0ydFpaM0d3SUV2NU10bnB1TVZIbUlqSDZycURBV013d1dW?=
 =?utf-8?B?azVtekVSWGdGaXEzdkJ6cHpuYmg2ZCt5aE5BZjUwcWRyWERkUmxIcmtodmN6?=
 =?utf-8?B?dmQrSjJycEw0VldxWGxnZyt1VXNjdklBaytmckJMVUo4TVRQN2NpOExwcTRH?=
 =?utf-8?B?SkhVOTk3em5IL2lTWnd0RWJ2MCtIczNrbFBOajlVNTJ5R3JpU1VFTjY4eGt2?=
 =?utf-8?B?SUNCUmc1YnBReTVLcDBKOUhjM3RNRzYyNzJaamVvcStScDJBeUZrUjZFbkhM?=
 =?utf-8?B?Q2F5aTdIaitvQmJZQnB1dm0xTTh6STltRTZEWGJIWTV2NGNCZEZCSjB4VjE1?=
 =?utf-8?Q?mOICdN+2leo1HHZ8=3D?=
X-OriginatorOrg: fb.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a611dec6-2911-484d-5840-08da3a8e1beb
X-MS-Exchange-CrossTenant-AuthSource: MW4PR15MB4410.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 May 2022 18:25:25.6709
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: UVUuwqVMeQ5AtDsvi8/tUTjIF/JpkfoD7MxAuIqVTJLoIHupf7Rk6JiNsjGImXfl
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR15MB3477
X-Proofpoint-GUID: vCKBUs_hfZvZ5gJxBzEUs2ekpDkvF2V0
X-Proofpoint-ORIG-GUID: vCKBUs_hfZvZ5gJxBzEUs2ekpDkvF2V0
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.874,Hydra:6.0.486,FMLib:17.11.64.514
 definitions=2022-05-20_05,2022-05-20_02,2022-02-23_01
X-Spam-Status: No, score=-4.0 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_LOW,RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org



On 5/19/22 1:18 AM, Christoph Hellwig wrote:
>  * This function returns a newly allocated iomap for the folio with the settings
>> + * specified in the gfp parameter.
>> + *
>> + **/
>>  static struct iomap_page *
>> -iomap_page_create(struct inode *inode, struct folio *folio)
>> +iomap_page_create_gfp(struct inode *inode, struct folio *folio,
>> +		unsigned int nr_blocks, gfp_t gfp)
>>  {
>> -	struct iomap_page *iop = to_iomap_page(folio);
>> -	unsigned int nr_blocks = i_blocks_per_folio(inode, folio);
>> +	struct iomap_page *iop;
>>  
>> -	if (iop || nr_blocks <= 1)
>> +	iop = kzalloc(struct_size(iop, uptodate, BITS_TO_LONGS(nr_blocks)), gfp);
>> +	if (!iop)
>>  		return iop;
>>  
>> -	iop = kzalloc(struct_size(iop, uptodate, BITS_TO_LONGS(nr_blocks)),
>> -			GFP_NOFS | __GFP_NOFAIL);
>>  	spin_lock_init(&iop->uptodate_lock);
>>  	if (folio_test_uptodate(folio))
>>  		bitmap_fill(iop->uptodate, nr_blocks);
>> @@ -61,6 +71,18 @@ iomap_page_create(struct inode *inode, struct folio *folio)
>>  	return iop;
>>  }
>>  
>> +static struct iomap_page *
>> +iomap_page_create(struct inode *inode, struct folio *folio)
>> +{
>> +	struct iomap_page *iop = to_iomap_page(folio);
>> +	unsigned int nr_blocks = i_blocks_per_folio(inode, folio);
>> +
>> +	if (iop || nr_blocks <= 1)
>> +		return iop;
>> +
>> +	return iomap_page_create_gfp(inode, folio, nr_blocks, GFP_NOFS | __GFP_NOFAIL);
> 
> Overly long line here.
> 
> Mor importantly why do you need a helper that does not do the number
> of blocks check?  Why can't we just pass a gfp_t to iomap_page_create?


The next version removes iomap_page_create_gfp() and adds the gfp flag to
iomap_page_create.
