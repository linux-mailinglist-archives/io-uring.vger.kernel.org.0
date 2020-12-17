Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A69B82DCB02
	for <lists+io-uring@lfdr.de>; Thu, 17 Dec 2020 03:29:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727894AbgLQC1F (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 16 Dec 2020 21:27:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38192 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725988AbgLQC1F (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 16 Dec 2020 21:27:05 -0500
Received: from mail-pj1-x1033.google.com (mail-pj1-x1033.google.com [IPv6:2607:f8b0:4864:20::1033])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4F770C061794
        for <io-uring@vger.kernel.org>; Wed, 16 Dec 2020 18:26:25 -0800 (PST)
Received: by mail-pj1-x1033.google.com with SMTP id hk16so3192497pjb.4
        for <io-uring@vger.kernel.org>; Wed, 16 Dec 2020 18:26:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:references:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=+2PNkCheOrdjyc+CPSQezQhwT9JRlmc51/6bb9TK3FU=;
        b=OsNxiiZuoQHcv1kj0CwGRFCe8B/dUt6cgAVPbt6qZpgq41uv2Gxw6IG+gQUUbkT3hZ
         zrL4A1fFOJlpJ2YWY7PkOb0F8SMnLvJ6LNP4lEaoN7gLtsDHf/sO6qOfv968G+RP3G3o
         rxhtmtUwle80KdV+g4T2swfRKLhxFy3/PzcLhvPY11kPKjtnjJfZ+bTtBVhUVs9z1zH1
         1QJFHmhQUOFw6e1oCrRRFpJdujzEuU3KsMSrpHvU4/YpXbO4MP/SSxYSzI9rNB7PscnL
         lVNr0PlKobXdRHI5qoZNhwS/jMt0YuZSxsn0JqHlbqOGkMImM6+Yudfsv7qCW8voqTXI
         yz4w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=+2PNkCheOrdjyc+CPSQezQhwT9JRlmc51/6bb9TK3FU=;
        b=SIzZ8B3vKBR/mveB4oSTYGrVAjyoHIZgnWx1PZxWVJ13f6s3+bteTSAeQN9yBH02AX
         Gw/3ST8oUlVTnFW6wsKDkdy0h41I7UxuWUroTPLmSIsfu76244ztc5aZvYsuQ2eEAiJJ
         nSfP5tlGUAE/IcA2TX7Qbj5GjeFLFfCKziCOQdqH2Vw2j9PHOLH9u3jGkMJLAckHsOFj
         h38znUP11lZzMHZy6za4kuoy8MZ3UfaYw0IFVuD38H7fgBggHp7uwkyCw78qkTZezNA0
         JfxHCnS9ez7uuD3sTmQ40G6iWnTiRFyexP295SuLuwiMl+0pnqwMK/u/BUuGiIKtIKr5
         kaOQ==
X-Gm-Message-State: AOAM532c/REuYQCnu2+Pnx9QDdrajmKy7gvlHkPTd0+MUMMpt1CNgVJa
        WLDlNl1lW5VaFJyd3Xc3AsgSATeJ3SQoiw==
X-Google-Smtp-Source: ABdhPJyWYFrl/l0k7FTMkde2evAaW1P6SxeDgb97FYR+6B2JpMtdAgjWZV2VVeeKHs54edzIHSpDJg==
X-Received: by 2002:a17:90a:d148:: with SMTP id t8mr5711493pjw.126.1608171984291;
        Wed, 16 Dec 2020 18:26:24 -0800 (PST)
Received: from [192.168.1.134] ([66.219.217.173])
        by smtp.gmail.com with ESMTPSA id u9sm3723842pfl.143.2020.12.16.18.26.23
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 16 Dec 2020 18:26:23 -0800 (PST)
Subject: Re: [PATCH 0/5] fixes around request overflows
To:     Pavel Begunkov <asml.silence@gmail.com>, io-uring@vger.kernel.org
References: <cover.1608164394.git.asml.silence@gmail.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <f0f7de4e-1aab-e28b-87a5-88c4c5cfd517@kernel.dk>
Date:   Wed, 16 Dec 2020 19:26:21 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <cover.1608164394.git.asml.silence@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 12/16/20 5:24 PM, Pavel Begunkov wrote:
> [1/5] is a recent regression, should be pretty easily discoverable
> (backport?). 3-5 are just a regular easy cleaning.

If 1/5 is a recent regression, why doesn't it have a Fixes line?
Any commit should have that, if applicable, as it makes it a lot
easier to judge what needs to be backported.

-- 
Jens Axboe

