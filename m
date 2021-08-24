Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 55E2A3F68BE
	for <lists+io-uring@lfdr.de>; Tue, 24 Aug 2021 20:04:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234486AbhHXSFe (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 24 Aug 2021 14:05:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43390 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233145AbhHXSFe (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 24 Aug 2021 14:05:34 -0400
Received: from mail-pl1-x630.google.com (mail-pl1-x630.google.com [IPv6:2607:f8b0:4864:20::630])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DBFEAC061764
        for <io-uring@vger.kernel.org>; Tue, 24 Aug 2021 11:04:49 -0700 (PDT)
Received: by mail-pl1-x630.google.com with SMTP id j2so8301482pll.1
        for <io-uring@vger.kernel.org>; Tue, 24 Aug 2021 11:04:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:references:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=hQDEKkSoig9y1CBEukh9Rw6DjHiQ4iqC1GEfn4iqR10=;
        b=ZK9qe23EuhPHRNUt0dTds0ajePU7QgL1ZVQQFP9jeMX216wnjsYX/Q2pMs0llKbZV3
         p5AtxFdwS7PovI8PcgvQ5nI7d9049JRsdFWo33Ds+Nr9BKi4iOvFgWWniTvm13k6v/MN
         G/i6U/7fK/f0SAa017kubNf5bQH7f2Ci0nmlyWZYjALYAaBcjeBYno1rjzPezy14boD7
         0Qd3gNWyns8OyrzAGA0pgi0ViT8R6eR1XOpUrJd6Gnz5YRxddHbfOIO3yiN87XpMLWiF
         czrvm9kpVq6ijG0z0MWVwHU/e7VgWNdd1XSMXoJwTyetu7sObVYku8KwLtFgje1aByku
         KCvw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=hQDEKkSoig9y1CBEukh9Rw6DjHiQ4iqC1GEfn4iqR10=;
        b=mO6VkhbtYSGHk3Ei8OCu6dYb17dfCz+WRPwM6IXSDTsIl/7dFg6js9yuESzCWbB2z5
         5VrBSM2h9ARklpTGo6h1gAQnzyTsM0Z1nKuW/BmH0FOFoA4vI457Kh0T1uJvbv5PVU3o
         fUIAeglrCyaoblNRvppMxVD1z1eUDOJC1MQ1oNk2fwiGKIrIsC1ASZPh+yCoq+pIEcP1
         kt+U7ApPpVvC8W7KsGx44wa5wmagy8702wRzro+DtP5FWjW8KDUNAxWsucltcsh0w/Fn
         rfwo2Iytsfg5Uq3RZJ4Ml++ZxEZ3tCwUkDk5abjFDCqYy/QQPFPI1y0TsFPfhl1VwXwy
         vJDg==
X-Gm-Message-State: AOAM533ik6ee5zzS/CgGNqnae+P0Mk59TGY6Dxgesl7DYovMuUjzqra7
        lWHqKUPUttVti3utEzjybf4O50B1wmlOyNXc
X-Google-Smtp-Source: ABdhPJygfX8O9JIjNplH2bScimea8qI7xs8WiR2ThVMvfMPzD34oBpgG3DeMwwI+7lI8wD2cETLB1A==
X-Received: by 2002:a17:902:b102:b0:134:a329:c2f8 with SMTP id q2-20020a170902b10200b00134a329c2f8mr9610509plr.71.1629828289080;
        Tue, 24 Aug 2021 11:04:49 -0700 (PDT)
Received: from ?IPv6:2600:380:4960:2a4d:1b63:8a6c:25bc:6edc? ([2600:380:4960:2a4d:1b63:8a6c:25bc:6edc])
        by smtp.gmail.com with ESMTPSA id h21sm3505805pgg.8.2021.08.24.11.04.48
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 24 Aug 2021 11:04:48 -0700 (PDT)
Subject: Re: [PATCH liburing 1/1] tests: fix poll-mshot-update
To:     Pavel Begunkov <asml.silence@gmail.com>, io-uring@vger.kernel.org
References: <7e588f712ec61e0ddc619ce016d1c3b9445716e1.1629826707.git.asml.silence@gmail.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <5565df54-2711-f732-2818-c8158f235e33@kernel.dk>
Date:   Tue, 24 Aug 2021 12:04:46 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <7e588f712ec61e0ddc619ce016d1c3b9445716e1.1629826707.git.asml.silence@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 8/24/21 11:38 AM, Pavel Begunkov wrote:
> poll-mshot-update constantly hangs. Apparently, the reason is
> reap_polls() clearing ->triggered flags racing with trigger_polls()
> setting them. So, reinit the flags only after joining the thread.
> 
> Also, replace magic constants with proper identificators, e.g.
> 1 -> IORING_POLL_ADD_MULTI.

Good catch!

-- 
Jens Axboe

