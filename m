Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 656DB477848
	for <lists+io-uring@lfdr.de>; Thu, 16 Dec 2021 17:20:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238219AbhLPQUD (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 16 Dec 2021 11:20:03 -0500
Received: from mail-mw2nam10on2045.outbound.protection.outlook.com ([40.107.94.45]:8489
        "EHLO NAM10-MW2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S239421AbhLPQUB (ORCPT <rfc822;io-uring@vger.kernel.org>);
        Thu, 16 Dec 2021 11:20:01 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=M+HFLbFQFuvg89qReT9+kZ4yP8gXeziCdJzErScB+fIHokpnMr+Bh+Ts+0MUAWIzZ+dtuKyN3yguVS3gUMCcYGVVNGsW7MSWHplIzGJ3SYsktYl0VXesiG2t9uJuiMOMHXs9/tRA0aqG56Ud0eHA/6+7kJLruC03e+ehyWPO/9KClXCoEIQJc+CKLRsJNPpXVByVlXE5vqMiOHdxmjqxb90qpEKyBeMYmj3NC3xjb01x4SVzYpUjOEcq+JxnwXLNcTI8wsZK/VmsJr9s86rfuoN8Ievkokn1bzhuoHTpvECvsp3jkXdr/F226famsZqQbhJVTdAWxqM/Op8eJ76wlg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=LBlC97i4wZCSASShaLcvgtuhNewP2pScKueUTW/0j4I=;
 b=NhKjwucjJVlKQTHIl2SHPpoHavX1jg71k8AdISB1wkL57dCRqjoOo5WITh6CTD0MwML/Lce/PMTkMtugnOyr6bJKVWGa61AV/IWj2xnc1jtdQhr2F0+MmKj4fK0+IqDixAIwovmn25BXg+DqI6/Hflmq3O+u0CcvKdRNX58fp6hwuPdXlWG2Ka0NJ6ZZNqxCKdabixVjgLpj83+tr0+bkMoAFW5/Qb2x9rvKdHsUQh5BRK1UemMdfxhGfRAaEnOaKnwFq133d5zE3sEA9x2/sowO0IK9ObHwv0QUJjuItAhV0f5Si013AMspNc//L3RNR7kQ+r9QpCOknY1j8IkNtQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 12.22.5.235) smtp.rcpttodomain=lists.infradead.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=nvidia.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=LBlC97i4wZCSASShaLcvgtuhNewP2pScKueUTW/0j4I=;
 b=p6S33hVECZb9vskTeMLd3p/eiX02epJgsf631ZW8b14O6ny2kyDNloVKHxYZuIO2zSsSUuqzXQQ/PoCGCCkufWrt+g8PoB66muXDAtbcXcw3YsUI8sRu5LipaqL7xF7/fAjQRMeTtJz+8qeE0rHgGInR7hAnw7ghyZg64YhrvQQOhkDyMeXwNIQ3f+Bwbns0hNOJ9YuGCYTvF9HiXpEq1nP1DqSqguc25umvqvo/QCtusFm+NxmRE74rx2bn3ZYQX+S+1pSngiMWw5W18pvmCvuLvSElNFd+KX1ffMOUMKHmdz/XRbsMD898Rl3ZHOdN89LXnCnahwZ/kkCCOT8q6g==
Received: from BN6PR16CA0029.namprd16.prod.outlook.com (2603:10b6:405:14::15)
 by PH0PR12MB5403.namprd12.prod.outlook.com (2603:10b6:510:eb::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4755.20; Thu, 16 Dec
 2021 16:20:00 +0000
Received: from BN8NAM11FT047.eop-nam11.prod.protection.outlook.com
 (2603:10b6:405:14:cafe::8d) by BN6PR16CA0029.outlook.office365.com
 (2603:10b6:405:14::15) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4801.14 via Frontend
 Transport; Thu, 16 Dec 2021 16:20:00 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 12.22.5.235)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 12.22.5.235 as permitted sender) receiver=protection.outlook.com;
 client-ip=12.22.5.235; helo=mail.nvidia.com;
Received: from mail.nvidia.com (12.22.5.235) by
 BN8NAM11FT047.mail.protection.outlook.com (10.13.177.220) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4801.14 via Frontend Transport; Thu, 16 Dec 2021 16:19:59 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by DRHQMAIL107.nvidia.com
 (10.27.9.16) with Microsoft SMTP Server (TLS) id 15.0.1497.18; Thu, 16 Dec
 2021 16:19:59 +0000
Received: from [172.27.15.177] (172.20.187.5) by rnnvmail201.nvidia.com
 (10.129.68.8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id 15.2.986.9; Thu, 16 Dec 2021
 08:19:56 -0800
Message-ID: <d1613b7f-342d-08ad-d655-a6afb89e1847@nvidia.com>
Date:   Thu, 16 Dec 2021 18:19:53 +0200
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
From:   Max Gurtovoy <mgurtovoy@nvidia.com>
In-Reply-To: <5f249c03-5cb2-9978-cd2c-669c0594d1c0@kernel.dk>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [172.20.187.5]
X-ClientProxiedBy: HQMAIL111.nvidia.com (172.20.187.18) To
 rnnvmail201.nvidia.com (10.129.68.8)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 7d8cf5ce-6dd4-49e6-da57-08d9c0afe86b
X-MS-TrafficTypeDiagnostic: PH0PR12MB5403:EE_
X-Microsoft-Antispam-PRVS: <PH0PR12MB540375D0C07AB5CD1F252899DE779@PH0PR12MB5403.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8882;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: BVJu+gI29HclNnwO407IAr+oLTgc6wiacVbItJ7uj9VSVj+5nKnku2XiBA0lsRWorEqve0xjR2GrDBJT5B/qLiFexOqYN8qUpAGoRycdAJrFVNh7E//o8e5VxbG2Aqwi+GNYyXiOngamB+PInFIw5PemuioGbT1+4Ogm0vg+0qOpKL/xLAGTZzXAk75Cdm6Zt6He+fg8gyrx+ylM+neC52R4L/ruTZNaLXHIp1OdX7NuIOFwZ/NLK+tpKYswD6V1KsKlQKMAGcqZJTKSPJ3in+5o5MX1rB6t50NxRDNxUaWLYEvaaHXBsLRGrsFBoAnf8kvM98qk2w+/NgDH9Vnz+e7A9WaCo3PoSOmEG0YFmqQ5IVu7mBfw3Qn4mSbXIjS/xmmdBGxngh6nHXpcrnx+7rLBUoPMK5c88a5GaUDH7ZDsr3qbuUbrT+6fwEkx4+w4/soRMHgjROOD4lG3470kENgtLH/8T7uMuuEZjsZXKvonVyZw6qpLSaNeY+M/uliWMdAGM5sJDq6vdPtOxaX7tLgp7LztpzPSSdms3w4gp/qqMqJBWwyDJRbD/dykNQfJB7vPRGAWqa5jyB5gGUr+5gJHXKMEBDyYcyETCPAq2kzF1LivSt940PKYwyERZDuV9r5L2hoU782bzHveLxdMtk3W2yF4dJm/XJob9Fp73jZ03n1gfFQdnbPUlbrIWqhMDjbSecE4ZyKkY20mbkqbVPNofub7vs71UEGBcAkEVzpMrsT2U6MstbI29ZYetM/T0TiUNPy84COMUcNGAMxKOyrtWQ8l6fRAasuoFI5kDeABYhyGhFVPysfEcJf1yrZX8LOThMQpIf3JHMIrbBx3NRgR3xDEGFkqefAWONEEGlk=
X-Forefront-Antispam-Report: CIP:12.22.5.235;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:mail.nvidia.com;PTR:InfoNoRecords;CAT:NONE;SFS:(4636009)(46966006)(36840700001)(40470700001)(47076005)(36756003)(53546011)(26005)(16526019)(34020700004)(40460700001)(83380400001)(6666004)(316002)(186003)(110136005)(508600001)(2906002)(2616005)(8936002)(336012)(4326008)(82310400004)(36860700001)(31696002)(70206006)(5660300002)(81166007)(70586007)(426003)(31686004)(54906003)(8676002)(86362001)(356005)(16576012)(43740500002)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Dec 2021 16:19:59.8953
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 7d8cf5ce-6dd4-49e6-da57-08d9c0afe86b
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[12.22.5.235];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT047.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR12MB5403
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org


On 12/16/2021 6:05 PM, Jens Axboe wrote:
> On 12/16/21 9:00 AM, Max Gurtovoy wrote:
>> On 12/16/2021 5:48 PM, Jens Axboe wrote:
>>> On 12/16/21 6:06 AM, Max Gurtovoy wrote:
>>>> On 12/16/2021 11:08 AM, Christoph Hellwig wrote:
>>>>> On Wed, Dec 15, 2021 at 09:24:21AM -0700, Jens Axboe wrote:
>>>>>> +	spin_lock(&nvmeq->sq_lock);
>>>>>> +	while (!rq_list_empty(*rqlist)) {
>>>>>> +		struct request *req = rq_list_pop(rqlist);
>>>>>> +		struct nvme_iod *iod = blk_mq_rq_to_pdu(req);
>>>>>> +
>>>>>> +		memcpy(nvmeq->sq_cmds + (nvmeq->sq_tail << nvmeq->sqes),
>>>>>> +				absolute_pointer(&iod->cmd), sizeof(iod->cmd));
>>>>>> +		if (++nvmeq->sq_tail == nvmeq->q_depth)
>>>>>> +			nvmeq->sq_tail = 0;
>>>>> So this doesn't even use the new helper added in patch 2?  I think this
>>>>> should call nvme_sq_copy_cmd().
>>>> I also noticed that.
>>>>
>>>> So need to decide if to open code it or use the helper function.
>>>>
>>>> Inline helper sounds reasonable if you have 3 places that will use it.
>>> Yes agree, that's been my stance too :-)
>>>
>>>>> The rest looks identical to the incremental patch I posted, so I guess
>>>>> the performance degration measured on the first try was a measurement
>>>>> error?
>>>> giving 1 dbr for a batch of N commands sounds good idea. Also for RDMA host.
>>>>
>>>> But how do you moderate it ? what is the batch_sz <--> time_to_wait
>>>> algorithm ?
>>> The batching is naturally limited at BLK_MAX_REQUEST_COUNT, which is 32
>>> in total. I do agree that if we ever made it much larger, then we might
>>> want to cap it differently. But 32 seems like a pretty reasonable number
>>> to get enough gain from the batching done in various areas, while still
>>> not making it so large that we have a potential latency issue. That
>>> batch count is already used consistently for other items too (like tag
>>> allocation), so it's not specific to just this one case.
>> I'm saying that the you can wait to the batch_max_count too long and it
>> won't be efficient from latency POV.
>>
>> So it's better to limit the block layar to wait for the first to come: x
>> usecs or batch_max_count before issue queue_rqs.
> There's no waiting specifically for this, it's just based on the plug.
> We just won't do more than 32 in that plug. This is really just an
> artifact of the plugging, and if that should be limited based on "max of
> 32 or xx time", then that should be done there.
>
> But in general I think it's saner and enough to just limit the total
> size. If we spend more than xx usec building up the plug list, we're
> doing something horribly wrong. That really should not happen with 32
> requests, and we'll never eg wait on requests if we're out of tags. That
> will result in a plug flush to begin with.

I'm not aware of the plug. I hope to get to it soon.

My concern is if the user application submitted only 28 requests and 
then you'll wait forever ? or for very long time.

I guess not, but I'm asking how do you know how to batch and when to 
stop in case 32 commands won't arrive anytime soon.

>
>> Also, This batch is per HW queue or SW queue or the entire request queue ?
> It's per submitter, so whatever the submitter ends up queueing IO
> against. In general it'll be per-queue.

struct request_queue ?

I think the best is to batch per struct blk_mq_hw_ctx.

I see that you check this in the nvme_pci driver but shouldn't it go to 
the block layer ?

>
