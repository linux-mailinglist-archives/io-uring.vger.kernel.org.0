Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C8F3E2ED305
	for <lists+io-uring@lfdr.de>; Thu,  7 Jan 2021 15:51:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727733AbhAGOtL (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 7 Jan 2021 09:49:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59418 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726338AbhAGOtL (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 7 Jan 2021 09:49:11 -0500
Received: from mail-il1-x12c.google.com (mail-il1-x12c.google.com [IPv6:2607:f8b0:4864:20::12c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 48934C0612F4
        for <io-uring@vger.kernel.org>; Thu,  7 Jan 2021 06:48:31 -0800 (PST)
Received: by mail-il1-x12c.google.com with SMTP id 75so6910910ilv.13
        for <io-uring@vger.kernel.org>; Thu, 07 Jan 2021 06:48:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:references:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=WlXhpf/hKVhCgoWgEzu4q3P4kYbJvRD9I1ORM4VyWZw=;
        b=0/UIVTPpoqm9u/S9Atd0Tl0mpigaH93fUsaQNpB5ThqXT7mCKBdpaXVcd9HWN9c44v
         y2WyMjkWVvPjv14nHGztzsH4sPNHUj1G7QveBQafMHqMFyxvCsv1jglTs3oY5tq4d9U4
         WNSu8feZRwNszAx3PSJUUyTpfBwdfPgTJ41JbWZdsFnN9MVsxcIY9ZKQn7ImiYc7qKjo
         CMwEMbvAM5aC2oG1957KV8BMpkL3DgVSN9MvpXRatTBrosARHarGhnA3fgzhOBFfRgrU
         K64kX8eQWjwHl5LDP2gQGBhq6u8veNaKwwk/4V8xkd+h2htHOKL51wMN1cQQ/fnEHvYx
         brcw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=WlXhpf/hKVhCgoWgEzu4q3P4kYbJvRD9I1ORM4VyWZw=;
        b=s3hr3nyvWGHhL9wQA5vn/ywQJ4r1/V4+wmP0dtp3J18MUSVwO7l4cAXpn8zHLgYdwR
         HZbERYFuejzEVt7rVyX1S0SkD+CDUFFbo5f/8OkyBOHj5F0qDFpHNYM96R95Gh3Rg1hm
         v8W3ha51wcH2zj9JuJW17Xx0ZTcX9YdZzBlpHt9mjWSkehCnr+HuEC9gfTVNCLMkJ98R
         ZY1CR4PbycJn66GYhu/oRZXqa4u5TM/3c0y14M5mIpL32fDi6UQ8/rmAnSlMOlmOi/v2
         XjFzoenNoMY7E4TfAUHXoEd+r6Cu84PiuuI+fOSOGEPaSOapL7jycVUa/U7aAVyhVx7f
         kvsg==
X-Gm-Message-State: AOAM5306vurOC0Tl9DnulBVx+gTQfd1d/sWGD2yBXr/HYeDyhRgu8idD
        mLsA5TXI0PguF8GZvcME9qORkLeokan4rA==
X-Google-Smtp-Source: ABdhPJxfzv0SJpNbHUGQ2S+H1xF9bQqneisjEJX79Jjk7iwOxf3XOoWEi7kjADlfCIw1sGkSV3aedg==
X-Received: by 2002:a92:1b43:: with SMTP id b64mr8903312ilb.71.1610030910543;
        Thu, 07 Jan 2021 06:48:30 -0800 (PST)
Received: from [192.168.1.30] ([65.144.74.34])
        by smtp.gmail.com with ESMTPSA id l9sm4618009ilg.51.2021.01.07.06.48.29
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 07 Jan 2021 06:48:30 -0800 (PST)
Subject: Re: [PATCH 0/3] commit/posted fixes
To:     Pavel Begunkov <asml.silence@gmail.com>, io-uring@vger.kernel.org
References: <cover.1609988832.git.asml.silence@gmail.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <d292b170-54f8-1c0d-1fa8-2cbb154a9be9@kernel.dk>
Date:   Thu, 7 Jan 2021 07:48:30 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <cover.1609988832.git.asml.silence@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 1/6/21 8:15 PM, Pavel Begunkov wrote:
> Looks like I accidentially didn't send this series.
> 
> Regarding mb in 3/3, I have a for-next patch removing
> it (one mb less in total), just prefer it to settle a
> bit so there is more time to be reported if anything
> goes wrong.

Applied, thanks.

-- 
Jens Axboe

