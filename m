Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 35D96151806
	for <lists+io-uring@lfdr.de>; Tue,  4 Feb 2020 10:38:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726230AbgBDJir (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 4 Feb 2020 04:38:47 -0500
Received: from mail-qk1-f196.google.com ([209.85.222.196]:39135 "EHLO
        mail-qk1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726406AbgBDJir (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 4 Feb 2020 04:38:47 -0500
Received: by mail-qk1-f196.google.com with SMTP id w15so17245779qkf.6
        for <io-uring@vger.kernel.org>; Tue, 04 Feb 2020 01:38:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=daurnimator.com; s=daurnimator;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=YNCQSvCIeWC94pgLACmS1HbX3HCukQpBVOdtXH1VKHw=;
        b=iqvCudZwiW9s7/uz/6ETltiDtjVZC24knRHyAK/Jno7LWqCZ4Pg4pOwnsnWUJylBPc
         mA8W3J/2ilWe2ZRArqDCgSt46+nf8rl+uVhjLKJztNpEUQ0y5PvYCN5eapJ9KdFUs7i2
         JbQVEeNP9Ab8GyktV1zUELNgnCbFVVCa3t7Q8=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=YNCQSvCIeWC94pgLACmS1HbX3HCukQpBVOdtXH1VKHw=;
        b=Hg+rtd2JxVZW3PLiXFT1J+LN3YjeZHYXCdxQPOiAfu6VSzS5I6zbtU1lKXgiUQumRy
         ymwIdG47OCLYgSABpHYZej/2DxjeR9SMLKDHnQnLtOJ0EnOYZmwjDz5U4VpJgi3v2ZDP
         I9CZJD8bxOfmeOeKwMZ7qDksZ1p+YwplM+K+NDqPqWnbVwyjAbnwbSSUrJjUjuEoa/sp
         kMTvcSNhTBWck/KOBVcxe3ZOrD0tVnOIW1lAWCNsl0Hri5K5L/sE8FuMP7w67oigXU8f
         aisM69E+4mG4GRVwpZJ5uCxUWA8+5/20OQf1667WHj6AKDkd+CLapg0nuD48mqm/sNAl
         vRTQ==
X-Gm-Message-State: APjAAAWmswCHHsTcTEl8wmXAFMKbt1MVDXCDwRpl7M1o9EUk3P+o58Ff
        yQZKBLhO6ZxJ3fcilFZRlIWB+crxMOvYlg==
X-Google-Smtp-Source: APXvYqxGm41nPlXglwYWuCtPR4g9T3SkUPZkgSUWSEgaMoshVSDUGYEbqDdfAQQ4BDx0lUchHBLh5w==
X-Received: by 2002:a37:6446:: with SMTP id y67mr27628150qkb.59.1580809125899;
        Tue, 04 Feb 2020 01:38:45 -0800 (PST)
Received: from mail-qv1-f54.google.com (mail-qv1-f54.google.com. [209.85.219.54])
        by smtp.gmail.com with ESMTPSA id o7sm10763653qkd.119.2020.02.04.01.38.44
        for <io-uring@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 04 Feb 2020 01:38:45 -0800 (PST)
Received: by mail-qv1-f54.google.com with SMTP id m5so8245389qvv.4
        for <io-uring@vger.kernel.org>; Tue, 04 Feb 2020 01:38:44 -0800 (PST)
X-Received: by 2002:ad4:57c7:: with SMTP id y7mr23151390qvx.174.1580809124559;
 Tue, 04 Feb 2020 01:38:44 -0800 (PST)
MIME-Version: 1.0
References: <73f985c9-66df-3a80-3aee-05c89a35faad@kernel.dk>
In-Reply-To: <73f985c9-66df-3a80-3aee-05c89a35faad@kernel.dk>
From:   Daurnimator <quae@daurnimator.com>
Date:   Tue, 4 Feb 2020 20:38:33 +1100
X-Gmail-Original-Message-ID: <CAEnbY+cUeNGLOHj2O9VughT8c6A_T4w5qG_nSen=P=fOivfMMA@mail.gmail.com>
Message-ID: <CAEnbY+cUeNGLOHj2O9VughT8c6A_T4w5qG_nSen=P=fOivfMMA@mail.gmail.com>
Subject: Re: [PATCH] io_uring: prevent eventfd recursion on poll
To:     Jens Axboe <axboe@kernel.dk>
Cc:     io-uring <io-uring@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Fri, 31 Jan 2020 at 16:25, Jens Axboe <axboe@kernel.dk> wrote:
>
> If we register an eventfd with io_uring for completion notification,
> and then subsequently does a poll for that very descriptor, then we
> can trigger a deadlock scenario. Once a request completes and signals
> the eventfd context, that will in turn trigger the poll command to
> complete. When that poll request completes, it'll try trigger another
> event on the eventfd, but this time off the path led us to complete
> the poll in the first place. The result is a deadlock in eventfd,
> as it tries to ctx->wqh.lock in a nested fashion.
>
> Check if the file in question for the poll request is our eventfd
> context, and if it is, don't trigger a nested event for the poll
> completion.

Could this deadlock/loop also happen via an epoll fd?
