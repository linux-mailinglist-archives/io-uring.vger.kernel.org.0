Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 549B04BD0AF
	for <lists+io-uring@lfdr.de>; Sun, 20 Feb 2022 19:39:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244512AbiBTShy (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sun, 20 Feb 2022 13:37:54 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:40040 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230370AbiBTShv (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sun, 20 Feb 2022 13:37:51 -0500
Received: from cloud48395.mywhc.ca (cloud48395.mywhc.ca [173.209.37.211])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 82F9EB847;
        Sun, 20 Feb 2022 10:37:29 -0800 (PST)
Received: from [45.44.224.220] (port=44660 helo=[192.168.1.179])
        by cloud48395.mywhc.ca with esmtpsa  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <olivier@trillion01.com>)
        id 1nLr5L-00074M-PE; Sun, 20 Feb 2022 13:37:27 -0500
Message-ID: <b674472d8c52a84002908e2248fd81ce11247569.camel@trillion01.com>
Subject: Re: [PATCH v1] io_uring: Add support for napi_busy_poll
From:   Olivier Langlois <olivier@trillion01.com>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     Pavel Begunkov <asml.silence@gmail.com>,
        Hao Xu <haoxu@linux.alibaba.com>,
        io-uring <io-uring@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
Date:   Sun, 20 Feb 2022 13:37:26 -0500
In-Reply-To: <f070354c-b65b-f8b3-e597-2e756bcfa705@kernel.dk>
References: <d11e31bd59c75b2cce994dd90a07e769d4e039db.1645257310.git.olivier@trillion01.com>
         <cbf791fb3cd495f156eb4aeb4dd01c42fca22cd4.camel@trillion01.com>
         <f070354c-b65b-f8b3-e597-2e756bcfa705@kernel.dk>
Organization: Trillion01 Inc
Content-Type: text/plain; charset="ISO-8859-1"
User-Agent: Evolution 3.42.3 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - cloud48395.mywhc.ca
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - trillion01.com
X-Get-Message-Sender-Via: cloud48395.mywhc.ca: authenticated_id: olivier@trillion01.com
X-Authenticated-Sender: cloud48395.mywhc.ca: olivier@trillion01.com
X-Source: 
X-Source-Args: 
X-Source-Dir: 
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Sat, 2022-02-19 at 17:22 -0700, Jens Axboe wrote:
> 
> Outside of this, I was hoping to see some performance numbers in the
> main patch. Sounds like you have them, can you share?
> 
Yes.

It is not much. Only numbers from my application and it is far from
being the best benchmark because the result can be influenced by
multiple external factors.

Beside addressing the race condition remaining inside io_cqring_wait()
around napi_list for v2 patch, creating a benchmark program that
isolate the performance of the new feature is on my todo list.

I would think that creating a simple UDP ping-pong setup and measure
RTT with and without busy_polling should be a good enough test.

In the meantime, here are the results that I have:

Without io_uring busy poll:
reaction time to an update: 17159usec
reaction time to an update: 19068usec
reaction time to an update: 23055usec
reaction time to an update: 16511usec
reaction time to an update: 17604usec

With io_uring busy poll:
reaction time to an update: 15782usec
reaction time to an update: 15337usec
reaction time to an update: 15379usec
reaction time to an update: 15275usec
reaction time to an update: 15107usec

Concerning my latency issue with busy polling, I have found this that
might help me:
https://lwn.net/ml/netdev/20201002222514.1159492-1-weiwan@google.com/

