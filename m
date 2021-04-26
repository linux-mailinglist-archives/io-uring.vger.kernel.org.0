Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9D39C36B3AB
	for <lists+io-uring@lfdr.de>; Mon, 26 Apr 2021 14:59:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233311AbhDZNA2 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 26 Apr 2021 09:00:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55032 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231862AbhDZNA1 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 26 Apr 2021 09:00:27 -0400
Received: from mail-pf1-x434.google.com (mail-pf1-x434.google.com [IPv6:2607:f8b0:4864:20::434])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 51A03C061574
        for <io-uring@vger.kernel.org>; Mon, 26 Apr 2021 05:59:46 -0700 (PDT)
Received: by mail-pf1-x434.google.com with SMTP id c17so4247944pfn.6
        for <io-uring@vger.kernel.org>; Mon, 26 Apr 2021 05:59:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:references:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=ox4PsIgXhRBXRC5NvjXKovUdCb+ciuf24jf5zg1aUZQ=;
        b=WtfUzOiL1xazAouCm4n1Bj7fz1U0uTErFwio7nrS0UcVpgWvj1ysPkvWNYCUZKOj/P
         7uRFgDE5jT3d0JWoRO3wpFxtopzDuNP1cJsOYNp4fJeTbHSaOZ7p2rEr4flFTAnQDcmy
         553MjfrFrB/k61DEV+nmXfFayu71osxCjMrlpQaQXwQKDL1Ck1SB2uFzvoHXnrJNvsln
         5cjQdtqCYpDbZPxR4UOexn9KblONoSeS3X6FndBzJzUhFyFbtb8J90yP/7yH87ngjPaf
         tV5ZJMjmqGSCuXQWJJj3SX0MEQ3Wc3KW10vBx2XmlvqS1kCYFKYbzMGrm8V/jFk979us
         FGlg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=ox4PsIgXhRBXRC5NvjXKovUdCb+ciuf24jf5zg1aUZQ=;
        b=hlu8gjmyHkPlw/lP01WtRDavBzxlbsb5Wk1RhGWE+O7H3PoLFi8Fexdr1J1Z6WtMDH
         tD9uOVE6lMIT+dlRD/E9Tuo+I6Z90no4TkFWQU0AWsAQvQvRi632CrarJEGIurx6GFs0
         0a0n5c1+ywL9FHiDLHcITVnvDcrMcf4FDo9XY4WwNeOOC96T7D4zFTGzfcfqchEEvxA+
         5FpDNND8U0XVX6rV72QiARfwIY9PSWV6XSDiOhY+hbUnO+xtLH7aYdGbHFbXraOj0Yfp
         SfbxB3+M1316514psmXH7MuTAgDaXaU3XqhvxmXHgP3Hm4Y0ZcqjobOPkAjAG8flF4g5
         Vedw==
X-Gm-Message-State: AOAM532TBNilx2CvgF/5HsDrovgKLc+vbGA17HbmrrUXuKjTJW2Dl6Lj
        6MghKbN9feZuq/57kpQ5KFaUrE68kQXWNw==
X-Google-Smtp-Source: ABdhPJyRUyBdVubNGNndxW6ibJNiVAhIQt8I8A+AhD3FaR6xUGDYgC1Q0ZCz2N3D47M1COJQYUwThg==
X-Received: by 2002:a63:7503:: with SMTP id q3mr4471530pgc.435.1619441985711;
        Mon, 26 Apr 2021 05:59:45 -0700 (PDT)
Received: from [192.168.1.134] ([66.219.217.173])
        by smtp.gmail.com with ESMTPSA id k11sm15566357pjq.47.2021.04.26.05.59.44
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 26 Apr 2021 05:59:45 -0700 (PDT)
Subject: Re: [PATCH 0/2] sqpoll cancellation
To:     Pavel Begunkov <asml.silence@gmail.com>, io-uring@vger.kernel.org
References: <cover.1619389911.git.asml.silence@gmail.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <32b5b5c0-f625-ad84-0b92-1858071ec5ae@kernel.dk>
Date:   Mon, 26 Apr 2021 06:59:48 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <cover.1619389911.git.asml.silence@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 4/25/21 4:34 PM, Pavel Begunkov wrote:
> 1/2 is yet another SQPOLL cancellation fix (not critical),
> 2/2 cleans up after it and sqpoll recent fixes

Applied, thanks.

-- 
Jens Axboe

