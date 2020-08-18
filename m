Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B120E248BCD
	for <lists+io-uring@lfdr.de>; Tue, 18 Aug 2020 18:42:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726806AbgHRQmZ (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 18 Aug 2020 12:42:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44730 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726721AbgHRQmW (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 18 Aug 2020 12:42:22 -0400
Received: from mail-pl1-x634.google.com (mail-pl1-x634.google.com [IPv6:2607:f8b0:4864:20::634])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 81AF3C061389
        for <io-uring@vger.kernel.org>; Tue, 18 Aug 2020 09:42:22 -0700 (PDT)
Received: by mail-pl1-x634.google.com with SMTP id bh1so9463284plb.12
        for <io-uring@vger.kernel.org>; Tue, 18 Aug 2020 09:42:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=jwDiGVsm+D4sTPvo7BwI/U+2xiBy0UHOPd3WZFDXMoA=;
        b=HDC8JxZJokWZogTYBmRnUn1Cz05XHvvF9x+rUsVrw0yimX7LuCoWVTQ3JK3xnA29TN
         BPdw4/zrgZw12eMEyDnPvM0Wd5wdxzMS14ofeYyEriqhFZZa/wm2RnVgA5X/hMfT44v7
         Xwy7j62qO+MtZmJoErNQfWeOAP2o9rNifhgXiE5323VMShaJTAVoHmBdB2I8NqqLFRsk
         p0YrrpIRvnAE8YUtK3Q/2FIs0olSSYHA+syn1ZKStkTE+kqkc6QiIMiSvimjyyibUXCA
         6rdZwED5mTipBMYhoRnhCPsI+3FB2CSIvfq2IHKxRNF/qo4YPP2r4ZbyhTwMJYlK6Z/+
         juoQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=jwDiGVsm+D4sTPvo7BwI/U+2xiBy0UHOPd3WZFDXMoA=;
        b=aAEjXcQPyG/SENBq8Sj/rTq/xwnShsHOiV51Uk0XjE7AxWJIc2z7us1odQwZHkrw37
         zNbvtd7skXTWXZHYqlOhndtXjhoFTBNRinwR8VVaQ+GMfgLZfxCBmpsjeygzTkrzuoZ8
         68Jj3RgIpZqz+x2gvwwQ/xgNvYHxr4XFKwO7DtWXlRG9/VAGqFUYvGW88xQbvgj+MpUk
         YOMwSpX3LgKBrc5L8k4ZVLPaVUmhxrQZDR7aLb8FUkZdANGH91+Ncsb8W3ooD4bfInEl
         tcwBeb2QZRVGO3mw8G0rvfgdytcqgGTpcZtgZWHhLkfez/F3707OoX9FLuxbp32QlfWY
         w7dw==
X-Gm-Message-State: AOAM531pNBj5biuwdTWwIhRc7MbgbX662LgwlyXtyQyQc87na1DwrOub
        1Nf/WwNj96+tWzHPhzzCh3dWKJfBw+0BBIU9
X-Google-Smtp-Source: ABdhPJywCyYj6/SxFQwJayus5bQ50Hpc/U0TRarak9YRZwkRut5jXaGfJ4RyQN4zkdBU0xbPgrXn6g==
X-Received: by 2002:a17:90a:ce94:: with SMTP id g20mr621133pju.61.1597768939651;
        Tue, 18 Aug 2020 09:42:19 -0700 (PDT)
Received: from ?IPv6:2605:e000:100e:8c61:9214:36a5:5cec:a06d? ([2605:e000:100e:8c61:9214:36a5:5cec:a06d])
        by smtp.gmail.com with ESMTPSA id s17sm15312878pgm.63.2020.08.18.09.42.18
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 18 Aug 2020 09:42:19 -0700 (PDT)
Subject: Re: Very low write throughput on file opened with O_SYNC/O_DSYNC
To:     Dmitry Shulyak <yashulyak@gmail.com>
Cc:     io-uring@vger.kernel.org
References: <CAF-ewDrOHDxpSAm8Or37m-k5K4u+b3H2YwnA-KpkFuVa+1vBOw@mail.gmail.com>
 <477c2759-19c1-1cb8-af4c-33f87f7393d7@kernel.dk>
 <CAF-ewDp5i0MmY8Xw6XZDZZTJu_12EH9BuAFC59pEdhhp57c0dQ@mail.gmail.com>
 <004a0e61-80a5-cba1-0894-1331686fcd1a@kernel.dk>
 <CAF-ewDqANgn-F=9bQiXZtLyPXOs2Dwi-CHS=80hXpiZYGrJjgg@mail.gmail.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <af9ffef1-fe53-e4d5-069b-8cfba31273c2@kernel.dk>
Date:   Tue, 18 Aug 2020 09:42:17 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <CAF-ewDqANgn-F=9bQiXZtLyPXOs2Dwi-CHS=80hXpiZYGrJjgg@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 8/18/20 9:09 AM, Dmitry Shulyak wrote:
> it worked, but there are some issues.
> with o_dsync and even moderate submission rate threads are stuck in
> some cpu task (99.9% cpu consumption), and make very slow progress.
> have you expected it? it must be something specific to uring, i can't
> reproduce this condition by writing from 2048 threads.

Do you have a reproducer I can run? Curious what that CPU spin is,
that obviously shouldn't happen.

-- 
Jens Axboe

