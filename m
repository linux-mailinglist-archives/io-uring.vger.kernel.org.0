Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7011942339E
	for <lists+io-uring@lfdr.de>; Wed,  6 Oct 2021 00:41:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231658AbhJEWnO (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 5 Oct 2021 18:43:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47812 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230113AbhJEWnO (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 5 Oct 2021 18:43:14 -0400
Received: from mail-io1-xd35.google.com (mail-io1-xd35.google.com [IPv6:2607:f8b0:4864:20::d35])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0B130C061749
        for <io-uring@vger.kernel.org>; Tue,  5 Oct 2021 15:41:23 -0700 (PDT)
Received: by mail-io1-xd35.google.com with SMTP id p68so728673iof.6
        for <io-uring@vger.kernel.org>; Tue, 05 Oct 2021 15:41:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=ZlFHrF2/c0UR4X3kqbHWMvJIzoxBUEv/PM+JH3qI4CU=;
        b=BGgqMVOBB57Dt3zHoPSV143TTBLXheOvQSHlfEsrXLbQfyBSso3j/ibC7knnO5ar+5
         8/kT5rWw5FAbqBCzzH/mjL6vRP7/rl8frqOGBmwtEEnirzmooy/z8X+jUHygvba07T2A
         ALqZ07CSdZUtLeUfHfyFaEv8EPwzdZpWrK1RPAOP9iynK3d+onjcFgsO35j2Qq15YWci
         oXh2IZ2El2fd2xVVcERS/8h0xeYQGEplYiG5s1F4S2EWAR2YiHnt/hGe6YXSfEogexxF
         8sRl0K3LrzTQOY6z5UHsIi0PjDmJQE18lXFZD8wOccB6A6DL2dbnIaNwz7hg5b63e0vi
         fKeQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=ZlFHrF2/c0UR4X3kqbHWMvJIzoxBUEv/PM+JH3qI4CU=;
        b=72BMqev0OL9gdBFooDDcEQIlKRorOpeQGlpbIlQQOzZYP9X/MUDk+5VAXSRhecTi5J
         n5EMv1Hi7TFL2cI2JxAv8lt76L3JKG39ztLtrUAyBG72pb7vcwEn7SZfeh/elFVhe1rH
         UlDDeViwM5xOv99bJBhOYEeNr6CHPyihUfFK6YmDsJhZER80t2q+jzCV1G4MZ4T2KLp8
         kQjgaTWJwyl2K0ePTwBppK92PdbpEIgIToJRakc3O7/l2LaqAnzG2pE8THMLnF7oKxhb
         WdNB8gywkwGPVmLbbKumrrvQlqfrn1lSEpp78GIa0t27cvRf9qLW3IKMpw2mkQ7idLgp
         UTVQ==
X-Gm-Message-State: AOAM530Ia4EEA5RWRZhemlHXedikrwlO4tC8p7U6BAThYH7t8EFsw3pi
        YBc2QPQ1uzRaBDYJLBytbucrFw==
X-Google-Smtp-Source: ABdhPJwbWsCvT38aBxYwi7ONg3C9nYWS2/K3XelVcqc1EVN166MsAowXjyCkCjKUDyGlhflw/JH2SQ==
X-Received: by 2002:a5d:9d59:: with SMTP id k25mr3908848iok.70.1633473682387;
        Tue, 05 Oct 2021 15:41:22 -0700 (PDT)
Received: from [192.168.1.116] ([66.219.217.159])
        by smtp.gmail.com with ESMTPSA id v63sm11366083ioe.17.2021.10.05.15.41.21
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 05 Oct 2021 15:41:22 -0700 (PDT)
Subject: Re: [PATCH] Fix typo "timout" -> "timeout"
To:     Ammar Faizi <ammar.faizi@students.amikom.ac.id>,
        Pavel Begunkov <asml.silence@gmail.com>,
        io-uring@vger.kernel.org
Cc:     Olivier Langlois <olivier@trillion01.com>
References: <cceed63f-aae7-d391-dbc3-776fcac93afe@kernel.dk>
 <20211005223010.741474-1-ammar.faizi@students.amikom.ac.id>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <3544387d-1e83-4422-213c-569f4447b3fa@kernel.dk>
Date:   Tue, 5 Oct 2021 16:41:21 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20211005223010.741474-1-ammar.faizi@students.amikom.ac.id>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 10/5/21 4:30 PM, Ammar Faizi wrote:
> Cc: Jens Axboe <axboe@kernel.dk>
> Cc: Olivier Langlois <olivier@trillion01.com>
> Fixes: a060c8e55a6116342a16b5b6ac0c4afed17c1cd7 ("liburing: Add io_uring_submit_and_wait_timeout function in API")
> Signed-off-by: Ammar Faizi <ammar.faizi@students.amikom.ac.id>
> ---
> 
> It seems Olivier got rushed a bit when writing this. How did you
> test this?

Ugh indeed. Olivier, did you test this at all? I missed this when reviewing
it, but I would assume that writing a separate test would have caught it.
Said test should go into liburing as well, fwiw. Can you please submit it?

-- 
Jens Axboe

