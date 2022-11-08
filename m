Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 35D52621166
	for <lists+io-uring@lfdr.de>; Tue,  8 Nov 2022 13:50:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233985AbiKHMu1 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 8 Nov 2022 07:50:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37142 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233820AbiKHMu1 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 8 Nov 2022 07:50:27 -0500
Received: from gnuweeb.org (gnuweeb.org [51.81.211.47])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4BF9FB38
        for <io-uring@vger.kernel.org>; Tue,  8 Nov 2022 04:50:26 -0800 (PST)
Received: from [10.7.7.5] (unknown [182.253.88.158])
        by gnuweeb.org (Postfix) with ESMTPSA id 33F05814AD;
        Tue,  8 Nov 2022 12:50:23 +0000 (UTC)
X-GW-Data: lPqxHiMPbJw1wb7CM9QUryAGzr0yq5atzVDdxTR0iA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gnuweeb.org;
        s=default; t=1667911825;
        bh=m582fqvc5yj7Tq4Ecp/5YHaDwZMM0YXRonFsOJIgc10=;
        h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
        b=T3RHPy4UPZi3ZCBkWEQKcikTA6BZPNMXLO1bsCuW7GUx/NepwfZEEToJ6eN5j10GW
         biRPutL6kN/aobVUZIJ4ar/jttfUsgWP0pBHerSXtXoJYlKeMVSLqjL91PnewV43pB
         qA60ZJNtSHJOICzJSuQBpDOiOMiyty253fwxMJkVuzwSGCADsUP7kutTm3bsq75PES
         LRUuSSlLELOUDEFsUyn3s/PWEFl7N4V2RXeNuxi3MvSywTlsao7+YWrNGVYPwVOhHh
         w0lQfwJD5aMn52dxxd31ydLTKzTD3zuoZge8iea0hgjCbAvpwXrv+U7oNuhcVqPrOi
         Y8QvijA+CiYqg==
Message-ID: <741d8fb7-863a-b0c5-c42b-5e227d0f7937@gnuweeb.org>
Date:   Tue, 8 Nov 2022 19:50:21 +0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.2.2
Subject: Re: [PATCH liburing v4] test that unregister_files processes task
 work
Content-Language: en-US
To:     Dylan Yudaken <dylany@meta.com>
Cc:     io-uring Mailing List <io-uring@vger.kernel.org>,
        Jens Axboe <axboe@kernel.dk>,
        Pavel Begunkov <asml.silence@gmail.com>
References: <20221108124207.751615-1-dylany@meta.com>
From:   Ammar Faizi <ammarfaizi2@gnuweeb.org>
In-Reply-To: <20221108124207.751615-1-dylany@meta.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,SPF_HELO_PASS,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 11/8/22 7:42 PM, Dylan Yudaken wrote:
> Ensure that unregister_files processes task work from defer_taskrun even
> when not explicitly flushed.
> 
> Signed-off-by: Dylan Yudaken <dylany@meta.com>

I feel a bit irritated because the close() and io_uring_queue_exit()
don't get invoked in the error paths. But not a big deal, since in the
test we'll be exiting soon after that :p

Reviewed-by: Ammar Faizi <ammarfaizi2@gnuweeb.org>

-- 
Ammar Faizi

