Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4E5831739D0
	for <lists+io-uring@lfdr.de>; Fri, 28 Feb 2020 15:26:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726845AbgB1O0f (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 28 Feb 2020 09:26:35 -0500
Received: from mail-io1-f68.google.com ([209.85.166.68]:39384 "EHLO
        mail-io1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726738AbgB1O0f (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 28 Feb 2020 09:26:35 -0500
Received: by mail-io1-f68.google.com with SMTP id h3so3575743ioj.6
        for <io-uring@vger.kernel.org>; Fri, 28 Feb 2020 06:26:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:references:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=Hmi5le44CQGwHZkkTL72nRXhpJhZ7lPRnGWjBH7JO1M=;
        b=sfTx6UEDp6jly1gWp413OHU4NBU0yLUmZSFdVEtigbJuYIxiT0ZcQet1qkwiKWAsN6
         ZwX73MDmY3TVBslM2YEoQ7CeebPykjbnQR/2K4BhlPuaXL1PR207IEVop5MoONHgs3F7
         xfWzUd+sKOtHbYGzATpBJEBrYslZuHHB34zAXL1swPoh/3aeO1aD2wut8A0WYPfwmz3l
         a3kDbNcYhshGGslRLREFhTI/qyyCeOlGOmP5/62DHnvnQ+BDU/uksO6XK0R1/a58Yj3l
         DXK58/e3qqVAL8AtUlAeiKcWuFWVblazb1lo8twdJ5KYgN9rr5EfZEQXpy9zeeV77Gqr
         8t8Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=Hmi5le44CQGwHZkkTL72nRXhpJhZ7lPRnGWjBH7JO1M=;
        b=ijuEStYBxLmtao9rIva2c7TRsRpH8vdpuufdmSHSgIlTAtWnxTOivds724u1pHVKhq
         ptcWp2BVj2E1bzMRX7WnFE+AncorUXhgsVDTXgQMfmtSUJKvLxGOtxxU7bLe96c9P2Vp
         py6+E1xYeT+OcM8nN8YZjuW4J/0byCPUz2lIpIRu6TGfZTmXxmo4WiMjEzo9B1dnB1yd
         B1RsJCgHUhtXZyCkkaGL/FFQy99QN15C1+ObZpybEFxXJPlOaPB2Mt5hhoKelheMcnlT
         lriTJqzA7PKyUSVevz6KbxJcTMIOfC3ajujm3cVWQYg6qCZTjkP4g9mikjxgalOZZlJ+
         WB/Q==
X-Gm-Message-State: APjAAAUjaHtNDG/kSuYN6ZivpiebmUzsB5VEXSzSgjfI2S154/AnXrQg
        PtEQxitKEBMbbVrFJJcNEbVOm0TwIS0=
X-Google-Smtp-Source: APXvYqwKE8S55tXWujXu74z/WrxCIhadSvN6bbCm06hlROjJQJMP7kzYGjmY4S46oUFEHpb8rfRG6A==
X-Received: by 2002:a5d:984e:: with SMTP id p14mr3823286ios.115.1582899993200;
        Fri, 28 Feb 2020 06:26:33 -0800 (PST)
Received: from [192.168.1.159] ([65.144.74.34])
        by smtp.gmail.com with ESMTPSA id n80sm3138915ilh.30.2020.02.28.06.26.32
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 28 Feb 2020 06:26:32 -0800 (PST)
Subject: Re: [PATCH 0/5] random io-wq and io_uring bits
To:     Pavel Begunkov <asml.silence@gmail.com>, io-uring@vger.kernel.org
References: <cover.1582874853.git.asml.silence@gmail.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <43a706cf-0abb-94bf-1417-8bb73048fd09@kernel.dk>
Date:   Fri, 28 Feb 2020 07:26:32 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.4.1
MIME-Version: 1.0
In-Reply-To: <cover.1582874853.git.asml.silence@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 2/28/20 12:36 AM, Pavel Begunkov wrote:
> A bunch of unconnected patches, easy and straightworward.
> Probably could even be picked separately.
> 
> The only thing could be of concern is [PATCH 4/5]. I assumed that
> work setup is short (switch creds, mm, fs, files with task_[un]lock),
> and arm a timeout after it's done.
> 
> Pavel Begunkov (5):
>   io_uring: clean io_poll_complete
>   io_uring: extract kmsg copy helper
>   io-wq: remove unused IO_WQ_WORK_HAS_MM
>   io_uring: remove IO_WQ_WORK_CB
>   io-wq: use BIT for ulong hash
> 
>  fs/io-wq.c    | 11 +++--------
>  fs/io-wq.h    |  2 --
>  fs/io_uring.c | 51 +++++++++++++++++++++------------------------------
>  3 files changed, 24 insertions(+), 40 deletions(-)

LGTM, and always love a negative diffstat. Applied for 5.7.

-- 
Jens Axboe

