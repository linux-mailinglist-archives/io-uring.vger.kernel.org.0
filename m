Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5922D4C2033
	for <lists+io-uring@lfdr.de>; Thu, 24 Feb 2022 00:45:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244965AbiBWXpK (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 23 Feb 2022 18:45:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38650 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230499AbiBWXpJ (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 23 Feb 2022 18:45:09 -0500
Received: from mail-qv1-xf2b.google.com (mail-qv1-xf2b.google.com [IPv6:2607:f8b0:4864:20::f2b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 75D1259A57
        for <io-uring@vger.kernel.org>; Wed, 23 Feb 2022 15:44:40 -0800 (PST)
Received: by mail-qv1-xf2b.google.com with SMTP id j11so1051802qvy.0
        for <io-uring@vger.kernel.org>; Wed, 23 Feb 2022 15:44:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=JX2j6/CStgbXRu6oviI2PhBCShvC/e8sssqjH5A+Bec=;
        b=zoe4ht23DWg9xZHZLh5zB0Ve8xg2uxa7aDv6Gn/+6+UtwCtr+/RLw74M0g+g2HR7bV
         NuvzBxdPX8RKP/fHD6QQkEXYtdtmBQ1HUao0BJBVhmnEQKkwwxGYO0VJ2VHwV3LbH8tL
         Y1fLnJl/Cx1V5qnpaNhZzq4TyeEaQpuN2R/AYqPfj5OX01+Ekg1gjouodrlR9LjQMSgn
         SEyYoLpkJMor1oIPfInNhw32N01uQmfCuhj902QyU4i7VyVSmSV84OQt8V31oTCITmRR
         TwsbN9z7/JL7FqIkpVGFO7UAiMwIp/ORQLluzR9ujMDnuS0K/WyXvGMo69L7aXUSJDWl
         4H/Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=JX2j6/CStgbXRu6oviI2PhBCShvC/e8sssqjH5A+Bec=;
        b=hMkhBUBWUxQZTRIyg3WVUBKVnpnDxSanqVnLNRu+ALiQGDpfBvsu/3dPbIKQaZPddz
         YvjRpkL+p5nRcsiibzh99HzpTdjDBHhuYJ4SdIqbYJ7046XpUGiC7mRGlNhvEC1Y2uhR
         +I1DGLr75KHNVFojX5UvoeIkYkKEyLL/PUgAK19raeg2zhi3yZ7fKG+hi2l6gYGmJMGp
         NN1BosZXK71Mfyy+7WatJGj1Sl9jb0E4hYdrd/pblkqM9MLZVoGPufM0NIN3fm62aI/a
         ieogaE+KSZLAmt90cEpOIDBV2xDfcBKjOyNQ0hzkCRaeWJO3+Rb6U7Db7xdcX4UEcBd6
         V71Q==
X-Gm-Message-State: AOAM532EtkPkKGyLLwLOJL7g/pqYOKLwes6Msq7Fii/P7mUUEXPtatn/
        i3VYoUOjRR0hF7Wg2OHWxrrIGw==
X-Google-Smtp-Source: ABdhPJwfU8bLXtL+RVH1T46PgABMs5FSbhygxQDdk7xl5P6U+wkeT7LxW6TMR3YVyyFOen/ay1BuZg==
X-Received: by 2002:a05:6214:5190:b0:42b:fc43:bf63 with SMTP id kl16-20020a056214519000b0042bfc43bf63mr75841qvb.33.1645659879512;
        Wed, 23 Feb 2022 15:44:39 -0800 (PST)
Received: from [172.19.131.148] ([8.46.73.115])
        by smtp.gmail.com with ESMTPSA id i19sm487045qkl.89.2022.02.23.15.44.36
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 23 Feb 2022 15:44:39 -0800 (PST)
Message-ID: <ae62c67d-5720-9bb3-70eb-76e7dda496a3@kernel.dk>
Date:   Wed, 23 Feb 2022 16:44:32 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux aarch64; rv:91.0) Gecko/20100101
 Thunderbird/91.6.0
Subject: Re: [PATCH v3 liburing] Test consistent file position updates
Content-Language: en-US
To:     Dylan Yudaken <dylany@fb.com>,
        Pavel Begunkov <asml.silence@gmail.com>,
        io-uring@vger.kernel.org
Cc:     kernel-team@fb.com
References: <20220222105712.3342740-1-dylany@fb.com>
From:   Jens Axboe <axboe@kernel.dk>
In-Reply-To: <20220222105712.3342740-1-dylany@fb.com>
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

On 2/22/22 3:57 AM, Dylan Yudaken wrote:
> read(2)/write(2) and friends support sequential reads without giving an
> explicit offset. The result of these should leave the file with an
> incremented offset.
> 
> Add tests for both read and write to check that io_uring behaves
> consistently in these scenarios. Expect that if you queue many
> reads/writes, and set the IOSQE_IO_LINK flag, that they will behave
> similarly to calling read(2)/write(2) in sequence.
> 
> Set IOSQE_ASYNC as well in a set of tests. This exacerbates the problem by
> forcing work to happen in different threads to submission.
> 
> Also add tests for not setting IOSQE_IO_LINK, but allow the file offset to
> progress past the end of the file.

Applied, thanks.

-- 
Jens Axboe

