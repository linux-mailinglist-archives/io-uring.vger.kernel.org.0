Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A8D8C6C70EE
	for <lists+io-uring@lfdr.de>; Thu, 23 Mar 2023 20:19:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229484AbjCWTTH (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 23 Mar 2023 15:19:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42848 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229518AbjCWTTH (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 23 Mar 2023 15:19:07 -0400
Received: from mail-il1-x136.google.com (mail-il1-x136.google.com [IPv6:2607:f8b0:4864:20::136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2CCFA8A56
        for <io-uring@vger.kernel.org>; Thu, 23 Mar 2023 12:19:06 -0700 (PDT)
Received: by mail-il1-x136.google.com with SMTP id j6so12111220ilr.7
        for <io-uring@vger.kernel.org>; Thu, 23 Mar 2023 12:19:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112; t=1679599145; x=1682191145;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=oraFreUcmD6M5OJ61rmKzWT/Kdiaf+qkDdb01wQm1lE=;
        b=YsdvIuje3Qb2bThVk2wg2+EoY8gnU2Ye4+nQqD/V8idQ+jSquYK+/FmKXK8znzS6VT
         Nm+aMIYaKKc1AxoOHRMl836Xk220qfLIJ+I0oF1RNuKKAaeYc9d79uGstDcZumb92Iji
         QNuA07i4Wz9fuCzqB4PgsrRN4dCq1FbHNgoJD9KRHToBZqyPNZ/BX5Izpx1pfgN8Ffmt
         sxwTgpf+VMVOGa9jkFlQ0kDgoCaPk5OFXdiqg09/ODmmfyrBgNLSM3rv/V2Rs7l/Ces9
         3X1JahXkfetEBZhUxuK4npCKqcvp2TIpsOFpqVKOdOGsMw1Eq6YFyk4cLIgaJAEmRBEe
         wxLg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679599145; x=1682191145;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=oraFreUcmD6M5OJ61rmKzWT/Kdiaf+qkDdb01wQm1lE=;
        b=Qa+CUz3VsM8Niqbx555gABlKttI160CSv3DNMfcPGZuT5UFSiTgwpT1OE4obuvScuM
         f86kI9dYJlcvmFGWAt+k2Lhb41ILsVdSWdVxnIdQArzH7OQuNriKFh8l8sj6/T2hkAMH
         VI0wnGBbJckxiy0NwPvYm7k3laufHg1AWiDd+netq3G2qhUftZq9DParacd8fjpF63Hu
         N5vackELMKF94cHGaDdHHZWp5Ku6Od7qyu3mULi86pGjWrFkWT3j9QJr+ZKvzFSlL8Ka
         L+OkMFt3EkKgdfiPbuC2njyTAJnTeMigtsgPgDudUt13sChN5QSuUj97Qtlvo3hTRHMw
         /rgQ==
X-Gm-Message-State: AAQBX9ebS0/bHNiucpKY6xk7CrYbunvNfXx9EvYyixW/dAW7eSxY20KW
        iotpFsMWeOkpUtua8Fg+QtDNI33AA9Js6uOcCZEmAQ==
X-Google-Smtp-Source: AKy350bl6Dihi5HdLYFo8TCSZWrW+8f5gmoVxps+pnbF7hy4/ZVMJTXIQ6JB8+qEUz8EtcmgocQAQQ==
X-Received: by 2002:a05:6e02:2207:b0:313:fb1b:2f86 with SMTP id j7-20020a056e02220700b00313fb1b2f86mr546465ilf.0.1679599145400;
        Thu, 23 Mar 2023 12:19:05 -0700 (PDT)
Received: from [192.168.1.94] ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id c13-20020a928e0d000000b003157b2c504bsm5322979ild.24.2023.03.23.12.19.04
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 23 Mar 2023 12:19:04 -0700 (PDT)
Message-ID: <4f119ce6-2ae9-6a7c-4c88-aee2445d6265@kernel.dk>
Date:   Thu, 23 Mar 2023 13:19:04 -0600
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux aarch64; rv:102.0) Gecko/20100101
 Thunderbird/102.9.0
Subject: Re: [PATCH 0/2] io-wq: cleanup io_wq and io_wqe
Content-Language: en-US
To:     Gabriel Krisman Bertazi <krisman@suse.de>
Cc:     io-uring@vger.kernel.org
References: <20230322011628.23359-1-krisman@suse.de>
From:   Jens Axboe <axboe@kernel.dk>
In-Reply-To: <20230322011628.23359-1-krisman@suse.de>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-0.0 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 3/21/23 7:16?PM, Gabriel Krisman Bertazi wrote:
> Hi Jens,
> 
> This tides up the io-wq internal interface by dropping the io_wqe/io_wq
> separation, which no longer makes sense since commit
> 0654b05e7e65 ("io_uring: One wqe per wq").  We currently have a single
> io_wqe instance per io_wq, which is embedded in the structure.  This
> patchset merges the two, dropping bit of code to go from one to the
> other in the io-wq implementation.
> 
> I don't expect it to have any positive impact on performance, of course,
> since hopefully the compiler optimizes it, but still, it is nice clean
> up.  To be sure, I measured with some mmtests microbenchmarks and I haven't
> seen differences with or without the patchset.
> 
> Patch 2 is slightly big to review but the use of wq and wqe is
> intrinsically connected; it was a bit hard to break it in more pieces.
> 
> Tested by running liburing's testsuite and mmtests performance
> microbenchmarks (which uses fio).
> 
> Based on your for-next branch.

Nice! This is a great continuation of getting rid of the per-node worker
setup.

-- 
Jens Axboe

