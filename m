Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1DA1734D91E
	for <lists+io-uring@lfdr.de>; Mon, 29 Mar 2021 22:40:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231158AbhC2Uja (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 29 Mar 2021 16:39:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40644 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229950AbhC2Ui6 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 29 Mar 2021 16:38:58 -0400
Received: from mail-pg1-x52d.google.com (mail-pg1-x52d.google.com [IPv6:2607:f8b0:4864:20::52d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 92727C061574
        for <io-uring@vger.kernel.org>; Mon, 29 Mar 2021 13:38:58 -0700 (PDT)
Received: by mail-pg1-x52d.google.com with SMTP id k8so1016940pgf.4
        for <io-uring@vger.kernel.org>; Mon, 29 Mar 2021 13:38:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=zkHWfQmcvkX73ALmQtfT/dMgLtpUYjokLV5A+ra7aPA=;
        b=NGD/oGDdTsHlXc0LBNKLLFrOdp5PDi57ozZMqjYlu6LPG3rlcjDn1Sbf4dB9vl9p08
         pRwVhxszXvNSxUYCe3itM4pcSztQ0AdPMuK1iczBcgKRR/ylTBe4gnPT8GMp8sOFqwYm
         4fNSoJxDKzf3UurJkPmZXXe0FcA3X9evAEXVQVAD/OXsunRw2kQyXZ4F6HN033rFtCoY
         pGprFloHW6w/CsLCSrUdJimSqpQcY8CatDe5KNDvX4rjLzrsGb4sYzX7QXrPMKnXuhXP
         tF45Bip9Bxlwp+ZI4rfmXeKZMpcqsRadfcRFJQd3Vem202FQOonlIRQbcKyYJaujS3qw
         4FKg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=zkHWfQmcvkX73ALmQtfT/dMgLtpUYjokLV5A+ra7aPA=;
        b=QL8Ee1Yyg/1QcZvsSCJXhHeoA3Re59L9m1twfnPybZk8VbmrA66JXxzUzWAofrGYM0
         +79RDY2oVK/Vp0A4MPY6UMLglpvED2jmpNcuEx4f+uU2END5pYyyK19iQEg16pVygWkE
         z6q8Uo7teo7Ec3HkaTJJVv/XkoSn+8zCTjv68YTw0/4568dkjWkizkLFqraKvVYI7DZ/
         5uGQgveApL31CMkRNhfgymC1SbT0m9zrlZH8TVdFF5xylhqKx/q/BIGUizSsVC8STAUH
         y+S949/P6Vvc1SXoFLPOH6z1x0+CmUBd8imM3DqpkOGuNah3DHRd36IdxR3M9Ls3vCwE
         /3QQ==
X-Gm-Message-State: AOAM533PyUL4dSusBzds7FxfGAoZqLS//ySG/wVjE2p2NM+GbvbOfSMi
        eBb0UYZfMN/lzWDL9NgP5L9hf/ognv0dBQ==
X-Google-Smtp-Source: ABdhPJx0li6XjdkZT3HqOc9PM9ncGiYgOib2tmuYH82gsurb9DJZSezE+S2huOzia/8ziYIjuRkGUA==
X-Received: by 2002:a05:6a00:b45:b029:207:16ba:12c4 with SMTP id p5-20020a056a000b45b029020716ba12c4mr26878935pfo.31.1617050338125;
        Mon, 29 Mar 2021 13:38:58 -0700 (PDT)
Received: from [192.168.1.134] ([66.219.217.173])
        by smtp.gmail.com with ESMTPSA id fv9sm487081pjb.23.2021.03.29.13.38.57
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 29 Mar 2021 13:38:57 -0700 (PDT)
Subject: Re: [PATCH v4 1/2] readdir: split the core of getdents64(2) out into
 vfs_getdents()
To:     Lennert Buytenhek <buytenh@wantstofly.org>,
        io-uring@vger.kernel.org
Cc:     Al Viro <viro@zeniv.linux.org.uk>, linux-fsdevel@vger.kernel.org
References: <YEuNMc5LlGftOHW6@wantstofly.org>
 <YEuNlKWpQqGMCtL8@wantstofly.org>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <a0301cec-2ec3-a3ea-40bd-7d00845705a1@kernel.dk>
Date:   Mon, 29 Mar 2021 14:38:56 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <YEuNlKWpQqGMCtL8@wantstofly.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 3/12/21 8:49 AM, Lennert Buytenhek wrote:
> So that IORING_OP_GETDENTS may use it, split out the core of the
> getdents64(2) syscall into a helper function, vfs_getdents().
> 
> vfs_getdents() calls into filesystems' ->iterate{,_shared}() which
> expect serialization on struct file, which means that callers of
> vfs_getdents() are responsible for either using fdget_pos() or
> performing the equivalent serialization by hand.

Al, how do you feel about this one?

-- 
Jens Axboe

