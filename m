Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 991CF56039A
	for <lists+io-uring@lfdr.de>; Wed, 29 Jun 2022 16:50:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233467AbiF2OtO (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 29 Jun 2022 10:49:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55810 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233679AbiF2OtN (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 29 Jun 2022 10:49:13 -0400
Received: from mail-pg1-x531.google.com (mail-pg1-x531.google.com [IPv6:2607:f8b0:4864:20::531])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0883F1CFFC
        for <io-uring@vger.kernel.org>; Wed, 29 Jun 2022 07:49:12 -0700 (PDT)
Received: by mail-pg1-x531.google.com with SMTP id q140so15538591pgq.6
        for <io-uring@vger.kernel.org>; Wed, 29 Jun 2022 07:49:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=V6ALSktArJeWLZ9Uwj0gLwIghi058dq5hVzYEwG4P/U=;
        b=5DJZ+ebFHmcdevPYm7DflTsxdyuEC6x+tTqRw7Zl8hm/XFbp3wuH1DoQijNNBRsRRJ
         vQdgJKWfzlGs4q5XihxOAQHmMMvKjegGHX8AH+v9jQ3eTanWnzozWYOCB1JKUz2JboJ2
         cqSsMENcjbZOzv5Dk4CbU0OLqeY5UFGZ/O7Xx8vm0YoNTbqFsBSqBLDe8TpYTWVSv8TW
         K+w6BA8WiED1fT0si12MU/+3dEZfRp05GflOv0SFXLVOVR8OVk2GeneoxLDWiQSjQw2k
         XL9eyu0qG6JzSUPAFtQG3VZ0QypFvgurNDO5AHKeH4DJuHmq7PsNZEvCmuJLF0oPRi/I
         wGUA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=V6ALSktArJeWLZ9Uwj0gLwIghi058dq5hVzYEwG4P/U=;
        b=BxjxeVw5Qm5qeuctMPRuHdVni1VwNzxfOcOn4FPu9g7GJDJfbv/6vQ/K5LQAz/WgsB
         k9tSVrhvvUodqx4mXfRBw1s/TzqMc1uPRYuHjCR/q5eSIjDY/U+yHPNb8RUvbVhoiaRr
         FuYnnA2DQcm6VKfA8Qj5W1dXPUKBhqmAEMNAffERk09Pko9zuaDhksbK/N6aSQusS1I/
         ua5flV1LA3zC04jq7Var0EAbW+TgfdvPEDM3zu+R7gdb2OgKqDhbNbKSs1ec8Z6girtu
         fH6u6eydY+NGAzqlz2a6y15cy2ZrYCQUv4rWPJi1QjmryFjlYcmyVGMQJkX4AkD4NJi4
         dXow==
X-Gm-Message-State: AJIora+yV5EriSH8CSABri+8iCWNW7gTQ7D0LCQicO1qbjMVWHTF8Id8
        ES3N03f49GcldHjn49Sfq2Yb88GrzYxE9g==
X-Google-Smtp-Source: AGRyM1tDiOdgVmQ2EEhTGYovau8QmlaEs9blCQz4nuPjIJmrpVWobUT4viSiqasOB2g2p1zbVraxNw==
X-Received: by 2002:a05:6a00:2495:b0:525:a822:d732 with SMTP id c21-20020a056a00249500b00525a822d732mr10544383pfv.46.1656514151458;
        Wed, 29 Jun 2022 07:49:11 -0700 (PDT)
Received: from [192.168.1.100] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id j17-20020a056a00175100b00525119428f8sm11590342pfc.209.2022.06.29.07.49.10
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 29 Jun 2022 07:49:11 -0700 (PDT)
Message-ID: <8bfba71c-55d7-fb49-6593-4d0f9d9c3611@kernel.dk>
Date:   Wed, 29 Jun 2022 08:49:09 -0600
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux aarch64; rv:91.0) Gecko/20100101
 Thunderbird/91.10.0
Subject: Re: [PATCH liburing v1 7/9] arch/arm64: Add `get_page_size()`
 function
Content-Language: en-US
To:     Ammar Faizi <ammarfaizi2@gnuweeb.org>
Cc:     Alviro Iskandar Setiawan <alviro.iskandar@gnuweeb.org>,
        Fernanda Ma'rouf <fernandafmr12@gnuweeb.org>,
        Pavel Begunkov <asml.silence@gmail.com>,
        Hao Xu <howeyxu@tencent.com>,
        io-uring Mailing List <io-uring@vger.kernel.org>,
        GNU/Weeb Mailing List <gwml@gnuweeb.org>
References: <20220629002028.1232579-1-ammar.faizi@intel.com>
 <20220629002028.1232579-8-ammar.faizi@intel.com>
From:   Jens Axboe <axboe@kernel.dk>
In-Reply-To: <20220629002028.1232579-8-ammar.faizi@intel.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 6/28/22 6:27 PM, Ammar Faizi wrote:
> From: Ammar Faizi <ammarfaizi2@gnuweeb.org>
> 
> This is a preparation patch to add aarch64 nolibc support.
> 
> aarch64 supports three values of page size: 4K, 16K, and 64K which are
> selected at kernel compilation time. Therefore, we can't hard code the
> page size for this arch. Utilize open(), read() and close() syscall to
> find the page size from /proc/self/auxv. For more details about the
> auxv data structure, check the link below.

We should probably cache this value if already read? At least I don't
think we have systems where the page size would differ between
applications.

-- 
Jens Axboe

