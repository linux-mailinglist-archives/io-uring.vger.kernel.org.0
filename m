Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0385B5396CA
	for <lists+io-uring@lfdr.de>; Tue, 31 May 2022 21:15:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346810AbiEaTPi (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 31 May 2022 15:15:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42276 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346790AbiEaTPg (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 31 May 2022 15:15:36 -0400
Received: from mx0a-00082601.pphosted.com (mx0a-00082601.pphosted.com [67.231.145.42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A05A96A054;
        Tue, 31 May 2022 12:15:35 -0700 (PDT)
Received: from pps.filterd (m0044010.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 24VFiEQ9021664;
        Tue, 31 May 2022 12:15:23 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=facebook;
 bh=eKS1KutjY8kp6PPnUgfihviIO/UwUsM8HoU8R7N7huI=;
 b=pTPAZE4ntRVmuGJerPfb006Xo6XSDLyZjL2k5cccjtCWlktap8Z/nRyYHEy1l/HQGdtp
 orKViAkcl8G7blhq4qFgipNgFg4L8PenZOucKsu7QBS81gi0a92/KO3o0tFyDlfwUClH
 dA4iK7n5rR+fNav+N1I58Il1dAl9FPf9j08= 
Received: from nam11-dm6-obe.outbound.protection.outlook.com (mail-dm6nam11lp2168.outbound.protection.outlook.com [104.47.57.168])
        by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 3gdbt64nw7-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 31 May 2022 12:15:23 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=bVYWStqUWVOKqZv9LXkinrP5GwNtbcukhW1kScJJ46N5Kp2TEc+b5Ox3wRT+J0/cU9XpdsLBPG9iV/GcLW+h8Jf/RTrvK9bQ46zjgxCyvs8nfy8r8nQ64sfi4ERXQs6wiV3wdhUh8FE/up5VMsZUXDCUx7Nqon2l6WUbcJhKLGOe+opZICnrFZiWTHBTH1P/WZHcKe7Pa48OTkcAdypFh1CQpT6VuNbwo7O7yxke9ZfYC+9zHfg39yoMjcubCDcr2oSewBFjdkrTGYkUO9NyKDlPsy8ZmF/y3Y9C6pN2Av15h2wWgPC7yYYL15nWTLKeUbr5BauE5JDmjovd96zUKQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=eKS1KutjY8kp6PPnUgfihviIO/UwUsM8HoU8R7N7huI=;
 b=dAyLffUEv73ND16VNgVG+73so2Rbztr3ZegjxrBtiAWKwiVidDwBpQHwssMCDddYZKApTHX2kYwfrAo7v3UGodYAQo4zmeO7DC1UqyE3tfFGpE0VDlO3wTEETYPvhsxUzN2om1hvadVSEJKejGAtzNHoTLAo7ZE5R6++fqpx+/wOP1UXu8ZM2eezQP1dDTvQ09F5Xeg1+CV0k4oZYt+TTJt1iDB9lfQ85fsiA9Gjpzg96LCBAOSE5XvAn7oQkVuAbcZYHp5RPwYwrJcNcSPX9SQmTRhGo7fG5YkYxGb3pmhoSgobnQH2S64/15KgGjLUFwvDcGbD47yAxlKMXVS4nQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
Received: from MWHPR15MB1791.namprd15.prod.outlook.com (2603:10b6:301:4e::20)
 by SN6PR1501MB2094.namprd15.prod.outlook.com (2603:10b6:805:11::28) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5293.19; Tue, 31 May
 2022 19:15:21 +0000
Received: from MWHPR15MB1791.namprd15.prod.outlook.com
 ([fe80::e17e:e90d:7675:24b8]) by MWHPR15MB1791.namprd15.prod.outlook.com
 ([fe80::e17e:e90d:7675:24b8%11]) with mapi id 15.20.5293.019; Tue, 31 May
 2022 19:15:21 +0000
Message-ID: <b0a521e2-6753-590b-ecb9-a8910d2ec678@fb.com>
Date:   Tue, 31 May 2022 12:15:19 -0700
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
From:   Stefan Roesch <shr@fb.com>
In-Reply-To: <YpW+DToVN0NjUpx4@infradead.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SJ0PR03CA0121.namprd03.prod.outlook.com
 (2603:10b6:a03:33c::6) To MWHPR15MB1791.namprd15.prod.outlook.com
 (2603:10b6:301:4e::20)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 9dbdfac2-a841-4568-4b08-08da4339e828
X-MS-TrafficTypeDiagnostic: SN6PR1501MB2094:EE_
X-Microsoft-Antispam-PRVS: <SN6PR1501MB2094782FA0C5294992C0E5E9D8DC9@SN6PR1501MB2094.namprd15.prod.outlook.com>
X-FB-Source: Internal
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Is2idyXhf0w70H9lVGD490gbLl4A8dyMxMYFoktsbrwsIi9MLniEPMhXuDF33i6o/jlRjVNS3URBgfVkulZ1M4yNTaobFOU1KxNQtEBGY6C2syX4KtRZeFXMpic4tcU0nSvoIkzmFe9U/s2bxx5Qhm960BGl6fpPHWHQ7bOloM2TVpMnZbLd286Bhxd5cOrS89S4PYqp4KvwWu7SI0WADuE5s2zN+psC1/aDFWFBL+j3F8wtyuOja1seFH2JZdAp8DEBG0RydFmi5ZXn7Bpw/aqVpJR8VN3gdc0gfVdA+WpWx1DDRxv6QL0IrGrv2EU9v/Y1aHTLVFHuqB8oEWAhR4SbpsFsGwFMwqQHraXJUpX4lFY5nq57R0bGLIFCNzjylsnLO5dfkaKpOwGMbUM2FQakfRnGqEtm7hqBgUmtaWjM2UilcL4Y3ZCXE+xxbVmYPozjD9O3T1OddLmdim1aDJZX/3o7ZYn9AUx9wwjEnAniJ/Ws9UDbPcmiWEQ1Wyib5UVX9Cr4iwWrbWB0RSLf6Sm+wH3lOL+P7K/NaZjIDxIVL+sI15qTr72QqkAxeB3YPfX/1ZMYNn3W+jC8LmrGgHEbb/Duf2f/0P1gqUh1pSm814fcixZuF61xZgfIqft9pKh+IJqYITcOpOAW9YlZXWKZpTJJhlGzg/EeX4UkY+wQtTugO8AC4V8Z9lmQuCVxBymVR5Qz0+SvRcSnB7SYeAjGI/dgTvSKxB7XfGuT0yyhui55qYVUmGWFyovysfuT
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR15MB1791.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(2616005)(186003)(38100700002)(8676002)(6916009)(36756003)(316002)(4326008)(66476007)(83380400001)(31686004)(8936002)(508600001)(66556008)(66946007)(31696002)(6506007)(86362001)(53546011)(6486002)(4744005)(5660300002)(6512007)(2906002)(43740500002)(45980500001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?WWdwblhkbDhicWZZZVlXSnNYUFE5Vy8wc1AwdGE0Y0RzcE00L0ZpUGptc2VE?=
 =?utf-8?B?YTVYUTRVR0g0TDdLMno3YUxnUTRDRkRpcFgxMmVLYy9ZTHN6TXNMVVVQVm82?=
 =?utf-8?B?bjFWMXpwQll1M001YnFHQm83ZkdxdldNS0M3ZHo2Yzk1MERBZHRISXhFMzlB?=
 =?utf-8?B?bmZXMFB6U0dQL2tGT1JzQXN1b3RvZGd3US9oZlo3VFdsc1VpdEM1WjdtSysv?=
 =?utf-8?B?eWR6Yk9lc3N5NFd4R1plRFVVNE1Nc1JwTVorYm02U3RTblM0WTN0VGtTdWJ5?=
 =?utf-8?B?bDRQbHg3UDBkaUFlMU4vdTF0RklYbldYZSt2ODdhY1I5VUh1YXNRampPMHdt?=
 =?utf-8?B?R0puRk1CaXlRQWhneExHVXl1R1pITDd1RDJuU09ObE1Eb3hXdnNDd1M0V2ln?=
 =?utf-8?B?VjQ1MzJkZ0Q1SzhUZkNMZ2JiSGdyL0dRaHVRMlEzYVdTdWhmVG9GRzdMVVdl?=
 =?utf-8?B?UnBncERmVWlpQytrdXZuaW1MUW5oandEaWtTeXNEQVZnQWZ6UFdTazZCZHJu?=
 =?utf-8?B?bWZXekJzb2RUZFRLTU52U0xENGpxRys4VDNLZ1I3UGZnVTNiQysxVHQ5RkFz?=
 =?utf-8?B?bzdzbnBjckFiQ1FIMUNzTUMyc1FjSHZnQnhGdXdlSDNRallGenlCclZFNTFj?=
 =?utf-8?B?TUlUa05zKzJQR09kM2RnYytDbFlBTER2TlVPVmd1R1ZMaGpYTDdDMFoxcGlH?=
 =?utf-8?B?TWJkbGQxRnhGbEl4WWlEejhhSzFLdkNVMGNFQUlINEF0V2NMbFZsVEdyRllw?=
 =?utf-8?B?bHA2YzZBbjVxM3J1VEJOQWorbitZNHNTWmZLUXhvSVRobm92cldqeWZ6RHJN?=
 =?utf-8?B?MHdNMVpoWjhqeDA1a0hLWWFReDNtVGdZeUw1UFhKbEpGSWNuRnVZYU15MWs4?=
 =?utf-8?B?R3RqSVU4L0RENkdtSWdtNjcra1dnWlZ2Sm9TSGxZOUNFaEdadFU4VU9ES0hx?=
 =?utf-8?B?RE04NElWSWhNZ1hMTzFFMkZKdDNESFJPd3AwUUhVSlRQZ29hb0dnd05JQnRp?=
 =?utf-8?B?WHV1RkRFdGx2Y1A2K1IvRmU0eFBWM0d0eGRCM0pyTU1DR3FGbEtNcm9pTHZE?=
 =?utf-8?B?dDZ3cGxMUVVFeS9oRnRkY1dhU0NQb2t5bzNndnRVZ1J4aHJ3WFUrRG14UUx2?=
 =?utf-8?B?eGpwczFON0xuYkU1Zk5XbHBGd1J3N2tJMXQyekw0T2FQME9MVmQzdTNMeHpr?=
 =?utf-8?B?by9ITndzN3UvdnZUZmZTb3VNSTRhemllajNVdWlnczJ6bm0yb2o1TEFzcEZF?=
 =?utf-8?B?VlNwbDdkLzhlRnhtLzhkK0FneVRNNDFHZ0s2WUFuNVRJUnlBNnN2TVBkeUhS?=
 =?utf-8?B?aG9xYWZYUGNoQzlGQUZjMVhpWDJJRm9mYXB1V1hpK1l6S1hpOVo4R2lQRVZC?=
 =?utf-8?B?QUtNTUVLZ3pPMFpzNVErS3hKQXFNb0VwZDZDaUZNS2NxWEFTMmUxMUpxNW5a?=
 =?utf-8?B?N3pVT1JxRDVsaGd2WnhVeGV6QjlwaTY0MDBHNkJBdnNDS1B2LzBPRVFXbHF5?=
 =?utf-8?B?aDVIdFBEamxGb2J6ZTRMTEs4K013RHBUelVsanlXRjFzVzRnYnN4Mjl5NHdK?=
 =?utf-8?B?VHJBcUZnL3dOemt4RzFtZDU2eStRRmR6bVl1VlpFZGFjVHhiK3ZWNjJSakx5?=
 =?utf-8?B?RkRleDN2V3BITnd1am80cDIxTVg4NzIwVjExaitJZFRMQTVOZCtxaGJsKyt3?=
 =?utf-8?B?bm0yell3dk5pU3FCZjRWa25EQ2JvNVJhc3J1dzkvem9uanpsZHE3bHE3b3hq?=
 =?utf-8?B?VHRmZDM2YmZtVzIyaXRPb3RwYmlORkZSVE9td1RCQjlxZCtUMzJWK0ZISkNp?=
 =?utf-8?B?aXlJc2xJVHVOUUd0NmtWaERheXluQk4zdzJoR0pqbkZvSjI4L0xPaTNqVlJE?=
 =?utf-8?B?LzdLQkNRaUxSMkVwMnhCcUlXU3BMTUtqK281K3JOdWtmM0pINTRPcjJUYldJ?=
 =?utf-8?B?NGdwazVCZ2RFRjJ1NmtqVlBhYUg5U3VLek80cytielZ5VW1WTGRLMGJFT2Rw?=
 =?utf-8?B?ai8xYzVwa3JuMmU4d0hVVHVXdGY1YmNBTDFsOHFUU3hWRHVBb3FmOHB6Tm5v?=
 =?utf-8?B?Uk91QlREdkhDd1lLSkRpKzhXRjdNWDZxRXZKdkhONmpiNjV1RnRacHpZdDda?=
 =?utf-8?B?ZjF1OEFHMkpiM3ZHM1BpcnNCVDlGWjBJSzlINFBGLytCODZFbi9QUlVlWDln?=
 =?utf-8?B?NzFyWEJoSUo2bUNnNVJCbWlIS0ZvbzQ1cUhtS3VLTk9JQVBQVjJSaWx1MEpa?=
 =?utf-8?B?T1p6V3ZaTFRrWDhldzkzNzVvRTNObm4rVWJQR0F6WWhBenpMY0lVM1dWdHlp?=
 =?utf-8?B?NnQzTmx5WDcvbDVRdWpkVUdabFM2RFNsdng1SzArZFk1YmZ6OTZna1dsd0Jh?=
 =?utf-8?Q?SbXER1oYbD/xG1ts=3D?=
X-OriginatorOrg: fb.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9dbdfac2-a841-4568-4b08-08da4339e828
X-MS-Exchange-CrossTenant-AuthSource: MWHPR15MB1791.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 31 May 2022 19:15:21.5060
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: c+V9Q3UKQKkkSr3UkGYOWygFnG4USbcI8xK0eArpi4PF9chxSLiVzJRR8AxEbB66
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN6PR1501MB2094
X-Proofpoint-ORIG-GUID: jdYUe_e9-nkkqejK6tRfR1x61ez-sQvY
X-Proofpoint-GUID: jdYUe_e9-nkkqejK6tRfR1x61ez-sQvY
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



On 5/31/22 12:04 AM, Christoph Hellwig wrote:
> On Thu, May 26, 2022 at 10:38:38AM -0700, Stefan Roesch wrote:
>> This changes the function signature of the function xfs_ilock_iocb():
>> - the parameter iocb is replaced with ip, passing in an xfs_inode
>> - the parameter iocb_flags is added to be able to pass in the iocb flags
>>
>> This allows to call the function from xfs_file_buffered_writes.
> 
> xfs_file_buffered_write?  But even that already has the iocb, so I'm
> not sure why we need that change to start with.

Yes xfs_file_buffered_write().

The problem is that xfs_iolock_iocb uses: iocb->ki_filp->f_inode,
                but xfs_file_buffered_write: iocb->ki_ki_filp->f_mapping->host

This requires to pass in the xfs_inode *.
