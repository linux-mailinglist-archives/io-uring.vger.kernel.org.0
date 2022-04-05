Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3CD034F51D3
	for <lists+io-uring@lfdr.de>; Wed,  6 Apr 2022 04:43:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346638AbiDFCVG (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 5 Apr 2022 22:21:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37850 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1450753AbiDEPwH (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 5 Apr 2022 11:52:07 -0400
Received: from mail-io1-xd30.google.com (mail-io1-xd30.google.com [IPv6:2607:f8b0:4864:20::d30])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B11F4D95C9
        for <io-uring@vger.kernel.org>; Tue,  5 Apr 2022 07:43:33 -0700 (PDT)
Received: by mail-io1-xd30.google.com with SMTP id 9so15412194iou.5
        for <io-uring@vger.kernel.org>; Tue, 05 Apr 2022 07:43:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :references:from:in-reply-to:content-transfer-encoding;
        bh=MtJsMPmXFuZ/ZzakxbhVchfgd5pZLoeOLwEBM9mwVu8=;
        b=6IS8PmekJ6kvTK+YRnQgPWVRRF2fk9d4OVyycqGYv9u8Wp+rDhOocENgSqnmVCTub9
         EDZfBHgdOuQ956OHmPuBg5s3jFogbawxXmxjmvhP2oPCdnd1Kld4X71xI9aXWKsCX7sO
         Y1HF0ebQo8fpRVxUwMem5+nFREfA+Q8oxdWPgH221CTEL60pr27/+bwkDHgPp5JpxBmX
         388LFT/n7ct0uIA2l/FR3R8DfXi4XuAJ4JLAn1ZstP7aOV/poSRzfSy+xkM8PDzEOw6D
         0oApA7sa6bFNg19ojRVuZgaD/mBl8jCeOktGZD43ewAH8sdmh87C5iYfdc7c9P/lMRJb
         3BCQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:references:from:in-reply-to
         :content-transfer-encoding;
        bh=MtJsMPmXFuZ/ZzakxbhVchfgd5pZLoeOLwEBM9mwVu8=;
        b=Pqh5QDg01qysECyBcanwvMXbXIjR5oeWircS3Zqc6Je2IDYYDbXFXPnuxAXarRlKGf
         2zFzV07F8H1/UIOplR8PQKu9w5hNpDdA4drTpBN8+CkJlGa6qi83zmyKSr2ZBpdyQM38
         r07Z1C6Z6w0UTvPD4+PNK9RykUtDKTFjzdwBOQuBkHsmY0Lga2v/tWLS+C4IvLkcuGA7
         2qrCwDxF9m705btRWfMtc1TJj+rcnl9seyOy3Pxwp/0RcBTDzxbIB60hR4a8ZROTXr+Y
         VS+2eKaZ7G0rbWp5DlCcF6HtSPysg7KqtMLticf25URRaBuuOymagxxxsThddglH+O0A
         cdDg==
X-Gm-Message-State: AOAM530CXV/fqfozTJI6+ibx9wFZuKQGpkU9BAmqJOe+qovepN+BZWuI
        FMVstvBBFSRcmKVVOHlWva++GKruT4ZQQg==
X-Google-Smtp-Source: ABdhPJy8HYUzzwqGHSoTfRQX5g8//RDrADFYPUemTKtOUwH5p29F9ZzwNONvT+TJfLGhqyU9Dhw+RA==
X-Received: by 2002:a02:ac89:0:b0:323:7aae:c30b with SMTP id x9-20020a02ac89000000b003237aaec30bmr2269655jan.133.1649169812666;
        Tue, 05 Apr 2022 07:43:32 -0700 (PDT)
Received: from [192.168.1.172] ([207.135.234.126])
        by smtp.gmail.com with ESMTPSA id a22-20020a5d9816000000b006496d8651cfsm8274325iol.1.2022.04.05.07.43.32
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 05 Apr 2022 07:43:32 -0700 (PDT)
Message-ID: <ccd1053a-39a7-91e8-9a17-4df42c6ebc3e@kernel.dk>
Date:   Tue, 5 Apr 2022 08:43:30 -0600
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux aarch64; rv:91.0) Gecko/20100101
 Thunderbird/91.7.0
Subject: Re: [PATCHSET v4 0/5] Fix early file assignment for links or drain
Content-Language: en-US
To:     Stefan Metzmacher <metze@samba.org>, io-uring@vger.kernel.org
References: <20220404235626.374753-1-axboe@kernel.dk>
 <2c35f878-5f25-9afe-be39-7239a8d3df6d@samba.org>
From:   Jens Axboe <axboe@kernel.dk>
In-Reply-To: <2c35f878-5f25-9afe-be39-7239a8d3df6d@samba.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.5 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 4/5/22 4:04 AM, Stefan Metzmacher wrote:
> Hi Jens,
> 
>> Most of this is prep patches, but the purpose is to make sure that we
>> treat file assignment for links appropriately. If not, then we cannot
>> use direct open/accept with links while avoiding separate submit+wait
>> cycles.
>>
>> v4:
>> - Drop merged patch for msg-ring
>> - Drop inflight tracking completely, pointless now
>> - Fix locking issue around file assignment
> 
> If the behavior change is backported to 5.15 stable,
> don't we need a flag to indicate that a newer kernel supports it?
> 
> Otherwise how could userspace know it can rely on the new behavior?

Yes, I have been thinking that too, we should add a FEAT flag for this.

-- 
Jens Axboe

