Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D3257784851
	for <lists+io-uring@lfdr.de>; Tue, 22 Aug 2023 19:20:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229469AbjHVRUA (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 22 Aug 2023 13:20:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58348 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229464AbjHVRT7 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 22 Aug 2023 13:19:59 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 629A7A24F
        for <io-uring@vger.kernel.org>; Tue, 22 Aug 2023 10:19:58 -0700 (PDT)
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 37MFnkM8019387;
        Tue, 22 Aug 2023 17:19:43 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : content-type : in-reply-to :
 mime-version; s=corp-2023-03-30;
 bh=Va0pWvwDAConJQk2LHE/4DfFO8Rgrdm3bRy7XIz/wTg=;
 b=xa/r70rUA2wOitXmjjn9HG2JEYtQ45Jv6nkdAJCMxHmIWhnfhizoFF1QzjLpbnT6YDji
 ktCPd7dAQTV1bWrQcXMZ2JL8Az1Cusf1/knaqI8S9JNekjz4xF6unXnt7vIij19Ay3gu
 cp8uCMpwToX/SngsuGTj2lmAvLZi8eLnYylgrxaK8AJ0377qPzDS7xZGUAZI1IWHohes
 S6QZtmHqlJGT2jU4q35oY12BWpUJVASDqz1OYax4ZFD9rL2R8kIPG3VYZkdcfsy0RsrG
 bG62zH8D7zm/YBk7kZMFbKACI1oarLyxgWDuzRykT5Ib1fS3b/BiEWafDUlPTkrR061m dA== 
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3sjmb1wwwp-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 22 Aug 2023 17:19:43 +0000
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 37MGLwu5031694;
        Tue, 22 Aug 2023 17:19:42 GMT
Received: from nam10-dm6-obe.outbound.protection.outlook.com (mail-dm6nam10lp2103.outbound.protection.outlook.com [104.47.58.103])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3sjm65e3w9-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 22 Aug 2023 17:19:42 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ORypw1IEx9D2KNX3HTQ4trzzszqmYo2Om8C4ipNQzINKHxrTXb96zP0qAfzG+fKqjhQn76W/82rwyMfu14mkBOsnTPpfYTCJ4uTXsToefjG9DcIMnCqsy+x1nBZtN3iVHGRQbvQvMAyovGlxbkBVrg1RZcZL9EB4QRWkHYatnJZ62nvsQA7r3jElauuJLIX2R7AbitplCrrzloqUjixuAhd1jLTNAE8Ay+K01h0235SxOgsaBqY03rHVJLjUqI/60/xvMpADG/+8aU+YsmnnBxVmTkiteL+BLVWt2Dgl5T0cPjmLR2RiPDe58x+vVNb4GDKkxGsGklA7TTz2UXJPhQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Va0pWvwDAConJQk2LHE/4DfFO8Rgrdm3bRy7XIz/wTg=;
 b=Eoplsm6vJcH/qHQYU7PFbs8ISgT8PupD/ci7iHtk1STN9N2Y1HPAeEyz0W7Hp0eBCEdPTS+LRXBe3p6DFt+vCXYMQo8QmRsF2VYcwT/Sux99w4M7CL4JEXCNj5MQNS2mNBHRf2hiS1BHWcFKzlxpfT9mYL4breNEv7zc03XUpxmv8X9PIyYWODqozXwyAy2ju1f30eLLpviXLGdxaVFQs5ufpE75G8t/c59Fk9is5MlDI0kiFf1tz0BvmvIibe4pmwXaiTDJWUFCrLN0Hf+JePbGDeK1qI+u7Y5riEqfjE8dSub6ws90ZegDvZYUYd/AYVWwcPHdM9mrKBDVmWcm3w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Va0pWvwDAConJQk2LHE/4DfFO8Rgrdm3bRy7XIz/wTg=;
 b=ODCjZ1KHN0OK7stNpjP6vEgaqdim6oU03ANrgKZM+3EIOfJ3NbJJLRtYeyxmaLlEJ1HLgdUd/AX/p7SJLkSVsr5ZFxasB/pRx+YH8YoegoX2cpzlfSGR1qn8eUU+WuxhhBPJLL9rDptEcFImkj4WxlqzEe327JvR6bEhbmqzaOI=
Received: from BY5PR10MB4196.namprd10.prod.outlook.com (2603:10b6:a03:20d::23)
 by SN4PR10MB5544.namprd10.prod.outlook.com (2603:10b6:806:1eb::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6699.24; Tue, 22 Aug
 2023 17:19:38 +0000
Received: from BY5PR10MB4196.namprd10.prod.outlook.com
 ([fe80::92ea:33e7:fb66:c937]) by BY5PR10MB4196.namprd10.prod.outlook.com
 ([fe80::92ea:33e7:fb66:c937%7]) with mapi id 15.20.6699.025; Tue, 22 Aug 2023
 17:19:36 +0000
Date:   Tue, 22 Aug 2023 10:19:33 -0700
From:   Mike Kravetz <mike.kravetz@oracle.com>
To:     Matthew Wilcox <willy@infradead.org>
Cc:     Andrew Morton <akpm@linux-foundation.org>,
        Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org,
        linux-mm@kvack.org
Subject: Re: [PATCH v2 07/13] mm: Remove HUGETLB_PAGE_DTOR
Message-ID: <20230822171933.GA4509@monkey>
References: <20230816151201.3655946-1-willy@infradead.org>
 <20230816151201.3655946-8-willy@infradead.org>
 <20230822031300.GA82632@monkey>
 <ZOQsUaUA2JnY22Nw@casper.infradead.org>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZOQsUaUA2JnY22Nw@casper.infradead.org>
X-ClientProxiedBy: MW4PR03CA0283.namprd03.prod.outlook.com
 (2603:10b6:303:b5::18) To BY5PR10MB4196.namprd10.prod.outlook.com
 (2603:10b6:a03:20d::23)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BY5PR10MB4196:EE_|SN4PR10MB5544:EE_
X-MS-Office365-Filtering-Correlation-Id: 84bcc444-9b5f-4b9a-e996-08dba333f552
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: LOlm+eNdC4fHswzau8uKb6rpkn9lTxLjGCP5xVGZQsO/SmNjTVUP6r7BOMIsSN1FBPK/EfrLXqUVaPaQ+isHBfjGQTVRZKnVN4bzIl/utqQvDYqCfjN1XGrJI7494LftNWudSQMfmz7sSlc9932w2laXj+aXXxnT9Sv5ymmUHM/q47chOFBd6Uj5InZQr0PLR/OzlLtyWlDJvMqWslD1J9dqnQRUSY6aRwUmpXlNSMm7MaE0HiE+z1aH3aLLALA3LVEO+WQsgrLd9o9q/+AekfIBF5YkeIzgy4JYNXq7NlWqggkhomV50Qjv1t9j5Rc02TU3WgkB+/Rzqfz7M0GzEw7rQJmPbPYyB9ADDCTnk6c1VleGlwlGa7YuITok92+3xQDnrSaCrUOGSYzzyuqv36sYX+nRnordgJQfraHbAVaKAdrNESoQK5whst32uJp0eH5azcm87T3XfQzkq9cLlnWan8Kp7xpN14bT8wed7R39k8cb5zXW3fEWif++63T2WmV5hiGudrO23bWSt2HwD6d8ji+Ig4+CJKw/2o4CXBY6crkr33t6legiuhpdfnmA
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR10MB4196.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(7916004)(136003)(376002)(396003)(366004)(39860400002)(346002)(186009)(1800799009)(451199024)(66556008)(54906003)(6916009)(66946007)(9686003)(66476007)(316002)(6512007)(8936002)(8676002)(4326008)(1076003)(33716001)(41300700001)(478600001)(6666004)(6506007)(6486002)(38100700002)(53546011)(2906002)(83380400001)(86362001)(44832011)(5660300002)(26005)(33656002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?860qjFcDRCNyF/DUh2uZcEZ3xmQGSGP8C9RT5wyvNjQF5ZKiKFsm10ntTP4O?=
 =?us-ascii?Q?+2Y8vaPOXXhyOYrVQzglkkWYGlkyKAp5eS0slkU1eQjyCFLdbTa6MUitm0mA?=
 =?us-ascii?Q?q+T3MG5lAlCz3wMlaC7c0dayLcZzDq6psRoDK4NN1FHh1gkbZaD4NH9k6FwF?=
 =?us-ascii?Q?hD2gErWbxc5ASYIwcLdnur/qn7u5v6y6lF0wIqFYiALPEGBR2BpZJAeC4wrF?=
 =?us-ascii?Q?h77oJUN14Vqtt/3on3SCzGOhqyIUySrLKyEQaX6E2bS37V/67l3ajBVZd/Yp?=
 =?us-ascii?Q?6QXiHQbYaE/7ocA6DY/CfQJL5IsvrMu1tZhRmVTSHBTxyQ2n+kZ15lh4ey7S?=
 =?us-ascii?Q?llPvKfEVgacTrSGFNkM/XT14x/4TE+O7m6uGFdz+WyG2dY7nFw9eHzHc50eR?=
 =?us-ascii?Q?mOORwxVr5WYeQSLHOCdpxI759UKt7bGTsmbXX+UPvusODC61LmSfEEILg3bi?=
 =?us-ascii?Q?kbLDhkxmjBoVTq872rSNQtZCXcRmPf1gttrNZCQmpYnQtLqn8J3US4qWcDoz?=
 =?us-ascii?Q?V/ApvO5dtuGTG2LYx810k0Hy7FGDDYJ3BjNW6xOGmGf7InPUOTHEexQoJNvw?=
 =?us-ascii?Q?WP53zT9xuxx9dm4de1xsZae7ssqg9lPL/8NS0OiXicm9qFAbI9UuKqAl0npw?=
 =?us-ascii?Q?v5VcnQpY2TUQVKMavV9XsswyD4tp866wwDqVf9g+W2pxwMpzHi2ttB2ny9r7?=
 =?us-ascii?Q?CiRjk74tgZbwCZzVo17dx1l+gvY8I4fxDw26Jfe9EtWdTdj6kXUOB39R87pM?=
 =?us-ascii?Q?0A9Fpx7Xvt0Nb/92WOvnLf3mbIugTKEnABp3DuafDrKZsFrEWg1Yp7rRL283?=
 =?us-ascii?Q?69avnr20IhKNwYE6MgUWIRJvx6vUW5RHM9Z4sdZuR2QN9YyGl6Pzqbcv8oDI?=
 =?us-ascii?Q?UWvIFST01RvTXuCv3yKjDHIt5F2jpVswT9Yj7Kyg4OCV4p1BzU2b1HMnEB9p?=
 =?us-ascii?Q?vJJIhKgeOne5a/5wEt7r3u30zE3/C+veDX8EjM7ODcdDVwvfIdnNEToBNlrL?=
 =?us-ascii?Q?q9YdQgxlrNpn2od7Zzy1zhvXZrtUhbudKqc5wL0G+WbIWeUhKgmRsxF7Mc4Q?=
 =?us-ascii?Q?+N4mswJao+OCKGETQVZPNHoIkwlL/PrqlDWATcRScU63n6zm7t++LKmUk7XE?=
 =?us-ascii?Q?MbuHWlTl+x029/s7uwxz1BPpZulru/iAbxnRjOwA7Y+d2YiBWwjiEHi+XjEn?=
 =?us-ascii?Q?Htv9p28mefgO0ZNLD5L2KWnbNYtl8ueAJ6htxWZeKwZj7ZSewgWsgBnZJL5X?=
 =?us-ascii?Q?U/MW7XVP2aBowByUe0YC5eTN92SSYHPGpM06O3ZtR1g/krWxmV71pmn1ihs5?=
 =?us-ascii?Q?XtJTpjc4iSI/XUxocZzixSowsk4bx4NyvXPL1z7GZXpZxuxNEh5NbzrDz34P?=
 =?us-ascii?Q?uAjPyzu/tmV3mDDCHD7yD+XCFqa+fdCsmnxhOfgcLci21b7J+qramzq0WExV?=
 =?us-ascii?Q?DX5S4v3M63GYoeWytB+0foj3BTFS2SiHz/6rHGRnirwwEpt93yiLu2uAfNbf?=
 =?us-ascii?Q?zJIAGIokSWli0C76AeVvun8NInmoeVpmDojvsZxA1NRXtS2KLzG9MDinGQ9M?=
 =?us-ascii?Q?//681zRR3ZAGoXvB0EC5A0Zkom7Ra85vVM5JlMKF?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: EobqNMB5B+NpeBlAycZf5a04or6OWCpsd4EKZMWi1jgwssJehkrxzrPa68YuH7MPq3TkckqQn117+t8gKX1OpNDBvWDiesJxXv9+axZ4cZWMqRWhaedzEqqoUSqvYWad5KMxLWDigzbBAJ+BaR7cdjSJhLWK5hbUk9BfFdTK+keaIJMFdgML6LC8mxIWV10K/YHMD/1wZDBY+CSQCrflF57KAZ6XMHjopt7kwp/qn/PJVgwrmbILyKjoutaedbxt264hIlijciaGapxv8PZE1lHwb5cLaoxcOjSi7bCEDM26NnYSqW8sxcVkR5JkDFn84M3zddahHwdU1I/QFTSEExhKJeWRRbeSVdu6p3/zNN2X8+sU4uAfE5IHFm5scfNKLg360p4tOAeFhLxN0P8Li5/Jj7OCmAZ4jw695kFgBcMUyn+aCcxLazqOAyuQSEa5m7eO1Gc5kJs6GxaJoLKLZrji/SVH5vY6prK8mb21lPeJvOBFnmx2qE+Wr3H20s12JN375OlZKC3xT+APV0X0GHLgipXukRHJn4KexsH6/MrlA+V9IgHh0ctSRuXlpTDNmuv6hud/2BzYiCfZ98tWEgBh6XTdy9xRCXqrFcupeV5GkU8dEtFY9Ltw8rX3nO8vSZPAIQp3cajRxyFO2EelXXkcYbTk0/5tVpd90kO+r0EDRKZf/X0n2z8GCHRVMsY4iLiqaXTaUta5Uj7RE3afnHOnCXnhDs06MK2lQzvw2sVQp5MtVXsbkgbzkYczRnGzK1Z9d3m71BxNWiNQNDIfkNXwgj5UPooWupr8CIMAOSq4UdFD/oAkHFgxRVuBAVMwZX4AdiJjGo+8gEskBS7iZ3vRZ8fM1rbp1ceJZas2ZJU2XyY1qpg5kz1ze8AHshko5PrfNPNpRojiYfHTo0yI+w==
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 84bcc444-9b5f-4b9a-e996-08dba333f552
X-MS-Exchange-CrossTenant-AuthSource: BY5PR10MB4196.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Aug 2023 17:19:36.1079
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: RoD/Z9wVxoqBnyVn/Gp121VxKBgA5Fo1r/JxB09uJOi/d4sil6ly12231ANmYxhImiDgupcobsOF/TYTBLc4qg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN4PR10MB5544
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.267,Aquarius:18.0.957,Hydra:6.0.601,FMLib:17.11.176.26
 definitions=2023-08-22_14,2023-08-22_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 bulkscore=0
 mlxlogscore=562 adultscore=0 spamscore=0 malwarescore=0 mlxscore=0
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2306200000 definitions=main-2308220137
X-Proofpoint-ORIG-GUID: qzdc6kOhMObBrkGDdKHdoFxufkLD7tcM
X-Proofpoint-GUID: qzdc6kOhMObBrkGDdKHdoFxufkLD7tcM
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_BLOCKED,
        RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 08/22/23 04:32, Matthew Wilcox wrote:
> On Mon, Aug 21, 2023 at 08:13:00PM -0700, Mike Kravetz wrote:
> > On 08/16/23 16:11, Matthew Wilcox (Oracle) wrote:
> > > We can use a bit in page[1].flags to indicate that this folio belongs
> > > to hugetlb instead of using a value in page[1].dtors.  That lets
> > > folio_test_hugetlb() become an inline function like it should be.
> > > We can also get rid of NULL_COMPOUND_DTOR.
> > 
> > Not 100% sure yet, but I suspect this patch/series causes the following
> > BUG in today's linux-next.  I can do a deeper dive tomorrow.
> > 
> > # echo 1 > /sys/kernel/mm/hugepages/hugepages-2048kB/nr_hugepages
> > # echo 0 > /sys/kernel/mm/hugepages/hugepages-2048kB/nr_hugepages
> > 
> > [  352.631099] page:ffffea0007a30000 refcount:0 mapcount:0 mapping:0000000000000000 index:0x1 pfn:0x1e8c00
> > [  352.633674] head:ffffea0007a30000 order:8 entire_mapcount:0 nr_pages_mapped:0 pincount:0
> 
> order 8?  Well, that's exciting.  This is clearly x86, so it should be
> order 9.  Did we mistakenly clear bit 0 of tail->flags?
> 
> Oh.  Oh yes, we do.
> 
> __update_and_free_hugetlb_folio:
> 
>         for (i = 0; i < pages_per_huge_page(h); i++) {
>                 subpage = folio_page(folio, i);
>                 subpage->flags &= ~(1 << PG_locked | 1 << PG_error |
>                                 1 << PG_referenced | 1 << PG_dirty |
>                                 1 << PG_active | 1 << PG_private |
>                                 1 << PG_writeback);
>         }
> 
> locked		PF_NO_TAIL
> error		PF_NO_TAIL
> referenced	PF_HEAD
> dirty		PF_HEAD
> active		PF_HEAD
> private		PF_ANY
> writeback	PF_NO_TAIL
> 
> So it seems to me there's no way to set any of these bits other than
> PG_private.  And, well, you control PG_private in hugetlbfs.  Do you
> ever set it on tail pages?

Nope

> 
> I think you can remove this entire loop and be happy?

I believe you are correct.  Although, this is clearing flags in the head
page as well as tail pages.  So, I think we still need to clear referenced,
dirty and active as well as private on the head page.

Will take a look today.
-- 
Mike Kravetz
