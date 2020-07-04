Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 32F9D21466B
	for <lists+io-uring@lfdr.de>; Sat,  4 Jul 2020 16:26:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726800AbgGDO0o (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sat, 4 Jul 2020 10:26:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38068 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726643AbgGDO0n (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sat, 4 Jul 2020 10:26:43 -0400
Received: from mail-pj1-x1043.google.com (mail-pj1-x1043.google.com [IPv6:2607:f8b0:4864:20::1043])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A404BC061794
        for <io-uring@vger.kernel.org>; Sat,  4 Jul 2020 07:26:43 -0700 (PDT)
Received: by mail-pj1-x1043.google.com with SMTP id h22so15131953pjf.1
        for <io-uring@vger.kernel.org>; Sat, 04 Jul 2020 07:26:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=U9QsXS+kRzeCiX9GiKwMZX59+CemvQFa4kNqY1rt+xc=;
        b=i0QeSwKpfBnLqZDEE+3n8uK4jgo3dnM1zlFtetW5SI35raeb/SztFdP0xFjlQT9XTD
         Y+qO1l8kgxlsSKpVjVkxRzoKg9Oet8ER4hNPdK20HcUJFUl18MiwPitJsfI3nV/Aarqq
         RN6Sqe2cLgnIYwrsa0248yqKYYWc4XNhRWiDKMamx5vS9gKLog7enKyz2ifw603BrhOH
         RkyekAb/DdLjPIkF3xvP/ZI6j/9o2az3BtJWbIk8/N5iH4yeJEFzMdihfkLZjN+MxgXT
         u44orQXtiUvsgRpY7+Sz4Qzsr1QMwSz+COcZT6Hk7sz3Q4ztoTMk4Uk4sWVf15ZnMHXm
         WUpw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=U9QsXS+kRzeCiX9GiKwMZX59+CemvQFa4kNqY1rt+xc=;
        b=WGf72B1dTwF/sWEN1HnoTuZ9Kby65+H+j0ofZlGc+/mj2hPOfrGwkpmfDSC6ku5TAw
         PhL/nwIHEdZ/7nytQuHCV4lKUO2oey6v9BN9haQdiTaKoRLhMUyUyledcyIZ9hiTv13v
         8/dkD/lxTeOMaIKR6OjD7hLnZQk9DEql+VYy07zkLJiue+MwzTxCefblJPD2hUA1QdSj
         qGkx3GlaxMTGQ7xWM3R3SaSx8jY1FhmVSoDj22+K0M9jlA+SI7Pqs23A9o18U3l83z0U
         lTnaiWwrPC9GqEcjwQCycLgguP0q7zHikDwP5FUz1chtlxsNMtp6FdCw1K+Y2b2ND1i6
         qKaQ==
X-Gm-Message-State: AOAM530O2pzGhu+sFgToX973iT3Z0e2V5mPaCcD9BCEJrZDyJiJo1WoZ
        398g1edBKARSq6ml/CrkI8UrbfjX+8ruFA==
X-Google-Smtp-Source: ABdhPJz+eGALw4YAijrFErBmFdTDgcI8xt9DyZLyqJHreDTt4W+YLw8D4aUOAelnGa9NqLOygHMGYA==
X-Received: by 2002:a17:902:ee8b:: with SMTP id a11mr23625335pld.26.1593872802976;
        Sat, 04 Jul 2020 07:26:42 -0700 (PDT)
Received: from [192.168.1.182] ([66.219.217.173])
        by smtp.gmail.com with ESMTPSA id o8sm14072685pgb.23.2020.07.04.07.26.41
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 04 Jul 2020 07:26:42 -0700 (PDT)
Subject: Re: Keep getting the same buffer ID when RECV with
 IOSQE_BUFFER_SELECT
To:     Daniele Salvatore Albano <d.albano@gmail.com>,
        Hieke de Vries <hdevries@fastmail.com>
Cc:     io-uring <io-uring@vger.kernel.org>
References: <CAKq9yRg1NkEOei-G8JKMMo-cTCp128aPPONeLCGPFLqD5w+fkA@mail.gmail.com>
 <193a1dc9-6b88-bb23-3cb5-cc72e109f41b@kernel.dk>
 <CAKq9yRjSewr5z2r8G7dt68RBX4VA9phGpFumKCipNgLzXMdcdQ@mail.gmail.com>
 <e68f971b-8b4a-0cdf-8688-288d6f6da56e@kernel.dk>
 <CAKq9yRjBUuTPAp7xuRhZ8X+OugiD0gm6LCbr6ZGzwKyG8hmvkw@mail.gmail.com>
 <e8b0f7e4-066b-4218-9c36-682939a9c461@www.fastmail.com>
 <CAKq9yRjwUZ93uybghRTdfjHOMQCs2+FeQ8+fKeWvpeuZi0Ro7w@mail.gmail.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <4ea62f2e-0605-0cea-603d-52b174541acf@kernel.dk>
Date:   Sat, 4 Jul 2020 08:26:41 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.8.0
MIME-Version: 1.0
In-Reply-To: <CAKq9yRjwUZ93uybghRTdfjHOMQCs2+FeQ8+fKeWvpeuZi0Ro7w@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 7/4/20 6:12 AM, Daniele Salvatore Albano wrote:
> On Sat, 4 Jul 2020 at 14:00, Hieke de Vries <hdevries@fastmail.com> wrote:
>>
>> There was a bug in the echo server code with re-registering the buffer: https://github.com/frevib/io_uring-echo-server/commit/aa6f2a09ca14c6aa17779a22343b9e7d4b3c7994
>>
>> Please try the latest master branch, maybe it'll help you with your own code as well.
>>
>> --
>> Hielke de Vries
> 
> Yes, that fixed my issue too!

So I guess this was just app error, nothing wrong on the kernel side?

-- 
Jens Axboe

