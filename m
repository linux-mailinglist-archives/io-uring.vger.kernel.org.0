Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 35ABD606098
	for <lists+io-uring@lfdr.de>; Thu, 20 Oct 2022 14:50:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230262AbiJTMul (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 20 Oct 2022 08:50:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59708 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230259AbiJTMuk (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 20 Oct 2022 08:50:40 -0400
Received: from mail-pl1-x62d.google.com (mail-pl1-x62d.google.com [IPv6:2607:f8b0:4864:20::62d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 07F4418952E
        for <io-uring@vger.kernel.org>; Thu, 20 Oct 2022 05:50:39 -0700 (PDT)
Received: by mail-pl1-x62d.google.com with SMTP id u6so2698079plq.12
        for <io-uring@vger.kernel.org>; Thu, 20 Oct 2022 05:50:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=3T6X+tt7V+91kobXX12t6/xBrHgsUusEkXMw0L2QMKo=;
        b=V1e+eumcTbSiXyjph0yA3r/AC6Jy3E7VdU0fC5UdvN3Jjv5eHkX+KRzb3g/5Snd3ZB
         TO3UwH0dGpPsF3IU1lCS+drZ84tqXau9dHvtNPhV2RLawCrjLIQ8PR4P5KZqR87/eJqb
         SE0VT26rx6WgMpUXzQiyNswQClOxqQojw78L07iPRMxPxe3bOhmP16OZQ6rbU0gwzOxU
         KnGQSw+KJJBW8s1zOep5CjR4Fmsir+FCzi9T8L9Okp56p7CnC33SIIoZB1zuZMOvWIPD
         RMXguy9y9Ej7zdSAjXnm6we46Y+87YtUPtndgbrZl3Bjtl/wMhRUbj0BQhxgNuJ6Dgcp
         Y9Lw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=3T6X+tt7V+91kobXX12t6/xBrHgsUusEkXMw0L2QMKo=;
        b=8BCPrFUAoCMW3LjMXTPf2TL+HjDpq8FPiKuX1pgB9jMtWmlRBQDZfra2uWqqx0l+mq
         pHSkH/eS6MG5XLrMuDaPArIEkZ3Ce7tPlWPhOVV8UYcog2RFWSoe0uuyuQGZ4QNqiayp
         8GeliQ+8a4PE22IhsYgWf76tZ5oPZ1lwRH0w0+8ePeh5ejnFZVhOHoeFXqb6rTirqLM+
         QRZpE9aIRdWlggtkPimKNnAymogW7QdP+cSl0md5EY+XgHRmrOOTxMMs6XDuASUxD8G5
         N8AN+Adr/FP28+3eJ8jvtmL/GseWqB6Z4KiIXG0p2qyc7PVIMH96weZWTp9FzzwHXz0v
         SCKw==
X-Gm-Message-State: ACrzQf2VHk/exleknpX4a7y0brdndcjVUkwI6lY3hrND/j8apvvIlymz
        2tYAX6JgnM0xBeUO5oL+Cz/JBw==
X-Google-Smtp-Source: AMsMyM4TRzgWshHzykwjj+0oSUfvvDKlhXsmbl0EEBW/4qsIASSjpO/zYNZVz/MgLoZQ1OlX/n7zyA==
X-Received: by 2002:a17:90b:2243:b0:20b:42a:4c0d with SMTP id hk3-20020a17090b224300b0020b042a4c0dmr49870333pjb.123.1666270238215;
        Thu, 20 Oct 2022 05:50:38 -0700 (PDT)
Received: from [127.0.0.1] (cpe-72-132-29-68.dc.res.rr.com. [72.132.29.68])
        by smtp.gmail.com with ESMTPSA id d8-20020a170902cec800b0017f7b6e970esm12885047plg.146.2022.10.20.05.50.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 20 Oct 2022 05:50:37 -0700 (PDT)
From:   Jens Axboe <axboe@kernel.dk>
To:     linux-block@vger.kernel.org,
        Pavel Begunkov <asml.silence@gmail.com>
Cc:     io-uring@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-fsdevel@vger.kernel.org
In-Reply-To: <cover.1666122465.git.asml.silence@gmail.com>
References: <cover.1666122465.git.asml.silence@gmail.com>
Subject: Re: (subset) [RFC for-next v2 0/4] enable pcpu bio caching for IRQ I/O
Message-Id: <166627023722.161997.8160242378689353670.b4-ty@kernel.dk>
Date:   Thu, 20 Oct 2022 05:50:37 -0700
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Mailer: b4 0.11.0-dev-d9ed3
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Tue, 18 Oct 2022 20:50:54 +0100, Pavel Begunkov wrote:
> This series implements bio pcpu caching for normal / IRQ-driven I/O
> extending REQ_ALLOC_CACHE currently limited to iopoll. The allocation side
> still only works from non-irq context, which is the reason it's not enabled
> by default, but turning it on for other users (e.g. filesystems) is
> as a matter of passing a flag.
> 
> t/io_uring with an Optane SSD setup showed +7% for batches of 32 requests
> and +4.3% for batches of 8.
> 
> [...]

Applied, thanks!

[1/4] bio: safeguard REQ_ALLOC_CACHE bio put
      commit: d4347d50407daea6237872281ece64c4bdf1ec99

Best regards,
-- 
Jens Axboe


