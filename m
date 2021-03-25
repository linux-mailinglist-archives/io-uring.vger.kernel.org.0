Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 63221349A89
	for <lists+io-uring@lfdr.de>; Thu, 25 Mar 2021 20:40:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230336AbhCYTjl (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 25 Mar 2021 15:39:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34022 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230226AbhCYTjQ (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 25 Mar 2021 15:39:16 -0400
Received: from mail-lf1-x136.google.com (mail-lf1-x136.google.com [IPv6:2a00:1450:4864:20::136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1BF99C06175F
        for <io-uring@vger.kernel.org>; Thu, 25 Mar 2021 12:39:14 -0700 (PDT)
Received: by mail-lf1-x136.google.com with SMTP id q29so4221980lfb.4
        for <io-uring@vger.kernel.org>; Thu, 25 Mar 2021 12:39:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=gzmi+VlURgVOiIckHYDGx4tksnLtuqPhZg704eyPPzc=;
        b=axAO0RrZyNnOLPeJBC+lqlIBSFCA0+T5m0c+QTvjiesvzRhrSrhNAJGNBpPYO2w5yg
         C8XEXbVJk+oVcSmsslcoGILcX1bst/8WI3rxAEQOD5N5m35uB129JOQ4p6zl6gjYV0hr
         N9zXUzK0n6LOTT7Lnko6AXU/5hsgnyUwAG1QQ=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=gzmi+VlURgVOiIckHYDGx4tksnLtuqPhZg704eyPPzc=;
        b=pvFzdwmDkvHEaPSE9uYH7oIB1f3VasqGNY1JwxXpswhwdAn2nenxv514obl5E7YKUf
         5J8xI01efbtDMUnwz8spYlRVO5oO4arkLswlSbcR9K4vPcj1xvqpn7wP6fQHKN3nD5TJ
         qU67qFspjAcdD23YxUDsZivBYlf6Ci0Dl3x9ky4zF/daTmKaY5BpwNRfPZr4zq9cmSZG
         2s6I3qWiDDasDFXGeMaEiLJ1BeuDY5M4y7klP+CaZN3AZlx+/VjgMbss38g5OGd+9E44
         pE4qLxCifM3f7a+CMef1PR4L5dhOJ8RgfUy8fPvPMHSFV6oCoMfrmPZ5dJo8jUhNSHeP
         1PrQ==
X-Gm-Message-State: AOAM531SBSEjHjNoaCaTktSD9f3YbC30PxrzWm7piVIyxYkv+bfWepk/
        JK5R5WtrzcoTSV6AQPrcW871NnPnrB1YYA==
X-Google-Smtp-Source: ABdhPJyxip2QHAEFK8e4SEqQtq/pNcwJiI3QCZTEFq6XPUDrr0UNqMl4A+td5YN/dnia/Nde+NwPow==
X-Received: by 2002:a05:6512:2389:: with SMTP id c9mr5736905lfv.651.1616701152457;
        Thu, 25 Mar 2021 12:39:12 -0700 (PDT)
Received: from mail-lf1-f53.google.com (mail-lf1-f53.google.com. [209.85.167.53])
        by smtp.gmail.com with ESMTPSA id f22sm633915lfc.68.2021.03.25.12.39.10
        for <io-uring@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 25 Mar 2021 12:39:11 -0700 (PDT)
Received: by mail-lf1-f53.google.com with SMTP id b83so4203165lfd.11
        for <io-uring@vger.kernel.org>; Thu, 25 Mar 2021 12:39:10 -0700 (PDT)
X-Received: by 2002:a05:6512:308b:: with SMTP id z11mr5719715lfd.487.1616701150641;
 Thu, 25 Mar 2021 12:39:10 -0700 (PDT)
MIME-Version: 1.0
References: <20210325164343.807498-1-axboe@kernel.dk> <m1ft0j3u5k.fsf@fess.ebiederm.org>
In-Reply-To: <m1ft0j3u5k.fsf@fess.ebiederm.org>
From:   Linus Torvalds <torvalds@linux-foundation.org>
Date:   Thu, 25 Mar 2021 12:38:54 -0700
X-Gmail-Original-Message-ID: <CAHk-=wjOXiEAjGLbn2mWRsxqpAYUPcwCj2x5WgEAh=gj+o0t4Q@mail.gmail.com>
Message-ID: <CAHk-=wjOXiEAjGLbn2mWRsxqpAYUPcwCj2x5WgEAh=gj+o0t4Q@mail.gmail.com>
Subject: Re: [PATCH 0/2] Don't show PF_IO_WORKER in /proc/<pid>/task/
To:     "Eric W. Biederman" <ebiederm@xmission.com>
Cc:     Jens Axboe <axboe@kernel.dk>, io-uring <io-uring@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Oleg Nesterov <oleg@redhat.com>,
        Stefan Metzmacher <metze@samba.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Thu, Mar 25, 2021 at 12:34 PM Eric W. Biederman
<ebiederm@xmission.com> wrote:
>
> A quick skim shows that these threads are not showing up anywhere in
> proc which appears to be a problem, as it hides them from top.
>
> Sysadmins need the ability to dig into a system and find out where all
> their cpu usage or io's have gone when there is a problem.  I general I
> think this argues that these threads should show up as threads of the
> process so I am not even certain this is the right fix to deal with gdb.

Yeah, I do think that hiding them is the wrong model, because it also
hides them from "ps" etc, which is very wrong.

I don't know what the gdb logic is, but maybe there's some other
option that makes gdb not react to them?

          Linus
