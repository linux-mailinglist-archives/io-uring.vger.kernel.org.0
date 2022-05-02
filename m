Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2457551790D
	for <lists+io-uring@lfdr.de>; Mon,  2 May 2022 23:21:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235738AbiEBVZE (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 2 May 2022 17:25:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57154 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232204AbiEBVZD (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 2 May 2022 17:25:03 -0400
Received: from mx0a-00082601.pphosted.com (mx0a-00082601.pphosted.com [67.231.145.42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D60DD2F5;
        Mon,  2 May 2022 14:21:33 -0700 (PDT)
Received: from pps.filterd (m0109333.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 242LKPLu010202;
        Mon, 2 May 2022 14:21:29 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=facebook;
 bh=e1ocDreiMUew3asfFx6pR8djx2fnfp6eRcFEFIXlqJo=;
 b=IadpFvxElqEJGSuEYB8GJhRkzqcUFCWLLKqtoXgE68TQ1PUDJM4mgQKpXjw0ELPOze3Q
 ZutrvTCssWsxivGj2/9iywPmlK3PkIauLPA2IT9L6c1PKHMqs9L1E8ULl8YoQdxRoqcb
 Z7YYnBMW1ETTN6nsKY83+78DAOSWGnPSaWg= 
Received: from nam11-bn8-obe.outbound.protection.outlook.com (mail-bn8nam11lp2176.outbound.protection.outlook.com [104.47.58.176])
        by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 3fs15k493b-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 02 May 2022 14:21:29 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=PNwy3V+xKdjGSOKw0br+xNeUdFlyUc62lq4LM+e0rEDpV9FiaAa1xnbOhfC2X5KOhAzr/dpoI1SRFW0QazV3NJ04VlFx+p6qzytQAov5SkNZ9F8MoI2gux+4dViA8vAedb9lTohhEbQyZxlQgSVn3OUgfW3i20emPkvlQcT2R6IUXctTJfILHg7ezGnPcVu7RBZpnX89GSzjes0qfj2D4DvnVvb4UUrHHS4OnqdoqBInkzpg7VznES/U/hSoKBZdqC8c0fuJplHWgUy1Ikc8XGsuYYWhUQPvIqFf2j/YmbGLljQSBxS23dwscw511fLaitWGm4zCAhQ1biuUkZiOXg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=e1ocDreiMUew3asfFx6pR8djx2fnfp6eRcFEFIXlqJo=;
 b=XMELKnonUCVT3TiG+4yPz/PgCeR4E4x0Rw14b1vQHkUZkcCx8QvdgFnUE8Lh9hRz7vxGbh+qWj/XwQuq2kDSqugURCOFSeq9gEA7iSQY3eV+cbgqdv8UtPapdyv/139cfbXJe8oe+yoGKl+gOfKylHVAz6yFt0dIG1CAcQaHny+VZwuIOk4qh6kuWJZzFCRcvP+U4GE6hQ0g4J3+1PYs+keFHl25bpqdNrOelPCOMxoO5w/MT65M4DDk/C3pyAdRE2q4RGZKbpVihgSYQgRjsEtPCjYD3v85ABVYprBDqUDJ3C6vCXgmxjGm3Kc4HN2YXO5dx9frc2JTk175faz2pg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
Received: from MW4PR15MB4410.namprd15.prod.outlook.com (2603:10b6:303:bf::10)
 by BN8PR15MB2787.namprd15.prod.outlook.com (2603:10b6:408:cf::28) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5206.24; Mon, 2 May
 2022 21:21:20 +0000
Received: from MW4PR15MB4410.namprd15.prod.outlook.com
 ([fe80::687a:3f7e:150b:1091]) by MW4PR15MB4410.namprd15.prod.outlook.com
 ([fe80::687a:3f7e:150b:1091%9]) with mapi id 15.20.5206.024; Mon, 2 May 2022
 21:21:20 +0000
Message-ID: <19d411e5-fe1f-a3f8-36e0-87284a1c02f3@fb.com>
Date:   Mon, 2 May 2022 14:21:17 -0700
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
 <30f2920c-5262-7cb0-05b5-6e84a76162a7@fb.com>
 <20220428215442.GW1098723@dread.disaster.area>
From:   Stefan Roesch <shr@fb.com>
In-Reply-To: <20220428215442.GW1098723@dread.disaster.area>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MW4PR04CA0338.namprd04.prod.outlook.com
 (2603:10b6:303:8a::13) To MW4PR15MB4410.namprd15.prod.outlook.com
 (2603:10b6:303:bf::10)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 38e72ab4-1134-4486-5f38-08da2c81b3a6
X-MS-TrafficTypeDiagnostic: BN8PR15MB2787:EE_
X-Microsoft-Antispam-PRVS: <BN8PR15MB2787195F6D69ECBBE970E2EBD8C19@BN8PR15MB2787.namprd15.prod.outlook.com>
X-FB-Source: Internal
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: a+sXOss4ZsCVDg6F1Ia2WhkHSNzDUBPYNS+l8BchWymRNxky2tZ9eD0ZS4YC5ImX0DHdm57iRZOdKi9wpIYvfmmy4QUBGHPULoLXYERBuZIqAVzh05vBQjki0XhyiWOFmriIzdS4nbUP91/ORB1REtv1Lwl7a5Ss8dXqjvrZ7tB2sbmtWn/5VdRJJM7Sdld9bh5rmeO23vi9LiO72kk/gNZgn77+mPOYN97uXYu8XrlohSoI0+uD3QFTEYIuwrpDBTcYwgo7C+PAQRUmzaOWX9J+XNj9vcfhb31U/eGDXMFzX7MpSLUghzPYAIEWPbofPInJ5nRAMvuQq39K7emCh2ZdU1+PMk38G8wu+998Aeq8JTy76BshWuLrdYeKhZ9DN3RfRGNKQMPFFXho4JCwSB2FbKP9r/VQvV7lhWyZrbF1Yc2/qk+XcB4vvakbqgdMYlpQjdMopeIMw30isI5fDO+gDIxzVwr6NBoOmfHx40Y6tnJaidtv75zbahw2/ehgvYJi8SQafyCEHyZscaVY/2a8KtM/3vzg/qhWxO3UqPMji9adEJt3Ec79aL6NZ/+sSRBTszX/ZaFu1zP9PfRnr72uQsfV4wt/kZK/8H21OF+tMyrzYbFikVwZs2QOxMtkNKxMJQ1GK/kWNuIMx+yYXS/LjrgEC89FUK0Zp+/jxSaITadYhDLg70iXcKy7DXCS3UyOT0NrgnunK4fU38KThuVNpC/9JrrTx9G17EyM3T4=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MW4PR15MB4410.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(36756003)(31686004)(53546011)(186003)(6916009)(38100700002)(6506007)(5660300002)(316002)(66946007)(83380400001)(8676002)(6666004)(8936002)(4326008)(66476007)(66556008)(2906002)(508600001)(86362001)(2616005)(31696002)(6486002)(6512007)(45980500001)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?NGt6bld4ejNUSkZPaHYwV2dxc0FlY2ZTQjA2U3dZRUZhMDZicDFFTHVUMmxk?=
 =?utf-8?B?VldMTUwrTVNCaTNoTmpWU0J1RGxDa1BQNXBlckh0blZxVS9kcFJIdi9tTWdO?=
 =?utf-8?B?VVlseEVzMk1NTEZpS1U3V1Z6bmdDWmZ6Y2JPemFKOFRoMjlJZzY3aTFwT09t?=
 =?utf-8?B?VjdnR2FBZ3BJQmtSK1JETGtYRWNzUW1KNWtXVW1DMTB2TGhaOVZ6R3F3dWli?=
 =?utf-8?B?Mm5BakxJeGZKVVkrWmNVL2wwRThzNm1KdkFNa0xpRnpIdlRPVnYycmFwQ1ZC?=
 =?utf-8?B?UDF5UElQTklDSXcreEo0V2dYZFhEQ2cxcjRZb09QTm5oUHNaK2JkckJGdnZJ?=
 =?utf-8?B?TkJQam1PNno0TllWVkw3TWVheDJxOVN3U1crZjZEa3dleDk2bHlkZ0xQdlZP?=
 =?utf-8?B?dzZvcjczOUVJRG84c2dEekZZeXlLaU1adEc2a2hxVk9wL01UekZoaGxET2JJ?=
 =?utf-8?B?N2wvSExERjE2YU9obGxPMnFweDlUT3owMkZSL3RvaE5Pc1R0ZTl1b0RwRHdT?=
 =?utf-8?B?WFROQnJhUWc4WEJId1k0TW51bmNCTWJSZ3N1MVNkTEFRWlRFSHEzRlRQWVND?=
 =?utf-8?B?MmEwb0dGMFBpbnJKMEVJT2RUZ1NBT2dpSjF1S21Bcm1mc3R4Y1RsdVY1cGpl?=
 =?utf-8?B?VDl5RVZBNXhoZzBDb05NVFZWdlBMSDd2d2VQcXRSV1BTT25WQXRwTDBaekpa?=
 =?utf-8?B?OTMwNDE0aEVsRlFCRXVMUS9YdVB4d0N4L2JTWjlGTjdJMy85ZlVpYXRtL3Zu?=
 =?utf-8?B?d01SaUlxL3cyMXcyUW5oLzlWK0MvbzQ2Vmdlbldoc0pNcjZhVmVSMlJ4UHRr?=
 =?utf-8?B?OUJpemZQM1YrM2I5bXlVK3hhd1Vsdk1acjFTeGVBY051MHkzK29lVHlGdno1?=
 =?utf-8?B?VS8wRThUSWdReFB3ZTEyU1pzMVBvRlNLQkJHNFVodXovenB4NHl3MEhsV2pp?=
 =?utf-8?B?SHZ5YVV1VFVndEFoVGhlamxWRlVNcTg3WDJNaE8xdmJiRC9YNlFCaW1hYWVO?=
 =?utf-8?B?K0swRmo1U0xnZVZTa2I3U01aZEtmTFd5T3l2STF1K3F3eDUxc2NqT3g2MjNI?=
 =?utf-8?B?MlE3c0lWNWtERjFTSWtNdGZNaDFIdmVXeEFPMzJwNlZ1cS9FalpLNklpME1B?=
 =?utf-8?B?MmZiYmtjVmpPQkZtMmcrbyt0V3R3Ulcyam41Y05rSUp6c2NEbXM2MGIzaXB3?=
 =?utf-8?B?aWNsN0hRWnkrWlZKMW9NdkQ5VGNxVXA2ZmE1MTRubWZGWVcvdTdzaW1Iekht?=
 =?utf-8?B?elhYQjU2NURvZUxYNDRMZ2xLRHhRc1ZFbVF6S3p0dW9OZ29ZNzVvQTdLK1dX?=
 =?utf-8?B?K2Q1dEpZVXlZdkFmLzJjb2IyMHNaTys2S2xydURQdXUybTdBRERJbk12dElU?=
 =?utf-8?B?TUdlWnFJZTNFVlV4eGlPcndOVjh1ZWs3cWhJT2VUT1o1cTZKTzdnT2NlOEZy?=
 =?utf-8?B?RFpUODY3aXZxOHFUdVVIcWErTEFrR1pWeXNLdnRKTWpQOHJvMGpxUzUxMVZ4?=
 =?utf-8?B?c1pRSm5oeWlvWFZQSEJZRlFYcWRJQTdqUVFYVjl4TFhWSHJLUVorZTEzRlRH?=
 =?utf-8?B?Mi9XSVcyOEV3dGhQWkg4cmJnYm9qRTNLVWpzZ1d2eFJxS1NJSWMzOFN0VVdR?=
 =?utf-8?B?bjNOY1FZcnNjZFdTNVlMb1A3Z2o0UUhGRGd6R2FmUytWYkNtZHEzb01KNnZJ?=
 =?utf-8?B?andsdmhIbkY0dzBtR3FZRkZmRW1mb3RXS21aL3ZNNjBRMDJYVnZDTTVvMFpr?=
 =?utf-8?B?ZUdBNlhxblh4bVZvSzl3d1lGaVZ2MWs3S3MzK0VnWUVvVVBLL1p6WGZZU2dL?=
 =?utf-8?B?Y0c1Ym1oamRDeTdjY2RiRzl5V2U5TnFZRkpaK1Ftc29SR0pLaEprTlN1RnJr?=
 =?utf-8?B?bmhBeHAvWnFNcS8zQ3FYUGdqUzk0aFVWcmY3ck5vU1lqanhJTUREOGI3N3R6?=
 =?utf-8?B?TFRNTzZPUWVUQjFSUC92UldMYXVaVytad3lBUC9iNXFpNlkrWC9FZjJqdG13?=
 =?utf-8?B?QURhR0lLb3cvQTVqQ0ZTNU5GM1ZNRTBySjhwM1NxK09lVUQwM1lYN0N3bmlz?=
 =?utf-8?B?b2xJbEhaZnhjdDhnQTRwa1M1OC9vZGJ5dmNSUUdDWHNXK1RZV202ZFBZZ1RZ?=
 =?utf-8?B?QVEzU1duSjFnRS81R0xlVFRldWFkU2lYREgxeXcwcVBld1p1NGlFTk5xM0dB?=
 =?utf-8?B?WFAzNDg1bDg4bDBLWGVCYjF2b1lXby9XQmFETUJtVUZqb3EzajlxOGU0b2py?=
 =?utf-8?B?ZkxCa21XWVg5WjBaZXVUZ2ZWQ1hZMlk1UVhJN25sMExwbUZRMktPR3RndDdw?=
 =?utf-8?B?YkYySW15WEVTMjVhVFQ0WlBFNEpPRzJucHFPRmlnSlhOVFNGSTRxSXVsd05h?=
 =?utf-8?Q?x4f0O9yQRrGmesm0=3D?=
X-OriginatorOrg: fb.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 38e72ab4-1134-4486-5f38-08da2c81b3a6
X-MS-Exchange-CrossTenant-AuthSource: MW4PR15MB4410.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 May 2022 21:21:20.4180
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 2Tmce5yHRR4kSJoGj+oNHwGjdjXkVahUAe8IuWYidiZM1bcKWqxfclWM1QIPPSS+
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN8PR15MB2787
X-Proofpoint-GUID: G9GLd4BYNy_DR5KSgAe-vJwE6aogPeu0
X-Proofpoint-ORIG-GUID: G9GLd4BYNy_DR5KSgAe-vJwE6aogPeu0
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.858,Hydra:6.0.486,FMLib:17.11.64.514
 definitions=2022-05-02_07,2022-05-02_03,2022-02-23_01
X-Spam-Status: No, score=-5.0 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_LOW,RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org



On 4/28/22 2:54 PM, Dave Chinner wrote:
> On Thu, Apr 28, 2022 at 12:58:59PM -0700, Stefan Roesch wrote:
>>
>>
>> On 4/26/22 3:56 PM, Dave Chinner wrote:
>>> On Tue, Apr 26, 2022 at 10:43:28AM -0700, Stefan Roesch wrote:
>>>> This adds the async buffered write support to XFS. For async buffered
>>>> write requests, the request will return -EAGAIN if the ilock cannot be
>>>> obtained immediately.
>>>>
>>>> Signed-off-by: Stefan Roesch <shr@fb.com>
>>>> ---
>>>>  fs/xfs/xfs_file.c | 10 ++++++----
>>>>  1 file changed, 6 insertions(+), 4 deletions(-)
>>>>
>>>> diff --git a/fs/xfs/xfs_file.c b/fs/xfs/xfs_file.c
>>>> index 6f9da1059e8b..49d54b939502 100644
>>>> --- a/fs/xfs/xfs_file.c
>>>> +++ b/fs/xfs/xfs_file.c
>>>> @@ -739,12 +739,14 @@ xfs_file_buffered_write(
>>>>  	bool			cleared_space = false;
>>>>  	int			iolock;
>>>>  
>>>> -	if (iocb->ki_flags & IOCB_NOWAIT)
>>>> -		return -EOPNOTSUPP;
>>>> -
>>>>  write_retry:
>>>>  	iolock = XFS_IOLOCK_EXCL;
>>>> -	xfs_ilock(ip, iolock);
>>>> +	if (iocb->ki_flags & IOCB_NOWAIT) {
>>>> +		if (!xfs_ilock_nowait(ip, iolock))
>>>> +			return -EAGAIN;
>>>> +	} else {
>>>> +		xfs_ilock(ip, iolock);
>>>> +	}
>>>
>>> xfs_ilock_iocb().
>>>
>>
>> The helper xfs_ilock_iocb cannot be used as it hardcoded to use iocb->ki_filp to
>> get a pointer to the xfs_inode.
> 
> And the problem with that is?
> 
> I mean, look at what xfs_file_buffered_write() does to get the
> xfs_inode 10 lines about that change:
> 
> xfs_file_buffered_write(
>         struct kiocb            *iocb,
>         struct iov_iter         *from)
> {
>         struct file             *file = iocb->ki_filp;
>         struct address_space    *mapping = file->f_mapping;
>         struct inode            *inode = mapping->host;
>         struct xfs_inode        *ip = XFS_I(inode);
> 
> In what cases does file_inode(iocb->ki_filp) point to a different
> inode than iocb->ki_filp->f_mapping->host? The dio write path assumes
> that file_inode(iocb->ki_filp) is correct, as do both the buffered
> and dio read paths.
> 
> What makes the buffered write path special in that
> file_inode(iocb->ki_filp) is not correctly set whilst
> iocb->ki_filp->f_mapping->host is?
> 

In the function xfs_file_buffered_write() the code calls the function 
xfs_ilock(). The xfs_inode pointer that is passed in is iocb->ki_filp->f_mapping->host.
The one used in xfs_ilock_iocb is ki_filp->f_inode.

After getting the lock, the code in xfs_file_buffered_write calls the
function xfs_buffered_write_iomap_begin(). In this function the code
calls xfs_ilock() for ki_filp->f_inode in exclusive mode.

If I replace the first xfs_ilock() call with xfs_ilock_iocb(), then it looks
like I get a deadlock.


Am I missing something?

I can:
- replace the pointer to iocb with pointer to xfs_inode in the function xfs_ilock_iocb()
  and also pass in the flags value as a parameter.
or
- create function xfs_ilock_inode(), which xfs_ilock_iocb() calls. The existing
  calls will not need to change, only the xfs_ilock in xfs_file_buffered_write()
  will use xfs_ilock_inode().


> Regardless, if this is a problem, then just pass the XFS inode to
> xfs_ilock_iocb() and this is a moot point.
> 
>> However here we need to use iocb->ki_filp->f_mapping->host.
>> I'll split off new helper for this in the next version of the patch.
> 
> We don't need a new helper here, either.
> 
> Cheers,
> 
> Dave.
