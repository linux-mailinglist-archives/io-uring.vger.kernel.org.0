Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2F30130C668
	for <lists+io-uring@lfdr.de>; Tue,  2 Feb 2021 17:51:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236745AbhBBQrB (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 2 Feb 2021 11:47:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56522 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236251AbhBBQot (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 2 Feb 2021 11:44:49 -0500
Received: from mail-il1-x12e.google.com (mail-il1-x12e.google.com [IPv6:2607:f8b0:4864:20::12e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8D50CC061573
        for <io-uring@vger.kernel.org>; Tue,  2 Feb 2021 08:44:09 -0800 (PST)
Received: by mail-il1-x12e.google.com with SMTP id y17so19651190ili.12
        for <io-uring@vger.kernel.org>; Tue, 02 Feb 2021 08:44:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=bSlMG2yMQr1ExsYTIiZZQSwEB7/ZgxktvZQvBQcnwxQ=;
        b=EGA5RGZOKvPl57iEZptFlcYysvyRptdhzG9jNUW6K8SNg71QZdJd/RyoJ+2AF1+4dl
         zslgmenqc1TMD0iGKrJE3VeyVfzSmGNHjkirKEjfxIUo2yBn68GfPaNLGA2Y7IAAmaCU
         w4KJRzZ9FyRqEC82IxalHfBGl9cavNw7pKn6pJI4QKoAkFN+At6NpHiTTRCJqvdoKYRX
         v+cMMP4X7+866NsUF7EXUX+wB2PvcYODGMX4df31XbIpsWacc1Wbk91e4xU8RlcfxDUE
         cLM89G8/JWneVRnAXydJXLTuajQ7UAYCs/zi1ZpMul8Yi91wby+Z75zbq4cyE45AbiMI
         nK/A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=bSlMG2yMQr1ExsYTIiZZQSwEB7/ZgxktvZQvBQcnwxQ=;
        b=r4Uh2fAUCmmO4MLzQcCA80PzUfxEbps7Tsms5OR3QtZJdR/z+PHbju312QhhtdEMsF
         cdPAM1UmrazHZ99zZFYAYpsVboNtjEzAiVMJgsqnhlUFmL6/HHDiqPZbEYpfPiqcQoad
         QqHMaGNX3citLDaXVyRytOxdoSSuY53MUBh4bZQ4vEZJwQi7ewT4fQVKkqn3nQeK+w0A
         a8leLwYPxVUqzskmw3qQA7O/EmWCkjDuWJx4z91jcxKaZ4bXR1lOhEf9fbBdOdgbBwwN
         EukYua/V4gLAcZhcthwuOf5bvwk/Lt55YhMfdWo2/cvq4at4KOyxxpWi+0geUfDj10dE
         dyGw==
X-Gm-Message-State: AOAM531DoT5siO8RjDI7VzCRs3YcPDHQGh71wbpyX59sNPNQw5veHUNk
        TZO/cmj0/TD9/D6/aziqkwHttNTrhKthOFQn
X-Google-Smtp-Source: ABdhPJwWXNvcsgBNs9ltgOC80xqz/6BvTIRouXN/wO380Y/TR79bgrJroGl2SNwO17oDngLCDmUkfQ==
X-Received: by 2002:a05:6e02:1b0c:: with SMTP id i12mr19033633ilv.200.1612284248689;
        Tue, 02 Feb 2021 08:44:08 -0800 (PST)
Received: from [192.168.1.30] ([65.144.74.34])
        by smtp.gmail.com with ESMTPSA id k20sm990587ilh.84.2021.02.02.08.44.07
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 02 Feb 2021 08:44:08 -0800 (PST)
Subject: Re: bug with fastpoll accept and sqpoll + IOSQE_FIXED_FILE
To:     Victor Stewart <v@nametag.social>,
        Pavel Begunkov <asml.silence@gmail.com>
Cc:     io-uring <io-uring@vger.kernel.org>
References: <CAM1kxwhCXpTCRjZ5tc_TPADTK3EFeWHD369wr8WV4nH8+M_thg@mail.gmail.com>
 <49743b61-3777-f152-e1d5-128a53803bcd@gmail.com>
 <c41e9907-d530-5d2a-7e1f-cf262d86568c@gmail.com>
 <CAM1kxwj6Cdqi0hJFNtGFvK=g=KoNRPMmLVoxtahFKZsjOkcTKQ@mail.gmail.com>
 <CAM1kxwg7wkB7Sj8CDi9RkssM5DwFXEFWeUcakUkpKtKVCOUSJQ@mail.gmail.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <4b44f4e1-c039-a6b6-711f-22952ce1abfb@kernel.dk>
Date:   Tue, 2 Feb 2021 09:44:07 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <CAM1kxwg7wkB7Sj8CDi9RkssM5DwFXEFWeUcakUkpKtKVCOUSJQ@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 2/2/21 9:30 AM, Victor Stewart wrote:
> i just reran it with my memset bug fixed, and now get these results...
> still fails with SQPOLL. (i ommited the SQPOLL without fixed flag
> result since i'm working with a 5.10 kernel). I tried with and without
> submitting, no difference.
> 
> with SQPOLL      with      FIXED FLAG -> FAILURE: failed with error = -22
> without SQPOLL with      FIXED FLAG -> SUCCESS: timeout as expected
> without SQPOLL without FIXED FLAG -> SUCCESS: timeout as expected

Can you send the updated test app?

-- 
Jens Axboe

