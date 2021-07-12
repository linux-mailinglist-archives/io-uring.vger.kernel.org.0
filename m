Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F21343C6316
	for <lists+io-uring@lfdr.de>; Mon, 12 Jul 2021 21:02:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234097AbhGLTFB (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 12 Jul 2021 15:05:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35064 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229928AbhGLTFB (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 12 Jul 2021 15:05:01 -0400
Received: from mail-lf1-x12d.google.com (mail-lf1-x12d.google.com [IPv6:2a00:1450:4864:20::12d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BA1FFC0613DD
        for <io-uring@vger.kernel.org>; Mon, 12 Jul 2021 12:02:11 -0700 (PDT)
Received: by mail-lf1-x12d.google.com with SMTP id v6so8145078lfp.6
        for <io-uring@vger.kernel.org>; Mon, 12 Jul 2021 12:02:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=05TXon0OWe0TdWnzF0gYVTRsMbmyDd8KVA9oD5hUpeA=;
        b=RqribjyX+FgXk9Jlj1MPkaZaCLoRgO3jHrV1pXk9CclhaTPG8owXmmkJgBhZo1CjnU
         tZ401uNZXW7wfn+Uu5W1PFB3J2aiKVhH3yid4QzaiT0DMJHZ6oZLTDTuw4qn8dg5cRUB
         w0rTi/NeXer18ql9FgnwcpxRQn3dmD9kafBpg=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=05TXon0OWe0TdWnzF0gYVTRsMbmyDd8KVA9oD5hUpeA=;
        b=Y85Oqa4o24lJJ9GEyAXqWrsFpAdjPh7bczp8gBdQ8USfZofv9v9xlHGu0nEnPEMpfU
         itC4EFOG3VYkAypaUd6U2cWtW1yJ8a5mHWS9pCEBEuM32vRlORqQSM3wbSYra/Y2m4Yw
         A/s2wDiJmFWSLF6hWUoIPcvZRLnoNxjrxeZOov5XhxF0bdPF8VLiOggYzqH6+jVJ5k+6
         N2hLPL+tOT2QZgJEBhypO7ObrWgNON5GaW43F5VxfhSdTc/TAnfm44bZQLamHrDnwJr7
         upM8SBmjF5sOsa8v95PelEyYTSv0ZByrDm8bpvxVzk64rz8T1GSxi1A+aYkpVLt+EUWC
         gWCw==
X-Gm-Message-State: AOAM532GqnDJBjTSBkXSoqIzH8/C3xud7mN+JP4r6NKdC8dHPrduaosK
        b+Y4RQEMv2MZBWXWW4O9dYBbyIZTTde+VDGo
X-Google-Smtp-Source: ABdhPJwwbonM8g9cGmI67xN/q/+AnHboGtAc9CsoaTpaRQ/noxDVUEtOFDmisKLUeDlnfLq4BkKyMQ==
X-Received: by 2002:a05:6512:3a8c:: with SMTP id q12mr188769lfu.334.1626116529950;
        Mon, 12 Jul 2021 12:02:09 -0700 (PDT)
Received: from mail-lf1-f50.google.com (mail-lf1-f50.google.com. [209.85.167.50])
        by smtp.gmail.com with ESMTPSA id f18sm1274183lfc.251.2021.07.12.12.02.09
        for <io-uring@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 12 Jul 2021 12:02:09 -0700 (PDT)
Received: by mail-lf1-f50.google.com with SMTP id y42so45384905lfa.3
        for <io-uring@vger.kernel.org>; Mon, 12 Jul 2021 12:02:09 -0700 (PDT)
X-Received: by 2002:ac2:42d6:: with SMTP id n22mr175625lfl.41.1626116528651;
 Mon, 12 Jul 2021 12:02:08 -0700 (PDT)
MIME-Version: 1.0
References: <20210712123649.1102392-1-dkadashev@gmail.com> <CAOKbgA4EqwLa3WDK_JcxFAU92pBw4hS8vjQ9p7B-w+5y7yX5Eg@mail.gmail.com>
In-Reply-To: <CAOKbgA4EqwLa3WDK_JcxFAU92pBw4hS8vjQ9p7B-w+5y7yX5Eg@mail.gmail.com>
From:   Linus Torvalds <torvalds@linux-foundation.org>
Date:   Mon, 12 Jul 2021 12:01:52 -0700
X-Gmail-Original-Message-ID: <CAHk-=wiGH-bYqLvjMOv2i48Wb1FQaAj8ukegSMLNbW0yri05rA@mail.gmail.com>
Message-ID: <CAHk-=wiGH-bYqLvjMOv2i48Wb1FQaAj8ukegSMLNbW0yri05rA@mail.gmail.com>
Subject: Re: [PATCH 0/7] namei: clean up retry logic in various do_* functions
To:     Dmitry Kadashev <dkadashev@gmail.com>
Cc:     Jens Axboe <axboe@kernel.dk>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        Christian Brauner <christian.brauner@ubuntu.com>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        io-uring <io-uring@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Mon, Jul 12, 2021 at 5:41 AM Dmitry Kadashev <dkadashev@gmail.com> wrote:
>
> Since this is on top of the stuff that is going to be in the Jens' tree
> only until the 5.15 merge window, I'm assuming this series should go
> there as well.

Yeah. Unless Al wants to pick this whole series up.

See my comments about the individual patches - some of them change
code flow, others do. And I think changing code flow as part of
cleanup is ok, but it at the very least needs to be mentioned (and it
might be good to do the "move code that is idempotent inside the
retry" as a separate patch from documentation purposes)

           Linus
