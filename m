Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 374BC477942
	for <lists+io-uring@lfdr.de>; Thu, 16 Dec 2021 17:35:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232386AbhLPQfU (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 16 Dec 2021 11:35:20 -0500
Received: from mail-bn8nam12on2068.outbound.protection.outlook.com ([40.107.237.68]:59424
        "EHLO NAM12-BN8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S230441AbhLPQfT (ORCPT <rfc822;io-uring@vger.kernel.org>);
        Thu, 16 Dec 2021 11:35:19 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=kHOo5BHf+GlTG1WLqqe3FXU0I22KNEJ8BCOF30Jf8dY/iKnnKsNU4qHOSwv+DTiVIsHxd9mWTQ4YyYHFM9o6kH33BJ+HXsC4ni3LVAvDXQTpIq1B/rCLnPhzWvF4GkSyjpfMPoPlxHR3qFBW6V+cca+xDGyhVVQxnCVZiCl3gCrigPN9Dhtdvp+It45xGHir5mE2EmVgStKC1tfUkhf23avyKpNwbhmcFQ3ttAstaPyaqkf4m/sxB1fKGV4Lj4hZfeTNOITnsnyXiZS3miuh8BXwb6fqH4JnlyRY8B0KsB1lgwmSRse/BQzGFw8VEsgGx7A1xVx+APprRzIsLYAiew==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ISUEGCwICVsEHOwPsDIbK2BPUlO/kNJBCKdJ2+towZE=;
 b=b909zEnQbN74NyrLfg42mMISZcw5enllJ4EJfLSTE+pby7IgN6ohZE71KsVBFoQ666ahpodWzaqS3xaf7w75v9/v16kvXdm/G8OTOizoCdNDJJSveMAl1HnMTmiX18dXx3uF1zGyYF7PpIdChATqnh/wpnI1ksCvmCAnC/ZLQboKzwvXOSHCbLVGx3HE4wYHasUDKTMq3qrrc35M5jl1Mc1SHTi9TQiKcwUACm3EZcjFlax/tYg7322BthZCspUFMcemDqOjPOPeCP/JEJHWVMC9H9f+MZBUCAd/HszseAOHzGhRekVq40i4DHJNMctz+Gj6uXtydHr/pSMKXQyRpA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 12.22.5.238) smtp.rcpttodomain=lists.infradead.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=nvidia.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ISUEGCwICVsEHOwPsDIbK2BPUlO/kNJBCKdJ2+towZE=;
 b=J7QuJ7UwvZqBwps4BJarNCdZa6IvxPBvZ+Lgp/ZBgz6InzO7Xq8GoXx31rQkuNdUj8a+3gLWJ2QVPsws5R7O2pikhuvBSNz6b6Zi58YdMeTc/MNI1Bb9qZpylpZzw/u8NYVVnGbAqbAokBdiKq9XcINEDsRVdFfTjdXY/PtA0d2AW/57n8a1eg0PJXXTr/Lsc4NwK5hkhx9d6C51y45KI3Pw9Rz3t6MjnjTSs+Hp6qkNUJhsPABkunaJ0nYh4JJOckCo3ZmxIjTm0TzWW9UXBFGxr1dMMMqQnqhtDh+YSIT8kZekzzDreIQBo6yF75cXAKiv8HLILrRLR6rM28uFRg==
Received: from BN7PR02CA0003.namprd02.prod.outlook.com (2603:10b6:408:20::16)
 by DM6PR12MB5007.namprd12.prod.outlook.com (2603:10b6:5:20d::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4778.16; Thu, 16 Dec
 2021 16:35:18 +0000
Received: from BN8NAM11FT009.eop-nam11.prod.protection.outlook.com
 (2603:10b6:408:20:cafe::69) by BN7PR02CA0003.outlook.office365.com
 (2603:10b6:408:20::16) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4755.14 via Frontend
 Transport; Thu, 16 Dec 2021 16:35:18 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 12.22.5.238)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 12.22.5.238 as permitted sender) receiver=protection.outlook.com;
 client-ip=12.22.5.238; helo=mail.nvidia.com;
Received: from mail.nvidia.com (12.22.5.238) by
 BN8NAM11FT009.mail.protection.outlook.com (10.13.176.65) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4801.14 via Frontend Transport; Thu, 16 Dec 2021 16:35:17 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by DRHQMAIL105.nvidia.com
 (10.27.9.14) with Microsoft SMTP Server (TLS) id 15.0.1497.18; Thu, 16 Dec
 2021 16:34:45 +0000
Received: from [172.27.15.177] (172.20.187.6) by rnnvmail201.nvidia.com
 (10.129.68.8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id 15.2.986.9; Thu, 16 Dec 2021
 08:34:43 -0800
Message-ID: <3474493a-a04d-528c-7565-f75db5205074@nvidia.com>
Date:   Thu, 16 Dec 2021 18:34:40 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.3.2
Subject: Re: [PATCH 4/4] nvme: add support for mq_ops->queue_rqs()
Content-Language: en-US
To:     Jens Axboe <axboe@kernel.dk>, Christoph Hellwig <hch@infradead.org>
CC:     <io-uring@vger.kernel.org>, <linux-nvme@lists.infradead.org>,
        "Hannes Reinecke" <hare@suse.de>
References: <20211215162421.14896-1-axboe@kernel.dk>
 <20211215162421.14896-5-axboe@kernel.dk> <YbsB/W/1Uwok4i0u@infradead.org>
 <2adafc43-3860-d9f0-9cb5-ca3bf9a27109@nvidia.com>
 <06ab52e6-47b7-6010-524c-45bb73fbfabc@kernel.dk>
 <9b4202b4-192a-6611-922e-0b837e2b97c3@nvidia.com>
 <5f249c03-5cb2-9978-cd2c-669c0594d1c0@kernel.dk>
 <d1613b7f-342d-08ad-d655-a6afb89e1847@nvidia.com>
 <a159220b-6e0c-6ee9-f8e2-c6dc9f6dfaed@kernel.dk>
From:   Max Gurtovoy <mgurtovoy@nvidia.com>
In-Reply-To: <a159220b-6e0c-6ee9-f8e2-c6dc9f6dfaed@kernel.dk>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [172.20.187.6]
X-ClientProxiedBy: HQMAIL111.nvidia.com (172.20.187.18) To
 rnnvmail201.nvidia.com (10.129.68.8)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 862be719-16c6-4433-facf-08d9c0b20b84
X-MS-TrafficTypeDiagnostic: DM6PR12MB5007:EE_
X-Microsoft-Antispam-PRVS: <DM6PR12MB500700DA402E000C47DF9910DE779@DM6PR12MB5007.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: irSGNZ2jOYVEbigzjGVcPQCoq09bySa20XStDDZ0GBFXpqH+a4cy+pxU47utRNi5dRN1R6937kucIueyVLQ5U/XJBWzkTdCo140XNFT6l5m4BNDpIjmDgn7eqTO8F0uzDs+K0d3uoQnHSgBW46l1mIkiUmTGVR8K+Bv9UyvSNfj9usSkt30D/dHtO8a9CO7ddjLqlyzeWGnT7GVZawkXBltsEV+1sBdsY3OadnYYE+Lb497KPfMSN0CbYClwmbqg4+QwL8dCtcburlInAUNRVaHBjr/o5rnPN+e1H1UUy7ucdmTnrfO0xYb0QxnZu8JdizKtVvvqpW4vc9HiJavBttQuGDql7xMS0fjF/JkRcWI2OM5fpyUM/g8qrYgFOAyeGF9xxngUl2zuLZ1A+JPLdG/3vNXPM7M/jmECLdUsVSqHldcM0cAHDzLo5MJCIKmqJp9aBeakCZJck3qXHlGnKbnUSBz81tCMjgZ5kq6zbzRjBE81eOugTcXARVf6UBRCQhsHkPuw//dc0m9UdkyWqkIuyu883K2unrZxiDbkJqauMpscX/n5xFYjTW1wVIaRLX2zNpYoA/GQvZI04xO9fmzfgQPXsdjslOgV+jtu4wgFXRmYHxYgZDrXZmZeVIaf2FP+G2XueV9xz5nNYwYkc7+gK80MxuaFK7LR/rJEI9ae6db9h+ovMPKUoZlTDDxQQ8Lg9/ooD+/lXHc62HJcgldxNU85ujnMK1iyM3Vu+6sA4Nd75azgL4bamdy8vhIb1jBTGBx5LmjZbXEp4jglY4BCTDs3l+stQvqeIv9BMY+Pg+x53enrcUwcb0Q9MsZ6xnlidRRfV3svdZVkzPpaPnc1NXv9USCPdzt4Zy7c0gE=
X-Forefront-Antispam-Report: CIP:12.22.5.238;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:mail.nvidia.com;PTR:InfoNoRecords;CAT:NONE;SFS:(4636009)(36840700001)(46966006)(40470700001)(16526019)(53546011)(2616005)(110136005)(82310400004)(316002)(83380400001)(426003)(4326008)(2906002)(86362001)(31686004)(40460700001)(508600001)(36860700001)(8676002)(36756003)(356005)(26005)(31696002)(70586007)(70206006)(34020700004)(16576012)(5660300002)(47076005)(336012)(8936002)(81166007)(54906003)(186003)(36900700001)(43740500002);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Dec 2021 16:35:17.7112
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 862be719-16c6-4433-facf-08d9c0b20b84
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[12.22.5.238];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT009.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB5007
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org


On 12/16/2021 6:25 PM, Jens Axboe wrote:
> On 12/16/21 9:19 AM, Max Gurtovoy wrote:
>> On 12/16/2021 6:05 PM, Jens Axboe wrote:
>>> On 12/16/21 9:00 AM, Max Gurtovoy wrote:
>>>> On 12/16/2021 5:48 PM, Jens Axboe wrote:
>>>>> On 12/16/21 6:06 AM, Max Gurtovoy wrote:
>>>>>> On 12/16/2021 11:08 AM, Christoph Hellwig wrote:
>>>>>>> On Wed, Dec 15, 2021 at 09:24:21AM -0700, Jens Axboe wrote:
>>>>>>>> +	spin_lock(&nvmeq->sq_lock);
>>>>>>>> +	while (!rq_list_empty(*rqlist)) {
>>>>>>>> +		struct request *req = rq_list_pop(rqlist);
>>>>>>>> +		struct nvme_iod *iod = blk_mq_rq_to_pdu(req);
>>>>>>>> +
>>>>>>>> +		memcpy(nvmeq->sq_cmds + (nvmeq->sq_tail << nvmeq->sqes),
>>>>>>>> +				absolute_pointer(&iod->cmd), sizeof(iod->cmd));
>>>>>>>> +		if (++nvmeq->sq_tail == nvmeq->q_depth)
>>>>>>>> +			nvmeq->sq_tail = 0;
>>>>>>> So this doesn't even use the new helper added in patch 2?  I think this
>>>>>>> should call nvme_sq_copy_cmd().
>>>>>> I also noticed that.
>>>>>>
>>>>>> So need to decide if to open code it or use the helper function.
>>>>>>
>>>>>> Inline helper sounds reasonable if you have 3 places that will use it.
>>>>> Yes agree, that's been my stance too :-)
>>>>>
>>>>>>> The rest looks identical to the incremental patch I posted, so I guess
>>>>>>> the performance degration measured on the first try was a measurement
>>>>>>> error?
>>>>>> giving 1 dbr for a batch of N commands sounds good idea. Also for RDMA host.
>>>>>>
>>>>>> But how do you moderate it ? what is the batch_sz <--> time_to_wait
>>>>>> algorithm ?
>>>>> The batching is naturally limited at BLK_MAX_REQUEST_COUNT, which is 32
>>>>> in total. I do agree that if we ever made it much larger, then we might
>>>>> want to cap it differently. But 32 seems like a pretty reasonable number
>>>>> to get enough gain from the batching done in various areas, while still
>>>>> not making it so large that we have a potential latency issue. That
>>>>> batch count is already used consistently for other items too (like tag
>>>>> allocation), so it's not specific to just this one case.
>>>> I'm saying that the you can wait to the batch_max_count too long and it
>>>> won't be efficient from latency POV.
>>>>
>>>> So it's better to limit the block layar to wait for the first to come: x
>>>> usecs or batch_max_count before issue queue_rqs.
>>> There's no waiting specifically for this, it's just based on the plug.
>>> We just won't do more than 32 in that plug. This is really just an
>>> artifact of the plugging, and if that should be limited based on "max of
>>> 32 or xx time", then that should be done there.
>>>
>>> But in general I think it's saner and enough to just limit the total
>>> size. If we spend more than xx usec building up the plug list, we're
>>> doing something horribly wrong. That really should not happen with 32
>>> requests, and we'll never eg wait on requests if we're out of tags. That
>>> will result in a plug flush to begin with.
>> I'm not aware of the plug. I hope to get to it soon.
>>
>> My concern is if the user application submitted only 28 requests and
>> then you'll wait forever ? or for very long time.
>>
>> I guess not, but I'm asking how do you know how to batch and when to
>> stop in case 32 commands won't arrive anytime soon.
> The plug is in the stack of the task, so that condition can never
> happen. If the application originally asks for 32 but then only submits
> 28, then once that last one is submitted the plug is flushed and
> requests are issued.

So if I'm running fio with --iodepth=28 what will plug do ? send batches 
of 28 ? or 1 by 1 ?

>>>> Also, This batch is per HW queue or SW queue or the entire request queue ?
>>> It's per submitter, so whatever the submitter ends up queueing IO
>>> against. In general it'll be per-queue.
>> struct request_queue ?
>>
>> I think the best is to batch per struct blk_mq_hw_ctx.
>>
>> I see that you check this in the nvme_pci driver but shouldn't it go to
>> the block layer ?
> That's not how plugging works. In general, unless your task bounces
> around, then it'll be a single queue and a single hw queue as well.
> Adding code to specifically check the mappings and flush at that point
> would be a net loss, rather than just deal with it if it happens for
> some cases.
>
