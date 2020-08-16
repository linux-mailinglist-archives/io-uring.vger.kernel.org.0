Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3D95C245528
	for <lists+io-uring@lfdr.de>; Sun, 16 Aug 2020 03:21:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726582AbgHPBVJ (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sat, 15 Aug 2020 21:21:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50048 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726177AbgHPBVI (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sat, 15 Aug 2020 21:21:08 -0400
Received: from mail-pl1-x644.google.com (mail-pl1-x644.google.com [IPv6:2607:f8b0:4864:20::644])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 451F7C061786
        for <io-uring@vger.kernel.org>; Sat, 15 Aug 2020 18:21:08 -0700 (PDT)
Received: by mail-pl1-x644.google.com with SMTP id k13so5776440plk.13
        for <io-uring@vger.kernel.org>; Sat, 15 Aug 2020 18:21:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:from:to:cc:references:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=+DOdg8c4h793eqoRKhHse/Dczs6vwgPQAMftMqsDKmI=;
        b=pF9kBHUNFTVDNezNpf4KbUGEWzDoNd94/pnHRjfCYHB6GsYhbXPJOwTMtL9idrgkA9
         /vGbliOvZTaWONPI5tdH9Utx4zRA3upouodbYsIYs1EMmCkErTWLf45jl97NINDeAFCE
         MPdsLmLRFAEmNctW+m1pb42J3Uqqd6B3+4i8683EcSlnTuai/GPdo00gQtubSbdIcBIk
         Zb07O1JFqskTBSvbjxX2dA4jPV1jVzjQ/N3SESTZaNlGBn7oYd3r+v5rcoBFm/lmIQwX
         wqOHiDaCgIeZxOMLrIyVfKDfVIY2XhhqOTAaasfjfIoiOlXRVRLHtBdEsLeReNmlurFU
         l/EQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:cc:references:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=+DOdg8c4h793eqoRKhHse/Dczs6vwgPQAMftMqsDKmI=;
        b=KzdCIIImC3QuznoJV28O6GAF4BHp5fqdsVk/chqxkcIdgl1FxUdiLzT3Kqy4UcrqCj
         o7MUBRdZ/u3dq/9cKci1MXPDD5zaoW1geMok2nlmrhNocaBvD/qI9OfTEzF9XxWiP9KS
         5TA/Fps0+QxgbXqU3J7IIupJURtFXtdlxMZiMCs22fqvuT1iz3GYOLt3WYjW1UmgBzgd
         CPe8aQveM7nIk4ECydXDCNwxJk3LPKd2K1qWGIXN68OTDmsnyFa+kmAMEeWa8xcxXTZA
         SZDfLkURhnq9r5vD5cdyZDO4+7YDkkQaKLbnU4PcRg5wW+TPKiNc6MtZRPgBP+1v5niL
         omIA==
X-Gm-Message-State: AOAM530yjlkmdxEoINH0nfzm6vwmA/vgVnrh2/ENzMuxPZ9Smr8ymcuT
        2TXwkRw3vpL5bhbpwzRWHc7CXw==
X-Google-Smtp-Source: ABdhPJwgyOM4x031TWMM5NnX+mQ1lN0+TaOmA0tdPfm1hh8X7YZ6K0zDSP2haDKpHBaz4PqDOHhkgw==
X-Received: by 2002:a17:90b:193:: with SMTP id t19mr7634489pjs.162.1597540867719;
        Sat, 15 Aug 2020 18:21:07 -0700 (PDT)
Received: from ?IPv6:2605:e000:100e:8c61:6299:2df1:e468:6351? ([2605:e000:100e:8c61:6299:2df1:e468:6351])
        by smtp.gmail.com with ESMTPSA id o192sm14179339pfg.81.2020.08.15.18.21.06
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 15 Aug 2020 18:21:07 -0700 (PDT)
Subject: Re: io_uring process termination/killing is not working
From:   Jens Axboe <axboe@kernel.dk>
To:     Josef <josef.grieb@gmail.com>,
        Pavel Begunkov <asml.silence@gmail.com>,
        io-uring@vger.kernel.org
Cc:     norman@apache.org
References: <CAAss7+pf+CGQiSDM8_fhsHRwjWUxESPcJMhOOsDOitqePQxCrg@mail.gmail.com>
 <dc3562d8-dc67-c623-36ee-38885b4c1682@kernel.dk>
 <8e734ada-7f28-22df-5f30-027aca3695d1@gmail.com>
 <5fa9e01f-137d-b0f8-211a-975c7ed56419@gmail.com>
 <d0d1f797-c958-ac17-1f11-96f6ba6dbf37@gmail.com>
 <d0621b79-4277-a9ad-208e-b60153c08d15@kernel.dk>
 <bb45665c-1311-807d-5a03-459cf3cbd103@gmail.com>
 <d06c7f29-726b-d46a-8c51-0dc47ef374ad@kernel.dk>
 <63024e23-2b71-937a-6759-17916743c16c@gmail.com>
 <CAAss7+qGqCpp8dWpDR2rVJERwtV7r=9vEajOMqbhkSQ8Y-yteQ@mail.gmail.com>
 <fa0c9555-d6bc-33a3-b6d1-6a95a744c69f@kernel.dk>
 <904b4d74-09ec-0bd3-030a-59b09fb1a7da@kernel.dk>
 <CAAss7+r8CZMVmxj0_mHTPUVbp3BzT4LGa2uEUjCK1NpXQnDkdw@mail.gmail.com>
 <390e6d95-040b-404e-58c4-d633d6d0041d@kernel.dk>
Message-ID: <63b47134-ad9c-4305-3a19-8c5deb7da686@kernel.dk>
Date:   Sat, 15 Aug 2020 18:21:05 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <390e6d95-040b-404e-58c4-d633d6d0041d@kernel.dk>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 8/15/20 5:41 PM, Jens Axboe wrote:
> On 8/15/20 5:36 PM, Josef wrote:
>>> Please try:
>>>
>>> https://git.kernel.dk/cgit/linux-block/commit/?h=io_uring-5.9&id=41d3344604e80db0e466f9deca5262b0914e4827
>>>
>>> There was a bug with the -EAGAIN doing repeated retries on sockets that
>>> are marked non-blocking.
>>>
>>
>> no it's not working, however I received the read event after
>> the second request (instead of the third request before) via Telnet
> 
> Are you sure your code is correct? I haven't looked too closely, but it
> doesn't look very solid. There's no error checking, and you seem to be
> setting up two rings (one overwriting the other). FWIW, I get the same
> behavior on 5.7-stable and the above branch, except that the 5.7 hangs
> on exit due to the other bug you found and that is fixed in the 5.9
> branch.
> 
> I'll take a closer look later or tomorrow, but just want to make sure
> I'm not spending time debugging your program :)
> 
> Hence it'd be helpful if you explain what your expectations are of
> the program, and how that differs from how it behaves.

Took a closer look, and made a few tweaks. Got rid of the extra links
and the nop, and I added a poll+read resubmit when a read completes.
Not sure how your program could work without that, if you expect it
to continue to echo out what is written on the connection? Also killed
that extra ring init.

After that, I made the following tweak to return short reads when
the the file is non-blocking. Then it seems to work as expected
for me.


diff --git a/fs/io_uring.c b/fs/io_uring.c
index cd956526c74c..dc506b75659c 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -3197,7 +3197,8 @@ static int io_read(struct io_kiocb *req, bool force_nonblock,
 	}
 
 	/* read it all, or we did blocking attempt. no retry. */
-	if (!iov_iter_count(iter) || !force_nonblock)
+	if (!iov_iter_count(iter) || !force_nonblock ||
+	    (req->file->f_flags & O_NONBLOCK))
 		goto done;
 
 	io_size -= ret;

-- 
Jens Axboe

