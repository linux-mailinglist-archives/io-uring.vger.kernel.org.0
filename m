Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 46D22391FA1
	for <lists+io-uring@lfdr.de>; Wed, 26 May 2021 20:49:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235742AbhEZSvH (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 26 May 2021 14:51:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36506 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234566AbhEZSux (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 26 May 2021 14:50:53 -0400
Received: from mail-ed1-x535.google.com (mail-ed1-x535.google.com [IPv6:2a00:1450:4864:20::535])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B761EC06138D
        for <io-uring@vger.kernel.org>; Wed, 26 May 2021 11:49:20 -0700 (PDT)
Received: by mail-ed1-x535.google.com with SMTP id b17so2813351ede.0
        for <io-uring@vger.kernel.org>; Wed, 26 May 2021 11:49:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=paul-moore-com.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=eUw5EWsm6YpLZJa7t+q5jtkegb7JzdC7cLbi2HaDaSY=;
        b=Qa4+2I8bj+Rl4uorvYi/14nmt2vKj6hYAl7zSFojW6Kt3Nt8daf6Gpm4ZJJgyUNFWI
         xkCMAKH5NW4fxSZHUxXVEUeZGqV3qAKmIt2X/M0TvaEJyVLwexIv0T21EVajyvyO6nub
         PUaOy9tS3C89//WbcyVRpE6YWPS+N7CBNALIqPZJa7o3+FX7M8Hu2Ysql1iwx/TdO6E+
         WNikm8vzY9a+WHq+pwjhS03/CounnEJ3vgkX1e9x2Njpf9ls33p53q9xTOmQDxxF2901
         TEpQTn2TGh9aaLRKw0gbUCJR8ualRB1k8OmjD8DD5IRGpzz6W0AAUVJhXX3DTE7R0ivF
         u5+A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=eUw5EWsm6YpLZJa7t+q5jtkegb7JzdC7cLbi2HaDaSY=;
        b=ZiXbYQaC6g5JwidXdKLghl6zAPHpMfh5hbinno1NbeTkzHRQ7CalYIrPkmoiRlmoiS
         me5XPJg7Ao2Urd5EVFEiRIeo8C9IW38aQO2pe9bZtF9+MU55kRW+kIspT64jRgclI7I7
         bOAGFZVd+BNbFdXgsgg2zXkV3Vle0i4uHFSNwrwkZTnWwb9yqirj2Ah5gy9GVky675q3
         7rzhtsocWppMkUZ/SAoRViRRzPWlNKMWgJavKToIiq/K6nDhLVW5BEftsTLA/jqe3PL3
         IlaNYHHTHqaomSw+1fo5M8BlwR7T7HB387eS3InambcuBVDJQRQmhOLmgrAKWc2IsG+O
         9fNg==
X-Gm-Message-State: AOAM533U6x2l3QHnKw5L2my2K+/dIvZ3ktY5E6ZKlLHh0+Z09YkTaAPa
        NGbKcGv/MTRO93n2dQQUAMSm0TPrSWbaQKcFSMFw
X-Google-Smtp-Source: ABdhPJwv0Uq8DQfJkDvdzA4OniOiI+rWA9eT/CLl2cGg/DPPNpGOFUfGKO6SZKb3UqHq3VqSm/joAe+wfqQshG0/qkY=
X-Received: by 2002:aa7:cb48:: with SMTP id w8mr39405253edt.12.1622054959225;
 Wed, 26 May 2021 11:49:19 -0700 (PDT)
MIME-Version: 1.0
References: <162163367115.8379.8459012634106035341.stgit@sifl> <x498s41o806.fsf@segfault.boston.devel.redhat.com>
In-Reply-To: <x498s41o806.fsf@segfault.boston.devel.redhat.com>
From:   Paul Moore <paul@paul-moore.com>
Date:   Wed, 26 May 2021 14:49:07 -0400
Message-ID: <CAHC9VhQ9r7WHbq2ga+-PF0x5q29nkdNjbLouQETvxDtjE3QaQg@mail.gmail.com>
Subject: Re: [RFC PATCH 0/9] Add LSM access controls and auditing to io_uring
To:     Jeff Moyer <jmoyer@redhat.com>
Cc:     linux-security-module@vger.kernel.org, selinux@vger.kernel.org,
        linux-audit@redhat.com, io-uring@vger.kernel.org,
        linux-fsdevel@vger.kernel.org,
        Kumar Kartikeya Dwivedi <memxor@gmail.com>,
        Jens Axboe <axboe@kernel.dk>,
        Alexander Viro <viro@zeniv.linux.org.uk>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Wed, May 26, 2021 at 10:59 AM Jeff Moyer <jmoyer@redhat.com> wrote:
> Paul Moore <paul@paul-moore.com> writes:
>
> > Also, any pointers to easy-to-run io_uring tests would be helpful.  I
> > am particularly interested in tests which make use of the personality
> > option, share urings across process boundaries, and make use of the
> > sqpoll functionality.
>
> liburing contains a test suite:
>   https://git.kernel.dk/cgit/liburing/
>
> You can run it via 'make runtests'.

Thanks Jeff, I'll take a look.  Quick question as I start sifting
through the tests, are there any tests in here which share a single
ring across process boundaries?

-- 
paul moore
www.paul-moore.com
