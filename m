Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AC98C5F4522
	for <lists+io-uring@lfdr.de>; Tue,  4 Oct 2022 16:07:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229445AbiJDOHD (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 4 Oct 2022 10:07:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47272 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229530AbiJDOHC (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 4 Oct 2022 10:07:02 -0400
Received: from mail-il1-x130.google.com (mail-il1-x130.google.com [IPv6:2607:f8b0:4864:20::130])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CE5742B621
        for <io-uring@vger.kernel.org>; Tue,  4 Oct 2022 07:07:00 -0700 (PDT)
Received: by mail-il1-x130.google.com with SMTP id u10so5025534ilm.5
        for <io-uring@vger.kernel.org>; Tue, 04 Oct 2022 07:07:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date;
        bh=p7Q82Ogq2xPg4acUPUahYN0JbViii+RELCYpkPeC9jE=;
        b=yBgSQpIX7cQ6hBHbax02T/j2z640YYWeqwqhkYs3OjQKDN6eGxPkfX75S8dVSYnD9c
         ym24uy79rQTKFq4KLcLeYeh/lfeS6wCg+d5MQHqmSH31YYLiwhBjO8SRAahSUdO4onnI
         6sWS2Zv0Ic5QWA+b0qSlvU+2f14y4ZfFUVw05rUgVxtAsRQwejhHAjw+DXQxK+OP5iMD
         OrzIvCA7jhE+zXcVuz8CWr86p+BSLVBykezyFmkzkAQN1OlfbbEjRuPg31+5zUmWSsLP
         Qu7tRoJb4shlpMnsncl9GVYI2J52vCoRFLyamaNdkt0mS1NPwNRH/toekBSrQ+wlD46X
         arlQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date;
        bh=p7Q82Ogq2xPg4acUPUahYN0JbViii+RELCYpkPeC9jE=;
        b=11334lMnUraRZnkKCjK13nirIqDreffo59ML9u9OUVu8Rj4vu5SkHrekjH8+R8MysG
         CifDaTxp3Bw375DQXU6dpN08nhHugom7SGvoceLdAfwBtpz7yH5KvgYbvEp4Q36nKYzc
         /lzr9KjcLMidJy4vZImhBm2JvKlyeyC+/hvmWFm3R0GmmSVBiPWOZjwJ9xUwYGsdHLdu
         kaTCbVnr5IO6ch7VOOlWQmZuN0+Umolp3vWPpwpxGnN/RxE3zIcjuUdRKBDg1NIKg+t7
         ROuVxFuwGMRvonO0LHxm/HlaAdGwN7G3tbQTe8xA4tjz9JcGtosYXN5yHltUhq1wYjpK
         ofNw==
X-Gm-Message-State: ACrzQf3G0LRQJ+7TWvHt/25KY9xOrls+MCWKxkQVmoaUpkVAyB6JYh8v
        EH6Yeo0rcerMfFvIof3cJPI0PA==
X-Google-Smtp-Source: AMsMyM4ANRazDqOQe3xQ3sT/KDLWplHBAO38i3wNHZfDVn0bHoq93tczpiGj/hXsPj98ziQEBX9WIw==
X-Received: by 2002:a05:6e02:158a:b0:2d3:f1c0:6b68 with SMTP id m10-20020a056e02158a00b002d3f1c06b68mr12355952ilu.38.1664892420229;
        Tue, 04 Oct 2022 07:07:00 -0700 (PDT)
Received: from [192.168.1.94] ([207.135.234.126])
        by smtp.gmail.com with ESMTPSA id l28-20020a02665c000000b00356744215f6sm5276128jaf.47.2022.10.04.07.06.59
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 04 Oct 2022 07:06:59 -0700 (PDT)
Message-ID: <79fd16a6-2585-2c68-5212-bf523ac02dd1@kernel.dk>
Date:   Tue, 4 Oct 2022 08:06:58 -0600
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux aarch64; rv:102.0) Gecko/20100101
 Thunderbird/102.3.0
Subject: Re: [PATCH -next] io_uring: Add missing inline to
 io_uring_cmd_import_fixed() dummy
Content-Language: en-US
To:     Geert Uytterhoeven <geert+renesas@glider.be>,
        Pavel Begunkov <asml.silence@gmail.com>,
        Anuj Gupta <anuj20.g@samsung.com>,
        Kanchan Joshi <joshi.k@samsung.com>
Cc:     io-uring@vger.kernel.org, linux-kernel@vger.kernel.org
References: <7404b4a696f64e33e5ef3c5bd3754d4f26d13e50.1664887093.git.geert+renesas@glider.be>
From:   Jens Axboe <axboe@kernel.dk>
In-Reply-To: <7404b4a696f64e33e5ef3c5bd3754d4f26d13e50.1664887093.git.geert+renesas@glider.be>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.3 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 10/4/22 6:39 AM, Geert Uytterhoeven wrote:
> If CONFIG_IO_URING is not set:
> 
>     include/linux/io_uring.h:65:12: error: ‘io_uring_cmd_import_fixed’ defined but not used [-Werror=unused-function]
>        65 | static int io_uring_cmd_import_fixed(u64 ubuf, unsigned long len, int rw,
> 	  |            ^~~~~~~~~~~~~~~~~~~~~~~~~
> 
> Fix this by adding the missing "inline" keyword.

Thanks Geert, I'll get this added.

-- 
Jens Axboe


