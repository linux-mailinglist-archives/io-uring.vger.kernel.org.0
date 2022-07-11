Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7673B570C3A
	for <lists+io-uring@lfdr.de>; Mon, 11 Jul 2022 22:56:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229844AbiGKU4F (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 11 Jul 2022 16:56:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46722 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231817AbiGKU4E (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 11 Jul 2022 16:56:04 -0400
Received: from mail-pg1-x52e.google.com (mail-pg1-x52e.google.com [IPv6:2607:f8b0:4864:20::52e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 097266D2DF
        for <io-uring@vger.kernel.org>; Mon, 11 Jul 2022 13:56:02 -0700 (PDT)
Received: by mail-pg1-x52e.google.com with SMTP id 72so5822076pge.0
        for <io-uring@vger.kernel.org>; Mon, 11 Jul 2022 13:56:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=RvgUjRHlL9vPG4qE59ynjNoBnSliGoJHCEzOpBtigRI=;
        b=3HwffMMeFi40aKorP3JIarWYuPbBLlFoFYIIl6ofNA78u2eKIRCcCcJRCXu2HOu9Yq
         oTbMa/LsIpsNx2Oblyhljf6SjBes2TAq+X7mjbRSruQRRl0i/FRh9EJVe08StmJrP+Hu
         kC30YCostMwBEwh63wIotD4zmqvdx77Ws3wvrz7COYBgF0HaDy575uqBUTiEFAXT8fHo
         iNQI08DhRzRwfWXjXAmhHi4Jy5LTR0duR3NQnY2Z+Z4HO6sxZACx9wMfYSCn/raWYlk8
         YhVSyZD0THhdB7Si/Dgpd8HF+X49eEOaLHKcFCLK5iUp8BG8JcBkb78Mkkwrcsk2y/aY
         4dSA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=RvgUjRHlL9vPG4qE59ynjNoBnSliGoJHCEzOpBtigRI=;
        b=FOJKAaGLbQaC+DdPfBbzCRKQU8w3uAfgDCSu3mX1tf6eSbkrN5oMltUe9v1FFWjtN+
         wfFhoVx6HgPb+A1Xo5gYhw9lbtw+b+/Tog8GmqK23ks/GrtgcqjZVvRv2gFeRgn8J3Q7
         Pf8ktp0hn57XWmAE8jRawebXnPT4NM/m6utwxcI8zVuKCvclld0LC4i6/3ABvTBIwa5h
         EqPkiRyC0j9Txv+UKm9Dv1g9hV7WG80YiEW+Y647P4wGaGzVFpqqLXZ8BALj53a+hZJf
         fxeToanGuWcMMpePQkbGCRX4OFrkpp9fSczdLN5uLmAOR1TXoLiOOzQB8WxJvXEclASQ
         Su8w==
X-Gm-Message-State: AJIora/jUste2+Jb5YEYKOvCkxlPrrrgWAMMvfgMKjaxL4PnIfM+ePJk
        0QA/MPE3WF3JUt5nB+6inY7sJg==
X-Google-Smtp-Source: AGRyM1uftf7+mAtxfSAQiEzfTMX67pZN2YyvvZVoq2TlqRElejy8lYyQgKmM464k1EavLCCx8byhYg==
X-Received: by 2002:a05:6a00:22c3:b0:525:628f:a835 with SMTP id f3-20020a056a0022c300b00525628fa835mr20336427pfj.58.1657572961387;
        Mon, 11 Jul 2022 13:56:01 -0700 (PDT)
Received: from [192.168.1.100] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id mr2-20020a17090b238200b001ef8912f763sm5231457pjb.7.2022.07.11.13.56.00
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 11 Jul 2022 13:56:00 -0700 (PDT)
Message-ID: <e973e70e-0802-0358-95da-8998cdd29281@kernel.dk>
Date:   Mon, 11 Jul 2022 14:55:59 -0600
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux aarch64; rv:91.0) Gecko/20100101
 Thunderbird/91.10.0
Subject: Re: [PATCH for-next 0/4] io_uring: multishot recv cleanups
Content-Language: en-US
To:     Dylan Yudaken <dylany@fb.com>,
        Pavel Begunkov <asml.silence@gmail.com>,
        io-uring@vger.kernel.org
Cc:     Kernel-team@fb.com
References: <20220708181838.1495428-1-dylany@fb.com>
From:   Jens Axboe <axboe@kernel.dk>
In-Reply-To: <20220708181838.1495428-1-dylany@fb.com>
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

On 7/8/22 12:18 PM, Dylan Yudaken wrote:
> These are some preparatory cleanups that are separate but required for a
> later series doing multishot recvmsg (will post this shortly).
> 
> Patches:
> 1: fixes a bug where a socket may receive data before polling
> 2: makes a similar change to compat logic for providing no iovs
> for buffer_select
> 3/4: move the recycling logic into the io_uring main framework which makes
> it a bit easier for recvmsg multishot

Applied 1-2, because I don't think the cleanup is necessarily correct. Do
we always hold ctx->uring_lock for io_clean_op()? I can see two ways
in there - one we definitely do, but from the __io_req_complete_put() or
io_free_req() path that doesn't seem to be the case. Hmm?

-- 
Jens Axboe

