Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D4FF3319F15
	for <lists+io-uring@lfdr.de>; Fri, 12 Feb 2021 13:51:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231959AbhBLMrO (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 12 Feb 2021 07:47:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43404 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231862AbhBLMpQ (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 12 Feb 2021 07:45:16 -0500
Received: from mail-pg1-x52b.google.com (mail-pg1-x52b.google.com [IPv6:2607:f8b0:4864:20::52b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6CEF5C061756
        for <io-uring@vger.kernel.org>; Fri, 12 Feb 2021 04:45:01 -0800 (PST)
Received: by mail-pg1-x52b.google.com with SMTP id t11so6158469pgu.8
        for <io-uring@vger.kernel.org>; Fri, 12 Feb 2021 04:45:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:references:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=g2inw4vsil6oN3ZbswIP46jL54Nps43wibZPL3bsq2Q=;
        b=hcLsoYieK1kmo6LhtrNV5rHFMY/ZL2UGBoKe2/7BS2N0g6xLcuvl26WR+fzIUrL4Ad
         IYtOCGJi0bAdtBqLHON0JJWqwvFfEjA+cnDTJaD35lSCwtxw4xWB/gJHOUjdT1ldo1HW
         yxlsbk/7lhWgngtrRitRvuVKANdFRVM26U0RvODv5cz4p6wO/s46oeFxsMqLd3FlViPi
         ne3xSzzL4cWA4kADWS13G7+TPFq47gT3uRdb28uE4U6t/YAauAd2Vmzi7+WAveBQ0vua
         qlwfaVHhsrZ0RPm9VAcJWPmeWPC1B9q1NsScoqweyZeBJcPLXV3j7n4eJ1WL0+jRqWBl
         c/YA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=g2inw4vsil6oN3ZbswIP46jL54Nps43wibZPL3bsq2Q=;
        b=WLtbEZZcYApRyGWsHyxl0bE+8oe5Qsqv5UJ03ee8PxTzYCOHeZa16taL1cD8uP+kyz
         CMiwdCaTxVbkeJjLE0QDc2ehcu/W5Ufbo2BSVM1HlPGHO+4/sWzs+e9gLdo7nstO953k
         E5GYQLt00uGksW4tHbr4JN5XdXAj1b8mIb2+1RFqaKzqRS20y5QSA9kgDu0rnOdEnSP6
         fbbkTFPjSBJwMzb3vhL5rlP+4E9hr0CffC29vkE2VNxJaPsH57s9AeS9v0GuDs9kQkyg
         3Cs9Ap4eW+2dsVzvxsA0TVoiAtwX8Svm79nQp0egn50jNclzvkVqTQjj6eqfcav+bNdH
         4ArA==
X-Gm-Message-State: AOAM530YwOGGXkqYrHQykCEJsz7ycrptXdukk4xn7vwfG+WfuVd3QQQm
        K7U4GTq3HLC2Z9QGtmxJColaJsjnggXYOw==
X-Google-Smtp-Source: ABdhPJxH0FIEyHYacTLqR/hlNkHyr4BcbedZqdtILNVF6If8rYRYMPcAkGdP/fXT9P4AHAdmykqYAw==
X-Received: by 2002:a63:3686:: with SMTP id d128mr2927149pga.240.1613133900839;
        Fri, 12 Feb 2021 04:45:00 -0800 (PST)
Received: from [192.168.1.134] ([66.219.217.173])
        by smtp.gmail.com with ESMTPSA id j22sm6782545pgh.42.2021.02.12.04.44.59
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 12 Feb 2021 04:45:00 -0800 (PST)
Subject: Re: [PATCH 1/1] io_uring: don't split out consume out of SQE get
To:     Pavel Begunkov <asml.silence@gmail.com>, io-uring@vger.kernel.org
References: <5294703c66d2c332377c1f0d258c6baa70d736a7.1613130703.git.asml.silence@gmail.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <35763b5f-9775-de27-37f5-95430fdf1816@kernel.dk>
Date:   Fri, 12 Feb 2021 05:45:00 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <5294703c66d2c332377c1f0d258c6baa70d736a7.1613130703.git.asml.silence@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 2/12/21 4:55 AM, Pavel Begunkov wrote:
> Remove io_consume_sqe() and inline it back into io_get_sqe(). It
> requires req dealloc on error, but in exchange we get cleaner
> io_submit_sqes() and better locality for cached_sq_head.

Applied, thanks.

-- 
Jens Axboe

