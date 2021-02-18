Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4117231F0FD
	for <lists+io-uring@lfdr.de>; Thu, 18 Feb 2021 21:29:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229919AbhBRU0n (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 18 Feb 2021 15:26:43 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38042 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230422AbhBRU0b (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 18 Feb 2021 15:26:31 -0500
Received: from mail-pf1-x431.google.com (mail-pf1-x431.google.com [IPv6:2607:f8b0:4864:20::431])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C4490C061756
        for <io-uring@vger.kernel.org>; Thu, 18 Feb 2021 12:25:51 -0800 (PST)
Received: by mail-pf1-x431.google.com with SMTP id u143so2075963pfc.7
        for <io-uring@vger.kernel.org>; Thu, 18 Feb 2021 12:25:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:references:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=WFt0OkNCCtCnxUwyJpUNR2oK8WDog/BKe1xZCi4vICI=;
        b=HJ8fxmtg0qUaQ6ytcezdzzltPvEMBUAvl4l2PV30wBI4HF9toWwshCgDUXj5q1K1Wm
         EgDVFFr6NVcZqvtEC5or+qcx/tQCR76UJNVnzeP/M0lVnqTi3nAZY1Boxj+fsyvxIQD+
         v2KmW/pYwCXpjbKMZoUIRZSC6nQ+rmvp/TVxweHXJrEnvqg0XTsWkGFAl5BmFylyh5l0
         3TuYghU5v1NNmReNT/AROZ4383TKvwkVwN3pF+FrYzhmvrY3FrDUexOwhXXYGuVUAaNg
         LNkci94wxzngGdWnsY+4qtQUEOA+TJLE9WAgKzziVou0x8hVQaZwwwDSaSNlV1XKpnv6
         cBwA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=WFt0OkNCCtCnxUwyJpUNR2oK8WDog/BKe1xZCi4vICI=;
        b=ao9er4ucdZKGo0jtrpnhwE0QBfv7sg3fYM3E3HpFxNvS+k50PAq8/PAGMykQV0cYy7
         px5/4sUnSzhZV3DU2bN3GfKcygLfPXRRMjLuOmSdc16y7oYVu6XE+9CUw5R2h63f1/t8
         HFb+5M2Ms1C1okMT1dkJVpvfwxS9KP2xK8ZfDE0aOfcXLjr78+O5VVtFB/78WAi6a7lq
         02I5e/Ottuw8t114xuZItf1mVkfH108MazO34l4JKHEl8iMgPvE6USN/eRX7gquw2ULU
         rAlHq4/ozWHjV23l/2dWPNfQJ/iKOSNJ6C0/K8YiZJTpdHXjuQwaRAdIdxCShBXASv8D
         RGqQ==
X-Gm-Message-State: AOAM531vjzB3jf4abShfHjQsnw/7nSOuGVa9zGK+vIHIiv9PE2NvhyIN
        O8AvuNHK9STPrbzKSan2LxJxBF6tVKEiBw==
X-Google-Smtp-Source: ABdhPJzPeBgesnyJUef5p7+rBNWmBIzIgm8fnkHN1XNJuAlDHWhvuWrEvmWtEaG9+A8nS0VYhqoQ5w==
X-Received: by 2002:a63:461d:: with SMTP id t29mr5421485pga.192.1613679951051;
        Thu, 18 Feb 2021 12:25:51 -0800 (PST)
Received: from [192.168.1.134] ([66.219.217.173])
        by smtp.gmail.com with ESMTPSA id h8sm6428808pfv.154.2021.02.18.12.25.50
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 18 Feb 2021 12:25:50 -0800 (PST)
Subject: Re: [PATCH 00/11] submission path cleanups and optimisation
To:     Pavel Begunkov <asml.silence@gmail.com>, io-uring@vger.kernel.org
References: <cover.1613671791.git.asml.silence@gmail.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <de91ee40-af76-3213-f2ee-e385164271d3@kernel.dk>
Date:   Thu, 18 Feb 2021 13:25:49 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <cover.1613671791.git.asml.silence@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 2/18/21 11:29 AM, Pavel Begunkov wrote:
> Refactor how we do io_req_prep(), which is currently spilled across
> multiple ifs and functions, that's a mess which is hard to validate.
> It also cuts down amount of work we're doing during submission, where
> nops(batch=32) test shows 15217 vs 16830 KIOPS, before and after
> respectively.
> 
> 1-6 are easy and should change nothing functionally.
> 
> 7/11 cancels all the link, where currently it can be partially executed.
> That happens only in some cases, and currently is not consistent. That
> change alters the user visible behaviour and breaks one liburing test,
> but looks like the right thing to do. (IMHO, the test is buggy in that
> regard).
> 
> 8/11 makes us to do one more opcode switch for where we previously
> were doing io_req_defer_prep(). That includes all links, but the total
> performance win, removing an extra async setup in 10/11, and just making
> all the thing cleaner justifies it well enough.

Looks good and tests good, I'm going to queue this up for 5.12 as it'll
be easier for later fixes too.

-- 
Jens Axboe

