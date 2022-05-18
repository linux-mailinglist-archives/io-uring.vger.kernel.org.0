Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D1FD352C778
	for <lists+io-uring@lfdr.de>; Thu, 19 May 2022 01:25:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231254AbiERXZT (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 18 May 2022 19:25:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37184 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231238AbiERXZR (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 18 May 2022 19:25:17 -0400
Received: from mx0a-00082601.pphosted.com (mx0a-00082601.pphosted.com [67.231.145.42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D8A87F584;
        Wed, 18 May 2022 16:25:16 -0700 (PDT)
Received: from pps.filterd (m0044010.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 24IN6CGp005571;
        Wed, 18 May 2022 16:25:10 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=facebook;
 bh=XgeJoVHKy6AK+747dXs4bfaUhzYh1vnB1CMiW362sDk=;
 b=fgGweO/s/Rw/K3cKUh1me1D6cOLop0FE0msoK03Br1QhZlmwm3JZwsOhvMClBBq0H5lk
 jWPZ5FOUYU/HP8Ye4UCT6+m+H+55bY9aVgtyGk9khFDJGwOq9Mp683cwqNaoOvEQNjrN
 KEL2GFd7CsyZH8bHbiamgk8CZ5WO//GxEQw= 
Received: from nam10-bn7-obe.outbound.protection.outlook.com (mail-bn7nam10lp2101.outbound.protection.outlook.com [104.47.70.101])
        by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 3g4ey1jysj-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 18 May 2022 16:25:10 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=VrgjCrWrWeVD/vabbG6YT8iWZhsiPAdEJnQjoo5MAciQm4opPLQzQINI84ZW6H9zI/W9WC3+nFp+jhFmSy6g8rc1QT3ltoSiAQZo/HyWvoja6f8+Bg/JxExS+eKbGs9DQLhdPMpjEvaKhBqc6k+tntpz+hCRrZCnJMBbYxdIRBdzvi8CxGJnOkv/ICh0wDEgOjzFw7L9rZOb6FKB5CbDmFrdcvHSfxaeGFZnhMrPdWNcNZlvGQAGmpLuo0wRcJ5NHjGAFF+X/jPZA/pbZkMQdbaTUdpQuo4Ad+FF7ViX9LAkkJ9bIGGgmMqNAX67ZGM9ZrPa0Iu+tFIffLG2UVomdw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=XgeJoVHKy6AK+747dXs4bfaUhzYh1vnB1CMiW362sDk=;
 b=XCcrcE2EceTh8xPGaatut0xtF6+ohPJ/xWD7ZDLvijpUOjN/auNxEhXNWE6y6tSAF5ZqHVCZx6TbtIapcF7he3Pph1cqR6mYACsmLFnXyufom1dO3U5igNX8tIZP9vhIKZBLfK4biacG7SZKD6XW9jJilJ+tXI0psC7G2UhpcAzzfAtjg2K7qNEDEFfg6c6/Pk1W83YPKrS0xeBD4Q0m6wk9rLpqYLFIgQs3XLq2etJISC+iMbRJCWjsHA9pigwbvTNyZ9pcJuyZRX5mt7BNz2Yio8oWepwBxxNeuDnnQxBAFNPjJ161m01VoDfzU2wk7Qgr6jV0tOTg2cmHIYW0Cg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
Received: from PH0SPR01MB0020.namprd15.prod.outlook.com (2603:10b6:510:76::6)
 by BYAPR15MB2773.namprd15.prod.outlook.com (2603:10b6:a03:150::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5273.13; Wed, 18 May
 2022 23:25:07 +0000
Received: from PH0SPR01MB0020.namprd15.prod.outlook.com
 ([fe80::ad90:787e:697e:3ed1]) by PH0SPR01MB0020.namprd15.prod.outlook.com
 ([fe80::ad90:787e:697e:3ed1%2]) with mapi id 15.20.5273.015; Wed, 18 May 2022
 23:25:07 +0000
Message-ID: <56aa7777-c8bf-3718-b37e-956ce331ddb6@fb.com>
Date:   Wed, 18 May 2022 16:25:06 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.8.0
Subject: Re: [RFC PATCH v2 06/16] fs: split off need_remove_file_privs()
 do_remove_file_privs()
Content-Language: en-US
To:     Christian Brauner <brauner@kernel.org>
Cc:     io-uring@vger.kernel.org, kernel-team@fb.com, linux-mm@kvack.org,
        linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        david@fromorbit.com, jack@suse.cz
References: <20220516164718.2419891-1-shr@fb.com>
 <20220516164718.2419891-7-shr@fb.com>
 <20220517131841.wjuy7mmqo3w2rdsv@wittgenstein>
From:   Stefan Roesch <shr@fb.com>
In-Reply-To: <20220517131841.wjuy7mmqo3w2rdsv@wittgenstein>
Content-Type: text/plain; charset=UTF-8
X-ClientProxiedBy: BY3PR03CA0009.namprd03.prod.outlook.com
 (2603:10b6:a03:39a::14) To PH0SPR01MB0020.namprd15.prod.outlook.com
 (2603:10b6:510:76::6)
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: c482884a-48ff-4a0c-f9cf-08da3925a53f
X-MS-TrafficTypeDiagnostic: BYAPR15MB2773:EE_
X-Microsoft-Antispam-PRVS: <BYAPR15MB277337EFDC08A34DEDFD08C8D8D19@BYAPR15MB2773.namprd15.prod.outlook.com>
X-FB-Source: Internal
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: idMVwRNJpGEn5M2VhqKHwZbwW8J0djzmidTpGHA3NYDch47h4GobSm+BOtkuByAmiH5yIDnMKz/15p7+/EZAyBamxsFKa8ccwWRkv2TP6ntZySlafiKNMxsAWVyG9GzVN295veFbG0lxOqAuDLpzwQXPQInS9lVHLhTIsImJmGOTut5Wq/yRZ/e433Ld1qXx6e6iBQJdHbLGq8fqJKRtjaBGbN4UziIxXy6a2iKuF+HC83bDO5GPIHgh/KX2Z+QJo7Mif/gmDxfTeG9AR1XZauIx7S6WtpGy3xHzWxO3tIOVOAWJytswJTs06mPqtPXl+sFaMr5j8fPfMA+7pXFI7RuELpjHNO34II9+Ji5ROX1Egca/o2GXphBuqKWbmkltW/SVZTo5NZbWiS/zQh7nn0yke4tdzntGDnr34CgzUPyWtPH8LwgtlXecch66b5oDJR2rpf2jm53BcfJGvHfiYGRcPVldERQJQGCHdQARCd28KDbW+dfUVADP2qwwBmrx8Frh11vbe0FpyA/nGgXndTbM6bPjnSavF765k5vwSKWeW1Mz1iH7MjwlJADbMc54S4GLdI+sNhamvWeepAZC0rDw4priSE9pD358gELnJ1pR5yhyMP5kAtCSDfsJ44NjYL8PZjVnmwcYBjq4GFJ6cT3RZTIViPMWLxTDapyibFuGU5tZhgKo8MIthvBXCZGsQeGXdkM/1Fe0gTGOzk6jzzcDeo41SHsYizzBR4/74SxClYC3MOz802YJLE8THeZS8nTNlgdhlIS7ncCorJuyqP05ndXAIjnw9LqGVAGcPBLRWh/dt2s55x2z08NsmPkKGgO/rQTHEYsjeiegSvnU1w==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0SPR01MB0020.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(53546011)(31696002)(86362001)(6506007)(186003)(84970400001)(2616005)(83380400001)(38100700002)(2906002)(8936002)(6512007)(66556008)(8676002)(66946007)(4326008)(66476007)(5660300002)(31686004)(966005)(6486002)(6916009)(508600001)(316002)(36756003)(43740500002)(45980500001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?VjdvMDdhWFkxUzY4eWNKL3JBWEdUM2l1aUhZVUpURmRYeEtPYjhZeVJwSnRH?=
 =?utf-8?B?N1N0MkZ5RXo1N0dra2lRUEUxN1paL0xpOG83NTVsUlpGWjFhN2NCdTNXYjlu?=
 =?utf-8?B?cTA0UHVYRUVTZlZxendlelBoT0pzbTYwa2t2dXNPRUExN0NCcEFuSzBST0Vs?=
 =?utf-8?B?b2tPY1p5N0FaMCt5TlVwYmtUalMxcU9wQ1RMaWRjeEgvbWNZd3VyRWxFaThQ?=
 =?utf-8?B?UXpkcWRVTDFJaFBjNW5KaDJpODU0NXVMY3haYXpzcS9sSlUrVjMxTENZQldz?=
 =?utf-8?B?Mk0yNVBibU5JbWwwRCtGcG9hT1pRN3IzSmYxaGlqY0RnclUzZG5kVDZWY05K?=
 =?utf-8?B?SjExclhXYUpZMXNKQ0wxbGttRmEzRGRqNnpxOERMUk9Tb09MaWsxcGV2TUNr?=
 =?utf-8?B?MjZ6SDJzWUZkY0VWL0NVdlRoVytRcTdYUkV0M3c4Q1dyT3FJS0oyN2pPWVBG?=
 =?utf-8?B?TFowbzhlRG1QNmYvT0FqNWRlN1N0SUJZdG93dXFoZzRSdWwwcjVqUzhBRS9o?=
 =?utf-8?B?TUNTVUZtMEpwTkw5MXoyVVhwRXBsWkE0cHdLdEllZm5tZm03U2dzTGtxUWV4?=
 =?utf-8?B?bm1HdjZEMkNzS1BOQlQ2UlkwVW1WUHJ3eHZxbUxJc2YrcmZVaUl0MGRTVjA1?=
 =?utf-8?B?NXJlZzhxNGVxeWlBd1MwVU1DSllxVzFpWHNVd3hHUU1qTXJLMGVVcnNVVGVG?=
 =?utf-8?B?Z1AzZWJvNGpSR2k4VEppNmZQYVI4NmNQY0Nsb3Z5R0xhaFpCM0hwZmV6TEhP?=
 =?utf-8?B?WHhKMHF5R3JqQkFpKy9PVUhEY0FGNWZ6ZXBhcU9KRloyaVhqWkppdjl2VHJ6?=
 =?utf-8?B?ZVNhcnV2b25mU0VyU0VGaGZDM0FYbkNxSG9JZWlsYXdKcjlXQzBkTFhQcU53?=
 =?utf-8?B?KzZid3MyOHJqcWl4Mk9WVlBQQkxsU2NlRjFXb0pqK09yaHpBNU1zWUg0Q3da?=
 =?utf-8?B?RlJ3aGpyUlkxaUVSNDI2Wm5MOWVHQjFnU3hMc1VRNElXRm5CS3RVanBmazVB?=
 =?utf-8?B?Q054VnZ2R2t1ZFNzbXQ1Mmo4K2pqdHNmWi90cEp0ZDBaRmg4aUhBMkdyRmpC?=
 =?utf-8?B?T0wrUU9SankxS2JpNFFYd0VhWmZXRVNVL1d1eXNWc2ErbVR6bXdnRkM4T1lG?=
 =?utf-8?B?dUVqWFN0VDY0Mm1QR0kwU1BNMXhYbXRscVFsL2FKRkpkaGJuRUJPeklCdTVP?=
 =?utf-8?B?ZWg1cUxsN2lLdHo0bW1NUFpvWXJjaVBlQ2dSVGtBMjZ5eHIxbE9OV3o0QVIv?=
 =?utf-8?B?SXlqQUpEbTVuMHNETFJrZm42bWVQaEIxSXUvanpDcEFJM1dZdXBva29TU3k2?=
 =?utf-8?B?eSsrVDNPdllBU0hiaUVLSTRDUnRWMHVhSmxURW1yQWNuUnRONDVhOU15a0hG?=
 =?utf-8?B?UzFZSEV1cWMxRzVkdVVqOFlOMFpGUElINmZuZnBMbVRLdUtJVnlhNEJLeWRC?=
 =?utf-8?B?d0k4SWV6UmhZWVJiN1BjanUzbm10dHFxeng2UVhHQTE2Zy9nRXg5Z1NkMExO?=
 =?utf-8?B?czQ5V0NjQ2ltcG9tZWtrWE5MdjVpZFp6N2ZiMnB1b005OVc0dzI5eE8zUmxL?=
 =?utf-8?B?ZGlFZ1lZVHlnb2tyTE45TFd0M1llVmpvSk04UURoSTB0NXhYNmQwQTdzcU9X?=
 =?utf-8?B?VlVWWkpsYzA0bkZLME9oRlZrZVpndTZ1UU02MnNTckpWeC96SmUyNWlRNXBE?=
 =?utf-8?B?OTE2d256YUFiTG5ZYkxEak4yaVg1czA0NmJEWDZQUzEvdUREb3hyY1lNQjQy?=
 =?utf-8?B?TnEyd3dpdW9hSC9XWFgrMm1qVGV1TzFwL2VobmhlRWl4dTNJWGtGbWRrV1Zj?=
 =?utf-8?B?enJmTkgvWTNWTUcyNnpCUC9zV0p0WS91L0duek9UVGZpT1g4V242NUcxVnl5?=
 =?utf-8?B?eThCbEdzRkFTS2pKZ3A2QUd4TGdCYXZUblpUR1dIWUVTVkRxNUJhZ2JwRzFT?=
 =?utf-8?B?ZnVhdHdsVW95eGo4NGJPUzhxYTZxM0tRWWFxQXF4Y0I1SFljWTBtN1J5U2pS?=
 =?utf-8?B?Nnh3aUNNWlYwZ2pneWFGTndYcUozSXdHcG1rMkptVWh2Mm9KT2VrVzVWQk5B?=
 =?utf-8?B?c1ZoZTd1RnNYNDBZaHgzRzdvYzFjaWNwc2ZNTmRQdVdVM1pucjhmdVU3VmJ2?=
 =?utf-8?B?alBRbUQ3KzJzSWlKZFhxS0FXWEt0b1lpUzFKa1hEN1d2UU5wSjdiQTFnbUZT?=
 =?utf-8?B?dGpXQ1IxNWpUUStzdkV5bmNFdzQ2TUswNkxVcGZnZTd6OG1uWnNUUHJzMU1P?=
 =?utf-8?B?enkzRHVyc1B0WWQyU2xtc3pGZFVTL2dTRW94SWxTeGZTanV1d3B6QlpGajQ3?=
 =?utf-8?B?ZUFFQmh4TGN1QlVOSXpDeVJzYmpNNGZEdTdLNTBQR1N1MVZlYWhhdGkzbkZG?=
 =?utf-8?Q?THGVfB65GOKgcK6g=3D?=
X-OriginatorOrg: fb.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c482884a-48ff-4a0c-f9cf-08da3925a53f
X-MS-Exchange-CrossTenant-AuthSource: PH0SPR01MB0020.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 May 2022 23:25:07.6914
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: VTJuZwaWwVYIYqzTTMpL+1iwIz7j0SRLWHWgYdhqNCZFwm/+jzMIJ+nJzx7raaLv
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR15MB2773
X-Proofpoint-ORIG-GUID: NMi10r3T0CCLd42twFiHxoB0qmGm8gVD
X-Proofpoint-GUID: NMi10r3T0CCLd42twFiHxoB0qmGm8gVD
Content-Transfer-Encoding: 7bit
X-Proofpoint-UnRewURL: 0 URL was un-rewritten
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.874,Hydra:6.0.486,FMLib:17.11.64.514
 definitions=2022-05-18_06,2022-05-17_02,2022-02-23_01
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



On 5/17/22 6:18 AM, Christian Brauner wrote:
> On Mon, May 16, 2022 at 09:47:08AM -0700, Stefan Roesch wrote:
>> This splits off the function need_remove_file_privs() from the function
>> do_remove_file_privs() from the function file_remove_privs().
>>
>> No intended functional changes in this patch.
>>
>> Signed-off-by: Stefan Roesch <shr@fb.com>
>> ---
> 
> Just a few nits...
> 
>>  fs/inode.c | 57 ++++++++++++++++++++++++++++++++++++------------------
>>  1 file changed, 38 insertions(+), 19 deletions(-)
>>
>> diff --git a/fs/inode.c b/fs/inode.c
>> index 9d9b422504d1..a6d70a1983f8 100644
>> --- a/fs/inode.c
>> +++ b/fs/inode.c
>> @@ -2010,17 +2010,8 @@ static int __remove_privs(struct user_namespace *mnt_userns,
>>  	return notify_change(mnt_userns, dentry, &newattrs, NULL);
>>  }
>>  
>> -/*
>> - * Remove special file priviledges (suid, capabilities) when file is written
>> - * to or truncated.
>> - */
>> -int file_remove_privs(struct file *file)
>> +static int need_file_remove_privs(struct inode *inode, struct dentry *dentry)
> 
> I'd rather call this file_needs_remove_privs()?
> 
Renamed to file_needs_remove_privs()

>>  {
>> -	struct dentry *dentry = file_dentry(file);
>> -	struct inode *inode = file_inode(file);
>> -	int kill;
>> -	int error = 0;
>> -
>>  	/*
>>  	 * Fast path for nothing security related.
>>  	 * As well for non-regular files, e.g. blkdev inodes.
>> @@ -2030,16 +2021,37 @@ int file_remove_privs(struct file *file)
>>  	if (IS_NOSEC(inode) || !S_ISREG(inode->i_mode))
>>  		return 0;
>>  
>> -	kill = dentry_needs_remove_privs(dentry);
>> -	if (kill < 0)
>> -		return kill;
>> -	if (kill)
>> -		error = __remove_privs(file_mnt_user_ns(file), dentry, kill);
>> +	return dentry_needs_remove_privs(dentry);
>> +}
>> +
>> +static int do_file_remove_privs(struct file *file, struct inode *inode,
>> +				struct dentry *dentry, int kill)
> 
> and that __file_remove_privs() which matches the rest of the file since
> here we don't have a lot of do_* but rather __* convention afaict.
> 

Renamed the function to __file_remove_privs().

>> +{
>> +	int error = 0;
>> +
>> +	error = __remove_privs(file_mnt_user_ns(file), dentry, kill);
>>  	if (!error)
>>  		inode_has_no_xattr(inode);
>>  
>>  	return error;
>>  }
>> +
>> +/*
>> + * Remove special file privileges (suid, capabilities) when file is written
>> + * to or truncated.
>> + */
>> +int file_remove_privs(struct file *file)
> 
> This is a generic comment, not aimed specifically at your change but we
> really need to get better at kernel-doc...
> 
> Since you're already touching this code could you at least to the
> exported function you're modifying add sm like:
> 

I added the kernel documentation.

> /**
>  * file_remove_privs - remove special file privileges (suid, capabilities) 
>  * @file: file to remove privileges from
>  * 
>  * When file is modified by a write or truncation ensure that special
>  * file privileges are removed.
>  *
>  * Return: 0 on success, negative errno on failure.
>  */
> int file_remove_privs(struct file *file)
> 
> This will then render on kernel.org/doc see e.g. lookup_one():
> https://www.kernel.org/doc/html/latest/filesystems/api-summary.html?highlight=lookup_one#c.lookup_one
> 
>> +{
>> +	struct dentry *dentry = file_dentry(file);
>> +	struct inode *inode = file_inode(file);
>> +	int kill;
>> +
>> +	kill = need_file_remove_privs(inode, dentry);
>> +	if (kill <= 0)
>> +		return kill;
>> +
>> +	return do_file_remove_privs(file, inode, dentry, kill);
>> +}
>>  EXPORT_SYMBOL(file_remove_privs);
>>  
>>  /**
>> @@ -2093,15 +2105,22 @@ EXPORT_SYMBOL(file_update_time);
>>  /* Caller must hold the file's inode lock */
>>  int file_modified(struct file *file)
> 
> Similar I'd add sm like:
> 

I added the kernel documentation.

> /**
>  * file_modified - handle mandated vfs changes when modifying a file
>  * @file: file that was was modified
>  * 
>  * When file has been modified ensure that special
>  * file privileges are removed and time settings are updated.
>  *
>  * Context: Caller must hold the file's inode lock.
>  *
>  * Return: 0 on success, negative errno on failure.
>  */
> int file_remove_privs(struct file *file)
> 
>>  {
>> -	int err;
>> +	int ret;
>> +	struct dentry *dentry = file_dentry(file);
>> +	struct inode *inode = file_inode(file);
>>  
>>  	/*
>>  	 * Clear the security bits if the process is not being run by root.
>>  	 * This keeps people from modifying setuid and setgid binaries.
>>  	 */
>> -	err = file_remove_privs(file);
>> -	if (err)
>> -		return err;
>> +	ret = need_file_remove_privs(inode, dentry);
>> +	if (ret < 0) {
>> +		return ret;
>> +	} else if (ret > 0) {
>> +		ret = do_file_remove_privs(file, inode, dentry, ret);
>> +		if (ret)
>> +			return ret;
>> +	}
> 
> The else-if branch looks a bit unorthodox to me. I'd probably rather
> make this:
> 
> 	ret = need_file_remove_privs(inode, dentry);
> 	if (ret < 0)
> 		return ret;
> 	
> 	if (ret > 0) {
> 		ret = do_file_remove_privs(file, inode, dentry, ret);
> 		if (ret)
> 			return ret;
> 	}
>>  
>>  	if (unlikely(file->f_mode & FMODE_NOCMTIME))
>>  		return 0;

I replaced the else if.

>> -- 
>> 2.30.2
>>
