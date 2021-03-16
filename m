Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5D10133D831
	for <lists+io-uring@lfdr.de>; Tue, 16 Mar 2021 16:52:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237468AbhCPPvo (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 16 Mar 2021 11:51:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40940 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237550AbhCPPvd (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 16 Mar 2021 11:51:33 -0400
Received: from mail-il1-x12b.google.com (mail-il1-x12b.google.com [IPv6:2607:f8b0:4864:20::12b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A9F14C06174A
        for <io-uring@vger.kernel.org>; Tue, 16 Mar 2021 08:51:32 -0700 (PDT)
Received: by mail-il1-x12b.google.com with SMTP id e7so13104084ile.7
        for <io-uring@vger.kernel.org>; Tue, 16 Mar 2021 08:51:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=s/EAT4HSlydRSIq9ygRjoznh+BfLxK52S7wifqI3MLg=;
        b=YrOZBTAV5OPMNIRTaBHuL9LjBP2Y8lr1OttSI6Dgm0S6Jco6EyTMKwd6FvtORZI09j
         tJsA76C5uOgzscnC+9dQyY6ck/w4Sj/hXhGYTy+79I9fgsFv+kYh9D6SCzVNoaNTbcUt
         lu8S3lbwbKpSYQiw/SMC3tQgTwxJwEuu7oP89snXh85HK1o+QPQImbcc8nwN+2UEu3jP
         zjiKx4Vbpczj+SS8Lcir1bKO5Ty4PwhvfT86nfI6zIHy9lGjvfV+HjIZK/qSfGCWgP1y
         CIUbz/Rzml8mMaOekkq7eb9eTDeLEweVYUeCyLA7VMOrvrnfUOy8OGZFYQiuPbRC1LM6
         TFCA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=s/EAT4HSlydRSIq9ygRjoznh+BfLxK52S7wifqI3MLg=;
        b=QnSaaNMs26s90x4ZmaN8f25ceYJDEia6HKbJKzsJYX/BQMaQBXcE2nHMUGKOsnh6mn
         5uFlNZPNBo/MdekBFJAiUh2cAw8oSXG9BYtF0N7t9ZjgLz/+vVxjFK9kZAt1gVBKd9xQ
         hFpWbG5zXe1iM8Kq4FuWh+l+d3KtjNiT0J9NmP1gV6yB8hU2iKiM1Q5SjQIWd9mKVYXJ
         Q/IQReveKTaNA4ksdenpGxy+Qs0+AzTVzZ0Tw5umqjzIsr0142Ad6QZA+yW6Edkp8RBi
         H3yZhAc5tpYg9nLToWEAYMXJqsS9ZYYGIwqKNkcL2yB+Er1AmEk8ZYErsSH4DkplTSSk
         NCyg==
X-Gm-Message-State: AOAM530iEvAZOodO3CQFlr/zO61PZH94NlJ6+ZbfOR9R0BF3e5usJ0KD
        zAgeZF1PTlTqI+ALmOMy/ssELQ==
X-Google-Smtp-Source: ABdhPJx+wvouE6WL3T10Cm/gOgsUdAdb26zeTKoF7+N6ZniYzPfKm4Wwh2DT8ZJ1ppQo+t2sbMFs8A==
X-Received: by 2002:a05:6e02:1688:: with SMTP id f8mr4187663ila.110.1615909892060;
        Tue, 16 Mar 2021 08:51:32 -0700 (PDT)
Received: from [192.168.1.30] ([65.144.74.34])
        by smtp.gmail.com with ESMTPSA id t9sm9645667iln.61.2021.03.16.08.51.31
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 16 Mar 2021 08:51:31 -0700 (PDT)
Subject: Re: [RFC PATCH v3 0/3] Async nvme passthrough over io_uring
To:     Kanchan Joshi <joshi.k@samsung.com>, hch@lst.de, kbusch@kernel.org,
        chaitanya.kulkarni@wdc.com
Cc:     io-uring@vger.kernel.org, linux-nvme@lists.infradead.org,
        anuj20.g@samsung.com, javier.gonz@samsung.com,
        nj.shetty@samsung.com, selvakuma.s1@samsung.com
References: <CGME20210316140229epcas5p23d68a4c9694bbf7759b5901115a4309b@epcas5p2.samsung.com>
 <20210316140126.24900-1-joshi.k@samsung.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <b5476c77-813a-6416-d317-38e8537b83cb@kernel.dk>
Date:   Tue, 16 Mar 2021 09:51:30 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20210316140126.24900-1-joshi.k@samsung.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 3/16/21 8:01 AM, Kanchan Joshi wrote:
> This series adds async passthrough capability for nvme block-dev over
> iouring_cmd. The patches are on top of Jens uring-cmd branch:
> https://git.kernel.dk/cgit/linux-block/log/?h=io_uring-fops.v3
> 
> Application is expected to allocate passthrough command structure, set
> it up traditionally, and pass its address via "block_uring_cmd->addr".
> On completion, CQE is posted with completion-status after any ioctl
> specific buffer/field update.

Do you have a test app? I'd be curious to try and add support for this
to t/io_uring from fio just to run some perf numbers.

-- 
Jens Axboe

