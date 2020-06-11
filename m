Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EB7381F5F00
	for <lists+io-uring@lfdr.de>; Thu, 11 Jun 2020 02:01:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726845AbgFKABz (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 10 Jun 2020 20:01:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39334 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726768AbgFKABy (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 10 Jun 2020 20:01:54 -0400
Received: from mail-pg1-x544.google.com (mail-pg1-x544.google.com [IPv6:2607:f8b0:4864:20::544])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 602CCC08C5C1
        for <io-uring@vger.kernel.org>; Wed, 10 Jun 2020 17:01:54 -0700 (PDT)
Received: by mail-pg1-x544.google.com with SMTP id m1so1721475pgk.1
        for <io-uring@vger.kernel.org>; Wed, 10 Jun 2020 17:01:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=RreJrUeG+o7wNboJvYBhDZ2wkvEQWCMADu44Ur/NXR8=;
        b=yY1Ra5sWWZIJonv04k0cs3fCpKZLCtue5MRZgJs5MegdNsNr0jv5nXdli+glxR4Cpu
         ugWfkkAVLcE/kPrbSaR/jOGajDTHYIwHvjBihue+ESC+wj2BZhjrtcosP17LGdkJqV4U
         UtQ7CAbaWl028Nlt3MwQY+2RAbusEI3yX/WCNNSEXUE+vfxE+tW75VcCun0rJrIv4CaL
         sSBbZyqYTeBnShCejDTNxTZmUXQBj1ngAbqyco6k/ygZatC+1AwR7QCq9fWHPRU6G4bB
         Mao8hMa0vzld4wVUIfahQYQQgMGXuY240CFB+VwqbCuLXSsMUn8+XzLBEUeStHKPAVkx
         aO5Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=RreJrUeG+o7wNboJvYBhDZ2wkvEQWCMADu44Ur/NXR8=;
        b=Z7uqC4lXAR4xcoeaWKMwOZnW40Bvpf0jKqh2DB6WBvf81VTmWn0QF7FWe7WsZnhuoF
         S8ZZsqYMkGSBDGOR+hLZiva/5ODaJn05Ka75oW6l8CBJhG4bu2mh7iZ6OCCYP7wcaHXi
         yqdek3aviRxpzGe6mjdcbEe6NnnJc+Rx5Thn3+jX2eQrIdO1Flg/uqInFjrqBl+rrve6
         s1H1uYhzOoL0y3DhTwMd+kqI4rPiXxKnvINmDYBs7t4kfua7UjGdzqxpMRlRp2iiEUz/
         zikN5GNoUdjpYlriAPvB3sMbQlpf/JLbbPNSMwvE0EIMRXHb3jM47B3MDp/aqWuTIvwm
         IVaA==
X-Gm-Message-State: AOAM5309mUAx2JP4ErtwrDqaS7Pyid+IgOMJIJ+wJGSFcKe71n7+0gmb
        pSYhgicOHW/AaJw1IOxfelfeyze6BziZRQ==
X-Google-Smtp-Source: ABdhPJy3hjggdqIJwt61m1XudtE8od/8X78xS2KPCIsvylatKLuJqZV5FLF4tyM4gMaS87k10X6OFg==
X-Received: by 2002:a65:4102:: with SMTP id w2mr4702016pgp.47.1591833713876;
        Wed, 10 Jun 2020 17:01:53 -0700 (PDT)
Received: from [192.168.1.188] ([66.219.217.173])
        by smtp.gmail.com with ESMTPSA id a12sm764915pjw.35.2020.06.10.17.01.52
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 10 Jun 2020 17:01:52 -0700 (PDT)
Subject: Re: [PATCH] io_uring: add EPOLLEXCLUSIVE flag to aoid thundering herd
 type behavior
To:     Jiufei Xue <jiufei.xue@linux.alibaba.com>, io-uring@vger.kernel.org
Cc:     joseph.qi@linux.alibaba.com
References: <1591769708-55768-1-git-send-email-jiufei.xue@linux.alibaba.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <fba0cf9c-1d9a-52d9-29d9-fce01b0a8a06@kernel.dk>
Date:   Wed, 10 Jun 2020 18:01:50 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.8.0
MIME-Version: 1.0
In-Reply-To: <1591769708-55768-1-git-send-email-jiufei.xue@linux.alibaba.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 6/10/20 12:15 AM, Jiufei Xue wrote:
> Applications can use this flag to avoid accept thundering herd.

So with this, any IORING_OP_POLL_ADD will be exclusive. Seems to me
that the other poll path we have could use it too by default, and
at that point, we could clean this up (and improve) it further by
including that?

-- 
Jens Axboe

