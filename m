Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D63AA24E86D
	for <lists+io-uring@lfdr.de>; Sat, 22 Aug 2020 17:50:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728256AbgHVPuQ (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sat, 22 Aug 2020 11:50:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52912 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727899AbgHVPuQ (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sat, 22 Aug 2020 11:50:16 -0400
Received: from mail-pf1-x441.google.com (mail-pf1-x441.google.com [IPv6:2607:f8b0:4864:20::441])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7A839C061574
        for <io-uring@vger.kernel.org>; Sat, 22 Aug 2020 08:50:15 -0700 (PDT)
Received: by mail-pf1-x441.google.com with SMTP id a79so2581643pfa.8
        for <io-uring@vger.kernel.org>; Sat, 22 Aug 2020 08:50:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=EjCIEmLCX91rHBKFhHTSELbJPRLp2dtv03xRAG6lAeQ=;
        b=lv9/ziNpM7ORowPn+ba9k0adJ3frF4EWjwRB538hIndtahbTe+pUs7oJRX4XrAnZom
         vE2odMkxNEB3phUbK2xNnEr0bWqTK53iJA2seut+fsJKs3rGcynFnIfepWzeFW3pcg5v
         rR8hoB2ReOZ8jUZ+iK4rzkW6+mmx9kUATEBDVa6rrIv03VOt2ikrv1ZcNxTngR6swvYn
         YYy9ZNDM0kC3LHKbeN09QDPo96aNhpA6DF0ghnlXCkDgwaAmWo0v9TgSzExv9oF2cWu+
         nMvI8vzGMiqzrYIRlIPxKwxz/3mhHBqtfP+NmANCvEIfR3p+x4yCBSN+A+bEedeSu4Lb
         ywTw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=EjCIEmLCX91rHBKFhHTSELbJPRLp2dtv03xRAG6lAeQ=;
        b=Ey87ZvgfL8c8nz/+qMWkMme+C2rOYKEHSJnCeMZ2OMC97O/dUfSeOFiBvF1b5GKMOi
         jsDZkyKSjX1nl1vXZJ3x6db5eoHHf0DWAKUjm0/M1lQZGR00WXqrM45l8P+Ie8AeQFsQ
         kFqEgZzLwDFKwXZkQeTey2wR7BDIiJODieI6uUdpj2E1xVEDppUqv15HljA86jQgYDt/
         BF6KmKQCj+SjnU5AIJoNopMp8hrRhLPZxwLdKrXghkoaDFN+7WmyR1d2lObB03U4z8a3
         tagPkeuc2Eb8NGRTwvppOB2ljPVptT47lQmbclmNi7GP8jPl/vYyn5MYUja9nqyVIsoa
         Ugbg==
X-Gm-Message-State: AOAM533nWyBpvkU20eg8FGYfeWAXW4v5KG9NlVJxq7CWBkHbLgdLJWZG
        Sh7mgloO7oQzChCg1M6t6L+EJg==
X-Google-Smtp-Source: ABdhPJy3SePscUzm5798uIKgCmDiTJJkqfg3ATunPeCePcvUUFaO5CtEAhXB81W6ezZOBhFr5y640w==
X-Received: by 2002:a63:9853:: with SMTP id l19mr5609746pgo.98.1598111414901;
        Sat, 22 Aug 2020 08:50:14 -0700 (PDT)
Received: from [192.168.1.182] ([66.219.217.173])
        by smtp.gmail.com with ESMTPSA id g33sm4731110pgg.46.2020.08.22.08.50.13
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 22 Aug 2020 08:50:14 -0700 (PDT)
Subject: Re: [PATCH] io_uring: Convert to use the fallthrough macro
To:     linmiaohe <linmiaohe@huawei.com>,
        "viro@zeniv.linux.org.uk" <viro@zeniv.linux.org.uk>
Cc:     "io-uring@vger.kernel.org" <io-uring@vger.kernel.org>,
        "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
References: <078dc0918bf34ddb8259e6dabb5394ac@huawei.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <9e196408-0f39-3eb5-2cb9-d43f5d884fca@kernel.dk>
Date:   Sat, 22 Aug 2020 09:50:12 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <078dc0918bf34ddb8259e6dabb5394ac@huawei.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 8/22/20 2:11 AM, linmiaohe wrote:
> Friendly ping :)

Huh, I thought I had applied this. I'll queue it up for 5.10, thanks.

-- 
Jens Axboe

