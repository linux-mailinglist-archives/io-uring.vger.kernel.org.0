Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 514AC5395EE
	for <lists+io-uring@lfdr.de>; Tue, 31 May 2022 20:12:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346851AbiEaSM4 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 31 May 2022 14:12:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56258 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234110AbiEaSMz (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 31 May 2022 14:12:55 -0400
Received: from mx0a-00082601.pphosted.com (mx0b-00082601.pphosted.com [67.231.153.30])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C67C24B42B;
        Tue, 31 May 2022 11:12:54 -0700 (PDT)
Received: from pps.filterd (m0001303.ppops.net [127.0.0.1])
        by m0001303.ppops.net (8.17.1.5/8.17.1.5) with ESMTP id 24VFiK9T013782;
        Tue, 31 May 2022 11:12:42 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=facebook;
 bh=r3LzOOZ2NYamdLHSsIBBCRrtsrK03tq55mMsUs8dtE4=;
 b=OxoFDAJVLT2HGpVEREoaY5noXMmkOEhdUQcK6BTKsLs94TR5ANK+XYTLBV+x+N8bppeE
 2JPRgtMyHXq4wA4up/ftAhz1LpAyHzog9KN6Gvy1zlTpFjZnG2pYSkowIZt4eCBnGaGT
 b7f1U/UeASBwS/5eZj6P6GAyrllRd2ie9l4= 
Received: from nam12-dm6-obe.outbound.protection.outlook.com (mail-dm6nam12lp2171.outbound.protection.outlook.com [104.47.59.171])
        by m0001303.ppops.net (PPS) with ESMTPS id 3gbfdtfquy-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 31 May 2022 11:12:42 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=fUS27XD/Sov8WtoJcDunFXi5k4m3Q0nVnHb/uUpIF/7X+5E/Pc49i9j12Yqy+6Tdt8TMZdqF9T06Gn8GOcEpN89bevY8rPtJBhyKSe5SAddIhfWoECCcsFakOvwwNg1focbLFFMkosL3rMVbWKs0fLCSAz6K5+nokflEDcvCcPUMFnXTxkhIgUg3SwDwCBy7DribPL1Xl7l6Okade+TkHnIKNl7u748iBZssCF16CFcuZiR9pKZKTtK38EtYvJmNjCdmXC5KhHgeDmojZLHbFhYYIAxl7FWrQh6OzVu909XEjbqHS97h9HgbY5xdGktwwpmuiGLLwyAIGbDMIl0wvg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=r3LzOOZ2NYamdLHSsIBBCRrtsrK03tq55mMsUs8dtE4=;
 b=K0eGCEBEOGBEjsR+b85Aw1xHktnufCsOtzdTNlN7QuKVet1TGwtQ/2aODtR3Fk6Auj8/1pQIh9jNgfqotDfHcNN/oXOydAi99h4dEVSUcCMcBpsFf402mtKFiZG6Z02HzQli9wJOEEH9PS6jLamZWRIuUzJiDSNZhqROUX4R2IPrjTtMtNnyZrkc6wG6Y8oVBScfD57SQCStUgHdhm/BQjcFhm1lReul+ttSIOlwesFC3/onVqt5mqrxZo7SOk2f2JnTqGE1t79mF5MRtksHHgy0byB38XOmOOA2+gyKPqHEROW31wh7iKCkfkpfIO4c0+BmqwaoSXBDhdnsjc0viA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
Received: from MWHPR15MB1791.namprd15.prod.outlook.com (2603:10b6:301:4e::20)
 by SN7PR15MB4190.namprd15.prod.outlook.com (2603:10b6:806:10c::24) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5293.19; Tue, 31 May
 2022 18:12:40 +0000
Received: from MWHPR15MB1791.namprd15.prod.outlook.com
 ([fe80::e17e:e90d:7675:24b8]) by MWHPR15MB1791.namprd15.prod.outlook.com
 ([fe80::e17e:e90d:7675:24b8%11]) with mapi id 15.20.5293.019; Tue, 31 May
 2022 18:12:40 +0000
Message-ID: <a2d5f74f-b354-6590-9910-82c3beca5c88@fb.com>
Date:   Tue, 31 May 2022 11:12:38 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.9.1
Subject: Re: [PATCH v6 04/16] iomap: Add flags parameter to
 iomap_page_create()
Content-Language: en-US
To:     Christoph Hellwig <hch@infradead.org>
Cc:     io-uring@vger.kernel.org, kernel-team@fb.com, linux-mm@kvack.org,
        linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        david@fromorbit.com, jack@suse.cz
References: <20220526173840.578265-1-shr@fb.com>
 <20220526173840.578265-5-shr@fb.com> <YpW7nKoUB9dJk3ee@infradead.org>
From:   Stefan Roesch <shr@fb.com>
In-Reply-To: <YpW7nKoUB9dJk3ee@infradead.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SJ0PR13CA0152.namprd13.prod.outlook.com
 (2603:10b6:a03:2c7::7) To MWHPR15MB1791.namprd15.prod.outlook.com
 (2603:10b6:301:4e::20)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 88609a26-5ed1-4221-a7c4-08da43312658
X-MS-TrafficTypeDiagnostic: SN7PR15MB4190:EE_
X-Microsoft-Antispam-PRVS: <SN7PR15MB4190F10D6D8C92C990C963BDD8DC9@SN7PR15MB4190.namprd15.prod.outlook.com>
X-FB-Source: Internal
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: PkOemQjXwq4kXtFSKyJq0AUWHWDNI9KnbPVlcFkmnIhTdoT9SRcJ3fcDbWDiavu9A6vVb9kjhmbHLpYBWkhjE29id9w6FeAiedMcZfu9Hu2m5ucN6XURac6FFXmOe1vCZfM4euQd5L2kjyxYZ5NP+Sld7WDYrJyx8dH6aKUzvu5bmajswBfirFIOD+dljJL4dbo2OogZ/2TQogsOnPrjbzc3OVGeyCevvPC7H/tBUObCV9NLMrIA/qiEj3hKltBkqNbnD/K7xgKw7Dmc9I0UhSNFYHiG0zkGb8Oib2Vn5KJiXF3/6QSlN2ppfvGfqJKV93OnGMuU4j21oRGeYYOiQz7tMkeommjAUgbDOdX/z54t1BmG2EHzoieGIiB0hwG0O602h/PtzJmTjdT5w8AvcTxaWqiCPvcWZQk4gSBmJFs1VrjS28b2JD/jPeUd00F4GpzhneNqBbxm38iNiqQh3W0zD+fCS+tOz9XzUsDJiQU7siHQdxLaJiXrQ9Cv032cKS9cdVVSWwnlSMZKZEclG6FlP1hSVyXespJUcVs+mYIM8+L2oMIaaN19xG/BlkznS1yeg5RwF15q5OLVGceiunLGMQJeutBQXiDo1yzbw/3/hf+W4LeRo+oEbMiDo/shSjyyRUYnyjIcxkgjRaSMokPoFu1uA0/bFwnbTUqPt7RRnb1DAJHyglkz+qF0RTAbXahqfbh4AQa5Vg/gHAtcS/QHZPQQ+JOUdrnTVlLkKdE=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR15MB1791.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(66476007)(66946007)(2906002)(31686004)(36756003)(4326008)(8676002)(66556008)(508600001)(2616005)(83380400001)(5660300002)(53546011)(6512007)(186003)(86362001)(6506007)(6486002)(31696002)(8936002)(38100700002)(316002)(6916009)(43740500002)(45980500001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?TGljOG9ZMTJVM2VKWXR6NXM0WjJmQXRUb0lvSXRBTEtnSEJKZTc3U1pJT3pE?=
 =?utf-8?B?STNkMThhK2hzLy9NdU0vbEVMWUxxSG52RjlIYmNWeWk2L3dmZ2pvMUlLRnFM?=
 =?utf-8?B?a3BOY1NDL3JIVVNBVm1YVWFhdERRaGltNTBRWG5XNFZ4dUdDTjd6Zk5zZ0Vn?=
 =?utf-8?B?V21qT1BLQlc4T2haVDZzenNpaDFjdk9sMWNKY1dtT2I4WGdZNi9DUmNhSE5s?=
 =?utf-8?B?Q1EyMlRhZEMwSmZHWmMreDc3MDNzYjhyT0kzV1hWbmhMbE1kSWJBQ3hIOTZK?=
 =?utf-8?B?KzJzajQrKzdkYzdvQzEwcC8xMzlIVllBODV1cFJ6WVRzYnVXUjMvdmtEc2JJ?=
 =?utf-8?B?eHBTTWd1cWUzVFlTT1d5eUlUWVl3L2tENktPMWtYQVE4TzBVY0pUWXB1SzJT?=
 =?utf-8?B?K3pQN0FFVkYxa0NCYmRVbFFrOU0yMVpHR3RKekRLajFJeDVxZkd1MERLaFFy?=
 =?utf-8?B?S0dzK0pVSktzWnNTd0hPcTZrd2pTcXBDVkRFQWRtNjA3c1BxTU9WY0h1dExD?=
 =?utf-8?B?cTlkK3JhS2JUVTB2VzBNeTRGYjFTQVJaLzlJVEpvNy9KV0ZrcVZOYXcwUFNt?=
 =?utf-8?B?MkxOemkvUUVySGkyRElIdlhma2l3bUJsUmlOM1dnU3pkQ29oN2RTVW81eVFy?=
 =?utf-8?B?ZFAvY2FBaTZLYTl0L0dkMDF4WldueHRkTkRsNEVYWi9ncWNZNVVKSkIvTWZW?=
 =?utf-8?B?QlYrWXRvTDBMdzNjRXA2bThVR3REVllwU0lIVzNWeWhCaDJjR2pqZGhLaEl4?=
 =?utf-8?B?bXVRbW5NYy8rVlZpQW5YVVo3WFFMZUJsbW1TZTVpZldpOTZEaDE0djB1ZUdn?=
 =?utf-8?B?MHVIbHhDMWN1SThwZTB3NEFhQ05UdnhUTzRYcFZsaElsZDJINGloMElndlBa?=
 =?utf-8?B?QnIzaUpCODJwOUxHSGtuNksyTmZ3U3c5RGVHV2VEbUtSL3VGMm9RWU9iUkZL?=
 =?utf-8?B?OTVLckFwanVNRVJMa0t1K3c1RnNhb2w1TVJZOFBjNURodHI2eFRnandFelk4?=
 =?utf-8?B?Mmo1Y1NsSDloQW9FWVJvcVhTV1A5dFJHZDJFamoyTlZpeUVTZHdSZWNieVRV?=
 =?utf-8?B?cnJ1ZnFjdVRCdTFsejByRmYyeGpHRW1WSUxHdmpIajNXV2dhWWp1aUwrYk1t?=
 =?utf-8?B?K0Y2cCtMeFFvOERaVXltdjNqT2VCMkhmRUt0MXRHVGRiVGQyWHBmM0t3QkVa?=
 =?utf-8?B?SFZGdHJ2cURFa2pKL1lPSE5mNmZNNWsrSWk2RnRzVHJtZ0dRMGdlMk56NThR?=
 =?utf-8?B?bEczNE1yQ3MrbldwYmJqZUJxM1JaYWt2NFVUc1g0NVUzSUw3eUw2Zk1qUVRx?=
 =?utf-8?B?UkVORHVlRjlmeldFV2t3cm1SYVZsRXFRNHQvMWl3clhMM0d4OXlXSWhkKzNu?=
 =?utf-8?B?TVNyWC9BR1lEWVhpbG0waEUrdzBzOHNaZFJ0Rnd5VUZyVHlCYndubE5QQlJW?=
 =?utf-8?B?TkltNExSWm5waGYyZ0hoVzBZeW1LbGc2TTYydlNPN21RMTJKVjRLbGl3bU9o?=
 =?utf-8?B?VmxHbDg5KzAvK1ZKTTAvYTdkYWlkUVl6QzBsc1ZtMjhUbUo0ek91QjBwOHVr?=
 =?utf-8?B?dlJwM0dTVDZlYXZKdnhvQjRNTkV0dHQ5YUJvUERmei9BSFIvRE5NallzVWZK?=
 =?utf-8?B?TTkwaHl6N1l2T0Zaa1o0OXlWZUxKOGhLSVViVXNtZk9rNzE4b0FEeTBZUy9r?=
 =?utf-8?B?dEUrVHk5WGdpSGVGZVc5c2xmVTh3YjNtenIvM3AxVnMyQkFIbzhETWJXdG15?=
 =?utf-8?B?QVFxZFZIeGVhWnVqN0NRVzFCSTRWZTcrL0IyOVRkTDg0ZUVOY002bU1TZjl2?=
 =?utf-8?B?Q1N0TVZhRlc4bGVoZnNmcTJYTGdSRWQ3Tm9keUREdWhNY21EVUZ3cDNzS3Vj?=
 =?utf-8?B?RHZoaC8xekt2QWM3RkhybWp4UmF1Um40dTdEOC9OU1V2UGluRjlrc0R2VkhQ?=
 =?utf-8?B?eVRQdHRMQ0tmVnErZjdHZjdydHRQSmxXVU8zb0R6UlE0djEzRXFuY0ZOY2Ir?=
 =?utf-8?B?U1FwS0xVb0o1eklHS0U2czlhN0IxZFBVRENndXpBM3poVHQxQUp3TG9rSC80?=
 =?utf-8?B?N3ZlcWwzWjBNaHBKVC9hYWJIa0JJeEtpWnRpWWtLakoycDNiOHYxSDFKNmRh?=
 =?utf-8?B?aWY5QVZFWnBwNVVLYWJKQ0diTC9FeFNxZkxRQ3RMbWpndFlYbklNNXRlczJU?=
 =?utf-8?B?VVN2NHptTDVZTFBJRE9FZkJsaGplZFF5VERNM0ZGUXdTVkZTSE5iOS9WSGRv?=
 =?utf-8?B?TWtubVFZak5UQnJJN0U5YTdDdmt2RmFkdi9qWDlrbjNKSEJOdmU2RmJPaWlB?=
 =?utf-8?B?bkowWS82SUtBeGR4bFNPVGg1VEhlM3pBYWpBMG93aFlOUzBmVkV2TUg2ZlBH?=
 =?utf-8?Q?TA9rfTbPjjtHPE40=3D?=
X-OriginatorOrg: fb.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 88609a26-5ed1-4221-a7c4-08da43312658
X-MS-Exchange-CrossTenant-AuthSource: MWHPR15MB1791.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 31 May 2022 18:12:40.4024
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 7xzbaUMvxrNIcd+dHQ2OpZeaAupYl+nZW/3xYAfXVTJ91Pn6+4QN1iqpAcZGHXTh
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR15MB4190
X-Proofpoint-ORIG-GUID: fNEJDDs0ukVZn1T8Ja-kye0kDA2Tsiwf
X-Proofpoint-GUID: fNEJDDs0ukVZn1T8Ja-kye0kDA2Tsiwf
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



On 5/30/22 11:54 PM, Christoph Hellwig wrote:
> On Thu, May 26, 2022 at 10:38:28AM -0700, Stefan Roesch wrote:
>> Add the kiocb flags parameter to the function iomap_page_create().
>> Depending on the value of the flags parameter it enables different gfp
>> flags.
>>
>> No intended functional changes in this patch.
>>
>> Signed-off-by: Stefan Roesch <shr@fb.com>
>> Reviewed-by: Jan Kara <jack@suse.cz>
>> ---
>>  fs/iomap/buffered-io.c | 19 +++++++++++++------
>>  1 file changed, 13 insertions(+), 6 deletions(-)
>>
>> diff --git a/fs/iomap/buffered-io.c b/fs/iomap/buffered-io.c
>> index 8ce8720093b9..d6ddc54e190e 100644
>> --- a/fs/iomap/buffered-io.c
>> +++ b/fs/iomap/buffered-io.c
>> @@ -44,16 +44,21 @@ static inline struct iomap_page *to_iomap_page(struct folio *folio)
>>  static struct bio_set iomap_ioend_bioset;
>>  
>>  static struct iomap_page *
>> -iomap_page_create(struct inode *inode, struct folio *folio)
>> +iomap_page_create(struct inode *inode, struct folio *folio, unsigned int flags)
>>  {
>>  	struct iomap_page *iop = to_iomap_page(folio);
>>  	unsigned int nr_blocks = i_blocks_per_folio(inode, folio);
>> +	gfp_t gfp = GFP_NOFS | __GFP_NOFAIL;
>>  
>>  	if (iop || nr_blocks <= 1)
>>  		return iop;
>>  
>> +	if (flags & IOMAP_NOWAIT)
>> +		gfp = GFP_NOWAIT;
>> +
> 
> Maybe this would confuse people less if it was:
> 
> 	if (flags & IOMAP_NOWAIT)
> 		gfp = GFP_NOWAIT;
> 	else
> 		gfp = GFP_NOFS | __GFP_NOFAIL;
> 

I made the above change.

> but even as is it is perfectly fine (and I tend to write these kinds of
> shortcuts as well).
> 
> Looks good either way:
> 
> Reviewed-by: Christoph Hellwig <hch@lst.de>
