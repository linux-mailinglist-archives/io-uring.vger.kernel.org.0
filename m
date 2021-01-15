Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5BEE62F8522
	for <lists+io-uring@lfdr.de>; Fri, 15 Jan 2021 20:09:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729312AbhAOTJN (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 15 Jan 2021 14:09:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40110 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728818AbhAOTJN (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 15 Jan 2021 14:09:13 -0500
Received: from mail-io1-xd29.google.com (mail-io1-xd29.google.com [IPv6:2607:f8b0:4864:20::d29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EA47CC061757
        for <io-uring@vger.kernel.org>; Fri, 15 Jan 2021 11:08:32 -0800 (PST)
Received: by mail-io1-xd29.google.com with SMTP id n2so3027057iom.7
        for <io-uring@vger.kernel.org>; Fri, 15 Jan 2021 11:08:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:references:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=1+Ziv14g0JJYERomYNbosTJBQniZoL1nqQ2JhYv6bpY=;
        b=wn4oDOK8RKRTyDCnH8D4Ya8TiPPFpD3B3gdC5q2y5rjjOgDlpZqELJoYmgRXH2vTxD
         II864sRlvVjSa7y7uGvU/p971qf/PGhjy4ca4WKXitRwpIwXkdPQ+kEOEqtirwaVSqyX
         Wx379sXh+zoJWLqwtair80kCFvS+2aBqdVUzKEjAGP0/1oJ1jG1aT5upo/zMowOx4K/Z
         OoA/tF4FdiKaVW/zwuUsF+6sMDwZgMrayE/jPVtI4dw8JlAo398PanMSIYaYm5Q+kQIj
         Gv76lNY95t/Cdl++F10BwB1h/kUl9BgFq5OaXAjd1d24NejZJ3iA+YEfSsoOvitd2wf/
         2s0Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=1+Ziv14g0JJYERomYNbosTJBQniZoL1nqQ2JhYv6bpY=;
        b=W8kZ3VtPAQkqc0alYBAEv2dwy5zFw3BUPfi35cJwB2WmzyKVxGcs8/qI/JCWmwsg0Z
         hrNdI3FGLPpry1ZnzdyWqdf5XRai0Qy45rVz0NU7GpGBcT+/N9FL4tinaAWIagrlR3Uu
         TSqpithG0sMWce1pSaxwBZNVnNyZVM423WQOUJ0p6Y6W78vYSfx0HBcLMVBM7a4JBwdQ
         HEGCUzoAhCXKqZDU7zhjkYvOJiTtzLZcezLFs2rn+euSs6lfoOl3JLNIwzHHoCvndL0R
         JQRnYK8gWGh7PckqLH5H+PMcJzIor8MfYjm4brYWd2Mw3JPtHeYZaePh6z92ggV6n2Q5
         w3qg==
X-Gm-Message-State: AOAM533fvSqn9zVZXqEtTQVAT88FWmci9p3wrfrvAugvAXCw1cw6Z3v5
        /p15dahgaC4tPujjxvqGPAr6mw==
X-Google-Smtp-Source: ABdhPJw7Te7fCr7+uQa0sUCJWC1sqssxylsLdSANmvYjf/Y4UR1gxtxpQC6Qios19NI8YSrCvE7fqQ==
X-Received: by 2002:a5d:9641:: with SMTP id d1mr9530521ios.123.1610737712323;
        Fri, 15 Jan 2021 11:08:32 -0800 (PST)
Received: from [192.168.1.30] ([65.144.74.34])
        by smtp.gmail.com with ESMTPSA id l13sm2931520ilm.79.2021.01.15.11.08.31
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 15 Jan 2021 11:08:31 -0800 (PST)
Subject: Re: [PATCH 0/9] Bijan's rsrc generalisation + prep parts
To:     Pavel Begunkov <asml.silence@gmail.com>, io-uring@vger.kernel.org,
        Bijan Mottahedeh <bijan.mottahedeh@oracle.com>
References: <cover.1610729502.git.asml.silence@gmail.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <3d80407a-003b-f35a-1f58-d944aafe59e2@kernel.dk>
Date:   Fri, 15 Jan 2021 12:08:31 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <cover.1610729502.git.asml.silence@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 1/15/21 10:37 AM, Pavel Begunkov wrote:
> I guess we can agree that generic rsrc handling is a good thing to have,
> even if we have only files at the moment. This consists of related
> patches from the Bijan's longer series, doesn't include sharing and
> buffer bits. I suggest to merge it first. It's approx half of the all
> changes.
> 
> Based on 5.12 with a few pathes from 5.11 cherry-pick to reduce merge
> conflicts, because of merging/etc. may wait for a week or so for the
> next rc before potentially being merged. This also addressed tricky
> merge conflicts where it was applying and compiling well but still
> buggy.
> 
> Bijan, for the changed patches I also dropped your signed-off, so
> please reply if you're happy with the new versions so we can
> add it back. There are change logs (e.g. [did so]) in commit messages
> of those.

Thanks - I plan on merging this once -rc4 is cut, so we don't have
any unnecessary merge conflicts.

-- 
Jens Axboe

