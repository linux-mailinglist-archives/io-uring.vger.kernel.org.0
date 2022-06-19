Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A5076550ADE
	for <lists+io-uring@lfdr.de>; Sun, 19 Jun 2022 15:31:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235488AbiFSNbb (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sun, 19 Jun 2022 09:31:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60568 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234686AbiFSNb3 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sun, 19 Jun 2022 09:31:29 -0400
Received: from mail-pg1-x52b.google.com (mail-pg1-x52b.google.com [IPv6:2607:f8b0:4864:20::52b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E3AF3BC2A
        for <io-uring@vger.kernel.org>; Sun, 19 Jun 2022 06:31:28 -0700 (PDT)
Received: by mail-pg1-x52b.google.com with SMTP id q140so8021442pgq.6
        for <io-uring@vger.kernel.org>; Sun, 19 Jun 2022 06:31:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :references:from:in-reply-to:content-transfer-encoding;
        bh=ol1Hl2wpzuar3+LtirYAreOKRsiFLWdWo9UQO/vEGO8=;
        b=SNeYnWN2n8QJq85eqRztFnKfJcQE7ZDrAGVfkxEp1uxIFGR/tNcTjPWd6klTWBMu0b
         idnxRzecOYBLLaKzDBYKTnhnOibpAUVl/nGTCZ8Us2j7c7z9ZKFcNgBrR3hShcXMnHjs
         mOFIzo/dA9vFmYlUpFxnOvCuo2664v0sBSnJwCddpuwveo7qS+SaW4mG5XE52ni0ZgED
         xWX25r6l9EeE1l4EnxiYkzkVQmVeQ5Za007zHhZ6qCOdxq7RK/PDMo/+XafZccOzFP5J
         16q/5TqEpY5GOcL3Ou9PjaTCgSXguRgvJdvTgXoRuWaIAvX8OwRJq3WFHxgSdU4g3ua0
         avUQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:references:from:in-reply-to
         :content-transfer-encoding;
        bh=ol1Hl2wpzuar3+LtirYAreOKRsiFLWdWo9UQO/vEGO8=;
        b=RuqfGOxtx6msVrwNfXPDQwfBwPNnqNuKGLqkDX7KyF9NQd62WDScBmFfhfErmm/XZQ
         ozjvRN0TM0OlSYABBEWWzL6cVSfSIkQp9uXz4GaTFRgB5YjFQ7LflPz3AwgcsoxebtQL
         DTe9AB+B/ry0sX+sMwELb3+HmTvV55Z94uXQ1YScZQwtJrNOJHjMZJJJYK/GMcpVfm43
         2/83SxItJXG91yJx7HBS/jT4Efu3RN3Mf/INyl7Ug48AM1dCDruHYBT1EdpIU581ivd1
         hIocck7ExktKuZTbVH6wWOWv1g3AwlnHCAnujxnJ084ov0kBig8BYSBVQSOcRem+39Fk
         w1jA==
X-Gm-Message-State: AJIora9+GpjP0etPcIAqkhZRFGougyOBz1rNisZ5sA2mBtKT5P58x6qn
        aSQwojxcvtoJ8NF9ur4sU56YfdZxVbNbTA==
X-Google-Smtp-Source: AGRyM1ttIDlHyGeJ7n4Qg9ECOJh3/3N7/KcyFXXWUNAg+u0iJED+WOvJvEGm5b4EFK7+/FqKbuj2PA==
X-Received: by 2002:a63:e946:0:b0:401:b982:38a7 with SMTP id q6-20020a63e946000000b00401b98238a7mr17398214pgj.327.1655645488351;
        Sun, 19 Jun 2022 06:31:28 -0700 (PDT)
Received: from [192.168.1.100] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id o18-20020a629a12000000b0051bf246ca2bsm7028850pfe.100.2022.06.19.06.31.27
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 19 Jun 2022 06:31:27 -0700 (PDT)
Message-ID: <1f573b6b-916a-124c-efa1-55f7274d0044@kernel.dk>
Date:   Sun, 19 Jun 2022 07:31:26 -0600
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux aarch64; rv:91.0) Gecko/20100101
 Thunderbird/91.10.0
Subject: Re: [PATCH for-next 5/7] io_uring: remove ->flush_cqes optimisation
Content-Language: en-US
To:     Pavel Begunkov <asml.silence@gmail.com>, io-uring@vger.kernel.org
References: <cover.1655637157.git.asml.silence@gmail.com>
 <692e81eeddccc096f449a7960365fa7b4a18f8e6.1655637157.git.asml.silence@gmail.com>
From:   Jens Axboe <axboe@kernel.dk>
In-Reply-To: <692e81eeddccc096f449a7960365fa7b4a18f8e6.1655637157.git.asml.silence@gmail.com>
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

On 6/19/22 5:26 AM, Pavel Begunkov wrote:
> It's not clear how widely used IOSQE_CQE_SKIP_SUCCESS is, and how often
> ->flush_cqes flag prevents from completion being flushed. Sometimes it's
> high level of concurrency that enables it at least for one CQE, but
> sometimes it doesn't save much because nobody waiting on the CQ.
> 
> Remove ->flush_cqes flag and the optimisation, it should benefit the
> normal use case. Note, that there is no spurious eventfd problem with
> that as checks for spuriousness were incorporated into
> io_eventfd_signal().

Would be note to quantify, which should be pretty easy. Eg run a nop
workload, then run the same but with CQE_SKIP_SUCCESS set. That'd take
it to the extreme, and I do think it'd be nice to have an understanding
of how big the gap could potentially be.

With luck, it doesn't really matter. Always nice to kill stuff like
this, if it isn't that impactful.

-- 
Jens Axboe

