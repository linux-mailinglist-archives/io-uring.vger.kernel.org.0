Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BED0A224BE1
	for <lists+io-uring@lfdr.de>; Sat, 18 Jul 2020 16:37:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727779AbgGROhR (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sat, 18 Jul 2020 10:37:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40136 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727103AbgGROhQ (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sat, 18 Jul 2020 10:37:16 -0400
Received: from mail-pg1-x541.google.com (mail-pg1-x541.google.com [IPv6:2607:f8b0:4864:20::541])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 90613C0619D2
        for <io-uring@vger.kernel.org>; Sat, 18 Jul 2020 07:37:16 -0700 (PDT)
Received: by mail-pg1-x541.google.com with SMTP id g67so8110399pgc.8
        for <io-uring@vger.kernel.org>; Sat, 18 Jul 2020 07:37:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:references:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=l5YWaw5ixjhtAYjd1G7ciSiLIU/kiucshTPeB3U3VoQ=;
        b=l1x11iJAKEHrWwujJIpETBnskYVztvx6O/sfkRtek979BMRII2IihQbN6kGJ1k1HdT
         2ExwWpJyXIGW4bp7qRR+akuH9L9ojvKV2PMJegNzYBqbbdAgpvX6/E9VptnsVtKm2YmY
         iEuhfOyPED8GbPqjRIT3suWAZG86scwzkxX1E+2Ba9GWp0tTox4FBAEzYiZXDBOsouQw
         lv5iXhgFrD7qR1+6a6TNCLF2RiBlXYYYRGr12JWNaTeFlWxRXA1xajNPnLXV+yX3tyyV
         8/ugQQJKpc6J72ZMXGuHejc/5SvrLiIcBgpXkVyTzPxYIBlG413UOn/7FYBSpXm4OIi0
         ffVg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=l5YWaw5ixjhtAYjd1G7ciSiLIU/kiucshTPeB3U3VoQ=;
        b=b/A7YSUjgaLKO3FLIKBAo2p3cjFfM5gc9vrobW+9pAvJR6/sp56lF1dISMuh63NtPu
         ISTS9J4XQ5MgsqgCgAxOEsBJiErDA4DtudNecY9w+yq23JhisDJgVquv+pgWUKUIu/cn
         May45h7TF0vzS5gy6D4t0txzBch/beOcd/NM2TmUY+g4RvYFS55izm1O6XpXOR+sw3eB
         ggxm5+HkBy5Ivt19KCYkm/Ycj4wBGS5SpGC+gtyRAm2y8zGdckS6Xgd1HkwHZjfGzf/W
         7Etns97yDk9EC3rBLtuarthJdHasOjZP5mhsiNO8wM7m5ybvZdpyP8d1IGnq2aHyEkut
         Xtyg==
X-Gm-Message-State: AOAM532RjUTeVMsTh5wAvPpao1+ugVEG15UTIyNAHZwELiMGyqVlYTLv
        GUjJhCvz1gE1iWHz3xFbR9GSlpMca0Q4sQ==
X-Google-Smtp-Source: ABdhPJzr32g9ST8Al/h/yHguTxtR3oam/fts3eQAOEqg1KfQwMADKL8y4AxU4R9aE5wq8ssCLV+T+Q==
X-Received: by 2002:a63:925a:: with SMTP id s26mr12572854pgn.21.1595083035879;
        Sat, 18 Jul 2020 07:37:15 -0700 (PDT)
Received: from [192.168.1.182] ([66.219.217.173])
        by smtp.gmail.com with ESMTPSA id c1sm5947874pje.9.2020.07.18.07.37.15
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 18 Jul 2020 07:37:15 -0700 (PDT)
Subject: Re: [PATCH 5.9 0/2] memory accounting fixes
To:     Pavel Begunkov <asml.silence@gmail.com>, io-uring@vger.kernel.org
References: <cover.1595017706.git.asml.silence@gmail.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <7adeba63-f143-c212-a8f7-3f026ffd9b1e@kernel.dk>
Date:   Sat, 18 Jul 2020 08:37:14 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <cover.1595017706.git.asml.silence@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 7/18/20 2:31 AM, Pavel Begunkov wrote:
> Two small memory accounting fixes for 5.9
> 
> Pavel Begunkov (2):
>   io_uring: don't miscount pinned memory
>   io_uring: return locked and pinned page accounting
> 
>  fs/io_uring.c | 11 ++++++-----
>  1 file changed, 6 insertions(+), 5 deletions(-)

Thanks, applied.

-- 
Jens Axboe

