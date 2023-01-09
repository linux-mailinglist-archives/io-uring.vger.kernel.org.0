Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7401F663375
	for <lists+io-uring@lfdr.de>; Mon,  9 Jan 2023 22:51:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237474AbjAIVvK (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 9 Jan 2023 16:51:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58154 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235107AbjAIVvI (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 9 Jan 2023 16:51:08 -0500
Received: from mail-io1-xd35.google.com (mail-io1-xd35.google.com [IPv6:2607:f8b0:4864:20::d35])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E0C01DEAB
        for <io-uring@vger.kernel.org>; Mon,  9 Jan 2023 13:51:02 -0800 (PST)
Received: by mail-io1-xd35.google.com with SMTP id h6so5224285iof.9
        for <io-uring@vger.kernel.org>; Mon, 09 Jan 2023 13:51:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=Q/4wk+jR1ilnOhlUaGH75lGZX0qYzLDVs/Vv8i0phPI=;
        b=XA7R14IZwl8Lq3Ehjs19/6HVgJlIRJd0Uzzdcc+RHfqpGZ+fGrSIa0sI/NRJ2/EPrs
         MBruLGbHxCfI2rpJGoxrugC1sKoSJk/vfg2foOrxgK93kq1qKqQqyiyugs+qcZQ3qL78
         iiAFvW2QBzbMQAsHInxwCBmK+y3SjVgNdYq6GVOHejsVy7gD/E8u+3kEl94Boedkn0sD
         qUcQSrMgibFh5NwKNiXTXrkFGrlSYFM2CA2MIKFhSKKdqz7R7BzWF0S/3eGb8UaxO4RN
         kpAdPlfwfLU7xL8A4Gg24HfWZdsGNljSgoqINPeU5HGVzH4tyZ4a8Qwa+vspEB/ivAoU
         Lqng==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Q/4wk+jR1ilnOhlUaGH75lGZX0qYzLDVs/Vv8i0phPI=;
        b=hnldNlu1h1sEsFT7QSdSthZLpqb+b2uXtQcQ00rO9mpqQY3PlDZs4ybVDP6Ogi3bpt
         qK7Dcggj5YWeBlGUXGajruQns4IFKhIafoWJjyzVvHRxkKIq6+zbIrK5rerqqw2KMYow
         icvBA2sRyUB7o1sIpzrDePkSL5HQlPKVtDq/sQsLO9uzS5Nkya5M8vpdvrcIKVHNJVS9
         kEGO/WrHF8PKq2hxa5+1TlWotvMSJ1Yn/Egop/AxXTlk8h6p1HMnaf8RrPmNAe/NlPwy
         OP77xsVz3M10Y8sANHiJhvvlduILJgncTAtMCCvwUP8COmw0AGPuOD0OuI2avIxdqR4r
         G2yQ==
X-Gm-Message-State: AFqh2kph9TjPg0KCGuyCi1bW1nS6CUja7w45dLb1nI5jpZs7a6+CoZs8
        wz38VUHEXI3NJVqtOJ1S5B1x1w==
X-Google-Smtp-Source: AMrXdXtF4iWYhQIDLJ58IMSzgSkAIdAOcp+HJcQYFq2kvI4lXHtSlvWdtFhNR+CFPOUFWHVNp4Q6bA==
X-Received: by 2002:a6b:7d46:0:b0:6ed:1ad7:56bc with SMTP id d6-20020a6b7d46000000b006ed1ad756bcmr9832804ioq.0.1673301062247;
        Mon, 09 Jan 2023 13:51:02 -0800 (PST)
Received: from [192.168.1.94] ([207.135.234.126])
        by smtp.gmail.com with ESMTPSA id d16-20020a6b6810000000b006de73a731dbsm3432345ioc.51.2023.01.09.13.51.01
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 09 Jan 2023 13:51:01 -0800 (PST)
Message-ID: <e3029146-e399-aaaf-6192-2af8f1c1e131@kernel.dk>
Date:   Mon, 9 Jan 2023 14:51:01 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux aarch64; rv:102.0) Gecko/20100101
 Thunderbird/102.6.0
Subject: Re: [syzbot] memory leak in io_submit_sqes (4)
Content-Language: en-US
To:     syzbot <syzbot+6c95df01470a47fc3af4@syzkaller.appspotmail.com>,
        asml.silence@gmail.com, io-uring@vger.kernel.org,
        linux-kernel@vger.kernel.org, syzkaller-bugs@googlegroups.com
References: <0000000000009156db05f1d984c7@google.com>
From:   Jens Axboe <axboe@kernel.dk>
In-Reply-To: <0000000000009156db05f1d984c7@google.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

#syz test: git://git.kernel.dk/linux.git syztest 

-- 
Jens Axboe


