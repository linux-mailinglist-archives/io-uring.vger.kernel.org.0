Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0EE5D551ED1
	for <lists+io-uring@lfdr.de>; Mon, 20 Jun 2022 16:27:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243291AbiFTO0i (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 20 Jun 2022 10:26:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57844 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1351265AbiFTO0W (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 20 Jun 2022 10:26:22 -0400
Received: from mail-pg1-x529.google.com (mail-pg1-x529.google.com [IPv6:2607:f8b0:4864:20::529])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BD91549C88
        for <io-uring@vger.kernel.org>; Mon, 20 Jun 2022 06:41:20 -0700 (PDT)
Received: by mail-pg1-x529.google.com with SMTP id f65so10331517pgc.7
        for <io-uring@vger.kernel.org>; Mon, 20 Jun 2022 06:41:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=xIVUAENkLPt1jauXXDh/SEeMsraYcAnOrnR1+oo8L6Y=;
        b=eSZzS918oJX5CO5SraMOPDByKRhmrQGNfniwmsuBbpRq1SG9JsijAcRrCj7Pa9j0xT
         RnMRm3QJb8I553pSrb6AbMngtCPlWkJUKhFZ37YInCvuW++PTXBXCcRc/QMEHQZzAaxP
         cDLPs1NTK0iVhgXRR/8BgE5T+DMs6WSu6E+7ILZWONMSKWkte/R6ZBdzyRnqYNtO2p+l
         wko0wCLhanjHdDSR6qLk7ANFzGyekBXtpBGWZMgZgscyP8+cVbjoVHHATprOnTxVByeO
         C6SSKiERXyapcfy/S8CRLFHIokKlsIUzjBFhIsuk/YrpidBL7phYUzSQyo8iDQ/u3BLg
         wthg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=xIVUAENkLPt1jauXXDh/SEeMsraYcAnOrnR1+oo8L6Y=;
        b=0aJuo+YPvFX9TnnaHoYsCEwtwQXh2CtfIm/iU+EgtYopvj/0yvnc5T95gewVRM0xJZ
         JRZr92BQ5jM8XNgNpWwlqmWGf3Z/P03ROzZyt7jKFi8Y3PgSRNsOhjOygg03EtMxY8SZ
         InV2vXa0Pr3Cr0gTK4i82246Pmoh4//mRtDY1ooZygbs7H3BDR6sMjrqdAAJXRlf/5Ca
         QU282Bv7LrENhKgV0BOu2VOmR2QvZ/NBEsRnDE6X6VbRLM79B4ORg7/FckUg1+EB9xfN
         GWUgcmgbijADH0qWSrOE5+UBZXkBu6PwV9zHsn+HkhIgsIAWL+5zmx+58oxI6NA8CBNR
         M8Ww==
X-Gm-Message-State: AJIora+oph8Wd0JS7IQIN9cHyyv/X9yTFQFq8rwSyiPtwCatQ7MZYP5k
        mQQET/45hjx29wNCkiEe0bVoog==
X-Google-Smtp-Source: AGRyM1vYL2kZb+7X2N5mW7JddkJY1tX4541gH48+OqgPzntiJlaAst5PWH7PpeVl131weYmX4szWEQ==
X-Received: by 2002:a63:ae03:0:b0:408:b78c:e284 with SMTP id q3-20020a63ae03000000b00408b78ce284mr21217323pgf.401.1655732479523;
        Mon, 20 Jun 2022 06:41:19 -0700 (PDT)
Received: from [192.168.1.100] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id q2-20020a170902f78200b001624cd63bbbsm8772223pln.133.2022.06.20.06.41.18
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 20 Jun 2022 06:41:19 -0700 (PDT)
Message-ID: <b297ac50-c336-dabe-b6ee-c067b7f418c7@kernel.dk>
Date:   Mon, 20 Jun 2022 07:41:18 -0600
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux aarch64; rv:91.0) Gecko/20100101
 Thunderbird/91.10.0
Subject: Re: [RFC] a new way to achieve asynchronous IO
Content-Language: en-US
To:     Hao Xu <hao.xu@linux.dev>, io-uring <io-uring@vger.kernel.org>
Cc:     Pavel Begunkov <asml.silence@gmail.com>, dvernet@fb.com
References: <3d1452da-ecec-fdc7-626c-bcd79df23c92@linux.dev>
From:   Jens Axboe <axboe@kernel.dk>
In-Reply-To: <3d1452da-ecec-fdc7-626c-bcd79df23c92@linux.dev>
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

On 6/20/22 6:01 AM, Hao Xu wrote:
> Hi,
> I've some thought on the way of doing async IO. The current model is:
> (given we are using SQPOLL mode)
> 
> the sqthread does:
> (a) Issue a request with nowait/nonblock flag.
> (b) If it would block, reutrn -EAGAIN
> (c) The io_uring layer captures this -EAGAIN and wake up/create
> a io-worker to execute the request synchronously.
> (d) Try to issue other requests in the above steps again.
> 
> This implementation has two downsides:
> (1) we have to find all the block point in the IO stack manually and
> change them into "nowait/nonblock friendly".
> (2) when we raise another io-worker to do the request, we submit the
> request from the very beginning. This isn't a little bit inefficient.
> 
> 
> While I think we can actually do it in a reverse way:
> (given we are using SQPOLL mode)
> 
> the sqthread1 does:
> (a) Issue a request in the synchronous way
> (b) If it is blocked/scheduled soon, raise another sqthread2
> (c) sqthread2 tries to issue other requests in the same way.
> 
> This solves problem (1), and may solve (2).
> For (1), we just do the sqthread waken-up at the beginning of schedule()
> just like what the io-worker and system-worker do. No need to find all
> the block point.
> For (2), we continue the blocked request from where it is blocked when
> resource is satisfied.
> 
> What we need to take care is making sure there is only one task
> submitting the requests.
> 
> To achieve this, we can maintain a pool of sqthread just like the iowq.
> 
> I've done a very simple/ugly POC to demonstrate this:
> 
> https://github.com/HowHsu/linux/commit/183be142493b5a816b58bd95ae4f0926227b587b
> 
> I also wrote a simple test to test it, which submits two sqes, one
> read(pipe), one nop request. The first one will be block since no data
> in the pipe. Then a new sqthread was created/waken up to submit the
> second one and then some data is written to the pipe(by a unrelated
> user thread), soon the first sqthread is waken up and continues the
> request.
> 
> If the idea sounds no fatal issue I'll change the POC to real patches.
> Any comments are welcome!

One thing I've always wanted to try out is kind of similar to this, but
a superset of it. Basically io-wq isn't an explicit offload mechanism,
it just happens automatically if the issue blocks. This applies to both
SQPOLL and non-SQPOLL.

This takes a page out of the old syslet/threadlet that Ingo Molnar did
way back in the day [1], but it never really went anywhere. But the
pass-on-block primitive would apply very nice to io_uring.

That way it'd work is that any issue, SQPOLL or not, would just assume
that it won't block. If it doesn't block, great, we can complete it
inline. If it does block, an io-wq thread is grabbed and the context
moved there. The io-wq takes over the blocking, and the original issue
returns in some fashion that allows us to know it went implicitly async.

This may be a bit more involved than what you suggest here, which in
nature is similar in how we just hope for the best, and deal with the
outcome if we did end up blocking.

Do you have any numbers from your approach?

[1] https://lore.kernel.org/all/20070301145742.GC12684@2ka.mipt.ru/T/

-- 
Jens Axboe

