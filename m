Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BFCFF2D4380
	for <lists+io-uring@lfdr.de>; Wed,  9 Dec 2020 14:44:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732474AbgLINlE (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 9 Dec 2020 08:41:04 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57128 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732065AbgLINlE (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 9 Dec 2020 08:41:04 -0500
Received: from mail-wr1-x444.google.com (mail-wr1-x444.google.com [IPv6:2a00:1450:4864:20::444])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E42E1C0613CF;
        Wed,  9 Dec 2020 05:40:23 -0800 (PST)
Received: by mail-wr1-x444.google.com with SMTP id r7so1783740wrc.5;
        Wed, 09 Dec 2020 05:40:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=to:cc:references:from:autocrypt:subject:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=wb0v0Tpn/LXq5vifgNW6E6ooJIXyL4+/EUe6gXt5AjA=;
        b=YLkw3uBJNQEB6Ow8AdhJs3yXbIraHjok/LjIhoexxcT0cJnljaBQWafgsHhC1nThiK
         Am1A+K6ZryYfu1/pwAbfJbRYFLYb4ksS2yQL0pYIEoMczWHhR89QkVK4NtJY9WVB49FM
         Wg9y0pTE5B4/+9dDOKr4dUWU4XEDCN25THALfkkOL1pqsHY1bdg1V1rBVqKjCbs0xKU5
         pOt9AEZCi76wdzpCOxCdiGqZ+8RineobV6xSuDhUOxhKXvd0e4IyV+E+78mpL8AAI0vn
         V+rFxFna0ocaz+15ruJC7JSBoq2UgvknI6coyA6SY2HO5KddauwmHmHMdV9rqpVkHSHX
         Pqlg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:to:cc:references:from:autocrypt:subject
         :message-id:date:user-agent:mime-version:in-reply-to
         :content-language:content-transfer-encoding;
        bh=wb0v0Tpn/LXq5vifgNW6E6ooJIXyL4+/EUe6gXt5AjA=;
        b=MZT+tL7a02ANMtTB+GtDlHr9zitLDwonXgicnlt0dBVeMZ+YoRAzKvKoKQhfhaaI7p
         6iJEiM9FbbHXSQTyly+ojWOIB0qLYHPyfAkvUY5Xm17a0QaRdr9cBYhm6rasQQnjz6Pu
         TBMP3FuaWJkNvIUjIDcMsjsli0wss8L9fPPY6SxXQxqwYswVqo8WP6rTAw5ZaYkC/f8/
         izZDA82ZeVECjMHkO6ixvNi5dw9rYqyNvQjDw/61mMn2k4ottL2qQnMrGxgQp/3KQlVd
         plxbrVdjHh/TL13sW9TBC51hwCP7gOMEp0/cc7GxwO0K0CcWQksn4XaCzpwGF+He9dAP
         4gLw==
X-Gm-Message-State: AOAM530vWhQ9hGa8kXnqnkgkWDf38KX2DXCQoWowq3E3aw9laV7YYJOB
        7ctuS9Q6uYRSEfJeNa+dKZaHi1Nxx/WXrQ==
X-Google-Smtp-Source: ABdhPJzxhFtO4UdlPdbGQ537u5MzCUPEdq6CWvNEZrH3xX47qHyNFybDxVPkT2FAj3g2zdg3JP0GqQ==
X-Received: by 2002:adf:ef4c:: with SMTP id c12mr2878033wrp.242.1607521222515;
        Wed, 09 Dec 2020 05:40:22 -0800 (PST)
Received: from [192.168.8.121] ([85.255.233.156])
        by smtp.gmail.com with ESMTPSA id m8sm3558947wmc.27.2020.12.09.05.40.21
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 09 Dec 2020 05:40:21 -0800 (PST)
To:     Al Viro <viro@zeniv.linux.org.uk>,
        Christoph Hellwig <hch@infradead.org>
Cc:     Jens Axboe <axboe@kernel.dk>, linux-fsdevel@vger.kernel.org,
        io-uring@vger.kernel.org, linux-block@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <cover.1607477897.git.asml.silence@gmail.com>
 <de27dbca08f8005a303e5efd81612c9a5cdcf196.1607477897.git.asml.silence@gmail.com>
 <20201209083645.GB21968@infradead.org>
 <20201209130723.GL3579531@ZenIV.linux.org.uk>
From:   Pavel Begunkov <asml.silence@gmail.com>
Autocrypt: addr=asml.silence@gmail.com; prefer-encrypt=mutual; keydata=
 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 bA==
Subject: Re: [PATCH 1/2] iov: introduce ITER_BVEC_FLAG_FIXED
Message-ID: <b6cd4108-dbfe-5753-768f-92f55f38d6cd@gmail.com>
Date:   Wed, 9 Dec 2020 13:37:05 +0000
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.3.0
MIME-Version: 1.0
In-Reply-To: <20201209130723.GL3579531@ZenIV.linux.org.uk>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 09/12/2020 13:07, Al Viro wrote:
> On Wed, Dec 09, 2020 at 08:36:45AM +0000, Christoph Hellwig wrote:
>>
>> This is making the iter type even more of a mess than it already is.
>> I think we at least need placeholders for 0/1 here and an explicit
>> flags namespace, preferably after the types.
>>
>> Then again I'd much prefer if we didn't even add the flag or at best
>> just add it for a short-term transition and move everyone over to the
>> new scheme.  Otherwise the amount of different interfaces and supporting
>> code keeps exploding.
> 
> Yes.  The only problem I see is how to describe the rules - "bdev-backed
> iterators need the bvec array to stay allocated until IO completes"?
> And one way or another, that needs to be documented - D/f/porting with
> "mandatory" for priority.

Yeah, I had troubles to put comments around, and it's still open.

For current cases it can be bound to kiocb, e.g. "if an bvec iter passed
"together" with kiocb then the vector should stay intact up to 
->ki_complete()". But that "together" is rather full of holes.

-- 
Pavel Begunkov
