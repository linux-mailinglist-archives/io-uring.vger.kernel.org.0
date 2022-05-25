Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F14195345F1
	for <lists+io-uring@lfdr.de>; Wed, 25 May 2022 23:44:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234247AbiEYVoU (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 25 May 2022 17:44:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44908 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229811AbiEYVoT (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 25 May 2022 17:44:19 -0400
Received: from mx0a-00082601.pphosted.com (mx0b-00082601.pphosted.com [67.231.153.30])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7EEF3B36E5;
        Wed, 25 May 2022 14:44:16 -0700 (PDT)
Received: from pps.filterd (m0001303.ppops.net [127.0.0.1])
        by m0001303.ppops.net (8.17.1.5/8.17.1.5) with ESMTP id 24PGtaF5012050;
        Wed, 25 May 2022 14:44:08 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=facebook;
 bh=5xNQgwjTLOo8fiuZ5vcZ4sWwnM20zplriWgBYccI2sY=;
 b=BWb33Q8FbciddjTCNXskSZBdze7RUF2bmS+r6X75H9skn+6LcMtKEIHXOxQPQGfM1OpD
 pSy0s1unSnjWJT63t+ql9oV18zyMZnh07JtXDOYzQ1fuy4pWSwZvwS499pZAnQZ2iia9
 svwqjLM934hLNk1t5EHZaiFy0+oHKhblfpU= 
Received: from nam12-dm6-obe.outbound.protection.outlook.com (mail-dm6nam12lp2175.outbound.protection.outlook.com [104.47.59.175])
        by m0001303.ppops.net (PPS) with ESMTPS id 3g9qtua773-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 25 May 2022 14:44:08 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=cI7lbepU1ShZ6RQQ1rgbwtIGMn2qKdJY8wsjkDg7PEz6G8OxKLMoBW6kR7Zwrpjv7klnbVZTZ48XOmE80LzmpUGU+YCeajHieGfwacfwRM7G/gzef+fDgYCN/xBiJKtmgmKdYN5Vaa6b9sK/KMMCH0FD2+egqTVpM0CnLpA9jSE8g7DPdyPT5bTM+fNtCwsQHqD6vEfNzQ0cOzP2kF3ObRCwpDbgb+fPEBFcKL/8kvnprVXvtTI9/kGDqu/kjXnwThvMLZQuuzO4j85Z4U7f/NGJHStTRbR9/aFeziYoRhuW+GeSQOyrF1qCO4vciVDs+viy+evIjakSXnPNOTOO6A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=5xNQgwjTLOo8fiuZ5vcZ4sWwnM20zplriWgBYccI2sY=;
 b=WomBKG0+jn9bNL5Vmu0LqnFC+kMGjp9IVhbESvBZLRCLyZC2boUFzp3MgDVIvGwAlhCz1kyZPgKlFPKS3RcCf0AhPhwue9zCRyxFbXetQ3wOlo+wF9SN8BwldibXuX70mDdn3/7cIWeoKq8E4HAv+MM1480Cu0/4rwu7C0adNbeaV3mTVLXoxWeLzzjR8PAFQ2uH4tlMv1xLAAkYqgytz6Q2RcIGNXPIlenWrOYNgyTVAvzT0NMuKaUCd7lWFtA027B9N0GE5YUZiLsHbk/tULhOxCKvGNdsnksRxDULj3AUjgDTR8NOpQPCV5uO908gEj6AexnmR15SO501I92Pfg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
Received: from MWHPR15MB1791.namprd15.prod.outlook.com (2603:10b6:301:4e::20)
 by MN2PR15MB2606.namprd15.prod.outlook.com (2603:10b6:208:12c::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5293.13; Wed, 25 May
 2022 21:44:05 +0000
Received: from MWHPR15MB1791.namprd15.prod.outlook.com
 ([fe80::e17e:e90d:7675:24b8]) by MWHPR15MB1791.namprd15.prod.outlook.com
 ([fe80::e17e:e90d:7675:24b8%11]) with mapi id 15.20.5293.013; Wed, 25 May
 2022 21:44:05 +0000
Message-ID: <48ed0f56-29c0-a6db-e320-4b314fa297a1@fb.com>
Date:   Wed, 25 May 2022 14:44:03 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.9.1
Subject: Re: [RFC PATCH v4 16/17] xfs: Add async buffered write support
Content-Language: en-US
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     io-uring@vger.kernel.org, kernel-team@fb.com, linux-mm@kvack.org,
        linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        david@fromorbit.com, jack@suse.cz, hch@infradead.org
References: <20220520183646.2002023-1-shr@fb.com>
 <20220520183646.2002023-17-shr@fb.com> <YopYP9vI7E7LbjiD@magnolia>
From:   Stefan Roesch <shr@fb.com>
In-Reply-To: <YopYP9vI7E7LbjiD@magnolia>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: BY3PR03CA0003.namprd03.prod.outlook.com
 (2603:10b6:a03:39a::8) To MWHPR15MB1791.namprd15.prod.outlook.com
 (2603:10b6:301:4e::20)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 0bcc9528-0b80-49c3-70a4-08da3e97b104
X-MS-TrafficTypeDiagnostic: MN2PR15MB2606:EE_
X-Microsoft-Antispam-PRVS: <MN2PR15MB2606EAA0DEEA718DB1E488D1D8D69@MN2PR15MB2606.namprd15.prod.outlook.com>
X-FB-Source: Internal
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: WZTkcINFO0mE0lOHe3H+mFgUkfHqmCgrBXc/UtxtbUuy9AgDvYJ5uRGau+0yCypi5l8vdXAVHDU0FioeD1XoDxwrXTenLEjbTxUh7RCcS6BRPB7VdRWucMIipLHEdaag6bmJLQcLZbRYzX4vc9ct0r3V5AshPAv6XVMPOw8OcQXwS1aRbBy7vGXTH0FU+RzZTdtBxerTTfksVSCWLcv+qL5e1BGmwKIDFdvsfn+x01D/Yek2EMEG3V7pQIoyAoODcgF14RaI5VGUizwr6WG6/SdSgrSScLJeSZfunBkcHVFreTLUVKHBxjgHA7JIiRifeaq2D8yCP7HU/MW2MGHlqGbcDfscSaS+z7ozS5TwFRqgW60z395ffZ0sVYhdjs6mEkPcCc7UHZVbCQGuTQt0wBAG8IVLaKfkGk897UODyiC8a6sad7rg4QVoIwd0AA6U1PzFbm2jh2KjWrVoSqEVNkPuLeA7efwjb0rBmWpuvmJ55gM4f+Rd33C+oZwX8M+ZO9oCLDR3uvAOSaXYMlhtOfcqeb253YCionNEL/b518WwhC8cAG9mZX/eynMsMGRLfgFLd3HSFJExp9JpCM+07nRegfqlWqOWgSpFN11WbL/7AbdMLt9bYZT8+QqueqFSmilO98HChFfBPsu6aH4f2+7hxfUOf9WNzGsbtRcXFde3Vpn3M2t8Q0GT0zl6z3zDT1WW6hJzcTwQv4A3Fta3f3P0eIQOpNi2uogFBkqyQwAYJH0YCNP3lyBnPGdIDG0S
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR15MB1791.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(6916009)(186003)(8936002)(36756003)(316002)(38100700002)(31686004)(83380400001)(2906002)(2616005)(6512007)(4326008)(66946007)(66556008)(66476007)(5660300002)(8676002)(6506007)(6486002)(53546011)(86362001)(508600001)(31696002)(43740500002)(45980500001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?M3VHOXRIRGNqTnhGMVUvVEpqN2lNS0lUeTRhZGs5ak1KcmlydVY2VW9sa0p1?=
 =?utf-8?B?Vk9zQ0p5NmtFcWJIV3ZvQVVsdHpWVTVwMkVwamk4WnpQTmU3ZVhSeEpoS1F5?=
 =?utf-8?B?YUtpYjh3VllOc01lTGZlckQ4Q282NHlsWE53cUZjcnBrZnZNWkxNRTM2b1Nx?=
 =?utf-8?B?L1JNcVd6NXl6Z1lId0w0d2REd0ZsMXpaRTNBUnVPcnppdS9iTjJaNzYzeUs1?=
 =?utf-8?B?SGRSU1BBem9xSXVkRnEwT2QrTTZpRkNRWkxFNkwzNVM5RmUrb3ZwWktrY0lw?=
 =?utf-8?B?UFU3Z01GU1N1MmdFZ0c2YS9iVU5iNVJhT0oyQUlFdXRGR29GQ0RFZlRvWGVk?=
 =?utf-8?B?NTNLQzRBdGIyTW53V0FCU1VYVWZTZVR3aFJvK3Y5SVlYUHRpWjYwSEpjamJY?=
 =?utf-8?B?d1RFbUIrZDZtSmJwdFdwSDBpSEdET0VKKzRPM0d4bDUrQThkK2V4WjdaMUtH?=
 =?utf-8?B?MHY3a0M0dU8zUXpKTjFRaTRkRnVWRWpQT0Y5aURJL0FWWVMzZDVwV0ZVRi8z?=
 =?utf-8?B?SlNUMjZjNWIwN1ByRGRMdjFWR21lK0VCOXNXMUk0MDFrZExEVVNlRTY3QnVQ?=
 =?utf-8?B?S05YSVU3aUhjOVRXVUN5b1dCSVc5MkV3R0h3aDluMWp4Wkh3eHZ3ZEl4VXps?=
 =?utf-8?B?T0tTRWpna3NGbXRtQWl6OEh4YjZZbko2cS9sY3hNSlZZN0pZaW5SWnZFUHF0?=
 =?utf-8?B?T3I5Q050U3V4VkVsSXkxQkt2WWJoQnNtbGJtSktRcTVGUm9ZcHR1L0taK1V6?=
 =?utf-8?B?SXZaU1grNTl5YzRNN1h3Mm5TWHN6cmlIL3B4SVE5K3lpbGpobk4wWlM4L1hh?=
 =?utf-8?B?czVqMWN0dHVzQlM2eTYxZHNkbmpadTZDZ0JiZUdoaGlaZFpuUEwrczFKU3Vu?=
 =?utf-8?B?WnR0OWw4bURlcDR0WHJwVVNVS2pJVDVONzJnTTFISXVibDFiVWY2cTJZUVp1?=
 =?utf-8?B?TVZvaWRIb1V3TTJJWUlRL1UxMzhKMUljeHR4a2prZzBNS2Y1amIrVEw0L2p6?=
 =?utf-8?B?T2k0TDdmaGhKNFQ5RmlVQ1dNNXQ3UEt0VUMxekpmUHhEbTFrc0VrY0ZhNGdO?=
 =?utf-8?B?c3ZLOUpOU1BxSDZNU08yNG5BcSthRFFsVDBydnByaUpQWWtrSFRsV29taVFV?=
 =?utf-8?B?cklpbzA3akE3VmRlM2twTXIrVHBILzRhSE8xOHA2SnVaVUU0WWc2TzlDMDNq?=
 =?utf-8?B?eE5lTzlEbXNGQUZaYjBXOHFxZ0FkSG80SzdYeFpmY1lrSC9RL0V0NUh3QVFO?=
 =?utf-8?B?eGhBUjgvUklVNFFxS2xiTWh4NjcvRE5tSEZmTlBRNzJyTDVPMUZ6RDU2bnlz?=
 =?utf-8?B?cERKVU9jTFBSZU00cXR2SmtWdllRSy9FeUJIVFcwclJiTTdCUlAvUGU5R3Zo?=
 =?utf-8?B?cTZHV3laZmk5cWhGUEE1MWRiZjRQTW1Gbm1PT1NkNkh6NnFDNWQ0QSt0THRa?=
 =?utf-8?B?YnNNVzNPRzE1bFc5d1FzVUx5NEdyQ2hnNklKNzR5YnplOFJMTXRZNThvcXdS?=
 =?utf-8?B?clJHYVkvdkNMN3ZQREtxNnBManNTNHBmWlQ4OUR2VlhCeVlDWFlNOXI3VzRU?=
 =?utf-8?B?cFVEYVkrQlVuSGo5LytQcUZBdGVndzQwRC93bzY2bER5UnFHVDVHeUhvT2pS?=
 =?utf-8?B?Uk5kRjFJcU5LY2lDM05KZjJsZGZZU0xia01IMHFGWk9ORmI5c0JacURZNnkw?=
 =?utf-8?B?ZW1Wc2txUmxGZW05eHpYMXV5L3JBZFpPVllpdlMySm95TFJaSnBtU1cwaUY2?=
 =?utf-8?B?VElGZlJwNlJrVWFRakRDcklxZ2ZmQVd0WkZEUWRxOVpnRzlpT1BTb1JYZExK?=
 =?utf-8?B?SjhWVUxFUFNVRExuTTNyRmM2SU1HdWFnWUN3UXNjbTNDVVI4V3FQY0oxZklu?=
 =?utf-8?B?cjRDNTZoTUZid1hWc0NjOThNOHY0c2lwbzh2T1NMUjJtellvZmNZY1dxSUM0?=
 =?utf-8?B?c0krZFlhbmhLNmxkQlZwajF4OGpSZG1TN1lKOWZGUnY5QWZMTnZlaHBwM3Zk?=
 =?utf-8?B?WnBXZW5aNHo5b2NPZWNCR1NsckpUMGxhanZMZnVBZjlaVTlrSzJvNU90V2w5?=
 =?utf-8?B?YWxkRFd4T0hKbG5WVExqdTM3d0trRy9lcEl4WGJFeVAxaGlxcGs5ZWwvc3dr?=
 =?utf-8?B?MTM1Q0JRN3BjNzc0YTQrZi9vK2RiV05VaGFqMTJ1SWhrbnp4VjFCTWdJVldW?=
 =?utf-8?B?VjBBblFOdlk5anp5czltcG5USk1rS0VLbUIxZWhyaTAwQ2cxNHUremhSb0xX?=
 =?utf-8?B?RU4rQUlXSnJjVHU1QjZIWDU0MGFPckZkZm9CdTlETy9uaGlpQ1lCNjZncm4y?=
 =?utf-8?B?WXh1TjA5OUt1U05YYWxNZFR5eHh5cDVxRStZVjZ4Mld3eW40ZS9OTlI4YnVx?=
 =?utf-8?Q?h5AWMrBPqyeunshI=3D?=
X-OriginatorOrg: fb.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0bcc9528-0b80-49c3-70a4-08da3e97b104
X-MS-Exchange-CrossTenant-AuthSource: MWHPR15MB1791.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 May 2022 21:44:05.8125
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: d4po8KniVstXr1QvK6YcpnHYzTb3PEqQ7gj7n2jhAqT93oU0hsM+hxFgFOPdrtor
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR15MB2606
X-Proofpoint-GUID: E4CWHekFCKc5Q7M3gLcoBiEfrKx_xyz4
X-Proofpoint-ORIG-GUID: E4CWHekFCKc5Q7M3gLcoBiEfrKx_xyz4
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



On 5/22/22 8:35 AM, Darrick J. Wong wrote:
> On Fri, May 20, 2022 at 11:36:45AM -0700, Stefan Roesch wrote:
>> This adds the async buffered write support to XFS. For async buffered
>> write requests, the request will return -EAGAIN if the ilock cannot be
>> obtained immediately.
>>
>> This splits off a new helper xfs_ilock_inode from the existing helper
>> xfs_ilock_iocb so it can be used for this function. The exising helper
>> cannot be used as it hardcoded the inode to be used.
>>
>> Signed-off-by: Stefan Roesch <shr@fb.com>
>> ---
>>  fs/xfs/xfs_file.c | 32 +++++++++++++++-----------------
>>  1 file changed, 15 insertions(+), 17 deletions(-)
>>
>> diff --git a/fs/xfs/xfs_file.c b/fs/xfs/xfs_file.c
>> index 793918c83755..ad3175b7d366 100644
>> --- a/fs/xfs/xfs_file.c
>> +++ b/fs/xfs/xfs_file.c
>> @@ -190,14 +190,13 @@ xfs_file_fsync(
>>  	return error;
>>  }
>>  
>> -static int
>> -xfs_ilock_iocb(
>> -	struct kiocb		*iocb,
>> +static inline int
>> +xfs_ilock_xfs_inode(
> 
> A couple of nitpicky things:
> 
> "ilock" is shorthand for "inode lock", which means this name expands to
> "xfs inode lock xfs inode", which is redundant.  Seeing as the whole
> point of this function is to take a particular inode lock with a
> particular set of IOCB flags, just leave the name as it was.
> 

Renamed xfs_ilock_xfs_inode()n back to xfs_ilock_iocb().

>> +	struct xfs_inode	*ip,
>> +	int			flags,
> 
> "iocb_flags", not "flags", to reinforce what kind of flags are supposed
> to be passed in here.
> 

Renamed flags parameter to iocb_flags in function xfs_ilock_iocb().

> --D
> 
>>  	unsigned int		lock_mode)
>>  {
>> -	struct xfs_inode	*ip = XFS_I(file_inode(iocb->ki_filp));
>> -
>> -	if (iocb->ki_flags & IOCB_NOWAIT) {
>> +	if (flags & IOCB_NOWAIT) {
>>  		if (!xfs_ilock_nowait(ip, lock_mode))
>>  			return -EAGAIN;
>>  	} else {
>> @@ -222,7 +221,7 @@ xfs_file_dio_read(
>>  
>>  	file_accessed(iocb->ki_filp);
>>  
>> -	ret = xfs_ilock_iocb(iocb, XFS_IOLOCK_SHARED);
>> +	ret = xfs_ilock_xfs_inode(ip, iocb->ki_flags, XFS_IOLOCK_SHARED);
>>  	if (ret)
>>  		return ret;
>>  	ret = iomap_dio_rw(iocb, to, &xfs_read_iomap_ops, NULL, 0, 0);
>> @@ -244,7 +243,7 @@ xfs_file_dax_read(
>>  	if (!iov_iter_count(to))
>>  		return 0; /* skip atime */
>>  
>> -	ret = xfs_ilock_iocb(iocb, XFS_IOLOCK_SHARED);
>> +	ret = xfs_ilock_xfs_inode(ip, iocb->ki_flags, XFS_IOLOCK_SHARED);
>>  	if (ret)
>>  		return ret;
>>  	ret = dax_iomap_rw(iocb, to, &xfs_read_iomap_ops);
>> @@ -264,7 +263,7 @@ xfs_file_buffered_read(
>>  
>>  	trace_xfs_file_buffered_read(iocb, to);
>>  
>> -	ret = xfs_ilock_iocb(iocb, XFS_IOLOCK_SHARED);
>> +	ret = xfs_ilock_xfs_inode(ip, iocb->ki_flags, XFS_IOLOCK_SHARED);
>>  	if (ret)
>>  		return ret;
>>  	ret = generic_file_read_iter(iocb, to);
>> @@ -343,7 +342,7 @@ xfs_file_write_checks(
>>  	if (*iolock == XFS_IOLOCK_SHARED && !IS_NOSEC(inode)) {
>>  		xfs_iunlock(ip, *iolock);
>>  		*iolock = XFS_IOLOCK_EXCL;
>> -		error = xfs_ilock_iocb(iocb, *iolock);
>> +		error = xfs_ilock_xfs_inode(ip, iocb->ki_flags, *iolock);
>>  		if (error) {
>>  			*iolock = 0;
>>  			return error;
>> @@ -516,7 +515,7 @@ xfs_file_dio_write_aligned(
>>  	int			iolock = XFS_IOLOCK_SHARED;
>>  	ssize_t			ret;
>>  
>> -	ret = xfs_ilock_iocb(iocb, iolock);
>> +	ret = xfs_ilock_xfs_inode(ip, iocb->ki_flags, iolock);
>>  	if (ret)
>>  		return ret;
>>  	ret = xfs_file_write_checks(iocb, from, &iolock);
>> @@ -583,7 +582,7 @@ xfs_file_dio_write_unaligned(
>>  		flags = IOMAP_DIO_FORCE_WAIT;
>>  	}
>>  
>> -	ret = xfs_ilock_iocb(iocb, iolock);
>> +	ret = xfs_ilock_xfs_inode(ip, iocb->ki_flags, iolock);
>>  	if (ret)
>>  		return ret;
>>  
>> @@ -659,7 +658,7 @@ xfs_file_dax_write(
>>  	ssize_t			ret, error = 0;
>>  	loff_t			pos;
>>  
>> -	ret = xfs_ilock_iocb(iocb, iolock);
>> +	ret = xfs_ilock_xfs_inode(ip, iocb->ki_flags, iolock);
>>  	if (ret)
>>  		return ret;
>>  	ret = xfs_file_write_checks(iocb, from, &iolock);
>> @@ -702,12 +701,11 @@ xfs_file_buffered_write(
>>  	bool			cleared_space = false;
>>  	int			iolock;
>>  
>> -	if (iocb->ki_flags & IOCB_NOWAIT)
>> -		return -EOPNOTSUPP;
>> -
>>  write_retry:
>>  	iolock = XFS_IOLOCK_EXCL;
>> -	xfs_ilock(ip, iolock);
>> +	ret = xfs_ilock_xfs_inode(ip, iocb->ki_flags, iolock);
>> +	if (ret)
>> +		return ret;
>>  
>>  	ret = xfs_file_write_checks(iocb, from, &iolock);
>>  	if (ret)
>> -- 
>> 2.30.2
>>
