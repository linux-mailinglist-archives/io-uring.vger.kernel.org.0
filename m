Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4B14828F4FC
	for <lists+io-uring@lfdr.de>; Thu, 15 Oct 2020 16:43:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388734AbgJOOnr (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 15 Oct 2020 10:43:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59452 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388728AbgJOOnq (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 15 Oct 2020 10:43:46 -0400
Received: from mail-il1-x143.google.com (mail-il1-x143.google.com [IPv6:2607:f8b0:4864:20::143])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4A255C061755
        for <io-uring@vger.kernel.org>; Thu, 15 Oct 2020 07:43:46 -0700 (PDT)
Received: by mail-il1-x143.google.com with SMTP id z2so2921049ilh.11
        for <io-uring@vger.kernel.org>; Thu, 15 Oct 2020 07:43:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=Qcgv+2yJUkH/T84kDkk4JbFTa/M9KcP0jfRpeslZ3LQ=;
        b=xmhP1BAAEgSIceO9muBHRjD/8G8w9XY4UWUzPhZBaRXQTiTwE93iK3FVfjB2V/t7cJ
         LRGcPtuc6dsRJhiVXZmU3NnXRuOb/PBwGiP+w9SbqHDcZaFJP5psBWLTrQxL1N+HX9uM
         lH/yY0yHWCLTLoAQ/Gjv1ECJwg6q4dLmHyiCQftPDRTV4xbSgefgtWAII459zA1P78Uv
         qVMLS1Z2iq6FzYmuDFaAgf/UIND9h6uOHL9YvoF2SiGdCwkqKxATAKP271doD6q+GKR2
         LSNjHgvapx22dqL5hw4FrBB/IQigmI/ilXQ4K3+QrhkDDA804nhuLbYX6v3nZj3IL+1W
         qY5Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=Qcgv+2yJUkH/T84kDkk4JbFTa/M9KcP0jfRpeslZ3LQ=;
        b=Q5R6lHTl6jJurOud4cH0LpztRc0hmMc+5PHhuhSQJVVLM4uGpKB5e3IbsL/gCf67YZ
         zMyAnnsfQWxAEs5NRI1wKAu4rVzti0+Rec5lQYeqP6VNLBJLAVMr7heLnxOI0muae9HK
         5oZV7MGZnQYFbD2jSIMxJ5WXFU6rHVhZKBO7qr8Nkpr43i6kP2gbK54Kcy/cK67ZJrHA
         GF4r56NKOvCpeL1p0VCHTQ6vL8zk/WzbkYt2VIoPwxXIgtuJWQwtLVJM6VuSc+niJfWL
         3bSu9YwWgRDsfyptZYW7djBZFO1vjJjuVjqSgfRR+yZQCm6LEuQ8l9KU4JZd6qG2T+DS
         tmnQ==
X-Gm-Message-State: AOAM531hFPRA8MHWSacFZpw1+EJmhR5vdAvHFmfrYxfpw/29Lb5mCthr
        CfiFT8k2aTlf7NTW2mBB8Lh/EQ==
X-Google-Smtp-Source: ABdhPJw3SnuM0CVnK+/LFdSp3qvCJ9+lQUg3YjgomaKAmVOoLG3gV1oFjuJzuzYgO1Kb0eq5F1T25w==
X-Received: by 2002:a92:c986:: with SMTP id y6mr3384387iln.10.1602773025483;
        Thu, 15 Oct 2020 07:43:45 -0700 (PDT)
Received: from [192.168.1.30] ([65.144.74.34])
        by smtp.gmail.com with ESMTPSA id s77sm3479346ilk.8.2020.10.15.07.43.44
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 15 Oct 2020 07:43:44 -0700 (PDT)
Subject: Re: [PATCH 1/5] tracehook: clear TIF_NOTIFY_RESUME in
 tracehook_notify_resume()
To:     Oleg Nesterov <oleg@redhat.com>
Cc:     linux-kernel@vger.kernel.org, io-uring@vger.kernel.org,
        peterz@infradead.org, tglx@linutronix.de
References: <20201015131701.511523-1-axboe@kernel.dk>
 <20201015131701.511523-2-axboe@kernel.dk> <20201015144207.GF24156@redhat.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <3cdc9a4e-1133-201f-b737-e4e73185d193@kernel.dk>
Date:   Thu, 15 Oct 2020 08:43:44 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20201015144207.GF24156@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 10/15/20 8:42 AM, Oleg Nesterov wrote:
> On 10/15, Jens Axboe wrote:
>>
>> All the callers currently do this, clean it up and move the clearing
>> into tracehook_notify_resume() instead.
>>
>> Reviewed-by: Thomas Gleixner <tglx@linutronix.de>
>> Signed-off-by: Jens Axboe <axboe@kernel.dk>
> 
> in case you didn't notice I already acked this change ;)
> 
> Reviewed-by: Oleg Nesterov <oleg@redhat.com>

Apparently I missed that - thanks, added!

-- 
Jens Axboe

