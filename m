Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 663A24383FD
	for <lists+io-uring@lfdr.de>; Sat, 23 Oct 2021 17:02:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230446AbhJWPEu (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sat, 23 Oct 2021 11:04:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37708 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229901AbhJWPEr (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sat, 23 Oct 2021 11:04:47 -0400
Received: from mail-oi1-x230.google.com (mail-oi1-x230.google.com [IPv6:2607:f8b0:4864:20::230])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2FF34C061714
        for <io-uring@vger.kernel.org>; Sat, 23 Oct 2021 08:02:26 -0700 (PDT)
Received: by mail-oi1-x230.google.com with SMTP id r6so8933064oiw.2
        for <io-uring@vger.kernel.org>; Sat, 23 Oct 2021 08:02:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=subject:to:references:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=fWpeqFRx+vwM8upW9HcuPOLVcGVJexOiL3fMORQrZmU=;
        b=uoL8QMXK5ZpfcwHzjbsARVjIzpdsU8USpy4/H4jX9WZPg06Ap7TtbpAqFMuTyu8L1r
         UDOX3rhHsxHZygI+kuAa8CdAvUsiCiROruSjMwPgyVhxCpKJOFl8Tf27iDVlM0ID7nDi
         DAif8xYNhsU7U+sT1vrXGaeAeCqhz6UFqOOKq6vIV1dP65mLiyMXw/3V2FxStHMsXlWX
         zUJj5Ypy7RFi+plwpLtFDOISRNlpNxFV2aCkPQwJb1cneWVVYTdSMNVIMxoj7tVfJY2N
         BFCSemZ0jsA3rel6X4qfhru0rxHxQ5CX0T8lB4TWe/po3m6YiayrT+707bH1q8e9xOtm
         QCqg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=fWpeqFRx+vwM8upW9HcuPOLVcGVJexOiL3fMORQrZmU=;
        b=NtUWAjLczxd0gf8ZYlqRRF98WMSW9ZQw/uRK7SF9faUYnDQyBvVvF40NCEe9pAj9Ek
         EyJ0KbWMw4FUmULQHtgEmy45TLiNhzUE0cYKshmoJmxcnnia429u1Z+31bw6c0JuEY82
         HP2GuM+A+q0YPcta2mKqaz+b0WSSyE/QXcdGofr3Oz3KndzFQScctsw12+UxJjqMcK1m
         4K2VBKKkEYl3LiUj/PtXyxB1k27EQtHpmOa94kc7n754/8/4X2UikvIg9nMJ3yv9ENWu
         O4RYRf2lSBCup1qN5wxQn82HeGjyfHpkVdUxm0ZNy5QIKXVYv3tVkg6llYe4nth+YCbX
         mtNA==
X-Gm-Message-State: AOAM533LtciaDr/vN47MtKZj48awAh8jXeyyLh8wsVefI8/2TpbBlt6J
        Ka61LNiVLlGvpy/UiVUBCXtfwNeCxQj4zyfk
X-Google-Smtp-Source: ABdhPJy3jec8GNIAPzqML42so2BLAAGZngKns81XuFZFqrpMvw+CnP5TP4pRcBaT+xJX4VdU0trLWA==
X-Received: by 2002:a05:6808:1802:: with SMTP id bh2mr4495252oib.142.1635001345402;
        Sat, 23 Oct 2021 08:02:25 -0700 (PDT)
Received: from ?IPv6:2600:380:7c3b:835b:9fac:942b:6e5d:a999? ([2600:380:7c3b:835b:9fac:942b:6e5d:a999])
        by smtp.gmail.com with ESMTPSA id f3sm2073007oot.1.2021.10.23.08.02.24
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 23 Oct 2021 08:02:24 -0700 (PDT)
Subject: Re: io-uring
To:     Praveen Kumar <kpraveen.lkml@gmail.com>, io-uring@vger.kernel.org
References: <e17b443e-621b-80be-03fd-520139bf3bdd@gmail.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <4a8f1917-e5af-b4a8-9938-e129987adc92@kernel.dk>
Date:   Sat, 23 Oct 2021 09:02:24 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <e17b443e-621b-80be-03fd-520139bf3bdd@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 10/23/21 2:08 AM, Praveen Kumar wrote:
> Hello,
> 
> I am Praveen and have worked on couple of projects in my professional
> experience, that includes File system driver and TCP stack
> development. I came across fs/io_uring.c and was interested to know
> more in-depth about the same and the use-cases, this solves. In
> similar regards, I read https://kernel.dk/io_uring.pdf and going
> through liburing. I'm interested to add value to this project.
> 
> I didn't find any webpage or TODO items, which I can start looking
> upon. Please guide me and let me know if there are any small items to
> start with. Also, is there any irc channel or email group apart from
> io-uring@vger.kernel.org, where I can post my queries(design specific
> or others).

Great that you are interested! It's quite a fast moving project, but
still plenty of things to tackle and improve. All discussion happens on
the io-uring mailing list, we don't have a more realtime communication
channel. Might make sense to setup a slack channel or something... But
for now I'd encourage you to just participate on the mailing list, and
question there are a good way to do it too.

-- 
Jens Axboe

