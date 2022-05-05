Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 25B5051C1AD
	for <lists+io-uring@lfdr.de>; Thu,  5 May 2022 15:57:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242789AbiEEN5U (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 5 May 2022 09:57:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45258 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346749AbiEEN5R (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 5 May 2022 09:57:17 -0400
Received: from szxga01-in.huawei.com (szxga01-in.huawei.com [45.249.212.187])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 48DA92FE52;
        Thu,  5 May 2022 06:53:37 -0700 (PDT)
Received: from kwepemi500019.china.huawei.com (unknown [172.30.72.54])
        by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4KvFX900GxzhYr7;
        Thu,  5 May 2022 21:53:12 +0800 (CST)
Received: from kwepemm600004.china.huawei.com (7.193.23.242) by
 kwepemi500019.china.huawei.com (7.221.188.117) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.24; Thu, 5 May 2022 21:53:34 +0800
Received: from huawei.com (10.175.124.27) by kwepemm600004.china.huawei.com
 (7.193.23.242) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.24; Thu, 5 May
 2022 21:53:34 +0800
From:   Guo Xuenan <guoxuenan@huawei.com>
To:     <axboe@kernel.dk>, <asml.silence@gmail.com>
CC:     <lee.jones@linaro.org>, <linux-kernel@vger.kernel.org>,
        <io-uring@vger.kernel.org>, <guoxuenan@huawei.com>,
        <yi.zhang@huawei.com>, <houtao1@huawei.com>
Subject: linux-stable-5.10-y CVE-2022-1508 of io_uring module
Date:   Thu, 5 May 2022 22:11:59 +0800
Message-ID: <20220505141159.3182874-1-guoxuenan@huawei.com>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <dd122760-5f87-10b1-e50d-388c2631c01a@kernel.dk>
References: <dd122760-5f87-10b1-e50d-388c2631c01a@kernel.dk>
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.175.124.27]
X-ClientProxiedBy: dggems701-chm.china.huawei.com (10.3.19.178) To
 kwepemm600004.china.huawei.com (7.193.23.242)
X-CFilter-Loop: Reflected
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Hi, Pavel & Jens

CVE-2022-1508[1] contains an patch[2] of io_uring. As Jones reported,
it is not enough only apply [2] to stable-5.10. 
Io_uring is very valuable and active module of linux kernel.
I've tried to apply these two patches[3] [4] to my local 5.10 code, I
found my understanding of io_uring is not enough to resolve all conflicts.

Since 5.10 is an important stable branch of linux, we would appreciate
your help in soloving this problem.

[1] https://access.redhat.com/security/cve/cve-2022-1508
[2] https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit/?id=89c2b3b7491
[3] https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit/?id=8fb0f47a9d7
[4] https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit/?id=cd65869512a

Best regards
Xuenan
