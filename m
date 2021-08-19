Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B14113F1D55
	for <lists+io-uring@lfdr.de>; Thu, 19 Aug 2021 17:53:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240168AbhHSPyX (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 19 Aug 2021 11:54:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35484 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232895AbhHSPyX (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 19 Aug 2021 11:54:23 -0400
Received: from mail-oo1-xc29.google.com (mail-oo1-xc29.google.com [IPv6:2607:f8b0:4864:20::c29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 24806C061575
        for <io-uring@vger.kernel.org>; Thu, 19 Aug 2021 08:53:47 -0700 (PDT)
Received: by mail-oo1-xc29.google.com with SMTP id s21-20020a4ae5550000b02902667598672bso1955105oot.12
        for <io-uring@vger.kernel.org>; Thu, 19 Aug 2021 08:53:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:references:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=N/R+1lKBGedFLZ3aYV0746BHm05ZFMdXPvfJpzQxAJM=;
        b=dYGfffv5TBGAkd9ZypVE5T/L3xwoZ2J1uA+0WEHKJy4ejOLSEk9eXyxESHvWL7eGpQ
         C0L0Db0XxFAiIDESvHHbG53Vsxl6koQ47t80Faan8GTx6FkYYcK6NNpmLC7zkRrhQuUS
         AMre7yhNpV7LqKKK8iYSCFYfBxeq3JnWMIFJgmOZz8EXT6pZbsnpDnMwK/2j01GndpyH
         9cN2S7AokoD3BZ8V+8uvWsCSs0M7uDJUDlsdAT0tAS84DS2WjmlMgLmEZASGcM02dKjP
         hzA8XCm1mk0LfHb6z27Uwhhot7DV9WhU16sT46TBIVmz/Q2SFCUNNx6wqUAP/oY0FHPB
         zr5Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=N/R+1lKBGedFLZ3aYV0746BHm05ZFMdXPvfJpzQxAJM=;
        b=VFtE/yPJCcufgFvyQdeXiQ5mV+3xlCS9GuX+ZcvmcjOfntWifNeFKXk1PGcxPUK0M+
         VV51y+IXP5GZT1ordMXzVj+arGdmum8kseBFgA3z+h/oud4EXrtKJgtr+7mFRj3uf7Yf
         BhJTHrxiMBEybfEnynzpfv0Qf5sKWE5xdIAQ+SsmCI+e8kSNZt0kqPWy2H3U9JocSxq7
         LdKXi4TskyYW/cQ0BhmYgNZNKJQ7zhGs3HQ1XXDlzC7DLvk8R/xzlDpK3wC9uQoCQGgG
         iY5vBKvyP2Bgydc5DrNHk4/paMpS2x1p2Ty3vUI2U1YRjE0QO3J4RS17DJzraiZb23GX
         XpzQ==
X-Gm-Message-State: AOAM531Bate6db/BlKrpXnXHDQf2cngyLPPTPH4XKmd/zoNHe5SDgG5z
        IlKAQ0HEMcsTJQnLEV5IfkrtTVWESqHsbBhL
X-Google-Smtp-Source: ABdhPJx00rvmrxC3iaeTBtjmBIFzxSoD6bXrU6kdqvos+jsMBuLlEzW2gTKyR48N1Hbf6UdwoNJcSA==
X-Received: by 2002:a4a:45cc:: with SMTP id y195mr12071178ooa.52.1629388426281;
        Thu, 19 Aug 2021 08:53:46 -0700 (PDT)
Received: from [192.168.1.30] ([207.135.234.126])
        by smtp.gmail.com with ESMTPSA id 4sm719398oil.38.2021.08.19.08.53.45
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 19 Aug 2021 08:53:45 -0700 (PDT)
Subject: Re: [PATCH 0/3] tw mutex & IRQ rw completion batching
To:     Pavel Begunkov <asml.silence@gmail.com>, io-uring@vger.kernel.org
References: <cover.1629286357.git.asml.silence@gmail.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <018a6c73-7327-bbba-86f2-057711755487@kernel.dk>
Date:   Thu, 19 Aug 2021 09:53:45 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <cover.1629286357.git.asml.silence@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 8/18/21 5:42 AM, Pavel Begunkov wrote:
> In essence, it's about two features. The first one is implemented by
> 1-2 and saves ->uring_lock lock/unlock in a single call of
> tctx_task_work(). Should be useful for links, apolls and BPF requests
> at some moment.
> 
> The second feature (3/3) is batching freeing and completing of
> IRQ-based read/write requests.
> 
> Haven't got numbers yet, but just throwing it for public discussion.

I ran some numbers and it looks good to me, it's a nice boost for the
IRQ completions. It's funny how the initial move to task_work for IRQ
completions took a small hit, but there's so many optimizations that it
unlocks that it's already better than before.

I'd like to apply 1/3 for now, but it depends on both master and
for-5.15/io_uring. Hence I think it'd be better to defer that one until
after the initial batch has gone in.

For the batched locking, the principle is sound and measures out to be a
nice win. But I have a hard time getting over the passed lock state, I
do wonder if there's a cleaner way to accomplish this...

-- 
Jens Axboe

