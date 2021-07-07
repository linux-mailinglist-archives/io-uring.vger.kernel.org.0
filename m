Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 95A793BF032
	for <lists+io-uring@lfdr.de>; Wed,  7 Jul 2021 21:22:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231181AbhGGTZH (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 7 Jul 2021 15:25:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50554 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229519AbhGGTZG (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 7 Jul 2021 15:25:06 -0400
Received: from mail-lf1-x12e.google.com (mail-lf1-x12e.google.com [IPv6:2a00:1450:4864:20::12e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0FB56C06175F
        for <io-uring@vger.kernel.org>; Wed,  7 Jul 2021 12:22:25 -0700 (PDT)
Received: by mail-lf1-x12e.google.com with SMTP id r26so6945196lfp.2
        for <io-uring@vger.kernel.org>; Wed, 07 Jul 2021 12:22:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=QWz6j7aQDicZF+8YuVqNXjaVMSD+f6gQ3hDARWuwoZw=;
        b=Vo43/qNbhMYCKn8reADLJoDDeEmatxkzxuMGmzH36T18+UunKRPkZXhu7Onj0iGd1m
         DyhjmfsKcNwvaEw9wj0bn5veD9VgTj37YFXTnQRqjNu+7E0+d/h1IdSaFWgJo+WXaxPt
         n9iKdaXWHIyihVRQYNxdY2/my8u598J8vlEng=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=QWz6j7aQDicZF+8YuVqNXjaVMSD+f6gQ3hDARWuwoZw=;
        b=KW3YRkcrwqLu/rv6+xv70wXMMHNdjfRCzZ7QeYE1FmRkLxda35obphFwTVNtyRE17i
         pCYy8YHmrisU2hmPnqRxzbjRDjye9a7YCVVwWxo4w7/L2zZzGd+Jg0iZYjnT1apeAdiT
         +ajBJoTzvUPZWEA955FPtFLnnX8QP2Nm99llUqIF+9wfZTFj8sRMthFuiLG8Jbg9y24B
         jkLN0hJIw+g7wHX4XHREeKBMTC1pw+R9CZ1JZfrfNyuDRUqNaM1dFtxy0JeXX/65R/Dh
         LMAHHrCMRQpOJXBIDno4Ylq9jT5xufEyCDmhPNcMqybvCtzlh7vxRDUxF5aFlOkp9a6y
         ZsDA==
X-Gm-Message-State: AOAM5336X/TQVXBMdxTl8uJa4G/01Sk9JB9a88+8ldUjgYltty15i3cl
        GU4fUhg8g7RABJQcqWs6tt1lhhTGw2+m34jNIo4=
X-Google-Smtp-Source: ABdhPJzaNJpmwbmLiUDTaU37gIH3Zq4b295s9IDlYiPPVfDOV8qilROgYhWM5Z/zP2x2k4/+FHAk1w==
X-Received: by 2002:ac2:4211:: with SMTP id y17mr19272771lfh.607.1625685742962;
        Wed, 07 Jul 2021 12:22:22 -0700 (PDT)
Received: from mail-lf1-f46.google.com (mail-lf1-f46.google.com. [209.85.167.46])
        by smtp.gmail.com with ESMTPSA id t13sm95112ljo.12.2021.07.07.12.22.22
        for <io-uring@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 07 Jul 2021 12:22:22 -0700 (PDT)
Received: by mail-lf1-f46.google.com with SMTP id u18so6905601lff.9
        for <io-uring@vger.kernel.org>; Wed, 07 Jul 2021 12:22:22 -0700 (PDT)
X-Received: by 2002:a2e:50b:: with SMTP id 11mr21108241ljf.220.1625685742103;
 Wed, 07 Jul 2021 12:22:22 -0700 (PDT)
MIME-Version: 1.0
References: <20210707122747.3292388-1-dkadashev@gmail.com> <20210707122747.3292388-6-dkadashev@gmail.com>
In-Reply-To: <20210707122747.3292388-6-dkadashev@gmail.com>
From:   Linus Torvalds <torvalds@linux-foundation.org>
Date:   Wed, 7 Jul 2021 12:22:06 -0700
X-Gmail-Original-Message-ID: <CAHk-=wiG+sN+2zSoAOggKCGue2kOJvw3rQySvQXsZstRQFTN+g@mail.gmail.com>
Message-ID: <CAHk-=wiG+sN+2zSoAOggKCGue2kOJvw3rQySvQXsZstRQFTN+g@mail.gmail.com>
Subject: Re: [PATCH v8 05/11] fs: make do_mknodat() take struct filename
To:     Dmitry Kadashev <dkadashev@gmail.com>
Cc:     Jens Axboe <axboe@kernel.dk>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        Christian Brauner <christian.brauner@ubuntu.com>,
        Pavel Begunkov <asml.silence@gmail.com>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        io-uring <io-uring@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Wed, Jul 7, 2021 at 5:28 AM Dmitry Kadashev <dkadashev@gmail.com> wrote:
>
> Pass in the struct filename pointers instead of the user string, for
> uniformity with the recently converted do_unlinkat(), do_renameat(),
> do_mkdirat().

Yup. And the uniformity continues with that "we could avoid the goto
retry/out1 with a mknodat_helper() function for the inner meat of the
function.

               Linus
