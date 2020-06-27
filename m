Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 29DF620BEEB
	for <lists+io-uring@lfdr.de>; Sat, 27 Jun 2020 07:59:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725924AbgF0F7W (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sat, 27 Jun 2020 01:59:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45082 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725880AbgF0F7W (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sat, 27 Jun 2020 01:59:22 -0400
Received: from mail-io1-xd41.google.com (mail-io1-xd41.google.com [IPv6:2607:f8b0:4864:20::d41])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 10EF1C03E979
        for <io-uring@vger.kernel.org>; Fri, 26 Jun 2020 22:59:22 -0700 (PDT)
Received: by mail-io1-xd41.google.com with SMTP id f23so12064169iof.6
        for <io-uring@vger.kernel.org>; Fri, 26 Jun 2020 22:59:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to;
        bh=yBqWiI4QsYN2/OQgDmff08J072L2yIAIqnp8kunYjWc=;
        b=N5h8x7Bn23ZokVo09Vw/4RRuejoGhshy/lTbW+6mICGqv61mOUN2yOCagRPBbqlWeK
         F6DSYgRjDTvO5QjdPeag9WdDpgSeMvoM6D/66Z2Mq7/WDkS+xTTE4B6/ZLM/eSTneHPd
         KrKWXJd294d7UYk7ErqIEC+NMB4qZHE6q6lrGHH9euRPBJTuor6v6B1NJYBvWtP5dpGB
         uqBT/ePiLLgVGlAK+8Mzt6CX21w88LvvuwhEZDv55shcHCxVv0doefMe4qq1CgMqactR
         iAJ8hRjSCCV6KZKAyQ/RaiNYQggzh0jS50oP83QZzsRhoSkVfID4LFGUat/zqddgZs+O
         VZ6Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to;
        bh=yBqWiI4QsYN2/OQgDmff08J072L2yIAIqnp8kunYjWc=;
        b=NObyjgY71w+ip1fwh9r0xQWskgBjsgn9vbbNKRN8eYKFaG57dXXSdNH4tr8oURl1FC
         jkDNb1l3kNgonETu4gV0vNHZoj/TE/Xg8hpdAmQtLEfGNrUGmgm/GNFdKt9X0KpMvMHV
         4A84upQxmWy12lQo040OdEiKWS70UIwYUOV/eVc64yjGJp8RZOSA9ksHonOMdaMelALX
         MOKg/UCzgqGnXVZ5pPSWFwTDTMjm/7fhWrzj9QsdaPf1ux1k6AKuwVq2P7WlEAqRBuzT
         fILvu6mdMkUYDjswhUhT4/hQSryoMkhsbcHspp0QeA8Q+/z5Lj1/nVwfnP4/BU5ybWky
         NPhA==
X-Gm-Message-State: AOAM531Ob8XpINP+mn+1baDKIqeEmDgyzGTICJOrQINfmXZ3KlFW6070
        amPQ0aINH5F8aueoOv2PXF8idp+dych08hVisilJ5ZmH
X-Google-Smtp-Source: ABdhPJxGDb+yK/Wdv5AU7yLGHyl+7Mn65vEOst1CFlsC45ehckyAZsTEIFrUgrHhDcOqg0CcNXEEdZoKKY/9rfGdpb4=
X-Received: by 2002:a05:6638:d42:: with SMTP id d2mr7329671jak.9.1593237561126;
 Fri, 26 Jun 2020 22:59:21 -0700 (PDT)
MIME-Version: 1.0
References: <20200627055515.764165-1-zeba.hrvoje@gmail.com>
In-Reply-To: <20200627055515.764165-1-zeba.hrvoje@gmail.com>
From:   Hrvoje Zeba <zeba.hrvoje@gmail.com>
Date:   Sat, 27 Jun 2020 01:59:10 -0400
Message-ID: <CAEsUgYiSXD0tamM8Du_OBgfoGHLw6f5C4Z09+4Rh=30Ttvn=9g@mail.gmail.com>
Subject: Re: [RFC PATCH] Fix usage of stdatomic.h for C++ compilers
To:     io-uring@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Sat, Jun 27, 2020 at 1:55 AM Hrvoje Zeba <zeba.hrvoje@gmail.com> wrote:
>
> Since b9c0bf79aa8, liburing.h doesn't compile with C++ compilers. C++
> provides it's own <atomic> interface and <stdatomic.h> can't be used. This
> is a minimal change to use <atomic> variants where needed.
>

I've tested this with gcc 10.1.0 and clang 10.0.0 and did some limited
testing. Seemed fine but somebody more knowledgeable should also take
a look.
