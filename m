Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0D04C5345EA
	for <lists+io-uring@lfdr.de>; Wed, 25 May 2022 23:41:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245704AbiEYVlE (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 25 May 2022 17:41:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57564 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235808AbiEYVlD (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 25 May 2022 17:41:03 -0400
Received: from mx0a-00082601.pphosted.com (mx0b-00082601.pphosted.com [67.231.153.30])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 462E8AFAFD;
        Wed, 25 May 2022 14:41:02 -0700 (PDT)
Received: from pps.filterd (m0001303.ppops.net [127.0.0.1])
        by m0001303.ppops.net (8.17.1.5/8.17.1.5) with ESMTP id 24PGtaGi012100;
        Wed, 25 May 2022 14:40:56 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=facebook;
 bh=VVt5U8VR9zZv/qYXF8mOJWFcRpCA8JzflLi116lix3E=;
 b=FUgh8U96WoFd5ggSQJm9InK5M3NCrKZ2w9FERZ1lywcSUvAKOazJKStLBeGUEBefjbWU
 4SogBJpfKFT5FTxbzRbfISaMcrpiwz+fDHdu4iBx64orWk4pP7PDxGkK8mxKG+HujnIY
 yoeL4+8tHAuwKUcX5rtL+42iyIYiCVHQYSQ= 
Received: from nam11-dm6-obe.outbound.protection.outlook.com (mail-dm6nam11lp2169.outbound.protection.outlook.com [104.47.57.169])
        by m0001303.ppops.net (PPS) with ESMTPS id 3g9qtua6p0-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 25 May 2022 14:40:56 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=m8mmQbc+PilDYrhuaNRK+EVWptCAhrzm8n2kMGYRCnyGRXnEab/6R3iQIwVihJQsHfkHQs4RD0HTcMZf2b/eXewBJ+bvI2Kq5hhI7eApBAEiTt1JzUynXxOT2YFACNtlNu6mWKTWQk0lpnA5T4nsB6yUhP9K6w+3NEDNroLOd85w1Ol86jNr85fuPiNH0iEByHiOefRW0/hUeEpugc1Td1dYdCAnPQYPdtuvZJ9if2DQcLwFGeHB7ncVcyNIQtvuy5lDEEcsDiSBLzvmkhqGdGjxBbGSbT1aELL3U64BwC7azjHqXcrwPSpODn+Y9XSooO/ORVmzzaD0SQp7+xsUeg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=VVt5U8VR9zZv/qYXF8mOJWFcRpCA8JzflLi116lix3E=;
 b=goTEYVoiUjCOnSTULFTJCngan16QF8MMuENx9h2QdsLNZ8g1eyRfXctKXstjEX+8X6IReJhr48pjpiRzamyxhPFw3uhBybnuAXVc6U+RVW3QjjXjkwv32GjS6GEEfxPJhudF+B4oORE/O8pxydSjFqPocqJES3pkJMcmFU7VsgNj5nTW75NZKZbQkFQAyQUF2ld9wAhxuygvwDM2cKZKpzwoEKfLYS2zF/YV3IQOPd2MP+dOABI4QNR3eImDopDE5M0+74mKqq0TO/cpuuLqzTyI/QkDfv+dpFUVTxO+YQgb/xYQOG4FoABlRVwpVvcu5LiS/HTgX0sT67NgprxzMQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
Received: from MWHPR15MB1791.namprd15.prod.outlook.com (2603:10b6:301:4e::20)
 by BN7PR15MB2260.namprd15.prod.outlook.com (2603:10b6:406:8a::27) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5293.13; Wed, 25 May
 2022 21:40:53 +0000
Received: from MWHPR15MB1791.namprd15.prod.outlook.com
 ([fe80::e17e:e90d:7675:24b8]) by MWHPR15MB1791.namprd15.prod.outlook.com
 ([fe80::e17e:e90d:7675:24b8%11]) with mapi id 15.20.5293.013; Wed, 25 May
 2022 21:40:53 +0000
Message-ID: <4c96fdba-b9e2-5595-872e-0e782ec76e0a@fb.com>
Date:   Wed, 25 May 2022 14:40:51 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.9.1
Subject: Re: [RFC PATCH v4 15/17] xfs: Add iomap async buffered write support
Content-Language: en-US
To:     Christoph Hellwig <hch@infradead.org>
Cc:     io-uring@vger.kernel.org, kernel-team@fb.com, linux-mm@kvack.org,
        linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        david@fromorbit.com, jack@suse.cz
References: <20220520183646.2002023-1-shr@fb.com>
 <20220520183646.2002023-16-shr@fb.com> <YonnWjcb2opa/f0X@infradead.org>
From:   Stefan Roesch <shr@fb.com>
In-Reply-To: <YonnWjcb2opa/f0X@infradead.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: BYAPR07CA0074.namprd07.prod.outlook.com
 (2603:10b6:a03:12b::15) To MWHPR15MB1791.namprd15.prod.outlook.com
 (2603:10b6:301:4e::20)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 7ee99758-7375-433d-eca1-08da3e973e57
X-MS-TrafficTypeDiagnostic: BN7PR15MB2260:EE_
X-Microsoft-Antispam-PRVS: <BN7PR15MB22600BD29556306369F983E3D8D69@BN7PR15MB2260.namprd15.prod.outlook.com>
X-FB-Source: Internal
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: LAVWzO5hZVmJ1nIBSmgVjA5mlIk7uN772VLf70ZKkPfJQ9qVmBTLObaLO2DY+Qi5rFqVcX53Fr3lMjo637iNoj4Xf9mbWBT9WTGheimho0GE4DfF65c7KEareEUExeroQeBwi9J1UI6VOJZwfZDNo2tiZ5YzUxOb4l6vPlKs8xao6f1ey1axwDowBJg4TFe45Rw85nfY6ZRFGtZseeK+u9LXWXOEtTaX7/ImUinTNJw6kV76adihObAcAskop6xPtl/P8dcqeTOLlyy0GRXdlU3luBVQ/dv2h8WPsSHQyaGbvxTaeoyNuriMO/Uyx9HEoJe3A++HQLuYmQu6ydNl80LREmGjaG/mnedDpffKAheO5QJQnEaRj7TvrIyDtPsz9EfGhwQjSvzEou3CuMRm8Rj/RwbaTROUeUYxB2Ildh31TRvK60tMMszjo8YkmpZvuzoAsh0U0a81ry8itSKQ4JpYFQUVDbCm6F8VaTTsH+bhl3LxwrsysWyBTbB3zw367V1/r5GaiQh21XQmK40y9mUzazCSGHwExDv96ylR1wXFF0FeAjYUzLn2Zra7/jgpkranirWCM6TzDm0+ryeGGVY08opc4ePhc3BE6LKI2+8uMzQ7VeApGrEEniHxYTBWKhknYnBtSwlSP4nlkuo+FW/WNxP/+mTQH0pY244BvVNLjXzSO7a+t7Mbq04Ye4ZyIRmK9wQN5pemcz6rQxzd9J+Kq+hnvkFv0ziDrCLxUdX6H7j5I9BbhkBYHe7wQ7vw
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR15MB1791.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(6506007)(53546011)(31696002)(2906002)(86362001)(6512007)(6486002)(508600001)(8936002)(83380400001)(4744005)(31686004)(38100700002)(6916009)(316002)(2616005)(186003)(36756003)(4326008)(8676002)(66556008)(66476007)(66946007)(5660300002)(43740500002)(45980500001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?cVVUTzVWbkFzSk5mQUtDdUVsNlV4OTFaWHVHTnNtVDNpLzhhZlN1UlhjeUQ3?=
 =?utf-8?B?VFlLM0twSFRRLzRiMm9sODdIU2wvU254QU1VNW5xeWdTaHpZTmo2bEFGanJL?=
 =?utf-8?B?TGxTZjliNW8rZHVReXJDY0FmOXcxZndaZnR2RzRBSzdCSHZpMFl2QXBDZnZB?=
 =?utf-8?B?S01rMnRRMC9mc1BhMTlNbFFJL3JTeExqbTE4Vk5odjhJR0RLbFpXYlFpeUFF?=
 =?utf-8?B?MHRGdDN1QkJpcDRMSjVTTldzckYrOUsrTXBiNTVQTkU2cWtKMk5EZ3c2K3BS?=
 =?utf-8?B?R05yMWwvSncvQ09NdG5iQmlZaEJ0b3N0Ri9TbW1yMVZ4NWhYK1VCaEgyanl5?=
 =?utf-8?B?ZEhrWE1hSXJsTXNZUWhmNTlHQkUreHBBTXlUS2sxMEp2VkRYcWFYQ3hOOGlr?=
 =?utf-8?B?RlJLUDdNZWZIeFhMeEt1Sml0L0VSRTBmSVdxVWJmc3BlSmVEYUVDWUMyUHVW?=
 =?utf-8?B?Q3JMM0hFcWpySGZkNGw2NGlubll1WEI5K0Zra1AxS1ZtTzIwYVRUa2pYcnRZ?=
 =?utf-8?B?d3AySkc0bWZtbHpKaUxodXFsY0w3LzhMMEZSdk1XWVpjY3JIK3VadXBsYWlt?=
 =?utf-8?B?aTJYaEZsYUFhMVhOT3Z3V2FtQWVheEtocmtxNElTaXUrSjlaeUxFaFU2Ylk2?=
 =?utf-8?B?WDFrVmFZVEVwYkhMWTJXaEFCNVBpYnd5N0ZyQTA4Q0ttUUV4M2ZkRFh6S3ZM?=
 =?utf-8?B?eEZQWWoxS01LdmFGb0ZlUS9nSEFidnJRbWx4ZFdJZkZ2bHgvVzR3eTVsSGhq?=
 =?utf-8?B?bW1lVEFzZTZTTTZTblBTWVFQWFhPMVdNREN1WUUzaHkxRXhGdGRTTlFDdnI5?=
 =?utf-8?B?VUkwaEdCSHhQYTB0U0xSZWllVnJQU3NrYk1GOEpsRzdHZjNEZkUwVU5iMjk0?=
 =?utf-8?B?c3I2d29XZVlBeFNFSUdrZmNBSHpZSW82VTZkOHdRbUpQYnROcTBONFo4OXVW?=
 =?utf-8?B?bVM2NEg3empJRzJDOTIzMWhmR0JpUjBXdmRqamhBcW9rMFp2OWd5MVQzZG9F?=
 =?utf-8?B?T0xBV2twcURIWlZTUHhwcEI5RmNGcW83eXNrbWFqVWRYWGtOck5IVWdQZkJ4?=
 =?utf-8?B?bm1lWjloRThSMlJFazB0OWxsRE5TSXNTMTJ4SDBUNW5ZTTRzZjBCaGxFdytT?=
 =?utf-8?B?TkNzR0c3RGJleGowbmFmK0xZYTMvZEpGWUJnR1g3bW42ZXhQK1REQlpQWnVE?=
 =?utf-8?B?OTVDMHFVMzVNd01yQ2Vhcm1Xdjlxc3UvWDBJQlFmTDZ5Vi9IbnZHVldaZk9I?=
 =?utf-8?B?WTREcGJ5Q1oxLzdyTWZmU3pwZ3g0TkpHOXVXYjMvZmRqeU43dnZhYXI5S3U3?=
 =?utf-8?B?L3VpK1dEL25SbGV5eVh1bUQwOW9kNFVORWMyc0FHdURydGdUTnFBejYwS0Yw?=
 =?utf-8?B?YjlJeGJHSkh6elJYTGNuMGZKTWw3Tm5VbWlHajc4dWxnZ3h0K0RmWnl5bXdC?=
 =?utf-8?B?YmR6RXpmblFWR1kxdFRrQzFtSWo3S2VhS2xDZ1lTY1V1S0NueERCQXZXK1ho?=
 =?utf-8?B?ZWMrbTEzL1FsbkpoUzdPTEVRdVl0UytZbFpGY01HQlVZT2V5ZGpLc3hPeVRT?=
 =?utf-8?B?V0xsbEhJVEM1aUZLWmtsRnhmdXFiOUdLMTlhb1Y1YWs1MDRFN09xV2JyZEYw?=
 =?utf-8?B?Z3BYQXU3SEhlempZaU1yS2tFZm42ZFV4b2tLV2tDUHZNVGUxU0h5T29DTDk3?=
 =?utf-8?B?NlZaZEZvNVp1N0tBempLVXFXWE12SGt1VkRXdnJMWEdQbDBRTW5pZ1JCMHEz?=
 =?utf-8?B?a21PMHRtcGJPNlNwTVVzQnQ1WFFBci9nc3hkZlBqc2pXL2JCbXJlOGJnY0FR?=
 =?utf-8?B?SExjbmhlMk9nYmgvTzl4MHExbjAwdlNvS1lGNDdlMVZrZ2ltRS9mT3l4aVp0?=
 =?utf-8?B?SmkyUllqZTR3LzJWaUZOOG1WQVltejY1d0lSMzV6Q0lYQlRrNGlFc0hnc2FX?=
 =?utf-8?B?cHFLNVd2eGNnTnBkV1Z6eFZkVndQZUVGOEkwUGhwTlBzZWVVcE5pN0pBTlE2?=
 =?utf-8?B?WjBZSENPWWN2YUk0elA2dG55OG5GaFVmdGNXdUlGdmJtMWtvVitsMmRZVk9j?=
 =?utf-8?B?SlZFQXA2TDBaU0YveTdmd0NBS01aSmlEWW1MaVAxVnhTcEJCTkgxMHlyVzFQ?=
 =?utf-8?B?YlVsY0NmWFNpRkFOQyt2NzhWbGl2OGtuck9sbHFzN05zTUhWL0p5SWNIaE9E?=
 =?utf-8?B?bHhoazNWYi9DSmExdTNvcC9mQ3FIOVdpeGc5Ym13U1hNak5mdkVpYmhEOHVG?=
 =?utf-8?B?OTRvR0VqVlpwWkJaSTRhRkNwVlF0YmJLcEwyOFd6UWF6dEw1SDh4TFhBRXhO?=
 =?utf-8?B?VVp2SUE1bWUyREJRMTZxaDR3eXpxdGx0TFEyaHMwU1dON01nK245SGljRWdH?=
 =?utf-8?Q?olmoDz2dgdGBu3Pw=3D?=
X-OriginatorOrg: fb.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7ee99758-7375-433d-eca1-08da3e973e57
X-MS-Exchange-CrossTenant-AuthSource: MWHPR15MB1791.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 May 2022 21:40:53.4842
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: mJo18fMVD/9ULrcQtkDFBAqrPsfOtq83imyQi7OumsvcXFY4ZwnhLochbN+1AATp
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN7PR15MB2260
X-Proofpoint-GUID: TQ6TskMppsGeOxgpwKRN-Fq10ziA0ueQ
X-Proofpoint-ORIG-GUID: TQ6TskMppsGeOxgpwKRN-Fq10ziA0ueQ
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



On 5/22/22 12:33 AM, Christoph Hellwig wrote:
> On Fri, May 20, 2022 at 11:36:44AM -0700, Stefan Roesch wrote:
>> This adds the async buffered write support to the iomap layer of XFS. If
>> a lock cannot be acquired or additional reads need to be performed, the
>> request will return -EAGAIN in case this is an async buffered write
>> request.
>>
>> This patch changes the helper function xfs_ilock_for_iomap such that the
>> lock mode needs to be passed in.
> 
> So from a pure commit structure POV, I'd make the changes to
> xfs_ilock_for_iomap one separate and clearly document patch, and then
> merge all the rest of the XFS enablement into a single other patch.

Done.
