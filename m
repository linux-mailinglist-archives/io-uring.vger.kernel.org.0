Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C8E14392FF8
	for <lists+io-uring@lfdr.de>; Thu, 27 May 2021 15:43:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236533AbhE0Noq (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 27 May 2021 09:44:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38256 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236373AbhE0Noq (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 27 May 2021 09:44:46 -0400
Received: from mail-ot1-x32f.google.com (mail-ot1-x32f.google.com [IPv6:2607:f8b0:4864:20::32f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 60429C061574
        for <io-uring@vger.kernel.org>; Thu, 27 May 2021 06:43:12 -0700 (PDT)
Received: by mail-ot1-x32f.google.com with SMTP id i23-20020a9d68d70000b02902dc19ed4c15so286702oto.0
        for <io-uring@vger.kernel.org>; Thu, 27 May 2021 06:43:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:references:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=iGQlZEEAZDBpgg5JSABtElPLt5kqvvkZA7rme3t9db8=;
        b=0IwmFMFThe1zLZzoAl5f70Xny9ySewzTP+RHjtCel3XB+S3hh2pRuDcMacB+5YByRr
         QFkPLCT69PQoMUF9d8bySfE/r5nEdKqC1bGuJYMAUNn03VaLfjSkcbmtxo7394ySl2kg
         kdBeVcT+VYikF+vLbtMfwIl2aQ9pM7OVcrLqZ5aBh0GHi76jkBNK4LMxnVEszgB2wn9/
         JKmfAHMKWK5jR0C9c87Tx8fT69fhkSepY4XjnQ9lnmq5nuK6lxVEbmwQwkbzQji/Lwn0
         JtW5zy1uYdxujePTYI3e5bSItD7VgW4x/TVD+NzXp9cPDzBWykRIrYC3uWoSI2hd+RP/
         H3Zw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=iGQlZEEAZDBpgg5JSABtElPLt5kqvvkZA7rme3t9db8=;
        b=aD1X2244QnqI3k/jt+SKYJNOxpUqQvCzMA9nrVq6QUwbUK74ywy6GXl+iNWs0qkP/x
         SsyXzTwI+GedC90WNqRx4WZwzxPOgLZVa7S3ipNLvTpEaVB4XlxAeRC59HLdygq8Ytqd
         hufHXySQLRDikaFUDvkphPvJCQbWF/odudQ6z3lZbMroyPi3HmRc1ioVc5EyqD4GCFUE
         JnoftJHkLjT/tRiHHi4QXnMVIb5te2TE82/PgzMngpkJKDNAXQc8/OqDnifwILa/j6u6
         V9IEX5HLvVPPfeRlfYpHBhLEFd0aHWj9JA6lOsCiknuDzxUoKv4cfgPSGPcvfrIEz1SI
         5vAA==
X-Gm-Message-State: AOAM531KlNpfpR0dbgdINYEzjH1Ahzme7Id+e9KuLx1OPpkoJqtcNsrE
        jjUtoUPo11tR1NCRC41byG1bfQ==
X-Google-Smtp-Source: ABdhPJypE4GJ67gMrf2L28NON3Gvn6AkwpYX3QKNBGDCLa0k6sOF3niKv89EJVx9mnmc8DSGIkCvWA==
X-Received: by 2002:a05:6830:51:: with SMTP id d17mr2826477otp.75.1622122991696;
        Thu, 27 May 2021 06:43:11 -0700 (PDT)
Received: from [192.168.1.30] ([207.135.233.147])
        by smtp.gmail.com with ESMTPSA id z15sm487225otp.20.2021.05.27.06.43.11
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 27 May 2021 06:43:11 -0700 (PDT)
Subject: Re: [PATCH] io_uring: Remove CONFIG_EXPERT
To:     "Justin M. Forbes" <jforbes@fedoraproject.org>,
        asml.silence@gmail.com, io-uring@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20210526223445.317749-1-jforbes@fedoraproject.org>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <aa130828-03c9-b49b-ab31-1fb83a0349fb@kernel.dk>
Date:   Thu, 27 May 2021 07:43:13 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20210526223445.317749-1-jforbes@fedoraproject.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 5/26/21 4:34 PM, Justin M. Forbes wrote:
> While IO_URING has been in fairly heavy development, it is hidden behind
> CONFIG_EXPERT with a default of on.  It has been long enough now that I
> think we should remove EXPERT and allow users and distros to decide how
> they want this config option set without jumping through hoops.

The whole point of EXPERT is to ensure that it doesn't get turned off
"by accident". It's a core feature, and something that more and more
apps or libraries are relying on. It's not something I intended to ever
go away, just like it would never go away for eg futex or epoll support.

-- 
Jens Axboe

