Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6113C2DE658
	for <lists+io-uring@lfdr.de>; Fri, 18 Dec 2020 16:17:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728265AbgLRPRO (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 18 Dec 2020 10:17:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39110 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728264AbgLRPRO (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 18 Dec 2020 10:17:14 -0500
Received: from mail-pj1-x102b.google.com (mail-pj1-x102b.google.com [IPv6:2607:f8b0:4864:20::102b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 61D28C0617A7
        for <io-uring@vger.kernel.org>; Fri, 18 Dec 2020 07:16:34 -0800 (PST)
Received: by mail-pj1-x102b.google.com with SMTP id b5so1511333pjl.0
        for <io-uring@vger.kernel.org>; Fri, 18 Dec 2020 07:16:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:references:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=ib+66mEnNwN6+xrO+uveYlB20hQBFr3QJtH9NQsL3vc=;
        b=b81xZVakJ7t3oNOe2E2Q3FPcMvtl1GVhe6R6//0j0N/3T7/AIlhuzefJPWytbQi3Eb
         R42ojTLg2u9O46nfInhSHVfcQ7Aymwgt+OZ3D7D5m0gOGWPHBoqNVpmxEOSgOwk5jdKo
         WnBK1+kq+aB1jo71aCNdnBj2rC5NQqk/qag98P6ENvIW96nbcTxFHZZB6feWB+kr0Ck6
         UtxdUWgLWZ39RnYFl3Ti4tcFFw9xyG37YRfgvw+caLNsCraNUgSalHlmUxnbUIKdljdE
         tUDilZMazOa0iPRbecFhcrcwmvLAC4iKim8OJCt+mQCwbDdKnufZqauixuEgjkj6jo89
         Urkg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=ib+66mEnNwN6+xrO+uveYlB20hQBFr3QJtH9NQsL3vc=;
        b=eqW9V6HuaYa124DS77QKhcnncky7oBnhpuGJ7DfMx845/FOA0SG+ZioktishVYsAtn
         dGWr1/BwAD3aHG/beont7mD6R5njhIka/m7sFsstVjmZPUMK9QdEFF2CIrPp73h3RHiS
         MZPb3FPVhsLa3MlsYi6Q74oQSYY7CIkp55fTRVJdZwP/1m0e7f5/UyWkEbOVnWcmzDsu
         R8WO9NRsNqNXfKjrMlsJg31rKerL50c9gERzp1j4yu8SV6Ak+K6UMX86ht3MPhvj5YgV
         P9897slVHGxdg6bkbdUORROUO9J2g2dZ4ty5Oe04ANkbZbqAeDfj8KDAAef1+J8M/a9o
         iFPQ==
X-Gm-Message-State: AOAM5300JnHC+cDPBFQL/0prKAlt2atZS4IRMmo5eS0VjzhYItBdAqqN
        IX1ogK7s5DUFdBOZxNc4QVWe4y0HjftuwA==
X-Google-Smtp-Source: ABdhPJzCgDFmLtTYSOiZy2x+twxaVNThjYWjxphOuML+H81L1n0NLW3fU8tn+60fqV+ixXAScR+Qnw==
X-Received: by 2002:a17:90b:1894:: with SMTP id mn20mr4812072pjb.100.1608304593725;
        Fri, 18 Dec 2020 07:16:33 -0800 (PST)
Received: from [192.168.1.134] ([66.219.217.173])
        by smtp.gmail.com with ESMTPSA id s29sm9765766pgn.65.2020.12.18.07.16.32
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 18 Dec 2020 07:16:33 -0800 (PST)
Subject: Re: [PATCH 0/8] a fix + cancellation unification
To:     Pavel Begunkov <asml.silence@gmail.com>, io-uring@vger.kernel.org
References: <cover.1608296656.git.asml.silence@gmail.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <17d4ffd5-9d11-1ffe-cdee-cc114dedec4b@kernel.dk>
Date:   Fri, 18 Dec 2020 08:16:32 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <cover.1608296656.git.asml.silence@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 12/18/20 6:12 AM, Pavel Begunkov wrote:
> I suggest for 1/8 to go for current, and the rest are for next.
> Patches 2-8 finally unify how we do task and files cancellation removing
> boilerplate and making it easier to understand overall. As a bonus to it
> ->inflight_entry is now used only for iopoll, probably can be put into a
> union with something and save 16B of io_kiocb if that would be needed.

I've added 1/8 to the 5.11 mix for now, I'll get back to the other ones.

-- 
Jens Axboe

