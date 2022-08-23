Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8780A59E81B
	for <lists+io-uring@lfdr.de>; Tue, 23 Aug 2022 18:56:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245455AbiHWQyq (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 23 Aug 2022 12:54:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53792 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245501AbiHWQyd (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 23 Aug 2022 12:54:33 -0400
Received: from mail-pg1-x533.google.com (mail-pg1-x533.google.com [IPv6:2607:f8b0:4864:20::533])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 429921365EB
        for <io-uring@vger.kernel.org>; Tue, 23 Aug 2022 06:23:30 -0700 (PDT)
Received: by mail-pg1-x533.google.com with SMTP id r22so12264789pgm.5
        for <io-uring@vger.kernel.org>; Tue, 23 Aug 2022 06:23:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc;
        bh=dsnQjm2aeQSPHxgMCEVQhHLhdbZVZgzIFBIMZn/yc4g=;
        b=zLOIG4kzUo02wThJ1sFTDaJUaKIjo7Zl2wfZhGz1UjLMeoqBlkPo7FeyrdyC3i3j1X
         KUt7J4cNBAdmjYwzmoni6OTa3lw9yWBRNmjknYYH+2/6KvGtqxO0N3xPoJLyH16wtI7H
         jt49qWGH/mISIPw+p8+4mIuG90FrXEljShY6ksQEDrjRod9+WV5Eo7LAsyj/Af37t4fw
         hzpBTQ3JtLEtDyIyeHQknuaP2EFNAjRQlSdCaIhGLyQu9UawqznQhB1okeT4p67CegZO
         0fEkmkmRTIiLboqwrZQ4zAvdOtwBQ5w/fTMZNcVqYOChcKtKrmMfOaE3OlgSw1zwaPwW
         NDGQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc;
        bh=dsnQjm2aeQSPHxgMCEVQhHLhdbZVZgzIFBIMZn/yc4g=;
        b=qpqTE+eSpf/BSGFBtxcudtB//vZP/Fj0jAUvvfLgd75Wpps+8GOQeohLb6JbSvXDHy
         ekZpCePyZebqrmxOHbJPpSBVQvHHw+Jr8eTWtbQuAFtLyP4o58zrn0evN/uKIYsS892V
         rwdiXHC1LMM3wW/Avo2PDMv/46ts+FVtzIL73HEE6rDf1tOQ7//Z7AQWxeXjBqAJ1jQ4
         4ptb0KfrY8JzN2OeR66+ik8a27Jg2p0W9hI2TGMIDd6J7rRoNgv+po9S5Tj8F8kUUvTH
         B2CgRsA9/rvH/dGTMdt3Er5rPXglcNuXK2CRzWJfSdaaIVIakot30XaHhWyB6YcBydQZ
         R10g==
X-Gm-Message-State: ACgBeo1U0bIuLExIMKp4+LKzfTfb6R9uuAfL4bwpQVpqmVuyGQed0U6r
        FBoK+jk7FmVxRl8x4mWQOnlosw==
X-Google-Smtp-Source: AA6agR78DUrQxEFL3FYUsKmK9NA09YKVQiuX98syAqM7Sveh0Pk2FWDokPiB4SdGsO3SoqLVmgpWBg==
X-Received: by 2002:a63:1c06:0:b0:423:317a:1e03 with SMTP id c6-20020a631c06000000b00423317a1e03mr20991438pgc.438.1661261009624;
        Tue, 23 Aug 2022 06:23:29 -0700 (PDT)
Received: from [192.168.1.136] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id z62-20020a623341000000b005360dc9c45csm8616771pfz.43.2022.08.23.06.23.27
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 23 Aug 2022 06:23:27 -0700 (PDT)
Message-ID: <f67b6e7d-0f06-692e-30ee-b4ce68b7efcb@kernel.dk>
Date:   Tue, 23 Aug 2022 07:23:26 -0600
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux aarch64; rv:102.0) Gecko/20100101
 Thunderbird/102.1.2
Subject: Re: [PATCH 0/2] Maintainer and uapi header update
To:     Ammar Faizi <ammarfaizi2@gnuweeb.org>
Cc:     io-uring Mailing List <io-uring@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        GNU/Weeb Mailing List <gwml@vger.gnuweeb.org>,
        Bart Van Assche <bvanassche@acm.org>,
        Dylan Yudaken <dylany@fb.com>,
        Facebook Kernel Team <kernel-team@fb.com>,
        Kanna Scarlet <knscarlet@gnuweeb.org>
References: <20220823114337.2858669-1-ammar.faizi@intel.com>
Content-Language: en-US
From:   Jens Axboe <axboe@kernel.dk>
In-Reply-To: <20220823114337.2858669-1-ammar.faizi@intel.com>
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

On 8/23/22 5:45 AM, Ammar Faizi wrote:
> From: Ammar Faizi <ammarfaizi2@gnuweeb.org>
> 
> Hi Jens,
> 
> There are two patches in this series.
> 
> 1) MAINTAINERS: Add `include/linux/io_uring_types.h`.
> 
> File include/linux/io_uring_types.h doesn't have a maintainer, add it
> to the io_uring section.
> 
> 2) io_uring: uapi: Add `extern "C"` in io_uring.h for liburing.

Applied, thanks.

-- 
Jens Axboe


