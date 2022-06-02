Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C82F953C044
	for <lists+io-uring@lfdr.de>; Thu,  2 Jun 2022 23:08:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237987AbiFBVGn (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 2 Jun 2022 17:06:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37526 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239376AbiFBVGn (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 2 Jun 2022 17:06:43 -0400
Received: from mx0a-00082601.pphosted.com (mx0a-00082601.pphosted.com [67.231.145.42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 060563527D;
        Thu,  2 Jun 2022 14:06:41 -0700 (PDT)
Received: from pps.filterd (m0109334.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 252KaKgp022821;
        Thu, 2 Jun 2022 14:06:33 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=facebook;
 bh=5DZvvLEYo1p2eZEUQxs3O9m2Onf8osBZdqXnCV7OpOc=;
 b=eolXnW7GlvUjii1SUpyqCE/I7MGagAJg6TOstQZEKuOOdsekpJBWEwfu72oWnjTbYHcC
 NCy+x+Y1Ge5b4Q33Kg+eju4tOAEjVXtK6VuuZFavhClv9Ay0A94Cia3DoQ258d98oj9N
 tKaljuBZ0GqjUQqPqNZBukD0z52mjXbB53Y= 
Received: from nam11-co1-obe.outbound.protection.outlook.com (mail-co1nam11lp2177.outbound.protection.outlook.com [104.47.56.177])
        by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 3gewq937r9-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 02 Jun 2022 14:06:33 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=hjgA0OBE/EGvBUTEa3L+NvYF9wYnt70b3Em4+Fu7G2Z1gvY6xjK0c8g8fRbN21aKRY+6I2SylYWUJxCoiIoHF5UFjEGToqio/fbhyrD/T/QYic54lAdT1pZezVgqJdzQm/eG2VujQ975lzsY81oMnsHqZbyyUFX8b0vTapamSWMxSoSBHgIdtknDROxf1rmYnbsptomiUUsUwsDAr1w0ws2rpkL982mA1JAdszyCr51bPw9UGsMv0WWnHfdQhYp5rAysOI9CYIQ++DI4eS/5dPO2zFp+P4i0PQQikj2om2hEtzGOmmTjBAatAV5bPdv3Z8fSIxrxzj0nUjDfC9spZw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=5DZvvLEYo1p2eZEUQxs3O9m2Onf8osBZdqXnCV7OpOc=;
 b=DGiPdQa0FOgmtSC0fEFkU+KxcPkCupu+ku9rtXN2Ja5yte6ets/IK5RBASH1vSONNMhgkfa+o/GFBagqUN5BlmZjqknD+H/P+LeYCUzmRJmqUwQoGp4uadrBks/WhPk9OwH4VKYpsj7agDWZhB8JOaGV7Ln19VaRzAt1qKZBkmx6GODvuYb3445SreQiVwWBk5tsuZ6+GRm0MuGbAgB9ciuwQwdKfbjxVFxcYjJMy4ER7/E+NVDaHUqhql4/DiC71THWMgEdhGRiooqXtt+uJc3NdlnyLIQH2wXa1bBil8nGKxTduc3eAuWHQ8kLgMEgK4jeYxoBY8RBCc3omYkQ0Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
Received: from MWHPR15MB1791.namprd15.prod.outlook.com (2603:10b6:301:4e::20)
 by PH0PR15MB4557.namprd15.prod.outlook.com (2603:10b6:510:87::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5314.13; Thu, 2 Jun
 2022 21:06:30 +0000
Received: from MWHPR15MB1791.namprd15.prod.outlook.com
 ([fe80::e17e:e90d:7675:24b8]) by MWHPR15MB1791.namprd15.prod.outlook.com
 ([fe80::e17e:e90d:7675:24b8%11]) with mapi id 15.20.5314.013; Thu, 2 Jun 2022
 21:06:30 +0000
Message-ID: <5724070f-e658-cdd6-70c2-5fdf0eb5d711@fb.com>
Date:   Thu, 2 Jun 2022 14:06:28 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.9.1
Subject: Re: [PATCH v7 11/15] fs: Optimization for concurrent file time
 updates.
Content-Language: en-US
To:     Jan Kara <jack@suse.cz>
Cc:     io-uring@vger.kernel.org, kernel-team@fb.com, linux-mm@kvack.org,
        linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        david@fromorbit.com, hch@infradead.org, axboe@kernel.dk
References: <20220601210141.3773402-1-shr@fb.com>
 <20220601210141.3773402-12-shr@fb.com>
 <20220602085958.z2gosfb3ul7fa4o3@quack3.lan>
From:   Stefan Roesch <shr@fb.com>
In-Reply-To: <20220602085958.z2gosfb3ul7fa4o3@quack3.lan>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: BYAPR03CA0027.namprd03.prod.outlook.com
 (2603:10b6:a02:a8::40) To MWHPR15MB1791.namprd15.prod.outlook.com
 (2603:10b6:301:4e::20)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: ce514687-6753-43e8-366a-08da44dbc3d8
X-MS-TrafficTypeDiagnostic: PH0PR15MB4557:EE_
X-Microsoft-Antispam-PRVS: <PH0PR15MB45575AEB6E82015D3425C2F4D8DE9@PH0PR15MB4557.namprd15.prod.outlook.com>
X-FB-Source: Internal
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: +rJ5sXD8XVGVEibecGjOtIkKWToHD1LHU4T4vKrpOac2GBtJy3FT9AoUTQh5QzUkxSrkrG4pyRBO99i9eoddNJdJDU7/DjNZYLEwTr8ZX9TH1Cm2bdWtAvwpv2bhNSLn3IbzjOv7VXpbKK/VqYmJJvSaT0HbDUZ7LUV5ro2Z1wKqDS4to6IvLCb7HsCH89fUNNRMucel7v0g1uwKgxb/I50ke2GaSSBVgDF8hAGx5Qr4FltfiToh23/8q9sj4QlHYWRAwmt++31cMQKCF7zuMZnUB3mx0ulvFHf+i5ErE1bcyO0U+Oy7Ln0urKrlDmMhyArSguAcn7QtHoZNv6nWwU6PguTCnLgUUAPiUqJpMX1Neaac88OSRLq6we/orHUhVNxzoDh+95uiqWGww1/mpBA+1+BBXsX04FgBBWsF1z4/sVJ4ESdgFatQ8NJ6XYacjnUQRF4vT+iAqhsm+Poiae+CtLWGQwWPeTzWzydapaobw6e+NJWwE5pqAUhlXfbhxMwBV1dnElU+6hK/Jztl7dt+F353/Ii5r1KIdpnA5F2qDzSSCcXuFgopYN5SK2RiuN5itv7y/L+7wSCtNWPYXon5C2Lw8WJdseMgTAlvqbspdlQ44qh/IVvrooJgZ+ZTDRW3y6LZIOlFO+uhk7pFsBQbKQ6n+izUJAbwN5RenLwyWPkyiEBqVYHZRLkE+hmzm08KELDRDG2AU7DDNTFUdQMwmD/ZvPpx8qlSbNKkqeWQ/+Ar0khDxHIeJMy1HmE2
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR15MB1791.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(186003)(316002)(36756003)(15650500001)(86362001)(31696002)(83380400001)(6916009)(53546011)(5660300002)(6486002)(38100700002)(6506007)(6512007)(2906002)(8936002)(508600001)(66946007)(66556008)(66476007)(31686004)(2616005)(8676002)(4326008)(45980500001)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?L3lidWhRUlMrNksyMTlVM1JKbi9hY3RDSWRGUC8rdjNkMUZ3QU10Y0xjZUtS?=
 =?utf-8?B?amhuY1k4b3lYRFZQUmxIb2dmamc3RGlBVjNLNDU3ZFBrcENCOU8rdlZiRXpu?=
 =?utf-8?B?ajRHYnF4TmtNTDU1UzlNSE94WjcvdDZSOTFNeGxXT3BrMmxyTGdHRWNicWIr?=
 =?utf-8?B?VmMwK01pem5VaXUvemRSQ2NOanRSVVhKNlBWVzNudVBKajAzR0dBRWZwQzQv?=
 =?utf-8?B?R0N3aWp3SFRROTh4MWFaZWVuMXk4T2o2dHRmSGppQnBxZlNPZHlPK3FXcE5i?=
 =?utf-8?B?UndFbXRIYkNRKytlQTdCN3J6OW04UFBXUHB2blNLSGlpN3VhaWhoODhxb0Ez?=
 =?utf-8?B?dHRScmU3eWNFZ2NoS3g3SmdtMGNvQnl3ZmZObVIwRjhVY2UrQVI4dXNvd041?=
 =?utf-8?B?SXRBcHgwZi80RnMyODl3emt6VE1KUi9hOGhsaUdneExiSU4zc0ZiNlpBSEZk?=
 =?utf-8?B?U0RYQ0FLbUdRVnVLYkZnbUl6YTRqYmQ0alYvVTJvV09kUXQ2aXlZbTNMeUls?=
 =?utf-8?B?b1AzRFkxQUNiY0tNaURlMEY4TUQydUtTdW4xcFNzcEhKSW9mei81SUYrak4v?=
 =?utf-8?B?SzdPaG13K3hoKzBuT21NNm4yTjhZU254L3V5ci81RllEYytuV0k3QnpQdEF3?=
 =?utf-8?B?KzZlaFVQbVBaZWs3MlVUcC9veGxPSnRUSE9CUkpsdmZtemx0VG50RzNJL3JV?=
 =?utf-8?B?T2VYbTRkaWt4blNFamRyME1ZY2JpcHFUOGRmOXRsQXlsdkF3ZmxSbmRoUDdX?=
 =?utf-8?B?UVZraUt3UnVYNU00dHp4ZDJZc0p5Mk9zSkF0dkE2SmgrRE1rbVVVbWVXOW1p?=
 =?utf-8?B?NDUzdVR4REVhelJSQUNtL3FxSSt2bGJaSXBENGI1ZWRCMjlNV2s4K2FKa0F6?=
 =?utf-8?B?cEFpYW1qck5DSWFicDB4ZlBCL3ZSME54Uk9BVUhFY3VKZ25vTisyY1dYQTVE?=
 =?utf-8?B?aGdWL1VDL1ZuK3VTQ1pRcm5HMXJBak1mNWV1NHRuQ2ZURjh3bTRRVVlSMVlh?=
 =?utf-8?B?UGc3ajZmMk1zWlZuUGRObjVac0h5SHVyMjh0Si9VK1FQMnFSV3dTT2ovVzV2?=
 =?utf-8?B?cDQwV0IwaFVoMXhuajQrN1MxMVR2bFZsWlNpajFYRU8wSmt0elpCUGVTa0VR?=
 =?utf-8?B?YUx3K1JsVXVMenhCejQ1dUJnMHJFdm9vc2ZESjlNMFdKMi9MYTg2NlpGMGhw?=
 =?utf-8?B?Qm5lMFBLNjgxUUpiK3habTZ3Ukg4em9BNDZsNkN0RDVoTFJBaG51aFV4YkR1?=
 =?utf-8?B?RUNka0ZveGRPckRmSndKV1BxTzgzR0tZaVhWTlhveVYvR0ZNbXNVdVlFV2E5?=
 =?utf-8?B?ditKejF3ZFB3ekhLR1NKV0lKWDVmei94VDY4MWIzZW41VnV3NGJLQ0pHZ2U0?=
 =?utf-8?B?N3FuWkMxbXNzWTFEQlJ4QjlmbVJ3ZzlPaDNFRkhSSlFocFlLYUE0SCt3ZXMy?=
 =?utf-8?B?RUlWWWliVkEzamxPTllGcUxvNjVNVkhjVlVjR1hRcTNocS8rNHpQQnRBNGhv?=
 =?utf-8?B?UkFuZ3VpTnowc0xrVktFUE0xR1p1N0NXRURTU0JSdjBVTXNCRFZUc1lJSWtO?=
 =?utf-8?B?NkRleGxpMm1UbTJzU04rSk0yYVV3MUZ6Rmo2Zno3czZkdStQcHQvYkE3NVdr?=
 =?utf-8?B?cDN0ZnMya2Z3UW9sUWZKekRXZ0dqcTdpcWZQWmdOOE1LZmR5c1B2c2Eva2dN?=
 =?utf-8?B?WUZUbmlkRjBEZzJVVjlmTzd5dVNlbzRZMEdLbk4wTTArSUFHZmdVVS9NNkVm?=
 =?utf-8?B?MEFPV3ZZWWdFYVZQclIvTmJueVN4SWY1REIyaCtxcTE4M3lzMlVLR3ZlRVNo?=
 =?utf-8?B?MmppOFVHT1NUbzVVd0NpMU14ZEhXbkRwR1QwWEFGRDRzTUdWZHU1cWtuY0xH?=
 =?utf-8?B?cDRpcFdnUXlZR0hkMVcwYUF3aHp0MC81Unp4Vjkzb0kwK2hvcTZJd3FMK1hN?=
 =?utf-8?B?eGVqTkpxdzNHY01uN1hYcW1rMUVwNnNHR1QwL0pHbkk3V1FvZDUrVHM3WnEv?=
 =?utf-8?B?NVl6c3YvWUdKSUFycXpvWisrN1VTOHk4Q3BWc3c2Q1JuY0hsTkFKNnBXZ3RQ?=
 =?utf-8?B?bzVqTXdzTGVsaVRuUDhhamQ2UmFScXdkUy9XZUlqRHF4cC9mdWUzcHVtc2Ux?=
 =?utf-8?B?UEM4aU1TTzJiOU9UZklYZ25oTmp1anRmZFh3M1pzSUF0N3V0U0JXYmpLZFlE?=
 =?utf-8?B?dzYySzd3RUxHNmlTeEF6TGpQWUFTVlBXUGZxQXhBblc3aFJyNUFYOFVtNXgv?=
 =?utf-8?B?WWpTS1BMZk9nUTNQR3cvM003S1BWckdhakRoZmhEemJNYnVWWkVZVHZIUXBB?=
 =?utf-8?B?eEE5ejlQTHFJdGRZZkd4b2pwcHhlSWdkcnNDNVlDREl0L1ZkZTJEanJWa2h2?=
 =?utf-8?Q?qBKg4JK+Gjrw6xmA=3D?=
X-OriginatorOrg: fb.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ce514687-6753-43e8-366a-08da44dbc3d8
X-MS-Exchange-CrossTenant-AuthSource: MWHPR15MB1791.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Jun 2022 21:06:30.2006
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 5brRqq2ug/GvJM/eZxJOgKJXbOKv9LLeC6TDGTBBxc+QtPJQ4SCWAcsVLWNC3byY
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR15MB4557
X-Proofpoint-ORIG-GUID: F-qJ-1gVtH3MIEz8WLEjK39Y2nZGf6FL
X-Proofpoint-GUID: F-qJ-1gVtH3MIEz8WLEjK39Y2nZGf6FL
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



On 6/2/22 1:59 AM, Jan Kara wrote:
> On Wed 01-06-22 14:01:37, Stefan Roesch wrote:
>> This introduces the S_PENDING_TIME flag. If an async buffered write
>> needs to update the time, it cannot be processed in the fast path of
>> io-uring. When a time update is pending this flag is set for async
>> buffered writes. Other concurrent async buffered writes for the same
>> file do not need to wait while this time update is pending.
>>
>> This reduces the number of async buffered writes that need to get punted
>> to the io-workers in io-uring.
>>
>> Signed-off-by: Stefan Roesch <shr@fb.com>
> 
> Thinking about this, there is a snag with this S_PENDING_TIME scheme. It
> can happen that we report write as completed to userspace before timestamps
> are actually updated. So following stat(2) can still return old time stamp
> which might confuse some userspace application. It might be even nastier
> with i_version which is used by NFS and can thus cause data consistency
> issues for NFS.
> 

Thanks for catching this, I removed this patch from the patch series.

> 								Honza
> 
>> ---
>>  fs/inode.c         | 11 +++++++++--
>>  include/linux/fs.h |  3 +++
>>  2 files changed, 12 insertions(+), 2 deletions(-)
>>
>> diff --git a/fs/inode.c b/fs/inode.c
>> index 4503bed063e7..7185d860d423 100644
>> --- a/fs/inode.c
>> +++ b/fs/inode.c
>> @@ -2150,10 +2150,17 @@ static int file_modified_flags(struct file *file, int flags)
>>  	ret = inode_needs_update_time(inode, &now);
>>  	if (ret <= 0)
>>  		return ret;
>> -	if (flags & IOCB_NOWAIT)
>> +	if (flags & IOCB_NOWAIT) {
>> +		if (IS_PENDING_TIME(inode))
>> +			return 0;
>> +
>> +		inode_set_flags(inode, S_PENDING_TIME, S_PENDING_TIME);
>>  		return -EAGAIN;
>> +	}
>>  
>> -	return __file_update_time(file, &now, ret);
>> +	ret = __file_update_time(file, &now, ret);
>> +	inode_set_flags(inode, 0, S_PENDING_TIME);
>> +	return ret;
>>  }
>>  
>>  /**
>> diff --git a/include/linux/fs.h b/include/linux/fs.h
>> index 553e57ec3efa..15f9a7beba55 100644
>> --- a/include/linux/fs.h
>> +++ b/include/linux/fs.h
>> @@ -2151,6 +2151,8 @@ struct super_operations {
>>  #define S_CASEFOLD	(1 << 15) /* Casefolded file */
>>  #define S_VERITY	(1 << 16) /* Verity file (using fs/verity/) */
>>  #define S_KERNEL_FILE	(1 << 17) /* File is in use by the kernel (eg. fs/cachefiles) */
>> +#define S_PENDING_TIME (1 << 18) /* File update time is pending */
>> +
>>  
>>  /*
>>   * Note that nosuid etc flags are inode-specific: setting some file-system
>> @@ -2193,6 +2195,7 @@ static inline bool sb_rdonly(const struct super_block *sb) { return sb->s_flags
>>  #define IS_ENCRYPTED(inode)	((inode)->i_flags & S_ENCRYPTED)
>>  #define IS_CASEFOLDED(inode)	((inode)->i_flags & S_CASEFOLD)
>>  #define IS_VERITY(inode)	((inode)->i_flags & S_VERITY)
>> +#define IS_PENDING_TIME(inode) ((inode)->i_flags & S_PENDING_TIME)
>>  
>>  #define IS_WHITEOUT(inode)	(S_ISCHR(inode->i_mode) && \
>>  				 (inode)->i_rdev == WHITEOUT_DEV)
>> -- 
>> 2.30.2
>>
