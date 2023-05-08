Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E9A976FB65B
	for <lists+io-uring@lfdr.de>; Mon,  8 May 2023 20:41:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229621AbjEHSl0 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 8 May 2023 14:41:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34584 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229539AbjEHSl0 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 8 May 2023 14:41:26 -0400
Received: from mail-il1-x136.google.com (mail-il1-x136.google.com [IPv6:2607:f8b0:4864:20::136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2872959E9
        for <io-uring@vger.kernel.org>; Mon,  8 May 2023 11:41:25 -0700 (PDT)
Received: by mail-il1-x136.google.com with SMTP id e9e14a558f8ab-334d0f0d537so859205ab.0
        for <io-uring@vger.kernel.org>; Mon, 08 May 2023 11:41:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20221208.gappssmtp.com; s=20221208; t=1683571284; x=1686163284;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=A7PuSvnxbmZTQbeeXnCmGe6EuFu2BAr149qtjGgbBP8=;
        b=CezMIwxzygqTFOj0LPFQXllQ/J5QNUnrU9Hldbtorh6aP6rGsq1flibQAmyuin4D+U
         jp2ixflOyfmLSTFGeNADPMYelt5B9yafz2J7KXUOf607v69UfJr1bR2RHEfNa1/yPao/
         5opuahQLcVcqy87AxOQ8nYgi/E1iyamDHd7z/zLEoUvGyixmDx7GbvwipNsVbCM68Nmr
         IEJByBwREdvG3SFzSxakCpzT0BMXNXvO929r3KSi11W/IQtakBnhkg3SX8VB2j24uJnt
         1dxeGDd/Kr9f7g2xNefyywApmnM8OLwv+twFf0qg9DylfxB8CCUHb6v4+cJP2QbyrNfy
         Glug==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1683571284; x=1686163284;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=A7PuSvnxbmZTQbeeXnCmGe6EuFu2BAr149qtjGgbBP8=;
        b=l3KGkiBgIKTn8Qh9vK1kXhOJfcsk+QUISJYbkYi0S9oqX64CWlstqnNT9F0Mea3pIg
         T/55ve2rzQPHfRubem2/RB3FvV80bJ4akqAyvLISgAI4zO8gvR+jycNRl7PvWvzkdpC6
         yJNTV5iPJc5pG5qzB2UQ0qYh70S4AD90baCY8/cfjxqyEO5+JOyokIAEDFYyfoP/9eIS
         WoKFVlIgEFhJD+FbOSiCHiyLlZAo8xw3fm98tUQcgDtAMLOFFpA2QkNB+PyMNOTf8by1
         5+JLx31jXuarbeppiX4+hU22TPvMwQagTqSi+4EvyWTOWEiOC3hoqlR1ybFXxBRueGPb
         ws3Q==
X-Gm-Message-State: AC+VfDwXmbRlUzv3El1tAGrkjZR74jjSuppTLMC9a39JoZ89mUjAZI5s
        wfC4mQbCPOcNhYiDErUxE6Br2Ja1jlc5dOToH1A=
X-Google-Smtp-Source: ACHHUZ7b3ZVbRJHxVgS7b3NXU9ez7OpVtZ1EfUfaNOGm1qoFeDLUI3s85n6Hq4aVfq1Wi9M1VvP9Ww==
X-Received: by 2002:a05:6602:1642:b0:763:542a:f26e with SMTP id y2-20020a056602164200b00763542af26emr8338913iow.1.1683571284426;
        Mon, 08 May 2023 11:41:24 -0700 (PDT)
Received: from [192.168.1.94] ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id f11-20020a056638168b00b0040fadba66b0sm2116035jat.58.2023.05.08.11.41.23
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 08 May 2023 11:41:23 -0700 (PDT)
Message-ID: <7020b6a2-a664-f034-baa7-27cd80e1ff88@kernel.dk>
Date:   Mon, 8 May 2023 12:41:22 -0600
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux aarch64; rv:102.0) Gecko/20100101
 Thunderbird/102.10.0
Subject: Re: [GIT PULL] Final io_uring updates for 6.4-rc1
Content-Language: en-US
To:     Linus Torvalds <torvalds@linux-foundation.org>
Cc:     io-uring <io-uring@vger.kernel.org>
References: <9b2e791d-aeba-a2c7-1877-797ff5c680a3@kernel.dk>
 <CAHk-=wjvZQeXHUDUJZKJnej+cLvq8OdkFifg1McWLmrHo=Y_0w@mail.gmail.com>
From:   Jens Axboe <axboe@kernel.dk>
In-Reply-To: <CAHk-=wjvZQeXHUDUJZKJnej+cLvq8OdkFifg1McWLmrHo=Y_0w@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-0.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,RCVD_IN_SBL_CSS,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 5/7/23 10:59?AM, Linus Torvalds wrote:
> On Sun, May 7, 2023 at 5:00?AM Jens Axboe <axboe@kernel.dk> wrote:
>>
>> Note that this will throw a merge conflict in the ublk_drv code, due
>> to this branch still being based off the original for-6.4/io_uring
>> branch. Resolution is pretty straight forward, I'm including it below
>> for reference.
> 
> Mine is somewhat different - I think the "ub_cmd" argument to
> __ublk_ch_uring_cmd() should also have been made a 'const' pointer.
> 
> And then using an actual initializer allows us to do the same thing
> for the copy in ublk_ch_uring_cmd() (and also makes it clear that it
> initializes the whole struct - which it did, but still...)
> 
> So my conflict resolution looks a bit more complicated, but I think
> it's the RightThing(tm) to do, and is consistent with the
> constification in commit fd9b8547bc5c ("io_uring: Pass whole sqe to
> commands").

Your resolution is obviously fine, and I did ponder pushing the
constification further. Thanks!

-- 
Jens Axboe

