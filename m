Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 352616BD2DC
	for <lists+io-uring@lfdr.de>; Thu, 16 Mar 2023 16:01:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229789AbjCPPBR (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 16 Mar 2023 11:01:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48602 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229887AbjCPPBQ (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 16 Mar 2023 11:01:16 -0400
Received: from mail-il1-x136.google.com (mail-il1-x136.google.com [IPv6:2607:f8b0:4864:20::136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 24CC4126F5
        for <io-uring@vger.kernel.org>; Thu, 16 Mar 2023 08:01:15 -0700 (PDT)
Received: by mail-il1-x136.google.com with SMTP id i19so1126928ila.10
        for <io-uring@vger.kernel.org>; Thu, 16 Mar 2023 08:01:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112; t=1678978874;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:to:subject:user-agent:mime-version:date:message-id:from
         :to:cc:subject:date:message-id:reply-to;
        bh=XCNI+AWJb3ZvdS+yDM5ZfyadNN6lXeRKK5Avr2AaIUo=;
        b=0hcsx2wUfCBJOOjpZ0omiXWIrgjp5UjM/gmRvn8aDNGqCJVL/WZRCUwECQ3NuJilEb
         5vb8VCDllOgcdEJf4uZbiLL/RhDFKJFbVlfD4FYDDbnX4+v1LLJosSVXGlKcYQWxylQM
         47a/EAdQctY8OkZfG73LysLs5I7QUUYjXgX3+Hkyef3Xj6qfD+Jv5A29oBX6AjeXHnvZ
         bn3EzGXKg8OYwbUHR5/B2p3A6Y6hyVHGudfHo9cMn7VZ5dsGanpcsX32WSReGN9ZpneK
         x52vPQOO1bdkRyuNo7BJ6yrSNtfdm9k/3KxXsNoHD4b31P6hKVHt9S/UiUr3llAhjmo0
         IXbQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678978874;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=XCNI+AWJb3ZvdS+yDM5ZfyadNN6lXeRKK5Avr2AaIUo=;
        b=X/aGH6lA0sChswm00SDfF/q85IYnmLjVt+FkFnChOGmYhEUPUDtc16YcvwC2XnIeUZ
         KwBKsYKHz1a907TxT1y6/iaq0Rnu77O8QCatprqnBXttjiYXDufbm0VNS5GeQhiW/Kc+
         h0GcIqQzwIhPpyIBxSPwgx1TyaschOHDyvqBWQC/f+pyvv5dTuwIxokssg/HLqdmnunT
         mZU3XlXQmjK3q1EI4F7GxP4C8aM5w+9bERwo5Pui6tSDPhj9pOI1jIsWAlyXTMMm+xd9
         2R9T7XlFJhYOEgcoSS5XJfqhU64bVJc3NpKvCcJCj085fpizSEwCc80FCQg1FC4ZRcHb
         zzpQ==
X-Gm-Message-State: AO0yUKWaU5ICeOs/TgzaHAYOumL5N4viGV+zKsIEe1KDAnUsZ3m9SYPM
        U9DNIm5rrXzjbXqqxPpZPqgILyQv8AoAEHF4GQKjUQ==
X-Google-Smtp-Source: AK7set9AR1xvozCwv8K6DM9MzN9RUA2WLj5gLrvtraNmqeqKfD/arGDrHCe1ZmxR0KzNvn0Qw7k6nA==
X-Received: by 2002:a92:c263:0:b0:322:fad5:5d8f with SMTP id h3-20020a92c263000000b00322fad55d8fmr1995858ild.2.1678978874430;
        Thu, 16 Mar 2023 08:01:14 -0700 (PDT)
Received: from [192.168.1.94] ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id k2-20020a056e02134200b0030ef8f16056sm2438566ilr.72.2023.03.16.08.01.13
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 16 Mar 2023 08:01:13 -0700 (PDT)
Message-ID: <107fb53b-6761-61d2-0e15-3ab586b87208@kernel.dk>
Date:   Thu, 16 Mar 2023 09:01:12 -0600
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux aarch64; rv:102.0) Gecko/20100101
 Thunderbird/102.8.0
Subject: Re: [PATCH liburing 1/2] Add io_uring_prep_msg_ring_fd_alloc() helper
To:     Pavel Begunkov <asml.silence@gmail.com>, io-uring@vger.kernel.org
References: <cover.1678968783.git.asml.silence@gmail.com>
 <9237f9399e4d8fcc9c8c1996905168138f99d2b3.1678968783.git.asml.silence@gmail.com>
Content-Language: en-US
From:   Jens Axboe <axboe@kernel.dk>
In-Reply-To: <9237f9399e4d8fcc9c8c1996905168138f99d2b3.1678968783.git.asml.silence@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 3/16/23 7:09 AM, Pavel Begunkov wrote:
> Add a helper initialising msg-ring requests transferring files and
> allocating a target file index.

This needs an ffi map entry too, I added it.

-- 
Jens Axboe


