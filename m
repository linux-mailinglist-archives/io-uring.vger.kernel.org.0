Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A985C2D91B1
	for <lists+io-uring@lfdr.de>; Mon, 14 Dec 2020 03:24:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2437914AbgLNCXm (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sun, 13 Dec 2020 21:23:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46556 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726316AbgLNCXl (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sun, 13 Dec 2020 21:23:41 -0500
Received: from mail-wr1-x444.google.com (mail-wr1-x444.google.com [IPv6:2a00:1450:4864:20::444])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 00CA7C0613D3
        for <io-uring@vger.kernel.org>; Sun, 13 Dec 2020 18:23:00 -0800 (PST)
Received: by mail-wr1-x444.google.com with SMTP id 91so14866741wrj.7
        for <io-uring@vger.kernel.org>; Sun, 13 Dec 2020 18:23:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=0gn4DRs529B6UR7+MZ66byWZpbUszeIoxbeaYCQ3L0g=;
        b=b81MflqmPGXpRA2kCkmHBYeKs65Q6AsGNluMFWLu1c1B5C3/J16hfZZyohpuPcxLRU
         mNFenIaVAX+BRfK4s3zIhUX/okySVVrza7s/k8kXrIPYHfaT5oQKTuL5P9t7M+mq+GJJ
         1UMVWHHsVVT97DwuXt1M9L3gfsjuFvcU5tqL8uBZbhrEm7uE30L1gMx+2R5gEzueqDFs
         Ncak9CSbeap6Z14SgVq035Q6oszXoezQAfitHYNuJZC6BuGSY/J5hXwtgHaF5WV7ZGz5
         Rv2KpYfOGPKd2PoU8W41OFs+wvWYSCH4tDPbWeD3G48c6Nz+3p58BlDESbqeYvHYCmoD
         e5FA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=0gn4DRs529B6UR7+MZ66byWZpbUszeIoxbeaYCQ3L0g=;
        b=oDmQWJaFAaji+br1uCXLHv/xThyxt5aBVsuGUWvVne2IhQcLSOln18kVVwV3Fpk/gH
         2wzqssmZgghrMA0R5dgXS3P/qxZsthssXXLEzktv3NbxRW6mPfCjle/YSOMfv4BXqLKt
         tL7eP9km7+YtfcoOs6jLRcOHymfDoLfUSBvYfWawzKGSSwoUE2P+Gxh9HIpXU7m/yLuO
         nazqBE/hzD7kN3jVRfbJ7F+uEkTiCbHV2AzTQVonYD562D7UEEraTxyOgFAa7Jsf24Ar
         wmUKkEIsYcfA3dTyJ8KiytNkcydCkgLLETOyzQBGDlJZ1ppCOOp6KqUptQ8RPhefCMUr
         poKg==
X-Gm-Message-State: AOAM530/wf5muABx24YikI3mJSq2AdzzF+s778eNZce0ZbfUYSbnv2/N
        vNx05gBKzmjM78vwI3y21jgd/Lc61san0r+oK9OFEg==
X-Google-Smtp-Source: ABdhPJyee7sn6paMCSM8cK5QwDANznn6hLybXpWpZf77RxDLPaSAQwRluHo/6or3rkFOgJ/WETK9VGn6WXXwQo+Jc+s=
X-Received: by 2002:adf:9506:: with SMTP id 6mr26263942wrs.172.1607912578290;
 Sun, 13 Dec 2020 18:22:58 -0800 (PST)
MIME-Version: 1.0
References: <20201213204339.24445-1-v@nametag.social>
In-Reply-To: <20201213204339.24445-1-v@nametag.social>
From:   Soheil Hassas Yeganeh <soheil@google.com>
Date:   Sun, 13 Dec 2020 21:22:22 -0500
Message-ID: <CACSApvbAXTN9VLcB0BphbJffZ8YXpxm=JF8FteKBVkBArwcd3A@mail.gmail.com>
Subject: Re: [PATCH v3] Allow UDP cmsghdrs through io_uring
To:     Victor Stewart <v@nametag.social>
Cc:     io-uring <io-uring@vger.kernel.org>,
        netdev <netdev@vger.kernel.org>, Jann Horn <jannh@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Sun, Dec 13, 2020 at 3:43 PM Victor Stewart <v@nametag.social> wrote:
>
> here we go, figured it out. sorry about that.
>
> This patch adds PROTO_CMSG_DATA_ONLY to inet_dgram_ops and inet6_dgram_ops so that UDP_SEGMENT (GSO) and UDP_GRO can be used through io_uring.

The v3 patch doesn't have "Signed-off-by". You can see all the checks
on patchwork:
https://patchwork.kernel.org/project/netdevbpf/patch/20201213204339.24445-2-v@nametag.social/

For patches to netdev, please include the target. Here it should be net-next:
https://www.kernel.org/doc/Documentation/networking/netdev-FAQ.txt
git format-patch --subject-prefix='PATCH net-next v4' ...

Also, since this patch affects udp, it's preferred to include "udp: "
in your commit's subject line.  In other words, the v4 of this patch
should look like the following:

[PATCH net-next v2] udp: allow UDP cmsghdrs through io_uring

Thank you


> GSO and GRO are vital to bring QUIC servers on par with TCP throughputs, and together offer a higher
> throughput gain than io_uring alone (rate of data transit
> considering), thus io_uring is presently the lesser performance choice.
>
> RE http://vger.kernel.org/lpc_net2018_talks/willemdebruijn-lpc2018-udpgso-paper-DRAFT-1.pdf,
> GSO is about +~63% and GRO +~82%.
>
> this patch closes that loophole.
>
> net/ipv4/af_inet.c  | 1 +
> net/ipv6/af_inet6.c | 1 +
> net/socket.c        | 8 +++++---
> 3 files changed, 7 insertions(+), 3 deletions(-)
>
>
