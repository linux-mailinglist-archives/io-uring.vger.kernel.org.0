Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 20A6A1F7A8B
	for <lists+io-uring@lfdr.de>; Fri, 12 Jun 2020 17:16:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726257AbgFLPQV (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 12 Jun 2020 11:16:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34932 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726085AbgFLPQV (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 12 Jun 2020 11:16:21 -0400
Received: from mail-pj1-x1033.google.com (mail-pj1-x1033.google.com [IPv6:2607:f8b0:4864:20::1033])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C7922C03E96F
        for <io-uring@vger.kernel.org>; Fri, 12 Jun 2020 08:16:20 -0700 (PDT)
Received: by mail-pj1-x1033.google.com with SMTP id ne5so3759013pjb.5
        for <io-uring@vger.kernel.org>; Fri, 12 Jun 2020 08:16:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=UCrHdKLCx3hRMwZHAdg0DDwTbcc5Psxh1fcWsWBlr4E=;
        b=kfBL7U52bxTsCEDomkzMljEikamArlpMkVv31vbAhaB4fj90AmUkYbFxieHRK/zOQF
         0CO5+rOrs+3Su6G9CzWgBDe/VE7HYLUUVF2t0tT7d6IxQPvzciU9d8ac0XOkcTvIvqqn
         uf7UL+7H6XyL8zjmDt/mkbhJvUYQXaG0856S0OmPoy7MyVLvtZGxpKroJQn2LnrtCLlF
         HIPeyQR23bCLcCsEOmgi+k/KqPmyNe/LR0HmlZaDuyrmfRBF5Pj11jWQyx6EHwQdNqMP
         z3ecEprjfSC5NB5Iczg95lYEVULCRbVISB9IsRb3U9tEtbFV1g5bOGEL4QylXOsP5t6O
         XAMg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=UCrHdKLCx3hRMwZHAdg0DDwTbcc5Psxh1fcWsWBlr4E=;
        b=P2Kb+y4xKxK6wyrrfBny/X3+Ww1o1SWUHNGwsgNf2JVzJzTSBxd8AIHVTe1r1F1k8P
         +DjfZm4WkRuz+QvIJdHII3WuAnt5319PPzDsVoyKswVQlAi/EIvZuC3K0Zv/JIiu/DZm
         wfNigPrWL3Z8qi2qht9L+heRH6WAug9eSXy/yUGHuGspR7ZJqiqSr6PaaxBTLKLO1GDJ
         y3i+c3F3iOJgey9OKsPsX+tkrZ5ccdxmuLCWxzBZ+nvN9iOU/BrPiNYQJGaziwwhYRs3
         CDRc/ZF0f0jo4jARBwB7cl7xd69xHg5avUDD/vVsIg/2wcmdCvvA4jAdnjWVoSK+Mv88
         +W/w==
X-Gm-Message-State: AOAM531g+HPimMQwp9HfSfsXhiqZ0ooIHR2Yq21BrOgLYFcz2oI1yis7
        0Jfa8ZQMNQqEyM323fb9vjGpnPNqFbjDrQ==
X-Google-Smtp-Source: ABdhPJzjJ8yVH63e89kuuOD1q9znZi7pI5gKcCMW4zVTn+BnH3WX5HzlJvnL59AFyC3ViPxtkZbWoA==
X-Received: by 2002:a17:90a:d206:: with SMTP id o6mr12237595pju.132.1591974979419;
        Fri, 12 Jun 2020 08:16:19 -0700 (PDT)
Received: from [192.168.1.188] ([66.219.217.173])
        by smtp.gmail.com with ESMTPSA id d22sm5777525pgh.64.2020.06.12.08.16.18
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 12 Jun 2020 08:16:18 -0700 (PDT)
Subject: Re: [RFC 1/2] io_uring: disallow overlapping ranges for buffer
 registration
To:     Bijan Mottahedeh <bijan.mottahedeh@oracle.com>
Cc:     io-uring@vger.kernel.org
References: <1591928617-19924-1-git-send-email-bijan.mottahedeh@oracle.com>
 <1591928617-19924-2-git-send-email-bijan.mottahedeh@oracle.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <b33937c3-6dbb-607a-d406-a2b42f407d86@kernel.dk>
Date:   Fri, 12 Jun 2020 09:16:17 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.8.0
MIME-Version: 1.0
In-Reply-To: <1591928617-19924-2-git-send-email-bijan.mottahedeh@oracle.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 6/11/20 8:23 PM, Bijan Mottahedeh wrote:
> Buffer registration is expensive in terms of cpu/mem overhead and there
> seems no good reason to allow overlapping ranges.

There's also no good reason to disallow it imho, so not sure we should
be doing that.

-- 
Jens Axboe

