Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B32E830BCAF
	for <lists+io-uring@lfdr.de>; Tue,  2 Feb 2021 12:11:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229677AbhBBLLO (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 2 Feb 2021 06:11:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41126 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229808AbhBBLKL (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 2 Feb 2021 06:10:11 -0500
Received: from mail-wr1-x429.google.com (mail-wr1-x429.google.com [IPv6:2a00:1450:4864:20::429])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F37DEC061573
        for <io-uring@vger.kernel.org>; Tue,  2 Feb 2021 03:09:30 -0800 (PST)
Received: by mail-wr1-x429.google.com with SMTP id l12so19992939wry.2
        for <io-uring@vger.kernel.org>; Tue, 02 Feb 2021 03:09:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=to:references:from:autocrypt:subject:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=sb5Z97r1r1HKTGc7ZoDxc6n4L4O934Q4DWPN2mmxtHg=;
        b=OP+yBrRT/9EVaor0E3EZoXDsPthi4+iUifywtyGA6AS8zyWMdtBnF/FqQt4uZvuRQL
         yIjgAxe2JVXzQpDcIdPVo2ihVz4pEdESAcWjhxlxNJyfoMa2tnu7lyzRUNA1b3TjiPr3
         n5rk5fX8ZchGLBjkanRz+8wGBeW1RazmYp01cQkpXSghuUst03S4uYDbZyqkbBh7F1kq
         jypKk3JYDjYMZCBPq4A8wHftAEtSRwt/S5UxQHCYp5A7k/h1JXBOOD71XUGDRmLD5B8b
         HMSQxU8VklJwMcTVJ/qmo/Apj3nC9jjzp8K/GwD0BGgOuvuGLOzsFz43YATLPw+y6u0v
         2bWQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:to:references:from:autocrypt:subject:message-id
         :date:user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=sb5Z97r1r1HKTGc7ZoDxc6n4L4O934Q4DWPN2mmxtHg=;
        b=jMLCuTSfM1tT2DRscOe+w36VbzJpp8BNpjMWIJ1SPs0LbevCrLdxACkoAoklo2ctZE
         xzE/QOn/+j7g5lXRviWHyXPr5NuLSRkXdtgTC3FnhTvGhu+PSMVer8kHWPTTtJ1OC2iL
         NT6mxT9PbozmTbAis7hgokQqo1e3Jv8ouJ/y9nutelsFsOk7LqARek0B+x+TuH7xh8l3
         0H7STjruwhCGg29GnxzNSzA/E2/T4rVW5EhJLQa8KGZtHr5vxbH7hJTKiqQqH2FY16WN
         s62LOMIU4KwHNfRsKJ3qifkD5iUe27/69gv8Gv09rQoyiXmzNCtt2sn6bxruhq8tyCk0
         zDPQ==
X-Gm-Message-State: AOAM532BxKrn30F4Mi0XNlt/YC39QH3mE/xZMlzgi25kdy7tcY86exii
        CTJrUjjs0SCiwLgWEZuuGwrd1MLrLwESUw==
X-Google-Smtp-Source: ABdhPJyGazh04CpdtJDuAjs3UXKi3HeTtSHSU9F1R3WDRx5t94khCdEVjz9wfbp4drV5/hMSiqOThA==
X-Received: by 2002:a05:6000:1105:: with SMTP id z5mr22926850wrw.15.1612264168332;
        Tue, 02 Feb 2021 03:09:28 -0800 (PST)
Received: from [192.168.8.169] ([185.69.145.241])
        by smtp.gmail.com with ESMTPSA id w4sm11170131wrt.69.2021.02.02.03.09.27
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 02 Feb 2021 03:09:27 -0800 (PST)
To:     Victor Stewart <v@nametag.social>,
        io-uring <io-uring@vger.kernel.org>
References: <CAM1kxwhCXpTCRjZ5tc_TPADTK3EFeWHD369wr8WV4nH8+M_thg@mail.gmail.com>
From:   Pavel Begunkov <asml.silence@gmail.com>
Autocrypt: addr=asml.silence@gmail.com; prefer-encrypt=mutual; keydata=
 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 bA==
Subject: Re: bug with fastpoll accept and sqpoll + IOSQE_FIXED_FILE
Message-ID: <49743b61-3777-f152-e1d5-128a53803bcd@gmail.com>
Date:   Tue, 2 Feb 2021 11:05:45 +0000
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.3.0
MIME-Version: 1.0
In-Reply-To: <CAM1kxwhCXpTCRjZ5tc_TPADTK3EFeWHD369wr8WV4nH8+M_thg@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 02/02/2021 05:36, Victor Stewart wrote:
> started experimenting with sqpoll and my fastpoll accepts started
> failing. was banging my head against the wall for a few hours... wrote
> this test case below....
> 
> basically fastpoll accept only works without sqpoll, and without
> adding IOSQE_FIXED_FILE to the sqe. fails with both, fails with
> either. these must be bugs?
> 
> I'm running Clear Linux 5.10.10-1017.native.
> 
> i hope no one here is allergic to C++, haha. compilation command
> commented in the gist, just replace the two paths. and I can fold
> these checks if needed into a liburing PR later.
> 
> https://gist.github.com/victorstewart/98814b65ed702c33480487c05b40eb56

Please don't forget about checking error codes. At least fixed
files don't work for you because of

int fds[10];
memset(fds, -1, 10); // 10 bytes, not 10 ints

So io_uring_register_files() silently fails.


For me, all two "with SQPOLL" tests spit SUCCESS, then it hangs.
But need to test it with upstream to be sure.

-- 
Pavel Begunkov
