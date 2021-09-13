Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 667F740A129
	for <lists+io-uring@lfdr.de>; Tue, 14 Sep 2021 01:01:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349890AbhIMXC3 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 13 Sep 2021 19:02:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51026 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1349892AbhIMXCT (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 13 Sep 2021 19:02:19 -0400
Received: from mail-io1-xd2c.google.com (mail-io1-xd2c.google.com [IPv6:2607:f8b0:4864:20::d2c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E5B45C0613C1
        for <io-uring@vger.kernel.org>; Mon, 13 Sep 2021 15:43:46 -0700 (PDT)
Received: by mail-io1-xd2c.google.com with SMTP id q3so14293329iot.3
        for <io-uring@vger.kernel.org>; Mon, 13 Sep 2021 15:43:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:from:to:cc:references:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=CUES55HK0iw4tz8fQ36vOwJ7kua+ZhjQXn4Oi1aQUoc=;
        b=HsyHrjsyxtk/pRLOhK0KaGbOsRal2ndwYEZzshaLwEtZjFWQqjaXMdutfw/BRsJBDJ
         3g8VSpQG4+DRYFyAJ8EdVFe8WumyirIss6SmrNjOwl0DoxxNPZkzgpG+jARQBeVn7keI
         fYLsfFW29dzyn+uwLz2vfzBKlPf9DcHVGvpRjHIgbTH2L2HjxtWS+t+julMro0lmNt/5
         a9aRjtvBkFqnXVtmvg5kzh7nkPtNPz3Tjgp4YWn2TKjivuJGGLl2gcUIfDk2fNPFCTg9
         nDmcYCg3Vgs50yPDsTvnO3BwWPjG+cXDkTUhC+E2hec0192znXnQwCaNOzeXQlWpqRH4
         j5mQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:from:to:cc:references:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=CUES55HK0iw4tz8fQ36vOwJ7kua+ZhjQXn4Oi1aQUoc=;
        b=OZqQuGtMAnTVxzCTZmCiTTT8YQJQ/vnf2RjOdu11Lqx3ZWzZ8/Z17LLCaEhzXfvhZj
         ruUhM65hXCk8UA+WATbOiqXseSq1LlHZET8gcuQ6TKTUhfSnVQqMC3VCoW9QDd3BzVM9
         fBTxYl2WNhgVmKzR8w2rPlv/op0q/d/3GIHip6ncUJtV1nNsCcTQpEoMPnA9BYOYzp4C
         h3zW3yfVVSyBuASEuG1BSueKsEhaLOl8c/YUtwHZxdmvRq6x14g+92B65Ydot/S8odMU
         JHixbPyM/6DPsTSfr2w6Wpj35Q2XfovaITeaJ9teqyyqEx7Bk04FLxqnR/N41P/d+UEp
         hzuQ==
X-Gm-Message-State: AOAM532Uc/7jwL2JcSrRVoFRcv2YOevM+DNnTCFMTVSNMgon7bHUbdJ3
        FaiGN/I85LHhxQ7UrYUrTPMmN+KSXwd1eA==
X-Google-Smtp-Source: ABdhPJxuZ0DHBjEg/acw5j4hkav4vXWUG7N5redfvP+aaNuIQp5rr5KdGLiNOYG9k1YqnGvgNh64FA==
X-Received: by 2002:a5d:9145:: with SMTP id y5mr10897737ioq.200.1631573026247;
        Mon, 13 Sep 2021 15:43:46 -0700 (PDT)
Received: from [192.168.1.116] ([66.219.217.159])
        by smtp.gmail.com with ESMTPSA id t25sm5334169ioh.51.2021.09.13.15.43.45
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 13 Sep 2021 15:43:45 -0700 (PDT)
Subject: Re: [PATCHSET 0/3] Add ability to save/restore iov_iter state
From:   Jens Axboe <axboe@kernel.dk>
To:     io-uring@vger.kernel.org, linux-fsdevel@vger.kernel.org
Cc:     torvalds@linux-foundation.org, viro@zeniv.linux.org.uk
References: <20210910182536.685100-1-axboe@kernel.dk>
Message-ID: <8a278aa1-81ed-72e0-dec7-b83997e5d801@kernel.dk>
Date:   Mon, 13 Sep 2021 16:43:44 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20210910182536.685100-1-axboe@kernel.dk>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 9/10/21 12:25 PM, Jens Axboe wrote:
> Hi,
> 
> Linus didn't particularly love the iov_iter->truncated addition and how
> it was used, and it was hard to disagree with that. Instead of relying
> on tracking ->truncated, add a few pieces of state so we can safely
> handle partial or errored read/write attempts (that we want to retry).
> 
> Then we can get rid of the iov_iter addition, and at the same time
> handle cases that weren't handled correctly before.
> 
> I've run this through vectored read/write with io_uring on the commonly
> problematic cases (dm and low depth SCSI device) which trigger these
> conditions often, and it seems to pass muster.
> 
> For a discussion on this topic, see the thread here:
> 
> https://lore.kernel.org/linux-fsdevel/CAHk-=wiacKV4Gh-MYjteU0LwNBSGpWrK-Ov25HdqB1ewinrFPg@mail.gmail.com/
> 
> You can find these patches here:
> 
> https://git.kernel.dk/cgit/linux-block/log/?h=iov_iter

Al, Linus, are you OK with this? I think we should get this in for 5.15.
I didn't resend the whole series, just a v2 of patch 1/3 to fix that bvec
vs iovec issue. Let me know if you want the while thing resent.

-- 
Jens Axboe

