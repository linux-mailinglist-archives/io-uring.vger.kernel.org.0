Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7F89A47A07A
	for <lists+io-uring@lfdr.de>; Sun, 19 Dec 2021 13:14:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235673AbhLSMOX (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sun, 19 Dec 2021 07:14:23 -0500
Received: from mail-bn8nam11on2045.outbound.protection.outlook.com ([40.107.236.45]:11622
        "EHLO NAM11-BN8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S235615AbhLSMOX (ORCPT <rfc822;io-uring@vger.kernel.org>);
        Sun, 19 Dec 2021 07:14:23 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=iinCzSWd1lGFkruIxeR1R416hvhtYZO0tNMVRmxU1gbdx6iQ9gTNUbSAloLSof+htuvqiOpfAjc/GJkfen+fbYnmDj48RJ1bOhrlsauEVp0c075SW6AK/HjzR5DwUWxWorNJ8YKkMX5rVEqH/jNchPVs14b4VkRxL31e72gJWQAd1ZmayOMrBvjoSiwoEXYMQXoFf50MFdG1Eu6w2Tcxix74c6TiniTP4IpHBhidQ331rVc8D3Yb+9hPMoAFt3AqMWUyZOnzwUuk4eRL+m6+s782UQN/pDQeEOajuzTpviZs1bXN+t8Mywr1ur3MKFYbOmGDtA5a4iLyGf3SqDBe4w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=hd+x3ZhdipejoOmvIT2tZP/vUur2TPPgAogOaB7dhQ0=;
 b=DiAsuR+LSuu2jFnlGQFSUm0DBWEahjI4KuPo6a9BgXICPx7Zlvny1ksy8ZKUxxqwHANlamRTRFlo3+FviMWIwdxT3w7/kfGO6zT+P2NNpWHCWuiDsaGazHVZBbTUeMSalVGGR+UBMHA0J0Y6GySAeNZQcCZnlfyz27FgeaSAV1J+frAzERQ0mUYl4v6C14CfgbDZM6MxXfILVmLaQo4ozRmHzzMivFjUaowe64my5h3UqOL0D9u8v3zw4hKkKjXxgL55UPN7PzrCM8BhJ3raqLpOOdVMR5OuCtloZ1FB96E1WX57Kpjk8cUewArKVDsIC646CcRZZGRBBR4HMzHJQw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 12.22.5.236) smtp.rcpttodomain=lists.infradead.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=nvidia.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=hd+x3ZhdipejoOmvIT2tZP/vUur2TPPgAogOaB7dhQ0=;
 b=dUWOqudFUaHGEcwYNc7O/+C4NorDRx6+jXkqDUnZjrW6gb/8ZszdZnTZnwL5NgZDgf7lVGhoKTcQhoC5mcotV8/giEHXr5CUjCsEzM9KL4Jwy7PkRgKf8yMGWVrDSqU8gzvjPEy7gDkuPltHd1Vxm9Moo8AQccNc4Nuye4WlOiby7oNWMkncm95+dSpC2CS6lAO7nGpU1Gtw1czdGdKAsEM8oIIUaUbFFLlBe5eveGFni7m9gF9Hxs7IZEt4Ty7/Zp/byTWMZkjGJIgGnlFycp5Du5ks+rRbt89UdnABV69DEvQGVKSCoXlm62koNMhfq0q9hpVw+OtTzyI4HaoS7A==
Received: from BN9PR03CA0505.namprd03.prod.outlook.com (2603:10b6:408:130::30)
 by BY5PR12MB4195.namprd12.prod.outlook.com (2603:10b6:a03:200::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4801.17; Sun, 19 Dec
 2021 12:14:18 +0000
Received: from BN8NAM11FT013.eop-nam11.prod.protection.outlook.com
 (2603:10b6:408:130:cafe::67) by BN9PR03CA0505.outlook.office365.com
 (2603:10b6:408:130::30) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4801.20 via Frontend
 Transport; Sun, 19 Dec 2021 12:14:18 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 12.22.5.236)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 12.22.5.236 as permitted sender) receiver=protection.outlook.com;
 client-ip=12.22.5.236; helo=mail.nvidia.com;
Received: from mail.nvidia.com (12.22.5.236) by
 BN8NAM11FT013.mail.protection.outlook.com (10.13.176.182) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4801.14 via Frontend Transport; Sun, 19 Dec 2021 12:14:17 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by DRHQMAIL109.nvidia.com
 (10.27.9.19) with Microsoft SMTP Server (TLS) id 15.0.1497.18; Sun, 19 Dec
 2021 12:14:17 +0000
Received: from [172.27.14.22] (172.20.187.5) by rnnvmail201.nvidia.com
 (10.129.68.8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id 15.2.986.9; Sun, 19 Dec 2021
 04:14:15 -0800
Message-ID: <01f9ce91-d998-c823-f2f2-de457625021e@nvidia.com>
Date:   Sun, 19 Dec 2021 14:14:12 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.3.2
Subject: Re: [PATCH 4/4] nvme: add support for mq_ops->queue_rqs()
Content-Language: en-US
To:     Jens Axboe <axboe@kernel.dk>, Christoph Hellwig <hch@infradead.org>
CC:     <io-uring@vger.kernel.org>, <linux-nvme@lists.infradead.org>,
        "Hannes Reinecke" <hare@suse.de>, Oren Duer <oren@nvidia.com>
References: <20211215162421.14896-1-axboe@kernel.dk>
 <20211215162421.14896-5-axboe@kernel.dk> <YbsB/W/1Uwok4i0u@infradead.org>
 <2adafc43-3860-d9f0-9cb5-ca3bf9a27109@nvidia.com>
 <06ab52e6-47b7-6010-524c-45bb73fbfabc@kernel.dk>
 <9b4202b4-192a-6611-922e-0b837e2b97c3@nvidia.com>
 <5f249c03-5cb2-9978-cd2c-669c0594d1c0@kernel.dk>
 <d1613b7f-342d-08ad-d655-a6afb89e1847@nvidia.com>
 <a159220b-6e0c-6ee9-f8e2-c6dc9f6dfaed@kernel.dk>
 <3474493a-a04d-528c-7565-f75db5205074@nvidia.com>
 <87e3a197-e8f7-d8d6-85b6-ce05bf1f35cd@kernel.dk>
 <5ee0e257-651a-ec44-7ca3-479438a737fb@nvidia.com>
 <e3974442-3b3f-0419-519c-7360057c4603@kernel.dk>
From:   Max Gurtovoy <mgurtovoy@nvidia.com>
In-Reply-To: <e3974442-3b3f-0419-519c-7360057c4603@kernel.dk>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [172.20.187.5]
X-ClientProxiedBy: HQMAIL101.nvidia.com (172.20.187.10) To
 rnnvmail201.nvidia.com (10.129.68.8)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: a11f9fc8-036b-46a1-9e90-08d9c2e914be
X-MS-TrafficTypeDiagnostic: BY5PR12MB4195:EE_
X-Microsoft-Antispam-PRVS: <BY5PR12MB419599949FAB5C463A5A8B87DE7A9@BY5PR12MB4195.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: jgg5YbA1Med0w+WDoh3npCvhPan29ACK3B3T+p8edAsqT1E+IrT1cUbHoxMtGH2JVVbb5aef4i9OoShe4DyoCfcTgF4RH7ZPCWcRSVyvic5lQfkFtrlKaOC13TvJXUADbD6HtQ+82DP3Mvr2QXhhEKl/V9pvb0sUGUi2HgFvVZZfmODnCtwhDDbXU3Wk6B71RtWWayefKEzzF8CzaLHCqjf3p1qTMa2Mc/kIGdKJUO6s3i0N75sVYBZLIxwVyR8dYhPv1dwNuKzgdgsjvaHDb5KrztOXlHLwkv3dd3VpVNzW79tNUb4637balPmrUbWcw4MzeAxY2mnROxxRR/2L6lQRXwYklqcMVMpZvV5BHErqRP15T7YLqnURPWZ2ujCAZ+VSxvXHwWyM4Fz8MakAsx2GKCaWKSs1Q25apiP/5Z4EKIFej0GoUkGPO4RNkTSHlUAbox6H0ANG6ahm631MdIY31YY9xO3SVf8Ku7Cfe6blqPFsma1vWyXja0UmPcLC9B74G3S6KWiRypGz7Bk/KmssY267Rv+uuzaKqylAxKySGXQoG4SSU1pCVHbbKNBwDtzUy5hA7b1qMr7vkjiQXm34ISKBUOzal+0tEuXFWZlizHFNy3rq793imJ0ooAXhzQ43MXGxGKEzkqiFK5po9jjsdicaw2H8qA1/yFz5t5PPUjc3L1/jAd+MnRcyjfG254ir/EEIIH9EmrLSAn9tfOd7wK26teANaWcDAM9+IUT8/+/Rv1E1AFdaDO4mtYzkQ8GbJqvgGAyQJhdJrFvUXGB5CQDBObPtxDjYNgcblUZhIGZgbrpxdO6LGr0WgdFssUqu90+d5VhUgMrLzqCmZ1oecfnd7/nl8tJCcoNwQw4=
X-Forefront-Antispam-Report: CIP:12.22.5.236;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:mail.nvidia.com;PTR:InfoNoRecords;CAT:NONE;SFS:(4636009)(46966006)(36840700001)(40470700001)(81166007)(16526019)(356005)(31686004)(83380400001)(31696002)(5660300002)(8676002)(26005)(186003)(34020700004)(508600001)(36756003)(53546011)(40460700001)(8936002)(16576012)(316002)(54906003)(82310400004)(2906002)(110136005)(86362001)(70206006)(336012)(2616005)(6666004)(426003)(70586007)(4326008)(36860700001)(107886003)(47076005)(36900700001)(43740500002);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Dec 2021 12:14:17.9094
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: a11f9fc8-036b-46a1-9e90-08d9c2e914be
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[12.22.5.236];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT013.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR12MB4195
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org


On 12/16/2021 7:16 PM, Jens Axboe wrote:
> On 12/16/21 9:57 AM, Max Gurtovoy wrote:
>> On 12/16/2021 6:36 PM, Jens Axboe wrote:
>>> On 12/16/21 9:34 AM, Max Gurtovoy wrote:
>>>> On 12/16/2021 6:25 PM, Jens Axboe wrote:
>>>>> On 12/16/21 9:19 AM, Max Gurtovoy wrote:
>>>>>> On 12/16/2021 6:05 PM, Jens Axboe wrote:
>>>>>>> On 12/16/21 9:00 AM, Max Gurtovoy wrote:
>>>>>>>> On 12/16/2021 5:48 PM, Jens Axboe wrote:
>>>>>>>>> On 12/16/21 6:06 AM, Max Gurtovoy wrote:
>>>>>>>>>> On 12/16/2021 11:08 AM, Christoph Hellwig wrote:
>>>>>>>>>>> On Wed, Dec 15, 2021 at 09:24:21AM -0700, Jens Axboe wrote:
>>>>>>>>>>>> +	spin_lock(&nvmeq->sq_lock);
>>>>>>>>>>>> +	while (!rq_list_empty(*rqlist)) {
>>>>>>>>>>>> +		struct request *req = rq_list_pop(rqlist);
>>>>>>>>>>>> +		struct nvme_iod *iod = blk_mq_rq_to_pdu(req);
>>>>>>>>>>>> +
>>>>>>>>>>>> +		memcpy(nvmeq->sq_cmds + (nvmeq->sq_tail << nvmeq->sqes),
>>>>>>>>>>>> +				absolute_pointer(&iod->cmd), sizeof(iod->cmd));
>>>>>>>>>>>> +		if (++nvmeq->sq_tail == nvmeq->q_depth)
>>>>>>>>>>>> +			nvmeq->sq_tail = 0;
>>>>>>>>>>> So this doesn't even use the new helper added in patch 2?  I think this
>>>>>>>>>>> should call nvme_sq_copy_cmd().
>>>>>>>>>> I also noticed that.
>>>>>>>>>>
>>>>>>>>>> So need to decide if to open code it or use the helper function.
>>>>>>>>>>
>>>>>>>>>> Inline helper sounds reasonable if you have 3 places that will use it.
>>>>>>>>> Yes agree, that's been my stance too :-)
>>>>>>>>>
>>>>>>>>>>> The rest looks identical to the incremental patch I posted, so I guess
>>>>>>>>>>> the performance degration measured on the first try was a measurement
>>>>>>>>>>> error?
>>>>>>>>>> giving 1 dbr for a batch of N commands sounds good idea. Also for RDMA host.
>>>>>>>>>>
>>>>>>>>>> But how do you moderate it ? what is the batch_sz <--> time_to_wait
>>>>>>>>>> algorithm ?
>>>>>>>>> The batching is naturally limited at BLK_MAX_REQUEST_COUNT, which is 32
>>>>>>>>> in total. I do agree that if we ever made it much larger, then we might
>>>>>>>>> want to cap it differently. But 32 seems like a pretty reasonable number
>>>>>>>>> to get enough gain from the batching done in various areas, while still
>>>>>>>>> not making it so large that we have a potential latency issue. That
>>>>>>>>> batch count is already used consistently for other items too (like tag
>>>>>>>>> allocation), so it's not specific to just this one case.
>>>>>>>> I'm saying that the you can wait to the batch_max_count too long and it
>>>>>>>> won't be efficient from latency POV.
>>>>>>>>
>>>>>>>> So it's better to limit the block layar to wait for the first to come: x
>>>>>>>> usecs or batch_max_count before issue queue_rqs.
>>>>>>> There's no waiting specifically for this, it's just based on the plug.
>>>>>>> We just won't do more than 32 in that plug. This is really just an
>>>>>>> artifact of the plugging, and if that should be limited based on "max of
>>>>>>> 32 or xx time", then that should be done there.
>>>>>>>
>>>>>>> But in general I think it's saner and enough to just limit the total
>>>>>>> size. If we spend more than xx usec building up the plug list, we're
>>>>>>> doing something horribly wrong. That really should not happen with 32
>>>>>>> requests, and we'll never eg wait on requests if we're out of tags. That
>>>>>>> will result in a plug flush to begin with.
>>>>>> I'm not aware of the plug. I hope to get to it soon.
>>>>>>
>>>>>> My concern is if the user application submitted only 28 requests and
>>>>>> then you'll wait forever ? or for very long time.
>>>>>>
>>>>>> I guess not, but I'm asking how do you know how to batch and when to
>>>>>> stop in case 32 commands won't arrive anytime soon.
>>>>> The plug is in the stack of the task, so that condition can never
>>>>> happen. If the application originally asks for 32 but then only submits
>>>>> 28, then once that last one is submitted the plug is flushed and
>>>>> requests are issued.
>>>> So if I'm running fio with --iodepth=28 what will plug do ? send batches
>>>> of 28 ? or 1 by 1 ?
>>> --iodepth just controls the overall depth, the batch submit count
>>> dictates what happens further down. If you run queue depth 28 and submit
>>> one at the time, then you'll get one at the time further down too. Hence
>>> the batching is directly driven by what the application is already
>>> doing.
>> I see. Thanks for the explanation.
>>
>> So it works only for io_uring based applications ?
> It's only enabled for io_uring right now, but it's generically available
> for anyone that wants to use it... Would be trivial to do for aio, and
> other spots that currently use blk_start_plug() and has an idea of how
> many IOs will be submitted

Can you please share an example application (or is it fio patches) that 
can submit batches ? The same that was used to test this patchset is 
fine too.

I would like to test it with our NVMe SNAP controllers and also to 
develop NVMe/RDMA queue_rqs code and test the perf with it.

> .
>
>> Don't you think it will be a good idea to not depend on applications and
>> batch according to some kernel mechanism ?
>>
>> Wait till X requests or Y usecs (first condition to be fulfilled) before
>> submitting the batch to LLD.
>>
>> Like we do with adaptive completion coalescing/moderation for capable
>> devices.
> This is how plugging used to work way back in the day. The problem is
> that you then introduce per-device state, which can cause contention.
> That's why the plug is a pure stack based entity now.
>
