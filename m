Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2AD3544C4E4
	for <lists+io-uring@lfdr.de>; Wed, 10 Nov 2021 17:14:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229926AbhKJQRh (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 10 Nov 2021 11:17:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38110 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229473AbhKJQRg (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 10 Nov 2021 11:17:36 -0500
Received: from mail-io1-xd29.google.com (mail-io1-xd29.google.com [IPv6:2607:f8b0:4864:20::d29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 20B10C061764
        for <io-uring@vger.kernel.org>; Wed, 10 Nov 2021 08:14:49 -0800 (PST)
Received: by mail-io1-xd29.google.com with SMTP id 14so3413727ioe.2
        for <io-uring@vger.kernel.org>; Wed, 10 Nov 2021 08:14:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=subject:to:references:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=QGMpys1bo/4qZ+vS+R9SdCno+YUi64oitTPGPkzwl54=;
        b=dSVtmQMCHdpI+EW5v3pCHYHH4gIulFETxjANfVt6zfLtga6SEzXEMqF6vL1hF/JrGV
         Ig2ckpN2eA7sHtjA0gLOb6nieML0ge0gboaNY8jlwyrYOHJOMX+Bbk1vnGAEAPPmtH0G
         bpN4CDTY0boqZgtp8Vbxil245CY2wxWVKtV/m18k73LywiRymIU/zQW8XDmKqdGU4EuQ
         K2aUbs8MnI4aLIzDMGj9rNdyX6J1QveuQ8BW4tUggYZu3Sec0+4gjBJpwxritpYCI3Fy
         71L/ck+i1rNIlpvouS+531xgeL4ZkrWrMf7UENHzaEXdIE7P6d42vIDAbp6eG9rj7CBW
         M/Hg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=QGMpys1bo/4qZ+vS+R9SdCno+YUi64oitTPGPkzwl54=;
        b=kt8Ip0O/U1X+g8l04jV0CWAeKmBPtuzRPL7+8mKJJ39c0/X953JB4FnfXyfqxtbedv
         9tCKSIQyjI4qUe7FKitBKPbZJRHYolUN29TZbKZfRZW6qleI+wmk8Fg1XHgDa3bnR9h+
         pEhpQtnJONGR5kbScgenb2DI61agvWdP70zDydd+wvvbSBbLp9pzJox96/iCNhzDAMlk
         cXV2AfqV+8inLO9BFeSHb0MRyKL4IDTbTDnEYVdbnIULCVcmw8M58qkPxKDG+EXcVwzY
         1VtyZPDNpRazL7nx/CM/ARvWIRg3bhNs3ZLWW6B/qWXD+XH5i/ditD42ylZL7zXUBssw
         6qAA==
X-Gm-Message-State: AOAM531EzYgJN17jEMZll2hRmB9thHDWJaZ/JR30YmQ1cqLNb72qIomV
        pejPm5BCDv/X+f6R0Iq7s5yC1pQ6kUk1O1xp
X-Google-Smtp-Source: ABdhPJyVxM4Pn8zTvPeg8DB1I7pg+QikODQnsFKgCjOp38m6bfC2xwgFfvceR4H9VaAz9ih9FOMznA==
X-Received: by 2002:a05:6602:27ce:: with SMTP id l14mr163896ios.193.1636560888362;
        Wed, 10 Nov 2021 08:14:48 -0800 (PST)
Received: from [192.168.1.30] ([207.135.234.126])
        by smtp.gmail.com with ESMTPSA id b7sm193980ilj.0.2021.11.10.08.14.47
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 10 Nov 2021 08:14:48 -0800 (PST)
Subject: Re: [PATCH v2 0/4] allow to skip CQE posting
To:     Pavel Begunkov <asml.silence@gmail.com>, io-uring@vger.kernel.org
References: <cover.1636559119.git.asml.silence@gmail.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <239ab9cc-e53c-f8aa-6bbf-816dfac73f32@kernel.dk>
Date:   Wed, 10 Nov 2021 09:14:47 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <cover.1636559119.git.asml.silence@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 11/10/21 8:49 AM, Pavel Begunkov wrote:
> It's expensive enough to post an CQE, and there are other
> reasons to want to ignore them, e.g. for link handling and
> it may just be more convenient for the userspace.
> 
> Try to cover most of the use cases with one flag. The overhead
> is one "if (cqe->flags & IOSQE_CQE_SKIP_SUCCESS)" check per
> requests and a bit bloated req_set_fail(), should be bearable.

I like the idea, one thing I'm struggling with is I think a normal use
case of this would be fast IO where we still need to know if a
completion event has happened, we just don't need to know the details of
it since we already know what those details would be if it ends up in
success.

How about having a skip counter? That would supposedly also allow drain
to work, and it could be mapped with the other cq parts to allow the app
to see it as well.

-- 
Jens Axboe

