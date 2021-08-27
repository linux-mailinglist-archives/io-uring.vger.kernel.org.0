Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0F43C3F9A2E
	for <lists+io-uring@lfdr.de>; Fri, 27 Aug 2021 15:32:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245136AbhH0NbC (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 27 Aug 2021 09:31:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35308 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231964AbhH0NbB (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 27 Aug 2021 09:31:01 -0400
Received: from mail-il1-x132.google.com (mail-il1-x132.google.com [IPv6:2607:f8b0:4864:20::132])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 111D9C061757
        for <io-uring@vger.kernel.org>; Fri, 27 Aug 2021 06:30:13 -0700 (PDT)
Received: by mail-il1-x132.google.com with SMTP id u7so6996895ilk.7
        for <io-uring@vger.kernel.org>; Fri, 27 Aug 2021 06:30:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:references:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=Req7gVy4BK3ILjNZUVYwwMfG4vXQNVcKU8txntD16CI=;
        b=zMiRciMddeYLak8ito/MsmyGJ5+F9+obwHPMxB8vhH23rbt2DOpP0lnMTTb7ZQtNat
         Ppo4YN9d38RjDzKpTR4igFetJwLO8RhrRdQVcQEqKF6pIRXtbmc7rdVG4Gvns0fSnD5w
         GkfEdlMqeyYML3FIkNZgdZ0qwynLpWOFP31GHsRAE4LrpCeIN5JlQX1nthZSjhlkSjE7
         SC/gs0cl76GBLCqsgtbfK+2HLpdVJgp3QapxHj4P+wfTmB8LhbZV8DMwhDgVtXjkw9GA
         g4KeON3+UeY8Ay2w2QrigBjSjnhpJoZuDNeNMN0vWR6CutIhjfsI3+Um1ktT+zvRna6W
         V3bg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=Req7gVy4BK3ILjNZUVYwwMfG4vXQNVcKU8txntD16CI=;
        b=IbK1Ix/DDyF9ZViU0mxEkseQ2iwG3ATFRUzaUBKBGbxpabLfS0eP4Df5DYdYR0lEO5
         /sT2Cll6EkKOzu5RyK+uQNlA01RvBldwktUh8g8wZ7FDwe8Eu0rLGMHSYig3vhoJY2zX
         y+MLE2bpwachTO+IwgVHY+pelHH0oJntqxfLifUsqyKES9/Shr9+fKlDZbfc3IPE8/IG
         vAHcMs+2ZsjaRx0vJoxd4rupAfpQpq/8iJ18FsiWaxf8Ftt2Qxp/uosIYM3Zn+LeyGV/
         jpFQ4zpoVLgiNR9iL6IvZoIEEBpYipZNx4MQJUFLZaRHNyoNllIBq0KlxPWZ40+81Wy3
         qYqQ==
X-Gm-Message-State: AOAM5328FeC7p5ASz4iu6EZkbXBe1USc7tbUFCWQUh4A6LI0ATSuZ4Lg
        A7qtqMaMctZIvKK/lk5z5pLae/32sZ36vw==
X-Google-Smtp-Source: ABdhPJyFuLjjX8Po9o3yzkfXu7o2u9iLIQLG6emzy5W7/6Bef+VH+EIM/GRSCvDtPoeVLrrh4Fda0g==
X-Received: by 2002:a05:6e02:1526:: with SMTP id i6mr6390652ilu.74.1630071011699;
        Fri, 27 Aug 2021 06:30:11 -0700 (PDT)
Received: from [192.168.1.30] ([207.135.234.126])
        by smtp.gmail.com with ESMTPSA id n11sm3441029ilq.21.2021.08.27.06.30.11
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 27 Aug 2021 06:30:11 -0700 (PDT)
Subject: Re: [PATCH for-next] io_uring: add task-refs-get helper
To:     Pavel Begunkov <asml.silence@gmail.com>, io-uring@vger.kernel.org
References: <d9114d037f1c195897aa13f38a496078eca2afdb.1630023531.git.asml.silence@gmail.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <0d4db19a-99e0-41f4-3809-0c48e68cfdb5@kernel.dk>
Date:   Fri, 27 Aug 2021 07:30:08 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <d9114d037f1c195897aa13f38a496078eca2afdb.1630023531.git.asml.silence@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 8/27/21 4:55 AM, Pavel Begunkov wrote:
> As we have a more complicating task referencing, which apart from normal
> task references includes taking tctx->inflight and caching all that, it
> would be a good idea to have all that isolated in helpers.

Applied, thanks.

-- 
Jens Axboe

