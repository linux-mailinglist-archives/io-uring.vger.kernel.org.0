Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A2BC2287695
	for <lists+io-uring@lfdr.de>; Thu,  8 Oct 2020 17:00:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730650AbgJHPAz (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 8 Oct 2020 11:00:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33272 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730811AbgJHPAy (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 8 Oct 2020 11:00:54 -0400
Received: from mail-io1-xd43.google.com (mail-io1-xd43.google.com [IPv6:2607:f8b0:4864:20::d43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BB895C061755
        for <io-uring@vger.kernel.org>; Thu,  8 Oct 2020 08:00:53 -0700 (PDT)
Received: by mail-io1-xd43.google.com with SMTP id u19so6510768ion.3
        for <io-uring@vger.kernel.org>; Thu, 08 Oct 2020 08:00:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=WZDzXjxsrnX66JH+D6AkXgCNvH1vevBLp81uQ80sSWc=;
        b=kRmKbOTbjgvZb6h6M+70aZMJlEE8zvlPv4MEw0qnkxbn8LXTsXaYO8Jn9fNp927MVl
         zLxtKJ6lYKS9c+tZ4A5rDUIQW5Q0Y+defzhqibmfyIIZFnAYqCkmhnbe8GtwscenQ3j3
         zVJ809y8U0UmSuun1Ke4Yx2j1o2z60yXbfwT8hrp0fYCa4dk90+xATdibG5NdEBauNn0
         vW7B7gp6J+7SAJfiUvAHduzpvvVi4dxfthO7+0gHehrM9or7PZ2Oi5eRAMIp5B9PRo+T
         Cuxxc5QJE6FZpSZhATSErYaNLuJZyQBq0xQWDPggUUw5lEA6tZ5a02/ZDp+emdutSvMM
         8u7Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=WZDzXjxsrnX66JH+D6AkXgCNvH1vevBLp81uQ80sSWc=;
        b=jy/3wfhFR79XRsDX7i6KXNhivUTKCmRjhHJdj1LVHd/SfVbP/vgqayv0hzYV9GZ4ap
         loecL/tfbVP7p4uzlyEQ3jBT+648vo7AwaBaK/iiUPCgUe7ryl3wbIil9utlsAh8rt0a
         K57EwBiKZFeHZ9WgH5PoQ+AmPQ64mij4OCRiE2KLFuefkywTnmMPq/T9/nmA7ih/ke8X
         zdKM+4Z3Lf1dkXYvrNEXAKpwIj3rHgDP4QuEhXVXuCM0M8u4CD7ezMdd2mswyULwHI5w
         eR7wzn9wHYmom5b/tSAkx5k1YArdZNQh82DSCiEA/BKVqcJZZvDUqNRPzbl9X6lt3R0S
         hBXA==
X-Gm-Message-State: AOAM532bYeVt+UHZS5O4t73rlKeEVpU48Y8ph+/QdUXyBEJ2KIJLuJHl
        qEKDvhxg+4msFM9ZtGdBOz6ZhdbKfS/Wyw==
X-Google-Smtp-Source: ABdhPJzUc8YVDY/oZyP69uvdNspVtF5RE22WXlq/MG8y+T4fsR+/GMl4bFzKyHaTdOGv/Q7GxgwKkQ==
X-Received: by 2002:a6b:f60b:: with SMTP id n11mr6255679ioh.45.1602169253095;
        Thu, 08 Oct 2020 08:00:53 -0700 (PDT)
Received: from [192.168.1.30] ([65.144.74.34])
        by smtp.gmail.com with ESMTPSA id h14sm2759625ilc.38.2020.10.08.08.00.52
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 08 Oct 2020 08:00:52 -0700 (PDT)
Subject: Re: [PATCHSET RFC v3 0/6] Add support for TIF_NOTIFY_SIGNAL
To:     Oleg Nesterov <oleg@redhat.com>
Cc:     linux-kernel@vger.kernel.org, io-uring@vger.kernel.org,
        peterz@infradead.org, tglx@linutronix.de
References: <20201005150438.6628-1-axboe@kernel.dk>
 <20201008145610.GK9995@redhat.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <7af78e02-2c4a-ba62-38c0-e927dc5267b7@kernel.dk>
Date:   Thu, 8 Oct 2020 09:00:52 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20201008145610.GK9995@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 10/8/20 8:56 AM, Oleg Nesterov wrote:
> On 10/05, Jens Axboe wrote:
>>
>> Hi,
>>
>> The goal is this patch series is to decouple TWA_SIGNAL based task_work
>> from real signals and signal delivery.
> 
> I think TIF_NOTIFY_SIGNAL can have more users. Say, we can move
> try_to_freeze() from get_signal() to tracehook_notify_signal(), kill
> fake_signal_wake_up(), and remove freezing() from recalc_sigpending().
> 
> Probably the same for TIF_PATCH_PENDING, klp_send_signals() can use
> set_notify_signal() rather than signal_wake_up().

Totally agree, which is why I liked your suggestion of turning it into a
tracehook.

I've rebased and collapsed the series with the changes, initial tests
look good here. I'll run it through some more testing and send out a v4.
I really like that it's down to 3 core patches now, instead of 5, and
the last one is just wiring up task_work. The changes you suggested also
means it's a lot easier to wire up new archs, so we could potentially
have full support for TIF_NOTIFY_SIGNAL very quickly and can drop the
JOBCTL etc parts.

I'll work on that next, if we have agreement that v4 is sound. Thanks a
lot for your reviews, Oleg! It might've started out a bit nasty on the
RFC front, but with the current direction, we'll end up deleting a lot
of extra code on top.

-- 
Jens Axboe

