Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D50F73F3F58
	for <lists+io-uring@lfdr.de>; Sun, 22 Aug 2021 14:43:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231391AbhHVMoT (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sun, 22 Aug 2021 08:44:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51514 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231305AbhHVMoS (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sun, 22 Aug 2021 08:44:18 -0400
Received: from mail-io1-xd2f.google.com (mail-io1-xd2f.google.com [IPv6:2607:f8b0:4864:20::d2f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D341EC061575
        for <io-uring@vger.kernel.org>; Sun, 22 Aug 2021 05:43:37 -0700 (PDT)
Received: by mail-io1-xd2f.google.com with SMTP id q3so939348iot.3
        for <io-uring@vger.kernel.org>; Sun, 22 Aug 2021 05:43:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=8y3yBYuRK66PsMTzVq1BQ6I85soTcvHbCQuzMCkksjk=;
        b=b+QPevuG45X2Iao0GJwWWpMwY6LYIwYE2Eqip2rEWGSx1dpVpxnHrY3M+UoExPb5UQ
         QazOESEpGbwZoROGuFNJELJFVGX2W1wdWow6XlRkRxy59IM//LfyS9VwJb1How/x72Dw
         nAKRPgEf7gI3ZIWhhR7aCEwcbAqRKR9LdlC1pbMBmryWlFD+Vp5cVFG+wyDaUukrvRUP
         sd/D/Wnncc8mUU4pJd+cIQqR9j3K6/1i9Uj7D23fjFh0n9Dw1jYH2j5uZBGDUy0Upyvy
         PLQYXBwipv05dahhdySSTCCUycmU2C4QEgWAxrRlNLA92BW2g8YwYD5eyNIyBep9bifi
         Iang==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=8y3yBYuRK66PsMTzVq1BQ6I85soTcvHbCQuzMCkksjk=;
        b=Uq+vELqVZQ0ami5NXf6e917igPC0trA5uw2UBzrQRkyKwzpQeVs3o6ms27CKHDvjyF
         94NHswldW9nH8guRN+RlbFYcQ+cNdZflrMZSJSiscnOd7ra+USVoqXo+PJ3RqqlcHdZC
         eCiRoS9XtiU2NGYPsw3hueDi5V4dP9nwarSJW56CIhHyASq0m09zeHFP6jRTKfi07OxD
         2W3Gu/jkPVfNfRCcqKSaTB8hMTCUnHF0+Y7RXmE+vDGo3mw1CnJMRgGYS185+HWSMphS
         64aq+XWCoCauKdkTheEeAEbEHcghbV0PvOzSYobHAzfCWT+adGZSJ7UVKfNwRUzS5cmQ
         PFBg==
X-Gm-Message-State: AOAM531E36kXhBg2j4T+gQieMvHprU++S9tYzEu5jsNENAm7EU1A5Orf
        W1lfVNFnkD3R+ovKdgI41xulxZhpnaOqnBpRxXQ=
X-Google-Smtp-Source: ABdhPJwgdBNNKjrzmXXzWoRxRZm2LrDbSLDEyCksSMjUiEcnY/urt1oKhUMAM2/FWFE1JU+BxgyIxT6w3GcdH1jdL7U=
X-Received: by 2002:a05:6638:148f:: with SMTP id j15mr25286142jak.61.1629636217272;
 Sun, 22 Aug 2021 05:43:37 -0700 (PDT)
MIME-Version: 1.0
References: <d2fee3ad7d2516d2a154ff380b067ae58a694e61.1629633956.git.asml.silence@gmail.com>
In-Reply-To: <d2fee3ad7d2516d2a154ff380b067ae58a694e61.1629633956.git.asml.silence@gmail.com>
From:   Ammar Faizi <ammarfaizi2@gmail.com>
Date:   Sun, 22 Aug 2021 19:43:20 +0700
Message-ID: <CAFBCWQKZv=mNPYqx4FQDgNjjH=efaXO+gQ-=U_=rbJCbFJh6Dw@mail.gmail.com>
Subject: Re: [PATCH liburing] tests; skip non-root sendmsg_fs_cve
To:     Pavel Begunkov <asml.silence@gmail.com>
Cc:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Sun, Aug 22, 2021 at 7:08 PM Pavel Begunkov <asml.silence@gmail.com> wrote:
> -               if (chroot(tmpdir)) {
> +               r = chroot(tmpdir);
> +               if (r) {
> +                       if (r == -EPERM) {
> +                               fprintf(stderr, "chroot not allowed, skip\n");
> +                               return 0;
> +                       }

Hey, it's the userspace API.

chroot, on success, zero is returned. On error, -1 is returned, and errno is
set appropriately.

Did you mean if (errno == EPERM)?
Should #include <errno.h> as well.
Sorry for the duplicate, forgot to switch to plain text.
---
Ammar Faizi
