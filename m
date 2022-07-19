Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0E1B15790DB
	for <lists+io-uring@lfdr.de>; Tue, 19 Jul 2022 04:29:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234196AbiGSC31 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 18 Jul 2022 22:29:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59618 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233360AbiGSC30 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 18 Jul 2022 22:29:26 -0400
Received: from mail-pj1-x1029.google.com (mail-pj1-x1029.google.com [IPv6:2607:f8b0:4864:20::1029])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 167E03C14B
        for <io-uring@vger.kernel.org>; Mon, 18 Jul 2022 19:29:25 -0700 (PDT)
Received: by mail-pj1-x1029.google.com with SMTP id q41-20020a17090a1b2c00b001f2043c727aso122504pjq.1
        for <io-uring@vger.kernel.org>; Mon, 18 Jul 2022 19:29:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=cyKjSUAbf6aP85qdLzMpG+9cGQ3XPhloIG7GN5HqbOk=;
        b=PtvjjDevADa6eY5pKioXcYnfJJSND/ijd1BdeH1tmUdp/23IMf/kiY4KS+ZhOStwud
         iybB4kMCiwSVMkA8YuXqfa3amnH2O4pcZIBoeVD0/FAcvtreTNAh78plnjqzNJG7B3PP
         EZDUOglKwDCYfYPnJoEAKUbd8QDFV2q4diM5h0oiE76qUXj5kNOqfk/G/43HcCbG9rL/
         yhUwI+6blwiAeFb0iWtG155fY92T2rsU/HptjH4uUTnwecaoaokLy7Kjmm0mJGQs5PKM
         kdZScs/OmYfVex1lyjeV9QptalsbxXetYuO0fdqJRhNuLusSRtYPefx1+mEcC8tmNLbz
         eJbQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=cyKjSUAbf6aP85qdLzMpG+9cGQ3XPhloIG7GN5HqbOk=;
        b=ZaNrvLN6pHBxq/CXbCBY1dDJIKrmZ155IPgnHdVtmrlEnnDijC3lzxjlEuYGL6doFe
         qyPVcP1ySnXOKh+vDghW0wiVg8ZDd6+5xUm6MZHmL1DHeoVoIV6js3IVFRF4emYB2MMa
         VR+67oYFVPmdMbSWv24nfCP6wWclMhgdu+FfqSL4Cwa+ocA0T5T34QASxvGbPtjujspi
         c4DyUHJP8IapYYBIgFi2ZReQqlN7lpx3K9HVu5boiizVqlyr3eeYg8NoVPmBhozJnFva
         Z/hQSFbLFSIn0bj8RxaHQpQ/kWM0Z2MOqKh0HgM5/+xYqX9kCApyodiFpao0nx/ejLDC
         JKCw==
X-Gm-Message-State: AJIora99703o9DMr1WSnRlPZiKC59uPpgcIXT6Q6RVvN+DUuvRG0CSWv
        JLlOfS42qN/LgGEFkft756pHUQ==
X-Google-Smtp-Source: AGRyM1uE7kGFOhcKAIUbIMwDuprs5wFhNaDkkeHbkK3wFdgYy5LG6jRHw7UlP4t59RnLwjBy7vbGcA==
X-Received: by 2002:a17:90b:1bc7:b0:1f0:34e2:5c86 with SMTP id oa7-20020a17090b1bc700b001f034e25c86mr34944374pjb.136.1658197764422;
        Mon, 18 Jul 2022 19:29:24 -0700 (PDT)
Received: from [192.168.1.100] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id m22-20020a170902bb9600b0016c5b2a16ffsm10189043pls.142.2022.07.18.19.29.23
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 18 Jul 2022 19:29:23 -0700 (PDT)
Message-ID: <74d1f308-de03-fd5e-b7f0-0e17980f988e@kernel.dk>
Date:   Mon, 18 Jul 2022 20:29:22 -0600
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
From:   Jens Axboe <axboe@kernel.dk>
In-Reply-To: <81af5cdf-1a13-db2c-7b7b-cfd86f1271e6@intel.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=1.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,RCVD_IN_SBL_CSS,
        SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.6
X-Spam-Level: *
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 7/18/22 8:16 PM, Yin Fengwei wrote:
> Hi Jens,
> 
> On 7/19/2022 12:27 AM, Jens Axboe wrote:
>> On 7/17/22 9:30 PM, Yin Fengwei wrote:
>>> Hi Jens,
>>>
>>> On 7/15/2022 11:58 PM, Jens Axboe wrote:
>>>> In terms of making this more obvious, does the below also fix it for
>>>> you?
>>>
>>> The regression is still there after applied the change you posted.
>>
>> Still don't see the regression here, using ext4. I get about 1020-1045
>> IOPS with or without the patch you sent.
>>
>> This is running it in a vm, and the storage device is nvme. What is
>> hosting your ext4 fs?
> Just did more test with vm. The regression can't be reproduced with latest
> code (I tried the tag v5.19-rc7) whatever the underneath storage is SATA
> or NVME.
> 
> But the regression and the debugging patch from me could be reproduced
> on both SATA and NVME if use commit 584b0180f0f4d6 as base commit
> (584b0180f0f4d6 vs 584b0180f0f4d6 with my debugging patch).
> 
> 
> Here is the test result I got:
> NVME as host storage:
>   5.19.0-rc7:
>     write: IOPS=933, BW=937MiB/s (982MB/s)(18.3GiB/20020msec); 0 zone resets
>     write: IOPS=993, BW=996MiB/s (1045MB/s)(19.5GiB/20020msec); 0 zone resets
>     write: IOPS=1005, BW=1009MiB/s (1058MB/s)(19.7GiB/20020msec); 0 zone resets
>     write: IOPS=985, BW=989MiB/s (1037MB/s)(19.3GiB/20020msec); 0 zone resets
>     write: IOPS=1020, BW=1024MiB/s (1073MB/s)(20.0GiB/20020msec); 0 zone resets
> 
>   5.19.0-rc7 with my debugging patch:
>     write: IOPS=988, BW=992MiB/s (1040MB/s)(19.7GiB/20384msec); 0 zone resets
>     write: IOPS=995, BW=998MiB/s (1047MB/s)(20.1GiB/20574msec); 0 zone resets
>     write: IOPS=996, BW=1000MiB/s (1048MB/s)(19.5GiB/20020msec); 0 zone resets
>     write: IOPS=995, BW=998MiB/s (1047MB/s)(19.5GiB/20020msec); 0 zone resets
>     write: IOPS=1006, BW=1009MiB/s (1058MB/s)(19.7GiB/20019msec); 0 zone resets

These two basically look identical, which may be why I get the same with
and without your patch. I don't think it makes a difference for this.
Curious how it came about?

>   584b0180f0:
>     write: IOPS=1004, BW=1008MiB/s (1057MB/s)(19.7GiB/20020msec); 0 zone resets
>     write: IOPS=968, BW=971MiB/s (1018MB/s)(19.4GiB/20468msec); 0 zone resets
>     write: IOPS=982, BW=986MiB/s (1033MB/s)(19.3GiB/20020msec); 0 zone resets
>     write: IOPS=1000, BW=1004MiB/s (1053MB/s)(20.1GiB/20461msec); 0 zone resets
>     write: IOPS=903, BW=906MiB/s (950MB/s)(18.1GiB/20419msec); 0 zone resets
> 
>   584b0180f0 with my debugging the patch:
>     write: IOPS=1073, BW=1076MiB/s (1129MB/s)(21.1GiB/20036msec); 0 zone resets
>     write: IOPS=1131, BW=1135MiB/s (1190MB/s)(22.2GiB/20022msec); 0 zone resets
>     write: IOPS=1122, BW=1126MiB/s (1180MB/s)(22.1GiB/20071msec); 0 zone resets
>     write: IOPS=1071, BW=1075MiB/s (1127MB/s)(21.1GiB/20071msec); 0 zone resets
>     write: IOPS=1049, BW=1053MiB/s (1104MB/s)(21.1GiB/20482msec); 0 zone resets

Last one looks like it may be faster indeed. I do wonder if this is
something else, though. There's no reason why -rc7 with that same patch
applied should be any different than 584b0180f0 with it.


these resu
> 
> 
> SATA disk as host storage:
>   5.19.0-rc7:
>     write: IOPS=624, BW=627MiB/s (658MB/s)(12.3GiB/20023msec); 0 zone resets
>     write: IOPS=655, BW=658MiB/s (690MB/s)(12.9GiB/20021msec); 0 zone resets
>     write: IOPS=596, BW=600MiB/s (629MB/s)(12.1GiB/20586msec); 0 zone resets
>     write: IOPS=647, BW=650MiB/s (682MB/s)(12.7GiB/20020msec); 0 zone resets
>     write: IOPS=591, BW=594MiB/s (623MB/s)(12.1GiB/20787msec); 0 zone resets
> 
>   5.19.0-rc7 with my debugging patch:
>     write: IOPS=633, BW=637MiB/s (668MB/s)(12.6GiB/20201msec); 0 zone resets
>     write: IOPS=614, BW=617MiB/s (647MB/s)(13.1GiB/21667msec); 0 zone resets
>     write: IOPS=653, BW=657MiB/s (689MB/s)(12.8GiB/20020msec); 0 zone resets
>     write: IOPS=618, BW=622MiB/s (652MB/s)(12.2GiB/20033msec); 0 zone resets
>     write: IOPS=604, BW=608MiB/s (638MB/s)(12.1GiB/20314msec); 0 zone resets

These again are probably the same, within variance.

>   584b0180f0:
>     write: IOPS=635, BW=638MiB/s (669MB/s)(12.5GiB/20020msec); 0 zone resets
>     write: IOPS=649, BW=652MiB/s (684MB/s)(12.8GiB/20066msec); 0 zone resets
>     write: IOPS=639, BW=642MiB/s (674MB/s)(13.1GiB/20818msec); 0 zone resets
> 
>   584b0180f0 with my debugging patch:
>     write: IOPS=850, BW=853MiB/s (895MB/s)(17.1GiB/20474msec); 0 zone resets
>     write: IOPS=738, BW=742MiB/s (778MB/s)(15.1GiB/20787msec); 0 zone resets
>     write: IOPS=751, BW=755MiB/s (792MB/s)(15.1GiB/20432msec); 0 zone resets

But this one looks like a clear difference.

I'll poke at this tomorrow.

-- 
Jens Axboe

