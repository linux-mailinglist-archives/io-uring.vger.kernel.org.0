Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7E81F1C3FD4
	for <lists+io-uring@lfdr.de>; Mon,  4 May 2020 18:29:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729547AbgEDQ3P (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 4 May 2020 12:29:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42526 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729425AbgEDQ3O (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 4 May 2020 12:29:14 -0400
Received: from mail-wm1-x342.google.com (mail-wm1-x342.google.com [IPv6:2a00:1450:4864:20::342])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 46185C061A0E
        for <io-uring@vger.kernel.org>; Mon,  4 May 2020 09:29:13 -0700 (PDT)
Received: by mail-wm1-x342.google.com with SMTP id k12so170965wmj.3
        for <io-uring@vger.kernel.org>; Mon, 04 May 2020 09:29:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=to:cc:references:from:autocrypt:subject:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=rJsjfY32fdlazgOtr9f8PulSzUm9PmE64Ox6eErNEn8=;
        b=Hh/71gI4okTJ1pc4WrJ6eZNptlsrzP6dgrVaUdV9i534BUHUy2DGotQ0s3AkneEHAJ
         ovSht+CQ56YWMrB6ghlMz6hQhwZ+FJoWTJ+Ej/UX6fQEOnhjtf50C7q0hPsO7u5+Hily
         kyJw32iGrS/rdu3GWTfuPUVR1Zu5LoVNkwJt2nVfLzxbCKumjlIiPzDyQTZFuF3aiC3m
         7CnCpV2jkwmlwbJLx4EwrVe8RAlqM7szSwMdgEgyA37ITjQrE/KhC5iU3go4bd55ObmF
         GY/Lw/flauXAaAc+zQymW5iyEb6+9maA5DnVPjMnr2CVIAkj0K7UHwjBtX9wGxam4INL
         F2HA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:to:cc:references:from:autocrypt:subject
         :message-id:date:user-agent:mime-version:in-reply-to
         :content-language:content-transfer-encoding;
        bh=rJsjfY32fdlazgOtr9f8PulSzUm9PmE64Ox6eErNEn8=;
        b=tzF54Ma7bPTFYlCXhlyenqbuUN8mKObCjFga4Fsl2ooDvcTG8IpfttW7TDXNRMXua+
         WqiCcgG16LczQ4W8B3w1gLoIxMlkua/gj0ODeg35dNqJIeF5tnTqS3XmpTAvbpcHkyNK
         14FkZgqGh9HZ7wR3KbU9VRlJnqs/DqsLutwENAO0GN1GWV1vtxy+efzIlWluZvnI65fe
         3oCbdl/kBcmd9QfG0OJUgwbJg2g5K5KNxfbWeU8Gfz8Xy4zgA9qhULc7gM2hxfSJxvuA
         SIkwBOGQwJaI3zXHpfBI3zusZ/Qhv8OaZ2p4lDpFiMDIo1C7wlLOlaIvrW/59EaUOQNt
         GQKQ==
X-Gm-Message-State: AGi0Puarz+hHf4NJ6d1CzJEwlG/bwjbwigEV+bGP0mmZBRG4LubCy55N
        emQ6lwxg5AFmjugsWyW465vOoPr6
X-Google-Smtp-Source: APiQypJWi7qUHgqvwUX6qjsOx5s1koAtxzLcpTJYkpMPseGyxCCjyekGUGXPSlbT8VZVjHhmXKK2EQ==
X-Received: by 2002:a1c:7d90:: with SMTP id y138mr16694497wmc.121.1588609751720;
        Mon, 04 May 2020 09:29:11 -0700 (PDT)
Received: from [192.168.43.158] ([109.126.133.135])
        by smtp.gmail.com with ESMTPSA id v10sm20279748wrq.45.2020.05.04.09.29.10
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 04 May 2020 09:29:11 -0700 (PDT)
To:     Jens Axboe <axboe@kernel.dk>,
        Bijan Mottahedeh <bijan.mottahedeh@oracle.com>
Cc:     io-uring <io-uring@vger.kernel.org>
References: <1588207670-65832-1-git-send-email-bijan.mottahedeh@oracle.com>
 <05997981-047c-a87b-c875-6ea7b229f586@kernel.dk>
 <07fda8ac-93e4-e488-0575-026b339d2c36@gmail.com>
 <84554b60-2ec5-9876-79ce-5962ae5580e4@kernel.dk>
From:   Pavel Begunkov <asml.silence@gmail.com>
Autocrypt: addr=asml.silence@gmail.com; prefer-encrypt=mutual; keydata=
 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 bA==
Subject: Re: [PATCH 1/1] io_uring: use proper references for fallback_req
 locking
Message-ID: <f1c46f3c-2fc3-ecd4-d7c6-70fc19437f0e@gmail.com>
Date:   Mon, 4 May 2020 19:28:06 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.3.0
MIME-Version: 1.0
In-Reply-To: <84554b60-2ec5-9876-79ce-5962ae5580e4@kernel.dk>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 04/05/2020 19:12, Jens Axboe wrote:
> On 5/3/20 6:52 AM, Pavel Begunkov wrote:
>> On 30/04/2020 17:52, Jens Axboe wrote:
>>> On 4/29/20 6:47 PM, Bijan Mottahedeh wrote:
>>>> Use ctx->fallback_req address for test_and_set_bit_lock() and
>>>> clear_bit_unlock().
>>>
>>> Thanks, applied.
>>>
>>
>> How about getting rid of it? As once was fairly noticed, we're screwed in many
>> other ways in case of OOM. Otherwise we at least need to make async context
>> allocation more resilient.
> 
> Not sure how best to handle it, it really sucks to have things fall apart
> under high memory pressure, a condition that isn't that rare in production
> systems. But as you say, it's only a half measure currently. We could have
> the fallback request have req->io already allocated, though. That would
> provide what we need for guaranteed forward progress, even in the presence
> of OOM conditions.

Good idea. +extend it to work with links as a next step. E.g. for short links
(2-3 reqs).

-- 
Pavel Begunkov
