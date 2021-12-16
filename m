Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 103F54779CB
	for <lists+io-uring@lfdr.de>; Thu, 16 Dec 2021 17:57:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237457AbhLPQ5o (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 16 Dec 2021 11:57:44 -0500
Received: from mail-sn1anam02on2081.outbound.protection.outlook.com ([40.107.96.81]:6076
        "EHLO NAM02-SN1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S234595AbhLPQ5n (ORCPT <rfc822;io-uring@vger.kernel.org>);
        Thu, 16 Dec 2021 11:57:43 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=NNd4QYtyfAhwW1dtTGxnUhQ9Wl1IdRfbaesMzmrnE3E3NEUEMFgyThx5uPoEo5IG6UaPE8BdpqIZXXUo08jIo51y4QUOVmLASMNN+d6pToiQj6n/RbvQvDfqxzUr4Lf3VhTZjYptYOikkiL/8JFVu3mDxCU6zG3hnepFAHhFXfJyOKa0gVmQGVP33+TSv/36kkOILpMOxpDlkDgC2NORww8TeMi6g99/itT2Ot4Jbt2wcz0EZNyQtl25nYtD09JMkaUdhZGYNP4IHVd1gmPs+z/0Ie/Cx3ke7CPhq/+4QNbEGyJdnwJJXqLqGzSPyhJayyulfp1ATJ35I1YOizMsCw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=NQE3SGHZPvDNn0O6il1UeOnKgjES4b53WOGwHuavpVM=;
 b=P6PfOErarriQqe2jUcWyobW8SDelHAdYoLKqtTAsTVYaLYSw5bt4ndrsEPuhl5RpiES+6RgKZfGlpLMFYBqGJzIga0Hi8UE0PWOpNH4+2n8uV6YNbQrMi8NU/U2NAJ3wYdovwQsmoEsDpgWPNG8hwgaPKAp8kF0vq/PArOVnXaKMNBzqp3mhEpFtoxtIbN3WnwydFwElKrhP+Dye3NGq5Grm8TEFTj//3wbG3IRnyhxVdO0lG34SV9EwBbOue5a6ARjal7LiJcDQhD8wQ+FYNw8sHxn/mkbTrgx7W3eUADBYPEQuK9p0gEXl2V0f62GfCg2Be+ytKBi7wNq8mNQ7tg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 12.22.5.234) smtp.rcpttodomain=lists.infradead.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=nvidia.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=NQE3SGHZPvDNn0O6il1UeOnKgjES4b53WOGwHuavpVM=;
 b=Ecw1GyhzmTgaLsp4fkgjc1Tv3e/+8+/wR06w0FIQqmCiliG4HHTro6r6Vlz29a0scBjCQxUXELPwWd254ZPU9KfjkfvXSnSx5q2mTAMpbz4QQU+j7f5HOEWNMYY1MOvpXM0hBjb/Zv1Ff9uqEi8+KwaEZuYW62mIEyPLGAMne2YWOFTui5sG/sNh5EESQZ6QNx0DuIVitUJK5Sf2sxUTHCuzXn87VJ7KdXx4Mvx3juxalPVAM2LuZTXPo3vRHK/UPVyjByOM7A6w5CkETL/ASc5bzCuwtw82YRDiMOuDOBOablJZYn5LZwxmZd+4yJgALcXXtnRjs5OcSxEQL3u7iA==
Received: from MWHPR13CA0030.namprd13.prod.outlook.com (2603:10b6:300:95::16)
 by CY4PR1201MB2503.namprd12.prod.outlook.com (2603:10b6:903:d1::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4778.15; Thu, 16 Dec
 2021 16:57:41 +0000
Received: from CO1NAM11FT024.eop-nam11.prod.protection.outlook.com
 (2603:10b6:300:95:cafe::86) by MWHPR13CA0030.outlook.office365.com
 (2603:10b6:300:95::16) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4801.12 via Frontend
 Transport; Thu, 16 Dec 2021 16:57:41 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 12.22.5.234)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 12.22.5.234 as permitted sender) receiver=protection.outlook.com;
 client-ip=12.22.5.234; helo=mail.nvidia.com;
Received: from mail.nvidia.com (12.22.5.234) by
 CO1NAM11FT024.mail.protection.outlook.com (10.13.174.162) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4801.14 via Frontend Transport; Thu, 16 Dec 2021 16:57:41 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by DRHQMAIL101.nvidia.com
 (10.27.9.10) with Microsoft SMTP Server (TLS) id 15.0.1497.18; Thu, 16 Dec
 2021 16:57:41 +0000
Received: from [172.27.15.177] (172.20.187.5) by rnnvmail201.nvidia.com
 (10.129.68.8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id 15.2.986.9; Thu, 16 Dec 2021
 08:57:38 -0800
Message-ID: <5ee0e257-651a-ec44-7ca3-479438a737fb@nvidia.com>
Date:   Thu, 16 Dec 2021 18:57:36 +0200
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
 <3474493a-a04d-528c-7565-f75db5205074@nvidia.com>
 <87e3a197-e8f7-d8d6-85b6-ce05bf1f35cd@kernel.dk>
From:   Max Gurtovoy <mgurtovoy@nvidia.com>
In-Reply-To: <87e3a197-e8f7-d8d6-85b6-ce05bf1f35cd@kernel.dk>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [172.20.187.5]
X-ClientProxiedBy: HQMAIL111.nvidia.com (172.20.187.18) To
 rnnvmail201.nvidia.com (10.129.68.8)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 711f5c2f-08f7-4131-b49d-08d9c0b52c7b
X-MS-TrafficTypeDiagnostic: CY4PR1201MB2503:EE_
X-Microsoft-Antispam-PRVS: <CY4PR1201MB2503EBD29F7EF8CA3823D90CDE779@CY4PR1201MB2503.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: C5LR++HoTnbZqJIl0f1GYwzeuCgyeGqDViewhyhCh71YsdmtrMrLTXpRygVxdfF1JFZHCb5a9dsuthxwFOWaAtkijhAPub69HBDrDwZMEV/SJMrvB9HFG/Emyj3kClsAVUqsxtxS2xQuGZyPoYNiuF2aOJiyYiSm9z3llvB6yoJbXlFwsejlgrccywURnQyE/Yf5D+cJauyvt7/xrFfREL1/wXm+zVQccSwiiPPH2yevGTaVIuCYpmVPjT7U6es5kVyeZJj0NT5B0KpSvliqj7fh6VO2qrsUQgXNY99yYMWi4mhS0b9Yo8lDzgdRA/s5gufVvymktUWTCBRcgARYQz7PVwud6vrWlHzcOVMsPBPf3hVYN21/B7nwzdOQhRbR/hIWCKunsq+QJiFuucSxY52HoqJBTScxq+0DAGOQD3Wy0FiVqTIfJIR1jyUyQKdRQVEUWJAkJWHG2S9/401Cbym+vu4cIUd8vjHbuBk3yQHGTLAjyMRYiMrd3Yq72FxU1QM0IjTSRMzqHnvK4dNquYWr47Q5zxRk901pnANREBeCQLRKEVB65ax3yfAPdjc00/TJbuyJpsGorShm7+jIb4aCpxRLQltyoBg1U0bswj9Bx/GwC4LNN9nGV7bUcZWTsakPjXhG9MT6Iur2wImMmV5eNEg83bBXq5OAAw0sE3+QUUZ3EkOHJzaL/T3CnmTWlNchulyKpZrZnDz0x/XFfnfLwSlneNwJ11occzU6IXK/4G1C8XgkDA7Szrsd3lDJWwvZZHkVJoYv2AIHH8rYYkJHWzxf3+rM4m6cynu5jHwuXO/sBhJgUWejY3j31a4sD9N4jSKxa+QllyCJSe+RYwgDyhiX/MNz2VRFIWE0wbA=
X-Forefront-Antispam-Report: CIP:12.22.5.234;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:mail.nvidia.com;PTR:InfoNoRecords;CAT:NONE;SFS:(4636009)(36840700001)(46966006)(40470700001)(70206006)(36860700001)(16576012)(316002)(110136005)(8676002)(8936002)(86362001)(31696002)(83380400001)(186003)(82310400004)(26005)(31686004)(54906003)(2616005)(426003)(40460700001)(16526019)(36756003)(5660300002)(53546011)(336012)(34020700004)(2906002)(81166007)(70586007)(356005)(4326008)(508600001)(47076005)(43740500002)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Dec 2021 16:57:41.6616
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 711f5c2f-08f7-4131-b49d-08d9c0b52c7b
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[12.22.5.234];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: CO1NAM11FT024.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY4PR1201MB2503
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org


On 12/16/2021 6:36 PM, Jens Axboe wrote:
> On 12/16/21 9:34 AM, Max Gurtovoy wrote:
>> On 12/16/2021 6:25 PM, Jens Axboe wrote:
>>> On 12/16/21 9:19 AM, Max Gurtovoy wrote:
>>>> On 12/16/2021 6:05 PM, Jens Axboe wrote:
>>>>> On 12/16/21 9:00 AM, Max Gurtovoy wrote:
>>>>>> On 12/16/2021 5:48 PM, Jens Axboe wrote:
>>>>>>> On 12/16/21 6:06 AM, Max Gurtovoy wrote:
>>>>>>>> On 12/16/2021 11:08 AM, Christoph Hellwig wrote:
>>>>>>>>> On Wed, Dec 15, 2021 at 09:24:21AM -0700, Jens Axboe wrote:
>>>>>>>>>> +	spin_lock(&nvmeq->sq_lock);
>>>>>>>>>> +	while (!rq_list_empty(*rqlist)) {
>>>>>>>>>> +		struct request *req = rq_list_pop(rqlist);
>>>>>>>>>> +		struct nvme_iod *iod = blk_mq_rq_to_pdu(req);
>>>>>>>>>> +
>>>>>>>>>> +		memcpy(nvmeq->sq_cmds + (nvmeq->sq_tail << nvmeq->sqes),
>>>>>>>>>> +				absolute_pointer(&iod->cmd), sizeof(iod->cmd));
>>>>>>>>>> +		if (++nvmeq->sq_tail == nvmeq->q_depth)
>>>>>>>>>> +			nvmeq->sq_tail = 0;
>>>>>>>>> So this doesn't even use the new helper added in patch 2?  I think this
>>>>>>>>> should call nvme_sq_copy_cmd().
>>>>>>>> I also noticed that.
>>>>>>>>
>>>>>>>> So need to decide if to open code it or use the helper function.
>>>>>>>>
>>>>>>>> Inline helper sounds reasonable if you have 3 places that will use it.
>>>>>>> Yes agree, that's been my stance too :-)
>>>>>>>
>>>>>>>>> The rest looks identical to the incremental patch I posted, so I guess
>>>>>>>>> the performance degration measured on the first try was a measurement
>>>>>>>>> error?
>>>>>>>> giving 1 dbr for a batch of N commands sounds good idea. Also for RDMA host.
>>>>>>>>
>>>>>>>> But how do you moderate it ? what is the batch_sz <--> time_to_wait
>>>>>>>> algorithm ?
>>>>>>> The batching is naturally limited at BLK_MAX_REQUEST_COUNT, which is 32
>>>>>>> in total. I do agree that if we ever made it much larger, then we might
>>>>>>> want to cap it differently. But 32 seems like a pretty reasonable number
>>>>>>> to get enough gain from the batching done in various areas, while still
>>>>>>> not making it so large that we have a potential latency issue. That
>>>>>>> batch count is already used consistently for other items too (like tag
>>>>>>> allocation), so it's not specific to just this one case.
>>>>>> I'm saying that the you can wait to the batch_max_count too long and it
>>>>>> won't be efficient from latency POV.
>>>>>>
>>>>>> So it's better to limit the block layar to wait for the first to come: x
>>>>>> usecs or batch_max_count before issue queue_rqs.
>>>>> There's no waiting specifically for this, it's just based on the plug.
>>>>> We just won't do more than 32 in that plug. This is really just an
>>>>> artifact of the plugging, and if that should be limited based on "max of
>>>>> 32 or xx time", then that should be done there.
>>>>>
>>>>> But in general I think it's saner and enough to just limit the total
>>>>> size. If we spend more than xx usec building up the plug list, we're
>>>>> doing something horribly wrong. That really should not happen with 32
>>>>> requests, and we'll never eg wait on requests if we're out of tags. That
>>>>> will result in a plug flush to begin with.
>>>> I'm not aware of the plug. I hope to get to it soon.
>>>>
>>>> My concern is if the user application submitted only 28 requests and
>>>> then you'll wait forever ? or for very long time.
>>>>
>>>> I guess not, but I'm asking how do you know how to batch and when to
>>>> stop in case 32 commands won't arrive anytime soon.
>>> The plug is in the stack of the task, so that condition can never
>>> happen. If the application originally asks for 32 but then only submits
>>> 28, then once that last one is submitted the plug is flushed and
>>> requests are issued.
>> So if I'm running fio with --iodepth=28 what will plug do ? send batches
>> of 28 ? or 1 by 1 ?
> --iodepth just controls the overall depth, the batch submit count
> dictates what happens further down. If you run queue depth 28 and submit
> one at the time, then you'll get one at the time further down too. Hence
> the batching is directly driven by what the application is already
> doing.

I see. Thanks for the explanation.

So it works only for io_uring based applications ?

Don't you think it will be a good idea to not depend on applications and 
batch according to some kernel mechanism ?

Wait till X requests or Y usecs (first condition to be fulfilled) before 
submitting the batch to LLD.

Like we do with adaptive completion coalescing/moderation for capable 
devices.


>
>
