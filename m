Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7DED330F56C
	for <lists+io-uring@lfdr.de>; Thu,  4 Feb 2021 15:54:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236919AbhBDOxS (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 4 Feb 2021 09:53:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59032 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236909AbhBDOwp (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 4 Feb 2021 09:52:45 -0500
Received: from mail-io1-xd2e.google.com (mail-io1-xd2e.google.com [IPv6:2607:f8b0:4864:20::d2e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E4DB2C061786
        for <io-uring@vger.kernel.org>; Thu,  4 Feb 2021 06:52:02 -0800 (PST)
Received: by mail-io1-xd2e.google.com with SMTP id x21so3429024iog.10
        for <io-uring@vger.kernel.org>; Thu, 04 Feb 2021 06:52:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:references:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=Vdn1QxNou0rEVrcVjweJbYkJP6uzLTwvcUNMZDSkXvw=;
        b=bZ17kGMTAA4EmU/R1O2ocExNr4Q7DX+/odIqh30t/B/c5r8ty/9t5SNMZo6oVuViNz
         oC806gtpTP2ZQMhM8ag6khUuRdspQ16GwkjqXrRGJuJp5VaoAa5S5R2MVlwT7M+XRzp/
         sBqgZ37L5TNAXkZKK2tneNfXN6xEyOhw4nnrt/WOWZKFyLesdvtLk0ZxJNuhhrgh5EDI
         /h+wv+Ka7JoACm8t7NI++JsKXucS6FZfL+8B9xyhi4c5XxdPmbsTbuH1ITdeqT4KE9bC
         MSSowJLuM37QxcIle8UziUJwFDy8C9oJ9cDbOT2/mq5+fFB3ImqvnCeUbiQ8NziAx6cn
         ZB0w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=Vdn1QxNou0rEVrcVjweJbYkJP6uzLTwvcUNMZDSkXvw=;
        b=QSies/6iWkB8fM+dyhfJiqDFkcGHiyDxGVvgOzk0TXi4spidPZ0Ixvue7rIOJiQar1
         GM8qAeTmXnns1T1B6CaerOJHmIwL5KR08PFaaK3LnqBlM89ih9YNWJxivQqj7utY64oZ
         czq4aE3iKuRSdD2n31DYSDBvunGIlSfAM6c2KuHO/wlggbV4sq7Ei+ErKbUfSAHZ2yKU
         lhuN4W667Iki/Txg7cse6O9jsP+SUxBHQxk2NJx4c+3EK8i4urLhpFdue9tLKJO6Vfx9
         u1YQzQ/lKKMZxR5wa87EdxyJtcA3pYWBht52WtthT6hw9976yJr3cjpGwjc9jPSs6ZcU
         ht/Q==
X-Gm-Message-State: AOAM531SKrm6g1xH8SAnkT2aVX4/7r4DASMe0h80q4bMGvYcRGHIqbsM
        JauVXhEu7Mr+Akvja1wL7TNmFQMPXIrtu8ew
X-Google-Smtp-Source: ABdhPJwSkrbygnxvWLG3WIHOF2A+hQ0bCkQMQUsf62ujFG1OIaWNTWkOu9NDdktXiao+EtNQ1TKDqg==
X-Received: by 2002:a6b:6a1a:: with SMTP id x26mr6990323iog.207.1612450322112;
        Thu, 04 Feb 2021 06:52:02 -0800 (PST)
Received: from [192.168.1.30] ([65.144.74.34])
        by smtp.gmail.com with ESMTPSA id k125sm2915848iof.14.2021.02.04.06.52.01
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 04 Feb 2021 06:52:01 -0800 (PST)
Subject: Re: [PATCH v2 13/13] io_uring/io-wq: return 2-step work swap scheme
To:     Pavel Begunkov <asml.silence@gmail.com>, io-uring@vger.kernel.org
References: <cover.1612446019.git.asml.silence@gmail.com>
 <014eff28b71c8e5da5edaa4ad9d142916317c839.1612446019.git.asml.silence@gmail.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <8acbd513-531c-0a12-ea3f-ecf0cd94c9e2@kernel.dk>
Date:   Thu, 4 Feb 2021 07:52:02 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <014eff28b71c8e5da5edaa4ad9d142916317c839.1612446019.git.asml.silence@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 2/4/21 6:52 AM, Pavel Begunkov wrote:
> Saving one lock/unlock for io-wq is not super important, but adds some
> ugliness in the code. More important, atomic decs not turning it to zero
> for some archs won't give the right ordering/barriers so the
> io_steal_work() may pretty easily get subtly and completely broken.
> 
> Return back 2-step io-wq work exchange and clean it up.

IIRC, this wasn't done to skip the lock/unlock exchange, which I agree
doesn't matter, but to ensure that a link would not need another io-wq
punt. And that is a big deal, it's much faster to run it from that
same thread, rather than needing a new async queue and new thread grab
to get there.

Just want to make sure that's on your mind... Maybe it's still fine
as-is, didn't look too closely yet or test it.

-- 
Jens Axboe

