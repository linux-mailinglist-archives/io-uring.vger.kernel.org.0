Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A31C74550FF
	for <lists+io-uring@lfdr.de>; Thu, 18 Nov 2021 00:17:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241527AbhKQXUc (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 17 Nov 2021 18:20:32 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36470 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241529AbhKQXU1 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 17 Nov 2021 18:20:27 -0500
Received: from mail-io1-xd2e.google.com (mail-io1-xd2e.google.com [IPv6:2607:f8b0:4864:20::d2e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 21EC1C061767
        for <io-uring@vger.kernel.org>; Wed, 17 Nov 2021 15:17:28 -0800 (PST)
Received: by mail-io1-xd2e.google.com with SMTP id p23so5524833iod.7
        for <io-uring@vger.kernel.org>; Wed, 17 Nov 2021 15:17:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=4BiqYeFyKUrWFUw/gzjS0FZN3/WTO0Znkg4w19bFepY=;
        b=2PdrfO7yzAA4x9le/Tj6UJ+YnIymJa7LRIc3PwxxepK37vhpk3cKuTWSSAis90ouIu
         xTXMmAZGnzECbvm3qtz0DkiuSLJ5zw+dB678lP+sKQ8IFTvc/rjfIaBjKeuOVY/lhxO+
         0t1xq9bddVMeemBgP+Sw5WDDZiUMX/ya4FSDBt4pgAnTnugjMk+ORDGO88w0LVl36nJR
         t3yZBI91yB80vBpiUfvc1OcVTicGGE2iZNSRDmCtlGtTEGsRmDzg0hBZy23t7KcAzGP0
         yYmYy68JbCLryX0GuWfB/odOjJCXcKWvvlOvHxLxoIM/1TLE8NFvRUjQa0az4EocJYYt
         T7mw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=4BiqYeFyKUrWFUw/gzjS0FZN3/WTO0Znkg4w19bFepY=;
        b=DS8CfPdw/87sUcR0xtWggB/o0Dlxvc4H6SkBxaddA+CVbQT6PSeISqLoSu5G8cIfcO
         QeGcpza82xkSptlqJffFt0ajoehd0THzONnNh0X2KqSv25+KbU5ZNIYVOew1c5XYczTI
         dkRqUOpII8AsBk3c+wE8yKjjryeK6tFNzRfobg/ZaYcpQpPmvQTn+0b61KaIm4euNbBB
         qnWs2/QaYmH0ue8JFK7qZMWMKlsp2ea5zyVhRMNHubVorkMROm/TjRXGQ7BOhQo/qAsp
         muFD8Y7xQ6xJtKmX2frpO3aTRkXsxLZAAXO177IZ2js+9jE3/oHbdATrCB3BhKynenWz
         zDBA==
X-Gm-Message-State: AOAM531FgrH1ywGpT2wIulXZtft9NRSjtt6eWDjQEqdi3E1BMxHpgi4V
        4cmrPPF30O+W504wT4brfP+OlQ==
X-Google-Smtp-Source: ABdhPJw6QAgvvsx4XIRmlrgi4MYpz0T6lzQvLpDB0Gv5hKTBDk1YUzEl0KIKWdvUyhIzrs4D9tEPBA==
X-Received: by 2002:a05:6638:260d:: with SMTP id m13mr16951793jat.99.1637191047442;
        Wed, 17 Nov 2021 15:17:27 -0800 (PST)
Received: from [192.168.1.116] ([66.219.217.159])
        by smtp.gmail.com with ESMTPSA id b15sm844654iln.36.2021.11.17.15.17.26
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 17 Nov 2021 15:17:27 -0800 (PST)
Subject: Re: [PATCH] Increase default MLOCK_LIMIT to 8 MiB
To:     Johannes Weiner <hannes@cmpxchg.org>,
        Andrew Morton <akpm@linux-foundation.org>
Cc:     Ammar Faizi <ammarfaizi2@gnuweeb.org>,
        Drew DeVault <sir@cmpwn.com>, linux-kernel@vger.kernel.org,
        linux-api@vger.kernel.org,
        io_uring Mailing List <io-uring@vger.kernel.org>,
        Pavel Begunkov <asml.silence@gmail.com>, linux-mm@kvack.org
References: <20211028080813.15966-1-sir@cmpwn.com>
 <CAFBCWQ+=2T4U7iNQz_vsBsGVQ72s+QiECndy_3AMFV98bMOLow@mail.gmail.com>
 <CFII8LNSW5XH.3OTIVFYX8P65Y@taiga>
 <593aea3b-e4a4-65ce-0eda-cb3885ff81cd@gnuweeb.org>
 <20211115203530.62ff33fdae14927b48ef6e5f@linux-foundation.org>
 <YZWBkZHdsh5LtWSG@cmpxchg.org>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <ec24ff4e-8413-914c-7cdf-203a7a5f0586@kernel.dk>
Date:   Wed, 17 Nov 2021 16:17:26 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <YZWBkZHdsh5LtWSG@cmpxchg.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 11/17/21 3:26 PM, Johannes Weiner wrote:
>> Link: https://lkml.kernel.org/r/20211028080813.15966-1-sir@cmpwn.com
>> Signed-off-by: Drew DeVault <sir@cmpwn.com>
>> Acked-by: Jens Axboe <axboe@kernel.dk>
>> Acked-by: Cyril Hrubis <chrubis@suse.cz>
>> Cc: Pavel Begunkov <asml.silence@gmail.com>
>> Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
> 
> Acked-by: Johannes Weiner <hannes@cmpxchg.org>
> 
> As per above, I think basing it off of RAM size would be better, but
> this increase is overdue given all the new users beyond mlock(), and
> 8M is much better than the current value.

That's basically my reasoning too. Let's just get something going that
will at least unblock some valid use cases, and not get bogged down with
aiming for perfection. The latter can happen in parallel, but it should
not hold it up imho.

-- 
Jens Axboe

