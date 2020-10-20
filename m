Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 31E79293E53
	for <lists+io-uring@lfdr.de>; Tue, 20 Oct 2020 16:10:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2407887AbgJTOKm (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 20 Oct 2020 10:10:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37082 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2407859AbgJTOKm (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 20 Oct 2020 10:10:42 -0400
Received: from mail-il1-x144.google.com (mail-il1-x144.google.com [IPv6:2607:f8b0:4864:20::144])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B372EC061755
        for <io-uring@vger.kernel.org>; Tue, 20 Oct 2020 07:10:41 -0700 (PDT)
Received: by mail-il1-x144.google.com with SMTP id j13so2400933ilc.4
        for <io-uring@vger.kernel.org>; Tue, 20 Oct 2020 07:10:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:references:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=OL7g0Mc6CiIq1igDSgtNhQz/PlXZkr2epPIQoRLz3SE=;
        b=HRqDPpip/G4xcw6iFrazRmY67SFPR9VgAa4aKTVZTxlcIBLHm7pr/zWqutpG44eKH8
         XEA3Ig608SPClAcHSDQUoYwSD0s0kwNL7o8QUQPMrb8dua5WOxUvqIo29Usq18c1KIPY
         SpzEKpgqI4s/PRSa6gC/27Hposc+iZVCdNBch4JntSz5Dqc5R7B/cC8/f9zIxxTttGJP
         DnU2qRtppv4PDFXGv8wdkcDFZ8cLTAtd7UN5II6P3mamm9G4QYbsD/JIUapSda7wnd7e
         CZB9WG460I6/ubwAI3yHpsvwq+W68vODhWYN7MuvmmEBM5/7kGdYp85C77VMLK8bz0a9
         oU9g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=OL7g0Mc6CiIq1igDSgtNhQz/PlXZkr2epPIQoRLz3SE=;
        b=OBzPNfygpftc3+AVUr5qHWKM8e0i2ID9hPwdEwv//e6AkgbUp+DDt49ni43MOm/bTg
         O5Wmx8c8LH9bSx6ZE3i/L/2buWfrgAFeNzaWGP2RhMYiLVsgxkTMny9UvTY3hFbhkLI3
         P7UfP/ZKuBtvpKK5HY4oi1SerPRzFjLg03mhUa6GykTQFYgIqIba7C2SJ/DuXz6nZKJ+
         hdU+hUtxfvJYAP+Agx3tc8kCslMuBHuTkObpBZeGSTLprBj0kW7SO7C/v4k0wLYoP2CY
         ogTONGz2OK6bWGxfmTv1jCQzCe1fui7LH5OrHNJu33SQbXKoVXnn/PWLowovkNjuCCan
         NGAw==
X-Gm-Message-State: AOAM533beAgy4HtiJEb5yf1pboaQHZ9Qa7QQMk4VPkwftVbwW2YNEv6g
        DW2zD/DiZ/r8XSa5XEbDVYQDdOYFH/mJDA==
X-Google-Smtp-Source: ABdhPJz442xnVoDzja+g5QAJkayxmXxIKdk/jPu0THKccl1Cbs9eqMoE/0F4f7H9WmNe635sMIagfA==
X-Received: by 2002:a92:8b41:: with SMTP id i62mr2250501ild.9.1603203040895;
        Tue, 20 Oct 2020 07:10:40 -0700 (PDT)
Received: from [192.168.1.30] ([65.144.74.34])
        by smtp.gmail.com with ESMTPSA id g8sm1752080ioh.54.2020.10.20.07.10.40
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 20 Oct 2020 07:10:40 -0700 (PDT)
Subject: Re: [PATCH 1/1] io_uring: fix racy REQ_F_LINK_TIMEOUT clearing
To:     Pavel Begunkov <asml.silence@gmail.com>, io-uring@vger.kernel.org
References: <5a8d5c3e3445a2f06070d827f15b4a04fac82076.1603120597.git.asml.silence@gmail.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <75c418ca-ba0a-0cdd-24ec-ef6dc5b4fe2f@kernel.dk>
Date:   Tue, 20 Oct 2020 08:10:39 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <5a8d5c3e3445a2f06070d827f15b4a04fac82076.1603120597.git.asml.silence@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 10/19/20 9:39 AM, Pavel Begunkov wrote:
> io_link_timeout_fn() removes REQ_F_LINK_TIMEOUT from the link head's
> flags, it's not atomic and may race with what the head is doing.
> 
> If io_link_timeout_fn() doesn't clear the flag, as forced by this patch,
> then it may happen that for "req -> link_timeout1 -> link_timeout2",
> __io_kill_linked_timeout() would find link_timeout2 and try to cancel
> it, so miscounting references. Teach it to ignore such double timeouts
> by marking the active one with a new flag in io_prep_linked_timeout().

Applied, thanks.

-- 
Jens Axboe

