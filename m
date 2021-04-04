Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 16D69353975
	for <lists+io-uring@lfdr.de>; Sun,  4 Apr 2021 21:17:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231150AbhDDTRZ (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sun, 4 Apr 2021 15:17:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46952 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230119AbhDDTRY (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sun, 4 Apr 2021 15:17:24 -0400
Received: from mail-pl1-x62d.google.com (mail-pl1-x62d.google.com [IPv6:2607:f8b0:4864:20::62d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F010FC061756
        for <io-uring@vger.kernel.org>; Sun,  4 Apr 2021 12:17:19 -0700 (PDT)
Received: by mail-pl1-x62d.google.com with SMTP id z12so642370plb.9
        for <io-uring@vger.kernel.org>; Sun, 04 Apr 2021 12:17:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=MCEhSsmBJRD77c7ZtBNVDq+E43XBM4/ph05u1uSobYQ=;
        b=yylhxEmj5huMKcqRqQyc9t71cROHEYtPtcFJypdO/SfzAtoZezuO1CDhtFmA0/aBd0
         SomvOEh4zo3t+Kv8aW3WqenylUv1uvPyaws6FgeX9FL0oRz/MfMgmA1byb/CyF4Pc3pX
         N9qzQLTlmpM0yRPoJPk/n/V920nkN0yU9EQecZKxbdnQ9daz1QJp7KVmm1WtgVkge1ke
         SMDWta0XgziWM5hQ74AmunMT9RkK4/W7HvWkjStGQd9R/yg/UOaJ5LQGb66ZxEXjZ271
         VXIER2qV6TOeccPxLhwM4CWGE0fKrObeGa7mNQNO86yeEMKD+uv1nT5Qmj4Kji6tZ7ro
         e6zw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=MCEhSsmBJRD77c7ZtBNVDq+E43XBM4/ph05u1uSobYQ=;
        b=mUtbMLdvGPy97nGG4vbACAlqaLKG0lDAx1WvCGgcauzFxaVUvsJd72E4ZsGaPAIIob
         EzMxlutiSw8YX8ebPFl+PX7ImGoVDlFGHK/TlUMNBm4DYcA6we4bMaS17H8Cd22HC63q
         2JiwHnP1gIXYbSfQB2ECasLBFnfDzxOBLbcIYsDwWolmf58s5s2XxOd8EnXZKlZbWGHS
         Fr+cO4VCoFpCP+rdciR84+UFt8KFcODdyX4QSeH1gH/FV//FDL6AZnozoAP1PjVQ/bNp
         0CmWYBQOJ2mYjM6yE4rGvM94GQ98pqRjpg2fumepgMq6MPkzqKORNVEAOxy2jq9B2icq
         +ThA==
X-Gm-Message-State: AOAM531knAkV8eZrLcanhPv6NFYBC1hQZrCrDVEESCfnfU78iIuutiPX
        gE9flhWhuc0NiB2CsR2VOyfhc6fBr5NePw==
X-Google-Smtp-Source: ABdhPJw2eySu8VOS3gesgyLMGXMEY/rSQk/JfQu4RhrOR9UL0XZdtKH+n2lOTOnBxQ7iosLLPUuwFg==
X-Received: by 2002:a17:90a:d48b:: with SMTP id s11mr23301012pju.67.1617563838753;
        Sun, 04 Apr 2021 12:17:18 -0700 (PDT)
Received: from [192.168.1.134] ([66.219.217.173])
        by smtp.gmail.com with ESMTPSA id u25sm13674029pgk.34.2021.04.04.12.17.17
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 04 Apr 2021 12:17:18 -0700 (PDT)
Subject: Re: [PATCH] io-wq: simplify code in __io_worker_busy
To:     Pavel Begunkov <asml.silence@gmail.com>,
        Hao Xu <haoxu@linux.alibaba.com>
Cc:     io-uring@vger.kernel.org, Joseph Qi <joseph.qi@linux.alibaba.com>
References: <1617358729-36761-1-git-send-email-haoxu@linux.alibaba.com>
 <91175ea9-950a-868b-bddf-dfe4c0184225@gmail.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <7f078f30-d60f-2b19-7933-f1ccba8e7282@kernel.dk>
Date:   Sun, 4 Apr 2021 13:17:17 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <91175ea9-950a-868b-bddf-dfe4c0184225@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 4/2/21 4:38 AM, Pavel Begunkov wrote:
> On 02/04/2021 11:18, Hao Xu wrote:
>> leverage xor to simplify code in __io_worker_busy
> 
> I don't like hard-coded ^1 because if indexes change it may break.
> One option is to leave it to the compiler:
> 
> idx = bound : WQ_BOUND ? WQ_UNBOUND;
> compl_idx = bound : WQ_UNBOUND ? WQ_BOUND;
> 
> Or add a BUILD_BUG_ON() checking that WQ_BOUND and WQ_UNBOUND
> are mod 2 complementary.

Was going to suggest just that, just add a BUILD_BUG_ON() to catch
any changes there. The code is way cleaner with the XOR trick.

Hao, can you resend with that?

-- 
Jens Axboe

