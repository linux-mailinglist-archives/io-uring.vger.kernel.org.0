Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 26EB014F8DA
	for <lists+io-uring@lfdr.de>; Sat,  1 Feb 2020 17:26:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726622AbgBAQ0T (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sat, 1 Feb 2020 11:26:19 -0500
Received: from mail-pg1-f176.google.com ([209.85.215.176]:45835 "EHLO
        mail-pg1-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726670AbgBAQ0S (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sat, 1 Feb 2020 11:26:18 -0500
Received: by mail-pg1-f176.google.com with SMTP id b9so5271648pgk.12
        for <io-uring@vger.kernel.org>; Sat, 01 Feb 2020 08:26:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:references:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=w0PjGS/klgnrRtPNKFCF6fGGDejuNhQNgoqlU58Tch0=;
        b=wAo0xbc12Nh4hBoZVjwv+emR9n/jSarM4NO7bzpPeAFDhzcuD4s73If4amekxIh8IB
         DO/EFDkqEuHsWJN9yzrZpuPKz2HeXhADf6All8yxhV4FzVl9Tgy/nTMLFVxdvyRLN9mg
         JiTXclzNVzUv+krA2I4fpeESlvxWHuCLciHRT1cfQWVLkTAgwRnhf/4wMq4uHyl2FTMx
         xrhU+sVzKtvYvSFEbOuVhyOkFYDD6RCYqy4n0QTFkZEsI2CqDEi8GU1PtXbVzikUyFr7
         /IKfrTo+wVuZ4waRqyxchYbj0VoRgaFInimhuH6XyYGNgFDdvOPxlqx30Q7gZsGGvpSt
         W77w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=w0PjGS/klgnrRtPNKFCF6fGGDejuNhQNgoqlU58Tch0=;
        b=PtGT1k5VD14md8JH7Z61WzoOx//J81oGRWHKS4pjiFzqROTj9MO69EL3nGWrHU0S8U
         1GGz9C2zXYsZiCeEFAoOsxnBPjICg++fZ9ETtAXrt90+sQWf7p0e8BNYLi8LO5uSx/cO
         d6l2UsOAqdAYAjCCwypdYIiXs1ihYt7QmXLM8fCTGdGtXnQvTVXfY/mHNxibkR2FA2AS
         /6QebZ1q67SiKCAJXpKVv55sXhXB6jgCNZlsvP4ddR27s0Lo39PC8BeIkVeZjwt9bJXj
         gWKjSC95lJiHl1k0yTKsnkc5INxGQc0zjWRIkNEJmpUwzqE5dBtcfbnAqV8egUxA69CF
         AMSQ==
X-Gm-Message-State: APjAAAX9CCUz7sqedYPWpm2gDlIYHAfqiGnJhAGhoXuSaZi4hgrNfNBg
        63mE6M5D1r3+vZ+aP9LRNIKyFg==
X-Google-Smtp-Source: APXvYqwhuUQ1S8cgtvCF/gHqRGnjcizBH7lNM6PwbO1VijPq03ib1uGGVdk3Y3njtLPXenUjzjBlng==
X-Received: by 2002:a62:1889:: with SMTP id 131mr16240997pfy.250.1580574376482;
        Sat, 01 Feb 2020 08:26:16 -0800 (PST)
Received: from [192.168.1.188] ([66.219.217.145])
        by smtp.gmail.com with ESMTPSA id c14sm14642299pfn.8.2020.02.01.08.26.15
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 01 Feb 2020 08:26:16 -0800 (PST)
Subject: Re: [PATCH] io_uring: iterate req cache backwards
To:     Pavel Begunkov <asml.silence@gmail.com>, io-uring@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <df6e93383161cd3bdbe19fe816b761af0096c303.1580518665.git.asml.silence@gmail.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <d46cbbd6-65c4-93f9-b3f4-566ec8f10272@kernel.dk>
Date:   Sat, 1 Feb 2020 09:26:14 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.4.1
MIME-Version: 1.0
In-Reply-To: <df6e93383161cd3bdbe19fe816b761af0096c303.1580518665.git.asml.silence@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 1/31/20 5:58 PM, Pavel Begunkov wrote:
> Grab requests from cache-array from the end, so can get by only
> free_reqs.

Applied, thanks.

-- 
Jens Axboe

