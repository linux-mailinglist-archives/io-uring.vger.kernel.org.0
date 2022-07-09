Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 061F556CA56
	for <lists+io-uring@lfdr.de>; Sat,  9 Jul 2022 17:26:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229518AbiGIP0C (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sat, 9 Jul 2022 11:26:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57484 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229515AbiGIP0B (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sat, 9 Jul 2022 11:26:01 -0400
Received: from mail-pf1-x42b.google.com (mail-pf1-x42b.google.com [IPv6:2607:f8b0:4864:20::42b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 80E3013F00
        for <io-uring@vger.kernel.org>; Sat,  9 Jul 2022 08:26:00 -0700 (PDT)
Received: by mail-pf1-x42b.google.com with SMTP id l124so1387313pfl.8
        for <io-uring@vger.kernel.org>; Sat, 09 Jul 2022 08:26:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :references:from:in-reply-to:content-transfer-encoding;
        bh=EH00XfcvUH/9T0CVuCRZndt2y6QgL4aCuW/TcNVknLM=;
        b=puYkuFhGKG8+c3HPM8Pn+fz1p9j9PD19NimXMOBQwzvQtvlehfRJDbdSQlLgaBruYx
         3gpVN62TN3ViMtf52A2kupoEmCiRd7N07nNDxAryikMf95wkffHW6CwzwFIM/yiZahUr
         8si15Ytd7qzKteC3zx3EvXpgWj2fzYgdzV6JMIct1mhk21kb33L14+hHVNZ7n8uQ76TO
         OMDJMwmHTiYpL4HQr0Q1Iri+eCcs1Lnf8XIS50T3LllLEGUYxsTweYJwNE+QwsSBGDzA
         lhlwK4U7RFFdDq/JoDQsYLdsBmehj+Yu0K8FANl+xdcTfcaYBsHmRp3P7Sl6HxV1PNc8
         I73Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:references:from:in-reply-to
         :content-transfer-encoding;
        bh=EH00XfcvUH/9T0CVuCRZndt2y6QgL4aCuW/TcNVknLM=;
        b=aAyNlZTVAHT8oC2HWlb2B6q1qBKzTL5olXntliw6B9wreoyxhAR72VDJojWjHExtpS
         7tVmrivSca5Bnd6WmF0myEDpRCAZxiJ8Zl7SGTPQdNMStjoqSQEk/jJ4Pr3uBsdIgiYp
         6f7KRmse71QEXDmxLr+7QG0VJ2gzv76xDq6ihNEtL+wuVsfIaFMZxFede5WpnsMwm+Oi
         o+0eTPHy2mQD6VvCEGE9orqeeMB6yhCFo9qiU7O7Kr2N6AbiVlYyGeazOCbVIWVDIyrq
         zMOD5uM+vo09T38oz0q9BuonZGE17GALn+4Vf/1x9SGju3eDI08c56BB1xuNf2ninNka
         dWJg==
X-Gm-Message-State: AJIora/FxHlpm88OngPMDSP7NWTkr5LBc8CMaGrum4M4AAD41pEMSRHF
        2Zw6QoH4ycvyzt5AVvsxpCeLXA==
X-Google-Smtp-Source: AGRyM1vzWZ9nqLDo04LjoGkG4ZgBuwxuAPpQZnxoKYiprFVmI7bABbgvKYRJtOCXsja5UyoHPVvnsg==
X-Received: by 2002:a05:6a00:21c2:b0:4fa:914c:2c2b with SMTP id t2-20020a056a0021c200b004fa914c2c2bmr9745938pfj.56.1657380359909;
        Sat, 09 Jul 2022 08:25:59 -0700 (PDT)
Received: from [192.168.1.100] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id y9-20020aa79ae9000000b00528c8ed356dsm1645487pfp.96.2022.07.09.08.25.59
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 09 Jul 2022 08:25:59 -0700 (PDT)
Message-ID: <924ece92-caa8-390e-7040-1dd3eb8ad3cd@kernel.dk>
Date:   Sat, 9 Jul 2022 09:25:58 -0600
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux aarch64; rv:91.0) Gecko/20100101
 Thunderbird/91.10.0
Subject: Re: recvmsg not honoring O_NONBLOCK
Content-Language: en-US
To:     Hrvoje Zeba <zeba.hrvoje@gmail.com>, io-uring@vger.kernel.org
References: <CAEsUgYg5zx5Zk_wp9=YXf5Y+qPh9vx7adDN=B_rpa3zoh2YSew@mail.gmail.com>
From:   Jens Axboe <axboe@kernel.dk>
In-Reply-To: <CAEsUgYg5zx5Zk_wp9=YXf5Y+qPh9vx7adDN=B_rpa3zoh2YSew@mail.gmail.com>
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

On 7/9/22 8:21 AM, Hrvoje Zeba wrote:
> Hi folks,
> 
> I was adapting msquic library to work with iouring and found an issue
> with recvmsg() where it ignores O_NONBLOCK flag set on the file
> descriptor. If MSG_DONTWAIT is set in flags, it behaves as expected.
> I've attached a simple test which currently just hangs on iouring's
> recvmsg(). I'm guessing sendmsg() behaves the same way but I have no
> idea how to fill the buffer to reliably test it.

I am guessing that you're waiting off waiting for the event. It's not
stalled on the issue, it'll arm poll and wait for an event. I won't go
into too much of a ran on O_NONBLOCK, but it's a giant mess, and where
possible, io_uring relies on per-request non-block flags as that is much
saner behavior.

-- 
Jens Axboe

