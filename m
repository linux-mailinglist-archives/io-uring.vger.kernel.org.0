Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EFAF7279942
	for <lists+io-uring@lfdr.de>; Sat, 26 Sep 2020 14:58:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728504AbgIZM54 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sat, 26 Sep 2020 08:57:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36062 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726409AbgIZM5z (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sat, 26 Sep 2020 08:57:55 -0400
Received: from mail-pl1-x62b.google.com (mail-pl1-x62b.google.com [IPv6:2607:f8b0:4864:20::62b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AAB00C0613CE
        for <io-uring@vger.kernel.org>; Sat, 26 Sep 2020 05:57:55 -0700 (PDT)
Received: by mail-pl1-x62b.google.com with SMTP id j7so815527plk.11
        for <io-uring@vger.kernel.org>; Sat, 26 Sep 2020 05:57:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:references:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=Wz5LNauCoKvTMyb0b4SzAKwX8OEgZY3RuODYDn5SeTE=;
        b=UMEMZPgMYN3NolgNByxcmmQZapj7gjLIaL8ZmB6QO4YTQKykywhxLeO6EqS6Hv/4/y
         MCw49EKr5s1L8UAGB/ZMrXH735z85bEirQNLg9/Xnhhh7N5B1p5c22C28REnlIjOr5Z0
         7s+TSZoYlxYzeDlcAGcelZOERsa3HWu+q5/2Fvi1XVn7nBkuFpG317V20aNrffxQouDQ
         9i6a/MWbKxqL0MZmaTYeVS0V/+gEfcOxNvl7EBjDCJ9nsQhlluvDFtdCIdlGWNINInYs
         btqQ1FkQl67B0hCL0zD94hbhVPJqknv2gs334aHsrQst8KDKXUtN8FpkXz6DbMtSQVSM
         0QXw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=Wz5LNauCoKvTMyb0b4SzAKwX8OEgZY3RuODYDn5SeTE=;
        b=If3HCvYF5bx4C2guN3xXaXqZK8QFhOGtEAG0y4NHMZ9Ddc9V8oUf8EYxSohMPkic36
         Iir/Lo9B+HwtK+DWmZPKS/aHJf4ZF8+y+GAUAQJ2yvNmzcDzTi+Qm9fZBA880w6OMhaL
         jBHID708fLrx1srLTHwHvD99uk2L77O51FGVOMoGskjg7NJoLmcIWOvJwoHSWLuYiEYu
         TFx7KOKQm/cmchhM3smEeonNUrrjNTpUGpraL+KMijPE4ECr/YP4ZLVTx7zYOVJR1U4N
         eH391AFEMTTz8xLxFnUDSPYrCrBbLrwAAeok09sM6k9q5yAkFhBjQ8mHVlgWVN1To49w
         1ebQ==
X-Gm-Message-State: AOAM532elyL48Oz/ynyZq4iLZBvMZCXvWvVQT+W2OlK41eRX2ZOt++oF
        TgRbOCiox6SaYunOzMCtF7xNTA==
X-Google-Smtp-Source: ABdhPJybUenW1BAsCifUdjwmueb5NgzN88IwgXTyBisU/lbzN05VvFKA9lWTNE3JXUTdo/9PoHlIbA==
X-Received: by 2002:a17:90b:317:: with SMTP id ay23mr1934175pjb.68.1601125074915;
        Sat, 26 Sep 2020 05:57:54 -0700 (PDT)
Received: from [192.168.1.134] ([66.219.217.173])
        by smtp.gmail.com with ESMTPSA id u22sm4984842pgi.85.2020.09.26.05.57.53
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 26 Sep 2020 05:57:54 -0700 (PDT)
Subject: Re: KASAN: use-after-free Read in io_wqe_worker
To:     syzbot <syzbot+9af99580130003da82b1@syzkaller.appspotmail.com>,
        io-uring@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, syzkaller-bugs@googlegroups.com,
        viro@zeniv.linux.org.uk
References: <0000000000007e88ec05b0354fdd@google.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <35306a33-70b5-5e7d-a582-4ba5235953a8@kernel.dk>
Date:   Sat, 26 Sep 2020 06:57:52 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <0000000000007e88ec05b0354fdd@google.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

#syz test: git://git.kernel.dk/linux-block.git 41d5f92f60a61e264dafbada79175dad0bc60c5b

-- 
Jens Axboe

