Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3B94C4ECE57
	for <lists+io-uring@lfdr.de>; Wed, 30 Mar 2022 23:06:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344739AbiC3Uth (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 30 Mar 2022 16:49:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54046 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1351102AbiC3Utg (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 30 Mar 2022 16:49:36 -0400
Received: from mail-il1-x12d.google.com (mail-il1-x12d.google.com [IPv6:2607:f8b0:4864:20::12d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7E78446B22
        for <io-uring@vger.kernel.org>; Wed, 30 Mar 2022 13:47:49 -0700 (PDT)
Received: by mail-il1-x12d.google.com with SMTP id x9so15369670ilc.3
        for <io-uring@vger.kernel.org>; Wed, 30 Mar 2022 13:47:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :references:from:in-reply-to:content-transfer-encoding;
        bh=sHxRB+WtrxvD15oXeoUMJaFA4YhKeWZi6TkdUgJMZE8=;
        b=I0PplgB6KQCqq2P3vCBdjn7JNQKQ8/HIb1nst71qIdVF+5O8/mWpxur3WJiCstfJ4r
         6PuQLaE/c2dHaK53FvbZQ1C3WgnDUv41KgOYIIGSSWBjurSFxjjOTNDFTrgGYaMwc81N
         Gt0XBoc62n8vcG7mMQCMNN/W8iWOkPCo1dIwU/7o4L4ycFiV2aUnpSFt3cBpnLLqH+Qb
         eJ2KEsxBOpwfbZ3l8v1myapiV9AdDqRrcDccu+7xBrauvQF+WzmJAUF/stP6aMcweb+P
         2+uoJy/NlrYJqC66UDDJMpZwJdO0oRbHYy+BeLneRD5Dp4ljuUsB5u7clB7pguFhNYWI
         GfeQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:references:from:in-reply-to
         :content-transfer-encoding;
        bh=sHxRB+WtrxvD15oXeoUMJaFA4YhKeWZi6TkdUgJMZE8=;
        b=329qbG+tV3+cgiW+JTmHrl4lIo1Dqrl3Fg5+f64KmNyXPfvaCScD3Qet8pPuU2g+jo
         1GFDiMMruTZSlUy/UD73Rr42EKjWP9LKnADQcvS4oHaGDsiz7ZgOpDKP7HOXh6hjIVVY
         LPplv8+KzZ/Nxg176Dz1iL9z9zLKVXwBx3lYHOWYl91N41CrIGrKkhXP9FKFVUbvFiTh
         BbpmTlL3ThyxMWoxXVYhdEBefEEolg6hpcXhFBa86Cr7caI/nA9s9+rPAmGr3Z1NPHYO
         YC0ULZNVlqQZqZ0eDelQ7/KcfzIG836QSZk+d4mCxPesxIhy/F++3uVl62kScmU2xPQ/
         29Wg==
X-Gm-Message-State: AOAM533gCqnkg+DoCdVITOoZRy8QFXRpDewvxRU5mDIzBHwCQyUMsjsV
        JLd2R3duSgfdRyVZQSRPIqhfNclboHVdfnEk
X-Google-Smtp-Source: ABdhPJw3GF4VQ36JOMKUkAcKmx/z4XSfXgNiTF5KtDVsegiaEUmqNBctuKcVHc4a6wgfuGbfAUmhpQ==
X-Received: by 2002:a05:6e02:1a66:b0:2c8:1f88:249a with SMTP id w6-20020a056e021a6600b002c81f88249amr11945133ilv.223.1648673268793;
        Wed, 30 Mar 2022 13:47:48 -0700 (PDT)
Received: from [192.168.1.172] ([207.135.234.126])
        by smtp.gmail.com with ESMTPSA id i12-20020a926d0c000000b002c9db5fdf66sm2542693ilc.15.2022.03.30.13.47.47
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 30 Mar 2022 13:47:48 -0700 (PDT)
Message-ID: <2634be17-2934-a30b-e7f0-498ae3283055@kernel.dk>
Date:   Wed, 30 Mar 2022 14:47:47 -0600
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux aarch64; rv:91.0) Gecko/20100101
 Thunderbird/91.7.0
Subject: Re: [PATCH v2 0/4] liburing: support xattr functions
Content-Language: en-US
To:     Stefan Roesch <shr@fb.com>, io-uring@vger.kernel.org,
        kernel-team@fb.com
References: <20220323154457.3303391-1-shr@fb.com>
From:   Jens Axboe <axboe@kernel.dk>
In-Reply-To: <20220323154457.3303391-1-shr@fb.com>
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

On 3/23/22 9:44 AM, Stefan Roesch wrote:
> Add xattr support and testing to liburing
> 
> Patch 1: liburing: update io_uring
>   Update io_uring.h with io_uring kernel changes.
> 
> Patch 2: liburing: add fsetxattr and setxattr
>   Add new helper functions for fsetxattr and setxattr support
>   in liburing.
> 
> Patch 3: liburing: add fgetxattr and getxattr
>   Add new helper functions for fgetxattr and getxattr support
>   in liburing.
> 
> Patch 4: liburing: add new tests for xattr
>   Adds a  new test program to test the xattr support.
> 
> There are also patches for io_uring and xfstests:
> - Adds xattr support for io_uring
> - Add xattr support to fsstress

Applied in the 'xattr' branch for now, I'll pull it into master
when:

a) The next liburing has been released, and
b) the xattr changes are upstream, targeted 5.19 merge window.

Thanks!

-- 
Jens Axboe

