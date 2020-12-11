Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8FE612D7E0B
	for <lists+io-uring@lfdr.de>; Fri, 11 Dec 2020 19:25:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2405806AbgLKSZO (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 11 Dec 2020 13:25:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52692 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2405042AbgLKSYq (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 11 Dec 2020 13:24:46 -0500
Received: from mail-wm1-x341.google.com (mail-wm1-x341.google.com [IPv6:2a00:1450:4864:20::341])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B7CF7C0613CF
        for <io-uring@vger.kernel.org>; Fri, 11 Dec 2020 10:24:05 -0800 (PST)
Received: by mail-wm1-x341.google.com with SMTP id k10so8330381wmi.3
        for <io-uring@vger.kernel.org>; Fri, 11 Dec 2020 10:24:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=to:cc:references:from:autocrypt:subject:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=8kST9Zrgi0LRe6FZFVzx0WrQeqYXNbKRcg/2tCZ9aMM=;
        b=eh4aldIcHNRnI87X7iw+vstkp6rD+86lHJRIhtl2uh6dX8MhgNGKbmNBdwRkv7D6ll
         q8YG6YSIQEkX1fd31CpIka8zyiH8I8Gd3TLlpesc8KlRv25+pcAcE10ccOd3e933DmUq
         0AMA4IhQ87vFrH7EWbk3oEWUep6MQeisOFynMv4EUa77cMsXU85jMNZaUZB8kSLdGjI4
         evOswWiW3c5aiZ8GKGc32CyafSY/IFbE8BoZ+qY19VIespc1Bn6SDBdbQiuKGBpgTtvR
         E/FEpuGWK+KN7Gkezoe/SizBwTISoPK47u5ncoWLdzWLimCxdsrGJfKYQLvk2LevCRo5
         1brQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:to:cc:references:from:autocrypt:subject
         :message-id:date:user-agent:mime-version:in-reply-to
         :content-language:content-transfer-encoding;
        bh=8kST9Zrgi0LRe6FZFVzx0WrQeqYXNbKRcg/2tCZ9aMM=;
        b=UI51Nk9awR3pOrmBLcWLDU1x8Tq0XSvPinSRwdjb7qFufRQQbCrQUzMVEmX7XXQXqF
         aIm30qw++pKUdkCROPd6xEb9xEGZX5zW5p8Sf7iFZgRu8rNKoqv7LioLVbafBDJXCiAW
         +f9WcFAzjqaH8YRin3F11ywTk94eKRQWxlSAdZVh3MJ7cik2wBYbR83+wcTmQtOCPWvf
         p8pWTvDLLqD/GkNKGWga12MBMXfeccmGiYSa/60zaJORGnnnjt6rPiGMSAAal9zJ9poZ
         QZAWntfS6Kt4CSdR964JyvLXW1wkDr9VADNZ5K1OL1gsxQeqUiDoDmue4OcYZuIJjS/R
         57LQ==
X-Gm-Message-State: AOAM531oyCgrU0RNQmt3jXHs7h2ZA7kzYvVWXE5oWrPxCeDBSUl+xNRV
        QKe1MRBQa6d/Y/4tMJ7hEOrQfIF/CGZg4w==
X-Google-Smtp-Source: ABdhPJzbtT+6IlulV5saFKuyQO+y0alRDYk3SKEcLi6o2An7gDEZ4jIiu3NCHdwjSVwCb9UZgmQAWA==
X-Received: by 2002:a7b:cbd0:: with SMTP id n16mr15055507wmi.162.1607711044356;
        Fri, 11 Dec 2020 10:24:04 -0800 (PST)
Received: from [192.168.8.123] ([85.255.234.121])
        by smtp.gmail.com with ESMTPSA id o23sm5364597wro.57.2020.12.11.10.24.03
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 11 Dec 2020 10:24:03 -0800 (PST)
To:     Xiaoguang Wang <xiaoguang.wang@linux.alibaba.com>,
        io-uring@vger.kernel.org
Cc:     axboe@kernel.dk, joseph.qi@linux.alibaba.com
References: <20201202113151.1680-1-xiaoguang.wang@linux.alibaba.com>
 <c4fa3437-49c2-4dce-471a-930ceca3aec3@gmail.com>
 <1249ded8-335a-b441-0207-db943b8a93c8@linux.alibaba.com>
From:   Pavel Begunkov <asml.silence@gmail.com>
Autocrypt: addr=asml.silence@gmail.com; prefer-encrypt=mutual; keydata=
 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 bA==
Subject: Re: [PATCH] io_uring: always let io_iopoll_complete() complete polled
 io.
Message-ID: <03c631cd-e8c6-35be-4b04-5340f693e88b@gmail.com>
Date:   Fri, 11 Dec 2020 18:20:46 +0000
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.3.0
MIME-Version: 1.0
In-Reply-To: <1249ded8-335a-b441-0207-db943b8a93c8@linux.alibaba.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 11/12/2020 14:59, Xiaoguang Wang wrote:
> Sorry for late, I had saw you and jens' discussion in previous mail. I was just
> busy recently, did't have time to look into this issue. Now I have time to handle
> it, will have a look at it tomorrow, thanks.

All cool, as Jens dropped it and decided to do that for 5.11 we're not in hurry,
just wanted to point out stuff to look after! You could also look for a similar
problem with io_cqring_events() if you're interested.

One more thing to ponder is failing -EAGAIN'ed requests in io_iopoll_complete()
if NOWAIT is set.

-- 
Pavel Begunkov
