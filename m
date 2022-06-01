Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A98E753AB9B
	for <lists+io-uring@lfdr.de>; Wed,  1 Jun 2022 19:15:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1355642AbiFARPh (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 1 Jun 2022 13:15:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40296 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244187AbiFARPf (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 1 Jun 2022 13:15:35 -0400
Received: from mx0a-00082601.pphosted.com (mx0a-00082601.pphosted.com [67.231.145.42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ACF23A3094;
        Wed,  1 Jun 2022 10:15:34 -0700 (PDT)
Received: from pps.filterd (m0109333.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 2519rkHb009929;
        Wed, 1 Jun 2022 10:15:24 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=facebook;
 bh=vRq15P0zEYOF0lH4OusZZa1IRkN3crov8h8H8B6dGGQ=;
 b=YEcJgbh3y3fMTK+8QCQ71IUcYTjpKegq6CRoXx0erHxLclh+aV6D6x3sthUswOVgAKt8
 JdH8pMp1UhiSSM62Ia2PhJ+HDaWr7hBa58Sbori4o9gYtcioMiTn4rd3qQMNr87LjvNK
 cy2RKcosAw6tdUxFdPaRV/jW038faL8/5ko= 
Received: from nam04-bn8-obe.outbound.protection.outlook.com (mail-bn8nam04lp2047.outbound.protection.outlook.com [104.47.74.47])
        by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 3ge5vcjp65-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 01 Jun 2022 10:15:23 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=lwvGYodw+mTcS3t9Uo8qCxW8rsSsTO1raRk03HP+m/Q1J7yixRFScqsvPKNB+Ym1EsyJSzTZcDkQCIVmEi1Piy4C8RtPGuBkujgTjgHKAWKXXE6LbYQKETK9cFJpStD7Dd9oW0gS+o2adL8Tp+0RlZGDtXrnG1wFFSWmVVmM8FRXUquQT0yVKdabncXkHZs3ARkrtbO0q5rme4J7MSgyjfMs9XrIo70SbnJJCeU65e7PvY61+jcIAv0cbPxATIf8QWQYsR0bDZjjicixMMEWthm4WdWIGzsDs3IxvOMUHPoqBlQdQGGJhyiCb7PgyXDVEudSw6HwTjJM5FOLIPBkVA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=vRq15P0zEYOF0lH4OusZZa1IRkN3crov8h8H8B6dGGQ=;
 b=h25Qdt8OI8pvxgI+AcaJkNHHtO6cVA9K5txuIB1eQussSI37er6H/czA6ca/wwXnv50kL34SdmnLylhf9QlSkU+wFJ7xDvD3L1ZKR5qyUCIMZcbPnJ42Idq7MLCT7CVw07gf3cFEbVL7GQzMwIDOkxROye+yOK4pAkv+fK84VgyDAkACU3Lckw0VJZ8+9r016vj5J4elffhIrYdY1FLxS5scFVwqGluZVkS5ILXKFohedPKG4/r7sjFRZwmqrouR2JflLk4uyrAvlub9Ika/2ZOxS9Rqi6LjLLMysTH6iDPQV/epFjOQAWpDwcdHTD7PXnN0Le11V2Vxr50QIYFr4w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
Received: from BN6PR15MB1780.namprd15.prod.outlook.com (2603:10b6:405:55::18)
 by BLAPR15MB3905.namprd15.prod.outlook.com (2603:10b6:208:271::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5314.13; Wed, 1 Jun
 2022 17:15:22 +0000
Received: from BN6PR15MB1780.namprd15.prod.outlook.com
 ([fe80::8dcf:110f:315d:1585]) by BN6PR15MB1780.namprd15.prod.outlook.com
 ([fe80::8dcf:110f:315d:1585%7]) with mapi id 15.20.5314.012; Wed, 1 Jun 2022
 17:15:22 +0000
Message-ID: <08eeaad4-3e2b-01c0-79ce-c377c26ff03b@fb.com>
Date:   Wed, 1 Jun 2022 10:15:18 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.9.1
Subject: Re: [PATCH v6 14/16] xfs: Change function signature of
 xfs_ilock_iocb()
Content-Language: en-US
To:     Christoph Hellwig <hch@infradead.org>
Cc:     io-uring@vger.kernel.org, kernel-team@fb.com, linux-mm@kvack.org,
        linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        david@fromorbit.com, jack@suse.cz
References: <20220526173840.578265-1-shr@fb.com>
 <20220526173840.578265-15-shr@fb.com> <YpW+DToVN0NjUpx4@infradead.org>
 <b0a521e2-6753-590b-ecb9-a8910d2ec678@fb.com>
 <Ypb4fzsBoWSbUh1Z@infradead.org>
From:   Stefan Roesch <shr@fb.com>
In-Reply-To: <Ypb4fzsBoWSbUh1Z@infradead.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SJ0PR13CA0094.namprd13.prod.outlook.com
 (2603:10b6:a03:2c5::9) To BN6PR15MB1780.namprd15.prod.outlook.com
 (2603:10b6:405:55::18)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 59a3b628-28b2-468e-72fe-08da43f24f4c
X-MS-TrafficTypeDiagnostic: BLAPR15MB3905:EE_
X-Microsoft-Antispam-PRVS: <BLAPR15MB39057667D059C97F7EE1C4A0D8DF9@BLAPR15MB3905.namprd15.prod.outlook.com>
X-FB-Source: Internal
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: JiWJNTSrK3kyN6TYPrE2MCmQ8ZLmJ2W28VtL/FQwaBnKeCLglWYhzaRPYLuLfFfVw+14DXkNpck7AUEMUddfZ7Ox+eUk3tS69BCX5IqjjBxZjjihQZkQLzjJd2eSHghd3yA8036pW2u7BysY2F4D/Y6hf2s8FPCG921b7pDSlv5zRe1OArP/Z4XwYOUUjLbs9Qi+cb1CPbhb9u+9RCoN+m2bZoNegUli7A6DJfVkTkeNYXEdW1q3xsCku2LqHG4YmWAga9e0IIFutEbaHF3XnbRQuTt5yJo1pisG/c8l+1Ch1L8RyyKXksuiX0TT0zXy1gLlyQNxadkzw62b6rK3YSIAmSua6xvL2jsRXqLIp4CqEbr54ZKNIOItpmJJdu62jAixO3XfQNYGH+P0ZxR/VNqsqhPqc77+N4sTtMUGDaZvvRG1ZxZwBsA3OrUgmMZlE2ygKw4tecNCIFJHrm3touoebsEqXb6piiLaFQlxb6lOaa8Xe3F6s+ZTXLMw7v6Ye3iCcM9MiGUYf5qujEJVGBWTuFg7VGM4DeC7Z1qYdiXZfYafuDSqXS8AYVe5om9rKpkYqWfPW7FkfYLtnlm4l/Vk96dRcxY3o8rF4Dk1eTicIwA+IdPW9UtVQLv2edVwoB3N/ON3FBIn/kQUOrcAAt6f57Pzm+hasH6gvjCTnFX+wPLtIsTBsCqgNdQCKe+nSjoKw8biu+DHr4ccGA0j9ocg+sEhkymoCIuyLmGvK/A=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN6PR15MB1780.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(186003)(2616005)(8936002)(83380400001)(6486002)(508600001)(5660300002)(2906002)(4744005)(66946007)(8676002)(6506007)(4326008)(6916009)(53546011)(31686004)(38100700002)(36756003)(66556008)(31696002)(86362001)(6666004)(316002)(66476007)(6512007)(45980500001)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?Uk9tTEdEQXJkSGJlUmNrOVZFcE9FN1o1dVQ0endTK2ZWTmtqYnU1VXlwZy9G?=
 =?utf-8?B?ZFRxMjBYZXk5VjBqMFRxNi92SjBPQ2l2eVd5MmtCbzN0clVMRHNFTFhxRmdK?=
 =?utf-8?B?TGVVZFJiWkpDNS9vZ256eDNBY3orL01KRnUvTXhOMFFBWlpjUEwvSmp0bVZH?=
 =?utf-8?B?YVFXaFdFSmVSLzMvb3pNUGFlK3JhQllYbzU1VXM4NFBVUzNlYXRsNnc4MStM?=
 =?utf-8?B?cEtxL05TeHBTQnAyWitzRTIxbzlLRnI0aHc5Z0VMMThOajJ5TVAyZm1aYzNY?=
 =?utf-8?B?QzJXSnpxODVYSVBUUzBJZEpZU2E1cWNtRDQ0Yk5tMU5WN1VkcE5MYmhFSCt0?=
 =?utf-8?B?UFg0SjZWU1Z1aXJReHIwaDZmYlBObmdTNm9lUFg4akpST1c1d1FOZGtiVmEv?=
 =?utf-8?B?aVJVT09YTVFIV0pCc0RHckl6alZxTEhwVzMyTG9zMzdncHZLcUZtZGJ6bTB6?=
 =?utf-8?B?WVFOQXNscU9xVkNlYWQzdDlOZ1ViWVJITksyQWd5YVJsSWs3YzlqaUEyQTFJ?=
 =?utf-8?B?RjJrY2o4N1V6TUNvblpBM1Fyb3JkQkNVVW1NYjQwVS9GVmJtdnJhaTRqQnk4?=
 =?utf-8?B?cVBXSHJ0TzRPS2NPOXlCWWEyQjlFZmg5TzdWWDNKcEF3RTlYajFUT2pOSTln?=
 =?utf-8?B?M3Zqd0h2d1Q5WWRkSi9MeTBZVzI1OXRudVRQblh2ZSs1SDFUMG0xbDh2TXlD?=
 =?utf-8?B?Wmd3aUNhRmNXdld3c2tKeXczTW0zMWNkdEpsbE5NY3RLSDNrYzNGUzBKZ2FL?=
 =?utf-8?B?ZWhUbXAvMzRGRlNuRGhIRGRodnlKZElNQ2RaUm9wNi9RenhiRGNEOWFBN215?=
 =?utf-8?B?YnUrRWcrQVBFOW5aZHZieGFoczQ3Y2svN25WYkUxOFVod0ZLL0c3NXpxbG1P?=
 =?utf-8?B?NzlnOTBYenNSUDZ0R20vRmtPTVhpUWxZQUx2L0poeWRRSVdGS2FZSFdoSnNx?=
 =?utf-8?B?K0xYTWh3ZC9nczBocSs5Q0ZVbVhTTWhoM2dLREhGeGJWNTg1QXR1eXA2OFli?=
 =?utf-8?B?aStGS3ltT1VNN25vTG9KUEJzRzh1MXZ5djl0WGVXdVRvTys1MjUyd2RUWk15?=
 =?utf-8?B?dDhlSlZCdFVSQ0pUNncwZSt3eHhKU2NYaUNVY21TQU4ySUZrMFZFVXY0MDc4?=
 =?utf-8?B?bGdPa0wwRmVUY3ZOZzdxWlFxVzBJZzI5NlEwdlNkT3RidThMOU9YczF3QmdT?=
 =?utf-8?B?b2VBbnBmT2JaaU5GVWpZZmo2a04vcTYrcXAzMEVwNTZjTlJjRzIzV2ZyWFU5?=
 =?utf-8?B?QWhKMHBTQ1oxcnZGT1QwQUliWGtuY3ovOTJabW52VS9Ua1JGZmNDUk1XSnlt?=
 =?utf-8?B?NEVTSlJEZGpxdEVZektBNG9zVkpFM05walRqNTl4eVJRZUhZaDRMWU5jaEtW?=
 =?utf-8?B?aENRZFB4ckI5bGJBV2QzVTRKMEdqbkwvSURabW5Ud1VHUWJkMmlKRkdaUXdX?=
 =?utf-8?B?Nm1kaFZoVFk0Y3RIR3gyZCtELzhpT0pFcXFOUUw3bzZxVUtHT0Q0aTZhVmNH?=
 =?utf-8?B?ZEJvdEZhL1ZwNDZWQXRSeGl4K0xOVS9ZTDFpamRmbHIxckdSdlpaQnEzYzZE?=
 =?utf-8?B?MHo5eWtLTDJKLzczbjBFWFVlQW5WL0pEdU5KWEVyOGtDN1REUW16bFNmOVE3?=
 =?utf-8?B?T2xtOXExNDc4d3BYSG9POWpLdWg0NEx2S1ZWSDFJRUxBQkd4ODdIR2pFdEMr?=
 =?utf-8?B?OUhQTU5jVmJGdlkyNlRLNDZ4emIvWlIzM3QvY3pWdFJTL01BSEJ3QnhmWUxF?=
 =?utf-8?B?cmUvZFJBTmZINURVN3IrMk1DNkpBUXpiSDVQeGwvMGd1WEkvT1VVUjVjTWd0?=
 =?utf-8?B?NWE1WXo3c0NCTlp3SzNmRjVRS3grdSswcndScEdROUdkZUNhdzZkT0RVdk5S?=
 =?utf-8?B?QUx1MmZZRTBCbzgwTFgxdlJXcHhrQlFObmhZNWZ4ZzBCajhoWmlkeEtWNDdt?=
 =?utf-8?B?N1BpVytZRTBoNTdhM2cvdjZCUGFqdHJHMDJKVDB6SytSbExyM3laTWhsQUND?=
 =?utf-8?B?L1JkdkJLTFEzSHV5dW5TV2pKTC9VZ2NxZlllZDBQRSs1NmVPd0N0djF2UmJW?=
 =?utf-8?B?QXN3cG54MGp1enAwd3VDeDJ1ZDFONlRIRGJvLzNmU2NmOHhRdFZtVmVRNEkw?=
 =?utf-8?B?WThGeHhaSDZwUXEyUFRBQWZNeStIMVpRbmpUZjVKa1ZsejJRZWUvWCt6blQ1?=
 =?utf-8?B?VnR6c3JrMldrcjIzY0Yza0d4ak82VWE1M2x4WCszMElYdnJyN0p1OW4wYmF2?=
 =?utf-8?B?dW82Ti9JaWZUdVN5czgwK3BYdGxqTUJxTDRRdEpnQVl1QUJBcjBxTDJBeklL?=
 =?utf-8?B?RW4xUUtaZytRNzBHZTB0RE5ibnNXVFNneHYyMjBrWE5CYm5yWlNBTGl6VW9O?=
 =?utf-8?Q?d+IDQtblDkPZBSgs=3D?=
X-OriginatorOrg: fb.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 59a3b628-28b2-468e-72fe-08da43f24f4c
X-MS-Exchange-CrossTenant-AuthSource: BN6PR15MB1780.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 Jun 2022 17:15:22.0715
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: FWtP8Z2jkNXUMy1Qy2cy1CoGpmVJwOQ+9NYXdxbcOgPrGpPIIIm2KVsnvi4gjzau
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BLAPR15MB3905
X-Proofpoint-GUID: rxI0fozl_OXw7rREzm_E_Amp7h2nr5Kj
X-Proofpoint-ORIG-GUID: rxI0fozl_OXw7rREzm_E_Amp7h2nr5Kj
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.874,Hydra:6.0.517,FMLib:17.11.64.514
 definitions=2022-06-01_06,2022-06-01_01,2022-02-23_01
X-Spam-Status: No, score=-4.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_LOW,RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org



On 5/31/22 10:26 PM, Christoph Hellwig wrote:
> On Tue, May 31, 2022 at 12:15:19PM -0700, Stefan Roesch wrote:
>> The problem is that xfs_iolock_iocb uses: iocb->ki_filp->f_inode,
>>                 but xfs_file_buffered_write: iocb->ki_ki_filp->f_mapping->host
>>
>> This requires to pass in the xfs_inode *.
> 
> Both must be the same.  The indirection only matters for device files
> (and coda).

I verified it. The patch is no longer needed. I will remove the patch.
