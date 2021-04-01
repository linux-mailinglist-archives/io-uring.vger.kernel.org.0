Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3353E3518E2
	for <lists+io-uring@lfdr.de>; Thu,  1 Apr 2021 19:49:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234954AbhDARsC (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 1 Apr 2021 13:48:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58368 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235584AbhDARnA (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 1 Apr 2021 13:43:00 -0400
Received: from mail-io1-xd33.google.com (mail-io1-xd33.google.com [IPv6:2607:f8b0:4864:20::d33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D6A1DC022597
        for <io-uring@vger.kernel.org>; Thu,  1 Apr 2021 08:21:27 -0700 (PDT)
Received: by mail-io1-xd33.google.com with SMTP id k25so2570588iob.6
        for <io-uring@vger.kernel.org>; Thu, 01 Apr 2021 08:21:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=+QYEIi6yMazIqkEu7x5PeloazytQGf3O76kbZP93pvs=;
        b=gA1l80M1chUyFRBfOPfClAndC6TNUVs3aJ/6iRCUSXsTAUccpG4qXFlInAM+z2eeM8
         IisfkUbGbF5w3kFsbNp0kh0ilTU5A9Xx78GQ2ylz73X+zRnOoFnL8J72OmGBdW8w7+79
         FJT/t8fxGI4iIAFOEXX6SvIJ2wPaySWTDExKodmW+oB9wY3rpq9Q6Uq3Eu3eq38GiTpy
         McrKvzvfSPzVwhNZCZSlJag1LWB5h/RI7kbQtr97fYhYZelpyosrMIJnjYCdQOYNUNBS
         3srh+h8/L3s0Y+cpc9lz714z7ei23qDTOD/nTLwHlV68l+F+qoH+DuwkvGEpwelS8F+s
         3mrA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=+QYEIi6yMazIqkEu7x5PeloazytQGf3O76kbZP93pvs=;
        b=YfpJG7VLHAIwhBR4U3mqReobVbb2FUB/n3URNylZZDmi0dAV3AMoYGeMZ6OCK4o2E8
         5BBo0kyuBh2XnlOBoF1nfj/Tdg5B5fTkvENNWFP5IHFNmznc+NkOLuOrWu4LyqxCe4Co
         X+YSLag2VQ4M6B6Af71GUnH3mHx/vJ7qwy5f6cNwsP7/l0NRTIc63JtpuS9p3KQ2fEDD
         TSW0YhSQJ6lxTatogZVISU36V9ShHZhljdDslLnaAmeZNU1cBRt9L2hJiPl/1lZNtj8j
         hvkthUCBoElCGk8LAKkozb0NUeD9vgsKTI4trjRCYMLGJmTXfXpn/04AXWu2EuEeEikK
         D8Fg==
X-Gm-Message-State: AOAM532gCN9BgNENoeLq0MNZYT3j0mFD/Mrh4yI6ndpKp4YJPq9tO9RF
        qVXvKzPWO5m6XnUWMEyUlkcKlg==
X-Google-Smtp-Source: ABdhPJzDzeGMX8ZemzOJaVBVamJz0a06zm8ftbU9JowZSTex//XvsY6FZP24I5ydL0tFqdSo1JZ0yg==
X-Received: by 2002:a5e:8d09:: with SMTP id m9mr6818047ioj.29.1617290487283;
        Thu, 01 Apr 2021 08:21:27 -0700 (PDT)
Received: from [192.168.1.30] ([65.144.74.34])
        by smtp.gmail.com with ESMTPSA id a7sm2650026iln.82.2021.04.01.08.21.26
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 01 Apr 2021 08:21:26 -0700 (PDT)
Subject: Re: [PATCH 5.12] io_uring/io-wq: protect against sprintf overflow
To:     Pavel Begunkov <asml.silence@gmail.com>, io-uring@vger.kernel.org
Cc:     Alexey Dobriyan <adobriyan@gmail.com>
References: <1702c6145d7e1c46fbc382f28334c02e1a3d3994.1617267273.git.asml.silence@gmail.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <38787c96-0ac6-6284-a980-898593b5e056@kernel.dk>
Date:   Thu, 1 Apr 2021 09:21:26 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <1702c6145d7e1c46fbc382f28334c02e1a3d3994.1617267273.git.asml.silence@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 4/1/21 2:55 AM, Pavel Begunkov wrote:
> task_pid may be large enough to not fit into the left space of
> TASK_COMM_LEN-sized buffers and overflow in sprintf. We not so care
> about uniqueness, so replace it with safer snprintf().

Applied, thanks.

-- 
Jens Axboe

