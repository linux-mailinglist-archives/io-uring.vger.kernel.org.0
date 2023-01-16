Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0A66966CF13
	for <lists+io-uring@lfdr.de>; Mon, 16 Jan 2023 19:45:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235131AbjAPSpi (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 16 Jan 2023 13:45:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48330 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234021AbjAPSpQ (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 16 Jan 2023 13:45:16 -0500
Received: from mail-pf1-x42d.google.com (mail-pf1-x42d.google.com [IPv6:2607:f8b0:4864:20::42d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5AC751353F
        for <io-uring@vger.kernel.org>; Mon, 16 Jan 2023 10:43:15 -0800 (PST)
Received: by mail-pf1-x42d.google.com with SMTP id i65so18153788pfc.0
        for <io-uring@vger.kernel.org>; Mon, 16 Jan 2023 10:43:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=CbyIKeZGuqTBg5wRUD19syhMWMa83AI//iU3faxWmUY=;
        b=YMmu5in7pGZ2445rqYLnn5y5DIC3h6ha9VzPcMFkpRR3AeWDzEggZ2taKcAPCoqVs2
         c/RXgQdNjn4A68PCsnflKA7tXwG+c/WmN0SK89RHCspUn+lyX6Yrkxs3/7PcvR81QU1S
         HmpA5dDUnaAIJHd3qP03XfUaqg1v5YsF92Pql1YzW3DT7PkdR66tBh9QJiU39fAA65QX
         ndbxl1zI5CZ0TNREoKtjpHdW/nm0qORXVeDVqsstfohbzDyPSa+DH1gcO8YbdkGFnV4+
         DMZmQPb/kXij8MBR18pMwnTgC183Iiwz+Yxa5wBueU4tESDL4BxIFHVq2C81NUsNv0K5
         t5ZQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=CbyIKeZGuqTBg5wRUD19syhMWMa83AI//iU3faxWmUY=;
        b=kz2jdCOg2HoI7XToqRDakelpIKnDCvuiZyrGNuxxY+2uOqOzEylhG1BKnabRiDp2Om
         uNQU3R2xaA/9ydOPu9rPfsbi8YiYoH/Dl54fp8/C09Ovc4PHdUu5zpMmaieeHNhhgcEG
         ioMoiFiwTNpkwM9otW/wA/KEgQ28bx9ngww2ToHm0t2mobvPNTvFhcJVlp/dEWMaoWvM
         VAXVVVgFCLUYLyf2D2jVoKp7B5Hddg9BLbtQfN6bSs9guKYWJHliuP0xIKMHy7BzktLp
         frnmaoHkgSilP0ZQ3Ymd7VHqq56qDoyox+2noy2ooOrAv2tS9M7+tvU3QRqSUT1so6m+
         0wJQ==
X-Gm-Message-State: AFqh2kpVxq/Qs0K0VPwaWDFaNcsc9EDcaM8fHyFvE5GByve6AuXF5Oon
        ylL2JL6tp3kX0fpO7dHT12vy1Q==
X-Google-Smtp-Source: AMrXdXtY0y60ErKkD5YGw9nmTByToqUK6q1JNS17yRRtfG0FM0PNsmh1I9E+vWLr65Xs4lPd+XHRLA==
X-Received: by 2002:a62:1c8b:0:b0:58d:995c:9c25 with SMTP id c133-20020a621c8b000000b0058d995c9c25mr133842pfc.3.1673894594717;
        Mon, 16 Jan 2023 10:43:14 -0800 (PST)
Received: from [192.168.1.136] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id b5-20020a62cf05000000b005821db4fd84sm6108214pfg.131.2023.01.16.10.43.14
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 16 Jan 2023 10:43:14 -0800 (PST)
Message-ID: <3b01c5b6-9b4c-0f7e-0fdf-67eb7c320bf0@kernel.dk>
Date:   Mon, 16 Jan 2023 11:43:13 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux aarch64; rv:102.0) Gecko/20100101
 Thunderbird/102.6.0
Subject: Re: [PATCH for-next 1/5] io_uring: return back links tw run
 optimisation
Content-Language: en-US
To:     Pavel Begunkov <asml.silence@gmail.com>, io-uring@vger.kernel.org
References: <cover.1673887636.git.asml.silence@gmail.com>
 <6328acdbb5e60efc762b18003382de077e6e1367.1673887636.git.asml.silence@gmail.com>
From:   Jens Axboe <axboe@kernel.dk>
In-Reply-To: <6328acdbb5e60efc762b18003382de077e6e1367.1673887636.git.asml.silence@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=1.3 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,RCVD_IN_SBL_CSS,
        SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.6
X-Spam-Level: *
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 1/16/23 9:48 AM, Pavel Begunkov wrote:
> io_submit_flush_completions() may queue new requests for tw execution,
> especially true for linked requests. Recheck the tw list for emptiness
> after flushing completions.

Did you check when it got lost? Would be nice to add a Fixes link?

-- 
Jens Axboe


