Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D3498296878
	for <lists+io-uring@lfdr.de>; Fri, 23 Oct 2020 04:22:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S374549AbgJWCWg (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 22 Oct 2020 22:22:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58600 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S374540AbgJWCWf (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 22 Oct 2020 22:22:35 -0400
Received: from mail-pl1-x62c.google.com (mail-pl1-x62c.google.com [IPv6:2607:f8b0:4864:20::62c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4A178C0613CF
        for <io-uring@vger.kernel.org>; Thu, 22 Oct 2020 19:22:34 -0700 (PDT)
Received: by mail-pl1-x62c.google.com with SMTP id 1so73204ple.2
        for <io-uring@vger.kernel.org>; Thu, 22 Oct 2020 19:22:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:from:to:cc:references:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=eRN4VvkSMjUAVDmvFO/IncAAF1JRwx57SYil1mK0hAM=;
        b=slXWMhQxek5pnsMwGTEvDRG4YA6tDbAOYvEjfIC8RRGgXggbmO/g/RencIIRqT6PCH
         lR2d3JcOdabY70CuW/ydgjEEgTTwRBHXnArQk/gCyp0N5WoHYZKEzWc1nrNLkB2qChD3
         bf/qf07/zzgoveQ+AZbBQ8I2DsHCkxHDhD4uGAnMOPE/GXYIN7aev4kKIVlUzJJk0/sm
         yKscOn+UlK4wfXhd8w3qFUPU3GF1sH2HnJcegEEFt4YrB7WDAKubaJ1uFQjqEtx+f7rG
         ycKCnNf1Dy7LCEe+vKWIt9cuRf1ivCYf8q0Xg3QGW2JSbHFG7BMaD90RI+m4lt5wZDoX
         H+zA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:cc:references:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=eRN4VvkSMjUAVDmvFO/IncAAF1JRwx57SYil1mK0hAM=;
        b=mT7rAfxrG4Qi10COyWJCPp3aooUkJyWcQGmOwvc/2Ze40mwV/A1toPiXPkNxxSCt6y
         xLFEusB89OzrG6sBFDLCiIf7LUWrdFQoxu4J0+3aAE4+h5uimYBbU2vIxYkuDjObsoAZ
         MNEIR0L3FnOYyNo/5HgCZBQGvYYHvk9vkE/YK3xHNWH/szpoejBx9nnA4Qc+YTXC/r3w
         HVrPvn3KpYjEmJ2KIp6J/HA5tRqC1VGc6WhPQ/Kq1saOetqfU2Gn0JuHK/qPEraZJdTW
         cqE5HA91baPe3CPQKJqcttQxAjKTipvBoMHgqpSWj56Bs1zVU49fMtuV6akGKRkFjXD4
         jI2g==
X-Gm-Message-State: AOAM531QeAD2r3pV8rx+Fv/OXLZITcgKsgc3A5EtPpFztDOE0iTZs/3c
        OByWFwiPnMw1csF5G0Z8UYbzAw==
X-Google-Smtp-Source: ABdhPJzgfYFUQi8ELACtuNjezZ830A5139WU+lqteVcVKP9/8bjfccP89Stp1zFoRmnIZEw68D1vYg==
X-Received: by 2002:a17:902:708a:b029:d4:cf7c:6c59 with SMTP id z10-20020a170902708ab02900d4cf7c6c59mr83549plk.52.1603419753508;
        Thu, 22 Oct 2020 19:22:33 -0700 (PDT)
Received: from [192.168.1.134] ([66.219.217.173])
        by smtp.gmail.com with ESMTPSA id il17sm138073pjb.39.2020.10.22.19.22.32
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 22 Oct 2020 19:22:32 -0700 (PDT)
Subject: Re: [PATCHSET v6] Add support for TIF_NOTIFY_SIGNAL
From:   Jens Axboe <axboe@kernel.dk>
To:     linux-kernel@vger.kernel.org, io-uring@vger.kernel.org
Cc:     peterz@infradead.org, oleg@redhat.com, tglx@linutronix.de
References: <20201016154547.1573096-1-axboe@kernel.dk>
Message-ID: <bf373428-bbc2-be66-db6b-0fa6352fa4ef@kernel.dk>
Date:   Thu, 22 Oct 2020 20:22:31 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20201016154547.1573096-1-axboe@kernel.dk>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 10/16/20 9:45 AM, Jens Axboe wrote:
> Hi,
> 
> The goal is this patch series is to decouple TWA_SIGNAL based task_work
> from real signals and signal delivery. The motivation is speeding up
> TWA_SIGNAL based task_work, particularly for threaded setups where
> ->sighand is shared across threads. See the last patch for numbers.
> 
> Cleanups in this series, see changelog. But the arch and cleanup
> series that goes after this series is much simpler now that we handle
> TIF_NOTIFY_SIGNAL generically for !CONFIG_GENERIC_ENTRY.

Any objections to this one? I just rebased this one and the full arch
series that sits on top for -git, but apart from that, no changes.

Thomas, would be nice to know if you're good with patch 2+3 at this
point. Once we get outside of the merge window next week, I'll post
the updated series since we get a few conflicts at this point, and
would be great if you could carry this for 5.11.

-- 
Jens Axboe

