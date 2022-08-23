Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4EC7659EA39
	for <lists+io-uring@lfdr.de>; Tue, 23 Aug 2022 19:51:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230091AbiHWRuE (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 23 Aug 2022 13:50:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47980 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231201AbiHWRs7 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 23 Aug 2022 13:48:59 -0400
Received: from mail-io1-xd33.google.com (mail-io1-xd33.google.com [IPv6:2607:f8b0:4864:20::d33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7780CABF01
        for <io-uring@vger.kernel.org>; Tue, 23 Aug 2022 08:47:57 -0700 (PDT)
Received: by mail-io1-xd33.google.com with SMTP id q81so3612447iod.9
        for <io-uring@vger.kernel.org>; Tue, 23 Aug 2022 08:47:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc;
        bh=2nx/vBH9mHgTdaJ+Vk5Te/8EVtC3eVg9d8e3DcsPrKw=;
        b=CK87JdQI8HOpZAt+zBCUSmXPMJrV2UEwL7bFoQwkFF9kJs1Pjf4ZAvUUG6xAz1eZ79
         I1MIrIuZsf1zY9yt4HZJ0rL3tzpOz+fXpOP/h9HOZK2wrtV7f1EHqMKJiGfNJDGqrR0y
         w7fF140KkZeA/FihnnogFcmT9KmrAqln2xjcfzjXH0p8HhuhMk79boOmLEMINu9AqQXL
         kJ1cXcG+9/In63r5CSTuyKxNENBz4x0BgSMHSSH7YgKymZ1hWo9slwkKNDIRMNmfWF/C
         CpppPWpnz3IKnzm4sGSVcnC22otDcMivSL9UZOtjtqQQlr+GOTlIfibNRYAeHlGgmMbR
         AnSQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc;
        bh=2nx/vBH9mHgTdaJ+Vk5Te/8EVtC3eVg9d8e3DcsPrKw=;
        b=S29LcrYy3UkuYuu1DDJSDprf7hSFy9Y//oFBTYlnBvRSkphv1JKQaxCu5DCXSNwXro
         /pOloVgWfx/ShQng5aY2VyN8FOOHhKkakghfHtNSsZiSFPzTi2UjeWyp/TR0Bi9V61kZ
         JZd++Mk1urzmZyCZPzV8jyF1uCQ8Mk64Pf3Vic7g2VwCZKyjtbhF/C+EOGnrctlTh3wM
         58udUynpS5P+54Xa785NeaXZS4YdHGXskhA2f0W+zjNSre8SV+tGN5bkgjqCYg/qPYSp
         qy34qFe3wawkS9DCzYP/xgc560EE558BfXyVprZRaGhS1EsWqMGGBpdi5llynEcll7lg
         yvgQ==
X-Gm-Message-State: ACgBeo3zUOjbDkPqih1Q/Xe9treCkVKDvK0gM6XoczuUkGFQ4O/ABcy+
        4rbK7jun2viBws3Dk5F4QE/00fdbDYObOA==
X-Google-Smtp-Source: AA6agR7MDCRksP2F9yER+cFiBsoa838vjtpLYsEArbbSU6rPaAp/e4LnsKB2mQeJ0vtsaQ7rYxbM6Q==
X-Received: by 2002:a02:a711:0:b0:349:db96:7708 with SMTP id k17-20020a02a711000000b00349db967708mr5048042jam.36.1661269676796;
        Tue, 23 Aug 2022 08:47:56 -0700 (PDT)
Received: from [192.168.1.94] ([207.135.234.126])
        by smtp.gmail.com with ESMTPSA id s15-20020a92cc0f000000b002dde208f0c6sm18182ilp.67.2022.08.23.08.47.53
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 23 Aug 2022 08:47:54 -0700 (PDT)
Message-ID: <fa8bde9c-290b-521d-f5c3-a764adc6a8f2@kernel.dk>
Date:   Tue, 23 Aug 2022 09:47:53 -0600
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux aarch64; rv:102.0) Gecko/20100101
 Thunderbird/102.1.2
Subject: Re: [PATCH liburing] test/io_uring_passthrough: add test case for
 submission failure
Content-Language: en-US
To:     Kanchan Joshi <joshi.k@samsung.com>
Cc:     io-uring@vger.kernel.org, ankit.kumar@samsung.com,
        anuj20.g@samsung.com
References: <CGME20220823153811epcas5p3e9262beb5b6dc0ae58f4bcf7486473de@epcas5p3.samsung.com>
 <20220823152725.5211-1-joshi.k@samsung.com>
From:   Jens Axboe <axboe@kernel.dk>
In-Reply-To: <20220823152725.5211-1-joshi.k@samsung.com>
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

On 8/23/22 9:27 AM, Kanchan Joshi wrote:
> Increase the coverage by adding a test which triggers submission-failure
> from nvme side.
> Issue an ill-formed passthrough command by populating invalid nsid
> value. If cqe->res is zero, report failure of the test.

Applied, thanks.

-- 
Jens Axboe


