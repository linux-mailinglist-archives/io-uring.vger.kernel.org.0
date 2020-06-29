Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4083420D6AC
	for <lists+io-uring@lfdr.de>; Mon, 29 Jun 2020 22:05:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730394AbgF2TWp (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 29 Jun 2020 15:22:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45100 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732264AbgF2TWo (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 29 Jun 2020 15:22:44 -0400
Received: from mail-pf1-x442.google.com (mail-pf1-x442.google.com [IPv6:2607:f8b0:4864:20::442])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C1B6BC030F38
        for <io-uring@vger.kernel.org>; Mon, 29 Jun 2020 09:56:42 -0700 (PDT)
Received: by mail-pf1-x442.google.com with SMTP id a127so8128840pfa.12
        for <io-uring@vger.kernel.org>; Mon, 29 Jun 2020 09:56:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:references:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=jposRscsSWN2ezJYyGSapvHrQyr/kI6uo/RpsG6RWr8=;
        b=oFqPaC+Pe3IWsDb0e4Xfyg4b+jJ8wjBUpChCKJITc3IKlw4IR19DSAYraQcDBERQOL
         mX9ZMv1coIhRnWIQCxmlWeAgz9C8kkZrNIP7lN8q3Si0xMJrAbyTPQAbD+mB24KLdQpa
         S+Dz/1uDFSdl3ik26t68TNJrY6cLZeqAZ3x5+esKEO8HsX/CCJeMI+tpXjbrgjRBLhZb
         MaB1vhTH06JjVR0DLzXlRvx+RZ8HL26MS0U6Qs7YtkR0ubsSBycG4Nb9mrokeLIsrCzA
         74QS42DoayxUZ4nXtp42m5iX33Bz0jZpNHwvzWz8fAE3Nw1iQP6fqzKzsLBq82vQDX4N
         otGA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=jposRscsSWN2ezJYyGSapvHrQyr/kI6uo/RpsG6RWr8=;
        b=fYF+HT3xkSNhj7xv4oCkyiKl2KGZRt3KL/SH7O07JeK8si3xdtyuxiy3C9CmFCUdw6
         PChndH+zp9d+XGizbF3uo4hv4bOCSFYqJoyIy0Amp9r2AIpNgkj/od7fYUyKIGzYUQF+
         z2hd5k3n8YP/Xt/ed1/hrU0NeKXhLo0yZ5KP0PQhaQ8q/ccl8eXmSiNWQdcLB/pHd02x
         mZEOCjxkl9VHdI97RTG353lnj4Br6a1JY8QGRrHzDvb26zEikBAIcq9Omo6b2oYWmj2r
         IgXYsA6cW936VgAsbx5zzh+Y/OA0JCw5wNV38vgwS2GhZlEbNIOMpcqUCKzJwZ9n5PSt
         +dBg==
X-Gm-Message-State: AOAM5306u4Cv1xeXY3VwZavSwaEygUFYmW6W2qcc4iKbSTGnvNmTalI+
        PpDqMILJJNNfgVjsAslXSNdo1IsDvs1rpA==
X-Google-Smtp-Source: ABdhPJweIQRBzsP3hwwsH57HpsuCGgvsNeZwfsRtkWRAEnIKI88Upyt5uSj7jDV2DEgm3hQyZsCfNQ==
X-Received: by 2002:a62:2983:: with SMTP id p125mr1921700pfp.302.1593449801914;
        Mon, 29 Jun 2020 09:56:41 -0700 (PDT)
Received: from [192.168.86.197] (cpe-75-85-219-51.dc.res.rr.com. [75.85.219.51])
        by smtp.gmail.com with ESMTPSA id r13sm233559pfr.181.2020.06.29.09.56.40
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 29 Jun 2020 09:56:41 -0700 (PDT)
Subject: Re: [PATCH for-5.9 0/4] moving grab_env() later before punt
To:     Pavel Begunkov <asml.silence@gmail.com>, io-uring@vger.kernel.org
References: <cover.1593446892.git.asml.silence@gmail.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <3a5f8125-acd7-771c-5c79-76ca1d8cc12c@kernel.dk>
Date:   Mon, 29 Jun 2020 10:56:40 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.8.0
MIME-Version: 1.0
In-Reply-To: <cover.1593446892.git.asml.silence@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 6/29/20 10:18 AM, Pavel Begunkov wrote:
> This is a first part of patches cleaning up after recent link/tast_work
> quick fixes. The main idea intention here is to make io_steal_work()
> functional again. That's done in [4/4], others are preps.
> 
> [4/4] may have its dragons, and even though I tested it
> long enough, would love someone to take a closer look / test as well.

1-3 are straight forward, but I also didn't find any issues with 4
both reviewing it and also testing it. So I'll apply this series,
thanks!

-- 
Jens Axboe

