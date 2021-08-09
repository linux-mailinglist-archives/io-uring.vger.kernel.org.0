Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B26C43E4C83
	for <lists+io-uring@lfdr.de>; Mon,  9 Aug 2021 20:56:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235925AbhHIS5Q (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 9 Aug 2021 14:57:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50476 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235656AbhHIS5N (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 9 Aug 2021 14:57:13 -0400
Received: from mail-wr1-x433.google.com (mail-wr1-x433.google.com [IPv6:2a00:1450:4864:20::433])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8112BC0613D3;
        Mon,  9 Aug 2021 11:56:52 -0700 (PDT)
Received: by mail-wr1-x433.google.com with SMTP id m12so22728431wru.12;
        Mon, 09 Aug 2021 11:56:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=to:cc:references:from:subject:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=jsAE4Gv7bcFVFL/kndy9dN7NqtFtPpLY5RgCYDsjOwA=;
        b=hNc3joHegyU3MtdqFSJY7zG87gPJbVs4FxIVqOb84CCMI43vkbX6D2dljGCpWJwEqv
         Sp+nwVp+ZRLp5/1QxRRKNEFbi2wL8/5/D3cVhArRvs7AMvJi/T0AJc/czhqmd7+Vyimb
         QYMI10tvHMZm2OG/qtz4DS79iF389Fro4ya55IpxEGtU+/5Bx7vKBgRUIxzEqrkjO/G+
         9tjsj0r0A0E6MY/M41lz4lvj8cnlB0odtUbLdL944qlxmJZMhdidWKs8xp+TAoV4rfis
         TlDLrCDxukwMJI2xOm9hyxNeGEUjszoCIg49bGDZ5XrJzlLKzpIiDBSW01T7w4vC/SpN
         bkvw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:to:cc:references:from:subject:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=jsAE4Gv7bcFVFL/kndy9dN7NqtFtPpLY5RgCYDsjOwA=;
        b=NBKGpV4ZX0AgC/U0pLrYXjcQpI147d27jZDVO1SgoEZL41S4+yBj/BPNr/5UpQK6hS
         5+PJ7xRBy9RgubgzpTry/LGnc1CZDh2lgOTOUpe4u0zQ59jq2YA/C4/1Zs7IfWQ/x04t
         +diLq6DLz9Dp/Gw0v3bKowKif2TE+/Ln3JQyEKInC+KzbjXaXGg9bapIxKB7Sp+V+wUv
         qOmpWZ20jnYkFI4zfoDYVXJnJVlihzLqU7LFI3Rg8utvgaEc6IdJx423+x4a4h8dHbaI
         55OuZI0AVvsPP9+7dNFslTVCEEPEmTbyzKUiXPNsMlg6ufq9bjxtwGNQ/yAbtCPUZfmp
         e4Tw==
X-Gm-Message-State: AOAM532J/7FunHYJH1WenRVwrFruN0nU0zLuTKs/3uQDdAEV9z8IQZWZ
        X7gW4zoj7WDlrZaFipmxY3v4TcPWBjc=
X-Google-Smtp-Source: ABdhPJzZJHBtpnUuAwZiDckkC63OiiC6dRcu7Zdp9+yK8fU+DOwmNrxSv0JSCRiaHBuA+zlq+FiYjQ==
X-Received: by 2002:adf:9063:: with SMTP id h90mr27339045wrh.121.1628535410961;
        Mon, 09 Aug 2021 11:56:50 -0700 (PDT)
Received: from [192.168.8.197] ([85.255.236.119])
        by smtp.gmail.com with ESMTPSA id x18sm20000910wrw.19.2021.08.09.11.56.49
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 09 Aug 2021 11:56:50 -0700 (PDT)
To:     Al Viro <viro@zeniv.linux.org.uk>
Cc:     linux-fsdevel@vger.kernel.org, Jens Axboe <axboe@kernel.dk>,
        io-uring@vger.kernel.org, linux-kernel@vger.kernel.org
References: <cover.1628509745.git.asml.silence@gmail.com>
 <YRFPR25scNRYaRzW@zeniv-ca.linux.org.uk>
From:   Pavel Begunkov <asml.silence@gmail.com>
Subject: Re: [PATCH 0/2] iter revert problems
Message-ID: <a03abd9e-82c1-7a63-a0dc-c7319f0c0751@gmail.com>
Date:   Mon, 9 Aug 2021 19:56:21 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.12.0
MIME-Version: 1.0
In-Reply-To: <YRFPR25scNRYaRzW@zeniv-ca.linux.org.uk>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 8/9/21 4:52 PM, Al Viro wrote:
> On Mon, Aug 09, 2021 at 12:52:35PM +0100, Pavel Begunkov wrote:
>> For the bug description see 2/2. As mentioned there the current problems
>> is because of generic_write_checks(), but there was also a similar case
>> fixed in 5.12, which should have been triggerable by normal
>> write(2)/read(2) and others.
>>
>> It may be better to enforce reexpands as a long term solution, but for
>> now this patchset is quickier and easier to backport.
> 
> 	Umm...  Won't that screw the cases where we *are* doing proper
> reexpands?  AFAICS, with your patches that flag doesn't go away once
> it had been set...

In general, the userspace should already expecting and retrying on
EAGAIN, and it seems to me, truncates should be rare enough to not
care much about performance. However, it'd better to be more careful
with nowait attempts.

For instance, we can avoid failing reexpanded and reverted iters.

if (i->truncated && iov_iter_count(i) != orig_size)
	// fail;

Or even re-import iov+iter, if still in the right context.


Al, is that viable to you on the iov side?

-- 
Pavel Begunkov
