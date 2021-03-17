Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5613433FBC3
	for <lists+io-uring@lfdr.de>; Thu, 18 Mar 2021 00:25:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229537AbhCQXY4 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 17 Mar 2021 19:24:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57790 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229494AbhCQXY3 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 17 Mar 2021 19:24:29 -0400
Received: from mail-pl1-x62b.google.com (mail-pl1-x62b.google.com [IPv6:2607:f8b0:4864:20::62b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A7BBFC06174A
        for <io-uring@vger.kernel.org>; Wed, 17 Mar 2021 16:24:29 -0700 (PDT)
Received: by mail-pl1-x62b.google.com with SMTP id v23so331260ple.9
        for <io-uring@vger.kernel.org>; Wed, 17 Mar 2021 16:24:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:references:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=NbcZhKlHY9PJK2NPILHeb0dP2UWKYmIeig1MSDtlNtc=;
        b=nrV5zN0ZtRL1yHxlWMKVG0HnL8q2048abi7HGgp3aB0CBnNkjaSmwgnMKJFhbqod+4
         Zw82xAFfQEGkYkxo0jnSGBPEu9oBE1LTDQar9AuxAGjvQHbhFuxOv0hFuRlqrg/Lyq3s
         4Y1U2KhUB0h/J1iscUNipJSqsPIIw6QDguuUeCrNpjcYcoVE8wv8eaEFLmOBs6qM2+7B
         bEwBWBH1LvLK3OtJSwZmfVKD+rTPjezPVcl0YPJNPJB+pzRc53oCv9aWeLcTIF01oQsr
         BH0gmHDllIGXAlKgomVG9nB/lU+m1jU3WYoboGkn6TOQipgXcVz/QuzQdDLHLqfNLQ1e
         9+2A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=NbcZhKlHY9PJK2NPILHeb0dP2UWKYmIeig1MSDtlNtc=;
        b=E/WjZDU4N0BBXJsZQ9Ndv9yH4Urkr1Ib+9NXGACCCTuuNyhbkwWItJBdCDFTOd7aoO
         MfQpj2AsNiQ+fGRvbprCDx+GFACNttSEUMwFwBQeN8JBv3PaAY4j1yLvcIUMuSD1BEt+
         MF0m19Tei4VGgyGSbO4taa8pCPe5v5U9G9ixQyfuO5N+4iqcT+sDqtZyX+SPjdSWLfZW
         N/iyIikEaAgWcG4vX5cV2RhY5K4ugnxLJYN7W3KIOKKS0yY8yCxwyehM8tFk9PNCan/g
         yDOZvQbiBIm5xE09Z434UUhOYSm5O/QPr9k7KUcPHHnLaRLeBych+9pUdud/wEuOun6R
         MjnA==
X-Gm-Message-State: AOAM532WLJ7/lDFXr0b8eqxAkh2Uve/gB96/ZspHthc2xXsRnKyz27cW
        xNMzg7CHOL1805XpW+byZ6Rid9kYkZGbCp1c
X-Google-Smtp-Source: ABdhPJzFQKTXGC6dF3um8Q0mIUb32rCbI4m6z9I1D9yNFjaDigsKD4QoIzMD17T080QKTVSYi8zCQw==
X-Received: by 2002:a17:90a:c918:: with SMTP id v24mr1244090pjt.182.1616023468855;
        Wed, 17 Mar 2021 16:24:28 -0700 (PDT)
Received: from ?IPv6:2600:380:4a51:337f:2eaa:706:9b3d:17d9? ([2600:380:4a51:337f:2eaa:706:9b3d:17d9])
        by smtp.gmail.com with ESMTPSA id a15sm169455pju.34.2021.03.17.16.24.27
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 17 Mar 2021 16:24:28 -0700 (PDT)
Subject: Re: [PATCH 0/2] send[msg]()/recv[msg]() fixes/improvements
To:     Pavel Begunkov <asml.silence@gmail.com>,
        Stefan Metzmacher <metze@samba.org>, io-uring@vger.kernel.org
References: <cover.1615908477.git.metze@samba.org>
 <47ae1117-0de3-47a9-26a2-80f92e242426@kernel.dk>
 <b2f00537-a8a3-9243-6990-d6708e7f7691@gmail.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <7ef8f70c-24a0-5218-ce18-3b0a354bf486@kernel.dk>
Date:   Wed, 17 Mar 2021 17:24:25 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <b2f00537-a8a3-9243-6990-d6708e7f7691@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 3/17/21 5:07 PM, Pavel Begunkov wrote:
> On 17/03/2021 22:36, Jens Axboe wrote:
>> On 3/16/21 9:33 AM, Stefan Metzmacher wrote:
>>> Hi,
>>>
>>> here're patches which fix linking of send[msg]()/recv[msg]() calls
>>> and make sure io_uring_enter() never generate a SIGPIPE.
> 
> 1/2 breaks userspace. Sounds like 2/2 might too, does it?

If they don't sever on short sends/receives, they cannot have been
used reliably by applications. So I don't think that's a real risk.

2/2 should just make it a reliable delivery, SIGPIPE would get
lost for async, amongst other things.

-- 
Jens Axboe

