Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 111BC77EC26
	for <lists+io-uring@lfdr.de>; Wed, 16 Aug 2023 23:47:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239393AbjHPVq3 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 16 Aug 2023 17:46:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54954 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346715AbjHPVqV (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 16 Aug 2023 17:46:21 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4F6672724
        for <io-uring@vger.kernel.org>; Wed, 16 Aug 2023 14:46:17 -0700 (PDT)
Received: from pps.filterd (m0333520.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 37GLDrn9029621;
        Wed, 16 Aug 2023 21:46:02 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2023-03-30;
 bh=FeX1hT9XKydbUZTjLTnr3kHisRE34k8hkHmmFMBSxpA=;
 b=bK39Kj07OiFHC1eniq1YLjGYbZbZrUdAqFTY+rnC00WDzdcvmEPEGPxOH6ElnqkdiFnO
 7Q6Q0EgVFBc2YIgONbpg2JV35UCDkiCMLtSkjbBw/qRnZ/mPqH0Az3vehZ24JOC9uIGf
 jHoGAakQM120NvjFW1iA7EGg+R2AajkSOqb1q5kLrqMb0SO7Aq57wi79XiiCproK6zR9
 lg4yBOV1izska8fQKy7Yi+mKOxuzR1tIlciJ0DLk6D/NA3LqmO8338E156xsD96Vubm0
 btMMU5JLG5k7uswYomFAqnhllTkmR7ePYrbm9+rb72JwRhyuY02h9e4MFv/izgg1TRC7 FQ== 
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3se61c8325-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 16 Aug 2023 21:46:02 +0000
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 37GLI6Jw006642;
        Wed, 16 Aug 2023 21:46:01 GMT
Received: from nam10-mw2-obe.outbound.protection.outlook.com (mail-mw2nam10lp2106.outbound.protection.outlook.com [104.47.55.106])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3sey2f2c93-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 16 Aug 2023 21:46:01 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=kczvsu38UnxK8ceHvqM5VWUwJTFuWndDJJvBV90ljKmE87m2Cenpb6GQUESJId2K2y6/PsUahv6RKmx6m78jXF8qXRXL54beRB40CgWKAHdS7bx6SrBD4X98oTzxOJnNhzheSzqqwLCEubsua7sqVbirYUTD3YO5ljYSLCXVl30LbeM6/0phdAdN5alrPIf767KHd1B3pd++4851XuHG6hdjZuZboP8IHDN/68xYfuawttvcsgr5xKznxI/h05iCxH2T+NE9QzMQqmw2bizn0MvR9ce8lehXffaYqpVrQUqvBc9pzd6RZkrhELTG4KL6ZVT+ZGz9WS8tpMEVGdeNHg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=FeX1hT9XKydbUZTjLTnr3kHisRE34k8hkHmmFMBSxpA=;
 b=ZpQp5bM2jcu3iyKL6yLBvngae99ViH9+d+UbeyLJPR5q+fseSS4jn9qszxuG8IIwqf4Jo13A2e3igxRDTSry9v6coKwWriRyvkzAsZriEE2m4puJPMpX3CH6mxYwJiR1zJSxfpfVVTas71GmTmReg8pOzN4AAPIIqfENb/5Vbf+A5hdL6CazFbgFxY2aRsVNtNJgc7EgbCPvx0uO2R3M0qebrZjaOD6foWZKSTwEmMdHZRwfHMc/8iO5nDxZGxNagWQGnyxOfOxWxZj0TMn0Bf37Dc/mK7sJARmipkSCzZX9IDhMRk+xrgZb4ERFR++f/8iEEfZhO8G9z96vx68igQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=FeX1hT9XKydbUZTjLTnr3kHisRE34k8hkHmmFMBSxpA=;
 b=WU0t7LW1zYKIQevac6+wW+xJ+GBNUhFqzD9hIcszjFDW5608VJ8OnJWtTFlesSv5eUa59a1sWEwbZDcGU30XLIDluAvNOUfGpueIf/ue4w2h6ajjKnYVlKHnMRSAkMzV3RPuZxU/0azSysinDZTuxp1oIDdQrAG1e7UOU4G9Sew=
Received: from CH0PR10MB5113.namprd10.prod.outlook.com (2603:10b6:610:c9::8)
 by DM6PR10MB4331.namprd10.prod.outlook.com (2603:10b6:5:222::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6678.30; Wed, 16 Aug
 2023 21:45:58 +0000
Received: from CH0PR10MB5113.namprd10.prod.outlook.com
 ([fe80::6bff:7715:4210:1e52]) by CH0PR10MB5113.namprd10.prod.outlook.com
 ([fe80::6bff:7715:4210:1e52%7]) with mapi id 15.20.6678.022; Wed, 16 Aug 2023
 21:45:58 +0000
Message-ID: <2bc6528d-4bd6-3f93-1d03-f1a6d9aba66f@oracle.com>
Date:   Wed, 16 Aug 2023 14:45:55 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.13.0
Subject: Re: [PATCH v2 07/13] mm: Remove HUGETLB_PAGE_DTOR
To:     "Matthew Wilcox (Oracle)" <willy@infradead.org>,
        Andrew Morton <akpm@linux-foundation.org>
Cc:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org,
        linux-mm@kvack.org
References: <20230816151201.3655946-1-willy@infradead.org>
 <20230816151201.3655946-8-willy@infradead.org>
Content-Language: en-US
From:   Sidhartha Kumar <sidhartha.kumar@oracle.com>
In-Reply-To: <20230816151201.3655946-8-willy@infradead.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SJ0PR03CA0273.namprd03.prod.outlook.com
 (2603:10b6:a03:39e::8) To CH0PR10MB5113.namprd10.prod.outlook.com
 (2603:10b6:610:c9::8)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH0PR10MB5113:EE_|DM6PR10MB4331:EE_
X-MS-Office365-Filtering-Correlation-Id: 30d13487-c0f3-4341-c2ea-08db9ea22cc6
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: ShReFwvklYowF7+UUwJCD+96aKU9t5ooSZGIXHgISHpCqOZbxIJPxbVBa6WE8+rsn4nS2ibKp28ZavYlBZU6rZSO//dDCq05hsFdKryEllZvrYp3PjWDrrgNpvTE2P/usnRrn5E+QSY1F0yLKlXRSrL1uWYMkNJnyADpLHF7XGSHiIZaTiUPnde8Zf7KQ91qXmPbuAL190z9XdP6WIvnRXvwuk0Nct2CmM62bXKPNDIaXy6Pxl8c6CirPKciKRlEw5brwfdhFRlswzjZAQb0Ql/YsEiiWBrlm5IeFpM6/ILF6LzTOCTePrq0vnn6/hnwiJZcGSLSbze9CVsljM+vHP4AWvFbBk7dAlTHo/tHN5qqJO1lGhGQ2xu9xyT0vst4I5Mo+zVbXNhdODwt2trYoonhJHb901glL1pnFaTsheOA3+YdU10pVkTvDxpBh5WqMlCuiQvdGQWp1dVGOuClv2cjQ6rDX7AuPL8iJgsVr9I9RmyYpz1XGMWC2Q9mxlVATneSHr4bJBlaB93pUibascayOTeSMPvlxgb1PaDQdJECkmKGKIxsKsfnzjnuqOhr4b1Zklp33bGtD+4/GVOQz4/dH7ZSqWf3WUeMeLbFiXbfhlxqHAKhEybH1Agn52ZyKxtLG0M5OCzDFu0a7bOYnqAbrm2Ol9spXB7JPT1ie0WTI8YyYUfV/WeNNcuDRsve
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH0PR10MB5113.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(366004)(346002)(136003)(396003)(376002)(39860400002)(1800799009)(451199024)(186009)(2906002)(83380400001)(86362001)(478600001)(36756003)(6506007)(6486002)(2616005)(6666004)(6512007)(53546011)(31696002)(44832011)(5660300002)(41300700001)(316002)(66946007)(66556008)(66476007)(110136005)(31686004)(8676002)(8936002)(4326008)(38100700002)(469214002)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?TDNTMitudi9oMVN2MUtGZTh3SHlVYnR6M21pdGE0RDJmQzlwSUd6akVEbnlO?=
 =?utf-8?B?YklRbm53NnhBWm52cnlnUlhMVzdNandiUG5RMnJ6dnNCbUE5OU5PVlJnelhQ?=
 =?utf-8?B?YW5EV2IwVUtkZWFWbWljY0tpdlM2cEF0VjR2YW14WmFWVnhLNmtia2VXd3N6?=
 =?utf-8?B?R1lVVVIrUW5ESkc3eHVKWFpEaEgxemNQZnVpTmFhdFZZeU9KdUh4aVJwM2pN?=
 =?utf-8?B?cGFsbkYzbVVCTkxWT0FNczJzY0U4NHJFSGFrZDFTcGpDU1VjanN6ZEllcmgw?=
 =?utf-8?B?Zy9jbzFNdWNsVTB1aXp1ckM3aWJRVm4ycG1nSlFvdmUwNjgrbGhrU0l0TE44?=
 =?utf-8?B?SkhUeFRGRVZqVmE4NkZrVGFpVzhORkFVdS9GTjZ5bkdpUjhBNlBReE1RUk9l?=
 =?utf-8?B?aFJBbmlRVjlhZzM3dTFZVEUvNklqWHd4WDJhNnRQQ3FBNERMaWMwMURuQWF6?=
 =?utf-8?B?U1A3RE9CUno4bEJGOTR0bzl5c1h3NjlMTEx6SHVXNVU2OGl1c1VoWWZvM1Zn?=
 =?utf-8?B?ajZ4TXl0dGoxdmhTa3ZnZFVtdWh1V2I5Y291OEoyTnQ5eU95SUtQbTB3c25U?=
 =?utf-8?B?QmNxaXRRTFFqaHJ6clA2OFV0U2pPUXdBakJrekRuczdQdWYvY3dWYVhCc2E5?=
 =?utf-8?B?VWhjd0hpeUJ4ZkJiRWdBOFNVYS9ubUxvWkJFT1dFQjVUSVhhMm9idDdhK29y?=
 =?utf-8?B?Rkkwb3orbGxIOGMySFU2WjZpUDRxRzBhUWxMQXFzNHRkdTJZK3NhWnNwVkJP?=
 =?utf-8?B?Q1NvaUIzTDJIRC9meXBCbitSbnRhZzM2aEM3TkRpMzdLSFNTczZvV1crdW14?=
 =?utf-8?B?TnppY1crSkNzZ3dzUHpQODh6L01iajIzMzJiTnNLT3dmNmEyUmI4NTNkZExu?=
 =?utf-8?B?RzR4UWZsTXN2c0c0UjZTeXo5a2FKWFp5aUJDZzFIRGRtQlNXUXdkNTJxcTBY?=
 =?utf-8?B?bU80THEyVjJSQVBldCtiSDhQdUtDUWFJejBEcVhVOXFpdkZyZUk5VUE3ejgz?=
 =?utf-8?B?VFZoby84SzVEbG1QVEhyb3VPdUJQd0h4Skc2bUhQbEE4dytkcnJFcStkT2RW?=
 =?utf-8?B?T2w5YzN2QTZNdHI3VTFlZ2wzU0JmV3VyWk95NndkVWtDYWRqbm1jejI4NHZn?=
 =?utf-8?B?VmUzbTE0dmE1QjR5YWdjRGVOYWJ5WWxlQXZGSUxxYWJuQ3BZbDRLbkhBOVVP?=
 =?utf-8?B?WGtzb2dYd1R0Z3NPNnp3ZUw2WUdocUxnRGJTV3FqOFRHRGVDNlg1Q1g0cGJr?=
 =?utf-8?B?ZmZNU1dqeWF5WWN0SENybUtlODdMYUEweDRKdmpkTXFLc21JNVZkMTVZdlU0?=
 =?utf-8?B?Vm5KUkJ6eHdUUk5OMkZtYnlUU0E1TnNZRHY5YTRtQ3FuT3RNMzlGYlh0UXhU?=
 =?utf-8?B?MURGc05pRnRRMEEzOGFLVnIvbWU3YU5SZUhrck1ZMG0wV0Nsc04yQVlXcVVj?=
 =?utf-8?B?NmZ4NmVNUW1ORUZRZFBDWEJpcWVudDFkaWVwbTR3WjlhVGFXUmV4c3hoRjNq?=
 =?utf-8?B?THFvd2xHRm9zVUhKc1QvVmxTV3hxckNrL1JaV09Ya1BneTJQYlZHS25mUVpD?=
 =?utf-8?B?cmxEamxuZExQYVJwZXBNbkREdlpDS0RpR1ZlTnB0VzY2ZFJ3Y3o0U2JjeUpT?=
 =?utf-8?B?SlRFSWlBelN1eFlFa25HSjJjbjJwR3BEdTUvOGJueU9IaDVnMUF4Z09zODg3?=
 =?utf-8?B?OFppaGYzVERpQzZtOTJHWlFrb041cDFxNkFxVmtXQVBrd1M1eG1CQTdQVFFU?=
 =?utf-8?B?Y1ozZ0NkS3dnRlFxLy9OL1I2eW9HWU1SVHg2c0tMNnBEM25JdG9LUDd4U0x2?=
 =?utf-8?B?NG9hWlZZcXAvMFNhUXFZcVlPZEM5WlBMbGFya25RMXVSVlZ5TEN3U1JWSjlM?=
 =?utf-8?B?S1hKanJrOEJvSS9IcHZidW91ZG1WMm5qdGVtMHBQeFh6RE04MDV3cENtZXhS?=
 =?utf-8?B?OXladjh4N0EyUkRTSFB6UDdqVW4vYnhRNWZSMVZtcFdoMGc1ejYzTndGN2cy?=
 =?utf-8?B?ZitoQzVUNGZrNTY5bVh1MTg5N3gxcjVnckNHOU1tQjc5VTlzQTFCS1RLb0or?=
 =?utf-8?B?MlI4cDU3cFZpaFdqVVlTVm5oK0dRVXBkTmxSaVlJR2JyMkRDeUlTOGpMUHRD?=
 =?utf-8?B?azhOT3oyOS9leUVTOHhPdlJPWFp5MDB3WlpYUElzTGdReVRSR1plWUt3ZVAw?=
 =?utf-8?Q?HpfjBF4LZHr7J0Nw9HgdC68=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: Q4g2nrcX7QszqM8ezYHrpK9dRiExJBQwEidLtCK+l8Hp/tl+kF+cBb0GJBY2xX7DvYezHW4rjcumz/ni3r+k6+fwYHLC0iXe/+IEw9OotdXkHwaUM8g59WlZuW3WU6RAL6emrG/9C5raFqDc1Ks1YQonPN6865xgdJeX4E/vAl5wpcAIMKuGAC5WOpPSEyZyY/Fh1CBBr3FF3MP8Js9OfGw/M1qoMmuesv3+d5go5pR5qIxLVpMkjhGPHYUd5/z6h7scIX72NLz4v8/PJrWlSCR/Or4JcA95taqsWLKYseGVielcdzYsDVXulKpovjxFehorP4MuOOY0j7S0QnRtBD7se+5AK6fm/cILopfwuuxZUSLR1NGoNe+cG1M0HkWouRFNSWBDDxjWJunnyUVjO0TRQMfIUUKQDaTs9BX0cm5sWkVNoBBO4S190xtHhqT7wK0ODt6Guyu8lsee3rVXFjHvkGd9StE4plkgUsWJ3XDsabEFFyFXH7NxVVQ7KrfPYdeAthwCawIlKwAbk3rV5R3s06rNltPFlZh63lI2BHuiadqQU6OC4xPAXNPIcFwKdc2KJFPZn4jDFj6s1p53mDPn+uoLQBTlt8B7TTKYFpeHVHvLV+be9b2FvbDki68Z1ZHgZ+8TwdflAO8oFiZxa4FBnmbV5FfRHvPEVxUt86HB76GtvC7fIhYdQ1OC6sq5WR1Z4RVIYCpIT78nzZc6MvP1kpKrbbRV84lOMD2sBQ3rLcgWxKnfNEEwbV5rN0wHN3yk8eOpZ+pbNUJiYhFbRQ8+FQpB39mtWbZD/Jh80oQaTr3L1XMHbzBtz2duNL3V9//R3J88oCLI/UZtgKqIQvdDg5g+bbIZ9VslzzGq0T3py8yVmeX8JH7PVkSHMLxFxwrSdMnP+yzpcJb7C4Zuvw==
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 30d13487-c0f3-4341-c2ea-08db9ea22cc6
X-MS-Exchange-CrossTenant-AuthSource: CH0PR10MB5113.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Aug 2023 21:45:57.7733
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: qezo5c3HUFLrqVW738JT07nIOICg1jz8xuHDzrrQzx2/ijXd9YvRaDlgumkxIjguKQ0/wsbSwd7ZZS4kNYAkADmTmM42bJyI3EiR5F5Z8wE=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR10MB4331
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.267,Aquarius:18.0.957,Hydra:6.0.601,FMLib:17.11.176.26
 definitions=2023-08-16_19,2023-08-15_02,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 phishscore=0
 mlxlogscore=999 bulkscore=0 adultscore=0 spamscore=0 malwarescore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2306200000 definitions=main-2308160194
X-Proofpoint-GUID: zs-LQI5OmnYw7ey2I7ir0pwBxHbbWeHd
X-Proofpoint-ORIG-GUID: zs-LQI5OmnYw7ey2I7ir0pwBxHbbWeHd
X-Spam-Status: No, score=-6.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 8/16/23 8:11 AM, Matthew Wilcox (Oracle) wrote:
> We can use a bit in page[1].flags to indicate that this folio belongs
> to hugetlb instead of using a value in page[1].dtors.  That lets
> folio_test_hugetlb() become an inline function like it should be.
> We can also get rid of NULL_COMPOUND_DTOR.
> 
> Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
> ---
>   .../admin-guide/kdump/vmcoreinfo.rst          | 10 +---
>   include/linux/mm.h                            |  4 --
>   include/linux/page-flags.h                    | 43 ++++++++++++----
>   kernel/crash_core.c                           |  2 +-
>   mm/hugetlb.c                                  | 49 +++----------------
>   mm/page_alloc.c                               |  2 +-
>   6 files changed, 43 insertions(+), 67 deletions(-)
> 
> diff --git a/Documentation/admin-guide/kdump/vmcoreinfo.rst b/Documentation/admin-guide/kdump/vmcoreinfo.rst
> index c18d94fa6470..baa1c355741d 100644
> --- a/Documentation/admin-guide/kdump/vmcoreinfo.rst
> +++ b/Documentation/admin-guide/kdump/vmcoreinfo.rst
> @@ -325,8 +325,8 @@ NR_FREE_PAGES
>   On linux-2.6.21 or later, the number of free pages is in
>   vm_stat[NR_FREE_PAGES]. Used to get the number of free pages.
>   
> -PG_lru|PG_private|PG_swapcache|PG_swapbacked|PG_slab|PG_hwpoision|PG_head_mask
> -------------------------------------------------------------------------------
> +PG_lru|PG_private|PG_swapcache|PG_swapbacked|PG_slab|PG_hwpoision|PG_head_mask|PG_hugetlb
> +-----------------------------------------------------------------------------------------
>   
>   Page attributes. These flags are used to filter various unnecessary for
>   dumping pages.
> @@ -338,12 +338,6 @@ More page attributes. These flags are used to filter various unnecessary for
>   dumping pages.
>   
>   
> -HUGETLB_PAGE_DTOR
> ------------------
> -
> -The HUGETLB_PAGE_DTOR flag denotes hugetlbfs pages. Makedumpfile
> -excludes these pages.
> -
>   x86_64
>   ======
>   
> diff --git a/include/linux/mm.h b/include/linux/mm.h
> index 7b800d1298dc..642f5fe5860e 100644
> --- a/include/linux/mm.h
> +++ b/include/linux/mm.h
> @@ -1268,11 +1268,7 @@ void folio_copy(struct folio *dst, struct folio *src);
>   unsigned long nr_free_buffer_pages(void);
>   
>   enum compound_dtor_id {
> -	NULL_COMPOUND_DTOR,
>   	COMPOUND_PAGE_DTOR,
> -#ifdef CONFIG_HUGETLB_PAGE
> -	HUGETLB_PAGE_DTOR,
> -#endif
>   	TRANSHUGE_PAGE_DTOR,
>   	NR_COMPOUND_DTORS,
>   };
> diff --git a/include/linux/page-flags.h b/include/linux/page-flags.h
> index 92a2063a0a23..aeecf0cf1456 100644
> --- a/include/linux/page-flags.h
> +++ b/include/linux/page-flags.h
> @@ -171,15 +171,6 @@ enum pageflags {
>   	/* Remapped by swiotlb-xen. */
>   	PG_xen_remapped = PG_owner_priv_1,
>   
> -#ifdef CONFIG_MEMORY_FAILURE
> -	/*
> -	 * Compound pages. Stored in first tail page's flags.
> -	 * Indicates that at least one subpage is hwpoisoned in the
> -	 * THP.
> -	 */
> -	PG_has_hwpoisoned = PG_error,
> -#endif
> -
>   	/* non-lru isolated movable page */
>   	PG_isolated = PG_reclaim,
>   
> @@ -190,6 +181,15 @@ enum pageflags {
>   	/* For self-hosted memmap pages */
>   	PG_vmemmap_self_hosted = PG_owner_priv_1,
>   #endif
> +
> +	/*
> +	 * Flags only valid for compound pages.  Stored in first tail page's
> +	 * flags word.
> +	 */
> +
> +	/* At least one page in this folio has the hwpoison flag set */
> +	PG_has_hwpoisoned = PG_error,
> +	PG_hugetlb = PG_active,
>   };
>   
>   #define PAGEFLAGS_MASK		((1UL << NR_PAGEFLAGS) - 1)
> @@ -812,7 +812,23 @@ static inline void ClearPageCompound(struct page *page)
>   
>   #ifdef CONFIG_HUGETLB_PAGE
>   int PageHuge(struct page *page);
> -bool folio_test_hugetlb(struct folio *folio);
> +SETPAGEFLAG(HugeTLB, hugetlb, PF_SECOND)
> +CLEARPAGEFLAG(HugeTLB, hugetlb, PF_SECOND)
> +
> +/**
> + * folio_test_hugetlb - Determine if the folio belongs to hugetlbfs
> + * @folio: The folio to test.
> + *
> + * Context: Any context.  Caller should have a reference on the folio to
> + * prevent it from being turned into a tail page.
> + * Return: True for hugetlbfs folios, false for anon folios or folios
> + * belonging to other filesystems.
> + */
> +static inline bool folio_test_hugetlb(struct folio *folio)
> +{
> +	return folio_test_large(folio) &&
> +		test_bit(PG_hugetlb, folio_flags(folio, 1));
> +}
>   #else
>   TESTPAGEFLAG_FALSE(Huge, hugetlb)
>   #endif
> @@ -1040,6 +1056,13 @@ static __always_inline void __ClearPageAnonExclusive(struct page *page)
>   #define PAGE_FLAGS_CHECK_AT_PREP	\
>   	((PAGEFLAGS_MASK & ~__PG_HWPOISON) | LRU_GEN_MASK | LRU_REFS_MASK)
>   
> +/*
> + * Flags stored in the second page of a compound page.  They may overlap
> + * the CHECK_AT_FREE flags above, so need to be cleared.
> + */
> +#define PAGE_FLAGS_SECOND						\
> +	(1UL << PG_has_hwpoisoned	| 1UL << PG_hugetlb)
> +
>   #define PAGE_FLAGS_PRIVATE				\
>   	(1UL << PG_private | 1UL << PG_private_2)
>   /**
> diff --git a/kernel/crash_core.c b/kernel/crash_core.c
> index 90ce1dfd591c..dd5f87047d06 100644
> --- a/kernel/crash_core.c
> +++ b/kernel/crash_core.c
> @@ -490,7 +490,7 @@ static int __init crash_save_vmcoreinfo_init(void)
>   #define PAGE_BUDDY_MAPCOUNT_VALUE	(~PG_buddy)
>   	VMCOREINFO_NUMBER(PAGE_BUDDY_MAPCOUNT_VALUE);
>   #ifdef CONFIG_HUGETLB_PAGE
> -	VMCOREINFO_NUMBER(HUGETLB_PAGE_DTOR);
> +	VMCOREINFO_NUMBER(PG_hugetlb);
>   #define PAGE_OFFLINE_MAPCOUNT_VALUE	(~PG_offline)
>   	VMCOREINFO_NUMBER(PAGE_OFFLINE_MAPCOUNT_VALUE);
>   #endif
> diff --git a/mm/hugetlb.c b/mm/hugetlb.c
> index 086eb51bf845..389490f100b0 100644
> --- a/mm/hugetlb.c
> +++ b/mm/hugetlb.c
> @@ -1585,25 +1585,7 @@ static inline void __clear_hugetlb_destructor(struct hstate *h,
>   {
>   	lockdep_assert_held(&hugetlb_lock);
>   
> -	/*
> -	 * Very subtle
> -	 *
> -	 * For non-gigantic pages set the destructor to the normal compound
> -	 * page dtor.  This is needed in case someone takes an additional
> -	 * temporary ref to the page, and freeing is delayed until they drop
> -	 * their reference.
> -	 *
> -	 * For gigantic pages set the destructor to the null dtor.  This
> -	 * destructor will never be called.  Before freeing the gigantic
> -	 * page destroy_compound_gigantic_folio will turn the folio into a
> -	 * simple group of pages.  After this the destructor does not
> -	 * apply.
> -	 *
> -	 */
> -	if (hstate_is_gigantic(h))
> -		folio_set_compound_dtor(folio, NULL_COMPOUND_DTOR);
> -	else
> -		folio_set_compound_dtor(folio, COMPOUND_PAGE_DTOR);
> +	folio_clear_hugetlb(folio);
>   }
>   
>   /*
> @@ -1690,7 +1672,7 @@ static void add_hugetlb_folio(struct hstate *h, struct folio *folio,
>   		h->surplus_huge_pages_node[nid]++;
>   	}
>   
> -	folio_set_compound_dtor(folio, HUGETLB_PAGE_DTOR);
> +	folio_set_hugetlb(folio);
>   	folio_change_private(folio, NULL);
>   	/*
>   	 * We have to set hugetlb_vmemmap_optimized again as above
> @@ -1814,9 +1796,8 @@ static void free_hpage_workfn(struct work_struct *work)
>   		/*
>   		 * The VM_BUG_ON_FOLIO(!folio_test_hugetlb(folio), folio) in
>   		 * folio_hstate() is going to trigger because a previous call to
> -		 * remove_hugetlb_folio() will call folio_set_compound_dtor
> -		 * (folio, NULL_COMPOUND_DTOR), so do not use folio_hstate()
> -		 * directly.
> +		 * remove_hugetlb_folio() will clear the hugetlb bit, so do
> +		 * not use folio_hstate() directly.
>   		 */
>   		h = size_to_hstate(page_size(page));
>   
> @@ -1955,7 +1936,7 @@ static void __prep_new_hugetlb_folio(struct hstate *h, struct folio *folio)
>   {
>   	hugetlb_vmemmap_optimize(h, &folio->page);
>   	INIT_LIST_HEAD(&folio->lru);
> -	folio_set_compound_dtor(folio, HUGETLB_PAGE_DTOR);

Hi Matthew,

In __prep_compound_gigantic_folio() there is still the comment:
/* we rely on prep_new_hugetlb_folio to set the destructor */
should that be modified to reference the hugetlb flag?

Thanks,
Sid

> +	folio_set_hugetlb(folio);
>   	hugetlb_set_folio_subpool(folio, NULL);
>   	set_hugetlb_cgroup(folio, NULL);
>   	set_hugetlb_cgroup_rsvd(folio, NULL);
> @@ -2070,28 +2051,10 @@ int PageHuge(struct page *page)
>   	if (!PageCompound(page))
>   		return 0;
>   	folio = page_folio(page);
> -	return folio->_folio_dtor == HUGETLB_PAGE_DTOR;
> +	return folio_test_hugetlb(folio);
>   }
>   EXPORT_SYMBOL_GPL(PageHuge);
>   
> -/**
> - * folio_test_hugetlb - Determine if the folio belongs to hugetlbfs
> - * @folio: The folio to test.
> - *
> - * Context: Any context.  Caller should have a reference on the folio to
> - * prevent it from being turned into a tail page.
> - * Return: True for hugetlbfs folios, false for anon folios or folios
> - * belonging to other filesystems.
> - */
> -bool folio_test_hugetlb(struct folio *folio)
> -{
> -	if (!folio_test_large(folio))
> -		return false;
> -
> -	return folio->_folio_dtor == HUGETLB_PAGE_DTOR;
> -}
> -EXPORT_SYMBOL_GPL(folio_test_hugetlb);
> -
>   /*
>    * Find and lock address space (mapping) in write mode.
>    *
> diff --git a/mm/page_alloc.c b/mm/page_alloc.c
> index 9638fdddf065..f8e276de4fd5 100644
> --- a/mm/page_alloc.c
> +++ b/mm/page_alloc.c
> @@ -1122,7 +1122,7 @@ static __always_inline bool free_pages_prepare(struct page *page,
>   		VM_BUG_ON_PAGE(compound && compound_order(page) != order, page);
>   
>   		if (compound)
> -			ClearPageHasHWPoisoned(page);
> +			page[1].flags &= ~PAGE_FLAGS_SECOND;
>   		for (i = 1; i < (1 << order); i++) {
>   			if (compound)
>   				bad += free_tail_page_prepare(page, page + i);

