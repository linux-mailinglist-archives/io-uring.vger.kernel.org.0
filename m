Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 46ADE3EC9DE
	for <lists+io-uring@lfdr.de>; Sun, 15 Aug 2021 17:16:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232896AbhHOPQc (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sun, 15 Aug 2021 11:16:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35450 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232412AbhHOPQc (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sun, 15 Aug 2021 11:16:32 -0400
Received: from mail-pj1-x1034.google.com (mail-pj1-x1034.google.com [IPv6:2607:f8b0:4864:20::1034])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7EA01C061764
        for <io-uring@vger.kernel.org>; Sun, 15 Aug 2021 08:16:02 -0700 (PDT)
Received: by mail-pj1-x1034.google.com with SMTP id om1-20020a17090b3a8100b0017941c44ce4so10150337pjb.3
        for <io-uring@vger.kernel.org>; Sun, 15 Aug 2021 08:16:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:references:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=AazDcWAlH0Poe4e4CltwNWA9S2ktv4tdQf1HjQJkx7g=;
        b=OZ7cQY5anQPa/WLkPsuxTo7/VCZeYw21jYywKmTfJ3aMvA6HJldLaH2SVh4pdl6jhy
         1464BJuIfGh0TxBYb8m88pBo1UWQfZ/0kosoziguEqwM747MA3MIrC2xb1huabT1kQAi
         P+VdrbDUUlS/UtXcgjij71E1Ste+qg2mtE1BRBFtcwD9gg8bgHBkc1JlCfNzT9D+L77u
         NxH3XtMWYkof4+MXr79cSMwIVqEShrruq7uEgvQEgX+eepr+cJ6IHwaPCuHROPmbVyDh
         g8fLGB1uN7REDor2NBRXyvazF5fKS/jfqOAPxchiCCIobw76saZOpn0MrEzQAqPc2cWA
         OSEg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=AazDcWAlH0Poe4e4CltwNWA9S2ktv4tdQf1HjQJkx7g=;
        b=KQ9pi1HTq8nsmEhAhSQdi10WMdpWBaoy49mJbXSbOFwTc6AHuzzKtW1xHjWr+fuNXi
         NJgW9cRP5wdV7tWaKSVBLiakEq3fdAix6vnD6eKestHpzz7OLu0fbqEZ/vmJzC4z5Yxp
         b5JwZEq5K16LeBM2wkGAm8zEykAIFcgaNJisau+rKGNPxzgdQqMrJuGuPk33MZleiFY1
         7cCDI8IHtgMcPbOtMxgAMr7wk9vxv29LTv1BehJNgL6Jcmft7apobdGUJ8Yw3Y6ljRD0
         u3XGqoh+GPu0HhyL81sKqIpoL7WA3DmAXKHZjW/zbiWhb5NtOHwxZ5QOR/IqEtprLAyR
         eamA==
X-Gm-Message-State: AOAM530yo25AFv94ujfyRI0Dr0/KoZOrCpqDHh1tAvmKnNn4LwvO0zAJ
        ebJHRqYLr/jIbajjH8EDOxeTC3WuWzCmznoq
X-Google-Smtp-Source: ABdhPJwtNP08mIFBAGazocbcV0CyBGDSnHuW/1tTNTu1+uhimp568TnUQH/Hx9mbVDG0Sd2/X7Qo9g==
X-Received: by 2002:a17:90a:8b12:: with SMTP id y18mr12539502pjn.72.1629040561519;
        Sun, 15 Aug 2021 08:16:01 -0700 (PDT)
Received: from [192.168.1.116] ([66.219.217.159])
        by smtp.gmail.com with ESMTPSA id g13sm6994337pfo.53.2021.08.15.08.16.00
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 15 Aug 2021 08:16:00 -0700 (PDT)
Subject: Re: [PATCH liburing 0/2] update linked timeout tests
To:     Pavel Begunkov <asml.silence@gmail.com>, io-uring@vger.kernel.org
References: <cover.1629020550.git.asml.silence@gmail.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <c701f801-4809-09d8-a46a-89752141c619@kernel.dk>
Date:   Sun, 15 Aug 2021 09:15:57 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <cover.1629020550.git.asml.silence@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 8/15/21 3:43 AM, Pavel Begunkov wrote:
> The main part is 2/2, which prepares the tests for early fail
> of invalid linked timeout SQE sequences.
> 
> Pavel Begunkov (2):
>   tests: close pipes in link-timeout
>   tests: fail early invalid linked setups

Applied, thanks.

-- 
Jens Axboe

