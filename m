Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B718657BC8C
	for <lists+io-uring@lfdr.de>; Wed, 20 Jul 2022 19:24:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239972AbiGTRYS (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 20 Jul 2022 13:24:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49944 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229921AbiGTRYR (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 20 Jul 2022 13:24:17 -0400
Received: from mail-io1-xd34.google.com (mail-io1-xd34.google.com [IPv6:2607:f8b0:4864:20::d34])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1F0FF55092
        for <io-uring@vger.kernel.org>; Wed, 20 Jul 2022 10:24:16 -0700 (PDT)
Received: by mail-io1-xd34.google.com with SMTP id e69so7295894iof.5
        for <io-uring@vger.kernel.org>; Wed, 20 Jul 2022 10:24:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=xN1e0M5XNbM3KXA/S/AVCXjXEIe1l4nyl0ZTvEljnbo=;
        b=Rr2nq5m+Krs4sVN8nCvW6/o4rNl5tdcAGeUIumQyYDBH2NvuTfm3Icx7+k5AaLeozg
         +a+M1MUZo386SSMJ2ZLyuFV6Iq2zhuNV+sWqdv9L7u2h1586CfetE3gb43mCUApHEarJ
         Nx2k95EReDwVriGtREP4Ax9ZGAFavwvkHmKkdxbqiaReJ6H29zgWvzCJV28xxX6j6jRd
         URKgDmVU5c3A/53xYDZeyAbqTGO2R8HhLCprJs21x9KxJAk9b1Jyw1m+O4zCfVHgguP+
         T/uhgUe98BmjRAES/NKdM5J0a/Je2dZtz1pUbly2YIduT0c6uvIbMm5wi/4xYWDlom7U
         CpFQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=xN1e0M5XNbM3KXA/S/AVCXjXEIe1l4nyl0ZTvEljnbo=;
        b=xBd0g6bx0sQF+Yt4ydZrzOsD/ycx/nvIdfUirFiTg5sdMJjETCY186/As+E9o+PBV/
         6ciH9xqzcQOgkbeopT/4+fLBB2o4KeM1cEHyBRAeIdxinXxn+2OPlXauj2RWZo+fUX/g
         ryo+DFd6idk+vxxzwQEpzoruuH5i0x/WAMEpRQEgoevzdwMfEhR4i+E4L99APpPqKSxG
         pPxdkRGcOHvirgL6AC2NVX4iYShB4KlQZa7yYQS7mmAk+GRxTSUMk6jz0DaSUr0pQqOf
         fS6bN1QXcSHa6+NOhfg2/V2gja9Pl0FfKhEeQozgRXJZgJdematvj37jEUwYz9vY+8c+
         EkXA==
X-Gm-Message-State: AJIora+pGEBuF305q89q5BKDYJtMzQMP4Eq9fzhp9Xgj3YsFXRBuZ71o
        aS9IvIYhk7bQbBwYx4I0rc2GfQ==
X-Google-Smtp-Source: AGRyM1uy38d9e+SjTB1Bwm0ezIHZDBfeGhs0SB7c6r7+g81F5cU5fxj4f4dvKsJVvkML9/S7imyLxg==
X-Received: by 2002:a02:9995:0:b0:33f:1def:a856 with SMTP id a21-20020a029995000000b0033f1defa856mr21611465jal.140.1658337855405;
        Wed, 20 Jul 2022 10:24:15 -0700 (PDT)
Received: from [192.168.1.172] ([207.135.234.126])
        by smtp.gmail.com with ESMTPSA id n2-20020a056602340200b0067b7a057ee8sm4950544ioz.25.2022.07.20.10.24.14
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 20 Jul 2022 10:24:14 -0700 (PDT)
Message-ID: <f5d20f6c-5363-231b-b208-b577a59b4ae9@kernel.dk>
Date:   Wed, 20 Jul 2022 11:24:14 -0600
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux aarch64; rv:91.0) Gecko/20100101
 Thunderbird/91.10.0
Subject: Re: [LKP] Re: [io_uring] 584b0180f0:
 phoronix-test-suite.fio.SequentialWrite.IO_uring.Yes.Yes.1MB.DefaultTestDirectory.mb_s
 -10.2% regression
Content-Language: en-US
To:     Yin Fengwei <fengwei.yin@intel.com>,
        kernel test robot <oliver.sang@intel.com>
Cc:     LKML <linux-kernel@vger.kernel.org>, io-uring@vger.kernel.org,
        lkp@lists.01.org, lkp@intel.com
References: <20220527092432.GE11731@xsang-OptiPlex-9020>
 <2085bfef-a91c-8adb-402b-242e8c5d5c55@kernel.dk>
 <0d60aa42-a519-12ad-3c69-72ed12398865@intel.com>
 <26d913ea-7aa0-467d-4caf-a93f8ca5b3ff@kernel.dk>
 <9df150bb-f4fd-7857-aea8-b2c7a06a8791@intel.com>
 <7146c853-0ff8-3c92-c872-ce6615baab40@kernel.dk>
 <81af5cdf-1a13-db2c-7b7b-cfd86f1271e6@intel.com>
 <74d1f308-de03-fd5e-b7f0-0e17980f988e@kernel.dk>
 <2ec953da-78fd-df01-44cf-6f33a5e40864@intel.com>
From:   Jens Axboe <axboe@kernel.dk>
In-Reply-To: <2ec953da-78fd-df01-44cf-6f33a5e40864@intel.com>
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

On 7/19/22 2:58 AM, Yin Fengwei wrote:
> Hi Jens,
> 
> On 7/19/2022 10:29 AM, Jens Axboe wrote:
>> I'll poke at this tomorrow.
> 
> Just FYI. Another finding (test is based on commit 584b0180f0):
> If the code block is put to different function, the fio performance result is
> different:

I think this turned out to be a little bit of a goose chase. What's
happening here is that later kernels defer the file assignment, which
means it isn't set if a request is queued with IOSQE_ASYNC. That in
turn, for writes, means that we don't hash it on io-wq insertion, and
then it doesn't get serialized with other writes to that file.

I'll come up with a patch for this that you can test.

-- 
Jens Axboe

