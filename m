Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 33C5551649F
	for <lists+io-uring@lfdr.de>; Sun,  1 May 2022 15:28:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347615AbiEANcB (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sun, 1 May 2022 09:32:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38306 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347585AbiEANb7 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sun, 1 May 2022 09:31:59 -0400
Received: from mail-pl1-x636.google.com (mail-pl1-x636.google.com [IPv6:2607:f8b0:4864:20::636])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7F6513299E
        for <io-uring@vger.kernel.org>; Sun,  1 May 2022 06:28:34 -0700 (PDT)
Received: by mail-pl1-x636.google.com with SMTP id c11so450129plg.13
        for <io-uring@vger.kernel.org>; Sun, 01 May 2022 06:28:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :references:from:in-reply-to:content-transfer-encoding;
        bh=argmY1poNmp/0MDul2tUbvzr6VVXO2oxAKwKuLQGC6Y=;
        b=vyYJvXkEsHycJR+klGYh3P+3rEmK9/1ecw2kUGWDGnfqqrP8cAQH318GxT+nOX9lq6
         txRlhCBS3uiNEVEKgpVQn2WpLKJeNo0bXwQN2OQ56elrwsrGGfZUDBClcq2HXz0VlUyr
         5jvYA6Uwk/C1YF8xFmpkoSCMUZpEke7MOTBiwwp9SCrl9uBo1XZy80+9dYl/BvSe56bK
         qntNEJcEWEqtrlW2UEhNf+/yFgDGzk0gv6FGc2AqpiqLE2gyNU7rbT/QkM4TNDfA6sve
         ictLkZcaJUoqxOfVAH1C3eP8isRb8xbPoMUKD355mB/hQRWYzeu27UKUeO9gdE2urTFd
         3elQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:references:from:in-reply-to
         :content-transfer-encoding;
        bh=argmY1poNmp/0MDul2tUbvzr6VVXO2oxAKwKuLQGC6Y=;
        b=fDnk26rHYJFIha8ISh6fcFMjG0essjJtP/sxWFeasCw7Q+s/xZH2Nc6LRjVA2A0+GL
         oF7D2PMV96PxuCPH4UnSEJLvyIbm9XaLai4w6Zgz1IIyxAHr1AS72sTeN1RsbQahssQw
         zlt6Ncl5GVfrb9VFQRfY2vUtyMHvMymxj+eS5Wwmew1VHo5VyPJObB4Bh67BFO6K89oc
         vCuAMBfc/Ce4qHWFfFjzuk1ssThxKcmrGvAgC2rIPa60C1KZxMlCN6q8QoNixeoy7ro9
         89moyj9EZFvwrYDW9oDn8lCT0+M5iOwbMVyTGoq44o3Egus7pWZpaJYDaPVzuLpIKbEl
         7LXA==
X-Gm-Message-State: AOAM531PvyqNE8PVYjHcwCRia51QUhyX1zFy+JbR0mXJsB7w0LgGjIu8
        xUJyee/iSQe6JB6xAD/1oHkau5KonwLTBe5p
X-Google-Smtp-Source: ABdhPJzsgp0ugkXXBV6/jGEWNy973ZN21PyTOEMCQT5HlhAKsBHNb2ISwsi9Valp54T34bVW7/8UhQ==
X-Received: by 2002:a17:90b:4aca:b0:1dc:2bd0:ee1d with SMTP id mh10-20020a17090b4aca00b001dc2bd0ee1dmr6585985pjb.170.1651411713894;
        Sun, 01 May 2022 06:28:33 -0700 (PDT)
Received: from [192.168.1.100] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id m69-20020a633f48000000b003c14af50637sm9692528pga.79.2022.05.01.06.28.32
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 01 May 2022 06:28:33 -0700 (PDT)
Message-ID: <f7e46c2f-5f38-5d9a-9e29-d04363961a97@kernel.dk>
Date:   Sun, 1 May 2022 07:28:32 -0600
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux aarch64; rv:91.0) Gecko/20100101
 Thunderbird/91.8.1
Subject: Re: [PATCHSET v2 RFC 0/11] Add support for ring mapped provided
 buffers
Content-Language: en-US
To:     Pavel Begunkov <asml.silence@gmail.com>, io-uring@vger.kernel.org
References: <20220429175635.230192-1-axboe@kernel.dk>
 <69fc3830-8b2e-7b40-ad68-394c7c9fbf60@gmail.com>
From:   Jens Axboe <axboe@kernel.dk>
In-Reply-To: <69fc3830-8b2e-7b40-ad68-394c7c9fbf60@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-3.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 5/1/22 7:14 AM, Pavel Begunkov wrote:
> On 4/29/22 18:56, Jens Axboe wrote:
>> Hi,
>>
>> This series builds to adding support for a different way of doing
>> provided buffers. The interesting bits here are patch 11, which also has
>> some performance numbers an an explanation of it.
> 
> Jens, would be great if you can CC me for large changes, you know
> how it's with mailing lists nowadays...

You bet, I can just add you to anything posted. Starting to lose faith
in email ever becoming reliable again...

> 1) reading "io_uring: abstract out provided buffer list selection"
> 
> Let's move io_ring_submit_unlock() to where the lock call is.
> In the end, it's only confusing and duplicates unlock in
> io_ring_buffer_select() and io_provided_buffer_select().

Sure, I can clean that up.

> 2) As it's a new API, let's do bucket selection right, I quite
> don't like io_buffer_get_list(). We can replace "bgid" with
> indexes into an array and let the userspace to handle indexing.
> Most likely it knows the index right away or can implement indexes
> lookup with as many tricks and caching it needs.

Maybe we can just use xarray here rather than a hashed list? It's really
just a sparse array. The downside is that xarray locking isn't always
very convenient, eg using it with your own locking...

Any other suggestions?

-- 
Jens Axboe

