Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 916BE58E4E8
	for <lists+io-uring@lfdr.de>; Wed, 10 Aug 2022 04:41:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230173AbiHJClJ (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 9 Aug 2022 22:41:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48102 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230193AbiHJClF (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 9 Aug 2022 22:41:05 -0400
Received: from mail-pg1-x530.google.com (mail-pg1-x530.google.com [IPv6:2607:f8b0:4864:20::530])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5E670265B
        for <io-uring@vger.kernel.org>; Tue,  9 Aug 2022 19:41:03 -0700 (PDT)
Received: by mail-pg1-x530.google.com with SMTP id bh13so13118704pgb.4
        for <io-uring@vger.kernel.org>; Tue, 09 Aug 2022 19:41:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc;
        bh=j82v1An9Y3qtBDNPcX53vPR1d/6XIUFLxPcUa40OMz4=;
        b=KW5PA3GqrgkrCPYHhYn+9pArVF9MbYvRykSDm7WBWwHlPFFdaq8yrY+qlo3WK+RsRJ
         4Ci0xGKZacsW9FVQC+8e7GXISqAQgw3Y8hIOxUoCuOghxkgqilBYnrtuo1XJOPf1tJKw
         xl8ZstXN4qeMHR4x4CuMlg+9Lz/XKAKpbUT1VGLYOEdr5KCNVaPvQavr6b5cV1wkE/fR
         5GBJEuE1+i929vuQ9WdQZXZZstubdm+68LI+SlFE6RBKrVkP7C17+SbKKRZ/e7Z/egaE
         915sh+pChzbK7d5+4xPDOM+jdKOuuvrjFhTPrK++AxhRAHiHq0W+EQXNXLuFLWtEeXci
         /VLA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc;
        bh=j82v1An9Y3qtBDNPcX53vPR1d/6XIUFLxPcUa40OMz4=;
        b=cFeg439ovFOlfFEBnUlhFD7uP5SQgFWoqgYl+6jOMb445Y4jbkyaz0aPm7fuAtRIVS
         CEDmKXCB7DEE9Km1u0I28uapiox6wBX6xqJzY6OkMmd3sPL/EH2u0K80Ry+qY/BhN9fN
         SZhQ8TSNXrH72XLWk2hDyyEipfw92Z9Enk5IOBN4QrUz6FF2QXkcy2Z/mw9aF/UqnhrL
         l1TILGMxbPST8l9EJYHoeiqKRMOFfSwEfcoeB7+tjmgYhVwZ5T/7oeZUP463KVaV8N/Q
         yhfsyPmqA783ZO5ZZMvXSQRgn8s2uxF9JlgEZvZ/IqE/5rRO9K6liJV5m77VoN0FGEAW
         fd1g==
X-Gm-Message-State: ACgBeo1OAiNaJdPxIK73818hPuieFsFNA/kOUuaT1fhRVIVyOzQBL0H6
        O3FVJx7ucZfhe6XdayvqyzCwjg==
X-Google-Smtp-Source: AA6agR6piFyoFiMPTw+wZofRf5fNgpJg0YhPFB8AQZp8bauhOBrrhiCxMAr6fzhey6VRE9Sy/BAOeg==
X-Received: by 2002:a63:d750:0:b0:41b:3eec:f9d0 with SMTP id w16-20020a63d750000000b0041b3eecf9d0mr21269662pgi.289.1660099262876;
        Tue, 09 Aug 2022 19:41:02 -0700 (PDT)
Received: from [192.168.1.100] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id fu6-20020a17090ad18600b001f1ea1152aasm298869pjb.57.2022.08.09.19.41.01
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 09 Aug 2022 19:41:02 -0700 (PDT)
Message-ID: <8c5037ee-135d-a338-4e0a-ac4a385ed1dc@kernel.dk>
Date:   Tue, 9 Aug 2022 20:41:01 -0600
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux aarch64; rv:91.0) Gecko/20100101
 Thunderbird/91.10.0
Subject: Re: [syzbot] KASAN: use-after-free Read in __io_remove_buffers
Content-Language: en-US
To:     syzbot <syzbot+6a8a923895a61a5dbf18@syzkaller.appspotmail.com>,
        asml.silence@gmail.com, io-uring@vger.kernel.org,
        linux-kernel@vger.kernel.org, syzkaller-bugs@googlegroups.com
References: <0000000000008909d405e5d970b8@google.com>
From:   Jens Axboe <axboe@kernel.dk>
In-Reply-To: <0000000000008909d405e5d970b8@google.com>
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

#syz fix: io_uring: fix free of unallocated buffer list

-- 
Jens Axboe

