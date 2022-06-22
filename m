Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7A4485540F4
	for <lists+io-uring@lfdr.de>; Wed, 22 Jun 2022 05:36:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243534AbiFVDg2 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 21 Jun 2022 23:36:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52196 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232276AbiFVDg1 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 21 Jun 2022 23:36:27 -0400
Received: from mail-pl1-x62f.google.com (mail-pl1-x62f.google.com [IPv6:2607:f8b0:4864:20::62f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 52A5028985
        for <io-uring@vger.kernel.org>; Tue, 21 Jun 2022 20:36:26 -0700 (PDT)
Received: by mail-pl1-x62f.google.com with SMTP id l6so6076781plg.11
        for <io-uring@vger.kernel.org>; Tue, 21 Jun 2022 20:36:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :references:from:in-reply-to:content-transfer-encoding;
        bh=Gw/pWs/pSXokXmtxlmDuvywxLcNtKYgYEvrvonVrDi8=;
        b=aEBEAcF7xvraUxywRbe8B+UCxhVNt0TzIpzz8D//sjdOrrcA16z4dwmBuMRwPboO0b
         sLWUkaILFApP33XQ9J4DnXbnlp2wO15fznF7X4O5asV4zzsMWqUxKa4ZD1kFq9ilbPle
         ntBH1urrBjNe2fwVFnJX1DVieR1MoqmEa8w6INEtgzQomzVcUWP6ruO2sJCFOF1gCLX9
         DvqGRQC8/4NgpWxmzEKTfkGBPU5WWFgAoyU35J/iLDrMUbt97CDX6AQYaCa1e9vBf9C0
         ghwzctuczNk3uq4pczt9qH2484CumqYx3o7DznZnlUQxnWwEZjjIHfck0DDUJ65mWA95
         8nSQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:references:from:in-reply-to
         :content-transfer-encoding;
        bh=Gw/pWs/pSXokXmtxlmDuvywxLcNtKYgYEvrvonVrDi8=;
        b=V+/bX0JVx48Zi+c/hfj3fwiSnRSJVua3jd0YR0WzEPJ/9TQvOfGKl5qRRR4dhnxlrw
         hvBJ2jixHubpxUHAfW+o69XHTLlH1+bewv4NqX91nEVbYCKH1QzwLIY/y7rMaczphfaX
         nxKwPjCeRoG0eY/5Jc1/L4QkTmCjtgZjB/ZDSTlsdXgXBhu5YBoDg1d1FD7fZEGJqXC8
         nfS7+BLAcoWrd6mVsn/ned32MpBOTYSUOm2GjK4nZqYrQOMEsOGpsNSUM7I3/EYqipOZ
         hHhkY+1g3Anc7ucWLUynlqXCVr3yXLE5eiyD9SDn2/elbaMnoYs4b+S/g2lzaySpTAEH
         Yf1w==
X-Gm-Message-State: AJIora/SzRKGn/lYQv4N55++2s7A1VUQzn0GoclaAADSTZrUOStCApBs
        X87CeS+ioyTWCpjWK+wGBH3hD838NT+cdw==
X-Google-Smtp-Source: AGRyM1ufHuKPRHfn8sar+1AI/msgK0kpOQ+yOaRTX1XNzTbFkIRhF9Twk2tTtVQGzTpCCX6j4Mo5ig==
X-Received: by 2002:a17:90a:a882:b0:1ec:918a:150d with SMTP id h2-20020a17090aa88200b001ec918a150dmr21105168pjq.137.1655868985714;
        Tue, 21 Jun 2022 20:36:25 -0700 (PDT)
Received: from [192.168.1.100] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id ix5-20020a170902f80500b00168eab11f67sm11507059plb.94.2022.06.21.20.36.25
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 21 Jun 2022 20:36:25 -0700 (PDT)
Message-ID: <191dde06-2c92-da8c-9e92-b31edebb3ea5@kernel.dk>
Date:   Tue, 21 Jun 2022 21:36:24 -0600
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux aarch64; rv:91.0) Gecko/20100101
 Thunderbird/91.10.0
Subject: Re: [PATCH 5.19 0/3] poll fixes
Content-Language: en-US
To:     Pavel Begunkov <asml.silence@gmail.com>, io-uring@vger.kernel.org
References: <cover.1655852245.git.asml.silence@gmail.com>
From:   Jens Axboe <axboe@kernel.dk>
In-Reply-To: <cover.1655852245.git.asml.silence@gmail.com>
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

On 6/21/22 5:00 PM, Pavel Begunkov wrote:
> Several poll and apoll fixes for 5.19. I don't know if problems in 2-3
> were occuring prior to "io_uring: poll rework", but let's at least
> back port it to that point.
> 
> I'll also be sending another clean up series for 5.20.

Looks good to me, a few comments in the patches. As mentioned privately,
I think we should write a dummy char driver that allows us to exercise
all types of poll (single, poll, pollfree, etc) and be able to trigger
the error paths with it too. I'll give that a shot. We can probably
just make it a debugfs file or something like that, and have it be
configurable too as a debug option for test purposes.

-- 
Jens Axboe

