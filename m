Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4FFD54252F4
	for <lists+io-uring@lfdr.de>; Thu,  7 Oct 2021 14:26:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241197AbhJGM1x (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 7 Oct 2021 08:27:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55088 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241144AbhJGM1x (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 7 Oct 2021 08:27:53 -0400
Received: from mail-io1-xd34.google.com (mail-io1-xd34.google.com [IPv6:2607:f8b0:4864:20::d34])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CE1FCC061746
        for <io-uring@vger.kernel.org>; Thu,  7 Oct 2021 05:25:59 -0700 (PDT)
Received: by mail-io1-xd34.google.com with SMTP id m20so5784022iol.4
        for <io-uring@vger.kernel.org>; Thu, 07 Oct 2021 05:25:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=sDRXuFABae3yGB4ZhRLOa5Q0Pg95Albn11hUSNzvLjM=;
        b=fUeNskoEIK9yehkdUcPS4JpecWQ2MkcGOKB5EdHNJLsJBTXwg0nMvj7VhEYWSXa+Id
         y/PB/pgUPByFHkdXLRKfDYeaRy96aLWLVWLto1M0Zi2IDOx/iu61ZFeKbRKspFftDvy0
         ibwyTRyG3Eob6Jo+fRDwsjoG/wCu1PROC1dxC6ZCzAaWjqCzwOXkYdfaB8l5NLE/gVth
         ZMrCDAX6wI7b7Zsdn+b2BXEuLiILlBBiWymuuIs3ny85SfjkvfcKZdr86AgJcPVE+0DF
         hnxrR4MTffKLdZgX4zWqOKuWjU+fNexgp1IbsdoaY8V1hSolAgmqIQz6Gyp2esrB7Phl
         3baA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=sDRXuFABae3yGB4ZhRLOa5Q0Pg95Albn11hUSNzvLjM=;
        b=pu8/kQzRbjKsJsGVPwRZngMPRcVz+2ki2KHYh3WNCIdckuNTgJR1tP85ba4iafqXy9
         A/WSD5ggL9kBg7OSobLZO/c+N6ogsU4TbpmnCQ8LlR84fwgRZNzSYhdh7q1T2Qqbr6s0
         GTo4YXiSJls+2JPj7WKwWkO0wgqA5JJK5ktAz+WZBAXgOfTsiGNPKJy0y89JzfzygL6o
         9u+jXj4f5ogHLB0RoISJ4AZPA/FaQ/hjM0vEPcIfH33hzLCZdFaZ12aTCR4dYKtH+sZ9
         7QX/dy10ZO3QN8SDCk8pLNL06/W87rjWvIS04qpxrJBMEFBJIv0Z8sB0whp8TEhaegqc
         Svaw==
X-Gm-Message-State: AOAM531DIhKmxTF6DCIOmf7qVjmMoW1xPd5TaT18CScxXAQQTsEG8lkR
        j02whzIdRVu/R1CVvBJ4gtOx+w==
X-Google-Smtp-Source: ABdhPJyUw5zYLumjm3TdC1pRl0PTeyUpP9Bo7pOZU2X4bB/weeZSOPpWYMi1SAHAcAgs0Im8Ut3kMA==
X-Received: by 2002:a02:6a0d:: with SMTP id l13mr2779764jac.92.1633609558946;
        Thu, 07 Oct 2021 05:25:58 -0700 (PDT)
Received: from [192.168.1.116] ([66.219.217.159])
        by smtp.gmail.com with ESMTPSA id z187sm13388058iof.49.2021.10.07.05.25.58
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 07 Oct 2021 05:25:58 -0700 (PDT)
Subject: Re: [PATCH v2 RFC liburing 2/5] test/cq-size: Don't use `errno` to
 check liburing's functions
To:     Ammar Faizi <ammar.faizi@students.amikom.ac.id>,
        Pavel Begunkov <asml.silence@gmail.com>,
        io-uring Mailing List <io-uring@vger.kernel.org>
Cc:     Bedirhan KURT <windowz414@gnuweeb.org>,
        Louvian Lyndal <louvianlyndal@gmail.com>
References: <a8a96675-91c2-5566-4ac1-4b60bbafd94e@kernel.dk>
 <20211007063157.1311033-1-ammar.faizi@students.amikom.ac.id>
 <20211007063157.1311033-3-ammar.faizi@students.amikom.ac.id>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <26076f44-aa84-96f7-912c-9990cc789c97@kernel.dk>
Date:   Thu, 7 Oct 2021 06:25:56 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20211007063157.1311033-3-ammar.faizi@students.amikom.ac.id>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 10/7/21 12:31 AM, Ammar Faizi wrote:
> When we build liburing without libc, we can't check `errno` variable
> with respect to liburing's functions. Don't do that it in test.
> 
> Note:
> The tests themselves can still use `errno` to check error from
> functions that come from the libc, but not liburing.

Applied, thanks.

-- 
Jens Axboe

