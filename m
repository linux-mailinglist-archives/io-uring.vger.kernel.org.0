Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C5C0551D263
	for <lists+io-uring@lfdr.de>; Fri,  6 May 2022 09:36:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1389613AbiEFHkd (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 6 May 2022 03:40:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59666 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242343AbiEFHkZ (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 6 May 2022 03:40:25 -0400
Received: from mail-pl1-x635.google.com (mail-pl1-x635.google.com [IPv6:2607:f8b0:4864:20::635])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9713D5DA30;
        Fri,  6 May 2022 00:36:43 -0700 (PDT)
Received: by mail-pl1-x635.google.com with SMTP id s14so6645411plk.8;
        Fri, 06 May 2022 00:36:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:from:to:cc
         :references:in-reply-to:content-transfer-encoding;
        bh=8XPOBsdw+QV6Az/8Hs9ZgR+OImDGXcVVxo2FYZtTPbg=;
        b=P1S0v3DOHG9KQkfS3JlicspQRp9aEUOEn8BVNeKg163DNevoOxh/ryHXFrKaCGpAgz
         gqKQEMcEq6BGoen5kEfR3QYZaZRokXTB6gFe+xMBNMmrBsh+G/xvjyOKAlDnIZQpseTz
         1TB+cu8D2F1qqKMW3pAYgb7TB2TbJ+PbGZ9gIaKqd3lpPlETf9sbKjyomfv/GBhUCKYj
         UA3bjywGrAefwYdU6du0D0RwjZnXCYEhxXuPJvPq1r9XfEbpaVwGaEanazRmsk+1L2Pv
         lv6Gian1gowj4o1h6+nKZGVF2aQ32eyV+sQpUDDH6qi5ZG1x/1sjRYvlN9WVHUDtxbnP
         ghSQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :from:to:cc:references:in-reply-to:content-transfer-encoding;
        bh=8XPOBsdw+QV6Az/8Hs9ZgR+OImDGXcVVxo2FYZtTPbg=;
        b=H4oc9pYTQ0rIItj7WVV8sy/OoR0AdLhhWJlpcCf+c+C4pek9YvKmqMre2K1LIrCF8L
         rnfqkYpXE+ZWEJo1zpujeyRGQQdD7526ORPvcaiBAXIo6UxgewUmT/hf/M6Dx0OD7/aS
         gG8mRtPnzl66iF9jNZ8gJ5duFJnVHP0bhOtfEC4v6ROI8K9fs3Gsu6+D1Bx3L5xAbbdG
         5A4CpGNaxkJ8E0aArLKylexhqLw4I2x/Z2FvCcEtcNrkUoeHxH2wkWFexixgv6I054ci
         opVX2lRws2AJu4pQopjlfIgOkkTgURtS2IQ6oBjU7OQkqBhTtPERw5d8FoQteAgJYFl+
         iYKg==
X-Gm-Message-State: AOAM532wyt5XWnMZI4s2eokSLGPuBAcPvbII7UfEG/lH+tZ212z4HRmE
        8BwxbtdCWfKUr5DaT3kxnuOJghgUE5I=
X-Google-Smtp-Source: ABdhPJzapMuz6f9puPHher7Kzmhy/nGphBj3sdFcklDK0QFq8MPK62npQh8RK6egBYy6eRkQNpq6yQ==
X-Received: by 2002:a17:902:e481:b0:15c:dc24:64e8 with SMTP id i1-20020a170902e48100b0015cdc2464e8mr2323004ple.35.1651822603054;
        Fri, 06 May 2022 00:36:43 -0700 (PDT)
Received: from [192.168.255.10] ([106.53.4.151])
        by smtp.gmail.com with ESMTPSA id x2-20020aa79a42000000b0050dc7628169sm2710321pfj.67.2022.05.06.00.36.40
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 06 May 2022 00:36:42 -0700 (PDT)
Message-ID: <b4d23f42-36f4-353a-1f44-c12178f0a2b3@gmail.com>
Date:   Fri, 6 May 2022 15:36:49 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.8.1
Subject: Re: [PATCH v2 0/5] fast poll multishot mode
From:   Hao Xu <haoxu.linux@gmail.com>
To:     io-uring@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>,
        Pavel Begunkov <asml.silence@gmail.com>,
        linux-kernel@vger.kernel.org
References: <20220506070102.26032-1-haoxu.linux@gmail.com>
In-Reply-To: <20220506070102.26032-1-haoxu.linux@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.6 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Hi All,
I actually had a question about the current poll code, from the code it
seems when we cancel a poll-like request, it will ignore the existing
events and just raise a -ECANCELED cqe though I haven't tested it. Is
this by design or am I missing something?

Regards,
Hao
