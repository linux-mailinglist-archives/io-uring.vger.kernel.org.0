Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4E66140B021
	for <lists+io-uring@lfdr.de>; Tue, 14 Sep 2021 16:02:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233354AbhINODU (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 14 Sep 2021 10:03:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60018 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233338AbhINODT (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 14 Sep 2021 10:03:19 -0400
Received: from mail-il1-x12d.google.com (mail-il1-x12d.google.com [IPv6:2607:f8b0:4864:20::12d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 66E1DC061574
        for <io-uring@vger.kernel.org>; Tue, 14 Sep 2021 07:02:02 -0700 (PDT)
Received: by mail-il1-x12d.google.com with SMTP id v16so9324266ilg.3
        for <io-uring@vger.kernel.org>; Tue, 14 Sep 2021 07:02:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:references:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=GTIJuKtC2bPARqSKxzjwg9U9Geol5KfnpgaR7vC7AGc=;
        b=IgE1A1MABCkOrceOV4e0sz5AmC4Xr82tF3YSi2YaQ52EUsqErPXmBSowjp90lhIEiX
         zsfkQtrgOsrJTkO0gK5V7Fs1GM8p1sbrLC8qHDnmSdJaXuZ7UzhWFnStC1+ePYYXJq1w
         VE528tEdKgoLlC4nw1Pzc6uDTQnw2otW00zNTKR1yrcJoXq/2uCredxjBZitUHZ8rT67
         tj20Vl+tnSV8WbaEpLGMY2XgIRUzrN7y3SX+kKf6PXfZSZu+315WO8VTJkbYxFSBeFQL
         YXPa7tQlohvleaVH+0+qY3TcItzIthjXRqqJGCzMcX2perWeQSo175KSBEHrNSAWJMSK
         CKqA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=GTIJuKtC2bPARqSKxzjwg9U9Geol5KfnpgaR7vC7AGc=;
        b=VdlpF5n0cx69sCMrSMyt7MiQvlUH8rUHoQhUiwhjfeRjqzfZk9jPbn2Hl9wMSw9VvH
         5FNL6jauRxRpuEpdMBoEfE9TmFn4+0Cv8U0HnxtIcVVbxLL4zXcGxH10DH2UpXGhX4tY
         dYuivSgX3klueNFfYQ27lS9EwMZyF4I6KUwTIAfSlFdCAJJzSXIzl93rw5DzZ2IQPEA9
         fQ1DxmZz2afmzdpMPoO5+3oZibRtp59ozv9EbJ+lswwSgC0fXmp9b7834bh5ogPbwJps
         4vxFUmBilC5zbmS1oUg/zvvWS7Doy1Vx3k6KqxWcF7cDbqoxDyBDxlI+uw26bmzmq0O0
         /tvg==
X-Gm-Message-State: AOAM531QEPMd9WyYWvKJhs2O0N1dAFI8x7DrZjYIqvga7W3wmYTdGHm0
        uLalt4VcadqvBCbPk4miLaO8e3mXFStn7NQgjw4=
X-Google-Smtp-Source: ABdhPJxkxe7y7uEwvIpi5NllIk54TKFPXR/L0gnFWOw3bpTBlL8wBavTII8sZc1Jzn8MPaZbnhw2Xw==
X-Received: by 2002:a92:7f0a:: with SMTP id a10mr12836019ild.22.1631628121481;
        Tue, 14 Sep 2021 07:02:01 -0700 (PDT)
Received: from [192.168.1.30] ([207.135.234.126])
        by smtp.gmail.com with ESMTPSA id b16sm6735458ila.1.2021.09.14.07.02.01
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 14 Sep 2021 07:02:01 -0700 (PDT)
Subject: Re: [PATCH 5.15] io_uring: auto-removal for direct open/accept
To:     Pavel Begunkov <asml.silence@gmail.com>, io-uring@vger.kernel.org
References: <0ef71a006879b9168f0d1bd6a5b5511ac87e7c40.1631626476.git.asml.silence@gmail.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <27718f96-30af-2ebc-3a53-8fb6bb7155ec@kernel.dk>
Date:   Tue, 14 Sep 2021 08:02:00 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <0ef71a006879b9168f0d1bd6a5b5511ac87e7c40.1631626476.git.asml.silence@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 9/14/21 7:37 AM, Pavel Begunkov wrote:
> It might be inconvenient that direct open/accept deviates from the
> update semantics and fails if the slot is taken instead of removing a
> file sitting there. Implement the auto-removal.
> 
> Note that removal might need to allocate and so may fail. However, if an
> empty slot is specified, it's guaraneed to not fail on the fd
> installation side. It's needed for users that can't tolerate spuriously
> closed files, e.g. accepts where the other end doesn't expect it.

I think this makes sense, just curious if this was driven by feedback
from a user, or if it's something that came about thinking about the use
cases? This is certainly more flexible and allows an application to open
a new file in an existing slot, rather than needing to explicitly close
it first.

-- 
Jens Axboe

