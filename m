Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 49D6B559FA5
	for <lists+io-uring@lfdr.de>; Fri, 24 Jun 2022 19:26:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231669AbiFXRHC (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 24 Jun 2022 13:07:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58962 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231654AbiFXRHC (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 24 Jun 2022 13:07:02 -0400
Received: from mail-io1-xd2a.google.com (mail-io1-xd2a.google.com [IPv6:2607:f8b0:4864:20::d2a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7DC4C4B859
        for <io-uring@vger.kernel.org>; Fri, 24 Jun 2022 10:07:00 -0700 (PDT)
Received: by mail-io1-xd2a.google.com with SMTP id y18so3348664iof.2
        for <io-uring@vger.kernel.org>; Fri, 24 Jun 2022 10:07:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=dUss8s/u0VyYByqSYI3XMK/X65tFGczqYRrmRcWXBDo=;
        b=iDWYD7TPQTxuf6SnEcRfbFeJyKJZ5Vl7TLaxyG0TqkWSYO53LRNcktoMjT3oCf2Ag3
         Q4qSjNBPXcClPZM/NwSfJLPJw0uMU2g7Pde3ldPUH3uUex/dcyGdIwBLe3NJ00766SiT
         qt3PYy0WW31MQjffOntL/YojUumYiFZLCtTQosYmCgMQMmwkZ4LRV6/NYY6R44aKlziY
         UI2VfDtAZm3daKD2+uHUF5bm2I8PKGGvqyuW5Pmjvw/6YNxTCSA1DzOmlVjztiFW1Er0
         JFHkjY+jb+Of+TIS+f1JCK8MZ3BAIFBIXin/q2htwkzNo/JuB/oLLp2JT7HeMDq8FYfe
         lEUQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=dUss8s/u0VyYByqSYI3XMK/X65tFGczqYRrmRcWXBDo=;
        b=H+dVj4oCI44D1Lm8+KXS92cFE/ykxl5kx7tEoXspphfE2w77u6mIFUfD63htljXf0D
         f5xAauFuwyj42ZP+7EcIswM/gghq53XqzBG+F13FcF9xNVLHVV4KkmUn2UG93fT7lc+a
         2XXCyw6eTqe1EAO+STBhnimXnQbjOlNJszsrnm/G/UhWv9lw5VzfiZbosFN2yEhEnwBA
         0gko9lEKo962sGn8NFIKBrejy7cUb8aFfVP28KEnoXorG+FZm/EYEEOtbOwvlZmFSQ7r
         tbYI00zlVeAqoBd2aGt/Ezh7XrizNd/9P1oRyLQeKlpeVyaIsye/BAAoh1ZTPCXDYjra
         K52Q==
X-Gm-Message-State: AJIora+xeOaZS80F6VSjrRlIrVicyVicHtfXL+eNhmwoc+fAYtNZzuRE
        8trluLApdoJufRr2iJ+io2oCcA==
X-Google-Smtp-Source: AGRyM1sE/h8IHPb+WZwNKRTHDfzyfuMgDelfkJSdW7zngXW9PMig7penFSvoATSJaKRM43bEZgG6mw==
X-Received: by 2002:a5d:9345:0:b0:66c:d57a:d06 with SMTP id i5-20020a5d9345000000b0066cd57a0d06mr7749ioo.56.1656090419861;
        Fri, 24 Jun 2022 10:06:59 -0700 (PDT)
Received: from [192.168.1.172] ([207.135.234.126])
        by smtp.gmail.com with ESMTPSA id u10-20020a02b1ca000000b00339da678a7csm1277019jah.78.2022.06.24.10.06.58
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 24 Jun 2022 10:06:59 -0700 (PDT)
Message-ID: <d55bb851-0604-57d2-eefc-8bc53896c117@kernel.dk>
Date:   Fri, 24 Jun 2022 11:06:57 -0600
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux aarch64; rv:91.0) Gecko/20100101
 Thunderbird/91.10.0
Subject: Re: [RESEND PATCH v9 07/14] fs: Add check for async buffered writes
 to generic_write_checks
Content-Language: en-US
To:     Christoph Hellwig <hch@infradead.org>, Stefan Roesch <shr@fb.com>
Cc:     io-uring@vger.kernel.org, kernel-team@fb.com, linux-mm@kvack.org,
        linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        david@fromorbit.com, jack@suse.cz, willy@infradead.org,
        Christoph Hellwig <hch@lst.de>,
        Christian Brauner <brauner@kernel.org>
References: <20220623175157.1715274-1-shr@fb.com>
 <20220623175157.1715274-8-shr@fb.com> <YrVJvA+kOvjYJHqw@infradead.org>
From:   Jens Axboe <axboe@kernel.dk>
In-Reply-To: <YrVJvA+kOvjYJHqw@infradead.org>
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

On 6/23/22 11:21 PM, Christoph Hellwig wrote:
> FYI, I think a subject like
> 
> "fs: add a FMODE_BUF_WASYNC flags for f_mode"
> 
> might be a more descriptive.  As the new flag here really is the
> interesting part, not that we check it.

I made that edit.

-- 
Jens Axboe

