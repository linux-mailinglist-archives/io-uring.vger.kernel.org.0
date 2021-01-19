Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7C2192FC460
	for <lists+io-uring@lfdr.de>; Wed, 20 Jan 2021 00:06:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729200AbhASXC3 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 19 Jan 2021 18:02:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50752 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729240AbhASXCZ (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 19 Jan 2021 18:02:25 -0500
Received: from mail-pl1-x636.google.com (mail-pl1-x636.google.com [IPv6:2607:f8b0:4864:20::636])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D5F01C061757
        for <io-uring@vger.kernel.org>; Tue, 19 Jan 2021 15:01:44 -0800 (PST)
Received: by mail-pl1-x636.google.com with SMTP id d4so11418831plh.5
        for <io-uring@vger.kernel.org>; Tue, 19 Jan 2021 15:01:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:references:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=muOr2ircD3SCkzX8/e68Anu28fX0GfahMRA60YodagA=;
        b=fOn38tjdxoITx+3Bc5THazYDvcpWO+6pDv4CCJ61RlCRYtvkX3ODHQ4ujvuyosLNqN
         /rJfjIL+WXHgZRkAlgVCXpXqersIVfy7S0PXGSHV1U0DIx8fXAm/uZ1U2svf+dTUXbYB
         HISbb+KYZpsHfuvDyip5V/z/g8t7ANX0VvidZisR0I3zHLse9fKkDLWihH/Gwj5G1x0t
         ojCZY/99liTdzXK8TCr8StKmin6TXir9kM1LSfI+36yS5Ft2W7PUfQKYkTTQNIx6nUOk
         biGq293mYQ6OYQxCXZpb3PbrN8KXe5cI8tpsnK02H/kvVP4C/fbHEWVS6BITHpvJgknJ
         D6Cg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=muOr2ircD3SCkzX8/e68Anu28fX0GfahMRA60YodagA=;
        b=lS3HiFspKIaB3fDKdTKS+6rYfEVQltpcpNvpyMH9ksj/sWWjXWCrDj6gcLs5MHJdMv
         vEdPcSYlmGHn0W6eOPJFBeWyi15zqCol437xMK7p0b/OTXFC8pbFEUuoLR85t/fdHkSG
         yRITcslnlyHFm+Vnvbo8+JLBQmNNlPMmk+fbkkAcIhy8y5ihjFnV/EzYo9AT9xRWVwc9
         ZgXOc9oSr8HdGYYJTDW0GI1dnnHnDYzT6gIrtMkJcsoXhapv8btoIUHOy8FY5q7YfRsi
         NlRZKQY/LZkvalYHCKeyV19ugrgHU+pRGVhSMihNsDETd4juD4LrRjMbRoBJ7dedKQqS
         3C5Q==
X-Gm-Message-State: AOAM530C06DyL1UtrWRVNhAQBnNjHPjNN9FDOGUeO7H8mdyYbb5/3fEq
        Xuc7+pKSP7IdXKhaTj+HJ9RNkIK2OFZAgw==
X-Google-Smtp-Source: ABdhPJxyNUhc7A4jlyFDeZFPYRjB4zaT4xDIIirKG0IWNw8ugeUmGuzCeI2YDbQodlX5Goyd1qL5cg==
X-Received: by 2002:a17:90a:7c44:: with SMTP id e4mr2098248pjl.138.1611097304080;
        Tue, 19 Jan 2021 15:01:44 -0800 (PST)
Received: from [192.168.4.41] (cpe-72-132-29-68.dc.res.rr.com. [72.132.29.68])
        by smtp.gmail.com with ESMTPSA id o76sm146256pfg.164.2021.01.19.15.01.42
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 19 Jan 2021 15:01:43 -0800 (PST)
Subject: Re: [PATCH for-next 00/14] mostly cleanups for 5.12
To:     Pavel Begunkov <asml.silence@gmail.com>, io-uring@vger.kernel.org
References: <cover.1611062505.git.asml.silence@gmail.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <09f57e54-dc3c-e719-08c5-f9217bda7492@kernel.dk>
Date:   Tue, 19 Jan 2021 16:01:42 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <cover.1611062505.git.asml.silence@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 1/19/21 6:32 AM, Pavel Begunkov wrote:
> Easy patches that should not conflict with other stuff, actually based
> on 5.11 because it has more essential changes, but I'll rebase if
> doesn't apply after rc4 and 5.12 rebase/merge.
> 
> 1-11 are easy mostly cleanups, and 12-14 are optimisations that
> may end up to be preps.

Applied except 10/14 as mentioned, thanks!

-- 
Jens Axboe

