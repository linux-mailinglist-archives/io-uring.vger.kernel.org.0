Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9886320C88D
	for <lists+io-uring@lfdr.de>; Sun, 28 Jun 2020 16:48:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726598AbgF1Os0 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sun, 28 Jun 2020 10:48:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34368 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726576AbgF1OsZ (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sun, 28 Jun 2020 10:48:25 -0400
Received: from mail-wr1-x442.google.com (mail-wr1-x442.google.com [IPv6:2a00:1450:4864:20::442])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4AEECC03E979
        for <io-uring@vger.kernel.org>; Sun, 28 Jun 2020 07:48:25 -0700 (PDT)
Received: by mail-wr1-x442.google.com with SMTP id q5so14064487wru.6
        for <io-uring@vger.kernel.org>; Sun, 28 Jun 2020 07:48:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:references:from:autocrypt:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=LuWUy41BJKvraAujxbgEDiaZgeoftlr9ccwN8sBfg+U=;
        b=pHWBxyX0h77sNFcbojbudXx/Nh5C3tJdFpypRNBOvIHQcLGm6EYuWpZ5rSB83Npsn8
         XukyAW48UM90FhiygdA7eV0QiUm2+ex8J9usGOnPJcIOjyUE/UG5AvWhl/q1Iq9uexqe
         P7XtyYzJ1VKoGrUizFBTDbhqMJuEf1FeJ9x+bu4/3DvDWS27O/TLdYsXzluBLpW6h43S
         B4J/KMpyw4YmRCgjvtfwYatgSZE9LF9MfzlTbUF+Vguxj9NNxZ4KIewUmRg8JW2dmwKF
         OFVGcf5J4dSywsJ9gBEVVYFUf8aV+a0jc5kDiH9QZ2t/mEwvWVI8d7wEAsA7kJwhTmIS
         pddw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:autocrypt:message-id
         :date:user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=LuWUy41BJKvraAujxbgEDiaZgeoftlr9ccwN8sBfg+U=;
        b=nCOPBqVnIus4ENjhLSP9EyCA3kpK9EjNCXja/bq5hjJj1biZeZrYFt7UoJ8fQ+XE+g
         BfPmRRaiAifmMLusMh5EZ5NaaCROOZJfa6y5PoEyoVVjJKcwNjg6H/yoHtpmRHaUZ+B5
         v+26KGdN6xPSyesYs/DwzEjPM9yNJGupEzyGom0aMa9zAVotpZeG0Ly2B8MdoMtKG0iW
         zdC+4FcjaYZFWUg+hvC30Va4mNCneTGv9OHyXQ8+KzJAUkoXIC03HrO4wbjQskK8EahH
         z4MjWKT789Fh4utbjfYm4a9m4JAg2nui3OthMh2xtMIsD5wPHUPajdV+KwJYIdh7Cj1y
         rTgA==
X-Gm-Message-State: AOAM533iExqbqfBMryaKycE1f5309kddseWh1k67pTpKK+RWZ+vVz80b
        Sx+h71F5186va8vTog8FPeW0T006
X-Google-Smtp-Source: ABdhPJxZVpS4tgCiI9f/bJQbgi5615QCCEu1znPTQYVjKfPeNzNY6hVHrgu8J1QIobzsI9Y9vmwiig==
X-Received: by 2002:a5d:6107:: with SMTP id v7mr12896977wrt.174.1593355703630;
        Sun, 28 Jun 2020 07:48:23 -0700 (PDT)
Received: from [192.168.43.39] ([5.100.193.85])
        by smtp.gmail.com with ESMTPSA id b10sm24353269wmj.30.2020.06.28.07.48.20
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 28 Jun 2020 07:48:22 -0700 (PDT)
Subject: Re: [PATCH 0/5] "task_work for links" fixes
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
References: <cover.1593253742.git.asml.silence@gmail.com>
 <05084aea-c517-4bcf-1e87-5a26033ba8eb@kernel.dk>
From:   Pavel Begunkov <asml.silence@gmail.com>
Autocrypt: addr=asml.silence@gmail.com; prefer-encrypt=mutual; keydata=
 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 bA==
Message-ID: <328bbfe9-514e-1a50-9268-b52c95f02876@gmail.com>
Date:   Sun, 28 Jun 2020 17:46:47 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.3.0
MIME-Version: 1.0
In-Reply-To: <05084aea-c517-4bcf-1e87-5a26033ba8eb@kernel.dk>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 28/06/2020 16:49, Jens Axboe wrote:
> On 6/27/20 5:04 AM, Pavel Begunkov wrote:
>> All but [3/5] are different segfault fixes for
>> c40f63790ec9 ("io_uring: use task_work for links if possible")
> 
> Looks reasonable, too bad about the task_work moving out of the
> union, but I agree there's no other nice way to avoid this. BTW,
> fwiw, I've moved that to the head of the series.

I think I'll move it back, but that would need more work to be
done. I've described the idea in the other thread.

-- 
Pavel Begunkov
