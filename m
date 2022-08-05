Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B998658AC70
	for <lists+io-uring@lfdr.de>; Fri,  5 Aug 2022 16:41:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238607AbiHEOlW (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 5 Aug 2022 10:41:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34076 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230363AbiHEOlV (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 5 Aug 2022 10:41:21 -0400
Received: from mail-il1-x132.google.com (mail-il1-x132.google.com [IPv6:2607:f8b0:4864:20::132])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8C3712F019
        for <io-uring@vger.kernel.org>; Fri,  5 Aug 2022 07:41:19 -0700 (PDT)
Received: by mail-il1-x132.google.com with SMTP id g18so1470502ilk.4
        for <io-uring@vger.kernel.org>; Fri, 05 Aug 2022 07:41:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc;
        bh=9SWifh8Q7b0YSnhcRYiE2N+LF4E02tEu8VVuL6YJKuo=;
        b=oFhhozEdB/4UqcQz65JiCNZvgaOAkM10q8oFCVFVTdV8n6lD76Qylnw3Glt9NzCjhQ
         3YnnUJa+h8lHNqNVlBheZQXhKSvw+z1vnUWIi3IxJPknaoDywEgNFiywGYSof+t+hvO4
         oM5N+0LUJUD7dYIzLdB0g7kgg4ijjy669UA6UGu2mItG8Kp3IvkITmcHGwnuYhwBLd0E
         eVJPtqtuwCmtkgkklD6YvlQNYAgL8+NF6RJdQMqz3Lcu/92Tye+GKQxiu0heJdR+6gKK
         7A567ofRUPgSOjLoWAkmgzo4P1vfZspWEceXWVbvy/dAc97Ia63XTxthZdix6CjVUK9e
         730A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc;
        bh=9SWifh8Q7b0YSnhcRYiE2N+LF4E02tEu8VVuL6YJKuo=;
        b=tNMligl6Z86sR5CrL5KvBxlJj5diaKyXLZnU7HkAAP8FmKOoVwVZgovNgYdXzWL4kL
         fiofzwrEpvbSGRlmYm7jO+fGNS3EBhe+m+8bn3iBEhYXR6aPRISFgnrxi176ZgXTQHeN
         1GvhMg0OwG0WFphKALVOOpbSigq1DS32+BbbWTqlQRpXlwF9u5FdgsIDLDQ+X0M6nGN6
         R8G0VGZWL1uWaqiwz0jgtxn9SHS1in6lSvxW18sawJzg08/UOEw0EIJ0RBcgge40r0DJ
         A0IkW4ZMeTy0qjlnLzueAdBkbcCTBpiddNEqypNucEI/qHe2FPCs4msBUA0B6bHicLzJ
         2ZVw==
X-Gm-Message-State: ACgBeo3+M3XBl3Wh32cMmlfYlq2Dcr9MqsutrMNSv3ywbe0WUZMSfGtr
        hxG5+MxCcda6WbqXVXvylE48Jg==
X-Google-Smtp-Source: AA6agR4qYoK3Pepm36BfNZMDcN6iEIb34c93CItRTaHssPMrcHDF0C4Me8kAwxpIcGs57rXXqsRbJw==
X-Received: by 2002:a05:6e02:1b8a:b0:2df:33d1:f85 with SMTP id h10-20020a056e021b8a00b002df33d10f85mr3219747ili.81.1659710478918;
        Fri, 05 Aug 2022 07:41:18 -0700 (PDT)
Received: from [192.168.1.172] ([207.135.234.126])
        by smtp.gmail.com with ESMTPSA id j19-20020a056e02125300b002dea1e18a94sm1716281ilq.47.2022.08.05.07.41.17
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 05 Aug 2022 07:41:18 -0700 (PDT)
Message-ID: <11442793-a1d0-2773-35d9-b39a0148d9c0@kernel.dk>
Date:   Fri, 5 Aug 2022 08:41:15 -0600
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux aarch64; rv:91.0) Gecko/20100101
 Thunderbird/91.10.0
Subject: Re: [PATCH] io_uring: fix io_recvmsg_prep_multishot casts
Content-Language: en-US
To:     Dylan Yudaken <dylany@fb.com>,
        Pavel Begunkov <asml.silence@gmail.com>,
        io-uring@vger.kernel.org
Cc:     Kernel-team@fb.com, kernel test robot <lkp@intel.com>
References: <20220805115450.3921352-1-dylany@fb.com>
From:   Jens Axboe <axboe@kernel.dk>
In-Reply-To: <20220805115450.3921352-1-dylany@fb.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 8/5/22 5:54 AM, Dylan Yudaken wrote:
> Fix casts missing the __user parts. This seemed to only cause errors on
> the alpha build, but it was definitely an oversight.
> 
> Reported-by: kernel test robot <lkp@intel.com>
> Fixes: 9bb66906f23e ("io_uring: support multishot in recvmsg")
> Signed-off-by: Dylan Yudaken <dylany@fb.com>
> ---
> 
> Hi,
> 
> I tried to reproduce this issue to be sure this fixes it, but I could not get the
> warnings out of the gcc I have locally.
> That being said it seems like a fairly clear fix.

If you do:

axboe@m1 ~/gi/linux-block (io_uring-6.0)> make C=1 io_uring/net.o
o_uring/net.c: note: in included file (through io_uring/io_uring.h):
io_uring/slist.h:138:29: warning: no newline at end of file
io_uring/net.c:579:44: warning: incorrect type in assignment (different address spaces)
io_uring/net.c:579:44:    expected void [noderef] __user *msg_control_user
io_uring/net.c:579:44:    got void *
io_uring/net.c:584:14: warning: incorrect type in assignment (different address spaces)
io_uring/net.c:584:14:    expected void [noderef] __user *
io_uring/net.c:584:14:    got void *

it'll show it, you need 'sparse' installed for that.


-- 
Jens Axboe

