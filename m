Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1772C54B4B1
	for <lists+io-uring@lfdr.de>; Tue, 14 Jun 2022 17:31:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234677AbiFNPaj (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 14 Jun 2022 11:30:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36436 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235039AbiFNPai (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 14 Jun 2022 11:30:38 -0400
Received: from mail-pl1-x632.google.com (mail-pl1-x632.google.com [IPv6:2607:f8b0:4864:20::632])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E8A133584E
        for <io-uring@vger.kernel.org>; Tue, 14 Jun 2022 08:30:37 -0700 (PDT)
Received: by mail-pl1-x632.google.com with SMTP id d5so5432598plo.12
        for <io-uring@vger.kernel.org>; Tue, 14 Jun 2022 08:30:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :references:from:in-reply-to:content-transfer-encoding;
        bh=v5IrOh3kjaDL9ZxIB0Zqv+YEeRMiciYnY4TxZc0Kavc=;
        b=GrPFQr4crfYdYCJWlWhlpW+uMBt7uGLBA47kSftXVqxcIjcxiETHa8rasbIsj1FHkd
         YYwmysGef1cSx4eL0vcbVqt4AvpKB2WMZ0O+wKElhT85a9Sdzhz/D/LOgfV3pnVuW24E
         GNffO9g0TzE+5WoFhYtqcNikkUYd1SYceicxaDcAg6w9hzVJqJ7T4l9mASSgN1fw0tIF
         418HGHdZJd6+RTTMn75EAi5XT1zBEHVp9gXipvsEKHHKB3nwKhVw50GdvAs/FIWI7BC9
         UCMPWCGJj2hsxMfS1gDwi7cdYm+ikqmVJv55TBZJUOw/9ozE1URzpXCUd7ZOKLyXiO/i
         vgZw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:references:from:in-reply-to
         :content-transfer-encoding;
        bh=v5IrOh3kjaDL9ZxIB0Zqv+YEeRMiciYnY4TxZc0Kavc=;
        b=fcWUgZTFEia9A0Q9kNA34QNvJEBXTXTPGfjnhHuaVHqu2NzQxq05vPXSDoCpeEQqvg
         0bq24zJN7+FZRhWItqcJVtEnKL+NvXNZt44ZYWfqhkKyDymiC3W48o/j+/4um7Y+qYvj
         Ic8NdzyZs4hpu+zjfOg9/9Jr+2L8rE59pi++zYBRSo5t8y3xCtt++WvX5PeLCllf5/iJ
         Y2WX0bQkRflRPgHflJ+5Tg6VJiO79UDpjbnJDMuJDwSlRvZ/QSaMyM+zH46mE4rGRpS6
         E27L1pK0dKDmWcFCcbEh1d2ZdHCueJyDTQld3C5FvcdZe/zzRlW7aa72TAUcQFr5BwG4
         mGNw==
X-Gm-Message-State: AJIora80OE+JOBxQSsFcgAIwvO2uHwEZbKT+H2ec1D88hyiZ684b14KD
        zE0awuPUYgjP2ErlmknukwN/ww==
X-Google-Smtp-Source: AGRyM1vWbdvZCcIebrHYji7jCM+63YcgblUcm/aDiNR995/5ZwvzbqxCpW9uDGODNM9dkQAABHGdRg==
X-Received: by 2002:a17:90b:3a87:b0:1e8:8079:b7e6 with SMTP id om7-20020a17090b3a8700b001e88079b7e6mr5211305pjb.139.1655220637267;
        Tue, 14 Jun 2022 08:30:37 -0700 (PDT)
Received: from [192.168.1.100] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id d15-20020aa797af000000b0051b930b7bbesm7761890pfq.135.2022.06.14.08.30.36
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 14 Jun 2022 08:30:36 -0700 (PDT)
Message-ID: <9b2daabd-3412-7cd8-79d8-8a9dfe4b27d2@kernel.dk>
Date:   Tue, 14 Jun 2022 09:30:35 -0600
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux aarch64; rv:91.0) Gecko/20100101
 Thunderbird/91.10.0
Subject: Re: [PATCH liburing v2 0/3] single-issuer and poll benchmark
Content-Language: en-US
To:     Pavel Begunkov <asml.silence@gmail.com>, io-uring@vger.kernel.org
References: <cover.1655219150.git.asml.silence@gmail.com>
From:   Jens Axboe <axboe@kernel.dk>
In-Reply-To: <cover.1655219150.git.asml.silence@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-3.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 6/14/22 9:27 AM, Pavel Begunkov wrote:
> Add some tests to check the kernel enforcing single-issuer right, and
> add a simple poll benchmark, might be useful if we do poll changes.

Should we add a benchmark/ or something directory rather than use
examples/ ?

I know Dylan was looking at that at one point. I don't feel too
strongly, as long as it doesn't go into test/.

-- 
Jens Axboe

