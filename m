Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 64D264D257E
	for <lists+io-uring@lfdr.de>; Wed,  9 Mar 2022 02:14:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229762AbiCIBE1 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 8 Mar 2022 20:04:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46148 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229771AbiCIBD6 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 8 Mar 2022 20:03:58 -0500
Received: from mx0a-00082601.pphosted.com (mx0a-00082601.pphosted.com [67.231.145.42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9DC5F26E2B1
        for <io-uring@vger.kernel.org>; Tue,  8 Mar 2022 16:41:10 -0800 (PST)
Received: from pps.filterd (m0148461.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.1.2/8.16.1.2) with ESMTP id 228MGAEF004111
        for <io-uring@vger.kernel.org>; Tue, 8 Mar 2022 16:41:10 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=message-id : date : to :
 from : subject : content-type : content-transfer-encoding : mime-version;
 s=facebook; bh=lr3ZeP9Svwbov3dIoJYRKCxQhm/xgjI7CnGpOg4u/VY=;
 b=RKTdtLlr9VHQIUcPRFeYLDQC0SCP1xSnkc5b520EYENk2zmrgNDU8lPoASImYLTyg1lG
 TpQ3CmNAgFFenAEbX5EDExkM6fPzJtqscGCNJgL370YqJM/b8TjC1CbWKu3t6x4DESSi
 VDS2HQskdyMRlJe33aBA52dSitRx6I90Sl8= 
Received: from nam11-dm6-obe.outbound.protection.outlook.com (mail-dm6nam11lp2177.outbound.protection.outlook.com [104.47.57.177])
        by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 3epfssgtpk-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <io-uring@vger.kernel.org>; Tue, 08 Mar 2022 16:41:10 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=NVoBecThz9T+szMccs6ces858m551PPUcgFmXtXRqKPG2jZsn8I8JFAnZJgRbu3+ggjA0Y26NVQnmqlxrtIxMZJC3H5fYpoKu/qz9YNUoJnQxNGHjP5LZIFs6sj5DstnW066e/yURL+EbL/3y53YJpLDQ95pbjRdyyb5boViV5xnR8UTUAw1/bNba4agfQnamwZh64znnMzdw1XDj/BydGL1B7lneveW9e9/9ZrrqSWVszY2yt3o5oE2UMKQRQbf+cEvsuiDP6La/U1lIcvjl9TfRGQCIAEsmCquam4i8QziLdgeQkFDukHmxBgiX6Vq77YWI4yXNarsYmAYLZsDxA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=lr3ZeP9Svwbov3dIoJYRKCxQhm/xgjI7CnGpOg4u/VY=;
 b=EBGvIXMtqIlftck2fG+Kr237nTHxpqeZAsAeokQjTsIwTXBYtV9oegRbMNSGldiNAWIPk3BWjgRUrNcE55ZV2ErL+uHIupZwMTiAC/eHYi2O0aVtFnK2G1Hdja3M0MsvXRqZ0Y0v5DP6x9Y+hV44+bNiQsory9OoqL8tMQXTomBT3izR9mMaUbOt+N/QmVebYcCK/QAZO19svc4es2IyrFxJVzmxW3G0h02+uxMqijUwTlMYmwWzKRqMvk4E+2vAAU+0XTcv5hWMGgaK6mWYtWHQe5qMfj05ReOiQUSwG0C3Ez2jPM+aHoBMyHZS2Bfvig8k9vfxp0yRtRM2+vXfMQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
Received: from BYAPR15MB2566.namprd15.prod.outlook.com (2603:10b6:a03:150::24)
 by PH0PR15MB4878.namprd15.prod.outlook.com (2603:10b6:510:c1::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5038.14; Wed, 9 Mar
 2022 00:41:08 +0000
Received: from BYAPR15MB2566.namprd15.prod.outlook.com
 ([fe80::4c03:ad71:a2cf:cd92]) by BYAPR15MB2566.namprd15.prod.outlook.com
 ([fe80::4c03:ad71:a2cf:cd92%5]) with mapi id 15.20.5038.027; Wed, 9 Mar 2022
 00:41:08 +0000
Message-ID: <161346bd-db47-d9e2-7cba-cda58264b20b@fb.com>
Date:   Tue, 8 Mar 2022 17:41:05 -0700
User-Agent: Mozilla/5.0 (X11; Linux aarch64; rv:91.0) Gecko/20100101
 Thunderbird/91.6.1
Content-Language: en-US
To:     io-uring <io-uring@vger.kernel.org>
From:   Jens Axboe <axboe@fb.com>
Subject: [PATCH] io_uring: speedup provided buffer handling
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: PH0P220CA0023.NAMP220.PROD.OUTLOOK.COM
 (2603:10b6:510:d3::23) To BYAPR15MB2566.namprd15.prod.outlook.com
 (2603:10b6:a03:150::24)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 66234dde-1016-4815-1483-08da01658043
X-MS-TrafficTypeDiagnostic: PH0PR15MB4878:EE_
X-Microsoft-Antispam-PRVS: <PH0PR15MB48789B35A2CD245EF885FC76C00A9@PH0PR15MB4878.namprd15.prod.outlook.com>
X-FB-Source: Internal
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: wPkKOZOr8dD6Yw1Nqbr7+6Mqiga5lnQ2SirK2/IjPUM0P7MaT48NC4dK2rpxWRrlBrQIHuPZyoreE7ETHycc8M+q8J+PF5Gqdztm1t/lbApZa9PNAakpWz+LhenQZlZzILgu0gRD9VR5zVx0JJel7t/BlSCOgSB1YqJA2IxrsfGkxlo3kLC/bnAxpbH3gInpxqePLb7wNZU1ss5HC7dyGRFyaQjujudUedp0gC4ior1R8pXIu0uO0yzFsKLT6n22nHmSyHYf66DP4lA0qlZlrVq4w1ManfOf7Wv28prIrjCjT6pkb+fPzqWtlWQKIeS67n9azE2qxLNq9ttfHJZr6kUfpLoyqJdKoz4WeDPr80ZReg0HbraisZqyirfKpcCBn6mBXMEhXc/r4twXqR90YKqjxOrp2d7b4AC4bZuBcdKKiCShwiSPsn+btYCxPZJAUsk6rbHemEGVQvF0xF+UHEaX3MbYRqvC1B5Md2GRcmnbPxFYNHQ6yyWOdQYhO3/fERg6T1ikwM184VCrLWarDHDXc03mh/D5R94ADV2GrcWphv/5W8d5zwfSfHnP33e0ToB/ihYPkIMCaL4i9IrG5XamiYp97I/lzTnBBfMHllPEud8N6N93/1WxTqj6i1n1jgGnxbUDsWrsuWkZx8OR9L7gtTWJRegR0wdtHU39h2CzNVzgczI6DB66mo8MRKusaIW0fxWK2eC7v6wBdOdtaRWE5zztgx5JnpqAwTc1/0w=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR15MB2566.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(66476007)(66946007)(66556008)(8676002)(8936002)(6486002)(5660300002)(2616005)(26005)(186003)(31686004)(36756003)(83380400001)(2906002)(6512007)(6506007)(6666004)(86362001)(31696002)(38100700002)(316002)(508600001)(6916009)(45980500001)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?c0c0Yjk1Wmo4dnlLMHZ4SWxUSUZBanpjTUFOZmozSnphRDlnUHc5V2IvekFJ?=
 =?utf-8?B?eTFKckllTlJ1YlVQSlhpSjN3c05ZbWZiaTZIdXEveXNWODdkczNSWmUrZTFQ?=
 =?utf-8?B?NFRCTE5IQ1N1d3lZWGFYR3JrREpjcmJ1cDJnMjFhMXhLY3Y1V3JIbWwrTlVY?=
 =?utf-8?B?NzZZaXJ2MVpKemRBQ3BPeTRLajVMUzEwdFV0Q0FXZ0Rtbzg5YUJscEROQTlC?=
 =?utf-8?B?WEN4Y0dQdWN3UVJXa21pQm5SWTR3RTV6L3A1T2ZGUng4dmpseHhWT0RCQitQ?=
 =?utf-8?B?YVoycUl3TUhPNElSVDVXK1RhZHZrOUtIZHNBaW9vOFViVWk3UGNRQWNYektm?=
 =?utf-8?B?VjExRjdpQW9HcnhZd2didU0yaHg0MW5pdkFXQXptbzQ4c2pMM0c3WjlPczBY?=
 =?utf-8?B?THQyT1lhWGNDOHordWtUYnhWMFI2ZmVTd0pUVU1BY09lb24wblMvNEZrZ2VF?=
 =?utf-8?B?TVpZQ2NidHd3aENWNGlnNSs1OXZWTy9wbXlYckVHQ1k1WmhyZm1LNTY0elNT?=
 =?utf-8?B?WWZTSGVWSXFOYU1ScjlVcDE0QkxKRTU1eUpnaEhSNjZRa3JKU0NuVzArN0JL?=
 =?utf-8?B?NVltNmRuL0ZOd0lzTUhGa3RnZUFYTVB1bHFYa3NQdy9LaHFkeTNMNENQazFD?=
 =?utf-8?B?OWw3QTRsUmhVMkltaG8wMjlSYkhzRXllMjFZbjF1N1UyQ3N3WFlxbnhVTzk5?=
 =?utf-8?B?V1JrbjFlRVJ4Wit6Z0Jqc2d3TkVHQTJvR3ljMXErV0RVV0Q1ellnZUZjcFRO?=
 =?utf-8?B?K083UWtIdzZOb09DUlhRdXRSUGNZWTBlZU1VbWFuSTFHdGx5N3pNeU0wY2lP?=
 =?utf-8?B?OVBpY245dG84N0dSdlpoS2ZVRkpIczFQT2FqcWlsWXlXVGMzQ3Y5M05DWGJu?=
 =?utf-8?B?NmpMcGNhRHpoV2VIVDNScm1EdHhvM0wxNmRjY09BTjJIanovcEVNcVBaSFFn?=
 =?utf-8?B?SHRtZVFTc1Qyc0FzcUJPVW45aDRNRHRTVnBPd2pTV2V0ZFlXQ2xPSEhFd2VV?=
 =?utf-8?B?cmZWOXlHQ0w3cnRZYU5ON1dJblIxM0lKR05xUTZHbnRYamExV2YvRXVMWWd1?=
 =?utf-8?B?UTh3WmR0SnhiS003SmFtc21wWk5ESWk2QkRHQ04rWDdQUW0rd2hON0xTdUI1?=
 =?utf-8?B?dGNBM2NuWkUvRmNaL3N0QkplUmozSmJJZktmOVRUY1pTb3QzZ1BJUjBoakpQ?=
 =?utf-8?B?TDhDMnZENXlvNlBPTlZ2cEVJeWhRTmt6eW5kOFdxcm82VFZqaDlkR09wQ2xF?=
 =?utf-8?B?bVpnRC9adldkVEYyYXlaZjNQcUYvRUc2U2Jsb3BYcHkyeXQ0Vm4xelJKaG5p?=
 =?utf-8?B?Mkw0eHN3ZUFWY2pIUU9sZkFWQzJnQ2JlWk9Gbzc5aWRicHpKbDdZTzFWM2ph?=
 =?utf-8?B?OUQvcUNGdTVNRXJwZjdndkZubHM2ai9JeCtzcWlkTFpMbXZzS1M0VHl4NXBQ?=
 =?utf-8?B?aHhVQmZwYWQrZy8rSExrTjlteVExWUlPWjBGUEtHYnprMEM0UkpRY0RSV1Rz?=
 =?utf-8?B?akhGcCszVVNkS3ZTR2hRaXc0MjBKRFh4RnExYU8zNis5QTRoU0htYnNKNUYx?=
 =?utf-8?B?M29xbEJhamd0ZTBlRm54N2E2azdHWUpMZkh1MXRES1psSGd3ejJDNW93MCsr?=
 =?utf-8?B?ZzZNL1NoOEJqazkyRlcvZGE5cXlZMmY0WnNjb3ptOG4wc3NZS0haZFR5VVVG?=
 =?utf-8?B?RTkvNk9tWjN3Q1BXWnZvdm1iL0lGcXRXRzlMVk4wYTVxejBpUko2VjZVY1hm?=
 =?utf-8?B?YTFCZW0vamJNUUJRdEtNWTZsV1gxSDVDZ3JQZVlyODhhR1VQNVU0Z3ZWVFFq?=
 =?utf-8?B?QXUvQXJ1SDRZcU9SdGI2bHlMQlVEbVlvZFpJME8zSzNQTk10bnJrbFc3dGlN?=
 =?utf-8?B?eU5xQk5lY29YRWFsbjZlZlR3Rmx1ZlQ2b1FTaFBEZ2FBTkFUU1FDZ1Z1VXZ5?=
 =?utf-8?B?bFR4b3NhZkJEdDdVWEdTQlEwczZGalZiOGlyTnlBaGw3Qm5aZVJKNGxRV0FD?=
 =?utf-8?B?UHBKSVkwbS82bUNyek51ekFVcjhJRlFGNS83OFZxYk1wZ040clBzck0ybnVu?=
 =?utf-8?B?T2RmcDJveG9zdU9PckNLbXFWVGRHMWI3ZERhOHlVTGJEMlViSExxWHJFa3l3?=
 =?utf-8?Q?ao30=3D?=
X-OriginatorOrg: fb.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 66234dde-1016-4815-1483-08da01658043
X-MS-Exchange-CrossTenant-AuthSource: BYAPR15MB2566.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Mar 2022 00:41:08.3582
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: QeEGV4r1Mpb9/VPWKQ5hreMkmwdv7Ohix+jCokGfWnlT9RjB1CVpT5Vm5u+O1r3X
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR15MB4878
X-Proofpoint-ORIG-GUID: reJX0LFJcoLpfAO6RZ3wjsCstoTJ613D
X-Proofpoint-GUID: reJX0LFJcoLpfAO6RZ3wjsCstoTJ613D
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.816,Hydra:6.0.425,FMLib:17.11.64.514
 definitions=2022-03-08_09,2022-03-04_01,2022-02-23_01
X-Spam-Status: No, score=-3.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

In testing high frequency workloads with provided buffers, we spend a
lot of time in allocating and freeing the buffer units themselves.
Rather than repeatedly free and alloc them, add a recycling cache
instead. There are two caches:

- ctx->io_buffers_cache. This is the one we grab from in the submission
  path, and it's protected by ctx->uring_lock. For inline completions,
  we can recycle straight back to this cache and not need any extra
  locking.

- ctx->io_buffers_comp. If we're not under uring_lock, then we use this
  list to recycle buffers. It's protected by the completion_lock.

On adding a new buffer, check io_buffers_cache. If it's empty, check if
we can splice entries from the io_buffers_comp_cache.

This reduces about 5-10% of overhead from provided buffers, bringing it
pretty close to the non-provided path.

Signed-off-by: Jens Axboe <axboe@kernel.dk>

---

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 23e7f93d3956..e8f5f380530c 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -384,6 +384,7 @@ struct io_ring_ctx {
 		struct list_head	ltimeout_list;
 		struct list_head	cq_overflow_list;
 		struct xarray		io_buffers;
+		struct list_head	io_buffers_cache;
 		struct xarray		personalities;
 		u32			pers_next;
 		unsigned		sq_thread_idle;
@@ -426,6 +427,8 @@ struct io_ring_ctx {
 		struct hlist_head	*cancel_hash;
 		unsigned		cancel_hash_bits;
 		bool			poll_multi_queue;
+
+		struct list_head	io_buffers_comp;
 	} ____cacheline_aligned_in_smp;
 
 	struct io_restriction		restrictions;
@@ -441,6 +444,8 @@ struct io_ring_ctx {
 		struct llist_head		rsrc_put_llist;
 		struct list_head		rsrc_ref_list;
 		spinlock_t			rsrc_ref_lock;
+
+		struct list_head	io_buffers_pages;
 	};
 
 	/* Keep this last, we don't need it for the fast path */
@@ -1279,24 +1284,56 @@ static inline void io_req_set_rsrc_node(struct io_kiocb *req,
 	}
 }
 
-static unsigned int __io_put_kbuf(struct io_kiocb *req)
+static unsigned int __io_put_kbuf(struct io_kiocb *req, struct list_head *list)
 {
 	struct io_buffer *kbuf = req->kbuf;
 	unsigned int cflags;
 
-	cflags = kbuf->bid << IORING_CQE_BUFFER_SHIFT;
-	cflags |= IORING_CQE_F_BUFFER;
+	cflags = IORING_CQE_F_BUFFER | (kbuf->bid << IORING_CQE_BUFFER_SHIFT);
 	req->flags &= ~REQ_F_BUFFER_SELECTED;
-	kfree(kbuf);
+	list_add(&kbuf->list, list);
 	req->kbuf = NULL;
 	return cflags;
 }
 
-static inline unsigned int io_put_kbuf(struct io_kiocb *req)
+static inline unsigned int io_put_kbuf_comp(struct io_kiocb *req)
 {
 	if (likely(!(req->flags & REQ_F_BUFFER_SELECTED)))
 		return 0;
-	return __io_put_kbuf(req);
+	return __io_put_kbuf(req, &req->ctx->io_buffers_comp);
+}
+
+static inline unsigned int io_put_kbuf(struct io_kiocb *req,
+				       unsigned issue_flags)
+{
+	unsigned int cflags;
+
+	if (likely(!(req->flags & REQ_F_BUFFER_SELECTED)))
+		return 0;
+
+	/*
+	 * We can add this buffer back to two lists:
+	 *
+	 * 1) The io_buffers_cache list. This one is protected by the
+	 *    ctx->uring_lock. If we already hold this lock, add back to this
+	 *    list as we can grab it from issue as well.
+	 * 2) The io_buffers_comp list. This one is protected by the
+	 *    ctx->completion_lock.
+	 *
+	 * We migrate buffers from the comp_list to the issue cache list
+	 * when we need one.
+	 */
+	if (issue_flags & IO_URING_F_UNLOCKED) {
+		struct io_ring_ctx *ctx = req->ctx;
+
+		spin_lock(&ctx->completion_lock);
+		cflags = __io_put_kbuf(req, &ctx->io_buffers_comp);
+		spin_unlock(&ctx->completion_lock);
+	} else {
+		cflags = __io_put_kbuf(req, &req->ctx->io_buffers_cache);
+	}
+
+	return cflags;
 }
 
 static bool io_match_task(struct io_kiocb *head, struct task_struct *task,
@@ -1444,6 +1481,7 @@ static __cold struct io_ring_ctx *io_ring_ctx_alloc(struct io_uring_params *p)
 	init_waitqueue_head(&ctx->sqo_sq_wait);
 	INIT_LIST_HEAD(&ctx->sqd_list);
 	INIT_LIST_HEAD(&ctx->cq_overflow_list);
+	INIT_LIST_HEAD(&ctx->io_buffers_cache);
 	init_completion(&ctx->ref_comp);
 	xa_init_flags(&ctx->io_buffers, XA_FLAGS_ALLOC1);
 	xa_init_flags(&ctx->personalities, XA_FLAGS_ALLOC1);
@@ -1452,6 +1490,8 @@ static __cold struct io_ring_ctx *io_ring_ctx_alloc(struct io_uring_params *p)
 	spin_lock_init(&ctx->completion_lock);
 	spin_lock_init(&ctx->timeout_lock);
 	INIT_WQ_LIST(&ctx->iopoll_list);
+	INIT_LIST_HEAD(&ctx->io_buffers_pages);
+	INIT_LIST_HEAD(&ctx->io_buffers_comp);
 	INIT_LIST_HEAD(&ctx->defer_list);
 	INIT_LIST_HEAD(&ctx->timeout_list);
 	INIT_LIST_HEAD(&ctx->ltimeout_list);
@@ -2330,7 +2370,8 @@ static void handle_prev_tw_list(struct io_wq_work_node *node,
 		if (likely(*uring_locked))
 			req->io_task_work.func(req, uring_locked);
 		else
-			__io_req_complete_post(req, req->result, io_put_kbuf(req));
+			__io_req_complete_post(req, req->result,
+						io_put_kbuf_comp(req));
 		node = next;
 	} while (node);
 
@@ -2680,7 +2721,7 @@ static int io_do_iopoll(struct io_ring_ctx *ctx, bool force_nonspin)
 		if (unlikely(req->flags & REQ_F_CQE_SKIP))
 			continue;
 
-		__io_fill_cqe(req, req->result, io_put_kbuf(req));
+		__io_fill_cqe(req, req->result, io_put_kbuf(req, 0));
 		nr_events++;
 	}
 
@@ -2856,14 +2897,14 @@ static bool __io_complete_rw_common(struct io_kiocb *req, long res)
 
 static inline void io_req_task_complete(struct io_kiocb *req, bool *locked)
 {
-	unsigned int cflags = io_put_kbuf(req);
 	int res = req->result;
 
 	if (*locked) {
-		io_req_complete_state(req, res, cflags);
+		io_req_complete_state(req, res, io_put_kbuf(req, 0));
 		io_req_add_compl_list(req);
 	} else {
-		io_req_complete_post(req, res, cflags);
+		io_req_complete_post(req, res,
+					io_put_kbuf(req, IO_URING_F_UNLOCKED));
 	}
 }
 
@@ -2872,7 +2913,8 @@ static void __io_complete_rw(struct io_kiocb *req, long res,
 {
 	if (__io_complete_rw_common(req, res))
 		return;
-	__io_req_complete(req, issue_flags, req->result, io_put_kbuf(req));
+	__io_req_complete(req, issue_flags, req->result,
+				io_put_kbuf(req, issue_flags));
 }
 
 static void io_complete_rw(struct kiocb *kiocb, long res)
@@ -4519,13 +4561,11 @@ static int __io_remove_buffers(struct io_ring_ctx *ctx, struct io_buffer *buf,
 
 		nxt = list_first_entry(&buf->list, struct io_buffer, list);
 		list_del(&nxt->list);
-		kfree(nxt);
 		if (++i == nbufs)
 			return i;
 		cond_resched();
 	}
 	i++;
-	kfree(buf);
 	xa_erase(&ctx->io_buffers, bgid);
 
 	return i;
@@ -4591,17 +4631,63 @@ static int io_provide_buffers_prep(struct io_kiocb *req,
 	return 0;
 }
 
-static int io_add_buffers(struct io_provide_buf *pbuf, struct io_buffer **head)
+static int io_refill_buffer_cache(struct io_ring_ctx *ctx)
+{
+	struct io_buffer *buf;
+	struct page *page;
+	int bufs_in_page;
+
+	/*
+	 * Completions that don't happen inline (eg not under uring_lock) will
+	 * add to ->io_buffers_comp. If we don't have any free buffers, check
+	 * the completion list and splice those entries first.
+	 */
+	if (!list_empty_careful(&ctx->io_buffers_comp)) {
+		spin_lock(&ctx->completion_lock);
+		if (!list_empty(&ctx->io_buffers_comp)) {
+			list_splice_init(&ctx->io_buffers_comp,
+						&ctx->io_buffers_cache);
+			spin_unlock(&ctx->completion_lock);
+			return 0;
+		}
+		spin_unlock(&ctx->completion_lock);
+	}
+
+	/*
+	 * No free buffers and no completion entries either. Allocate a new
+	 * page worth of buffer entries and add those to our freelist.
+	 */
+	page = alloc_page(GFP_KERNEL_ACCOUNT);
+	if (!page)
+		return -ENOMEM;
+
+	list_add(&page->lru, &ctx->io_buffers_pages);
+
+	buf = page_address(page);
+	bufs_in_page = PAGE_SIZE / sizeof(*buf);
+	while (bufs_in_page) {
+		list_add_tail(&buf->list, &ctx->io_buffers_cache);
+		buf++;
+		bufs_in_page--;
+	}
+
+	return 0;
+}
+
+static int io_add_buffers(struct io_ring_ctx *ctx, struct io_provide_buf *pbuf,
+			  struct io_buffer **head)
 {
 	struct io_buffer *buf;
 	u64 addr = pbuf->addr;
 	int i, bid = pbuf->bid;
 
 	for (i = 0; i < pbuf->nbufs; i++) {
-		buf = kmalloc(sizeof(*buf), GFP_KERNEL_ACCOUNT);
-		if (!buf)
+		if (list_empty(&ctx->io_buffers_cache) &&
+		    io_refill_buffer_cache(ctx))
 			break;
-
+		buf = list_first_entry(&ctx->io_buffers_cache, struct io_buffer,
+					list);
+		list_del(&buf->list);
 		buf->addr = addr;
 		buf->len = min_t(__u32, pbuf->len, MAX_RW_COUNT);
 		buf->bid = bid;
@@ -4633,7 +4719,7 @@ static int io_provide_buffers(struct io_kiocb *req, unsigned int issue_flags)
 
 	list = head = xa_load(&ctx->io_buffers, p->bgid);
 
-	ret = io_add_buffers(p, &head);
+	ret = io_add_buffers(ctx, p, &head);
 	if (ret >= 0 && !list) {
 		ret = xa_insert(&ctx->io_buffers, p->bgid, head, GFP_KERNEL);
 		if (ret < 0)
@@ -5244,7 +5330,7 @@ static int io_recvmsg(struct io_kiocb *req, unsigned int issue_flags)
 	if (kmsg->free_iov)
 		kfree(kmsg->free_iov);
 	req->flags &= ~REQ_F_NEED_CLEANUP;
-	__io_req_complete(req, issue_flags, ret, io_put_kbuf(req));
+	__io_req_complete(req, issue_flags, ret, io_put_kbuf(req, issue_flags));
 	return 0;
 }
 
@@ -5299,7 +5385,7 @@ static int io_recv(struct io_kiocb *req, unsigned int issue_flags)
 out_free:
 		req_set_fail(req);
 	}
-	__io_req_complete(req, issue_flags, ret, io_put_kbuf(req));
+	__io_req_complete(req, issue_flags, ret, io_put_kbuf(req, issue_flags));
 	return 0;
 }
 
@@ -6719,7 +6805,7 @@ static __cold void io_drain_req(struct io_kiocb *req)
 static void io_clean_op(struct io_kiocb *req)
 {
 	if (req->flags & REQ_F_BUFFER_SELECTED)
-		io_put_kbuf(req);
+		io_put_kbuf_comp(req);
 
 	if (req->flags & REQ_F_NEED_CLEANUP) {
 		switch (req->opcode) {
@@ -9494,6 +9580,14 @@ static void io_destroy_buffers(struct io_ring_ctx *ctx)
 
 	xa_for_each(&ctx->io_buffers, index, buf)
 		__io_remove_buffers(ctx, buf, index, -1U);
+
+	while (!list_empty(&ctx->io_buffers_pages)) {
+		struct page *page;
+
+		page = list_first_entry(&ctx->io_buffers_pages, struct page, lru);
+		list_del_init(&page->lru);
+		__free_page(page);
+	}
 }
 
 static void io_req_caches_free(struct io_ring_ctx *ctx)


-- 
Jens Axboe

