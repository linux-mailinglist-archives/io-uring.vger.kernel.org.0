Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6636F3251D4
	for <lists+io-uring@lfdr.de>; Thu, 25 Feb 2021 16:00:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231274AbhBYO6v (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 25 Feb 2021 09:58:51 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59796 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229466AbhBYO6q (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 25 Feb 2021 09:58:46 -0500
Received: from mail-il1-x129.google.com (mail-il1-x129.google.com [IPv6:2607:f8b0:4864:20::129])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0D989C061574
        for <io-uring@vger.kernel.org>; Thu, 25 Feb 2021 06:58:06 -0800 (PST)
Received: by mail-il1-x129.google.com with SMTP id g9so5163836ilc.3
        for <io-uring@vger.kernel.org>; Thu, 25 Feb 2021 06:58:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=Hdvl+LnFgFW6IaF+a4EIHQ9KYeTYCbmMEPDyK8Giwls=;
        b=2TxrfpPKGr1eYvHlyrk5OBVC6TPgEzHf+sKCJuKlw4VJkuiqFrhgrCwz/f6M7HQcAM
         KTaLPvJssEtF2riiy8fhf08V3Nm7DqefK9d/QfKjprKZlXmCZJRkpD+8bmAjRWmM2/DN
         b43Pe9L6McSeTdORTT6cqPNHCBEoWWcWROIdYBC2N5MfuX+q37r/s6Qxmn5CsmThgef8
         OrmUCHddRhxxBF/EsC9zi/j9z/VVBKJjX+ZerQJ5o4K6xikOvCoJHARmXz67irmSTUvc
         OFKjBwSn79kKuLP0VUZsNEQeQ9fiuY+vJ34AZBCW9HicMzh34luY4EyNNd2h9bugP/NA
         dcGA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=Hdvl+LnFgFW6IaF+a4EIHQ9KYeTYCbmMEPDyK8Giwls=;
        b=ePK+e4Uqn+R3jtoj1f8eezdpaTTK/uXXtuS1/Kdp8Ru0O2MNZVNqMnI8dj5l0WPJ2A
         qvYFX67j9BY+kNmNChE9KOvann/LaS/X8fc0fIY2G9vZpZbqlvoVzPftjOtO/B+K+D8+
         ICPZjIGle9jWsboLvj/jmIZLAsVH0no1X5WiQSFk1FwbbJ5aazavm0vO/SL9B5j8hcuK
         B0N/x/lrogN0sodwcObOWdZ8ww1shJFrVy8OLAOip2M9txACvJXhKorfxw2KR67Ey5Dg
         feyeCtTajdPhECTnRb6gxHOKHZH4d3fyC7FsCRFxWOpBX3+N8db4eHWxGryKq34PjA1l
         Upig==
X-Gm-Message-State: AOAM53360ii7cbuGkwDUHx7UOBa4evFgtv+AyUzluE7OK7M7DxnGTOo0
        jYrN2eXC3DZiQl5/CFyUiAuAEg==
X-Google-Smtp-Source: ABdhPJy5VFTH54v2OD1qsugbeyazQf5hCK/PEOuBWUixgWtxc2O6u2nAJA/2VeEibfS/VZ194RghKQ==
X-Received: by 2002:a05:6e02:bc4:: with SMTP id c4mr2813187ilu.169.1614265085392;
        Thu, 25 Feb 2021 06:58:05 -0800 (PST)
Received: from [192.168.1.30] ([65.144.74.34])
        by smtp.gmail.com with ESMTPSA id g5sm3142071ild.25.2021.02.25.06.58.04
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 25 Feb 2021 06:58:04 -0800 (PST)
Subject: Re: [PATCH 1/1] io_uring: don't re-read iovecs in iopoll_complete
To:     Pavel Begunkov <asml.silence@gmail.com>, io-uring@vger.kernel.org
Cc:     xiaoguang.wang@linux.alibaba.com
References: <3b8aa8f6cfcad71b8a633477932e34232ade68d8.1614257829.git.asml.silence@gmail.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <3677a8f9-c264-3089-231c-15fc96acb23a@kernel.dk>
Date:   Thu, 25 Feb 2021 07:58:04 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <3b8aa8f6cfcad71b8a633477932e34232ade68d8.1614257829.git.asml.silence@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 2/25/21 6:02 AM, Pavel Begunkov wrote:
> Issuing a request for IO poll and doing actual IO polling might be done
> from different syscalls, so userspace's iovec used during submission may
> already be gone by the moment of reaping the request and doing reissue
> with prep inside is not always safe.
> 
> Fail IO poll reissue with -EAGAIN for requests that would need to read
> iovec from the userspace. The userspace have to check for it, so it's
> fine.

That looks fine, we can't be off the submit path at that point, so
should get -EAGAIN if we don't have the state we need.

-- 
Jens Axboe

