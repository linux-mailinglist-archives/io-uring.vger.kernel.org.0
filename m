Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E11FE135312
	for <lists+io-uring@lfdr.de>; Thu,  9 Jan 2020 07:09:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727961AbgAIGJc (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 9 Jan 2020 01:09:32 -0500
Received: from mail-qv1-f47.google.com ([209.85.219.47]:35778 "EHLO
        mail-qv1-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725899AbgAIGJb (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 9 Jan 2020 01:09:31 -0500
Received: by mail-qv1-f47.google.com with SMTP id u10so2513790qvi.2
        for <io-uring@vger.kernel.org>; Wed, 08 Jan 2020 22:09:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=daurnimator.com; s=daurnimator;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=r7Xvq/S/UnBz8PGcA9iN7E/DoGN73xwMY9aIFNWHjwQ=;
        b=ivshZxUhtJOe++SOOUGEIXcCDFSLBEAzVsi1nJhxzpwxCAShBw0LGGDrFLorJ3ruUJ
         iugPukLwMdwn+zrkG8G9jFB9wz9mtVLcgL4IGyE6B1c6JNtRDwDKih75V5PCmqTSkBbd
         AcU7pzbkcvmzVtZxRdWQjVwgVXNhozWSZcXVg=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=r7Xvq/S/UnBz8PGcA9iN7E/DoGN73xwMY9aIFNWHjwQ=;
        b=chPKrydFg3E7S2JBF3BshMGiTZnTipCRCZd/884NkTR2VkbboAGV5SKtk5OYwNyoZa
         qLAmF5kPYtrboojuWYO7SD533TC0SdyW82Si+01mjF04ZPSQEfzf95/rSCoT2Cvpz4Ld
         PFSp5crC/kXmiSh+dAy948BQxuoL08LY7qSMTUTmZgJR1OXi4SRENhLiH964qUklw4Aa
         HnwH13ZHdPdA/JB8UayFJVGbmoaKuRhYDiSQbBVNdcsa+57sbwjqWXXa4jTC4bg3DTYw
         RkRFJb79FjrU5+o5an3WNrXzWxaDulG+XIE+s4Fphk2tCV/J4dxvF5nPSRwzH7zXK61A
         oA/g==
X-Gm-Message-State: APjAAAVBSxJlZ4rB4z8R8t54CS1iaCuLVUlyoNzvSWV+nf8IZKmnMkud
        4RFi5dbeAS8L0pH4/OSc2Lz0X7um5EQ=
X-Google-Smtp-Source: APXvYqwIlXbPvbsSZU/WgGu3JCLi6udW/olvdJ9+IzzmsnVgjLfzkYAkPFgcJcyaGhMQjck9KqxN3Q==
X-Received: by 2002:a05:6214:1745:: with SMTP id dc5mr7244538qvb.230.1578550169471;
        Wed, 08 Jan 2020 22:09:29 -0800 (PST)
Received: from mail-qk1-f178.google.com (mail-qk1-f178.google.com. [209.85.222.178])
        by smtp.gmail.com with ESMTPSA id 206sm2556471qkf.132.2020.01.08.22.09.28
        for <io-uring@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 08 Jan 2020 22:09:28 -0800 (PST)
Received: by mail-qk1-f178.google.com with SMTP id d71so5044311qkc.0
        for <io-uring@vger.kernel.org>; Wed, 08 Jan 2020 22:09:28 -0800 (PST)
X-Received: by 2002:a37:b783:: with SMTP id h125mr7771038qkf.75.1578550168021;
 Wed, 08 Jan 2020 22:09:28 -0800 (PST)
MIME-Version: 1.0
References: <2005CB9A-0883-4C35-B975-1931C3640AA1@icloud.com>
 <55243723-480f-0220-2b93-74cc033c6e1d@kernel.dk> <60360091-ffce-fc8b-50d5-1a20fecaf047@kernel.dk>
 <4DED8D2F-8F0B-46FB-800D-FEC3F2A5B553@icloud.com> <d949ea3a-bd24-e597-b230-89b7075544cc@kernel.dk>
In-Reply-To: <d949ea3a-bd24-e597-b230-89b7075544cc@kernel.dk>
From:   Daurnimator <quae@daurnimator.com>
Date:   Thu, 9 Jan 2020 17:09:14 +1100
X-Gmail-Original-Message-ID: <CAEnbY+fSuT+bBztpOUNJY3cq2pZ6tbFvKkSUeY+mEVwjtdNDow@mail.gmail.com>
Message-ID: <CAEnbY+fSuT+bBztpOUNJY3cq2pZ6tbFvKkSUeY+mEVwjtdNDow@mail.gmail.com>
Subject: Re: io_uring and spurious wake-ups from eventfd
To:     Jens Axboe <axboe@kernel.dk>
Cc:     Mark Papadakis <markuspapadakis@icloud.com>,
        io-uring@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Thu, 9 Jan 2020 at 03:25, Jens Axboe <axboe@kernel.dk> wrote:
> I see what you're saying, so essentially only trigger eventfd
> notifications if the completions happen async. That does make a lot of
> sense, and it would be cleaner than having to flag this per request as
> well. I think we'd still need to make that opt-in as it changes the
> behavior of it.
>
> The best way to do that would be to add IORING_REGISTER_EVENTFD_ASYNC or
> something like that. Does the exact same thing as
> IORING_REGISTER_EVENTFD, but only triggers it if completions happen
> async.
>
> What do you think?


Why would a new opcode be cleaner than using a flag for the existing
EVENTFD opcode?
