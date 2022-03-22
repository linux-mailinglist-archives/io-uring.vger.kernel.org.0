Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7D6E34E47ED
	for <lists+io-uring@lfdr.de>; Tue, 22 Mar 2022 21:58:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235107AbiCVU7g (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 22 Mar 2022 16:59:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33280 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234812AbiCVU7d (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 22 Mar 2022 16:59:33 -0400
Received: from mail-il1-x132.google.com (mail-il1-x132.google.com [IPv6:2607:f8b0:4864:20::132])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 920CB62DB
        for <io-uring@vger.kernel.org>; Tue, 22 Mar 2022 13:58:02 -0700 (PDT)
Received: by mail-il1-x132.google.com with SMTP id r11so13280700ila.1
        for <io-uring@vger.kernel.org>; Tue, 22 Mar 2022 13:58:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :references:from:in-reply-to:content-transfer-encoding;
        bh=3fa+Yc6J9FxvaVrYGbZmAuXR7+SlkzyafMy9YlzUS1Y=;
        b=xzCRh0mzebV0NEbXdETJkgSxAjpFmUqIBWTgTh3BxUKaEYubmStk+H/cgCIN9Jsa1q
         kW/Xf9szJrxn2780580bikRVFWJfwlb1ATAZLECyKgnLTTI7iIf1TqjTC5/4bgB6S79G
         CphxK1WNPG0eWvMV2xw8xLXUxMY4fu+bW15NPT9m0N0w1ZhNzIZZHI35mAi4p156E9gV
         PKz4bIZ3FVVQ3aLeAyQfbjPJnHXB9TJ3ug7/U0ZhsmDIb4+8dMPjsfu9wGQfNsAFs9ax
         oYyisDmI5tBYh8xo6IgywOGxsc9CV2H8BiqzB6M/I6WfwQS8p+8gFgeFj8eWpAcIb65C
         AS0g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:references:from:in-reply-to
         :content-transfer-encoding;
        bh=3fa+Yc6J9FxvaVrYGbZmAuXR7+SlkzyafMy9YlzUS1Y=;
        b=V/BvxUgZg9fNf1/4bCxW5KR/0C6eF2JSSG2SNf/a1sU6abqiFRRXxt2AOHKAFR/PTv
         6Ui6/M5nHGdy3KFMccvKyMI/Bnnz4FUEwMtyVgfRJz9hHUmZCOfqUoxfCWl9cWgwuGIO
         mRbmzRxJw4C5NBJk4ry7WAvaUR48LhorVVQ8PVWI5IMcwecvn9417KnU8zYIKSRawcQu
         +RW2ZChKbfN2nTTIX2DywIFhiMEEs9yRw4lzfWIORZMeuwfjdjODBJdZD3xbzO/VPTqH
         Dde3oztVqc6l2nGOrB2+/ujxKZvy68tZLZn/Ml5XQ9wUG8Ib6L5JWUMxMFhXsS08M0zC
         xIpw==
X-Gm-Message-State: AOAM533mwMN+2Cdr22CvrJjrLju/mThQkwP/Qg2AzDzrnzp6oO6V6qqv
        XAj7VpUr0lXUmd/Ta6LRC3ejyA==
X-Google-Smtp-Source: ABdhPJzGGVYNkM9jRB4tYvUPREszbLNgJgr5gOIuewZQxhfFL2bL6v0GCiGwZ7tnVqWQ38VRoOHEXA==
X-Received: by 2002:a92:c242:0:b0:2c6:7a1e:1cb2 with SMTP id k2-20020a92c242000000b002c67a1e1cb2mr14069387ilo.315.1647982681889;
        Tue, 22 Mar 2022 13:58:01 -0700 (PDT)
Received: from [192.168.1.172] ([207.135.234.126])
        by smtp.gmail.com with ESMTPSA id w13-20020a92d2cd000000b002c8533c4b27sm519308ilg.78.2022.03.22.13.58.01
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 22 Mar 2022 13:58:01 -0700 (PDT)
Message-ID: <5cd8d8f7-b172-12a1-5c4f-f9933b576208@kernel.dk>
Date:   Tue, 22 Mar 2022 14:58:00 -0600
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux aarch64; rv:91.0) Gecko/20100101
 Thunderbird/91.7.0
Subject: Re: [syzbot] KASAN: use-after-free Read in add_wait_queue
Content-Language: en-US
To:     syzbot <syzbot+950cee6d91e62329be2c@syzkaller.appspotmail.com>,
        asml.silence@gmail.com, io-uring@vger.kernel.org,
        linux-kernel@vger.kernel.org, syzkaller-bugs@googlegroups.com
References: <000000000000acacb205dad4d42c@google.com>
From:   Jens Axboe <axboe@kernel.dk>
In-Reply-To: <000000000000acacb205dad4d42c@google.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

#syz test: git://git.kernel.dk/linux-block for-5.18/io_uring

-- 
Jens Axboe

