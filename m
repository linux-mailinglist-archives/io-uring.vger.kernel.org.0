Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8E5DB47E9AC
	for <lists+io-uring@lfdr.de>; Fri, 24 Dec 2021 00:39:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232017AbhLWXjn (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 23 Dec 2021 18:39:43 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55236 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229834AbhLWXjn (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 23 Dec 2021 18:39:43 -0500
Received: from mail-ed1-x531.google.com (mail-ed1-x531.google.com [IPv6:2a00:1450:4864:20::531])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2A17FC061401
        for <io-uring@vger.kernel.org>; Thu, 23 Dec 2021 15:39:43 -0800 (PST)
Received: by mail-ed1-x531.google.com with SMTP id f5so27008168edq.6
        for <io-uring@vger.kernel.org>; Thu, 23 Dec 2021 15:39:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=AL3HzL4cKyYJ2EZ6WJmgT62XCqTymgz5pGxiiXe4IfY=;
        b=dFWlYUplfGDBl7WTzsC+cvFHXd3jjM/Ek1k9ANKm1mbvWwD1FEzmeAnTWRw9pMzYPW
         YDU0OUEU0o967bRncuFSbur1czpOvYfygJBKtomUQJZiQyJdeIpscGTBkYXhVWwfUhWR
         kQPkIHOCXIgtWKO4l+t4EMFAr6zG6DQ3Nozn0=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=AL3HzL4cKyYJ2EZ6WJmgT62XCqTymgz5pGxiiXe4IfY=;
        b=vuW9Wu3cBBDNMnT+gnf3k2hJWnZTrLZavlsrpdAaFlXd22KFuUfs59mzcRTiiIbG89
         VVIOMpbSdVcfngXOuJUIxfTdG9FbZuC+OH3pXJ4EMj+JzfI4f6VtA8Wpt+8IWSz9cp0n
         ITtC8V90F7KPowWClhlV7H4Vujiy4MeqVqyCEy4v1qBjl30abqTI7dNm6bMaErsarg54
         0pLTIkEdM1buea+K01yVuAAakj/3Fl0Y4+JpAjgFCcUcaiMZ18eeQ/lVYp8EQd7aja7f
         7wKTv/hh0B70SsY+T5gA9a4XG+I58Ml0x0LlJxEZnE6usv1RayjJOZkhWFj3SkC47kNj
         9f0A==
X-Gm-Message-State: AOAM530dXhkczUE5defEt0yTeoiFpsEQ5PY1INQgCpAXZGovPFHqM6pA
        vdcfkr8OT4jKm/R+6jYfVwZRvIUTk0EGgOgpGHo=
X-Google-Smtp-Source: ABdhPJz2GKh4DNSfkVM2pT3VkbtTqIJqwtKi4sEkFRnmwqdRJGEnSsc7UAcdbQxnYuAlaHrp804bgQ==
X-Received: by 2002:a17:907:7dac:: with SMTP id oz44mr3427103ejc.307.1640302781385;
        Thu, 23 Dec 2021 15:39:41 -0800 (PST)
Received: from mail-wr1-f41.google.com (mail-wr1-f41.google.com. [209.85.221.41])
        by smtp.gmail.com with ESMTPSA id he34sm2134046ejc.70.2021.12.23.15.39.40
        for <io-uring@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 23 Dec 2021 15:39:41 -0800 (PST)
Received: by mail-wr1-f41.google.com with SMTP id j18so14308333wrd.2
        for <io-uring@vger.kernel.org>; Thu, 23 Dec 2021 15:39:40 -0800 (PST)
X-Received: by 2002:adf:f54e:: with SMTP id j14mr3032332wrp.442.1640302780605;
 Thu, 23 Dec 2021 15:39:40 -0800 (PST)
MIME-Version: 1.0
References: <b004710b-1c16-3d90-b990-7a1faf1e5fd0@kernel.dk>
In-Reply-To: <b004710b-1c16-3d90-b990-7a1faf1e5fd0@kernel.dk>
From:   Linus Torvalds <torvalds@linux-foundation.org>
Date:   Thu, 23 Dec 2021 15:39:24 -0800
X-Gmail-Original-Message-ID: <CAHk-=wj-fA6Sp+dNaSkadCg0sgB2fKW7Wi=f8DoG+GmiM2_shA@mail.gmail.com>
Message-ID: <CAHk-=wj-fA6Sp+dNaSkadCg0sgB2fKW7Wi=f8DoG+GmiM2_shA@mail.gmail.com>
Subject: Re: [GIT PULL] io_uring fix for 5.16-rc7
To:     Jens Axboe <axboe@kernel.dk>
Cc:     io-uring <io-uring@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Thu, Dec 23, 2021 at 1:11 PM Jens Axboe <axboe@kernel.dk> wrote:
>
> Single fix for not clearing kiocb->ki_pos back to 0 for a stream,
> destined for stable as well.

I don't think any of this is right.

You can't use f_pos without using fdget_pos() to actually get the lock to it.

Which you don't do in io_uring.

            Linus
