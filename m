Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B05EA21C4C7
	for <lists+io-uring@lfdr.de>; Sat, 11 Jul 2020 17:16:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728330AbgGKPQA (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sat, 11 Jul 2020 11:16:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46272 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728309AbgGKPQA (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sat, 11 Jul 2020 11:16:00 -0400
Received: from mail-pf1-x443.google.com (mail-pf1-x443.google.com [IPv6:2607:f8b0:4864:20::443])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2A0FCC08C5DD
        for <io-uring@vger.kernel.org>; Sat, 11 Jul 2020 08:16:00 -0700 (PDT)
Received: by mail-pf1-x443.google.com with SMTP id u185so3873325pfu.1
        for <io-uring@vger.kernel.org>; Sat, 11 Jul 2020 08:16:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=4JGKsTrujWh1J+jL+NJGFy+29BEF2aFduIpRoKZuL1Q=;
        b=lc6E0QmXfgQ89svAC+FK1ytDapZ7Pot3ICVcs+k5Rsz/R2OUwwJtNb01LjqBjjEzih
         9+HBQ8XqLvllAq8/lTHTbMMBDtuNDPc2Ub0a63N/NO0LjL+PZlb4p1qhT6n24lIqsKkj
         l8kjFBO5xXsXPcfC6xtNyWncu6XruAT3Kwe48+C4eeY851Gn99Fj9XZwnA5cQVRB2ED1
         3JwYd0aS2m9eUG1aySmS9T78FRmrU/7myD0FCI7dvUeUD6VuAnd1B9OHcuD88OZKUGH6
         NqKPwA9wM62BgnD9Xo6PLCzjQBMYDUE/j8o849u88H2D3Ra2cRrEIUFVtR+m5VZGT6p+
         fXWA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=4JGKsTrujWh1J+jL+NJGFy+29BEF2aFduIpRoKZuL1Q=;
        b=CdBAlb6N4UvAjZWIKLUk1eZ57hfLiPVKLN8s1OwgnheNF2gdhDBIa58I84+XlhgtVB
         GC1sFr/nQEnqqBFYZGc3oQ0tuInKZkY88LIK0d2rFkhrHYCF/+r9J5neTWOkV4Odqrhn
         P8vLvdzcHy8sBkoS+AdRn+7wDMWYInouvwIsbB2K74TqBm59m/RnijwP2JBYWlAZ+/lb
         A0qaGKG16Xkkobr1IE/aJD2NpkKi8A0ESHT4JtD+ChIQycfPMjc2y5mLdxpLzjrt/Hy8
         qubZ1geC6IFhprO6OFlxrw2YJYu4QwZyjfVJJ4GlNxS5PHdd7FO3+mOaqErLfVQSZcq5
         pnHw==
X-Gm-Message-State: AOAM531K15KjngsIg5oUduh88udBIJ1r/g8jjwjZHXzQ8mOEAx2yLhu9
        f+i0mXaEP5EoqSwIdiApN5Q5OQ==
X-Google-Smtp-Source: ABdhPJwQVw+u4WkgAzKY0R3CNF4cYFUdOgY5FuzxbSOcoZ8ZesPh4pNfyxHG1M2BmXlGgd7zXh7L4Q==
X-Received: by 2002:a63:fc09:: with SMTP id j9mr64853654pgi.308.1594480559480;
        Sat, 11 Jul 2020 08:15:59 -0700 (PDT)
Received: from [192.168.1.182] ([66.219.217.173])
        by smtp.gmail.com with ESMTPSA id o14sm8806255pjw.3.2020.07.11.08.15.58
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 11 Jul 2020 08:15:58 -0700 (PDT)
Subject: Re: [PATCH] io_uring: fix sq array offset calculation
To:     Dmitry Vyukov <dvyukov@google.com>
Cc:     necip@google.com, io-uring@vger.kernel.org,
        Hristo Venev <hristo@venev.name>
References: <20200711093111.2490946-1-dvyukov@google.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <7d4e4f01-17d4-add1-5643-1df6a6868cb3@kernel.dk>
Date:   Sat, 11 Jul 2020 09:15:57 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20200711093111.2490946-1-dvyukov@google.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 7/11/20 3:31 AM, Dmitry Vyukov wrote:
> rings_size() sets sq_offset to the total size of the rings
> (the returned value which is used for memory allocation).
> This is wrong: sq array should be located within the rings,
> not after them. Set sq_offset to where it should be.
> 
> Signed-off-by: Dmitry Vyukov <dvyukov@google.com>
> Cc: io-uring@vger.kernel.org
> Cc: Hristo Venev <hristo@venev.name>
> Fixes: 75b28affdd6a ("io_uring: allocate the two rings together")
> 
> ---
> This looks so wrong and yet io_uring works.
> So I am either missing something very obvious here,
> or io_uring worked only due to lucky side-effects
> of rounding size to power-of-2 number of pages
> (which gave it enough slack at the end),
> maybe reading/writing some unrelated memory
> with some sizes.
> If I am wrong, please poke my nose into what I am not seeing.
> Otherwise, we probably need to CC stable as well.

Well that's a noodle scratcher, it's definitely been working fine,
and I've never seen any out-of-bounds on any of the testing I do.
I regularly run anything with KASAN enabled too.

In any case, the patch is obviously correct, I'll queue it up.

-- 
Jens Axboe

