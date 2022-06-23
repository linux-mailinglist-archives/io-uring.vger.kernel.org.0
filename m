Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 229A15589FB
	for <lists+io-uring@lfdr.de>; Thu, 23 Jun 2022 22:23:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229461AbiFWUXk (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 23 Jun 2022 16:23:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51350 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229451AbiFWUXj (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 23 Jun 2022 16:23:39 -0400
Received: from mx0b-00082601.pphosted.com (mx0b-00082601.pphosted.com [67.231.153.30])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 671865253D;
        Thu, 23 Jun 2022 13:23:33 -0700 (PDT)
Received: from pps.filterd (m0109332.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 25NK2snT022858;
        Thu, 23 Jun 2022 13:23:22 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=facebook;
 bh=/wyf08nnhx+lTZZEatVti4GkdIdwfJB5umk4uL35IQQ=;
 b=YXAK7I0xdMrRvif4/O6u9uKmewV3QqpEUG87Z0rK89Lhd9SltdDoj235JH5RYO4UXVg4
 mmUImOrT4Wr4ak2xO/NEnI/iEKuc7wPHFqhFGcs9luc+nsB3XRDEn9sdVYGM6Jq7T1Li
 ebj9O3lEKcVUjMjBBI/Mw7GS+RgaUNHl9Qw= 
Received: from nam11-bn8-obe.outbound.protection.outlook.com (mail-bn8nam11lp2169.outbound.protection.outlook.com [104.47.58.169])
        by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 3gvn943y1v-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 23 Jun 2022 13:23:22 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=cgofYBRPpNsd2ojAYhSEaqaScYhgc8D1yuOZQOfTvxT6gN1sUDOgf0+28fvlNKqZuZLrlV8dU5LWI9vjUFDe6GuS3m8PmaZ3ZF210rp/uu4aXs0znszCew9DAZzgZfTakLprTDhnL0YB7EKrukLSceJdK4oqieQRwnszN1MsrAbejTBFGpDtbAFRcAphGfvV22dsp+0VWsw48oLmFZIFpl0ll4dpCJ1E+x0ThzdcughpUo5ydRx3i+42+MUHhg9XuM0fYGMcOI9ybyLtw+1iIVkjLFRznMjGInUD6jaVtjOAH3YSrzRycBctJSG5vCaXwMimkM/uRV4PR8r5dkae7w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=/wyf08nnhx+lTZZEatVti4GkdIdwfJB5umk4uL35IQQ=;
 b=Bug4oFiEsLNTJ8n+uNt6BMMDPnlz7J2it+PzC4qckvP9oBEFz+u3DNobflYUUo8RPVHymzG8YhHVcOPV3JVn5e4IHpLxIRr6wQwCitEp8Vi97vSFKoXOtXzuydeVvnXxvBFPXqr4YozhQLLufFEt0bqRk2PRWjkbOAGQumLqvvpMiYDQXyFjPjFz7oRs3Jd4N9PIEWdKEoMIQ6PNKlzEXWTrDB8bwQXr2J6eKvre00K9m8YiOXSTiTLhQbUsINk9wbxxUhiyE+QQa/FLOsFIJuEOfAFt2FoywpYbJFt3K0xpXxWEzqTYvD0d1f4f2+QublcCISAcUaywsUS0phTTcg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
Received: from MWHPR15MB1791.namprd15.prod.outlook.com (2603:10b6:301:4e::20)
 by MN2PR15MB3678.namprd15.prod.outlook.com (2603:10b6:208:1bd::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5353.22; Thu, 23 Jun
 2022 20:23:04 +0000
Received: from MWHPR15MB1791.namprd15.prod.outlook.com
 ([fe80::e17e:e90d:7675:24b8]) by MWHPR15MB1791.namprd15.prod.outlook.com
 ([fe80::e17e:e90d:7675:24b8%11]) with mapi id 15.20.5353.022; Thu, 23 Jun
 2022 20:23:04 +0000
Message-ID: <1f121d1e-8a50-5152-d984-c9299ced1491@fb.com>
Date:   Thu, 23 Jun 2022 13:23:02 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.10.0
Subject: Re: [RESEND PATCH v9 06/14] iomap: Return -EAGAIN from
 iomap_write_iter()
Content-Language: en-US
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     io-uring@vger.kernel.org, kernel-team@fb.com, linux-mm@kvack.org,
        linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        david@fromorbit.com, jack@suse.cz, hch@infradead.org,
        axboe@kernel.dk, willy@infradead.org
References: <20220623175157.1715274-1-shr@fb.com>
 <20220623175157.1715274-7-shr@fb.com> <YrTKnzpfaaExxXAS@magnolia>
From:   Stefan Roesch <shr@fb.com>
In-Reply-To: <YrTKnzpfaaExxXAS@magnolia>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: BYAPR02CA0024.namprd02.prod.outlook.com
 (2603:10b6:a02:ee::37) To MWHPR15MB1791.namprd15.prod.outlook.com
 (2603:10b6:301:4e::20)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: b0a444c8-ca7d-4c4e-50e3-08da55562d54
X-MS-TrafficTypeDiagnostic: MN2PR15MB3678:EE_
X-FB-Source: Internal
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: tks3VMGRB0QI7GlhA/QeEk+9k4scNcuGk+qyIWiW9mN+KRKfMLPU/LFs5Xj/RkdWSFvwHhXB8E7v76GpZBIdbrD/w/NPKPPMwQE8ov80Jd8SYivF1Q+WiTz9DjrvEv13/3XS+5TRCFddFJE6CCwDdt3cM7fJCGBk+9WbGtpjrNrTmvL7w4kti/vcYc63GqOHLZFiJ5l7RGyI2wdEBG5K3uwU6cw9UH+oT4RU7Kfb+qB6J+f4X01jB4E9GaQtlC5pNKTS52YaPBl1z02Ij/pujfiK/+tSQnHvlIHys3g4H2kNbn2WeEz1uSH+PgAQyV4sPfaBwjoTbrTviFgHcskgEzug1FU0kvvpoed+GSKDsHifv/Da871vNTFmPUcq9cfAVKGdDYp/ZsOTZ1u4Bz5yk3JqGbKrvCyssRLImqcyOaKGFwaeF0Atglw5l0nBkZH52ooROMQTmEKxaGjRLzJg6TzyX26d2Ja3ubIs8slO4ynSlSPjyKmjMMYMMWDKdIVfY39Ewp0CaHcrGbMKFI0M+InXsY2CPQSCsAwZK21eJgSGtkFGJsBFtX1W9wjLmt9dmRRN3wE+cJQOEqq9e+Af+TtoIBIZfPkoLINlsrrQFa8YXilXvWcqkSsM6mvwWm2FDWZo///TYhXziySXctpcTtQu3s7H38ieL1NtrEobh5YpeN2nSz5LZJN+zgZKostJIl3XnonRK7PN3eHss0siF6cRg7cakxW+gGweJyAUGpdyjTZT47Gzq3tM8dzLkXh+g05QCXk4hYUo8WSfD4qpjhDkbA4B0jD5wsIzw7RARbCa8CyVeDNqMui/ColKmUGVaOcU2u22CQprCoFxWiVwaQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR15MB1791.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(136003)(396003)(376002)(366004)(39860400002)(346002)(31696002)(53546011)(41300700001)(186003)(31686004)(86362001)(316002)(38100700002)(7416002)(6506007)(2616005)(6512007)(478600001)(66946007)(6486002)(36756003)(83380400001)(2906002)(8936002)(8676002)(6916009)(66556008)(4326008)(5660300002)(66476007)(45980500001)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?V29vWDNDa0NzT0dVTHl2TXlNTjBMQVZialFzSk94c0g0RU5McTJZMnhhK0hs?=
 =?utf-8?B?ZUJSNTVmVllJQXQ3R1Y4STdHbTFKUlAxdjBIb1pSQ1hPMURtdnZlL2kxcHJq?=
 =?utf-8?B?SmlHYUZQRzRSaytWdUtKUms5NU9LMTRITE5CcmE3SmZPaElHK2xQN3l2RTNS?=
 =?utf-8?B?OUg4eUVua28xWDJSMlFEYjFRQnMrb2l2Ti9FUVNYUkkyZkx1VW5qNUhJTkxC?=
 =?utf-8?B?dWUwaFp5TVVVeEVuT29HalB6SXZjNWVBbE9Mbmk5R1BvcVZLZG5FaHVYSmE4?=
 =?utf-8?B?bUhWSGhIWk1nTXVjRmdtNVA4c09FL0ZOakJzZWVKa0xGSS9MQlJpL3lXdXhz?=
 =?utf-8?B?RkdZNEVCazF1Nm00b3IyTGJJbU1zYStYZnpoaHEvSjdmdVNNY25pWU1LRUFS?=
 =?utf-8?B?Zld6VVpiaDI1WFpKaHFXeUdiTlJncGkrY2dEWFBOenRRWldNQ09QSndiZGlt?=
 =?utf-8?B?OENmUE5hTTA1RlFTZXJHcThMUVdEbW90ZnV1NVgyVCtuN1FhVzhneE0yWGdB?=
 =?utf-8?B?RmVQWm45RFdzSEJteVVzMVl1OEVyUkJCYWZuWWtQaXgybytVRElLU3NwSUZj?=
 =?utf-8?B?WTVCakF6WUZlVWpVQzdyY3VxRDQvNEEzT2NRU2QybWREcHZKVzc5bzlQTTBP?=
 =?utf-8?B?T3NXcWdyTE45dTRQQjNqQnBybU5TSVZydHlsR0FobVE4a2htNWMzR2NEWUZj?=
 =?utf-8?B?MmRmamRnWmdFaytzVGNNajVpaTBpZkp2Q081aWdPUTRuL3dOaGI5L1VKN1RE?=
 =?utf-8?B?bGN4bCtXZGV4Z3lhQVZjNkI3Uk5XY0MxWFpSL1NpQWxaNE1YSW5ZeWJDbjBC?=
 =?utf-8?B?ZGY4U3B4UHpWaGhPL0ZOZndSYWM5SW9aOUQxb2trTDdGTkNkaUpBUld0NTFG?=
 =?utf-8?B?SENBUW4wYi8yaE1WQ0diNXhJTldGLzRpakY4NU96Z0xYQ2I3YnlEY1Z3am1L?=
 =?utf-8?B?K2Z6QmNBbkx1N0s3WjYvRkxJRktKZkR6ZG5QRzJlNFRSNjRJUGE4VkhyeWY3?=
 =?utf-8?B?T3lWbHY3MHhtTXY2amRuYWNMYncyVERJL2JhVjdHeTZaL3dZUDVvZEM4ZEw1?=
 =?utf-8?B?a25mZFcvWDJaZFhnNUFIUlc5VWRoQ2x6YlQvN1I4ZHhxU1RMb2hBaTF2ZWw2?=
 =?utf-8?B?WEdkeW5Rb293eEU0R0M3RXRVeTRzb2QxVU9vZTFOeUM1NXBOYjNkUTZGNWlk?=
 =?utf-8?B?dVR1Und4bS91cU10b1YxM3QyRGhHN3JGTVNWdEQxUnJZYWNJeW9EdnN1Y04z?=
 =?utf-8?B?aXJGcnE2b21uenQwVDhyM1JQb3RVSmZqejQwdkpPZ25BZUpqOExvLzZQWWFa?=
 =?utf-8?B?TjJ4ZmJqOUYySmNqdkNIVVlzalRuMGFxak5BREJLNFQrNjU2UlRtRmpaVTJy?=
 =?utf-8?B?ei95eHAvc2EwN3g1UnJZRkU2N1FIUEd1SnROV2IyeE85MDVZcXVKL2Z6R3hO?=
 =?utf-8?B?OFJyOEhiZVRvNHpvSFRZWHpDeTZUZERlcGtWVlBvak85UStYeTlCRTdHNkVS?=
 =?utf-8?B?V1ZZYVk4QTdvRmpBMzBHK2hoYjk4KzFPWG9HRXZmVVY3NDJzSmw4bVhBR2U3?=
 =?utf-8?B?eXB6ekR0ZjNrNjVaanc3OFhpREJqTE9sajZrYkxiWmNuaGc2OWF6bE5YNnZ6?=
 =?utf-8?B?bTZMRUFJb0dIaUlNYlFEdkV0b1B6L0RZYjhwZGVVc2J0VTJhMGpXVGRPT25C?=
 =?utf-8?B?RUc4MkNTQ2t5b1d3OXBwdENmeG1aUXhTS01nK2thN2RqSVJFQ3JsalYvaE5n?=
 =?utf-8?B?Z3JZa1dsS25pYnFMTUs3bmpmNDV2ZDlJQXlVK2VrckVkR0syUndhaEFrcVRx?=
 =?utf-8?B?QXhKMkpldzUyNDVXWnFhay92cFdGSFFHR3FEc05Zc25hZlcya2RwSGg1OCt4?=
 =?utf-8?B?REpiTGY3NjlZNVZSNTNkajBkOC90MXBkVmdwYndpWktMb0Rod3Q0NkdxT25I?=
 =?utf-8?B?bEVPNFl4UWk2eUh6RW4wbXRDNFlDN0gyOURyaEJtN2o4aStJZFIyUzJqSiti?=
 =?utf-8?B?djA4N0MvSDVldHlwYkt1OHRUTVRPOE5jeXRSMGFsYTBlZVlXT0dURXNxb2h4?=
 =?utf-8?B?a2QzNFJoVitOQnh5MWNJL01RejlGdU9mZVRBTHMrazdEcEs4OHRHZVBuZnlJ?=
 =?utf-8?B?NExYNXUzRE0wTzlvZSttRE1TMkhUOGR0cW9lWFR3N0xiK3p6ZnVyQmV2TEFo?=
 =?utf-8?B?WkxMdDM1Tm9qRG1BN3NoYWV2WXBRSzZNRlRLVDc1RVF0TDl4RGlIVCs4cFJE?=
 =?utf-8?B?bmxETUlCS1Q1Y3JGMHI4S1NnQnBCUTV1OHJGOUJMeWt0RG42Q0VoL1MxZDBK?=
 =?utf-8?B?RC9yL3JEZHVleDdxZDEramovNjZLTkFGZ0Job1R0cmJMQmFrcnNtbzRYaC9s?=
 =?utf-8?Q?2916bExeQVZ8R8S8=3D?=
X-OriginatorOrg: fb.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b0a444c8-ca7d-4c4e-50e3-08da55562d54
X-MS-Exchange-CrossTenant-AuthSource: MWHPR15MB1791.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Jun 2022 20:23:04.4113
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 7CSpUpmqonwRf0eD5VniGpGB74oV+bOEXaMsxeDdYFAPWb0fuqmq2xAUmCwefnCT
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR15MB3678
X-Proofpoint-ORIG-GUID: 4JfpokBitj7ybuaJNGmBsoRoF1f_qhKd
X-Proofpoint-GUID: 4JfpokBitj7ybuaJNGmBsoRoF1f_qhKd
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.883,Hydra:6.0.517,FMLib:17.11.122.1
 definitions=2022-06-23_09,2022-06-23_01,2022-06-22_01
X-Spam-Status: No, score=-2.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org



On 6/23/22 1:18 PM, Darrick J. Wong wrote:
> On Thu, Jun 23, 2022 at 10:51:49AM -0700, Stefan Roesch wrote:
>> If iomap_write_iter() encounters -EAGAIN, return -EAGAIN to the caller.
>>
>> Signed-off-by: Stefan Roesch <shr@fb.com>
>> ---
>>  fs/iomap/buffered-io.c | 8 +++++++-
>>  1 file changed, 7 insertions(+), 1 deletion(-)
>>
>> diff --git a/fs/iomap/buffered-io.c b/fs/iomap/buffered-io.c
>> index 83cf093fcb92..f2e36240079f 100644
>> --- a/fs/iomap/buffered-io.c
>> +++ b/fs/iomap/buffered-io.c
>> @@ -830,7 +830,13 @@ static loff_t iomap_write_iter(struct iomap_iter *iter, struct iov_iter *i)
>>  		length -= status;
>>  	} while (iov_iter_count(i) && length);
>>  
>> -	return written ? written : status;
>> +	if (status == -EAGAIN) {
>> +		iov_iter_revert(i, written);
>> +		return -EAGAIN;
>> +	}
>> +	if (written)
>> +		return written;
>> +	return status;
> 
> Any particular reason for decomposing the ternary into this?  It still
> looks correct, but it doesn't seem totally necessary...
>

Do you prefer this version?

+	if (status == -EAGAIN) {
+		iov_iter_revert(i, written);
+		return -EAGAIN;
+	}
	return written ? written : status;

 
> Reviewed-by: Darrick J. Wong <djwong@kernel.org>
> 
> --D
> 
>>  }
>>  
>>  ssize_t
>> -- 
>> 2.30.2
>>
