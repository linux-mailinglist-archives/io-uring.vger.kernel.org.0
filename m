Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 30F1F21CA0A
	for <lists+io-uring@lfdr.de>; Sun, 12 Jul 2020 17:41:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728844AbgGLPlb (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sun, 12 Jul 2020 11:41:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44066 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728840AbgGLPlb (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sun, 12 Jul 2020 11:41:31 -0400
Received: from mail-pf1-x441.google.com (mail-pf1-x441.google.com [IPv6:2607:f8b0:4864:20::441])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7646CC061794
        for <io-uring@vger.kernel.org>; Sun, 12 Jul 2020 08:41:31 -0700 (PDT)
Received: by mail-pf1-x441.google.com with SMTP id a14so4885947pfi.2
        for <io-uring@vger.kernel.org>; Sun, 12 Jul 2020 08:41:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:references:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=3lJByClgknjlObSsuW5c+clyVUuB2tlFMLblWN0tJAk=;
        b=DkQfkeBc0Xm5ojbuaYW6c8LBCj7ML+sSRablfDEXQI+/wbk0BrdEP8alnjwGXdhBQz
         bPb8GmPnFbDF/LX5QJPoaFDSxPgh23kPulVKa1BGGjabrWDnPu0G4a6axQJUwTrrIo4M
         wXrqCtKJ9fmuTqaxbk1ptkzDY1MpmVarHVwd96rfPNHz5lndXskHwhyVWqd36S2SLUqT
         JsTYfEvRIgC/PYAuxAjaj3vQ+jrfV5Hu93b7t9U3ph0nDfTOmwb/Kd6y7CaRnHAO/uQY
         9kTSyJMOD7hUnnEvZSLJfS8pJIaIg7tg/LQ4ONfJKfS7BBU6XJYEAskBZVMoxJFZJVN6
         q86g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=3lJByClgknjlObSsuW5c+clyVUuB2tlFMLblWN0tJAk=;
        b=Av5vuNwZePu8obtVO5wPVfNTymbGYDbK8pIoabgmm+ifryX6Vil1rX9oJ4repfNdQT
         ntFKyXTWcfaNka5w/D9Ub16dZEzcMsPa+d8kCIdWOeE7IE4cnGGD9moZygX2B3VCWW/2
         WuWkkJTM8QvRSvx+XWfLKYPVXYK3LiExc+f9navvyJcEB4zDNyY7flpgchq/JKf3colW
         Msu0o5DQNVgKdziZ5B64zNVZV7q7lHl2kJhXz0J+QU+W5kXbAPFspz/yCzsu9MAAWdja
         6MSdiZm2YSJ2m2yjFkIGb36D1pY4E5v661fvlxdpV7OU9+YBVtoHw37hsJ5iPmvKtFLg
         VdXA==
X-Gm-Message-State: AOAM530VeufgFrcr5LzAAUwOMEBsjA5BaYLtqAgOBkfEeb5YUFa1IVEQ
        9OyIPtGjIUGcIbjiG37yQXALjkXhCpU3Fg==
X-Google-Smtp-Source: ABdhPJwnyxHOyxRpiRw71BEbuV3ADjx77iZwsWfmPThXgpe/kOfgBMqXMF/flULY/pezoCg6ZUTNug==
X-Received: by 2002:a63:5461:: with SMTP id e33mr55486460pgm.321.1594568490787;
        Sun, 12 Jul 2020 08:41:30 -0700 (PDT)
Received: from [192.168.1.182] ([66.219.217.173])
        by smtp.gmail.com with ESMTPSA id h7sm11810367pfq.15.2020.07.12.08.41.29
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 12 Jul 2020 08:41:30 -0700 (PDT)
Subject: Re: [PATCH 5.8] io_uring: fix not initialised work->flags
To:     Pavel Begunkov <asml.silence@gmail.com>, io-uring@vger.kernel.org
References: <54dadfaba67a45d351ed9059547575214bc2458a.1594559782.git.asml.silence@gmail.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <8884cd53-7a35-3d56-b308-a81c1166a264@kernel.dk>
Date:   Sun, 12 Jul 2020 09:41:29 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <54dadfaba67a45d351ed9059547575214bc2458a.1594559782.git.asml.silence@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 7/12/20 7:16 AM, Pavel Begunkov wrote:
> 59960b9deb535 ("io_uring: fix lazy work init") tried to fix missing
> io_req_init_async(), but left out work.flags and hash. Do it earlier.

Thanks Pavel, applied.

-- 
Jens Axboe

