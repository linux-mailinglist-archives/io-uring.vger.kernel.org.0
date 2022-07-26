Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9A514581759
	for <lists+io-uring@lfdr.de>; Tue, 26 Jul 2022 18:23:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229840AbiGZQXY (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 26 Jul 2022 12:23:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38300 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239312AbiGZQXT (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 26 Jul 2022 12:23:19 -0400
Received: from mail-il1-x12e.google.com (mail-il1-x12e.google.com [IPv6:2607:f8b0:4864:20::12e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BDFF827FFA
        for <io-uring@vger.kernel.org>; Tue, 26 Jul 2022 09:23:17 -0700 (PDT)
Received: by mail-il1-x12e.google.com with SMTP id e12so720203ilu.7
        for <io-uring@vger.kernel.org>; Tue, 26 Jul 2022 09:23:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=from:to:cc:in-reply-to:references:subject:message-id:date
         :mime-version:content-transfer-encoding;
        bh=kTYnTrLfVvl1aD0eYJ/uKh6RpXWMrN/t/lsehOkFNvc=;
        b=cvj98CNHmxqHAgXM5XJGCYanHNpg/BAer2tNhy/u4NgZOjgcaZGyo6tPGeNBzfoy2c
         vmR9X/5xIEz6R68z2sbyhV/zI/RLxE44WdwR8bQuB2NauOPc7NS8gqb4gGqoTGCcIrPp
         LFTr1bM9ukZok/HSdBcxVRIZWtpIOn++qlotIwtzGq+awXDsytb3tI/MZkLvMBxUaUay
         tUj9bYnRAUdFeCtsQcCGnCoDAGfCK7K5znj8DXZEcVF6nkj0dVHth0g4SUUo1G52IATN
         jC7EfYwWtXXnLgoHIKRmLRr2KR++0e6MeNI8Td9jGOKTfl6bqMSkxr+VamJ2IplQCqXC
         AxAg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:in-reply-to:references:subject
         :message-id:date:mime-version:content-transfer-encoding;
        bh=kTYnTrLfVvl1aD0eYJ/uKh6RpXWMrN/t/lsehOkFNvc=;
        b=OseXlUWPlmX47t2zvQe8zTwxFZzNpPFnoxUQCLXETnj5clqpLrTviaiGMS5eLUqcEl
         bd/lUHBmDKgbJybUlJv70mFfURNtFmYMQszJouDkhDey6VfgmuZGfGxrk06L4YGytjkq
         MrhbS47GmINn3/XN9buy2/uOEs6KkKQSq7buJpIpeAOZ5leJ9ysXhG5wcbsMBGa/fpdK
         QOAfhq0T1D9VzLYxcqsx58HoZoVe1Qt+yhYYUD0QVwe1LxS+mzCY9MdLxQ1MViPd2TA0
         VboIQIpjRYSoGrILOX3WtKuKCRGFhwDteZyZ2kpM+O58Dk2HpksqieaLi00jn/oTBjPV
         AbBA==
X-Gm-Message-State: AJIora+EQnN1ebWlDxM/bfh9e9R7eeePpD+opl7hQZtMvk5oyl7CCpKw
        r4rKgxLFcSPhntK/ATmzmnx8tw==
X-Google-Smtp-Source: AGRyM1uADlSz6CDl2tCINJKywZCJ9bHZ6gaek8MnfwjQQ3UX7j5W77ECV3bA/TqGeSdUYSQsmiUDJw==
X-Received: by 2002:a05:6e02:b44:b0:2dd:89bf:6b99 with SMTP id f4-20020a056e020b4400b002dd89bf6b99mr2008090ilu.114.1658852597110;
        Tue, 26 Jul 2022 09:23:17 -0700 (PDT)
Received: from [127.0.1.1] ([207.135.234.126])
        by smtp.gmail.com with ESMTPSA id b11-20020a026f4b000000b0033f5c35704esm6838168jae.54.2022.07.26.09.23.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 26 Jul 2022 09:23:16 -0700 (PDT)
From:   Jens Axboe <axboe@kernel.dk>
To:     asml.silence@gmail.com, dylany@fb.com
Cc:     Kernel-team@fb.com, io-uring@vger.kernel.org
In-Reply-To: <20220726121502.1958288-1-dylany@fb.com>
References: <20220726121502.1958288-1-dylany@fb.com>
Subject: Re: [PATCH liburing 0/5] multishot recvmsg docs and example
Message-Id: <165885259629.1516215.11114286078111026121.b4-ty@kernel.dk>
Date:   Tue, 26 Jul 2022 10:23:16 -0600
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Tue, 26 Jul 2022 05:14:57 -0700, Dylan Yudaken wrote:
> Some multishot recvmsg patches for liburing:
> 
> Patches 1-3  cleanup the API a little while we're doing this.
> Patch 4 adds docs for the new API
> Patch 5 adds an example UDP echo server that uses the API
> 
> 
> [...]

Applied, thanks!

[1/5] more consistent multishot recvmsg API parameter names
      commit: c025f206a8d7337109f148a738bf5df75aeed494
[2/5] order like functions together in liburing.h
      commit: b569b365c3c7d4ac78e8c2f482d5a227a980977f
[3/5] change io_uring_recvmsg_payload_length return type
      commit: 464ed8e15b3dbec2b44e087c4620dcffdc28a753
[4/5] add documentation for multishot recvmsg
      commit: 06f979baaae2c5a17f6b4233cb1f1d6720378149
[5/5] add an example for a UDP server
      commit: 61d472b51e761e61cbf46caea40aaf40d8ed1484

Best regards,
-- 
Jens Axboe


