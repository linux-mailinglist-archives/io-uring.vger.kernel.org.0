Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E523B56240E
	for <lists+io-uring@lfdr.de>; Thu, 30 Jun 2022 22:19:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231270AbiF3UTQ (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 30 Jun 2022 16:19:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48502 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234853AbiF3UTP (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 30 Jun 2022 16:19:15 -0400
Received: from mail-pf1-x42d.google.com (mail-pf1-x42d.google.com [IPv6:2607:f8b0:4864:20::42d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E4B0F1A38C
        for <io-uring@vger.kernel.org>; Thu, 30 Jun 2022 13:19:13 -0700 (PDT)
Received: by mail-pf1-x42d.google.com with SMTP id a15so436349pfv.13
        for <io-uring@vger.kernel.org>; Thu, 30 Jun 2022 13:19:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=opHiS7W0j4JfIKBs5FAWT07swKhjSTZ00pV0v6S58zQ=;
        b=vdZ3b6pX+tYCfhtJv9wBy6nGS3J4VGoOyw29++xEt5L+lVni6tK6PkJ4OnsnrR/8l4
         OFXG4B5v7VitLeJgHbvKdBwZp7apQOcQkMub2HdZRxKrYc1BIa832Mw5wbeLJZwF7u+W
         ddOahw9Khk+CQAgdaJFPgAopNmXaDDr2K2CN6QimwHeDF3Z/jmiEF+m1XX/NTw2vk3t6
         wTeUfbEWkYTNy1Iw2mN7LJmGh9JJc248oNP97YPizq2DdPEeAAd0c7Bm0+YhjHrLjNGy
         T7Ij18ep9/paO4Q1gUq+5W7Mnp1YMYTXzVSFDjATjOfbsbgOpB3OuiSkwP8RKyFhcKrO
         BzMg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=opHiS7W0j4JfIKBs5FAWT07swKhjSTZ00pV0v6S58zQ=;
        b=i2e/bMrdaBE5VB4CGNQH5iHbcEwiNG5VTQi9uhefaOiCV3MZp3tQAXnVC8LxoiTQ1a
         ARA2tESgcqIy7Tz3UeB39k1C7UFyOloV+a4x2CTPndWUsfzjAS3W0ftuCASEIdRk5aB5
         vK+gAFQ05aB9dnlUTd5YDcla1lEpWgUt//yrB6T9QPUBjV3fq+ViKQzDltgUF5WEFCVJ
         gu4Ha/NmL8aEOincZmlMCqvqti6QE0S1LBfc1WHRP8WkDg4wVSo2rPeJWYwPMy8EvY2c
         cGj4hJa4QUukTmwgJoK9VbMC1nRdCY1dIG2xGa6sojcbvcaHriyO3niTxyw/W/UzOeoX
         GeHA==
X-Gm-Message-State: AJIora+eao9Aaxcm1QWZYlVNx9nq/kuNO0adtoSxxq/3bsARpNbTRdUR
        fQ6xqacjIxE426g2aNYlSHyQog==
X-Google-Smtp-Source: AGRyM1uwsbrLlc+JXoK43XZNutldhUFETTdDmzr5ylh5bTG+uhLyPr0Yc+59u6A7vGq3Jht/DMuMyQ==
X-Received: by 2002:a05:6a00:234f:b0:525:1f7c:f2bf with SMTP id j15-20020a056a00234f00b005251f7cf2bfmr16361339pfj.14.1656620353395;
        Thu, 30 Jun 2022 13:19:13 -0700 (PDT)
Received: from [192.168.1.100] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id rw7-20020a17090b2c4700b001d954837197sm2464778pjb.22.2022.06.30.13.19.12
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 30 Jun 2022 13:19:12 -0700 (PDT)
Message-ID: <9639d0f7-f50d-c3f2-8e68-b208286af68f@kernel.dk>
Date:   Thu, 30 Jun 2022 14:19:11 -0600
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux aarch64; rv:91.0) Gecko/20100101
 Thunderbird/91.10.0
Subject: Re: [PATCH v2 for-next 00/12] io_uring: multishot recv
Content-Language: en-US
To:     Dylan Yudaken <dylany@fb.com>,
        Pavel Begunkov <asml.silence@gmail.com>,
        io-uring@vger.kernel.org
Cc:     Kernel-team@fb.com, linux-kernel@vger.kernel.org
References: <20220630091231.1456789-1-dylany@fb.com>
From:   Jens Axboe <axboe@kernel.dk>
In-Reply-To: <20220630091231.1456789-1-dylany@fb.com>
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

On 6/30/22 3:12 AM, Dylan Yudaken wrote:
> This series adds support for multishot recv/recvmsg to io_uring.
> 
> The idea is that generally socket applications will be continually
> enqueuing a new recv() when the previous one completes. This can be
> improved on by allowing the application to queue a multishot receive,
> which will post completions as and when data is available. It uses the
> provided buffers feature to receive new data into a pool provided by
> the application.
> 
> This is more performant in a few ways:
> * Subsequent receives are queued up straight away without requiring the
>   application to finish a processing loop.
> * If there are more data in the socket (sat the provided buffer
>   size is smaller than the socket buffer) then the data is immediately
>   returned, improving batching.
> *  Poll is only armed once and reused, saving CPU cycles
> 
> Running a small network benchmark [1] shows improved QPS of ~6-8% over
> a range of loads.

I have applied this, changing ->addr2 to ->ioprio for the flags bit as
per the io_uring-5.19 branch.

Pretty excited about recv multishot. I think it's an elegant model, and
it has really nice performance improvements as well!

-- 
Jens Axboe

