Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9D02830C86C
	for <lists+io-uring@lfdr.de>; Tue,  2 Feb 2021 18:53:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237925AbhBBRtZ (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 2 Feb 2021 12:49:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41838 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237760AbhBBRrL (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 2 Feb 2021 12:47:11 -0500
Received: from mail-il1-x12e.google.com (mail-il1-x12e.google.com [IPv6:2607:f8b0:4864:20::12e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ADA3DC061794
        for <io-uring@vger.kernel.org>; Tue,  2 Feb 2021 09:46:31 -0800 (PST)
Received: by mail-il1-x12e.google.com with SMTP id g9so1689546ilc.3
        for <io-uring@vger.kernel.org>; Tue, 02 Feb 2021 09:46:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:from:to:cc:references:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=cLbfMzdOo43ZNNPhMj/eXXzj0QRxWKgbEVzT/5kjaQg=;
        b=RzyZaqKK442O9VXJJOXG/C2/30XwRXJCO9Fdls9t9hSyFmKazmLoAN06s0LBpiVWJk
         e6RQ37G9ykQoLMUH5/lRFC6c+2eAnmYUkUDhmRHzQ3L+5wz6d0Ngm7sNPY+Xd3BM32eC
         g1oS9KUyhjAGw68V7MbiZzbKx+3wQxzxHC8QlkOLxHdJnO+d9Q/JjuewEugzAcDI1ccf
         QAD24oNLTSR9U5Xe9xntu+iP5DnMKRYRgocgYNv3FrFyQdZhVKLWBUei4VVKQyNdDSAc
         o4YWVX7WEJefWrNFFGTfwLBNXpJZ6bsCNUvsPh/2lPn58O6bPkmdKqN7udLoGOlRSO6H
         PFRw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:cc:references:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=cLbfMzdOo43ZNNPhMj/eXXzj0QRxWKgbEVzT/5kjaQg=;
        b=m0PuSlTVkRBjGVosaxxJ0uwsKDkAuPuc83OM+eaFwTrAERMI1JhrFDQLFz153/fe4h
         UAZGCJsMp7uViPljjUymwx3/1PecRP/SDSO4SFEph8313DKhbw/eQ0FgJw433MN8QHZ3
         fyy8A8oriAi41RiOAtaFV3pJMUoSB70TYCQIWs+mjDOAaEe2Y9XJoTUmaNoGrjaglY/d
         yZFTSBdiixTLEOUyOPgH1LvFmzmshndqrrlHU0fkxdv3RXGiCrZvd/2RIcVn71ngsB6q
         cVj0u2IWSiO4WJ6hjvT7j+xGnXJeB5ozSOiapxKu1DPC3SDIdANi8nlin267rGor+qf1
         WqIg==
X-Gm-Message-State: AOAM533tI9GEFCVZoOAhCFfFRJu3ancw/CHXM5l8rX+nQYTdGWsnAcNk
        xgn591Tqxyf0YaD4bvf59QnlAser+tHvIaPh
X-Google-Smtp-Source: ABdhPJywpxo9C1Hvdv2NUcf8kT7q2/adreBaDgkhkrIvlMtWNgnqZbQo2f/oqXynL8OXGmQnxjgDCQ==
X-Received: by 2002:a92:3f06:: with SMTP id m6mr10842657ila.283.1612287991019;
        Tue, 02 Feb 2021 09:46:31 -0800 (PST)
Received: from [192.168.1.30] ([65.144.74.34])
        by smtp.gmail.com with ESMTPSA id f8sm10074843ioh.42.2021.02.02.09.46.30
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 02 Feb 2021 09:46:30 -0800 (PST)
Subject: Re: bug with fastpoll accept and sqpoll + IOSQE_FIXED_FILE
From:   Jens Axboe <axboe@kernel.dk>
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
 <06ceae30-7221-80e9-13e3-148cdf5e3c9f@kernel.dk>
Message-ID: <1baf259f-5a78-3044-c061-2c08c37f7d58@kernel.dk>
Date:   Tue, 2 Feb 2021 10:46:29 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <06ceae30-7221-80e9-13e3-148cdf5e3c9f@kernel.dk>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 2/2/21 10:24 AM, Jens Axboe wrote:
> On 2/2/21 10:10 AM, Victor Stewart wrote:
>>> Can you send the updated test app?
>>
>> https://gist.github.com/victorstewart/98814b65ed702c33480487c05b40eb56
>>
>> same link i just updated the same gist
> 
> And how are you running it?

Alright, so you're doing ACCEPT with 5.10 and you cannot do ACCEPT
with SQPOLL as it needs access to the file table. That works in 5.11
and newer, NOT in 5.10. Same goes or eg open/close and those kinds
of requests.

-- 
Jens Axboe

