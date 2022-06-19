Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 99925550AA6
	for <lists+io-uring@lfdr.de>; Sun, 19 Jun 2022 14:45:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235344AbiFSMhH (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sun, 19 Jun 2022 08:37:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33992 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229472AbiFSMhH (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sun, 19 Jun 2022 08:37:07 -0400
Received: from mail-wr1-x42e.google.com (mail-wr1-x42e.google.com [IPv6:2a00:1450:4864:20::42e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2E0D362DF
        for <io-uring@vger.kernel.org>; Sun, 19 Jun 2022 05:37:06 -0700 (PDT)
Received: by mail-wr1-x42e.google.com with SMTP id s1so11200867wra.9
        for <io-uring@vger.kernel.org>; Sun, 19 Jun 2022 05:37:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=GgOPHfIBFLBZolWbamXHzF0MK9l+e1WVJbT4mUUGZt8=;
        b=g0hHpR6Ymx+6R+JTNSqq/qMj7oYxw0ZHNZEiyUYBRpYvLwrxAtm6hZUB87U2xYUW65
         ZwzwyDBXw0JaqfrJrmf6bIZBtMl9R+88xra88H2mPlu/cRuI4WJvY/kD6s971pcVnT2/
         FFtkSUH6fMSNFxNGMyX4iFCYouHLsRCR6TMboL6AYBehEU/I0FKqd7US8riKRacyTrd9
         jshAqC8PB51GOn2aQWlGgahNw7DbsGmveoRgoJXCNfkk88DQ/LqbGr5dzHmOCnNYhSqe
         y0X9PdSjJ8+diJ04iYm7QawoMi8D60l8mfcUW/YBzO1Q7IHZM3fseHGLvme2RvIWHDn+
         vgkA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=GgOPHfIBFLBZolWbamXHzF0MK9l+e1WVJbT4mUUGZt8=;
        b=nPmwgAKuS+hQFN4ESL16bMqRGKY8KjojJe3dsxu22nVxF0ojRM4hLfqCyvrefwqVuv
         hi6KJCzkyTKA51ocRALoPmTMS500n8xgrf2Lk/hBrlaTDXzm4njTcHAW+1yC5LM4VaDG
         N08XS/VeiSoyuKPZoei294lfrLPRrNU9xqh9MepUg1Z6De7+TNoX6cgKMCX/AlDqGjFV
         k1KNaGN4RUlgfkWAZ2rW1P0prIgi43LfcXckJOqDnoNUTp7GcsCsawVPYhD4WC+Uz9Aw
         eLdQ2XyZjLYrfb07kDr8r62TxUNC+T+qIAbDTdTYJNcjX5zG2Ve1VGRwv4V3jHtLmwo/
         z6Ew==
X-Gm-Message-State: AJIora8wuh/a4G1/AxEOX/uFCnuec3F0RvcVOeS0OdoVcvUKonPz5OEz
        pS0MiNI9aiV+19VG9ZVCGidmIkpW9cBvIw==
X-Google-Smtp-Source: AGRyM1uCrJbszlLLceKK8VJ2z/1/n8b2oAdrZtRh9e8JBEdYZpueysVie5KOvaNXGMprG4yXneutgg==
X-Received: by 2002:a5d:6488:0:b0:203:b628:70d2 with SMTP id o8-20020a5d6488000000b00203b62870d2mr18221837wri.83.1655642223789;
        Sun, 19 Jun 2022 05:37:03 -0700 (PDT)
Received: from [192.168.8.198] (188.28.125.106.threembb.co.uk. [188.28.125.106])
        by smtp.gmail.com with ESMTPSA id s6-20020a1cf206000000b0039c975aa553sm11746182wmc.25.2022.06.19.05.37.03
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 19 Jun 2022 05:37:03 -0700 (PDT)
Message-ID: <e24d6be9-d097-8c4d-3306-5bdf84012395@gmail.com>
Date:   Sun, 19 Jun 2022 13:36:41 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.9.1
Subject: Re: [PATCH for-next 0/7] cqe posting cleanups
Content-Language: en-US
To:     io-uring@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>
References: <cover.1655637157.git.asml.silence@gmail.com>
From:   Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <cover.1655637157.git.asml.silence@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 6/19/22 12:26, Pavel Begunkov wrote:
> Apart from this patches removing some implicit assumptions, which we
> had problems with before, and making code cleaner, they and especially
> 6-7 are also needed to push for synchronisation optimisations later, lile
> [1] or removing spinlocking with SINGLE_ISSUER.
> 
> The downside is that we add additional lock/unlock into eventfd path,
> but I don't think we care about it.

just in case there conflicts, it's based on top of

"[PATCH for-next 0/4] simple cleanups" from yesterday


> 
> The series also exposes a minor issue with cancellations, which for some
> reason calls io_kill_timeouts() and io_poll_remove_all() too many times on
> task exit. That makes poll-cancel to timeout on sigalarm, though usually
> is fine if given 3-5 sec instead of 1. We'll investigate it later.
> 
> [1] https://github.com/isilence/linux/commit/6224f58bf7b542e6aed1eed44ee6bd5b5f706437
> 
> Pavel Begunkov (7):
>    io_uring: remove extra io_commit_cqring()
>    io_uring: reshuffle io_uring/io_uring.h
>    io_uring: move io_eventfd_signal()
>    io_uring: hide eventfd assumptions in evenfd paths
>    io_uring: remove ->flush_cqes optimisation
>    io_uring: introduce locking helpers for CQE posting
>    io_uring: add io_commit_cqring_flush()
> 
>   include/linux/io_uring_types.h |   2 +
>   io_uring/io_uring.c            | 144 ++++++++++++++++-----------------
>   io_uring/io_uring.h            | 108 ++++++++++++++-----------
>   io_uring/rw.c                  |   5 +-
>   io_uring/timeout.c             |   7 +-
>   5 files changed, 133 insertions(+), 133 deletions(-)
> 

-- 
Pavel Begunkov
