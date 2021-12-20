Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D5E1C47B041
	for <lists+io-uring@lfdr.de>; Mon, 20 Dec 2021 16:29:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237233AbhLTP3V (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 20 Dec 2021 10:29:21 -0500
Received: from mail-dm6nam10on2070.outbound.protection.outlook.com ([40.107.93.70]:49716
        "EHLO NAM10-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S235647AbhLTP3L (ORCPT <rfc822;io-uring@vger.kernel.org>);
        Mon, 20 Dec 2021 10:29:11 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=KgfawK6+5gNa5XaZlkP73zduR2DtqoT1TdtJWKQHO8Hl+DzD4Hy36neP93l2ywl+c1E28Bcaxz+BuSGdDvBLOTF3tAiY7yCeEtz45IKztRz3IBQZICIEoZwmgBWmiNgrBijijpXm2V0NF3VRwSXt0CYYQfqH8ZQ5dmIAOwiUkoSzdwJXpKMmbmObTJg9oh1M8FaaLau0f0XelGkH3PwFEC+Ak1iu6MNGHsTPsm0QAkEpCjzGPlzcFhgsggr8CxEE33Sbl0Iv5rOTKdCsFGjbAF2zfD3JKuCjBx1oJn2N0JwjJNfdIkIUALI9E0RM7uwCXl2UPIMvIfxU1tvg8Y6PbA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=YI3VeGZnrOgLSv6tHBIJns8fhMaqyWPmyDArFQXfAkQ=;
 b=K1OuiwWmm52/DsawpoE0eM/7QzjOgGxa+o6iHPSRFU3tUgN40x7upuXGHrY3su1lyJnH8hSzAZW/hNPE/hBLn/MW5DyRnxZ0oeSY4Pee+bar1uuu5jeZS753S2C9wtwc/qGZB41ljwKRwqcJ7rkOWjxNcjwkAkH9/OGp89Ya9UfbkBB60JAsoTUB/8zq2y75m/0Vd9eaA2uaGKH278Fpk0FZ7i6SxoHwv57HSqy5w0YYNQIN8iKMlYdMBvBF8LSuLyBDxDMy8ahxe4OaD496D96WYbsXowmFkuWoRL6OKCxGbdcSezLb1YJHdndeMj8CivEv2LUkrcl64JKVKyLnrQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 12.22.5.234) smtp.rcpttodomain=lists.infradead.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=nvidia.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=YI3VeGZnrOgLSv6tHBIJns8fhMaqyWPmyDArFQXfAkQ=;
 b=L9V3j9KGtq/uWTeYQm9X3eFOIYRVJCJFxJk3Bo0cW6cSaywcWXA9Or2LH+kyrwH5FO0kTJTzClUeF2lJVMSL5a8wUQsBVaa6dg4zTTcRPBZnZmY2U7sKnK72IRJLLoyeaYQOpeLJqj3OBucrF72CAmbDIWIidemggIVf7nX76LgfV/DGApw60A0TQeWA0rL1KMnQ1oTF4bDOP8Y0EdUY61KDpo9hr8W7VWnrl9YkJlIMrsqOjpM4mjkuB5kfKMbatxL+FhTdOwOOGVxpqBktavIVcsrQxd/yzfsZ/QqOomxoWBu6PzPPAwoXak8Pio+6N7GZ48/K3Pb1Qp0kTE/AgA==
Received: from DM6PR02CA0112.namprd02.prod.outlook.com (2603:10b6:5:1b4::14)
 by DM6PR12MB4731.namprd12.prod.outlook.com (2603:10b6:5:35::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4801.20; Mon, 20 Dec
 2021 15:29:09 +0000
Received: from DM6NAM11FT049.eop-nam11.prod.protection.outlook.com
 (2603:10b6:5:1b4:cafe::53) by DM6PR02CA0112.outlook.office365.com
 (2603:10b6:5:1b4::14) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4801.14 via Frontend
 Transport; Mon, 20 Dec 2021 15:29:09 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 12.22.5.234)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 12.22.5.234 as permitted sender) receiver=protection.outlook.com;
 client-ip=12.22.5.234; helo=mail.nvidia.com;
Received: from mail.nvidia.com (12.22.5.234) by
 DM6NAM11FT049.mail.protection.outlook.com (10.13.172.188) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4801.14 via Frontend Transport; Mon, 20 Dec 2021 15:29:09 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by DRHQMAIL101.nvidia.com
 (10.27.9.10) with Microsoft SMTP Server (TLS) id 15.0.1497.18; Mon, 20 Dec
 2021 15:29:09 +0000
Received: from [172.27.13.95] (172.20.187.6) by rnnvmail201.nvidia.com
 (10.129.68.8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id 15.2.986.9; Mon, 20 Dec 2021
 07:29:06 -0800
Message-ID: <e1afcf34-a283-a88a-fa0b-26c7c1094e74@nvidia.com>
Date:   Mon, 20 Dec 2021 17:29:03 +0200
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
 <01f9ce91-d998-c823-f2f2-de457625021e@nvidia.com>
 <573bbe72-d232-6063-dd34-2e12d8374594@kernel.dk>
 <4fbf2936-8e4c-9c04-e5a9-10eae387b562@nvidia.com>
 <6ca82929-7e70-be15-dcbb-1e68a02dd933@kernel.dk>
From:   Max Gurtovoy <mgurtovoy@nvidia.com>
In-Reply-To: <6ca82929-7e70-be15-dcbb-1e68a02dd933@kernel.dk>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [172.20.187.6]
X-ClientProxiedBy: HQMAIL101.nvidia.com (172.20.187.10) To
 rnnvmail201.nvidia.com (10.129.68.8)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 3968ca5e-f2eb-4e51-6d13-08d9c3cd77e5
X-MS-TrafficTypeDiagnostic: DM6PR12MB4731:EE_
X-Microsoft-Antispam-PRVS: <DM6PR12MB4731064F1A7654A2C09A3FDBDE7B9@DM6PR12MB4731.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8882;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: fKL5Rfqw6t5Td1C/GuwfeOw/76ZkymtUKobAiOzZmal4zvQW4ISdHNQbb9C7+Zhjk0inoCAtzw9CDRo0j3bV2Djyy+bFmnx83Fyfh2BvF2hRDAwh5q5BnPRNi+pyiQF/i9RNJlWaM7E8JFmefR5qw6/M1vr4HT6KXymlrdedW6NU5w1E9b6bXvYGEmNxNrO18mRyqBSkizt2OifQzgSvv3265GhnahQEiXApSMgEQ53mY8C81PrDmQZyHmwZQ9zgYWNiPYdNoBvtFoFVEKcRiapbUyLIiG6B9bO1OCii1We6YgSL7CsCTxDCyxQh5KTKwsAHm42uZJCUHNsjRMuhbbM+FM7yHy2JZ7kwhXL0ArQb1dRnkvKj3t8u64YC7z7N/3hYyf28yTBHG6KOVfXOPmNa+WGUqEFVrTE7zAkX9AYu5jwvdl5V18cMCxDDv+xxm+AmxSlIySJgBW6nj2c/B55XowUhm+X39+KOm5Lp35aVO4RBDNHjl5cl4ocIDlQlVJA81C2nKAy6vOmQmxanNqhIIcQxPoh5aGUxDnc7vQrlzAvI70SVrSwZhl8L+3gAo2QpvVXPk68siT/tByR60B5bHBRli7ZjCMcCs3PgMzs4Rc2pFO1j0bs2e69uw6xHzLbP3J7nycX/4lGSYYb2Ad5famvERUQQpdwPeNXSMJz3k11uw3zYjm98qE+p2TBxLoi2h7XRoKeENR6NjUul7MRQy6iE2k4VbBRWcN3riiIBGLG9Xbq3HYNTbMvSKPfB9+8A/Gcj77MHQJjd040b2LjAyAEwSxPuLvtC4f2LnW4G9tT3+0TFNfqx2q08gxcmQ4MK8sQdx5jv9B0L+lyBydSf307+VZ49pbQlTxoH8Sg=
X-Forefront-Antispam-Report: CIP:12.22.5.234;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:mail.nvidia.com;PTR:InfoNoRecords;CAT:NONE;SFS:(4636009)(36840700001)(46966006)(40470700001)(31686004)(2906002)(107886003)(70206006)(47076005)(81166007)(31696002)(426003)(53546011)(36756003)(36860700001)(6666004)(316002)(110136005)(16576012)(8676002)(356005)(83380400001)(40460700001)(26005)(82310400004)(5660300002)(4326008)(186003)(8936002)(16526019)(34020700004)(508600001)(86362001)(336012)(70586007)(54906003)(2616005)(36900700001)(43740500002);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Dec 2021 15:29:09.5622
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 3968ca5e-f2eb-4e51-6d13-08d9c3cd77e5
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[12.22.5.234];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT049.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB4731
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org


On 12/20/2021 4:19 PM, Jens Axboe wrote:
> On 12/20/21 3:11 AM, Max Gurtovoy wrote:
>> On 12/19/2021 4:48 PM, Jens Axboe wrote:
>>> On 12/19/21 5:14 AM, Max Gurtovoy wrote:
>>>> On 12/16/2021 7:16 PM, Jens Axboe wrote:
>>>>> On 12/16/21 9:57 AM, Max Gurtovoy wrote:
>>>>>> On 12/16/2021 6:36 PM, Jens Axboe wrote:
>>>>>>> On 12/16/21 9:34 AM, Max Gurtovoy wrote:
>>>>>>>> On 12/16/2021 6:25 PM, Jens Axboe wrote:
>>>>>>>>> On 12/16/21 9:19 AM, Max Gurtovoy wrote:
>>>>>>>>>> On 12/16/2021 6:05 PM, Jens Axboe wrote:
>>>>>>>>>>> On 12/16/21 9:00 AM, Max Gurtovoy wrote:
>>>>>>>>>>>> On 12/16/2021 5:48 PM, Jens Axboe wrote:
>>>>>>>>>>>>> On 12/16/21 6:06 AM, Max Gurtovoy wrote:
>>>>>>>>>>>>>> On 12/16/2021 11:08 AM, Christoph Hellwig wrote:
>>>>>>>>>>>>>>> On Wed, Dec 15, 2021 at 09:24:21AM -0700, Jens Axboe wrote:
>>>>>>>>>>>>>>>> +	spin_lock(&nvmeq->sq_lock);
>>>>>>>>>>>>>>>> +	while (!rq_list_empty(*rqlist)) {
>>>>>>>>>>>>>>>> +		struct request *req = rq_list_pop(rqlist);
>>>>>>>>>>>>>>>> +		struct nvme_iod *iod = blk_mq_rq_to_pdu(req);
>>>>>>>>>>>>>>>> +
>>>>>>>>>>>>>>>> +		memcpy(nvmeq->sq_cmds + (nvmeq->sq_tail << nvmeq->sqes),
>>>>>>>>>>>>>>>> +				absolute_pointer(&iod->cmd), sizeof(iod->cmd));
>>>>>>>>>>>>>>>> +		if (++nvmeq->sq_tail == nvmeq->q_depth)
>>>>>>>>>>>>>>>> +			nvmeq->sq_tail = 0;
>>>>>>>>>>>>>>> So this doesn't even use the new helper added in patch 2?  I think this
>>>>>>>>>>>>>>> should call nvme_sq_copy_cmd().
>>>>>>>>>>>>>> I also noticed that.
>>>>>>>>>>>>>>
>>>>>>>>>>>>>> So need to decide if to open code it or use the helper function.
>>>>>>>>>>>>>>
>>>>>>>>>>>>>> Inline helper sounds reasonable if you have 3 places that will use it.
>>>>>>>>>>>>> Yes agree, that's been my stance too :-)
>>>>>>>>>>>>>
>>>>>>>>>>>>>>> The rest looks identical to the incremental patch I posted, so I guess
>>>>>>>>>>>>>>> the performance degration measured on the first try was a measurement
>>>>>>>>>>>>>>> error?
>>>>>>>>>>>>>> giving 1 dbr for a batch of N commands sounds good idea. Also for RDMA host.
>>>>>>>>>>>>>>
>>>>>>>>>>>>>> But how do you moderate it ? what is the batch_sz <--> time_to_wait
>>>>>>>>>>>>>> algorithm ?
>>>>>>>>>>>>> The batching is naturally limited at BLK_MAX_REQUEST_COUNT, which is 32
>>>>>>>>>>>>> in total. I do agree that if we ever made it much larger, then we might
>>>>>>>>>>>>> want to cap it differently. But 32 seems like a pretty reasonable number
>>>>>>>>>>>>> to get enough gain from the batching done in various areas, while still
>>>>>>>>>>>>> not making it so large that we have a potential latency issue. That
>>>>>>>>>>>>> batch count is already used consistently for other items too (like tag
>>>>>>>>>>>>> allocation), so it's not specific to just this one case.
>>>>>>>>>>>> I'm saying that the you can wait to the batch_max_count too long and it
>>>>>>>>>>>> won't be efficient from latency POV.
>>>>>>>>>>>>
>>>>>>>>>>>> So it's better to limit the block layar to wait for the first to come: x
>>>>>>>>>>>> usecs or batch_max_count before issue queue_rqs.
>>>>>>>>>>> There's no waiting specifically for this, it's just based on the plug.
>>>>>>>>>>> We just won't do more than 32 in that plug. This is really just an
>>>>>>>>>>> artifact of the plugging, and if that should be limited based on "max of
>>>>>>>>>>> 32 or xx time", then that should be done there.
>>>>>>>>>>>
>>>>>>>>>>> But in general I think it's saner and enough to just limit the total
>>>>>>>>>>> size. If we spend more than xx usec building up the plug list, we're
>>>>>>>>>>> doing something horribly wrong. That really should not happen with 32
>>>>>>>>>>> requests, and we'll never eg wait on requests if we're out of tags. That
>>>>>>>>>>> will result in a plug flush to begin with.
>>>>>>>>>> I'm not aware of the plug. I hope to get to it soon.
>>>>>>>>>>
>>>>>>>>>> My concern is if the user application submitted only 28 requests and
>>>>>>>>>> then you'll wait forever ? or for very long time.
>>>>>>>>>>
>>>>>>>>>> I guess not, but I'm asking how do you know how to batch and when to
>>>>>>>>>> stop in case 32 commands won't arrive anytime soon.
>>>>>>>>> The plug is in the stack of the task, so that condition can never
>>>>>>>>> happen. If the application originally asks for 32 but then only submits
>>>>>>>>> 28, then once that last one is submitted the plug is flushed and
>>>>>>>>> requests are issued.
>>>>>>>> So if I'm running fio with --iodepth=28 what will plug do ? send batches
>>>>>>>> of 28 ? or 1 by 1 ?
>>>>>>> --iodepth just controls the overall depth, the batch submit count
>>>>>>> dictates what happens further down. If you run queue depth 28 and submit
>>>>>>> one at the time, then you'll get one at the time further down too. Hence
>>>>>>> the batching is directly driven by what the application is already
>>>>>>> doing.
>>>>>> I see. Thanks for the explanation.
>>>>>>
>>>>>> So it works only for io_uring based applications ?
>>>>> It's only enabled for io_uring right now, but it's generically available
>>>>> for anyone that wants to use it... Would be trivial to do for aio, and
>>>>> other spots that currently use blk_start_plug() and has an idea of how
>>>>> many IOs will be submitted
>>>> Can you please share an example application (or is it fio patches) that
>>>> can submit batches ? The same that was used to test this patchset is
>>>> fine too.
>>>>
>>>> I would like to test it with our NVMe SNAP controllers and also to
>>>> develop NVMe/RDMA queue_rqs code and test the perf with it.
>>> You should just be able to use iodepth_batch with fio. For my peak
>>> testing, I use t/io_uring from the fio repo. By default, it'll run QD of
>>> and do batches of 32 for complete and submit. You can just run:
>>>
>>> t/io_uring <dev or file>
>>>
>>> maybe adding -p0 for IRQ driven rather than polled IO.
>> I used your block/for-next branch and implemented queue_rqs in NVMe/RDMA
>> but it was never called using the t/io_uring test nor fio with
>> iodepth_batch=32 flag with io_uring engine.
>>
>> Any idea what might be the issue ?
>>
>> I installed fio from sources..
> The two main restrictions right now are a scheduler and shared tags, are
> you using any of those?

No.

But maybe I'm missing the .commit_rqs callback. is it mandatory for this 
feature ?


