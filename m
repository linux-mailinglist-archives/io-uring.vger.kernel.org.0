Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 940B15345C9
	for <lists+io-uring@lfdr.de>; Wed, 25 May 2022 23:32:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232640AbiEYVcb (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 25 May 2022 17:32:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58686 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233748AbiEYVc3 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 25 May 2022 17:32:29 -0400
Received: from mx0a-00082601.pphosted.com (mx0a-00082601.pphosted.com [67.231.145.42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6C37EA8898;
        Wed, 25 May 2022 14:32:28 -0700 (PDT)
Received: from pps.filterd (m0044012.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 24PGteqJ009813;
        Wed, 25 May 2022 14:32:22 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=facebook;
 bh=25hkc7CfFlLh+jaWMkMqC7xGxd2mR9pe3KhTPZx7Uco=;
 b=cDgGEOTSPTl6evR0UHJBxPIfKHYrqBoYCfi6QCY6fEI11/OO8x0rkqq7hhkqbk2EXo8X
 A351U26zeh5s9lp7ugyqUnQ9OWh1QuHCwql98Z6mujyHeDRX69zQvqywvCn/dSLT2fNv
 0j0HkOBD2/LhK+4XETdxaUt881G/huoN52Q= 
Received: from nam10-mw2-obe.outbound.protection.outlook.com (mail-mw2nam10lp2102.outbound.protection.outlook.com [104.47.55.102])
        by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 3g93uph1kn-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 25 May 2022 14:32:22 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=YYzQDj23iToG5azgLsRU6osGZ2YaI8KRQohtpn/oAPC54Fry/YS6ENE76czTGFMaO2zt8ze3gKFcAUNwcShhdRdo2FFWXnpTVPTYMeD1FKX3ey0oNFDYLIkZhYjDdu9ClcicfeZhdbV7WLJQu7fRbiEsdUnMbZSmuO2gLuRdj9bQrwWbBAJl+r/+I0wxaWK2dQVmgKzWZen5117GGC9wLowxex4HrWLSmi7Hj2aQNLWaOmEjmTiCuxLfI+OSNjVrmmGjHy9ZDitFYEtcTM2ibUX/ptfqwhXwzFyCQbsJ/T7BGE7T9z4uIOzegCUaymWqjtn5WoOO10pnMBNVlq4gnw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=25hkc7CfFlLh+jaWMkMqC7xGxd2mR9pe3KhTPZx7Uco=;
 b=hrCmsfmAf8JIDej8VBZ1ccRGSBlNmFK4BO6LrlPD279vUlbN+qKt5ZU0DwZ7DE8uTTYUqA9dCChm9ubpkV/c2jcmaAYxbXXHaEhFXRsGXMJ2ScLL0Gf5Lni44aETkIEZKR7d5/AOTfNPaSsX1BDQYkX9YDmxmRPD6rngoOvFVq0F2zCCKumG0mBHhL+yoi0MJSXSKOwF9g9KKqILAq7hKCZ6F29DBSTHSuQpXpxBEcWYHVucNG4GbH/PwVvXLavnlZnRr3TzWqJBmjhkM8TQURhfQ3/dceDuQcQr0XRFTe5Qmz4wnZR+P6LjShn7htt9OVjYDa8x3oVfiVjOwdWF2A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
Received: from MWHPR15MB1791.namprd15.prod.outlook.com (2603:10b6:301:4e::20)
 by MN2PR15MB3168.namprd15.prod.outlook.com (2603:10b6:208:a5::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5273.23; Wed, 25 May
 2022 21:32:20 +0000
Received: from MWHPR15MB1791.namprd15.prod.outlook.com
 ([fe80::e17e:e90d:7675:24b8]) by MWHPR15MB1791.namprd15.prod.outlook.com
 ([fe80::e17e:e90d:7675:24b8%11]) with mapi id 15.20.5293.013; Wed, 25 May
 2022 21:32:20 +0000
Message-ID: <ac8d7ce5-5752-69c2-f521-fdd81a4dc84d@fb.com>
Date:   Wed, 25 May 2022 14:32:17 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.9.1
Subject: Re: [RFC PATCH v4 07/17] iomap: Use
 balance_dirty_pages_ratelimited_flags in iomap_write_iter
Content-Language: en-US
To:     Christoph Hellwig <hch@infradead.org>
Cc:     io-uring@vger.kernel.org, kernel-team@fb.com, linux-mm@kvack.org,
        linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        david@fromorbit.com, jack@suse.cz
References: <20220520183646.2002023-1-shr@fb.com>
 <20220520183646.2002023-8-shr@fb.com> <YonkAyZvfjHWdzsa@infradead.org>
From:   Stefan Roesch <shr@fb.com>
In-Reply-To: <YonkAyZvfjHWdzsa@infradead.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SJ0PR13CA0019.namprd13.prod.outlook.com
 (2603:10b6:a03:2c0::24) To MWHPR15MB1791.namprd15.prod.outlook.com
 (2603:10b6:301:4e::20)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: f6be5431-7e94-42fa-24a4-08da3e960c83
X-MS-TrafficTypeDiagnostic: MN2PR15MB3168:EE_
X-Microsoft-Antispam-PRVS: <MN2PR15MB3168956C1584AE60B5802841D8D69@MN2PR15MB3168.namprd15.prod.outlook.com>
X-FB-Source: Internal
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: /5dtbIiaL5LxLE1CmrJVvJ+Z9pnn5U/z7IYfT4sBgeT9IEbMBMdJivaCMQYirT0RfJggLmsbWWG6oww273kRgWZ1iPWTbu4Xu0Fl4b4aZ5gTaFlWJX14BXhNdqCuooJP6rvfhJLEZgjqHgQ0MvUpGNiewM7Z2HjLsk9iMehTw6koIMan1X4ruCpqKSubG/WgKDQam5M5y+IcI8Lsy7u8bSRaoEkU3Nu8+GDc+UQFuZG+0kS60gw41AOtDoTKZqPu2zzx/yKqKKS/TS752Mr86hCHmrJD/svmgltfL0FiivZHIRCjaWXQtPlIJ909snqCJQQP6zpJxakAx8AezedBhDM0zCEUy/lGZpw3gv9jtZpxfTUQQBol0KDYzScJUGBLf0+F+xRXxg/SjjlqwYD+EhQeCMZj8OmB4DxJJ/7+Pt02nphyDPGbOHwV45q2+uKo6fSE3XmlWP2kbys0fZHaTQaL9WRsMWfgfxrhHZNA5EL4azYE2eTmY48gQcT5b1yUCLF0U8jHw0qqQo9seBbMe0S8fQTeBvr8dpdqm8YOlcDPfdGKszI3sBSIFoTuXYXCHTPGEAYnTEcVPx5Qu2oeCMM4hnMK4cI/ZS39VxmE/sMEszy4Wp2ucLVKgX8UdkP2raxrTePe4Jro17WecZ0b+pt9SrkWBZkGS8TY4ZlQ05QGxLGGIKjks4WkLOdXldjg14qRAf9pipKncf/yCoUVz2H764kF6Kd4nAeL0+ZdsO0s7pcpNPH7iveLVRggNvbkzk7fNwo2ivmQxMAdETDXtQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR15MB1791.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(2616005)(186003)(6486002)(86362001)(66476007)(83380400001)(8676002)(8936002)(6512007)(6916009)(6506007)(53546011)(31686004)(316002)(38100700002)(31696002)(66556008)(5660300002)(4744005)(2906002)(36756003)(66946007)(4326008)(508600001)(6666004)(14143004)(43740500002)(45980500001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?TUQ1SzVMVnJ1Qi9pV28venIyN2lRSC83bUFGbUVlOXVHQ203M1MrRkhGWGJP?=
 =?utf-8?B?WTA4bzFaTkxMR0ZSdDdxL1VES0dCMWRuOG5jUlR5dXg3TldTdnRBcTc5dTh2?=
 =?utf-8?B?OEZnbTlxY2I2c1BLdTlHcldUd2lKMGd5V1pRcU5vNzBIbWszRmppMzJkdTNx?=
 =?utf-8?B?N2R4dGhIV29ZdFNldUhUdE95SVo0RVhraXNudXZtbmJaMWw4bmRwd0tDMHF1?=
 =?utf-8?B?VjBXTzNMeXI4bDJCYzZ3c1VHdkUwTFJwLzFjalJrRk50QzRsc1AycURDYmxw?=
 =?utf-8?B?d2V3M1pxNXBmUCtTVnZtVDhqMm1JUXMrT2RXalU5NDAzVUM0QmxPUjc1d0N1?=
 =?utf-8?B?RDVlSFZJMUFjWXRiNUtrVGNrMzZKbmZ6c2RUR1hUUWRlTkt0RHBDeDZyazlS?=
 =?utf-8?B?T1I4SEdPNnkraEc2d3dZN0hXTnIxaFFla0Y2NjREQTVSOWh2MXZaTVpuU0tm?=
 =?utf-8?B?TDhISm5TUm1pL0k1VzV2V1BIVDc4ZGV4REkyZmZCNHpjMlYwSWhxeE9hQ1lw?=
 =?utf-8?B?ZTYxT0ZaWEd2WmZXaElORWQyRjhVUU1ac2l5OGZMclJqSll1WlUwd1NYNi9k?=
 =?utf-8?B?eTJOSWtjODJWTDcreDE4bEIrZHc2S3ltTWNadUhPYkxna0c1Z1l6YStjak02?=
 =?utf-8?B?ODVKNGw1VWlwcC93RkpJTGJDY2RzK2VCQkRCeE1OY2dDQnpvTCt6QXFlWDZ6?=
 =?utf-8?B?bTF2T04yOGsrVlBlcml0YWlIWThtTkJRNGxzdTBVMkpGdXBuZmx3cCs5ajNj?=
 =?utf-8?B?UXVjRU04dUFQa3F4akplejlTZTdzS3V4OXZJK0ZTN1RQazF0T09lY1NBNENT?=
 =?utf-8?B?dS9RUXhzM3JaODFwRFlFeE14TW5FSm9hcVJiTnNFeFFvYjhBcGJJa09GYVFC?=
 =?utf-8?B?aWZ5aFBNVllmMHE4UzRTdFdETWhGTUVIRmMrNkQzanROdVRpWTJOVHlhcm0w?=
 =?utf-8?B?Q1pUWjdXSHBrY0R0aDNoa2huUERMVDB4aWQxWXdOUVFwbzEwY25iVGJQMUVz?=
 =?utf-8?B?L2NjWGNnRUpyM0tEeVQ2RitOYnhVQjJ1Zyt5NGNzZkR1anFYNUo2L3hlcUNZ?=
 =?utf-8?B?L2pMa2d2aGkrRjZZRUxPOG1QUkdrQWxaNFB0VUNpZVBvZ0ZVakdqZkhhdW5y?=
 =?utf-8?B?djUrMDMzTnpKb2I5SFpQelArbTlhT3N0a1IyYTFhcC9FQnRjRXdNMUtnU0VW?=
 =?utf-8?B?dUlMT1p6ZFNocWcrKzhIM1p2RldEbVNDQXBUWUx3eFRScjd5OWtTWExRajdN?=
 =?utf-8?B?OTE0SUYzZWZrd2lJVG84bnFGWE5pd3BLMWg3a0FWWFl6L2xYSndYSFh6YWhx?=
 =?utf-8?B?bmpMZ2x6dXcrenFPbkpKUFAwRkEvNFBFRjZ0YnVrNUxvMFRQcE5vSWx3T2pn?=
 =?utf-8?B?VFJ3TVloblhpVG9UcStaZVdRZ1FWNzNwVGJ6THhpZERGdHVEZkRpaEtPNUNC?=
 =?utf-8?B?ZlVFYXZmNFhIbWVBcm1BbFI2RFNBaDliTmhGMHZQbVA0U2NiaFFWZWw1Q0p6?=
 =?utf-8?B?bmEzbHZvN250WTRaZmdOS0dhVUFGRThJR2tUdmZMTUtzdDVIMEF4QmEySWxX?=
 =?utf-8?B?WjJsUEFLcWxKL1dxQThndVJTeVF4bnd0VGJLYUtySEZ2MFFxbnRzbVpENCtZ?=
 =?utf-8?B?ckRNYUxncEZ5dXhDQTFsMlc0Q01ybEcwa3VrckdMUmo5Vmg1NkhvTzlINytJ?=
 =?utf-8?B?dm5UTkUzWXkzVDJnb2t0TXQ1Wjcrdk9INWRNalBNU21VakJyTkcwVUxZSGpJ?=
 =?utf-8?B?UldNcFVqQ3V2VytHdldSSTl5dURSTXkwSGFCaFpBZzU5N0E0K3lzbDZCL2lO?=
 =?utf-8?B?ei9NT05sYWJrRG95MmtqMnBEd3lMZnBIRFVaL3ZrVmpaSzA2MmlTdUdNVHFJ?=
 =?utf-8?B?N2hBR1JqT1Z4bzkzb2piaHFkVVVDSzJBM3V0ektBZVEyQ0FSY2trQ0Radm5v?=
 =?utf-8?B?dkFWWEFyM1A0cElVVkFRU0dOTjNQd3ZVKzdkeGo5R2w1ZXN5MlRkNkhPWmhy?=
 =?utf-8?B?cFRpSkwwM2QvY1JZWVNlWGVqbUNKOSt4REdpZ0tUSnFjSWJjditDUUdpT1Y1?=
 =?utf-8?B?WXFXc0xsNVdaN2dIbUJwTFE2RWJxTXVZRW5LL2UzM1dYaEw2bFpIT3ZIR3dI?=
 =?utf-8?B?c21RWE90UjJqMW82WmJiUUV4NDZHNHZzYlQ0ZDZNeDZsSm1GdURGb2xOS0RC?=
 =?utf-8?B?NlJBZndmS1lZMmNhNXBOb1ZUMXFxNnNrcTc2Z2MrdTFtaGlkRHBnOURoa3Vm?=
 =?utf-8?B?VEhOVDBmMUdlbTlnbVh3SUNBQmFNZi9TL2YxRWdodUNPV0oxMnpqWEtRRGVq?=
 =?utf-8?B?d1RNRktTV3JyaDRsTStIOS9LQWVsUUgzMmtldzRmUm5jSS9oMG9VNUxuWnNq?=
 =?utf-8?Q?cl5nR26378AEr24Y=3D?=
X-OriginatorOrg: fb.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f6be5431-7e94-42fa-24a4-08da3e960c83
X-MS-Exchange-CrossTenant-AuthSource: MWHPR15MB1791.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 May 2022 21:32:20.3690
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: LRddq9cpsgcBgW8HeM3P4oyX5dQIRX+vp46xElMbAFaaMkBTcMq42IxiwOoicyBO
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR15MB3168
X-Proofpoint-GUID: W87WPQ8xjtR1e0Au2GwtPhXdSNqK9nOV
X-Proofpoint-ORIG-GUID: W87WPQ8xjtR1e0Au2GwtPhXdSNqK9nOV
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



On 5/22/22 12:19 AM, Christoph Hellwig wrote:
> On Fri, May 20, 2022 at 11:36:36AM -0700, Stefan Roesch wrote:
>> @@ -765,14 +765,22 @@ static loff_t iomap_write_iter(struct iomap_iter *iter, struct iov_iter *i)
>>  	do {
>>  		struct folio *folio;
>>  		struct page *page;
>> +		struct address_space *mapping = iter->inode->i_mapping;
>>  		unsigned long offset;	/* Offset into pagecache page */
>>  		unsigned long bytes;	/* Bytes to write to page */
>>  		size_t copied;		/* Bytes copied from user */
>> +		unsigned int bdp_flags =
>> +			(iter->flags & IOMAP_NOWAIT) ? BDP_ASYNC : 0;
> 
> Bot the mapping and bdp_flags don't change over the loop iterations,
> so we can initialize them once at the start of the function.
> 

Moved the variable definitions outside of the loop.

> Otherwise this looks good, but I think this should go into the
> previous patch as it is a central part of supporting async buffered
> writes.
>

I merged it with the previous patch.
 
