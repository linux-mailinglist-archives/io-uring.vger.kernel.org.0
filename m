Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4804530C7B9
	for <lists+io-uring@lfdr.de>; Tue,  2 Feb 2021 18:29:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237419AbhBBR32 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 2 Feb 2021 12:29:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36604 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236690AbhBBRZ3 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 2 Feb 2021 12:25:29 -0500
Received: from mail-io1-xd2f.google.com (mail-io1-xd2f.google.com [IPv6:2607:f8b0:4864:20::d2f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 82E1CC061352
        for <io-uring@vger.kernel.org>; Tue,  2 Feb 2021 09:24:42 -0800 (PST)
Received: by mail-io1-xd2f.google.com with SMTP id e133so11316767iof.8
        for <io-uring@vger.kernel.org>; Tue, 02 Feb 2021 09:24:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=FtRvtpb6cLkvUQpthiNu23iT/6oh6MEYboY8olYjOls=;
        b=PbJIA178U6f5r8mK+dbxWDQ/rxgT4JIDRNXRD3tlYbx8tNPY8mTrHVeRfNfNIEh/C2
         +oSY1tqsns/eom628X0WJfGaG5HRyuYOtlUwter/xyI4dmCIjo0PXqrJ5xfcdBSoQJ4L
         fVsRqeMwHbbYB/5cGql6VSsTyBYg9mAdoHK/WyzB0AJYDL9ndsEh9j5q0Pgi5lbZCiyl
         WSEf66A/W822y/O5xMcSaKG4jMRkYbVhhSzk4I4EqgF6mJnRImRbzH/PrDBX5e3Kiwkq
         mHy26gyVHJc6kdjqwFK+QEj6WCOIZfQg9/eJmEnOu0UrlsdUUK5UiHeELKBAn2Oh0nxZ
         KPeA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=FtRvtpb6cLkvUQpthiNu23iT/6oh6MEYboY8olYjOls=;
        b=o4UKWfiCMwaS9YUghjxhw7RKpgPcYRsIbg2mJOH8cZWx9c8L+y53F3zL8vEi5hsGGJ
         eJBp6EP0JH5bnBaZNFmBda4xgEEVuhKHnuUd1ANB3qsri89R5F9Mvn0NHrD7rHpiu6Gm
         0hZUHMrSSMP1hwBnFvR3ai4fvVfpKucbXDwtyHHpqwl5kc69GYg30O8XKTn7gqSuoBxd
         2GvM/Ej7GpPFvF3F+3PsGb9bAgKK+RPuTpRzSlrZHLzQIKma1TTFl8t41+Gp7R4EYhEh
         a0NSf9kXP8tmBGJfz9/tCnS0oAVYpMSY4/3arpm8I9SGlHMpanG+RJc4rWeePxHtmlnC
         LlJA==
X-Gm-Message-State: AOAM533wIBSxo5ucwj7ToH96lkPKUwoD+5M6DBXTiK8P/MjAphkGy6Zp
        NwBUuL4tGSWcLisOPkQqCgv6/Z1l/92tItso
X-Google-Smtp-Source: ABdhPJzMO6p0TNpHmFMKGCs9hpL7EITHM5XAn2plqUJ2bcFGPZ+Tvt3BhrzSj+K4gfBQGJh52ZFHFA==
X-Received: by 2002:a02:2a83:: with SMTP id w125mr22070858jaw.48.1612286681582;
        Tue, 02 Feb 2021 09:24:41 -0800 (PST)
Received: from [192.168.1.30] ([65.144.74.34])
        by smtp.gmail.com with ESMTPSA id h19sm11170039ilo.21.2021.02.02.09.24.40
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 02 Feb 2021 09:24:41 -0800 (PST)
Subject: Re: bug with fastpoll accept and sqpoll + IOSQE_FIXED_FILE
To:     Victor Stewart <v@nametag.social>
Cc:     Pavel Begunkov <asml.silence@gmail.com>,
        io-uring <io-uring@vger.kernel.org>
References: <CAM1kxwhCXpTCRjZ5tc_TPADTK3EFeWHD369wr8WV4nH8+M_thg@mail.gmail.com>
 <49743b61-3777-f152-e1d5-128a53803bcd@gmail.com>
 <c41e9907-d530-5d2a-7e1f-cf262d86568c@gmail.com>
 <CAM1kxwj6Cdqi0hJFNtGFvK=g=KoNRPMmLVoxtahFKZsjOkcTKQ@mail.gmail.com>
 <CAM1kxwg7wkB7Sj8CDi9RkssM5DwFXEFWeUcakUkpKtKVCOUSJQ@mail.gmail.com>
 <4b44f4e1-c039-a6b6-711f-22952ce1abfb@kernel.dk>
 <CAM1kxwgPW5Up-YqQWdh_cG4jvc5RWsD4UYNWN-jRRbWq5ide5g@mail.gmail.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <06ceae30-7221-80e9-13e3-148cdf5e3c9f@kernel.dk>
Date:   Tue, 2 Feb 2021 10:24:39 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <CAM1kxwgPW5Up-YqQWdh_cG4jvc5RWsD4UYNWN-jRRbWq5ide5g@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 2/2/21 10:10 AM, Victor Stewart wrote:
>> Can you send the updated test app?
> 
> https://gist.github.com/victorstewart/98814b65ed702c33480487c05b40eb56
> 
> same link i just updated the same gist

And how are you running it?

-- 
Jens Axboe

