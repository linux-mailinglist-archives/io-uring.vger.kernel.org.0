Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6C4B75EABA0
	for <lists+io-uring@lfdr.de>; Mon, 26 Sep 2022 17:50:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235357AbiIZPu5 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 26 Sep 2022 11:50:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49098 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234477AbiIZPuf (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 26 Sep 2022 11:50:35 -0400
Received: from mail-io1-xd2d.google.com (mail-io1-xd2d.google.com [IPv6:2607:f8b0:4864:20::d2d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B075B51A0E
        for <io-uring@vger.kernel.org>; Mon, 26 Sep 2022 07:37:55 -0700 (PDT)
Received: by mail-io1-xd2d.google.com with SMTP id d8so5350668iof.11
        for <io-uring@vger.kernel.org>; Mon, 26 Sep 2022 07:37:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date;
        bh=sw6FZfqvzqmIX08UU5Lp/Uj6v4XlSe1NzsiXFnfdCQQ=;
        b=Sgk7alXXb92f8PuIwx5286o8RmTgibl09jojUbn0aQnglsvqSkRc63Rbb/PKHCsnWp
         Zp9Ql3jXYfs9f9jPlBoEVH+KcUOtZTf9qDObHCVzc2DN/f32kF4n2DdbShZSIQWZ2LCp
         xphNxJPxas1kCrrp1f7LcqXPD/7Z0ir5kthtSk9Yt5F7Oe9x3WASdtNVhHQsRAawoqsO
         ZehgRkevoTRmE3+taiu8haTclgXb7j+oWKXpQEzTjWCU6pIP011YlIZLPU/z6H4/6/hM
         Cs10ttseX8HJ3duSUtX7rqDDEMYL2OnWWcy2LI/uOE7zIf3bwZCTJzFhyjcxlqhx2Elc
         GfoQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date;
        bh=sw6FZfqvzqmIX08UU5Lp/Uj6v4XlSe1NzsiXFnfdCQQ=;
        b=zA7A3D6OWWL6bjVKmfSrxL1mF5db8Sr4JSZ26LR9KeWRwJwypWeZQdOWYHNsYYMHIN
         ETaTNey9y327LIuP2r8kDOBW1VTIBfHaPObuHchRoOf2h61b1SiG1W3O9cq245dwnPhz
         opDRs4QvGnnsEIkY1i0XtZM+5qqpdijOrFua0m9hTwu6up4tdKK8R8IPa/LDycvn+tSj
         WGLH/RkOv3kFKY71Pdk5A6Q1M3Gxw09mAcAfq2Ukd44qo8gex2x8AFFtA5uprLAJ/DQS
         pSji/v3xb8Mc+20pcX6udRxNhzA52C1WRTrokC6slHx4Vvf+QxW2bptgh/9Y1IlihAGu
         BQNw==
X-Gm-Message-State: ACrzQf1wW38M0UtTqFLZfaJSRLqokokWZzOE8y5todCJXnCgE71h83oj
        COTUDjFEl8sSuh21VSHS5PRLTQ==
X-Google-Smtp-Source: AMsMyM6dc8lGAnVF5vWLwpmxZCPIcuTQGiT+kISHXfhf5AFSZVDgnKY327j0Xn7BDiTqruKZzb9eHA==
X-Received: by 2002:a02:2711:0:b0:35a:4fb3:efcf with SMTP id g17-20020a022711000000b0035a4fb3efcfmr11779967jaa.14.1664203074842;
        Mon, 26 Sep 2022 07:37:54 -0700 (PDT)
Received: from [192.168.1.94] ([207.135.234.126])
        by smtp.gmail.com with ESMTPSA id i7-20020a056638380700b00349d2d52f6asm7097615jav.37.2022.09.26.07.37.54
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 26 Sep 2022 07:37:54 -0700 (PDT)
Message-ID: <e1ddd430-384d-f704-2373-41a455288380@kernel.dk>
Date:   Mon, 26 Sep 2022 08:37:53 -0600
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux aarch64; rv:102.0) Gecko/20100101
 Thunderbird/102.2.2
Subject: Re: [PATCH 0/3] io_uring: register single issuer task at creation
Content-Language: en-US
To:     Dylan Yudaken <dylany@fb.com>,
        Pavel Begunkov <asml.silence@gmail.com>
Cc:     io-uring@vger.kernel.org, linux-kernel@vger.kernel.org,
        kernel-team@fb.com
References: <20220926140304.1973990-1-dylany@fb.com>
From:   Jens Axboe <axboe@kernel.dk>
In-Reply-To: <20220926140304.1973990-1-dylany@fb.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 9/26/22 8:03 AM, Dylan Yudaken wrote:
> Registering the single issuer task from the first submit adds unnecesary
> complications to the API as well as the implementation. Where simply
> registering it at creation should not impose any barriers to getting the
> same performance wins.
> 
> There is another problem in 6.1, with IORING_SETUP_DEFER_TASKRUN. That
> would like to check the submitter_task from unlocked contexts, which would
> be racy. If upfront the submitter_task is set at creation time it will
> simplify the logic there and probably increase performance (though this is
> unmeasured).
> 
> Patch 1 registers the task at creation of the io_uring, this works
> standalone in case you want to only merge this part for 6.0
> 
> Patch 2/3 cleans up the code from the old style

Applied 1/3 for 6.0, and then created a new branch for 6.1 that holds
2-3/3. Thanks!

-- 
Jens Axboe


