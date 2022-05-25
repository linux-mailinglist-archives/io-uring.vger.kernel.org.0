Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 15EC45345BE
	for <lists+io-uring@lfdr.de>; Wed, 25 May 2022 23:30:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238386AbiEYVaT (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 25 May 2022 17:30:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51554 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344022AbiEYVaR (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 25 May 2022 17:30:17 -0400
Received: from mx0a-00082601.pphosted.com (mx0a-00082601.pphosted.com [67.231.145.42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7C3267CB15;
        Wed, 25 May 2022 14:30:16 -0700 (PDT)
Received: from pps.filterd (m0044012.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 24PGthwZ009939;
        Wed, 25 May 2022 14:30:00 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=facebook;
 bh=B4J2Eg9iyW/atDTlhXmByB79eDauG2pzAiyX4hQMMts=;
 b=qiM+V/7ryI+IVlfd50Sdw9wlqwDFU1+FtROfGZQdMWa8+DvKmAQWCH1huadkHgdwbDij
 UNN30S61V6xjhy3GBmqrCLko4zknpBW8zMi6o661TDUqL/WBljwPDbBeCFWUrOcpgObE
 T9kDwRw5pEz4SMt7uFPPlGpTRYisouo2UPQ= 
Received: from nam10-mw2-obe.outbound.protection.outlook.com (mail-mw2nam10lp2108.outbound.protection.outlook.com [104.47.55.108])
        by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 3g93uph15h-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 25 May 2022 14:29:59 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=T3PpJNsI+LxVadwY38MZaNsE3JlK4Lo6QqkKzL6lRdb2l2xa4wBRUAmUqAUUDz8DpmIbOit45bvq4Pvaws1Fm/Bgd4gWR+F3x0Mr377nGwo4nbTzrlirSnuAp5b0qyZ/cN/wgkIZ40Tj0jClPRxZkKDqDZXOaPnWfSYJ7tV5pQUOUisKVGN3x8+QVNcbgoKmJEl+BtoZQDlTxzIWjitoW47ZGOA08/6/zy4chfpqxCtOZHJ0Ik06NHR8y9u/x1LjSr3XSOpx17OABSVMKix2W7K7pZwxI6Ga72hyB0HZEyqd3C3WqW/A35f/vhv0yDd7pEId8XrHF3SHteg7CJNM8g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=B4J2Eg9iyW/atDTlhXmByB79eDauG2pzAiyX4hQMMts=;
 b=EXTitDgBkNXb5sAqHHt8wJA3M1wrep49dRBKplU6+YPay5N9x0ow0ErooIFPOHvdvXROnhGzqSLOkheWhib+CblsjYJ4MSkuWIT4jvKRM8kuDVUpnhnkZqDIhvpXV2s42RLXmjyE1d61Hb02yDJXXaeZrZJai8S7JEI6MHNjxFc68bgnq+aRK2bppVXHAeOc3//pzhIkoXHRPbfM/p2MhSW3uFDFaGbAiibe+gZnuRBLs4SYWgAh8Da0qLp5FJUokxzZYBiZAlK5wmNQ1KsZ29d/xc8QUFwo4m4867T3tReNp2p048JsTKkpPQaSdiqkYqPmGd0jWWnEWkxGW3oTTA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
Received: from MWHPR15MB1791.namprd15.prod.outlook.com (2603:10b6:301:4e::20)
 by MN2PR15MB3168.namprd15.prod.outlook.com (2603:10b6:208:a5::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5273.23; Wed, 25 May
 2022 21:29:57 +0000
Received: from MWHPR15MB1791.namprd15.prod.outlook.com
 ([fe80::e17e:e90d:7675:24b8]) by MWHPR15MB1791.namprd15.prod.outlook.com
 ([fe80::e17e:e90d:7675:24b8%11]) with mapi id 15.20.5293.013; Wed, 25 May
 2022 21:29:57 +0000
Message-ID: <ed6a367b-242c-0219-1281-58fe3f69dd3b@fb.com>
Date:   Wed, 25 May 2022 14:29:54 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.9.1
Subject: Re: [RFC PATCH v4 05/17] iomap: Add gfp parameter to
 iomap_page_create()
Content-Language: en-US
To:     Christoph Hellwig <hch@infradead.org>
Cc:     io-uring@vger.kernel.org, kernel-team@fb.com, linux-mm@kvack.org,
        linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        david@fromorbit.com, jack@suse.cz
References: <20220520183646.2002023-1-shr@fb.com>
 <20220520183646.2002023-6-shr@fb.com> <YonkXRZtj7sKWTdx@infradead.org>
From:   Stefan Roesch <shr@fb.com>
In-Reply-To: <YonkXRZtj7sKWTdx@infradead.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SJ0PR03CA0014.namprd03.prod.outlook.com
 (2603:10b6:a03:33a::19) To MWHPR15MB1791.namprd15.prod.outlook.com
 (2603:10b6:301:4e::20)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 4a3f7c56-4008-4407-d687-08da3e95b70a
X-MS-TrafficTypeDiagnostic: MN2PR15MB3168:EE_
X-Microsoft-Antispam-PRVS: <MN2PR15MB316899D1BB7839BE62819173D8D69@MN2PR15MB3168.namprd15.prod.outlook.com>
X-FB-Source: Internal
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: ZJejwShK5B9Rgw0OJPsuhCp6VIBMnfF+exFTscye2FDma150hyr3ZIrPt98H30UFFvo/eDfcNG/KMuV4BAAw36thpkT9be7VacS+Er1I0ycS+b4IZyVCveADj7zoHmfItzqt2EhzVG45cY+jL5gt6tDY0+MbchjL7S8r3bWUba0FyviMaFfkL7z8zKSQ/JAkhpZQ+9D65VWVn2GEQh+PbwxYhOPsUMbpVs8QK3JrleJgqDq2qhdgkNHf9/gn8sNlHFdy387qVMKMlepyPFNnATAmnibUi2YCLA1cXHED8AcPKypH83UDpWjQQrN8TJNw1BZEh5ZXe+mLqn0ZMBkinYc575PyhHrTBwleFprb9aYnyyOxzMKcquO+NmzNsMqz6iei1SaaZ4f/WEqfUXGv1rmLcgPzn3OXMiPbMhEGZ7s1zndyL7SUkTbt/hYtq0mEO/NZq6kO/QlR98vcIpL05kYXdBu+OPQACRAguMjnuf3gPVITW9jG4bkiJGyH69ufuunG5+vQW3MYl5OVE+pQNsO0ikTce8uRuwkV4ZonSFJ8RIABwwerp/6iScgZOfJWh+dcFzkGiHIeBcwh6bNu/B5rfPzpPHLgOlZjvrw6jENp6TsrJmC430ezFWpS4vWCelk9OtpN7Nuw1LGpIjoqjzB2YMDno51Xg9kSoFaL/O2Vdm9+hdjt84CVKmT1ykZz98rj1pvH9nem94UedJNdSsN4MGhgo2y59MeOEsTkLvA=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR15MB1791.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(2616005)(186003)(6486002)(86362001)(66476007)(83380400001)(8676002)(8936002)(6512007)(6916009)(6506007)(53546011)(31686004)(316002)(38100700002)(31696002)(66556008)(5660300002)(4744005)(2906002)(36756003)(66946007)(4326008)(508600001)(6666004)(43740500002)(45980500001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?c20raXhyZXhpbGl2NVY2REo0N08yZGU1RFQ2bE9uSkxWcm1xbGFTOFh4REJW?=
 =?utf-8?B?Qk9nSGhNeERzS1hOaXlYZkpUNmRzbHhqYkFqbGtzdVlVWHo1OTV5RkNZNThl?=
 =?utf-8?B?UlFHV1lmUk45S3J2dkJjTm1UaTFCb3VGbjFnNnhmWWRMUFZReXdXNG0zdHdW?=
 =?utf-8?B?VHloaWtjN0c2c2dvb1pUVWlZdlowa1kydm54YzUya0FrYnIxWVVRc0liQVpa?=
 =?utf-8?B?RGhrcTNkSTBwRFN1cm0wRXhlRkFGQStZdzU5YVJQWDFnT2RDeDNhamRsUHpS?=
 =?utf-8?B?N2hDQ00ydUFRMzRTUmhLZy9wMUdHdG44SUtkOFQ0MlZzTWd4MFBHSUU1YTZP?=
 =?utf-8?B?YXlOK2grS1ZDMk5OVHZzVTRWaDZWbGUvVW1pdW1xdmZ1UElMeW1VVTMzTDVV?=
 =?utf-8?B?dFI0N1VENEdMMk53TXV2S1NPU0dUYklyTCtCWVdoQkVNNkxSQnMwTUEzVDBm?=
 =?utf-8?B?ZGYvL2lBSDZWNVlxQ2hyeE4vNDBYWFBxcFluYmdsb1dQR1RmVlU4aXRvOFhY?=
 =?utf-8?B?bnVCL2NJSytobXlsK2ZCbHZEb1NjRkc0Q3hpSngrdHpyTGk2ZlBBaVpSanIy?=
 =?utf-8?B?OHRHa3l5Y00wbUNrSUlaTUJLMFlOdnI0QnYraU1oMW4wQjFVbG5xcHRqVzdr?=
 =?utf-8?B?eUNyRW43U3BSTkhFM3ZPbHlmaVJsSnRtZUVrZ3Y0L3QzcDNFOUF2Y2pEdzR1?=
 =?utf-8?B?elBCOWRrQUttVTIyQk4wR1JZRjF4MGg0alB1Lzk4VmxpU1pnZW1ad3ZsWjgy?=
 =?utf-8?B?QmU2dTZ1YzlhcVlCb2VqUUZzanhSSEwzNnFwM0VYc2d0Nm9jbEdacXRtR3k1?=
 =?utf-8?B?Mm1xREUzTXhzaWk4aHNBVjRKR0FoODhHSzFYQk1iRGhmbTE3R3pxT1QwTldS?=
 =?utf-8?B?MUdyQ2FERDl2NUxPU1NWRXl1eE0yVXFjdmdhV1dWdzY5aE84d1NBR0xNUm9v?=
 =?utf-8?B?NnUwd1lhTnRMdzFWaHJrL1h5SzNVdW4xclVRM3ZndDJmczNXY2drUmcrZlM2?=
 =?utf-8?B?MVUrdlY5ZzlvSkViVGFQK3hLSytVNDI5ZGNFNjc2KzB5RzBsZy8yVjBQeGho?=
 =?utf-8?B?Zmo4czFGQVlKSmlETDNsV2tEenh6NHFpNTFBTXVDWWhlOGkzUno2YlpPakFP?=
 =?utf-8?B?TjByV3Qrb090Zzc2V21qdURMTll5NFEranIxVlpZK2lNeFpUYlVKdHZJLysr?=
 =?utf-8?B?Ylk2UUdzU0xNcWRUd3hjT3pJR01vT3I4RC9MZUVCWjQxaFJPODJTMDJZNTJ2?=
 =?utf-8?B?TEdRNzI1VWVXN3VLVGFaOTRhOEx2K3JiZk5tT0NOcXgzTVliUnVMR0xobTgx?=
 =?utf-8?B?WWh6SjJxU3RlMERYNFF5TEZUazFhN1phNHV6ZXl0UnRNYUhEUU1LaFU0bHNS?=
 =?utf-8?B?VzcwNzM4VzFpcldZVnBaSERrQ3o3cHNvTmgrZ1hGYlJibTJLZkFMQnpCakRJ?=
 =?utf-8?B?M0NwZEhUejJhSnBvOWFwSUpvK0pqQ1NGOHk4eklMaHNYekNuemcrNkp3OGNB?=
 =?utf-8?B?OGVrSXhGbEZEb0RybC9SM1E0TllmRzdZbGhidXM5aStmd0pYZVhmMVVBM3Jv?=
 =?utf-8?B?WkdaUHJPQzJPTXJMNWZGcnJWYUUzV2J6MHRJNDA5eXhHaTBoMHhYeUNYUTBt?=
 =?utf-8?B?Yk1OTXVicXRNdzNvQndBRXpZNWRmNDhrT1p6VXRtV2gxdG5QNEdyLy9WWDM1?=
 =?utf-8?B?N2pFRHdGNE1oeG5SamswVGl6Z2x2UnVMcjNyN29VQUs2eHpxV2RCb3oxYTM2?=
 =?utf-8?B?ekl2U01odVNva1JaOExKZVFvc0pOczhvZlBjdTAwUUNhUUVTcWcyMHdTbHNX?=
 =?utf-8?B?WUQzTHg4TnlDcXFWUHB5V3ZQNkVQMmZoQkpWYlg1dXdJZndlWG5GZ2NicDM0?=
 =?utf-8?B?OFM0UCsxWE1kNUtubk5pY09oTS92dFlWRS9CZCt5MGduY2xUUUR6WUlQU0hP?=
 =?utf-8?B?ZnlPYk9kbzFDT3l5OFU5bG5BUFdTdFRnaTdMRDBXK1NrNmVzbGwzc3pRdnFX?=
 =?utf-8?B?eUsySWlVaDYyVFVxQ3FRSmJaeEhibGpDVFJ5ZFNoRkpoUUtEMkQ4R1kraTFa?=
 =?utf-8?B?S0p1SVFXejBxaUpDK3pUOTV1Tjk0SE9mdDJQVFdkWWthVlcwSW9oNWFTaTNU?=
 =?utf-8?B?L21XT20xUzYxRkRpa0NxbmtXTkMxTlljYkd3dnhya1VWYjRwTzNyV25YaTY3?=
 =?utf-8?B?aTRKZWNtMWs5ZHJkeTc0cVU0ckZ1VFBWUjFWTmVMbGdncStDSmhZMFpHZkZL?=
 =?utf-8?B?RGRkZWRlUEJXOVh6SDNaaDlVeHhMalVTNUQxOEFmTUxzcUtjbjNtZkR2UHBE?=
 =?utf-8?B?TFJ1c3JrdSttUU5zalgvaFduUCs4SFBqOFJ6alFNbXR2b29xY1pRTldRU1RO?=
 =?utf-8?Q?t6K/PKBP1tlt/IdM=3D?=
X-OriginatorOrg: fb.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4a3f7c56-4008-4407-d687-08da3e95b70a
X-MS-Exchange-CrossTenant-AuthSource: MWHPR15MB1791.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 May 2022 21:29:57.0836
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: d7bXgJQ8EV5K0mwV4wcqWCjmF80Hp7FusCToYtcaMdFbMU7FbugSbFRKkjt7VBZP
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR15MB3168
X-Proofpoint-GUID: pKMW8Q8jUnMXj7ZZzZYgIqZmE2KiN98o
X-Proofpoint-ORIG-GUID: pKMW8Q8jUnMXj7ZZzZYgIqZmE2KiN98o
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



On 5/22/22 12:21 AM, Christoph Hellwig wrote:
> On Fri, May 20, 2022 at 11:36:34AM -0700, Stefan Roesch wrote:
>> -	iop = kzalloc(struct_size(iop, uptodate, BITS_TO_LONGS(nr_blocks)),
>> -			GFP_NOFS | __GFP_NOFAIL);
>> +	iop = kzalloc(struct_size(iop, uptodate, BITS_TO_LONGS(nr_blocks)), gfp);
> 
> Please avoid the overly long line.

Fixed.

> 
> Looking at this I also thnk my second suggestion of just passing the
> flags to iomap_page_create and let iomap_page_create itself pick the
> gfp_t might be the better option here.

Replaced the gfp paramter with a flags parameter and decide on setting
the gfp flags in iomap_page_create.
