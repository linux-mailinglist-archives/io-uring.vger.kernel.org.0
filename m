Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5153743431B
	for <lists+io-uring@lfdr.de>; Wed, 20 Oct 2021 03:48:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229683AbhJTBu5 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 19 Oct 2021 21:50:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49658 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229555AbhJTBu4 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 19 Oct 2021 21:50:56 -0400
Received: from mail-io1-xd33.google.com (mail-io1-xd33.google.com [IPv6:2607:f8b0:4864:20::d33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2A2D6C06161C
        for <io-uring@vger.kernel.org>; Tue, 19 Oct 2021 18:48:43 -0700 (PDT)
Received: by mail-io1-xd33.google.com with SMTP id h196so22718645iof.2
        for <io-uring@vger.kernel.org>; Tue, 19 Oct 2021 18:48:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=kYiJ/dOy6CNC8qADFZcH9nLqVdllMWrVqA9IiKKox58=;
        b=Z1pbV1BSM0Ulb0f+CET9w5K5Sa4924kCAS6IG+m5n+ind48p+5u8ugyoc3u9E3i567
         bEOKZ5Pu0ql44id2ev+0vuejqW0BZ2So+4L2szogdkR9hN9XsJ1quKEU3QIopPt95ZFO
         jY5IfE6eQVoyoECIEGXmE0PBnuJd1ppGRlFMm1u/aeCq/2PQcHZTqzTXKHi6H3niIaWS
         qFBjIl9eC6MpDDPtuCoUaep31x+A1/VOL5ZFzmzk/Ia7VW1UCNZPHSvs1nVsarNB8D+c
         Sotis8DsBuqsefWjBj3lX6N9HMOS3N5V96Kl+2ExGd2YaFyQfLCcf38runwC9C9++36P
         z0aA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=kYiJ/dOy6CNC8qADFZcH9nLqVdllMWrVqA9IiKKox58=;
        b=6ZCJ+ZaXG2dvcTXzicVCf5DYwTPG4bO+3xkuA0eJ6jRXQvynVNi2l5e3szyYgAVa8O
         5+9icKIv0FdxsYQAkabqjXgGKnySS2xoJqRr2X+7kFXwY+FpztrIpwOBkWK3ute9Jl26
         K2RYBn+6Pii+eBfL1jg8TU3KYLFQC52SAE0ZSrCYwNTxl67aIxj5rSDJSswNpGp8M94y
         F4xARrgwPRAEBGnHrolJ5AxJtwYOu4VdhQCHu13t/g2WlPN1TLODaOac34cIvEznbEMp
         6DoEaYgC04CxGx1IP1hzjyJEvlaiPNfzv+ieyUbtRGnP5HQJAKvd8ZfQ/Yx6B1qEf7lJ
         YK4w==
X-Gm-Message-State: AOAM530XxaUdpmsryaJd8CTHKoqMpj3hRCRczULBHDHdr3RQC2sK9Is+
        rov0WgSx1W6cfFJKlgeSx3RTsQ==
X-Google-Smtp-Source: ABdhPJxEUeraumGqCC5GhJd4anh2s1HOoZv8QxpBzfkYtgOPtVGpC+UjgW91h4Yj15u2LCPv7do47Q==
X-Received: by 2002:a02:a38e:: with SMTP id y14mr6762912jak.8.1634694522060;
        Tue, 19 Oct 2021 18:48:42 -0700 (PDT)
Received: from [192.168.1.116] ([66.219.217.159])
        by smtp.gmail.com with ESMTPSA id e8sm418538ilu.17.2021.10.19.18.48.40
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 19 Oct 2021 18:48:40 -0700 (PDT)
Subject: Re: [PATCH 5.15] io_uring: fix ltimeout unprep
To:     Pavel Begunkov <asml.silence@gmail.com>, io-uring@vger.kernel.org
Cc:     Beld Zhang <beldzhang@gmail.com>
References: <902042fd54ccefaa79e6e9ebf7d4bba9a6d5bfaa.1634692926.git.asml.silence@gmail.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <0370d998-3fcb-d4f0-266a-3032ecff8aa8@kernel.dk>
Date:   Tue, 19 Oct 2021 19:48:39 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <902042fd54ccefaa79e6e9ebf7d4bba9a6d5bfaa.1634692926.git.asml.silence@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 10/19/21 7:26 PM, Pavel Begunkov wrote:
> io_unprep_linked_timeout() is broken, first it needs to return back
> REQ_F_ARM_LTIMEOUT, so the linked timeout is enqueued and disarmed. But
> now we refcounted it, and linked timeouts may get not executed at all,
> leaking a request.
> 
> Just kill the unprep optimisation.

This appears to be against something that is not 5.15, can you please
check the end result:

https://git.kernel.dk/cgit/linux-block/commit/?h=io_uring-5.15&id=46cb76b2f5ff39bf019bf7a072524fc7fe6deb01

-- 
Jens Axboe

