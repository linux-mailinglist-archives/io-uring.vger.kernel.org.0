Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C899841FE43
	for <lists+io-uring@lfdr.de>; Sat,  2 Oct 2021 23:32:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234089AbhJBVeT (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sat, 2 Oct 2021 17:34:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44528 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229503AbhJBVeT (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sat, 2 Oct 2021 17:34:19 -0400
Received: from mail-io1-xd2c.google.com (mail-io1-xd2c.google.com [IPv6:2607:f8b0:4864:20::d2c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 60AB9C061714
        for <io-uring@vger.kernel.org>; Sat,  2 Oct 2021 14:32:33 -0700 (PDT)
Received: by mail-io1-xd2c.google.com with SMTP id d18so15748675iof.13
        for <io-uring@vger.kernel.org>; Sat, 02 Oct 2021 14:32:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=subject:to:references:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=slxJvLqIoIyNgVBm7X4YLfI4iWVi8o9k8bQd8I2W9R8=;
        b=oAiAvDbn7s4i06aACeHhM4TRFxQBT4oeNJwz1ddX4pA5mE8hd0Xi5+1d2zeEaraxgG
         AVfRU2v/nYbEj7BgS93VDw4QVOWp9Kgj81ZiGQH/GmKjwv36QkCFJsUgWcNgobbUovcc
         rQ8i2IzwMdEOrIyeIQzv53W44biZnoS2Y8/IathbPN9Eyvn3MrS+8oquNQpZmHEyw7vV
         UVhcNkO3nVdc+zHoNYGaxpuNq5FfQ8jq2AaEcHIGxPsN6fL8zs5aQSn16UEKxfoFBDu2
         rP3B1g4z3pkY0748D6BHZ+fIWhHsi4Ax8TaPrgn8Otzud/cQlKWibbKo0RmIBq7sZskA
         +BNg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=slxJvLqIoIyNgVBm7X4YLfI4iWVi8o9k8bQd8I2W9R8=;
        b=HwzMyqELsGUIqRPnLN9jN8mUPO2aYlzClzw3LOQCzLYhacP75pN+nxj8becMSewsQp
         JuoK8Nj19pYOxHUAETkWjd0tVWYKcbiDsPglx6Es4XkmqnZcjeGjy4cFjqMA/RAzRwsb
         USbPrh2IGfYUNZQN1JmyRwKEHgfdePrS8ZYZ23zfyOxN73kbq/jhxqrgnxop8KCDBqCG
         3ZOs7IKyzcLPZHvg2O73WwZy+z1FytLgEU3kp4mfvqU1lhFbHKD/no7db4bIUkm1gCL6
         of1/4WXxBgWzneQJhZFLNolO5KC+8XPud4uZEhR3UNRle3hGQw30dCDdyYSGH0nujZKk
         efgQ==
X-Gm-Message-State: AOAM531MqCBqZkeX97bo/4FpLLqGuWCI28YCndhVPq38rEARMTqZCJX6
        v0tiwJRAvoFGh/HAOdV6CAqHkz4mpMapSA==
X-Google-Smtp-Source: ABdhPJwj8ujZrWYgNbFSkYSoSiEg583hKfiHQlsTAYo9F+jjpyYJ5tJXj3NKEQeiJEwnA5nEcfqUeg==
X-Received: by 2002:a05:6602:1812:: with SMTP id t18mr3627273ioh.36.1633210352554;
        Sat, 02 Oct 2021 14:32:32 -0700 (PDT)
Received: from [192.168.1.116] ([66.219.217.159])
        by smtp.gmail.com with ESMTPSA id b5sm2182258ilq.77.2021.10.02.14.32.31
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 02 Oct 2021 14:32:32 -0700 (PDT)
Subject: Re: [PATCH v3] io_uring: add flag to not fail link after timeout
To:     Pavel Begunkov <asml.silence@gmail.com>, io-uring@vger.kernel.org
References: <17c7ec0fb7a6113cc6be8cdaedcada0ba836ac0e.1633199723.git.asml.silence@gmail.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <ad256428-ea19-0b35-e8a0-01a1b6dc0271@kernel.dk>
Date:   Sat, 2 Oct 2021 15:32:30 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <17c7ec0fb7a6113cc6be8cdaedcada0ba836ac0e.1633199723.git.asml.silence@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 10/2/21 12:36 PM, Pavel Begunkov wrote:
> For some reason non-off IORING_OP_TIMEOUT always fails links, it's
> pretty inconvenient and unnecessary limits chaining after it to hard
> linking, which is far from ideal, e.g. doesn't pair well with timeout
> cancellation. Add a flag forcing it to not fail links on -ETIME.

Applied, thanks.

-- 
Jens Axboe

