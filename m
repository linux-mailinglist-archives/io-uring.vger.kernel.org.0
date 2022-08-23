Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A04E559EA3E
	for <lists+io-uring@lfdr.de>; Tue, 23 Aug 2022 19:51:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229744AbiHWRsv (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 23 Aug 2022 13:48:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46262 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231394AbiHWRs1 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 23 Aug 2022 13:48:27 -0400
Received: from mail-il1-x12a.google.com (mail-il1-x12a.google.com [IPv6:2607:f8b0:4864:20::12a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 21BAE89CF0
        for <io-uring@vger.kernel.org>; Tue, 23 Aug 2022 08:47:45 -0700 (PDT)
Received: by mail-il1-x12a.google.com with SMTP id h8so3421111ili.11
        for <io-uring@vger.kernel.org>; Tue, 23 Aug 2022 08:47:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc;
        bh=XyrkWsezGKAKmd8mQ8F6Ffev2XPrkb/bHu+uol6KuJk=;
        b=B9FZM3IAJcpBbXibpEYrU3fMC/agwhlKJssD8OYhofxJ4+SV9sxDYiNk7/ot8HbjWW
         ar5x7clhrttLpP9iZnv5IWTyICWlLMzm0Gtlre1qWI2K4Ix/KJ7NnkkXpM4RkOyv04xj
         mIKZCBXV0sAstfGKdJ6rH/Hw3WDocAdub36JUaroJ7vU59WVqPREVmylh2Sn3N9PnwHw
         Gar59GKbE4NuhREDsvkGjDKhSfFFhZPnuIOyh7D/17S+JnrOxnVA+9dcK5BZCbjg7Pho
         BJ9v8kdHQ3OL+ylE0QbMxvsGsxPjyu+fgQe6Xd1wNMwgeXlm04bCRODab7akziPBCOdO
         fTSw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc;
        bh=XyrkWsezGKAKmd8mQ8F6Ffev2XPrkb/bHu+uol6KuJk=;
        b=s4E/Iqu+PqjlKZO7iwr5LDt2XsyC6IiP2aZAGzVaTtabBvjAXmWJI/9X02q8P70ErG
         xB6Gr0uBjBJ+VGa+lCPWwILiRWIZ1jpxx4l8xkll70sAVpNcYzwiMJRdPIMFEfRPb/7i
         MeOjQNhu0UaZzmNdTHAJVsDWiMEepraS8yRTtProx26/9SATA339K3crdhVxcMUsKzIX
         olhGb+6GFVtGGnp5sfKS7bRCNv+SeBV3K4I0/hSBVC1We+CIp/CXWrk8yX+tY6z2fERO
         qjIAbQFTxkqP18CY487RQW1H9QVula6j94q26u6y2csDij+0JhJHSMZ6Etd2joRNNAmp
         SsEg==
X-Gm-Message-State: ACgBeo3EItmjkQ3X4S/WIAfx8Pla2rY1xoZSo7rLh7v/hLHTQIHR+Ceu
        x2f7YQzUnH4e2XGk9l1ArRobpQ==
X-Google-Smtp-Source: AA6agR7zmJsPm5gt/VL5Rsyhsv6EwB22FNwuY/UShvHYx0NOOYfQYQFCKzhqG8c61wPcGcOH3hfPjQ==
X-Received: by 2002:a92:c269:0:b0:2e9:d24e:4ee5 with SMTP id h9-20020a92c269000000b002e9d24e4ee5mr103365ild.191.1661269664441;
        Tue, 23 Aug 2022 08:47:44 -0700 (PDT)
Received: from [192.168.1.94] ([207.135.234.126])
        by smtp.gmail.com with ESMTPSA id y4-20020a02bb04000000b00349df2f4a46sm2090391jan.40.2022.08.23.08.47.40
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 23 Aug 2022 08:47:41 -0700 (PDT)
Message-ID: <ceaf9d3f-7588-a64c-0661-79133222f443@kernel.dk>
Date:   Tue, 23 Aug 2022 09:47:39 -0600
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux aarch64; rv:102.0) Gecko/20100101
 Thunderbird/102.1.2
Subject: Re: [PATCH] io_uring: fix submission-failure handling for uring-cmd
Content-Language: en-US
To:     Kanchan Joshi <joshi.k@samsung.com>, asml.silence@gmail.com,
        io-uring@vger.kernel.org, anuj20.g@samsung.com
References: <CGME20220823152018epcas5p3141ae99b73ba495f1501723d7834ee32@epcas5p3.samsung.com>
 <20220823151022.3136-1-joshi.k@samsung.com>
From:   Jens Axboe <axboe@kernel.dk>
In-Reply-To: <20220823151022.3136-1-joshi.k@samsung.com>
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

On 8/23/22 9:10 AM, Kanchan Joshi wrote:
> If ->uring_cmd returned an error value different from -EAGAIN or
> -EIOCBQUEUED, it gets overridden with IOU_OK. This invites trouble
> as caller (io_uring core code) handles IOU_OK differently than other
> error codes.
> Fix this by returning the actual error code.

Not sure if this is strictly needed, as the cqe error is set just
fine. But I guess some places also check return value of the issue
path.

Applied.

-- 
Jens Axboe


