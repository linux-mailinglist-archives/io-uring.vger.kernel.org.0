Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8B94647C4C8
	for <lists+io-uring@lfdr.de>; Tue, 21 Dec 2021 18:15:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240249AbhLURPn (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 21 Dec 2021 12:15:43 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56938 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240247AbhLURPn (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 21 Dec 2021 12:15:43 -0500
Received: from mail-ed1-x52d.google.com (mail-ed1-x52d.google.com [IPv6:2a00:1450:4864:20::52d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EEEB1C06173F
        for <io-uring@vger.kernel.org>; Tue, 21 Dec 2021 09:15:42 -0800 (PST)
Received: by mail-ed1-x52d.google.com with SMTP id w16so26372808edc.11
        for <io-uring@vger.kernel.org>; Tue, 21 Dec 2021 09:15:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=r0NH9maniglx0SF/wKf0I3ioVnyY1MiBpV/YgH0N7P8=;
        b=Yaa7g3Zef1Oq1YixxCcEUFRq7kdXZwvcbZkJvP3zY5/RM3j8EXC2mEAIfM1uPPFVrk
         LyNYYIZjMOdR+NAUMpd6QrykLWYz4FbQtkJXyrK42GDXTPjtN67hnRCk1nSj+/VVndsm
         YqscC3t7F8SCnkPYUWJxmfew3IxRArtNpSpNc=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=r0NH9maniglx0SF/wKf0I3ioVnyY1MiBpV/YgH0N7P8=;
        b=LRye1ZsWUz7XfEfsJ9wv237Mt9rYNzV6YEjJIs4IVpCJW6+oZ3KEt7ewKRSsslkGuu
         5qWyk+IoKqfrc+SjfGJpqar1zT/KLv9RP8wuoB3iYzs0BQHp1roMc5jfhnxL6EpXGi81
         5IN/2kxws4KfhVJAyLWR1b0ganjusisJFRDNkHeB2OOb2IaWmHSRU1/YakvfnGCT9oIe
         X5Hdhdq59dGFnPJPb1V3yscmd1jANPjHvSX/dtVqeiuxdNKSlKnmbvS6FxLenn2ZQlNn
         /WMvin9d/mjWD7rlS6PbRfX6G6dTIJrODw+KzyxMIYF+SasJaNIItYNRaUJhBY+LJ9OU
         EN5A==
X-Gm-Message-State: AOAM531BHGZfF0k/kz0kKmAHD5tOWDQonnEkwqU7INI/GkVmVWG2aGDi
        PTj5wSkIgZUNdviAxEKZgVRIIm0e77qzrUAVYeI=
X-Google-Smtp-Source: ABdhPJyu+KAYQG9w872l429NbWYdEfHhs9x2Oxdyg/zeXQyuoBSIzyUyOkYRroe40wcUehevbLQiDg==
X-Received: by 2002:a17:907:97c6:: with SMTP id js6mr2050316ejc.667.1640106941364;
        Tue, 21 Dec 2021 09:15:41 -0800 (PST)
Received: from mail-wm1-f41.google.com (mail-wm1-f41.google.com. [209.85.128.41])
        by smtp.gmail.com with ESMTPSA id n12sm6140142edb.86.2021.12.21.09.15.40
        for <io-uring@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 21 Dec 2021 09:15:41 -0800 (PST)
Received: by mail-wm1-f41.google.com with SMTP id bg2-20020a05600c3c8200b0034565c2be15so2226298wmb.0
        for <io-uring@vger.kernel.org>; Tue, 21 Dec 2021 09:15:40 -0800 (PST)
X-Received: by 2002:a05:600c:1e01:: with SMTP id ay1mr3605133wmb.152.1640106940746;
 Tue, 21 Dec 2021 09:15:40 -0800 (PST)
MIME-Version: 1.0
References: <20211221164004.119663-1-shr@fb.com>
In-Reply-To: <20211221164004.119663-1-shr@fb.com>
From:   Linus Torvalds <torvalds@linux-foundation.org>
Date:   Tue, 21 Dec 2021 09:15:24 -0800
X-Gmail-Original-Message-ID: <CAHk-=wgHC_niLQqhmJRPTDULF7K9n8XRDfHV=SCOWvCPugUv5Q@mail.gmail.com>
Message-ID: <CAHk-=wgHC_niLQqhmJRPTDULF7K9n8XRDfHV=SCOWvCPugUv5Q@mail.gmail.com>
Subject: Re: [PATCH v7 0/3] io_uring: add getdents64 support
To:     Stefan Roesch <shr@fb.com>
Cc:     io-uring <io-uring@vger.kernel.org>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Tue, Dec 21, 2021 at 8:40 AM Stefan Roesch <shr@fb.com> wrote:
>
> This series adds support for getdents64 in liburing. The intent is to
> provide a more complete I/O interface for io_uring.

Ack, this series looks much more natural to me now.

I think some of the callers of "iterate_dir()" could probably be
cleaned up with the added argument, but for this series I prefer that
mindless approach of just doing "&(arg1)->f_pos" as the third argument
that is clearly a no-op.

So the end result is perhaps not as beautiful as it could be, but I
think the patch series DTRT.

            Linus
