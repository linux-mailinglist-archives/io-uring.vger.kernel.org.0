Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E064553C026
	for <lists+io-uring@lfdr.de>; Thu,  2 Jun 2022 23:01:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239270AbiFBVA5 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 2 Jun 2022 17:00:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50184 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239122AbiFBVA5 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 2 Jun 2022 17:00:57 -0400
Received: from mx0a-00082601.pphosted.com (mx0a-00082601.pphosted.com [67.231.145.42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 577E034BB6;
        Thu,  2 Jun 2022 14:00:56 -0700 (PDT)
Received: from pps.filterd (m0148461.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 252Js2rN022588;
        Thu, 2 Jun 2022 14:00:43 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=facebook;
 bh=+i2TFujPT+nZ3p9UgufwtoaJU/KL/fM8rRq8kEt8aOk=;
 b=hOYIusZDLMQ/CboOmP/oOy6WiFq0eoOfEDOBwY971zCdhuTjOUR/22vgxtguBfQnnKDg
 fLyzHE33h3eWhuNnAECRzUSG66idwJGXoABdG+ViseV9WkQOMd0RUhmgYrk8LAvOMAUu
 DC+cRBo9Oox4USgnce+cST47iMHcQcNTvTc= 
Received: from nam11-co1-obe.outbound.protection.outlook.com (mail-co1nam11lp2171.outbound.protection.outlook.com [104.47.56.171])
        by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 3geubauuh7-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 02 Jun 2022 14:00:42 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=bbVrYpQiPNW4mU4oHswebdKIsJPr38X9ABTQjBBpq1KwSVnEl0b2i4Qqk6qNjyc8Fy1ikcQJ5iTXQhpBlZLaHTE6JaQPsaEh38QuPv/tcbGluYe71meHxUqaaITYPAQcv1kw7CVb5fx4B2OaTvhsSdT5tqDIkE/ZHC/5ynCh+eHOKcBBRfgQMqznU8qwJFHLS46hmfQzFJEgD+b5J6MVijYcil+0EMqkj+5t1HiVB+2WUOZ5BvqsKQu1nG2oSDuwfKxoczhA//kk2VQDpGjV4/+06DddqB+UlpHGIT5KYVOBsFoXNBTKRXXnFSu0UuVWLu3GtHbccxNFselVxyKxIg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=+i2TFujPT+nZ3p9UgufwtoaJU/KL/fM8rRq8kEt8aOk=;
 b=Pu64goyR6mxIi1h6AyWk3lKwU6JidrxzJqJS/qZoltnN3jmzr33XAC+iRESg5bH1RQsVYVu3evGdlDJhzI7FlAPIJSnaZycmrpBKYG3v6qz0KjUWkdtiGVLv2XKJ4Aq5gY/DMCLVAbJGOJKeY/jzL0bu6EQ/nDVHuovbt5Wj3M6MZhpTqVFMeKwpCbBWDC6AXm9EUK6qQxOywmUyY+1cW/DDg75CoP1tayTEXIMmn5MAW6MMaVnAVJBGhSkwVZymHo0Nnz8KlJ1BaQH014F8g/O8ujMYF4DQqJvlM/pKY3pZETkqRfdrKNvE6Lr0wZjANXXhipxoGZPczXckFm4cHA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
Received: from MWHPR15MB1791.namprd15.prod.outlook.com (2603:10b6:301:4e::20)
 by BN6PR15MB1636.namprd15.prod.outlook.com (2603:10b6:404:114::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5314.13; Thu, 2 Jun
 2022 21:00:40 +0000
Received: from MWHPR15MB1791.namprd15.prod.outlook.com
 ([fe80::e17e:e90d:7675:24b8]) by MWHPR15MB1791.namprd15.prod.outlook.com
 ([fe80::e17e:e90d:7675:24b8%11]) with mapi id 15.20.5314.013; Thu, 2 Jun 2022
 21:00:40 +0000
Message-ID: <06c41c2d-4265-3dad-ad97-755ade33a8fa@fb.com>
Date:   Thu, 2 Jun 2022 14:00:38 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.9.1
Subject: Re: [PATCH v7 10/15] fs: Add async write file modification handling.
Content-Language: en-US
To:     Jan Kara <jack@suse.cz>
Cc:     io-uring@vger.kernel.org, kernel-team@fb.com, linux-mm@kvack.org,
        linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        david@fromorbit.com, hch@infradead.org, axboe@kernel.dk,
        Christoph Hellwig <hch@lst.de>
References: <20220601210141.3773402-1-shr@fb.com>
 <20220601210141.3773402-11-shr@fb.com>
 <20220602090605.ulwxr4edbrsgdxtl@quack3.lan>
From:   Stefan Roesch <shr@fb.com>
In-Reply-To: <20220602090605.ulwxr4edbrsgdxtl@quack3.lan>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SJ0PR03CA0210.namprd03.prod.outlook.com
 (2603:10b6:a03:2ef::35) To MWHPR15MB1791.namprd15.prod.outlook.com
 (2603:10b6:301:4e::20)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: cd8ae5a3-5e2c-4883-1a62-08da44daf37d
X-MS-TrafficTypeDiagnostic: BN6PR15MB1636:EE_
X-Microsoft-Antispam-PRVS: <BN6PR15MB1636C43A2354B9A0EFABFD9CD8DE9@BN6PR15MB1636.namprd15.prod.outlook.com>
X-FB-Source: Internal
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 0MLfAQXQ1Tk1TxlXnLVP6RQMqxvB8LGCQVhLJzYD3Bw/I7FHD7BFAvN5B6tMHE62zIR1vWtqIPwycDFJggJ/YviMBvonS8gBXaNV9lwdcGH63Vu79+PkgKcG+vr6+9YUzplI90KaxmLHyL2sji/b6Qj54yPZR4BtB7o7Y2kgypu368J0JsqyUIxYXew3ktt4y/rmyaa8P1B1KftndEXoqTJcLiIBhdl3focC1oeZkiBx0LndbntII34xkompilRBL0sHDtyleg3pVUr6mI9WpccmM5brvE3HfAZ9+DggBBXhlB57Gfnv+uT8go2xi3l1RpguwQateOjInhvnkQ6dX9HhEUscsGb9jnMqpe0vmgbEraj5SehFgeDGX9PcSoraKTqLXfbeCWHf0mYUSQdW4BN6FulZSSvFSstLP5vWUTWuyyDxIseXjhKk+z6uKg4GaHfRtECmEoR57oFfuVVQhLEsvcKLgmBScKgOf7+Tx3xz11n/PVSDTI7BeHOaisRK+vQf+xt9AXyOLegti0GWj4pDGGG9MsMUI+4mMgWKHOaxzuhBWVOHmw40a9uznQjhvFyzHUuBBUSGgrbw7cX/tXWY7Z6rxlYZOOUDcWzTh74TIZVN4uqbW9nczjMw79CA/Wn0Z2KrSc2tjso9weRItgH8a4LH1Vqw5rd8/uTlb2aw2enn7aqPDTw1z6Osvj9uxx0ZWklUgD42DIcMsubnh1QIoWARiwnTVyjtVESEI+Y=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR15MB1791.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(6512007)(6506007)(53546011)(66946007)(66556008)(38100700002)(66476007)(2616005)(31696002)(6486002)(86362001)(316002)(508600001)(6916009)(186003)(83380400001)(5660300002)(2906002)(31686004)(8676002)(4326008)(36756003)(8936002)(43740500002)(45980500001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?UGZpZzNubnVXaG8yYzJYa2lKVk9rYjRmT2o2Z21DSStXenJsaWVGVi95VUhl?=
 =?utf-8?B?ZXpSUkF0K2xJQmE1WXFpeTFYTzNRclY5UjlWMzdnMmZLeDlpM2o1RWEyVEt3?=
 =?utf-8?B?WDFpWDNiREphYXJEYmptME9XR1c5WXhDUWhHNm5VYkVKaWk2RzdWMHRIbjA3?=
 =?utf-8?B?Yjd5ODViVEh5M3RZQTVnN3Y3dE5vMFVxV2sybmovZ1pnWjludC9TVXFBcjJi?=
 =?utf-8?B?RVRTRzhqZDN0SUNvRm5odHFPdnpsK1lOQmlzeUJMamlabW5veGlkUkhPV0VQ?=
 =?utf-8?B?RkZYTlJGdEZ3T2lPTWxQLzhaaWtMWERMTHNuWVpJbGJoV1JqTTdXSDRNMTJU?=
 =?utf-8?B?TS9ZaldTNnZPc3dUdDlSS294SWRoVGtBOVM3WG4wUW5hNEIxTDZOZU1YL1Mr?=
 =?utf-8?B?RXpRajhMUy83Yjk3elhMM21MSHh0WExTem9LbittNFc5Y2VCWTEvNkd5QVRn?=
 =?utf-8?B?YWQwYnRCU2pWRW42S1RJY1VFaFllRDNrWmNSN1ozWllrK3NOWEIyVTduakx6?=
 =?utf-8?B?dC9Bb3BtN215TTFjaXNJSC9ML0h0T2h6TTJySmlrU2pLeU84elY5OWY1c1VR?=
 =?utf-8?B?WGgxZWNrL2QyZ0JkNXpRQTJBQlBOOGVFZkJqdTJ1c0poWndqOVRURS9PRXJ4?=
 =?utf-8?B?aDllNFpDczN6cTVuM0RaTWJYdS8vUGZ1ZjVRY1B2TWp4Y253TnhGcnBub3No?=
 =?utf-8?B?OUt3Q3l2cmdPcjlwYWxRV1MwMStwSlNSYzNkSDgxSTh3QUFldzlsaTJOMW9Y?=
 =?utf-8?B?UmFlM05NRFhzUjY1QTVxbE9EekVCQUxWbHNXYmhkUFlGOVlvcXZPL0w2TS95?=
 =?utf-8?B?THhsZ0NFNStSaFliN1UrL21WOCtBQm5RbzNkbDZSSURWdnBsTjFqdnZwRlVX?=
 =?utf-8?B?U3pkbVEyd2piTk5RVXlFSFdyeEhVNkNQMDArTlg5eE1vdDcwTlFTN29PRWNK?=
 =?utf-8?B?RGF3VjhKMkVheENtM25Ia3NDODdDL1ByVldDRU51bUhDdHo5MUFHZ1daOUo5?=
 =?utf-8?B?bElveEovSjZkQXp0eEE4MjNFTkhMa0dKUDkvUmVpdloveXU1UlJ4WkJnS3Ry?=
 =?utf-8?B?a003eDBWbjZmVzdTUEpZazlWU0ZkTFFIeUphRWVTOE5qNXZMd1Q0T1lPRCtZ?=
 =?utf-8?B?NDB6eDJzWG5IbzVtUGFiNjNWMHJMdEZESkhKaCtxMmYzUGZFOStXbE5GTnlB?=
 =?utf-8?B?dzBVbi9PQk94K1JUZDd3MFdaU2hJV3hMWUlxbmsxY3BjZ0JiNW4rREtKNjd5?=
 =?utf-8?B?TVd5dnVMSnVZOGc2TzJWamF2WlpDd28vb1FXZ20zVURNVUxBQ1UybTBMQTNY?=
 =?utf-8?B?SmtTbjRKN1Q1VVRvTjVOY0h1VmM4QktPbnVyaWhhd3c0dUF0U2pBTFRIeG9P?=
 =?utf-8?B?Ryt4VmVIYWR2NTVlZnFtdVRaak9Pc2s0czRkd0huUGg3dUI4SGh2eXdES0RG?=
 =?utf-8?B?RHZMaVdJdEp2a0tHVXo1NEMwOUNjYjIxRWR5a3VRRUg1TXROZWRUWDlaL0x0?=
 =?utf-8?B?OE5obkU5L05NZkV4a0dIV0o4clFXckUrR2tUNGhpYU9vMVZ2U24xRUE2cmpT?=
 =?utf-8?B?TkdyL1U5Nk4ycDVsSmJFMFhBTk5udVBBRS94WnZGRHpSRGdTWHVOVGhja0NE?=
 =?utf-8?B?Z0ZMYnByU3VDdlZTYVBWNldadm5SUkEzUnVKZEN0Q3JCQjRVRzJVV0QyaS9C?=
 =?utf-8?B?TjZZTFFrTklmYXUvZDVnL2tDZ1RMUWRoSnRSbVJnT2F6dnY5UUdQUVdQekZS?=
 =?utf-8?B?SE1LTlNVRWJVbnBpVmtpbld3WHFYTDhIaG0xbUtjU2c3L3ZFSjR3cDc3UTNH?=
 =?utf-8?B?UGFhMTNJZTVrYzJxek1mWk9WbUUwbGdLZFFxOW9lMy9OTXZZZ0pHMko2L1k3?=
 =?utf-8?B?RVB3eHBVcXJVUGJMWVZmTkFIY0RZL1pqNXlkbmNYS3p0aXVKMWNhdXV3RGNl?=
 =?utf-8?B?bGdiMHR2ZTVCdVdkUEFabjdNYXluZUlRUWdseDkrMnIzRkY4cE8wUksvVDRx?=
 =?utf-8?B?MWdwY1R4NmFLckp0RkR0QUZ0SVU3UkRiQlU1TnU3V3ppTjdGeGlVbmFzUmRJ?=
 =?utf-8?B?WisvM2svQjc0QjZiWnlvUGtFOEhHZlZZTEdWbXQ0cHJyKzRZOFpua3F1ckg4?=
 =?utf-8?B?RlEwSzIzWW9ZTjBod1ljS3lwSUtLNHBZUCtVSXM1MWFIYitBb2F0OVE5UkRM?=
 =?utf-8?B?cVYyUjhUU0FWZHYvN2xrWXNPcE9KNmdGVW1iQU5oWjJWY0szRmtGQkJxQ3Fn?=
 =?utf-8?B?N25QZ2doVWR4MjJJTENvTHNlQ05RT0ZqYXo4c2Fseml2eVhGVitwZDhFNmV5?=
 =?utf-8?B?WXJGT0RQQUhkZmlJOGdPbjF4NDF5RVZGRlVoYzB4K3ZiUnJHaGVSOThnWnB1?=
 =?utf-8?Q?VWjzDxJ0yvVRd8wE=3D?=
X-OriginatorOrg: fb.com
X-MS-Exchange-CrossTenant-Network-Message-Id: cd8ae5a3-5e2c-4883-1a62-08da44daf37d
X-MS-Exchange-CrossTenant-AuthSource: MWHPR15MB1791.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Jun 2022 21:00:40.6686
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: tmWK0o3OiqAyYmo9gslJU6Se8V6kmb0LRRIzrkkjJKab71uyKpTZXdIzPytx8gNZ
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN6PR15MB1636
X-Proofpoint-GUID: ingbLuonlnynJUQXrNCd_LHVJCfQuWRd
X-Proofpoint-ORIG-GUID: ingbLuonlnynJUQXrNCd_LHVJCfQuWRd
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.874,Hydra:6.0.517,FMLib:17.11.64.514
 definitions=2022-06-02_05,2022-06-02_01,2022-02-23_01
X-Spam-Status: No, score=-6.0 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_LOW,RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org



On 6/2/22 2:06 AM, Jan Kara wrote:
> On Wed 01-06-22 14:01:36, Stefan Roesch wrote:
>> This adds a file_modified_async() function to return -EAGAIN if the
>> request either requires to remove privileges or needs to update the file
>> modification time. This is required for async buffered writes, so the
>> request gets handled in the io worker of io-uring.
>>
>> Signed-off-by: Stefan Roesch <shr@fb.com>
>> Reviewed-by: Christoph Hellwig <hch@lst.de>
> 
> I've found one small bug here:
> 
>> diff --git a/fs/inode.c b/fs/inode.c
>> index c44573a32c6a..4503bed063e7 100644
>> --- a/fs/inode.c
>> +++ b/fs/inode.c
> ...
>> -int file_modified(struct file *file)
>> +static int file_modified_flags(struct file *file, int flags)
>>  {
>>  	int ret;
>>  	struct inode *inode = file_inode(file);
> 
> We need to use 'flags' for __file_remove_privs_flags() call in this patch.
> 

I assume that you meant that the function should not be called _file_remove_privs(),
but instead file_remove_privs_flags(). Is that correct?

This would need to be changed in patch 8: "fs: add __remove_file_privs() with flags parameter"

> 								Honza
> 
