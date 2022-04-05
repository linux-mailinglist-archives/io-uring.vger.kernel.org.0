Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E9E704F398F
	for <lists+io-uring@lfdr.de>; Tue,  5 Apr 2022 16:49:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242333AbiDELfa (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 5 Apr 2022 07:35:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49242 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1355545AbiDEKUU (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 5 Apr 2022 06:20:20 -0400
Received: from hr2.samba.org (hr2.samba.org [IPv6:2a01:4f8:192:486::2:0])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 90EEE75C13
        for <io-uring@vger.kernel.org>; Tue,  5 Apr 2022 03:05:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=samba.org;
        s=42; h=From:To:Date:Message-ID:CC;
        bh=bd44gXtz9EA+2ciuYmMNfF2ed/LdZlDFHzJzhGtWeqE=; b=R0Nv7OapVdrJ1SHBoUFLr3ryG8
        3NKGIi7jDkaBVxt2EGTYoAdD+/KSUKkrL8C35dY617VoJdF7gAD7O1KIx3NuBaqJxzFdCnRomU1Ay
        LkFA6gS6+qlBqRf1Dif8mZDrVvZ5q3pT5rf6YTkwthZY2RRTpG9Wj4UF2zQqEZbUOoeP7IOcTYgKO
        qWJ2dLuvpqRPS+ZR/z8COTAjW1LpewhiT0L9k4OFSlvTQwb3N8QOrExsvuDWmEgLT6XYvXnNykDfg
        B8zQI9wg/XOb0fFayDwZz889F7k7P8RFuNzRiKfxkCJs80JQKdMTxxnyqki7Z1pkbLVMs+iCYr3V5
        PYaymS4EpIXaDTKnp6DFfflh892Co5X2VGlYClBiPwwIpbHefbnxYRIgIomLzFGCRI77qZBjRX+8/
        olWqSx7nAYB3KZIp/4Q2WBVMt3qSCij/IPmpw6XCYRmQ0v3Y6dKnghIl0/R95ckUZjdCpIhDQMDAD
        iQq/y+oW0hznNp+3OUovVy+G;
Received: from [127.0.0.2] (localhost [127.0.0.1])
        by hr2.samba.org with esmtpsa (TLS1.3:ECDHE_SECP256R1__ECDSA_SECP256R1_SHA256__CHACHA20_POLY1305:256)
        (Exim)
        id 1nbg3W-005PGI-4K; Tue, 05 Apr 2022 10:04:58 +0000
Message-ID: <2c35f878-5f25-9afe-be39-7239a8d3df6d@samba.org>
Date:   Tue, 5 Apr 2022 12:04:57 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.7.0
Content-Language: en-US
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
References: <20220404235626.374753-1-axboe@kernel.dk>
From:   Stefan Metzmacher <metze@samba.org>
Subject: Re: [PATCHSET v4 0/5] Fix early file assignment for links or drain
In-Reply-To: <20220404235626.374753-1-axboe@kernel.dk>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-5.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Hi Jens,

> Most of this is prep patches, but the purpose is to make sure that we
> treat file assignment for links appropriately. If not, then we cannot
> use direct open/accept with links while avoiding separate submit+wait
> cycles.
> 
> v4:
> - Drop merged patch for msg-ring
> - Drop inflight tracking completely, pointless now
> - Fix locking issue around file assignment

If the behavior change is backported to 5.15 stable,
don't we need a flag to indicate that a newer kernel supports it?

Otherwise how could userspace know it can rely on the new behavior?

metze

