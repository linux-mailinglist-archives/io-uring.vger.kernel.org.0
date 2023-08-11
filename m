Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 018A97794CA
	for <lists+io-uring@lfdr.de>; Fri, 11 Aug 2023 18:36:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229592AbjHKQgs (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 11 Aug 2023 12:36:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59636 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235488AbjHKQgr (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 11 Aug 2023 12:36:47 -0400
Received: from mail-pf1-x431.google.com (mail-pf1-x431.google.com [IPv6:2607:f8b0:4864:20::431])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BD6352D79
        for <io-uring@vger.kernel.org>; Fri, 11 Aug 2023 09:36:46 -0700 (PDT)
Received: by mail-pf1-x431.google.com with SMTP id d2e1a72fcca58-686f6231bdeso493273b3a.1
        for <io-uring@vger.kernel.org>; Fri, 11 Aug 2023 09:36:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20221208.gappssmtp.com; s=20221208; t=1691771806; x=1692376606;
        h=content-transfer-encoding:in-reply-to:from:references:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=KWqpWditKXOjx4vZ6ni48OG2BMbT39LwVrViRWFbTfA=;
        b=dm/6Es/gvHFCMJdLAI/VUTOVcQzgtU+lJW2TTuDlbInswZR8ODJucVnEGbwCRIxIb+
         C1XhgPg+6+i5JAvbCi2fXKwdl2lhC+tD9c2e5FqPiSSOvDmcDObcGCabsTnjbLIaoAj4
         E8H8O3qHkTCAN8uMjYKGKkMByRvQOHTL8p5okPJWAK9tZfuICUAn+y2CVr6FFwvSQcne
         FT8edkYZueLR7FBhukVlTZGvS6ci3vE3JLvgxPNQnQlpt1NGQADi/Li0chPORN5jnAIq
         sR5dWNFLpW4jvuDlEPplZlQ4AJLkSiNhLDBNo68BCDUhRlfgRdPUGOSH0rg1EzQFnC20
         sXDw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1691771806; x=1692376606;
        h=content-transfer-encoding:in-reply-to:from:references:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=KWqpWditKXOjx4vZ6ni48OG2BMbT39LwVrViRWFbTfA=;
        b=WhGT2tEPwG7LvlXqpYR97TafRUxhn6HYeDJPVHubyTW6FfOoZRGOOERbbSKzYTONpG
         jfp3VieVmhm7Jd/A81UTkXI6tyAwr0cgGjUq7oBj2IUKyozxDfjqgAk/LRbVZ5FMU/i9
         A6gE16wrBxcDfHEu+JVgqItM63u/vJjlX+RgR2BUzqqwTdrzFdxVqSKidF2iko7SpHNz
         0PXoiN+5SJ0S2p2Rv0VQTG9bjVKBeLSUdbl6vvnVFcU30K7dhY3kwWmQPR8Dk6e76JAA
         gT4N4LekXK3FfI6ffe1FBt2BgzG0KcUKCj9F944GcxNU3e4+cfKC0nDwf+DbO417TpO8
         vh8g==
X-Gm-Message-State: AOJu0YyMhsm2/oMqHaq2OFVze2gf8ZkfvJL3uKewOgi0W+NcBxv3JtAu
        D9LqCBDZJPTrhYiylKFDvaQQR1Xw5dqr/AoAdkw=
X-Google-Smtp-Source: AGHT+IHqaHUxNM9VW1jOIcFbgwEcDGkTok9bCLbsVS2nvJE2c2TVwdcTyCOGHtAzKUoaZZqHBvwEiw==
X-Received: by 2002:a05:6a20:a11e:b0:13c:bda3:79c3 with SMTP id q30-20020a056a20a11e00b0013cbda379c3mr3474440pzk.4.1691771806125;
        Fri, 11 Aug 2023 09:36:46 -0700 (PDT)
Received: from [192.168.1.136] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id j7-20020a62e907000000b00686edf28c22sm3521511pfh.87.2023.08.11.09.36.44
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 11 Aug 2023 09:36:45 -0700 (PDT)
Message-ID: <2305efb9-36a7-4aee-9312-293b723aa0df@kernel.dk>
Date:   Fri, 11 Aug 2023 10:36:44 -0600
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCHSET 0/3] io-wq locking improvements
Content-Language: en-US
To:     Hao Xu <hao.xu@linux.dev>, io-uring@vger.kernel.org
References: <20230809194306.170979-1-axboe@kernel.dk>
 <0399dbf5-ada0-d528-b925-aa90fa42df49@linux.dev>
From:   Jens Axboe <axboe@kernel.dk>
In-Reply-To: <0399dbf5-ada0-d528-b925-aa90fa42df49@linux.dev>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 8/10/23 10:00 PM, Hao Xu wrote:
> On 8/10/23 03:43, Jens Axboe wrote:
>> Hi,
>>
>> In chatting with someone that was trying to use io_uring to read
>> mailddirs, they found that running a test case that does:
>>
>> open file, statx file, read file, close file
>>
>> The culprit here is statx, and argumentation aside on whether it makes
>> sense to statx in the first place, it does highlight that io-wq is
>> pretty locking intensive.
>>
>> This (very lightly tested [1]) patchset attempts to improve this
>> situation, but reducing the frequency of grabbing wq->lock and
>> acct->lock.
>>
>> The first patch gets rid of wq->lock on work insertion. io-wq grabs it
>> to iterate the free worker list, but that is not necessary.
>>
>> Second patch reduces the frequency of acct->lock grabs, when we need to
>> run the queue and process new work. We currently grab the lock and check
>> for work, then drop it, then grab it again to process the work. That is
>> unneccessary.
>>
>> Final patch just optimizes how we activate new workers. It's not related
>> to the locking itself, just reducing the overhead of activating a new
>> worker.
>>
>> Running the above test case on a directory with 50K files, each being
>> between 10 and 4096 bytes, before these patches we get spend 160-170ms
>> running the workload. With this patchset, we spend 90-100ms doing the
>> same work. A bit of profile information is included in the patch commit
>> messages.
>>
>> Can also be found here:
>>
>> https://git.kernel.dk/cgit/linux/log/?h=io_uring-wq-lock
>>
>> [1] Runs the test suite just fine, with PROVE_LOCKING enabled and raw
>>      lockdep as well.
>>
> 
> Haven't got time to test it, but looks good from the code itself.
> 
> Reviewed-by: Hao Xu <howeyxu@tencent.com>

Thanks, added.

-- 
Jens Axboe


