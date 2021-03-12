Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 02B6B339628
	for <lists+io-uring@lfdr.de>; Fri, 12 Mar 2021 19:20:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232987AbhCLSUE (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 12 Mar 2021 13:20:04 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52762 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233055AbhCLSTq (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 12 Mar 2021 13:19:46 -0500
Received: from mail-il1-x12b.google.com (mail-il1-x12b.google.com [IPv6:2607:f8b0:4864:20::12b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9FC13C061574
        for <io-uring@vger.kernel.org>; Fri, 12 Mar 2021 10:19:46 -0800 (PST)
Received: by mail-il1-x12b.google.com with SMTP id v14so3386114ilj.11
        for <io-uring@vger.kernel.org>; Fri, 12 Mar 2021 10:19:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:references:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=qiJ3o+kVwN7b2PwuXdPNbBBrFy8XZ5m0pEHEwuYG9tQ=;
        b=rM0maUfLYm9MLBf7iNYWx77iq9VirO/LMuRLbQ7thRifkiaxHXaJnw83ThpT0qQIN4
         qqOipP+6MMqNOZLyQK4sRJluROniAnF85jve8czZHxuz/ag3FZhKtbm5ngyb+0f0SWXy
         sMVhtgflLJeS+VvdiDw8QSgWZbnlFYE4Ki5aBG3C/1bVIQj97AZ1BKnVD/Jt25ck5OaJ
         2WBOrO9qNTdfAxW/dOT//kqND9crIo+w5ifKgv4RczIGUVwoPeFDrEP7Q4rcX+imzGSG
         4JXkOStplmEDYYXL9f9072qFejzlyrePNVFxAa/J9WPDggcIfTLjhWiq9j6nSXcvZFDb
         qHJg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=qiJ3o+kVwN7b2PwuXdPNbBBrFy8XZ5m0pEHEwuYG9tQ=;
        b=jod1BmTGiErj2CA8Oyw4BWU6vjO1SUeAFpJILg1MzmD0KFFSBmDWzNSqE6v5vCPkGC
         7gddtZesoRrXJjgM+xJaEmnPWan0adswrv7gjX+UMBWWSAM8LHAc9tG7fuL4BXkoJ2ij
         7n63r7kG2oAEgAgyfWpHp/MDsSjSirV6vQzLpdSoS0VMuNS/BTa0X8miOVJX94XNbxLf
         MX3WoRxNXc2I3/ZVDnEi2CtVqxy80SHoLKgT+LAeSVZZr5y7TzTH0QDAM82omahqfFft
         IRwB/rO2RMy1y9Pm6DrRK5ymNdgt40bfPZlLAM0s6Ox81bcNkV2xVAh9Qsrw41L+Kn7+
         5ubA==
X-Gm-Message-State: AOAM533tYFiGh6bZexWKc0sPe6TU8KKYXhZxD66btgB5mghwFGBnBdaS
        i4JMdrZtOEDIEhPrEKiAJ9t4iTPxiGhaMA==
X-Google-Smtp-Source: ABdhPJzDW5bxUwCBbks9TDtmIa5J7f9KWJTBmc5h/hFhi0TQQlStofBvUowHPVmVayNkvQavMLvMqw==
X-Received: by 2002:a92:c052:: with SMTP id o18mr3763044ilf.84.1615573185852;
        Fri, 12 Mar 2021 10:19:45 -0800 (PST)
Received: from [192.168.1.30] ([65.144.74.34])
        by smtp.gmail.com with ESMTPSA id q15sm3265770ilt.30.2021.03.12.10.19.45
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 12 Mar 2021 10:19:45 -0800 (PST)
Subject: Re: [PATCH 0/4] sqpoll fixes
To:     Pavel Begunkov <asml.silence@gmail.com>, io-uring@vger.kernel.org
References: <cover.1615504663.git.asml.silence@gmail.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <9c2af3b2-c902-d291-f8bb-7b602407073a@kernel.dk>
Date:   Fri, 12 Mar 2021 11:19:44 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <cover.1615504663.git.asml.silence@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 3/11/21 4:29 PM, Pavel Begunkov wrote:
> 1-3 are relatively easy. 2/3 is rather a cleanup, but it's better to
> throw it out of the equation, makes life easier.
> 
> 4/4 removes the park/unpark dance for cancellations, and fixes a couple
> of issues (will send one test later).
> Signals in io_sq_thread() add troubles adding more cases to think about
> and care about races b/w dying SQPOLL task, dying ctxs and going away
> userspace tasks.
> 
> Pavel Begunkov (4):
>   io_uring: cancel deferred requests in try_cancel
>   io_uring: remove useless ->startup completion
>   io_uring: prevent racy sqd->thread checks
>   io_uring: cancel sqpoll via task_work
> 
>  fs/io_uring.c | 195 +++++++++++++++++++++++++-------------------------
>  1 file changed, 99 insertions(+), 96 deletions(-)

Added for 5.12, thanks.

-- 
Jens Axboe

