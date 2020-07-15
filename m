Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EC7C3221170
	for <lists+io-uring@lfdr.de>; Wed, 15 Jul 2020 17:45:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725861AbgGOPoX (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 15 Jul 2020 11:44:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34858 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725835AbgGOPoX (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 15 Jul 2020 11:44:23 -0400
Received: from mail-il1-x144.google.com (mail-il1-x144.google.com [IPv6:2607:f8b0:4864:20::144])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 681BDC061755
        for <io-uring@vger.kernel.org>; Wed, 15 Jul 2020 08:44:23 -0700 (PDT)
Received: by mail-il1-x144.google.com with SMTP id t4so2389858iln.1
        for <io-uring@vger.kernel.org>; Wed, 15 Jul 2020 08:44:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:references:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=5VDzqNDhtdaEbf6M4ISMd6Vo5LLgkMPqTWY+wSFErh8=;
        b=1fI7iOV4BTV02RxF4CsFEMYGHURsTDhtW7pXgR6j4mE6nX7mo61HYRGzuL8Opn5fsc
         kzk+Aq16eHC7UcGb0Z8XEICz6u6fNzTuZTgRS+lEupKIvaL4Nb6agszYqM7nnYeyiUus
         1QW5wwHAm/glAsn1m7o8eT+NFtQlJ2KatZvs08Oe0ADllxaLdRaLnszBMWOFgLhYwhv6
         xpWp/pPxybuWEu2B4xhQm8BgnztqUiI3c6h2NI0t7Szk+R6bfR131sQ8YAv+i6q8+m9M
         YZ42NpG1lxQbXVyZYrfZRYnkGYWZhiothALKkmyz6T6mrR8ikuQ/ywKymTBQfutTUsuG
         VHRA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=5VDzqNDhtdaEbf6M4ISMd6Vo5LLgkMPqTWY+wSFErh8=;
        b=QNMd/OrEhsnp+44d/VHIi0waa8ztH7JDIwu95lOB3+fT52sYHb72A3oI5TchsoLlbk
         dB6o0cuvG9LL8+FXxdBnPxJuMfYfcnMqbk6rf3tcEGRFw2v3P/UdAYthhKbaicO9sw5V
         mfJypq3QsUCQaw1DaZf1XgadPvfiN8NQRdpP2lJwJ7ZWgCs0jBK5sycaW60m7ek9q8Qp
         8wL3Z7TnHU6w3th8/gDB5a3WJf58q4YERqbHKTP/bznDSOSAVXimL95thOJ7x0jAUYzW
         cKrRiD5OPi66fBDiZ7OUT0QR94x5nCoZNuxZPHJpEEyGRoQgWuVcHa++mpgsoXt73Y1l
         KgQw==
X-Gm-Message-State: AOAM5322hMgpLPxZaSyYcPDgcSCKJTrGBVhGzVtjr9QiRZMDON4CZqOK
        qOqpJo5gGbUR1fzQZotdTISD+hVrSKw6Pg==
X-Google-Smtp-Source: ABdhPJwca4eHkTdehyy79HQHMtbJC2GWkzIHkHlubF7tiGOPo7HRTPnWhw3JsaehubxQoo5LNKj5dA==
X-Received: by 2002:a92:dc90:: with SMTP id c16mr122762iln.202.1594827862418;
        Wed, 15 Jul 2020 08:44:22 -0700 (PDT)
Received: from [192.168.1.58] ([65.144.74.34])
        by smtp.gmail.com with ESMTPSA id u65sm1265579iod.45.2020.07.15.08.44.21
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 15 Jul 2020 08:44:21 -0700 (PDT)
Subject: Re: [PATCH 0/4] quick unrelated cleanups
To:     Pavel Begunkov <asml.silence@gmail.com>, io-uring@vger.kernel.org
References: <cover.1594806332.git.asml.silence@gmail.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <839dc20d-6fbf-b8d1-f16b-05d78e1a984b@kernel.dk>
Date:   Wed, 15 Jul 2020 09:44:21 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <cover.1594806332.git.asml.silence@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 7/15/20 3:46 AM, Pavel Begunkov wrote:
> Probably, can be picked separately, but bundled for
> convenience.
> 
> Pavel Begunkov (4):
>   io_uring: inline io_req_work_grab_env()
>   io_uring: remove empty cleanup of OP_OPEN* reqs
>   io_uring: alloc ->io in io_req_defer_prep()
>   io_uring/io-wq: move RLIMIT_FSIZE to io-wq
> 
>  fs/io-wq.c    |  1 +
>  fs/io-wq.h    |  1 +
>  fs/io_uring.c | 95 +++++++++++++++++++--------------------------------
>  3 files changed, 37 insertions(+), 60 deletions(-)

Look (and test) fine, applied. Thanks!

-- 
Jens Axboe

