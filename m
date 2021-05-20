Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 18CAC38AC7E
	for <lists+io-uring@lfdr.de>; Thu, 20 May 2021 13:40:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240504AbhETLkf (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 20 May 2021 07:40:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44062 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242129AbhETLiv (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 20 May 2021 07:38:51 -0400
Received: from mail-wr1-x430.google.com (mail-wr1-x430.google.com [IPv6:2a00:1450:4864:20::430])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A9AD4C049807
        for <io-uring@vger.kernel.org>; Thu, 20 May 2021 03:11:29 -0700 (PDT)
Received: by mail-wr1-x430.google.com with SMTP id c14so15255432wrx.3
        for <io-uring@vger.kernel.org>; Thu, 20 May 2021 03:11:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=to:references:from:subject:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=gfU/P0CZgOFGjGPBxOxJFVpmD14eY9VFXEeDmqe7Vgw=;
        b=RLmbfHfBGffx2jRAn0cFrL6R0c8B+cTNPGf+xnSO/UwG+oRiFdNBdoOMxQyIl7aLWu
         2As6qOVEgZrxagrdJ5GFGIXg2p7A2IqBNxROTk+ve/iAnnl0qnQ4969bt74JZMoGpbXy
         wLP7jD53bYXAjFQzc4cmi7UnmwsPTnuau0m9kKcI/C5U0yJk2PvNqURaTI0AlmsOTfeP
         /Y4qqwOUwKpF/dq//UR8BsdvRxMhHoSFzRgQMBGCX8oU1PECH/plaz8a1fmVXTEcre/R
         fZciui2szijJm2QnjfObcnRHJdxiL3YFZDdYeuooiw4BvrcQ56EeX8H5tr57WP6DNHyK
         jrdw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:to:references:from:subject:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=gfU/P0CZgOFGjGPBxOxJFVpmD14eY9VFXEeDmqe7Vgw=;
        b=tzPuerE1I2qUbkGXuUS92qbd+DlLFThf7ZnLRZL+h2ZaFiTsRcviceFKEpMXOwcPGN
         WO0BlqTD38m39R1dWivh3XYmaGKykd1gag7ROAqwf4as3lX2nITDbQPzkkoovsiq6xeS
         BK+jFG3I7V6SU4AnEjKo6vil7ULUAoWfqLqT3aEcnfnXk3dxNVzu1x+UkdqThMSFocQ1
         NWeEFkH3B2K1dPeeEBX2QIJMjiUKUFxNeQxUOzrHiwChf3RODZkikkqH6XhoOIE4Z8vA
         6LDap3Sol0MnXZ19KDhhMw17ePbVRrVJyfvTYUgJGflCHbfEoST/QzSI3Y7Iq9uQUpJJ
         Rurg==
X-Gm-Message-State: AOAM533Zf/CAstTsreNtxAqcV55hL24dgGrzskkQkRu12AeJr9lFPv5D
        h7AfyvE+qjXPhJ4/PmMh3UKHUibIM0ieWTAL
X-Google-Smtp-Source: ABdhPJxuqaGq5Gx7OTCqs6fed/XodwmCAEj0KUYSaJbb4yoTO2D4gDSyzyiJZ0XDwCwmcLtFL/EUFA==
X-Received: by 2002:a05:6000:52:: with SMTP id k18mr3401134wrx.419.1621505488041;
        Thu, 20 May 2021 03:11:28 -0700 (PDT)
Received: from ?IPv6:2620:10d:c096:310::2810? ([2620:10d:c093:600::2:130f])
        by smtp.gmail.com with ESMTPSA id y3sm2611576wrh.28.2021.05.20.03.11.27
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 20 May 2021 03:11:27 -0700 (PDT)
To:     Drew DeVault <sir@cmpwn.com>, io-uring@vger.kernel.org
References: <CBHHFOFELZZ3.C2MWHZF690NB@taiga>
From:   Pavel Begunkov <asml.silence@gmail.com>
Subject: Re: Confusion regarding the use of OP_TIMEOUT
Message-ID: <740c1a20-f160-2ce4-708a-ecc0a8f33283@gmail.com>
Date:   Thu, 20 May 2021 11:11:20 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.1
MIME-Version: 1.0
In-Reply-To: <CBHHFOFELZZ3.C2MWHZF690NB@taiga>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 5/19/21 8:51 PM, Drew DeVault wrote:
> Hi folks! I'm trying to use IO_TIMEOUT to insert a pause in the middle
> of my SQ. I set the off (desired number of events to wait for) to zero,
> which according to the docs just makes it behave like a timer.

Right

> 
> Essentially, I want the following:
> 
> [operations...]
> OP_TIMEOUT
> [operations...]
> 
> To be well-ordered, so that the second batch executes after the first.
> To accomplish this, I've tried to submit the first operation of the
> second batch with IO_DRAIN, which causes the CQE to be delayed, but

...causes request submission (i.e. execution) to be delayed to be
exact, not CQE. But anyway sounds workable to me. (if timeout works
well) the second should not be submitted earlier than
submission_time + timeout. Or if timeout is marked DRAIN as well
would be batch1_completion_time + timeout.

> ultimately it fails with EINTR instead of just waiting to execute.

Does some request fails and you find such a CQE (which request?)?
Or a syscall? submission or waiting?

> I understand that the primary motivator for OP_TIMEOUT is to provide a
> timeout functionality for other CQEs. Is my use-case not accomodated by
> io_uring?

-- 
Pavel Begunkov
