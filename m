Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 91250513C4E
	for <lists+io-uring@lfdr.de>; Thu, 28 Apr 2022 22:04:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347635AbiD1UHR (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 28 Apr 2022 16:07:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45406 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237720AbiD1UHQ (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 28 Apr 2022 16:07:16 -0400
Received: from mx0b-00082601.pphosted.com (mx0b-00082601.pphosted.com [67.231.153.30])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2DF06BF533;
        Thu, 28 Apr 2022 13:04:01 -0700 (PDT)
Received: from pps.filterd (m0109332.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 23SJfjNa005872;
        Thu, 28 Apr 2022 13:03:58 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=facebook;
 bh=XFewJQ3Y5HXdb+sOwcozagPX1eFH4iQC2O5kgGsOQCw=;
 b=ognpr2cE4h7yk2vf/sSM0uzJt1jxJ3ko+ZvRV9sWYQrG/P/buahr3K4+YvG13eRWp3vR
 sm+aD1/sOIq4EcfMhF7Oj1A8yndgpzXNO9pe21dZMZGegt8+tlq2OvKlXthqpfTBh5NT
 l5qWG0TqgRDLj/GF3bBffcGMIi+6B0uU+nk= 
Received: from nam12-bn8-obe.outbound.protection.outlook.com (mail-bn8nam12lp2168.outbound.protection.outlook.com [104.47.55.168])
        by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 3fqvxxtjmw-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 28 Apr 2022 13:03:58 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=QwXzClu4dIN6rDjPZc2yQiFn2Dp9A0b+lsrMK/9sUiolveQFs8jkhNfjd/ZK2WPyYr8jkkI9Pjke1uiF17CwMjS6WjaIDXqdiCSHIbrikjCVKYQqyXyNvXKq84IyqJVad9+femX707qTvmiO29pDXinfSqu9ocxtrzr3EOyic/GN9X9ugQr6VFgnd2qEC1OPAJkQ51IX8dYsFU7GkJqZ6vO+qVfRnC/jyDetweGYq7zASHQyQLQdisUa6PNS3Rl+aossWTuWfkOFwOqnWhGCt09VJGt3ty7OhFOkS26iQHGRNUsKZXAdND5iYA1SYTAQvweJ0HyY4dxCHT2JaQvfIw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=XFewJQ3Y5HXdb+sOwcozagPX1eFH4iQC2O5kgGsOQCw=;
 b=ThCm2cSLmIseIExwtSv4VZRGHTILixiOKK+0Q2qvy77eKk8sAlUVliOOnmNtuf+KR+Gd4504EdnCxbyMmqIbsQuZ2LZZy9uQq7Q2d6x5/u7DtMe06aeKxcQcMMFVRyBI9WKsSISng0bGWv76izGlBi9kLY6/1tEdg8xj30V8Fi6hBI4TL5wQ8MJM0er/7/X2Ey2u72Rf8Mh5JkHQcPYtCTTh6/L3unadGtuaySo8HlVgabmOg+9/IKv9NYxdY9EmTWWuljbHtftmChUzxA7571pL8o1Mx7V/5YSQmFVIU83zUvNh2hJuZvvycMdYmSZhEnpbg/ubMKxualU1GhB8zQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
Received: from MW4PR15MB4410.namprd15.prod.outlook.com (2603:10b6:303:bf::10)
 by DM5PR1501MB2118.namprd15.prod.outlook.com (2603:10b6:4:a5::31) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5186.21; Thu, 28 Apr
 2022 20:03:51 +0000
Received: from MW4PR15MB4410.namprd15.prod.outlook.com
 ([fe80::687a:3f7e:150b:1091]) by MW4PR15MB4410.namprd15.prod.outlook.com
 ([fe80::687a:3f7e:150b:1091%7]) with mapi id 15.20.5206.013; Thu, 28 Apr 2022
 20:03:51 +0000
Message-ID: <8b71929a-895d-fdab-468d-541eaa8b4128@fb.com>
Date:   Thu, 28 Apr 2022 13:03:49 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.8.0
Subject: Re: [RFC PATCH v1 06/18] xfs: add iomap async buffered write support
Content-Language: en-US
To:     Dave Chinner <david@fromorbit.com>
Cc:     io-uring@vger.kernel.org, kernel-team@fb.com, linux-mm@kvack.org,
        linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org
References: <20220426174335.4004987-1-shr@fb.com>
 <20220426174335.4004987-7-shr@fb.com>
 <20220426225436.GQ1544202@dread.disaster.area>
From:   Stefan Roesch <shr@fb.com>
In-Reply-To: <20220426225436.GQ1544202@dread.disaster.area>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: BYAPR11CA0068.namprd11.prod.outlook.com
 (2603:10b6:a03:80::45) To MW4PR15MB4410.namprd15.prod.outlook.com
 (2603:10b6:303:bf::10)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: cda6e1e8-a860-4c55-f58b-08da295236d2
X-MS-TrafficTypeDiagnostic: DM5PR1501MB2118:EE_
X-Microsoft-Antispam-PRVS: <DM5PR1501MB21183ECB4E51306268194FD2D8FD9@DM5PR1501MB2118.namprd15.prod.outlook.com>
X-FB-Source: Internal
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Qh6Qz4n0HqyeVuJpsdyqq6hsNCe0OjAbWPAfv4YBlLUG8a/mZlgFQ+lBnzrxa1GA7F0C5hb7xygSZOyfESBUgPWbzH9GcHPq9xzyPr9LjEQI2x6XcUc/GiApAD7IKt47wBdE+DUcUccYnF0EFmqn6CeXJrVoo9ik/LHJjqpw625muDOcmub+M0D8u0P0TykvtEOmUH6Aj4Jp8EZgeG4G2oGCKYqSCRIGG8XQG31E8h7ITcQxc2VNF6oNHgNhXebnDL73Bgckatfi354M5nDsDSdeihHHONG2FD7F8cPYkK9fpROe1gV1gPRpE9VwOKZT/dshmowtlBPq3E7le0HFJ4IMVv+GzM8ftMzsb79lnlRfuUemttcFMgIZ/CNM9Ue0jX4xFWVowZLvZuDGCnmAZCdd+c0w4p+NSRJoXEIiCvn5LFddBakb572yuUMjthASzaqN8ksD8EFneW3g/ia1m6JDYyoRrWs+FEdrM+B/utpkATaduvzFByUwTEjQhvG1bGDgTz3JBGGMJaUp58nmy31wF0ee8TC3Ee9f56UjtkjletEPeCdQLg4WERDEjZUf7p+VFml0RGPOAmmZKeD3D+Y9Ux2CA/UI5MK/WYXQZPJnTGjJtzDmdfId2FuG+u4zT7L9B6vpvw1C/pLKPy24ltNLK1aR+/nGTTZ6QLuJrlS9CqAJK4LmyszaSM7P4XJa84qMwz/fJTaLiXfZf8mD9/GgGu0OMTj73mnC2nGlo4c=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MW4PR15MB4410.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(31696002)(6486002)(2906002)(86362001)(508600001)(38100700002)(66476007)(66556008)(8676002)(4326008)(66946007)(316002)(5660300002)(6916009)(8936002)(6512007)(31686004)(83380400001)(2616005)(186003)(6506007)(53546011)(36756003)(45980500001)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?OTVXRmZJQVZyM3FZR09vQU5xa2ZJSklTZFIwOVN3dGh2eGlKWjBpdGZDUDNm?=
 =?utf-8?B?cFA1KzlPWWMwU200YjVyNHFFd25LY3dRN01WQnh5UlZ0UHorL0prSmV4RFkz?=
 =?utf-8?B?SVBaa2hSMExiaitNYlZRUTNUcGdCc2xyZ3VxNDBLdkEwM25QZXF5c3N3MUdy?=
 =?utf-8?B?VExJWXdFSmtkaUY1b1MrSkh5ejEzakNsSlRPRW4yTjdYVkhXcnFzYjhVbE5k?=
 =?utf-8?B?eFc1ZXc3RUsva1VUeWRnK1ZBNWRJVHZxMG9abThNSWpncmovQ2tJWnF2TmFB?=
 =?utf-8?B?dmRKWjJNdDZZVVFzSm9HUSs3NlI2ZTF1RVlYWWQ2TC95eVJrc0pIcTdoc1lM?=
 =?utf-8?B?QUttN0dQdzBUN0NiaGJIcTRXQlVRblBMWVR6T1Q0em1oU3ZLWWF0NXYzaEl2?=
 =?utf-8?B?RS9QODBmcXBodXB0L251dEVZWjljQzBYakVuZUYyY2pWcXFBcHJ0UE5CVnpi?=
 =?utf-8?B?ZVdrQ3ZZalhYMTNnVXplNUJXa2VKaDY3SVZDZWRNWlVVQ0VOOTN4M2VMNVpa?=
 =?utf-8?B?SklhNElKeXVQVWwwdkkyLzlvcnRPMXhSZmFXSUhyWHpKWW8yem52WWpoSjJW?=
 =?utf-8?B?ZU5iN21vVnovczdEUERNbCtEMURBQnlZU1p2aDJoZkhHQXEzSXc5QXR6Qlli?=
 =?utf-8?B?SzZ3enBwdkw4QXdqdXhKaENNU0FTRjF6ZmM0SXo4RWlFRmtGUW5Uc3JHM2ZP?=
 =?utf-8?B?ZDBMM1BQeWV5VHh0ZHU2Y0F4QkdlM29TQ2VZZmducUltV1VtMThVelQzVmt4?=
 =?utf-8?B?a0pMN05hNmJneXFxMnh1NUhWdWlHR1ZGRG03K3E0Z2Z3b2pFWkxLYlVtNkZh?=
 =?utf-8?B?OC9JNDZZbjZBdWRYKzZSWERtNDFUa3dmRE01U2ZZY0w2cVdPYzZ6b0h2REUv?=
 =?utf-8?B?bnJ0WTBlSitwRjlIOGV0Q1FvQXdIRzhJSllBbEpla0pJcFp2eFJUZm5Ob1Zs?=
 =?utf-8?B?VmNMc2JaMWdSa2R3Mmd3eHVpRXlsTmRRczI3YnJtU2N0Tlk2ZXRObTBGOXdN?=
 =?utf-8?B?VlB6OFJ4S0NZd2ErSXBXR01OeGJsdEJ5elowTStCME40Yk03SVBJb29raU1q?=
 =?utf-8?B?ZzdQSDZxQlRjZWdYeWNHek5qdFNOSVByWUtIUG1ubDdHNU5QMzVPUzhIWWJ2?=
 =?utf-8?B?ZWRqYjkzL0VzQTRnclJ0Wkx6a0NMKzBmeGdRN0dPdHJlMkhTZndzZ1lYcHg4?=
 =?utf-8?B?bVM4eFlQNWU0UkxDQnk2TndiUEtDY3QybDUxdTYrRVQyYXIzbFFESklqSUxn?=
 =?utf-8?B?VXBZYnRLVHVDYXZtL0N3UVdZcVlsSTg3d3RiMnoyY2dGUnNNbW4ySUcwbGdt?=
 =?utf-8?B?NjM0U2hjQWpWMW0wem5namJ3VysvNzR3d3hyUnpvam9VQkdxUDE4TlN2YWlk?=
 =?utf-8?B?dzhGMTNoRXNWZmdPOXR6ZzZucExuWExDZ1dIeVZ2WDlXck56azRmQ1BseXhP?=
 =?utf-8?B?ZXo3THN4Z2lwWU1hKzZBSEF5U0FocUEzUUZkbDVQS0xCVUh5ZmphMCt5Y3BS?=
 =?utf-8?B?RldJMDJ4UGV0dEp5UHhIRWVvQUNsODZYMi9BeVFGbnlkMlhaWnd3SG1aMmI3?=
 =?utf-8?B?L1pKK1B4SlFYWE82VHVFRElHOUI3NTRPMG5pazhxbm1WbUc4K1pUbElqV2lD?=
 =?utf-8?B?Rnl2Qm0xNjRTSTVzY1Z3bVBNbE5idXh2dHQ4WmVCSEZYMzFWWkJrQVlVVVQw?=
 =?utf-8?B?cGZYVzR0NzBrdWdaZ0ZVL3ppK0hQV054UlZSSW1FN3dEb05DNCtaOHhRdGFy?=
 =?utf-8?B?bTZoL2tTMzBPcXNPNWxUQ3poUGtWNnZoNXBPMWpyejZMc0t0Tm9MeXltMjc5?=
 =?utf-8?B?ZUhFanN1cTJkR21nMjJHUjhsRHYrOG84RmV1YWh3K2FuL1lhb0E0cnM5REFN?=
 =?utf-8?B?U0JhdmcrclpOcDB0cE44ek4yVy9YREhXSWQ3Zml3Q2o3WnZSTXlvVVd1QXNa?=
 =?utf-8?B?c3kyVzdkNXlkNXNHM3RSMXhla2wzdXBmeDdMR3BQSit4Umd2Nk5BM2VtY0Vt?=
 =?utf-8?B?N1g3SkV4cGNwQ05Zb3Z5WXE4dFhvbmxJZmNseUVIS3pjV2R6SVkvTVhZd1I5?=
 =?utf-8?B?SVZTNnVzNWUrQ1NDQm1WOWNoSUxZR2VsVkZvYzFsK1E4ejduTTZ2VktRSHZq?=
 =?utf-8?B?YWIxdHcxRlB3T05xbURGOEVoZCtvZkRUbGtLUFpsMElyMVRTc2dFc0RTZjBD?=
 =?utf-8?B?Wmd5R2pRK2s2MnVDcFBZYVN2UjlnUEVXcUc0V1pIYWVna1NxSUp2N2ZralhW?=
 =?utf-8?B?dFFCY2hnUnl0eEVIWmlubmszOGFyZEdWTWlFUTI2KzkrTzVaZktIWmVoUDRw?=
 =?utf-8?B?UTZZd2pSVFRFc05TNGo0UlZURWRvYWRXeWlURGNUVmFWVjZnY1VUUXJMMlVK?=
 =?utf-8?Q?HRBIxNhEnNExWjSw=3D?=
X-OriginatorOrg: fb.com
X-MS-Exchange-CrossTenant-Network-Message-Id: cda6e1e8-a860-4c55-f58b-08da295236d2
X-MS-Exchange-CrossTenant-AuthSource: MW4PR15MB4410.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Apr 2022 20:03:51.1292
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: yxbI+vS0y4Fs4oZPytsc/Zi9X839xoXvm8Z0TK8+LQyEa438inxHlH3zoNtt1i/h
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR1501MB2118
X-Proofpoint-GUID: 7imTyyTbuZM9SRdn0lCfgHAW3pvrrnD4
X-Proofpoint-ORIG-GUID: 7imTyyTbuZM9SRdn0lCfgHAW3pvrrnD4
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



On 4/26/22 3:54 PM, Dave Chinner wrote:
> On Tue, Apr 26, 2022 at 10:43:23AM -0700, Stefan Roesch wrote:
>> This adds the async buffered write support to the iomap layer of XFS. If
>> a lock cannot be acquired or additional reads need to be performed, the
>> request will return -EAGAIN in case this is an async buffered write request.
>>
>> Signed-off-by: Stefan Roesch <shr@fb.com>
>> ---
>>  fs/xfs/xfs_iomap.c | 33 +++++++++++++++++++++++++++++++--
>>  1 file changed, 31 insertions(+), 2 deletions(-)
>>
>> diff --git a/fs/xfs/xfs_iomap.c b/fs/xfs/xfs_iomap.c
>> index e552ce541ec2..80b6c48e88af 100644
>> --- a/fs/xfs/xfs_iomap.c
>> +++ b/fs/xfs/xfs_iomap.c
>> @@ -881,18 +881,28 @@ xfs_buffered_write_iomap_begin(
>>  	bool			eof = false, cow_eof = false, shared = false;
>>  	int			allocfork = XFS_DATA_FORK;
>>  	int			error = 0;
>> +	bool			no_wait = (flags & IOMAP_NOWAIT);
>>  
>>  	if (xfs_is_shutdown(mp))
>>  		return -EIO;
>>  
>>  	/* we can't use delayed allocations when using extent size hints */
>> -	if (xfs_get_extsz_hint(ip))
>> +	if (xfs_get_extsz_hint(ip)) {
>> +		if (no_wait)
>> +			return -EAGAIN;
>> +
>>  		return xfs_direct_write_iomap_begin(inode, offset, count,
>>  				flags, iomap, srcmap);
> 
> Why can't we do IOMAP_NOWAIT allocation here?
> xfs_direct_write_iomap_begin() supports IOMAP_NOWAIT semantics just
> fine - that's what the direct IO path uses...

I'll make that change in the next version.
> 
>> +	}
>>  
>>  	ASSERT(!XFS_IS_REALTIME_INODE(ip));
>>  
>> -	xfs_ilock(ip, XFS_ILOCK_EXCL);
>> +	if (no_wait) {
>> +		if (!xfs_ilock_nowait(ip, XFS_ILOCK_EXCL))
>> +			return -EAGAIN;
>> +	} else {
>> +		xfs_ilock(ip, XFS_ILOCK_EXCL);
>> +	}
> 
> handled by xfs_ilock_for_iomap().

The helper xfs_ilock_for_iomap cannot be used for this purpose. The function
xfs_ilock_for_iomap tries to deduce the lock mode. For the function xfs_file_buffered_write()
the lock mode must be exclusive. However this is not always the case when the
helper xfs_ilock_for_iomap is used. There are cases where xfs_is_cow_inode(() is not
true.

I'll add a new helper that will be used here.

>>  
>>  	if (XFS_IS_CORRUPT(mp, !xfs_ifork_has_extents(&ip->i_df)) ||
>>  	    XFS_TEST_ERROR(false, mp, XFS_ERRTAG_BMAPIFORMAT)) {
>> @@ -902,6 +912,11 @@ xfs_buffered_write_iomap_begin(
>>  
>>  	XFS_STATS_INC(mp, xs_blk_mapw);
>>  
>> +	if (no_wait && xfs_need_iread_extents(XFS_IFORK_PTR(ip, XFS_DATA_FORK))) {
>> +		error = -EAGAIN;
>> +		goto out_unlock;
>> +	}
>> +
> 
> Also handled by xfs_ilock_for_iomap().

I'll remove this check with the next version.

> 
>>  	error = xfs_iread_extents(NULL, ip, XFS_DATA_FORK);
>>  	if (error)
>>  		goto out_unlock;
>> @@ -933,6 +948,10 @@ xfs_buffered_write_iomap_begin(
>>  	if (xfs_is_cow_inode(ip)) {
>>  		if (!ip->i_cowfp) {
>>  			ASSERT(!xfs_is_reflink_inode(ip));
>> +			if (no_wait) {
>> +				error = -EAGAIN;
>> +				goto out_unlock;
>> +			}
>>  			xfs_ifork_init_cow(ip);
>>  		}
> 
> Also handled by xfs_ilock_for_iomap().
> 

I'll remove this check with the next version.


>>  		cow_eof = !xfs_iext_lookup_extent(ip, ip->i_cowfp, offset_fsb,
>> @@ -956,6 +975,11 @@ xfs_buffered_write_iomap_begin(
>>  			goto found_imap;
>>  		}
>>  
>> +		if (no_wait) {
>> +			error = -EAGAIN;
>> +			goto out_unlock;
>> +		}
>> +
> 
> Won't get here because this is COW path, and xfs_ilock_for_iomap()
> handles returning -EAGAIN for that case.

I'll remove this check with the next version.

> 
>>  		xfs_trim_extent(&imap, offset_fsb, end_fsb - offset_fsb);
>>  
>>  		/* Trim the mapping to the nearest shared extent boundary. */
>> @@ -993,6 +1017,11 @@ xfs_buffered_write_iomap_begin(
>>  			allocfork = XFS_COW_FORK;
>>  	}
>>  
>> +	if (no_wait) {
>> +		error = -EAGAIN;
>> +		goto out_unlock;
>> +	}
> 
> Why? Delayed allocation doesn't block...

I'll remove this check with the next version.

> 
> Cheers,
> 
> Dave.
> 
