Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B0BF33E3046
	for <lists+io-uring@lfdr.de>; Fri,  6 Aug 2021 22:19:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244924AbhHFUUB (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 6 Aug 2021 16:20:01 -0400
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:39654 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S244883AbhHFUUB (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 6 Aug 2021 16:20:01 -0400
Received: from pps.filterd (m0089730.ppops.net [127.0.0.1])
        by m0089730.ppops.net (8.16.0.43/8.16.0.43) with SMTP id 176KEBEI013964
        for <io-uring@vger.kernel.org>; Fri, 6 Aug 2021 13:19:44 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=to : from : subject :
 message-id : date : content-type : content-transfer-encoding :
 mime-version; s=facebook; bh=89qxTIhuvMEQz23EVnc+yQUUIjW8QZooOkCN9TUKF5k=;
 b=PEtEAIMt0mVBAS/ICCRL8lWQ9ptWaIr+kY5WSEQdd/NzoIGmcCo4DIwcMueoXOyCD8mo
 Ps2xTxLt57nO0S/bKU2iBbu70EQ2oSqzBGCif9cIjysHaXJOFSWkLmeOm2wsKY2+4dsl
 sqMJ4vTcR8KPOWQuDioT7sBSzp4vlkb1zJw= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by m0089730.ppops.net with ESMTP id 3a8jh88e2a-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <io-uring@vger.kernel.org>; Fri, 06 Aug 2021 13:19:44 -0700
Received: from NAM02-SN1-obe.outbound.protection.outlook.com (100.104.31.183)
 by o365-in.thefacebook.com (100.104.36.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Fri, 6 Aug 2021 13:19:43 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=HeULD7W0FiqtKKNA2pM86ZaJn8G4nBGbQ16Afd3gkGG7mxXBU3bDJiVbl3TxAoUdnfKQs4rflEbx/0wau60kNEkGKEEoWT04XXnJ2tS1C6Qx3gLiCDrKaXalv5odWWUzla/UJz2y3uGjCGXG+kOyeatERQDsFd40QyuPeSZgr9jBTYBOo9pbvVG6ri8/tPoavi+SCB8ygDfpz5euuzR36dpxnxsr9qMPgyLz9i6OqoKoNCbNDHjIlfY/RtBgf96ZI9pavYoEPCqyVQ62++SWWEvFZSs5BSLANw4q9tB0IwcET6uXi9ZXrVTMPU6/fxh2JgAZEcz7gU0MPljsuSYtFw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=89qxTIhuvMEQz23EVnc+yQUUIjW8QZooOkCN9TUKF5k=;
 b=leIQsKKX5VOLgJdLqy4Ak1RV8z1jPadg/I8UFpRqAXQkccPhWO4lzl9LDbCxBZ3Su9sx3VWH6FgXVKzkM4YgH1mbEydeZDukc7kNXsbmn+DB3lAKZ5tM5k/fF/1XTVybQkvts5ycl/QF33p2rDI6Yf+Tj6RnGxmAhtckJyYNlo0EES5JhzsPjJjdG38XGdFyTDyilf8d69Rxo/jVIjRMR/0Fo5jlyVtr5h2vpiO975Jw76SZJ27Ply/quVt711QBrxYbTKDL4RXDCmzxTZSyJ+G3QslF//SCmw7R9z4t7NV0wOfCPRAg7zfT4zXMpErB+UF5wVlnPgb65KoNz4nizg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=fb.com;
Received: from BYAPR15MB2566.namprd15.prod.outlook.com (2603:10b6:a03:150::24)
 by SJ0PR15MB4663.namprd15.prod.outlook.com (2603:10b6:a03:37c::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4394.16; Fri, 6 Aug
 2021 20:19:42 +0000
Received: from BYAPR15MB2566.namprd15.prod.outlook.com
 ([fe80::f95c:3d80:7dcb:c68d]) by BYAPR15MB2566.namprd15.prod.outlook.com
 ([fe80::f95c:3d80:7dcb:c68d%3]) with mapi id 15.20.4373.026; Fri, 6 Aug 2021
 20:19:42 +0000
To:     io-uring <io-uring@vger.kernel.org>
From:   Jens Axboe <axboe@fb.com>
Subject: [PATCH] io_uring: be smarter about waking multiple CQ ring waiters
Message-ID: <27997f97-68cc-63c3-863b-b0c460bc42c0@fb.com>
Date:   Fri, 6 Aug 2021 14:19:40 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: BYAPR05CA0053.namprd05.prod.outlook.com
 (2603:10b6:a03:74::30) To BYAPR15MB2566.namprd15.prod.outlook.com
 (2603:10b6:a03:150::24)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [192.168.1.116] (198.8.77.61) by BYAPR05CA0053.namprd05.prod.outlook.com (2603:10b6:a03:74::30) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4415.5 via Frontend Transport; Fri, 6 Aug 2021 20:19:42 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 5408c97e-3fac-40c8-614b-08d959178643
X-MS-TrafficTypeDiagnostic: SJ0PR15MB4663:
X-Microsoft-Antispam-PRVS: <SJ0PR15MB4663C3EAFD38896A7CEE883EC0F39@SJ0PR15MB4663.namprd15.prod.outlook.com>
X-FB-Source: Internal
X-MS-Oob-TLC-OOBClassifiers: OLM:8273;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: CTLdxUCrLXgiQqByUnK6ecj3lI8voPfG/C0fkfSGBoZCSsrlHUHMq+Ci4TZFJcKuCzWYALNtChlk6VjiznDiUJqzE/dHbEE5jrNIvMSdy7BpTJXG80i9kZISXOXtESwIjOpPL9Dm6iLm2PBbfyaPV1Z4glYDmbCB15DbVWX50iOEhCoG/JB8eKbpC1ukh/bmw1usqvhOdVvCuBMcLmRE8sKwwsuiT39dy2hKRmVQ+dWgYFWTtllva1dDT0WROmoMAf2Y/ylxXvEzHzeiNZ1qfaAxCkpBLVMw8xE0K4ImVj41EWRxoFl3yvyu83Gry4t4Ouw0TL9zU5bfM+55JF4JbwhmA8ng+WqFr38hy8DU1tIzLtvOy4pvGHJHxR9nFtji3oVjcbJcTqQUpBCXszcQFJsv3+/NydbuISyXrLX1IKItdAoTsq7eSbxzrA0R7TOUunnc79jl54f1o5Li4I6DoSsYlmlVRiCB08emznoeAUHEQUzn3OG1VrbVCAenEUiUJe7r5LGNOgGIlhcJ9c54fFGZTX/Q9pDtSlCUv4ZvRvsErxxxWVvH4RcMuBJaLZgjne9YCw9NEtYEUjhz9tx/6xB5j27Dm4EghUrQTKhMADCxd/AegxAn1IZR5sqmeJmoNHxYU3rO3qE4KsGN7C1NDR7nL89lB/zyY9xsGMsZ186SpUoGKmKKUvUv91XCPU3C8ROfGLkCdqgbuBTGLY+iqMYFBX5dYQR2SOOk4rmfvEFpJ82xpy/u4/AfkvpLaotYwG70jJBWipkvbtzYYICJlg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR15MB2566.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(39860400002)(136003)(346002)(376002)(396003)(366004)(5660300002)(66476007)(36756003)(66556008)(38350700002)(8936002)(8676002)(478600001)(38100700002)(186003)(26005)(86362001)(31686004)(31696002)(66946007)(6486002)(16576012)(316002)(2906002)(52116002)(6916009)(956004)(2616005)(43740500002)(45980500001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?NnlBcEliWFdYbUlSdDl4RlhGQmdQdmlkL1lrdC9NRDU3SUhGRlV6WDM2Mm5V?=
 =?utf-8?B?V0dZQkNLa3FreVREaFZDNDVwYitiVC9PN28raHJ2YXdnQUZRdlBVUWQ0WGE2?=
 =?utf-8?B?VGc0eit2c0JFSXlhUW9hbGJLRml5a1NNdzg3bElaM0I5R0d4WkhSZWNla09T?=
 =?utf-8?B?d21UeXFpbUZjTzNHMWl2S0F4a3VVc3RrSXlMM2VPM1R2Nzc5UTMrR3FBMHF5?=
 =?utf-8?B?YnJrNjNHL2lhMnFKMy9TRGZkelpxM1RWS3daSTUrOFcrUmFqemJKanJIZFM3?=
 =?utf-8?B?dDhVQ25Fb09kK1dUNkQrUnYraFF3dGdvcUNtSkJjbHJ4akJObVJJYU8xWDNY?=
 =?utf-8?B?MXRIaVBydnU3VjdnQjVpTnRlYlJpUlVoTVcreHpBbmFpVXA0MnNNMTBhbFpE?=
 =?utf-8?B?MEdkREVqZkh3S1VMeDdNbStuRW5iSEh5ekNJbnBhRGxZSS82SDlzQmdFT3J2?=
 =?utf-8?B?WnMzRGk2Q2d6dmcrNG5BVUduYlFZcjYvWjZabDVjS2taS0toUVpJbkl2aXow?=
 =?utf-8?B?dDBQZzRVdmFrNDBmeU03L2RuNTdlV0d3UkU2bDZvbWlCbERINUc0a0R1TUlv?=
 =?utf-8?B?Zi90Q09NL2JleVY1bGV5QWtXUjdsUmdXVlNaOCttQ1pnSlNMTGpLamlvRytQ?=
 =?utf-8?B?dHlvTit5UlpvOXhpT01mMDFGeFlhc3VZRVZwY0VveHU2NTFwNVhIbzJWNW1S?=
 =?utf-8?B?dE5SUW9CR2lrcTNmN3d0MkJ3RFIzTGwvVkJ2M0J0UW5SRElkUmxKTkgwUVV1?=
 =?utf-8?B?NXhqZStLUmVUZzBOdStwdVZQNXVQVXF5MTRXUzMySDZWMGp2dVZDaG1mbm5h?=
 =?utf-8?B?UllzdWx1Tnlsd0hMWFZKWkcvK21seElpV0pOVXBkN3VVZHp1dnJKNFNJbTFa?=
 =?utf-8?B?ZEpTeE9HWjNjZmd2ajJidUswdkJSdGpya1NRQnd4VnpFd1dzZm5JN0M2UDZT?=
 =?utf-8?B?OUNVRFI5Rm9zaU1LYy91U051ZmJjZWMvbk5zNkU4OGJWZU9CUnUxcVZUL3V1?=
 =?utf-8?B?MzNGeStlbmZYWUhFMXA4ajNwd2QrS0V1cnFSNVhCdmRvYnhQdS93dFJKRFdv?=
 =?utf-8?B?UXlrbFR3TExlSHErWHBnS2RoY1NDRDh3SVJtVWRLSjNnMEVEMWU3ZlhvN1p4?=
 =?utf-8?B?TlQrcmpwNUo3MWY5T2Q1OHR3UmJCYnBHK0JmaUdTVGF1dzJWWS9QdkxsWW9y?=
 =?utf-8?B?bG5RMERrWi9ua2xQcndERENJMVdFbThQQW5JMGhTNnBwU0V1QVltbVN6UlNR?=
 =?utf-8?B?OHVOdDhWb3BDZUZ6UVNJNnBkR0kwRUJvSXRzTWJhZXF6OC9qZXV5cGNaYlRp?=
 =?utf-8?B?M09qVGRIZmdkTmRkOWlyT3hvUHFHQ3lWYmJZTlhJdkluSjdEUVBlc1BYbVh0?=
 =?utf-8?B?UU5icUVHMzBPMkdjS2ZsSEpIcXNBUE1hN2pFdEpacHlmbm1yalZaL0FUWXRz?=
 =?utf-8?B?U2FYUWFIKzh2UThUc05TWkJTSXNjeUpBenJ4QlkwUWJHWTQ4TFdtQVdBWVpV?=
 =?utf-8?B?eFBYeU5iR3RFRVdiWEwxWGlBVU0zbDVQWTFaOEU4R2lqZCtmM0N1TVR6cXQw?=
 =?utf-8?B?WnEweG1FNkRpODdpTnJkSldXVVltRnpOWmttalhDQkROQzZmSWJZRlc5QjlO?=
 =?utf-8?B?WGtWNGZRTGVXNkVhKzJCNFlSS1RUWFpueXc0RE9LdEtQNm8rNkt3VGFSQUV0?=
 =?utf-8?B?cUhVbVRZNDRmNTYvK21KTWxlblVzVEI4YWVSSVkwdHBOUEdISU42WE1aWG4v?=
 =?utf-8?Q?x8WJj3sNGC5RuHsvi76ZYVaEdmSFw5bR+Ii8seG?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 5408c97e-3fac-40c8-614b-08d959178643
X-MS-Exchange-CrossTenant-AuthSource: BYAPR15MB2566.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Aug 2021 20:19:42.2697
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: h5O+MrALXVIv/66+5+ERiZ2dqimR8XkFjoIp66Bmwf8YrGzhbb21hgrR8PC8Yw9v
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR15MB4663
X-OriginatorOrg: fb.com
X-Proofpoint-ORIG-GUID: 5Z8P9_V4L-0vLDbn17Q00ukmlm2gOTj4
X-Proofpoint-GUID: 5Z8P9_V4L-0vLDbn17Q00ukmlm2gOTj4
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.790
 definitions=2021-08-06_06:2021-08-06,2021-08-06 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 spamscore=0 adultscore=0
 impostorscore=0 mlxscore=0 clxscore=1011 priorityscore=1501
 lowpriorityscore=0 phishscore=0 malwarescore=0 mlxlogscore=999
 suspectscore=0 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2107140000 definitions=main-2108060135
X-FB-Internal: deliver
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Currently we only wake the first waiter, even if we have enough entries
posted to satisfy multiple waiters. Improve that situation so that
every waiter knows how much the CQ tail has to advance before they can
be safely woken up.

With this change, if we have N waiters each asking for 1 event and we get
4 completions, then we wake up 4 waiters. If we have N waiters asking
for 2 completions and we get 4 completions, then we wake up the first
two. Previously, only the first waiter would've been woken up.

Signed-off-by: Jens Axboe <axboe@kernel.dk>

---

diff --git a/fs/io_uring.c b/fs/io_uring.c
index bf548af0426c..04df4fa3c75e 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -1435,11 +1435,13 @@ static inline bool io_should_trigger_evfd(struct io_ring_ctx *ctx)
 
 static void io_cqring_ev_posted(struct io_ring_ctx *ctx)
 {
-	/* see waitqueue_active() comment */
-	smp_mb();
-
-	if (waitqueue_active(&ctx->cq_wait))
-		wake_up(&ctx->cq_wait);
+	/*
+	 * wake_up_all() may seem excessive, but io_wake_function() and
+	 * io_should_wake() handle the termination of the loop and only
+	 * wake as many waiters as we need to.
+	 */
+	if (wq_has_sleeper(&ctx->cq_wait))
+		wake_up_all(&ctx->cq_wait);
 	if (ctx->sq_data && waitqueue_active(&ctx->sq_data->wait))
 		wake_up(&ctx->sq_data->wait);
 	if (io_should_trigger_evfd(ctx))
@@ -6968,20 +6970,21 @@ static int io_sq_thread(void *data)
 struct io_wait_queue {
 	struct wait_queue_entry wq;
 	struct io_ring_ctx *ctx;
-	unsigned to_wait;
+	unsigned cq_tail;
 	unsigned nr_timeouts;
 };
 
 static inline bool io_should_wake(struct io_wait_queue *iowq)
 {
 	struct io_ring_ctx *ctx = iowq->ctx;
+	unsigned tail = ctx->cached_cq_tail + atomic_read(&ctx->cq_timeouts);
 
 	/*
 	 * Wake up if we have enough events, or if a timeout occurred since we
 	 * started waiting. For timeouts, we always want to return to userspace,
 	 * regardless of event count.
 	 */
-	return io_cqring_events(ctx) >= iowq->to_wait ||
+	return tail >= iowq->cq_tail ||
 			atomic_read(&ctx->cq_timeouts) != iowq->nr_timeouts;
 }
 
@@ -7045,7 +7048,6 @@ static int io_cqring_wait(struct io_ring_ctx *ctx, int min_events,
 			.entry		= LIST_HEAD_INIT(iowq.wq.entry),
 		},
 		.ctx		= ctx,
-		.to_wait	= min_events,
 	};
 	struct io_rings *rings = ctx->rings;
 	signed long timeout = MAX_SCHEDULE_TIMEOUT;
@@ -7081,6 +7083,8 @@ static int io_cqring_wait(struct io_ring_ctx *ctx, int min_events,
 	}
 
 	iowq.nr_timeouts = atomic_read(&ctx->cq_timeouts);
+	iowq.cq_tail = READ_ONCE(ctx->rings->cq.head) + min_events +
+			iowq.nr_timeouts;
 	trace_io_uring_cqring_wait(ctx, min_events);
 	do {
 		/* if we can't even flush overflow, don't wait for more */

-- 
Jens Axboe

