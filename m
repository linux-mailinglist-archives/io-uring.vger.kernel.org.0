Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0FD1452C22F
	for <lists+io-uring@lfdr.de>; Wed, 18 May 2022 20:27:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238068AbiERSZF (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 18 May 2022 14:25:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54208 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234057AbiERSZE (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 18 May 2022 14:25:04 -0400
Received: from mail-io1-xd2c.google.com (mail-io1-xd2c.google.com [IPv6:2607:f8b0:4864:20::d2c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1680C18C04C
        for <io-uring@vger.kernel.org>; Wed, 18 May 2022 11:25:03 -0700 (PDT)
Received: by mail-io1-xd2c.google.com with SMTP id h85so3191952iof.12
        for <io-uring@vger.kernel.org>; Wed, 18 May 2022 11:25:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :references:from:in-reply-to:content-transfer-encoding;
        bh=91e+Ezv8Krvjqm9jw5qxhEL6TqEnewgRnyeoD8PlkXs=;
        b=f3abBIfaHc0Sx598Ufzv7almqJ4M9NLF9m0mFm997h76fA07QvJWiDP34jYk19rkYY
         HFoI0yWwWUXYcjQyPPDHYYMcws3gttNDHSkQqt7LVNey/5g5L6HvqshP2IGTvZjyqbjK
         JQNKdRKSxqlXHfiYnbH7cFwuIAeUir6c/ZA26MU62ZWo7oSVyMNqFbz9YhXPfy0eZ3pp
         el1tkpAhkMhg7NGdTsccnqqz0ba70AxU3Z+wu5Q97VM6B7os33FMayKGmRiT5GtdpHUj
         /G7y0fKBrHlmS0WzLMTIQfVsAoJ2PPtIkw9Biks/aOmqtGTeWvxUhYPdkYPw0waHQLCn
         kXoQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:references:from:in-reply-to
         :content-transfer-encoding;
        bh=91e+Ezv8Krvjqm9jw5qxhEL6TqEnewgRnyeoD8PlkXs=;
        b=M1M1ytwXmLTlpa9PvgobP7nXySRSObrb8b5S5KFfo7tJ//w9fTEgW1TmHtDGyICwmz
         21zN9oTuqxhXGw/7PQ3vwCe6KFpHyDDGq7ZK3Z8oLEv2n8YVH6vRJpjGq/nlPDEqlb5G
         2ZQdh/wIfE9W5dhMu8nCsiZuJoR/ISgPurPIHCNiq0DvqR1w3fnV5QtrswO59oHfkpy4
         Cv+bKlxYBJMmApH/1u33sZSWtlJp1P7uaIgqse2M5EsqjVTXYA4ZvFm+CRoF7Ma4DqDr
         hm8GSyPdhAmdxR3gCJByaRY8J8l+dkzG8zjNxkvkHJSmcM0ImOtiBxiOlZW4k+zxb9D2
         Zv+w==
X-Gm-Message-State: AOAM5314Wvjfq6OcbGgS4OtQg0/3ANy472pM/apKLN9wzE6U5YZ+PaVS
        55gaqBBsoUBBpjd7cyYuzx6jEFkJ6v9tpQ==
X-Google-Smtp-Source: ABdhPJx7d8JKX32zN6fQh7nN/NtbOKqk1kl7arKPY2eXY8qnMZac3vCJfy6yI+zL0cYb1c9/97UjGg==
X-Received: by 2002:a05:6602:29ca:b0:649:558a:f003 with SMTP id z10-20020a05660229ca00b00649558af003mr486748ioq.160.1652898302229;
        Wed, 18 May 2022 11:25:02 -0700 (PDT)
Received: from [192.168.1.172] ([207.135.234.126])
        by smtp.gmail.com with ESMTPSA id c17-20020a6bfd11000000b0065afea99555sm61793ioi.24.2022.05.18.11.25.01
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 18 May 2022 11:25:01 -0700 (PDT)
Message-ID: <b4ca571b-c909-e4e3-62fd-e6af546d9c66@kernel.dk>
Date:   Wed, 18 May 2022 12:25:00 -0600
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux aarch64; rv:91.0) Gecko/20100101
 Thunderbird/91.8.1
Subject: Re: [PATCH for-next] io_uring: add fully sparse buffer registration
Content-Language: en-US
To:     Pavel Begunkov <asml.silence@gmail.com>, io-uring@vger.kernel.org
References: <66f429e4912fe39fb3318217ff33a2853d4544be.1652879898.git.asml.silence@gmail.com>
From:   Jens Axboe <axboe@kernel.dk>
In-Reply-To: <66f429e4912fe39fb3318217ff33a2853d4544be.1652879898.git.asml.silence@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 5/18/22 12:13 PM, Pavel Begunkov wrote:
> Honour IORING_RSRC_REGISTER_SPARSE not only for direct files but fixed
> buffers as well. It makes the rsrc API more consistent.

Was thinking about that as well when doing the file side, agree we
should do it. Thanks!

-- 
Jens Axboe

