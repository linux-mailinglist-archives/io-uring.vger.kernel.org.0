Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 73EB3428234
	for <lists+io-uring@lfdr.de>; Sun, 10 Oct 2021 17:11:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232596AbhJJPNe (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sun, 10 Oct 2021 11:13:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43808 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232527AbhJJPNd (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sun, 10 Oct 2021 11:13:33 -0400
Received: from mail-io1-xd30.google.com (mail-io1-xd30.google.com [IPv6:2607:f8b0:4864:20::d30])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1849DC061570
        for <io-uring@vger.kernel.org>; Sun, 10 Oct 2021 08:11:35 -0700 (PDT)
Received: by mail-io1-xd30.google.com with SMTP id r134so5616954iod.11
        for <io-uring@vger.kernel.org>; Sun, 10 Oct 2021 08:11:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=NiN/vtCH/1wTdlvK8+2qBaytBTGSKTn4RvMKejPPr5s=;
        b=qN98hInKKkJTTpYhOyAGPYOiRjaXZ8giGUc8dlguYM9bktWy4eFb2pHfY7jMqMlPv4
         0d+l566QVss5NFt2H3lyXA4JLm6LjNFWbwXaoAOv9x/y8L8J6L/cTwTEvQ0UF0IXp9O1
         IYjOyVxyQ2wwVfTYapiDwqbV9jWSGsbL9lVeei/bVoVS0//4CYc7iXYLFf3SBLqwzBAt
         H2+FCiNjd/C6e2BnGfio7nrfFmS1/2aLqnT8o28rCw73CkQQpdk9MJcunkFAQxYJG1qL
         P9wgYlBucktqzNlu7f9SNvHz325VYv+cYSjOwegS9ORnyQVb1jAAM6T4ovxd/U7ovt/V
         CJJQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=NiN/vtCH/1wTdlvK8+2qBaytBTGSKTn4RvMKejPPr5s=;
        b=OyF3a3iHpQ3FhP5YM+viMHWOZc/KsVcdtQvfkKhI67kLevTlEpM9FXaT8DdCnDodIO
         jfHrD89LpCqvYoFucgxPSgox9m2WIxO+pWdPEI1Q5NPaGgLwIMU/LG6Yjh9ETaaJI6si
         dROtVfXURNRcLQOn0+29rbM7nkw8sKj4hJ1C7cxaJlG5rpf7w9V+K3PI4HqeK9Ll4MNi
         m7H9G8xgJnccAtVgVphxecK9bbN/TdZSyebSDslcFLLXloI1a8HvP1ThKuGXTOZwG9DR
         KTwhO3U93bvoKoMnfxjzeNTFo4UjEsB6tLqfcyBvXlUxouPfpAhf3URHjYG8KtxpU/EI
         zwlQ==
X-Gm-Message-State: AOAM533w9vFhI4lv5LRYSyFzLwrN4OxhwcKFbJAjnuLte3kGn/QikQZZ
        MY5ro9iZ/nNXn9HW9HLBNxMfog==
X-Google-Smtp-Source: ABdhPJwEEWXjwnLelsFfGxXp7cm1ORPW8xaPvC6pIx2jEBtjmGgcw9Fl/Obys7MdCBqGj9akaCbpUg==
X-Received: by 2002:a05:6602:1650:: with SMTP id y16mr15676043iow.114.1633878694353;
        Sun, 10 Oct 2021 08:11:34 -0700 (PDT)
Received: from [192.168.1.116] ([66.219.217.159])
        by smtp.gmail.com with ESMTPSA id s5sm2761309ilq.59.2021.10.10.08.11.33
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 10 Oct 2021 08:11:33 -0700 (PDT)
Subject: Re: [PATCHSET v3 liburing 0/3] Add nolibc support for x86-64 arch
To:     Ammar Faizi <ammar.faizi@students.amikom.ac.id>,
        Pavel Begunkov <asml.silence@gmail.com>,
        io-uring Mailing List <io-uring@vger.kernel.org>
Cc:     Bedirhan KURT <windowz414@gnuweeb.org>,
        Louvian Lyndal <louvianlyndal@gmail.com>
References: <20211010135338.397115-1-ammar.faizi@students.amikom.ac.id>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <8b6475f8-e028-98a6-0c73-137a30b4b78e@kernel.dk>
Date:   Sun, 10 Oct 2021 09:11:31 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20211010135338.397115-1-ammar.faizi@students.amikom.ac.id>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 10/10/21 7:53 AM, Ammar Faizi wrote:
> Hi,
> 
> This is the patchset v3 to add support liburing nolibc x86-64. If you
> think there is more to be fixed, please let me know, I will be happy
> to address it.
> 
> In this patchset, I introduce nolibc support for x86-64 arch.
> Hopefully, one day we can get support for other architectures as well.
> 
> Motivation:
> Currently liburing depends on libc. We want to make liburing can be
> built without libc.
> 
> This idea firstly posted as an issue on the liburing GitHub
> repository here: https://github.com/axboe/liburing/issues/443

Applied, thanks.

-- 
Jens Axboe

