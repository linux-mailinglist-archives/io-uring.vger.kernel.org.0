Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 308EA4280CF
	for <lists+io-uring@lfdr.de>; Sun, 10 Oct 2021 13:25:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231705AbhJJL1h (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sun, 10 Oct 2021 07:27:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50504 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231482AbhJJL1h (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sun, 10 Oct 2021 07:27:37 -0400
Received: from mail-il1-x12e.google.com (mail-il1-x12e.google.com [IPv6:2607:f8b0:4864:20::12e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 024E0C061764
        for <io-uring@vger.kernel.org>; Sun, 10 Oct 2021 04:25:39 -0700 (PDT)
Received: by mail-il1-x12e.google.com with SMTP id j8so3192788ila.11
        for <io-uring@vger.kernel.org>; Sun, 10 Oct 2021 04:25:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=xcewtthj9iZgbrbldSmA9MOyUwjVVkJAx2OpI4mMS3I=;
        b=AdTwwk55+MkeeSOu/RrXj+kGdmEcCYyBtuUr6VXDLJ2r7HYIKV0nHL1ybyQw7ccq7X
         EpzS23a0RNRUS7/u0ZX/rymy80BLInSuVPmmkFBLXIqfrldWYdtfyVMbnnZX9l35i4Y+
         ntdBAdfDiOwVjsDXJj9F58+HIbmuRYssZMEXNvIzcH34S04hxxlv92iN67WDvJeDwmOm
         KtZiu2Z42wObjiTBUztqTCMkSP+Mtr4ijfBOcxCiF2W7n8GSFMxkQdsMY1cmR0iKfFT3
         CDwBnUW5xwbnjc5vKlrNTaANxMwIdTvA17PENrqX/dp5b77zeIqS55uDTdQ7Ep/Yx3/u
         ZLmA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=xcewtthj9iZgbrbldSmA9MOyUwjVVkJAx2OpI4mMS3I=;
        b=UPtKR6ekKiUathf+hDqjQDf/USdk1TEuxOusDnU34OuCw0vGhHTxif6j4eYWC9ejYy
         3MyvNo+3j4PUl5i35qQDuQOadU7UobOuApUASUpy3HLXLvIVZ2ZVuWancjIHgbB2mRvK
         q6wKkXnb76ZsalYY3JO8nqtYVu7juj2herv/Mk9hDDIVtXUn60DvLtTUhTQClMzeePGV
         j2xRnr62vYvuPFz0/WS3pIAg4Yqe8Cc+S7jijNBNLXztjP4dLWbiQ4/Ws6Jk/Z78WELt
         qTfBmoHu/AllShlA8BBmuIRVMksJQdiSn+GQ9pVbxcjBesKAHil+HgcJ/fcBeo6rTfqs
         C6DQ==
X-Gm-Message-State: AOAM531VF8iLPDEfhCC+8HBayFpApygRRXEbmB8eOVgKP0OU63vVRuWS
        +sdPx7CcK4uhXkShue0Tq1SIWA==
X-Google-Smtp-Source: ABdhPJwpkdWSpL5fnvNy3EXq5rZmy+qj3dhmIEMct7DTAF4xY18NV9ENxpx4jkKKdNCa/Toe7z6QGg==
X-Received: by 2002:a05:6e02:12a3:: with SMTP id f3mr12878557ilr.54.1633865138421;
        Sun, 10 Oct 2021 04:25:38 -0700 (PDT)
Received: from [192.168.1.116] ([66.219.217.159])
        by smtp.gmail.com with ESMTPSA id b15sm2459624ion.8.2021.10.10.04.25.37
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 10 Oct 2021 04:25:37 -0700 (PDT)
Subject: Re: [PATCH v2 liburing 1/4] test/thread-exit: Fix use after free bug
To:     Ammar Faizi <ammar.faizi@students.amikom.ac.id>,
        Pavel Begunkov <asml.silence@gmail.com>,
        io-uring Mailing List <io-uring@vger.kernel.org>
Cc:     Bedirhan KURT <windowz414@gnuweeb.org>,
        Louvian Lyndal <louvianlyndal@gmail.com>
References: <20211010063906.341014-1-ammar.faizi@students.amikom.ac.id>
 <20211010063906.341014-2-ammar.faizi@students.amikom.ac.id>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <910f4f52-5959-53bb-d7f3-8141b28dd5d4@kernel.dk>
Date:   Sun, 10 Oct 2021 05:25:35 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20211010063906.341014-2-ammar.faizi@students.amikom.ac.id>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 10/10/21 12:39 AM, Ammar Faizi wrote:
> When I add support for nolibc x86-64, I find this test failed.
> 
> Long story short, we provide our own `free()` that always unmaps the VM
> with `munmap()`. It makes the CQE return -EFAULT because the kernel
> reads unmapped user memory from the pending `write()` SQE.
> 
> I believe this test can run properly with libc build because `free()`
> from libc doesn't always unmap the memory, instead it uses free list on
> the userspace and the freed heap may still be userspace addressable.
> 
> Fix this by deferring the free.

Applied, thanks.

-- 
Jens Axboe

