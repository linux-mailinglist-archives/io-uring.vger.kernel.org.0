Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8552920C854
	for <lists+io-uring@lfdr.de>; Sun, 28 Jun 2020 16:09:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726397AbgF1OJM (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sun, 28 Jun 2020 10:09:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56636 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726344AbgF1OJM (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sun, 28 Jun 2020 10:09:12 -0400
Received: from mail-pf1-x444.google.com (mail-pf1-x444.google.com [IPv6:2607:f8b0:4864:20::444])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 15B27C061794
        for <io-uring@vger.kernel.org>; Sun, 28 Jun 2020 07:09:12 -0700 (PDT)
Received: by mail-pf1-x444.google.com with SMTP id j1so6780246pfe.4
        for <io-uring@vger.kernel.org>; Sun, 28 Jun 2020 07:09:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:references:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=LRn87f6TB5vFE32sU3uEqHgnkyvupmbRH33WqnbJq8Q=;
        b=hxkz/jWrx3QUXRYakC2kBjwpr7DwPiCQKuWmMEG5Z7MSAlsDm9bP7M7L9DQQ3SJ3On
         p3mf6NEM3bkkZCTGFqB2GIwuzRV7wv34v9x7YXzzWC3rv5xMf+JaFDozeqSD5PsKzQBv
         6u21XgTnObVr956Jz/9p2deZKsgPT9iC2U/rZS0ecVehuvOUMYyCGLn0eruk089NYAE7
         JMfZfhqJbywT2D5m6jHiQjTC0jDJ0L2TB1oUwRtKjBg1F3Q6yKQoJ11wW3OdtvY1ldDY
         k1BjLyeHnsPbcHlaolQ8MDp92Fc/cdR4/aPezVB0x/pn88wTjpw2IVX+zRajm/IzTFCw
         RT3w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=LRn87f6TB5vFE32sU3uEqHgnkyvupmbRH33WqnbJq8Q=;
        b=MDtoLcG0n6Y44oRTz/TE8q7QUG72M+DkAwF0WaVyAuGYLwAvyAMDlb+M4wLKHlvJPu
         NNI06dYnvF82eA8vHgMzT2alTSAWKnMR3FjE44kj4zN0bbYZPVXjCXk2+J0LbdDvPb0k
         XuArnk1Wb37e+lDmi1VwhnjbZag8yHV/GARpNcp0OHkFQ7pnUC00weC1KAPL91zHPn2E
         5Su6ptY0Q9nd0XO/W7HZ7oqHDbMuZBFraUNjGNSx1pYJEOs6qnjLM6dcO/FzN/LavYfP
         eL3xRVH+L7WwSqsfxnQZlrR/vxtyvM8nJ0XKGPnrz5nMjF26zi6V0QytQsI3ceI8xFX3
         q3dA==
X-Gm-Message-State: AOAM5316367nQPesrkUOjntavCW91u/FmI7BPAZWp/gf94KY7Oghr3KH
        gR+SxlXd27/srt6XP5G0o7F+nMOe4T72gw==
X-Google-Smtp-Source: ABdhPJwmp93LDn3AKW2GoaUgC98TV4MLKqdFQhg87bRM53dLTZMNaN/wLQODPnhapJ9JIJDyEfn+wQ==
X-Received: by 2002:a62:fc4c:: with SMTP id e73mr5942827pfh.308.1593353350970;
        Sun, 28 Jun 2020 07:09:10 -0700 (PDT)
Received: from [192.168.86.197] (cpe-75-85-219-51.dc.res.rr.com. [75.85.219.51])
        by smtp.gmail.com with ESMTPSA id i14sm16543310pju.24.2020.06.28.07.09.10
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 28 Jun 2020 07:09:10 -0700 (PDT)
Subject: Re: [PATCH 00/10] some fixing + refactoring batch-free
To:     Pavel Begunkov <asml.silence@gmail.com>, io-uring@vger.kernel.org
References: <cover.1593337097.git.asml.silence@gmail.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <5d9f98ba-0f98-a300-ebeb-e3e9c4c599fa@kernel.dk>
Date:   Sun, 28 Jun 2020 08:09:09 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.8.0
MIME-Version: 1.0
In-Reply-To: <cover.1593337097.git.asml.silence@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 6/28/20 3:52 AM, Pavel Begunkov wrote:
> Firing away... All for 5.9 on top of 5 previous patches fixing link
> task submission. I don't think there is much to discuss so didn't
> separate into sub-patchsets. Let me know if I should.

Agree, this works fine as posted.

> Batching free is inteded to be reused outside of iopoll, so
> it's a preparation but nice by itself. 
> 
> [8/10] looks like it, but double check would be nice.

Thanks, yes we need the wakeup there.

I have applied this on top, thanks Pavel!

-- 
Jens Axboe

