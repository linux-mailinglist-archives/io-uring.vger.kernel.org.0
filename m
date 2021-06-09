Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5250E3A18E1
	for <lists+io-uring@lfdr.de>; Wed,  9 Jun 2021 17:13:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232586AbhFIPPo (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 9 Jun 2021 11:15:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48706 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229770AbhFIPPl (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 9 Jun 2021 11:15:41 -0400
Received: from mail-pf1-x42a.google.com (mail-pf1-x42a.google.com [IPv6:2607:f8b0:4864:20::42a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5279EC061574
        for <io-uring@vger.kernel.org>; Wed,  9 Jun 2021 08:13:31 -0700 (PDT)
Received: by mail-pf1-x42a.google.com with SMTP id u18so18593247pfk.11
        for <io-uring@vger.kernel.org>; Wed, 09 Jun 2021 08:13:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:references:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=7ZxTPS2sfY6BT5D3Akub8+p7MCkN8JLtunUT7vQaOjk=;
        b=o+ebj25NROsFINwzIeGuS8MRAi29OxqyMiXQVgJdG9X3H2o9D6g3ddbe8R9K/lzkzO
         ZtaaRLTWTKWhpn2pUk8hKbFNy28jhUvT5olANc+lgmQ5vskp8lM/H4PMzj62yKge7tUS
         8v63/hd322httfJ12vzRBJxgsw+NHit1ZKT28sqR8B8JrR2Dzbx+SneS5qBvVN/TUJLJ
         jH72Kv4JQwdIN7P1d3JsfSfkkWujCS1qLrhj5LfFUztEeg6pvoxy/i+6oBLe7btMo3Um
         tPENxPwxIze4SFfsbZBBYC1dfLaVQrG/stGrfjG9R1h9g6MtMdfu0VpMneiHYcWzxN2c
         jDDQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=7ZxTPS2sfY6BT5D3Akub8+p7MCkN8JLtunUT7vQaOjk=;
        b=YYnpdCX7+quhHt5+odB6sxwHLllmX2j1rpCsqJI67xg3+zLnqICFbBLLWtOrCXEEjJ
         K45+g8JDQYih6lPj+wWbdYx96xB1Lkn/A0RREUh4qVk75AGQSJ/jG6W9C8RhH0STb6nn
         PwkZJd2n+CXb72F3S9Pk/m+N0Zc5F5xK/Ne/BOH486Uztp55s9o/uHqGGWlnndne9ttx
         +8fKxgaxYbiflhbXwgN1tJfpl5o0t38kYbUveJw+uBQuX7Ox3QXpVQLJipk6oGEwbffZ
         UdipYU+7sKmlXywqQUtpHCXlk8lMvQSvN/40t4n6WNwaDnp1o2+REFj4NsZGB4jRk8uB
         tmiw==
X-Gm-Message-State: AOAM5301bRdsGhRBRGDWh7J+aWyFziWf00xSakWWGDAWlcKW3dUM7AUn
        4JwUFYwXHDsyvgux39p3YhNYEm4+h9odpA==
X-Google-Smtp-Source: ABdhPJzrhompLUfXFBpeufItAtVoD0E0SPgAU3101wkEP0xMq19iKiwGRyPsavJ7Z7TzIGqvORMsuw==
X-Received: by 2002:a62:7582:0:b029:2ea:132:6d99 with SMTP id q124-20020a6275820000b02902ea01326d99mr288825pfc.53.1623251610644;
        Wed, 09 Jun 2021 08:13:30 -0700 (PDT)
Received: from [192.168.4.41] (cpe-72-132-29-68.dc.res.rr.com. [72.132.29.68])
        by smtp.gmail.com with ESMTPSA id ev11sm5374131pjb.36.2021.06.09.08.13.29
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 09 Jun 2021 08:13:30 -0700 (PDT)
Subject: Re: [PATCH liburing 1/1] tests: update reg-buf limits testing
To:     Pavel Begunkov <asml.silence@gmail.com>, io-uring@vger.kernel.org
References: <947234e13ba32fdc9b8ce45f679d78b9d08cb46a.1623239194.git.asml.silence@gmail.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <91fe6e62-4dcf-c047-aead-53731deecd45@kernel.dk>
Date:   Wed, 9 Jun 2021 09:13:29 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <947234e13ba32fdc9b8ce45f679d78b9d08cb46a.1623239194.git.asml.silence@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 6/9/21 5:46 AM, Pavel Begunkov wrote:
> We now allow more fixed buffers to be registered, update tests from the
> previous UIO_MAXIOV limit to something that will definitely fail.

Applied, thanks.

-- 
Jens Axboe

