Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3ADF75EA9E0
	for <lists+io-uring@lfdr.de>; Mon, 26 Sep 2022 17:13:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235799AbiIZPMs (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 26 Sep 2022 11:12:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56882 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235861AbiIZPMR (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 26 Sep 2022 11:12:17 -0400
Received: from mail-wr1-x435.google.com (mail-wr1-x435.google.com [IPv6:2a00:1450:4864:20::435])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 530CD66110;
        Mon, 26 Sep 2022 06:51:03 -0700 (PDT)
Received: by mail-wr1-x435.google.com with SMTP id cc5so10338234wrb.6;
        Mon, 26 Sep 2022 06:51:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date;
        bh=2cRdMsGPAB+qaapM85CUGvse7MWNDqaXFtk6mDGsNwk=;
        b=RUNnDTt0sLmJ6pb7/xz5KzCM2L/F6rGIiJpTlZxBaJryX2CKLtE8+q4TXmf962YkWp
         +JbEdWl8lrI0FpxyWucwKWNpT4fA+JKrUjHzx7cyC1KKQInCXwFZAuJC57tUuGqPR5Yl
         EViqroNDb4+iUaBH5etIfmI0q0tsMYhzlkNTUOvJzaGGjktImniuT7DZYXbGKaBQX4u8
         Nk8fWrCNXO9aRrAbrtzxABvVufd5z9KZ0GIu7no4N8l2yurRtgt6uJ9cOYPEOD018+zs
         V0PZonD8ARBe1hEgYZG+vK9aA5lWeGogW5ZHnQWtr5B8romLtJIvaoSpXZtAorve5GoP
         iwnw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date;
        bh=2cRdMsGPAB+qaapM85CUGvse7MWNDqaXFtk6mDGsNwk=;
        b=r9rwCLYuBNrDnniU/bh0qXMoGPbGnUXpdzPXEozpgsb8PH4nPtDl1Br39JObNOW/HB
         JlfrxSsf8L/wehITlii9N4FcEwstDltgZ1gyiPJkYOXkuMmPgrCRcLvWZiYxR3JXWZnz
         5/AS5Dq8djh/jpYrMIZcwv+eIuDbNb2PxRUojzTjL0lCi6No7gIiC+SS6nCTdyFnFSYA
         0WucJD6b1TKbbQFm7ahKbAGjXhUew4eLa9BQTSLUjocukNt5wLmKmF2z9R+kHUZPB8PS
         xMcF44L3lCRdEvXbCVzxCCP16BtxyPhPI0PIYsYhjlg6ggi+pyVoSEaR8Fr5IoH0jW6S
         ywfw==
X-Gm-Message-State: ACrzQf3bIiZBZXs6rOQf1DuEvLAhcpLXqfFNo5tTFuSJ+cfjZKaTBElu
        OTCK5wbbNbi0OYlAKXQYBzDXT9JCbEg=
X-Google-Smtp-Source: AMsMyM7NuNmw6IHUUelKQei8N5V/FL7N1DQ6rcS+BjLDl355r43vBfRvTKHCGWb9uFbUpc1ODIiZkg==
X-Received: by 2002:a5d:4e88:0:b0:228:c8ed:2af8 with SMTP id e8-20020a5d4e88000000b00228c8ed2af8mr13927076wru.412.1664200262293;
        Mon, 26 Sep 2022 06:51:02 -0700 (PDT)
Received: from [192.168.8.100] (188.28.209.34.threembb.co.uk. [188.28.209.34])
        by smtp.gmail.com with ESMTPSA id n39-20020a05600c3ba700b003a540fef440sm12042359wms.1.2022.09.26.06.51.01
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 26 Sep 2022 06:51:01 -0700 (PDT)
Message-ID: <ee12470f-4fca-a036-1195-d68a3ca1f3f9@gmail.com>
Date:   Mon, 26 Sep 2022 14:49:54 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.12.0
Subject: Re: [syzbot] KASAN: invalid-free in io_clean_op
Content-Language: en-US
To:     syzbot <syzbot+edfd15cd4246a3fc615a@syzkaller.appspotmail.com>,
        axboe@kernel.dk, io-uring@vger.kernel.org,
        linux-kernel@vger.kernel.org, syzkaller-bugs@googlegroups.com
References: <000000000000082de205e98465e4@google.com>
From:   Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <000000000000082de205e98465e4@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 9/25/22 19:15, syzbot wrote:
> Hello,
> 
> syzbot has tested the proposed patch but the reproducer is still triggering an issue:
> KASAN: invalid-free in io_clean_op

#syz test: https://github.com/isilence/linux.git io_uring/net-free-iov-bug

-- 
Pavel Begunkov
