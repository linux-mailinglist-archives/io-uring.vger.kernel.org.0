Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5A86C6E86C3
	for <lists+io-uring@lfdr.de>; Thu, 20 Apr 2023 02:46:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232273AbjDTAqd (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 19 Apr 2023 20:46:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46166 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232265AbjDTAqb (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 19 Apr 2023 20:46:31 -0400
Received: from mail-wm1-x335.google.com (mail-wm1-x335.google.com [IPv6:2a00:1450:4864:20::335])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B87132685
        for <io-uring@vger.kernel.org>; Wed, 19 Apr 2023 17:46:30 -0700 (PDT)
Received: by mail-wm1-x335.google.com with SMTP id 5b1f17b1804b1-3f176a16c03so1705095e9.2
        for <io-uring@vger.kernel.org>; Wed, 19 Apr 2023 17:46:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1681951589; x=1684543589;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=Yg2tIgDY+QtktQKRUt7sPjeZBLSP+diyakLZ0LuiMTo=;
        b=mTfjmRsvXNx/Vs26BfRkergM3Jrx66eC254MAPX7gCe6wh/M05dbzH4R3nn5gkjJxe
         C4L2p0Ak7NTZqMgGsoHqExHTWYaL7L+usViRwa+CSzV6tnnBKkgf7CQ7c2ZURI/fwTS7
         hoR0DS8nyQUY/YbPkgVpqfHE2X5+W2FywLr3BQ4/3/J0sRlj3nTEBRILgM9sUsMA2dPU
         qOp873ZVwYIx/U7Isl+FgZYAY56FeNtEk3yV6ODPpYFubPFkbK8+A4LyRSajhoacB+W3
         YcAlULwnh8OG4A87BOgC5aBePPnrVK88UtAN2UrcD3+4elhQyhZ5l4o3VLVhzAJFvy+y
         BsKQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1681951589; x=1684543589;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Yg2tIgDY+QtktQKRUt7sPjeZBLSP+diyakLZ0LuiMTo=;
        b=KNmAOwDhy3HrsJNdn130zcFRndBN3MTf4kMmgqafIo5facmYg/wqEHq9QSFp4jvN/h
         +HCJTdYDjc4/Vg6nzhD+Cy0wtnedfSe6uGkQ5AdNhqBW466E58OF6TLKIQRGaSoC1Xu/
         bwHvTxGIL+6nDSmMbtJVVsTLzfGoPZFiZ4ap4z9jwxSaT6fB1IGtsTsmy4Kbq/l8eKCJ
         p54bSZqeIBlU5TKMUKmtGgf1v/Gah1b3RI5UPLXsQkhxqp8k3+Ym6vKj0Mmb5CPuEOX9
         axhpBQ5I1JaMy9r+rATvWrKMdS9VKw32kp/fPm1zrQjWWepM/D5ifNdT0G0EXYsv5B6b
         Rfcw==
X-Gm-Message-State: AAQBX9efvJ/baJeYXXgh+a3OFgMgxlxRMF/ZIPLvhhGatCO4i1vjQK9x
        NxUOly9SmoIc34pcL/q5LenuETCeCC8=
X-Google-Smtp-Source: AKy350ZMvbpvcaNshV+4Mo+Lrqi8NWvLzAUIc6dd9WCTVg+XjeuCYNEdtdpgdaSLZ34nciDyNHLU/A==
X-Received: by 2002:a5d:500b:0:b0:2ef:9837:6b2b with SMTP id e11-20020a5d500b000000b002ef98376b2bmr5768041wrt.21.1681951589047;
        Wed, 19 Apr 2023 17:46:29 -0700 (PDT)
Received: from [192.168.8.100] (188.28.97.56.threembb.co.uk. [188.28.97.56])
        by smtp.gmail.com with ESMTPSA id i1-20020a05600011c100b002cff06039d7sm458401wrx.39.2023.04.19.17.46.28
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 19 Apr 2023 17:46:28 -0700 (PDT)
Message-ID: <1f57b637-e0b5-2954-fa34-ff2672f55787@gmail.com>
Date:   Thu, 20 Apr 2023 01:43:35 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.10.0
Subject: Re: [PATCHSET 0/6] Enable NO_OFFLOAD support
Content-Language: en-US
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
Cc:     luhongfei@vivo.com
References: <20230419162552.576489-1-axboe@kernel.dk>
From:   Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <20230419162552.576489-1-axboe@kernel.dk>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.7 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 4/19/23 17:25, Jens Axboe wrote:
> Hi,
> 
> This series enables support for forcing no-offload for requests that
> otherwise would have been punted to io-wq. In essence, it bypasses
> the normal non-blocking issue in favor of just letting the issue block.
> This is only done for requests that would've otherwise hit io-wq in
> the offload path, anything pollable will still be doing non-blocking
> issue. See patch 3 for details.

That's shooting ourselves in the leg.

1) It has never been easier to lock up userspace. They might be able
to deal with simple cases like read(pipe) + write(pipe), though even
that in a complex enough framework would cause debugging and associated
headache.

Now let's assume that the userspace submits nvme passthrough requests,
it exhausts tags and a request is left waiting there. To progress
forward one of the previous reqs should complete, but it's only putting
task in tw, which will never be run with DEFER_TASKRUN.

It's not enough for the userspace to be careful, for DEFER_TASKRUN
there will always be a chance to get locked .

2) It's not limited only to requests we're submitting, but also
already queued async requests. Inline submission holds uring_lock,
and so if io-wq thread needs to grab a registered file for the
request, it'll io_ring_submit_lock() and wait until the submission
ends. Same for provided buffers and some other cases.

Even task exit will actively try to grab the lock.

-- 
Pavel Begunkov
