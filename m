Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8587550CCCF
	for <lists+io-uring@lfdr.de>; Sat, 23 Apr 2022 20:06:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235339AbiDWSJG (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sat, 23 Apr 2022 14:09:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36908 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229656AbiDWSJF (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sat, 23 Apr 2022 14:09:05 -0400
Received: from mail-pl1-x62d.google.com (mail-pl1-x62d.google.com [IPv6:2607:f8b0:4864:20::62d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E0B5B31518
        for <io-uring@vger.kernel.org>; Sat, 23 Apr 2022 11:06:07 -0700 (PDT)
Received: by mail-pl1-x62d.google.com with SMTP id s17so17871650plg.9
        for <io-uring@vger.kernel.org>; Sat, 23 Apr 2022 11:06:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=C2fVH0jJFVK9rfNYeozpx/s2EF2LOwOcSAdlBI0tjTY=;
        b=F0JWnf/RRqkdgcpm+0ZW9mMob8pDKExi7RTgd/FZELQjaszLnBUFsOwnK4LzTcUuFf
         uNNK2ZgVyoDr9Z+LQamNpFoTF7BbaQb2MtGQF6xgRjQJyxgIETWa5L/x2YsKl4iC+iA3
         gUxHQy/6TWsCONSK9Ek0HkzVIZ+AXMEuNKtkuEj1bB8Fiy94K3ntZpl4V0WBTgsVh4/R
         RzoyEGzLPd3EWkkc3axfWJ33y86r5+5mXCPo3DdymNBGrZBi2ct/F5nIcUMLoLFyVmMJ
         ntPPRas9ee8dDeHSN/+2/ycyVDvnwhVJDVZDbDiJwvzHyMGCA9nPF5dKHBAichq82pDJ
         WDdw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=C2fVH0jJFVK9rfNYeozpx/s2EF2LOwOcSAdlBI0tjTY=;
        b=Rqu3Y928+Mn48kIOPb13B1goMqQM248f7hEhSycTy1YwB7sPefnSukDGOpV6KwL2UZ
         SSamjI22P7nPjHFMx5dre+ncDtNlIrKt/+LpqfTczg5wKHuTU0C36vXalRIggbNv5SmH
         54+Bw7IiXWqf2A+mUNT86L3iZaA0nPorfdefdSnI/9qOxQrbdstADQJLjczR9kIrvrjO
         ViTbpOerQjolCMUqGqdTd3I+zbDWZnVtFbzLYSgoiDn7zBPsjCcV8lzRMsOvmjyjBAxK
         2fDam/zc9pted+JoQQ4qOZPr8TNdBhPfAZ2797YA6f+pSGPYnScfhNQpKtSEVRYqyRL7
         BzzA==
X-Gm-Message-State: AOAM5332kFZN6gVd0xNVDhX+rHMAHDZUwaFAj3CLtHxscA3+mjSTABYc
        DpjPcmDc7gt2NMFgyJnVViBLjA==
X-Google-Smtp-Source: ABdhPJy9/hmicQtZltcoQTTlzuvfAB57HzdrIsHqibzTRRhE7KSHy54yDMQJVfbkpLGxe/dnRV5/Tw==
X-Received: by 2002:a17:902:d505:b0:15c:e116:768e with SMTP id b5-20020a170902d50500b0015ce116768emr4964344plg.64.1650737166528;
        Sat, 23 Apr 2022 11:06:06 -0700 (PDT)
Received: from [192.168.1.100] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id gm11-20020a17090b100b00b001cde015e02fsm9613182pjb.31.2022.04.23.11.06.05
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 23 Apr 2022 11:06:06 -0700 (PDT)
Message-ID: <ca1767ba-0398-e26e-4e80-fe339e769c01@kernel.dk>
Date:   Sat, 23 Apr 2022 12:06:05 -0600
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux aarch64; rv:91.0) Gecko/20100101
 Thunderbird/91.8.0
Subject: Re: [PATCH] io_uring: cleanup error-handling around io_req_complete
Content-Language: en-US
To:     Kanchan Joshi <joshi.k@samsung.com>, io-uring@vger.kernel.org
Cc:     hch@lst.de
References: <CGME20220422101608epcas5p22e9c82eb1b3beef6bf6e1c2e83b4b19b@epcas5p2.samsung.com>
 <20220422101048.419942-1-joshi.k@samsung.com>
From:   Jens Axboe <axboe@kernel.dk>
In-Reply-To: <20220422101048.419942-1-joshi.k@samsung.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-3.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 4/22/22 4:10 AM, Kanchan Joshi wrote:
> Move common error-handling to io_req_complete, so that various callers
> avoid repeating that. Few callers (io_tee, io_splice) require slightly
> different handling. These are changed to use __io_req_complete instead.

This seems incomplete, missing msgring and openat2 at least? I do like
the change though. Care to respin a v2?

-- 
Jens Axboe

