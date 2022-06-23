Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3156D557E73
	for <lists+io-uring@lfdr.de>; Thu, 23 Jun 2022 17:09:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231229AbiFWPJh (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 23 Jun 2022 11:09:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59420 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230480AbiFWPJg (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 23 Jun 2022 11:09:36 -0400
Received: from mx0a-00082601.pphosted.com (mx0a-00082601.pphosted.com [67.231.145.42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C00063336D
        for <io-uring@vger.kernel.org>; Thu, 23 Jun 2022 08:09:35 -0700 (PDT)
Received: from pps.filterd (m0044012.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 25N0wZAZ008889
        for <io-uring@vger.kernel.org>; Thu, 23 Jun 2022 08:09:35 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=message-id : date : to :
 from : subject : content-type : content-transfer-encoding : mime-version;
 s=facebook; bh=mzXJZL/rHy91qVVeOqSpti15aJOAvxebufhUzLQQh7E=;
 b=lFJXVEoh2ajvjXt/3AsAZzUCRJ0/vVLRaDf6wwcaIaBJFq04ZY9Q4YAWr9ZD20/wF6/B
 YmqqceCJ+8IqxvCRxqf2UPAtuQDs8Lo+INNvUpSijlFmruzQtK1Sw0xIyMStU6LyLD4H
 aAzQGaGYAGmkHOMiyB5+7B/0kyVIOgUBRKw= 
Received: from nam12-bn8-obe.outbound.protection.outlook.com (mail-bn8nam12lp2170.outbound.protection.outlook.com [104.47.55.170])
        by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 3gv4qg7pwx-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <io-uring@vger.kernel.org>; Thu, 23 Jun 2022 08:09:35 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=L1Cg5LsMzX7cDelweSXZcuIHB/MBVcMhw7tw9ErzoqlMhXDQXlHm0f7TIJb4RAYd9KjqBNxthnCrLO5EgV5N59icT8GuQzAc31VpvVKYUvWCKW6ug/hEGf8CdfEgw+/NOCGOGHqIioSodKKj27pVfzUWGibtXRUdOJbhj8ZQDY+9T7cQaEJ1/yKgNHmp7ACbVzoRkh8TI60ROMnfPI3S58j4/apMrKpBJV+MSfhZw22IfzHaedWyxor5eUhOlElrL+OpjMH8sJH5TiUwen1jokNyh9jpHsqi4mZMhQnJnT43Nc3poiVxL1LChDDqC2Bzj7dnqkB/gNaIgKwQGfa/7g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=mzXJZL/rHy91qVVeOqSpti15aJOAvxebufhUzLQQh7E=;
 b=jp5nHRUZz+h0bdFQKVtkfUH7EuABMYgu1bmW/VWx66m9zsz0g/UhTuQQpefGTK50Wh6rifkfK9xPPuwSbLI8zp1a9OaePG1eoOlHbvvSBOtzUFZhkhvctNZ3B6uTn6jUCpA602WMGdxwEZzHLRqHwKJw72fHtvtLScR+GAudwtRMha3YYBYR3syzAXPY4H659GKhlfzY28WP1XjuAd6wzMpqwYX6dNRB72O3KrsNr8UmLtx5Zcp1OnqHnUcfGoZ6ghvAHeVf3AFnLQuL7xjhFCB9UOrKRzyYTujI3w0+87JFB7/Y4kANchbUiO9fmoi/LfFHfx7jCuKYeVcqbUjFgw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
Received: from BYAPR15MB2566.namprd15.prod.outlook.com (2603:10b6:a03:150::24)
 by MN2PR15MB2990.namprd15.prod.outlook.com (2603:10b6:208:f2::24) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5373.15; Thu, 23 Jun
 2022 15:09:32 +0000
Received: from BYAPR15MB2566.namprd15.prod.outlook.com
 ([fe80::f900:19ea:3d56:9231]) by BYAPR15MB2566.namprd15.prod.outlook.com
 ([fe80::f900:19ea:3d56:9231%6]) with mapi id 15.20.5373.016; Thu, 23 Jun 2022
 15:09:31 +0000
Message-ID: <a8e604e5-dfbd-bf96-c97c-4d332841d624@fb.com>
Date:   Thu, 23 Jun 2022 09:09:28 -0600
User-Agent: Mozilla/5.0 (X11; Linux aarch64; rv:91.0) Gecko/20100101
 Thunderbird/91.10.0
Content-Language: en-US
To:     io-uring <io-uring@vger.kernel.org>
From:   Jens Axboe <axboe@fb.com>
Subject: [PATCH for-next] io_uring: move POLLFREE handling to separate
 function
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: CY5PR14CA0020.namprd14.prod.outlook.com
 (2603:10b6:930:2::9) To BYAPR15MB2566.namprd15.prod.outlook.com
 (2603:10b6:a03:150::24)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 12da6c16-f0ed-463c-51c5-08da552a5fa6
X-MS-TrafficTypeDiagnostic: MN2PR15MB2990:EE_
X-Microsoft-Antispam-PRVS: <MN2PR15MB2990C64909DE07C9122FB2CFC0B59@MN2PR15MB2990.namprd15.prod.outlook.com>
X-FB-Source: Internal
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 5OQw9uqIPGWyci3XNZcYbu7i18t0ArqoG9u3jOoM79Va1W3oYlcdJhaoIs9cU0Ov3DLqlDsM/X3ZJRS70KHU3sMvUtBhzQFwH3SEBqn+hTk9fghQZsIh4wcAXLvabtSZEOSgvWGzaeTWEPgkVXXbnCnIr12kME8UTSz1BLi87HOeIaI/3W6x+jqXMmMGonpC0djTrtmXrzU9UcM8CNeOvCgWcxfihDefwc5Gc7OH9TbgYCNhMd57qIVkK4ViUXY8TbVLolQevhjk4HeeThvhKfN2Be/bK24IdOZoFyOflwYzSnh91uPkfNI2iu05srmFVWr1kTjNZT6iuStp5fQk1+WeTXnwhgtZonb+PF2Mmx5VLuKzm9JXP0b7dWoB8VRRLO5nObT7JnLyIKHOSLvbEVJ3kNRILHCF/DM2XGqcR38OH2czZtu4os/wuoDfO8IKYhSCzaJc5Mjhrr8NHiCYBcbynNE2BWsmOwl+j93r1eES+VdohMyACQBXipaMV6es1hGXoAOENRTLhFUwl2PsS1oAe+t4Dztyv4cxf8bndRAL9zeOURSmzqCKsWOdYlqa+dGF9SD72plrOy2mIrcqDOSabY1t4Ryadvmwx28RX2JvAP2e7g5qT5y4CnLyhJLV/y5xTRsE+hTbbg0pDYGmWAe1I9Gxg0Xq7ZZIMibxUT3UvbXFnqFgZhZC9497HZvadXducW0mIwPa76bVBCzthTtA/C38q6alLDL/vTzLv8QNcljZwUbb9zKQKOGq113MKu1efzIhbQTGeZdPAMQvq7tiigV37UlyloWxLLJ0LT4=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR15MB2566.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(346002)(136003)(39860400002)(396003)(376002)(366004)(6506007)(38100700002)(41300700001)(6666004)(26005)(186003)(31696002)(6512007)(2616005)(83380400001)(8936002)(8676002)(31686004)(36756003)(66476007)(2906002)(6916009)(316002)(66556008)(86362001)(5660300002)(478600001)(6486002)(66946007)(45980500001)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?dEhqMFpHLzROK09SUjV5dU5rNmh3L1o1SCttU1dyWTZ5Wk94dU4vWDRFR3J6?=
 =?utf-8?B?blJuSjNsekdWZ0YxVGxweHRHaTlRUzVhWE9DMWxrVW43ZTgxcGwxQXVFcnU2?=
 =?utf-8?B?WnorY0NiaWFNTmNCeGt0R3Z4Kys3MTFDTUJyK3RSNGN2S0hSWnJvamRMOUNG?=
 =?utf-8?B?MEVaZnhIdnZQRlpOc1RCQk92OXgrZ0g5bm1OZC9IMXBaanBHY1FtZEVhbVRJ?=
 =?utf-8?B?QmFTLzlSMnE2N3lFVk1wM2RnZmgrZlc2VkFZYlgrOXBsbGZwbU10Z2g1cVpt?=
 =?utf-8?B?Vk9TK3N2Q0tnWmxXb0xLZDZzdlRuV1U2V3hXN0ZJRXhmRDcvdnlHQllJTHRH?=
 =?utf-8?B?ajZkOGJrbWVKd2dBU1JWYU1QeE5DNGNseC8zK2FrK3RnUi9JVE5JK3NMa1dn?=
 =?utf-8?B?YWtIQlV0Q2RWTU85RmZIaHJ1ZXAvd0hxdlFNcC9BaUlRTWdDSFNSajh1TlF2?=
 =?utf-8?B?a1AzVGl6VnBrVFZZSnkzRk04UVpOYk5Ybkx3UGM0OTlvbmxiT3MraTVuTGZX?=
 =?utf-8?B?bVFubkIyckQ5Uks1VE11ZnV0S2JENkRuZkxOVWhKQmNnQ0dvSWFmeE4wTFQ5?=
 =?utf-8?B?VEd3empuU1FOT3F2aXhPU3JRRUViRDVpNWdmMk9VNXF4R2NkSlRuU2lFdUZ4?=
 =?utf-8?B?bHJOak5RSVNWNVVYUGpaQm9SUklpY29pZWxhVlFIclpvOTBkazFiZVphMXYy?=
 =?utf-8?B?c2FJWDJ6eU1tYmlGYVpxYzc4VDdUOWxKcWNPVnpJbXB5WVZRVER0Z0N3Rm12?=
 =?utf-8?B?S012V2xjZWV6UmNRTFE2ZUhSMXRreTJKaGZVTGx1UlNTN0htL2pFclNJKzEy?=
 =?utf-8?B?eEI5LzZ6OFJXUmYrWkFOMkc1UTF2QVZGSy9LSlRsakJ3MkdOYlh4QjRuLzlm?=
 =?utf-8?B?YTlrWnFYSDF0UW1ocnFnRGo3K0xJRkptQUtrcXZLcW1DcFBnMlFFc1J3aXpx?=
 =?utf-8?B?RTVKSW5CR1VhdGpwYzZUQzhxMG1mZ1pzTDYrc3phT21BYVQ3VkFGTFo2a0Ju?=
 =?utf-8?B?Q1A3N3hxOCsrUmN3QmtlOUxOSkllcEY2T2J5YjBuSTM1REJZYWhlM2lyZ0lC?=
 =?utf-8?B?L0tDWmJiWGRlSEFGTDlLS3FjanVhOEkyTWNPZEM0a21tK3gvZ013a3JBbUIv?=
 =?utf-8?B?Z2FMMWk4Z01oaXl2WjZzcFRSeHQreHFWMEdYUnpldDF1REdyNktFdVY1MnNG?=
 =?utf-8?B?SnhEeVl4Q2hjOXpaU01SV3cvRjhBMThJdDdoTkw5ZERhN0tQRzlkMHdNSVVi?=
 =?utf-8?B?bWFDZXJ6NytnRkE2WUMzSFl1ZTgrUnlpRkE4TCs4MHZWVi9jdFRnRndmRHRu?=
 =?utf-8?B?UFo4Qi8vT2RtelVRRElwZVQ2cDhnZ3hlRUx4NXNLcVZObXpyVjBiVDc4ME1y?=
 =?utf-8?B?bWtFVVdvbW83ZUx4c2hCY05RSTlTbkFIMUhXUjlkUjRYWW92cTQ5WklnWnRZ?=
 =?utf-8?B?ODNNRW1VOUY1cGFMazUzaXNvNHpTaTZLUlV6RjREWW5jQlFZSDg5THo3S0Zn?=
 =?utf-8?B?MWhoMUhtYXJUQk9aM3lZYktoWGFmZU9telhQYVRJM0pUOFJabmdXaWFxL3F1?=
 =?utf-8?B?RDU1L2RRZnp0S0NKUzAxWTBMU0Yxa2V2STRHMDhrbTREcnhhNEZ1eUcyN1Fm?=
 =?utf-8?B?Zk5Ia0VxOHZlVCttYTZYbStqdlBjSjlLdzltR3dzTmlQcWZVSU9EQ2drWjZC?=
 =?utf-8?B?TmV5enpEbVZIYnNYbzJJMVF0cC8waE1nY1E4YncvQ0RQakp5TzlVRlJCVkd6?=
 =?utf-8?B?STJJYVk1TzR0MGtZcDU3eGdkK3ZnSEwycnRxaXBrZEUvbXdTNUVpeUFWd3NB?=
 =?utf-8?B?b1VlVUw3dUZsd0ZTNnBCaDV5MHl6MFFDa2FLUjdyeEY3Vk9xRUFueUg1ajFx?=
 =?utf-8?B?YyszS21sWEI5bkxhc3BVek9nNVZ1YkozNFMwSGtwNGV5a0lJdFRkMTJ6cmU1?=
 =?utf-8?B?eWNPTnprTHJPQVBpZ0lDVFU4TitZT1pLdkZXZjNxMXJmT1BIS1pZbFVOY2dT?=
 =?utf-8?B?V1ZmWEVaeXM5eVdqZFgxTHRidGpqLzNhQ1ZIRXFjTFlZVXJBK0dySHM2RFVJ?=
 =?utf-8?B?MHZBVlpUQnJ0N0RnQTgyeGVEUndSU2E4Tm9iVUpuOWlUMWhrTXZFMnlxSGdM?=
 =?utf-8?B?OTA5QklLOGdjSllkQUJVVWFoeGNqT2txRUNwWTAyRnZ0YjhOQlJ2M1lRWlFY?=
 =?utf-8?B?dzUrdEhUOEIzRkhHYVUxZTZ6clMrMWFSRVJscFoxR0tPOS82NlA3eHRIb2hu?=
 =?utf-8?B?Y3M3WnoxUlRUWkJGbGVUSFRISWZRVnlSa1RSNTkvY2JCeEtzUGMxRFg4MzA0?=
 =?utf-8?B?TjRFREtpaWNwTVM3VkRMMkd0eHhyTWI0aTZyb0VVdGpCUkR0MnhFUT09?=
X-OriginatorOrg: fb.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 12da6c16-f0ed-463c-51c5-08da552a5fa6
X-MS-Exchange-CrossTenant-AuthSource: BYAPR15MB2566.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Jun 2022 15:09:31.6506
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: JnV669ctjUK1dZWPBg/jNCOwInlvUw6kJjF3ehEnpF4QnHQcn4mLjnamdXXNutZU
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR15MB2990
X-Proofpoint-ORIG-GUID: plPVaoF2Wu2NAAFK9d92WJmP8AvGnZHx
X-Proofpoint-GUID: plPVaoF2Wu2NAAFK9d92WJmP8AvGnZHx
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.883,Hydra:6.0.517,FMLib:17.11.122.1
 definitions=2022-06-23_06,2022-06-23_01,2022-06-22_01
X-Spam-Status: No, score=-2.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

We really don't care about this at all in terms of performance. Outside
of having it already be marked unlikely(), shove it into a separate
__cold function.

Signed-off-by: Jens Axboe <axboe@kernel.dk>

---

diff --git a/io_uring/poll.c b/io_uring/poll.c
index eba767594dee..fa25b88a7b93 100644
--- a/io_uring/poll.c
+++ b/io_uring/poll.c
@@ -325,6 +325,31 @@ static void io_poll_cancel_req(struct io_kiocb *req)
 
 #define IO_ASYNC_POLL_COMMON	(EPOLLONESHOT | EPOLLPRI)
 
+static __cold int io_pollfree_wake(struct io_kiocb *req, struct io_poll *poll)
+{
+	io_poll_mark_cancelled(req);
+	/* we have to kick tw in case it's not already */
+	io_poll_execute(req, 0);
+
+	/*
+	 * If the waitqueue is being freed early but someone is already
+	 * holds ownership over it, we have to tear down the request as
+	 * best we can. That means immediately removing the request from
+	 * its waitqueue and preventing all further accesses to the
+	 * waitqueue via the request.
+	 */
+	list_del_init(&poll->wait.entry);
+
+	/*
+	 * Careful: this *must* be the last step, since as soon
+	 * as req->head is NULL'ed out, the request can be
+	 * completed and freed, since aio_poll_complete_work()
+	 * will no longer need to take the waitqueue lock.
+	 */
+	smp_store_release(&poll->head, NULL);
+	return 1;
+}
+
 static int io_poll_wake(struct wait_queue_entry *wait, unsigned mode, int sync,
 			void *key)
 {
@@ -332,29 +357,8 @@ static int io_poll_wake(struct wait_queue_entry *wait, unsigned mode, int sync,
 	struct io_poll *poll = container_of(wait, struct io_poll, wait);
 	__poll_t mask = key_to_poll(key);
 
-	if (unlikely(mask & POLLFREE)) {
-		io_poll_mark_cancelled(req);
-		/* we have to kick tw in case it's not already */
-		io_poll_execute(req, 0);
-
-		/*
-		 * If the waitqueue is being freed early but someone is already
-		 * holds ownership over it, we have to tear down the request as
-		 * best we can. That means immediately removing the request from
-		 * its waitqueue and preventing all further accesses to the
-		 * waitqueue via the request.
-		 */
-		list_del_init(&poll->wait.entry);
-
-		/*
-		 * Careful: this *must* be the last step, since as soon
-		 * as req->head is NULL'ed out, the request can be
-		 * completed and freed, since aio_poll_complete_work()
-		 * will no longer need to take the waitqueue lock.
-		 */
-		smp_store_release(&poll->head, NULL);
-		return 1;
-	}
+	if (unlikely(mask & POLLFREE))
+		return io_pollfree_wake(req, poll);
 
 	/* for instances that support it check for an event match first */
 	if (mask && !(mask & (poll->events & ~IO_ASYNC_POLL_COMMON)))

-- 
Jens Axboe

