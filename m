Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B8505141470
	for <lists+io-uring@lfdr.de>; Fri, 17 Jan 2020 23:52:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730140AbgAQWwP (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 17 Jan 2020 17:52:15 -0500
Received: from mail-pf1-f182.google.com ([209.85.210.182]:44504 "EHLO
        mail-pf1-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729015AbgAQWwO (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 17 Jan 2020 17:52:14 -0500
Received: by mail-pf1-f182.google.com with SMTP id 62so5957142pfu.11
        for <io-uring@vger.kernel.org>; Fri, 17 Jan 2020 14:52:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:references:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=zZWEA2FKqB3h/5PGTZxs6byNWrbGN1jtGQLLTYcsCjo=;
        b=subFMBWFiGeMgmFJexeXXaaAIqZZGgZ8bd0mYZrGokugnMsHo+U9znDxdPQjNqiokb
         NtVqZsqQ8U4wDO1BNidW2jA1f86gqMQzhE6CJc3GQKzrq2QAq0AvAyoKSuGz41DGhPa5
         KnSPyFzx6F30rkTMGf59U2oMmY77xQK7dcTDFXxms+nOsBLi9IMWGIVNwZjM57rXCxQP
         lRLkmNomdkewmA1kUeCuamnSAhDFL9Y7rQyFUt2lpNlCosBODoi9nVE4r7phxztERZQw
         /fuUrQEC/ChknlOVvNtMI1zvNj1Rgf61HnXKbav4aZz80eCfuKmUXdxGfMOPmiGoTUtc
         8bIg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=zZWEA2FKqB3h/5PGTZxs6byNWrbGN1jtGQLLTYcsCjo=;
        b=PW78ZJ+L7MCVIbUVIsA40+7+d00wI1taNzK3iuONYrwOGLy8i/wHYfJkwciCX9R6ge
         vhkAWU+4u0/LEAnac3FaQHfN1D5fJVwDNz0qnkF/qey9JEh19/dMWj9JZAZjdjGG0UUr
         kdXbqkjOR8aqu5kJBsY+hKy4CthKv7X72xWEfzzvRaeJKI/9vw9Cj0to4Ian+rzug7w4
         pOzDndmGjdfyYxxOBRIDI4TQUFNoA7xO+ocuhN8bIBulgupa7aHuWri1m3VG4aAdIE5b
         515ejWdITIB6/+t0wSZolcGJLYS/XVpTjmBWPXQ2UCEuKbKHqOaPYWtYvx35nvs62NiT
         JArw==
X-Gm-Message-State: APjAAAWqxzXE8atLVtcjIUgvXzOsYTzd4QiEVopUnvlH3DsOpviqPsqB
        gAKslZxW/yplp4YarJM6ltBKAPj4fow=
X-Google-Smtp-Source: APXvYqwiI8Cb1T24g/UNmh6x2AOiPIenJpVx/WqH9s6Q8AJBUoeDOWr4H8hhb26mt5Q8PrIRiNwacg==
X-Received: by 2002:a63:d94b:: with SMTP id e11mr47807579pgj.79.1579301534172;
        Fri, 17 Jan 2020 14:52:14 -0800 (PST)
Received: from [192.168.1.188] ([66.219.217.145])
        by smtp.gmail.com with ESMTPSA id n14sm30357674pff.188.2020.01.17.14.52.13
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 17 Jan 2020 14:52:13 -0800 (PST)
Subject: Re: [BUG] io_uring
To:     Pavel Begunkov <asml.silence@gmail.com>,
        io-uring <io-uring@vger.kernel.org>
References: <2e58fed4-d95f-3d69-b938-a8f77bf96102@gmail.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <ced24634-1808-c06c-61b7-806a87e9eaa1@kernel.dk>
Date:   Fri, 17 Jan 2020 15:52:12 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.4.1
MIME-Version: 1.0
In-Reply-To: <2e58fed4-d95f-3d69-b938-a8f77bf96102@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 1/17/20 3:05 PM, Pavel Begunkov wrote:
> I'm hitting a bug with yesterday's for-next (e.g. 126c20adbd98f2eff00c837afc).
> I'll debug it in several days, if nobody would do it by then.
> 
> kernel: yesterday's for-next (e.g. 126c20adbd98f2eff00c837afc)
> How to reproduce: run ./file-update in a loop (for me 10th run hit the problem)

Let me know if it still happens in the current tree, I fixed the wait on this.
But it might be something new, we'll see.

-- 
Jens Axboe

