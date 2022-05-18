Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3389652C77D
	for <lists+io-uring@lfdr.de>; Thu, 19 May 2022 01:28:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231293AbiERX20 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 18 May 2022 19:28:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48350 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229674AbiERX2O (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 18 May 2022 19:28:14 -0400
Received: from mx0a-00082601.pphosted.com (mx0a-00082601.pphosted.com [67.231.145.42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DBFD05F246;
        Wed, 18 May 2022 16:28:12 -0700 (PDT)
Received: from pps.filterd (m0109333.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 24IN6B4m013664;
        Wed, 18 May 2022 16:28:06 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=facebook;
 bh=J/TGzakSnBYnf82zAMFxa3XcB+ioNYtOJPcMDqkXz2I=;
 b=ox3qh8QvtHrRf5qwVaIu8rDN/2VmCVJBZYKmU9KcEgLKuhUaBM59MmVPccssJ+n/kYGa
 +4NWDJFKb8ZKpWEwG0zsXVA81L3dOen8pfz49vSbWb9felXbP3wPjbGIpuHvaVBlcFKL
 GHLogDz+KsmwVbFFYLwQPB2k86ATZ95xqHA= 
Received: from nam10-bn7-obe.outbound.protection.outlook.com (mail-bn7nam10lp2109.outbound.protection.outlook.com [104.47.70.109])
        by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 3g4d823w30-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 18 May 2022 16:28:06 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Zje1/dKvTbg3V/1eZWCBHlTJmrlp8dmcGcduILfsxi9V69ns/0xTfF722HrxJgyCLcrc/ymanE129RRhB51Qn7l+W2Lme1X3vBSh75Tbd6FKCm39LIl/zOnM8rEEdFRJNHHucU2KpLnlm5++6K80gG1ukFX7AYo1mMqXI6zQOepXNzyqVKmjUzWXEQvlmR4TVtm1FcI6YK/iyg3ezJQamYOKvP5b1dGd6vcFfKHM94iS7ILDE9D00KmKNwImZBTUI/Htz0HmQKab/ALqPTgQY3Lspdgr4FQeE8y080Ohsc9rCjwTSVBnAyu1DFaPZuJMa4llD4MSksVLY042/vgqJw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=J/TGzakSnBYnf82zAMFxa3XcB+ioNYtOJPcMDqkXz2I=;
 b=IhxwMUjFL3rD19/7IsanF4qmXtKFQhfNlkQLb+cckM0urE2JIj6YWwnRJMFxkPKQjRNqdaT8XwbfErbPsDCvy80Q7mTZHjswlmdMUWeKRLqL7TVL7kJUe9Qil34vsxshqlTke2/LOyEt/ZUAF7/oI3xv/xuj+QxI5m54LFhLHd02Hi6l/pjtMumr1Y4WLwzFgVFIaCvcwl33t1FQhKbIF949WeCmiQ0QK2FcqqKz28XXc7CHOwdFph64/o6jZvgHXdM6acBMh9cP2rOyYZcI8Ph36sxp8bC+cDH2vljkaq4nRsmFcpvNjpk9TTWPyZNJS0RIcPPKYCEDTEeVl31VXQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
Received: from PH0SPR01MB0020.namprd15.prod.outlook.com (2603:10b6:510:76::6)
 by BYAPR15MB2773.namprd15.prod.outlook.com (2603:10b6:a03:150::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5273.13; Wed, 18 May
 2022 23:28:02 +0000
Received: from PH0SPR01MB0020.namprd15.prod.outlook.com
 ([fe80::ad90:787e:697e:3ed1]) by PH0SPR01MB0020.namprd15.prod.outlook.com
 ([fe80::ad90:787e:697e:3ed1%2]) with mapi id 15.20.5273.015; Wed, 18 May 2022
 23:28:02 +0000
Message-ID: <bca738a3-2276-a6c3-7851-a4b048ead961@fb.com>
Date:   Wed, 18 May 2022 16:28:00 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.8.0
Subject: Re: [RFC PATCH v2 07/16] fs: split off need_file_update_time and
 do_file_update_time
Content-Language: en-US
To:     Christian Brauner <brauner@kernel.org>
Cc:     io-uring@vger.kernel.org, kernel-team@fb.com, linux-mm@kvack.org,
        linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        david@fromorbit.com, jack@suse.cz
References: <20220516164718.2419891-1-shr@fb.com>
 <20220516164718.2419891-8-shr@fb.com>
 <20220517134049.tfxbsbdscalblsmv@wittgenstein>
From:   Stefan Roesch <shr@fb.com>
In-Reply-To: <20220517134049.tfxbsbdscalblsmv@wittgenstein>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: BY3PR04CA0019.namprd04.prod.outlook.com
 (2603:10b6:a03:217::24) To PH0SPR01MB0020.namprd15.prod.outlook.com
 (2603:10b6:510:76::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: f0213e98-d00d-419b-c506-08da39260d3e
X-MS-TrafficTypeDiagnostic: BYAPR15MB2773:EE_
X-Microsoft-Antispam-PRVS: <BYAPR15MB277311F3EFCB94E1FD629130D8D19@BYAPR15MB2773.namprd15.prod.outlook.com>
X-FB-Source: Internal
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: IcVNoS7EWepUQN/ljEBT22DjXjm+Ra7M+toGinDwa9SxmnmyPA+cqZkAmk2trh6b8GBmjRvMK50C5wujMu2UEc0mw1H12k2H+0TpZ8hjxigHuH3agh4zNWkL/uY6Pxg7DVLwD/pqtJgwbEgXqFK9Ldey3y5XaMjN+QefeJ3SHoN6kKdpiWY8gpXpeCv7BzdomM5viG8NM1aViHOApH+atRY2kWJhwUQjnilgx3L0yBozEQzlVIuX08+UJDJl8yKRj2jHbDLLFcM7/ur5Hb2kDC5QzGDDikflStTs0VcgKOOgm2RLg4P1YrMEXF95UQNmpJ4giJ2a8ZpBlWFPO6WfodFdnBVef8fIU0N1P0HhzTcvh+mEz18V+UOWODSV0xoBDOZzaako0uMAG9BIPlGjAE3KHsyH44rknvwj0UOtgRhS9mVLGYb3af3ErdmZROEv4FP+YktMVUJFxgZ2adH6IjcWp2HcSFnxQhtOP8h46hb+9H6UVfiJkfBU6XGb/xNMf6uIkirsSUAyYo18iy53Y41A96nHylouBJRjnGzRSIVY46FKUsqK6wLJ8ev1SukU6reITXa/Nk55zsgIy9n2A1fvb8vMAK6pURDTvGHFVHnXuA7SCm4BOUTwCwkf5sfTw6JifQi3sk9C3lbdSWJrqT+oXP1c3xpkMbNDf54/JNUwK40VXuIt7UB5CfZIJIzxRyjXaP/KgFT1nH++eJ2hSjVI+D3O8hWFZwOMnehUwxr4V/527s4rIdAziwI2DCQe
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0SPR01MB0020.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(53546011)(31696002)(86362001)(6506007)(186003)(2616005)(83380400001)(38100700002)(2906002)(8936002)(6512007)(66556008)(8676002)(66946007)(4326008)(66476007)(5660300002)(31686004)(6486002)(6916009)(508600001)(316002)(36756003)(43740500002)(45980500001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?SFV3OFV1bWpTTlc1U3NLM3hFb040ZFFJQVNqZFdCdlltYXdsQ3dsQUhvUGtz?=
 =?utf-8?B?V3d1OE9vZmhwRTVDSTF4TDE3bU9aTGFZdHlkVDNTQXZZWituamVldUg1c3VE?=
 =?utf-8?B?U3p6ancwc1ZjVnYrS240S0NIakZBSmcxb2g5WXNRSjRsdG55MWVvdUloVjJh?=
 =?utf-8?B?ajdEQ3VQTis5OVpmSmN2YWRtb3RWNFA2TmdDWWsyWG1HTVI1TGx1KytmeDNG?=
 =?utf-8?B?WEN0alBGYWFuRjRSSkhTSEU5ZGE4RkdFd0JGNjdCYkpVbTB5bVpvUnNpTlU5?=
 =?utf-8?B?cSthVUdIaXZhMHVoNkw1UkNQcC9aMkNySW12TmlhcnE3VC9vd3h6WXZvM2Yw?=
 =?utf-8?B?QTlXQy9mV21yZnUzZDRjQ1gwaW1POHVFaTRYYlhlcE5zdytzTTJiZ29YdDRi?=
 =?utf-8?B?ZWo2ZHlPSUtpU1plNThrNFl6b0M3VGNhRzEvdTVsbGhDRHg5aUtIZ2VZT0Nk?=
 =?utf-8?B?a1F2Sk1Hemg5WVJBSFFUL040aTYzUkJveWY1RW5WVWFnTlZJQ010VHhUMnFq?=
 =?utf-8?B?c2JHVlYwUXJvVU96MWZUbVc4V3Z4cDVkUVBmY1l4a3UveHVKWG5PZjNuR0pz?=
 =?utf-8?B?VzUxS1laelNEdHF2RnJQOXFXem40c3BSWUlWNUYyRzIwbHgvNVRGTTZIYUIz?=
 =?utf-8?B?WTBVLzR3VHBQNnF2bU5RdWVjcDdObXBQNkY5cGZWaW5sYlFzWE55S2FueEtK?=
 =?utf-8?B?RzdYcWtna0FvSUVwdmlVeU1PQzFwL25RMzAzY1JHVmU3aFhQZzgwa0lBWmtR?=
 =?utf-8?B?UllraGlDTGwwaE0rTmpQQTVqeGo5T0JuZWUwNXdJWi9LL2FmTzRLeW5Hd3M2?=
 =?utf-8?B?bVk2ZkoxbXV2enJHSEZNa2l2SHh4dFZtdDkzK3F1SjZ4NlhwTWZxVEFsS2FX?=
 =?utf-8?B?Z2plWWRpcUhmblBJT0hoeEcvdDlONHdjZHhKM1didmE3Y1F4eE9QR3Vxc0pJ?=
 =?utf-8?B?M09UbWM0YktIZXhJNmUrT2hnNDFSSTFvTmZMY2JvbWdRYzBkT3BhS3gwUC9q?=
 =?utf-8?B?dWQ1bERRNnN1SXRXQWJOQWxsbHozaWpSUDRzUGp3VHp5ZVA5czVyZ3pPTXR4?=
 =?utf-8?B?TXdzaXg1SWZ4SXNPeVdMeDNWcHlmL3JLTzhPOHhlNFhTUjRyZjIzUVhJZDRx?=
 =?utf-8?B?cTgxenh2Z0swUzVXakdrTDlkd1RJUWdkeDFWZ3FFenQxWENTSVVrVnl3b2U4?=
 =?utf-8?B?VklGTFI3VXQ2clZUSXlPaEt2cjVJd2xHUEtaRGdaR0xVRzN0Sms2d3NZOUl5?=
 =?utf-8?B?TWNTZVJtUzlKeitVU0VoQ1RhWjNYQnNnLzl1dXRSenRGZWY3c3lvT0F6djFH?=
 =?utf-8?B?SUU4SjBMenpkNEhLUnI2SjhaRm5jbXB5S2tKNW91RTMyOVlSMEZFdFJmemJJ?=
 =?utf-8?B?QWxxOXZtTnppT0ptMENwYkt1ZFA0bXJDbHgzUFFMZjMySHFtUzcybUtZRk11?=
 =?utf-8?B?VStQU1FsWmk4aXEzd3hvYVI3azlESFN5REVWM3o4emp5ME5mQmJjN1puRk0y?=
 =?utf-8?B?YnYxdGFsVFEzRk5PN04zaDMwYnZzSFVXbXBaVWx0VUdyb2RGRXhvRUFxK0ZG?=
 =?utf-8?B?dGR0SDlPRHRuamxMTTNkUTk5a3pXdUlpMEo5V3JsQnhtT1RyMG1ERWZJRlpX?=
 =?utf-8?B?VTdPOTZXUVArZU8reU5qSTI1NkpacGUzQ0Vnb2gxbXdLSytZSEVGdDhiYWdM?=
 =?utf-8?B?ZFZFUDNtVEVpV1dMT09CT1p6RWI0Y1dGS0dGa29YbzIwUDUyMGZ4WktzenZP?=
 =?utf-8?B?VjNJSU1tOC84YUxRalp1YnIwWnJrejBHbEIwaTZ4L25QOW5PVEkzb2ZCU1hJ?=
 =?utf-8?B?TC9aTm1QZUVUZS9EcGdlbFdaeVNKWVdER0g2bWR5RHRXcm1rYThvVnNwcC9Y?=
 =?utf-8?B?Kzc3UktiWUpITkNIS2N1NGVrRS95dkFDMWkzVnFTSlQ4aFRJalA0RHVINmJo?=
 =?utf-8?B?dVBCbjNuMUZ2V2NyNmZ0K1dEeEdFK0YwOGE4QUxlQll6bzl1am5aQjV1QVRL?=
 =?utf-8?B?NTNnOFJQRWVjNzZ6WkFMaFBDWHpmNnZrNTRLdzNDQ0gxaVFPZjVRdHVqb3BF?=
 =?utf-8?B?bjVJYUFDbEhORGIrWnh1c0hRSVYyTytFaGo1enpGemxpVWJOa3dpcldKa0xr?=
 =?utf-8?B?QVltMXVtM1Uva1BzREZhTnRncCtuMThOUVRpUFBXNVAyOEY4dlNvanZSdG5x?=
 =?utf-8?B?Q3AyUjNGRTZ6L2VWWG1IdmV6ZVFRS0J1STJDQTIzMXIvUStmTVBEQWZMZE5Z?=
 =?utf-8?B?eUs1ZHEwRUs2dVNZNStDSXBHVk5QKyttUjhTUHNQb01oZ2lIbUpXcS9wZWJ6?=
 =?utf-8?B?akhhR0tJY0RsMGVOM1Vmb2F2eVM1Sy9lL1VubDRJZVBQcEs2UDNGYnFqaU5Z?=
 =?utf-8?Q?sI1bill2yqsJbpbg=3D?=
X-OriginatorOrg: fb.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f0213e98-d00d-419b-c506-08da39260d3e
X-MS-Exchange-CrossTenant-AuthSource: PH0SPR01MB0020.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 May 2022 23:28:02.1041
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: WJv0pmThExoDQVaDMgno0vHHY+DXmMYazX2typzT0jsA5NRFv2MPpLIL2b+lwjd0
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR15MB2773
X-Proofpoint-GUID: h5e-f4OWOASlGgbMdtwIa9CAigCg_qSv
X-Proofpoint-ORIG-GUID: h5e-f4OWOASlGgbMdtwIa9CAigCg_qSv
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



On 5/17/22 6:40 AM, Christian Brauner wrote:
> On Mon, May 16, 2022 at 09:47:09AM -0700, Stefan Roesch wrote:
>> This splits off the functions need_file_update_time() and
>> do_file_update_time() from the function file_update_time().
>>
>> This is required to support async buffered writes.
>> No intended functional changes in this patch.
>>
>> Signed-off-by: Stefan Roesch <shr@fb.com>
>> ---
>>  fs/inode.c | 71 ++++++++++++++++++++++++++++++++++++------------------
>>  1 file changed, 47 insertions(+), 24 deletions(-)
>>
>> diff --git a/fs/inode.c b/fs/inode.c
>> index a6d70a1983f8..1d0b02763e98 100644
>> --- a/fs/inode.c
>> +++ b/fs/inode.c
>> @@ -2054,35 +2054,22 @@ int file_remove_privs(struct file *file)
>>  }
>>  EXPORT_SYMBOL(file_remove_privs);
>>  
>> -/**
>> - *	file_update_time	-	update mtime and ctime time
>> - *	@file: file accessed
>> - *
>> - *	Update the mtime and ctime members of an inode and mark the inode
>> - *	for writeback.  Note that this function is meant exclusively for
>> - *	usage in the file write path of filesystems, and filesystems may
>> - *	choose to explicitly ignore update via this function with the
>> - *	S_NOCMTIME inode flag, e.g. for network filesystem where these
>> - *	timestamps are handled by the server.  This can return an error for
>> - *	file systems who need to allocate space in order to update an inode.
>> - */
>> -
>> -int file_update_time(struct file *file)
>> +static int need_file_update_time(struct inode *inode, struct file *file,
>> +				struct timespec64 *now)
> 
> I think file_need_update_time() is easier to understand.
> 

I renamed the function to file_needs_update_time().

>>  {
>> -	struct inode *inode = file_inode(file);
>> -	struct timespec64 now;
>>  	int sync_it = 0;
>> -	int ret;
>> +
>> +	if (unlikely(file->f_mode & FMODE_NOCMTIME))
>> +		return 0;
> 
> Moving this into this generic helper and using the generic helper
> directly in file_update_atime() leads to a change in behavior for
> file_update_time() callers. Currently they'd get time settings updated
> even if FMODE_NOCMTIME is set but with this change they'd not get it
> updated anymore if FMODE_NOCMTIME is set. Am I reading this right?
> 

Correct, this was not intended and will be addressed with the next version of the patch.

> Is this a bugfix? And if so it should be split into a separate commit...
> 
>>  
>>  	/* First try to exhaust all avenues to not sync */
>>  	if (IS_NOCMTIME(inode))
>>  		return 0;
>>  
>> -	now = current_time(inode);
>> -	if (!timespec64_equal(&inode->i_mtime, &now))
>> +	if (!timespec64_equal(&inode->i_mtime, now))
>>  		sync_it = S_MTIME;
>>  
>> -	if (!timespec64_equal(&inode->i_ctime, &now))
>> +	if (!timespec64_equal(&inode->i_ctime, now))
>>  		sync_it |= S_CTIME;
>>  
>>  	if (IS_I_VERSION(inode) && inode_iversion_need_inc(inode))
>> @@ -2091,15 +2078,49 @@ int file_update_time(struct file *file)
>>  	if (!sync_it)
>>  		return 0;
>>  
>> +	return sync_it;
>> +}
>> +
>> +static int do_file_update_time(struct inode *inode, struct file *file,
>> +			struct timespec64 *now, int sync_mode)
>> +{
>> +	int ret;
>> +
>>  	/* Finally allowed to write? Takes lock. */
>>  	if (__mnt_want_write_file(file))
>>  		return 0;
>>  
>> -	ret = inode_update_time(inode, &now, sync_it);
>> +	ret = inode_update_time(inode, now, sync_mode);
>>  	__mnt_drop_write_file(file);
>>  
>>  	return ret;
>>  }
> 
> Maybe
> 
> static int __file_update_time(struct inode *inode, struct file *file,
> 			      struct timespec64 *now, int sync_mode)
> {
> 	int ret = 0;
> 
> 	/* try to update time settings */
> 	if (!__mnt_want_write_file(file)) {
> 		ret = inode_update_time(inode, now, sync_mode);
> 		__mnt_drop_write_file(file);
> 	}
> 
> 	return ret;
> }
> 
> reads a little easier and the old comment is a bit confusing imho. I'd
> just say we keep it short. 
> 

I made the change.

>> +
>> +/**
>> + *	file_update_time	-	update mtime and ctime time
>> + *	@file: file accessed
>> + *
>> + *	Update the mtime and ctime members of an inode and mark the inode
>> + *	for writeback.  Note that this function is meant exclusively for
>> + *	usage in the file write path of filesystems, and filesystems may
>> + *	choose to explicitly ignore update via this function with the
>> + *	S_NOCMTIME inode flag, e.g. for network filesystem where these
>> + *	timestamps are handled by the server.  This can return an error for
>> + *	file systems who need to allocate space in order to update an inode.
>> + */
>> +
>> +int file_update_time(struct file *file)
> 
> My same lame complaint as before to make this kernel-doc. :)
> 
> /**
>  * file_update_time - update mtime and ctime time
>  * @file: file accessed
>  *
>  * Update the mtime and ctime members of an inode and mark the inode or
>  * writeback. Note that this function is meant exclusively for sage in
>  * the file write path of filesystems, and filesystems may hoose to
>  * explicitly ignore update via this function with the _NOCMTIME inode
>  * flag, e.g. for network filesystem where these imestamps are handled
>  * by the server. This can return an error for ile systems who need to
>  * allocate space in order to update an inode.
>  *
>  * Return: 0 on success, negative errno on failure.
>  */
> int file_update_time(struct file *file)
> 

I added the above kernel documentation, I only fixed a couple of typos.

>> +{
>> +	int err;
>> +	struct inode *inode = file_inode(file);
>> +	struct timespec64 now = current_time(inode);
>> +
>> +	err = need_file_update_time(inode, file, &now);
>> +	if (err < 0)
>> +		return err;
> 
> I may misread this but shouldn't this be err <= 0, i.e., if it returns 0
> then we don't need to update time?
> 

Good catch. Fixed.

>> +
>> +	return do_file_update_time(inode, file, &now, err);
>> +}
>>  EXPORT_SYMBOL(file_update_time);
>>  
>>  /* Caller must hold the file's inode lock */
>> @@ -2108,6 +2129,7 @@ int file_modified(struct file *file)
>>  	int ret;
>>  	struct dentry *dentry = file_dentry(file);
>>  	struct inode *inode = file_inode(file);
>> +	struct timespec64 now = current_time(inode);
>>  
>>  	/*
>>  	 * Clear the security bits if the process is not being run by root.
>> @@ -2122,10 +2144,11 @@ int file_modified(struct file *file)
>>  			return ret;
>>  	}
>>  
>> -	if (unlikely(file->f_mode & FMODE_NOCMTIME))
>> -		return 0;
>> +	ret = need_file_update_time(inode, file, &now);
>> +	if (ret <= 0)
>> +		return ret;
>>  
>> -	return file_update_time(file);
>> +	return do_file_update_time(inode, file, &now, ret);
>>  }
>>  EXPORT_SYMBOL(file_modified);
>>  
>> -- 
>> 2.30.2
>>
