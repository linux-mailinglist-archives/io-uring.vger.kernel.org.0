Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 493451A906C
	for <lists+io-uring@lfdr.de>; Wed, 15 Apr 2020 03:30:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2392570AbgDOBaD (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 14 Apr 2020 21:30:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59148 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S2387762AbgDOBaB (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 14 Apr 2020 21:30:01 -0400
Received: from mail-pj1-x1043.google.com (mail-pj1-x1043.google.com [IPv6:2607:f8b0:4864:20::1043])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 57A51C061A0C
        for <io-uring@vger.kernel.org>; Tue, 14 Apr 2020 18:30:00 -0700 (PDT)
Received: by mail-pj1-x1043.google.com with SMTP id b7so6093210pju.0
        for <io-uring@vger.kernel.org>; Tue, 14 Apr 2020 18:30:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:references:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=tw1ol9hIySF4SEjxnV31z4ZCVunCJuhUBUf/qto1qDk=;
        b=laMZ5Nan8iiNRpSb5q9KzmAhNq0103cgg0P5iWhae9Qsi/x3SVW2rFTff9y7AW73lo
         8F4fnFznO5VZOoCeCsX0mzLIUv89kNsfmOe9fYYqAub8BAo8aK4+XqBPPmYJOc9kBVPh
         3qYGgpDN5IPje/dughVgunhVwLRxi5cPfgL4ff8qxCYQK2icVh3o0oKs6ZpmyKDmgXWY
         ++NWG2mxot8LQD6vDjumovPtdoI88EPTBUCqMvZvDJ/VEzK/I6HiPd20caCi1hWE5/PI
         Et69wH51qCxh34ySRwZ8ziSniRw9A/3r80jRSi8eHvjhRM0V0bdMKH9DWKVZLUwk9rrm
         dytw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=tw1ol9hIySF4SEjxnV31z4ZCVunCJuhUBUf/qto1qDk=;
        b=Q4YvmhsITScGYUZrsO6axeuJgWikzIfSMaRH3mUOggi/987U9vr12mzmbLVaRqyjUC
         9+mAEBlqp9oC1IdkvdIyxyuoT83PpnJHV7+M2mqwonV6Bn7JQjXnCJnIXQ/jBYIQX91k
         yIGUgEtRmMUPGOx3M/Sb9gXqul8l9SMGpeIBlhrd35hfXm2Jtdz2UGwFTUBaUWYmYD18
         9/TCSz5UB6uk4GKFjnRBO4sf9skpNUun2B+DMQZffsJMi/sbp5mikWVFGG2yLrtUXF8x
         RxIax7zGIoC6bJMx2lWD3e6tcUvKswCiJns5jsHHHmij4MtfP5Rc8OnnAdaSdRGr4pv+
         ysAQ==
X-Gm-Message-State: AGi0PuYwJKzEeE7BINxmXH6HpzF3BABM8eYneIpRsbQeVnarqVo7jRhe
        guQzqkNHoT89LcYobTVs6u4CVA==
X-Google-Smtp-Source: APiQypKse0Vw4MTAK2eIDz+rkZLvUptgDnRhmyWoFDYLfNVx8BAvRbQCsJSge6k3bnsrPrr5WcPaSA==
X-Received: by 2002:a17:902:8487:: with SMTP id c7mr2378462plo.251.1586914199821;
        Tue, 14 Apr 2020 18:29:59 -0700 (PDT)
Received: from [192.168.1.188] ([66.219.217.145])
        by smtp.gmail.com with ESMTPSA id y9sm12551095pfo.135.2020.04.14.18.29.58
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 14 Apr 2020 18:29:59 -0700 (PDT)
Subject: Re: [PATCH 0/4] timeout and sequence fixes
To:     Pavel Begunkov <asml.silence@gmail.com>, io-uring@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <cover.1586899625.git.asml.silence@gmail.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <ddcd1626-83bd-3d25-32b9-d2308ba9b3ed@kernel.dk>
Date:   Tue, 14 Apr 2020 19:29:57 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.7.0
MIME-Version: 1.0
In-Reply-To: <cover.1586899625.git.asml.silence@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 4/14/20 3:39 PM, Pavel Begunkov wrote:
> [4/4] is dirty, but fixes the issue. And there is still "SQ vs CQ"
> problem, solving which can effectively revert it, so I suggest to
> postpone the last patch for a while. I'll rebase if it'd be necessary.
> 

Thanks, I've applied 1-3 for now. Looks good to me, and also tests out
fine.

-- 
Jens Axboe

