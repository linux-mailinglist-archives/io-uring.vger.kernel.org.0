Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4B3DF47A794
	for <lists+io-uring@lfdr.de>; Mon, 20 Dec 2021 11:12:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230424AbhLTKMG (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 20 Dec 2021 05:12:06 -0500
Received: from mail-bn1nam07on2088.outbound.protection.outlook.com ([40.107.212.88]:23560
        "EHLO NAM02-BN1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S230422AbhLTKMF (ORCPT <rfc822;io-uring@vger.kernel.org>);
        Mon, 20 Dec 2021 05:12:05 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Se8hkLadHa2wxxUtyx+xg/+E3YkoaUUgaqVkEQzUCEntIrUIahzQUPX0WtjdXA6d5xgXA9ApiQYzer1fQt02ZzwXDngUrWnCX4Bw3CPiVWfsV40iCpeVaWkxZj+dHVDDk3zLlyOcaBBR/x53aoFmjg0d1eOsTvorNEcSW08k60CcGxHMT9bS/7ORmMtZ8+dSfO8DLCURS5K11CCy5i5/m7p76drbKV5ARoRlOtYi3z5Zt2Q92cqSlfINMk2n8uzh0o+qD6VlIdffvJgeWnWjoyNq3UN812OUV58Jdxv7/fpeU/52tlR9/DjpAKeJXUH1+56K/veqvrMwEdCcvEz9lQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=d5bHPD/0KW6i0E1L3YRq9mou8cvXfVcUrFd+U+ZhVb8=;
 b=ho8JE80oiEAGmVlMPLv/3aAyRyCzGDPpVkqJmRLO3pkgQS2QE0lJ38avr24gAFM5tCLR5VeqmNRaAj2jm4uZfrbgnbtVMBWMTOrGLfijIeNCIb78R5XTUJi7GZdN/MjBD4jLiH0MaCFFFWIT8veN/j/DwakQzG4ycq2hx9AEt0JGOzOhMI4/vhxjL8GJk7lzounpyzSGA28NYExICvzzXD86edtsZODjZQfZyuArIolzBpmQPWq5s/H2e+v0D90PQtYzHKEU2Q+aR/siWeg1E98RtAuVBYCwQTLJr5asVHIXSOB2BxYYDb0RExVDC136nEbxnFXfodw9JCCXfbU3Bw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 12.22.5.235) smtp.rcpttodomain=lists.infradead.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=nvidia.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=d5bHPD/0KW6i0E1L3YRq9mou8cvXfVcUrFd+U+ZhVb8=;
 b=tvIhAVgGsGJOnzQt9p/z1tqhThgZUuG6TcNkZdjeugyV21i97BqoPyraN8MFJKFWiEsAoV9Rrxz1ua5DpQewtWRfHBRoBY3c6hXySfNgyyu1Xm0rHi/YVfrkoys9pSBKvcvpzyrEYkO3O1SVwoBpwIrbS9clRGSE/DCkS5FXw6YzwAZ1GwHYFOctFycEORi6qI5hEBlWaBFGFfaN0lCI2XFHk0nUA6YKyYk1XOQvEyMRNu6chHigq59lq5qiA4dejvpbmw4nBwHjJKN233cgnby6GFf971BlYpnmlPAovgShjBIqikRf08N8OFAIBsEIfUA7HCE8oJsyKcsMeSVnHw==
Received: from DS7PR03CA0258.namprd03.prod.outlook.com (2603:10b6:5:3b3::23)
 by BN8PR12MB3617.namprd12.prod.outlook.com (2603:10b6:408:47::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4801.14; Mon, 20 Dec
 2021 10:12:03 +0000
Received: from DM6NAM11FT056.eop-nam11.prod.protection.outlook.com
 (2603:10b6:5:3b3:cafe::2e) by DS7PR03CA0258.outlook.office365.com
 (2603:10b6:5:3b3::23) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4801.20 via Frontend
 Transport; Mon, 20 Dec 2021 10:12:03 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 12.22.5.235)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 12.22.5.235 as permitted sender) receiver=protection.outlook.com;
 client-ip=12.22.5.235; helo=mail.nvidia.com;
Received: from mail.nvidia.com (12.22.5.235) by
 DM6NAM11FT056.mail.protection.outlook.com (10.13.173.99) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4801.14 via Frontend Transport; Mon, 20 Dec 2021 10:12:03 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by DRHQMAIL107.nvidia.com
 (10.27.9.16) with Microsoft SMTP Server (TLS) id 15.0.1497.18; Mon, 20 Dec
 2021 10:12:02 +0000
Received: from [172.27.13.95] (172.20.187.5) by rnnvmail201.nvidia.com
 (10.129.68.8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id 15.2.986.9; Mon, 20 Dec 2021
 02:12:00 -0800
Message-ID: <4fbf2936-8e4c-9c04-e5a9-10eae387b562@nvidia.com>
Date:   Mon, 20 Dec 2021 12:11:57 +0200
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
From:   Max Gurtovoy <mgurtovoy@nvidia.com>
In-Reply-To: <573bbe72-d232-6063-dd34-2e12d8374594@kernel.dk>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [172.20.187.5]
X-ClientProxiedBy: HQMAIL107.nvidia.com (172.20.187.13) To
 rnnvmail201.nvidia.com (10.129.68.8)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 965bcef6-db04-49fc-33bd-08d9c3a12b92
X-MS-TrafficTypeDiagnostic: BN8PR12MB3617:EE_
X-Microsoft-Antispam-PRVS: <BN8PR12MB361729C5D939AD5F376AD677DE7B9@BN8PR12MB3617.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8882;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: GTnU/yLhrWcIpGXnTndI8c+9fxDFIfCHB3M0omMkai4Hipm6ci6m9bbHkmtzrB6nss++19v3ZixvaGgO5tH1+dpFawOuMDydKc+2hWUOn3IhpHA29pm1IOO2uts3EMKrk7uwazxGomyv/fQ0hHYEDrNJcLipZqKvPPu8N6+0abPOl6Uoo0pXTx1OeB7HXALb4ZvFKapoKihReVqOHaSfNkpZ9tZ8ZrsSUnWirtvNrOkd5EcLQQwgjBTJexCv1Poj5ym3uFNwQlsmq0Z+znVx6TwxBUH9ksXVOPREjBJgyvlyhh10YAmWT8RduhgufHBZ1plHhlhpShnol0DLMRpokPH6bhuBPN1d3fWueVPUXfmIskCyOjbMvPMx8U/eXBOYzReQKgVmE4hMGoKQXHklkuUDbwSRTTP06I2mBNT9/wNmAQTHpC53JDNFaAF6rsVU4ikKo2ljJhtFKz9Z5ICf5xcmuaAwUlDNjmLKr/7LBA6Fn4ooDsWGlKiGqvOssIdcJpT56FySs4p6RD65YwBDua3fqUUc19Ps9i2+L27ypfi/pIE5afK3S2va1rqilWOdKntShNZEPLphHuG3TrOJ0l5cb59jkR937Ezf8k3BXcaTvslqcpjs6IYA5/OqgoBDGh1L83/vGrGjX3aycmezwac58knke/8xb0O9uTfrFSKROgPZhrkX7kgvkkCgzPzXDv3BsRx3I4mqszSXSpOXm+sRgdrWJcFaraUU3c2K6Rt4DFWmGmzdOsjWyvW0qDSApg05IOTvXam53AEildUcSLC0jNkAbC1ZWmSOf2xf5yrePG33GiLWM9j23fhXbdKstvgIbrmwqCYY6XDdVGFjjT87NMnyBaCZQrE1LD0JJE0=
X-Forefront-Antispam-Report: CIP:12.22.5.235;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:mail.nvidia.com;PTR:InfoNoRecords;CAT:NONE;SFS:(4636009)(46966006)(36840700001)(40470700001)(70206006)(336012)(36860700001)(16526019)(356005)(186003)(5660300002)(426003)(81166007)(82310400004)(86362001)(2906002)(70586007)(40460700001)(54906003)(316002)(2616005)(83380400001)(31696002)(4326008)(8676002)(16576012)(31686004)(34020700004)(8936002)(26005)(107886003)(47076005)(53546011)(6666004)(36756003)(508600001)(110136005)(43740500002)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Dec 2021 10:12:03.6538
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 965bcef6-db04-49fc-33bd-08d9c3a12b92
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[12.22.5.235];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT056.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN8PR12MB3617
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org


On 12/19/2021 4:48 PM, Jens Axboe wrote:
> On 12/19/21 5:14 AM, Max Gurtovoy wrote:
>> On 12/16/2021 7:16 PM, Jens Axboe wrote:
>>> On 12/16/21 9:57 AM, Max Gurtovoy wrote:
>>>> On 12/16/2021 6:36 PM, Jens Axboe wrote:
>>>>> On 12/16/21 9:34 AM, Max Gurtovoy wrote:
>>>>>> On 12/16/2021 6:25 PM, Jens Axboe wrote:
>>>>>>> On 12/16/21 9:19 AM, Max Gurtovoy wrote:
>>>>>>>> On 12/16/2021 6:05 PM, Jens Axboe wrote:
>>>>>>>>> On 12/16/21 9:00 AM, Max Gurtovoy wrote:
>>>>>>>>>> On 12/16/2021 5:48 PM, Jens Axboe wrote:
>>>>>>>>>>> On 12/16/21 6:06 AM, Max Gurtovoy wrote:
>>>>>>>>>>>> On 12/16/2021 11:08 AM, Christoph Hellwig wrote:
>>>>>>>>>>>>> On Wed, Dec 15, 2021 at 09:24:21AM -0700, Jens Axboe wrote:
>>>>>>>>>>>>>> +	spin_lock(&nvmeq->sq_lock);
>>>>>>>>>>>>>> +	while (!rq_list_empty(*rqlist)) {
>>>>>>>>>>>>>> +		struct request *req = rq_list_pop(rqlist);
>>>>>>>>>>>>>> +		struct nvme_iod *iod = blk_mq_rq_to_pdu(req);
>>>>>>>>>>>>>> +
>>>>>>>>>>>>>> +		memcpy(nvmeq->sq_cmds + (nvmeq->sq_tail << nvmeq->sqes),
>>>>>>>>>>>>>> +				absolute_pointer(&iod->cmd), sizeof(iod->cmd));
>>>>>>>>>>>>>> +		if (++nvmeq->sq_tail == nvmeq->q_depth)
>>>>>>>>>>>>>> +			nvmeq->sq_tail = 0;
>>>>>>>>>>>>> So this doesn't even use the new helper added in patch 2?  I think this
>>>>>>>>>>>>> should call nvme_sq_copy_cmd().
>>>>>>>>>>>> I also noticed that.
>>>>>>>>>>>>
>>>>>>>>>>>> So need to decide if to open code it or use the helper function.
>>>>>>>>>>>>
>>>>>>>>>>>> Inline helper sounds reasonable if you have 3 places that will use it.
>>>>>>>>>>> Yes agree, that's been my stance too :-)
>>>>>>>>>>>
>>>>>>>>>>>>> The rest looks identical to the incremental patch I posted, so I guess
>>>>>>>>>>>>> the performance degration measured on the first try was a measurement
>>>>>>>>>>>>> error?
>>>>>>>>>>>> giving 1 dbr for a batch of N commands sounds good idea. Also for RDMA host.
>>>>>>>>>>>>
>>>>>>>>>>>> But how do you moderate it ? what is the batch_sz <--> time_to_wait
>>>>>>>>>>>> algorithm ?
>>>>>>>>>>> The batching is naturally limited at BLK_MAX_REQUEST_COUNT, which is 32
>>>>>>>>>>> in total. I do agree that if we ever made it much larger, then we might
>>>>>>>>>>> want to cap it differently. But 32 seems like a pretty reasonable number
>>>>>>>>>>> to get enough gain from the batching done in various areas, while still
>>>>>>>>>>> not making it so large that we have a potential latency issue. That
>>>>>>>>>>> batch count is already used consistently for other items too (like tag
>>>>>>>>>>> allocation), so it's not specific to just this one case.
>>>>>>>>>> I'm saying that the you can wait to the batch_max_count too long and it
>>>>>>>>>> won't be efficient from latency POV.
>>>>>>>>>>
>>>>>>>>>> So it's better to limit the block layar to wait for the first to come: x
>>>>>>>>>> usecs or batch_max_count before issue queue_rqs.
>>>>>>>>> There's no waiting specifically for this, it's just based on the plug.
>>>>>>>>> We just won't do more than 32 in that plug. This is really just an
>>>>>>>>> artifact of the plugging, and if that should be limited based on "max of
>>>>>>>>> 32 or xx time", then that should be done there.
>>>>>>>>>
>>>>>>>>> But in general I think it's saner and enough to just limit the total
>>>>>>>>> size. If we spend more than xx usec building up the plug list, we're
>>>>>>>>> doing something horribly wrong. That really should not happen with 32
>>>>>>>>> requests, and we'll never eg wait on requests if we're out of tags. That
>>>>>>>>> will result in a plug flush to begin with.
>>>>>>>> I'm not aware of the plug. I hope to get to it soon.
>>>>>>>>
>>>>>>>> My concern is if the user application submitted only 28 requests and
>>>>>>>> then you'll wait forever ? or for very long time.
>>>>>>>>
>>>>>>>> I guess not, but I'm asking how do you know how to batch and when to
>>>>>>>> stop in case 32 commands won't arrive anytime soon.
>>>>>>> The plug is in the stack of the task, so that condition can never
>>>>>>> happen. If the application originally asks for 32 but then only submits
>>>>>>> 28, then once that last one is submitted the plug is flushed and
>>>>>>> requests are issued.
>>>>>> So if I'm running fio with --iodepth=28 what will plug do ? send batches
>>>>>> of 28 ? or 1 by 1 ?
>>>>> --iodepth just controls the overall depth, the batch submit count
>>>>> dictates what happens further down. If you run queue depth 28 and submit
>>>>> one at the time, then you'll get one at the time further down too. Hence
>>>>> the batching is directly driven by what the application is already
>>>>> doing.
>>>> I see. Thanks for the explanation.
>>>>
>>>> So it works only for io_uring based applications ?
>>> It's only enabled for io_uring right now, but it's generically available
>>> for anyone that wants to use it... Would be trivial to do for aio, and
>>> other spots that currently use blk_start_plug() and has an idea of how
>>> many IOs will be submitted
>> Can you please share an example application (or is it fio patches) that
>> can submit batches ? The same that was used to test this patchset is
>> fine too.
>>
>> I would like to test it with our NVMe SNAP controllers and also to
>> develop NVMe/RDMA queue_rqs code and test the perf with it.
> You should just be able to use iodepth_batch with fio. For my peak
> testing, I use t/io_uring from the fio repo. By default, it'll run QD of
> and do batches of 32 for complete and submit. You can just run:
>
> t/io_uring <dev or file>
>
> maybe adding -p0 for IRQ driven rather than polled IO.

I used your block/for-next branch and implemented queue_rqs in NVMe/RDMA 
but it was never called using the t/io_uring test nor fio with 
iodepth_batch=32 flag with io_uring engine.

Any idea what might be the issue ?

I installed fio from sources..

