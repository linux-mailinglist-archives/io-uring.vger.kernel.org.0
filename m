Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2E8DB4772AF
	for <lists+io-uring@lfdr.de>; Thu, 16 Dec 2021 14:06:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234693AbhLPNGu (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 16 Dec 2021 08:06:50 -0500
Received: from mail-mw2nam08on2060.outbound.protection.outlook.com ([40.107.101.60]:39937
        "EHLO NAM04-MW2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S234670AbhLPNGt (ORCPT <rfc822;io-uring@vger.kernel.org>);
        Thu, 16 Dec 2021 08:06:49 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=jL27jOONSA0qIfLBIDhR51rgMlGYlFO7Z3E+H4MXccYDUXxeI4BA3hRCPYzDulvxQc24mwaBh2sjGq8zhgkm9xqD63FTJ7e8XlKQbe3Jraig3+Fz9SUI2JHS6ilh7rabHo82cFvJtop1cMffZAWdqJE2KHUDvkpMjgGTqzNraHVaVq5IvJXG/5Tv8evgj0NTFq2VeGWwMvxmQteVKWYESRLaQl5Wxg6e9wZ8ddOU57m4twj7YTYg6qxoKTvh0IPtTc69zhfGTWzxtoyobukO6AOi+/AUW9F1G/5p4fLANF7Hxq2vLop1JLC1GtK5SxVvrqc8Iy7vvaSJP0oneSArJw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=PU4IhdzdQ8NYWER2MGTQqC2fh1lCcX9ys+Ucg/+d3Pk=;
 b=m5MKh7XLCC3uX8U3r0NqYyinMx1qHMufCo3SM082BG/yTrnIMspvtPR0u6w3x4FEVS3Ox87rHz2PN/Wq6XOBqgWup2ppPc6fO9jd1aeuwQnEanX7Nd+a+kR21ECatYYWco6XL/hZCWqWV0QzwOm49pQhKnBNAmbJlCUTIecl2NdRN4/Hj0n6ZZx5541sSXojtigESrZjNoDfRHzSmfH44tnZ5yHTcO3+YYquQYgOHQ8diSShv0K4PidlzILDo+wyh3FYODErGdp/5JhuxOVF0o2lzu9H9KIiIQGRXog7+1GpQcm+2hbPLFHz/As4QkSW02yCNUszeXPsmgoDpVyIog==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 12.22.5.236) smtp.rcpttodomain=lists.infradead.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=nvidia.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=PU4IhdzdQ8NYWER2MGTQqC2fh1lCcX9ys+Ucg/+d3Pk=;
 b=tD5e1dLGQEvXMA86JTv5XHfdYxPfXjey+x9C/66NC0IzohhD6uMQ729S3M4Qad77KLrEBAfSmZ+qQlpV5rHAwwZ6/3PTH7ak7ix/obeRMapHAIemXBb6eRp20Tf39Dvm0J6Ea7eGKHNO2yKVELdexiHcbUN5DZ8j3mOv4RRrZ1a8yXKJzjl04JhYGclaZdq383IpC82BX0oRPlfUrGJyZoFwDStwMYN4GUOwf8Cd73DDt5j2Q6OuyK2UpaRNQaLTA1RYKO/LkW/5QD8MHu2NEeGhx3VDpx+7fjzF5NhxIzrmQz09w3OcRQfyt+1AhKJVQR0XbxSG02dhMepotU4Jyg==
Received: from DM5PR13CA0003.namprd13.prod.outlook.com (2603:10b6:3:23::13) by
 CY4PR1201MB0165.namprd12.prod.outlook.com (2603:10b6:910:1c::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4778.17; Thu, 16 Dec
 2021 13:06:47 +0000
Received: from DM6NAM11FT044.eop-nam11.prod.protection.outlook.com
 (2603:10b6:3:23:cafe::a7) by DM5PR13CA0003.outlook.office365.com
 (2603:10b6:3:23::13) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4823.8 via Frontend
 Transport; Thu, 16 Dec 2021 13:06:47 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 12.22.5.236)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 12.22.5.236 as permitted sender) receiver=protection.outlook.com;
 client-ip=12.22.5.236; helo=mail.nvidia.com;
Received: from mail.nvidia.com (12.22.5.236) by
 DM6NAM11FT044.mail.protection.outlook.com (10.13.173.185) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4801.14 via Frontend Transport; Thu, 16 Dec 2021 13:06:47 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by DRHQMAIL109.nvidia.com
 (10.27.9.19) with Microsoft SMTP Server (TLS) id 15.0.1497.18; Thu, 16 Dec
 2021 13:06:46 +0000
Received: from [172.27.15.177] (172.20.187.6) by rnnvmail201.nvidia.com
 (10.129.68.8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id 15.2.986.9; Thu, 16 Dec 2021
 05:06:44 -0800
Message-ID: <2adafc43-3860-d9f0-9cb5-ca3bf9a27109@nvidia.com>
Date:   Thu, 16 Dec 2021 15:06:42 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.3.2
Subject: Re: [PATCH 4/4] nvme: add support for mq_ops->queue_rqs()
Content-Language: en-US
To:     Christoph Hellwig <hch@infradead.org>, Jens Axboe <axboe@kernel.dk>
CC:     <io-uring@vger.kernel.org>, <linux-nvme@lists.infradead.org>,
        "Hannes Reinecke" <hare@suse.de>
References: <20211215162421.14896-1-axboe@kernel.dk>
 <20211215162421.14896-5-axboe@kernel.dk> <YbsB/W/1Uwok4i0u@infradead.org>
From:   Max Gurtovoy <mgurtovoy@nvidia.com>
In-Reply-To: <YbsB/W/1Uwok4i0u@infradead.org>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [172.20.187.6]
X-ClientProxiedBy: HQMAIL111.nvidia.com (172.20.187.18) To
 rnnvmail201.nvidia.com (10.129.68.8)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: e83043e9-4ef4-422a-3813-08d9c094eaa0
X-MS-TrafficTypeDiagnostic: CY4PR1201MB0165:EE_
X-Microsoft-Antispam-PRVS: <CY4PR1201MB0165948427892E65403CCB3ADE779@CY4PR1201MB0165.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:4303;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 2yOPd9s5MF0c1mkXiEGtjDHDwH+jf3qSkqoesoy3+MlXyLSLJ3DDthFhbTjrA9IU62y9BGVHxTsYNTlFb0yK3rnsGc3TLF++lpqBAXbBs6+geOfhErcNTpY7y+rsBdV+j4P+dd1TN7mz0wc6ZZ9BbSCQIglI4maw5gLPNmX8hLKbv5W8atVC3hUneRdYaR1vHvnvufcVrfVOM2NmhPS8SeU6luxcJ2vxyNoq0vY5WWyA4iTM4ckgNLTz5Hr00wIH8YDGzcY2hjtcnHa3AULVcNXaKpsqs0jjQYOSdGL2RV2ZGIIuRUzpjsSTSALJHKahJ54lljvWcDcAfaN/H6Eo2OQup9THx2kbdNlmt3b/fnRQ/7IVY+pXzrp/P+ASaCxTeEwYJN7Uoe/wlJTyoWL3bHlPkd3juOn/R56CkeLpTlic7ckQ77LCLKeCj+I3cOt3duUmucAdGvE8HfXB0iZmRmkmdx2ebxxBv70qHXn3+1UmWrW9Eyn/hZwsagyVu0Hwnd/8KvsGFcBldlh17B6nJI1y+C+gPvkVWtfJzFDQlZYqcCHKtn+o11pzp9lRjEMxxaMizsFntFRNgxmJ3h9kMbv3QEyngfF7fy1EhX/BWzLo6Dviq7QwiAnM3y5/pL1b8bjyRhWDfBOy4F1rOXU1M/U0CdFMLqBOmmd9XKXjotRWCxUgvoYXL84jhVo6ohnICiqF8+yvhr6daP2KeeIEFezFuM4Rvj0XR5pXsK/hT1dZ7m5O6odW2uW4hVJ4ldQhvH4xBTsUY43HnTbgnTuh9u+g8Q2ZAT310Jhf4luEUS/vwNdRCra3MyNfkFp0Dk/kVnG8p0D+FHLYtyRsjEcFkPy7JFIO6Zd9zroVGS3XgSs=
X-Forefront-Antispam-Report: CIP:12.22.5.236;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:mail.nvidia.com;PTR:InfoNoRecords;CAT:NONE;SFS:(4636009)(36840700001)(46966006)(40470700001)(2616005)(26005)(16526019)(186003)(8676002)(4326008)(81166007)(53546011)(83380400001)(336012)(34020700004)(426003)(16576012)(316002)(70206006)(36756003)(82310400004)(40460700001)(70586007)(86362001)(5660300002)(8936002)(36860700001)(356005)(31686004)(2906002)(508600001)(110136005)(31696002)(54906003)(47076005)(43740500002)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Dec 2021 13:06:47.2447
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: e83043e9-4ef4-422a-3813-08d9c094eaa0
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[12.22.5.236];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT044.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY4PR1201MB0165
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org


On 12/16/2021 11:08 AM, Christoph Hellwig wrote:
> On Wed, Dec 15, 2021 at 09:24:21AM -0700, Jens Axboe wrote:
>> +	spin_lock(&nvmeq->sq_lock);
>> +	while (!rq_list_empty(*rqlist)) {
>> +		struct request *req = rq_list_pop(rqlist);
>> +		struct nvme_iod *iod = blk_mq_rq_to_pdu(req);
>> +
>> +		memcpy(nvmeq->sq_cmds + (nvmeq->sq_tail << nvmeq->sqes),
>> +				absolute_pointer(&iod->cmd), sizeof(iod->cmd));
>> +		if (++nvmeq->sq_tail == nvmeq->q_depth)
>> +			nvmeq->sq_tail = 0;
> So this doesn't even use the new helper added in patch 2?  I think this
> should call nvme_sq_copy_cmd().

I also noticed that.

So need to decide if to open code it or use the helper function.

Inline helper sounds reasonable if you have 3 places that will use it.

> The rest looks identical to the incremental patch I posted, so I guess
> the performance degration measured on the first try was a measurement
> error?

giving 1 dbr for a batch of N commands sounds good idea. Also for RDMA host.

But how do you moderate it ? what is the batch_sz <--> time_to_wait 
algorithm ?

