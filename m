Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BAB85329F97
	for <lists+io-uring@lfdr.de>; Tue,  2 Mar 2021 13:54:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238936AbhCBDkG (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 1 Mar 2021 22:40:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45040 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346289AbhCAXmS (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 1 Mar 2021 18:42:18 -0500
Received: from mail-pg1-x52f.google.com (mail-pg1-x52f.google.com [IPv6:2607:f8b0:4864:20::52f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5BAB1C061756
        for <io-uring@vger.kernel.org>; Mon,  1 Mar 2021 15:41:38 -0800 (PST)
Received: by mail-pg1-x52f.google.com with SMTP id t25so12647090pga.2
        for <io-uring@vger.kernel.org>; Mon, 01 Mar 2021 15:41:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:references:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=o5Kl6YZ2n7rvvn7/KUijlpSLo6uItK1acuOvc8FVtZM=;
        b=FuOdeDYXeN6CnZTAwhQ9GerV0sJW+IsA6GhRsi9GMyFHLA9af/aBcdMDPfOhtPOLgm
         UO+MKifAH/oTn1lv+VHHpf09d5UvIfPE/v08xCbkH4NxmTI8CEQutVXg8k1isZQLG3aE
         Pg2K7OoHMIIvR7a2iiSgAU/BJ+KGkpIWa6S4GL/GuTWEVq+MhkFKIJH5jr+Dw/v7Jr00
         oVOPB0wkLA06BwP9N8ohPUyw2x0YtkVrmeKw0R1nV36PkxlmzX8iQlH80juh+WhgycFj
         b6F2xA4CAYA9qSaeDwMIOBAUMb0bU7HcfM9k99Fr1GcX3k+LwQ1M4IgvcezSU1JztpX+
         WoFg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=o5Kl6YZ2n7rvvn7/KUijlpSLo6uItK1acuOvc8FVtZM=;
        b=idGmHXpKThtOFZNwrQVD/4C7Vvn6shPlYKlqYITFAmBYEZXEfybYJ7EeydIxBAzw6S
         3cuc88sDgW/E4AijWwNTN36e75x/it/35tXoGBUwpAFBaGKiKWyyLrLchUhnPBACDuyj
         tMrzKTlczZfgypGuSi+xRxu2Ht33taRIwJUXvMGdw2krbtZf/esLjY2MqP0at87XtoTD
         jWmqDOH69OjDQd10FA7XK3zFwC+QGyiCwR+XrHa+7lQIR5VM6lzA5GEHAbZbzxuimnvn
         HsXP8zJhmJi2E9el+Auq5HrJZHGolMEHmNOJQgBs5lofesYpHs70mP4TmB+SFIQhMFXx
         AolQ==
X-Gm-Message-State: AOAM530KXI15IL4lkJ/wsGQGrb06r0ild6wleaXR2drxXArDz9Hp8VWr
        AC0PjFGjRixknWmlFTiWGZN0Hwnx5RGhSQ==
X-Google-Smtp-Source: ABdhPJyhsHFkyxvdUnwxgWuJ/YJ90Yv/oIPe9LzuWsePpdViPaacidEu0qblLrSjqz0uuLUq+R4RNQ==
X-Received: by 2002:a05:6a00:1342:b029:1ba:5263:63c3 with SMTP id k2-20020a056a001342b02901ba526363c3mr747529pfu.2.1614642097456;
        Mon, 01 Mar 2021 15:41:37 -0800 (PST)
Received: from [192.168.1.134] ([66.219.217.173])
        by smtp.gmail.com with ESMTPSA id g6sm19135308pfi.15.2021.03.01.15.41.36
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 01 Mar 2021 15:41:36 -0800 (PST)
Subject: Re: [PATCH 5.12 0/4] random 5.12 bits
To:     Pavel Begunkov <asml.silence@gmail.com>, io-uring@vger.kernel.org
References: <cover.1614622683.git.asml.silence@gmail.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <2846c6bd-9cfb-c7cc-bbcb-01f919c97dd8@kernel.dk>
Date:   Mon, 1 Mar 2021 16:41:35 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <cover.1614622683.git.asml.silence@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 3/1/21 11:20 AM, Pavel Begunkov wrote:
> 1/4 is a fix.
> Others may make slightly easier looking for ->io_uring usages.
> 
> Pavel Begunkov (4):
>   io_uring: choose right tctx->io_wq for try cancel
>   io_uring: inline io_req_clean_work()
>   io_uring: inline __io_queue_async_work()
>   io_uring: remove extra in_idle wake up
> 
>  fs/io_uring.c | 44 +++++++++++++++-----------------------------
>  1 file changed, 15 insertions(+), 29 deletions(-)

Looks good, applied.

-- 
Jens Axboe

