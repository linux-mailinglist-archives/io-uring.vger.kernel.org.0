Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 188955783FE
	for <lists+io-uring@lfdr.de>; Mon, 18 Jul 2022 15:42:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234517AbiGRNmL (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 18 Jul 2022 09:42:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36330 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234635AbiGRNmI (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 18 Jul 2022 09:42:08 -0400
Received: from mail-pg1-x536.google.com (mail-pg1-x536.google.com [IPv6:2607:f8b0:4864:20::536])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3DBAC20BD7
        for <io-uring@vger.kernel.org>; Mon, 18 Jul 2022 06:42:06 -0700 (PDT)
Received: by mail-pg1-x536.google.com with SMTP id q16so7500163pgq.6
        for <io-uring@vger.kernel.org>; Mon, 18 Jul 2022 06:42:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=u7oVfkm/MVI1OSiZ0jzeZ2Vv5LzcXrNRaw00z4jQoKM=;
        b=Luc2TOA3YaVEMqBav+2d6PzyiCVA8bxRaxOkzuimVRuQX2pzlSLX64KOuccMfZ/GwA
         Th11hXhXGtCN9c1q0Rad3LAWFsP1EBQIfY7j9dGKUhYbpFYIR4dCk8Ta/3s5UhwuRKdm
         zWJgaFdtccTNyUtK3UVmpC/7arC2tbiwFEStM6uFWhuuKYcAM16wkWJ1AHE8528iwjW/
         JHxmzHED/DtaLQVKkrY0NlNzBmdHWyPVrm4I5aaVO4rdnJAuRPn5n9mKX3FUfF6fG7f+
         TLvUyrGS/Cr7CcAsQ1EIVftoEc99bd/2tS63BKuoNtxGB32Nk9iDpbvK3gIsl9FHtTX2
         oQ9A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=u7oVfkm/MVI1OSiZ0jzeZ2Vv5LzcXrNRaw00z4jQoKM=;
        b=aMI0ANr2VyINdlRRomllmqAiJOHAfs5p+y/v+xoCSOGB5XeqTkN8AuhmrglAmx2Jfb
         kMrK5P5gNs+9AVenSd46jIAfB1fu+rKej88OMynYzDUtcmU07NRHfqryrIoZXyMI93Qk
         6rPR/P0vsrNVIasXZRBngb8m49BMBsIWryEmqs8SUzE+X0CXOgSrUIE0++nQdAKWwOH+
         zFtnx5lZDtP8x08nLNTPOpY5ln2Lvh8RrS1m6cS1DImbN6NTM37R/ZdD1N2c1i6r/6q0
         xU4xutbqwADVp9vSDdnSjRqdYwcv8tvqbdhtU+KdRpZxD4j2rqy/RSa5344tx17dlYuq
         bvKg==
X-Gm-Message-State: AJIora+dke+x8uAstaRFpPNDyGiO5x6wAdDapc0nCLNfdVWtYEKcuK/N
        XzZ0yxcOiAq5ZN85FAEL1930vg==
X-Google-Smtp-Source: AGRyM1sD1WHGEWztFWYxtpAKMVvU+F4VvyTXosuzNoUjZIlLIggFAw2x3AYzhkpGL5IanaKthC3YzQ==
X-Received: by 2002:a05:6a00:14d2:b0:52a:d2a1:5119 with SMTP id w18-20020a056a0014d200b0052ad2a15119mr27978857pfu.36.1658151725682;
        Mon, 18 Jul 2022 06:42:05 -0700 (PDT)
Received: from [192.168.1.100] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id a3-20020a1709027e4300b0016ce9b735dcsm3547327pln.40.2022.07.18.06.42.04
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 18 Jul 2022 06:42:05 -0700 (PDT)
Message-ID: <da243472-9ee6-f08c-db8d-c51eb1035c09@kernel.dk>
Date:   Mon, 18 Jul 2022 07:42:04 -0600
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux aarch64; rv:91.0) Gecko/20100101
 Thunderbird/91.10.0
Subject: Re: [PATCH liburing] fix io_uring_recvmsg_cmsg_nexthdr logic
Content-Language: en-US
To:     Ammar Faizi <ammarfaizi2@gnuweeb.org>,
        Dylan Yudaken <dylany@fb.com>,
        Pavel Begunkov <asml.silence@gmail.com>
Cc:     io-uring Mailing List <io-uring@vger.kernel.org>,
        Facebook Kernel Team <kernel-team@fb.com>
References: <20220718133429.726628-1-dylany@fb.com>
 <accaa2d6-53d6-c45c-28ba-6436652d51ca@gnuweeb.org>
From:   Jens Axboe <axboe@kernel.dk>
In-Reply-To: <accaa2d6-53d6-c45c-28ba-6436652d51ca@gnuweeb.org>
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

On 7/18/22 7:41 AM, Ammar Faizi wrote:
> On 7/18/22 8:34 PM, Dylan Yudaken wrote:
>> io_uring_recvmsg_cmsg_nexthdr was using the payload to delineate the end
>> of the cmsg list, but really it needs to use whatever was returned by the
>> kernel.
>>
>> Reported-by: Jens Axboe <axboe@kernel.dk>
>> Fixes: 874406f ("add multishot recvmsg API")
>> Signed-off-by: Dylan Yudaken <dylany@fb.com>
> 
> The Fixes tag must be at least 12 chars.

It was fixed up while applying.

-- 
Jens Axboe

