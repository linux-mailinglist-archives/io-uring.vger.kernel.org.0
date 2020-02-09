Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DF195156A15
	for <lists+io-uring@lfdr.de>; Sun,  9 Feb 2020 13:19:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727473AbgBIMTC (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sun, 9 Feb 2020 07:19:02 -0500
Received: from mail-lj1-f177.google.com ([209.85.208.177]:39500 "EHLO
        mail-lj1-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727453AbgBIMTC (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sun, 9 Feb 2020 07:19:02 -0500
Received: by mail-lj1-f177.google.com with SMTP id o15so4001773ljg.6
        for <io-uring@vger.kernel.org>; Sun, 09 Feb 2020 04:19:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:references:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=tDKnztJWpIyM4yTHijHSMNDJkz9Y/PdSi1YqX8LEbIc=;
        b=k5z42tHfxgJ3WkHK7i6jh14zQPSVO2HT3RGiMYaOmoRpR66RobWaOO+K7sAGpTY5v9
         0UN0b3pyJ1VXLrx1WvBkuaLVeH8RR7UE5Y+gvVh7fujWOemzcDoLwhXW0ZVPzbXKPdiI
         QsmfJ6U5b6xmB8vbQQLvhJDe5yigUZcw5nLXeswKM9OXDB7TQ0kczgrqVtwo9t1wp8II
         y7CDKSW95vgUN8FjNQlYlrD/kcrGg/N46d/1bJ1rNU39b9kbHCUo86WgQfy0JDk1qqus
         zROuAQXb1sQTrfzDu6tIgmdsmhH2hYtRvnCqDRrUxnXtu0QRPmtYwIOz+WHrp2ltun9U
         wcPA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=tDKnztJWpIyM4yTHijHSMNDJkz9Y/PdSi1YqX8LEbIc=;
        b=mazs44gHtBhVqJUuY0fFOhg4CRLqEqhPNW+SudEABcBzAgQuQnJy9obBfUdxx9gFWa
         7UM5sYUFKGtP08d8jOY9TOfAJiqzGQYcgD1IniijtY5+AE6N7CI4VUYwKmf7RHhfCIdL
         r5KMY4XpoHNHicxI8L/GUVQ3GbYmkihBTyqtGBbFBrl98iO5JQuVdjDbOkeT0b1QFJ56
         MaxgTXAIMkzN9OQfm6hVQFuxPAWRHhpr3LHsxFeQUaMiJZxJpvr5V5TMmvS8W0heSpqa
         MLvum0lfxsdclF7KO++ihlJHL8H72ecVA92byXu8iupK6CuUxmWWbT7AciBBzT+i/KmA
         58Vw==
X-Gm-Message-State: APjAAAVrtsm9OcAV9bXPPuTm3knnTKKMhutOAZRPEJ1wRL+N+enuzI6x
        77Eyy7VFjWePK3VahSDPmTkNLpzoPds=
X-Google-Smtp-Source: APXvYqw065/IrGW38FWWP6wtZBbGSd2AVPgoEcO0aD//D3wlUaG0hrY4IjCfgGDaFPA31IhFs7Z+1w==
X-Received: by 2002:a2e:9e16:: with SMTP id e22mr5270757ljk.220.1581250739553;
        Sun, 09 Feb 2020 04:18:59 -0800 (PST)
Received: from [172.31.190.83] ([86.57.146.226])
        by smtp.gmail.com with ESMTPSA id i5sm4607854ljj.29.2020.02.09.04.18.58
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 09 Feb 2020 04:18:59 -0800 (PST)
Subject: Re: [RFC] fixed files
To:     Jens Axboe <axboe@kernel.dk>, io-uring <io-uring@vger.kernel.org>
References: <ace72a3f-0c25-5d53-9756-32bbdc77c844@gmail.com>
 <ea5059d0-a825-e6e7-ca06-c4cc43a38cf4@kernel.dk>
From:   Pavel Begunkov <asml.silence@gmail.com>
Message-ID: <8ac7e520-c94e-22e1-3518-db8432debb6b@gmail.com>
Date:   Sun, 9 Feb 2020 15:18:57 +0300
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.4.2
MIME-Version: 1.0
In-Reply-To: <ea5059d0-a825-e6e7-ca06-c4cc43a38cf4@kernel.dk>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 2/8/2020 11:15 PM, Jens Axboe wrote:
> On 2/8/20 6:28 AM, Pavel Begunkov wrote:
>> Hi,
>>
>> As you remember, splice(2) needs two fds, and it's a bit of a pain
>> finding a place for the second REQ_F_FIXED_FILE flag. So, I was
>> thinking, can we use the last (i.e. sign) bit to mark an fd as fixed? A
>> lot of userspace programs consider any negative result of open() as an
>> error, so it's more or less safe to reuse it.
>>
>> e.g.
>> fill_sqe(fd) // is not fixed
>> fill_sqe(buf_idx | LAST_BIT) // fixed file
> 
> Right now we only support 1024 fixed buffers anyway, so we do have some
> space there. If we steal a bit, it'll still allow us to expand to 32K of
> fixed buffers in the future.
> 
> It's a bit iffy, but like you, I don't immediately see a better way to
> do this that doesn't include stealing an IOSQE bit or adding a special
> splice flag for it. Might still prefer the latter, to be honest...

"fixed" is clearly a per-{fd,buffer} attribute. If I'd now design it
from the scratch, I would store fixed-resource index in the same field
as fds and addr (but not separate @buf_index), and have per-resource
switch-flag somewhere. And then I see 2 convenient ways:

1. encode the fixed bit into addr and fd, as supposed above.

2. Add N generic IOSQE_FIXED bits (i.e. IOSQE_FIXED_RESOURSE{1,2,...}),
which correspond to resources (fd, buffer, etc) in order of occurrence
in an sqe. I wouldn't expect having more than 3-4 flags.

And then IORING_OP_{READ,WRITE}_FIXED would have been the same opcode as
the corresponding non-fixed version. But backward-compatibility is a pain.

-- 
Pavel Begunkov
