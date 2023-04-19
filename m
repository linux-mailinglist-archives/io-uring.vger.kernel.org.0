Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BC3746E70D0
	for <lists+io-uring@lfdr.de>; Wed, 19 Apr 2023 03:43:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230248AbjDSBn5 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 18 Apr 2023 21:43:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37838 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230153AbjDSBn4 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 18 Apr 2023 21:43:56 -0400
Received: from mail-pf1-x431.google.com (mail-pf1-x431.google.com [IPv6:2607:f8b0:4864:20::431])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1E6D47AB9
        for <io-uring@vger.kernel.org>; Tue, 18 Apr 2023 18:43:55 -0700 (PDT)
Received: by mail-pf1-x431.google.com with SMTP id d2e1a72fcca58-63b781c9787so1097099b3a.1
        for <io-uring@vger.kernel.org>; Tue, 18 Apr 2023 18:43:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20221208.gappssmtp.com; s=20221208; t=1681868634; x=1684460634;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=MWht8lTfoer/xYCMSNeFDPoGf5xNZpBt/8TrHTgAuP0=;
        b=ExWBKn7N2Q66K97km29e/f7fbkWXgx698YH6YbzlKIlYABNxVAm4RwXwlqUqe5EBzZ
         1LPq35m+ri0DkdQcw67wxnq00WZ3DSEgS/lpC2GveNP2lXXv7qeYoKC2F512rsE2J6b+
         2h85Wqn9W7o/7BEIBQI+i4AgjOEvts5iTl5woNpsk4Lmd+iX0xtyvsqKdKL0p/Yhn/CI
         P63utl/5m+JxfJZAuKG5kk/S8AVoc7uX2+oTgdqdQfcWmUjUj+fdgycm35KB1R+mQUgx
         9NvrKpyEnpUhBVe+cJi3s7a99dIn7oDTrIdge1Q/3wSQYjRSuZvR8jcNiSg/bZluy48z
         ARWQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1681868634; x=1684460634;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=MWht8lTfoer/xYCMSNeFDPoGf5xNZpBt/8TrHTgAuP0=;
        b=ipfUrrs36Ka7KUND2T0E7kOWMX5bZ8Z2gzPX0nvx5ckhQEq2FfdsPLDI6uyTOf/ATU
         0zmCa14tOXVvDA96aAq4hjsAkZ1JBH23c7eIQ/0+lEwgTZfy8hFaI/r9O6/ZcrHzQxZD
         0HWCiySYvHnpXpQpjpIoizGhfyiHIGP4M9whxGXfz9vcptlJBQoIBoOJ4irS5/rYvqwV
         PVouGV+Arr2XM8dGU92AcXADmPkbTBhrf8CZ+ZN0qSv/4FHiT4nNeKkGc/CxkHydWwKz
         sp+IQ+ngrqXTYUBGROBiLnSwopPuDAiaI6drPBeg0vuRLOcG2IdXuRDCTbOBfeVExDnu
         Z+qA==
X-Gm-Message-State: AAQBX9ehEuz38SM7yZMR62eRBKB30nvDOrIMpsb6zQFbJXG6w365YujH
        Zevm/tOnL5990io852Q7brqyPQ==
X-Google-Smtp-Source: AKy350YR3SwSPCMiHACMz3Djl+ePBNiU85Tpissy0Ir2PRR59gf5s5lcQy8H+EjL+nXZ4t09MmT7ww==
X-Received: by 2002:a05:6a00:3489:b0:638:abf4:d49c with SMTP id cp9-20020a056a00348900b00638abf4d49cmr18124611pfb.3.1681868634500;
        Tue, 18 Apr 2023 18:43:54 -0700 (PDT)
Received: from [192.168.1.136] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id c6-20020aa78c06000000b0063b7c42a072sm6528038pfd.13.2023.04.18.18.43.53
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 18 Apr 2023 18:43:54 -0700 (PDT)
Message-ID: <57046550-32ab-7b37-2ae9-50495061d6d0@kernel.dk>
Date:   Tue, 18 Apr 2023 19:43:53 -0600
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux aarch64; rv:102.0) Gecko/20100101
 Thunderbird/102.9.0
Subject: Re: [PATCH v3 0/2] liburing: multishot timeout support
Content-Language: en-US
To:     David Wei <davidhwei@meta.com>,
        Pavel Begunkov <asml.silence@gmail.com>
Cc:     io-uring@vger.kernel.org
References: <20230414225506.4108955-1-davidhwei@meta.com>
From:   Jens Axboe <axboe@kernel.dk>
In-Reply-To: <20230414225506.4108955-1-davidhwei@meta.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.5 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 4/14/23 4:55?PM, David Wei wrote:
> Changes on the liburing side to support multishot timeouts.
> 
> Changes since v2:
> 
> * Edited man page for io_uring_prep_timeout.3
> 
> David Wei (2):
>   liburing: add multishot timeout support
>   liburing: update man page for multishot timeouts
> 
>  man/io_uring_prep_timeout.3     |   7 +
>  src/include/liburing/io_uring.h |   1 +
>  test/timeout.c                  | 263 ++++++++++++++++++++++++++++++++
>  3 files changed, 271 insertions(+)

I applied this, but there's an issue in that the tests don't just skip
if the kernel doesn't support multishot. Tests for liburing need to
accept that the feature isn't available on older kernels. Generally this
is done by the first test setting 'no_timeout_mshot = true' or something
like that, and then subsequent ones just returning T_SETUP_SKIP if
no_timeout_mshot == true and whatever calls the test not failing if
T_SETUP_SKIP is returned.

Would be great if you could send a followup patch against the current
liburing -git that does that. Thanks!

-- 
Jens Axboe

