Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 757856FC858
	for <lists+io-uring@lfdr.de>; Tue,  9 May 2023 15:59:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235596AbjEIN7y (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 9 May 2023 09:59:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44402 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233962AbjEIN7x (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 9 May 2023 09:59:53 -0400
Received: from mail-il1-x134.google.com (mail-il1-x134.google.com [IPv6:2607:f8b0:4864:20::134])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E866A30FA
        for <io-uring@vger.kernel.org>; Tue,  9 May 2023 06:59:50 -0700 (PDT)
Received: by mail-il1-x134.google.com with SMTP id e9e14a558f8ab-3357ea1681fso417195ab.1
        for <io-uring@vger.kernel.org>; Tue, 09 May 2023 06:59:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20221208.gappssmtp.com; s=20221208; t=1683640790; x=1686232790;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=hd6ZB9aSf979ARr3TqFE0nWEfQzugKRcLTSaL7ZQ8us=;
        b=4+PqTxPO/yz7EkghXMUvCXZqut880jtX1fj+yTavRDIDlW6VCKy0JigNU5r11IUHF/
         I4/ImtFwGv4FBzUzDBzXOIOi/CgoRb3rp0U3sJTLgG7HJeHROJUBCrMp0rTnCWoMQ+jL
         0Fxls9FNabL7++hSX6jtSDFq+pav6pYPtgOZsn2jJuKqZWNkwM+06Y4jnq4H1DlkhICM
         qzFKRn4y8EMHsqfThybD3WggyuAbi1nLyG7Z8LBJFz8ZaIoJ6iKEamCLfI84/sgVrmqR
         OMiLDpRV2IJHEh1BvPVtn6VOSv7bauJMaB4T8t7KbAhcxndrggGzFpvdlTHEwoABcZRc
         hB+w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1683640790; x=1686232790;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=hd6ZB9aSf979ARr3TqFE0nWEfQzugKRcLTSaL7ZQ8us=;
        b=PwkMm6KEStlmJLeZeFG1WAJR3RIGRErhxUoiKvVZkyHoOWGgAE9lj+smRuMizaV+D6
         5qMd449y2ff3Z2rMMuVeF7HmL1bO4ka9EsvRN7kHlJmwo7btBdL8L/nr5Iy+xQg7GE9h
         9YnsiXCFH7UVmhuAApOZqe3MJaks1izWY6ReVmGpxnJif8P1znXcxbSrxEloEWPGMra6
         PAemhMk5D7UReEaj9YmvxLr1vetpodO9AFlVHYk6ppZxcbxq3HxihFzfOkokWiBeHa8I
         zipxDTQJLqBiiWjG1PJJN7XdSAj/yvxdMBB7Sbs302/Xx/LFO3Ti378zCvrpd2DI1Dco
         VDkg==
X-Gm-Message-State: AC+VfDwvYZXdhWGmDsG8YI++UArJLcTsUCgYo8caB8wK6lrVwzl5GVhM
        7/IaVk/uR0DmkocVoqgxkCt+Fg==
X-Google-Smtp-Source: ACHHUZ7Y5mQy1Q7Ux5Hq4kEgKF/SGR+TgYQuhDIIaVeLtYJy/BQ7njzk9FzPnC/yJOGbvvQX7FJe3Q==
X-Received: by 2002:a05:6e02:4a9:b0:32a:8792:7248 with SMTP id e9-20020a056e0204a900b0032a87927248mr6440953ils.2.1683640790150;
        Tue, 09 May 2023 06:59:50 -0700 (PDT)
Received: from [192.168.1.94] ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id b24-20020a05663801b800b00411b6a4ab7esm2752304jaq.93.2023.05.09.06.59.49
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 09 May 2023 06:59:49 -0700 (PDT)
Message-ID: <6d6a494b-3c1a-2bf6-79e3-0ccc81166a67@kernel.dk>
Date:   Tue, 9 May 2023 07:59:48 -0600
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux aarch64; rv:102.0) Gecko/20100101
 Thunderbird/102.10.0
Subject: Re: [GIT PULL] Final io_uring updates for 6.4-rc1
Content-Language: en-US
To:     Chen-Yu Tsai <wenst@chromium.org>
Cc:     Linus Torvalds <torvalds@linux-foundation.org>,
        io-uring <io-uring@vger.kernel.org>, linux-kernel@vger.kernel.org
References: <9b2e791d-aeba-a2c7-1877-797ff5c680a3@kernel.dk>
 <20230508031852.GA4029098@google.com>
 <fb84f054-517c-77d4-eb11-d3df61f53701@kernel.dk>
 <CAGXv+5GpeJ8hWt2Sc6L+4GB-ghA4vESobEaFGpo1_ZyPhOvW0g@mail.gmail.com>
From:   Jens Axboe <axboe@kernel.dk>
In-Reply-To: <CAGXv+5GpeJ8hWt2Sc6L+4GB-ghA4vESobEaFGpo1_ZyPhOvW0g@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.3 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 5/8/23 8:35?PM, Chen-Yu Tsai wrote:
> On Tue, May 9, 2023 at 2:42?AM Jens Axboe <axboe@kernel.dk> wrote:
>>
>> On 5/7/23 9:18?PM, Chen-Yu Tsai wrote:
>>> Hi,
>>>
>>> On Sun, May 07, 2023 at 06:00:48AM -0600, Jens Axboe wrote:
>>>> Hi Linus,
>>>>
>>>> Nothing major in here, just two different parts:
>>>>
>>>> - Small series from Breno that enables passing the full SQE down
>>>>   for ->uring_cmd(). This is a prerequisite for enabling full network
>>>>   socket operations. Queued up a bit late because of some stylistic
>>>>   concerns that got resolved, would be nice to have this in 6.4-rc1
>>>>   so the dependent work will be easier to handle for 6.5.
>>>>
>>>> - Fix for the huge page coalescing, which was a regression introduced
>>>>   in the 6.3 kernel release (Tobias).
>>>>
>>>> Note that this will throw a merge conflict in the ublk_drv code, due
>>>> to this branch still being based off the original for-6.4/io_uring
>>>> branch. Resolution is pretty straight forward, I'm including it below
>>>> for reference.
>>>>
>>>> Please pull!
>>>>
>>>>
>>>> The following changes since commit 3c85cc43c8e7855d202da184baf00c7b8eeacf71:
>>>>
>>>>   Revert "io_uring/rsrc: disallow multi-source reg buffers" (2023-04-20 06:51:48 -0600)
>>>>
>>>> are available in the Git repository at:
>>>>
>>>>   git://git.kernel.dk/linux.git tags/for-6.4/io_uring-2023-05-07
>>>>
>>>> for you to fetch changes up to d2b7fa6174bc4260e496cbf84375c73636914641:
>>>>
>>>>   io_uring: Remove unnecessary BUILD_BUG_ON (2023-05-04 08:19:05 -0600)
>>>>
>>>> ----------------------------------------------------------------
>>>> for-6.4/io_uring-2023-05-07
>>>>
>>>> ----------------------------------------------------------------
>>>> Breno Leitao (3):
>>>>       io_uring: Create a helper to return the SQE size
>>>>       io_uring: Pass whole sqe to commands
>>>
>>> This commit causes broken builds when IO_URING=n and NVME_CORE=y, as
>>> io_uring_sqe_cmd(), called in drivers/nvme/host/ioctl.c, ends up being
>>> undefined. This was also reported [1] by 0-day bot on your branch
>>> yesterday, but it's worse now that Linus merged the pull request.
>>>
>>> Not sure what the better fix would be. Move io_uring_sqe_cmd() outside
>>> of the "#if defined(CONFIG_IO_URING)" block?
>>
>> Queued up a patch for this:
>>
>> https://git.kernel.dk/cgit/linux/commit/?h=io_uring-6.4&id=5d371b2f2b0d1a047582563ee36af8ffb5022847
> 
> Thanks! Looks like the Reported-by line for the test bot is missing a right
> angle bracket?
> 
> Also, consider it
> 
> Tested-by: Chen-Yu Tsai <wenst@chromium.org>

Oops yes, thanks for noticing. I'll correct that and add your tested-by.

-- 
Jens Axboe

