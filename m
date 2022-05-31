Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A10D75396AB
	for <lists+io-uring@lfdr.de>; Tue, 31 May 2022 21:03:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344343AbiEaTDQ (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 31 May 2022 15:03:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38378 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234487AbiEaTDP (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 31 May 2022 15:03:15 -0400
Received: from mx0a-00082601.pphosted.com (mx0a-00082601.pphosted.com [67.231.145.42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 01DA4689A4;
        Tue, 31 May 2022 12:03:12 -0700 (PDT)
Received: from pps.filterd (m0109333.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 24VFiPEj020093;
        Tue, 31 May 2022 12:03:01 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=facebook;
 bh=rMa9tv6V2i+w0M9Y+AM7qiQ4A9RquJttEFv/5vaRMDg=;
 b=ViZenE08osuEKdGepByqNPjF7VO+S2+KRUbNNFkxL+yH+pWutLAMgizTE/xnG8heEBTS
 /xzPw05gRL1ruFmaBCscOiOz0vZW0bkdIeyus6R7ehMiYJfIeor7PPQMB8HSB6Bvghxp
 XZ6znhmTRLoakvClYUpdYvEkbCSMTFpD1rs= 
Received: from nam02-sn1-obe.outbound.protection.outlook.com (mail-sn1anam02lp2047.outbound.protection.outlook.com [104.47.57.47])
        by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 3gbfshyx57-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 31 May 2022 12:03:01 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=FU2z2YXq7GBwI/3nBL9xaD8NXqDC+Slw+ModPVssL4ZcbAC+R6jclyWBMeiSAerSUE0Y1yjJ7OjH5KnnwM8ACXOmCIb9W6Xzy6TxQJ1mDH6cRsuqgAkexD2xcoUsGhAsqdb9SUHMwjJKXonaIuF6AaY5voi5s6Nr8WtD3Zv7Kf/Yh8wc4Y0s0qypw4cpPC4g4COoWHPJdZVCYKqoKrSzQM+qUO3Za9A50YS9mBu14HZ7qHwqM5PFUPZqu6FD/koRScEMzdryaC0gBugVgE1BthO3dyElTTbwfDZGs9fevfVyL9/YF4AXX/ko3iqY8pW7L68g965RYBxu+Z5svyyiJw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=rMa9tv6V2i+w0M9Y+AM7qiQ4A9RquJttEFv/5vaRMDg=;
 b=Ov0lpAbT8LRalEjNBldq69d++aDJbrtE2J3eHyH5IE6/7utGIxHFijLP1zXhxc7aX7UHNEumgH1/gfp6POzavG4sa75tmh5KBlojjIF9Qq2//b3htwniPUSs92eKGYolma6pHtKGMGsCt63WMgrAKfIAMMoSGe+u3Grz+39KAmAhgZEi1J/2Ndy1wzws+ysOoGjL5xTyvTxYioJW+s/QEUNfUleXeEN5wLQ/MJYFG7gzKa3ESnHQ7w0BRFkPg8yO2WRIx16g2I1yeKRC7bmhZx/bxoaAR8LraUB3rpNOJGsZDnZ3u4KzEbIzHUcn2f/KDD+LKx+8+vIXaIHqrjeMaA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
Received: from MWHPR15MB1791.namprd15.prod.outlook.com (2603:10b6:301:4e::20)
 by BN8PR15MB3428.namprd15.prod.outlook.com (2603:10b6:408:a9::24) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5314.12; Tue, 31 May
 2022 19:02:58 +0000
Received: from MWHPR15MB1791.namprd15.prod.outlook.com
 ([fe80::e17e:e90d:7675:24b8]) by MWHPR15MB1791.namprd15.prod.outlook.com
 ([fe80::e17e:e90d:7675:24b8%11]) with mapi id 15.20.5293.019; Tue, 31 May
 2022 19:02:58 +0000
Message-ID: <633de871-89f1-b9e3-638d-1c665ae401e8@fb.com>
Date:   Tue, 31 May 2022 12:02:55 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.9.1
Subject: Re: [PATCH v6 08/16] fs: Split off inode_needs_update_time and
 __file_update_time
Content-Language: en-US
To:     Christoph Hellwig <hch@infradead.org>
Cc:     io-uring@vger.kernel.org, kernel-team@fb.com, linux-mm@kvack.org,
        linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        david@fromorbit.com, jack@suse.cz
References: <20220526173840.578265-1-shr@fb.com>
 <20220526173840.578265-9-shr@fb.com> <YpW9Qkn3yZbUvETE@infradead.org>
From:   Stefan Roesch <shr@fb.com>
In-Reply-To: <YpW9Qkn3yZbUvETE@infradead.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: BYAPR11CA0060.namprd11.prod.outlook.com
 (2603:10b6:a03:80::37) To MWHPR15MB1791.namprd15.prod.outlook.com
 (2603:10b6:301:4e::20)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: cfdc7147-cd40-4ca1-17c8-08da43382d2c
X-MS-TrafficTypeDiagnostic: BN8PR15MB3428:EE_
X-Microsoft-Antispam-PRVS: <BN8PR15MB342895AA12016FAD120AA6EDD8DC9@BN8PR15MB3428.namprd15.prod.outlook.com>
X-FB-Source: Internal
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: JUC6KlRbS/JSWQ5iYhetmGFUadqbheV4990oWZpFtp12/6jfvgnYV/FhvEA7sNi7oj5M7Ak9PUx325Zz7uSyAd71hIa6QEZuL7fkYfwFy6jQ5p6sLgzMAAxtEKJjUgjDaimfLWatsIte0hu0jdvAIjEmoIo7u8GXW9zt8gxAzFVbmlKBKN6eUgwr9NkXCz7V+ZRuTYBl5KEjhAg+0vrkmV2o5+raj5kYOdpLXbYANEEVjXAI7x//wn0YYENEU4FS+tkfot8N1n2Pf1jB8GoKBXmXFJHYN9Hg3WFWSbOPtU9MZTVNuniHCBSGKh/SG2t15CvKwkoQhX6hxF6PFNLI9w/zvZqNX9ItMRVTYRQ3Dymq2xcA55qPCbxHKjrZ5iigvwAQ6WVPXG5fgMkrCjPs2NDYAt3myVt4eMu6zMhm1rlF9vlX7mzSOq+4/Mlgd3xF2sSCMKt55cs5b75cwHq07B/zPmm9YWXiqr/zwbgnig+eJyjakk6T2jPfb734Tyj+rugJ51sVJmwwSJ+zwFYSfYMDugMcrhTF9jK/ARydyBAZK6vNrFryp0smbDICd537+nd24GnDa+spfOH37EPZ9BBWU6N+OFgEnwhwwAjfBPrK7pNT9vwRu9BWz4VRgX/Mje6U4b5GCKQjYpJrlmZCr1wBrt5G6P8JfNe9gJQ5F4y/nPuo2F9TGTwK/DyhiUOF8w59aFovAd9Ask0Deubfj21ZAvYYYZk4VEg1rzYkBfE=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR15MB1791.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(8936002)(4744005)(66556008)(66946007)(66476007)(31686004)(316002)(6916009)(6666004)(6486002)(2906002)(53546011)(5660300002)(8676002)(4326008)(508600001)(36756003)(6506007)(6512007)(38100700002)(83380400001)(86362001)(31696002)(186003)(2616005)(45980500001)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?NnBLUVp6NnRFVjRGR3JtVjRLQnFESkhPRE5idmdZTkloYW9JakkzY2ZTcVk0?=
 =?utf-8?B?QVc2cndydHFUblFpOUgvSWJJN0JxTmlzSVZvRTZ0R1E4TFQxb2JhdGl5UVI0?=
 =?utf-8?B?UmNHa0RwUElYUHdIbkNKR0ZzdEIvTW9UNXd1bnhRRVpCcHZpbVhBcUMzZ01k?=
 =?utf-8?B?SnNic3h1c2RLbGRKODZ1cWhLVm1KaCt6SC9FM1J3L3pRMllQZ0ppbmdmNHZC?=
 =?utf-8?B?djFtek5UbVh6V0VTK25FQlh1L1pibkJZYm1vNlJxL0NNbFRuVWg4d0hIZHNL?=
 =?utf-8?B?YWVWM3M1cHJOR3ZEZkQxaSsyUXVIb1kxcE1GUTlwa3dMV20rc0hvU2NPU3Fv?=
 =?utf-8?B?cG9UeWV2VVpkRlVIQUxwbTNjUWNldC9qTnNiVVgwQ2hyMklwc1BVckZUWjdD?=
 =?utf-8?B?RzR6RDB2Zzk4QnBkTWtZMUt0L2RXVlJaUmJOOVNGS1RGNnF4WEIyQTNNek90?=
 =?utf-8?B?WUswb0hLTktqc1Zvd3duZUhnV3U4aDJBT3VVQms0KyswNkwweUdrWDYxa1Er?=
 =?utf-8?B?QjdkNktlbUFNQWZsdGNQem9VdGlsTmxLN0lYOStwS1IybEF3TEg3WEplZENJ?=
 =?utf-8?B?WFNSa3puYzFFWFRvbnZFU3VMdzV2UjlxT0ovb3owcFRqN2dSQWVTWHJBdTZx?=
 =?utf-8?B?U2kxRzV3RXQ5b1VEanV1OEJic1BOL01CTWJYTHRScWVhRm00T0xNYUhqU05l?=
 =?utf-8?B?OGg2V3B6OTZhTjJaZHZjWEI5R0h0TG1SRGo0Y2ZLaVRmQks1YTlQNUZTOHRZ?=
 =?utf-8?B?UmFKYVI4YU1OYTdCOWNUVEp5RTZtNUhYS01FTnBheS9iZ1piYTdTL2JzbVFr?=
 =?utf-8?B?NStjcldzSytDRlhiaCs3UW9tQlR3Y3lOenlodTBnNGlFcEpGNG9mdHIxa0VI?=
 =?utf-8?B?RlNxcXJ1MTd6c0JQY0FTM010NWhxYWZaYUlraVd2OXQxaS9xY1V5ZGlEVDRj?=
 =?utf-8?B?M0xNVThPek9rSkdIeXFZbTJTYktyU3MwK3NuRFpNaGRPOHUrN1Y3eDk2QkMy?=
 =?utf-8?B?cmZFYk5Na2RxZDR1WUZQZ1kyMnVvc1B1aDhRUXJ4UWdJQWwwWmxSZEtUN0pi?=
 =?utf-8?B?bS9nRGVkenpyRGwrTnppbHZZRkFxSk96S2NZSlhDNUFyNjQ4STRIVXEwSkto?=
 =?utf-8?B?ZVFTSlNMNFZRT3dBZlNxK3puNFl2TW94aTVvd0YrdVhVbWs2djFUekhwQmI0?=
 =?utf-8?B?cmJPVml4alQzMUNGb2NxQXA3N1RUbFMya3pRbGVORklhUUxBT3d2WVNudnFh?=
 =?utf-8?B?cTNYdFRGQWpoVUk0eEZaYmg0d3A4ZzhzM2JrWmJYdWRkWXlXMmE5OG9vZ0lQ?=
 =?utf-8?B?K2lrY28yOExLakxVN2tWWko0OHFURUtJRy95Q2dZa0hOWDFTbHc4Mk1scTF1?=
 =?utf-8?B?eTJ3SHZqRHB5TE5pKzR2SzFEMC9YM3daeHlQMDVrUXhhcEY0Q2tSdTR5Mnov?=
 =?utf-8?B?aWF5N1pGbTF3SHlzc3pZS3JiSSs5QkF1bjBQMUxXNUo5dmlmODRrSG5KZXRE?=
 =?utf-8?B?enRjSkhSNmxpMXFuc3ZEVEoyM05SSVJoQnJTcExEZGxyRzhQSDRYcUZ5VHM1?=
 =?utf-8?B?OWtLTUxxNTFwdVMxUW1UbFQxK3RwOXZWTitERlVIei9KUFJlMG1KVW1tV1Zk?=
 =?utf-8?B?a2VLRk9SM3JxcHdhaUlwMEtwWjZWQ3JwcnpGRSt3REx0V2N4dHRGeTVrTWRp?=
 =?utf-8?B?WlRRWDdpTXQzSy9mQlhPTnVIQVcrc3M3dVYrR2RiOHJqWkFtMXp6K3llRDFJ?=
 =?utf-8?B?ZlB1MjBjTVZpaitzMGRUYVgrZmMvZnozRVhPcXFNRW5UT0NFYkpLbHkxQXZH?=
 =?utf-8?B?Z3VsZCthQi9zSEtFTVhGRDBJMUFTM2xiL3M0MGFianJoQnlDYzdzMmE3cU5C?=
 =?utf-8?B?TXdOV2pIWlJreUN4ajR1dDNXWUl5SG8zejF0UGhHT3lmMm9YRmZvQytLMTF2?=
 =?utf-8?B?eHlVL3RPVUNveVJrTlVVaXZmWElpUmswL1YwOXQ1U2Q2OFNSNmo2ZFdsdkhS?=
 =?utf-8?B?Z3JuaGxzekxTbTY3bW8xTy94T3N0NUF3L0VxRVEzWG5mYytNc1MrNk8vNVNG?=
 =?utf-8?B?dyt5V0Yrd0plcFJKYnROK1dDUVM4cERPVjJaNUorZG9JQ0ZQVFJJaHB2b0d4?=
 =?utf-8?B?djdad1kwTkkzOFp6UTFYdmF4SnJLZGJmV0U1WHAwV3BsV21vVFdZd0ZzSWJy?=
 =?utf-8?B?S0pIMXZZV0ltbGJiSXpaUjZBVVdaNmd5RklDdURQKzZacnFuKzgzZ3VEYlpN?=
 =?utf-8?B?MUFPZXp5YXFLaUl0MTFzQWN5VzIxK0lJYi9wNm1NNndjb3BwTUN2clVLcXUv?=
 =?utf-8?B?SG90ZEVYT1ZZdnUxRjFlQUJPN1c3YjRnRG9tOGRpY1QzRzNleGRzSGUxa0do?=
 =?utf-8?Q?kVSYc/Zk3LZUVRc4=3D?=
X-OriginatorOrg: fb.com
X-MS-Exchange-CrossTenant-Network-Message-Id: cfdc7147-cd40-4ca1-17c8-08da43382d2c
X-MS-Exchange-CrossTenant-AuthSource: MWHPR15MB1791.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 31 May 2022 19:02:58.4096
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: lLNo61MuO8YkBvJQ2Y/2jAuub7nu3/+5TAZ8nUuXsn1YONb0KCKLAbcM4crch21i
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN8PR15MB3428
X-Proofpoint-GUID: pe1iBFzURUmV7xbBQNFJzF-PJSxQnMjF
X-Proofpoint-ORIG-GUID: pe1iBFzURUmV7xbBQNFJzF-PJSxQnMjF
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.874,Hydra:6.0.517,FMLib:17.11.64.514
 definitions=2022-05-31_07,2022-05-30_03,2022-02-23_01
X-Spam-Status: No, score=-6.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_LOW,RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org



On 5/31/22 12:01 AM, Christoph Hellwig wrote:
> This patch itself looks fine, but I think with how the next patch goes
> we don't even need it anymore, do we?
> 

We still need the patch:
- I don't want to set the pending time flag in all calls to update_time
  (for "fs: Optimization for concurrent file time updates")
  I only want to set the flag in the file_modified case and if the time needs
  to be updated.
  Also setting and clearing the flag in pending time flag in the same procedure
  makes it easier to understand.
