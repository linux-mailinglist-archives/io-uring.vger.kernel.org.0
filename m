Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7300A52C768
	for <lists+io-uring@lfdr.de>; Thu, 19 May 2022 01:21:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231201AbiERXVj (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 18 May 2022 19:21:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47670 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230058AbiERXVf (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 18 May 2022 19:21:35 -0400
Received: from mx0a-00082601.pphosted.com (mx0b-00082601.pphosted.com [67.231.153.30])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B75FA2CE03;
        Wed, 18 May 2022 16:21:29 -0700 (PDT)
Received: from pps.filterd (m0089730.ppops.net [127.0.0.1])
        by m0089730.ppops.net (8.17.1.5/8.17.1.5) with ESMTP id 24INKb72016619;
        Wed, 18 May 2022 16:21:23 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=facebook;
 bh=ZsOl8vqapVwLR1JwHqSDY0VbdOjy/Jo1/HskmzT6KPs=;
 b=p0kg5k388aigalc3uycMG/1wwusGZ2buwIqSiO1TH5pm5VsOfLHi4yvK1pOjKVrtL0aS
 e5McdJxypnQ68wHRx5G3NgrMadYN470pttVjlgx0ULoWc2B5z2x+F5XKBQ13B/QuqN50
 4a4kO7JnExNo2Aja0fmYDKk/7r8wGzLVB7g= 
Received: from nam10-mw2-obe.outbound.protection.outlook.com (mail-mw2nam10lp2105.outbound.protection.outlook.com [104.47.55.105])
        by m0089730.ppops.net (PPS) with ESMTPS id 3g5acy005c-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 18 May 2022 16:21:23 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=eq1AIIcN3uYfQcGccc1j6dqB7977F+Qbig2eFBSmh/ED0vW/qMwbVa/qMMVVYcFwmxEbE4fd+OudaDcl9bGnR/5C4M67SBxux3+KUmEHkQ3JXFIPb1Xhmr1nwT9zoVNXNxf8Bp0zZsVBmJVyMNZ5WlmXZox4FH3FL6Wz7EgvoNcI2NYQEEAW4Ji7D9MJaCA/L8k6UZzfuYW6SKpYWLr5UE2ZFlv2/w40i9j5PzH/KCJorRCQc7+6RfMh4dcj8cKaIutDjk2+4Hs+4yINqn+RFud8cEot78B0aWBGCc/cNISwGBH5SKXWLAozAV0LZTUjSuGoKnP+62rY/a2jSUlbRQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ZsOl8vqapVwLR1JwHqSDY0VbdOjy/Jo1/HskmzT6KPs=;
 b=Qjyd3LxrCr0NP8X5X3ALTCVqivbYpvScuQxtdVtgkhsWQ0vkl3c/xw7ItlNLtGn6EXWa1N6vusncSL5mzRtQBpBm6cr/GqLFPxunyxi0D3c0c7Tb0F0LN+DiI5p3VrA8BhEwK/jPrdbUNiKS++b8sz9eQ2DVDMqVoY4FyIdzbyT3dgPCGAGqGCPT/qu4wtGeOkyfnlZEMHTQwK7yws3RuCOHc+9TBchMBocxehiSHXOKIFsA3VgRwdise+A/WUP3Z9KYOFDvJ0P6hnm1osqye5QGRIrsCHvqT5/i3l4SzFgzcbqqVoTDiEDOHcRg7YVhoUwZ+9WkyofvhfJ6Yd61KQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
Received: from PH0SPR01MB0020.namprd15.prod.outlook.com (2603:10b6:510:76::6)
 by BYAPR15MB2773.namprd15.prod.outlook.com (2603:10b6:a03:150::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5273.13; Wed, 18 May
 2022 23:21:21 +0000
Received: from PH0SPR01MB0020.namprd15.prod.outlook.com
 ([fe80::ad90:787e:697e:3ed1]) by PH0SPR01MB0020.namprd15.prod.outlook.com
 ([fe80::ad90:787e:697e:3ed1%2]) with mapi id 15.20.5273.015; Wed, 18 May 2022
 23:21:21 +0000
Message-ID: <f376e618-601b-7679-35bd-2febb14ef110@fb.com>
Date:   Wed, 18 May 2022 16:21:19 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.8.0
Subject: Re: [RFC PATCH v2 03/16] iomap: use iomap_page_create_gfp() in
 __iomap_write_begin
Content-Language: en-US
To:     Matthew Wilcox <willy@infradead.org>
Cc:     io-uring@vger.kernel.org, kernel-team@fb.com, linux-mm@kvack.org,
        linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        david@fromorbit.com, jack@suse.cz
References: <20220516164718.2419891-1-shr@fb.com>
 <20220516164718.2419891-4-shr@fb.com> <YoLlQ+lyko2Xr8Y1@casper.infradead.org>
From:   Stefan Roesch <shr@fb.com>
In-Reply-To: <YoLlQ+lyko2Xr8Y1@casper.infradead.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: BYAPR03CA0026.namprd03.prod.outlook.com
 (2603:10b6:a02:a8::39) To PH0SPR01MB0020.namprd15.prod.outlook.com
 (2603:10b6:510:76::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: fd3cd82a-06f4-4366-03d4-08da39251e28
X-MS-TrafficTypeDiagnostic: BYAPR15MB2773:EE_
X-Microsoft-Antispam-PRVS: <BYAPR15MB2773D2F13F9B3B6ACCD8DC07D8D19@BYAPR15MB2773.namprd15.prod.outlook.com>
X-FB-Source: Internal
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: KV+KFarvDBnEgoWxQiG9mkR/GQ5Q3Qk9RzQdpzeN/TXaOnHwvv9r2k8+FH76Z2WGDiJBpNVH0hkgSQfgNBVShdh4zJ6bqg1+Zdi/cGILTnYtmo8LJS61lf/2QLYS7Yb3TzSyVjiUrzSjIUuZyCa38xdgNjgV81Bx8B0VEL/6q1tOoWMsZYezhQYNe8NcVwy7FoKnzk61nk1j9Zws/czUcbhFKo2OM823pqIjGO4BNEFfF9/9tQQrRdGIu2TpgWFiVa6jaFb11tzXjT2Xh2pxOGhjafomLMS3Li6DGPXo4xPCSM41RYv2k8+YAgDDufdnVA0WshjzrUVqF1aLe0kgHN/6DvF5rBbDxDO5u4wvB/+9DTTKhtuh/PlYM+ds4diFXyD8ntX9QN2wZy5rfkncFKNTyF5HT0RLuXuQ+EOFMG3Vxn6fUYOS+bPhRaotBzHRL+vtpP6/gzxHNlxC/Y2uNdC/H+0CryTRQkzcW0pk3yho5heBzmL1UZJKpP47QwwhL9xq5LQpeuIo7tRwJT2utdjrOZ024JOSyoDKDbXcUO2YDfluod2S7MTBe0EwK7zjPXIu/rdsjQ3kEaOjQy411uFwEDlibGxuMuKFdsk7U+R6YN+Iiew1hBC7gaLziDwhd0xHgFaRVPm2cSJdBIVnfJAmqZ/2F3AW/I+NnwZanUVsAkMKPJoDqXenecWR0MwJ7zOtgiitZDe1+LJ+2m1ig+MRtlgZFLGjMlABFfkBv+ZdDXd5uQnl/gCss1iufVOu
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0SPR01MB0020.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(53546011)(31696002)(86362001)(6506007)(186003)(2616005)(83380400001)(38100700002)(2906002)(8936002)(6512007)(66556008)(8676002)(66946007)(4326008)(66476007)(5660300002)(31686004)(6486002)(6916009)(508600001)(316002)(36756003)(43740500002)(45980500001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?ZUlOdGdvWTJWczlwTHZhQlhOeFhNNVJaMGVVOW0zbi9mZURmOVRCb05BRFFa?=
 =?utf-8?B?OGRXZndJbHZkVnEraHRIV3lXWStGdmVDaWhyZFZycXhOeWVkdXE5ZzUwdkN6?=
 =?utf-8?B?OW1HdVgwWmpBNGNUV21pMG8xMXhhaTNEQk1XcHByc0FVcjBGL2N3YnlBdEEz?=
 =?utf-8?B?TEhZdkdHQ1lPN241Szd6RDBZaFpZbG8xODhOdjUwM01GU0VsU2RSbExNSExy?=
 =?utf-8?B?ajFKbDNTZWozVHZOd3VOTSszNUdXRWZhL1BXWmM3ZWNQeWxMTmpCVFJESGtF?=
 =?utf-8?B?b0pNZHVKT3Y4eDhiTXF5WnZHQTk3b08vR2FsRStWTU5XeXdKNlBxSzZwalh4?=
 =?utf-8?B?cmYreXRsNG1uYUR2VzRncEhGazR2Mkh2NWJZKzYvNlgxS2dzZWdPblNIbElt?=
 =?utf-8?B?TU8vUElqZ1JwRzVUdElHZkNEbnRUZG0weE53QXd6WTBGeVpRUlYvK1dEWFVM?=
 =?utf-8?B?Q1ZsMUNWQ1RPYVlYTis2TzdGdTJsY2c1bTlpZStEbzBCQW5wRHp6MmRXL2Z1?=
 =?utf-8?B?Mmc3QVZNYjU5M0QrcEg0dmlCbE1LbnpOSklRTlc1UkpZbkxDbjFsZUNvanZv?=
 =?utf-8?B?dTRRYWF4eUJ3a3dsYjU1RnNhR3dYWitFTkdmRUo5MDRGRWlCTkpkNTNmMFla?=
 =?utf-8?B?VjJKamhTZzc4K3piMDlYUnJzSGF4QzlKSW9YNzJnTlF5dUsvSXdsLzFrTERL?=
 =?utf-8?B?MHVkUGJOeVJld3B0RGlKRmxlQnFKczFyTVdVdjRHcGFlN3BIRnF1aXhHbU5v?=
 =?utf-8?B?ekl1ZGhjbk5IK0ZaR2Ird1lXTFYxMUJUaUw3VFlTSGNkS21GbXAyWkFiSXZT?=
 =?utf-8?B?Z3QzSXJsRFI4SUd2Wmg2bUV0YVdsZTg4N05ObUpmSXJpNXZxdVdQSndQVzZN?=
 =?utf-8?B?NVZweFhxdTZUNFRzanVjYzVOYUI5Q2hLekphTExCWmF5MmJqdDV0L1NwN0NT?=
 =?utf-8?B?ZjFHbnk1UWpaQ1JtZVBZdWh3cHEwR1EzVjF6K3FicjVuYjZxSE00QlVtaXdK?=
 =?utf-8?B?UzZ6TU9ROGZRb2s4czl5Qnd1UllvVVowYzJDYkhuQjFHYkFlMlhjaDI0THNq?=
 =?utf-8?B?TjBLbkNRcXpkMmZkQmJKU3l6b2lRcTZuYXJFVTNtZkM2N3FBbCtHQkNSUXZJ?=
 =?utf-8?B?NFhHT3NXbklGdEdzekVnMzIzM0NhU1Y1eTNWV2EzWHJEVDhCOTlDakJRRlkr?=
 =?utf-8?B?b1M0T3hGWGZoSVBteXoxSEcvWGNhT01EOTJ1WWRZMkVEZDR3SFhpSXBWZGow?=
 =?utf-8?B?cVRTWDRzR0tndzJ5MEVweVZkdHdPbW9xYjUrNzFUNkNRTUw5QlBieXYyblM3?=
 =?utf-8?B?djA2UFJJWVdTVDRISi9lUjRXR21zYndyRmY4a0VWL0xTWkJ3ME0zM2VFcDBI?=
 =?utf-8?B?THNQNFhZTGdOenZNMEFYT3JJTTNIRSsrTThRV2ZWQlNXSkJBKys1dTJKTVho?=
 =?utf-8?B?eW1UUTg0NW1ONXhZSkhoRmlrbTF3K1QxQ1pMK2lhN3hzVWRhZk9kUklxQkRY?=
 =?utf-8?B?anY5MnBvbnRweFFrNVBWWkF6Q2o1dFhvQXF4bDhnRE1aS3lOTFpiOExWazFh?=
 =?utf-8?B?OEtYbEUzNklVT2NwbHQ4ai9jdWVRcitzbmpwbGpYem1UYnRiRXRCdXd4QzhJ?=
 =?utf-8?B?YUp4SExYWEY2MnFybE5qZG9xNnpIcnF3VmVLM3BDTW9rNVR2ampCYUxhNWdO?=
 =?utf-8?B?V0xqbndqN3Z4dTBaL2pQT2ZjcjZjYnF3ZzdQa1dKbXQwcUh0Vkk1dDlMNDlH?=
 =?utf-8?B?LzVJVkRlSXRjWDlWMWcybVYzSXIyRGhYb1h0VW5iN2F2T2E4SEpUaVlwNHBk?=
 =?utf-8?B?OGlqQjZYaWw3RXFZMUc3MDc1VTlNU2d1TlpyeWVjcnVvbGVZcHFzZTkvNHMx?=
 =?utf-8?B?bGlsRFZmcUVUTHBVR3FUdlpRVGQ4N2Q1QUF6TmZYbU9tYUVMMVBLYW1KT1hr?=
 =?utf-8?B?Wm4xYnZtT1BESU1YNEhnSXZrSXgzd1FIMW40ZXBjemg5a2hrTUYxOGVENmVt?=
 =?utf-8?B?NUtOc2VVK1RENFU5bGF3U3pyLzFNelRhYitWY1FtSnVuKzlDTzBzaTBZVVo2?=
 =?utf-8?B?Z2V4dHlSUzVMcTcvNUtNcGt5M0w0QjhQNFNjaDNvSkFQMTF6YW5Kd1J6aito?=
 =?utf-8?B?Qm5rSk0yQ2tHZmcvZHdFdlVmK3VQRGZyMllwNmNYamNjTGNLRFIwMUpxVnQ5?=
 =?utf-8?B?d3JpYlQ4RzlCVGVNUEtoWE9nUXVOWXdZMko2QkE1WWRFbkhsQjFVZWdoNmUr?=
 =?utf-8?B?NkV1bUlUWVVPMTZnSkZ6Uk14MENtQmo5bDdBQ0c5VzlWdWwxWERrekNjczZr?=
 =?utf-8?B?ZjY0L2JnSnlsbWF4WmhUS0VwZnhWL0xZVGc5b0RwNG02aEdOMVlWV0xkQmNC?=
 =?utf-8?Q?U/Tr5rgOmloqSufc=3D?=
X-OriginatorOrg: fb.com
X-MS-Exchange-CrossTenant-Network-Message-Id: fd3cd82a-06f4-4366-03d4-08da39251e28
X-MS-Exchange-CrossTenant-AuthSource: PH0SPR01MB0020.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 May 2022 23:21:20.9795
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: EKG5glNXk8i9w5l+oucW9z4JLiD3FkX1wnecNIVdX6/sXH/fOdhSey7BlnS3TajB
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR15MB2773
X-Proofpoint-ORIG-GUID: UNEnUpNobIEanHGzELRt62s2z-I9S76R
X-Proofpoint-GUID: UNEnUpNobIEanHGzELRt62s2z-I9S76R
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



On 5/16/22 4:58 PM, Matthew Wilcox wrote:
> On Mon, May 16, 2022 at 09:47:05AM -0700, Stefan Roesch wrote:
>> This change uses the new iomap_page_create_gfp() function in the
>> function __iomap_write_begin().
>>
>> No intended functional changes in this patch.
> 
> But there is one.  I don't know if it's harmful or not.
> 
>>  	const struct iomap *srcmap = iomap_iter_srcmap(iter);
>> -	struct iomap_page *iop = iomap_page_create(iter->inode, folio);
>> +	struct iomap_page *iop = to_iomap_page(folio);
>>  	loff_t block_size = i_blocksize(iter->inode);
>>  	loff_t block_start = round_down(pos, block_size);
>>  	loff_t block_end = round_up(pos + len, block_size);
>> +	unsigned int nr_blocks = i_blocks_per_folio(iter->inode, folio);
>>  	size_t from = offset_in_folio(folio, pos), to = from + len;
>>  	size_t poff, plen;
>> +	gfp_t  gfp = GFP_NOFS | __GFP_NOFAIL;
> 
> For the case where the folio is already uptodate, would need an iop to
> be written back (ie nr_blocks > 1) but doesn't have an iop, we used to
> create one here, and now we don't.

The next version of the patch series will remove the 
	if (!iop && nr_blocks > 1)
check.

> 
> How much testing has this seen with blocksize < 4k?
> 
>>  	if (folio_test_uptodate(folio))
>>  		return 0;
>>  	folio_clear_error(folio);
>>  
>> +	if (!iop && nr_blocks > 1)
>> +		iop = iomap_page_create_gfp(iter->inode, folio, nr_blocks, gfp);
>> +
>>  	do {
>>  		iomap_adjust_read_range(iter->inode, folio, &block_start,
>>  				block_end - block_start, &poff, &plen);
>> -- 
>> 2.30.2
>>
>>
