Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8FBB7235397
	for <lists+io-uring@lfdr.de>; Sat,  1 Aug 2020 19:03:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726534AbgHARDk (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sat, 1 Aug 2020 13:03:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40306 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727904AbgHARDk (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sat, 1 Aug 2020 13:03:40 -0400
Received: from mail-pg1-x542.google.com (mail-pg1-x542.google.com [IPv6:2607:f8b0:4864:20::542])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1AE9EC06174A
        for <io-uring@vger.kernel.org>; Sat,  1 Aug 2020 10:03:40 -0700 (PDT)
Received: by mail-pg1-x542.google.com with SMTP id p3so17622541pgh.3
        for <io-uring@vger.kernel.org>; Sat, 01 Aug 2020 10:03:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:references:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=zvhP+JMA/dEllbo3oCJGxPVR4nrKQ2we50OsqYjwgjg=;
        b=bz1fpGctgTvpk9i3wU6T5eHiRyFQntlME1ynIfPenA5753EgrqJ3OUkr3IyFs1fiA+
         9FaPb8o6QPAspo1q26ACoZ1EhXSF5SOumzE4tTYeHi1fhWJx9vuQvcQWeiNO8zpjdCma
         XzkapDzxtXfNHpaar4eeN3wSEw/llBnO3X8DH5w7Hma/VRTyHZ+ZmUUmHBC+LtEoJt5w
         zsPPwJnhnAN4BwSQlYtWxiWbplwDvZVzZ/KfQsycHFKw582Wa03m3oDXjST0GO5WpYBc
         MDkKcaMZX0zCOG10muPFUujmQrRB6DKV+6V3vHII5CFwY+yUuodFkotg4uZIOf5OmonN
         EZ+Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=zvhP+JMA/dEllbo3oCJGxPVR4nrKQ2we50OsqYjwgjg=;
        b=YaXNsO0OfpTiAeLYKO4F5V197NY7foPEON5yDrEucmjTUNFAQwqPNrNmoTK+cfdrND
         Rb9qR7N0BGy2kjKFT4OYuDiCG3HTkyafrPR19/Epz3nvVz0UuK/bMwzSEjLYPY9KexNa
         Vf1lm0p47n1ueppzHlb3rhLwNmu9j+BFHWm1t7wVjFxTvFz+ep3bnN5KLhXGf3nYr4Iu
         ItABzHj4e8MXKSn3dQLHX//WLXFylTqBO01vlnGLlbOqp4FPV+qufxcT9NF2aOrQe6Hs
         5Wh73z1D9BCHXhCIkZK9bqkngFN61IFf5qQVgOCPCdr79rluYw5GXv9YZIgdkJp+w9PR
         9RFQ==
X-Gm-Message-State: AOAM531CMy5TNmBIMmh21tCeVoPcrYgR9FhHPXllM8vK+UYQw6mnqZ93
        nHdUh9UVQYSeUemNx9hyMuPDephsUsQ=
X-Google-Smtp-Source: ABdhPJyZUjc9B38z7RRXuxjyB3ZNgsGAWOCMcvbxpw2peJHeK/Y7CyicyBiBK208YZOjlAu4utXA+Q==
X-Received: by 2002:a62:78d6:: with SMTP id t205mr9025623pfc.68.1596301419363;
        Sat, 01 Aug 2020 10:03:39 -0700 (PDT)
Received: from [192.168.1.182] ([66.219.217.173])
        by smtp.gmail.com with ESMTPSA id w70sm14094105pfc.98.2020.08.01.10.03.38
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 01 Aug 2020 10:03:38 -0700 (PDT)
Subject: Re: [PATCH] io_uring: flip if handling after io_setup_async_rw
To:     Pavel Begunkov <asml.silence@gmail.com>, io-uring@vger.kernel.org
References: <b5a869f3f739854a0458cc32be9af96e79b62dbc.1596275586.git.asml.silence@gmail.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <90fc3c0d-054f-4abf-ad5d-623609335a34@kernel.dk>
Date:   Sat, 1 Aug 2020 11:03:37 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <b5a869f3f739854a0458cc32be9af96e79b62dbc.1596275586.git.asml.silence@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 8/1/20 4:50 AM, Pavel Begunkov wrote:
> As recently done with with send/recv, flip the if after
> rw_verify_aread() in io_{read,write}() and tabulise left bits left.
> This removes mispredicted by a compiler jump on the success/fast path.

Applied, thanks.

-- 
Jens Axboe

