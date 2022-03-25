Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1FE874E7398
	for <lists+io-uring@lfdr.de>; Fri, 25 Mar 2022 13:35:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350213AbiCYMh1 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 25 Mar 2022 08:37:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51024 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239734AbiCYMh1 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 25 Mar 2022 08:37:27 -0400
Received: from mail-pf1-x433.google.com (mail-pf1-x433.google.com [IPv6:2607:f8b0:4864:20::433])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0448D21804
        for <io-uring@vger.kernel.org>; Fri, 25 Mar 2022 05:35:54 -0700 (PDT)
Received: by mail-pf1-x433.google.com with SMTP id y10so3011439pfa.7
        for <io-uring@vger.kernel.org>; Fri, 25 Mar 2022 05:35:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :references:from:in-reply-to:content-transfer-encoding;
        bh=tUig/d0zeaBZ8zFx4sXbe+TqL7yxJNlhIpgACFnv/OE=;
        b=ClUOI2mrdSdvKp5G2slR1aoyTDNvDBgyq2ArNAngV2AjfdpL4yylxIzBSZlURBuEDb
         /aHFYhbgDEaJdG90Oh98N3ex6Q1X4/zdcXTCQHXloeuYVLnzp1o2af8NWYpnuab5vR4W
         kOJ+chdfuWWZmeyI8VvsKfCeiAIh7N6AWeSgiD/LZswV9Jx35aUDyafPSLNzrIyhhWOu
         ST45UBHk0GNNsQY1PtKjKdT+/InkFutm4lkJXj1CJDWHXkMyuMa4QWgCfmcSmqHhmL+L
         ljvN1dPyaLWAIM7p4l4rpYlmKTkYsxsKPWHYf2868YtZKR9Qqql5afH2FIId+OX9I17H
         rMWQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:references:from:in-reply-to
         :content-transfer-encoding;
        bh=tUig/d0zeaBZ8zFx4sXbe+TqL7yxJNlhIpgACFnv/OE=;
        b=KL9TC+mP1fuDXVq+m46E2SOMCmPaNiVqHq0cbGoq8wusf9Xg7vYdVIARYJEtESb3dq
         7Krsy88a0UsmGKdS/K+wj6Z9Yag4pvj56adI5d/6Ln3qtjugNrU/fnnbnNq6MDTmE+SW
         0qBW/K7liYXXmOrXl3VZ+PJvIo8Rdb+rA/ReWi6M6p5na7VD7Z62OuQ13/qAK8fLBPT3
         Rqj91KfFJWBxUYvOgk7ruJQ0LhuMvV45llw0eALhKC9Jt4tL3WybprVOz7323X9HodUK
         mUv3aCptgH4Mk5H6eM73NpkqpBhpVvnSXjs8wW3QvnuSiQbos2UZGm7UYlFZbpbCS7x6
         ZV4A==
X-Gm-Message-State: AOAM530rvCbOuRLeCJCnqLbR5luHWdSPYEbD4uURRhdVPh4p9zG/BiNC
        x/KgW29smuoUmNqpddDfSD/1KxXfHuZOXtGM
X-Google-Smtp-Source: ABdhPJyMAtPfGH5iu085bL+8vKdHkI5vDDOVPZ9AIf8R5hDDJeTeX+CPIzxV8QhIyuWX7xVqW7+w8A==
X-Received: by 2002:a63:334c:0:b0:386:291f:3435 with SMTP id z73-20020a63334c000000b00386291f3435mr7704146pgz.264.1648211753501;
        Fri, 25 Mar 2022 05:35:53 -0700 (PDT)
Received: from [192.168.1.100] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id k13-20020aa7820d000000b004fa72a52040sm6663654pfi.172.2022.03.25.05.35.52
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 25 Mar 2022 05:35:53 -0700 (PDT)
Message-ID: <494268a9-63a2-e9f7-7bee-12dc3f44b9d9@kernel.dk>
Date:   Fri, 25 Mar 2022 06:35:52 -0600
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux aarch64; rv:91.0) Gecko/20100101
 Thunderbird/91.7.0
Subject: Re: [PATCH 3/5] io_uring: silence io_for_each_link() warning
Content-Language: en-US
To:     Pavel Begunkov <asml.silence@gmail.com>, io-uring@vger.kernel.org
References: <cover.1648209006.git.asml.silence@gmail.com>
 <f0de77b0b0f8309554ba6fba34327b7813bcc3ff.1648209006.git.asml.silence@gmail.com>
From:   Jens Axboe <axboe@kernel.dk>
In-Reply-To: <f0de77b0b0f8309554ba6fba34327b7813bcc3ff.1648209006.git.asml.silence@gmail.com>
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

On 3/25/22 5:52 AM, Pavel Begunkov wrote:
> Some tooling keep complaining about self assignment in
> io_for_each_link(), the code is correct but still let's workaround it.

Honestly, it's worth it to avoid having to reply about reports on
this. So thanks for doing that.

-- 
Jens Axboe

