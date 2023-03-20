Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A1FB56C2341
	for <lists+io-uring@lfdr.de>; Mon, 20 Mar 2023 21:57:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230244AbjCTU5w (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 20 Mar 2023 16:57:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42040 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230198AbjCTU5s (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 20 Mar 2023 16:57:48 -0400
Received: from mail-il1-x133.google.com (mail-il1-x133.google.com [IPv6:2607:f8b0:4864:20::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7B2D359D0
        for <io-uring@vger.kernel.org>; Mon, 20 Mar 2023 13:57:44 -0700 (PDT)
Received: by mail-il1-x133.google.com with SMTP id bc5so1428366ilb.9
        for <io-uring@vger.kernel.org>; Mon, 20 Mar 2023 13:57:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112; t=1679345864;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=IAyH74/h3Nt69hDZN42vQSbOyNUz1CutvowS5LT2Jic=;
        b=r+/1xUaM5x/KHYn42Md1OJU0JzGtJ1nGCnQnVHFydG5+dPIkniu7C4UAOq+y5AknNo
         3RpaxoaFjFAPoz/wgb4Mf9DuuwCbO6eUdG0do8bV/DhJbEz8Gr8tzdgzC8xovb1gDS32
         kRdS0uFNKa4BcdHQkuCsnMPetRU4a6hOldzqe2G+uz3WaR4g+8QXOZ+gd4a4OqbHNu7u
         oT4VYSckIxClr8XdrDs3VksAPC6KgrHWuwjQeZvB2WZrqWidTF6THLhm5MWGT1k50MbD
         pFvh645RHmqeUoVJQzxYMAh7aQKdgLijdgS5dVmnwnrg/PE8n0uu0/jCjkGdLKSzJz0k
         cMrQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679345864;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=IAyH74/h3Nt69hDZN42vQSbOyNUz1CutvowS5LT2Jic=;
        b=KK33EO1JtbPaPr/fuzszQrr2smqFCLWeZQDEO0KrFXIUhC4bQi6H5PidcvxDjQL9AQ
         iUveBeowKqitkrqvSK5C8WR5YXOhoeMPItjcV9qqd0Muq9TI+fneBzvrinhwdp11ol8X
         wcAZcUzYNazOLg7RrJrSWRwaFXEqBt88XlDVpYeZKAmFAXkxDV9RZXP8PVpvAoGxsT/l
         fsblOYtWeegQNZqbxuXqvnjCGlyncyqngbt2NeSKZ8poraF62XWGs/aT9SmC2TjV7ToL
         KCpxbVQ14+qCD6DF7WTU4ajHwSBOpPOmm6T674S9Mk9calil2P2csq7dCVJq62lI7u+U
         mGng==
X-Gm-Message-State: AO0yUKVaC6klnZ1ZJ2WANuiV0SajIr3hGQbVU8dEsWUFhB+XaD+F6F18
        Jysqyi2UlzqwmW7r4TPKTG31Hg==
X-Google-Smtp-Source: AK7set/1ZVYCb599lqZsiCEva3XtvFdNCfLQ/CPX2PAyfptVDgmzABLTlKUAuKcevuJiIqTnHcyI3g==
X-Received: by 2002:a05:6e02:15cb:b0:322:fad5:5d8f with SMTP id q11-20020a056e0215cb00b00322fad55d8fmr774483ilu.2.1679345863813;
        Mon, 20 Mar 2023 13:57:43 -0700 (PDT)
Received: from [192.168.1.94] ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id r3-20020a02aa03000000b004061d3cce02sm3681586jam.67.2023.03.20.13.57.43
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 20 Mar 2023 13:57:43 -0700 (PDT)
Message-ID: <24d0a268-d30a-cd79-c995-e30658d0dc1b@kernel.dk>
Date:   Mon, 20 Mar 2023 14:57:42 -0600
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux aarch64; rv:102.0) Gecko/20100101
 Thunderbird/102.8.0
Subject: Re: [PATCHv2] blk-mq: remove hybrid polling
Content-Language: en-US
To:     Keith Busch <kbusch@kernel.org>, Keith Busch <kbusch@meta.com>
Cc:     linux-block@vger.kernel.org, io-uring@vger.kernel.org,
        Pavel Begunkov <asml.silence@gmail.com>
References: <20230320194926.3353144-1-kbusch@meta.com>
 <ZBjIkXZLR2fSOyqX@kbusch-mbp.dhcp.thefacebook.com>
From:   Jens Axboe <axboe@kernel.dk>
In-Reply-To: <ZBjIkXZLR2fSOyqX@kbusch-mbp.dhcp.thefacebook.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 3/20/23 2:56 PM, Keith Busch wrote:
> On Mon, Mar 20, 2023 at 12:49:26PM -0700, Keith Busch wrote:
>> From: Keith Busch <kbusch@kernel.org>
>>
>> io_uring provides the only way user space can poll completions, and that
>> always sets BLK_POLL_NOSLEEP. This effectively makes hybrid polling dead
>> code, so remove it and everything supporting it.
> 
> Hybrid polling was effectively killed off with 9650b453a3d4b1, "block: ignore
> RWF_HIPRI hint for sync dio", so we could add a "Fixes: " for that. It was
> still potentially reachable through io_uring until d729cf9acb93119, "io_uring:
> don't sleep when polling for I/O", but hybrid polling probably should not have
> been reachable through that async interface from the beginning.

Thanks, I'll add it as fixing both of those. More as a reference than
anything else, it's not like we are backporting this change.

-- 
Jens Axboe


