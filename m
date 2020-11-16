Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4D9812B4B3F
	for <lists+io-uring@lfdr.de>; Mon, 16 Nov 2020 17:34:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730473AbgKPQdR (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 16 Nov 2020 11:33:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35696 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729499AbgKPQdQ (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 16 Nov 2020 11:33:16 -0500
Received: from mail-io1-xd44.google.com (mail-io1-xd44.google.com [IPv6:2607:f8b0:4864:20::d44])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B5965C0613CF
        for <io-uring@vger.kernel.org>; Mon, 16 Nov 2020 08:33:16 -0800 (PST)
Received: by mail-io1-xd44.google.com with SMTP id u21so18011549iol.12
        for <io-uring@vger.kernel.org>; Mon, 16 Nov 2020 08:33:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:references:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=S4uXS9wNCJpfPqqgZcOszxWplaibEKGo08LLsGR09XQ=;
        b=F2ApCbLGK6MR4DbYGce35YJInPM8okW99o1C1iuxW0XyBDPFDS9qF+m/8JCtGnGc5Q
         mfNhLj5rXHIiqEeWvxdiklWaaEjxbXD+qLYMDzJdyhs78AIgwT5ZAirrpgY/lKc+OcDL
         2U2uWtYiK64GKaZ8TD465c27gAYVv4KoLXEfWLGrP3yPkau+jYL5EX9J7hK5rEO5NyL6
         6JsfV8a2c29pchhnwjaXiaJZFhcfrH2IoMRqUogt877CxoqOVZt5GgNwUiQ5IOTmgx61
         Wn8XHrA+G7beiEOOftf35aMONQ22YWAMZYrhTxNCp+V3niXRuKjjzY4cMVE6TRi9j31c
         5L/Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=S4uXS9wNCJpfPqqgZcOszxWplaibEKGo08LLsGR09XQ=;
        b=UNh7CaQy49BJPud028UNFtAr+DzZy83g8vJNRqxqNNTfsStuIYqohF/pLKPW64cOwI
         BUs2o2seNIPkD9RndDxQhC2PkhDSMEAygMK6xc3uER7Km/tLtJ5eXOl/0j1S+NJb8PV4
         hKsPci/+SMWL8VVvMjUgcHRsXvHF4sY1hKHxmObDO77nD12wNuqPlSPwLIYx99i5lxvu
         ldt48GAgHPYTMXQ/V9rxG/FJHaOYM7Japfjj66svpWAD5GOVTjKPlEuT6QC8jC7s+LC2
         5V70kwqctBHxvWN3/da411u8eedVKEsxYngY3TtpOeZvcduSpZXHNVHtUHEhq9dhRE9K
         A0Eg==
X-Gm-Message-State: AOAM530gYS+BsLa6vMxEFtGOZLIoUc1nsgr+g8J8W1yQk12a1wMJhxVS
        xi84/SkrcxGxYz7HPJlzFHdeQKlKLdlCIA==
X-Google-Smtp-Source: ABdhPJycbRMemcspmjv+pkwHfhWzflMu6i0SlC65yIyqz2jNynTEJN8CL7jl8wUd/cvQHPisqbnKtw==
X-Received: by 2002:a5d:9b8f:: with SMTP id r15mr8602741iom.35.1605544395912;
        Mon, 16 Nov 2020 08:33:15 -0800 (PST)
Received: from [192.168.1.30] ([65.144.74.34])
        by smtp.gmail.com with ESMTPSA id q25sm1645541ili.34.2020.11.16.08.33.15
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 16 Nov 2020 08:33:15 -0800 (PST)
Subject: Re: [PATCH 1/1] io_uring: replace inflight_wait with tctx->wait
To:     Pavel Begunkov <asml.silence@gmail.com>, io-uring@vger.kernel.org
References: <ce4f91e603b524b6425d68cf49c83c7d4fbd7d79.1605444955.git.asml.silence@gmail.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <463ac36b-974d-f88c-d178-6e4d24fa4c93@kernel.dk>
Date:   Mon, 16 Nov 2020 09:33:15 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <ce4f91e603b524b6425d68cf49c83c7d4fbd7d79.1605444955.git.asml.silence@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 11/15/20 5:56 AM, Pavel Begunkov wrote:
> As tasks now cancel only theirs requests, and inflight_wait is awaited
> only in io_uring_cancel_files(), which should be called with ->in_idle
> set, instead of keeping a separate inflight_wait use tctx->wait.
> 
> That will add some spurious wakeups but actually is safer from point of
> not hanging the task.
> 
> e.g.
> task1                   | IRQ
>                         | *start* io_complete_rw_common(link)
>                         |        link: req1 -> req2 -> req3(with files)
> *cancel_files()         |
> io_wq_cancel(), etc.    |
>                         | put_req(link), adds to io-wq req2
> schedule()              |
> 
> So, task1 will never try to cancel req2 or req3. If req2 is
> long-standing (e.g. read(empty_pipe)), this may hang.

This looks like it's against 5.11, but also looks like we should add
it for 5.10?

-- 
Jens Axboe

