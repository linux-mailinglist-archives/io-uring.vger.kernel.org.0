Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BDE3948373C
	for <lists+io-uring@lfdr.de>; Mon,  3 Jan 2022 19:55:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235897AbiACSzu (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 3 Jan 2022 13:55:50 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44596 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235519AbiACSzu (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 3 Jan 2022 13:55:50 -0500
Received: from mail-ed1-x529.google.com (mail-ed1-x529.google.com [IPv6:2a00:1450:4864:20::529])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F38E0C061761
        for <io-uring@vger.kernel.org>; Mon,  3 Jan 2022 10:55:49 -0800 (PST)
Received: by mail-ed1-x529.google.com with SMTP id f5so139313537edq.6
        for <io-uring@vger.kernel.org>; Mon, 03 Jan 2022 10:55:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=h/tl740B5dKu3LcT9k/DwsMLta3onSSEJxNz0w7L77Q=;
        b=Kswum6/H/CUH2m0aHNjA1M5P7b2h+4XmNGY0uwlFwhgK88+sTraM9oPHfrCUvC7BBC
         z9HqFO/bsZzRqNxojrBth5Oqqu5mYpoIPKcy4zoL5GBEtm0KpwU4q8c0MbhbFUQPm6Z1
         +tMVNRgmFAbuDQCKKiMS5Qsyxrr9JVh2pPJKs=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=h/tl740B5dKu3LcT9k/DwsMLta3onSSEJxNz0w7L77Q=;
        b=MEKZ5zUy6Wci+FX20uY29WZoUaj7JktTCloym5uqGj0qh2+3A33lxkQfk7gOrSYNMe
         1Tl+yjm8a0RNSP1ygmas2jm0jWvIgrCrD1HufaEFNIVzZ4pOvWoWr1264gCV/YxfsoCX
         nQjl6UEtb1sBt8LMT2CS4CF0q/KAcHRS9OLbfQ1gXq4FhaT8nT7hoaqfZ4dHLP3idafz
         beU0K7EJnFBkV/nyZVjac1wv0tvfPoACafh5w5BK+Y08n/Oj7uzyg6lHLkbG62cIGpMe
         XKU5YVjjJltTCAXT+27nRcw4wYyFdO6XZKSbW4uu1TstT41JA/mbPZlKknHvJ/2P8dCP
         nHMQ==
X-Gm-Message-State: AOAM530y00iyAyN4DO4+V+x1CpFnw8ESoWWJ/Gf/9NzjyQc8CvN9OaON
        jhmLra/jfVod7PIW6qvtqxEigJVmZ9VEoysp
X-Google-Smtp-Source: ABdhPJzDnouy/CkrNnM3lI9llRzT97jBUynXiq46C5GjOId8w8j7rTMUKdzV+yBlASlW+P005E91ZA==
X-Received: by 2002:a17:906:a15a:: with SMTP id bu26mr2407352ejb.335.1641236148368;
        Mon, 03 Jan 2022 10:55:48 -0800 (PST)
Received: from mail-wr1-f50.google.com (mail-wr1-f50.google.com. [209.85.221.50])
        by smtp.gmail.com with ESMTPSA id o22sm13958868edc.85.2022.01.03.10.55.47
        for <io-uring@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 03 Jan 2022 10:55:47 -0800 (PST)
Received: by mail-wr1-f50.google.com with SMTP id o3so13390655wrh.10
        for <io-uring@vger.kernel.org>; Mon, 03 Jan 2022 10:55:47 -0800 (PST)
X-Received: by 2002:a05:6000:10d2:: with SMTP id b18mr39310306wrx.193.1641236147522;
 Mon, 03 Jan 2022 10:55:47 -0800 (PST)
MIME-Version: 1.0
References: <20211221164004.119663-1-shr@fb.com> <CAHk-=wgHC_niLQqhmJRPTDULF7K9n8XRDfHV=SCOWvCPugUv5Q@mail.gmail.com>
 <Yc+PK4kRo5ViXu0O@zeniv-ca.linux.org.uk> <YdCyoQNPNcaM9rqD@zeniv-ca.linux.org.uk>
 <CAG48ez1O9VxSuWuLXBjke23YxUA8EhMP+6RCHo5PNQBf3B0pDQ@mail.gmail.com>
In-Reply-To: <CAG48ez1O9VxSuWuLXBjke23YxUA8EhMP+6RCHo5PNQBf3B0pDQ@mail.gmail.com>
From:   Linus Torvalds <torvalds@linux-foundation.org>
Date:   Mon, 3 Jan 2022 10:55:31 -0800
X-Gmail-Original-Message-ID: <CAHk-=wjPEDXkiyTtLijupF80JdNbKG9Rr8QA448u1siuZLCfkw@mail.gmail.com>
Message-ID: <CAHk-=wjPEDXkiyTtLijupF80JdNbKG9Rr8QA448u1siuZLCfkw@mail.gmail.com>
Subject: Re: [PATCH v7 0/3] io_uring: add getdents64 support
To:     Jann Horn <jannh@google.com>
Cc:     Al Viro <viro@zeniv.linux.org.uk>, Jens Axboe <axboe@kernel.dk>,
        Stefan Roesch <shr@fb.com>,
        io-uring <io-uring@vger.kernel.org>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        Pavel Begunkov <asml.silence@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Sun, Jan 2, 2022 at 11:04 PM Jann Horn <jannh@google.com> wrote:
>
> And for this validation caching to work properly, AFAIU you need to
> hold the file->f_pos_lock (or have exclusive access to the "struct
> file"), which happens in the normal getdents() path via fdget_pos().
> This guarantees that the readdir handler has exclusive access to the
> file's ->f_version, which has to stay in sync with the position.

Yes.

So the whole 'preaddir()' model was wrong, and thanks to Al for noticing.

It turns out that you cannot pass in a different 'pos' than f_pos,
because we have that very tight coupling between the 'struct file' and
readdir().

It's not just about f_pos and f_version, either - Al pointed out the
virtual filesystems, which use a special dentry cursor to traverse the
child dentries for readdir, and that one uses 'file->private_data'.

So the directory position isn't really about some simple passed-in
pos, it has locking rules, it has validation, and it has actual
secondary data in the file pointer.

                  Linus
