Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 70EE51567A1
	for <lists+io-uring@lfdr.de>; Sat,  8 Feb 2020 20:53:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727473AbgBHTx6 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sat, 8 Feb 2020 14:53:58 -0500
Received: from mail-pj1-f67.google.com ([209.85.216.67]:35398 "EHLO
        mail-pj1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727471AbgBHTx6 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sat, 8 Feb 2020 14:53:58 -0500
Received: by mail-pj1-f67.google.com with SMTP id q39so2419832pjc.0
        for <io-uring@vger.kernel.org>; Sat, 08 Feb 2020 11:53:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:references:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=UMDJMiQTFcKCxPkVkF9StmgbZfLqi1e4W4NfLM9RGGQ=;
        b=mKY4hd2as7iT5swEh2F8QhDSA2OKX3SB05pC/Y2HtdG8CVj7yoqEXXAbyqp7/lqDug
         9+5oXA2JDjqYNYOrr+69PUN8UAY3P1NedCp4E8KPj+l8VsPofsIJ+8Pk1Uf4fOvyIsRh
         eSFz4kGtDMh72HDZK03AF1hSlc85eKA7fd0IxjU45t97ZzV0ikGop0U5CjSSKySjwHyG
         2yy+Kf6wh+z9WPEgavWquy6fJXzzZCwJRDpXB7fsu4iIv3x4J2JVahIVMuYVYJjckGMg
         AwqG18kH/KS2Bk6TqZfAVl1UO0cWTGOoOHDlnfOOzGD3K06j4zdaCweuL6e3WzJy4P9o
         diQA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=UMDJMiQTFcKCxPkVkF9StmgbZfLqi1e4W4NfLM9RGGQ=;
        b=cWVBfes+nTsKG2yqhyNYbvk+vy1M6mMEGokscGbJ9Zlo21vWajQW8zj7iz+AD1LWgw
         N5jMhw3feBO7cqgvmJYJxQ5WIwZ8rmwOqi6DxSoxV/NLmXfm67h65jB2LU+tcTU6eEaD
         p46qaeR6SkIKXyHtb+R7dxm1wF/b1znOTD8b29y9oYlCuvmKoEowHJOOqEplflNqX4B2
         X2AiVHWEKEQGdjujOgYPNnMxTgTRU55sVWRoWM4bbRY40pRbXalyTHjukyBzZ4/hOxor
         /73c35vRpq6cBoFRhHa6Mk4CTE59ojN1kGEkP2D0XpeXslUY0xWMq1uSebihURIkK85M
         nkWQ==
X-Gm-Message-State: APjAAAUKKWXKdrWNU0f+az2w5qiO04DaC+2OmwKO9/MSm8Kku+vlnN1r
        netT8NT7sO2w87BB7McQN4X+7xdUIUA=
X-Google-Smtp-Source: APXvYqzo4p/1a3wvw6HTi9jsGg/qb5UWEPPOXa35iQJObbQiB5+drNX5be1G6ww7RJuO5K0ACc9Bfg==
X-Received: by 2002:a17:902:547:: with SMTP id 65mr5017787plf.50.1581191635719;
        Sat, 08 Feb 2020 11:53:55 -0800 (PST)
Received: from [192.168.1.188] ([66.219.217.145])
        by smtp.gmail.com with ESMTPSA id v10sm7219532pgk.24.2020.02.08.11.53.54
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 08 Feb 2020 11:53:55 -0800 (PST)
Subject: Re: [PATCH v1] io_uring_cqe_get_data() only requires a const struct
 io_uring_cqe *cqe
To:     Stefan Metzmacher <metze@samba.org>, io-uring@vger.kernel.org
References: <20200206160209.14432-1-metze@samba.org>
 <94d5b40d-a5d8-706f-ab5c-3a8bd512d831@kernel.dk>
 <9ecdcb22-c51c-8b84-678a-d41e8b97fc09@samba.org>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <f2049c0c-9fca-c6e6-6d2a-18585b86307f@kernel.dk>
Date:   Sat, 8 Feb 2020 12:53:53 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.4.1
MIME-Version: 1.0
In-Reply-To: <9ecdcb22-c51c-8b84-678a-d41e8b97fc09@samba.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 2/7/20 4:45 PM, Stefan Metzmacher wrote:
> Hi Jens,
> 
>> Unrelated to this patch, but I'd like to release a 0.4 sooner rather
>> than later. Let me know if you see any immediate work that needs doing
>> before that happens.
> 
> I just noticed that IORING_FEAT_CUR_PERSONALITY is not yet documented,
> I'm not sure if that's important enough to have in 0.4.

Ah good catch, I'll add that.

> When do you plan to tag the release?

Sometime next week, need to do the above doc addition and the debian
guys had something as well.

-- 
Jens Axboe

