Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 779521EC1B8
	for <lists+io-uring@lfdr.de>; Tue,  2 Jun 2020 20:23:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726037AbgFBSXK (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 2 Jun 2020 14:23:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38994 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726000AbgFBSXK (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 2 Jun 2020 14:23:10 -0400
Received: from mail-lf1-x12b.google.com (mail-lf1-x12b.google.com [IPv6:2a00:1450:4864:20::12b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0006AC08C5C0
        for <io-uring@vger.kernel.org>; Tue,  2 Jun 2020 11:23:09 -0700 (PDT)
Received: by mail-lf1-x12b.google.com with SMTP id w15so6741622lfe.11
        for <io-uring@vger.kernel.org>; Tue, 02 Jun 2020 11:23:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=HbjLHChqs4RGetcC0+4nf5fqcHOx+7jtjO+yHMD9jQs=;
        b=uvpDfYjhj7F0ffCUDwdsRuXc5Nop901js4niNFY13vdmadUIs/u0DrtMa4qAUZ3rot
         YLa6oJ/m0FwHrRC5p+nshZOes90JuW5ZvR0ZURpQi/sOYb4FntYQBm342LRmiMUrT4NI
         O/tzW5wIfHe+1JtWghv3itP9rpWCe5hp9FWhZKaO1yU21ONacXke6eeT5TlgnIkv2OP1
         pRny0VYFeFKVrIAGsedOfdtA+WtvPoe1SYBsQuQE0YWC4r1m5/jGRqio4s75mQRLeIKq
         G/7vI49pnNSoAeBxnHH19U2KT/uGgeXU5m8ojy7u8dHfLJEVzaD/U9hVNDIBwj3FF6d9
         w5Rw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=HbjLHChqs4RGetcC0+4nf5fqcHOx+7jtjO+yHMD9jQs=;
        b=uW/m46nwUW1XJMQ0j6POaQZ0fPQ9j3QzfUjGE3Zt8+olJsqDQYYo/goSmGW9Bfbkkh
         NEHKfqb2w8jV8Mka1O/IoBPA2hPOcyRHbSyI6j4+hTjv00wMYB4d9Wp2D0UQfJjdaVte
         AdTOZUIuNygShZpxf9cB9ZNmiKP6ENVdvuvcuXGSmIyjkt+jF73C1wnbNRCyMcvweDzJ
         TOmrT4ZWOPF8NsV3h2t8ZtcarXu4yeagIt3aN3gPW55xw9PBGtr3S/mImU5iVuR+26Lx
         GpDmgVaxnBDKcgRKPxvYtRigNsy8CfcOd/n6kwvG8NYTLKA4nEUO20xmm0xzZWi0bSom
         UVig==
X-Gm-Message-State: AOAM533vAPyjBY3Bfg+R0u/Piy3b6cKiFKe/vS4d+kx7PQFYCYH//R6n
        woPiG+UAd9tHE1x3ks7aWXjDH8+5HzVbZEiq0hlf8Kl9
X-Google-Smtp-Source: ABdhPJyh/K32e9qyZ8YXJh39uAK0a6It4jTbbe+OpNqzBVOVgp3DiKy3qDJL+4lUkkauCXmmcQE1ZCFIpiqHxzpa8XU=
X-Received: by 2002:a05:6512:6ca:: with SMTP id u10mr352162lff.184.1591122188034;
 Tue, 02 Jun 2020 11:23:08 -0700 (PDT)
MIME-Version: 1.0
References: <20200531124740.vbvc6ms7kzw447t2@ps29521.dreamhostps.com>
 <5d8c06cb-7505-e0c5-a7f4-507e7105ce5e@kernel.dk> <4eaad89b-f6e3-2ff4-af07-f63f7ce35bdc@kernel.dk>
In-Reply-To: <4eaad89b-f6e3-2ff4-af07-f63f7ce35bdc@kernel.dk>
From:   Jann Horn <jannh@google.com>
Date:   Tue, 2 Jun 2020 20:22:41 +0200
Message-ID: <CAG48ez1CvEpjNTfOJWBRmR6SVkQjLVeSi2gFvuceR0ubF_HJCQ@mail.gmail.com>
Subject: Re: IORING_OP_CLOSE fails on fd opened with O_PATH
To:     Jens Axboe <axboe@kernel.dk>
Cc:     Clay Harris <bugs@claycon.org>, io-uring <io-uring@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Sun, May 31, 2020 at 10:19 PM Jens Axboe <axboe@kernel.dk> wrote:
> We just need this ported to stable once it goes into 5.8-rc:
>
> https://git.kernel.dk/cgit/linux-block/commit/?h=for-5.8/io_uring&id=904fbcb115c85090484dfdffaf7f461d96fe8e53

How does that work? Who guarantees that the close operation can't drop
the refcount of the uring instance to zero before reaching the fdput()
in io_uring_enter?
