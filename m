Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C5B0C675A5F
	for <lists+io-uring@lfdr.de>; Fri, 20 Jan 2023 17:46:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230403AbjATQqH (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 20 Jan 2023 11:46:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57096 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230422AbjATQqG (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 20 Jan 2023 11:46:06 -0500
Received: from mail-il1-x12b.google.com (mail-il1-x12b.google.com [IPv6:2607:f8b0:4864:20::12b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1749F73EE4
        for <io-uring@vger.kernel.org>; Fri, 20 Jan 2023 08:46:04 -0800 (PST)
Received: by mail-il1-x12b.google.com with SMTP id r19so2595480ilt.7
        for <io-uring@vger.kernel.org>; Fri, 20 Jan 2023 08:46:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=6jGSjVHoA66QoqpYo5YpaS5Orq+4JCym6//ZWkXoS7Y=;
        b=8AVhrkTBsNpi4vhbxXwCFFC+JPofSIN5QKW4VTC73RR80XDyH6xEUkyO2VVbx2gg+g
         HKfC4keYGVN6uGBcMK8kAaOqQoEtXxH/rOonN+Svya4mbS2RIf0EdEThPVVqeoFn/DYM
         /uVBH6MIRuWeo3Cr15UZD69uYea+yWYBPiyl6KxcXZvdFSLZ49FjPl9EcmNo7VqX1tMP
         0UUbu61dahXNbUHSUgUMUeiD2p3hQe+cNaOPryXqxVs8FC75mPYwQl+gMGkbDK2MBTJ6
         V69cXb9ZWVt97b3cfFISJyxGoWWp+BZdIu2hSEbcgPRGusMMC1mU2rNMZ55v3PHt3SiF
         LfBA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=6jGSjVHoA66QoqpYo5YpaS5Orq+4JCym6//ZWkXoS7Y=;
        b=3Sq6smcxqsa+DOM6ckiIbS7IOzdfpjeuNyZI/gWXnmGDPmpg/RNyJJj5y3ooqlJq3P
         Mr7UzpRypGpvURBzs3KbH+ANQ60tExNsfMVuXx7KZ05seko2R89chnH4j9Tu1fV14PLM
         TD0xnPRkwrGjhLrODQwrYtXMhGtHvmxdKM+D9pgRIfHzxAxTiC7199oyDwhuC2LqAtMM
         IXPsReP62wUKGdKF2c/gdwPhcmW/YzqIv8gUWagFdeujyrDxh2ScVSJLjKxDU7UhkbN5
         M+gOYG6zz4RuYonQz8h/UQ/YsSpmcdClYfwLI/YTv9lsbljI4Zo8R8mTZ9mbeHPirUEf
         QDdA==
X-Gm-Message-State: AFqh2krRsozaLX92d+tTpLuSczZBJplo22ZWBtPJoZB30rttUIhOvP1J
        hyB9HsjHM17+73+oYNNEueWg8A==
X-Google-Smtp-Source: AMrXdXsX5Tynw4pbnVz+RLVjHxp1oEtW28Yw7cgy/oXfuuqk5Wh6ETTh93fr1Dr5mxqiRQMslCL2hg==
X-Received: by 2002:a92:d841:0:b0:30e:ed5c:8c87 with SMTP id h1-20020a92d841000000b0030eed5c8c87mr2013832ilq.3.1674233163290;
        Fri, 20 Jan 2023 08:46:03 -0800 (PST)
Received: from [192.168.1.94] ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id d2-20020a028582000000b0039e97f04e1esm9312768jai.155.2023.01.20.08.46.02
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 20 Jan 2023 08:46:02 -0800 (PST)
Message-ID: <59f0c85d-7afd-1bf2-cc36-983fa70741f4@kernel.dk>
Date:   Fri, 20 Jan 2023 09:46:02 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux aarch64; rv:102.0) Gecko/20100101
 Thunderbird/102.6.0
Subject: Re: [PATCH for-6.2 v2 0/3] msg_ring fixes
Content-Language: en-US
To:     Pavel Begunkov <asml.silence@gmail.com>, io-uring@vger.kernel.org
References: <cover.1674232514.git.asml.silence@gmail.com>
From:   Jens Axboe <axboe@kernel.dk>
In-Reply-To: <cover.1674232514.git.asml.silence@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 1/20/23 9:38 AM, Pavel Begunkov wrote:
> First two patches are msg_ring fixes. 3/3 can go 6.3
> 
> v2: fail msg_ring'ing to disabled rings
> 
> Pavel Begunkov (3):
>   io_uring/msg_ring: fix flagging remote execution
>   io_uring/msg_ring: fix remote queue to disabled ring
>   io_uring/msg_ring: optimise with correct tw notify method
> 
>  io_uring/io_uring.c |  4 ++--
>  io_uring/msg_ring.c | 55 +++++++++++++++++++++++++++++++--------------
>  2 files changed, 40 insertions(+), 19 deletions(-)

I took 1-2 for 6.2, and then will get 3 applied for 6.3 once these
two hit mainline.

-- 
Jens Axboe


