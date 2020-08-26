Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3850B253865
	for <lists+io-uring@lfdr.de>; Wed, 26 Aug 2020 21:40:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727053AbgHZTka (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 26 Aug 2020 15:40:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51168 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727020AbgHZTk2 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 26 Aug 2020 15:40:28 -0400
Received: from mail-pf1-x444.google.com (mail-pf1-x444.google.com [IPv6:2607:f8b0:4864:20::444])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A7575C061574
        for <io-uring@vger.kernel.org>; Wed, 26 Aug 2020 12:40:27 -0700 (PDT)
Received: by mail-pf1-x444.google.com with SMTP id m71so1567925pfd.1
        for <io-uring@vger.kernel.org>; Wed, 26 Aug 2020 12:40:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=OG8uhnCA9kG3csdFryFQgnoVrLmqM/Aisjk2iXjlTO4=;
        b=CCtjUjayr/qntPIykQMCTBeZZeCK50TmOXnltMMVDBp3CR9A65E334WHfJcIaB+qj5
         lM0Ab5TQ23N8QqsdlltlQODO+OGXq6MmQcJBd+tA7A5w2hgKBd/HXsYX/JCZnPLsvU76
         Fc4t/yR7DlFMji9jHEtdubrTqLh5q1Ob78A9U=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=OG8uhnCA9kG3csdFryFQgnoVrLmqM/Aisjk2iXjlTO4=;
        b=kpIVj0OERT3eIn/ASAXE2BS7760cdFssW58R4+qnxDFDM2iMzN2zmZCngqIQIZDkuI
         JP8v3IaEdl3qTxeexxAi3Oz5wqKxZPeUPgGljAgKjno0kJQBzb3Qx3jxt1vDXXTt+4cs
         w9sm0xWC6U0eQKgZHXE89Jc5aFRR1DBIaNGO7USTJXkfnpgpDHDj8ubewRYstMWqBQhp
         gW9c/4/5SY9h4eSlpIeEME0rLNjipQb0OQJwPX4VrPEcUErw5nAr+FMM4jbGaLVLLpeL
         iFRSxZOC3cdUDGY0fzVNfdEmouqxvfcxfB6ABjhmyRQgouVWV1Pljk4kYNpPRgXjIEDy
         ZBbQ==
X-Gm-Message-State: AOAM531wt3hC2TD1G+RXhZAMy7V5d+jWb/VrC5mMpRu5nH78RDDMQZMp
        SQZvWvuZTffg2RyHYvR+Jps5CA==
X-Google-Smtp-Source: ABdhPJwoFPtYUC9LMuzuxI/JkcSQzWHlHT55l/323/HECz8Y1hZ6XBGrFMmE05TvFRpD7eDwLUE2Aw==
X-Received: by 2002:a63:516:: with SMTP id 22mr12143709pgf.316.1598470827209;
        Wed, 26 Aug 2020 12:40:27 -0700 (PDT)
Received: from www.outflux.net (smtp.outflux.net. [198.145.64.163])
        by smtp.gmail.com with ESMTPSA id e16sm3774598pfd.17.2020.08.26.12.40.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 26 Aug 2020 12:40:26 -0700 (PDT)
Date:   Wed, 26 Aug 2020 12:40:24 -0700
From:   Kees Cook <keescook@chromium.org>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     Stefano Garzarella <sgarzare@redhat.com>,
        Christian Brauner <christian.brauner@ubuntu.com>,
        Jann Horn <jannh@google.com>, Jeff Moyer <jmoyer@redhat.com>,
        Linux FS Devel <linux-fsdevel@vger.kernel.org>,
        Sargun Dhillon <sargun@sargun.me>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        Kernel Hardening <kernel-hardening@lists.openwall.com>,
        Stefan Hajnoczi <stefanha@redhat.com>,
        kernel list <linux-kernel@vger.kernel.org>,
        Aleksa Sarai <asarai@suse.de>,
        io-uring <io-uring@vger.kernel.org>
Subject: Re: [PATCH v4 0/3] io_uring: add restrictions to support untrusted
 applications and guests
Message-ID: <202008261237.904C1E6@keescook>
References: <20200813153254.93731-1-sgarzare@redhat.com>
 <CAGxU2F55zzMzc043P88TWJNr2poUTVwrRmu86qyh0uM-8gimng@mail.gmail.com>
 <82061082-42c8-1e1c-1f36-6f42e7dd10cb@kernel.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <82061082-42c8-1e1c-1f36-6f42e7dd10cb@kernel.dk>
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Wed, Aug 26, 2020 at 10:47:36AM -0600, Jens Axboe wrote:
> On 8/25/20 9:20 AM, Stefano Garzarella wrote:
> > Hi Jens,
> > this is a gentle ping.
> > 
> > I'll respin, using memdup_user() for restriction registration.
> > I'd like to get some feedback to see if I should change anything else.
> > 
> > Do you think it's in good shape?
> 
> As far as I'm concerned, this is fine. But I want to make sure that Kees
> is happy with it, as he's the one that's been making noise on this front.

Oop! Sorry, I didn't realize this was blocked on me. Once I saw how
orthogonal io_uring was to "regular" process trees, I figured this
series didn't need seccomp input. (I mean, I am still concerned about
attack surface reduction, but that seems like a hard problem given
io_uring's design -- it is, however, totally covered by the LSMs, so I'm
satisfied from that perspective.)

I'll go review... thanks for the poke. :)

-- 
Kees Cook
