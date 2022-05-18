Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 35C6752C76F
	for <lists+io-uring@lfdr.de>; Thu, 19 May 2022 01:23:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231183AbiERXXN (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 18 May 2022 19:23:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55726 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229952AbiERXXN (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 18 May 2022 19:23:13 -0400
Received: from mx0a-00082601.pphosted.com (mx0a-00082601.pphosted.com [67.231.145.42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DEC4F17909C;
        Wed, 18 May 2022 16:23:11 -0700 (PDT)
Received: from pps.filterd (m0044012.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 24IN6F9R013632;
        Wed, 18 May 2022 16:23:07 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=facebook;
 bh=1GmrS3qeFWiqLkoeJ9LfgwQ0P5K13MhE4n/sqipegXI=;
 b=ncUnXPub9Avnae+Qyi17tUj5ER/mrvfeGcVSTsacDKns0oW5JDcEf1RJkp93hHutefl/
 JyU0m8kpXt93u2M8mvn4tJgZTdPJQl+xzIIbs68xvBqUJpXXF5EsfIcYCWBAmDVB4jEU
 stVDcM67x9yplEoJfLVusyJEuORZI1Mzops= 
Received: from nam10-bn7-obe.outbound.protection.outlook.com (mail-bn7nam10lp2109.outbound.protection.outlook.com [104.47.70.109])
        by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 3g4dea3rcg-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 18 May 2022 16:23:07 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=OjeKjAGMNcVEXeEwumLLHTZ9jZpmZE9AbW+YVeO4UHO8CUSuC+A0si6bSJIwlSBveNBE7X9RwToafzDFLm5h0lKf8bukGwBo/+qLnB4B/RLf8yTKcsvt/Dxg6MX8CN0MPBh8FHdeWepEj1fCGBL5bsIGFcla5gOuwu8tY/WyWhnIDRBjR5CkjhlcKAkoS0yXWrqCt42uZ7QAexJs+XmCV4t8QmN+Mr7MbS2iTf/yydcEseW7Gy5nvxOA4PRwnZxu1p04WiXUHWGy6c92wdWJwunRUVmGZZoSZIraJQ39hSS14TNWW8ZBgdqBbJiLW90xGhF9B5pwXXEGA0V6x+gfOg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=1GmrS3qeFWiqLkoeJ9LfgwQ0P5K13MhE4n/sqipegXI=;
 b=TsH+9VGU4ASjHrIJoS2JmnKz9sVj9srMYQwdCJ3LA24IVDyEikWY90vB1B2voh5pndeyqsDOkEudt4OHWrWA59B3xlYW2oOwOhE0VVgNmJd3PYll3m/BsfBw/Jt7zs6+MTh9rxvLSPT9vYHLdvYS4pEuenepThyRaEfYxsOlWRV7jboV1I6OS57PBqsNWHciIW/sXR8nx1/B0fgCnBZYm29saBd5/FA97VD5o7FGmPfygJZemxExgzZWHJ/Ww1/hpF7cO4SxixaxBI61KcgRT+51hYzF365UW4f7E2HbGZNE/WBHHn4mm/qME7EmfjbE8WZdkprVNXtjb8s34VEA8w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
Received: from PH0SPR01MB0020.namprd15.prod.outlook.com (2603:10b6:510:76::6)
 by BYAPR15MB2773.namprd15.prod.outlook.com (2603:10b6:a03:150::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5273.13; Wed, 18 May
 2022 23:23:04 +0000
Received: from PH0SPR01MB0020.namprd15.prod.outlook.com
 ([fe80::ad90:787e:697e:3ed1]) by PH0SPR01MB0020.namprd15.prod.outlook.com
 ([fe80::ad90:787e:697e:3ed1%2]) with mapi id 15.20.5273.015; Wed, 18 May 2022
 23:23:04 +0000
Message-ID: <88e7ecb9-65e9-7209-fe4a-7aa6368691b4@fb.com>
Date:   Wed, 18 May 2022 16:23:02 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.8.0
Subject: Re: [RFC PATCH v2 08/16] fs: add pending file update time flag.
Content-Language: en-US
To:     Jan Kara <jack@suse.cz>
Cc:     io-uring@vger.kernel.org, kernel-team@fb.com, linux-mm@kvack.org,
        linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        david@fromorbit.com
References: <20220516164718.2419891-1-shr@fb.com>
 <20220516164718.2419891-9-shr@fb.com>
 <20220517112816.ygkadxcjcfcirauo@quack3.lan>
From:   Stefan Roesch <shr@fb.com>
In-Reply-To: <20220517112816.ygkadxcjcfcirauo@quack3.lan>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: BYAPR01CA0036.prod.exchangelabs.com (2603:10b6:a02:80::49)
 To PH0SPR01MB0020.namprd15.prod.outlook.com (2603:10b6:510:76::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: ff285cd3-2e5c-45a3-f5b8-08da39255bbe
X-MS-TrafficTypeDiagnostic: BYAPR15MB2773:EE_
X-Microsoft-Antispam-PRVS: <BYAPR15MB2773748AA5530761F696B1C1D8D19@BYAPR15MB2773.namprd15.prod.outlook.com>
X-FB-Source: Internal
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: o4ciP1iLLNh2z6pOkvPmP+F4hXI4PA2UJwkCLCcyVKSWF4vI/qd3gAYR8oS3tj1+ogrriYPV6rxa8xiMO2BVfeqSPQLcwVcuFP/x7YXSE2SrFL3b4IBYxnox3gOWOzknZRfHJLAj+TLpvWkmArw3jJjQUmBXsUfeTECEGFe8YGgWNSdI3zXrNap/OaFC6CG6TvXgLzv5ioA6JYgOvl2wVdoGFURQfiH9b2HGM5z37mq3VXkOLZ/IadwguCIuRyzQzprSLAiSaUB0CTbyhaOQsjUWSqCMNIdbhXKXPiUCuwte4oKF0ra01NNsP79DYszG0GzG8+FmqMRgecEC/9WctsyZOuhuRmLZ15d+d8Ddzzm+ZKftP0j5wd+nRUqguzla8iK5gqWAk3fhCrZNV2NDu2GVADkP3GE7h/QpSrVYwo3BPZt6jhPQuJ1zhTUMvTlrgRSBcj93iwJgDA1hYu4ilV/nufURMzUCfA13b7uDTg/wv8GSKoiJok5mNNL3FtO4+fGdX18tMX6tNOKJOh0uTMqaHvrA2VWtd34yM4rTBs4lZAoJt585xOvgCirljflqCqw3Gt9zm1sFNpHyfuG26rjOcMBNdK5sg2Rax6IeA6zj/zQXOYnsZCBTwV6KC17iS1CAVd41J3w2GcOyqSz+xgAxbYpcf9YJl7Cnfgbk6lZ45Wg861+s5fFfrTnNGFuaJ1b5mmNFGB/ZqEjw+ndA/qniK9HrjiB+8xm9rdL9IRIiLNLCbkc7o5r7AOMQsScY
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0SPR01MB0020.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(53546011)(31696002)(86362001)(6506007)(186003)(2616005)(83380400001)(38100700002)(2906002)(8936002)(6512007)(66556008)(8676002)(66946007)(4326008)(66476007)(5660300002)(31686004)(15650500001)(6486002)(6916009)(508600001)(316002)(36756003)(43740500002)(45980500001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?S0t2VjIzZmsvWlo0ZER3Vm5Gc3Bsb1JTa3BXdEN3NmU2a3FXWlBseEVydldE?=
 =?utf-8?B?eUs3NzdxOUQvZnFDVGtVMnNNR0dGQ3R6eGNJOGVmR3JOenhBV2ZtQWkxenNw?=
 =?utf-8?B?bGpURWZvTk52cWFmTmt3QVNsa0xtNEhLVzZtSkJ0MkVCTHR3SUxZaWFScFhY?=
 =?utf-8?B?MlVna0lEa2V3amdpMVlIamw1ckFuRVI3emZaRHh2b3dyNEN0dHl3Z3JIc0FG?=
 =?utf-8?B?czZDeC9HUFhQTWJCVFlxcmZrYWVnZStSakZWMTBOclJjQXMwcDZQVHgyQWQy?=
 =?utf-8?B?TTlYK1l3dmdKTVJjVUtjQUpyc292Qkw3enowOEpQQ3hJeUtMR0JGZkJETXh5?=
 =?utf-8?B?L3lRZldBSXVjWnRjL1ZvTkIwL3NwSmU0M1hTMGVOeURqTVVUUDBsVXB6T01Q?=
 =?utf-8?B?NjlWbnhrS1hzVnVaNGR2cHBiU0d2SHhoN042V1FSR1o0QmNQMkxWa0lnbkZK?=
 =?utf-8?B?b3IvUjF6cUIrNnRLQnJPNy9iSFhDWFpMeWQ1RHJCMm80bWZLdlA1UUREOFRO?=
 =?utf-8?B?RHdyc2RjQzRNcjNTejZGWFVJWTRyV2MrbWg5YnZCdzEzTndVS0lFK0o1VzRX?=
 =?utf-8?B?NVRPOVFyNlJQVG1hYWluVWJGS3NEM1JReTh1dW16bDg2a0g2NnZFa1psSUhm?=
 =?utf-8?B?ek9JMkt3TE1XMW9QK3RlSndWRDJaYXRqRlhNZUFrVFVlTjlmZnBNM0YrSUg3?=
 =?utf-8?B?Uko0TVFzcFJ6d0RHN3MweVByaDNoaFRoLzBwTUhJbFJRR1Erb3pQZzRTaGR5?=
 =?utf-8?B?YlMzaDloQkFmeDN3MUdIVGhKQkFnUVRjczRUZWgva1dJTDVIaEJFRnVld1dU?=
 =?utf-8?B?Y3lGZEdoVDg4Z2dYVTBoRFdzV2dNKzl6UXZzL1dvU2FvQWc0TTBiZm5GMmpl?=
 =?utf-8?B?dDQrZ2k3RzlLMkJwb2VTcW9FdVZxaFNkUmlXRCtCSForNjdrOUw1bzR5NWZ3?=
 =?utf-8?B?TTZYZTVpTGZ3SG1SRmRsT1pFUGFTdit6YUdsVUV5WHh3d3Q3bUhydnl3YW9u?=
 =?utf-8?B?UlpMa3lDeUROOXZ2RGlmOXhOMmR5Lzd5a09zbnVqK2dSaDBIeENHdG5qWThr?=
 =?utf-8?B?aTdqTXY0M1UvRDBtelBIUG9XTlRBSi8rY0daMDM3UTJ2bTNDWmlKUVpiOHdG?=
 =?utf-8?B?L3h4VDYydXFKdEhvYXBzWUY1RG9zRC9lUHhmbEpGVW5mazdPbDZIMFFHak5E?=
 =?utf-8?B?NmFzaC9pS2pQcUhRTzdTbVFkQzlldkt4QnV2N1RiWG5BaEE2aEFQQjdaeGVp?=
 =?utf-8?B?SjZJbjRSSWxMYjJJNENPT0x0R1piTGw2OU03U1JHamg1ZXdWRmo5QlF4cklY?=
 =?utf-8?B?eThjMDluUnNxK1NHbEVIeWdaMDVaSU80S0IwMnFBdjdJSXJ3ZGpBOWFBY1R2?=
 =?utf-8?B?aVA5MlcwSkFqTmltak1Pd3EvUTd4K1hzYzJHWnNVLzd6bXZJWHBWUXROYnFD?=
 =?utf-8?B?Q3Q3LzNPaXFEY2YyM2dTYXBTd25hZlJKRUxUZWNjZitoa1FydlFvblpuN3JV?=
 =?utf-8?B?U1grU0JpS1FvcHhLZy9aUjE2N0lpK2dZUE9oVi9UUUNXQ3pLS0o3UDZDZTJU?=
 =?utf-8?B?RE5kb2lCSW9UZkF4L2UrNTkxMDNORmE5Myt6TWJSYTlqN1hPakZrZ3NncFM0?=
 =?utf-8?B?SzMwaSs3d1pzb2dCRzFkRnpwV2FvaTdYS0pCb0pEYnRiN3RSWEVsTnRxRWNt?=
 =?utf-8?B?NjFJanlTOTlNcTV2Tm5paytmNGV5VGlHUFNhbjJtTXJ4ZkEreDNFZlBNNkEy?=
 =?utf-8?B?WEVmRjQ3ZVBEcGxxOHQ1NEFsVlJnRTlXQkRmTlIrNHpxVkZDYVhwdEdUL0tJ?=
 =?utf-8?B?S3dkeTdiWTkxRXYxWEovRDlWTVg5THpVRGE3T0NPKy9KM1RYa2V2YzIveUdV?=
 =?utf-8?B?UWZ6dkcwSmdSUlZleUd0cXFWL1hCUC9qRkxPRG82bFB5ZjQ3Z1ZYT1d2Qm9M?=
 =?utf-8?B?QmFuZW53UitDNmora2ZJT21iazFlRElrSVhpVWJSRnJQbWU4ZUdjMlQ5U2ZE?=
 =?utf-8?B?dktnY2w0ZkRON054SjA5elQ4TzdXWlZLRU82c2VFa0h6aWZjN2N2SWw4b3VX?=
 =?utf-8?B?bjhmT0tOVDlGQlhwWThOLzRHQzQzWldzclJrQ1FzWHBIQmFCMnNxM3VYbmtO?=
 =?utf-8?B?NFJpbGJxMGlZSW1oRnBnQ2FTZ1QzTTNKdlRmRURKTFhYT054b2x1OVlUMTUx?=
 =?utf-8?B?OFdDRVA5WHpHNXYyTXF2dEtVeU0xOWZEYWVUWEZwUlJwVVljY1dKaUx6V3Bv?=
 =?utf-8?B?KzNTMXRhMy9sd1k0MEwzdXZkclc5UDMrMnRtQU9WdnJLSXYwSE1yZHA0dHNs?=
 =?utf-8?B?eU9qM3FJUnFNUm1lSHRsdVByRkEvZDZsdXFaSHZkd21CaGVGSmt4ZWQwTDZy?=
 =?utf-8?Q?oGKcystq8OdCGMZk=3D?=
X-OriginatorOrg: fb.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ff285cd3-2e5c-45a3-f5b8-08da39255bbe
X-MS-Exchange-CrossTenant-AuthSource: PH0SPR01MB0020.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 May 2022 23:23:04.3410
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 18N51bO+VJx1o26BVk+kVoy6qTD5lXqJwAhq05NeXMJzQmrpQZZdI5Lipwo0lhdl
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR15MB2773
X-Proofpoint-ORIG-GUID: OneKH6njQbMoKmo9I8xjkKgin97OMVLM
X-Proofpoint-GUID: OneKH6njQbMoKmo9I8xjkKgin97OMVLM
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



On 5/17/22 4:28 AM, Jan Kara wrote:
> On Mon 16-05-22 09:47:10, Stefan Roesch wrote:
>> This introduces an optimization for the update time flag and async
>> buffered writes. While an update of the file modification time is
>> pending and is handled by the workers, concurrent writes do not need
>> to wait for this time update to complete.
>>
>> Signed-off-by: Stefan Roesch <shr@fb.com>
>> ---
>>  fs/inode.c         | 1 +
>>  include/linux/fs.h | 3 +++
>>  2 files changed, 4 insertions(+)
>>
>> diff --git a/fs/inode.c b/fs/inode.c
>> index 1d0b02763e98..fd18b2c1b7c4 100644
>> --- a/fs/inode.c
>> +++ b/fs/inode.c
>> @@ -2091,6 +2091,7 @@ static int do_file_update_time(struct inode *inode, struct file *file,
>>  		return 0;
>>  
>>  	ret = inode_update_time(inode, now, sync_mode);
>> +	inode->i_flags &= ~S_PENDING_TIME;
> 
> So what protects this update of inode->i_flags? Usually we use
> inode->i_rwsem for that but not all file_update_time() callers hold it...
> 

I'll move setting the flags to the file_modified() function.

> 								Honza
> 
