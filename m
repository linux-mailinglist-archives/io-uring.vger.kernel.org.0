Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 031D432E0B8
	for <lists+io-uring@lfdr.de>; Fri,  5 Mar 2021 05:25:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229562AbhCEEZc (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 4 Mar 2021 23:25:32 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46090 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229478AbhCEEZb (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 4 Mar 2021 23:25:31 -0500
Received: from mail-pl1-x633.google.com (mail-pl1-x633.google.com [IPv6:2607:f8b0:4864:20::633])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B1829C061574
        for <io-uring@vger.kernel.org>; Thu,  4 Mar 2021 20:25:30 -0800 (PST)
Received: by mail-pl1-x633.google.com with SMTP id d11so727724plo.8
        for <io-uring@vger.kernel.org>; Thu, 04 Mar 2021 20:25:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:references:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=w1pkYGQHeC+/JUnUlnHqIjzCe5SI2Q0MKWKJkdyiidw=;
        b=MIrv6bfzlwdEtAu7KdN947noIw181nkaEdPxRvdSdR8uqxpZ2k8nBgGLfYtP9aInxs
         NuW++B8ukDR4EG02r78oGUiRQpHKFweKVx26YPlyH6utFg5Wyvtwn/9RG5seDqY2p/MF
         9IYabhoAfBrinfx7WF+ejzlcphwwjFlyQX/nN1gr53AHnCIcHa+8iEjspuLV9aBzuJPH
         86ipNSIlo1BeWZVZbspw+L+3h/qcrc5qi4Nto1jbpoocW6kQ0baqbs6Cmp75o4+rQOXQ
         yUqqCkDjhW35M+LsmWkJFtzVe7doozl1L4tz/7L7ZTno3Zrr64IVYOUFv1XbXo8BHe2c
         X4Uw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=w1pkYGQHeC+/JUnUlnHqIjzCe5SI2Q0MKWKJkdyiidw=;
        b=QodUjBia8QZvkGcW+zAczj/bbZcUr1jXX8j2zwfkkjiFrWHltPJsjfu+lJ4hQMep/7
         5d4sEkgLetPAS81q/ZJ1HbzSvS/mpYQmxvXJ8Law/CIATOx+dY+1BXum0+XEmjop6T87
         3VHiebR8Jq8Vfw4toTqtB/tYAoLvjyXZdq6j2Dyxx/gouKD7ahu38sCgSjb0GaGbHHsp
         +27wpjlE5pO/xA+S3H8Mf/oXkeJK2c6OfSsm/EaBb8oizlEICSK13ByNY+iPIOEgzzMZ
         xT43kg5wzXg8PUHTjvay6TngOhHp3AFGPsy8ABfoRp2zUuoU3bT8k57SdX3jcweztGxQ
         Vovw==
X-Gm-Message-State: AOAM531WLsQNO2YRMzR38HHOKXC4MVe1QZ+sBw4DMbFpPsZ0Hb4lQ3ce
        2f13t8R3OjHyTdmKQIaM27t0YeozZeDnOA==
X-Google-Smtp-Source: ABdhPJwKnoyd0uYYalEk3XUONfQUQp42xq2wqaDpxA+Mntsb0fPUhF84i9YrhPVOp8bJGWQ9OShRKQ==
X-Received: by 2002:a17:902:ed88:b029:e3:6b9f:9ac3 with SMTP id e8-20020a170902ed88b02900e36b9f9ac3mr7138150plj.72.1614918329996;
        Thu, 04 Mar 2021 20:25:29 -0800 (PST)
Received: from [192.168.1.134] ([66.219.217.173])
        by smtp.gmail.com with ESMTPSA id x1sm668452pje.40.2021.03.04.20.25.29
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 04 Mar 2021 20:25:29 -0800 (PST)
Subject: Re: [PATCH 8/8] io_uring: warn when ring exit takes too long
To:     Pavel Begunkov <asml.silence@gmail.com>, io-uring@vger.kernel.org
References: <cover.1614866085.git.asml.silence@gmail.com>
 <4bc9b29f2f5b7952b313be604f43b131a2dfe277.1614866085.git.asml.silence@gmail.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <2eed01be-1148-86da-b4ea-dcb349f04476@kernel.dk>
Date:   Thu, 4 Mar 2021 21:25:28 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <4bc9b29f2f5b7952b313be604f43b131a2dfe277.1614866085.git.asml.silence@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 3/4/21 6:59 AM, Pavel Begunkov wrote:
> We use system_unbound_wq to run io_ring_exit_work(), so it's hard to
> monitor whether removal hang or not. Add WARN_ONCE to catch hangs.

Minor nit, but I'd just use jiffies for this. Ala:

unsigned long timeout = jiffies + 60 * HZ;

if (time_after(jiffies, timeout))
    complain();

That's a well known idiom, and we don't need better precision than that.

-- 
Jens Axboe

