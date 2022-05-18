Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 10D6A52C76B
	for <lists+io-uring@lfdr.de>; Thu, 19 May 2022 01:22:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231152AbiERXWD (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 18 May 2022 19:22:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50160 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230058AbiERXWC (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 18 May 2022 19:22:02 -0400
Received: from mx0a-00082601.pphosted.com (mx0a-00082601.pphosted.com [67.231.145.42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4EBA519F83;
        Wed, 18 May 2022 16:22:00 -0700 (PDT)
Received: from pps.filterd (m0044010.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 24IN6CDG005613;
        Wed, 18 May 2022 16:21:55 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=facebook;
 bh=WNeIW+eGY/LI7E9I0LljzFm7qj9SrrTPHqzQJKNS1cU=;
 b=ZjTsHy4OhpFbVm9RsyppEC4jq8flstP1+X2fo+b53L3sIUudHnmG/s9d+yXaOWb5I6a8
 WyxfNQZKIadReN/3Qk7FoT1GBRzIk/VXU59uFQ7Wi3RNcMpIzwTLF8Pfouhgqa/msQz0
 oJHn/TmYL2xjSqoFS296tusJV7b8xf5aw5o= 
Received: from nam10-bn7-obe.outbound.protection.outlook.com (mail-bn7nam10lp2103.outbound.protection.outlook.com [104.47.70.103])
        by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 3g4ey1jybs-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 18 May 2022 16:21:55 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=XvtgMm9qg2OiNgBn0QO20Y9AEf5084o3SeT/qHzPODU5DgVN5Cn+j+LTFcx2GnWfsn1zlv/0BOzju/o0LeoqYdAnhtF8F5/D+FTfMW3MrY+rp0+xGFuoIybaMBb7zqINt2HSNYHk8rn5aLlWcS5eUg2dHKcY1sxH4f1sOY2Md5ucpNW1QoDBgomsbz2dZVsevQRD5vTErmDP/zqUCJLrrfj+hfyMCnMSZwVWwt4rJz25T1316kI5BKnyGpJqekKOT7GlcuatWSJ2u2cQ1Fsd5FY4LEDlyubi2AhE/p4PHpbmvrg3zmmD96COzy6Ld6biQ911qDT0tXXm5kG7twym0w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=WNeIW+eGY/LI7E9I0LljzFm7qj9SrrTPHqzQJKNS1cU=;
 b=B3s9Pza5S29/lbj1jNOYxTmHqI6dfdDd5kPXtOqyeSOVWRwpis9RFLy3yr8RQJCBU7v6WtzKzE82dlu8NBfHyIeWMT+7l7moZbQLSUL1ZnboVdXQ3bkrKVwEnCe6dJxMG5/O5JM5ZhcC+ixm/VB3E/TP3vTF//CjnRbLQBnC6OVxcw0i2V+GLZCwT2gPPXTl90TobCiOCQLax5dIKaorhJQLhFmSwNkF88EM1f/xK6WFdQjbj7m72+hOH8UnR9ZNVZr2UNU80p3wS90eMospYbQL8Wy8p6TBoB0C1XHdcSaoO+vo7MqRXOqOM/R59Fi9stE6rf4dyqHJJ/YMTyuBlw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
Received: from PH0SPR01MB0020.namprd15.prod.outlook.com (2603:10b6:510:76::6)
 by BYAPR15MB2773.namprd15.prod.outlook.com (2603:10b6:a03:150::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5273.13; Wed, 18 May
 2022 23:21:53 +0000
Received: from PH0SPR01MB0020.namprd15.prod.outlook.com
 ([fe80::ad90:787e:697e:3ed1]) by PH0SPR01MB0020.namprd15.prod.outlook.com
 ([fe80::ad90:787e:697e:3ed1%2]) with mapi id 15.20.5273.015; Wed, 18 May 2022
 23:21:53 +0000
Message-ID: <361ed617-fd23-ac83-e9d8-2f4179e8b857@fb.com>
Date:   Wed, 18 May 2022 16:21:51 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.8.0
Subject: Re: [RFC PATCH v2 07/16] fs: split off need_file_update_time and
 do_file_update_time
Content-Language: en-US
To:     Jan Kara <jack@suse.cz>
Cc:     io-uring@vger.kernel.org, kernel-team@fb.com, linux-mm@kvack.org,
        linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        david@fromorbit.com
References: <20220516164718.2419891-1-shr@fb.com>
 <20220516164718.2419891-8-shr@fb.com>
 <20220517112036.xln2r72wbhja2sro@quack3.lan>
From:   Stefan Roesch <shr@fb.com>
In-Reply-To: <20220517112036.xln2r72wbhja2sro@quack3.lan>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: BYAPR01CA0032.prod.exchangelabs.com (2603:10b6:a02:80::45)
 To PH0SPR01MB0020.namprd15.prod.outlook.com (2603:10b6:510:76::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 8af687ed-93b9-48f1-155d-08da39253133
X-MS-TrafficTypeDiagnostic: BYAPR15MB2773:EE_
X-Microsoft-Antispam-PRVS: <BYAPR15MB2773E8C5653EBA6FB1C18A71D8D19@BYAPR15MB2773.namprd15.prod.outlook.com>
X-FB-Source: Internal
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: /c7pMXVD/NVty5oeOSbiX3Xs+LmFzRtu7sqX+TbH5fHxvaXJvIjCt0O+45tLNsWSCxa56COFYzx2uF/YInkPlFh7oMH8ZLQXDuyldWX3FHjqhCKbXyAHGpTI54tCBUBVKrxj1yAHZR7SvWU9zKsliLUqPpXdSPkSKzUUrsJNzkg/kPXLvWm/nmI2o/tvDjw/1c4jpLeTt/Wvw0alv7A4EmZwXUsWTnFzSILhLg2dg6QzM2aeJ7WliK1uOryraSjaIGdcgaqPCEJUSTxkV/m2oNYxPqMMj5Oa1ojTnGbYZ/XstvsKxTbqH0Zqknb9w93xx6ni1vrM6cdN0/ch8DOCEU28clssSqaJZAO1Xu8blBh5iNWIbCH+auIP7paukWCByb6xVQRsSqV8cBX0Fkt7WZWyci8HVXjhFh5EgftHkAlCt4uOgjsF4HJMuKPmdeHWfMZoyKJ+vpV0OORYCZytZh/jwrJ9nyMwlHHXA34QhsRV148rxGyxX7D/ku4X5BdQpIR8Cl9Y3RIVktDwdmSW/S/KREr8aVT7ETW3Mv+QfGfNmKpWFvZD7wMe5inicffgHr8Z532YhC5/KLcbQ46QuwB3nrXI5KfVJxuruu/zzM7KzpCg2C3923IuFO6w+k91wql+0JZTovgnBBA9W1pH0hHdqqJJL6QL4OxV1xi0JM0pOuCRkST/4dAxq+qIwz2Sa8ATc+fId1e0b8fOdwAEEuKwnA+L4A1CBA44ZMdNrss=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0SPR01MB0020.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(53546011)(31696002)(86362001)(6506007)(186003)(2616005)(83380400001)(38100700002)(2906002)(8936002)(4744005)(6512007)(66556008)(8676002)(66946007)(4326008)(66476007)(5660300002)(31686004)(6486002)(6916009)(508600001)(316002)(36756003)(43740500002)(45980500001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?eFVOWTUzSGttVG0wOVBaUDdlNGNFQ25uVFM5bkI3Q0tRZisrOHZEWWdVbTBt?=
 =?utf-8?B?Ky9NOVdYWGlBTXhKc084N0FaTHZManN1bURYNWdaUVZid05MRWJqNDRuYitR?=
 =?utf-8?B?VnVRYUh6NHl5VEM5MXRUaVRhWXFUNEp4MDBiaHZqaFFkZDd0eitINEJRa05Y?=
 =?utf-8?B?ZkQ2Z2RlTzZlb0dleiszSGROK1Fvbm00dGpKN0V0L2pmcDl1dmFtNXcxeUNS?=
 =?utf-8?B?a3psanhXTTdyRzNndGJ3MGl1MkJBK0V0MEQvZmJTL3VOWEpQOCtraTNXSW9C?=
 =?utf-8?B?TnNxWGIrdnM1TzRHcm1xdnc4OUR4T28yUDJmbFJJUXI5VG05RW44NWt4ZXdl?=
 =?utf-8?B?TVNJb0p6eW9HUmhEMnBnb1lUb3d1MDJhNGlway80a284N0pLc3BKeWVRaXlM?=
 =?utf-8?B?ekZVMVJ5T3VHelVxcU5kQ2FpZGtBdVRHZ2ZjVW5LY0ZBTStURG55QkdRUHlq?=
 =?utf-8?B?K0dqVWVCaWdLTzhNU3RYbk1wSjlrS0tjNzJjRmR6cVY2Z1hpVmNiK3VSTm9Z?=
 =?utf-8?B?MEZzU1p2Q3ZPZC85WVdFc1NLSlJzcVJIcUh0RGc5dmNsekhSNTFnT0ZZZHhN?=
 =?utf-8?B?SUtQQWF1d0F1OUlvLzkrTnMrOFFySTZOMHdhTmZrczliM3JjV1ZmbzFyZFg0?=
 =?utf-8?B?MHJYODFIKzRJN1h2dGFHOTduS2w3THRLbS9hVDlsejNyNjFET2NsdWVlMGZN?=
 =?utf-8?B?VUxaNmJWVUhpSHBQanQ0SDJZS0szTTJIeS9vOXVTd2tMd1pFZ2tyRjNTaHQz?=
 =?utf-8?B?WVlhYWxWZnIzUldnbEFlcjF0ZkUxZFk2UG9wcmI3cDN1V28vcnVXRFhkQk9W?=
 =?utf-8?B?YkFrcXVPQ3BKcDF0NDQ3RkhDYkE0ZWtzY3F5R3hiVm1BcktkcjNkSkQrbEo0?=
 =?utf-8?B?citBMXYxQXhIZWVVNm4rMVJzZ1FLZ0U1OWs3NTVoaVUvK0ZjK2E1V3QwSGZL?=
 =?utf-8?B?dWlIeWM1UHVDd1lhU2UxMEtuaVlzNFFQaGQxdFFjc1FvRm4zeStVWXZGTVM0?=
 =?utf-8?B?SUJuRU13eE9nUEJEMzlBRXB5amRTbTJVVklnaGkza0RwWjUrV3dIdjRNOFFz?=
 =?utf-8?B?cjNrcStJSzdLNzNNbjMrTlNJdng5LzVyc2VjcHU2b09ET1hscUFKaFpkQWJt?=
 =?utf-8?B?eENvaHNwWk5jM2MvZ0UyWWN1aTJIOFQyNWxWTkJyR3FqN0NNdzdPaXdTZ3VQ?=
 =?utf-8?B?eHFOcmtSRDMrNzZPYk92d0gxdnJzc3lCcHR3U203N0JhM1VZdFhCL3grSCs0?=
 =?utf-8?B?c3ZPdXpuMmpWMjVoNldsM0c5dmR2dVNIdkRmMXRJNWdPZ3VEbnFlYi9MMDMw?=
 =?utf-8?B?QVJoN2s5a2p5YUszRlFpcW1TUWdNdmE5YVNWb28yMTZJanNJaGlMc29qa3pZ?=
 =?utf-8?B?UVFJaDNUTEg0SXQzdUhTUmgzbHpYZEkxb2M1VW85S2MvUHkvSTNGelovMXI1?=
 =?utf-8?B?QmhIMCtRRE5MY2UzcGNybGc0QTMxVHcxekx1VEVmaEIxc3NNc2E5cGJ2Skoy?=
 =?utf-8?B?OVNPemRRdE1KR1hPNnRjUDgvaUlrUjljb1B0bUdsYzVHc3VuTWcwemcrL1VD?=
 =?utf-8?B?WGJueEFNOVpoVzhIM3J4dHA5ZXEraHVSYmFxR3B5Z2pNUUg2L2Z0NldCUjFE?=
 =?utf-8?B?UncwTWRMenBJeWZ1aFZRRWcxeW5XOWg0R0ZqT1lTaWVTYnczUTNrbE81TTdC?=
 =?utf-8?B?SVlhVnNobGFLbGVrckJXWjUxT1VpNm1SMEZ5RWpBa3puNkM1VHBXZDduSUt2?=
 =?utf-8?B?S3kwZ1hmendLeS9LcllhczlFb1FkUlhQR3dIRExabVdwWDFObHJWcUZJQ0ZO?=
 =?utf-8?B?NnN4cWNjQ0hnZUp2TFRoZnBOUnNEVDRnc2dOUlU4SWowdXl1NnVZMkNIMmcr?=
 =?utf-8?B?dUhZQXNCOXVPdGZIbTNRQUJHTlNQTWtmTWVITUZ3Q0xEM2RSTFp3UkU5eDJH?=
 =?utf-8?B?VDlpMGdITHVrbEpIYUFzdVJ6R2NodUFPQTcvcUcxeGtkSDlqeHZFK3hQKzF4?=
 =?utf-8?B?aC9ncTZ6YUpSTGZNUW1mMXFvMVdHbmtsM1N5Q0ROQlhnK2NTSlZET2hqQVJR?=
 =?utf-8?B?N0EvVDhMVndmVVhPL2xmMVRvSDdBSzZ2b0lxcTR4dytJeU9rcDl0VDdYUUs5?=
 =?utf-8?B?TEU3czBZOXN3NVNEdnZOeGt3cG5Ra1RUV2tNUE9vV3BhdlBDeGNNM3dEby9C?=
 =?utf-8?B?dkM5TldlWXEyeTFHRWJyL1F4RTUwRlI4djhZNlZQbSt5emgvZXphT2J4L0lZ?=
 =?utf-8?B?TFNRR0x4RWl6UmNwVmdGc2RlOUpYdmN0WW94dEdVVU9EajRQcFJKcUNVZW1j?=
 =?utf-8?B?eVEzOVBCL1N0OUZjdGlKZ29yVXlESDkxTVpMSmFPTjhuVlhGOTR2RkU3OHJl?=
 =?utf-8?Q?IOnv7pqL4c0AKDoc=3D?=
X-OriginatorOrg: fb.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8af687ed-93b9-48f1-155d-08da39253133
X-MS-Exchange-CrossTenant-AuthSource: PH0SPR01MB0020.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 May 2022 23:21:53.0069
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: bkfGE3vDWwZBtpBsvz96b7y49jtB2/Cmdos9RP+zLm2altqMW3K5/09Mvfn/50d6
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR15MB2773
X-Proofpoint-ORIG-GUID: CzQRmliENDu-A5251U5rMtfRhmEfcXI_
X-Proofpoint-GUID: CzQRmliENDu-A5251U5rMtfRhmEfcXI_
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



On 5/17/22 4:20 AM, Jan Kara wrote:
> On Mon 16-05-22 09:47:09, Stefan Roesch wrote:
>> This splits off the functions need_file_update_time() and
>> do_file_update_time() from the function file_update_time().
>>
>> This is required to support async buffered writes.
>> No intended functional changes in this patch.
>>
>> Signed-off-by: Stefan Roesch <shr@fb.com>
> 
> ...
>> +int file_update_time(struct file *file)
>> +{
>> +	int err;
>> +	struct inode *inode = file_inode(file);
>> +	struct timespec64 now = current_time(inode);
>> +
>> +	err = need_file_update_time(inode, file, &now);
>> +	if (err < 0)
>> +		return err;
>> +
>> +	return do_file_update_time(inode, file, &now, err);
>> +}
>>  EXPORT_SYMBOL(file_update_time);
> 
> I guess 'ret' would be a more appropriate variable name than 'err'.
> Otherwise the patch looks good.
> 

I renamed it to ret in the next version of the patch series.
> 								Honza
